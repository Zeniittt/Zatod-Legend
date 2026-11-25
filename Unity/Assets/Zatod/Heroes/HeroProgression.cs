using System;
using System.Collections.Generic;
using System.Linq;

namespace Zatod.Heroes
{
    // Trusted progression primitives, not client-authoritative inventory transactions.
    // A future server inventory transaction must verify ownership and consume the item with Equip.
    public static class HeroProgression
    {
        public static void Equip(HeroData hero, HeroCatalog catalog, string slotId, string itemId)
        {
            catalog.ValidateHero(hero);
            var rank = CurrentRank(hero, catalog);
            var slot = rank.EquipmentSlots.SingleOrDefault(s => s.Id == slotId);
            HeroCatalog.Require(slot != null && slot.RequiredItemId == itemId, "Item does not match the current slot requirement.");
            HeroCatalog.Require(!hero.EquippedItems.Any(i => i.SlotId == slotId), "Slot is already equipped.");
            catalog.Item(itemId);
            HeroCatalog.Require(hero.Level >= catalog.Item(itemId).LevelRequirement, "Hero level is below the equipment requirement.");
            hero.EquippedItems.Add(new EquippedItemData { SlotId = slotId, ItemId = itemId, Id = Guid.NewGuid().ToString("D") });
        }

        public static HeroRankDefinition CurrentRank(HeroData hero, HeroCatalog catalog)
        {
            var path = catalog.RankPath(catalog.Hero(hero.HeroDefinitionId), hero.RankId);
            return path[path.Count - 1];
        }

        public static bool CanPromote(HeroData hero, HeroCatalog catalog)
        {
            catalog.ValidateHero(hero);
            var rank = CurrentRank(hero, catalog);
            return !string.IsNullOrEmpty(rank.NextRankId)
                && rank.EquipmentSlots.All(s => hero.EquippedItems.Any(i => i.SlotId == s.Id));
        }

        public static void Promote(HeroData hero, HeroCatalog catalog)
        {
            HeroCatalog.Require(CanPromote(hero, catalog), "Hero needs all equipment slots filled and a next rank.");
            var rank = CurrentRank(hero, catalog);
            var absorbed = new List<AbsorbedItemData>(hero.AbsorbedItems);
            foreach (var item in hero.EquippedItems)
                absorbed.Add(new AbsorbedItemData { RankId = rank.Id, SlotId = item.SlotId, ItemId = item.ItemId, Id = item.Id, Quantity = 1 });
            // Prepare before mutating; callers persist the completed operation as one save transaction.
            var emptySlots = new List<EquippedItemData>();
            hero.AbsorbedItems = absorbed;
            hero.EquippedItems = emptySlots;
            hero.RankId = rank.NextRankId;
        }

        public static List<HeroSkillSlotDefinition> UnlockedSkills(HeroData hero, HeroCatalog catalog)
        {
            catalog.ValidateHero(hero);
            var definition = catalog.Hero(hero.HeroDefinitionId);
            return UnlockedSkills(definition, catalog.RankPath(definition, hero.RankId));
        }

        public static List<HeroSkillSlotDefinition> UnlockedSkills(HeroDefinition definition, IEnumerable<HeroRankDefinition> path)
        {
            var unlocked = new HashSet<string>(path.SelectMany(rank => rank.UnlockSkillSlotIds), StringComparer.Ordinal);
            return definition.SkillSlots.Where(s => unlocked.Contains(s.Id)).ToList();
        }
    }
}
