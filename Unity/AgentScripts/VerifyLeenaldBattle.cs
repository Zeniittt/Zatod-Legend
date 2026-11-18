using System;
using System.IO;
using System.Linq;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;

public static class VerifyLeenaldBattle
{
    public static object Run()
    {
        int checks = 0;
        void Check(bool ok, string reason) { checks++; if (!ok) throw new Exception(reason); }
        var catalog = HeroDataJson.LoadBundledCatalog();
        var initial = ServerHeroTeams.Create("balanced", new[] { "preview-leenald" }, catalog, out var loadouts);
        Check(initial.Count == 6 && initial.Single(f => f.team == 0).name == "Leenald", "Selected squad ignored");
        Check(loadouts.Single().hero.Skills.Count == 1 && loadouts.Single().hero.HasNormalAttack, "White rank skill gate");
        Check(initial.Single(f => f.team == 0).range == 100, "Center range must come from Hero stats");
        try { ServerHeroTeams.Create("balanced", new[] { "forged-hero" }, catalog, out _); throw new Exception("Accepted foreign hero"); }
        catch (ArgumentException) { checks++; }
        try { ServerHeroTeams.Create("balanced", new[] { "preview-leenald", "preview-leenald" }, catalog, out _); throw new Exception("Accepted duplicate"); }
        catch (ArgumentException) { checks++; }
        var id = Guid.NewGuid().ToString("N");
        var record = new BattleSimulation(id, "balanced", 123, initial, loadouts).RunToCompletion();
        Check(record.events.Any(e => e.actorId == 1 && e.kind == BattleEventKind.Damage), "No Leenald basic attack");
        Check(record.projectiles.Count > 0 && record.projectiles.Any(p => p.hit), "No ultimate projectile hit");
        Check(record.durationTicks - record.combatEndTick == 30, "Final Death animation was truncated");
        Check(record.events.Any(e => e.actorId == 1 && e.kind == BattleEventKind.Stun), "Projectile did not stun");
        Check(!record.events.Any(e => e.actorId == 1 && e.kind == BattleEventKind.Action && (e.state.animationState == "Skill2" || e.state.animationState == "Skill3" || e.state.animationState == "Skill4")), "Locked skill cast");
        foreach (var p in record.projectiles)
        {
            Check(p.startTick < p.endTick, "Projectile did not travel");
            if (p.hit) Check(record.events.Any(e => e.tick == p.endTick && e.actorId == p.actorId && e.targetId == p.targetId && e.kind == BattleEventKind.Stun), "Stun timing differs from recorded hit");
        }
        var loaded = ReplayArchive.Decode(ReplayArchive.Encode(record));
        var timeline = new ReplayTimeline(loaded);
        var reference = loaded.initial.ToDictionary(f => f.id, f => f.Copy());
        int cursor = 0;
        for (int tick = 0; tick <= loaded.durationTicks; tick++)
        {
            while (cursor < loaded.events.Count && loaded.events[cursor].tick <= tick)
            { var e = loaded.events[cursor++]; if (e.hasState) reference[e.state.id] = e.state.Copy(); }
            timeline.Seek(tick);
            foreach (var f in reference.Values) Check(JsonUtility.ToJson(f) == JsonUtility.ToJson(timeline.States[f.id]), "Seek differs at " + tick);
        }
        // Frozen source data must survive later balancing.
        int frozen = loaded.loadouts[0].hero.NormalAttack.Effects[0].DamageScaleBasisPoints;
        loadouts[0].hero.NormalAttack.Effects[0].DamageScaleBasisPoints = 1;
        Check(record.loadouts[0].hero.NormalAttack.Effects[0].DamageScaleBasisPoints == frozen, "Caller mutated battle config");
        var promoted = catalog.CreateHero("leenald", "test-promoted");
        for (int rank = 0; rank < 3; rank++)
        {
            foreach (var slot in HeroProgression.CurrentRank(promoted, catalog).EquipmentSlots)
                HeroProgression.Equip(promoted, catalog, slot.Id, slot.RequiredItemId);
            HeroProgression.Promote(promoted, catalog);
        }
        var promotedData = HeroBattleFactory.Create(promoted, catalog);
        var duel = PrototypeTeams.Create("balanced").Where(f => f.id == 1 || f.id == 101).ToList();
        duel[0].x = 0; duel[0].range = 100; duel[0].hp = duel[0].maxHp = 50000;
        duel[1].x = 90; duel[1].hp = duel[1].maxHp = 100000; duel[1].attack = 20;
        var advanced = new BattleSimulation(Guid.NewGuid().ToString("N"), "balanced", 123, duel,
            new System.Collections.Generic.List<FighterLoadout> { new FighterLoadout { fighterId = 1, hero = promotedData } }).RunToCompletion();
        Check(advanced.projectiles.Any(p => p.resource.EndsWith("Skill2_Projectile") && p.hit), "Skill2 projectile did not hit");
        Check(advanced.events.Any(e => e.hasState && e.state.knockUpUntil > e.tick), "Skill2 did not knock up");
        Check(advanced.events.Any(e => e.actorId == 1 && e.kind == BattleEventKind.Heal), "Skill3 did not heal self");
        Check(advanced.events.Any(e => e.actorId == 1 && e.kind == BattleEventKind.Stun && e.ability == catalog.Skill("leenald_skill4").Name), "Skill4 did not push");
        var rig = new GameObject("VerifyReplaySprite", typeof(RectTransform));
        try
        {
            var sprite = rig.AddComponent<ReplaySprite>(); sprite.Initialize("Heroes/Leenald/AnimationSet");
            foreach (string state in new[] { "Idle", "Run", "NormalAttack", "Ultimate", "Stun", "Death" })
            {
                sprite.Sample(state, .25f, true, .9f);
                var first = rig.GetComponent<UnityEngine.UI.Image>().sprite;
                sprite.Sample(state, .5f, false, .9f);
                sprite.Sample(state, .25f, true, .9f);
                Check(first != null && rig.GetComponent<UnityEngine.UI.Image>().sprite == first, "Sprite seek changed: " + state);
            }
        }
        finally { UnityEngine.Object.DestroyImmediate(rig); }
        string directory = Path.GetFullPath(Path.Combine(Application.dataPath, "../../Artifacts/LeenaldBattle"));
        Directory.CreateDirectory(directory); File.WriteAllText(Path.Combine(directory, "record.json"), JsonUtility.ToJson(loaded));
        return new { passed = true, checks, ticks = record.durationTicks, projectiles = record.projectiles.Count, winner = record.winner };
    }
}
