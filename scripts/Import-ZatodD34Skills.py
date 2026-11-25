"""Explicit D34 skill/Evo mapping. Only mutates an existing staging Data folder."""
from pathlib import Path
import argparse,importlib.util,json,re
ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('d34heroes',ROOT/'scripts/Import-ZatodD34Heroes.py')
base=importlib.util.module_from_spec(spec);spec.loader.exec_module(base)

def apply(data,source=None):
    if data.is_relative_to(ROOT/'Unity'):raise ValueError('Map and verify a staging folder before activation.')
    source=source or base.Source();docs={n:base.read(data/(n+'.txt')) for n in ('Heroes','Skills','Buffs','Stats')}
    skills={s['Crystal']['SourceId']:s for s in docs['Skills']['Skills'] if s.get('Crystal')}
    pending={int(c['SourceSkillId']) for c in base.read(ROOT/'docs/reference/zatod-d34-hero-import.json')['Coverage'] if not c['RuntimeEvoImported']}
    evos={sid:[source.row('SkillEvo',sid,n) for n in (1,2,3)] for sid in pending}
    for sid in pending:
        skill=skills[sid];skill['Crystal']['ExpandedRules']=True
        skill['Evolutions']=[dict(Id=skill['Id']+'_evo_'+str(n),RequiredSkillLevel=row['EvoSkill UnlockLevel'],Description='',ParameterChanges=[],TriggeredEffects=[]) for n,row in enumerate(evos[sid],1)]
    def arg(s,r,n=1):return evos[s][r-1]['Script Arg'+str(n)]
    def e(s,r):return skills[s]['Evolutions'][r-1]
    def p(s,r,field,value=None,mode=0,description=None,**extra):
        value=arg(s,r) if value is None else value
        e(s,r)['ParameterChanges'].append(dict(Field=field,Value=value,Mode=mode,**extra))
        e(s,r)['Description']=description or f'{field} {"increases by" if mode else "becomes"} {value:g}.'
    def trigger(s,r,kind=0,when=2,target=0,description='',**extra):
        e(s,r)['TriggeredEffects'].append(dict(Effect=kind,Trigger=when,Target=target,Duration=-1,Chance=100,**extra))
        e(s,r)['Description']=description
    def deferred(s,r,reason):e(s,r).update(Description='Primary-attribute mechanic deferred under D34: '+reason,DeferredReason=reason)
    def stat(s,r,name,sign=1):p(s,r,'BuffStat',arg(s,r)*sign,1,StatId=name)
    # Reviewed source lists. Unknown milestones have no coefficient fallback.
    ratios={50:[1,2,3],52:[1,2,3],110:[1,2,3],112:[2],113:[2,3],120:[2,3],122:[1,2],123:[1,2,3],132:[2,3],133:[1,2],140:[1,2],142:[1,2,3],150:[1,2],152:[1,2],153:[1,2],210:[1,2],212:[1,2,3],230:[2,3],232:[1,2,3],262:[1,2],263:[1,2],264:[1,2],310:[1,2,3],312:[1,2,3],313:[1,2],322:[1],323:[1,2],330:[1,2],333:[1,2],340:[1,2,3],342:[1,2],350:[1,2],352:[1,2,3],384:[1,2,3],390:[1,2,3],393:[1,2]}
    for sid,ranks in ratios.items():
        for rank in ranks:p(sid,rank,'PlusRatio')
    passive_add={14:[1,2,3],24:[1,2,3],44:[2,3],54:[2,3],64:[1,2,3],74:[1,2],84:[1,2,3],94:[1,2],104:[1,2],114:[1,2,3],124:[1,2,3],134:[1,2,3],144:[1,2,3],154:[1,2],164:[1,2,3],174:[1,2,3],184:[1,2,3],204:[1,2,3],214:[1,2],224:[1,2,3],234:[1,2],235:[1,2,3],244:[1,2,3],274:[1,2,3],284:[1,2,3],294:[1,2],304:[1,2,3],314:[1,2],324:[1,2],334:[1,2,3],344:[1,2],364:[1,2,3],394:[1,2,3],454:[1,2,3]}
    for sid,ranks in passive_add.items():
        for rank in ranks:p(sid,rank,'BasicAmount',mode=1)
    for sid in (254,354):
        for rank in ((1,2) if sid==254 else (1,2,3)):p(sid,rank,'BasicAmount',-arg(sid,rank),1)
    for rank in (1,2,3):p(34,rank,'ScriptArg2',mode=1);p(343,rank,'BuffStat',mode=1,StatId='health_regen')
    for sid in (130,260):
        for rank in (1,2,3):p(sid,rank,'BuffDurationBonus',mode=1)
    for sid in (122,133,140,150,152,153,262,322,333,393):p(sid,3,'BuffDuration')
    p(44,1,'HolyCurrentHealthPercent');p(44,1,'HolyCapAp',arg(44,1,2))
    p(74,3,'MaleDamageReduction')
    p(94,3,'RepeatMagicChance')
    p(104,3,'BasicCooldown',1.5);p(104,3,'BasicGlobalCooldown',1)
    p(112,1,'SingleStunDuration');p(112,3,'DoubleStunDuration')
    p(113,1,'ExtraPhysicalApRatio')
    p(120,1,'ThirdWaveBuff',10001203)
    trigger(132,1,BuffId=10001303,description='Successful Riptide hits apply the source armor-reduction buff.')
    p(53,1,'BuffStat',-arg(53,1),StatId='haste');p(53,2,'BuffStat',-arg(53,2),1,StatId='damage');p(53,3,'BuffStat',-arg(53,3),1,StatId='damage')
    p(54,1,'DamageTakenEnergyDrain')
    p(143,1,'MarkDamageRatio');stat(143,2,'defense',-1);p(143,3,'TargetArmorPercent')
    p(154,3,'DispelHealthStep',.15)
    for rank in (1,2):p(195,rank,'BasicAmount',mode=1)
    p(195,3,'RebirthInstant',1);p(195,3,'RebirthBuff',10001903)
    deferred(210,3,'No MainAttrib immunity rule while primary attributes remain omitted.')
    deferred(213,1,'INT transfer is omitted.');deferred(213,2,'INT transfer is omitted.')
    p(213,3,'ImprisonDamageAp');p(213,3,'ImprisonEnergy',arg(213,3,2))
    p(214,3,'BasicEnergyChance');p(214,3,'BasicEnergyAmount',arg(214,3,2))
    p(230,1,'UrsaCurrentHpRatio',arg(230,1)/100);p(230,1,'UrsaHpCap',arg(230,1,2))
    p(234,3,'BasicCooldown',1.8);p(234,3,'BasicGlobalCooldown',1.5)
    p(254,3,'EnergyPerEnemy');p(254,3,'EnergyEnemyCap',arg(254,3,2))
    p(263,3,'ScriptArg2',mode=1)
    deferred(264,3,'INT transfer is omitted; ordinary damage and first two evolutions remain active.')
    skills[210]['Description']='Deals magic damage (%Skill&Basic Num% + %Skill&Plus Ratio% * Magic Intensity) to enemies.'
    skills[213]['Description']='Banishes a random enemy for %Buff&Time%s. The target cannot act, be targeted or take damage during banishment. This skill is not cast when only one enemy remains.'
    p(294,3,'CounterStunChance',30);p(294,3,'CounterStunBuff',10002903)
    p(313,3,'PerfectBounce',1)
    p(314,3,'AuraBaseStatPercent')
    p(320,1,'FirstCastEnergy');trigger(320,2,when=3,target=1,BuffId=10003202,description='Cast completion grants the source defensive buff.')
    p(320,3,'SwapStunSkill',322)
    p(322,2,'NoDodge',1);stat(323,3,'defense',-1)
    p(324,3,'AllyDeathAttackReduction')
    p(330,3,'AttackFrameAllyEnergy')
    p(332,1,'BuffDuration');stat(332,2,'damage');stat(332,2,'ability_power')
    for name in ('haste','action_speed'):p(332,3,'BuffStat',StatId=name)
    p(342,3,'NoDodge',1)
    p(344,3,'MissingHealthHaste',arg(344,3)*100)
    trigger(350,2,BuffId=10003502,description='Successful ultimate hits apply the source evolution debuff.')
    p(350,3,'BounceDamageBase');p(350,3,'BounceDamageAp',arg(350,3,2))
    p(353,1,'BuffStat',mode=1,StatId='health_regen',ScalingAttribute='ability_power',ScalingRatio=arg(353,1,2))
    p(353,1,'ArmorRetaliationBuff',10003503)
    stat(353,2,'defense');stat(353,3,'defense')
    p(375,1,'BasicAmount',mode=1);p(375,2,'ScriptArg2',mode=1);p(375,3,'BasicGainEnergy',60)
    p(392,1,'BasicAmount',mode=1);p(392,2,'BasicAmount',mode=1)
    p(392,3,'AttackHealBase');p(392,3,'AttackHealAp',arg(392,3,2))
    # Structural fields represent native source behavior, never an additional owned skill.
    for sid in (34,195,375):skills[sid]['Crystal']['TriggerOnly']=True
    for sid in (212,264,313,342,384):skills[sid]['Crystal']['ReplacesBasic']=True
    skills[310]['Crystal']['AdditionalEffectResources']=['eff_point_Luna_moon.cha','eff_point_Luna_night.cha']
    for hero in docs['Heroes']['Heroes']:
        raw=source.row('Unit',hero['SourceUnitId']);hero['SourceGender']=raw['Gender']
        duration=source.table('AnimDuration')[1].get(hero['SourceResource']+'.cha',{}).get('Birth')
        hero['BirthSeconds']=base.named_row(source.table('AnimDuration'),duration)['Duration'] if duration else 0
        if hero['SourceUnitId'] in base.NEW_HEROES:skills[source.row('Unit',hero['SourceUnitId'])['Basic Skill']]['Crystal']['ExpandedRules']=True
        for slot in hero['SkillSlots']:
            info=skills[next(k for k,v in skills.items() if v['Id']==slot['SkillId'])]['Crystal']
            attr=info.get('PassiveAttribute')
            if info.get('ActiveType') in ('passive','aura','negative_aura') and attr in ('STR','AGI','INT'):
                is_aura=info['ActiveType']!='passive'
                info['PassiveStatRatios']=base.amounts(source.direct({attr:1},None if is_aura else raw['Main Attrib']))
                info['PassiveExtraDamageTargets']=[i for i,r in source.table('Unit')[1].items() if is_aura and source.row('Unit',i)['Main Attrib']==attr]
    needed={10000502,10001203,10001303,10001903,10001905,10002903,10003201,10003202,10003205,10003403,10003404,10003406,10003502,10003503}
    needed.update(x.get('BuffId') for sid in pending for evolution in skills[sid]['Evolutions'] for x in evolution['TriggeredEffects'] if x.get('BuffId'))
    existing={b['SourceId'] for b in docs['Buffs']['Buffs']}
    for bid in sorted(needed-existing):
        raw=source.row('Buff',bid)
        docs['Buffs']['Buffs'].append(dict(Id='d34_buff_'+str(bid),SourceId=bid,Name=source.english(raw['Name'],str(raw['Name'])),Control=','.join(str(v) for v in (raw['Control Effects'] or {}).values()),StackRule=str(raw['Stack and Refresh'] or ''),Dispel=raw['Dispel'] or '',Tenacity=raw['Tenacity'],Effect=raw['Effect'],ImpactEffect=raw['Impact Effect'],Mod=raw['MOD'],Duration=raw['Time'],ShieldValue=raw['Shield Value'],ShieldType=raw['Shield Type'],ClearOnDeath=bool(raw['Clear On Death ']),MaximumStacks=raw['Max Stack Times'],Stats=base.amounts(source.direct(raw)),Scaling=[dict(StatId=source.stat_map[k],Attribute=source.stat_map[raw[k+'.x']],Ratio=raw[k+'.a']) for k in source.source_stats if raw.get(k+'.x') in source.stat_map]))
    for sid in pending:
        for evolution in skills[sid]['Evolutions']:
            if not evolution.get('DeferredReason'):
                row=evos[sid][skills[sid]['Evolutions'].index(evolution)]
                description=source.english(row['Description'])
                if description:
                    description=re.sub(r'%Script Arg&([1-4])%',lambda m:f'{row["Script Arg"+m[1]]:g}',description)
                    description=re.sub(r'<#\d+#(.*?)#>',r'\1',description)
                    description=re.sub(r'</?lable[^>]*>','',description).replace('#p#','%').replace('\\n','\n')
                    evolution['Description']=description
            assert evolution['Description'] and (evolution['ParameterChanges'] or evolution['TriggeredEffects'] or evolution.get('DeferredReason')), (sid,evolution)
    base.complete_stats(docs)
    base.direct_passive_descriptions(docs)
    base.buff_presentation(docs,source)
    for n,doc in docs.items():base.write(data/(n+'.txt'),doc)
    print('Mapped',len(pending),'skills /',sum(len(skills[s]['Evolutions']) for s in pending),'milestones; explicit primary-attribute deferrals retained.')

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--data',type=Path,required=True);a=p.parse_args();apply(a.data.resolve())
