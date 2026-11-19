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
    public static class CrystalPrototypeSetup
    {
        public const string ScenePath="Assets/Zatod/Scenes/CrystalPrototype.unity";
        [MenuItem("Zatod/Crystal/Setup Prototype Scene")]
        public static string Setup()
        {
            if(EditorApplication.isPlaying)throw new InvalidOperationException("Stop Play Mode first.");
            var active=UnityEngine.SceneManagement.SceneManager.GetActiveScene();
            if(active.isDirty)throw new InvalidOperationException("Save the current scene before Crystal setup.");
            var scene=EditorSceneManager.NewScene(NewSceneSetup.EmptyScene,NewSceneMode.Single);
            var camera=new GameObject("Main Camera",typeof(Camera),typeof(AudioListener));camera.tag="MainCamera";camera.transform.position=new Vector3(0,0,-10);camera.GetComponent<Camera>().orthographic=true;
            var bootstrap=new GameObject("CrystalBootstrap",typeof(TelepathyTransport),typeof(CrystalConnection),typeof(CrystalPrototypeView));
            var font=FormationSetup.EnsureFont();
            string labels="ZATOD LEGEND CRYSTAL PROTOTYPE Kết nối Ngắt Phó bản Arena PvP online Hero Đồ Replay Dừng trận Kho Cấp món Mặc Tiến bậc Đã mặc Tạm dừng Phát Tốc độ Xem lại Trắng Xanh Lá Xanh Dương Đội hình Chương Ải ĐÃ VALIDATE ĐANG VALIDATE";
            if(!font.TryAddCharacters(labels,out string missing))throw new InvalidOperationException("Missing font glyphs: "+missing);
            bootstrap.GetComponent<CrystalPrototypeView>().Font=font;EditorUtility.SetDirty(font);
            EditorSceneManager.SaveScene(scene,ScenePath);
            var old=EditorBuildSettings.scenes.Where(s=>s.path!=ScenePath).ToArray();
            EditorBuildSettings.scenes=new[]{new EditorBuildSettingsScene(ScenePath,true)}.Concat(old).ToArray();
            PlayerSettings.productName="Zatod Legend";PlayerSettings.runInBackground=true;PlayerSettings.defaultScreenWidth=1600;PlayerSettings.defaultScreenHeight=900;PlayerSettings.fullScreenMode=FullScreenMode.Windowed;PlayerSettings.resizableWindow=true;
            AssetDatabase.SaveAssets();return ScenePath;
        }
        [MenuItem("Zatod/Crystal/Build Windows Prototype")]
        public static string Build()
        {
            if(EditorApplication.isPlaying)throw new InvalidOperationException("Stop Play Mode first.");
            if(!File.Exists(ScenePath))throw new InvalidOperationException("Run Crystal scene setup first.");
            string executable=Path.GetFullPath("../Builds/CrystalPrototype/ZatodCrystal.exe");Directory.CreateDirectory(Path.GetDirectoryName(executable));
            var report=BuildPipeline.BuildPlayer(new BuildPlayerOptions{scenes=new[]{ScenePath},locationPathName=executable,target=BuildTarget.StandaloneWindows64,subtarget=(int)StandaloneBuildSubtarget.Player,options=BuildOptions.None});
            if(report.summary.result!=BuildResult.Succeeded)throw new Exception("Crystal build failed: "+report.summary.result);
            return executable;
        }
    }
}
