"""Losslessly extract APKs, unwrap Crystal Legends scripts, normalize Lua 5.1."""
import collections
import hashlib
import io
import json
import math
import pathlib
import struct
import sys
import time
import zipfile

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / 'recovered'
STANDARD = 'MOVE LOADK LOADBOOL LOADNIL GETUPVAL GETGLOBAL GETTABLE SETGLOBAL SETUPVAL SETTABLE NEWTABLE SELF ADD SUB MUL DIV MOD POW UNM NOT LEN CONCAT JMP EQ LT LE TEST TESTSET CALL TAILCALL RETURN FORLOOP FORPREP TFORLOOP SETLIST CLOSE CLOSURE VARARG'.split()
CUSTOM = 'ADD SUB MUL DIV MOD POW UNM NOT LEN MOVE LOADK LOADBOOL LOADNIL GETUPVAL GETGLOBAL GETTABLE SETGLOBAL SETUPVAL SETTABLE NEWTABLE SELF CONCAT JMP EQ LT LE TEST TESTSET CALL TAILCALL RETURN FORLOOP FORPREP TFORLOOP SETLIST CLOSE CLOSURE VARARG'.split()
OPMAP = [STANDARD.index(name) for name in CUSTOM]

def destination(root, name):
    parts = pathlib.PurePosixPath(name).parts
    if not parts or any(p in ('..', '') or ':' in p for p in parts) or pathlib.PurePosixPath(name).is_absolute():
        raise ValueError(f'Unsafe archive name: {name}')
    result = root.joinpath(*parts)
    # Windows may return an extended-length path for a OneDrive file but not
    # for its directory. Compare the same representation on both sides.
    canonical = lambda p: pathlib.Path(str(p.resolve()).removeprefix('\\\\?\\'))
    canonical(result).relative_to(canonical(root))
    return result

def write(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)

def unwrap(data, filename):
    key = filename.encode('utf-8')
    step = next(p for p in (10007, 10009, 10037, 10039, 10061, 10067, 10069) if len(data) % p)
    if math.gcd(step, len(data)) != 1:
        raise ValueError('Non-invertible byte permutation')
    decoded = bytearray(len(data))
    for i, value in enumerate(data):
        decoded[(i * step) % len(data)] = value ^ key[i % len(key)]
    password = ('cocos2d: ERROR: Invalid filename ' + filename.rsplit('.', 1)[0]).encode('utf-8')
    with zipfile.ZipFile(io.BytesIO(decoded)) as archive:
        # zipfile checks CRC after decryption and decompression.
        return archive.read('data', pwd=password)

class LuaChunk:
    def __init__(self, data):
        self.data = bytearray(data)
        self.pos = 12
        if data[:12] != b'\x1aDgmQ\x00\x01\x04\x04\x04\x08\x00':
            raise ValueError(f'Unexpected Lua header: {data[:12].hex()}')
        self.functions = 0
        self.instructions = 0
        self.sources = []
        self.function()
        if self.pos != len(data):
            raise ValueError(f'Trailing chunk data: {len(data) - self.pos}')
        self.data[:4] = b'\x1bLua'

    def take(self, size):
        if size < 0 or self.pos + size > len(self.data):
            raise ValueError('Truncated Lua chunk')
        result = self.data[self.pos:self.pos + size]
        self.pos += size
        return result

    def uint(self):
        return struct.unpack('<I', self.take(4))[0]

    def string(self):
        size = self.uint()
        value = self.take(size)
        if size and value[-1] != 0:
            raise ValueError('Unterminated Lua string')
        return bytes(value[:-1]) if size else b''

    def function(self):
        self.functions += 1
        source = self.string()
        if source:
            self.sources.append(source.decode('utf-8', 'replace'))
        self.take(12)  # line bounds + nups, params, vararg, stack
        count = self.uint()
        self.instructions += count
        raw_next = False
        for _ in range(count):
            offset = self.pos
            word = self.uint()
            if raw_next:
                raw_next = False
                continue
            opcode = word & 63
            if opcode >= len(OPMAP):
                raise ValueError(f'Unknown opcode {opcode} at {offset}')
            raw_next = CUSTOM[opcode] == 'SETLIST' and ((word >> 14) & 511) == 0
            struct.pack_into('<I', self.data, offset, (word & ~63) | OPMAP[opcode])
        for _ in range(self.uint()):
            tag = self.take(1)[0]
            if tag == 0:
                pass
            elif tag == 1:
                self.take(1)
            elif tag == 3:
                self.take(8)
            elif tag == 4:
                self.string()
            else:
                raise ValueError(f'Unknown constant type {tag}')
        for _ in range(self.uint()):
            self.function()
        self.take(4 * self.uint())  # line info
        for _ in range(self.uint()):
            self.string()
            self.take(8)
        for _ in range(self.uint()):
            self.string()

