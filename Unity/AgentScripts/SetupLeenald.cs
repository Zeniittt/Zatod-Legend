using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEditor.Animations;
using UnityEditor.U2D.Sprites;
using UnityEngine;
using Zatod.Animation;
using Zatod.Editor;
using Zatod.Heroes;

public static class SetupLeenald
{
    const string Source = "C:/Users/tinnq/Downloads/monk_x4_selected_v3";
    const string Art = "Assets/Zatod/Art/Leenald";
    const string Root = "Assets/Zatod/Resources/Heroes/Leenald";
    const string Key = "Heroes/Leenald/";
    static readonly Vector2 Anchor = new Vector2(576, 28);
    static readonly string[] States = { "Idle", "Run", "Stun", "Death", "NormalAttack", "Ultimate", "Skill2", "Skill3", "Skill4", "Ultimate_Projectile", "Skill2_Projectile" };
    static readonly string[] Folders = { "Idle", "Run", "TakeHit", "Death", "Attack", "Ultimate", "Skill2", "Skill3", "Skill4", "Ultimate_Projectile", "Skill2_Projectile" };
    static readonly int[] Counts = { 6, 8, 6, 18, 12, 25, 12, 16, 7, 21, 6 };

    public static object Run()
    {
        if (EditorApplication.isPlaying) throw new InvalidOperationException("Stop Play Mode before importing Leenald.");
        var oldDocuments = HeroConfigFileStore.Read();
        var data = HeroDataJson.ReadDocuments(oldDocuments).Data;
        if (data.Heroes.Any(h => h.Id == "leenald")) throw new InvalidOperationException("Leenald already exists; this initial setup will not overwrite balanced data.");
        string backup = Path.GetFullPath(Path.Combine(Application.dataPath, "../../Artifacts/LeenaldBefore", DateTime.UtcNow.ToString("yyyyMMdd-HHmmss")));
        Directory.CreateDirectory(backup);
        foreach (var section in HeroDataJson.Sections) File.WriteAllText(Path.Combine(backup, section + ".txt"), oldDocuments.Get(section));
        Directory.CreateDirectory(Art); Directory.CreateDirectory(Root + "/Animations"); Directory.CreateDirectory("Assets/Zatod/Resources/HeroPortraits");
        var library = new HeroAnimationSetData { HeroId = "leenald" };
        var clips = new Dictionary<string, AnimationClip>(StringComparer.Ordinal);
        int total = 0;
        for (int group = 0; group < States.Length; group++)
        {
            string state = States[group], folder = Folders[group];
            var files = Directory.GetFiles(Path.Combine(Source, folder), "*.png").OrderBy(FrameNumber).ToArray();
            if (files.Length != Counts[group]) throw new InvalidDataException("Unexpected frame count in " + folder);
            Directory.CreateDirectory(Art + "/" + folder); AssetDatabase.Refresh();
            var entry = new HeroAnimationClipData { State = state, SourceFolder = folder, ClipResource = Key + "Animations/" + state, Loop = state == "Idle" || state == "Run", Projectile = group >= 9 };
            var sprites = new List<Sprite>();
            foreach (string source in files)
            {
                string path = Art + "/" + folder + "/" + Path.GetFileName(source);
                CopyUnchanged(source, path);
                var bounds = ReadBounds(source);
                sprites.Add(ImportFrame(path, bounds)); entry.Frames.Add(bounds); entry.SourceFrames.Add(Path.GetFileName(source)); total++;
            }
            clips.Add(state, CreateClip(state, sprites, entry.Loop)); library.Clips.Add(entry);
            Debug.Log("[LeenaldImport] " + state + ": " + files.Length + " naturally ordered frames");
        }
        CopyUnchanged(Path.Combine(Source, "monk_icon_256.png"), "Assets/Zatod/Resources/HeroPortraits/leenald.png");
        AssetDatabase.ImportAsset("Assets/Zatod/Resources/HeroPortraits/leenald.png");
        var iconImporter = (TextureImporter)AssetImporter.GetAtPath("Assets/Zatod/Resources/HeroPortraits/leenald.png");
        iconImporter.textureType = TextureImporterType.Sprite; iconImporter.spriteImportMode = SpriteImportMode.Single;
        iconImporter.filterMode = FilterMode.Point; iconImporter.mipmapEnabled = false; iconImporter.textureCompression = TextureImporterCompression.Uncompressed;
        var iconSettings = new TextureImporterSettings(); iconImporter.ReadTextureSettings(iconSettings);
        iconSettings.spriteAlignment = (int)SpriteAlignment.Center; iconImporter.SetTextureSettings(iconSettings); iconImporter.SaveAndReimport();
        CopyUnchanged(Path.Combine(Source, "projectile_bboxes.json"), Art + "/projectile_bboxes.json");
        CopyUnchanged(Path.Combine(Source, "README.txt"), Art + "/SourceNotes.txt");
        var material = AssetDatabase.LoadAssetAtPath<Material>(Root + "/LeenaldSprite.mat");
        if (material == null)
        {
            var shader = Shader.Find("Universal Render Pipeline/2D/Sprite-Unlit-Default");
            if (shader == null) throw new InvalidOperationException("URP 2D unlit sprite shader is missing.");
            material = new Material(shader); AssetDatabase.CreateAsset(material, Root + "/LeenaldSprite.mat");
        }
        var bodyController = CreateController("Leenald", clips.Where(p => !p.Key.EndsWith("_Projectile")).ToDictionary(p => p.Key, p => p.Value), true);
        CreatePrefab("Leenald", bodyController, FirstSprite(clips["Idle"]), material, 0);
        foreach (var entry in library.Clips.Where(c => c.Projectile))
        {
            var controller = CreateController(entry.State, new Dictionary<string, AnimationClip> { { entry.State, clips[entry.State] } }, false);
            CreatePrefab(entry.State, controller, FirstSprite(clips[entry.State]), material, entry.DurationSeconds);
        }
        HeroDataJson.WriteFileAtomically(Root + "/AnimationSet.txt", JsonUtility.ToJson(library, true));
        Configure(data);
        HeroConfigFileStore.Save(data, oldDocuments);
        AssetDatabase.Refresh(); LeenaldAtlasBuild.Ensure(); AssetDatabase.SaveAssets();
        foreach (var window in Resources.FindObjectsOfTypeAll<GameEditorWindow>()) window.ReloadIfClean();
        return new { status = "PASS", frames = total, animations = library.Clips.Count, hero = "leenald", data.ConfigVersion, backup, packer = EditorSettings.spritePackerMode.ToString() };
    }

