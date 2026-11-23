"""Export usable assets while preserving all source files in apk_contents."""
import collections
import concurrent.futures
import hashlib
import io
import json
import os
import pathlib
import shutil
import struct
import sys
import zipfile
import zlib
from PIL import Image
from recover import ROOT, OUT, destination, write

def pvr_image(data):
    if data[:4] == b'CCZ!':
        compression, version, reserved, length = struct.unpack('>HHII', data[4:16])
        if compression != 0 or version > 2:
            raise ValueError(f'Unsupported CCZ compression/version {compression}/{version}')
        data = zlib.decompress(data[16:])
        if len(data) != length:
            raise ValueError('CCZ length mismatch')
    if len(data) < 52:
        raise ValueError('Truncated PVR')
    header = struct.unpack('<13I', data[:52])
    size, height, width, mips, flags, payload, bits, rm, gm, bm, am, magic, surfaces = header
    if size != 52 or magic != 0x21525650 or surfaces != 1:
        raise ValueError(f'Unsupported PVR header {header}')
    fmt = flags & 255
    body = data[size:]
    if bits == 16 and fmt == 16 and (rm, gm, bm, am) == (61440, 3840, 240, 15):
        length = width * height * 2
        if len(body) < length:
            raise ValueError('Truncated RGBA4444 pixels')
        raw = body[:length]
        low, high = raw[0::2], raw[1::2]
        upper = bytes((v >> 4) * 17 for v in range(256))
        lower = bytes((v & 15) * 17 for v in range(256))
        rgba = bytearray(width * height * 4)
        rgba[0::4] = high.translate(upper)
        rgba[1::4] = high.translate(lower)
        rgba[2::4] = low.translate(upper)
        rgba[3::4] = low.translate(lower)
        return Image.frombytes('RGBA', (width, height), bytes(rgba)), header
    if bits == 32 and (rm, gm, bm, am) == (255, 65280, 16711680, 4278190080):
        mode, rawmode, length = 'RGBA', 'RGBA', width * height * 4
    elif bits == 24 and (rm, gm, bm) == (255, 65280, 16711680):
        mode, rawmode, length = 'RGB', 'RGB', width * height * 3
    elif bits == 8 and fmt == 27:
        mode, rawmode, length = 'L', 'L', width * height
    else:
        raise ValueError(f'Unsupported PVR pixel format {fmt}, {bits} bits, masks {(rm,gm,bm,am)}')
    if len(body) < length:
        raise ValueError('Truncated PVR pixels')
    return Image.frombytes(mode, (width, height), body[:length], 'raw', rawmode), header

def export_one(path):
    rel = path.relative_to(OUT / 'apk_contents')
    parts = rel.parts
    asset_rel = pathlib.PurePosixPath(*parts[2:])  # apk/assets/...
    target = destination(OUT / 'assets' / parts[0], asset_rel.as_posix())
    record = {'original': rel.as_posix()}
    try:
        if path.suffix == '.abc':
            return None
        if path.name.endswith('.pvr.ccz') or path.suffix == '.ccz':
            image, header = pvr_image(path.read_bytes())
            target = target.with_name(target.name.removesuffix('.pvr.ccz').removesuffix('.ccz') + '.png')
            target.parent.mkdir(parents=True, exist_ok=True)
            image.save(target, compress_level=3)
            # Pixel-for-pixel verification; PNG must preserve the PVR base image.
            with Image.open(target) as check:
                if check.mode != image.mode or check.size != image.size or check.tobytes() != image.tobytes():
                    raise ValueError('PNG pixel verification failed')
            record.update(status='png_verified', width=image.width, height=image.height,
                          mode=image.mode, pvr_flags=header[4], mipmaps=header[3],
                          pixels_sha256=hashlib.sha256(image.tobytes()).hexdigest())
        else:
            if not path.suffix:
                with path.open('rb') as f:
                    signature = f.read(8)
                if signature == b'\x89PNG\r\n\x1a\n':
                    target = target.with_name(target.name + '.png')
            target.parent.mkdir(parents=True, exist_ok=True)
            if not target.exists():
                shutil.copyfile(path, target)
            elif os.path.samefile(path, target):
                # Keep editable exports independent from the forensic copy.
                temporary = target.with_name(target.name + '.copying')
                shutil.copyfile(path, temporary)
                os.replace(temporary, target)
            record['status'] = 'original_exported'
        record['output'] = target.relative_to(OUT).as_posix()
    except Exception as exc:
        record.update(status='error', error=str(exc))
    return record

def unpack_fca():
    records = []
    for path in sorted((OUT / 'apk_contents').rglob('*.fca')):
        rel = path.relative_to(OUT / 'apk_contents')
        root = OUT / 'assets_unpacked' / rel.with_suffix('')
        record = {'original': rel.as_posix(), 'entries': []}
        try:
            with zipfile.ZipFile(path) as archive:
                for info in archive.infolist():
                    if info.is_dir():
                        continue
                    data = archive.read(info)
                    target = destination(root, info.filename)
                    write(target, data)
                    entry = {'name': info.filename, 'bytes': len(data)}
                    if info.filename == 'plist':
                        write(target.with_suffix('.plist'), data)
                    if info.filename.endswith('.pvr'):
                        try:
                            image, header = pvr_image(data)
                            png = target.with_suffix('.png')
                            image.save(png, compress_level=3)
                            with Image.open(png) as check:
                                if check.tobytes() != image.tobytes():
                                    raise ValueError('FCA PNG pixel verification failed')
                            entry.update(converted_png=True, width=image.width, height=image.height)
                        except Exception as exc:
                            entry['conversion_error'] = str(exc)
                    record['entries'].append(entry)
            record['status'] = 'unpacked'
        except Exception as exc:
            record.update(status='error', error=str(exc))
        records.append(record)
    write(OUT / 'reports' / 'fca_inventory.json', json.dumps(records, ensure_ascii=False, indent=2).encode())
    print('FCA results:', collections.Counter(r['status'] for r in records), flush=True)

if __name__ == '__main__':
    paths = sorted(p for apk in (OUT / 'apk_contents').iterdir()
                   if (apk / 'assets').exists() for p in (apk / 'assets').rglob('*') if p.is_file())
    inventory = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
        for index, record in enumerate(pool.map(export_one, paths), 1):
            if record:
                inventory.append(record)
            if index % 1000 == 0:
                print(f'Assets {index}/{len(paths)}: {collections.Counter(r["status"] for r in inventory)}', flush=True)
    write(OUT / 'reports' / 'asset_inventory.json', json.dumps(inventory, ensure_ascii=False, indent=2).encode())
    print('Asset results:', collections.Counter(r['status'] for r in inventory), flush=True)
    unpack_fca()
