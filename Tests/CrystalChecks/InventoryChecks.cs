using System;
using System.Linq;
using Zatod.Heroes;
using Zatod.Combat;
partial class Program
{
    static void InventoryChecks()
    {
        Check(GuestIdentity.Name("  An   Nguyễn  ")=="An Nguyễn","Guest display name normalization");
        Check(GuestIdentity.Name("  A\u0301nh  ")=="Ánh","Guest Unicode composed name");
        foreach(var bad in new[]{"", "   ", "<color=red>Admin", new string('x',25), "one\n<sprite=0>"})
        {bool rejected=false;try{GuestIdentity.Name(bad);}catch(ArgumentException){rejected=true;}Check(rejected,"Invalid guest name rejected");}
        var c=ImportedCatalog();var p=new ProgressionCatalog(Read<ProgressionDefinition>("Unity/Assets/Zatod/Resources/Data/Progression.txt"));
        var campaign=new CampaignCatalog(Read<CampaignDefinition>("Unity/Assets/Zatod/Resources/Data/Campaigns.txt"),c);
        var a=campaign.CreateDemoCharacter(c);p.Initialize(a,1000);CurrencyBalance.AddGold(a,10000000);var inv=new ItemInventory(a,c);var planner=new InventoryCatalog(c);
        var session=new ZatodPlayerSession(c,campaign,Guid.NewGuid().ToString("D"),a,progression:p);
        Check(c.Data.Items.Count==142&&c.Data.StarRules.Count==5,"Inventory metadata/Soulstone coverage");
        var before=c.CreateHero("coco","bonus-check");var original=c.Item("boxing_gloves_of_strength");
        Check(original.PreciseStats.All(x=>x.StatId!="damage")&&original.PreciseStats.Single(x=>x.StatId=="health").Value==54,"Removed bonus must not turn into a universal bonus");
        var sale=inv.AddItemByItemId("boxing_gloves_of_strength")[0];var plan=planner.Sell(a,sale.Id);long gold=CurrencyBalance.GetGold(a),revision=a.Revision;string op=Guid.NewGuid().ToString("D");
        bool failed=false;try{session.ExecuteInventory("sell",sale.Id,0,InventoryCatalog.Signature(plan),op,()=>throw new Exception("disk"));}catch{failed=true;}
        Check(failed&&a.Inventory.Any(x=>x.Id==sale.Id)&&CurrencyBalance.GetGold(a)==gold&&a.Revision==revision,"Sell rollback gold/GUID/revision");
        var receipt=session.ExecuteInventory("sell",sale.Id,0,InventoryCatalog.Signature(plan),op);Check(!a.Inventory.Any(x=>x.Id==sale.Id)&&CurrencyBalance.GetGold(a)==gold+original.SellPrice,"Sell proceeds");
        Check(ReferenceEquals(receipt,session.ExecuteInventory("sell",sale.Id,0,InventoryCatalog.Signature(plan),op)),"Sell retry must return same receipt");
        failed=false;try{session.ExecuteInventory("sell","wrong",0,"wrong",op);}catch{failed=true;}Check(failed,"Operation payload reuse rejected");
        var r=c.Data.CraftRecipes.First(x=>x.Ingredients.Count==1&&c.Item(x.Ingredients[0].ItemId).ItemKind==ItemKind.Fragment);var need=r.Ingredients[0];a.Inventory.Clear();inv.AddItemByItemId(need.ItemId,need.Amount*2+1);
        plan=planner.QuickCraft(a,new[]{r.Id});gold=CurrencyBalance.GetGold(a);op=Guid.NewGuid().ToString("D");
        failed=false;try{session.ExecuteInventory("quick_craft",r.Id,0,InventoryCatalog.Signature(plan),op,()=>throw new Exception("disk"));}catch{failed=true;}
        Check(failed&&a.Inventory.Count==need.Amount*2+1&&CurrencyBalance.GetGold(a)==gold,"Quick Craft rollback whole batch");
        session.ExecuteInventory("quick_craft",r.Id,0,InventoryCatalog.Signature(plan),op);
        Check(a.Inventory.Count(x=>x.ItemId==need.ItemId)==1&&a.Inventory.Count(x=>x.ItemId==r.OutputItemId)==2*r.OutputAmount&&CurrencyBalance.GetGold(a)==gold-2*r.GoldCost,"Quick Craft maximum direct output with remainder");
        Check(a.Inventory.Select(x=>x.Id).Distinct().Count()==a.Inventory.Count,"Batch output GUID uniqueness");
        var hero=a.HeroDesk.First();hero.Level=1;hero.Exp=0;a.Inventory.Clear();inv.AddItemByItemId("exp_potion",10);inv.AddItemByItemId("exp_pizza",1);
        plan=planner.Exp(a,hero.HeroInstanceId,2,p);Check(plan.Consumed.All(x=>x.ItemId=="exp_potion")&&plan.TargetLevel>=2,"EXP must use small items first and show actual level");
        op=Guid.NewGuid().ToString("D");revision=a.Revision;failed=false;try{session.ExecuteInventory("use_exp",hero.HeroInstanceId,plan.TargetLevel,InventoryCatalog.Signature(plan),op,()=>throw new Exception("disk"));}catch{failed=true;}
        Check(failed&&hero.Level==1&&hero.Exp==0&&a.Inventory.Count==11&&a.Revision==revision,"EXP rollback level/EXP/GUIDs");
        session.ExecuteInventory("use_exp",hero.HeroInstanceId,plan.TargetLevel,InventoryCatalog.Signature(plan),op);Check(hero.Level>=2&&a.Inventory.Any(x=>x.ItemId=="exp_pizza"),"EXP granted and large item retained");
        var stale=planner.Sell(a,a.Inventory.First().Id);a.Revision++;failed=false;try{session.ExecuteInventory("sell",stale.ItemInstanceId,0,InventoryCatalog.Signature(stale),Guid.NewGuid().ToString("D"));}catch{failed=true;}Check(failed,"Stale preview must be rejected");
        hero.Level=p.Player(a.Level).MaxHeroLevel;failed=false;try{planner.Exp(a,hero.HeroInstanceId,hero.Level+1,p);}catch{failed=true;}Check(failed,"EXP cap consumes no item");
        var d=c.Data.Heroes.First(x=>a.HeroDesk.All(h=>h.HeroDefinitionId!=x.Id));inv.AddItemByItemId(d.SoulstoneItemId,planner.Rule(d.InitialStars).SummonStones);
        plan=planner.Stone(a,d.Id,true);op=Guid.NewGuid().ToString("D");int heroes=a.HeroDesk.Count;gold=CurrencyBalance.GetGold(a);
        failed=false;try{session.ExecuteInventory("recruit",d.Id,0,InventoryCatalog.Signature(plan),op,()=>throw new Exception("disk"));}catch{failed=true;}
        Check(failed&&a.HeroDesk.Count==heroes&&CurrencyBalance.GetGold(a)==gold,"Recruit rollback must remove new Hero");
        receipt=session.ExecuteInventory("recruit",d.Id,0,InventoryCatalog.Signature(plan),op);var created=a.HeroDesk.Single(x=>x.HeroDefinitionId==d.Id);
        Check(created.Stars==d.InitialStars&&created.Level==1&&created.Exp==0&&Guid.TryParse(created.HeroInstanceId,out _),"Recruit initial progress and unique identity");
        Check(ReferenceEquals(receipt,session.ExecuteInventory("recruit",d.Id,0,InventoryCatalog.Signature(plan),op))&&a.HeroDesk.Count==heroes+1,"Recruit retry must not create second Hero");
        failed=false;try{planner.Stone(a,d.Id,true);}catch{failed=true;}Check(failed,"Cannot recruit an owned Hero");
        Check(!planner.HasUpgradeStones(a,created),"No badge below next-star requirement");
        int oldStar=created.Stars;inv.AddItemByItemId(d.SoulstoneItemId,planner.Rule(oldStar+1).UpgradeStones);Check(planner.HasUpgradeStones(a,created),"Badge at exact next-star threshold");plan=planner.Stone(a,d.Id,false);op=Guid.NewGuid().ToString("D");
        failed=false;try{session.ExecuteInventory("star_up",d.Id,0,InventoryCatalog.Signature(plan),op,()=>throw new Exception("disk"));}catch{failed=true;}
        Check(failed&&created.Stars==oldStar,"Star Up rollback");session.ExecuteInventory("star_up",d.Id,0,InventoryCatalog.Signature(plan),op);
        Check(created.Stars==oldStar+1&&created.RankId==d.StartingRankId&&created.Level==1,"Star Up must preserve other progress");
        Check(!planner.HasUpgradeStones(a,created),"Consumed stones remove upgrade badge");
        created.Stars=5;Check(!planner.HasUpgradeStones(a,created),"Max star Hero has no upgrade badge");failed=false;try{planner.Stone(a,d.Id,false);}catch{failed=true;}Check(failed,"Max star cap");
        var offered=inv.AddItemByItemId("boxing_gloves_of_strength")[0];plan=planner.Sell(a,offered.Id);CurrencyBalance.Gold(a).Amount=0;
        new ItemInventory(a,c).Validate();
        var batchAccount=campaign.CreateDemoCharacter(c);p.Initialize(batchAccount,1000);var batchInv=new ItemInventory(batchAccount,c);
        var batchRows=c.Data.CraftRecipes.Where(x=>x.Ingredients.Count==1&&c.Item(x.Ingredients[0].ItemId).ItemKind==ItemKind.Fragment).Take(2).ToArray();
        foreach(var row in batchRows)batchInv.AddItemByItemId(row.Ingredients[0].ItemId,row.Ingredients[0].Amount*2);
        var batchPlan=planner.QuickCraft(batchAccount,batchRows.Select(x=>x.Id));var ids=batchAccount.Inventory.Select(x=>x.Id).ToArray();
        var batchSession=new ZatodPlayerSession(c,campaign,Guid.NewGuid().ToString("D"),batchAccount,progression:p);
        failed=false;try{batchSession.ExecuteInventory("quick_craft",batchPlan.TargetId,0,InventoryCatalog.Signature(batchPlan),Guid.NewGuid().ToString("D"));}catch{failed=true;}
        Check(failed&&batchAccount.Inventory.Select(x=>x.Id).SequenceEqual(ids)&&batchAccount.ItemOperations.Count==0,"Insufficient gold must not partially craft a multi-row batch");
        CurrencyBalance.AddGold(batchAccount,10000000);batchPlan=planner.QuickCraft(batchAccount,batchRows.Select(x=>x.Id));
        failed=false;try{batchSession.ExecuteInventory("quick_craft",batchPlan.TargetId,0,InventoryCatalog.Signature(batchPlan),Guid.NewGuid().ToString("D"),()=>throw new Exception("disk"));}catch{failed=true;}
        Check(failed&&batchAccount.Inventory.Select(x=>x.Id).SequenceEqual(ids)&&CurrencyBalance.GetGold(batchAccount)==10000000,"Multi-row batch rollback preserves all original GUIDs");
        var grouped=InventoryCatalog.Stacks(batchAccount);Check(grouped.Count==2&&grouped.Sum(x=>x.Amount)==batchAccount.Inventory.Count,"Stack projection counts all instances");
        Check(grouped.SelectMany(x=>x.InstanceIds).OrderBy(x=>x).SequenceEqual(batchAccount.Inventory.Select(x=>x.Id).OrderBy(x=>x)),"Stack projection must retain every original GUID");
        var stackSale=batchInv.AddItemByItemId("boxing_gloves_of_strength",5);var salePlan=planner.Sell(batchAccount,stackSale[2].Id,3);var allIds=stackSale.Select(x=>x.Id).ToArray();long initialGold=CurrencyBalance.GetGold(batchAccount);string sellOp=Guid.NewGuid().ToString("D");
        failed=false;try{batchSession.ExecuteInventory("sell",stackSale[2].Id,3,InventoryCatalog.Signature(salePlan),sellOp,()=>throw new Exception("disk"));}catch{failed=true;}
        Check(failed&&allIds.All(id=>batchAccount.Inventory.Any(x=>x.Id==id))&&CurrencyBalance.GetGold(batchAccount)==initialGold,"Stack sale rollback preserves all GUIDs");
        var stackReceipt=batchSession.ExecuteInventory("sell",stackSale[2].Id,3,InventoryCatalog.Signature(salePlan),sellOp);
        Check(stackReceipt.Consumed.Count==3&&stackReceipt.Consumed.Any(x=>x.Id==stackSale[2].Id)&&batchAccount.Inventory.Count(x=>x.ItemId=="boxing_gloves_of_strength")==2,"Stack sale consumes exactly selected quantity and selected GUID");
        Check(CurrencyBalance.GetGold(batchAccount)==initialGold+3*c.Item("boxing_gloves_of_strength").SellPrice,"Stack sale price");
        Check(ReferenceEquals(stackReceipt,batchSession.ExecuteInventory("sell",stackSale[2].Id,3,InventoryCatalog.Signature(salePlan),sellOp)),"Stack sale retry not idempotent");
        failed=false;try{planner.Sell(batchAccount,batchAccount.Inventory.First(x=>x.ItemId=="boxing_gloves_of_strength").Id,3);}catch{failed=true;}Check(failed,"Cannot sell more than stack contains");
        c.Data.MaxHeroStars=4;failed=false;try{planner.Rule(5);}catch{failed=true;}Check(failed,"Editable star cap must be enforced");c.Data.MaxHeroStars=5;
        c.Data.MaxHeroStars=0;failed=false;try{new HeroCatalog(c.Data);}catch{failed=true;}Check(failed,"Invalid star cap must fail config validation");c.Data.MaxHeroStars=5;
    }
}