    static int FrameNumber(string path)
    {
        var match = Regex.Match(Path.GetFileNameWithoutExtension(path), @"_(\d+)(?:_proj)?$");
        if (!match.Success) throw new InvalidDataException("Missing numeric frame suffix: " + path);
        return int.Parse(match.Groups[1].Value, System.Globalization.CultureInfo.InvariantCulture);
    }

    static void CopyUnchanged(string source, string path)
    {
        if (File.Exists(path))
        {
            if (!File.ReadAllBytes(source).SequenceEqual(File.ReadAllBytes(path))) throw new IOException("Destination already contains different artwork: " + path);
        }
        else File.Copy(source, path, false);
    }

    static HeroFrameBounds ReadBounds(string source)
    {
        var texture = new Texture2D(2, 2, TextureFormat.RGBA32, false);
        try
        {
            if (!texture.LoadImage(File.ReadAllBytes(source)) || texture.width != 1152 || texture.height != 512) throw new InvalidDataException("Expected 1152x512 RGBA canvas: " + source);
            var pixels = texture.GetPixels32(); int minX = 1152, minY = 512, maxX = -1, maxY = -1;
            for (int y = 0; y < texture.height; y++) for (int x = 0; x < texture.width; x++)
                if (pixels[y * texture.width + x].a != 0) { minX = Math.Min(minX, x); minY = Math.Min(minY, y); maxX = Math.Max(maxX, x); maxY = Math.Max(maxY, y); }
            bool empty = maxX < 0;
            if (empty) return new HeroFrameBounds { X = 574, Y = 26, Width = 4, Height = 4, Empty = true };
            minX = Math.Max(0, Math.Min(minX, (int)Anchor.x) - 2); minY = Math.Max(0, Math.Min(minY, (int)Anchor.y) - 2);
            maxX = Math.Min(1151, Math.Max(maxX, (int)Anchor.x) + 2); maxY = Math.Min(511, Math.Max(maxY, (int)Anchor.y) + 2);
            return new HeroFrameBounds { X = minX, Y = minY, Width = maxX - minX + 1, Height = maxY - minY + 1 };
        }
        finally { UnityEngine.Object.DestroyImmediate(texture); }
    }

