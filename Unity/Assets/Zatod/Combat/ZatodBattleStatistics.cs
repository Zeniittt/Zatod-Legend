using System;
using System.Collections.Generic;
using System.Linq;

namespace Zatod.Combat
{
    [Serializable] public sealed class ZatodUnitStatistics
    {
        public int EntityId,Team,Wave,Level,Kills,SummonerId;
        public string DefinitionId,Name,Resource;
        public double DamageDealt,DamageTaken,Healing;
        public ZatodUnitStatistics Copy()=>(ZatodUnitStatistics)MemberwiseClone();
    }
    [Serializable] public sealed class ZatodLootDrop
    {
        public int Index,Wave,EntityId;
        public string ItemId;
        public ZatodLootDrop Copy()=>(ZatodLootDrop)MemberwiseClone();
    }
    public sealed partial class ZatodBattleSimulation
    {
        readonly Dictionary<int,ZatodUnitStatistics> statistics=new Dictionary<int,ZatodUnitStatistics>();
        readonly List<ZatodCombatEvent> deathRecords=new List<ZatodCombatEvent>();
        public List<ZatodCombatEvent> DeathRecords()=>deathRecords.ConvertAll(e=>e.Copy());
        public List<ZatodLootDrop> LootPlan()=>(initial.LootDrops??new List<ZatodLootDrop>()).ConvertAll(d=>d.Copy());
        void RegisterStatistics(ZatodUnitData data)
        {
            if(!statistics.ContainsKey(data.EntityId))statistics.Add(data.EntityId,new ZatodUnitStatistics{EntityId=data.EntityId,Team=data.Team,Wave=data.Team==0 && data.SummonerId==0?0:wave+1,Level=data.Level,DefinitionId=data.DefinitionId,Name=data.Name,Resource=data.Resource,SummonerId=data.SummonerId});
        }
        public List<ZatodUnitStatistics> Statistics()=>statistics.Values.OrderBy(s=>s.Team).ThenBy(s=>s.Wave).ThenBy(s=>s.EntityId).Select(s=>s.Copy()).ToList();
        void RecordDamage(Unit source,Unit target,double amount)
        {
            if(amount<=0 || source==target)return;
            statistics[target.Data.EntityId].DamageTaken+=amount;
            if(source!=null)statistics[source.Data.EntityId].DamageDealt+=amount;
        }
        void RecordHealing(Unit source,double amount)
        {if(source!=null && amount>0)statistics[source.Data.EntityId].Healing+=amount;}
        void RecordPeriodicHealing(Unit target,double amount)
        {
            if(amount<=0)return;
            double baseWeight=Math.Max(0,target.Base.TryGetValue("health_regen",out double value)?value:0);
            var sources=target.Buffs.Where(b=>b.Modifiers.TryGetValue("health_regen",out double v)&&v>0).ToArray();
            double total=baseWeight+sources.Sum(b=>b.Modifiers["health_regen"]);if(total<=0)return;
            foreach(var buff in sources)if(statistics.TryGetValue(buff.CasterId,out var row))row.Healing+=amount*buff.Modifiers["health_regen"]/total;
        }
        void RecordPeriodicDamage(Unit target,double amount)
        {
            if(amount<=0)return;
            statistics[target.Data.EntityId].DamageTaken+=amount;
            // The current core combines HPR modifiers before applying a single HP delta.
            // Attribute that actual delta proportionally to negative contributors; don't change HPR rules.
            double baseWeight=Math.Max(0,-(target.Base.TryGetValue("health_regen",out double value)?value:0));
            var sources=target.Buffs.Where(b=>b.Modifiers.TryGetValue("health_regen",out double v)&&v<0).ToArray();
            double total=baseWeight+sources.Sum(b=>-b.Modifiers["health_regen"]);
            if(total<=0)return;
            foreach(var buff in sources)if(buff.CasterId!=target.Data.EntityId && statistics.TryGetValue(buff.CasterId,out var row))row.DamageDealt+=amount*(-buff.Modifiers["health_regen"])/total;
        }
        void RecordDeath(Unit source,Unit target)
        {
            if(source!=null && source!=target)statistics[source.Data.EntityId].Kills++;
            var death=new ZatodCombatEvent{Id=++combatEventId,Tick=tick,Wave=wave+1,EntityId=target.Data.EntityId,SourceActorId=source?.Data.EntityId??0,Kind="death",X=target.State.X,Y=target.State.Y,Height=target.State.Height};
            combatEvents.Add(death);deathRecords.Add(death);
        }
    }
}
