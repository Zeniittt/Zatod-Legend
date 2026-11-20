using System;
using System.IO;
using System.Linq;
using TMPro;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEditor.Build.Reporting;
using UnityEngine;
using UnityEngine.TextCore.LowLevel;
using Zatod.Heroes;
using Zatod.Presentation;

namespace Zatod.Editor
{
    public static class FormationSetup
    {
        const string ScenePath = "Assets/Zatod/Scenes/ArenaPrototype.unity";
        const string FontPath = "Assets/Zatod/Resources/UI/FormationFont.asset";

        public static void Install()
        {
            if (EditorApplication.isPlaying) throw new InvalidOperationException("Stop Play Mode before installing formation UI.");
            var scene = UnityEngine.SceneManagement.SceneManager.GetActiveScene();
            if (scene.path != ScenePath) throw new InvalidOperationException("Open ArenaPrototype.unity before installing formation UI.");
            var arena = UnityEngine.Object.FindAnyObjectByType<ArenaView>();
            if (arena == null) throw new InvalidOperationException("Arena bootstrap is missing.");
            string backup = Path.GetFullPath(Path.Combine(Application.dataPath, "../../Artifacts/FormationBefore", DateTime.UtcNow.ToString("yyyyMMdd-HHmmss")));
            Directory.CreateDirectory(backup);
            File.Copy(ScenePath, Path.Combine(backup, "ArenaPrototype.unity"), false);
            foreach (var section in HeroDataJson.Sections) File.Copy(HeroDataJson.AssetPath(section), Path.Combine(backup, section + ".txt"), false);
            AddPreviewHeroes();
            var formation = arena.GetComponent<FormationView>();
            if (formation == null) formation = arena.gameObject.AddComponent<FormationView>();
            var heroes = arena.GetComponent<HeroRosterView>();
            if (heroes == null) heroes = arena.gameObject.AddComponent<HeroRosterView>();
            formation.Font = EnsureFont();
            EditorUtility.SetDirty(formation); EditorUtility.SetDirty(heroes); EditorSceneManager.MarkSceneDirty(scene); EditorSceneManager.SaveScene(scene);
            AssetDatabase.SaveAssets();
            Debug.Log("[FormationSetup] Formation view installed. Backup: " + backup);
        }

        public static TMP_FontAsset EnsureFont()
        {
            var font = AssetDatabase.LoadAssetAtPath<TMP_FontAsset>(FontPath);
            if (font != null) return font;
            var source = AssetDatabase.LoadAssetAtPath<Font>("Assets/TextMesh Pro/Fonts/LiberationSans.ttf");
            if (source == null) throw new InvalidOperationException("Missing bundled LiberationSans font.");
            Directory.CreateDirectory(Path.GetDirectoryName(FontPath)); AssetDatabase.Refresh();
            font = TMP_FontAsset.CreateFontAsset(source, 90, 9, GlyphRenderMode.SDFAA, 1024, 1024, AtlasPopulationMode.Dynamic, true);
            font.name = "FormationFont";
            AssetDatabase.CreateAsset(font, FontPath);
            AssetDatabase.AddObjectToAsset(font.material, font);
            foreach (var texture in font.atlasTextures) if (texture != null) AssetDatabase.AddObjectToAsset(texture, font);
            string labels = "CHỌN ĐỘI HÌNH Trước Giữa Sau Chạm Hero để thêm vào đội hình. Đội hình đã đủ 5 Hero. Chạm Hero đã chọn để bỏ chọn.";
            if (!font.TryAddCharacters(labels, out string missing)) throw new InvalidOperationException("Font is missing Vietnamese characters: " + missing);
            EditorUtility.SetDirty(font); AssetDatabase.SaveAssets(); return font;
        }

        public static string BuildWindowsPreview()
        {
            return BuildPreview("FormationPreview");
        }

        public static string BuildHeroPreview()
        {
            return BuildPreview("HeroPreview");
        }

        public static string BuildLeenaldPreview()
        {
            return BuildPreview("LeenaldPreview");
        }

        public static string BuildLeenaldBattlePreview() { return BuildPreview("LeenaldBattle"); }

        static string BuildPreview(string folder)
        {
            if (EditorApplication.isPlaying) throw new InvalidOperationException("Stop Play Mode before building.");
            string directory = Path.GetFullPath(Path.Combine(Application.dataPath, "../../Builds", folder));
            Directory.CreateDirectory(directory);
            string executable = Path.Combine(directory, "ZatodArena.exe");
            var result = BuildPipeline.BuildPlayer(new BuildPlayerOptions
            {
                scenes = new[] { ScenePath }, locationPathName = executable,
                target = BuildTarget.StandaloneWindows64, options = BuildOptions.None,
                subtarget = (int)StandaloneBuildSubtarget.Player
            });
            if (result.summary.result != BuildResult.Succeeded) throw new Exception("Formation preview build failed: " + result.summary.result);
            return executable;
        }

        public static void AddPreviewHeroes()
        {
            var source = HeroConfigFileStore.Read();
            var data = HeroDataJson.ReadDocuments(source).Data;
            var template = data.Heroes.Single(h => h.Id == "training_warrior");
            bool changed = false;
            if (string.IsNullOrEmpty(template.PortraitKey)) { template.PortraitKey = "shield"; changed = true; }
            string[] ids = { "ember_blade", "grove_warden", "ironhide", "dawn_knight", "stone_guard", "windrunner", "moon_huntress", "shadow_dancer", "frost_archer", "stormcaller", "sunweaver", "star_sage", "dawn_priestess", "night_oracle", "grove_keeper", "tide_healer", "void_scholar" };
            string[] names = { "Ember Blade", "Grove Warden", "Ironhide", "Dawn Knight", "Stone Guard", "Windrunner", "Moon Huntress", "Shadow Dancer", "Frost Archer", "Stormcaller", "Sunweaver", "Star Sage", "Dawn Priestess", "Night Oracle", "Grove Keeper", "Tide Healer", "Void Scholar" };
            string[] portraits = { "blades", "shield", "shield", "blades", "shield", "bow", "bow", "blades", "bow", "star", "star", "star", "cross", "star", "cross", "cross", "star" };
            for (int i = 0; i < ids.Length; i++)
            {
                if (data.Heroes.Any(h => h.Id == ids[i])) continue;
                var hero = JsonUtility.FromJson<HeroDefinition>(JsonUtility.ToJson(template));
                hero.Id = ids[i]; hero.Name = names[i]; hero.Position = i < 5 ? HeroPosition.Front : i < 11 ? HeroPosition.Middle : HeroPosition.Rear;
                hero.PortraitKey = portraits[i]; data.Heroes.Add(hero); changed = true;
            }
            if (changed) { data.ConfigVersion += "-formation-1"; HeroConfigFileStore.Save(data, source); }
        }
    }
}
