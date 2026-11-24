"""D35 targeted import. Reads safe Lua tables; preserves roster/ranks/items/progress.

The explicit mapping below was reviewed against each battle/heroes/<Hero>.lua hook.
Only the 75 active main slots receive milestones. Purple rows remain reference only.
"""
from pathlib import Path
import ast
import json
import re
import sys

ROOT=Path(__file__).resolve().parent.parent
REF=ROOT/'Unity/Assets/Crystal Legend'
DATA=ROOT/'Unity/Assets/Zatod/Resources/Data'
sys.path.insert(0,str(REF/'recovery_tools'))
from lua_data import read_table,named_row,Reader
def read(name): return json.loads((DATA/(name+'.txt')).read_text())
docs={n:read(n) for n in ('Heroes','Skills','Buffs','Stats')}
skills={s['Crystal']['SourceId']:s for s in docs['Skills']['Skills']}
source=json.loads((ROOT/'docs/reference/zatod-skill-promote-source.json').read_text())
evos={(r['SkillGroupId'],r['EvoSKill Rank']):r for r in source['SourceSkillEvoRows']}
tables={n:read_table(n) for n in ('SkillGroup','Skill','Buff')}
def row(name,*keys):
    raw=tables[name][1]
    for key in keys:raw=raw[key]
    return named_row(tables[name],raw)
def arg(s,r,n=1):return evos[s,r]['Script Arg'+str(n)]
groups={}
active={}
for hero in docs['Heroes']['Heroes']:
    groups.update({r['Skill Group ID']:r for r in [named_row(tables['SkillGroup'],x) for x in tables['SkillGroup'][1][hero['SourceUnitId']].values()]})
    for slot in hero['SkillSlots']:
        skill=next(x for x in skills.values() if x['Id']==slot['SkillId'])
        sid=skill['Crystal']['SourceId'];active[sid]=hero['Id'];slot['InitialLevel']=groups[sid]['Init Level']
        skill['Evolutions']=[dict(Id=skill['Id']+'_evo_'+str(r),RequiredSkillLevel=evos[sid,r]['EvoSkill UnlockLevel'],Description='',ParameterChanges=[],TriggeredEffects=[]) for r in (1,2,3)]
def evo(s,r):return skills[s]['Evolutions'][r-1]
def param(s,r,field,value=None,mode=0,text=None,**kw):
    p=dict(Field=field,Mode=mode,Value=arg(s,r) if value is None else value)
    if text is not None:p['Text']=text
    p.update(kw);evo(s,r)['ParameterChanges'].append(p)
def desc(s,r,text):evo(s,r)['Description']=text
def effect(s,r,kind=0,trigger=2,target=0,**kw):
    e=dict(Effect=kind,Trigger=trigger,Target=target,Duration=-1,Chance=100);e.update(kw);evo(s,r)['TriggeredEffects'].append(e)
def ratio(s,r):
    param(s,r,'PlusRatio');desc(s,r,f"Scaling increases to {arg(s,r):g} × {skills[s]['Crystal']['PlusAttribute']}.")
def duration(s,r,bonus=False,buff=0):
    param(s,r,'BuffDurationBonus' if bonus else 'BuffDuration',mode=1 if bonus else 0,BuffId=buff)
    desc(s,r,f"Effect duration {'increases by' if bonus else 'becomes'} {arg(s,r):g}s before tenacity.")
def stat(s,r,name,sign=1):
    param(s,r,'BuffStat',arg(s,r)*sign,1,StatId=name)
    desc(s,r,f"Buff {name.replace('_',' ')} changes by {arg(s,r)*sign:+g}.")

# Ordinary coefficient milestones, explicitly listed (no implicit fallback for unknown hooks).
ratio_ranks={10:[2],13:[1,3],12:[2,3],20:[2,3],22:[1,2,3],30:[1,2,3],32:[1,3],33:[1,2],40:[1,2,3],42:[2,3],43:[1,2],60:[1,2,3],62:[1],70:[1,2],72:[1],73:[1,2],82:[1,2],90:[1,2],92:[1,2],93:[1,2,3],100:[1,2],102:[2,3],103:[2,3],170:[3],172:[2,3],180:[1,2],182:[1,2,3],190:[1],192:[1,2],202:[1,2,3],292:[1,2,3],293:[1,2],370:[1,2],372:[1,2],450:[1,3],452:[1,2,3],160:[1,2],220:[1,2],222:[1,3],240:[1,2],242:[1,2],250:[1,2],252:[1,2,3],270:[1,2],272:[1,2],280:[1,2],283:[1,2],300:[1,2],302:[1,2],303:[1,2],360:[1,2],362:[1,2],363:[1,2,3],382:[1,2,3],383:[1,2]}
for s,ranks in ratio_ranks.items():
    for r in ranks:ratio(s,r)
