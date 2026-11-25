"""Recover and bake the effect containers referenced by selected Crystal content."""
from pathlib import Path
import argparse,json,zipfile,sys,concurrent.futures
from Bake_CrystalSupport import ROOT, REF, bake, recover_effect, PACK
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--data',type=Path,default=ROOT/'Unity/Assets/Zatod/Resources/Data')
parser.add_argument('--unity-project',type=Path,default=ROOT/'Unity')
parser.add_argument('--report',type=Path,default=ROOT/'Artifacts/CrystalPhaseChecks/effect-bake.json')
parser.add_argument('--recovered-output',type=Path,default=ROOT/'Artifacts/DerivedCrystalEffects')
parser.add_argument('--only',nargs='+',help='Explicit source effect resource names')
args=parser.parse_args()
DATA=args.data.resolve()
from Bake_CrystalSupport import module
module.UNITY=args.unity_project.resolve();module.ART=module.UNITY/'Assets/Zatod/Art/Imported'
wanted=set()
for section in ['Skills','Buffs']:
 for row in json.loads((DATA/(section+'.txt')).read_text(encoding='utf-8'))[section]:
  value=row.get('Crystal',row)
  if not value:continue
  wanted.update(Path(name).stem for name in value.get('AdditionalEffectResources',[]))
  for key in ['ProjectileArt','ImpactEffect','ChainEffect','LaunchEffect','PointEffect','Effect']:
   if value.get(key):wanted.add(Path(value[key]).stem)
# Hero and form timelines may spawn art not explicitly listed in skill fields.
import importlib.util
form_spec=importlib.util.spec_from_file_location('form_helpers',ROOT/'scripts/Import-ZatodD34Heroes.py');form_helpers=importlib.util.module_from_spec(form_spec);form_spec.loader.exec_module(form_helpers)
actor_resources={u.get('SourceArtResource',u['SourceResource']) for section in ['Heroes','Monsters'] for u in json.loads((DATA/(section+'.txt')).read_text(encoding='utf-8'))[section] if u.get('SourceUnitId')}
actor_resources.update(f.get('SourceArtResource',f['Resource']) for f in form_helpers.battle_forms(json.loads((DATA/'Skills.txt').read_text())['Skills']))
for path in (REF/'recovered/heroes').glob('*/animation.json'):
 if path.parent.name not in actor_resources:continue
 for action in json.loads(path.read_text(encoding='utf-8'))['actions']:
  for frame in action['frames']:
   for event in frame['events']:
    value=event.get('argument','')
    if value.endswith('.cha'):wanted.add(Path(value).stem)
wanted.update(['eff_point_NEC_ult','eff_point_Sniper_ult','eff_point_Tiny_atk3','eff_impact_Coco_ult'])
if args.only:wanted=set(args.only)
extracted=REF/'recovered/downloads/aab_1.1.100312'
if (extracted/'patch/pfca/effect').is_dir():
 containers={p.stem:p.relative_to(extracted).as_posix() for p in (extracted/'patch/pfca/effect').rglob('*.fca')}
else:
 with zipfile.ZipFile(PACK) as archive:
  containers={Path(n).stem:n for n in archive.namelist() if n.startswith('patch/pfca/effect/') and n.endswith('.fca')}
def work(resource):
 if resource not in containers:return {'Resource':resource,'Status':'missing native source container'}
 folder=REF/'recovered/heroes'/resource
 if not (folder/'animation.json').exists():
  folder=args.recovered_output.resolve()/resource
  record=recover_effect(containers[resource],folder)
  if record['status']!='recovered':raise ValueError(str(record))
 if (module.ART/resource/'bake-manifest.txt').exists():return {'Resource':resource,'Status':'already baked'}
 result=bake({'Id':'effect_'+resource,'SourceResource':resource,'RecoveredFolder':str(folder),'OversizeFrameSize':2048});print(json.dumps(result),flush=True);return result
if __name__=='__main__':
 with concurrent.futures.ThreadPoolExecutor(max_workers=3) as pool:results=list(pool.map(work,sorted(wanted)))
 args.report.parent.mkdir(parents=True,exist_ok=True)
 args.report.write_text(json.dumps(results,indent=2),encoding='utf-8')
 print('DONE',len(results),'effects',flush=True)
