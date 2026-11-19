using System;
using System.Collections.Generic;
using System.IO;
using Zatod.Combat;

namespace Zatod.Networking
{
    public sealed class LiveBattleCursor
    {
        internal int Tick=-1,Events,Snapshots,Projectiles,Effects;
    }
    [Serializable] public sealed class LiveProjectileUpdate { public int index; public BattleProjectile value; }
    [Serializable] public sealed class LiveEffectUpdate { public int index; public BattleVisualEffect value; }
    [Serializable] public sealed class LiveBattleDelta
    {
        public bool hasHeader;
        public BattleRecord header;
        public int tick,eventOffset,snapshotOffset;
        public List<BattleEvent> events=new List<BattleEvent>();
        public List<BattleSnapshot> snapshots=new List<BattleSnapshot>();
        public List<LiveProjectileUpdate> projectiles=new List<LiveProjectileUpdate>();
        public List<LiveEffectUpdate> effects=new List<LiveEffectUpdate>();
    }
    public static class LiveBattleCodec
    {
        public static byte[] Encode(BattleRecord record,LiveBattleCursor cursor)
        {
            var delta=new LiveBattleDelta{hasHeader=cursor.Tick<0,tick=record.durationTicks,eventOffset=cursor.Events,snapshotOffset=cursor.Snapshots};
            if(delta.hasHeader)delta.header=record;
            else
            {
                delta.events.AddRange(record.events.GetRange(cursor.Events,record.events.Count-cursor.Events));
                delta.snapshots.AddRange(record.snapshots.GetRange(cursor.Snapshots,record.snapshots.Count-cursor.Snapshots));
                for(int i=0;i<record.projectiles.Count;i++)if(i>=cursor.Projectiles || record.projectiles[i].endTick>=cursor.Tick)
                    delta.projectiles.Add(new LiveProjectileUpdate{index=i,value=record.projectiles[i]});
                for(int i=0;i<record.visualEffects.Count;i++)if(i>=cursor.Effects || record.visualEffects[i].endTick>=cursor.Tick)
                    delta.effects.Add(new LiveEffectUpdate{index=i,value=record.visualEffects[i]});
            }
            byte[] result=ReplayArchive.EncodePayload(delta);
            cursor.Tick=record.durationTicks;cursor.Events=record.events.Count;cursor.Snapshots=record.snapshots.Count;
            cursor.Projectiles=record.projectiles.Count;cursor.Effects=record.visualEffects.Count;return result;
        }
        public static BattleRecord Decode(byte[] bytes,BattleRecord previous)
        {
            var delta=ReplayArchive.DecodePayload<LiveBattleDelta>(bytes);BattleRecord result;
            if(delta.hasHeader)
            {
                if(previous!=null || delta.header==null)throw new InvalidDataException("Unexpected live header.");
                result=delta.header;ReplayArchive.NormalizeLoadouts(result);
            }
            else
            {
                if(previous==null || delta.tick<=previous.durationTicks || delta.eventOffset!=previous.events.Count || delta.snapshotOffset!=previous.snapshots.Count)
                    throw new InvalidDataException("Live frame is out of sequence.");
                result=new BattleRecord{schemaVersion=previous.schemaVersion,rulesVersion=previous.rulesVersion,battleId=previous.battleId,
                    opponentId=previous.opponentId,createdUtc=previous.createdUtc,seed=previous.seed,tickRate=previous.tickRate,
                    campaignStageId=previous.campaignStageId,campaignConfigVersion=previous.campaignConfigVersion,
                    formationLayoutVersion=previous.formationLayoutVersion,manualUltimateTeams=previous.manualUltimateTeams,battleInProgress=true,
                    durationTicks=delta.tick,initial=previous.initial,loadouts=previous.loadouts,
                    events=new List<BattleEvent>(previous.events),snapshots=new List<BattleSnapshot>(previous.snapshots),
                    projectiles=new List<BattleProjectile>(previous.projectiles),visualEffects=new List<BattleVisualEffect>(previous.visualEffects)};
                result.events.AddRange(delta.events);result.snapshots.AddRange(delta.snapshots);
                var seen=new HashSet<int>();foreach(var p in delta.projectiles)
                {
                    if(p==null || p.value==null || p.index<0 || p.index>result.projectiles.Count || !seen.Add(p.index))throw new InvalidDataException("Invalid live projectile index.");
                    if(p.index==result.projectiles.Count)result.projectiles.Add(p.value);else result.projectiles[p.index]=p.value;
                }
                seen.Clear();foreach(var e in delta.effects)
                {
                    if(e==null || e.value==null || e.index<0 || e.index>result.visualEffects.Count || !seen.Add(e.index))throw new InvalidDataException("Invalid live effect index.");
                    if(e.index==result.visualEffects.Count)result.visualEffects.Add(e.value);else result.visualEffects[e.index]=e.value;
                }
            }
            if(!result.battleInProgress || result.durationTicks!=delta.tick)throw new InvalidDataException("Invalid unfinished frame.");
            ReplayArchive.Validate(result,true);return result;
        }
    }
}
