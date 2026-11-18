using System;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using Zatod.Combat;
using Zatod.Networking;
using Zatod.Presentation;

public static class VerifyLeenaldRuntime
{
    public static async Task<object> Run()
    {
        int checks = 0;
        void Check(bool ok, string why) { checks++; if (!ok) throw new Exception(why); }
        var formation = UnityEngine.Object.FindAnyObjectByType<FormationView>();
        var connection = formation.GetComponent<ArenaConnection>();
        var arena = formation.GetComponent<ArenaView>();
        formation.Show();
        foreach (var id in formation.Selection.Character.Formation.HeroInstanceIds.ToArray()) formation.Selection.Toggle(id);
        string[] selected = { "preview-leenald", "preview-training_warrior", "preview-windrunner", "preview-stormcaller", "preview-dawn_priestess" };
        foreach (var id in selected) formation.Selection.Toggle(id);
        formation.Show();
        UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>().Single(b => b.name == "FormationBattle").onClick.Invoke();
        var deadline = DateTime.UtcNow.AddSeconds(25);
        while ((arena.Record == null || connection.Busy) && DateTime.UtcNow < deadline) await Task.Delay(50);
        Check(arena.Record != null && arena.Record.rulesVersion == BattleRecord.CurrentRules, "No current server replay");
        Check(!Mirror.NetworkServer.active && connection.Connected, "Client must use dedicated server");
        Check(arena.Record.initial.Count == 10 && arena.Record.initial.Count(f => f.team == 0) == selected.Length, "Squad size differs");
        Check(arena.Record.loadouts.Select(l => l.hero.HeroInstanceId).OrderBy(s => s).SequenceEqual(selected.OrderBy(s => s)), "Squad differs from selected IDs");
        Check(arena.Record.initial.Single(f => f.heroDefinitionId == "leenald").slot == 0, "Leenald not in front");
        if (arena.Playing) arena.TogglePlayback();
        var action = arena.Record.events.First(e => e.actorId == 1 && e.kind == BattleEventKind.Action && e.state.animationState == "NormalAttack");
        arena.Seek((action.tick + 4f) / arena.Record.tickRate);
        var body = UnityEngine.Object.FindObjectsByType<ReplaySprite>().Single(s => s.transform.parent.name == "Fighter_1");
        Check(body.CurrentState == "NormalAttack" && body.GetComponent<UnityEngine.UI.Image>().sprite != null, "No attack sprite");
        var frame = body.GetComponent<UnityEngine.UI.Image>().sprite;
        float time = body.SampleSeconds;
        await Task.Delay(200);
        Check(body.SampleSeconds == time && body.GetComponent<UnityEngine.UI.Image>().sprite == frame, "Pause drifted sprite");
        arena.Seek(arena.Record.DurationSeconds); arena.Seek((action.tick + 4f) / arena.Record.tickRate);
        Check(body.SampleSeconds == time && body.GetComponent<UnityEngine.UI.Image>().sprite == frame, "Backward seek changed sprite");
        Check(arena.Record.projectiles.Any(p => p.actorId == 1 && p.hit), "No Leenald projectile");
        return new { passed = true, checks, battleId = arena.Record.battleId, seconds = arena.Record.DurationSeconds, at = arena.Playhead };
    }
}
