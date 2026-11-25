"""Explicit native mappings for encounter-only Hero skills, with open coverage recorded."""
import argparse,importlib.util,re
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('heroes',ROOT/'scripts/Import-ZatodD34Heroes.py');base=importlib.util.module_from_spec(spec);spec.loader.exec_module(base)
def apply(data,source=None):
    if data.is_relative_to(ROOT/'Unity'):raise ValueError('Verify a separate staging catalog before activation.')
    source=source or base.Source();docs={n:base.read(data/(n+'.txt')) for n in ('Heroes','Skills','Buffs','Stats')}
    skills={s['Crystal']['SourceId']:s for s in docs['Skills']['Skills']}
    monsters=base.read(data/'Monsters.txt')['Monsters']
    selected=(400,402,403,404,410,412,413,414,420,422,423,424,430,432,433,434,440,442,443,444,460,462,463,464,470,472,473,474,490,492,493,494,500,502,503,504,510,512,513,514,520,522,523,524,550,552,553,554,610,613,614,615,650,652,653,654,730,732,733,734,810,812,813,814,950,952,953,954)
    selected=selected+(680,682,683,684,1110,1112,1113,1114,1140,1142,1143,1144,1220,1222,1223,1224)
    selected=selected+(11100,11102,11103,11104)
    selected=selected+(1280,1282,1283,1284)
    selected=selected+(1430,1432,1433,1434)
    selected=selected+(1760,1762,1763,1764)
    selected=selected+(1490,1492,1493,1494)
    rows={sid:[source.row('SkillEvo',sid,n) for n in (1,2,3)] for sid in selected}
    for sid in selected:
        skill=skills[sid];skill['Crystal']['ExpandedRules']=True
        skill['Evolutions']=[dict(Id=skill['Id']+'_evo_'+str(n),RequiredSkillLevel=row['EvoSkill UnlockLevel'],Description=source.english(row['Description'],row['Description']),ParameterChanges=[],TriggeredEffects=[]) for n,row in enumerate(rows[sid],1)]
    def arg(s,r,n=1):return rows[s][r-1]['Script Arg'+str(n)]
    def p(s,r,field,value=None,mode=0,**extra):skills[s]['Evolutions'][r-1]['ParameterChanges'].append(dict(Field=field,Value=arg(s,r) if value is None else value,Mode=mode,**extra))
    for sid,ranks in {400:(1,2),402:(1,2,3),412:(1,2,3),413:(1,2,3),422:(1,2),460:(2,3),462:(1,3),493:(1,2),500:(1,2),502:(2,3)}.items():
        for rank in ranks:p(sid,rank,'PlusRatio')
    for sid in (404,414,424,463,464,494,504):
        for rank in (1,2,3):p(sid,rank,'BasicAmount',mode=1)
    p(400,3,'GhostLeechRatio',.3);p(400,3,'GhostEndHealRatio',.4)
    p(403,1,'BuffDuration');p(403,2,'BuffDuration');p(403,3,'BuffStat',-arg(403,3),StatId='magic_resistance')
    p(410,1,'BuffDuration')
    for stat in ('haste','action_speed'):p(410,2,'BuffStat',mode=1,StatId=stat)
    p(410,3,'UndeadWhileUlt',1)
    for rank in (1,2,3):p(420,rank,'ShieldBonus',mode=1)
    p(422,3,'EnemyHealDamageRatio',3)
    for rank in (1,2):p(423,rank,'ShieldBonus',mode=1)
    skills[423]['Evolutions'][2]['TriggeredEffects'].append(dict(Effect=2,Trigger=2,Target=0,Duration=-1,Chance=100))
    for rank in (1,2):
        for stat in ('physical_immunity','magic_immunity'):p(490,rank,'BuffStat',mode=1,StatId=stat)
    p(490,3,'BuffStat',mode=0,StatId='health_regen',ScalingAttribute='health',ScalingRatio=arg(490,3,2)/100)
    for rank in (1,2):p(492,rank,'BuffStat',-arg(492,rank),1,StatId='defense')
    p(492,3,'BuffDuration');p(493,3,'BristleDamageStep',arg(493,3)/100)
    p(460,1,'ManaVoidScaling',1)
    p(462,2,'BlinkShieldBase');p(462,2,'BlinkShieldAttackRatio',arg(462,2,2));p(462,3,'ExtraManaBurn',arg(462,3,2))
    p(500,3,'MaximumHealthDamageRatio',arg(500,3)/100);p(500,3,'MaximumHealthDamageCap',arg(500,3,2))
    p(502,1,'BuffDuration')
    for rank in (1,2,3):p(503,rank,'ShieldBonus',mode=1)
    p(430,1,'PlusRatio');p(430,2,'InfernalGuard',1);p(430,3,'BuffDuration')
    p(432,1,'EnemyDotBonus');p(432,2,'BuffStat',mode=1,StatId='health_regen');p(432,3,'EnemyHealingReduction')
    for rank in (1,2,3):
        p(433,rank,'InfernalAttackRatio')
        skills[434]['Evolutions'][rank-1]['SourceNote']='Recovered WL hook tests Infernal_atk3.evo_rank, but group10036 has no SkillEvo rows and parent434 Evo is not forwarded; retain the observed inert source milestone.'
    for sid,ranks in {440:(1,2),442:(1,2),443:(1,3),510:(1,2,3)}.items():
        for rank in ranks:p(sid,rank,'PlusRatio')
    p(440,3,'PandaHolyAttackRatio');p(442,3,'BuffDuration');p(443,2,'BuffDuration')
    p(444,1,'CycloneIntervalReduction');p(444,2,'MistDefenseSkill',446);p(444,3,'CycloneLandingBuff',10004406)
    skills[444]['Crystal']['TriggerOnly']=True
    p(512,1,'RefractionEnergyBonus');p(512,2,'RefractionCharges');p(512,2,'RefractionMaximum',arg(512,2,2));p(512,3,'RefractionEntryAndKill',1)
    p(513,1,'BuffDuration');p(513,2,'BuffStat',-arg(513,2),1,StatId='health_regen');p(513,3,'BuffDuration')
    p(514,1,'BladeSplashBonus',mode=1);p(514,2,'BladeSplashHoly',1);p(514,3,'BladeSplashBonus',mode=1)
    skills[514]['Crystal']['ReplacesBasic']=True
    for sid in (550,552,553,950):
        for rank in (1,2,3):p(sid,rank,'PlusRatio')
    for rank in (1,2):p(554,rank,'BuffStat',-arg(554,rank),1,StatId='health_regen')
    for stat in ('physical_immunity','magic_immunity'):p(554,3,'BuffStat',-arg(554,3),1,StatId=stat)
    for rank in (1,2,3):p(952,rank,'FinalHitAttackRatio')
    for rank in (1,2):p(953,rank,'PlusRatio');p(954,rank,'BasicAmount',mode=1)
    p(953,3,'BuffStat',-arg(953,3),1,StatId='defense');p(954,3,'ScriptArg2',mode=1)
    skills[954]['Crystal']['TriggerOnly']=True
    # D05/D34 omit primary-attribute mechanics; never convert dynamic AGI/STR
    # comparisons to AP. The independent HP-scaled passive remains active.
    skills[950]['Crystal']['TargetType']=skills[953]['Crystal']['TargetType']='nearest'
    for rank in (1,3):p(610,rank,'BuffStat',mode=1,StatId='damage')
    p(610,2,'PhantomGuardBuff',10006104)
    for rank in (1,2,3):p(613,rank,'PlusRatio');p(615,rank,'BasicAmount',mode=1)
    for rank in (1,2):p(614,rank,'BuffStat',mode=1,StatId='dodge')
    p(614,3,'DodgeEnergyBonus')
    for sid in (520,523):
        for rank in (1,2,3):p(sid,rank,'PlusRatio')
    for rank in (1,2):p(522,rank,'BuffStat',mode=1,StatId='ability_power');p(524,rank,'PhoenixRebirthHealth',mode=1)
    p(522,3,'PhoenixBasicRatio',1);p(524,3,'PhoenixEggHitBonus',1)
    skills[524]['Crystal']['TriggerOnly']=True
    for rank in (1,2):p(650,rank,'BuffStat',-arg(650,rank),1,StatId='health_regen')
    p(650,3,'DoomEnergyDrain')
    for rank in (1,3):p(652,rank,'PlusRatio')
    p(652,2,'BuffStat',-arg(652,2),1,StatId='health_regen')
    for rank in (1,2):p(653,rank,'PlusRatio')
    p(653,3,'OutnumberedRatio',2);p(654,1,'DevourDamageBonus')
    for rank in (2,3):p(654,rank,'GainEnergy')
    skills[654]['Crystal']['TargetType']='random'
    for sid in (460,461,462):skills[sid]['Crystal']['TargetType']='nearest'
    for sid in (460,462,1110,1113,1142):
        skills[sid]['Description']=re.sub(r'(?:the )?(?:enemy|enemies) with (?:the )?(?:highest|lowest)\s*<lable color=(?:int|agi|str)>[^<]+</lable>', 'a nearby enemy',skills[sid]['Description'],flags=re.I)
    for rank in (1,2,3):p(730,rank,'PlusRatio');p(734,rank,'BasicAmount',mode=1)
    p(730,3,'HookGuard',1);p(732,1,'BuffStat',StatId='magic_immunity');p(732,2,'RotNoSelfDamage',1)
    p(732,3,'RotCurrentHealthRatio',arg(732,3)/100);p(732,3,'RotCurrentHealthCap',arg(732,3,2))
    p(733,1,'PlusRatio');p(733,2,'BiteGuard',1);p(733,3,'BiteAfterHook',1)
    p(680,1,'PlusRatio');p(680,2,'DuelFinisherRatio');p(680,3,'DuelNoDodge',1)
    for rank in (1,2,3):p(682,rank,'PlusRatio')
    for rank in (1,2):p(683,rank,'BuffStat',mode=1,StatId='health_regen');p(684,rank,'ChargeDamageBonus',mode=1)
    for stat in ('haste','action_speed'):p(683,3,'BuffStat',StatId=stat)
    p(684,3,'BuffDuration')
    for rank in (1,2):p(1110,rank,'TuskPunchRatio');p(1114,rank,'TuskChargeReduction',mode=1)
    p(1110,3,'TuskPunchGuard',1)
    for rank in (1,2,3):p(1112,rank,'TuskLastShotRatio');p(1113,rank,'PlusRatio')
    p(1114,3,'TuskChargedPenetration');skills[1114]['Crystal']['TriggerOnly']=True
    for rank in (1,2,3):p(1140,rank,'PlusRatio');p(1143,rank,'MissileRatio')
    for rank in (1,3):p(1142,rank,'PlusRatio')
    p(1142,2,'BlinkSplashStun',1);p(1144,1,'OverheatReductionBonus');p(1144,2,'OverheatReflectBase');p(1144,2,'OverheatReflectRatio',arg(1144,2,2));p(1144,3,'HeatReductionBonus')
    skills[1144]['Crystal']['TriggerOnly']=True;skills[1142]['Crystal']['TargetType']='nearest'
    for rank in (1,2):
        for stat in ('defense','magic_resistance'):p(1220,rank,'BuffStat',mode=1,StatId=stat)
    p(1220,3,'UndyingEnergyDrain')
    for rank in (1,2,3):p(1222,rank,'TombstoneInterval');p(1223,rank,'PlusRatio')
    p(1224,1,'ZombieDeathHealth');p(1224,2,'ZombieDeathEnergy');p(1224,3,'ZombieArmorBuff',11002205);skills[1224]['Crystal']['TriggerOnly']=True
    for rank in (1,2,3):p(11100,rank,'PlusRatio')
    for rank in (1,2):p(11102,rank,'PlusRatio');p(11103,rank,'MarsParryBonus',mode=1)
    p(11102,3,'MarsNoDodge',1);p(11103,3,'MarsParryThreshold',arg(11103,3)/100);skills[11103]['Crystal']['TriggerOnly']=True
    p(11104,1,'BuffDurationBonus');p(11104,2,'MarsTauntAttack');p(11104,3,'MarsTauntGuard',1)
    p(1280,1,'MonkWeakDamageBonus');p(1280,2,'MonkUltimateGuard',1);p(1280,3,'MonkUltimateDebuff',11002815)
    for rank in (1,2,3):p(1282,rank,'MonkSplashRatio');p(1283,rank,'PlusRatio');p(1283,rank,'MonkPushRatio',arg(1283,rank,2))
    p(1283,3,'MonkPushNoDodge',1);p(1284,1,'MonkQiAttack');p(1284,2,'MonkQiInterval');p(1284,3,'MonkQiInterval');skills[1284]['Crystal']['TriggerOnly']=True
    for rank in (1,2):
        p(1430,rank,'PlusRatio');p(1434,rank,'PlusRatio')
        for sid in (1432,1433):
            for stat in ('defense','magic_resistance'):p(sid,rank,'BuffStat',mode=1,StatId=stat)
    p(1430,3,'BuffDuration');p(1432,3,'DancerTeamSlow',1);p(1434,3,'DancerComboGuard',1)
    for stat in ('damage','ability_power'):p(1433,3,'BuffStat',StatId=stat)
    p(1760,1,'PlusRatio');p(1760,2,'DruidSleepDefenseRatio',arg(1760,2)/100);p(1760,3,'DruidBearUltimateBuff',11007613)
    for rank in (1,2):p(1762,rank,'BearInheritBonus',arg(1762,rank)/100,1);p(1764,rank,'PlusRatio')
    p(1762,3,'BearRecoveryRatio',.1);p(1763,1,'BearDamageGrowthRatio',.035);p(1763,2,'BearDamageGrowthRatio',.04);p(1763,3,'BearFearAttackReduction')
    skills[1763]['Crystal']['TriggerOnly']=True;p(1764,3,'BuffStat',-arg(1764,3),1,StatId='health_regen')
    for rank in (1,2):p(1490,rank,'PlusRatio');p(1492,rank,'SpiderPowerRatio');p(1493,rank,'PlusRatio');p(1494,rank,'PlusRatio')
    p(1490,3,'NestSummonWeight');p(1492,3,'SpiderCostReduction');p(1492,3,'SpiderSilence',1);skills[1492]['Crystal']['TriggerOnly']=True
    p(1493,3,'BuffDuration');p(1494,3,'BroodMarkedRatio')
    skills[1762]['Crystal']['Summon']=dict(Enabled=True,MonsterId=next(m['Id'] for m in monsters if m['SourceUnitId']==266),Count=1,DurationSeconds=120,HealthMultiplier=1,DamageMultiplier=1,
        InheritLevelAndStars=True,UseSkillLevel=True,Persistent=True,IncludeSkills=True)
    for sid,monster,persistent in ((1490,249,True),(1492,250,False)):
        skills[sid]['Crystal']['Summon']=dict(Enabled=True,MonsterId=next(m['Id'] for m in monsters if m['SourceUnitId']==monster),Count=1,DurationSeconds=15,HealthMultiplier=1,DamageMultiplier=1,
            InheritLevelAndStars=True,UseSkillLevel=True,Persistent=persistent,IncludeSkills=True,StackOnRecast=not persistent)
    skills[1222]['Crystal']['Summon']=dict(Enabled=True,MonsterId=next(m['Id'] for m in monsters if m['SourceUnitId']==214),
        AlternateMonsterId=next(m['Id'] for m in monsters if m['SourceUnitId']==215),Count=1,DurationSeconds=15,HealthMultiplier=1,DamageMultiplier=1,
        InheritLevelAndStars=True,UseSkillLevel=True,StarsOverride=1,HpMultiplierOverride=1,StackOnRecast=True,Persistent=True,IncludeSkills=True)
    for sid in (1110,1113):
        skills[sid]['Crystal']['TargetType']='nearest'
        skills[sid]['Description']=re.sub('highest AGI|highest Agility','nearby',skills[sid]['Description'])
    skills[654]['Description']='Devours a summoned enemy, dealing %Skill&Script Arg2% Holy damage and gaining %Skill&Gain MP% Energy.'
    skills[950]['Description']='Blinks to a nearby enemy and deals physical damage (%Skill&Basic Num% + %Skill&Plus Ratio% * Physical ATK).'
    skills[953]['Description']='Blinks to a nearby enemy, deals physical damage (%Skill&Basic Num% + %Skill&Plus Ratio% * Physical ATK) and reduces Armor.'
    p(470,1,'BuffStat',StatId='lifesteal');p(470,2,'MirrorConvertOnTransform',1);p(470,3,'DemonFearBuff',10004705)
    for rank in (1,2):p(472,rank,'ScriptArg3',mode=1);p(473,rank,'SunderMaximumBonus',mode=1)
    p(472,3,'SummonCount',2);p(473,3,'SunderMinimumBonus')
    for rank in (1,2,3):p(474,rank,'BasicAmount',mode=1)
    monsters=base.read(data/'Monsters.txt')['Monsters']
    skills[472]['Crystal']['Summon']=dict(Enabled=True,MonsterId=next(m['Id'] for m in monsters if m['SourceUnitId']==129),
        AlternateMonsterId=next(m['Id'] for m in monsters if m['SourceUnitId']==130),Count=1,DurationSeconds=15,HealthMultiplier=1,DamageMultiplier=1,
        InheritLevelAndStars=True,UseSkillLevel=True,StackOnRecast=True)
    for sid,resources in {400:['eff_buff_DP_ult.cha'],423:['eff_point_DR_atk3.cha','eff_impact_LOA_atk2.cha'],
        440:['eff_point_Panda_ult.cha'],444:['eff_point_DOTsr_atk2'],522:['eff_tile_Phoenix_atk2.cha','eff_point_burst.cha'],650:['eff_point_DOOM_ult.cha'],
        812:['eff_point_Luna_night.cha','eff_point_LYC_atk2_1.cha'],
        470:['eff_point_TB_ult.cha','eff_impact_TB_atk.cha','eff_point_TB_ult3.cha'],
        1490:['eff_point_BR_ult_2.cha'],1494:['eff_point_BR_atk4.cha'],1760:['eff_point_TitanDruid_ult.cha'],1432:['eff_point_Luna_night.cha'],1433:['eff_point_Dancer_atk3b.cha'],
        1224:['eff_point_UD_atk4.cha'],11103:['eff_impact_TitanMars_atk3.cha'],11104:['eff_impact_TitanMars_atk4.cha'],11100:['eff_buff_TitanMars_ult.cha'],680:['eff_point_LC_ult1.cha','eff_point_LC_ult2.cha','eff_point_LC_atk2_2.cha'],
        1144:['eff_buff_CG_heat_1.cha','eff_buff_CG_heat_2.cha','eff_buff_CG_heat_3.cha'],1143:['eff_point_CG_atk3.cha','eff_point_burst.cha'],
        473:['eff_tile_TB_atk3.cha','eff_tile_TB_atk3_2.cha','eff_impact_TB_atk3.cha','eff_impact_TB_atk3_2.cha','eff_impact_TB_atk3_3.cha','eff_impact_TB_atk3_4.cha']}.items():
        skills[sid]['Crystal']['AdditionalEffectResources']=resources
    def native_form(sid,owner,group,period,puppet_name=None,active_skills=None,attach=True):
        form=source.row('Period',group,period) if group else {'Puppet ID':puppet_name,'Basic Skill':source.row('Unit',owner)['Basic Skill'],'Skill List':dict(enumerate(active_skills))}
        puppet=source.row('Puppet',form['Puppet ID']);unit=dict(source.row('Unit',owner),Puppet=form['Puppet ID'])
        art=base.puppet_art(puppet)
        actions=[dict(Action=k[7:],Target=v) for k,v in puppet.items() if k.startswith('Action ') and v]
        def duration(action):
            mapped=puppet.get('Action '+action) or action
            row=source.table('AnimDuration')[1].get(puppet['Resource']+'.cha',{}).get(mapped)
            return base.named_row(source.table('AnimDuration'),row)['Duration'] if row else 0
        definition=dict(Enabled=True,**art,AnimationSetResource='Zatod/'+art['Resource']+'/AnimationSet',
            ArtScale=puppet['Scale'],BasicSourceId=form['Basic Skill'],ActiveSkillSourceIds=[int(i) for i in form['Skill List'].values() if int(i) in skills],
            ActionRemaps=actions,DeathSeconds=duration('Death'),HurtSeconds=duration('Damaged'),
            SkillPhases=[dict(SourceId=int(i),Phases=source.phases(unit,source.row('Skill',int(i),0))) for i in form['Skill List'].values() if int(i) in skills])
        if attach:skills[sid]['Crystal']['NativeForm']=definition
        for dependent in definition['ActiveSkillSourceIds']:
            if skills[dependent]['Crystal']['LevelSourceId']:
                skills[dependent]['Crystal']['Phases']=source.phases(unit,source.row('Skill',dependent,0))
        return definition
    native_form(610,61,14,2);native_form(810,81,23,2);native_form(470,47,None,None,'TBult.cha',[471,472,473,474]);native_form(1220,10022,35,2)
    skills[1762]['Crystal']['Summon']['Forms']=[native_form(1762,266,57,stage,attach=False) for stage in range(1,6)]
    for sid in (1767,26601,26602,26603,26604,26605):skills[sid]['Crystal']['ExpandedRules']=True
    skills[26602]['Crystal']['TriggerOnly']=True
    for stat in ('haste','action_speed'):p(810,1,'BuffStat',mode=1,StatId=stat,BuffId=10008101)
    p(810,2,'WolfEnergyAttack');p(810,3,'WolfEnergyDrain')
    for rank in (1,2,3):
        p(812,rank,'BuffStat',mode=1,StatId='physical_crit');p(812,rank,'WolfShotRatio',arg(812,rank,2))
        p(813,rank,'PlusRatio');p(813,rank,'WolfRushRatio',arg(813,rank,2));p(814,rank,'WolfFinisherRatio')
    infernal=next(m for m in base.read(data/'Monsters.txt')['Monsters'] if m['SourceUnitId']==128)
    skills[430]['Crystal']['Summon']=dict(Enabled=True,MonsterId=infernal['Id'],Count=1,DurationSeconds=8,HealthMultiplier=1,DamageMultiplier=1,
        IncludeSkills=True,InheritLevelAndStars=True,Persistent=True,ReplaceExisting=True,AtImpact=True)
    for sid in selected:
        for rank,evo in enumerate(skills[sid]['Evolutions'],1):
            evo['Description']=re.sub(r'%Script Arg&([1-4])%',lambda m:f'{arg(sid,rank,int(m[1])):g}',evo['Description'])
            evo['Description']=re.sub(r'<#\d+#(.*?)#>',r'\1',evo['Description'])
            evo['Description']=re.sub(r'</?lable[^>]*>','',evo['Description']).replace('#p#','%').replace('\\n','\n')
            assert evo['ParameterChanges'] or evo['TriggeredEffects'] or evo.get('SourceNote'),(sid,rank)
    base.complete_stats(docs)
    base.direct_passive_descriptions(docs)
    base.buff_presentation(docs,source)
    for n,doc in docs.items():base.write(data/(n+'.txt'),doc)
    base.write(data.parent/(data.name+'-encounter-native.json'),dict(MappedSkills=list(selected),MappedMilestones=len(selected)*3,MappingComplete=True,AcceptanceComplete=False,
        PrimaryAttributeDeferrals=['Nana950 dynamic AGI-difference damage and950/953 minimum-STR target selection omitted under D05/D34; ordinary nearest target retained.',
            'AM460/461/462 maximum-INT targeting and UD zombie maximum-INT AI omitted under D05/D34; ordinary nearest enemy retained.',
            'Tusk1110/1113 maximum-AGI target selection omitted under D05/D34; ordinary nearest target retained.',
            'CG1142 minimum-STR target selection omitted under D05/D34; ordinary nearest target retained.',
            'DOOM654 post-devour buff selection by the summoned target MainAttrib omitted under D05/D34; Holy damage and energy gain remain active.'],
        Pending='Unity, TCP, replay and full farm acceptance before runtime activation'))
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--data',type=Path,required=True);a=p.parse_args();apply(a.data.resolve())
