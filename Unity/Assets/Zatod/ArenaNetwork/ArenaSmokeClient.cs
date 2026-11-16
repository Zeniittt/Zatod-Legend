using System;
using System.Collections;
using UnityEngine;
using Zatod.Combat;

namespace Zatod.Networking
{
    // Run a real headless client against a separate process; this never starts a server.
    public sealed class ArenaSmokeClient : MonoBehaviour
    {
        IEnumerator Start()
        {
            var connection = GetComponent<ArenaConnection>();
            float deadline = Time.realtimeSinceStartup + 45;
            while (!connection.Connected && Time.realtimeSinceStartup < deadline) yield return null;
            if (!connection.Connected) { Fail("Could not connect"); yield break; }
            string savedId = ArenaConnection.Argument("--replay-id", "");
            string requested = savedId.Length > 0 ? savedId : connection.Challenge("balanced");
            if (savedId.Length > 0) connection.LoadReplay(savedId);
            while ((connection.LastRecord == null || connection.Busy) && Time.realtimeSinceStartup < deadline) yield return null;
            if (connection.LastRecord == null) { Fail(connection.Status); yield break; }
            var first = connection.LastRecord;
            if (savedId.Length == 0 && first.rulesVersion != BattleRecord.CurrentRules) { Fail("Server is running old combat rules"); yield break; }
            if (first.battleId != requested) { Fail("Battle ID differs from request"); yield break; }
            var timeline = new ReplayTimeline(first);
            timeline.Seek(first.durationTicks);
            var final = first.snapshots[first.snapshots.Count - 1];
            foreach (var state in final.fighters)
                if (JsonUtility.ToJson(state) != JsonUtility.ToJson(timeline.States[state.id])) { Fail("Final replay differs"); yield break; }
            int received = 0;
            string firstJson = JsonUtility.ToJson(first);
            connection.ReplayReceived += _ => received++;
            connection.LoadReplay(first.battleId);
            while (received < 1 && Time.realtimeSinceStartup < deadline) yield return null;
            if (received != 1 || JsonUtility.ToJson(connection.LastRecord) != firstJson) { Fail("Reload differs"); yield break; }
            if (savedId.Length == 0)
            {
                connection.Challenge("balanced", first.battleId); // Idempotent retry must return same result.
                while (received < 2 && Time.realtimeSinceStartup < deadline) yield return null;
                if (received != 2 || JsonUtility.ToJson(connection.LastRecord) != firstJson) { Fail("Duplicate request rerolled match"); yield break; }
            }
            Debug.Log("[ArenaSmoke] PASS battle=" + first.battleId + " events=" + first.events.Count + " winner=" + first.winner + " serverActive=" + Mirror.NetworkServer.active);
            Application.Quit(0);
        }
        static void Fail(string message) { Debug.LogError("[ArenaSmoke] FAIL " + message); Application.Quit(1); }
    }
}