    static Sprite ImportFrame(string path, HeroFrameBounds bounds)
    {
        AssetDatabase.ImportAsset(path);
        var importer = (TextureImporter)AssetImporter.GetAtPath(path);
        importer.textureType = TextureImporterType.Sprite; importer.spriteImportMode = SpriteImportMode.Multiple;
        importer.spritePixelsPerUnit = 100; importer.filterMode = FilterMode.Point; importer.mipmapEnabled = false;
        importer.textureCompression = TextureImporterCompression.Uncompressed; importer.npotScale = TextureImporterNPOTScale.None;
        importer.maxTextureSize = 2048; importer.SaveAndReimport();
        var factories = new SpriteDataProviderFactories(); factories.Init();
        var provider = factories.GetSpriteEditorDataProviderFromObject(importer);
        if (provider == null) throw new InvalidOperationException("Sprite data provider is missing: " + path);
        provider.InitSpriteEditorDataProvider();
        var edit = provider.GetDataProvider<ISpriteFrameEditCapability>();
        if (edit == null) throw new InvalidOperationException("Sprite editing capability is unavailable: " + path);
        var capabilities = edit.GetEditCapability();
        foreach (var required in new[] { EEditCapability.CreateAndDeleteSprite, EEditCapability.EditSpriteRect, EEditCapability.EditPivot, EEditCapability.EditSpriteName })
            if (!capabilities.HasCapability(required)) throw new InvalidOperationException("Missing sprite edit capability " + required + ": " + path);
        var old = provider.GetSpriteRects();
        var rect = new SpriteRect
        {
            name = Path.GetFileNameWithoutExtension(path), spriteID = old.Length == 1 ? old[0].spriteID : GUID.Generate(),
            rect = new Rect(bounds.X, bounds.Y, bounds.Width, bounds.Height), alignment = SpriteAlignment.Custom,
            pivot = new Vector2((Anchor.x - bounds.X) / bounds.Width, (Anchor.y - bounds.Y) / bounds.Height)
        };
        provider.SetSpriteRects(new[] { rect });
        var names = provider.GetDataProvider<ISpriteNameFileIdDataProvider>();
        if (names != null) names.SetNameFileIdPairs(new[] { new SpriteNameFileIdPair(rect.name, rect.spriteID) });
        provider.Apply(); importer.SaveAndReimport();
        return AssetDatabase.LoadAllAssetsAtPath(path).OfType<Sprite>().Single();
    }

    static AnimationClip CreateClip(string state, List<Sprite> sprites, bool loop)
    {
        string path = Root + "/Animations/" + state + ".anim";
        var clip = AssetDatabase.LoadAssetAtPath<AnimationClip>(path);
        if (clip == null) { clip = new AnimationClip(); AssetDatabase.CreateAsset(clip, path); }
        clip.name = state; clip.frameRate = 12;
        var keys = sprites.Select((sprite, index) => new ObjectReferenceKeyframe { time = index / 12f, value = sprite }).ToList();
        AnimationUtility.SetObjectReferenceCurve(clip, EditorCurveBinding.PPtrCurve("", typeof(SpriteRenderer), "m_Sprite"), keys.ToArray());
        var settings = AnimationUtility.GetAnimationClipSettings(clip); settings.loopTime = loop; settings.startTime = 0; settings.stopTime = sprites.Count / 12f;
        AnimationUtility.SetAnimationClipSettings(clip, settings);
        EditorUtility.SetDirty(clip); return clip;
    }

