"""Recover and bake the effect containers referenced by selected Crystal content."""
from pathlib import Path
import json,zipfile,sys,concurrent.futures
from Bake_CrystalSupport import ROOT, REF, bake, recover_effect, PACK
DATA=ROOT/'Unity/Assets/Zatod/Resources/Data'
wanted=set()
for section in ['Skills','Buffs']:
 for row in json.loads((DATA/(section+'.txt')).read_text(encoding='utf-8'))[section]:
  value=row.get('Crystal',row)
  if not value:continue
  for key in ['ProjectileArt','ImpactEffect','ChainEffect','LaunchEffect','PointEffect','Effect']:
   if value.get(key):wanted.add(Path(value[key]).stem)
# Hero timeline events may spawn art not explicitly listed in the skill table.
for path in (REF/'recovered/heroes').glob('*/animation.json'):
 if path.parent.name not in {u['SourceResource'] for section in ['Heroes','Monsters'] for u in json.loads((DATA/(section+'.txt')).read_text(encoding='utf-8'))[section] if u.get('SourceUnitId')}:continue
 for action in json.loads(path.read_text(encoding='utf-8'))['actions']:
  for frame in action['frames']:
   for event in frame['events']:
    value=event.get('argument','')
    if value.endswith('.cha'):wanted.add(Path(value).stem)
wanted.update(['eff_point_NEC_ult','eff_point_Sniper_ult','eff_point_Tiny_atk3','eff_impact_Coco_ult'])
extracted=REF/'recovered/downloads/aab_1.1.100312'
if (extracted/'patch/pfca/effect').is_dir():
 containers={p.stem:p.relative_to(extracted).as_posix() for p in (extracted/'patch/pfca/effect').rglob('*.fca')}
else:
 with zipfile.ZipFile(PACK) as archive:
  containers={Path(n).stem:n for n in archive.namelist() if n.startswith('patch/pfca/effect/') and n.endswith('.fca')}
def work(resource):
 if resource not in containers:raise ValueError('Missing selected effect: '+resource)
 if not (REF/'recovered/heroes'/resource/'animation.json').exists():
  record=recover_effect(containers[resource])
  if record['status']!='recovered':raise ValueError(str(record))
 if (ROOT/'Unity/Assets/Zatod/Art/Imported'/resource/'bake-manifest.txt').exists():return {'Resource':resource,'Status':'already baked'}
 result=bake({'Id':'effect_'+resource,'SourceResource':resource});print(json.dumps(result),flush=True);return result
if __name__=='__main__':
 with concurrent.futures.ThreadPoolExecutor(max_workers=3) as pool:results=list(pool.map(work,sorted(wanted)))
 (ROOT/'Artifacts/CrystalPhaseChecks/effect-bake.json').write_text(json.dumps(results,indent=2),encoding='utf-8')
 print('DONE',len(results),'effects',flush=True)
