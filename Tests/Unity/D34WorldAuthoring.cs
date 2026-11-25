// Run in Edit Mode through Unity Pipeline in the disposable validation workspace.
using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Editor;
using Zatod.Heroes;
using Zatod.World;

public static class D34WorldAuthoring
{
    public static object Run(string report)
    {
        if (EditorApplication.isPlaying || !Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/") ||
            Application.platform != RuntimePlatform.OSXEditor)
            throw new InvalidOperationException("Use the isolated macOS validation Editor in Edit Mode.");

        int checks = 0;
        void Check(bool ok, string error)
        {
            checks++;
            if (!ok) throw new InvalidOperationException(error);
        }

        const string indexPath = WorldConfigFileStore.IndexPath;
        string campaignPath = CampaignDataJson.AssetPath;
        var world = WorldConfigFileStore.Read();
        var town = world.Maps.Single(map => map.Draft.Id == "town");
        string progressionPath = ProgressionDataJson.AssetPath;
        var originals = new[] { indexPath, campaignPath, town.AssetPath, progressionPath }
            .Concat(HeroDataJson.Sections.Select(HeroDataJson.AssetPath)).ToDictionary(path => path, File.ReadAllBytes);
        string campaignSource = File.ReadAllText(campaignPath);
        string folder = "fixture_d34_" + Guid.NewGuid().ToString("N");
        string resource = "Data/WorldMaps/" + folder + "/island";
        string mapPath = WorldConfigFileStore.MapAssetPath(resource);
        string directory = Path.GetDirectoryName(mapPath);
        var heroes = HeroDataJson.LoadBundledCatalog();
        var data = JsonUtility.FromJson<CampaignDefinition>(campaignSource);
        var savedCampaign = new CampaignCatalog(JsonUtility.FromJson<CampaignDefinition>(campaignSource), heroes);
        var marker = town.Draft.Interactions.First(point => point.Kind == WorldInteractionKind.Portal);
        const string fixture = "fixture_d34";
        const string stageId = fixture + "_stage";
        float fixtureOrigin=world.Maps.Max(map=>map.Draft.OriginX+map.Draft.MaxX)+60;

