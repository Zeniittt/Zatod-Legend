"""Repair two missing-parenthesis errors confirmed against the VM instructions."""
import hashlib
import json
from recover import OUT, write

BASE = OUT / 'scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data'
PATCHES = [
    ('ui/activity/tenPumping.lua',
     'local id = (data._rewards or {})[1] or {}._id',
     'local id = ((data._rewards or {})[1] or {})._id',
     'tenPumping.disassembly.txt; original Lua line 1012: TEST/NEWTABLE precedes GETTABLE _id'),
    ('ui_new/modules/peakArena/peakArenaPvpScene.lua',
     'local name = (challenge._oppo or {})._summary or {}._name or "NickName"',
     'local name = ((challenge._oppo or {})._summary or {})._name or "NickName"',
     'peakArenaPvpScene.disassembly.txt; original Lua line 1023: TEST/NEWTABLE precedes GETTABLE _name'),
]

def main():
    records = []
    for relative, before, after, evidence in PATCHES:
        path = BASE / relative
        data = path.read_bytes()
        source = data.decode('utf-8')
        if before in source:
            if source.count(before) != 1:
                raise ValueError('Patch match is not unique')
            original = OUT / 'reports/decompiler_original' / relative
            write(original, data)
            corrected = source.replace(before, after, 1).encode('utf-8')
            write(path, corrected)
        elif after in source:
            data = (OUT / 'reports/decompiler_original' / relative).read_bytes()
            corrected = path.read_bytes()
        else:
            raise ValueError(f'Expected decompiler expression missing: {relative}')
        records.append({'file': str(path.relative_to(OUT)), 'before': before, 'after': after,
                        'evidence': evidence, 'original_sha256': hashlib.sha256(data).hexdigest(),
                        'corrected_sha256': hashlib.sha256(corrected).hexdigest()})
    write(OUT / 'reports/source_repairs.json', json.dumps(records, ensure_ascii=False, indent=2).encode())
    print('Repaired decompiler parentheses:', len(records))

if __name__ == '__main__':
    main()
