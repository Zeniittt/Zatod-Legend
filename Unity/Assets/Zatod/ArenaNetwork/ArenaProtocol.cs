using System;
using Mirror;

namespace Zatod.Networking
{
    // Prototype: one server-owned development account. No client-supplied stats or result.
    public struct ChallengeRequest : NetworkMessage { public string requestId, opponentId; }
    public struct ReplayRequest : NetworkMessage { public string battleId; }
    public struct CatalogRequest : NetworkMessage { }
    public struct CatalogResponse : NetworkMessage { public ReplaySummary[] replays; }
    public struct ArenaFailure : NetworkMessage { public string message; }
    public struct ReplayBegin : NetworkMessage { public string battleId, sha256; public int length, chunks; }
    public struct ReplayChunk : NetworkMessage { public string battleId; public int index; public byte[] bytes; }

    [Serializable]
    public struct ReplaySummary
    {
        public string battleId, opponentId, createdUtc;
        public int winner;
        public float duration;
    }
}
