"""Import the approved Crystal prototype config from recovered, return-only Lua tables.
Never executes game Lua. Existing pixel content is retained; imported rows have stable crystal_ IDs.
"""
from pathlib import Path
from collections import defaultdict
import json, sys, math
ROOT = Path(__file__).resolve().parent.parent
REF = ROOT / 'Crystal Legend'
sys.path.insert(0, str(REF / 'recovery_tools'))
from lua_data import read_table, named_row
DATA = ROOT / 'Unity/Assets/Zatod/Resources/Data'
TABLES = {}
def table(name):
    if name not in TABLES: TABLES[name] = read_table(name)
    return TABLES[name]
def row(name, raw): return named_row(table(name), raw)
def values(value): return list(value.values()) if isinstance(value, dict) else []
def write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2)+'\n', encoding='utf8')
def read(path): return json.loads(path.read_text(encoding='utf-8-sig'))
def uid(i): return 'crystal_' + str(i)
def sid(i): return 'crystal_skill_' + str(i)
def iid(i): return 'crystal_item_' + str(i)
MAP = {'HP':'health','MP':'energy_max','AD':'damage','AP':'ability_power','ARM':'defense','MR':'magic_resistance','CRIT':'physical_crit','MCRIT':'magic_crit','HPS':'wave_health_regen','MPS':'wave_energy_regen','HIT':'accuracy','DODG':'dodge','ARMP':'armor_penetration','MRI':'magic_penetration','LFS':'lifesteal','CDR':'energy_cost_reduction','HEAL':'healing_bonus','HealRatio':'heal_ratio','HAST':'haste','MSPD':'action_speed','TEN':'tenacity','HPR':'health_regen','MPR':'energy_regen','PIMU':'physical_immunity','MIMU':'magic_immunity','ALLIMU':'all_immunity','SILR':'silence_resistance','SKL':'skill_level_bonus','INTR':'interrupt_rating','KMPR':'kill_energy','DOTRES':'dot_resistance','CRITRES':'physical_crit_resistance','MCRITRES':'magic_crit_resistance'}
SOURCE_STATS = ['HP','MP','AD','AP','ARM','MR','CRIT','MCRIT','HPS','MPS','HIT','DODG','ARMP','MRI','LFS','CDR','HEAL','HealRatio','SKL','SILR','TEN','INTR','KMPR','DOTRES','CRITRES','MCRITRES','HPR','MPR','HAST','MSPD','PIMU','MIMU','ALLIMU','LFSRatio','POAD','POAP','POARM','POMR','DotDRatio','MPRatio','MPGainRatio','KnockRES','MDODG','ADDP','APDP','CSD','MCSD','RESHURT']
for key in SOURCE_STATS: MAP.setdefault(key, key.lower())
required_stats = set(['health','damage','defense','attack_range','move_speed','attack_interval','energy_max','ability_power','magic_resistance','haste','action_speed'])
def direct(raw, main=None):
    result = {MAP[k]:float(raw.get(k) or 0) for k in SOURCE_STATS}
    strength, agility, intelligence = [float(raw.get(k) or 0) for k in ['STR','AGI','INT']]
    result['health'] += strength*18
    result['defense'] += strength*.15 + agility*.08
    result['ability_power'] += intelligence*2.4
    result['magic_resistance'] += intelligence*.1
    result['damage'] += agility*.4 + float(raw.get(main) or 0)
    result['physical_crit'] += agility*.4
    return {k:round(v,9) for k,v in result.items() if abs(v)>1e-9}
def amounts(stats):
    required_stats.update(stats)
    return [{'StatId':k,'Value':v} for k,v in sorted(stats.items()) if abs(v)>1e-9]
def plus(a,b,ratio=1):
    result=dict(a)
    for k,v in b.items(): result[k]=result.get(k,0)+v*ratio
    return result
units={i:row('Unit',r) for i,r in table('Unit')[1].items()}
starter=[1,2,3,4,45]
selected=set(starter)
normal_stages=sorted([row('Stage',r) for r in table('Stage')[1].values() if row('Stage',r)['Chapter ID']==1 and row('Stage',r)['Difficulty']==1],key=lambda r:r['Stage ID'])
for st in normal_stages:
    for raw in table('Battle')[1][st['Stage ID']].values():
        w=row('Battle',raw)
        selected.update(w['Monster '+str(n)+' ID'] for n in range(1,6) if w['Monster '+str(n)+' ID'])
