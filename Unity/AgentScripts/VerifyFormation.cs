using System;
using System.IO;
using System.Linq;
using UnityEngine;
using Zatod.Combat;
using Zatod.Networking;
using Zatod.Presentation;

public static class VerifyFormation
{
    static int checks;
    static void Check(bool ok, string reason) { checks++; if (!ok) throw new Exception(reason); }
    static void CheckProjection(ArenaView view)
    {
        var alive = view.Timeline.States.Values.Where(s => s.Alive).OrderBy(s => s.x).ToArray();
        if (alive.Length < 2) return;
        Func<FighterState, Vector2> point = s => GameObject.Find("Fighter_" + s.id).GetComponent<RectTransform>().anchoredPosition;
        var a = alive.First(); var b = alive.Last();
        if (a.x == b.x) return;
        float slope = (point(b).x - point(a).x) / (b.x - a.x);
        float offset = point(a).x - a.x * slope;
        Check(slope > 0, "Battle camera reversed world direction");
        foreach (var s in alive)
        {
            Check(Mathf.Abs(point(s).x - (s.x * slope + offset)) < .02f, "Per-unit positioning distorted recorded center distance");
            Check(Mathf.Abs(point(s).y - (s.y * .2f - 25)) < .02f, "Fixed vertical lanes remain in current replay");
        }
        foreach (var s in view.Timeline.States.Values.Where(s => !s.Alive))
            Check(GameObject.Find("Fighter_" + s.id).GetComponent<CanvasGroup>().alpha == 0, "Defeated unit still obscures the new front line");
    }
    public static object Run()
    {
        checks = 0;
        var view = UnityEngine.Object.FindAnyObjectByType<ArenaView>();
        Check(view != null && view.Record != null && view.Record.rulesVersion == BattleRecord.CurrentRules, "Load a current-rules server replay first");
        var record = view.Record;
        if (view.Playing) view.TogglePlayback();
        view.Seek(0); CheckProjection(view);
        var retarget = record.events.FirstOrDefault(e => e.kind == BattleEventKind.Target && e.tick > 1 &&
            record.events.Any(m => m.kind == BattleEventKind.Move && m.actorId == e.actorId && m.tick > e.tick && m.tick < e.tick + 100 && m.state.targetId == e.state.targetId));
        Check(retarget != null, "No post-death approach was exercised");
        var move = record.events.First(e => e.kind == BattleEventKind.Move && e.actorId == retarget.actorId && e.tick > retarget.tick && e.state.targetId == retarget.state.targetId);
        var previous = record.events.Last(e => e.kind == BattleEventKind.Target && e.actorId == retarget.actorId && e.sequence < retarget.sequence);
        var death = record.events.Last(e => e.kind == BattleEventKind.Death && e.targetId == previous.state.targetId && e.sequence < retarget.sequence);
        Check(move.tick < move.state.nextActionTick, "Approach after death failed to exercise movement during cooldown");
        float beforeSeconds = Math.Max(0, death.tick - 1) / (float)record.tickRate;
        float afterSeconds = Math.Min(record.durationTicks, move.tick + 25) / (float)record.tickRate;
        view.Seek(beforeSeconds); CheckProjection(view);
        int beforeX = view.Timeline.States[retarget.actorId].x;
        view.Seek(afterSeconds); CheckProjection(view);
        int afterX = view.Timeline.States[retarget.actorId].x;
        Check(beforeX != afterX, "Chasing unit did not change recorded world position");
        // Attack animation must not displace the logical root/nameplate.
        var cast = record.events.First(e => e.kind == BattleEventKind.Action && e.state.action == BattleAction.Attack);
        view.Seek((cast.tick + 3) / (float)record.tickRate); CheckProjection(view);
        view.Seek(record.DurationSeconds); CheckProjection(view);
        // Existing archives retain their outcomes and use the explicitly labeled legacy layout.
        string directory = Path.GetFullPath(Path.Combine(Application.dataPath, "../../ServerData"));
        bool legacyChecked = false;
        foreach (string file in Directory.GetFiles(directory, "*.arena.gz").OrderBy(p => p))
        {
            var old = ReplayArchive.Decode(File.ReadAllBytes(file));
            if (old.rulesVersion != "combat-prototype-1") continue;
            view.Load(old); view.TogglePlayback(); view.Seek(old.DurationSeconds / 2);
            Check(view.Record.rulesVersion == "combat-prototype-1", "Legacy replay was rerolled");
            legacyChecked = true; break;
        }
        view.Load(record); view.TogglePlayback(); view.Seek(beforeSeconds);
        return new { passed = true, checks, legacyChecked, actor = retarget.actorId, oldTarget = previous.state.targetId, newTarget = retarget.state.targetId, beforeX, afterX, beforeSeconds, afterSeconds, battleId = record.battleId };
    }
}
