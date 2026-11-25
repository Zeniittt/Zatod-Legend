"""Append Normal chapters 3–8 and author six independent islands from tracked source.

Only writes the chosen staging Data and derived art; never edits existing stages,
loot pools, Owned or source reference. IDs are merged with the tracked aliases.
"""
from pathlib import Path
import argparse,copy,hashlib,importlib.util,json,random,re,shutil
from PIL import Image
ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('heroes',ROOT/'scripts/Import-ZatodD34Heroes.py');base=importlib.util.module_from_spec(spec);spec.loader.exec_module(base)
WORDS={1:'one',2:'two',3:'three',4:'four',5:'five',6:'six',7:'seven',8:'eight'}
def apply(data,manifest,unity,source=None):
    if data.is_relative_to(ROOT/'Unity'):raise ValueError('Use a separate staging catalog.')
    source=source or base.Source();campaign=base.read(data/'Campaigns.txt');world=base.read(data/'Worlds.txt')
    if any(c['Id']=='chapter_three' for c in campaign['Chapters']):raise ValueError('Chapters already authored; use a fresh draft.')
    aliases=dict(re.findall(r'\{"([^"\n]+)","([^"\n]+)"\}',(ROOT/'Unity/Assets/Zatod/Heroes/ZatodContentIds.cs').read_text()))
    for key,value in manifest['NewAliases'].items():
        if key in aliases and aliases[key]!=value:raise ValueError('Refusing alias replacement: '+key)
        aliases[key]=value
    units={r['SourceUnitId']:r for name in ('Heroes','Monsters') for r in base.read(data/(name+'.txt'))[name]}
    heroes={r['SourceUnitId'] for r in base.read(data/'Heroes.txt')['Heroes']};items={r['ItemId'] for r in base.read(data/'Items.txt')['Items']}
    stages={i:base.named_row(source.table('Stage'),r) for i,r in source.table('Stage')[1].items()}
    by_chapter={i:sorted([s for s in stages.values() if s['Difficulty']==1 and s['Chapter ID']==i],key=lambda s:s['Stage ID']) for i in range(1,9)}
    for chapter in range(3,9):
        aliases['crystal_chapter_'+str(chapter)]='chapter_'+WORDS[chapter]
        for n,stage in enumerate(by_chapter[chapter],1):aliases['crystal_stage_'+str(stage['Stage ID'])]='chapter_'+WORDS[chapter]+'_stage_'+str(n)
    marker_source=(base.BASE/'ui_new/modules/stage/stageselectres.lua').read_text(encoding='utf-8-sig');marker_maps={};assets=[];stage_visuals=[]
    def markers(chapter):
        if chapter not in marker_maps:
            start=marker_source.index('{',marker_source.index('map.chapter'+str(chapter)+' ='));depth=0
            for end in range(start,len(marker_source)):
                if marker_source[end]=='{':depth+=1
                elif marker_source[end]=='}':
                    depth-=1
                    if depth==0:break
            marker_maps[chapter]=base.Reader('return '+re.sub(r'ccp\(([^)]+)\)',r'{\1}',marker_source[start:end+1])).parse()
        return marker_maps[chapter]
    def crop_icon(relative,target):
        path=base.ART/relative;dest=unity/'Assets/Zatod/Resources/Zatod/World/StageIcons'/(target+'.png');dest.parent.mkdir(parents=True,exist_ok=True)
        with Image.open(path) as original:
            image=original.convert('RGBA');bounds=image.getbbox()
            if bounds is None:raise ValueError('Empty source stage icon: '+relative)
            cropped=image.crop(bounds);cropped.save(dest)
        assets.append(dict(Source=path.relative_to(ROOT).as_posix(),SourceSha256=hashlib.sha256(path.read_bytes()).hexdigest(),Target=dest.relative_to(unity).as_posix(),Sha256=hashlib.sha256(dest.read_bytes()).hexdigest(),AlphaCrop=list(bounds)))
    def multiplier(value,default=100):return float(value or default)/100
    def point(ident,label,visual,x,y,kind,target,spawn='entry',height=2.3):
        return dict(Id=ident,Label=label,VisualResource=visual,X=x,Y=y,Kind=kind,TargetId=target,DestinationSpawnId=spawn,Height=height,Radius=2.8,HalfWidth=.45,HalfDepth=.25)
    for chapter in range(3,9):
        ident='chapter_'+WORDS[chapter];new=[]
        for index,stage in enumerate(by_chapter[chapter]):
            sid=stage['Stage ID'];waves=[]
            for number,raw in sorted(source.table('Battle')[1][sid].items()):
                w=base.named_row(source.table('Battle'),raw);enemies=[]
                for n in range(1,6):
                    uid=w['Monster '+str(n)+' ID']
                    if not uid:continue
                    rank=w['Rank '+str(n)];boss=n==w['Boss Position']
                    if rank>7:raise ValueError('Authored encounter rank exceeds this phase: '+str(sid))
                    enemies.append(dict(Id='enemy_'+str(n),DefinitionId=units[uid]['Id'],SourceUnitId=uid,Kind=0 if uid in heroes else 1,Level=w['Level '+str(n)],Stars=w['Stars '+str(n)],RankId=base.RANKS[rank-1] if rank else '',InitialEnergy=w['MP '+str(n)],Boss=boss,EstimateRank=rank==0,HpMultiplier=multiplier(w['Monster HP%'])*(multiplier(w['Boss HP%']) if boss else 1),DamageMultiplier=multiplier(w['Monster DPS%'])*(multiplier(w['Boss DPS%']) if boss else 1),ArmorMultiplier=multiplier(w['Monster ARM%'])*(multiplier(w['Boss ARM%']) if boss else 1),MagicResistanceMultiplier=multiplier(w['Monster MR%'])*(multiplier(w['Boss MR%']) if boss else 1),SizeMultiplier=multiplier(w['BOSS SIZE%'],120) if boss else 1))
                waves.append(dict(Id='wave_'+str(number),Index=number,TimeLimitSeconds=90,BackgroundResource=w['Background Pic'],FlipBackground=w['H Flip'],Enemies=enemies,Hooks=[]))
            drops=[]
            for n in range(1,11):
                item=stage.get('UI reward'+str(n));key=aliases.get('crystal_item_'+str(item))
                if item and item!=20555:
                    if key not in items:raise ValueError(f'Missing reward definition {sid}: {item}')
                    if key not in [d['ItemId'] for d in drops]:drops.append(dict(ItemId=key,DropChancePercent=0))
            if not drops:raise ValueError('Stage has no imported reward pool: '+str(sid))
            share=10000//len(drops)
            for i,drop in enumerate(drops):drop['DropChancePercent']=(share if i<len(drops)-1 else 10000-share*(len(drops)-1))/100
            name=source.english(stage['Stage Name'])
            if not name:raise ValueError('Missing official English stage name: '+str(sid))
            row=dict(Id=aliases['crystal_stage_'+str(sid)],Name=name,Description=source.english(stage['description'],stage['description']),SourceStageId=sid,Difficulty=1,VitalityCost=stage['Vitality Cost'],RequiredStageId=aliases['crystal_stage_'+str(stage['Require Stage'])] if stage['Require Stage'] else None,EnergyGainMultiplier=stage['MP Bonus'],EnergySupplyPercent=stage['Mps Restraint'],MapX=round(.08+(index%7)*.14,6),MapY=round(.2+(index//7)*.3,6),Monsters=[],Waves=waves,DropItems=drops,MaxDropAmount=5)
            for target,key in [('VitalityReturn','Vit Return'),('PlayerExpReward','Exp Reward'),('HeroExpReward','Heroexp Reward'),('GoldReward','Money Reward'),('FailPlayerExpReward','Fail Exp Reward')]:row[target]=stage[key]
            new.append(row)
            marker=next(p for p in markers(chapter)['stage'].values() if p['id']==sid);resource=marker.get('resid',sid)
            relative=f'UI/alpha/1080P/campaign/key_stages/stage-{resource}.png';dedicated=(base.ART/relative).is_file()
            crop_icon(relative if dedicated else 'UI/alpha/1080P/campaign/stagecircle_current.png','stage_'+str(sid))
            crop_icon(relative.replace('.png','-locked.png') if dedicated else 'UI/alpha/1080P/campaign/stagecircle_skeleton1.png','stage_'+str(sid)+'_locked')
            stage_visuals.append(dict(SourceStageId=sid,VisualResource='crystal_stage_'+str(sid),IconResource='Zatod/World/StageIcons/stage_'+str(sid),Height=2.8 if dedicated else 1.0))
        name=source.english(source.row('Chapter',chapter)['Chapter Name'],f'Chapter {chapter}')
        campaign['Chapters'].append(dict(Id=ident,Name=name,WorldMapId=ident,Stages=new))
        theme='grass' if chapter%2 else 'purple'
        points=[point('town','Town','goddess',3,4,1,'town'),point('previous','Chapter '+str(chapter-1),'goddess',3,35,1,'chapter_'+WORDS[chapter-1],'from_next')]
        if chapter<8:points.append(point('next','Chapter '+str(chapter+1),'goddess',56,4,1,'chapter_'+WORDS[chapter+1]))
        for i,stage in enumerate(new):
            col=i%7;row=i//7
            if row%2:col=6-col
            visual=next(v for v in stage_visuals if v['SourceStageId']==stage['SourceStageId'])
            points.append(point('stage_'+str(i+1),stage['Name'],visual['VisualResource'],9+col*7,10+row*10,0,stage['Id'],height=visual['Height']))
        island=dict(Id=ident,Name='Chapter '+str(chapter)+' - '+name,Theme=theme,VisualResource=theme+'_background',MinX=0,MinY=0,MaxX=62,MaxY=42,OriginX=chapter*110,OriginY=0,InterestRadius=48,Spawns=[dict(Id='entry',X=6,Y=5),dict(Id='from_next',X=53,Y=35)],Interactions=points,Props=[])
        rng=random.Random(88+chapter*47)
        for i in range(65):
            x=rng.uniform(1,61);y=rng.uniform(1,41)
            if any((x-p['X'])**2+(y-p['Y'])**2<13 for p in points+island['Spawns']):continue
            tree=i%3==0
            island['Props'].append(dict(Id='prop_'+str(i),VisualResource=theme+('_tree_'+str((i//3)%3) if tree else '_patch'),X=x,Y=y,Height=rng.uniform(2.4,3.4) if tree else .45,HalfWidth=.35 if tree else 0,HalfDepth=.23 if tree else 0))
        base.write(data/'WorldMaps'/(ident+'.txt'),island);world['MapResources'].append('Data/WorldMaps/'+ident)
    previous=base.read(data/'WorldMaps/chapter_two.txt')
    previous['Interactions'].append(point('next','Chapter 3','goddess',56,4,1,'chapter_three'))
    base.write(data/'WorldMaps/chapter_two.txt',previous)
    music=base.ART/'sound_menu/battle_bgm.mp3';target=unity/'Assets/Zatod/Resources/Zatod/Audio/battle_bgm.mp3';target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(music,target)
    for chapter in campaign['Chapters']:chapter['BattleMusicResource']='Zatod/Audio/battle_bgm'
    native_assets={row['Target']:row for row in manifest['Assets']}
    for background in sorted({w['BackgroundResource'] for c in campaign['Chapters'] for s in c['Stages'] for w in s['Waves']}):
        path=base.ART/'UI/alpha/1080P'/background
        if not path.is_file():raise FileNotFoundError(path)
        target='Zatod/Backgrounds/'+Path(background).name
        native_assets[target]=dict(Source=path.relative_to(ROOT).as_posix(),Target=target,Sha256=hashlib.sha256(path.read_bytes()).hexdigest())
    manifest['Assets']=sorted(native_assets.values(),key=lambda row:row['Target'])
    base.write(data/'Campaigns.txt',campaign);base.write(data/'Worlds.txt',world)
    version='zatod-d34-chapters-1-8-v7'
    for path in data.rglob('*.txt'):
        document=base.read(path)
        if 'ConfigVersion' in document:document['ConfigVersion']=version;base.write(path,document)
    code=(ROOT/'Unity/Assets/Zatod/Heroes/ZatodContentIds.cs').read_text();original=dict(re.findall(r'\{"([^"\n]+)","([^"\n]+)"\}',code))
    additions=''.join('{'+json.dumps(k)+','+json.dumps(v)+'},\n' for k,v in sorted(aliases.items()) if k not in original)
    code=code.replace('};',additions+'};',1);(data.parent/(data.name+'-content-ids.cs')).write_text(code)
    report=dict(Chapters=8,Stages=sum(len(c['Stages']) for c in campaign['Chapters']),Waves=sum(len(s['Waves']) for c in campaign['Chapters'] for s in c['Stages']),WorldMaps=len(world['MapResources']),StageVisuals=stage_visuals,DerivedArt=assets,Aliases=aliases,OriginalStagesPreserved=True,NewLootPolicy='Max5; equal per-pool percent; total100')
    base.write(data.parent/(data.name+'-chapters.json'),report);print(json.dumps({k:v for k,v in report.items() if k not in ('StageVisuals','DerivedArt','Aliases')},ensure_ascii=False,indent=2))

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--data',type=Path,required=True);p.add_argument('--manifest',type=Path,required=True);p.add_argument('--unity-project',type=Path,default=ROOT/'Unity');a=p.parse_args();apply(a.data.resolve(),base.read(a.manifest),a.unity_project.resolve())