hero_ids=sorted(i for i in selected if units[i]['Unit Type']=='Hero')
monster_ids=sorted(selected-set(hero_ids))
heroes=[];monsters=[];skills={};buff_ids=set();items={};audit={'warnings':[],'units':[]}
for hid in hero_ids:
    for rank in range(1,5):
        r=row('hero_equip',table('hero_equip')[1][hid][rank])
        for n in range(1,7):
            item_id=r['Equip'+str(n)+' ID']
            source=row('equip',table('equip')[1][item_id])
            if item_id not in items:
                items[item_id]={'ItemId':iid(item_id),'Name':source['Name'],'IconResource':source['Icon'],'LevelRequirement':source['Level Requirement'],'Quality':source['Quality'],'Stats':[],'PreciseStats':amounts(direct(source)),'HeroStats':[]}
for item_id, item in items.items():
    source=row('equip',table('equip')[1][item_id])
    for hid in hero_ids:
        extra=float(source.get(units[hid]['Main Attrib']) or 0)
        if extra:item['HeroStats'].append({'HeroId':uid(hid),'Stats':amounts({'damage':extra})})

def phases_for(unit, info):
    puppet=row('Puppet',table('Puppet')[1][unit['Puppet']]);resource=puppet['Resource']+'.cha';phases=[]
    for action in values(info['Action(s)']):
        duration_raw=table('AnimDuration')[1].get(resource,{}).get(action)
        events=table('AnimAtkFrame')[1].get(resource,{}).get(action,{})
        if not duration_raw: raise ValueError(f'Missing duration {resource}:{action}')
        origins=[row('AnimAtkFrame',e) for e in events.values()]
        origins.sort(key=lambda r:r['Time'])
        phases.append({'Action':action,'Duration':duration_raw[table('AnimDuration')[2]['Duration']],'AttackTimes':[e['Time'] for e in origins],'AttackOrigins':[{'Time':e['Time'],'X':e['X'],'Y':e['Y']} for e in origins]})
    return phases

FIELDS={'ActiveType':'Active Type','TargetType':'Target Type','TrackType':'Track Type','DamageType':'Damage Type','PlusAttribute':'Plus Attr','PassiveAttribute':'Passive Attr','AoeOrigin':'AOE Origin','AoeShape':'AOE Shape','ProjectileArt':'Tile Art','ImpactEffect':'Impact Effect','ChainEffect':'Chain Effect','LaunchEffect':'Launch Effect','PointEffect':'Point Effect','TargetCamp':'Target Camp','AffectedCamp':'Affected Camp','BuffId':'Buff ID','ChainJumps':'Chain Jumps','BasicAmount':'Basic Num','PlusRatio':'Plus Ratio','CostEnergy':'Cost MP','GainEnergy':'Gain MP','Cooldown':'CD','InitialCooldown':'Init CD','GlobalCooldown':'Global CD','MinRange':'Min Range','MaxRange':'Max Range','ShapeArg1':'Shape Arg1','ShapeArg2':'Shape Arg2','XShift':'X Shift','ChainGap':'Chain Gap','ProjectileSpeed':'Tile XY Speed','ProjectileZSpeed':'Tile Z Speed','Gravity':'Tile Gravity','ProjectileDistance':'Tile Distance','ProjectileOverHeight':'Tile OTT Height','KnockUp':'Knock Up','KnockBack':'Knock Back','MoveForward':'Move Forward','CritPercent':'CRIT%','LifestealPercent':'LFS%','Manual':'Manual','Piercing':'Tile Piercing','AimTarget':'Aim Target'}
def import_skill(unit, group):
    skill_id=group['Skill Group ID']
    if skill_id in skills:return skills[skill_id]
    info=row('Skill',table('Skill')[1][skill_id][0])
    meta={out:info.get(src) for out,src in FIELDS.items() if info.get(src) is not None}
    meta.update(SourceId=skill_id,Slot=group['Slot'],UnlockRank=group['Unlock'],Priority=group['Priority'],Interruptable=group['Interruptable'],Growth=[{'Field':group['Growth '+str(i)+' Field'],'Amount':group['Growth '+str(i)+' Value']} for i in range(1,6) if group['Growth '+str(i)+' Field']],ScriptArgs=[info['Script Arg'+str(i)] for i in range(1,7)],Phases=phases_for(unit,info))
    if meta.get('BuffId'):buff_ids.add(meta['BuffId'])
    active=info['Active Type']=='active';manual=bool(info['Manual'])
    entry={'Id':sid(skill_id),'Name':group['Display Name'] or info['Skill Name'],'Kind':0 if active else 1,'Activation':1 if manual else (0 if active else 2),'Target':1,'EnergyCost':int(info['Cost MP']),'CooldownMilliseconds':round(info['CD']*1000),'CastRange':round(info['Max Range']*10),'AnimationState':meta['Phases'][0]['Action'] if meta['Phases'] else 'Idle','Effects':[],'Crystal':meta}
    skills[skill_id]=entry
    return entry

