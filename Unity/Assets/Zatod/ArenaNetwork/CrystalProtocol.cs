using System;
using System.Collections.Generic;
using Mirror;
using Zatod.Heroes;
using Zatod.Combat;
namespace Zatod.Networking
{
    public struct CrystalPacket : NetworkMessage { public string id,kind;public int index,length;public byte[] bytes; }
    [Serializable] public sealed class CrystalRequest { public string Command,A,B,C;public int Number;public string[] Heroes; }
    [Serializable] public sealed class CrystalAccountSnapshot { public CharacterData Account;public List<string> Cleared=new List<string>();public List<string> Replays=new List<string>(); }
    [Serializable] public sealed class CrystalStart { public CrystalMatchDefinition Match;public int Team; }
    [Serializable] public sealed class CrystalTick { public string BattleId;public int Tick;public List<CrystalInput> Inputs=new List<CrystalInput>();public ulong Digest; }
    [Serializable] public sealed class CrystalOperation { public string BattleId;public int Tick;public List<int> Actors=new List<int>(); }
    [Serializable] public sealed class CrystalNotice { public string Text; }
}
