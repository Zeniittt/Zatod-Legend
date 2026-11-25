// Run with Unity Pipeline in Play Mode in the isolated build workspace.
using System;
using System.IO;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Presentation;

public static class D34HealthBars
{
    const BindingFlags Private = BindingFlags.Instance | BindingFlags.NonPublic;

    public static async Task<object> Run(string report)
    {
        if (!EditorApplication.isPlaying || !Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/"))
            throw new InvalidOperationException("Use the isolated validation Editor in Play Mode.");

        var view = UnityEngine.Object.FindAnyObjectByType<ZatodPrototypeView>();
        var scenes = view.GetComponent<ZatodBattleSceneController>();
        int checks = 0;
        void Check(bool passed, string message)
        {
            checks++;
            if (!passed) throw new InvalidOperationException(message);
        }
        void Apply(string method, params object[] args)
            => typeof(ZatodPrototypeView).GetMethod(method, Private).Invoke(view, args);

        var catalog = HeroDataJson.LoadBundledCatalog();
        var match = ZatodMatchFactory.Versus(catalog,
            new[] { catalog.CreateHero("coco", "guardian"), catalog.CreateHero("lina", "attacker") },
            new[] { catalog.CreateHero("lina", "target") }, 34, "health-bars", false);
        var guardian = match.Players[0];
        var attacker = match.Players[1];
        var target = match.Waves[0].Enemies[0];
        match.Waves[0].TimeLimitSeconds = 6;
        match.Buffs.Add(new ZatodBuffDefinition { SourceId = 9001, Duration = 4, ShieldValue = 250, ShieldType = "all" });
        foreach (var actor in new[] { guardian, attacker, target })
        {
            actor.Battle.Skills.Clear();
            actor.Battle.HasNormalAttack = actor != target;
            actor.Battle.NormalAttack = actor == target ? null : new SkillDefinition
            {
                Id = "health_fixture",
                Crystal = new ZatodSkillDefinition
                {
                    SourceId = 9002, ActiveType = "active", TargetType = actor == guardian ? "self" : "target",
                    TargetCamp = -1, AffectedCamp = -1, DamageType = actor == guardian ? null : "Holy",
                    BasicAmount = 125, BuffId = actor == guardian ? 9001 : 0,
                    MaxRange = 9999, Cooldown = 1000, GlobalCooldown = 1000,
                    Phases = new() { new ZatodActionPhase { Action = "atk", Duration = .5, AttackTimes = new() { .25 } } }
                }
            };
        }
        var archive = new ZatodBattleSimulation(match).RunToCompletion();
        Apply("LoadReplay", archive);
        Apply("SetReplayPlaying", false);
        try
        {
            double limit = EditorApplication.timeSinceStartup + 8;
            while (scenes.Phase != ZatodScenePhase.InBattle && EditorApplication.timeSinceStartup < limit)
                await Task.Delay(30);
            Check(scenes.Phase == ZatodScenePhase.InBattle, "Replay scene did not load.");
            Transform Bar(ZatodUnitData actor) => scenes.Stage.transform.Find("Hero_" + actor.EntityId + "/HealthBar");
            float Width(Transform bar, string member) => bar.Find(member).localScale.x;
            async Task Seek(int tick)
            {
                var previous = Bar(guardian);
                Apply("Seek", tick);
                double cleanupLimit = EditorApplication.timeSinceStartup + 3;
                while (previous != null && EditorApplication.timeSinceStartup < cleanupLimit)
                    await Task.Delay(30);
                if (previous != null) throw new TimeoutException("Seek did not release the old actor view.");
            }
            Check(!Bar(guardian).gameObject.activeSelf && !Bar(target).gameObject.activeSelf, "Idle health bars should start hidden.");

            for (int tick = 1; tick <= 3; tick++)
            {
                Apply("AdvanceReplay", tick);
                Apply("DrawBattle");
            }
            var shield = Bar(guardian);
            var damaged = Bar(target);
            float watchedShield = Width(shield, "ShieldFill");
            float watchedHp = Width(damaged, "HealthFill");
            float watchedTrail = Width(damaged, "HealthTrail");
            Check(shield.gameObject.activeSelf && watchedShield > 0 && Mathf.Approximately(Width(shield, "HealthFill"), .9f),
                "Full health concealed the shield.");
            Check(damaged.gameObject.activeSelf && watchedTrail > watchedHp, "Damage should show the HP trail.");

            await Seek(16);
            Check(!Bar(guardian).gameObject.activeSelf && Width(Bar(guardian), "ShieldFill") > 0,
                "The shield should still exist after its bar auto-hides.");
            await Seek(3);
            Check(Bar(guardian).gameObject.activeSelf && Width(Bar(guardian), "ShieldFill") == watchedShield,
                "Backward seek lost the active shield bar.");
            Check(Bar(target).gameObject.activeSelf && Width(Bar(target), "HealthFill") == watchedHp &&
                Width(Bar(target), "HealthTrail") == watchedTrail, "Backward seek changed the HP animation.");
            await Seek(35);
            Check(Bar(guardian).gameObject.activeSelf && !Bar(guardian).Find("ShieldFill").GetComponent<SpriteRenderer>().enabled,
                "Shield expiry should reveal the group, with the shield fill removed.");
            await Seek(47);
            Check(!Bar(guardian).gameObject.activeSelf && !Bar(target).gameObject.activeSelf, "Stable bars should hide.");
        }
        finally
        {
            Apply("Show", "campaign");
        }
        var result = new { State = "PASS", Checks = checks, archive.Digest };
        File.WriteAllText(report, Newtonsoft.Json.JsonConvert.SerializeObject(result, Newtonsoft.Json.Formatting.Indented));
        return result;
    }
}