for s,ranks in {10:[3],13:[2],33:[3],43:[3],62:[2,3],102:[1],173:[3],190:[3],290:[3],293:[3],453:[1,2,3],223:[1,2,3],282:[3],362:[3]}.items():
    for r in ranks:duration(s,r)
for s in (23,63):
    for r in (1,2):duration(s,r,True)
for s,r,bid in [(12,1,10000103),(32,2,10000301),(73,3,10000703),(250,2,10002503),(163,3,10001603)]:
    effect(s,r,BuffId=bid);desc(s,r,f"On a successful hit, applies {row('Buff',bid)['Name']}.")
effect(10,1,trigger=1,target=2,BuffId=10000104)
desc(10,1,'At the attack frame, grants all living allies Rum for 9s: +20 physical and magic damage immunity.')
param(20,1,'ExtraVolleyProjectiles',1);desc(20,1,'Each volley launches one additional arrow, up to five.')
param(23,3,'ShapeArg1',80+arg(23,3));desc(23,3,f"Silence radius increases to {80+arg(23,3):g}.")
param(42,1,'ChainJumps',arg(42,1)+1);desc(42,1,f"Lightning reaches {arg(42,1)+1:g} targets.")
effect(63,2,kind=1,Amount=arg(63,2,2));desc(63,2,f"Extends disable by {arg(63,2):g}s and steals {arg(63,2,2):g} energy.")
for stat_id in ('physical_immunity','magic_immunity'):param(63,3,'BuffStat',-arg(63,3),StatId=stat_id)
desc(63,3,f"While disabled, the target loses {arg(63,3):g} physical and magic immunity.")
param(70,3,'KnockBack',100);param(70,3,'KnockUp',.1);desc(70,3,'Hits knock enemies back by 100 and lift them for 0.1s.')
stat(72,2,'health_regen',-1);param(72,3,'DotHealPercent');desc(72,3,f"Heals the caster for {arg(72,3):g}% of this poison's periodic damage.")
for r in (1,2,3):param(80,r,'ShieldBonus',mode=1);desc(80,r,f"Adds {arg(80,r):g} shield capacity.")
effect(82,3,kind=3,SkillId=skills[85]['Id'],UseSkillPower=True,Ratio=arg(82,3)/100)
desc(82,3,f"Healing also deals {arg(82,3):g}% of skill power as magic damage around the healed ally.")
effect(83,1,kind=2);desc(83,1,'Removes dispellable enemy debuffs from the target.')
for r in (2,3):param(83,r,'ShieldBonus',mode=1);desc(83,r,f"Adds {arg(83,r):g} shield capacity.")
effect(90,3,trigger=3,target=1,BuffId=10000901);desc(90,3,'On cast completion, grants the source Tinker evolution buff.')
param(92,3,'AoeOrigin',0,text='target');param(92,3,'AoeShape',0,text='circle');param(92,3,'ShapeArg1',100);desc(92,3,'Laser hits enemies within radius 100 around its target.')
param(100,3,'KillEnergy');desc(100,3,f"A killing shot restores {arg(100,3):g} additional energy.")
param(103,1,'SlowCap');desc(103,1,f"The direct attack-stat ratio may amplify the slowing effect up to {arg(103,1):g}×.")
for r in (1,2):stat(170,r,'damage');stat(173,r,'haste')
effect(170,3,trigger=0,target=1,BuffId=10001703,Amount=arg(170,3,2),Ratio=arg(170,3,3));desc(170,3,f"Scaling becomes {arg(170,3):g}×; cast start grants a shield of {arg(170,3,2):g} + {arg(170,3,3):g} × AP.")
param(172,1,'RepeatHitRatio',arg(172,1)/100);param(172,1,'RepeatHitMaximum',arg(172,1,2));desc(172,1,f"Each prior hit on the same target adds {arg(172,1):g}% damage, up to {arg(172,1,2):g} stacks.")
effect(180,2,trigger=0,target=1,BuffId=10001803);desc(180,2,f"Scaling becomes {arg(180,2):g} × AP; immune to control during channeling.")
param(180,3,'ScriptArg2',mode=1);desc(180,3,f"Life drain heals an additional {arg(180,3):g}% of damage dealt.")
for r in (1,2):stat(183,r,'magic_immunity',-1)
effect(183,3,kind=6);param(183,3,'MagicHitRatio',arg(183,3)/100);param(183,3,'MagicHitMaximum',arg(183,3,2));desc(183,3,f"Magic hits during Exile charge the next Magic Burst by {arg(183,3):g}% per hit, up to {arg(183,3,2):g} hits.")
effect(190,2,trigger=4,BuffId=10001904);desc(190,2,'When its stun is removed, applies the source burning and slowing debuff.')
param(192,3,'MissingHealthRatio');param(192,3,'CritPercent',100);desc(192,3,f"Adds {arg(192,3):g} × caster missing HP to damage and permits critical hits.")
for r in (1,2,3):param(194,r,'BasicAmount',mode=1);desc(194,r,f"Aura lifesteal increases by {arg(194,r):g}.")
for r,field in [(1,'ScriptArg4'),(2,'ScriptArg3'),(3,'ScriptArg2')]:param(200,r,field,mode=1);desc(200,r,f"{'Minimum damage' if r==1 else 'Maximum damage' if r==2 else 'Missing-health ratio'} increases by {arg(200,r):g}.")
stat(203,1,'health_regen');stat(203,2,'magic_immunity');desc(203,3,'At the first lethal hit, Life Insight also resets Vitality Pulse cooldown.')
effect(203,3,kind=7,trigger=7,target=1,SkillId=skills[202]['Id'])
for r in (1,2):param(290,r,'ScriptArg3');desc(290,r,f"Landing damage scales with {arg(290,r):g} × AP.")
stat(370,3,'health_regen',-1);param(372,3,'BuffStat',0,1,StatId='health_regen',ScalingAttribute='ability_power',ScalingRatio=-arg(372,3));desc(372,3,f"Poison gains {arg(372,3):g} × AP damage per second.")
for r in (1,2):param(374,r,'BasicAmount',mode=1);desc(374,r,f"Passive magic resistance increases by {arg(374,r):g}.")
effect(374,3,trigger=6,BuffId=10003703);desc(374,3,'When taking physical damage, poisons the living attacker.')
effect(450,2,kind=5,BuffId=10004502,Maximum=row('Skill',455,0)['Script Arg2']);desc(450,2,'Excess healing becomes a 12s shield, capped at 10000; subsequent full-health healing adds to the shield.')
param(160,3,'BuffStat',-arg(160,3),StatId='physical_immunity');desc(160,3,f"Petrified enemies lose {arg(160,3):g} physical immunity, including Arcane Serpent petrification.")
for r in (1,2):param(162,r,'SplitRatioBonus',arg(162,r)/100,1);desc(162,r,f"Secondary arrows gain {arg(162,r):g}% of primary arrow damage.")
param(162,3,'SplitTargets');desc(162,3,f"Fires at up to {arg(162,3):g} additional enemies.")
for r in (1,2):param(163,r,'ScriptArg2',mode=1);desc(163,r,f"Arcane Serpent steals {arg(163,r):g} more energy.")
param(220,3,'ChainJumps',arg(220,3)+1);desc(220,3,f"Shadow Wave reaches {arg(220,3)+1:g} targets.")
stat(222,2,'health_regen',-1)
for s in (240,242,243):param(s,3,'MulticastFourChance',20);desc(s,3,'Multicast chances become 40% / 20% / 20% / 20% for 1 / 2 / 3 / 4 casts.')
for r in (1,2):stat(243,r,'haste')
param(250,3,'DistanceDamageCap');desc(250,3,f"Nearby enemies take up to {arg(250,3):g}× ultimate damage.")
for r in (1,2,3):stat(253,r,'damage');stat(273,r,'health_regen')
effect(270,3,kind=4,Chance=arg(270,3));desc(270,3,f"Each successful slash has a {arg(270,3):g}% chance to add a basic attack.")
param(272,3,'Cooldown');desc(272,3,f"Cooldown becomes {arg(272,3):g}s.")
param(280,3,'ExecuteDamageRatio');desc(280,3,f"Against enemies below 30% HP, deals {arg(280,3):g}× damage.")
for r in (1,2):stat(282,r,'health_regen',-1)
param(283,3,'CounterChance');param(283,3,'CounterCooldown',arg(283,3,2));param(283,3,'CounterHealPercent',arg(283,3,3));desc(283,3,f"Counter chance becomes {arg(283,3):g}%, with {arg(283,3,2):g}s internal cooldown; completing it heals {arg(283,3,3):g}% max HP.")
for s in (300,302,303):effect(s,3,kind=3,trigger=1,target=1,SkillId=skills[305]['Id'],ScaleByEnemyCount=True);desc(s,3,'Attack frame adds Aftershock around the caster, with damage multiplied by enemies in range.')
for dep in (368,369):effect(360,3,kind=3,SkillId=skills[dep]['Id'])
desc(360,3,'Successful ultimate hits also apply both native evolution debuffs around the target.')
for r in (1,2,3):duration(380,r,buff=10003803)
param(383,3,'DamageType',0,text='Holy');desc(383,3,'Flame Storm deals Holy damage.')