        try
        {
            Directory.CreateDirectory(directory);
            var island = new WorldMapDefinition
            {
                Id = fixture, Name = "Fixture island", OriginX = fixtureOrigin, MinX = 0, MinY = 0, MaxX = 50, MaxY = 40,
                VisualResource = world.Maps.Single(map => map.Draft.Id == "chapter_two").Draft.VisualResource,
                Spawns = { new WorldSpawnPoint { Id = "entry", X = 4, Y = 6 } },
                Interactions =
                {
                    new WorldInteractionDefinition { Id = "return", Kind = WorldInteractionKind.Portal, TargetId = "town", VisualResource = marker.VisualResource, X = 8, Y = 8 },
                    new WorldInteractionDefinition { Id = "stage", Kind = WorldInteractionKind.Stage, TargetId = stageId, VisualResource = marker.VisualResource, X = 16, Y = 8 }
                }
            };
            HeroDataJson.WriteFileAtomically(mapPath, JsonUtility.ToJson(island, true));
            WorldConfigFileStore.Attach(world, resource);
            Check(world.Changed && world.Maps.Last().Draft.Id == fixture && SameBytes(indexPath), "Attaching a draft changed the index on disk.");
            Reject(() => WorldConfigFileStore.Attach(world, resource), "already references:");

            town.Draft.Interactions.Add(new WorldInteractionDefinition
            {
                Id = "fixture_gate", Kind = WorldInteractionKind.Portal, TargetId = fixture, VisualResource = marker.VisualResource, X = marker.X, Y = marker.Y
            });
            var chapter = new CampaignChapterDefinition { Id = fixture, Name = island.Name, WorldMapId = island.Id };
            chapter.Stages.Add(new CampaignStageDefinition
            {
                Id = stageId, Name = "Fixture encounter", RequiredStageId = data.Chapters.Last().Stages.Last().Id,
                DropItems = { new CampaignDropItemDefinition { ItemId = heroes.Data.Items[0].DefinitionId } },
                Waves = { new WaveDefinition { Id = "fixture_wave", Index = 1, BackgroundResource = "fixture.png",
                    Enemies = { new WaveSpawnDefinition { Id = "fixture_enemy", Kind = SpawnKind.Monster, DefinitionId = heroes.Data.Monsters[0].Id } } } }
            });
            data.Chapters.Add(chapter);
            var combined = new CampaignCatalog(data, heroes);
            Reject(() => WorldConfigFileStore.Save(world, savedCampaign), "Unknown stage at world entrance:");
            Reject(() => WorldConfigFileStore.SaveCampaignAndMaps(world, combined, campaignSource + "\n"), "Campaign config changed on disk.");
            Check(originals.Keys.All(SameBytes), "A rejected save modified live configs.");

            world.Maps.Last().Draft.Name += " changed";
            var islandBefore = File.ReadAllBytes(mapPath);
            try
            {
                Permissions("555");
                bool refused = false;
                try { WorldConfigFileStore.SaveCampaignAndMaps(world, combined, campaignSource); }
                catch (Exception e) when (e is IOException || e is UnauthorizedAccessException) { refused = true; }
                Check(refused && originals.Keys.All(SameBytes) && File.ReadAllBytes(mapPath).SequenceEqual(islandBefore) && world.Changed,
                    "A mid-save write failure did not roll back all files and preserve the draft.");
            }
            finally { Permissions("755"); }

            Check(WorldConfigFileStore.SaveCampaignAndMaps(world, combined, campaignSource) == 3 && !world.Changed,
                "The combined save or draft baseline failed.");
            var published = new CampaignCatalog(JsonUtility.FromJson<CampaignDefinition>(File.ReadAllText(campaignPath)), heroes);
            var reloaded = WorldConfigFileStore.Read();
            var compiled = WorldConfigFileStore.Validate(reloaded, published);
            Check(compiled.Map(fixture).Interactions.Single(point => point.Id == "stage").TargetId == stageId,
                "Stage entrance did not survive save/reload.");
            Check(compiled.Spawn(fixture, "entry").X == fixtureOrigin+4 && reloaded.Maps.Last().Draft.Spawns[0].X == 4,
                "The save mixed local and compiled world coordinates.");
            var runtime = WorldDataJson.Load(published);
            Check(runtime.Spawn(fixture, "entry").X == fixtureOrigin+4 && runtime.Interaction("town", "fixture_gate").TargetId == fixture,
                "The runtime resource loader did not see the published route.");

            SaveAllThroughEditor();
        }
        finally
        {
            foreach (var original in originals)
            {
                if (!SameBytes(original.Key)) File.WriteAllBytes(original.Key, original.Value);
                AssetDatabase.ImportAsset(original.Key);
            }
            ProgressionDataJson.ResetCache();
            if (!AssetDatabase.DeleteAsset(directory) && Directory.Exists(directory)) Directory.Delete(directory, true);
        }
        Check(originals.Keys.All(SameBytes) && !File.Exists(mapPath), "The isolated workspace was not restored.");
        var output = new { State = "PASS", Checks = checks, Rollback = true, Restored = true };
        File.WriteAllText(report, Newtonsoft.Json.JsonConvert.SerializeObject(output));
        return output;

        bool SameBytes(string path) => File.ReadAllBytes(path).SequenceEqual(originals[path]);
        void Reject(Action action, string expected)
        {
            string message = null;
            try { action(); } catch (Exception error) when (error is ArgumentException || error is IOException) { message = error.Message; }
            Check(message != null && message.Contains(expected), "Expected " + expected + "; got " + message);
        }
        void Permissions(string mode)
        {
            using var process = Process.Start(new ProcessStartInfo("/bin/chmod", mode + " " + directory) { UseShellExecute = false, CreateNoWindow = true });
            if (process == null || !process.WaitForExit(5000) || process.ExitCode != 0)
                throw new IOException("Could not set permissions for the fixture directory.");
        }

