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
        public string Id, Description;
        public int RequiredSkillLevel;
        public List<SkillParameterChange> ParameterChanges=new List<SkillParameterChange>();
        public List<SkillTriggeredEffect> TriggeredEffects=new List<SkillTriggeredEffect>();
        public SkillEvolutionDefinition Copy()=>new SkillEvolutionDefinition{Id=Id,Description=Description,RequiredSkillLevel=RequiredSkillLevel,ParameterChanges=ParameterChanges.ConvertAll(x=>x.Copy()),TriggeredEffects=TriggeredEffects.ConvertAll(x=>x.Copy())};
    }
    public static class SkillEvolution
    {
        static readonly HashSet<string> Numeric=new HashSet<string>(new[]{"BasicAmount","PlusRatio","Cooldown","InitialCooldown","GlobalCooldown","ShapeArg1","ShapeArg2","KnockBack","KnockUp","GainEnergy","CritPercent","ChainJumps","ScriptArg1","ScriptArg2","ScriptArg3","ScriptArg4","ScriptArg5","ScriptArg6"},StringComparer.Ordinal);
        static readonly HashSet<string> Runtime=new HashSet<string>(new[]{"BuffDuration","BuffDurationBonus","BuffStat","ShieldBonus","SlowCap","ExtraVolleyProjectiles","KillEnergy","DotHealPercent","DistanceDamageCap","ExecuteDamageRatio","RepeatHitRatio","RepeatHitMaximum","MagicHitRatio","MagicHitMaximum","SplitRatioBonus","SplitTargets","MulticastFourChance","MissingHealthRatio","CounterChance","CounterCooldown","CounterHealPercent"},StringComparer.Ordinal);
        static readonly Dictionary<string,string[]> TextFields=new Dictionary<string,string[]>(StringComparer.Ordinal){["AoeOrigin"]=new[]{"self","target"},["AoeShape"]=new[]{"circle","rectangle","halfcircle","quartercircle"},["DamageType"]=new[]{"AD","AP","Holy","Heal"}};
        static readonly Dictionary<string,int[]> NativeParameters=new Dictionary<string,int[]>(StringComparer.Ordinal)
        {
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
        public static void ApplyParameters(SkillDefinition skill,int level)
        {
            foreach(var p in Active(skill,level).SelectMany(x=>x.ParameterChanges))
            {
                if(TextFields.ContainsKey(p.Field)){typeof(ZatodSkillDefinition).GetField(p.Field).SetValue(skill.Crystal,p.Text);continue;}
                if(!Numeric.Contains(p.Field))continue;
                if(p.Field.StartsWith("ScriptArg",StringComparison.Ordinal))
                {int i=int.Parse(p.Field.Substring(9))-1;while(skill.Crystal.ScriptArgs.Count<=i)skill.Crystal.ScriptArgs.Add(0);skill.Crystal.ScriptArgs[i]=p.Mode==SkillParameterMode.Add?skill.Crystal.ScriptArgs[i]+p.Value:p.Value;continue;}
                var field=typeof(ZatodSkillDefinition).GetField(p.Field,BindingFlags.Instance|BindingFlags.Public);
                double value=p.Mode==SkillParameterMode.Add?Convert.ToDouble(field.GetValue(skill.Crystal))+p.Value:p.Value;
                field.SetValue(skill.Crystal,field.FieldType==typeof(int)?(object)checked((int)value):value);
            }
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
                    if(p==null || p.Field==null || !Enum.IsDefined(typeof(SkillParameterMode),p.Mode) || !Finite(p.Value) || !Finite(p.ScalingRatio) || !fields.Add(p.Field+":"+p.BuffId+":"+p.StatId) || !(Numeric.Contains(p.Field)||Runtime.Contains(p.Field)||TextFields.ContainsKey(p.Field)))throw new ArgumentException("Unsupported evolution parameter: "+skill.Id);
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