assert len(active)==75
for s in active:
    for e in skills[s]['Evolutions']:
        assert e['Description'] and (e['ParameterChanges'] or e['TriggeredEffects']), (s,e)

# Official localization contains source placeholders; runtime preview resolves their values.
translation_path=REF/'recovered/scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data/texttable/texttable.lua'
translation_text=translation_path.read_text(encoding='utf-8-sig')
translation_text=re.sub(r'\[(=*)\[(.*?)\]\1\]',lambda m:json.dumps(m.group(2),ensure_ascii=False),translation_text,flags=re.S)
translations=Reader(translation_text.replace('ed.textConfig =','return ',1)).parse()
for sid in active:
    info=row('Skill',sid,0);key=info.get('Full Description') or info.get('Description')
    translated=translations.get(key,{}).get('nil',{}).get('en')
    skills[sid]['Description']=translated or translations.get(info.get('Description'),{}).get('nil',{}).get('en') or skills[sid]['Name']
    icon=Path(groups[sid]['Icon']);art=REF/'recovered/assets/install_time_pack/remake'
    if not (art/icon).is_file() and (art/icon.with_suffix('.jpg')).is_file():icon=icon.with_suffix('.jpg')
    if not (art/icon).is_file():raise FileNotFoundError(f'Missing skill icon: {icon}')
    skills[sid]['IconResource']=icon.as_posix()

