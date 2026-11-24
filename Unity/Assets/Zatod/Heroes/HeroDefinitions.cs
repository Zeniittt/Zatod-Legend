using System;
using System.Collections.Generic;

namespace Zatod.Heroes
{
    [Serializable]
    public sealed class HeroCatalogData
    {
        public int SchemaVersion = 1;
        public int MaxHeroStars = 5;
        public string ConfigVersion = "heroes-prototype-1";
        public List<StatDefinition> Stats = new List<StatDefinition>();
        public List<ItemDefinition> Items = new List<ItemDefinition>();
        public List<CraftRecipeDefinition> CraftRecipes = new List<CraftRecipeDefinition>();
        public List<StarRuleDefinition> StarRules = new List<StarRuleDefinition>();
        public List<SkillDefinition> Skills = new List<SkillDefinition>();
        public SkillProgressionDefinition SkillProgression = new SkillProgressionDefinition();
        public List<HeroDefinition> Heroes = new List<HeroDefinition>();
        public List<MonsterDefinition> Monsters = new List<MonsterDefinition>();
        public List<ZatodBuffDefinition> Buffs = new List<ZatodBuffDefinition>();
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
        // ItemId identifies a definition; instance GUIDs belong to ItemData.
        public string ItemId;
        public string Id, Name; // Id reads existing prototype configs during migration.
        public string DefinitionId => string.IsNullOrEmpty(ItemId) ? Id : ItemId;
        public string IconResource;
        public int LevelRequirement = 1, Quality;
        public ItemKind ItemKind;
        public long HeroExpValue;
        public List<StatAmount> PreciseStats = new List<StatAmount>();
        public InventoryTab InventoryTab;
        public InventoryFilter InventoryFilter;
        public string Description, Comment;
        public long SellPrice;
        public List<StatValue> Stats = new List<StatValue>();
    }

    public enum HeroPosition { Front, Middle, Rear }

    [Serializable]
    public abstract class CombatantDefinition
    {
        public string Id, Name;
        public int SourceUnitId;
        public string SourcePuppet, SourceResource;
        public double ArtScale = 1, CollideRadius;
        public List<StatAmount> PreciseBaseStats = new List<StatAmount>();
        public List<HeroGrowthDefinition> Growth = new List<HeroGrowthDefinition>();
        public List<UnitRankStats> RankStats = new List<UnitRankStats>();
        public HeroPosition Position;
        public string PortraitKey;
        public string BodyPrefabResource, AnimationSetResource, NormalAttackSkillId;
        public int ProjectileHurtboxHeight = 100;
        public int DeathAnimationMilliseconds = 1500;
        public List<HeroSpawnPointDefinition> SpawnPoints = new List<HeroSpawnPointDefinition>();
        public List<StatValue> BaseStats = new List<StatValue>();
    }

    [Serializable]
    public sealed class HeroDefinition : CombatantDefinition
    {
        public string StartingRankId, SoulstoneItemId;
        public int InitialStars=1;
        public List<HeroRankDefinition> Ranks = new List<HeroRankDefinition>();
        public List<HeroSkillSlotDefinition> SkillSlots = new List<HeroSkillSlotDefinition>();
    }

    [Serializable]
    public sealed class HeroSpawnPointDefinition
    {
        public string Id;
        // Local combat units: Forward mirrors with facing; Height is measured above the ground.
        public int Forward, Height;
        public HeroSpawnPointDefinition Copy() { return (HeroSpawnPointDefinition)MemberwiseClone(); }
    }

    [Serializable]
    public sealed class HeroRankDefinition
    {
        public string Id, Name, NextRankId;
        // Incremental bonuses: every reached rank contributes once.
        public List<StatValue> BonusStats = new List<StatValue>();
        public List<StatAmount> PreciseBonusStats = new List<StatAmount>();
        public List<EquipmentSlotDefinition> EquipmentSlots = new List<EquipmentSlotDefinition>();
        public List<string> UnlockSkillSlotIds = new List<string>();
    }

    [Serializable] public sealed class EquipmentSlotDefinition { public string Id, RequiredItemId; }
    [Serializable] public sealed class HeroSkillSlotDefinition { public string Id, SkillId; public bool IsUltimate; public int InitialLevel = 1; }
    public enum SkillKind { Active, Passive }
    public enum SkillActivation { Automatic, UltimateIntent, BattleStart, AfterBasicAttack, OnDeath }
    public enum SkillTarget { Self, FrontEnemy, LowestHealthEnemy, AllEnemies, LowestHealthAlly, AllAllies, NearestEnemy, EnemiesInRange, NearestEnemies, EnemiesInLine, FarthestEnemy, LowestHealthAndBehind }
    public enum SkillEffectKind { Damage, Heal, Stun, StatBonus, KnockUp, Knockback, Poison, DamageBuff, Resurrect, Burn }
    public enum SkillDelivery { Instant, Projectile, TargetedEffect, Beam }
    public enum ProjectileAim { TargetPosition, Forward }