ranks=['white','green','green_plus_1','blue']
for unit_id in sorted(selected):
    unit=units[unit_id];puppet=row('Puppet',table('Puppet')[1][unit['Puppet']]);resource=puppet['Resource']
    if not (REF/'recovered/heroes'/resource/'animation.json').is_file():raise ValueError('Missing art '+resource)
    precise=direct(unit,unit['Main Attrib'])
    basic_id=unit['Basic Skill'];rawgroups=[row('SkillGroup',r) for r in table('SkillGroup')[1].get(unit_id,{}).values()]
    basic=next(g for g in rawgroups if g['Skill Group ID']==basic_id)
    import_skill(unit,basic)
    for group in rawgroups:
        if group['Unlock']<=4 and not group['Awake'] and not group['Super Awake']:import_skill(unit,group)
    base_stats={'health':max(1,round(precise.get('health',1))),'damage':max(1,round(precise.get('damage',1))),'defense':max(0,round(precise.get('defense',0))),'attack_range':max(1,round(skills[basic_id]['Crystal']['MaxRange']*10)),'move_speed':round(unit['Walk Speed']*10),'attack_interval':max(1,round(skills[basic_id]['Crystal']['Cooldown']*20)),'damage_energy_rate':unit['MP Gain Rate'],'interrupt_health_ratio':unit['Interrupt HP Ratio'] or 8}
    growth=[]
    for star in range(1,6):
        src={a:unit.get('+'+a+str(star),0) for a in ['STR','AGI','INT']}
        growth.append({'Stars':star,'PerLevel':amounts(direct(src,unit['Main Attrib']))})
    definition={'Id':uid(unit_id),'Name':unit['Name'],'SourceUnitId':unit_id,'Position':{'前排':0,'中排':1,'后排':2}.get(unit['Position Type'],0),'PortraitKey':uid(unit_id),'BodyPrefabResource':'Crystal/'+resource+'/'+resource,'AnimationSetResource':'Crystal/'+resource+'/AnimationSet','SourcePuppet':unit['Puppet'],'SourceResource':resource,'ArtScale':puppet['Scale'],'CollideRadius':unit['Collide Radius'],'ProjectileHurtboxHeight':100,'DeathAnimationMilliseconds':1500,'NormalAttackSkillId':sid(basic_id),'BaseStats':[{'StatId':k,'Value':v} for k,v in base_stats.items()],'PreciseBaseStats':amounts(plus(precise,{k:v for k,v in base_stats.items() if k in ['attack_range','move_speed','attack_interval','damage_energy_rate','interrupt_health_ratio']})),'Growth':growth}
    definition['RankStats']=[]
    for source_rank in range(1,5):
        rs=row('UnitRank',table('UnitRank')[1][unit_id][source_rank])
        es={k:rs.get('E.'+k,rs.get(k,0)) for k in ['STR','AGI','INT']+SOURCE_STATS}
        definition['RankStats'].append({'Rank':source_rank,'Stats':amounts(direct(rs,unit['Main Attrib'])),'EstimatedStats':amounts(direct(es,unit['Main Attrib']))})
    if unit_id in hero_ids:
        definition.update(StartingRankId='white',Ranks=[],SkillSlots=[])
        primary=[g for g in rawgroups if 1<=g['Slot']<=4 and g['Unlock']<=4 and not g['Awake'] and not g['Super Awake']]
        primary.sort(key=lambda g:g['Slot'])
        for group in primary:definition['SkillSlots'].append({'Id':'skill_'+str(group['Slot']),'SkillId':sid(group['Skill Group ID']),'IsUltimate':group['Slot']==1})
        absorbed={};prior_residual={}
        for rank in range(1,5):
            gear=row('hero_equip',table('hero_equip')[1][unit_id][rank]);unitrank=row('UnitRank',table('UnitRank')[1][unit_id][rank])
            desired=direct(unitrank,unit['Main Attrib']);residual=plus(desired,absorbed,-1);increment=plus(residual,prior_residual,-1);prior_residual=residual
            slots=[{'Id':'gear_'+str(i),'RequiredItemId':iid(gear['Equip'+str(i)+' ID'])} for i in range(1,7)]
            definition['Ranks'].append({'Id':ranks[rank-1],'Name':['Trắng','Xanh Lá','Xanh Lá+1','Xanh Dương'][rank-1],'NextRankId':ranks[rank] if rank<4 else '', 'BonusStats':[],'PreciseBonusStats':amounts(increment),'EquipmentSlots':slots,'UnlockSkillSlotIds':['skill_'+str(g['Slot']) for g in primary if g['Unlock']==rank]})
            for i in range(1,7):absorbed=plus(absorbed,direct(row('equip',table('equip')[1][gear['Equip'+str(i)+' ID']]),unit['Main Attrib']))
        heroes.append(definition)
    else:
        rank=row('UnitRank',table('UnitRank')[1][unit_id][1]);precise=plus(precise,direct(rank,unit['Main Attrib']))
        definition['PreciseBaseStats']=amounts(plus(direct(unit,unit['Main Attrib']),{k:v for k,v in base_stats.items() if k in ['attack_range','move_speed','attack_interval','damage_energy_rate','interrupt_health_ratio']}))
        for v in definition['BaseStats']:
            if v['StatId'] in precise:v['Value']=max(0,round(precise[v['StatId']]))
        definition['SkillIds']=[];monsters.append(definition)
    audit['units'].append({'Id':unit_id,'Name':unit['Name'],'Resource':resource,'Hero':unit_id in hero_ids})

