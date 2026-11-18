using System;
using System.IO;
using System.Linq;
using Mirror;
using TMPro;
using UnityEditor;
using UnityEditor.Build.Reporting;
using UnityEditor.SceneManagement;
using UnityEngine;
using Zatod.Networking;
using Zatod.Presentation;

namespace Zatod.Editor
{
    public static class PrototypeSetup
    {
        const string ScenePath = "Assets/Zatod/Scenes/ArenaPrototype.unity";

        [MenuItem("Zatod/Setup Arena Prototype")]
        public static void Setup()
        {
            if (EditorApplication.isPlaying) throw new InvalidOperationException("Stop Play Mode before setup.");
            var font = Resources.Load<TMP_FontAsset>("Fonts & Materials/LiberationSans SDF");
            if (font == null) throw new InvalidOperationException("Import TMP Essentials first with Zatod/Import Text Resources, then run setup again.");
            Directory.CreateDirectory("Assets/Zatod/Scenes");
            var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
            var camera = new GameObject("Main Camera", typeof(Camera));
            camera.tag = "MainCamera";
            camera.transform.position = new Vector3(0, 0, -10);
            var cam = camera.GetComponent<Camera>();
            cam.orthographic = true; cam.clearFlags = CameraClearFlags.SolidColor;
            cam.backgroundColor = new Color(.043f, .067f, .106f);
            var bootstrap = new GameObject("ArenaBootstrap", typeof(TelepathyTransport), typeof(ArenaConnection), typeof(ArenaView), typeof(FormationView), typeof(HeroRosterView),typeof(CampaignView));
            bootstrap.GetComponent<ArenaView>().Font = font;
            bootstrap.GetComponent<FormationView>().Font = FormationSetup.EnsureFont();
            EditorSceneManager.SaveScene(scene, ScenePath);
            EditorBuildSettings.scenes = new[] { new EditorBuildSettingsScene(ScenePath, true) };
            PlayerSettings.companyName = "Zatod";
            PlayerSettings.productName = "Zatod Legend - Arena Prototype";
            PlayerSettings.bundleVersion = "0.1.0";
            PlayerSettings.defaultScreenWidth = 1600; PlayerSettings.defaultScreenHeight = 900;
            PlayerSettings.fullScreenMode = FullScreenMode.Windowed;
            PlayerSettings.resizableWindow = true;
            PlayerSettings.runInBackground = true;
            PlayerSettings.defaultInterfaceOrientation = UIOrientation.LandscapeLeft;
            PlayerSettings.allowedAutorotateToPortrait = false;
            PlayerSettings.allowedAutorotateToPortraitUpsideDown = false;
            PlayerSettings.allowedAutorotateToLandscapeLeft = true;
            PlayerSettings.allowedAutorotateToLandscapeRight = true;
            AssetDatabase.SaveAssets();
            Debug.Log("[PrototypeSetup] Scene, landscape client and server bootstrap ready.");
        }

        [MenuItem("Zatod/Import Text Resources")]
        public static void ImportTextResources() { TMP_PackageResourceImporter.ImportResources(true, false, false); }

        [MenuItem("Zatod/Build Windows Prototype")]
        public static string BuildWindows()
        {
            string directory = Path.GetFullPath(Path.Combine(Application.dataPath, "../../Builds/Windows"));
            Directory.CreateDirectory(directory);
            var result = BuildPipeline.BuildPlayer(new BuildPlayerOptions
            {
                scenes = new[] { ScenePath }, locationPathName = Path.Combine(directory, "ZatodArena.exe"),
                target = BuildTarget.StandaloneWindows64, options = BuildOptions.None,
                subtarget = (int)StandaloneBuildSubtarget.Player
            });
            if (result.summary.result != BuildResult.Succeeded) throw new Exception("Windows build failed: " + result.summary.result);
            Debug.Log("[PrototypeSetup] Windows client/headless server build: " + directory);
            return directory;
        }

        [MenuItem("Zatod/Build Linux Dedicated Server")]
        public static string BuildLinuxServer()
        {
            string directory = Path.GetFullPath(Path.Combine(Application.dataPath, "../../Builds/LinuxServer"));
            Directory.CreateDirectory(directory);
            var result = BuildPipeline.BuildPlayer(new BuildPlayerOptions
            {
                scenes = new[] { ScenePath }, locationPathName = Path.Combine(directory, "ZatodArenaServer"),
                target = BuildTarget.StandaloneLinux64, options = BuildOptions.None,
                subtarget = (int)StandaloneBuildSubtarget.Server
            });
            if (result.summary.result != BuildResult.Succeeded) throw new Exception("Linux server build failed: " + result.summary.result);
            return directory;
        }
    }
}
