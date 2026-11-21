using System;
using System.Collections.Generic;
using System.Linq;
namespace Zatod.Heroes
{
    public enum ItemKind { Equipment, Fragment, Material }
    [Serializable] public sealed class CraftIngredient { public string ItemId; public int Amount=1; }
    [Serializable] public sealed class CraftRecipeDefinition
    {
        public string Id,OutputItemId; public int SourceItemId,OutputAmount=1; public long GoldCost;
        public List<CraftIngredient> Ingredients=new List<CraftIngredient>();
    }
    [Serializable] public sealed class ItemOperationReceipt
    {
        public string OperationId,Command,HeroId,SlotId,ItemInstanceId,RecipeId;
        public long Revision,GoldCharged;
        public List<ItemData> Consumed=new List<ItemData>(),Created=new List<ItemData>();
    }
    // A recipe names types. Executing it consumes distinct, owned instances.
    public sealed class CraftingCatalog
    {
        readonly HeroCatalog catalog;
        readonly Dictionary<string,CraftRecipeDefinition> byId,byOutput;
        public CraftingCatalog(HeroCatalog catalog)
        {
            this.catalog=catalog;
            var recipes=catalog.Data.CraftRecipes??new List<CraftRecipeDefinition>();
            byId=new Dictionary<string,CraftRecipeDefinition>(StringComparer.Ordinal);byOutput=new Dictionary<string,CraftRecipeDefinition>(StringComparer.Ordinal);
            foreach(var recipe in recipes)
            {
                HeroCatalog.Require(recipe!=null && !string.IsNullOrWhiteSpace(recipe.Id),"Craft recipe ID is required.");
                HeroCatalog.Require(!byId.ContainsKey(recipe.Id) && !byOutput.ContainsKey(recipe.OutputItemId??""),"Duplicate recipe ID or output.");
                catalog.Item(recipe.OutputItemId);
                HeroCatalog.Require(recipe.OutputAmount>0 && recipe.OutputAmount<=100 && recipe.GoldCost>=0,"Invalid craft output or cost.");
                HeroCatalog.Require(recipe.Ingredients!=null && recipe.Ingredients.Count>0 && recipe.Ingredients.Count<=16,"Craft needs ingredients.");
                foreach(var ingredient in recipe.Ingredients)
                {HeroCatalog.Require(ingredient!=null && ingredient.Amount>0 && ingredient.Amount<=10000,"Invalid ingredient amount.");catalog.Item(ingredient.ItemId);}
                // Consolidate repeated type requirements without changing the authoring records.
                Requirements(recipe);
                byId.Add(recipe.Id,recipe);byOutput.Add(recipe.OutputItemId,recipe);
            }
            var visiting=new HashSet<string>();var done=new HashSet<string>();
            void Visit(string item)
            {
                if(done.Contains(item)||!byOutput.TryGetValue(item,out var recipe))return;
                HeroCatalog.Require(visiting.Add(item),"Craft recipe cycle: "+item);
                foreach(var i in recipe.Ingredients)Visit(i.ItemId);
                visiting.Remove(item);done.Add(item);
            }
            foreach(var output in byOutput.Keys)Visit(output);
        }
        public CraftRecipeDefinition Recipe(string id)=>byId.TryGetValue(id??"",out var recipe)?recipe:throw new ArgumentException("Unknown craft recipe: "+id);
        public CraftRecipeDefinition ForItem(string id)=>byOutput.TryGetValue(id??"",out var recipe)?recipe:null;
        public static Dictionary<string,int> Requirements(CraftRecipeDefinition recipe)
        {var result=new Dictionary<string,int>(StringComparer.Ordinal);foreach(var i in recipe.Ingredients)result[i.ItemId]=checked((result.TryGetValue(i.ItemId,out int n)?n:0)+i.Amount);return result;}
        public bool CanCraft(CharacterData account,string id)
        {return Requirements(Recipe(id)).All(i=>account.Inventory.Count(x=>x.ItemId==i.Key)>=i.Value);}
        public ItemOperationReceipt Craft(CharacterData account,string id)
        {
            var recipe=Recipe(id);new ItemInventory(account,catalog).Validate();
            var consumed=new List<ItemData>();
            foreach(var i in Requirements(recipe))
            {
                var owned=account.Inventory.Where(x=>x.ItemId==i.Key).OrderBy(x=>x.Id,StringComparer.Ordinal).Take(i.Value).ToArray();
                HeroCatalog.Require(owned.Length==i.Value,"Not enough ingredients: "+catalog.Item(i.Key).Name);consumed.AddRange(owned);
            }
            var created=Enumerable.Range(0,recipe.OutputAmount).Select(_=>new ItemData{Id=Guid.NewGuid().ToString("D"),ItemId=recipe.OutputItemId}).ToList();
            foreach(var item in consumed)account.Inventory.Remove(item);account.Inventory.AddRange(created);
            // D28: prototype bypasses gold only; keep the original GoldCost in config.
            return new ItemOperationReceipt{RecipeId=id,GoldCharged=0,Consumed=consumed,Created=created};
        }
    }
}
