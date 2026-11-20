using System;
using System.Collections.Generic;
using System.Linq;
namespace Zatod.Heroes
{
    public static class ZatodSaveMigration
    {
        public static void Apply(CharacterData account,HeroCatalog catalog)
        {
            if(!catalog.Data.Heroes.Any(h=>h.SourceUnitId>0))return;
            account.RetiredHeroDesk=account.RetiredHeroDesk??new List<HeroData>();
            account.RetiredInventory=account.RetiredInventory??new List<ItemData>();
            account.RetiredFormationIds=account.RetiredFormationIds??new List<string>();
            foreach(var hero in account.HeroDesk.ToArray())
            {
                hero.HeroDefinitionId=ZatodContentIds.Canonical(hero.HeroDefinitionId);
                foreach(var item in hero.EquippedItems)item.ItemId=ZatodContentIds.Canonical(item.ItemId);
                foreach(var item in hero.AbsorbedItems)item.ItemId=ZatodContentIds.Canonical(item.ItemId);
                if(!catalog.Data.Heroes.Any(h=>h.Id==hero.HeroDefinitionId))
                {account.HeroDesk.Remove(hero);account.RetiredHeroDesk.Add(hero);}
            }
            foreach(var item in account.Inventory.ToArray())
            {
                item.ItemId=ZatodContentIds.Canonical(item.ItemId);
                if(!catalog.Data.Items.Any(i=>i.DefinitionId==item.ItemId))
                {account.Inventory.Remove(item);account.RetiredInventory.Add(item);}
            }
            if(account.Formation!=null)
                foreach(string id in account.Formation.HeroInstanceIds.ToArray())
                    if(!account.HeroDesk.Any(h=>h.HeroInstanceId==id))
                    {account.Formation.HeroInstanceIds.Remove(id);if(!account.RetiredFormationIds.Contains(id))account.RetiredFormationIds.Add(id);}
            if(account.HeroDesk.Count==0 && account.RetiredHeroDesk.Count>0)
                foreach(int sourceId in new[]{1,2,3,4,45})
                    account.HeroDesk.Add(catalog.CreateHero(ZatodContentIds.Unit(sourceId),Guid.NewGuid().ToString("D")));
        }
    }
}
