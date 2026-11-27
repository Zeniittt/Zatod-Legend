"""Apply only D38 chapter gates, stage policy, portal placement and exact selector art.
Reads extracted Crystal source; preserves every encounter/reward/Evo and all IDs.
"""
from pathlib import Path
import argparse,hashlib,json,shutil,sys
ROOT=Path(__file__).resolve().parents[1]
REF=ROOT/'Crystal Legend'
sys.path.insert(0,str(REF/'recovery_tools'))
from lua_data import read_table,named_row

def apply(unity):
    data=unity/'Assets/Zatod/Resources/Data'
    def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
    def write(p,value):p.write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n')
    campaign=read(data/'Campaigns.txt');table=read_table('Stage');levels=read_table('PlayerLevel');gates={}
    for level,row in levels[1].items():
        for chapter in (named_row(levels,row).get('Chapter') or {}).values():gates.setdefault(chapter,level)
    original=json.loads(json.dumps(campaign));key=0
    for index,chapter in enumerate(campaign['Chapters'],1):
        chapter['RequiredAccountLevel']=gates[index]
        for stage in chapter['Stages']:
            raw=named_row(table,table[1][stage['SourceStageId']]);assert raw['Chapter ID']==index and raw['Difficulty']==1
            stage['KeyStage']=bool(raw['Key Stage']);key+=stage['KeyStage']
            stage['WorldBossEnemyId']=next((e['Id'] for e in stage['Waves'][-1]['Enemies'] if e.get('Boss')),stage['Waves'][-1]['Enemies'][0]['Id'])
        p=data/'WorldMaps'/(chapter['WorldMapId']+'.txt');world=read(p)
        # Preserve authored entrances; add the missing left portal where needed.
        world['Interactions']=[r for r in world['Interactions'] if r['Id'] not in ('previous','next')]
        for delta,ident,x,spawn,dest_spawn in [(-1,'previous',2,'from_left','from_right'),(1,'next',60,'from_right','from_left')]:
            if not 1<=index+delta<=len(campaign['Chapters']):continue
            target=campaign['Chapters'][index+delta-1]
            world['Interactions'].append(dict(Id=ident,Label=('Previous: ' if delta<0 else 'Next: ')+target['Name'],VisualResource='goddess',X=x,Y=21,Kind=1,TargetId=target['WorldMapId'],DestinationSpawnId=dest_spawn,Height=2.3,Radius=2.5,HalfWidth=.35,HalfDepth=.25))
        world['Spawns']=[r for r in world['Spawns'] if r['Id'] not in ('from_left','from_right')]+[dict(Id='from_left',X=6,Y=21),dict(Id='from_right',X=56,Y=21)]
        for spawn in world['Spawns']:
            if spawn['Id'] not in ('from_left','from_right'):continue
            for y in (21,19,23,17,25):
                if not any(p.get('HalfWidth',0)>0 and p.get('HalfDepth',0)>0 and abs(spawn['X']-p['X'])<p['HalfWidth']+.6 and abs(y-p['Y'])<p['HalfDepth']+.6 for p in world['Props']+world['Interactions']):
                    spawn['Y']=y;break
            else:raise ValueError('No safe portal spawn: '+world['Id'])
        for point in world['Interactions']:

            if point['Kind']==0:point['Height']=2.5 # World actor size, encounter art scale remains unchanged.
        write(p,world)
    campaign['ConfigVersion']=original['ConfigVersion'].split('-d38')[0]+'-d38'
    write(data/'Campaigns.txt',campaign)
    town_path=data/'WorldMaps/town.txt';town=read(town_path)
    buildings={'campaign':'eff_UI_Main_Pve','clan':'eff_UI_Main_Guild','arena':'eff_UI_Main_Pvp','pvp':'eff_UI_Main_Pvp_fort','tower':'eff_UI_Main_fancytower'}
    definitions={hero['Id']:hero for hero in read(data/'Heroes.txt')['Heroes']}
    for point in town['Interactions']:
        if point['Id'] in buildings:point['AnimationSetResource']='Zatod/'+buildings[point['Id']]+'/AnimationSet'
        elif point['TargetId'] in ('heroes','history'):point['AnimationSetResource']=definitions['coco' if point['TargetId']=='heroes' else 'zeus']['AnimationSetResource']
    write(town_path,town)
    art=REF/'recovered/assets/install_time_pack/remake/UI/alpha/1080P';dest=unity/'Assets/Zatod/Resources/Zatod/UI/ChapterSelector';dest.mkdir(parents=True,exist_ok=True);assets=[]
    names=['bg/worldmap_normal.jpg','bg/worldmap_normal_1.jpg','campaign/worldmap/worldmap_chapter_normal_bg.png','campaign/worldmap/worldmap_chapter_lock.png']
    names += ['campaign/worldmap/worldmap_map_norlmal_'+str(n)+'.png' for n in range(1,9)]
    names += ['campaign/worldmap/worldmap_map_norlmal_choose_'+str(n)+'.png' for n in range(1,9)]
    for name in names:
        source=art/name;target=dest/source.name;shutil.copyfile(source,target)
        assets.append(dict(Source=source.relative_to(ROOT).as_posix(),Target=target.relative_to(unity).as_posix(),Sha256=hashlib.sha256(target.read_bytes()).hexdigest()))
    return dict(KeyStages=key,MinorStages=sum(len(c['Stages']) for c in campaign['Chapters'])-key,Gates=gates,Assets=assets)
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--unity-project',type=Path,required=True);p.add_argument('--report',type=Path,required=True);a=p.parse_args()
    result=apply(a.unity_project.resolve());a.report.parent.mkdir(parents=True,exist_ok=True);a.report.write_text(json.dumps(result,indent=2)+'\n');print('D38:',result['KeyStages'],'key /',result['MinorStages'],'minor;',len(result['Assets']),'native selector assets')
