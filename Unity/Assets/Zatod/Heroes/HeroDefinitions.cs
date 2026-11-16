using System;
using System.Collections.Generic;

namespace Zatod.Heroes
{
    [Serializable]
    public sealed class HeroCatalogData
    {
        public int SchemaVersion = 1;
        public string ConfigVersion = "heroes-prototype-1";
        public List<StatDefinition> Stats = new List<StatDefinition>();
        public List<ItemDefinition> Items = new List<ItemDefinition>();
        public List<SkillDefinition> Skills = new List<SkillDefinition>();
        public List<HeroDefinition> Heroes = new List<HeroDefinition>();
    }

    [Serializable] public sealed class StatDefinition { public string Id, Name; public int Minimum; }

    [Serializable]
    public sealed class StatValue
    {
        public string StatId;
        public int Value;
        public StatValue() { }
        public StatValue(string id, int value) { StatId = id; Value = value; }
        public StatValue Copy() { return new StatValue(StatId, Value); }
    }

    [Serializable]
    public sealed class ItemDefinition
    {
        public string Id, Name;
        public List<StatValue> Stats = new List<StatValue>();
    }

    [Serializable]
    public sealed class HeroDefinition
    {
        public string Id, Name, StartingRankId;
        public List<StatValue> BaseStats = new List<StatValue>();
        public List<HeroRankDefinition> Ranks = new List<HeroRankDefinition>();
        public List<HeroSkillSlotDefinition> SkillSlots = new List<HeroSkillSlotDefinition>();
    }

    [Serializable]
    public sealed class HeroRankDefinition
    {
        public string Id, Name, NextRankId;
        // Incremental bonuses: every reached rank contributes once.
        public List<StatValue> BonusStats = new List<StatValue>();
        public List<EquipmentSlotDefinition> EquipmentSlots = new List<EquipmentSlotDefinition>();
        public List<string> UnlockSkillSlotIds = new List<string>();
    }

    [Serializable] public sealed class EquipmentSlotDefinition { public string Id, RequiredItemId; }
    [Serializable] public sealed class HeroSkillSlotDefinition { public string Id, SkillId; public bool IsUltimate; }
    public enum SkillKind { Active, Passive }
    public enum SkillActivation { Automatic, UltimateIntent, BattleStart, AfterBasicAttack }
    public enum SkillTarget { Self, FrontEnemy, LowestHealthEnemy, AllEnemies, LowestHealthAlly, AllAllies }
    public enum SkillEffectKind { Damage, Heal, Stun, StatBonus }

    [Serializable]
    public sealed class SkillDefinition
    {
        public string Id, Name;
        public SkillKind Kind;
        // UltimateIntent is supplied by offline AI or a live player's accepted command.
        public SkillActivation Activation;
        public SkillTarget Target;
        public int EnergyCost, CooldownMilliseconds, CastRange, EffectRadius;
        public int WindupMilliseconds, RecoveryMilliseconds;
        public List<SkillEffectDefinition> Effects = new List<SkillEffectDefinition>();
    }

    [Serializable]
    public sealed class SkillEffectDefinition
    {
        public SkillEffectKind Kind;
        public int Amount, AttackScaleBasisPoints, DurationMilliseconds;
        public string StatId;
        public SkillEffectDefinition Copy() { return (SkillEffectDefinition)MemberwiseClone(); }
    }
}