buffs=[]
buff_ids.update([10000402,10000701,10001004,10002001])
for buff_id in sorted(buff_ids):
    info=row('Buff',table('Buff')[1][buff_id]);stats=direct(info);required_stats.update(stats)
    scaling=[{'StatId':MAP[key],'Attribute':MAP[info[key+'.x']],'Ratio':info[key+'.a']} for key in SOURCE_STATS if info.get(key+'.x')]
    buffs.append({'SourceId':buff_id,'Name':info['Name'],'Control':','.join(str(x) for x in values(info['Control Effects'])) if info['Control Effects'] else '','StackRule':str(info['Stack and Refresh'] or ''),'Dispel':str(info['Dispel'] or ''),'Tenacity':info['Tenacity'],'Effect':info['Effect'],'ImpactEffect':info['Impact Effect'],'Mod':info['MOD'],'Duration':info['Time'],'ShieldValue':info['Shield Value'],'ShieldType':info['Shield Type'],'ClearOnDeath':bool(info['Clear On Death ']),'MaximumStacks':info['Max Stack Times'],'Scaling':scaling,'Stats':[{'StatId':k,'Value':v} for k,v in sorted(stats.items())]})
# Buff mode suffixes are handled by the buff runtime, not permanent stat IDs.
version=read(DATA/'Stats.txt')['ConfigVersion'].split('-crystal-p1')[0]+'-crystal-p1'
imports={'Heroes':heroes,'Monsters':monsters,'Items':list(items.values()),'Skills':list(skills.values()),'Buffs':buffs}
for section,entries in imports.items():
    path=DATA/(section+'.txt');doc=read(path) if path.exists() else {'SchemaVersion':1,'ConfigVersion':version,section:[]}
    if section=='Buffs':doc[section]=entries
    else:
        key=lambda r:r.get('ItemId') or r.get('Id','')
        doc[section]=[r for r in doc[section] if not key(r).startswith('crystal_')]+entries
    doc['ConfigVersion']=version;write(path,doc)
stats=read(DATA/'Stats.txt');existing={r['Id'] for r in stats['Stats']}
for key in sorted(required_stats-existing):stats['Stats'].append({'Id':key,'Name':key.replace('_',' ').title(),'Minimum':0})
stats['ConfigVersion']=version;write(DATA/'Stats.txt',stats)
audit.update(Heroes=len(heroes),Monsters=len(monsters),Items=len(items),Skills=len(skills),Buffs=len(buffs),ConfigVersion=version)
assert len(heroes)==16 and len(monsters)==10 and len(items)==67
write(ROOT/'Artifacts/CrystalPhaseChecks/config-import.json',audit)
print(json.dumps({k:v for k,v in audit.items() if k not in ['units','warnings']},ensure_ascii=False))