def extract():
    inventory = []
    for apk in sorted(ROOT.glob('*.apk')):
        count = 0
        with zipfile.ZipFile(apk) as archive:
            for info in archive.infolist():
                if info.is_dir():
                    continue
                data = archive.read(info)
                target = destination(OUT / 'apk_contents' / apk.stem, info.filename)
                write(target, data)
                inventory.append({'apk': apk.name, 'entry': info.filename, 'bytes': len(data),
                                  'sha256': hashlib.sha256(data).hexdigest()})
                count += 1
        print(f'Extracted {apk.name}: {count} files', flush=True)
    write(OUT / 'reports' / 'apk_inventory.json', json.dumps(inventory, ensure_ascii=False, indent=2).encode())

def scripts():
    inventory = []
    candidates = sorted((OUT / 'apk_contents').rglob('*.abc'))
    for index, path in enumerate(candidates, 1):
        rel = path.relative_to(OUT / 'apk_contents')
        # Keep the APK name so files from different packages never overwrite.
        record = {'original': rel.as_posix(), 'status': 'error'}
        try:
            cached = destination(OUT / 'scripts' / 'custom_bytecode', rel.as_posix())
            if cached.exists():
                data = cached.read_bytes()
                record['payload_cached'] = True
            else:
                try:
                    data = unwrap(path.read_bytes(), path.name)
                    record['encryption_filename'] = path.name
                except zipfile.BadZipFile:
                    if not path.stem.endswith('_ptr'):
                        raise
                    filename = path.stem.removesuffix('_ptr') + path.suffix
                    data = unwrap(path.read_bytes(), filename)
                    record['encryption_filename'] = filename
            write(destination(OUT / 'scripts' / 'custom_bytecode', rel), data)
            record.update(decrypted_bytes=len(data), decrypted_sha256=hashlib.sha256(data).hexdigest())
            if data.startswith(b'\x1aDgm'):
                chunk = LuaChunk(data)
                output = destination(OUT / 'scripts' / 'lua51_bytecode', rel.with_suffix('.luac').as_posix())
                write(output, chunk.data)
                record.update(status='normalized_lua51', functions=chunk.functions,
                              instructions=chunk.instructions, sources=chunk.sources,
                              normalized_sha256=hashlib.sha256(chunk.data).hexdigest())
            else:
                if data.lstrip().startswith((b'package ', b'enum ', b'message ', b'syntax ')):
                    proto = destination(OUT / 'scripts' / 'protobuf_original', rel.with_suffix('.proto').as_posix())
                    write(proto, data)
                    try:
                        text = data.decode('utf-8')
                        encoding = 'utf-8'
                    except UnicodeDecodeError:
                        text = data.decode('gb18030')
                        encoding = 'gb18030'
                    utf8 = destination(OUT / 'scripts' / 'protobuf_utf8', rel.with_suffix('.proto').as_posix())
                    write(utf8, text.encode('utf-8'))
                    record.update(status='protobuf_source', original_encoding=encoding)
                else:
                    record['status'] = 'unwrapped_other_format'
        except Exception as exc:
            record['error'] = str(exc)
        inventory.append(record)
        if index % 250 == 0:
            print(f'Scripts {index}/{len(candidates)}: {collections.Counter(r["status"] for r in inventory)}', flush=True)
    write(OUT / 'reports' / 'script_inventory.json', json.dumps(inventory, ensure_ascii=False, indent=2).encode())
    print('Script results:', collections.Counter(r['status'] for r in inventory), flush=True)

if __name__ == '__main__':
    OUT.mkdir(exist_ok=True)
    modes = sys.argv[1:] or ['extract', 'scripts']
    if 'extract' in modes:
        extract()
    if 'scripts' in modes:
        scripts()