    public static object RepairClipTiming()
    {
        if (EditorApplication.isPlaying) throw new InvalidOperationException("Stop Play Mode before repairing clips.");
        var library = JsonUtility.FromJson<HeroAnimationSetData>(File.ReadAllText(Root + "/AnimationSet.txt"));
        foreach (var entry in library.Clips)
        {
            var clip = AssetDatabase.LoadAssetAtPath<AnimationClip>(Root + "/Animations/" + entry.State + ".anim");
            var keys = AnimationUtility.GetObjectReferenceCurve(clip, EditorCurveBinding.PPtrCurve("", typeof(SpriteRenderer), "m_Sprite"));
            CreateClip(entry.State, keys.Take(entry.SourceFrames.Count).Select(k => (Sprite)k.value).ToList(), entry.Loop);
        }
        AssetDatabase.SaveAssets(); return "Clip duration matches frame count / 12 FPS";
    }

    static AnimatorController CreateController(string name, Dictionary<string, AnimationClip> clips, bool body)
    {
        string path = Root + "/" + name + ".controller";
        var existing = AssetDatabase.LoadAssetAtPath<AnimatorController>(path);
        if (existing != null) return existing;
        var controller = AnimatorController.CreateAnimatorControllerAtPath(path);
        var machine = controller.layers[0].stateMachine;
        var states = new Dictionary<string, AnimatorState>(); int index = 0;
        foreach (var pair in clips)
        {
            var state = machine.AddState(pair.Key, new Vector3((index % 3) * 240, (index / 3) * 90, 0));
            state.motion = pair.Value; state.writeDefaultValues = false; states.Add(pair.Key, state); index++;
        }
        machine.defaultState = body ? states["Idle"] : states.Values.First();
        if (body) foreach (string action in new[] { "NormalAttack", "Ultimate", "Skill2", "Skill3", "Skill4" })
        {
            var transition = states[action].AddTransition(states["Idle"]); transition.hasExitTime = true; transition.exitTime = 1;
            transition.hasFixedDuration = true; transition.duration = 0;
        }
        EditorUtility.SetDirty(controller); return controller;
    }

    static Sprite FirstSprite(AnimationClip clip)
    {
        return (Sprite)AnimationUtility.GetObjectReferenceCurve(clip, EditorCurveBinding.PPtrCurve("", typeof(SpriteRenderer), "m_Sprite"))[0].value;
    }

    static void CreatePrefab(string name, AnimatorController controller, Sprite first, Material material, float projectileLife)
    {
        var go = new GameObject(name);
        try
        {
            var renderer = go.AddComponent<SpriteRenderer>(); renderer.sprite = first; renderer.sharedMaterial = material; renderer.sortingOrder = projectileLife > 0 ? 1 : 0;
            var animator = go.AddComponent<Animator>(); animator.runtimeAnimatorController = controller; animator.updateMode = AnimatorUpdateMode.UnscaledTime;
            if (projectileLife > 0) go.AddComponent<ProjectileVisualLifetime>().LifetimeSeconds = projectileLife;
            else go.AddComponent<HeroAnimationPlayer>().HeroId = "leenald";
            PrefabUtility.SaveAsPrefabAsset(go, Root + "/" + name + ".prefab");
        }
        finally { UnityEngine.Object.DestroyImmediate(go); }
    }

