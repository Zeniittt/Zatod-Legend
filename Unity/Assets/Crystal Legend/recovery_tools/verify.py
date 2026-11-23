"""Compile recovered Lua without executing it; verify the raw extraction."""
import collections
import hashlib
import json
import pathlib
import struct
import sys
from recover import ROOT, OUT, write

sys.path.insert(0, str(ROOT / '.recovery-deps'))
from lupa.lua51 import LuaRuntime

def host_bytecode(data):
    """Change only serialized size_t width for a 64-bit Lua 5.1 host."""
    if data[:12] != b'\x1bLuaQ\x00\x01\x04\x04\x04\x08\x00':
        raise ValueError('Unexpected normalized header')
    pos = 12
    output = bytearray(data[:12])
    output[8] = 8
    def take(size, copy=True):
        nonlocal pos
        b = data[pos:pos + size]
        if len(b) != size:
            raise ValueError('Truncated chunk')
        pos += size
        if copy:
            output.extend(b)
        return b
    def uint():
        return struct.unpack('<I', take(4))[0]
    def string():
        size = struct.unpack('<I', take(4, False))[0]
        output.extend(struct.pack('<Q', size))
        take(size)
    def function():
        string()
        take(12)
        take(uint() * 4)
        for _ in range(uint()):
            tag = take(1)[0]
            if tag == 0:
                pass
            elif tag == 1:
                take(1)
            elif tag == 3:
                take(8)
            elif tag == 4:
                string()
            else:
                raise ValueError(f'Unknown constant {tag}')
        for _ in range(uint()):
            function()
        take(uint() * 4)
        for _ in range(uint()):
            string()
            take(8)
        for _ in range(uint()):
            string()
    function()
    if pos != len(data):
        raise ValueError('Trailing data')
    return bytes(output)

def main():
    lua = LuaRuntime(encoding=None)
    compile_only = lua.eval(b'function(s,n) local f,e=loadstring(s,n); return f ~= nil,e end')
    inventory = []
    scripts = json.loads((OUT / 'reports/script_inventory.json').read_text(encoding='utf-8'))
    for index, row in enumerate(scripts, 1):
        if row['status'] != 'normalized_lua51':
            continue
        relative = pathlib.Path(row['original'])
        source = OUT / 'scripts/lua' / relative.with_suffix('.lua')
        binary = OUT / 'scripts/lua51_bytecode' / relative.with_suffix('.luac')
        record = {'original': row['original']}
        for label, path in [('source', source), ('bytecode', binary)]:
            try:
                data = path.read_bytes()
                if label == 'bytecode':
                    data = host_bytecode(data)
                ok, error = compile_only(data, str(path.name).encode())
                record[label + '_valid'] = ok
                if error:
                    record[label + '_error'] = error.decode('utf-8', 'replace')
            except Exception as exc:
                record[label + '_valid'] = False
                record[label + '_error'] = str(exc)
        inventory.append(record)
        if index % 500 == 0:
            lua.gccollect()
            print(f'Lua validation {index}/{len(scripts)}', flush=True)
    write(OUT / 'reports/lua_validation.json', json.dumps(inventory, ensure_ascii=False, indent=2).encode())
    print('Lua validation:', len(inventory),
          'source failures', sum(not r['source_valid'] for r in inventory),
          'bytecode failures', sum(not r['bytecode_valid'] for r in inventory), flush=True)
    rows = json.loads((OUT / 'reports/apk_inventory.json').read_text(encoding='utf-8'))
    errors = []
    for row in rows:
        p = OUT / 'apk_contents' / pathlib.Path(row['apk']).stem / row['entry']
        try:
            data = p.read_bytes()
            if len(data) != row['bytes'] or hashlib.sha256(data).hexdigest() != row['sha256']:
                errors.append(str(p))
        except Exception as exc:
            errors.append(f'{p}: {exc}')
    report = {'files': len(rows), 'bytes': sum(r['bytes'] for r in rows), 'errors': errors,
              'lua_files': len(inventory),
              'lua_source_failures': sum(not r['source_valid'] for r in inventory),
              'lua_bytecode_failures': sum(not r['bytecode_valid'] for r in inventory),
              'game_scripts_executed': False}
    write(OUT / 'reports/verification.json', json.dumps(report, ensure_ascii=False, indent=2).encode())
    print('Raw extraction verified:', report['files'], 'files;', len(errors), 'errors', flush=True)

if __name__ == '__main__':
    main()
