"""Extend the canonical Zatod catalog with Crystal chapter two, preserving existing definitions/IDs."""
from pathlib import Path
import json,re,sys,copy
ROOT=Path(__file__).resolve().parent.parent
DATA=ROOT/'Unity/Assets/Zatod/Resources/Data'
sys.path.insert(0,str(ROOT/'Crystal Legend/recovery_tools'))
from lua_data import Reader

def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def write(p,v):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def slug(v):return re.sub('[^a-z0-9]+','_',re.sub(r'([a-z0-9])([A-Z])',r'\1_\2',str(v)).lower()).strip('_')
def main():
    source=(ROOT/'scripts/Import-CrystalConfig.py').read_text(encoding='utf-8-sig')
    # Reuse the source row conversion without running its chapter-one overwrite/export section.
    prefix=source[:source.index('# Buff mode suffixes')].replace("['Chapter ID']==1","['Chapter ID'] in [1,2]")
    env={'__file__':str(ROOT/'scripts/Import-CrystalConfig.py')};exec(compile(prefix,'Import-CrystalConfig.py','exec'),env)
    table,row=env['table'],env['row'];docs={n:read(DATA/(n+'.txt')) for n in ['Heroes','Monsters','Items','Skills','Buffs','Stats']}
    mappingPath=ROOT/'Artifacts/CrystalPhaseChecks/zatod-id-mapping.json';mapping=read(mappingPath);aliases=mapping['Aliases'];newAlias={};report={'Heroes':[],'Monsters':[],'Items':[],'Skills':[],'Buffs':[],'TechnicalSkillNames':[]}
    text=(ROOT/'Crystal Legend/recovered/scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data/texttable/texttable.lua').read_text(encoding='utf-8-sig')
    text=re.sub(r'\[(=*)\[(.*?)\]\1\]',lambda m:json.dumps(m.group(2),ensure_ascii=False),text,flags=re.S)
    translations=Reader(text.replace('ed.textConfig =','return ',1)).parse()
    def english(name):
        entry=translations.get(name,{})
        if entry.get('nil',{}).get('en'):return entry['nil']['en']
        return None
    units=env['heroes']+env['monsters'];unitByOld={u['Id']:u for u in units}
    used=set(x['Id'] for n in ['Heroes','Monsters'] for x in docs[n][n])
    for u in units:
        if u['Id'] not in aliases:
            ident=slug(u['Name']);assert ident and ident not in used,(u['Name'],ident)
            aliases[u['Id']]=ident;newAlias[u['Id']]=ident;used.add(ident)
    # Include all low-level chapter-two preview equipment, in addition to the expanded Blue-rank gear set.
    for st in env['normal_stages']:
        for key,value in st.items():
            if not key.startswith('UI reward') or not value or value==20555 or value in env['items']:continue
            item=row('equip',table('equip')[1][value]);env['items'][value]={'ItemId':env['iid'](value),'Name':item['Name'],'IconResource':item['Icon'],'LevelRequirement':item['Level Requirement'],'Quality':item['Quality'],'Stats':[],'PreciseStats':env['amounts'](env['direct'](item)),'HeroStats':[]}
    used={x['ItemId'] for x in docs['Items']['Items']}
    for item in env['items'].values():
        if item['ItemId'] in aliases:continue
        name=english(item['Name']);assert name,('Missing original English item',item['Name'])
        ident=slug(name);assert ident not in used,ident;used.add(ident);aliases[item['ItemId']]=ident;newAlias[item['ItemId']]=ident;item['Name']=name
    used={x['Id'] for x in docs['Skills']['Skills']}
    for skill in env['skills'].values():
        if skill['Id'] in aliases:continue
        name=english(skill['Name']) or english(skill['Name'].lstrip('&'))
        owners=[u for u in units if u['NormalAttackSkillId']==skill['Id'] or any(s['SkillId']==skill['Id'] for s in u.get('SkillSlots',[]))]
        owner=aliases[owners[0]['Id']] if owners else slug(row('Skill',table('Skill')[1][skill['Crystal']['SourceId']][0])['Skill Name'].split('_')[0])
        if not name:
            technical=row('Skill',table('Skill')[1][skill['Crystal']['SourceId']][0])['Skill Name'];name=technical.lstrip('&').replace('_',' ');report['TechnicalSkillNames'].append({'SourceId':skill['Crystal']['SourceId'],'Name':name})
        skill['Name']=name;ident=owner+'_'+slug(name)
        if ident in used:ident+='_'+slug(row('Skill',table('Skill')[1][skill['Crystal']['SourceId']][0])['Skill Name'])
        assert ident not in used,ident;used.add(ident);aliases[skill['Id']]=ident;newAlias[skill['Id']]=ident
    for sourceId in range(19,40):aliases['crystal_stage_'+str(sourceId)]='chapter_two_stage_'+str(sourceId-18)
    aliases['crystal_chapter_2']='chapter_two'
    def canonical(v):
        if isinstance(v,list):return [canonical(x) for x in v]
        if isinstance(v,dict):return {k:canonical(x) for k,x in v.items()}
        if isinstance(v,str):return aliases.get(v,v).replace('Crystal/','Zatod/')
        return v
    imported={'Heroes':env['heroes'],'Monsters':env['monsters'],'Items':list(env['items'].values()),'Skills':list(env['skills'].values()),'Buffs':env['buffs']}
    for section,entries in imported.items():
        existing={r.get('ItemId',r.get('Id',r.get('SourceId'))):r for r in docs[section][section]}
        if section=='Buffs':existing={r['SourceId']:r for r in docs[section][section]}
        for original in entries:
            value=canonical(original)
            if section=='Buffs':
                key=value['SourceId'];value['Id']=slug(value['Name']);assert value['Id'],value['Name'];value['Name']=value['Id'].replace('_',' ').title()
            else:key=value.get('ItemId',value.get('Id'))
            if key not in existing:
                docs[section][section].append(value);existing[key]=value;report[section].append(key)
            elif section=='Items':
                # Existing equipment needs its direct-main-attribute contribution for the newly imported Heroes.
                heroIds={r['HeroId'] for r in existing[key].get('HeroStats',[])}
                for bonus in value.get('HeroStats',[]):
                    if bonus['HeroId'] not in heroIds:existing[key].setdefault('HeroStats',[]).append(bonus)
        docs[section]['ConfigVersion']='zatod-prototype-chapters-1-2'
    oldStats={s['Id'] for s in docs['Stats']['Stats']}
    for key in sorted(env['required_stats']-oldStats):docs['Stats']['Stats'].append({'Id':key,'Name':key.replace('_',' ').title(),'Minimum':0})
    docs['Stats']['ConfigVersion']='zatod-prototype-chapters-1-2'
    stageCode=source[source.index('def multiplier('):source.index("write(DATA/'Campaigns.txt'")];exec(compile(stageCode,'chapter-stages','exec'),env)
    campaign=read(DATA/'Campaigns.txt')
    if not any(ch['Id']=='chapter_two' for ch in campaign['Chapters']):
        new=[]
        for original in env['stages']:
            if original['SourceStageId']<19:continue
            st=canonical(original);st['DropItems']=[];src=row('Stage',table('Stage')[1][st['SourceStageId']])
            for n in range(1,11):
                item=src.get('UI reward'+str(n),0);key=aliases.get('crystal_item_'+str(item))
                if key and key in {x['ItemId'] for x in docs['Items']['Items']} and not any(x['ItemId']==key for x in st['DropItems']):st['DropItems'].append({'ItemId':key,'DropChancePercent':0})
            st['MaxDropAmount']=5
            if st['DropItems']:
                share=10000//len(st['DropItems'])
                for i,drop in enumerate(st['DropItems']):drop['DropChancePercent']=(share if i<len(st['DropItems'])-1 else 10000-share*(len(st['DropItems'])-1))/100
            new.append(st)
        campaign['Chapters'].append({'Id':'chapter_two','Name':'Chương 2','Stages':new})
    campaign['ConfigVersion']='zatod-chapters-1-2-world-1'
    for ch in campaign['Chapters']:
        if ch['Id']=='chapter_two':
            for index,st in enumerate(ch['Stages']):st['MapX']=round(.08+(index%7)*.14,6);st['MapY']=round(.2+(index//7)*.3,6)
    for n,doc in docs.items():write(DATA/(n+'.txt'),doc)
    write(DATA/'Campaigns.txt',campaign);mapping['Aliases']=aliases;mapping['Counts']={n:len(doc[n]) for n,doc in docs.items()};write(mappingPath,mapping)
    # Keep legacy references readable without changing persisted GUIDs or archive IDs.
    lines=['using System;','using System.Collections.Generic;','namespace Zatod.Heroes { public static class ZatodContentIds {','static readonly Dictionary<string,string> aliases=new Dictionary<string,string>(StringComparer.Ordinal) {']
    lines += ['{'+json.dumps(k)+','+json.dumps(v)+'},' for k,v in sorted(aliases.items())]
    lines += ['};','public static string Canonical(string id)=>id!=null && aliases.TryGetValue(id,out var v)?v:id;','public static string Unit(int id)=>Canonical("crystal_"+id);','public static string Stage(int id)=>Canonical("crystal_stage_"+id);','}}']
    (ROOT/'Unity/Assets/Zatod/Heroes/ZatodContentIds.cs').write_text('\n'.join(lines)+'\n',encoding='utf-8')
    report['Counts']=mapping['Counts'];report['ChapterStageCounts']=[len(ch['Stages']) for ch in campaign['Chapters']];report['WaveCount']=sum(len(st['Waves']) for ch in campaign['Chapters'] for st in ch['Stages'])
    write(ROOT/'Artifacts/ZatodWorldChecks/chapter-two-import.json',report);print(json.dumps(report,ensure_ascii=False))
if __name__=='__main__':main()
