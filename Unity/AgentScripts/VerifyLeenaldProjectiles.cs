using System;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using Zatod.Animation;
using Zatod.Combat;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.Presentation;

public static class VerifyLeenaldProjectiles
{
    public static async Task<object> Run()
    {
        int checks = 0;
        void Check(bool ok, string reason) { checks++; if (!ok) throw new Exception(reason); }
        var catalog = HeroDataJson.LoadBundledCatalog();
        var manifest = JsonUtility.FromJson<HeroAnimationSetData>(Resources.Load<TextAsset>(catalog.Hero("leenald").AnimationSetResource).text);
        string restore = Directory.GetDirectories(Path.GetFullPath("../Artifacts/LeenaldOriginalBefore")).OrderByDescending(p => p).First();
        const string icon = "Assets/Zatod/Resources/HeroPortraits/leenald.png";
        foreach (string suffix in new[] { "", ".meta" })
            Check(File.ReadAllBytes(icon + suffix).SequenceEqual(File.ReadAllBytes(Path.Combine(restore, "Unity", icon + suffix))), "Icon bytes/metadata changed");
        foreach (var entry in manifest.Clips)
        {
            Check(entry.ContentBounds.Count == entry.SourceFrames.Count, "Missing opaque content bounds");
            string oldClip = File.ReadAllText(Path.Combine(restore, "Unity/Assets/Zatod/Resources/Heroes/Leenald/Animations", entry.State + ".anim"));
            var previous = Regex.Matches(oldClip, @"value: \{fileID: (-?\d+), guid: ([a-f0-9]+), type: 3\}");
            var clip = Resources.Load<AnimationClip>(entry.ClipResource);
            var keys = AnimationUtility.GetObjectReferenceCurve(clip, EditorCurveBinding.PPtrCurve("", typeof(SpriteRenderer), "m_Sprite"));
            Check(previous.Count == keys.Length, "Old/new clip frame count changed");
            for (int i = 0; i < keys.Length; i++)
            {
                AssetDatabase.TryGetGUIDAndLocalFileIdentifier(keys[i].value, out string guid, out long localId);
                Check(guid == previous[i].Groups[2].Value && localId == long.Parse(previous[i].Groups[1].Value), "Sprite GUID/local file ID changed");
            }
        }
        var arena = UnityEngine.Object.FindAnyObjectByType<ArenaView>();
        foreach (string slot in new[] { "ultimate", "skill_2" })
        {
            var record = BuildIsolated(catalog, new HeroSandboxSettings { HeroId = "leenald", RankId = "purple", Mode = SandboxTestMode.SingleSkill,
                SkillSlotId = slot, DurationSeconds = 5 });
            arena.LoadSandbox(record); arena.TogglePlayback();
            var p = record.projectiles.Single();
            string state = p.resource.Split('/').Last(); var clip = manifest.Clips.Single(c => c.State == state);
            Check(p.hit && p.endTick - p.startTick == 1, "Close-hit regression case not reproduced");
            Check(record.events.Any(e => e.kind == BattleEventKind.Stun && e.tick == p.endTick), "Hit/control timing changed");
            // Sample well after logical contact, where the old renderer had already hidden the projectile.
            float age = clip.DurationSeconds * .7f;
            arena.Seek(p.startTick / (float)record.tickRate + age);
            Canvas.ForceUpdateCanvases(); await Task.Delay(40);
            var fx = UnityEngine.Object.FindObjectsByType<ReplaySprite>().Single(s => s.name == "Projectile_1");
            var image = fx.GetComponent<UnityEngine.UI.Image>();
            var expected = Path.GetFileNameWithoutExtension(clip.SourceFrames[Mathf.FloorToInt(age * clip.FramesPerSecond)]);
            Check(fx.CurrentState == state && image.sprite != null && image.sprite.name == expected, "Projectile animation missing after impact: " + slot);
            Check(image.enabled && !image.canvasRenderer.cull && image.canvasRenderer.GetMesh().vertexCount >= 4, "Projectile has no visible canvas geometry");
            float scale = p.visualScaleBasisPoints > 0 ? .9f * p.visualScaleBasisPoints / 10000f : .65f;
            Check(image.sprite.pixelsPerUnit == 25 && image.rectTransform.sizeDelta == image.sprite.rect.size * (4 * scale), "Original art draw size changed");
            float sampled = fx.SampleSeconds;
            await Task.Delay(80); Check(fx.SampleSeconds == sampled, "Paused projectile animation advanced");
            arena.Seek((p.startTick - 1) / (float)record.tickRate); Check(!fx.gameObject.activeSelf, "Projectile shown before release");
            arena.Seek(p.startTick / (float)record.tickRate + clip.DurationSeconds + .05f); Check(!fx.gameObject.activeSelf, "Projectile visual did not expire");
            arena.Seek(p.startTick / (float)record.tickRate + age);
            Check(fx.gameObject.activeSelf && image.sprite.name == expected, "Backward seek did not restore projectile frame");
            var frame = clip.ContentBounds[Mathf.FloorToInt(age * clip.FramesPerSecond)];
            var crop = clip.Frames[Mathf.FloorToInt(age * clip.FramesPerSecond)];
            float pivotX = clip.UseProjectileOrigin ? (clip.ProjectileOriginPixelX + frame.X - clip.ContentBounds[0].X - crop.X) / crop.Width : (frame.X + frame.Width * .5f - crop.X) / crop.Width;
            Check(Mathf.Abs(image.rectTransform.pivot.x - pivotX) < .001f, "Authored horizontal motion not normalized");
        }
        return new { passed = true, checks, source = "monk_original_selected", iconPreserved = true, closeHitEffects = 2 };
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