    [Serializable]
    public sealed class SkillDefinition
    {
        public string Id, Name;
        public string Description, IconResource;
        public List<SkillEvolutionDefinition> Evolutions=new List<SkillEvolutionDefinition>();
        public ZatodSkillDefinition Crystal;
        public SkillKind Kind;
        // UltimateIntent is supplied by offline AI or a live player's accepted command.
        public SkillActivation Activation;
        public SkillTarget Target;
        public int EnergyCost, CooldownMilliseconds, CastRange, EffectRadius;
        public int WindupMilliseconds, RecoveryMilliseconds;
        public int MaxTargets, AnimationDurationMilliseconds;
        public string TargetEffectState;
        public int TargetEffectDelayMilliseconds, TargetEffectImpactMilliseconds, TargetEffectDurationMilliseconds;
        public string ProjectileFlightState, ProjectileImpactState;
        public int ProjectileImpactDurationMilliseconds, ProjectileTargetHeight;
        public bool DescendingProjectile, ImpactOnGround;
        public int ProjectileHitOffsetHeight;
        public List<SkillVisualCue> CasterVisuals = new List<SkillVisualCue>();
        public bool CastAtBattleStart;
        public List<SkillCastSequence> CastSequences = new List<SkillCastSequence>();
        public string AnimationState;
        public SkillDelivery Delivery;
        public string ProjectileResource;
        public string ProjectileSpawnPointId;
        public int ProjectileSpawnOffsetForward, ProjectileSpawnOffsetHeight, ProjectileHitOffsetForward;
        // Zero retains legacy art size. 10000 uses the character's reference art scale.
        public int ProjectileVisualScaleBasisPoints;
        public ProjectileAim ProjectileAim;
        public int ProjectileSpawnMilliseconds, ProjectileSpeed, ProjectileHitRadius, ProjectileLifetimeMilliseconds;
        public int LifestealBasisPoints;
        public string LifestealReturnState;
        public int ProjectileMaxHits = 1;
        public bool ProjectileTargetOnly;
        public bool ProjectileTracksTarget;
        public List<SkillEffectDefinition> Effects = new List<SkillEffectDefinition>();
        public SkillDefinition Copy()
        {
            var copy = (SkillDefinition)MemberwiseClone();
            copy.Crystal = Crystal?.Copy();
            copy.Evolutions = (Evolutions??new List<SkillEvolutionDefinition>()).ConvertAll(x=>x.Copy());
            copy.Effects = Effects.ConvertAll(effect => effect.Copy());
            copy.CasterVisuals = CasterVisuals.ConvertAll(cue => cue.Copy());
            copy.CastSequences = CastSequences.ConvertAll(sequence => sequence.Copy());
            return copy;
        }
    }

    [Serializable]
    public sealed class SkillVisualCue
    {
        public string State;
        public int DelayMilliseconds, DurationMilliseconds, Forward, Height;
        public bool FollowCaster = true, StretchToRange;
        public bool AtTarget, FollowTarget, StretchToTarget;
        public bool Shockwave;
        public int MoveForward, MoveHeight, GrowMilliseconds;
        public SkillVisualCue Copy() { return (SkillVisualCue)MemberwiseClone(); }
    }

    public enum SkillSequenceAction { Projectile, Effects, AreaPulse, TeleportToTarget, GrabTarget, ThrowTarget }
    public enum SequenceTargetOrder { Nearest, LowestHealth }

    [Serializable]
    public sealed class SkillSequenceCue
    {
        // Zero preserves existing cues; a positive value scales this cue's direct damage only.
        public int DamageMultiplierBasisPoints;
        public int DelayMilliseconds;
        public SkillSequenceAction Action;
        public int Distance, DurationMilliseconds, Height, TargetIndex;
        public bool SelectTargetByIndex, RequireAttackRange, RequiresGrab;
        public SequenceTargetOrder TargetOrder;
        public SkillSequenceCue Copy() { return (SkillSequenceCue)MemberwiseClone(); }
    }

    [Serializable]
    public sealed class SkillMotionKey
    {
        public int TimeMilliseconds, Forward, Height;
        public SkillMotionKey Copy() { return (SkillMotionKey)MemberwiseClone(); }
    }

    [Serializable]
    public sealed class SkillCastSequence
    {
        public bool Opening, ContinueAfterRelease;
        public bool ReturnToStartOnEnd;
        public string AnimationState;
        public int DurationMilliseconds, ReleaseMilliseconds;
        public List<SkillSequenceCue> Actions = new List<SkillSequenceCue>();
        public List<SkillVisualCue> Visuals = new List<SkillVisualCue>();
        public List<SkillMotionKey> Motion = new List<SkillMotionKey>();
        public SkillCastSequence Copy()
        {
            var copy = (SkillCastSequence)MemberwiseClone();
            copy.Actions = Actions.ConvertAll(c => c.Copy());
            copy.Visuals = Visuals.ConvertAll(c => c.Copy());
            copy.Motion = Motion.ConvertAll(c => c.Copy());
            return copy;
        }
    }

    [Serializable]
    public sealed class SkillEffectDefinition
    {
        public SkillEffectKind Kind;
        public int Amount, DamageScaleBasisPoints, DurationMilliseconds;
        public int TickIntervalMilliseconds;
        public int FirstTickDelayMilliseconds;
        public string VisualState;
        public int ModifierBasisPoints;
        public int ReviveDelayMilliseconds, ReviveHealthBasisPoints, MaxTriggersPerBattle;
        public int DisplacementDistance, KnockUpHeight;
        public string StatId;
        public SkillEffectDefinition Copy() { return (SkillEffectDefinition)MemberwiseClone(); }
    }
}
