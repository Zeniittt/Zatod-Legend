using System;
using System.Collections.Generic;
using System.Linq;

namespace Zatod.Heroes
{
    // Build a new catalog when applying a balance file; do not mutate a live catalog.
    public sealed class HeroCatalog
    {
        public HeroCatalogData Data { get; private set; }
        readonly Dictionary<string, StatDefinition> stats;
        readonly Dictionary<string, ItemDefinition> items;
        readonly Dictionary<string, SkillDefinition> skills;
        readonly Dictionary<string, HeroDefinition> heroes;

        public HeroCatalog(HeroCatalogData data)
        {
            Require(data != null && data.SchemaVersion == 1, "Unsupported hero config schema.");
            Require(!string.IsNullOrWhiteSpace(data.ConfigVersion), "ConfigVersion is required.");
            Data = data;
            stats = Index(data.Stats, s => s.Id, "Stats");
            items = Index(data.Items, s => s.Id, "Items");
            skills = Index(data.Skills, s => s.Id, "Skills");
            heroes = Index(data.Heroes, s => s.Id, "Heroes");
            Require(stats.Count > 0 && heroes.Count > 0, "Config needs stats and heroes.");
            foreach (var stat in data.Stats) Require(stat.Minimum >= 0, "Negative minimum: " + stat.Id);
            foreach (var item in data.Items) ValidateStats(item.Stats, "Item " + item.Id);
            foreach (var skill in data.Skills)
            {
                Require(Enum.IsDefined(typeof(SkillKind), skill.Kind) && Enum.IsDefined(typeof(SkillActivation), skill.Activation)
                    && Enum.IsDefined(typeof(SkillTarget), skill.Target), "Invalid skill enum: " + skill.Id);
                Require(skill.EnergyCost >= 0 && skill.CooldownMilliseconds >= 0 && skill.CastRange >= 0
                    && skill.EffectRadius >= 0 && skill.WindupMilliseconds >= 0 && skill.RecoveryMilliseconds >= 0,
                    "Negative skill timing/cost/range: " + skill.Id);
                Require(skill.Kind != SkillKind.Passive || skill.Activation == SkillActivation.BattleStart
                    || skill.Activation == SkillActivation.AfterBasicAttack, "Passive needs an event trigger: " + skill.Id);
                Require(skill.Effects != null && skill.Effects.Count > 0, "Missing effects: " + skill.Id);
                foreach (var effect in skill.Effects)
                {
                    Require(effect != null && Enum.IsDefined(typeof(SkillEffectKind), effect.Kind), "Invalid effect: " + skill.Id);
                    Require(effect.DurationMilliseconds >= 0 && effect.AttackScaleBasisPoints >= 0, "Invalid effect duration/scale: " + skill.Id);
                    if (effect.Kind == SkillEffectKind.StatBonus) Stat(effect.StatId);
                    else Require(effect.Amount >= 0, "Negative damage/heal amount: " + skill.Id);
                }
            }
            foreach (var hero in data.Heroes) ValidateDefinition(hero);
        }

        public StatDefinition Stat(string id) { return Find(stats, id, "stat"); }
        public ItemDefinition Item(string id) { return Find(items, id, "item"); }
        public SkillDefinition Skill(string id) { return Find(skills, id, "skill"); }
        public HeroDefinition Hero(string id) { return Find(heroes, id, "hero"); }

        public List<HeroRankDefinition> RankPath(HeroDefinition hero, string throughRankId)
        {
            var ranks = Index(hero.Ranks, r => r.Id, "Ranks of " + hero.Id);
            var path = new List<HeroRankDefinition>();
            var visited = new HashSet<string>(StringComparer.Ordinal);
            string next = hero.StartingRankId;
            while (!string.IsNullOrEmpty(next))
            {
                Require(visited.Add(next), "Rank cycle in " + hero.Id + ": " + next);
                var rank = Find(ranks, next, "rank");
                path.Add(rank);
                if (rank.Id == throughRankId) return path;
                next = rank.NextRankId;
            }
            Require(throughRankId == null, "Unreachable rank: " + throughRankId);
            Require(path.Count == ranks.Count, "Unreachable ranks in " + hero.Id);
            return path;
        }

        public HeroData CreateHero(string definitionId, string instanceId)
        {
            Require(!string.IsNullOrWhiteSpace(instanceId), "HeroInstanceId is required.");
            var definition = Hero(definitionId);
            return new HeroData
            {
                HeroInstanceId = instanceId, HeroDefinitionId = definition.Id,
                RankId = definition.StartingRankId, Definition = definition,
                Skills = definition.SkillSlots.Select(s => new HeroSkillData { SlotId = s.Id, Level = 1 }).ToList()
            };
        }

        public void Bind(CharacterData character)
        {
            Require(character != null && character.SchemaVersion == 1, "Unsupported character save schema.");
            Require(!string.IsNullOrWhiteSpace(character.CharacterId), "CharacterId is required.");
            Require(character.HeroDesk != null, "HeroDesk is missing.");
            var ids = new HashSet<string>(StringComparer.Ordinal);
            foreach (var hero in character.HeroDesk)
            {
                ValidateHero(hero);
                Require(ids.Add(hero.HeroInstanceId), "Duplicate owned hero: " + hero.HeroInstanceId);
            }
            // Commit references only after the entire desk is valid.
            foreach (var hero in character.HeroDesk) hero.Definition = Hero(hero.HeroDefinitionId);
        }

