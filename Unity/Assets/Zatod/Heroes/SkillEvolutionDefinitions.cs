using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace Zatod.Heroes
{
    public enum SkillParameterMode { Replace, Add }
    public enum SkillEvolutionEvent { CastStart, AttackFrame, Hit, CastFinish, BuffRemoved, BuffExpired, PhysicalDamageReceived, FirstLethalDamage }
    public enum SkillEvolutionTarget { Target, Caster, LivingAllies, LivingEnemiesAroundCaster }
    public enum SkillEvolutionEffect { Buff, EnergySteal, DispelDebuffs, DependentSkill, BasicAttack, OverhealShield, CollectMagicHits, ResetCooldown }

    [Serializable] public sealed class SkillParameterChange
    {
        // Field is restricted to the names validated below, not an arbitrary script expression.
        public string Field, Text, StatId, ScalingAttribute;
        public SkillParameterMode Mode;
        public double Value, ScalingRatio;
        public int BuffId;
        public SkillParameterChange Copy()=>(SkillParameterChange)MemberwiseClone();
    }
    [Serializable] public sealed class SkillTriggeredEffect
    {
        public SkillEvolutionEvent Trigger;
        public SkillEvolutionTarget Target;
        public SkillEvolutionEffect Effect;
        public int BuffId;
        public string SkillId;
        public double Amount, Ratio, Maximum, Radius, Duration=-1, Chance=100;
        public bool ScaleByEnemyCount, UseSkillPower;
        public SkillTriggeredEffect Copy()=>(SkillTriggeredEffect)MemberwiseClone();
    }
    [Serializable] public sealed class SkillEvolutionDefinition
    {
        public string Id, Description, DeferredReason, SourceNote;
        public int RequiredSkillLevel;
        public List<SkillParameterChange> ParameterChanges=new List<SkillParameterChange>();
        public List<SkillTriggeredEffect> TriggeredEffects=new List<SkillTriggeredEffect>();
        public SkillEvolutionDefinition Copy()=>new SkillEvolutionDefinition{Id=Id,Description=Description,DeferredReason=DeferredReason,SourceNote=SourceNote,RequiredSkillLevel=RequiredSkillLevel,ParameterChanges=ParameterChanges.ConvertAll(x=>x.Copy()),TriggeredEffects=TriggeredEffects.ConvertAll(x=>x.Copy())};
    }
    public static class SkillEvolution
    {
        static readonly HashSet<string> Numeric=new HashSet<string>(new[]{"BasicAmount","PlusRatio","Cooldown","InitialCooldown","GlobalCooldown","ShapeArg1","ShapeArg2","KnockBack","KnockUp","GainEnergy","CritPercent","ChainJumps","ScriptArg1","ScriptArg2","ScriptArg3","ScriptArg4","ScriptArg5","ScriptArg6"},StringComparer.Ordinal);
        static readonly HashSet<string> Runtime=new HashSet<string>(new[]{"BuffDuration","BuffDurationBonus","BuffStat","ShieldBonus","SlowCap","ExtraVolleyProjectiles","KillEnergy","DotHealPercent","DistanceDamageCap","ExecuteDamageRatio","RepeatHitRatio","RepeatHitMaximum","MagicHitRatio","MagicHitMaximum","SplitRatioBonus","SplitTargets","MulticastFourChance","MissingHealthRatio","CounterChance","CounterCooldown","CounterHealPercent"},StringComparer.Ordinal);
        static readonly HashSet<string> ExpandedParameters=new HashSet<string>(new[]{"HolyCurrentHealthPercent","HolyCapAp","MaleDamageReduction","RepeatMagicChance","BasicCooldown","BasicGlobalCooldown","SingleStunDuration","DoubleStunDuration","ExtraPhysicalApRatio","ThirdWaveBuff","DamageTakenEnergyDrain","MarkDamageRatio","TargetArmorPercent","DispelHealthStep","RebirthInstant","RebirthBuff","ImprisonDamageAp","ImprisonEnergy","BasicEnergyChance","BasicEnergyAmount","UrsaCurrentHpRatio","UrsaHpCap","EnergyPerEnemy","EnergyEnemyCap","CounterStunChance","CounterStunBuff","PerfectBounce","AuraBaseStatPercent","FirstCastEnergy","SwapStunSkill","NoDodge","AllyDeathAttackReduction","AttackFrameAllyEnergy","MissingHealthHaste","BounceDamageBase","BounceDamageAp","ArmorRetaliationBuff","BasicGainEnergy","AttackHealBase","AttackHealAp","GhostLeechRatio","GhostEndHealRatio","UndeadWhileUlt","EnemyHealDamageRatio","BristleDamageStep","ManaVoidScaling","BlinkShieldBase","BlinkShieldAttackRatio","ExtraManaBurn","MaximumHealthDamageRatio","MaximumHealthDamageCap","InfernalGuard","EnemyDotBonus","EnemyHealingReduction","InfernalAttackRatio","PandaHolyAttackRatio","CycloneIntervalReduction","MistDefenseSkill","CycloneLandingBuff","RefractionEnergyBonus","RefractionCharges","RefractionMaximum","RefractionEntryAndKill","BladeSplashBonus","BladeSplashHoly","FinalHitAttackRatio","PhantomGuardBuff","DodgeEnergyBonus","PhoenixRebirthHealth","PhoenixBasicRatio","PhoenixEggHitBonus","DoomEnergyDrain","OutnumberedRatio","DevourDamageBonus","WolfEnergyAttack","WolfEnergyDrain","WolfShotRatio","WolfRushRatio","WolfFinisherRatio","MirrorConvertOnTransform","DemonFearBuff","SunderMaximumBonus","SunderMinimumBonus","HookGuard","RotNoSelfDamage","RotCurrentHealthRatio","RotCurrentHealthCap","BiteGuard","BiteAfterHook","DuelFinisherRatio","DuelNoDodge","ChargeDamageBonus","TuskPunchRatio","TuskChargeReduction","TuskPunchGuard","TuskLastShotRatio","TuskChargedPenetration","MissileRatio","BlinkSplashStun","OverheatReductionBonus","OverheatReflectBase","OverheatReflectRatio","HeatReductionBonus","UndyingEnergyDrain","TombstoneInterval","ZombieDeathHealth","ZombieDeathEnergy","ZombieArmorBuff","MarsParryBonus","MarsParryThreshold","MarsNoDodge","MarsTauntAttack","MarsTauntGuard","MonkWeakDamageBonus","MonkUltimateGuard","MonkUltimateDebuff","MonkSplashRatio","MonkPushRatio","MonkPushNoDodge","MonkQiAttack","MonkQiInterval","DancerTeamSlow","DancerComboGuard","DruidSleepDefenseRatio","DruidBearUltimateBuff","BearInheritBonus","BearRecoveryRatio","BearDamageGrowthRatio","BearFearAttackReduction","SpiderPowerRatio","NestSummonWeight","SpiderCostReduction","SpiderSilence","BroodMarkedRatio"},StringComparer.Ordinal);
        static readonly Dictionary<string,string[]> TextFields=new Dictionary<string,string[]>(StringComparer.Ordinal){["AoeOrigin"]=new[]{"self","target"},["AoeShape"]=new[]{"circle","rectangle","halfcircle","quartercircle"},["DamageType"]=new[]{"AD","AP","Holy","Heal"}};
        static readonly Dictionary<string,int[]> NativeParameters=new Dictionary<string,int[]>(StringComparer.Ordinal)
        {
            ["HolyCurrentHealthPercent"]=new[]{44},
            ["HolyCapAp"]=new[]{44},
            ["MaleDamageReduction"]=new[]{74},
            ["RepeatMagicChance"]=new[]{94},
            ["BasicCooldown"]=new[]{104,234},
            ["BasicGlobalCooldown"]=new[]{104,234},
            ["SingleStunDuration"]=new[]{112},
            ["DoubleStunDuration"]=new[]{112},
            ["ExtraPhysicalApRatio"]=new[]{113},
            ["ThirdWaveBuff"]=new[]{120},
            ["DamageTakenEnergyDrain"]=new[]{54},
            ["MarkDamageRatio"]=new[]{143},
            ["TargetArmorPercent"]=new[]{143},
            ["DispelHealthStep"]=new[]{154},
            ["RebirthInstant"]=new[]{195},
            ["RebirthBuff"]=new[]{195},
            ["ImprisonDamageAp"]=new[]{213},
            ["ImprisonEnergy"]=new[]{213},
            ["BasicEnergyChance"]=new[]{214},
            ["BasicEnergyAmount"]=new[]{214},
            ["UrsaCurrentHpRatio"]=new[]{230},
            ["UrsaHpCap"]=new[]{230},
            ["EnergyPerEnemy"]=new[]{254},
            ["EnergyEnemyCap"]=new[]{254},
            ["CounterStunChance"]=new[]{294},
            ["CounterStunBuff"]=new[]{294},
            ["PerfectBounce"]=new[]{313},
            ["AuraBaseStatPercent"]=new[]{314},
            ["FirstCastEnergy"]=new[]{320},
            ["SwapStunSkill"]=new[]{320},
            ["NoDodge"]=new[]{322,342},
            ["AllyDeathAttackReduction"]=new[]{324},
            ["AttackFrameAllyEnergy"]=new[]{330},
            ["MissingHealthHaste"]=new[]{344},
            ["BounceDamageBase"]=new[]{350},
            ["BounceDamageAp"]=new[]{350},
            ["ArmorRetaliationBuff"]=new[]{353},
            ["BasicGainEnergy"]=new[]{375},
            ["AttackHealBase"]=new[]{392},
            ["AttackHealAp"]=new[]{392},
            ["GhostLeechRatio"]=new[]{400},
            ["GhostEndHealRatio"]=new[]{400},
            ["UndeadWhileUlt"]=new[]{410},
            ["EnemyHealDamageRatio"]=new[]{422},
            ["BristleDamageStep"]=new[]{493},
            ["ManaVoidScaling"]=new[]{460},
            ["BlinkShieldBase"]=new[]{462},
            ["BlinkShieldAttackRatio"]=new[]{462},
            ["ExtraManaBurn"]=new[]{462},
            ["MaximumHealthDamageRatio"]=new[]{500},
            ["MaximumHealthDamageCap"]=new[]{500},
            ["InfernalGuard"]=new[]{430},["EnemyDotBonus"]=new[]{432},["EnemyHealingReduction"]=new[]{432},["InfernalAttackRatio"]=new[]{433},
            ["PandaHolyAttackRatio"]=new[]{440},
            ["CycloneIntervalReduction"]=new[]{444},
            ["MistDefenseSkill"]=new[]{444},
            ["CycloneLandingBuff"]=new[]{444},
            ["RefractionEnergyBonus"]=new[]{512},
            ["RefractionCharges"]=new[]{512},
            ["RefractionMaximum"]=new[]{512},
            ["RefractionEntryAndKill"]=new[]{512},
            ["BladeSplashBonus"]=new[]{514},
            ["BladeSplashHoly"]=new[]{514},
            ["MirrorConvertOnTransform"]=new[]{470},["DemonFearBuff"]=new[]{470},["SunderMaximumBonus"]=new[]{473},["SunderMinimumBonus"]=new[]{473},
            ["SpiderPowerRatio"]=new[]{1492},["NestSummonWeight"]=new[]{1490},["SpiderCostReduction"]=new[]{1492},["SpiderSilence"]=new[]{1492},["BroodMarkedRatio"]=new[]{1494},
            ["DruidSleepDefenseRatio"]=new[]{1760},["DruidBearUltimateBuff"]=new[]{1760},["BearInheritBonus"]=new[]{1762},["BearRecoveryRatio"]=new[]{1762},["BearDamageGrowthRatio"]=new[]{1763},["BearFearAttackReduction"]=new[]{1763},
            ["DancerTeamSlow"]=new[]{1432},["DancerComboGuard"]=new[]{1434},
            ["MonkWeakDamageBonus"]=new[]{1280},["MonkUltimateGuard"]=new[]{1280},["MonkUltimateDebuff"]=new[]{1280},["MonkSplashRatio"]=new[]{1282},["MonkPushRatio"]=new[]{1283},["MonkPushNoDodge"]=new[]{1283},["MonkQiAttack"]=new[]{1284},["MonkQiInterval"]=new[]{1284},
            ["MarsParryBonus"]=new[]{11103},["MarsParryThreshold"]=new[]{11103},["MarsNoDodge"]=new[]{11102},["MarsTauntAttack"]=new[]{11104},["MarsTauntGuard"]=new[]{11104},
            ["UndyingEnergyDrain"]=new[]{1220},["TombstoneInterval"]=new[]{1222},["ZombieDeathHealth"]=new[]{1224},["ZombieDeathEnergy"]=new[]{1224},["ZombieArmorBuff"]=new[]{1224},
            ["MissileRatio"]=new[]{1143},["BlinkSplashStun"]=new[]{1142},["OverheatReductionBonus"]=new[]{1144},["OverheatReflectBase"]=new[]{1144},["OverheatReflectRatio"]=new[]{1144},["HeatReductionBonus"]=new[]{1144},
            ["TuskPunchRatio"]=new[]{1110},["TuskChargeReduction"]=new[]{1114},["TuskPunchGuard"]=new[]{1110},["TuskLastShotRatio"]=new[]{1112},["TuskChargedPenetration"]=new[]{1114},
            ["DuelFinisherRatio"]=new[]{680},["DuelNoDodge"]=new[]{680},["ChargeDamageBonus"]=new[]{684},
            ["HookGuard"]=new[]{730},["RotNoSelfDamage"]=new[]{732},["RotCurrentHealthRatio"]=new[]{732},["RotCurrentHealthCap"]=new[]{732},["BiteGuard"]=new[]{733},["BiteAfterHook"]=new[]{733},
            ["WolfEnergyAttack"]=new[]{810},["WolfEnergyDrain"]=new[]{810},["WolfShotRatio"]=new[]{812},["WolfRushRatio"]=new[]{813},["WolfFinisherRatio"]=new[]{814},
            ["DoomEnergyDrain"]=new[]{650},["OutnumberedRatio"]=new[]{653},["DevourDamageBonus"]=new[]{654},
            ["PhoenixRebirthHealth"]=new[]{524},["PhoenixEggHitBonus"]=new[]{524},["PhoenixBasicRatio"]=new[]{522},
            ["FinalHitAttackRatio"]=new[]{952},["PhantomGuardBuff"]=new[]{610},["DodgeEnergyBonus"]=new[]{614},
            ["SlowCap"]=new[]{103},["ExtraVolleyProjectiles"]=new[]{20},["KillEnergy"]=new[]{100},["DotHealPercent"]=new[]{72},
            ["DistanceDamageCap"]=new[]{250},["ExecuteDamageRatio"]=new[]{280},["RepeatHitRatio"]=new[]{172},["RepeatHitMaximum"]=new[]{172},
            ["MagicHitRatio"]=new[]{183},["MagicHitMaximum"]=new[]{183},["SplitRatioBonus"]=new[]{162},["SplitTargets"]=new[]{162},
            ["MulticastFourChance"]=new[]{240,242,243},["MissingHealthRatio"]=new[]{192},["CounterChance"]=new[]{283},["CounterCooldown"]=new[]{283},["CounterHealPercent"]=new[]{283}
        };
        public static IEnumerable<SkillEvolutionDefinition> Active(SkillDefinition skill,int level)=>(skill.Evolutions??new List<SkillEvolutionDefinition>()).Where(x=>x.RequiredSkillLevel<=level).OrderBy(x=>x.RequiredSkillLevel).ThenBy(x=>x.Id,StringComparer.Ordinal);
        public static double Value(SkillDefinition skill,int level,string field,double initial)
        {
            foreach(var p in Active(skill,level).SelectMany(x=>x.ParameterChanges).Where(x=>x.Field==field))initial=p.Mode==SkillParameterMode.Add?initial+p.Value:p.Value;
            return initial;
        }
        // Called on detached runtime data only, after ordinary level growth.
        public static void ApplyParameters(SkillDefinition skill,int level,bool includeSummons=true)
        {
            foreach(var p in Active(skill,level).SelectMany(x=>x.ParameterChanges))
            {
                if(IsSummonParameter(p.Field))
                {
                    if(includeSummons && skill.Crystal.Summon?.Enabled==true)ApplySummonParameter(skill.Crystal.Summon,p,skill.Id);
                    continue;
                }
                if(TextFields.ContainsKey(p.Field)){typeof(ZatodSkillDefinition).GetField(p.Field).SetValue(skill.Crystal,p.Text);continue;}
                if(!Numeric.Contains(p.Field))continue;
                if(p.Field.StartsWith("ScriptArg",StringComparison.Ordinal))
                {int i=int.Parse(p.Field.Substring(9))-1;while(skill.Crystal.ScriptArgs.Count<=i)skill.Crystal.ScriptArgs.Add(0);skill.Crystal.ScriptArgs[i]=p.Mode==SkillParameterMode.Add?skill.Crystal.ScriptArgs[i]+p.Value:p.Value;continue;}
                var field=typeof(ZatodSkillDefinition).GetField(p.Field,BindingFlags.Instance|BindingFlags.Public);
                double value=p.Mode==SkillParameterMode.Add?Convert.ToDouble(field.GetValue(skill.Crystal))+p.Value:p.Value;
                field.SetValue(skill.Crystal,field.FieldType==typeof(int)?(object)checked((int)value):value);
            }
        }
        static bool IsSummonParameter(string field)=>field is "SummonCount" or "SummonDurationSeconds" or "SummonHealthMultiplier" or "SummonDamageMultiplier";

        static void ApplySummonParameter(ZatodSummonDefinition summon,SkillParameterChange parameter,string skillId)
        {
            double Adjust(double current)=>parameter.Mode==SkillParameterMode.Add?current+parameter.Value:parameter.Value;
            switch(parameter.Field)
            {
                case "SummonCount":
                    double count=Adjust(summon.Count);
                    if(!(count>=1 && count<=4 && count==Math.Truncate(count)))
                        throw new ArgumentException("Evolution summon count must be an integer from 1 to 4: "+skillId);
                    summon.Count=(int)count;
                    break;
                case "SummonDurationSeconds": summon.DurationSeconds=Adjust(summon.DurationSeconds); break;
                case "SummonHealthMultiplier": summon.HealthMultiplier=Adjust(summon.HealthMultiplier); break;
                case "SummonDamageMultiplier": summon.DamageMultiplier=Adjust(summon.DamageMultiplier); break;
            }
            if(!summon.HasValidParameters)throw new ArgumentException("Evolution summon parameter is outside its limits: "+skillId);
        }

        public static void Validate(SkillDefinition skill,HeroCatalogData data)
        {
            if(skill.Evolutions==null)throw new ArgumentException("Missing Evolutions: "+skill.Id);
            var ids=new HashSet<string>(StringComparer.Ordinal);var levels=new HashSet<int>();
            foreach(var evo in skill.Evolutions)
            {
                if(evo==null || string.IsNullOrWhiteSpace(evo.Id) || !ids.Add(evo.Id) || evo.RequiredSkillLevel<1 || evo.RequiredSkillLevel>10000 || !levels.Add(evo.RequiredSkillLevel) || string.IsNullOrWhiteSpace(evo.Description) || evo.ParameterChanges==null || evo.TriggeredEffects==null || skill.Crystal==null)throw new ArgumentException("Invalid/ambiguous evolution: "+skill.Id);
                var fields=new HashSet<string>(StringComparer.Ordinal);
                foreach(var p in evo.ParameterChanges)
                {
                    if(p==null || p.Field==null || !Enum.IsDefined(typeof(SkillParameterMode),p.Mode) || !Finite(p.Value) || !Finite(p.ScalingRatio) || !fields.Add(p.Field+":"+p.BuffId+":"+p.StatId) || !(Numeric.Contains(p.Field)||Runtime.Contains(p.Field)||TextFields.ContainsKey(p.Field)||IsSummonParameter(p.Field)||ExpandedParameters.Contains(p.Field)))throw new ArgumentException("Unsupported evolution parameter: "+skill.Id);
                    if(ExpandedParameters.Contains(p.Field) && !skill.Crystal.ExpandedRules)throw new ArgumentException("Expanded parameter requires V7 content: "+skill.Id);
                    if(IsSummonParameter(p.Field) && (skill.Crystal.Summon?.Enabled!=true || p.BuffId!=0 ||
                        !string.IsNullOrEmpty(p.StatId) || !string.IsNullOrEmpty(p.Text) ||
                        !string.IsNullOrEmpty(p.ScalingAttribute) || p.ScalingRatio!=0))
                        throw new ArgumentException("Summon evolutions require an enabled summon and a numeric parameter: "+skill.Id);
                    if(TextFields.TryGetValue(p.Field,out var values) && (p.Mode!=SkillParameterMode.Replace || !values.Contains(p.Text)))throw new ArgumentException("Invalid evolution text parameter: "+skill.Id);
                    if(p.Field=="BuffStat" && !data.Stats.Any(x=>x.Id==p.StatId) || !string.IsNullOrEmpty(p.ScalingAttribute) && !data.Stats.Any(x=>x.Id==p.ScalingAttribute))throw new ArgumentException("Unknown evolution stat: "+skill.Id);
                    if(p.BuffId!=0 && !data.Buffs.Any(x=>x.SourceId==p.BuffId))throw new ArgumentException("Unknown evolution buff: "+skill.Id);
                    if(NativeParameters.TryGetValue(p.Field,out var supported) && !supported.Contains(skill.Crystal.SourceId))throw new ArgumentException("Evolution parameter has no handler for this skill: "+p.Field);
                    if(new[]{"BuffDuration","BuffDurationBonus","BuffStat","ShieldBonus"}.Contains(p.Field) && !data.Buffs.Any(x=>x.SourceId==(p.BuffId==0?skill.Crystal.BuffId:p.BuffId)))throw new ArgumentException("Evolution parameter has no target buff: "+skill.Id);
                    if(p.Field=="ChainJumps" && (p.Value<0 || p.Value!=Math.Truncate(p.Value)))throw new ArgumentException("Invalid chain count.");
                }
                foreach(var effect in evo.TriggeredEffects)
                {
                    if(effect==null || !Enum.IsDefined(typeof(SkillEvolutionEvent),effect.Trigger)||!Enum.IsDefined(typeof(SkillEvolutionTarget),effect.Target)||!Enum.IsDefined(typeof(SkillEvolutionEffect),effect.Effect) || new[]{effect.Amount,effect.Ratio,effect.Maximum,effect.Radius,effect.Duration,effect.Chance}.Any(x=>!Finite(x)) || effect.Chance<0 || effect.Chance>100 || effect.Radius<0 || effect.Duration< -1)throw new ArgumentException("Invalid evolution trigger: "+skill.Id);
                    if((effect.Effect==SkillEvolutionEffect.Buff || effect.Effect==SkillEvolutionEffect.OverhealShield) && !data.Buffs.Any(x=>x.SourceId==effect.BuffId))throw new ArgumentException("Missing triggered buff: "+skill.Id);
                    if((effect.Effect==SkillEvolutionEffect.DependentSkill || effect.Effect==SkillEvolutionEffect.ResetCooldown) && (effect.SkillId==skill.Id || !data.Skills.Any(x=>x.Id==effect.SkillId)))throw new ArgumentException("Missing/recursive dependent skill: "+skill.Id);
                    if(effect.Effect==SkillEvolutionEffect.OverhealShield && (effect.Trigger!=SkillEvolutionEvent.Hit || skill.Crystal.DamageType!="Heal" || effect.Maximum<=0) || effect.Effect==SkillEvolutionEffect.CollectMagicHits && (effect.Trigger!=SkillEvolutionEvent.Hit || skill.Crystal.SourceId!=183) || effect.Trigger==SkillEvolutionEvent.FirstLethalDamage && skill.Crystal.SourceId!=203 || (effect.Trigger==SkillEvolutionEvent.BuffRemoved || effect.Trigger==SkillEvolutionEvent.BuffExpired) && skill.Crystal.BuffId<=0)throw new ArgumentException("Unsupported evolution event/effect combination: "+skill.Id);
                    if(effect.Effect==SkillEvolutionEffect.EnergySteal && effect.Amount<0 || (effect.ScaleByEnemyCount || effect.UseSkillPower) && effect.Effect!=SkillEvolutionEffect.DependentSkill)throw new ArgumentException("Unsupported evolution effect options: "+skill.Id);
                }
            }
            var summon=skill.Crystal?.Summon?.Copy();
            if(summon?.Enabled!=true)return;
            foreach(var parameter in Active(skill,int.MaxValue).SelectMany(evolution=>evolution.ParameterChanges).Where(p=>IsSummonParameter(p.Field)))
                ApplySummonParameter(summon,parameter,skill.Id);
        }
        public static void ValidateDependencies(HeroCatalogData data)
        {
            var skills=data.Skills.ToDictionary(x=>x.Id,StringComparer.Ordinal);var visited=new HashSet<string>();var pending=new HashSet<string>();
            void Visit(string id)
            {
                if(pending.Contains(id))throw new ArgumentException("Recursive evolution dependency: "+id);
                if(!visited.Add(id))return;
                pending.Add(id);
                foreach(var effect in skills[id].Evolutions.SelectMany(x=>x.TriggeredEffects).Where(x=>x.Effect==SkillEvolutionEffect.DependentSkill))Visit(effect.SkillId);
                pending.Remove(id);
            }
            foreach(var id in skills.Keys)Visit(id);
        }
        static bool Finite(double x)=>!double.IsNaN(x)&&!double.IsInfinity(x);
    }
}
