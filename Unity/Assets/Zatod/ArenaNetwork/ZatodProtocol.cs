using System;
using System.Collections.Generic;
using Mirror;
using Zatod.Heroes;
using Zatod.Combat;
namespace Zatod.Networking
{
    public struct ZatodPacket : NetworkMessage { public string id,kind;public int index,length;public byte[] bytes; }
    [Serializable] public sealed class ZatodRequest { public string Command,A,B,C,OperationId;public int Number;public string[] Heroes; }
    [Serializable] public sealed class ZatodStageStars { public string StageId;public int Stars; }
    [Serializable] public sealed class ZatodAccountSnapshot
    {
        public CharacterData Account;
        public long ServerTime;
        public List<string> Cleared=new List<string>();
        public List<ZatodStageStars> StageStars=new List<ZatodStageStars>();
        public List<string> Replays=new List<string>();
        public ZatodCampaignReward LastCampaignReward;
        public int StarsFor(string stageId)=>Math.Clamp(StageStars?.Find(s=>s.StageId==stageId)?.Stars??0,0,3);
    }
    [Serializable] public sealed class ZatodStart { public ZatodMatchDefinition Match;public int Team;public List<string> LootItems=new List<string>(); }
    [Serializable] public sealed class ZatodTick { public string BattleId;public int Tick;public List<ZatodInput> Inputs=new List<ZatodInput>();public ulong Digest; }
    [Serializable] public sealed class ZatodOperation { public string BattleId;public int Tick;public List<int> Actors=new List<int>(); }
    [Serializable] public sealed class ZatodNotice { public string Text; }
}
