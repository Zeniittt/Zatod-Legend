using System;
using System.Collections.Generic;
using System.Linq;

namespace Zatod.Heroes
{
    // Owns the transition between an inventory instance and a Hero equipment slot.
    // Call from the server/account owner; never resolve an item instance by type alone.
    public sealed class ItemInventory
    {
        readonly CharacterData character;
        readonly HeroCatalog catalog;

        public ItemInventory(CharacterData character, HeroCatalog catalog)
        {
            this.character = character ?? throw new ArgumentNullException(nameof(character));
            this.catalog = catalog ?? throw new ArgumentNullException(nameof(catalog));
            Validate();
        }

        public IReadOnlyList<ItemData> AddItemByItemId(string itemId, int amount = 1)
        {
            catalog.Item(itemId);
            if (amount < 1) throw new ArgumentOutOfRangeException(nameof(amount));
            Validate();
            var created = new List<ItemData>();
            for (int i = 0; i < amount; i++)
                created.Add(new ItemData { Id = Guid.NewGuid().ToString("D"), ItemId = itemId });
            character.Inventory.AddRange(created);
            return created.AsReadOnly();
        }

        public void Equip(string heroInstanceId, string slotId, string itemInstanceId)
        {
            Validate();
            var hero = character.HeroDesk.SingleOrDefault(h => h.HeroInstanceId == heroInstanceId);
            HeroCatalog.Require(hero != null, "Hero is not owned by this character.");
            catalog.ValidateHero(hero);
            var item = character.Inventory.SingleOrDefault(i => i.Id == itemInstanceId);
            HeroCatalog.Require(item != null, "Item instance is not in this inventory.");
            var rank = HeroProgression.CurrentRank(hero, catalog);
            var slot = rank.EquipmentSlots.SingleOrDefault(s => s.Id == slotId);
            HeroCatalog.Require(slot != null && slot.RequiredItemId == item.ItemId, "Item does not match the current equipment slot.");
            HeroCatalog.Require(!hero.EquippedItems.Any(i => i.SlotId == slotId), "Equipment slot is occupied.");
            HeroCatalog.Require(hero.Level >= catalog.Item(item.ItemId).LevelRequirement, "Hero level is below the equipment requirement.");
            var equipped = new EquippedItemData { SlotId = slotId, ItemId = item.ItemId, Id = item.Id };
            hero.EquippedItems.Add(equipped);
            character.Inventory.Remove(item);
        }

        public void Promote(string heroInstanceId)
        {
            Validate();
            var hero = character.HeroDesk.SingleOrDefault(h => h.HeroInstanceId == heroInstanceId);
            HeroCatalog.Require(hero != null, "Hero is not owned by this character.");
            HeroProgression.Promote(hero, catalog);
        }

        public void Validate()
        {
            HeroCatalog.Require(character.Inventory != null && character.HeroDesk != null, "Inventory and HeroDesk are required.");
            var ids = new HashSet<Guid>();
            Action<string, string> validate = (id, type) =>
            {
                HeroCatalog.Require(Guid.TryParseExact(id, "D", out var guid) && guid != Guid.Empty, "Item instance needs a nonempty GUID in D format.");
                HeroCatalog.Require(ids.Add(guid), "An item instance exists in more than one location.");
                catalog.Item(type);
            };
            foreach (var item in character.Inventory)
            {
                HeroCatalog.Require(item != null, "Null inventory item.");
                validate(item.Id, item.ItemId);
            }
            foreach (var hero in character.HeroDesk)
            {
                catalog.ValidateHero(hero);
                foreach (var item in hero.EquippedItems)
                    validate(item.Id, item.ItemId);
                foreach (var item in hero.AbsorbedItems)
                {
                    HeroCatalog.Require(item.Quantity == 1, "A GUID item cannot represent multiple absorbed items.");
                    validate(item.Id, item.ItemId);
                }
            }
            // Retired records remain history, but their instance GUIDs cannot be reused.
            var retired=(character.RetiredInventory??new List<ItemData>()).Where(x=>x!=null).Select(x=>x.Id)
                .Concat((character.RetiredHeroDesk??new List<HeroData>()).Where(x=>x!=null).SelectMany(h=>
                    (h.EquippedItems??new List<EquippedItemData>()).Select(x=>x.Id)
                    .Concat((h.AbsorbedItems??new List<AbsorbedItemData>()).Select(x=>x.Id))));
            foreach(var id in retired)
                if(Guid.TryParseExact(id,"D",out var guid))HeroCatalog.Require(!ids.Contains(guid),"An active item GUID is reserved by retired history.");
        }
    }
}
