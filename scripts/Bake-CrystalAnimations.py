"""Bake selected recovered character timelines into transparent Unity sprite sheets."""
from pathlib import Path
import json,sys,math,concurrent.futures
ROOT=Path(__file__).resolve().parent.parent
REF=ROOT/'Crystal Legend'
sys.path.insert(0,str(REF/'recovery_tools'))
sys.path.insert(0,str(REF/'.recovery-deps'))
from PIL import Image
from hero_animation import load_hero,action_bounds,render_frame
ART=ROOT/'Unity/Assets/Zatod/Art/Imported'
DATA=ROOT/'Unity/Assets/Zatod/Resources/Data'
units=[]
for section in ['Heroes','Monsters']:
 units.extend(x for x in json.loads((DATA/(section+'.txt')).read_text(encoding='utf8'))[section] if x.get('SourceUnitId'))
def bake(unit):
 resource=unit['SourceResource'];folder,animation,sprites=load_hero(resource)
 target=ART/resource;target.mkdir(parents=True,exist_ok=True)
 manifest={'UnitId':unit['Id'],'Resource':resource,'Sheets':[],'Actions':[]}
 scale=animation['translation_scale_for_atlas_pixels']
 total=0
 for action in animation['actions']:
  name=action['name'];bounds=action_bounds(action,sprites,scale)
  width,height=bounds[2]-bounds[0],bounds[3]-bounds[1]
  if max(width,height)>4096:raise ValueError(f'Action exceeds lossless sheet limit: {resource}/{name} {width}x{height}')
  cols=max(1,min(math.ceil(math.sqrt(len(action['frames']))),4096//width));rows=max(1,4096//height)
  per=cols*rows;frames=[]
  for page,start in enumerate(range(0,len(action['frames']),per)):
   count=min(per,len(action['frames'])-start);actual_rows=math.ceil(count/cols)
   sheet=Image.new('RGBA',(width*cols,height*actual_rows))
   rel=f'Assets/Zatod/Art/Imported/{resource}/{name}_{page}.png'
   definitions=[]
   for local in range(count):
    index=start+local;frame=render_frame(action['frames'][index],sprites,bounds,scale)
    x=(local%cols)*width;y=(local//cols)*height
    sheet.alpha_composite(frame,(x,y))
    frame_name=f'{resource}_{name}_{index:04d}'
    definitions.append({'Name':frame_name,'X':x,'Y':sheet.height-y-height,'Width':width,'Height':height,'PivotX':-bounds[0]/width,'PivotY':(height+bounds[1])/height})
    frames.append({'Sheet':rel,'Name':frame_name})
   out=ROOT/'Unity'/rel;sheet.save(out,compress_level=3)
   manifest['Sheets'].append({'Path':rel,'Frames':definitions})
  manifest['Actions'].append({'Name':name,'Fps':action['fps'],'Duration':len(action['frames'])/action['fps'],'Frames':frames,'Loop':name in ['Idle','Move','Loop'],'Width':width,'Height':height,'AudioCues':[{'Time':i/action['fps'],'Resource':'Crystal/Audio/'+Path(e['argument']).stem} for i,f in enumerate(action['frames']) for e in f['events'] if e['type']==1 and e['argument']]})
  total+=len(action['frames'])
 (target/'bake-manifest.txt').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf8')
 return {'Resource':resource,'Actions':len(manifest['Actions']),'Frames':total,'Manifest':str(target/'bake-manifest.txt')}
if __name__=='__main__':
 if '--missing-only' in sys.argv:units=[u for u in units if not (ART/u['SourceResource']/'bake-manifest.txt').exists()]
 with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
  results=[]
  for result in pool.map(bake,units):results.append(result);print(json.dumps(result),flush=True)
 report=ROOT/'Artifacts/CrystalPhaseChecks/animation-bake.json';report.parent.mkdir(parents=True,exist_ok=True);report.write_text(json.dumps(results,ensure_ascii=False,indent=2),encoding='utf8')
 print('DONE',len(results),'characters',sum(x['Frames'] for x in results),'frames',flush=True)
