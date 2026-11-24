using System;
using System.Collections.Generic;
using System.Linq;

namespace Zatod.Heroes
{
    [Serializable]
    public sealed class SkillUpgradeCost
    {
        public int FromLevel;
        public long Gold;
    }

    [Serializable]
    public sealed class SkillProgressionDefinition
    {
        public int SkillLevelCap = 80;
        public List<SkillUpgradeCost> GoldUpgradeCurve = new List<SkillUpgradeCost>();
    }

    public sealed class SkillUpgradePlan
    {
        public string HeroId, SlotId;
        public int FromLevel, ToLevel;
        public long Gold;
    }

    public static class SkillProgression
    {
        public static void Validate(SkillProgressionDefinition rules)
        {
            HeroCatalog.Require(rules != null && rules.SkillLevelCap >= 1 && rules.SkillLevelCap <= 10000,
                "Invalid skill level cap.");
            HeroCatalog.Require(rules.GoldUpgradeCurve != null, "Missing skill gold curve.");
            var levels = new HashSet<int>();
            foreach (var cost in rules.GoldUpgradeCurve)
                HeroCatalog.Require(cost != null && cost.FromLevel >= 1 && cost.FromLevel < 10000
                    && cost.Gold >= 0 && levels.Add(cost.FromLevel), "Invalid or duplicate skill upgrade cost.");
            // A pre-D35 catalog can still be read. It cannot sell upgrades without a configured price.
            if (rules.GoldUpgradeCurve.Count > 0)
                for (int level = 1; level < rules.SkillLevelCap; level++)
                    HeroCatalog.Require(levels.Contains(level), "Missing skill price for level " + level);
        }

        public static int Cap(HeroData hero, HeroCatalog catalog)
            => Math.Min(hero.Level, catalog.Data.SkillProgression.SkillLevelCap);

        public static SkillUpgradePlan Plan(HeroData hero, HeroCatalog catalog, string slotId, int expectedLevel, int count)
        {
            catalog.ValidateHero(hero);
            HeroCatalog.Require(count >= 1 && count <= 100, "Choose 1-100 requested skill levels.");
            HeroCatalog.Require(HeroProgression.UnlockedSkills(hero, catalog).Any(s => s.Id == slotId),
                "This skill is locked by Hero rank.");
            var skill = hero.Skills.Single(s => s.SlotId == slotId);
            HeroCatalog.Require(skill.Level == expectedLevel, "Skill level changed. Review the updated Hero.");
            HeroCatalog.Require(skill.Level <= Cap(hero, catalog) - count, "Skill has reached its Hero/config level cap.");
            long gold = 0;
            for (int level = skill.Level; level < skill.Level + count; level++)
            {
                var cost = catalog.Data.SkillProgression.GoldUpgradeCurve.SingleOrDefault(x => x.FromLevel == level);
                HeroCatalog.Require(cost != null, "Skill upgrade price is not configured for level " + level);
                try { gold = checked(gold + cost.Gold); }
                catch (OverflowException) { throw new ArgumentException("Skill upgrade price is too large."); }
            }
            return new SkillUpgradePlan { HeroId = hero.HeroInstanceId, SlotId = slotId,
                FromLevel = skill.Level, ToLevel = skill.Level + count, Gold = gold };
        }

        // Called before save validation, including when a newer catalog introduces a locked slot.
        public static void AddMissingSlots(HeroData hero, HeroDefinition definition)
        {
            hero.Skills = hero.Skills ?? new List<HeroSkillData>();
            foreach (var slot in definition.SkillSlots)
                if (!hero.Skills.Any(s => s != null && s.SlotId == slot.Id))
                    hero.Skills.Add(new HeroSkillData { SlotId = slot.Id, Level = slot.InitialLevel });
        }

        public static List<EquippedItemData> QuickEquipPlan(CharacterData account, HeroData hero, HeroCatalog catalog)
        {
            new ItemInventory(account, catalog).Validate();
            HeroCatalog.Require(account.HeroDesk.Contains(hero), "Hero is not owned by this character.");
            var available = account.Inventory.OrderBy(x => x.Id, StringComparer.Ordinal).ToList();
            var plan = new List<EquippedItemData>();
            foreach (var slot in HeroProgression.CurrentRank(hero, catalog).EquipmentSlots)
            {
                if (hero.EquippedItems.Any(x => x.SlotId == slot.Id)) continue;
                if (hero.Level < catalog.Item(slot.RequiredItemId).LevelRequirement) continue;
                var item = available.FirstOrDefault(x => x.ItemId == slot.RequiredItemId);
                if (item == null) continue;
                plan.Add(new EquippedItemData { Id = item.Id, ItemId = item.ItemId, SlotId = slot.Id });
                available.Remove(item);
            }
            return plan;
        }
    }
}
