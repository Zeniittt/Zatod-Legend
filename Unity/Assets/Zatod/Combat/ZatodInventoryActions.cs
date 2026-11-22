using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;
namespace Zatod.Combat
{
    public sealed partial class ZatodPlayerSession
    {
        public ItemOperationReceipt ExecuteInventory(string command,string target,int level,string preview,string operationId,Action persist=null)
        {
            if(!Guid.TryParseExact(operationId,"D",out var op)||op==Guid.Empty)throw new ArgumentException("Item operation requires a GUID.");
            operationId=op.ToString("D");string key=command+"\n"+target+"\n"+level+"\n"+preview;
            Account.ItemOperations=Account.ItemOperations??new List<ItemOperationReceipt>();
            var old=Account.ItemOperations.SingleOrDefault(x=>x.OperationId==operationId);
            if(old!=null){if(old.RequestKey!=key)throw new ArgumentException("Operation ID reused with a different request.");return old;}
            if(issued.Count>0)throw new ArgumentException("Finish or cancel the battle before changing items.");
            new ItemInventory(Account,catalog).Validate();
            var planner=new InventoryCatalog(catalog);InventoryPlan plan;
            switch(command)
            {
                case "sell":plan=planner.Sell(Account,target,level==0?1:level);break;
                case "quick_craft":plan=planner.QuickCraft(Account,(target??"").Split('|'));break;
                case "use_exp":plan=planner.Exp(Account,target,level,progression);break;
                case "recruit":plan=planner.Stone(Account,target,true);break;
                case "star_up":plan=planner.Stone(Account,target,false);break;
                default:throw new ArgumentException("Unknown inventory action.");
            }
            if(preview!=InventoryCatalog.Signature(plan))throw new ArgumentException("Inventory changed. Review the updated preview.");
            if(CurrencyBalance.GetGold(Account)<plan.GoldCost)throw new ArgumentException("Not enough gold.");
            var economy=new EconomyCheckpoint(Account);var inventory=Account.Inventory.ToList();var heroes=Account.HeroDesk.ToList();
            var stars=heroes.ToDictionary(h=>h.HeroInstanceId,h=>h.Stars,StringComparer.Ordinal);ItemOperationReceipt receipt=null;
            try
            {
                receipt=new ItemOperationReceipt{OperationId=operationId,Command=command,RequestKey=key,HeroId=plan.HeroId,ItemInstanceId=plan.ItemInstanceId,GoldCharged=plan.GoldCost,GoldReceived=plan.GoldReward};
                CurrencyBalance.AddGold(Account,checked(plan.GoldReward-plan.GoldCost));
                foreach(var item in plan.Consumed){if(!Account.Inventory.Remove(item))throw new ArgumentException("Item is no longer owned.");receipt.Consumed.Add(new ItemData{Id=item.Id,ItemId=item.ItemId});}
                foreach(var output in plan.Outputs)
                    for(int n=0;n<output.Amount;n++){var item=new ItemData{Id=Guid.NewGuid().ToString("D"),ItemId=output.ItemId};Account.Inventory.Add(item);receipt.Created.Add(item);}
                if(command=="use_exp")receipt.Experience=progression.AddHeroExp(Account,Account.HeroDesk.Single(x=>x.HeroInstanceId==target),plan.Experience);
                if(command=="recruit")
                {
                    var h=catalog.CreateHero(target,Guid.NewGuid().ToString("D"));h.Stars=catalog.Hero(target).InitialStars;
                    Account.HeroDesk.Add(h);receipt.HeroId=h.HeroInstanceId;
                }
                if(command=="star_up")Account.HeroDesk.Single(x=>x.HeroDefinitionId==target).Stars++;
                receipt.Revision=++Account.Revision;Account.ItemOperations.Add(receipt);
                new ItemInventory(Account,catalog).Validate();persist?.Invoke();return receipt;
            }
            catch
            {
                Account.HeroDesk=heroes;foreach(var h in heroes)h.Stars=stars[h.HeroInstanceId];economy.Restore();Account.Inventory=inventory;
                if(receipt!=null)Account.ItemOperations.Remove(receipt);throw;
            }
        }
    }
}
