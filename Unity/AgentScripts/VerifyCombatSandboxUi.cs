using System;
using System.Linq;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Combat;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Presentation;

public static class VerifyCombatSandboxUi
{
    public static async Task<object> Run()
    {
        int checks = 0;
        void Check(bool ok, string why) { checks++; if (!ok) throw new Exception(why); }
        var window = EditorWindow.GetWindow<HeroCombatSandboxWindow>();
        var root = window.rootVisualElement;
        root.Q<IntegerField>("sandbox-casts").value = 1;
        root.Q<IntegerField>("sandbox-casts").value = 1;
        var arena = UnityEngine.Object.FindAnyObjectByType<ArenaView>();
        var formation = arena.GetComponent<FormationView>();
        var before = JsonUtility.ToJson(formation.Selection.Character);
        Check(root.Q<DropdownField>("sandbox-hero").choices.Count == HeroDataJson.LoadBundledCatalog().Data.Heroes.Count, "Catalog dropdown incomplete");
        var rank = root.Q<DropdownField>("sandbox-rank"); rank.value = rank.choices.Last();
        void Click(string name)
        {
            var button = root.Q<UnityEngine.UIElements.Button>(name);
            Check(button != null && button.enabledInHierarchy, "Missing/disabled button: " + name);
            using (var evt = NavigationSubmitEvent.GetPooled()) { evt.target = button; button.SendEvent(evt); }
        }
        async Task RunButton(string name)
        {
            string previous = arena.Record?.battleId;
            Click(name);
            var deadline = DateTime.UtcNow.AddSeconds(10);
            while ((arena.Record == null || arena.Record.battleId == previous) && DateTime.UtcNow < deadline) await Task.Delay(20);
            Check(arena.Record != null && arena.Record.battleId != previous && arena.SandboxMode, "Button did not open sandbox: " + name);
        }
        foreach (string slot in new[] { "ultimate", "skill_2", "skill_3", "skill_4" })
        {
            await RunButton("sandbox-cast-" + slot);
            var skill = arena.Record.loadouts.Single(l => l.fighterId == 1).hero.Skills.Single();
            Check(skill.SlotId == slot, "Wrong isolated skill");
            if (arena.Playing) arena.TogglePlayback();
            arena.Seek(0);
            Click("sandbox-step-forward"); Check(arena.Timeline.Tick == 1 && !arena.Playing, "Forward tick failed");
            Click("sandbox-step-back"); Check(arena.Timeline.Tick == 0, "Backward tick failed");
        }
        rank.value = rank.choices.First();
        Check(root.Q<UnityEngine.UIElements.Button>("sandbox-cast-ultimate").enabledInHierarchy, "White ultimate locked");
        Check(!root.Q<UnityEngine.UIElements.Button>("sandbox-cast-skill_2").enabledInHierarchy, "White Skill2 unlocked");
        await RunButton("sandbox-test-all");
        Check(rank.value == rank.choices.Last() && arena.Record.loadouts[0].hero.Skills.Count == 4, "Test-all did not select highest rank");
        Check(!Mirror.NetworkServer.active && !Mirror.NetworkClient.active, "Sandbox started a network host/client");
        Check(JsonUtility.ToJson(formation.Selection.Character) == before, "Sandbox changed owned HeroDesk");
        if (arena.Playing) arena.TogglePlayback(); arena.Seek(6.2f);
        return new { passed = true, checks, sandbox = arena.Record.opponentId, pausedAt = arena.Playhead };
    }
}
