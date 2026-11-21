"""Author prototype world layout and copy native UI dependencies for chapters 1/2."""
from pathlib import Path
import json,random,shutil,sys
ROOT=Path(__file__).resolve().parent.parent
DATA=ROOT/'Unity/Assets/Zatod/Resources/Data'
REF=ROOT/'Crystal Legend/recovered/assets/install_time_pack/remake'
sys.path.insert(0,str(ROOT/'Crystal Legend/recovery_tools'))
from lua_data import read_table,named_row
campaign=json.loads((DATA/'Campaigns.txt').read_text(encoding='utf8'))
def point(id,label,visual,x,y,kind,target,spawn='entry',height=2.3):
 return dict(Id=id,Label=label,VisualResource=visual,X=x,Y=y,Kind=kind,TargetId=target,DestinationSpawnId=spawn,Height=height,Radius=2.8,HalfWidth=.45,HalfDepth=.25)
def mapdef(id,name,theme,bounds,spawns,points):
 m=dict(Id=id,Name=name,Theme=theme,VisualResource=theme+'_background',MinX=bounds[0],MinY=bounds[1],MaxX=bounds[2],MaxY=bounds[3],Spawns=[dict(Id=s[0],X=s[1],Y=s[2]) for s in spawns],Interactions=points,Props=[])
 rng=random.Random(88 if theme=='grass' else 72)
 for i in range(65):
  x=rng.uniform(bounds[0]+1,bounds[2]-1);y=rng.uniform(bounds[1]+1,bounds[3]-1)
  if any((x-p['X'])**2+(y-p['Y'])**2<13 for p in points+m['Spawns']):continue
  tree=i%3==0
  m['Props'].append(dict(Id='prop_'+str(i),VisualResource=theme+('_tree_'+str(i%3) if tree else '_patch'),X=x,Y=y,Height=rng.uniform(2.4,3.4) if tree else .45,HalfWidth=.35 if tree else 0,HalfDepth=.23 if tree else 0))
 return m
town=mapdef('town','Town','grass',[-18,-13,18,13],[('entry',0,-4)], [point('campaign','Campaign','goddess',0,4,1,'chapter_one'),point('clan','Clan Hall','main_building',-10,4,2,'clan',height=4),point('tower','Lost Tower','watch_tower',10,4,2,'tower',height=4),point('arena','Arena','cyclone_tower',-10,-6,2,'arena',height=3),point('pvp','PvP Realtime','blessing_tower',10,-6,2,'pvp',height=3),point('heroes','Heroes','npc_varn',-5,-1,2,'heroes')])
maps=[town]
for ci,c in enumerate(campaign['Chapters']):
 id=['chapter_one','chapter_two'][ci];c['WorldMapId']=id;theme=['grass','undead'][ci]
 points=[point('town','Town','goddess',3,4,1,'town')]
 points.append(point('next' if ci==0 else 'previous','Chapter 2' if ci==0 else 'Chapter 1','goddess',56,35,1,'chapter_two' if ci==0 else 'chapter_one','entry' if ci==0 else 'from_next'))
 cols=6 if ci==0 else 7
 npcs=['npc_celeste','npc_varn','main_building','watch_tower']
 for n,s in enumerate(c['Stages']):
  row=n//cols;col=n%cols
  if row%2:col=cols-1-col
  points.append(point('stage_'+str(n+1),s['Name'],'crystal_stage_'+str(s['SourceStageId']),9+col*(8 if ci==0 else 7),10+row*10,0,s['Id'],height=2.8 if (REF/('UI/alpha/1080P/campaign/key_stages/stage-'+str(s['SourceStageId'])+'.png')).exists() or s['SourceStageId']==23 else 1.0))
 maps.append(mapdef(id,'Chapter '+str(ci+1)+' - '+('Grasslands' if ci==0 else 'Undead Forest'),theme,[0,0,62,42],[('entry',6,5),('from_next',53,35)],points))
map_resources=[]
for index,m in enumerate(maps):
 m.update(OriginX=index*110,OriginY=0,InterestRadius=48)
 folder=DATA/'WorldMaps';folder.mkdir(exist_ok=True)
 (folder/(m['Id']+'.txt')).write_text(json.dumps(m,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
 map_resources.append('Data/WorldMaps/'+m['Id'])
(DATA/'Worlds.txt').write_text(json.dumps(dict(SchemaVersion=1,ConfigVersion='zatod-world-2-islands',MapResources=map_resources,Maps=[]),indent=2)+'\n',encoding='utf8')
(DATA/'Campaigns.txt').write_text(json.dumps(campaign,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
table=read_table('Unit')
for section in ['Heroes','Monsters']:
 for u in json.loads((DATA/(section+'.txt')).read_text(encoding='utf8'))[section]:
  raw=named_row(table,table[1][u['SourceUnitId']]);key=raw['Portrait'] if 'Portrait' in raw else raw.get('Icon')
  # Existing portraits follow the native unit's portrait key.
  candidates=list((REF/'UI/DOTA-HERO').glob(str(key)[1:])) if key else []
  dest=ROOT/'Unity/Assets/Zatod/Resources/Zatod/UI/Formation/Portraits'/(u['Id']+'.jpg')
  if not dest.exists():
   if not candidates:raise ValueError(('Portrait missing',u['Id'],key,raw.keys()))
   dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(candidates[0],dest)
items={i['ItemId']:i for i in json.loads((DATA/'Items.txt').read_text(encoding='utf8'))['Items']}
for itemid in {d['ItemId'] for c in campaign['Chapters'] for s in c['Stages'] for d in s['DropItems']}:
 item=items[itemid];source=REF/item['IconResource'];dest=ROOT/'Unity/Assets/Zatod/Resources/Zatod/UI/StagePreview/Items'/(itemid+'.jpg')
 if not source.exists():raise FileNotFoundError(source)
 shutil.copyfile(source,dest)
print('World maps:',len(maps),'stage points:',sum(p['Kind']==0 for m in maps for p in m['Interactions']))
