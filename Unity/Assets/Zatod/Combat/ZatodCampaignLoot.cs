using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using Zatod.Heroes;

namespace Zatod.Combat
{
    [Serializable] public sealed class ZatodCampaignReward
    {
        public string BattleId, StageId;
        public EconomyBattleReceipt Economy;
        public List<ItemData> Items = new List<ItemData>();
    }

    // Server-only selection. Never draws from the deterministic combat RNG.
    public static class ZatodCampaignLoot
    {
        public static List<ZatodLootDrop> Assign(ZatodMatchDefinition match,IReadOnlyList<string> items)
        {
            var enemies=match.Waves.SelectMany((w,index)=>w.Enemies.Select(e=>new{Unit=e,Wave=index+1})).ToArray();
            var bosses=enemies.Where(e=>e.Unit.Boss).ToArray();var targets=bosses.Length>0?bosses:enemies;
            if(targets.Length==0 && items.Count>0)throw new ArgumentException("Loot needs an enemy spawn.");
            return items.Select((id,index)=>new ZatodLootDrop{Index=index,ItemId=id,Wave=targets[index%targets.Length].Wave,EntityId=targets[index%targets.Length].Unit.EntityId}).ToList();
        }
        public static List<string> Roll(CampaignStageDefinition stage)
        {
            using(var generator=RandomNumberGenerator.Create())
            {
                var bytes=new byte[4];
                uint Next(){generator.GetBytes(bytes);return BitConverter.ToUInt32(bytes,0);}
                int Bounded(int bound)
                {
                    ulong limit=(1UL<<32)/((uint)bound)*((uint)bound);
                    uint value;do{value=Next();}while((ulong)value>=limit);
                    return (int)(value%(uint)bound);
                }
                return Roll(stage,Bounded,()=>Next()/4294967296d);
            }
        }

        public static List<string> Roll(CampaignStageDefinition stage,Func<int,int> nextCount,Func<double> nextChoice)
        {
            if(stage==null || stage.MaxDropAmount<0 || stage.MaxDropAmount==int.MaxValue || stage.DropItems==null || stage.DropItems.Count==0)
                throw new ArgumentException("Invalid campaign loot config.");
            decimal total=0;
            foreach(var item in stage.DropItems)
            {
                if(item==null || string.IsNullOrWhiteSpace(item.ItemId) || double.IsNaN(item.DropChancePercent) || double.IsInfinity(item.DropChancePercent) || item.DropChancePercent<0 || item.DropChancePercent>100)
                    throw new ArgumentException("Invalid campaign item chance.");
                total+=(decimal)item.DropChancePercent;
            }
            if(total!=100m)throw new ArgumentException("Drop chances must total 100%.");
            int count=nextCount(stage.MaxDropAmount+1);
            if(count<0 || count>stage.MaxDropAmount)throw new ArgumentException("Loot count outside configured range.");
            var result=new List<string>(count);
            for(int i=0;i<count;i++)
            {
                double sample=nextChoice();
                if(double.IsNaN(sample) || sample<0 || sample>=1)throw new ArgumentException("Invalid loot random sample.");
                decimal target=(decimal)sample*100m,cumulative=0;
                // Converting the largest double below 1 to decimal may round to 1.
                string selected=stage.DropItems.Last(item=>item.DropChancePercent>0).ItemId;
                foreach(var item in stage.DropItems)
                {
                    cumulative+=(decimal)item.DropChancePercent;
                    if(target<cumulative){selected=item.ItemId;break;}
                }
                result.Add(selected);
            }
            return result;
        }
    }
}
