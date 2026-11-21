"""Import English stage names and verified Crystal marker art, preserving gameplay data."""
from pathlib import Path
import sys,re,json,hashlib,copy
from PIL import Image
ROOT=Path(__file__).resolve().parent.parent
DATA=ROOT/'Unity/Assets/Zatod/Resources/Data'
REF=ROOT/'Crystal Legend/recovered/assets/install_time_pack/remake'
SOURCE=ROOT/'Crystal Legend/recovered/scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data'
sys.path.insert(0,str(ROOT/'Crystal Legend/recovery_tools'))
from lua_data import Reader,read_table,named_row
OUT=ROOT/'Artifacts/ZatodItemSourcesChecks';OUT.mkdir(parents=True,exist_ok=True)

def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def write(p,v):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def translations():
 text=(SOURCE/'texttable/texttable.lua').read_text(encoding='utf-8-sig')
 text=re.sub(r'\[(=*)\[(.*?)\]\1\]',lambda m:json.dumps(m.group(2),ensure_ascii=False),text,flags=re.S)
 return Reader(text.replace('ed.textConfig =','return ',1)).parse()

def main():
 campaign=read(DATA/'Campaigns.txt');before=copy.deepcopy(campaign);tr=translations();st=read_table('Stage');native={i:named_row(st,r) for i,r in st[1].items()}
 resource_text=(SOURCE/'ui_new/modules/stage/stageselectres.lua').read_text(encoding='utf8');maps={}
 def chapter(ci):
  if ci not in maps:
   start=resource_text.index('{',resource_text.index('map.chapter'+str(ci)+' ='));depth=0
   for end in range(start,len(resource_text)):
    if resource_text[end]=='{':depth+=1
    elif resource_text[end]=='}':
     depth-=1
     if depth==0:break
   maps[ci]=Reader('return '+re.sub(r'ccp\(([^)]+)\)',r'{\1}',resource_text[start:end+1])).parse()
  return maps[ci]
 art=ROOT/'Unity/Assets/Zatod/Resources/Zatod/World/StageIcons';art.mkdir(parents=True,exist_ok=True);assets=[]
 def crop(source,name):
  p=REF/source
  with Image.open(p) as opened:
   im=opened.convert('RGBA');bbox=im.getbbox();assert bbox;cropped=im.crop(bbox);dest=art/(name+'.png');cropped.save(dest)
   with Image.open(dest) as saved:assert saved.convert('RGBA').tobytes()==cropped.tobytes()
   assets.append(dict(Resource='Zatod/World/StageIcons/'+name,Source=source,SourceSHA256=sha(p),AlphaCrop=list(bbox),Size=list(cropped.size),RGBA_SHA256=hashlib.sha256(cropped.tobytes()).hexdigest(),PNG_SHA256=sha(dest)))
 crop('UI/alpha/1080P/campaign/stagecircle_current.png','stage_node');crop('UI/alpha/1080P/campaign/stagecircle_skeleton1.png','stage_node_locked')
 mapping=[]
 for c in campaign['Chapters']:
  for s in c['Stages']:
   source=native[s['SourceStageId']];english=tr.get(source['Stage Name'],{}).get('nil',{}).get('en');assert english and not any('\u3400'<=x<='\u9fff' for x in english)
   s['Name']=english;point=next(p for p in chapter(source['Chapter ID'])['stage'].values() if p['id']==s['SourceStageId']);rid=point.get('resid',point['id']);rel=f'UI/alpha/1080P/campaign/key_stages/stage-{rid}.png';dedicated=(REF/rel).exists()
   normal=rel if dedicated else 'UI/alpha/1080P/campaign/stagecircle_current.png';locked=rel.replace('.png','-locked.png') if dedicated else 'UI/alpha/1080P/campaign/stagecircle_skeleton1.png'
   crop(normal,'stage_'+str(s['SourceStageId']));crop(locked,'stage_'+str(s['SourceStageId'])+'_locked')
   mapping.append(dict(StageId=s['Id'],SourceStageId=s['SourceStageId'],Name=english,Dedicated=dedicated,NativeResid=rid if dedicated else None,NativeResource=normal,VisualResource='crystal_stage_'+str(s['SourceStageId']),Height=2.8 if dedicated else 1.0))
 before_version=before.pop('ConfigVersion');after=copy.deepcopy(campaign);after.pop('ConfigVersion')
 for c in before['Chapters']:
  for s in c['Stages']:s.pop('Name')
 for c in after['Chapters']:
  for s in c['Stages']:s.pop('Name')
 assert before==after,'Non-name Campaign gameplay fields changed'
 if campaign['ConfigVersion']!='zatod-item-sources-1':campaign['ConfigVersion']='zatod-item-sources-1'
 write(DATA/'Campaigns.txt',campaign)
 indexed={x['StageId']:x for x in mapping};map_audit=[]
 for p in sorted((DATA/'WorldMaps').glob('*.txt')):
  world=read(p);prior=copy.deepcopy(world);count=0
  for point in world['Interactions']:
   if point['Kind']!=0:continue
   item=indexed[point['TargetId']];point['Label']=item['Name'];point['VisualResource']=item['VisualResource'];point['Height']=item['Height'];count+=1
  scrub=lambda w: [[p.pop(k,None) for k in ['Label','VisualResource','Height']] for p in w['Interactions'] if p['Kind']==0]
  prev_scrub=copy.deepcopy(prior);next_scrub=copy.deepcopy(world);scrub(prev_scrub);scrub(next_scrub);assert prev_scrub==next_scrub,'Non-visual map fields changed: '+p.name
  if prior!=world:write(p,world)
  map_audit.append(dict(Map=world['Id'],StagePoints=count,GameplayFieldsUnchanged=True))
 for filename in ['access_normal.png','access_unlock.png','access_arrow.png']:
  p=REF/'UI/alpha/1080P/package'/filename;dest=ROOT/'Unity/Assets/Zatod/Resources/Zatod/UI/Crafting/package'/filename;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(p.read_bytes());assert sha(p)==sha(dest)
 write(OUT/'import.json',dict(StageCount=len(mapping),DedicatedStageCount=sum(m['Dedicated'] for m in mapping),GenericStageCount=sum(not m['Dedicated'] for m in mapping),Mapping=mapping,Images=assets,Maps=map_audit,CampaignNonNameFieldsUnchanged=True,OriginalConfigVersion=before_version))
 print('Imported',len(mapping),'English stage names,',len(assets),'alpha-trimmed native marker images; gameplay fields unchanged.')
if __name__=='__main__':main()
