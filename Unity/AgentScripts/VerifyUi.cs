using System;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using Zatod.Combat;
using Zatod.Networking;
using Zatod.Presentation;

public static class VerifyUi
{
    static UnityEngine.UI.Button Button(string name)
    {
        return UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>().Single(b => b.name == name);
    }
    static async Task Wait(Func<bool> condition)
    {
        var deadline = DateTime.UtcNow.AddSeconds(15);
        while (!condition()) { if (DateTime.UtcNow > deadline) throw new Exception("UI condition timed out"); await Task.Delay(50); }
    }
    public static async Task<object> Run()
    {
        int checks = 0;
        Action<bool, string> check = (ok, reason) => { checks++; if (!ok) throw new Exception(reason); };
        var connection = UnityEngine.Object.FindAnyObjectByType<ArenaConnection>();
        var view = UnityEngine.Object.FindAnyObjectByType<ArenaView>();
        check(view != null && !Mirror.NetworkServer.active, "UI must be a client only");
        if (!connection.Connected) Button("Connect").onClick.Invoke();
        await Wait(() => connection.Connected && !connection.Busy);
        Button("Burst").onClick.Invoke();
        Button("START CHALLENGE").onClick.Invoke();
        await Wait(() => view.Record != null && !connection.Busy);
        check(view.Record.opponentId == "burst", "Opponent button wiring");
        check(view.Record.rulesVersion == BattleRecord.CurrentRules, "Server is running old movement rules");
        Button("PLAY").onClick.Invoke();
        check(!view.Playing, "Pause button wiring");
        float pausedAt = view.Playhead;
        await Task.Delay(300);
        check(Mathf.Approximately(view.Playhead, pausedAt), "Pause changed playhead");
        var slider = GameObject.Find("Timeline").GetComponent<UnityEngine.UI.Slider>();
        slider.value = .6f;
        check(Mathf.Abs(view.Playhead - view.Record.DurationSeconds * .6f) < .02f, "Timeline slider wiring");
        var expected = new ReplayTimeline(view.Record);
        expected.Seek(view.Timeline.Tick);
        foreach (var f in expected.States.Values)
            check(JsonUtility.ToJson(f) == JsonUtility.ToJson(view.Timeline.States[f.id]), "UI seek state differs");
        float at = view.Playhead;
        Button("-5s").onClick.Invoke();
        check(Mathf.Abs(view.Playhead - Mathf.Max(0, at - 5)) < .02f, "Back five seconds");
        Button("+5s").onClick.Invoke();
        check(Mathf.Abs(view.Playhead - at) < .02f, "Forward five seconds");
        Button("2x").onClick.Invoke();
        check(view.Speed == 2, "Speed button wiring");
        Button("PLAY").onClick.Invoke();
        check(view.Playing, "Resume button wiring");
        await Task.Delay(400);
        check(view.Playhead > at + .2f, "Replay clock not advancing");
        Button("PLAY").onClick.Invoke();
        Button("End").onClick.Invoke();
        check(Mathf.Abs(view.Playhead - view.Record.DurationSeconds) < .01f, "End button wiring");
        Button("Restart").onClick.Invoke();
        check(view.Playhead == 0 && view.Timeline.Tick == 0, "Restart wiring");
        view.Seek(10);
        foreach (var graphic in UnityEngine.Object.FindObjectsByType<ArenaGraphic>())
            check(graphic.GetComponent<CanvasRenderer>() != null && graphic.canvasRenderer.GetMesh() != null && graphic.canvasRenderer.GetMesh().vertexCount > 0, "Custom graphic missing mesh");
        check(!Mirror.NetworkServer.active, "Client unexpectedly started a server");
        return new { passed = true, checks, battleId = view.Record.battleId, opponent = view.Record.opponentId, playhead = view.Playhead, paused = !view.Playing };
    }
}
