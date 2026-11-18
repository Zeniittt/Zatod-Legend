using System;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using UnityEditor;
using UnityEditor.Animations;
using UnityEditor.U2D;
using UnityEditor.U2D.Sprites;
using UnityEngine;
using Zatod.Animation;
using Zatod.Heroes;
using Zatod.Presentation;

public static class VerifyLeenald
{
    static int checks;
    static void Check(bool ok, string reason) { checks++; if (!ok) throw new Exception(reason); }
    static int Number(string name) { return int.Parse(Regex.Match(Path.GetFileNameWithoutExtension(name), @"_(\d+)(?:_proj)?$").Groups[1].Value); }
    static string Hash(string path) { using (var hash = SHA256.Create()) using (var stream = File.OpenRead(path)) return BitConverter.ToString(hash.ComputeHash(stream)); }
    static async Task Wait(int ms) { await Task.Delay(ms); }

    public static async Task<object> Run()
    {
        checks = 0;
        var catalog = HeroDataJson.LoadBundledCatalog(); var hero = catalog.Hero("leenald");
        Check(hero.Name == "Leenald" && hero.Position == HeroPosition.Front, "Wrong Hero identity/position");
        var owned = catalog.CreateHero("leenald", "leenald-test"); var stats = HeroStatCalculator.Calculate(owned, catalog);
        Check(stats.Get("health") == 4800 && stats.Get("damage") == 220 && stats.Get("defense") == 60 && stats.Get("attack_range") == 100, "Wrong base stats");
        foreach (int unlocked in new[] { 1, 2, 3, 4 })
        {
            Check(HeroProgression.UnlockedSkills(owned, catalog).Count == unlocked, "Skill unlock progression");
            if (unlocked == 4) break;
            foreach (var slot in HeroProgression.CurrentRank(owned, catalog).EquipmentSlots) HeroProgression.Equip(owned, catalog, slot.Id, slot.RequiredItemId);
            HeroProgression.Promote(owned, catalog);
        }
        var ultimate = catalog.Skill("leenald_ultimate"); var skill2 = catalog.Skill("leenald_skill2");
        var skill3 = catalog.Skill("leenald_skill3"); var skill4 = catalog.Skill("leenald_skill4");
        Check(ultimate.Target == SkillTarget.NearestEnemy && ultimate.Delivery == SkillDelivery.Projectile
            && ultimate.Effects.Single().Kind == SkillEffectKind.Stun && ultimate.Effects[0].DurationMilliseconds == 1500, "Ultimate target/stun");
        Check(skill2.Delivery == SkillDelivery.Projectile && skill2.Effects.Single().Kind == SkillEffectKind.KnockUp && skill2.Effects[0].KnockUpHeight > 0, "Skill2 knock-up");
        Check(skill3.Activation == SkillActivation.Automatic && skill3.Target == SkillTarget.Self && skill3.Effects.Single().Kind == SkillEffectKind.Heal && skill3.Effects[0].Amount == 600, "Skill3 self heal");
        Check(skill4.Target == SkillTarget.EnemiesInRange && skill4.EffectRadius == 100 && skill4.Effects.Single().Kind == SkillEffectKind.Knockback, "Skill4 radius/knockback");
        var copy = HeroBattleFactory.Create(owned, catalog);
        Check(copy.HasNormalAttack && copy.NormalAttack.AnimationState == "NormalAttack" && copy.NormalAttack.Effects.Single().DamageScaleBasisPoints == 10000, "Battle copy lost normal attack config");
        copy.NormalAttack.Effects[0].Amount = 999;
        Check(catalog.Skill(hero.NormalAttackSkillId).Effects[0].Amount == 0, "Normal attack snapshot shared with config");
        Check(copy.Skills[0].Definition.ProjectileResource == ultimate.ProjectileResource && copy.Skills[0].Definition.AnimationState == "Ultimate", "Battle copy lost animation/projectile config");
        var library = JsonUtility.FromJson<HeroAnimationSetData>(Resources.Load<TextAsset>(hero.AnimationSetResource).text);
        Check(library.CanvasWidth == 288 && library.CanvasHeight == 128 && library.PixelsPerUnit == 25, "Original-resolution manifest mismatch");
        Check(library.Clips.Count == 11 && library.Clips.Sum(c => c.SourceFrames.Count) == 137, "Wrong asset counts");
        int[] expectedCounts = { 6, 8, 6, 18, 12, 25, 12, 16, 7, 21, 6 }; int group = 0;
        var factories = new SpriteDataProviderFactories(); factories.Init();
        foreach (var entry in library.Clips)
        {
            Check(entry.SourceFrames.Count == expectedCounts[group++], "Wrong count: " + entry.State);
            Check(entry.SourceFrames.Select(Number).SequenceEqual(entry.SourceFrames.Select(Number).OrderBy(n => n)), "Frames sorted lexically instead of numerically");
            var clip = Resources.Load<AnimationClip>(entry.ClipResource);
            Check(clip != null && Mathf.Abs(clip.length - entry.DurationSeconds) < .001f, "Clip duration: " + entry.State);
            Check(AnimationUtility.GetAnimationClipSettings(clip).loopTime == (entry.State == "Idle" || entry.State == "Run"), "Wrong loop: " + entry.State);
            var keys = AnimationUtility.GetObjectReferenceCurve(clip, EditorCurveBinding.PPtrCurve("", typeof(SpriteRenderer), "m_Sprite"));
            Check(keys.Length == entry.SourceFrames.Count, "Missing or duplicated animation frame key");
            for (int i = 0; i < entry.SourceFrames.Count; i++)
            {
                var sprite = (Sprite)keys[i].value;
                Check(sprite != null && sprite.name == Path.GetFileNameWithoutExtension(entry.SourceFrames[i]), "Frame order mismatch: " + entry.State);
                Check(Mathf.Abs(keys[i].time - i / 12f) < .0001f && sprite.pixelsPerUnit == library.PixelsPerUnit, "Timing/PPU mismatch");
                string asset = AssetDatabase.GetAssetPath(sprite);
                Check(Hash(asset) == Hash(Path.Combine("C:/Users/tinnq/Downloads/monk_original_selected", entry.SourceFolder, entry.SourceFrames[i])), "Source artwork bytes changed");
                var importer = (TextureImporter)AssetImporter.GetAtPath(asset);
                Check(importer.filterMode == FilterMode.Point && !importer.mipmapEnabled && importer.npotScale == TextureImporterNPOTScale.None, "Pixel import settings");
                var provider = factories.GetSpriteEditorDataProviderFromObject(importer); provider.InitSpriteEditorDataProvider();
                var rect = provider.GetSpriteRects().Single();
                Check(Mathf.Abs(rect.rect.x + rect.pivot.x * rect.rect.width - library.AnchorPixelX) < .001f
                    && Mathf.Abs(rect.rect.y + rect.pivot.y * rect.rect.height - library.AnchorPixelY) < .001f, "Frame anchor drift: " + asset);
            }
        }
        Check(library.Clips.Single(c => c.State == "Stun").SourceFolder == "TakeHit" && library.Clips.Single(c => c.State == "NormalAttack").SourceFolder == "Attack", "Folder mapping");
        Check(library.Clips.Single(c => c.State == "Death").Frames.Last().Empty, "Blank final death frame lost");
        foreach (var pair in new[] { new { Body = "Ultimate", Projectile = "Ultimate_Projectile", Skill = ultimate }, new { Body = "Skill2", Projectile = "Skill2_Projectile", Skill = skill2 } })
        {
            var body = library.Clips.Single(c => c.State == pair.Body); var projectile = library.Clips.Single(c => c.State == pair.Projectile);
            int expectedSpawn = Mathf.RoundToInt((Number(projectile.SourceFrames[0]) - Number(body.SourceFrames[0])) * 1000f / 12);
            Check(pair.Skill.ProjectileSpawnMilliseconds == expectedSpawn, "Projectile spawn frame is not aligned");
            Check(Resources.Load<GameObject>(pair.Skill.ProjectileResource) != null, "Projectile prefab missing");
        }
        var controller = AssetDatabase.LoadAssetAtPath<AnimatorController>("Assets/Zatod/Resources/Heroes/Leenald/Leenald.controller");
        var states = controller.layers[0].stateMachine.states.Select(s => s.state).ToArray();
        Check(states.Length == 9 && controller.layers[0].stateMachine.defaultState.name == "Idle", "Animator state setup");
        Check(states.Single(s => s.name == "Death").transitions.Length == 0 && states.Single(s => s.name == "Stun").transitions.Length == 0, "Stun/death should hold until explicitly changed");
        var atlas = (SpriteAtlasImporter)AssetImporter.GetAtPath("Assets/Zatod/Art/Leenald/Leenald.spriteatlasv2");
        Check(atlas.includeInBuild && !atlas.packingSettings.enableRotation && atlas.textureSettings.filterMode == FilterMode.Point
            && EditorSettings.spritePackerMode == SpritePackerMode.SpriteAtlasV2, "Atlas configuration");

        var roster = UnityEngine.Object.FindAnyObjectByType<HeroRosterView>(); roster.Show();
        var ownedPreview = roster.Character.HeroDesk.Single(h => h.HeroDefinitionId == "leenald");
        Check(roster.Character.HeroDesk[0] == ownedPreview && ownedPreview.RankId == "white", "Leenald should be the first real Hero at initial rank");
        roster.OpenDetail(ownedPreview.HeroInstanceId); await Wait(100);
        var preview = UnityEngine.Object.FindAnyObjectByType<HeroModelPreview>(); var player = preview.Player;
        Check(player != null && preview.Texture != null && preview.Texture.IsCreated(), "Model render preview missing");
        var renderer = player.GetComponent<SpriteRenderer>();
        player.Play("Idle"); await Wait(180); string idle = renderer.sprite.name; await Wait(180);
        Check(renderer.sprite.name != idle, "Idle animation does not advance");
        player.Play("Run"); await Wait(850); Check(player.GetComponent<Animator>().GetCurrentAnimatorStateInfo(0).IsName("Run"), "Run should loop");
        player.Play("Stun"); await Wait(700); Check(player.GetComponent<Animator>().GetCurrentAnimatorStateInfo(0).IsName("Stun"), "Stun did not hold");
        player.Play("Death"); await Wait(1650); Check(renderer.sprite.name == "death_18", "Death does not reach blank last frame");
        player.Play("NormalAttack"); await Wait(1150); Check(player.GetComponent<Animator>().GetCurrentAnimatorStateInfo(0).IsName("Idle"), "Attack does not return to Idle");
        int spawned = player.SpawnedProjectileCount;
        player.Play("Ultimate"); await Wait(100); player.Play("Stun"); await Wait(250);
        Check(player.SpawnedProjectileCount == spawned, "Cancelled cast spawned a projectile");
        player.SetFacing(false); player.Play("Ultimate"); await Wait(370);
        Check(player.SpawnedProjectileCount == spawned + 1, "Ultimate did not spawn projectile");
        var fx = UnityEngine.Object.FindObjectsByType<ProjectileVisualLifetime>().Single();
        Check(fx.transform.position == player.transform.position && fx.transform.localScale.x < 0 && fx.gameObject.layer == 31, "Projectile origin/facing/layer mismatch");
        await Wait(1850); Check(UnityEngine.Object.FindObjectsByType<ProjectileVisualLifetime>().Length == 0, "Projectile lifetime leaked");
        player.SetFacing(true); player.Play("Skill2"); await Wait(530); Check(player.SpawnedProjectileCount == spawned + 2, "Skill2 did not spawn projectile");
        await Wait(700); player.Play("Skill3"); await Wait(1450); Check(player.GetComponent<Animator>().GetCurrentAnimatorStateInfo(0).IsName("Idle"), "Skill3 does not return to Idle");
        player.Play("Skill4"); await Wait(750); Check(player.GetComponent<Animator>().GetCurrentAnimatorStateInfo(0).IsName("Idle"), "Skill4 does not return to Idle");
        var texture = preview.Texture; roster.CloseDetail(); await Wait(100);
        Check(texture == null && !UnityEngine.Object.FindObjectsByType<Camera>().Any(c => c.name == "HeroPreviewCamera"), "Preview camera/texture leaked after closing");
        roster.OpenDetail(ownedPreview.HeroInstanceId); await Wait(100);
        Check(!Mirror.NetworkServer.active, "Animation preview started a client host");
        return new { passed = true, checks, frames = 137, clips = 11, hero = "leenald" };
    }
}
