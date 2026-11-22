using System;
using System.Collections.Generic;
using System.Linq;
namespace Zatod.Heroes
{
    public enum InventoryTab { Items, Shards, Gears, Soulstones }
    public enum InventoryFilter { All, Common, Events, Precious, Cosmetic, Develop, Forged, Primal, Scroll }
    [Serializable] public sealed class StarRuleDefinition
    { public int Stars, SummonStones, UpgradeStones; public long SummonGold, UpgradeGold; }
    [Serializable] public sealed class InventoryPlan
    {
        public string Command, HeroId, ItemInstanceId, TargetId, Signature;
        public int TargetLevel, Amount; public long Revision, GoldCost, GoldReward, Experience;
        public List<ItemData> Consumed = new List<ItemData>();
        public List<CraftIngredient> Outputs = new List<CraftIngredient>();
    }
    // A transient stack projection. Ownership still contains one GUID per actual item.
    public sealed class InventoryStack
    {
        public string ItemId {get;}
        public IReadOnlyList<string> InstanceIds {get;}
        public int Amount=>InstanceIds.Count;
        public InventoryStack(string id,IEnumerable<string> guids){ItemId=id;InstanceIds=Array.AsReadOnly(guids.OrderBy(x=>x,StringComparer.Ordinal).ToArray());}
    }
    // Both preview and server use this planner. Plans never mutate an owned account.
    public sealed class InventoryCatalog
    {
        readonly HeroCatalog catalog;
        public InventoryCatalog(HeroCatalog catalog) { this.catalog = catalog; }
        public int MaxStars=>catalog.Data.MaxHeroStars;
        public static IReadOnlyList<InventoryStack> Stacks(CharacterData a)=>a.Inventory.GroupBy(x=>x.ItemId).Select(g=>new InventoryStack(g.Key,g.Select(x=>x.Id))).OrderBy(x=>x.ItemId,StringComparer.Ordinal).ToArray();
        public static void Validate(HeroCatalog c)
        {
            foreach(var i in c.Data.Items)
            {
                HeroCatalog.Require(Enum.IsDefined(typeof(InventoryTab),i.InventoryTab) && Enum.IsDefined(typeof(InventoryFilter),i.InventoryFilter) && i.SellPrice>=0 && i.HeroExpValue>=0,"Invalid inventory metadata: "+i.DefinitionId);
                if(i.InventoryFilter!=InventoryFilter.All)
                    HeroCatalog.Require(i.InventoryTab==InventoryTab.Items ? i.InventoryFilter>=InventoryFilter.Common&&i.InventoryFilter<=InventoryFilter.Develop : i.InventoryTab==InventoryTab.Gears&&i.InventoryFilter>=InventoryFilter.Forged,"Filter does not belong to tab: "+i.DefinitionId);
            }
            HeroCatalog.Require(c.Data.MaxHeroStars>=1&&c.Data.MaxHeroStars<=5,"Unsupported max Hero stars.");
            if(c.Data.StarRules.Count==0)return; // Legacy fixtures/replay catalogs have no Soulstone feature.
            HeroCatalog.Require(c.Data.StarRules.Count==5 && c.Data.StarRules.Select(x=>x.Stars).Distinct().Count()==5,"Need five unique star rules.");
            for(int s=1;s<=5;s++){var r=c.Data.StarRules.SingleOrDefault(x=>x.Stars==s);HeroCatalog.Require(r!=null&&r.SummonStones>0&&r.SummonGold>=0&&r.UpgradeStones>=0&&r.UpgradeGold>=0&&(s==1||r.UpgradeStones>0),"Invalid star rule.");}
            var links=new HashSet<string>(StringComparer.Ordinal);
            foreach(var h in c.Data.Heroes)
            {
                HeroCatalog.Require(h.InitialStars>=1&&h.InitialStars<=c.Data.MaxHeroStars&&!string.IsNullOrEmpty(h.SoulstoneItemId)&&links.Add(h.SoulstoneItemId),"Invalid Hero Soulstone link: "+h.Id);
                var i=c.Item(h.SoulstoneItemId);HeroCatalog.Require(i.ItemKind==ItemKind.Soulstone&&i.InventoryTab==InventoryTab.Soulstones,"Invalid Soulstone item.");
            }
        }
        public StarRuleDefinition Rule(int stars)=>stars<1||stars>MaxStars?throw new ArgumentException("Maximum stars reached."):catalog.Data.StarRules.SingleOrDefault(x=>x.Stars==stars)??throw new ArgumentException("Missing star rule.");
        public bool HasUpgradeStones(CharacterData a,HeroData hero)
        {
            if(hero==null||hero.Stars>=MaxStars||catalog.Data.StarRules.Count==0)return false;
            string item=catalog.Hero(hero.HeroDefinitionId).SoulstoneItemId;
            return !string.IsNullOrEmpty(item)&&a.Inventory.Count(i=>i.ItemId==item)>=Rule(hero.Stars+1).UpgradeStones;
        }
        public HeroDefinition StoneHero(string itemId)=>catalog.Data.Heroes.SingleOrDefault(x=>x.SoulstoneItemId==itemId)??throw new ArgumentException("Soulstone has no Hero.");
        static void Take(CharacterData a,InventoryPlan p,string item,int amount)
        {
            var selected=a.Inventory.Where(x=>x.ItemId==item&&!p.Consumed.Any(y=>y.Id==x.Id)).OrderBy(x=>x.Id,StringComparer.Ordinal).Take(amount).ToList();
            if(selected.Count!=amount)throw new ArgumentException("Not enough items: "+item);p.Consumed.AddRange(selected);
        }
        static InventoryPlan New(CharacterData a,string command)=>new InventoryPlan{Command=command,Revision=a.Revision};
        public InventoryPlan Sell(CharacterData a,string guid,int amount=1)
        {
            var item=a.Inventory.SingleOrDefault(x=>x.Id==guid)??throw new ArgumentException("Item is not in inventory.");
            var price=catalog.Item(item.ItemId).SellPrice;if(price<=0)throw new ArgumentException("This item cannot be sold.");
            if(amount<1)throw new ArgumentException("Choose a positive sale amount.");
            var p=New(a,"sell");p.ItemInstanceId=guid;p.Amount=amount;p.GoldReward=checked(price*amount);p.Consumed.Add(item);
            Take(a,p,item.ItemId,amount-1);return p;
        }
        public InventoryPlan QuickCraft(CharacterData a,IEnumerable<string> recipeIds)
        {
            var ids=(recipeIds??Array.Empty<string>()).ToArray();
            if(ids.Length<1||ids.Length>100||ids.Distinct(StringComparer.Ordinal).Count()!=ids.Length)throw new ArgumentException("Choose unique fragment recipes.");
            var p=New(a,"quick_craft");var crafting=new CraftingCatalog(catalog);
            foreach(var id in ids.OrderBy(x=>x,StringComparer.Ordinal))
            {
                var r=crafting.Recipe(id);var needs=CraftingCatalog.Requirements(r);
                if(needs.Count!=1||catalog.Item(needs.First().Key).ItemKind!=ItemKind.Fragment)throw new ArgumentException("Quick Craft only combines fragments directly.");
                var need=needs.First();int n=a.Inventory.Count(x=>x.ItemId==need.Key)/need.Value;
                if(n<1)throw new ArgumentException("Not enough fragments.");
                Take(a,p,need.Key,checked(n*need.Value));p.GoldCost=checked(p.GoldCost+n*r.GoldCost);p.Outputs.Add(new CraftIngredient{ItemId=r.OutputItemId,Amount=checked(n*r.OutputAmount)});
            }
            p.TargetId=string.Join("|",ids.OrderBy(x=>x,StringComparer.Ordinal));return p;
        }
        public InventoryPlan Exp(CharacterData a,string heroId,int target,ProgressionCatalog progression)
        {
            if(progression==null)throw new ArgumentException("Progression unavailable.");
            var h=a.HeroDesk.SingleOrDefault(x=>x.HeroInstanceId==heroId)??throw new ArgumentException("Hero is not owned.");
            int cap=progression.Player(a.Level).MaxHeroLevel;
            if(target<=h.Level||target>cap||h.Level>=cap)throw new ArgumentException("Choose an attainable higher level.");
            long gap=-h.Exp;for(int level=h.Level;level<target;level++)gap=checked(gap+progression.Hero(level).NextLevelExp);
            var p=New(a,"use_exp");p.HeroId=heroId;p.TargetLevel=target;
            foreach(var i in catalog.Data.Items.Where(x=>x.ItemKind==ItemKind.Consumable&&x.HeroExpValue>0).OrderBy(x=>x.HeroExpValue).ThenBy(x=>x.DefinitionId,StringComparer.Ordinal))
            {
                if(p.Experience>=gap)break;
                long need=(gap-p.Experience+i.HeroExpValue-1)/i.HeroExpValue;
                int n=(int)Math.Min(need,a.Inventory.Count(x=>x.ItemId==i.DefinitionId));
                Take(a,p,i.DefinitionId,n);p.Experience=checked(p.Experience+n*i.HeroExpValue);
            }
            if(p.Experience<gap)throw new ArgumentException("Not enough EXP items.");
            long exp=checked(h.Exp+p.Experience);int actual=h.Level;
            while(actual<cap&&exp>=progression.Hero(actual).NextLevelExp&&progression.Hero(actual).NextLevelExp>0){exp-=progression.Hero(actual).NextLevelExp;actual++;}
            p.TargetLevel=actual;return p;
        }
        public InventoryPlan Stone(CharacterData a,string definitionId,bool recruit)
        {
            var d=catalog.Hero(definitionId);var h=a.HeroDesk.SingleOrDefault(x=>x.HeroDefinitionId==definitionId);
            if(recruit&&h!=null)throw new ArgumentException("Hero is already owned.");
            if(!recruit&&h==null)throw new ArgumentException("Hero is not owned.");
            var r=Rule(recruit?d.InitialStars:h.Stars+1);var p=New(a,recruit?"recruit":"star_up");
            p.TargetId=definitionId;p.HeroId=h?.HeroInstanceId;p.GoldCost=recruit?r.SummonGold:r.UpgradeGold;
            Take(a,p,d.SoulstoneItemId,recruit?r.SummonStones:r.UpgradeStones);return p;
        }
        // Include state and exact GUIDs so a stale preview cannot silently consume different items.
        public static string Signature(InventoryPlan p)=>p.Revision+":"+p.Command+":"+p.HeroId+":"+p.ItemInstanceId+":"+p.TargetId+":"+p.TargetLevel+":"+p.Amount+":"+p.GoldCost+":"+p.GoldReward+":"+p.Experience+":"+string.Join(",",p.Consumed.Select(x=>x.Id).OrderBy(x=>x,StringComparer.Ordinal));
    }
}
