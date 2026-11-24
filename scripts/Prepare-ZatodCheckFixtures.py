"""Recreate ignored check inputs from return-only source tables; never writes game config."""
from pathlib import Path
import ast
import json
import re
import sys

ROOT = Path(__file__).resolve().parent.parent
REF = ROOT / 'Unity/Assets/Crystal Legend'
sys.path.insert(0, str(REF / 'recovery_tools'))
from lua_data import read_table, named_row

# Reuse only the audited source conversion functions, not the importer's top-level writes.
tree = ast.parse((ROOT / 'scripts/Import-CrystalConfig.py').read_text())
scope = {}
for node in tree.body:
    if isinstance(node, ast.Assign) and any(isinstance(t, ast.Name) and t.id in ('MAP', 'SOURCE_STATS') for t in node.targets):
        exec(compile(ast.Module(body=[node], type_ignores=[]), '<source-stat-conversion>', 'exec'), scope)
    elif isinstance(node, ast.FunctionDef) and node.name in ('direct', 'plus'):
        exec(compile(ast.Module(body=[node], type_ignores=[]), '<source-stat-conversion>', 'exec'), scope)
for key in scope['SOURCE_STATS']:
    scope['MAP'].setdefault(key, key.lower())
direct, plus = scope['direct'], scope['plus']
tables = {name: read_table(name) for name in ('Unit', 'UnitRank', 'hero_equip', 'equip')}
def row(name, *keys):
    raw = tables[name][1]
    for key in keys:
        raw = raw[key]
    return named_row(tables[name], raw)

heroes = json.loads((ROOT / 'Unity/Assets/Zatod/Resources/Data/Heroes.txt').read_text())['Heroes']
rows = []
for hero in heroes:
    hid = hero['SourceUnitId']
    unit = row('Unit', hid)
    for stars in (1, 3, 5):
        growth = direct({a: unit.get('+'+a+str(stars), 0) for a in ('STR','AGI','INT')}, unit['Main Attrib'])
        for rank, rank_id in enumerate(('white','green','green_plus_1','blue'), 1):
            base = plus(plus(direct(unit, unit['Main Attrib']), growth, 40), direct(row('UnitRank', hid, rank), unit['Main Attrib']))
            gear = row('hero_equip', hid, rank)
            for full in (False, True):
                expected = dict(base)
                if full:
                    for n in range(1, 7):
                        expected = plus(expected, direct(row('equip', gear['Equip'+str(n)+' ID']), unit['Main Attrib']))
                rows.append(dict(HeroId=hero['Id'], Stars=stars, Level=40, RankId=rank_id, Equipped=full,
                                 Expected=[dict(StatId=k, Value=v) for k,v in sorted(expected.items()) if abs(v)>1e-9]))
aliases = dict(re.findall(r'\{"([^"]+)","([^"]+)"\}', (ROOT/'Unity/Assets/Zatod/Heroes/ZatodContentIds.cs').read_text()))
output = ROOT/'Artifacts/CrystalPhaseChecks'
output.mkdir(parents=True, exist_ok=True)
for name, data in [('stat-oracle.json', {'Rows': rows}), ('zatod-id-mapping.json', {'Aliases': aliases})]:
    (output/name).write_text(json.dumps(data, ensure_ascii=False, indent=2)+'\n')
print(f'Prepared {len(rows)} source-stat cases and {len(aliases)} ID aliases in {output}')
