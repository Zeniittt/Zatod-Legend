using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using Zatod.Animation;
using Zatod.Combat;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Presentation;

public static class VerifySkillOriginFix
{
    static Vector3 SourcePoint(ReplaySprite visual, HeroAnimationClipData clip, float sourceX, float sourceY)
    {
        int frame = Mathf.Min(clip.Frames.Count - 1, Mathf.FloorToInt(visual.SampleSeconds * clip.FramesPerSecond + .0001f));
        var crop = clip.Frames[frame]; var rect = (RectTransform)visual.transform;
        return rect.TransformPoint(new Vector3(rect.rect.xMin + (sourceX - crop.X) / crop.Width * rect.rect.width,
            rect.rect.yMin + (sourceY - crop.Y) / crop.Height * rect.rect.height, 0));
    }
    public static async Task<object> Run()
    {
        int checks = 0;
        void Check(bool ok, string why) { checks++; if (!ok) throw new Exception(why); }
        var catalog = HeroDataJson.LoadBundledCatalog(); var skill = catalog.Skill("leenald_skill2");
        var manifest = JsonUtility.FromJson<HeroAnimationSetData>(Resources.Load<TextAsset>(catalog.Hero("leenald").AnimationSetResource).text);
        var art = manifest.Clips.Single(c => c.State == "Skill2_Projectile");
        var bodyClip = manifest.Clips.Single(c => c.State == "Skill2");
        Check(skill.ProjectileSpawnPointId == "feet" && art.UseProjectileOrigin, "Skill2 origin config missing");
        Check(skill.ProjectileHitOffsetForward == Mathf.RoundToInt((art.ContentBounds[0].X - art.ProjectileOriginPixelX) * 100f / manifest.PixelsPerUnit), "Server shape offset does not match source ground gap");
        var arena = UnityEngine.Object.FindAnyObjectByType<ArenaView>();
        float[] gaps = new float[2]; int index = 0;
        foreach (int direction in new[] { 1, -1 })
        {
            var record = BuildIsolated(catalog, new HeroSandboxSettings { HeroId = "leenald", RankId = "purple", Mode = SandboxTestMode.SingleSkill,
                SkillSlotId = "skill_2", TargetCount = 1, DurationSeconds = 4 });
            if (direction < 0)
            {
                var initial = record.initial.Select(f => f.Copy()).ToList();
                foreach (var f in initial) { f.team = 1 - f.team; f.x = -f.x; }
                record = new BattleSimulation(Guid.NewGuid().ToString("N"), "mirrored-test", 123, initial, record.loadouts, 80).RunToCompletion();
            }
            var p = record.projectiles.Single();
            Check(p.hasSpawnPoint && p.spawnPointId == "feet" && p.spawnHeight == 0 && p.startX == 0, "Server did not launch from grounded foot");
            Check(p.direction == direction && p.hit && p.endX == p.startX, "Close overlap contact point was moved to victim center");
            arena.LoadSandbox(record); arena.TogglePlayback(); await Task.Delay(30);
            arena.Seek(p.startTick / 20f);
            var body = UnityEngine.Object.FindObjectsByType<ReplaySprite>().Single(v => v.transform.parent.name == "Fighter_1");
            var projectile = UnityEngine.Object.FindObjectsByType<ReplaySprite>().Single(v => v.name == "Projectile_1");
            var bodySprite = body.GetComponent<UnityEngine.UI.Image>().sprite;
            var texture = new Texture2D(2,2,TextureFormat.RGBA32,false);
            texture.LoadImage(File.ReadAllBytes(AssetDatabase.GetAssetPath(bodySprite)));
            int footEdge = -1; var pixels = texture.GetPixels32();
            for (int x = 0; x < texture.width; x++) if (pixels[(int)manifest.AnchorPixelY * texture.width + x].a > 0) footEdge = x;
            UnityEngine.Object.Destroy(texture);
            var foot = SourcePoint(body, bodyClip, footEdge, manifest.AnchorPixelY);
            var groundFx = SourcePoint(projectile, art, art.ContentBounds[0].X, art.ContentBounds[0].Y);
            var gap = body.transform.parent.InverseTransformVector(groundFx - foot);
            gaps[index++] = gap.x;
            float pixel = 100f / manifest.PixelsPerUnit * .9f;
            Check(Mathf.Abs(gap.y) < .01f, "Ground projectile is not on character foot plane");
            Check(Mathf.Abs(gap.x - direction * pixel) < .05f, "Ground eruption does not start one source pixel beyond casting foot");
            arena.Seek((p.endTick + 2) / 20f);
            Check(projectile.gameObject.activeInHierarchy, "Ground effect disappeared immediately after impact");
        }
        var push = BuildIsolated(catalog, new HeroSandboxSettings { HeroId = "leenald", RankId = "purple", Mode = SandboxTestMode.SingleSkill, SkillSlotId = "skill_4", DurationSeconds = 3 });
        int impact = push.events.First(e => e.actorId == 1 && e.kind == BattleEventKind.Stun).tick;
        arena.LoadSandbox(push); arena.TogglePlayback(); await Task.Delay(30);
        var root = GameObject.Find("Fighter_1").GetComponent<RectTransform>();
        arena.Seek((impact - 1) / 20f); float beforeScreen = root.anchoredPosition.x; int beforeWorld = arena.Timeline.States[1].x;
        arena.Seek(impact / 20f); float afterScreen = root.anchoredPosition.x;
        Check(beforeWorld == arena.Timeline.States[1].x && beforeWorld == 0, "Caster moved in server simulation");
        Check(Mathf.Abs(beforeScreen - afterScreen) < .001f, "Camera made caster slide during knockback");
        Check(push.events.Where(e => e.actorId == 1 && e.kind == BattleEventKind.Stun).All(e => e.targetId != 1 && e.state.team != 0), "Knockback applied to self/ally");
        arena.Seek(push.DurationSeconds); arena.Seek((impact - 1) / 20f);
        Check(Mathf.Abs(root.anchoredPosition.x - beforeScreen) < .001f, "Camera depends on playback/seek history");
        return new { passed = true, checks, groundGapPixels = gaps, casterScreenBefore = beforeScreen, casterScreenAfter = afterScreen };
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
