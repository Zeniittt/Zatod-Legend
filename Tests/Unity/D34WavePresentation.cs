using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using TMPro;
using UnityEditor;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Presentation;

public static class D34WavePresentation
{
    public static async Task<object> Run(string report)
    {
        if (!EditorApplication.isPlaying || !Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/"))
            throw new InvalidOperationException("Use the isolated validation Editor in Play Mode.");

        var heroes = HeroDataJson.LoadBundledCatalog();
        var session = new ZatodPlayerSession(heroes, CampaignDataJson.LoadZatod(heroes), Guid.NewGuid().ToString("D"));
        var match = session.BeginCampaign("chapter_one_stage_1", null, 34, "wave-presentation");
        var subject = match.Players[0];
        match.Waves[1].Hooks.Add(new WaveHookDefinition
        {
            Id = "fixture_reset", PlayerSide = true, TargetDefinitionId = subject.DefinitionId, Action = WaveHookAction.SetEnergy
        });
        match.Waves[1].Hooks.Add(new WaveHookDefinition
        {
            Id = "fixture_gain", PlayerSide = true, TargetDefinitionId = subject.DefinitionId, Action = WaveHookAction.AddEnergy, Amount = 100
        });
        var sim = new ZatodBattleSimulation(match);
        ZatodFrame entry = null;
        while (!sim.Finished)
        {
            foreach (var actor in sim.Frame().Units.Where(actor => actor.Team == 0 && actor.CanActivateUltimate))
                sim.RequestUltimate(actor.EntityId);
            sim.Step();
            if (entry == null && sim.WaveIndex == 2) entry = sim.Frame();
        }
        if (entry?.WaveEntryRemaining != .75)
            throw new InvalidOperationException("The fixture did not produce a V5 wave entry.");
        var popup = entry.CombatEvents.Single(e => e.Wave == 2 && e.EntityId == subject.EntityId && e.Kind == "energy");

        var view = UnityEngine.Object.FindAnyObjectByType<ZatodPrototypeView>();
        var scenes = view.GetComponent<ZatodBattleSceneController>();
        const BindingFlags privateMember = BindingFlags.Instance | BindingFlags.NonPublic;
        var hud = (ZatodBattleHudLayout)typeof(ZatodPrototypeView).GetField("hud", privateMember).GetValue(view);
        void Apply(string method, params object[] args)
            => typeof(ZatodPrototypeView).GetMethod(method, privateMember).Invoke(view, args);

        Apply("LoadReplay", sim.Replay());
        Apply("SetReplayPlaying", false);
        try
        {
            double limit = EditorApplication.timeSinceStartup + 8;
            while (scenes.Phase != ZatodScenePhase.InBattle && EditorApplication.timeSinceStartup < limit)
                await Task.Delay(30);
            if (scenes.Phase != ZatodScenePhase.InBattle)
                throw new InvalidOperationException("Could not open the replay scene.");

            async Task<float> SeekAndReadAnchor(int tick)
            {
                var priorActor = scenes.Stage.transform.Find("Hero_" + subject.EntityId);
                Apply("Seek", tick);
                double cleanupLimit = EditorApplication.timeSinceStartup + 3;
                while (priorActor != null && EditorApplication.timeSinceStartup < cleanupLimit)
                    await Task.Delay(25);
                if (priorActor != null) throw new TimeoutException("The old actor survived replay seek.");

                var actor = scenes.Stage.transform.Find("Hero_" + subject.EntityId);
                var text = hud.Floating.Find("Combat_energy_" + popup.Id).GetComponent<TextMeshProUGUI>();
                float visualAnchor = text.rectTransform.anchoredPosition.x + 110 - (popup.Id % 3 - 1) * 18;
                float actorAnchor = (actor.position.x + 8) * 100;
                if (Mathf.Abs(visualAnchor - actorAnchor) > .05f)
                    throw new InvalidOperationException("The energy number remained at the final formation instead of following the actor.");
                return visualAnchor;
            }

            float first = await SeekAndReadAnchor(entry.Tick);
            float mid = await SeekAndReadAnchor(entry.Tick + 3);
            float repeated = await SeekAndReadAnchor(entry.Tick);
            if (mid <= first || Mathf.Abs(first - repeated) > .05f)
                throw new InvalidOperationException("Wave entry moved or replayed the anchor incorrectly.");
            var result = new { State = "PASS", entry.Tick, FirstX = first, MidX = mid, ReplayX = repeated };
            File.WriteAllText(report, Newtonsoft.Json.JsonConvert.SerializeObject(result));
            return result;
        }
        finally { Apply("Show", "campaign"); }
    }
}