        public void ValidateHero(HeroData hero)
        {
            Require(hero != null && !string.IsNullOrWhiteSpace(hero.HeroInstanceId), "Invalid HeroData identity.");
            Require(!string.IsNullOrWhiteSpace(hero.RankId), "Hero RankId is required.");
            var definition = Hero(hero.HeroDefinitionId);
            var path = RankPath(definition, hero.RankId);
            var rank = path[path.Count - 1];
            Require(hero.Level >= 1 && hero.Stars >= 1 && hero.Exp >= 0, "Invalid reserved hero progression.");
            var equipped = Index(hero.EquippedItems, i => i.SlotId, "Equipped items");
            foreach (var item in equipped.Values)
            {
                Item(item.ItemId);
                Require(rank.EquipmentSlots.Any(s => s.Id == item.SlotId), "Unknown current equipment slot: " + item.SlotId);
                // Grandfather previously equipped items when the required recipe changes.
            }
            Require(hero.AbsorbedItems != null, "AbsorbedItems is missing.");
            var historyKeys = new HashSet<string>(StringComparer.Ordinal);
            var priorRanks = new HashSet<string>(path.Take(path.Count - 1).Select(r => r.Id), StringComparer.Ordinal);
            foreach (var item in hero.AbsorbedItems)
            {
                Require(item != null && priorRanks.Contains(item.RankId) && !string.IsNullOrWhiteSpace(item.SlotId)
                    && item.Quantity > 0, "Invalid absorbed item provenance.");
                Require(historyKeys.Add(item.RankId + "\n" + item.SlotId), "Duplicate absorbed rank/slot.");
                Item(item.ItemId);
                // Never reconstruct history from today's recipe or require a historical slot to still exist.
            }
            var ownedSkills = Index(hero.Skills, s => s.SlotId, "Hero skills");
            Require(ownedSkills.Count == definition.SkillSlots.Count, "Hero skill slots do not match definition.");
            foreach (var slot in definition.SkillSlots)
                Require(ownedSkills.ContainsKey(slot.Id) && ownedSkills[slot.Id].Level >= 1, "Missing/invalid skill progress: " + slot.Id);
        }

        void ValidateDefinition(HeroDefinition hero)
        {
            ValidateStats(hero.BaseStats, "Hero " + hero.Id);
            var slots = Index(hero.SkillSlots, s => s.Id, "Skill slots of " + hero.Id);
            Require(slots.Count > 0 && slots.Values.Count(s => s.IsUltimate) == 1, "Hero needs exactly one ultimate slot: " + hero.Id);
            foreach (var slot in slots.Values)
            {
                var skill = Skill(slot.SkillId);
                Require(!slot.IsUltimate || (skill.Kind == SkillKind.Active && skill.Activation == SkillActivation.UltimateIntent),
                    "Ultimate must be active with UltimateIntent: " + slot.Id);
            }
            var path = RankPath(hero, null);
            Require(path.Count > 0, "Hero needs a starting rank: " + hero.Id);
            var unlocked = new HashSet<string>(StringComparer.Ordinal);
            foreach (var rank in path)
            {
                ValidateStats(rank.BonusStats, "Rank " + rank.Id);
                var equipment = Index(rank.EquipmentSlots, e => e.Id, "Equipment slots of " + rank.Id);
                foreach (var item in equipment.Values) Item(item.RequiredItemId);
                Require(string.IsNullOrEmpty(rank.NextRankId) || equipment.Count > 0, "Promotable rank needs equipment requirements: " + rank.Id);
                Require(rank.UnlockSkillSlotIds != null, "Missing unlock list: " + rank.Id);
                foreach (var slotId in rank.UnlockSkillSlotIds)
                    Require(slotId != null && slots.ContainsKey(slotId) && unlocked.Add(slotId), "Unknown/duplicate skill unlock: " + slotId);
            }
            Require(path[0].UnlockSkillSlotIds.Contains(slots.Values.Single(s => s.IsUltimate).Id), "Starting rank must unlock ultimate.");
            Require(unlocked.Count == slots.Count, "Every configured skill slot needs an unlock rank.");
        }

        void ValidateStats(List<StatValue> values, string context)
        {
            var unique = Index(values, s => s.StatId, context + " stats");
            foreach (var value in unique.Values) Stat(value.StatId);
        }

        static Dictionary<string, T> Index<T>(IEnumerable<T> values, Func<T, string> key, string context) where T : class
        {
            Require(values != null, context + " is missing.");
            var result = new Dictionary<string, T>(StringComparer.Ordinal);
            foreach (var value in values)
            {
                Require(value != null, "Null entry in " + context);
                string id = key(value);
                Require(!string.IsNullOrWhiteSpace(id) && id == id.Trim() && !id.Contains("\n") && !id.Contains("\r"), "Invalid ID in " + context);
                Require(!result.ContainsKey(id), "Duplicate ID in " + context + ": " + id);
                result.Add(id, value);
            }
            return result;
        }

        static T Find<T>(Dictionary<string, T> values, string id, string kind)
        {
            if (id != null && values.TryGetValue(id, out var value)) return value;
            throw new ArgumentException("Unknown " + kind + " ID: " + id);
        }

        internal static void Require(bool condition, string message)
        {
            if (!condition) throw new ArgumentException(message);
        }
    }
}