# Chapter and stat oracle stay separate from the legacy prototype campaign.
def multiplier(value, default=100): return float(value or default)/100
stages=[]
for st in normal_stages:
    stage_id=st['Stage ID'];waves=[]
    for wave_id, raw in sorted(table('Battle')[1][stage_id].items()):
        info=row('Battle',raw);spawns=[]
        for n in range(1,6):
            unit_id=info['Monster '+str(n)+' ID']
            if not unit_id:continue
            boss=n==info['Boss Position']
            rank=info['Rank '+str(n)]
            spawns.append({'Id':'enemy_'+str(n),'DefinitionId':uid(unit_id),'SourceUnitId':unit_id,'Kind':0 if unit_id in hero_ids else 1,'Level':info['Level '+str(n)],'Stars':info['Stars '+str(n)],'RankId':ranks[rank-1] if 1<=rank<=4 else '', 'InitialEnergy':info['MP '+str(n)],'Boss':boss,'EstimateRank':rank==0,'HpMultiplier':multiplier(info['Monster HP%'])*(multiplier(info['Boss HP%']) if boss else 1),'DamageMultiplier':multiplier(info['Monster DPS%'])*(multiplier(info['Boss DPS%']) if boss else 1),'ArmorMultiplier':multiplier(info['Monster ARM%'])*(multiplier(info['Boss ARM%']) if boss else 1),'MagicResistanceMultiplier':multiplier(info['Monster MR%'])*(multiplier(info['Boss MR%']) if boss else 1),'SizeMultiplier':multiplier(info['BOSS SIZE%'],120) if boss else 1})
        hooks=[]
        if stage_id in [1,2,3] and wave_id==2:hooks.append({'Id':'dr_opening_energy','Action':0,'PlayerSide':True,'TargetDefinitionId':uid(2),'Amount':150})
        if stage_id==1 and wave_id==3:hooks.append({'Id':'boss_manual_ultimate','Action':2,'BossOnly':True,'Amount':0})
        if stage_id in [6,7] and wave_id==3:hooks.append({'Id':'boss_initial_energy','Action':1,'BossOnly':True,'Amount':800 if stage_id==6 else 950})
        waves.append({'Id':'wave_'+str(wave_id),'Index':wave_id,'TimeLimitSeconds':90,'BackgroundResource':info['Background Pic'],'FlipBackground':info['H Flip'],'Enemies':spawns,'Hooks':hooks})
    stages.append({'Id':'crystal_stage_'+str(stage_id),'Name':st['Stage Name'],'Description':st['description'],'SourceStageId':stage_id,'Difficulty':1,'VitalityCost':st['Vitality Cost'],'RequiredStageId':'crystal_stage_'+str(st['Require Stage']) if st['Require Stage'] else None,'EnergyGainMultiplier':st['MP Bonus'],'EnergySupplyPercent':st['Mps Restraint'],'MapX':round(.08+((stage_id-1)%6)*.168,6),'MapY':round(.2+((stage_id-1)//6)*.3,6),'Monsters':[],'Waves':waves})
write(DATA/'Campaigns.txt',{'SchemaVersion':1,'ConfigVersion':'crystal-chapter1-1','StarterHeroRankId':'white','StarterHeroIds':[uid(i) for i in starter],'Chapters':[{'Id':'crystal_chapter_1','Name':'Chương 1','Stages':stages}]})
oracle=[]
for hid in hero_ids:
    unit=units[hid]
    for stars in [1,3,5]:
        growth=direct({a:unit.get('+'+a+str(stars),0) for a in ['STR','AGI','INT']},unit['Main Attrib'])
        for rank in range(1,5):
            base=plus(direct(unit,unit['Main Attrib']),growth,40)
            base=plus(base,direct(row('UnitRank',table('UnitRank')[1][hid][rank]),unit['Main Attrib']))
            gear=row('hero_equip',table('hero_equip')[1][hid][rank])
            for full in [False,True]:
                expected=dict(base)
                if full:
                    for n in range(1,7):expected=plus(expected,direct(row('equip',table('equip')[1][gear['Equip'+str(n)+' ID']]),unit['Main Attrib']))
                oracle.append({'HeroId':uid(hid),'Stars':stars,'Level':40,'RankId':ranks[rank-1],'Equipped':full,'Expected':amounts(expected)})
write(ROOT/'Artifacts/CrystalPhaseChecks/stat-oracle.json',{'Rows':oracle})
print('Chapter: 18 stages / 54 waves; stat oracle:',len(oracle),'cases')

# Keep active Zatod config canonical after importing source metadata.
import runpy
runpy.run_path(str(ROOT / "scripts/Prepare-ZatodData.py"), run_name="__main__")
runpy.run_path(str(ROOT / "scripts/Import-ZatodStageDrops.py"), run_name="__main__")