        void SaveAllThroughEditor()
        {
            var bom = new byte[] { 0xEF, 0xBB, 0xBF };
            if (!originals[progressionPath].Take(bom.Length).SequenceEqual(bom))
                File.WriteAllBytes(progressionPath, bom.Concat(originals[progressionPath]).ToArray());
            AssetDatabase.ImportAsset(progressionPath, ImportAssetOptions.ForceUpdate);
            var before = originals.Keys.Append(mapPath).ToDictionary(path => path, File.ReadAllBytes);
            string backupRoot = Path.GetFullPath("../Artifacts/ZatodConfigBefore");
            var previousBackups = Directory.GetDirectories(backupRoot, "all-*");
            const BindingFlags members = BindingFlags.Instance | BindingFlags.NonPublic;
            var window = ScriptableObject.CreateInstance<GameEditorWindow>();
            T Get<T>(string name) => (T)typeof(GameEditorWindow).GetField(name, members).GetValue(window);
            void Set(string name, object value) => typeof(GameEditorWindow).GetField(name, members).SetValue(window, value);
            try
            {
                window.CreateGUI();
                var heroDraft = Get<HeroCatalogData>("draft");
                var campaignDraft = Get<CampaignDefinition>("campaignDraft");
                var progressionDraft = Get<ProgressionDefinition>("progressionDraft");
                var worldDraft = Get<WorldConfigDocuments>("worldDocuments");
                heroDraft.ConfigVersion += "-transaction-fixture";
                heroDraft.Heroes[0].Name += " fixture";
                campaignDraft.Chapters.Last().Stages.Last().Name += " fixture";
                progressionDraft.InitialGold++;
                worldDraft.Index.ConfigVersion += "-transaction-fixture";
                worldDraft.Maps.Last().Draft.Name += " publish";
                Set("draftJson", JsonUtility.ToJson(heroDraft, true));
                Set("campaignJson", JsonUtility.ToJson(campaignDraft, true));
                Set("progressionJson", JsonUtility.ToJson(progressionDraft, true));
                typeof(GameEditorWindow).GetMethod("UpdateDirtyState", members).Invoke(window, null);
                Check(window.hasUnsavedChanges, "The combined draft was not marked dirty.");

                try
                {
                    Permissions("555");
                    window.SaveConfig();
                    Check(Get<Label>("status").text.StartsWith("ERROR", StringComparison.Ordinal),
                        "Save all reported success despite the unwritable island.");
                    Check(before.All(file => File.ReadAllBytes(file.Key).SequenceEqual(file.Value)),
                        "Save all left a Hero, progression, Campaign, or world file changed after rollback.");
                    Check(window.hasUnsavedChanges && Get<HeroCatalogData>("draft").ConfigVersion == heroDraft.ConfigVersion &&
                        Get<WorldConfigDocuments>("worldDocuments").Changed,
                        "The unsuccessful save discarded or advanced a draft baseline.");
                    string backup = Directory.GetDirectories(backupRoot, "all-*").Except(previousBackups).Single();
                    Check(new[] { "Progression.txt", "Skills.txt", "Campaigns.txt", "Worlds.txt" }.All(file =>
                        File.ReadAllBytes(Path.Combine(backup,file)).SequenceEqual(before[HeroDataJson.ConfigAssetDirectory + "/" + file])),
                        "The transaction recovery files did not match the original bytes.");
                }
                finally { Permissions("755"); }

                window.SaveConfig();
                Check(!window.hasUnsavedChanges && Get<Label>("status").text.StartsWith("SAVED", StringComparison.Ordinal),
                    "Retry did not publish the original draft or clear its dirty state.");
                var savedHeroes = HeroDataJson.LoadBundledCatalog();
                var savedCampaign = CampaignDataJson.LoadZatod(savedHeroes);
                var savedWorld = WorldDataJson.Load(savedCampaign);
                Check(savedHeroes.Data.ConfigVersion == heroDraft.ConfigVersion &&
                    savedHeroes.Data.Heroes[0].Name == heroDraft.Heroes[0].Name &&
                    ProgressionDataJson.LoadBundled().Data.InitialGold == progressionDraft.InitialGold,
                    "Bundled Hero or progression files were not updated together.");
                Check(savedCampaign.Stage(stageId).Name == campaignDraft.Chapters.Last().Stages.Last().Name &&
                    savedWorld.Data.ConfigVersion == worldDraft.Index.ConfigVersion &&
                    savedWorld.Map(fixture).Name == worldDraft.Maps.Last().Draft.Name,
                    "Bundled Campaign and world did not round-trip the retried save.");
            }
            finally
            {
                UnityEngine.Object.DestroyImmediate(window);
            }
        }
    }
}
