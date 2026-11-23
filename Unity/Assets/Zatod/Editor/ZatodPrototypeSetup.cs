using System;
using System.IO;
using System.Linq;
using Mirror;
using TMPro;
using UnityEditor;
using UnityEditor.Build.Reporting;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.TextCore.LowLevel;
using Zatod.Networking;
using Zatod.Presentation;
namespace Zatod.Editor
{
    public static class ZatodPrototypeSetup
    {
        public const string ScenePath="Assets/Zatod/Scenes/ZatodPrototype.unity";
        [MenuItem("Zatod/Tools/Setup Prototype Scene")]
        public static string Setup()
        {
            if(EditorApplication.isPlaying)throw new InvalidOperationException("Stop Play Mode first.");
            var active=UnityEngine.SceneManagement.SceneManager.GetActiveScene();
            if(active.isDirty)throw new InvalidOperationException("Save the current scene before Zatod setup.");
            var scene=EditorSceneManager.NewScene(NewSceneSetup.EmptyScene,NewSceneMode.Single);
            var camera=new GameObject("Main Camera",typeof(Camera),typeof(AudioListener));camera.tag="MainCamera";camera.transform.position=new Vector3(0,0,-10);camera.GetComponent<Camera>().orthographic=true;
            var bootstrap=new GameObject("ZatodBootstrap",typeof(TelepathyTransport),typeof(ZatodConnection),typeof(ZatodPrototypeView));
            var font=EnsureFont();
            string labels="ZATOD LEGEND ZATOD PROTOTYPE Kết nối Ngắt Phó bản Arena PvP online Hero Đồ Replay Dừng trận Kho Cấp món Mặc Tiến bậc Đã mặc Tạm dừng Phát Tốc độ Xem lại Trắng Xanh Lá Xanh Dương Đội hình Chương Ải ĐÃ VALIDATE ĐANG VALIDATE";
            if(!font.TryAddCharacters(labels,out string missing))throw new InvalidOperationException("Missing font glyphs: "+missing);
            bootstrap.GetComponent<ZatodPrototypeView>().Font=font;EditorUtility.SetDirty(font);
            EditorSceneManager.SaveScene(scene,ScenePath);
            var old=EditorBuildSettings.scenes.Where(s=>s.path!=ScenePath).ToArray();
            EditorBuildSettings.scenes=new[]{new EditorBuildSettingsScene(ScenePath,true)}.Concat(old).ToArray();
            PlayerSettings.productName="Zatod Legend";PlayerSettings.runInBackground=true;PlayerSettings.defaultScreenWidth=1600;PlayerSettings.defaultScreenHeight=900;PlayerSettings.fullScreenMode=FullScreenMode.Windowed;PlayerSettings.resizableWindow=true;
            AssetDatabase.SaveAssets();return ScenePath;
        }
        public static TMP_FontAsset EnsureFont()
        {
            var font = AssetDatabase.LoadAssetAtPath<TMP_FontAsset>("Assets/Zatod/Resources/UI/FormationFont.asset");
            if (font != null) return font;
            var source = AssetDatabase.LoadAssetAtPath<Font>("Assets/TextMesh Pro/Fonts/LiberationSans.ttf");
            if (source == null) throw new InvalidOperationException("Missing bundled LiberationSans font.");
            Directory.CreateDirectory(Path.GetDirectoryName("Assets/Zatod/Resources/UI/FormationFont.asset")); AssetDatabase.Refresh();
            font = TMP_FontAsset.CreateFontAsset(source, 90, 9, GlyphRenderMode.SDFAA, 1024, 1024, AtlasPopulationMode.Dynamic, true);
            font.name = "FormationFont";
            AssetDatabase.CreateAsset(font, "Assets/Zatod/Resources/UI/FormationFont.asset");
            AssetDatabase.AddObjectToAsset(font.material, font);
            foreach (var texture in font.atlasTextures) if (texture != null) AssetDatabase.AddObjectToAsset(texture, font);
            string labels = "CHỌN ĐỘI HÌNH Trước Giữa Sau Chạm Hero để thêm vào đội hình. Đội hình đã đủ 5 Hero. Chạm Hero đã chọn để bỏ chọn.";
            if (!font.TryAddCharacters(labels, out string missing)) throw new InvalidOperationException("Font is missing Vietnamese characters: " + missing);
            EditorUtility.SetDirty(font); AssetDatabase.SaveAssets(); return font;
        }

        [MenuItem("Zatod/Tools/Build Windows Prototype")]
        public static string Build()
        {
            if(EditorApplication.isPlaying)throw new InvalidOperationException("Stop Play Mode first.");
            if(!File.Exists(ScenePath))throw new InvalidOperationException("Run Zatod scene setup first.");
            var dirtyScenes=Enumerable.Range(0,UnityEngine.SceneManagement.SceneManager.sceneCount)
                .Select(UnityEngine.SceneManagement.SceneManager.GetSceneAt).Where(scene=>scene.isDirty).Select(scene=>scene.name).ToArray();
            if(dirtyScenes.Length>0)throw new InvalidOperationException("Save modified scenes before building Zatod: "+string.Join(", ",dirtyScenes));
            string executable=Path.GetFullPath("../Builds/ZatodPrototype/ZatodLegend.exe");Directory.CreateDirectory(Path.GetDirectoryName(executable));
            var report=BuildPipeline.BuildPlayer(new BuildPlayerOptions{scenes=new[]{ScenePath,ZatodBattleSceneController.ScenePath},locationPathName=executable,target=BuildTarget.StandaloneWindows64,subtarget=(int)StandaloneBuildSubtarget.Player,options=BuildOptions.None});
            if(report.summary.result!=BuildResult.Succeeded)throw new Exception("Zatod build failed: "+report.summary.result);
            return executable;
        }
    }
}
