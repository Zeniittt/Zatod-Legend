"""Download the exact supplementary resource pack referenced by this APK."""
import hashlib
import json
from pathlib import Path
import time
import urllib.request
import zipfile

ROOT = Path(__file__).resolve().parent.parent
OUTPUT = ROOT / 'recovered' / 'downloads'
URL = 'https://dgame-remake-prod-global-cdn-01.farlightgames.com/1.0/obt.iPhone/mult/aab_1.1.100312.zip'
EXPECTED = 739997090

def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    final = OUTPUT / 'aab_1.1.100312.zip'
    partial = OUTPUT / 'aab_1.1.100312.zip.part'
    if final.exists():
        if final.stat().st_size != EXPECTED:
            raise ValueError('Existing final file has unexpected size')
    else:
        offset = partial.stat().st_size if partial.exists() else 0
        headers = {'Range': f'bytes={offset}-'} if offset else {}
        request = urllib.request.Request(URL, headers=headers)
        start = time.monotonic()
        last = start
        with urllib.request.urlopen(request, timeout=45) as response:
            if offset and response.status != 206:
                raise ValueError('Server did not honor resume request')
            if offset and not response.headers.get('Content-Range', '').startswith(f'bytes {offset}-'):
                raise ValueError('Resume range mismatch')
            metadata = {'url': URL, 'final_url': response.url, 'headers': dict(response.headers)}
            (OUTPUT / 'cdn_download_metadata.json').write_text(json.dumps(metadata, indent=2), encoding='utf-8')
            with partial.open('ab' if offset else 'wb') as stream:
                total = offset
                while True:
                    chunk = response.read(1024 * 1024)
                    if not chunk:
                        break
                    stream.write(chunk)
                    total += len(chunk)
                    now = time.monotonic()
                    if now - last >= 8:
                        rate = (total - offset) / max(now - start, 0.01) / 1048576
                        print(f'Download {total}/{EXPECTED} bytes ({total / EXPECTED:.1%}), {rate:.1f} MiB/s', flush=True)
                        last = now
        if partial.stat().st_size != EXPECTED:
            raise ValueError(f'Incomplete download: {partial.stat().st_size}/{EXPECTED}')
        partial.replace(final)
    digest = hashlib.sha256()
    with final.open('rb') as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b''):
            digest.update(chunk)
    with zipfile.ZipFile(final) as archive:
        entries = [{'name': i.filename, 'bytes': i.file_size, 'compressed_bytes': i.compress_size,
                    'crc32': f'{i.CRC:08x}', 'encrypted': bool(i.flag_bits & 1)} for i in archive.infolist()]
        (OUTPUT / 'cdn_pack_inventory.json').write_text(json.dumps(entries, ensure_ascii=False, indent=2), encoding='utf-8')
        bad = archive.testzip()
        if bad:
            raise ValueError(f'ZIP CRC failed: {bad}')
    report = {'url': URL, 'file': str(final.relative_to(ROOT)), 'bytes': final.stat().st_size,
              'sha256': digest.hexdigest(), 'zip_entries': len(entries), 'zip_crc_verified': True}
    (OUTPUT / 'cdn_pack_verification.json').write_text(json.dumps(report, indent=2), encoding='utf-8')
    print(json.dumps(report), flush=True)

if __name__ == '__main__':
    main()
