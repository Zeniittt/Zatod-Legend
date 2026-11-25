using System;
using System.Collections.Generic;

namespace Zatod.Heroes
{
    [Serializable] public sealed class StatAmount
    {
        public string StatId;
        public double Value;
        public StatAmount Copy() => (StatAmount)MemberwiseClone();
    }
    [Serializable] public sealed class UnitRankStats { public int Rank; public List<StatAmount> Stats = new List<StatAmount>(); public List<StatAmount> EstimatedStats = new List<StatAmount>(); }
    [Serializable] public sealed class HeroGrowthDefinition
    {
        public int Stars;
        public List<StatAmount> PerLevel = new List<StatAmount>();
    }
    [Serializable] public sealed class HeroItemStats
    {
        public string HeroId;
        public List<StatAmount> Stats = new List<StatAmount>();
    }
    [Serializable] public sealed class ZatodActionPhase
    {
        public string Action;
        public double Duration;
        public List<double> AttackTimes = new List<double>();
        public List<ZatodAttackOrigin> AttackOrigins = new List<ZatodAttackOrigin>();
        public ZatodActionPhase Copy()
        {
            var copy=(ZatodActionPhase)MemberwiseClone();
            copy.AttackTimes=new List<double>(AttackTimes);
            copy.AttackOrigins=AttackOrigins.ConvertAll(x=>new ZatodAttackOrigin{Time=x.Time,X=x.X,Y=x.Y});return copy;
        }
    }
    [Serializable] public sealed class ZatodAttackOrigin { public double Time, X, Y; }
    [Serializable] public sealed class ZatodGrowthField { public string Field; public double Amount; }
    [Serializable] public sealed class ZatodSummonDefinition
    {
        public bool Enabled;
        public bool IncludeSkills,InheritLevelAndStars,Persistent,ReplaceExisting,AtImpact;
        public bool StackOnRecast,UseSkillLevel;
        // An empty MonsterId creates a basic-attack-only clone of the caster.
        public string MonsterId,AlternateMonsterId;
        public int Count=1;
        public int StarsOverride;
        public double HpMultiplierOverride;
        public List<ZatodBattleFormDefinition> Forms=new List<ZatodBattleFormDefinition>();
        public double DurationSeconds=8, HealthMultiplier=1, DamageMultiplier=1;
        internal bool HasValidParameters=>StarsOverride>=0 && StarsOverride<=5 && HpMultiplierOverride>=0 && HpMultiplierOverride<=10 && Count>=1 && Count<=4 && DurationSeconds>=.125 && DurationSeconds<=120 &&
            HealthMultiplier>0 && HealthMultiplier<=10 && DamageMultiplier>=0 && DamageMultiplier<=10;
        public ZatodSummonDefinition Copy()
        {var copy=(ZatodSummonDefinition)MemberwiseClone();copy.Forms=(Forms??new List<ZatodBattleFormDefinition>()).ConvertAll(f=>f.Copy());return copy;}
    }
    [Serializable] public sealed class ZatodSkillDefinition
    {
        public int SourceId, Slot, UnlockRank;
        public int EnemyUnlockRank=-1;
        public int LevelSourceId;
        public double Priority;
        public string IgnoreTargetType;
        public string ActiveType, TargetType, TrackType, DamageType, PlusAttribute, PassiveAttribute;
        public string AoeOrigin, AoeShape, ProjectileArt, ImpactEffect, ChainEffect, LaunchEffect, PointEffect;
        public int TargetCamp, AffectedCamp, BuffId, ChainJumps;
        public double BasicAmount, PlusRatio, CostEnergy, GainEnergy, Cooldown, InitialCooldown, GlobalCooldown;
        public double MinRange, MaxRange, ShapeArg1, ShapeArg2, XShift, ChainGap;
        public double ProjectileSpeed, ProjectileZSpeed, Gravity, ProjectileDistance, ProjectileOverHeight;
        public double KnockUp, KnockBack, MoveForward, CritPercent, LifestealPercent;
        public bool Manual, Interruptable, Piercing, AimTarget;
        public bool ExpandedRules, TriggerOnly, ReplacesBasic, NoDodge, VisualOnly;
        public List<StatAmount> PassiveStatRatios=new List<StatAmount>();
        public List<int> PassiveExtraDamageTargets=new List<int>();
        public List<string> AdditionalEffectResources=new List<string>();
        public ZatodSummonDefinition Summon;
        public ZatodBattleFormDefinition NativeForm;
        public List<ZatodGrowthField> Growth = new List<ZatodGrowthField>();
        public List<double> ScriptArgs = new List<double>();
        public List<ZatodActionPhase> Phases = new List<ZatodActionPhase>();
        public ZatodSkillDefinition Copy()
        {
            var copy=(ZatodSkillDefinition)MemberwiseClone();
            copy.Growth=Growth.ConvertAll(x=>new ZatodGrowthField{Field=x.Field,Amount=x.Amount});
            copy.ScriptArgs=new List<double>(ScriptArgs);copy.Phases=Phases.ConvertAll(x=>x.Copy());
            copy.PassiveStatRatios=(PassiveStatRatios??new List<StatAmount>()).ConvertAll(x=>x.Copy());
            copy.PassiveExtraDamageTargets=new List<int>(PassiveExtraDamageTargets??new List<int>());
            copy.AdditionalEffectResources=new List<string>(AdditionalEffectResources??new List<string>());
            copy.Summon=Summon?.Copy();copy.NativeForm=NativeForm?.Enabled==true?NativeForm.Copy():null;return copy;
        }
    }
    [Serializable] public sealed class ZatodBattleFormDefinition
    {
        public bool Enabled;
        public string Resource,AnimationSetResource;
        public double ArtScale=1;
        public double DeathSeconds,HurtSeconds;
        public int BasicSourceId;
        public List<int> ActiveSkillSourceIds=new List<int>();
        public List<ZatodActionRemap> ActionRemaps=new List<ZatodActionRemap>();
        public List<ZatodFormSkillPhases> SkillPhases=new List<ZatodFormSkillPhases>();
        public ZatodBattleFormDefinition Copy()
        {var copy=(ZatodBattleFormDefinition)MemberwiseClone();copy.ActiveSkillSourceIds=new List<int>(ActiveSkillSourceIds);copy.ActionRemaps=ActionRemaps.ConvertAll(x=>x.Copy());copy.SkillPhases=SkillPhases.ConvertAll(x=>x.Copy());return copy;}
    }
    [Serializable] public sealed class ZatodFormSkillPhases
    {
        public int SourceId;
        public List<ZatodActionPhase> Phases=new List<ZatodActionPhase>();
        public ZatodFormSkillPhases Copy()=>new ZatodFormSkillPhases{SourceId=SourceId,Phases=Phases.ConvertAll(p=>p.Copy())};
    }
    [Serializable] public sealed class ZatodActionRemap
    {
        public string Action,Target;
        public ZatodActionRemap Copy()=>(ZatodActionRemap)MemberwiseClone();
    }
    public enum ZatodBuffEffectLayer { Default, BehindActor, InFrontOfActor, AboveBattlefield, BehindBattlefieldActors, WorldActors }
    public enum ZatodBuffShader { None,Frozen,Poison,Banish,Stone,Ice,Bkb,Invisible,Fire,Nana,Mirror }
    [Serializable] public sealed class ZatodBuffScaling { public string StatId, Attribute; public double Ratio; }
    [Serializable] public sealed class ZatodBuffDefinition
    {
        public int SourceId,LevelCheckDice;
        public string ResistAttribute;
        public string Id, Name, Control, StackRule, Dispel, Tenacity, Effect, ImpactEffect, Mod;
        public double Duration, ShieldValue;
        public string ShieldType;
        public bool ClearOnDeath;
        public ZatodBuffEffectLayer EffectLayer;
        public ZatodBuffShader Shader;
        public double ActorScaleX=1,ActorScaleY=1;
        public double EffectHeightOffset, EffectScale;
        public int MaximumStacks;
        public List<ZatodBuffScaling> Scaling = new List<ZatodBuffScaling>();
        public List<StatAmount> Stats = new List<StatAmount>();
    }
}
