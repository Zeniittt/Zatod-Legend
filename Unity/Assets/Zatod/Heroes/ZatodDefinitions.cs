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
    [Serializable] public sealed class ZatodSkillDefinition
    {
        public int SourceId, Slot, UnlockRank;
        public double Priority;
        public string ActiveType, TargetType, TrackType, DamageType, PlusAttribute, PassiveAttribute;
        public string AoeOrigin, AoeShape, ProjectileArt, ImpactEffect, ChainEffect, LaunchEffect, PointEffect;
        public int TargetCamp, AffectedCamp, BuffId, ChainJumps;
        public double BasicAmount, PlusRatio, CostEnergy, GainEnergy, Cooldown, InitialCooldown, GlobalCooldown;
        public double MinRange, MaxRange, ShapeArg1, ShapeArg2, XShift, ChainGap;
        public double ProjectileSpeed, ProjectileZSpeed, Gravity, ProjectileDistance, ProjectileOverHeight;
        public double KnockUp, KnockBack, MoveForward, CritPercent, LifestealPercent;
        public bool Manual, Interruptable, Piercing, AimTarget;
        public List<ZatodGrowthField> Growth = new List<ZatodGrowthField>();
        public List<double> ScriptArgs = new List<double>();
        public List<ZatodActionPhase> Phases = new List<ZatodActionPhase>();
        public ZatodSkillDefinition Copy()
        {
            var copy=(ZatodSkillDefinition)MemberwiseClone();
            copy.Growth=Growth.ConvertAll(x=>new ZatodGrowthField{Field=x.Field,Amount=x.Amount});
            copy.ScriptArgs=new List<double>(ScriptArgs);copy.Phases=Phases.ConvertAll(x=>x.Copy());return copy;
        }
    }
    [Serializable] public sealed class ZatodBuffScaling { public string StatId, Attribute; public double Ratio; }
    [Serializable] public sealed class ZatodBuffDefinition
    {
        public int SourceId;
        public string Id, Name, Control, StackRule, Dispel, Tenacity, Effect, ImpactEffect, Mod;
        public double Duration, ShieldValue;
        public string ShieldType;
        public bool ClearOnDeath;
        public int MaximumStacks;
        public List<ZatodBuffScaling> Scaling = new List<ZatodBuffScaling>();
        public List<StatAmount> Stats = new List<StatAmount>();
    }
}