    static void Configure(HeroCatalogData data)
    {
        var hero = JsonUtility.FromJson<HeroDefinition>(JsonUtility.ToJson(data.Heroes.Single(h => h.Id == "training_warrior")));
        hero.Id = "leenald"; hero.Name = "Leenald"; hero.Position = HeroPosition.Front; hero.PortraitKey = "leenald";
        hero.BodyPrefabResource = Key + "Leenald"; hero.AnimationSetResource = Key + "AnimationSet"; hero.NormalAttackSkillId = "leenald_normal_attack";
        hero.BaseStats = new List<StatValue> { new StatValue("health", 4800), new StatValue("damage", 220), new StatValue("defense", 60), new StatValue("attack_range", 100), new StatValue("move_speed", 1600), new StatValue("attack_interval", 26) };
        hero.SkillSlots = new List<HeroSkillSlotDefinition>
        {
            new HeroSkillSlotDefinition { Id = "ultimate", SkillId = "leenald_ultimate", IsUltimate = true },
            new HeroSkillSlotDefinition { Id = "skill_2", SkillId = "leenald_skill2" },
            new HeroSkillSlotDefinition { Id = "skill_3", SkillId = "leenald_skill3" },
            new HeroSkillSlotDefinition { Id = "skill_4", SkillId = "leenald_skill4" }
        };
        data.Heroes.Add(hero);
        data.Skills.Add(new SkillDefinition
        {
            Id = hero.NormalAttackSkillId, Name = "Leenald / Normal Attack", Kind = SkillKind.Active, Activation = SkillActivation.Automatic,
            Target = SkillTarget.NearestEnemy, AnimationState = "NormalAttack", CastRange = 100, WindupMilliseconds = 417, RecoveryMilliseconds = 583,
            Effects = new List<SkillEffectDefinition> { new SkillEffectDefinition { Kind = SkillEffectKind.Damage, DamageScaleBasisPoints = 10000 } }
        });
        data.Skills.Add(new SkillDefinition
        {
            Id = "leenald_ultimate", Name = "Leenald / Earth Seal", Kind = SkillKind.Active, Activation = SkillActivation.UltimateIntent,
            Target = SkillTarget.NearestEnemy, AnimationState = "Ultimate", EnergyCost = 100, CastRange = 1000,
            WindupMilliseconds = 250, RecoveryMilliseconds = 1833, Delivery = SkillDelivery.Projectile,
            ProjectileResource = Key + "Ultimate_Projectile", ProjectileAim = ProjectileAim.TargetPosition,
            ProjectileSpawnMilliseconds = 250, ProjectileSpeed = 1200, ProjectileHitRadius = 60, ProjectileLifetimeMilliseconds = 1750, ProjectileMaxHits = 1,
            Effects = new List<SkillEffectDefinition> { new SkillEffectDefinition { Kind = SkillEffectKind.Stun, DurationMilliseconds = 1500 } }
        });
        data.Skills.Add(new SkillDefinition
        {
            Id = "leenald_skill2", Name = "Leenald / Rising Stone", Kind = SkillKind.Active, Activation = SkillActivation.Automatic,
            Target = SkillTarget.NearestEnemy, AnimationState = "Skill2", CooldownMilliseconds = 6000, CastRange = 700,
            WindupMilliseconds = 417, RecoveryMilliseconds = 583, Delivery = SkillDelivery.Projectile,
            ProjectileResource = Key + "Skill2_Projectile", ProjectileAim = ProjectileAim.Forward,
            ProjectileSpawnMilliseconds = 417, ProjectileSpeed = 1400, ProjectileHitRadius = 60, ProjectileLifetimeMilliseconds = 500, ProjectileMaxHits = 1,
            Effects = new List<SkillEffectDefinition> { new SkillEffectDefinition { Kind = SkillEffectKind.KnockUp, DurationMilliseconds = 800, KnockUpHeight = 100 } }
        });
        data.Skills.Add(new SkillDefinition
        {
            Id = "leenald_skill3", Name = "Leenald / Meditation", Kind = SkillKind.Active, Activation = SkillActivation.Automatic,
            Target = SkillTarget.Self, AnimationState = "Skill3", CooldownMilliseconds = 8000, WindupMilliseconds = 667, RecoveryMilliseconds = 666,
            Effects = new List<SkillEffectDefinition> { new SkillEffectDefinition { Kind = SkillEffectKind.Heal, Amount = 600 } }
        });
        data.Skills.Add(new SkillDefinition
        {
            Id = "leenald_skill4", Name = "Leenald / Repelling Palm", Kind = SkillKind.Active, Activation = SkillActivation.Automatic,
            Target = SkillTarget.EnemiesInRange, AnimationState = "Skill4", CooldownMilliseconds = 7000, CastRange = 100, EffectRadius = 100,
            WindupMilliseconds = 167, RecoveryMilliseconds = 416,
            Effects = new List<SkillEffectDefinition> { new SkillEffectDefinition { Kind = SkillEffectKind.Knockback, DurationMilliseconds = 250, DisplacementDistance = 100 } }
        });
        data.ConfigVersion += "-leenald-1";
    }
}
