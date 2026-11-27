"""Bake selected recovered character timelines into transparent Unity sprite sheets."""
from pathlib import Path
import json,sys,math,concurrent.futures,argparse,hashlib
ROOT=Path(__file__).resolve().parent.parent
REF=ROOT/'Crystal Legend'
sys.path.insert(0,str(REF/'recovery_tools'))
sys.path.insert(0,str(REF/'.recovery-deps'))
from PIL import Image
from hero_animation import load_hero,action_bounds,render_frame
UNITY=ROOT/'Unity'
ART=UNITY/'Assets/Zatod/Art/Imported'
DATA=UNITY/'Assets/Zatod/Resources/Data'
units=[]
for section in ['Heroes','Monsters']:
 units.extend(x for x in json.loads((DATA/(section+'.txt')).read_text(encoding='utf8'))[section] if x.get('SourceUnitId'))
def bake(unit):
 resource=unit['SourceResource']
 if unit.get('RecoveredFolder'):
  folder=Path(unit['RecoveredFolder']);animation=json.loads((folder/'animation.json').read_text(encoding='utf-8'));sprites={}
  for element in animation['elements']:
   with Image.open(folder/element['sprite_file']) as image:sprites[element['id']]=image.convert('RGBA')
 else:folder,animation,sprites=load_hero(unit.get('SourceArtResource',resource))
 replacements=unit.get('ComponentReplacements',[])
 absent_components=[]
 if replacements:
  by_name={element['name']:element['id'] for element in animation['elements']}
  for pair in replacements:
   if pair['From'] not in by_name and pair['To'] not in by_name:
    absent_components.append(pair);continue # No drawable element on either side in this recovered FCA.
   if pair['From'] not in by_name or pair['To'] not in by_name:raise ValueError('Missing source puppet component: '+str(pair))
   sprites[by_name[pair['From']]]=sprites[by_name[pair['To']]]
 target=ART/resource;target.mkdir(parents=True,exist_ok=True)
 manifest={'UnitId':unit['Id'],'Resource':resource,'Sheets':[],'Actions':[]}
 if replacements:manifest.update(SourceArtResource=unit['SourceArtResource'],ComponentReplacements=replacements,AbsentDrawableComponents=absent_components)
 actions={};duplicates={}
 for action in animation['actions']:
  name=action['name']
  if name in actions:
   if action!=actions[name]:raise ValueError('Conflicting native actions with the same name: '+resource+'/'+name)
   duplicates[name]=duplicates.get(name,1)+1
  else:actions[name]=action
 source_actions=list(actions.values())
 if duplicates:manifest['IdenticalSourceActionCopies']=duplicates
 scale=animation['translation_scale_for_atlas_pixels']
 bounds_by_action=[action_bounds(action,sprites,scale) for action in source_actions]
 largest=max(max(b[2]-b[0],b[3]-b[1]) for b in bounds_by_action)
 bake_scale=min(1,unit.get('OversizeFrameSize',4096)/largest) if largest>4096 and unit.get('OversizeFrameSize') else 1
 if bake_scale<1:manifest.update(BakeScale=bake_scale,PixelsPerUnit=100*bake_scale,Resampling='Lanczos; identical frames share a sprite; source timing and normalized origins preserved')
 total=0
 for action,bounds in zip(source_actions,bounds_by_action):
  name=action['name']
  width,height=bounds[2]-bounds[0],bounds[3]-bounds[1]
  if bake_scale<1:
   source_width,source_height=width,height;width=max(1,round(width*bake_scale));height=max(1,round(height*bake_scale))
   unique=[];hashes={};indices=[]
   for index,frame in enumerate(action['frames']):
    rendered=render_frame(frame,sprites,bounds,scale);scaled=rendered.resize((width,height),Image.Resampling.LANCZOS);rendered.close()
    digest=hashlib.sha256(scaled.tobytes()).digest()
    if digest not in hashes:hashes[digest]=len(unique);unique.append((index,scaled))
    else:scaled.close()
    indices.append(hashes[digest])
   cols=max(1,min(math.ceil(math.sqrt(len(unique))),4096//width));rows=max(1,4096//height);per=cols*rows;references=[]
   for page,start in enumerate(range(0,len(unique),per)):
    count=min(per,len(unique)-start);sheet=Image.new('RGBA',(width*cols,height*math.ceil(count/cols)));definitions=[]
    rel=f'Assets/Zatod/Art/Imported/{resource}/{name}_{page}.png'
    for local,(index,rendered) in enumerate(unique[start:start+count]):
     x=(local%cols)*width;y=(local//cols)*height;sheet.alpha_composite(rendered,(x,y));rendered.close();frame_name=f'{resource}_{name}_{index:04d}'
     definitions.append(dict(Name=frame_name,X=x,Y=sheet.height-y-height,Width=width,Height=height,PivotX=-bounds[0]/source_width,PivotY=(source_height+bounds[1])/source_height))
     references.append(dict(Sheet=rel,Name=frame_name))
    sheet.save(UNITY/rel,compress_level=3);sheet.close();manifest['Sheets'].append(dict(Path=rel,Frames=definitions))
   manifest['Actions'].append(dict(Name=name,Fps=action['fps'],Duration=len(action['frames'])/action['fps'],Frames=[references[i] for i in indices],
    Loop=name in ['Idle','Move','Loop'],Width=width,Height=height,SourceWidth=source_width,SourceHeight=source_height,UniqueSprites=len(unique),
    AudioCues=[dict(Time=i/action['fps'],Resource='Crystal/Audio/'+Path(e['argument']).stem) for i,f in enumerate(action['frames']) for e in f['events'] if e['type']==1 and e['argument']]))
   total+=len(action['frames']);continue
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
   out=UNITY/rel;sheet.save(out,compress_level=3)
   manifest['Sheets'].append({'Path':rel,'Frames':definitions})
  manifest['Actions'].append({'Name':name,'Fps':action['fps'],'Duration':len(action['frames'])/action['fps'],'Frames':frames,'Loop':name in ['Idle','Move','Loop'],'Width':width,'Height':height,'AudioCues':[{'Time':i/action['fps'],'Resource':'Crystal/Audio/'+Path(e['argument']).stem} for i,f in enumerate(action['frames']) for e in f['events'] if e['type']==1 and e['argument']]})
  total+=len(action['frames'])
 (target/'bake-manifest.txt').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf8')
 return {'Resource':resource,'Actions':len(manifest['Actions']),'Frames':total,'Manifest':str(target/'bake-manifest.txt')}
if __name__=='__main__':
 parser=argparse.ArgumentParser(description=__doc__)
 parser.add_argument('--data',type=Path,default=DATA)
 parser.add_argument('--unity-project',type=Path,default=UNITY)
 parser.add_argument('--only',nargs='+',help='Canonical unit IDs to bake')
 parser.add_argument('--missing-only',action='store_true')
 parser.add_argument('--jobs',type=int,default=4)
 parser.add_argument('--report',type=Path,default=ROOT/'Artifacts/CrystalPhaseChecks/animation-bake.json')
 args=parser.parse_args()
 UNITY=args.unity_project.resolve();ART=UNITY/'Assets/Zatod/Art/Imported';DATA=args.data.resolve()
 units=[x for section in ['Heroes','Monsters'] for x in json.loads((DATA/(section+'.txt')).read_text(encoding='utf8'))[section] if x.get('SourceUnitId')]
 import importlib.util
 form_spec=importlib.util.spec_from_file_location('form_helpers',ROOT/'scripts/Import-ZatodD34Heroes.py');form_helpers=importlib.util.module_from_spec(form_spec);form_spec.loader.exec_module(form_helpers)
 for form in form_helpers.battle_forms(json.loads((DATA/'Skills.txt').read_text(encoding='utf8'))['Skills']):
  units.append(dict(Id='form_'+form['Resource'].lower(),SourceResource=form['Resource'],SourceUnitId=0,
   **{k:form[k] for k in ('SourceArtResource','ComponentReplacements') if k in form}))

 if args.only:
  missing=set(args.only)-{u['Id'] for u in units}
  if missing:raise ValueError('Unknown unit IDs: '+', '.join(sorted(missing)))
  units=[u for u in units if u['Id'] in args.only]
 def valid_bake(unit):
  manifest=ART/unit['SourceResource']/'bake-manifest.txt'
  if not manifest.is_file():return False
  value=json.loads(manifest.read_text(encoding='utf-8'))
  if len(value['Sheets'])!=len({s['Path'] for s in value['Sheets']}) or len(value['Actions'])!=len({a['Name'] for a in value['Actions']}):return False
  expected='Assets/Zatod/Art/Imported/'+unit['SourceResource']+'/'
  return bool(value.get('Sheets')) and all(s['Path'].startswith(expected) and (UNITY/s['Path']).is_file() for s in value['Sheets'])
 if args.missing_only:units=[u for u in units if not valid_bake(u)]
 # Multiple encounter IDs can share a puppet. Bake once, deterministically,
 # rather than allowing workers to race on the same sheets and manifest.
 unique={}
 for unit in units:
  key=unit['SourceResource']
  if key in unique and unique[key].get('RecoveredFolder')!=unit.get('RecoveredFolder'):raise ValueError('Conflicting recovered puppet: '+key)
  unique.setdefault(key,unit)
 units=list(unique.values())
 with concurrent.futures.ThreadPoolExecutor(max_workers=max(1,min(args.jobs,8))) as pool:
  results=[]
  for result in pool.map(bake,units):results.append(result);print(json.dumps(result),flush=True)
 report=args.report;report.parent.mkdir(parents=True,exist_ok=True);report.write_text(json.dumps(results,ensure_ascii=False,indent=2),encoding='utf8')
 print('DONE',len(results),'characters',sum(x['Frames'] for x in results),'frames',flush=True)
