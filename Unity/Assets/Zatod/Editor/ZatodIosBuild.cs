using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.Build;
using UnityEditor.Build.Reporting;
using UnityEngine;
using Zatod.Presentation;
#if UNITY_IOS
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;
#endif

namespace Zatod.Editor
{
    public static class ZatodIosBuild
    {
        public const string BundleId="com.zatodlegend.lantest";
        public static string Checks=>Path.GetFullPath("../Artifacts/ZatodIosChecks");
        public static void Configure()
        {
            PlayerSettings.SetApplicationIdentifier(NamedBuildTarget.iOS,BundleId);
            PlayerSettings.SetScriptingBackend(NamedBuildTarget.iOS,ScriptingImplementation.IL2CPP);
            PlayerSettings.SetArchitecture(NamedBuildTarget.iOS,1); // ARM64 device, not Simulator.
            PlayerSettings.iOS.sdkVersion=iOSSdkVersion.DeviceSDK;
            PlayerSettings.iOS.targetOSVersionString="15.0";
            PlayerSettings.iOS.targetDevice=iOSTargetDevice.iPhoneOnly;
            PlayerSettings.iOS.applicationDisplayName="Zatod Legend";
            PlayerSettings.iOS.appleEnableAutomaticSigning=true;
            // Select the user's own Personal Team in Xcode; never store Apple credentials here.
            PlayerSettings.SetUseDefaultGraphicsAPIs(BuildTarget.iOS,false);
            PlayerSettings.SetGraphicsAPIs(BuildTarget.iOS,new[]{UnityEngine.Rendering.GraphicsDeviceType.Metal});
            PlayerSettings.defaultInterfaceOrientation=UIOrientation.AutoRotation;
            PlayerSettings.allowedAutorotateToPortrait=false;PlayerSettings.allowedAutorotateToPortraitUpsideDown=false;
            PlayerSettings.allowedAutorotateToLandscapeLeft=true;PlayerSettings.allowedAutorotateToLandscapeRight=true;
            AssetDatabase.SaveAssets();
        }
        public static int ConfigureTextures()
        {
            int changed=0;
            AssetDatabase.StartAssetEditing();
            try
            {
                foreach(var guid in AssetDatabase.FindAssets("t:Texture2D",new[]{"Assets/Zatod/Art/Imported"}))
                {
                    string path=AssetDatabase.GUIDToAssetPath(guid);
                    var importer=AssetImporter.GetAtPath(path) as TextureImporter;if(importer==null)continue;
                    var android=importer.GetPlatformTextureSettings("Android");
                    if(!android.overridden||android.format!=TextureImporterFormat.ASTC_6x6)continue;
                    var ios=importer.GetPlatformTextureSettings("iPhone");
                    if(ios.overridden&&ios.format==TextureImporterFormat.ASTC_6x6&&ios.maxTextureSize==android.maxTextureSize)continue;
                    string backup=Path.Combine(Checks,"Before",path+".meta");Directory.CreateDirectory(Path.GetDirectoryName(backup));
                    if(!File.Exists(backup))File.Copy(path+".meta",backup);
                    ios.name="iPhone";ios.overridden=true;ios.format=TextureImporterFormat.ASTC_6x6;
                    ios.maxTextureSize=android.maxTextureSize;ios.textureCompression=TextureImporterCompression.Compressed;
                    ios.crunchedCompression=false;importer.SetPlatformTextureSettings(ios);importer.SaveAndReimport();changed++;
                }
            }
            finally{AssetDatabase.StopAssetEditing();}
            Debug.Log("[Zatod iOS] Configured ASTC 6x6 for "+changed+" imported sheets; pixel size, sprite geometry and GUID retained.");
            return changed;
        }
        [MenuItem("Zatod/Build LAN Test/iOS Xcode Project")]
        public static void Export()
            =>ExportTo(Zatod.Networking.ZatodConnection.Argument("-buildOutput",Path.Combine(ZatodLanBuild.OutputRoot,"iOS","Xcode-"+DateTime.Now.ToString("yyyyMMdd-HHmmss"))));
        public static void ExportTo(string path)
        {
            if(EditorApplication.isPlaying)throw new InvalidOperationException("Stop Play Mode before export.");
            if(Enumerable.Range(0,UnityEngine.SceneManagement.SceneManager.sceneCount).Any(i=>UnityEngine.SceneManagement.SceneManager.GetSceneAt(i).isDirty))throw new InvalidOperationException("Save modified scenes before export.");
            if(EditorUserBuildSettings.activeBuildTarget!=BuildTarget.iOS)throw new InvalidOperationException("Switch the active platform to iOS before exporting.");
            if(string.IsNullOrWhiteSpace(path))throw new ArgumentException("An export path is required.",nameof(path));
            path=Path.GetFullPath(path);
            if(Directory.Exists(path)&&Directory.EnumerateFileSystemEntries(path).Any())throw new InvalidOperationException("Choose an empty export folder; an existing Xcode project will not be overwritten.");
            Configure();int textures=ConfigureTextures();Directory.CreateDirectory(path);
            var report=BuildPipeline.BuildPlayer(new BuildPlayerOptions{scenes=new[]{ZatodPrototypeSetup.ScenePath,ZatodBattleSceneController.ScenePath},locationPathName=path,target=BuildTarget.iOS,subtarget=0,options=BuildOptions.None});
            Directory.CreateDirectory(Checks);
            File.WriteAllText(Path.Combine(Checks,"ios-export.json"),Newtonsoft.Json.JsonConvert.SerializeObject(new{
                Result=report.summary.result.ToString(),Errors=report.summary.totalErrors,Warnings=report.summary.totalWarnings,
                Seconds=report.summary.totalTime.TotalSeconds,Bytes=report.summary.totalSize,Path=path,BundleId,TextureOverrides=textures,
                Unity=Application.unityVersion,NativeCompilationVerified=false,DeviceInstallVerified=false
            },Newtonsoft.Json.Formatting.Indented));
            if(report.summary.result!=BuildResult.Succeeded)throw new Exception("iOS export failed: "+report.summary.result);
            string guide=Path.GetFullPath("../docs/zatod-ios-build-and-install.md");
            if(File.Exists(guide))File.Copy(guide,Path.Combine(path,"START-HERE.md"),true);
            Debug.Log("[Zatod iOS] Xcode project exported to "+path+". Native build/sign/install must be completed on Mac.");
        }
#if UNITY_IOS
        public static void ConfigureGameAssemblyScripts(PBXProject project)
        {
            string target=project.TargetGuidByName("GameAssembly");
            if(string.IsNullOrEmpty(target))throw new InvalidOperationException("The exported Xcode project is missing its GameAssembly target.");
            // IL2CPP reads its toolchain and creates temporary directories from this build phase.
            // Scope this setting to GameAssembly; it does not change the app's runtime sandbox.
            project.SetBuildProperty(target,"ENABLE_USER_SCRIPT_SANDBOXING","NO");
        }
        public static void ConfigureUnityFrameworkModules(PBXProject project)
        {
            string target=project.GetUnityFrameworkTargetGuid();
            if(string.IsNullOrEmpty(target))throw new InvalidOperationException("The exported Xcode project is missing its UnityFramework target.");
            // Unity's generated headers rely on include order/PCH and are not standalone verifier inputs.
            // Keep normal module compilation enabled; only skip the separate framework verification pass.
            project.SetBuildProperty(target,"ENABLE_MODULE_VERIFIER","NO");
        }
        public static void ConfigureUnityRuntimeEmbedding(PBXProject project)
        {
            string runtime=project.FindFileGuidByProjectPath("Frameworks/UnityRuntime.framework");
            if(string.IsNullOrEmpty(runtime))return;
            // UUM-151138: UnityRuntime is a build-time artifact, not an app framework.
            // Remove only the main app's copy; retain UnityFramework's linker reference.
            project.RemoveFileFromBuild(project.GetUnityMainTargetGuid(),runtime);
        }
        [PostProcessBuild(100)]
        public static void SetLocalNetworkPermission(BuildTarget target,string path)
        {
            if(target!=BuildTarget.iOS)return;
            string plistPath=Path.Combine(path,"Info.plist");var plist=new PlistDocument();plist.ReadFromFile(plistPath);
            plist.root.SetString("NSLocalNetworkUsageDescription","Zatod Legend connects to the PC game server on your local network so you can play together.");
            plist.WriteToFile(plistPath);
            // Direct TCP only: no multicast entitlement or Bonjour advertising is added.
            string projectPath=PBXProject.GetPBXProjectPath(path);var project=new PBXProject();project.ReadFromFile(projectPath);
            ConfigureGameAssemblyScripts(project);ConfigureUnityFrameworkModules(project);
            ConfigureUnityRuntimeEmbedding(project);project.WriteToFile(projectPath);
        }
#endif
    }
}
