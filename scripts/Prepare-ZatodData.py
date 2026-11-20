"""Canonicalize imported Zatod content; retain stable source metadata and legacy ID aliases.
Run after Import-CrystalConfig.py. Does not execute any recovered Lua.
"""
from pathlib import Path
from collections import Counter
import json, re

ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / 'Unity/Assets/Zatod/Resources/Data'
AUDIT = ROOT / 'Artifacts/CrystalPhaseChecks/english-name-audit-20261119.json'

def read(p): return json.loads(p.read_text(encoding='utf-8-sig'))
def write(p, v): p.write_text(json.dumps(v, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
def slug(v):
    v=re.sub(r'([a-z0-9])([A-Z])', r'\1_\2', v)
    return re.sub('[^a-z0-9]+','_',v.lower()).strip('_')

def main():
    # Idempotence is important: an authoring reload must not bring back the old roster.
    if all(not str(x.get('ItemId',x.get('Id',''))).startswith('crystal_') for x in read(DATA/'Heroes.txt')['Heroes']):
        print('Zatod config already canonical.'); return
    audit=read(AUDIT); names={x['OldId']:x for n in ['Items','Skills'] for x in audit[n]}
    docs={n:read(DATA/(n+'.txt')) for n in ['Heroes','Monsters','Items','Skills','Buffs','Stats']}
    rows={n:[x for x in d[n] if n in ['Buffs','Stats'] or str(x.get('ItemId',x.get('Id',''))).startswith('crystal_')] for n,d in docs.items()}
    aliases={}; used=set(); units={}
    for section in ['Heroes','Monsters']:
        for row in rows[section]:
            old=row['Id']; new=slug(row['Name']); assert new not in used,new
            used.add(new);aliases[old]=new;units[row['SourceUnitId']]=new
    hidden={'OK_evo':'OK Evolution','OK_fashion':'OK Fashion Seal','Bone_warschool':'Bone War School Spirit',
            'Pugna_warschool':'Pugna War School Spirit','Tiny_warschool':'Tiny Stone Skin',
            'Ench_evo':'Ench Forest Shield','Ench_fashion_cake':'Ench Sweet Supply'}
    for section in ['Items','Skills']:
        used=set()
        for row in rows[section]:
            old=row.get('ItemId',row.get('Id')); entry=names[old]
            en=entry['ExactEnglish'].get('nil') or entry.get('EnglishAfterRemovingTechnicalPrefix',{}).get('nil')
            if not en:en=hidden[entry['SourceScriptName']]
            row['Name']=en
            if section=='Items':new=slug(en)
            else:
                owners=[u for group in ['Heroes','Monsters'] for u in rows[group] if u['NormalAttackSkillId']==old or any(s['SkillId']==old for s in u.get('SkillSlots',[])) or old in u.get('SkillIds',[])]
                owner=units[owners[0]['SourceUnitId']] if owners else slug(entry['SourceScriptName'].split('_')[0])
                new=owner+'_'+slug(en)
                if new in used:new+='_'+slug(entry['SourceScriptName'].split('_',1)[-1])
            assert new not in used,new
            used.add(new);aliases[old]=new
    campaign=read(DATA/'Campaigns.txt')
    for chapter in campaign['Chapters']:
        aliases[chapter['Id']]='chapter_one'
        for stage in chapter['Stages']:aliases[stage['Id']]='chapter_one_stage_'+str(stage['SourceStageId'])
    def replace(v):
        if isinstance(v,dict):return {k:replace(x) for k,x in v.items()}
        if isinstance(v,list):return [replace(x) for x in v]
        if isinstance(v,str):return aliases.get(v,v).replace("Crystal/","Zatod/")
        return v
    for n,entries in rows.items():
        if n=='Buffs':
            for b in entries:b['Id']=slug(b['Name']);b['Name']=b['Id'].replace('_',' ').title()
        write(DATA/(n+'.txt'),{'SchemaVersion':1,'ConfigVersion':'zatod-prototype-2',n:replace(entries)})
    campaign=replace(campaign);campaign['ConfigVersion']='zatod-chapter-one-2'
    # Actual Unity asset replacement/move is performed through the Editor to preserve GUIDs.
    write(ROOT/'Artifacts/CrystalPhaseChecks/zatod-campaign-canonical.json',campaign)
    write(DATA/'Campaigns.txt',campaign)
    existing=ROOT/'Artifacts/CrystalPhaseChecks/zatod-id-mapping.json'
    combined=read(existing)['Aliases'] if existing.exists() else {}
    combined.update(aliases)
    mapping=ROOT/'Artifacts/CrystalPhaseChecks/zatod-id-mapping.json'
    write(mapping,{'Date':'2026-11-19','Aliases':combined,'Counts':{n:len(v) for n,v in rows.items()},'HiddenTechnicalNames':hidden})
    # Pure C# mapping is shared by CLI tests, Unity, the server and save migration.
    lines=['using System;','using System.Collections.Generic;','namespace Zatod.Heroes {',
           'public static class ZatodContentIds {',
           'static readonly Dictionary<string,string> aliases=new Dictionary<string,string>(StringComparer.Ordinal) {']
    lines += ['{'+json.dumps(k)+','+json.dumps(v)+'},' for k,v in sorted(combined.items())]
    lines += ['};','public static string Canonical(string id)=>id!=null && aliases.TryGetValue(id,out var value)?value:id;',
              'public static string Unit(int sourceId)=>Canonical("crystal_"+sourceId);',
              'public static string Stage(int sourceId)=>Canonical("crystal_stage_"+sourceId);','}}']
    (ROOT/'Unity/Assets/Zatod/Heroes/ZatodContentIds.cs').write_text('\n'.join(lines)+'\n',encoding='utf-8')
    print(json.dumps({'Counts':{n:len(v) for n,v in rows.items()},'AliasCount':len(combined)}))

if __name__=='__main__':main()
