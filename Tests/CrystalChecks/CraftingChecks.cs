using System;
using System.IO;
using System.Linq;
using System.Text.Json;
using Zatod.Heroes;
using Zatod.Combat;
static partial class Program
{
    static void CraftingChecks()
    {
        var catalog=ImportedCatalog();var crafting=new CraftingCatalog(catalog);
        Check(catalog.Data.CraftRecipes.Count>47,"Missing recursive recipes");
        Check(catalog.Item(crafting.ForItem("shortsword").Ingredients[0].ItemId).ItemKind==ItemKind.Fragment,"Fragment metadata");
        var campaign=new CampaignCatalog(Read<CampaignDefinition>((BundledData+"/Campaigns.txt")),catalog);
        var owned=campaign.CreateDemoCharacter(catalog);owned.CharacterId=Guid.NewGuid().ToString("D");var session=new ZatodPlayerSession(catalog,campaign,Guid.NewGuid().ToString("D"),owned);var inventory=new ItemInventory(owned,catalog);
        var recipe=crafting.ForItem("green_boots");Check(recipe.GoldCost==1200 && recipe.Ingredients.Count==3,"Source boot formula");
        foreach(var i in recipe.Ingredients)inventory.AddItemByItemId(i.ItemId,i.Amount);
        CurrencyBalance.AddGold(owned,1000000);var extra=inventory.AddItemByItemId("boots")[0];string operation=Guid.NewGuid().ToString("D");
        string Before()=>JsonSerializer.Serialize(owned,Json);
        var before=Before();try{session.Craft(recipe.Id,operation,()=>throw new IOException("Test save failure"));throw new Exception("Save failure not propagated");}catch(IOException){}
        Check(Before()==before,"Craft rollback changed account");int saves=0;var receipt=session.Craft(recipe.Id,operation,()=>saves++);
        Check(receipt.Consumed.Count==3 && receipt.Created.Count==1 && receipt.GoldCharged==1200 && CurrencyBalance.GetGold(owned)==998800,"Craft contents or gold expense");
        Check(owned.Inventory.Count==2 && owned.Inventory.Count(i=>i.ItemId=="boots")==1 && receipt.Consumed.Select(i=>i.Id).Distinct().Count()==3,"Craft used an extra GUID");
        Check(receipt.Created.All(i=>Guid.TryParseExact(i.Id,"D",out _)) && !receipt.Consumed.Any(i=>i.Id==receipt.Created[0].Id),"Craft GUIDs");
        Check(session.Craft(recipe.Id,operation.ToUpperInvariant(),()=>saves++).Created[0].Id==receipt.Created[0].Id && saves==1,"Duplicate or differently cased operation repeated");
        Reject(()=>session.Craft("shortsword_recipe",operation),"Operation ID payload reuse");
        var saved=JsonSerializer.Deserialize<CharacterData>(Before(),Json);var reloaded=new ZatodPlayerSession(catalog,campaign,Guid.NewGuid().ToString("D"),saved);
        Check(reloaded.Craft(recipe.Id,operation).Created[0].Id==receipt.Created[0].Id && saved.Inventory.Count==2,"Retry after reload minted items");
        Reject(()=>session.Craft(recipe.Id,Guid.NewGuid().ToString("D")),"Craft with missing material");
        var sword=crafting.ForItem("shortsword");Check(sword.Ingredients.Single().Amount==5,"Fragment recipe count");
        inventory.AddItemByItemId(sword.Ingredients[0].ItemId,4);Reject(()=>session.Craft(sword.Id,Guid.NewGuid().ToString("D")),"Craft with four of five fragments");inventory.AddItemByItemId(sword.Ingredients[0].ItemId);
        var shards=session.Craft(sword.Id,Guid.NewGuid().ToString("D"));Check(shards.Consumed.Count==5 && shards.Created.Count==1,"Fragment GUID consumption");
        var hero=owned.HeroDesk[0];var slot=HeroProgression.CurrentRank(hero,catalog).EquipmentSlots[0];var item=inventory.AddItemByItemId(slot.RequiredItemId)[0];hero.Level=40;operation=Guid.NewGuid().ToString("D");before=Before();
        try{session.EquipItem(hero.HeroInstanceId,slot.Id,item.Id,operation,()=>throw new IOException("Test equip save failure"));throw new Exception("Equip save failure not propagated");}catch(IOException){}
        Check(Before()==before,"Equip rollback changed GUID locations");session.EquipItem(hero.HeroInstanceId,slot.Id,item.Id,operation);Check(hero.EquippedItems.Single(i=>i.SlotId==slot.Id).Id==item.Id && !owned.Inventory.Any(i=>i.Id==item.Id),"Equip did not keep GUID");
        int count=owned.ItemOperations.Count;session.EquipItem(hero.HeroInstanceId,slot.Id,item.Id,operation);Check(owned.ItemOperations.Count==count,"Repeated equip committed twice");
        session.BeginCampaign("chapter_one_stage_1",owned.HeroDesk.Take(5).Select(h=>h.HeroInstanceId),123,Guid.NewGuid().ToString("N"));Reject(()=>session.Craft(sword.Id,Guid.NewGuid().ToString("D")),"Craft during issued battle");session.CancelCampaign();
        HeroCatalogData Copy()=>JsonSerializer.Deserialize<HeroCatalogData>(JsonSerializer.Serialize(catalog.Data,Json),Json);
        var invalid=Copy();invalid.CraftRecipes[0].Ingredients[0].Amount=0;Reject(()=>new HeroCatalog(invalid),"Zero ingredient amount");
        invalid=Copy();invalid.CraftRecipes[0].Ingredients[0].ItemId="missing";Reject(()=>new HeroCatalog(invalid),"Missing ingredient reference");
        invalid=Copy();invalid.CraftRecipes[0].Ingredients[0].ItemId=invalid.CraftRecipes[0].OutputItemId;Reject(()=>new HeroCatalog(invalid),"Recipe self cycle");
        invalid=Copy();invalid.CraftRecipes.Add(invalid.CraftRecipes[0]);Reject(()=>new HeroCatalog(invalid),"Duplicate recipe");
        var repeated=crafting.ForItem("vital_shield");Check(repeated.Ingredients.Single(i=>i.ItemId=="stockings_of_agility").Amount==2,"Repeated source ingredient was not consolidated");
        new ItemInventory(owned,catalog).Validate();
    }
}
