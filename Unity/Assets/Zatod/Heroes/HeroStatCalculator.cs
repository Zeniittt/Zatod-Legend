using System;
using System.Collections.Generic;
using System.Linq;

namespace Zatod.Heroes
{
    public sealed class StatContribution
    {
        public string Source, StatId;
        public int Value;
    }

    public sealed class HeroStatResult
    {
        public readonly List<StatValue> Stats = new List<StatValue>();
        public readonly List<StatContribution> Breakdown = new List<StatContribution>();
        public int Get(string statId)
        {
            var stat = Stats.SingleOrDefault(s => s.StatId == statId);
            if (stat == null) throw new ArgumentException("Unknown calculated stat: " + statId);
            return stat.Value;
        }
    }

    public static class HeroStatCalculator
    {
        // Only flat contributions in this phase. Level/star growth, percentages and combat power
        // require their own configured formulas before being added here.
        public static HeroStatResult Calculate(HeroData hero, HeroCatalog catalog)
        {
            catalog.ValidateHero(hero);
            var result = new HeroStatResult();
            var totals = catalog.Data.Stats.ToDictionary(s => s.Id, s => 0L, StringComparer.Ordinal);
            Action<string, List<StatValue>, int> add = (source, values, quantity) =>
            {
                foreach (var stat in values)
                {
                    int value = checked(stat.Value * quantity);
                    totals[stat.StatId] = checked(totals[stat.StatId] + value);
                    result.Breakdown.Add(new StatContribution { Source = source, StatId = stat.StatId, Value = value });
                }
            };
            var definition = catalog.Hero(hero.HeroDefinitionId);
            add("Base", definition.BaseStats, 1);
            foreach (var rank in catalog.RankPath(definition, hero.RankId)) add("Rank/" + rank.Id, rank.BonusStats, 1);
            foreach (var item in hero.AbsorbedItems)
                add("Absorbed/" + item.RankId + "/" + item.SlotId + "/" + item.ItemId, catalog.Item(item.ItemId).Stats, item.Quantity);
            foreach (var item in hero.EquippedItems)
                add("Equipped/" + item.SlotId + "/" + item.ItemId, catalog.Item(item.ItemId).Stats, 1);
            foreach (var stat in catalog.Data.Stats)
            {
                long total = totals[stat.Id];
                long clamped = Math.Max(stat.Minimum, total);
                if (clamped != total) result.Breakdown.Add(new StatContribution { Source = "Minimum", StatId = stat.Id, Value = checked((int)(clamped - total)) });
                result.Stats.Add(new StatValue(stat.Id, checked((int)clamped)));
            }
            return result;
        }
    }

    public static class HeroBattleFactory
    {
        // Fully detached snapshot: later config/progression edits cannot change an existing battle.
        // Stage effects and combat buffs will modify this runtime data, never HeroData or config.
        public static HeroBattleData Create(HeroData hero, HeroCatalog catalog)
        {
            var stats = HeroStatCalculator.Calculate(hero, catalog);
            var battle = new HeroBattleData
            {
                ConfigVersion = catalog.Data.ConfigVersion, HeroInstanceId = hero.HeroInstanceId,
                HeroDefinitionId = hero.HeroDefinitionId, Stats = stats.Stats.Select(s => s.Copy()).ToList()
            };
            var health = battle.Stats.SingleOrDefault(s => s.StatId == "health");
            battle.CurrentHp = health == null ? 0 : health.Value;
            var definition = catalog.Hero(hero.HeroDefinitionId);
            if (!string.IsNullOrEmpty(definition.NormalAttackSkillId))
            {
                battle.HasNormalAttack = true;
                battle.NormalAttack = catalog.Skill(definition.NormalAttackSkillId).Copy();
            }
            battle.SpawnPoints = definition.SpawnPoints.ConvertAll(point => point.Copy());
            foreach (var slot in HeroProgression.UnlockedSkills(hero, catalog))
            {
                var source = catalog.Skill(slot.SkillId);
                battle.Skills.Add(new BattleSkillData
                {
                    SlotId = slot.Id, IsUltimate = slot.IsUltimate,
                    Level = hero.Skills.Single(s => s.SlotId == slot.Id).Level,
                    Definition = source.Copy()
                });
            }
            return battle;
        }
    }
}
