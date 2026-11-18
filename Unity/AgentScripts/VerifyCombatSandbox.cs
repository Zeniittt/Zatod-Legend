using System;
using System.Linq;
using UnityEngine;
using Zatod.Combat;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Networking;

public static class VerifyCombatSandbox
{
    public static object Run()
    {
        int checks = 0;
        void Check(bool ok, string why) { checks++; if (!ok) throw new Exception(why); }
        var catalog = HeroDataJson.LoadBundledCatalog();
        string original = JsonUtility.ToJson(catalog.Data);
        var highest = HeroCombatSandbox.Ranks(catalog, "leenald").Last().Id;
        var hero = HeroCombatSandbox.TemporaryHero(catalog, "leenald", highest);
        var skills = HeroProgression.UnlockedSkills(hero, catalog);
        Check(skills.Count == 4, "Highest rank must unlock four Leenald skills");
        foreach (var slot in skills)
        {
            var settings = new HeroSandboxSettings { HeroId = "leenald", RankId = highest,
                Mode = SandboxTestMode.SingleSkill, SkillSlotId = slot.Id, DurationSeconds = 15 };
            var record = BuildIsolated(catalog, settings);
            var skill = catalog.Skill(slot.SkillId);
            Check(record.events.Count(e => e.kind == BattleEventKind.Action && e.actorId == 1 && e.ability == skill.Name) == 1, "Single-skill preview repeated or failed: " + slot.Id);
            Check(!record.events.Any(e => e.kind == BattleEventKind.Damage), "Isolated control/heal skill made basic damage");
            Check(record.initial[0].hp * 2 == record.initial[0].maxHp || Math.Abs(record.initial[0].hp * 2 - record.initial[0].maxHp) == 1, "Initial HP ignored");
            if (slot.IsUltimate)
            {
                Check(record.projectiles.Count == 1 && record.projectiles[0].hit, "Ultimate projectile missing");
                Check(record.events.Any(e => e.actorId == 1 && e.kind == BattleEventKind.Stun && e.state.stunUntil - e.tick == 30), "Ultimate stun missing");
            }
            else if (slot.Id == "skill_2")
                Check(record.events.Any(e => e.actorId == 1 && e.hasState && e.state.knockUpUntil - e.tick == 16 && e.controlKind == ControlKind.KnockUp), "Knock-up missing");
            else if (slot.Id == "skill_3")
                Check(record.events.Any(e => e.actorId == 1 && e.targetId == 1 && e.kind == BattleEventKind.Heal && e.amount == 600), "Self heal missing");
            else if (slot.Id == "skill_4")
            {
                var pushes = record.events.Where(e => e.actorId == 1 && e.kind == BattleEventKind.Stun).ToList();
                Check(pushes.Count == 2 && pushes.Any(e => e.targetId == 101) && pushes.Any(e => e.targetId == 102), "Radius 100 should hit targets at 70/90, exclude 110");
                Check(pushes.All(e => e.controlKind == ControlKind.Knockback && e.state.controlKind == ControlKind.Knockback), "Knockback label missing");
                Check(pushes.Single(e => e.targetId == 101).state.x == 170 && pushes.Single(e => e.targetId == 102).state.x == 190, "Knockback distance wrong");
            }
            var loaded = ReplayArchive.Decode(ReplayArchive.Encode(record));
            var timeline = new ReplayTimeline(loaded);
            foreach (int tick in new[] { 0, 5, 20, 80, loaded.durationTicks })
            {
                timeline.Seek(tick);
                var expected = loaded.initial.ToDictionary(f => f.id, f => f.Copy());
                foreach (var e in loaded.events.Where(e => e.tick <= tick && e.hasState)) expected[e.state.id] = e.state;
                foreach (var state in expected.Values)
                    Check(JsonUtility.ToJson(state) == JsonUtility.ToJson(timeline.States[state.id]), "Sandbox seek mismatch");
            }
        }
        var autoSettings = new HeroSandboxSettings { HeroId = "leenald", RankId = highest };
        var auto = BuildIsolated(catalog, autoSettings);
        foreach (var slot in skills)
            Check(auto.events.Any(e => e.actorId == 1 && e.kind == BattleEventKind.Action && e.ability == catalog.Skill(slot.SkillId).Name), "Auto did not exercise " + slot.Id);
        var repeated = BuildIsolated(catalog, autoSettings);
        Check(auto.events.Select(e => JsonUtility.ToJson(e)).SequenceEqual(repeated.events.Select(e => JsonUtility.ToJson(e))), "Seed/settings did not repeat same outcomes");
        foreach (var definition in catalog.Data.Heroes)
        {
            var basic = BuildIsolated(catalog, new HeroSandboxSettings { HeroId = definition.Id,
                RankId = definition.StartingRankId, Mode = SandboxTestMode.BasicAttack, DurationSeconds = 3,
                TargetDistance = Math.Min(600, Math.Max(70, definition.BaseStats.FirstOrDefault(s => s.StatId == "attack_range")?.Value / 2 ?? 70)) });
            Check(basic.initial[0].heroDefinitionId == definition.Id, "Factory hardcoded a hero");
            Check(basic.events.Any(e => e.actorId == 1 && e.kind == BattleEventKind.Damage), "No basic attack for " + definition.Id);
            Check(basic.durationTicks == 60, "Requested duration ignored");
        }
        try
        {
            BuildIsolated(catalog, new HeroSandboxSettings { HeroId = "leenald", RankId = "white", Mode = SandboxTestMode.SingleSkill, SkillSlotId = "skill_2" });
            throw new Exception("Accepted locked skill");
        }
        catch (ArgumentException) { checks++; }
        Check(JsonUtility.ToJson(catalog.Data) == original, "Sandbox changed source config");
        return new { passed = true, checks, heroes = catalog.Data.Heroes.Count, skills = skills.Count, autoSeconds = auto.DurationSeconds };
    }
    static Zatod.Combat.BattleRecord BuildIsolated(Zatod.Heroes.HeroCatalog catalog, Zatod.Editor.HeroSandboxSettings settings)
    {
        settings.MonsterIds = System.Linq.Enumerable.Repeat("fighter_goblin", settings.TargetCount).ToList();
        if (settings.TargetHp == 0) settings.TargetHp = 100000;
        if (settings.TargetSpacing == 220) settings.TargetSpacing = 20;
        var setup = Zatod.Editor.HeroCombatSandbox.Prepare(catalog, settings);
        foreach (var loadout in setup.Loadouts.Where(l => l.fighterId != 1))
        { loadout.disableBasicAttacks = true; loadout.Data.Skills.Clear(); loadout.Data.Stats.Single(s => s.StatId == "defense").Value = 0; }
        foreach (var fighter in setup.Fighters.Where(f => f.id != 1))
        { fighter.armor = 0; fighter.range = 0; fighter.projectileHurtboxHeight = 100; }
        return setup.Run();
    }
}
