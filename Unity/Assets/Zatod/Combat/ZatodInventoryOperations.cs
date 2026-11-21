using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;
namespace Zatod.Combat
{
    public sealed partial class ZatodPlayerSession
    {
        public ItemOperationReceipt Craft(string recipeId,string operationId,Action persistOwned=null)
            =>InventoryOperation("craft",null,null,null,recipeId,operationId,persistOwned);
        public ItemOperationReceipt EquipItem(string heroId,string slotId,string guid,string operationId,Action persistOwned=null)
            =>InventoryOperation("equip",heroId,slotId,guid,null,operationId,persistOwned);
        ItemOperationReceipt InventoryOperation(string command,string heroId,string slotId,string guid,string recipeId,string operationId,Action persist)
        {
            if(!Guid.TryParseExact(operationId,"D",out var parsed)||parsed==Guid.Empty)throw new ArgumentException("Item operation requires a GUID.");
            operationId=parsed.ToString("D");
            Account.ItemOperations=Account.ItemOperations??new List<ItemOperationReceipt>();
            var previous=Account.ItemOperations.SingleOrDefault(o=>o.OperationId==operationId);
            if(previous!=null)
            {
                if(previous.Command!=command||previous.HeroId!=heroId||previous.SlotId!=slotId||previous.ItemInstanceId!=guid||previous.RecipeId!=recipeId)throw new ArgumentException("Operation ID reused with a different request.");
                return previous;
            }
            if(issued.Count>0)throw new ArgumentException("Finish or cancel the battle before changing items.");
            var inventory=Account.Inventory.ToList();var equipment=Account.HeroDesk.ToDictionary(h=>h.HeroInstanceId,h=>h.EquippedItems.ToList());long revision=Account.Revision;
            ItemOperationReceipt receipt=null;
            try
            {
                if(command=="craft")receipt=new CraftingCatalog(catalog).Craft(Account,recipeId);
                else {new ItemInventory(Account,catalog).Equip(heroId,slotId,guid);receipt=new ItemOperationReceipt();}
                receipt.OperationId=operationId;receipt.Command=command;receipt.HeroId=heroId;receipt.SlotId=slotId;receipt.ItemInstanceId=guid;receipt.RecipeId=recipeId;receipt.Revision=++Account.Revision;
                Account.ItemOperations.Add(receipt);persist?.Invoke();return receipt;
            }
            catch
            {
                Account.Inventory=inventory;foreach(var h in Account.HeroDesk)h.EquippedItems=equipment[h.HeroInstanceId];Account.Revision=revision;
                if(receipt!=null)Account.ItemOperations.Remove(receipt);throw;
            }
        }
    }
}
