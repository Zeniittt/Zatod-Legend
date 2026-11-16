using System;
using System.Collections.Generic;

namespace Zatod.Combat
{
    public enum FighterRole { Vanguard, Striker, Ranger, Arcanist, Medic }
    // Append values to preserve the numeric values used by existing replay archives.
    public enum BattleAction { Idle, Attack, Ultimate, Dead, Moving }
    public enum BattleEventKind { Move, Action, Damage, Heal, Energy, Stun, Death, Cancel, Finished, Target, Miss }

    [Serializable]
    public sealed class FighterState
    {
        public int id, team, slot;
        public string name;
        public FighterRole role;
        public int maxHp, hp, energy, armor, attack, range, attackInterval;
        public int x, y, stunUntil, nextActionTick, targetId;
        public int actionTargetId, movementLockUntilTick, moveSpeed, formationSpacing;
        public BattleAction action;
        public int actionStartTick, actionEndTick;
        public bool Alive { get { return hp > 0; } }
        public FighterState Copy() { return (FighterState)MemberwiseClone(); }
    }

    [Serializable]
    public sealed class BattleEvent
    {
        public int sequence, tick, actorId, targetId, amount;
        public BattleEventKind kind;
        public bool critical;
        public bool hasState;
        public string ability;
        // Absolute resulting state: playback never recalculates damage, RNG, or AI.
        public FighterState state;
    }

    [Serializable]
    public sealed class BattleSnapshot
    {
        public int tick, nextEventIndex;
        public List<FighterState> fighters = new List<FighterState>();
    }

    [Serializable]
    public sealed class BattleRecord
    {
        public const int CurrentSchema = 1;
        public int schemaVersion = CurrentSchema;
        public const string CurrentRules = "combat-prototype-2";
        public string rulesVersion = CurrentRules;
        public string battleId, createdUtc, opponentId;
        public uint seed;
        public int tickRate = 20, durationTicks, winner = -1;
        public bool timedOut;
        public List<FighterState> initial = new List<FighterState>();
        public List<BattleEvent> events = new List<BattleEvent>();
        public List<BattleSnapshot> snapshots = new List<BattleSnapshot>();
        public float DurationSeconds { get { return (float)durationTicks / tickRate; } }
    }

    public static class PrototypeTeams
    {
        public static readonly string[] OpponentIds = { "balanced", "fortress", "burst" };

        public static List<FighterState> Create(string opponentId)
        {
            if (Array.IndexOf(OpponentIds, opponentId) < 0)
                throw new ArgumentException("Unknown server-owned opponent.", nameof(opponentId));
            var fighters = new List<FighterState>();
            for (int team = 0; team < 2; team++)
            for (int slot = 0; slot < 5; slot++)
            {
                var role = (FighterRole)slot;
                int[] health = { 4600, 3100, 2450, 2250, 2600 };
                int[] power = { 180, 270, 245, 230, 145 };
                int[] armor = { 70, 30, 15, 10, 20 };
                int[] ranges = { 1100, 2000, 3000, 3900, 4800 };
                int[] depth = { 120, -140, 100, -120, 80 };
                int[] intervals = { 27, 23, 26, 30, 32 };
                int hp = health[slot], atk = power[slot], def = armor[slot];
                if (team == 1 && opponentId == "fortress") { hp = hp * 125 / 100; def += 20; atk = atk * 85 / 100; }
                if (team == 1 && opponentId == "burst") { hp = hp * 85 / 100; atk = atk * 130 / 100; }
                fighters.Add(new FighterState
                {
                    id = team * 100 + slot + 1, team = team, slot = slot,
                    name = role.ToString(), role = role, maxHp = hp, hp = hp,
                    armor = def, attack = atk, range = ranges[slot], attackInterval = intervals[slot],
                    x = (team == 0 ? -1 : 1) * (2300 + slot * 1000), y = depth[slot],
                    moveSpeed = 1600, formationSpacing = 850,
                    nextActionTick = slot * 2, action = BattleAction.Idle
                });
            }
            return fighters;
        }
    }
}