# Import only buff dependencies used by active Evo/native hooks.
needed={e['BuffId'] for s in active for evo_ in skills[s]['Evolutions'] for e in evo_['TriggeredEffects'] if e.get('BuffId')}
needed.update((10003803,10002005))
existing={b['SourceId'] for b in docs['Buffs']['Buffs']}
scope={}
tree=ast.parse((ROOT/'scripts/Import-CrystalConfig.py').read_text())
for node in tree.body:
    if isinstance(node,ast.Assign) and any(isinstance(t,ast.Name) and t.id in ('MAP','SOURCE_STATS') for t in node.targets) or isinstance(node,ast.FunctionDef) and node.name=='direct':
        exec(compile(ast.Module(body=[node],type_ignores=[]),'<source-buff-conversion>','exec'),scope)
for k in scope['SOURCE_STATS']:scope['MAP'].setdefault(k,k.lower())
for bid in sorted(needed-existing):
    b=row('Buff',bid);stats=scope['direct'](b)
    docs['Buffs']['Buffs'].append(dict(Id='skill_evo_buff_'+str(bid),SourceId=bid,Name=b['Name'],Control=','.join(str(x) for x in (b['Control Effects'] or {}).values()),StackRule=str(b['Stack and Refresh'] or ''),Dispel=b['Dispel'] or '',Tenacity=b['Tenacity'],Effect=b['Effect'],ImpactEffect=b['Impact Effect'],Mod=b['MOD'],Duration=b['Time'],ShieldValue=b['Shield Value'],ShieldType=b['Shield Type'],ClearOnDeath=bool(b['Clear On Death ']),MaximumStacks=b['Max Stack Times'],Stats=[dict(StatId=k,Value=v) for k,v in stats.items()],Scaling=[dict(StatId=scope['MAP'][k],Attribute=scope['MAP'][b[k+'.x']],Ratio=b[k+'.a']) for k in scope['SOURCE_STATS'] if b.get(k+'.x')]))
docs['Skills']['SkillProgression']=dict(SkillLevelCap=80,GoldUpgradeCurve=[dict(FromLevel=r['FromLevel'],Gold=r['Gold']) for r in source['GoldUpgradeCurve']])
for name in ('Heroes','Skills','Buffs'):
    (DATA/(name+'.txt')).write_text(json.dumps(docs[name],ensure_ascii=False,indent=2)+'\n')
coverage=[dict(Hero=active[s],SkillId=skills[s]['Id'],SourceId=s,SourceHook=groups[s]['Caster Name']+'.lua',Milestones=[dict(Id=e['Id'],Level=e['RequiredSkillLevel'],Parameters=e['ParameterChanges'],Triggers=e['TriggeredEffects']) for e in skills[s]['Evolutions']]) for s in active]
(ROOT/'docs/reference/zatod-d35-evo-coverage.json').write_text(json.dumps(dict(Status='Mapped; runtime verification pending',ActiveSkills=coverage,LockedPurpleRows=75),ensure_ascii=False,indent=2)+'\n')
print(f'D35: {len(active)} active skills / 225 milestones; {len(needed-existing)} dependency buffs; roster and ranks preserved.')
