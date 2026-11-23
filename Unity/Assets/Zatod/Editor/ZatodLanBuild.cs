using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.Build;
using UnityEditor.Build.Reporting;
using UnityEngine;
using Zatod.Presentation;
namespace Zatod.Editor
{
    public static class ZatodLanBuild
    {
        public static string OutputRoot=>Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory),"Zatod Legend LAN Test");
        public static string AndroidApk=>Path.Combine(Path.GetTempPath(),"ZatodLanTestBuild","Android","ZatodLegend.apk");
        static void CheckReady()
        {
            if(EditorApplication.isPlaying)throw new InvalidOperationException("Stop Play Mode before building.");
            if(Enumerable.Range(0,UnityEngine.SceneManagement.SceneManager.sceneCount).Any(i=>UnityEngine.SceneManagement.SceneManager.GetSceneAt(i).isDirty))throw new InvalidOperationException("Save modified scenes before building.");
        }
        [MenuItem("Zatod/Build LAN Test/Windows")]
        public static string Windows()
        {
            CheckReady();string path=Path.Combine(OutputRoot,"Windows","ZatodLegend.exe");Build(path,BuildTarget.StandaloneWindows64,"windows-build.json");return path;
        }
        [MenuItem("Zatod/Build LAN Test/Android APK")]
        public static string Android()
        {
            CheckReady();
            if(EditorUserBuildSettings.activeBuildTarget!=BuildTarget.Android)throw new InvalidOperationException("Switch the active platform to Android in Build Profiles before building, so Android manifest processors are compiled.");
            ConfigureAndroid();Build(AndroidApk,BuildTarget.Android,"android-build.json");return AndroidApk;
        }
        public static void AndroidBatch(){Android();}
        public static void ConfigureAndroid()
        {
            PlayerSettings.SetApplicationIdentifier(NamedBuildTarget.Android,"com.zatodlegend.lantest");
            PlayerSettings.SetScriptingBackend(NamedBuildTarget.Android,ScriptingImplementation.IL2CPP);
            PlayerSettings.Android.targetArchitectures=AndroidArchitecture.ARM64;
            PlayerSettings.Android.minSdkVersion=AndroidSdkVersions.AndroidApiLevel26;
            PlayerSettings.Android.targetSdkVersion=AndroidSdkVersions.AndroidApiLevel34;
            PlayerSettings.Android.bundleVersionCode=1;PlayerSettings.Android.useCustomKeystore=false;
            PlayerSettings.Android.splitApplicationBinary=false;
            PlayerSettings.defaultInterfaceOrientation=UIOrientation.AutoRotation;
            PlayerSettings.allowedAutorotateToPortrait=false;PlayerSettings.allowedAutorotateToPortraitUpsideDown=false;
            PlayerSettings.allowedAutorotateToLandscapeLeft=true;PlayerSettings.allowedAutorotateToLandscapeRight=true;
            PlayerSettings.SetUseDefaultGraphicsAPIs(BuildTarget.Android,false);
            PlayerSettings.SetGraphicsAPIs(BuildTarget.Android,new[]{UnityEngine.Rendering.GraphicsDeviceType.OpenGLES3});
            PlayerSettings.Android.forceInternetPermission=true;
            EditorUserBuildSettings.buildAppBundle=false;EditorUserBuildSettings.exportAsGoogleAndroidProject=false;
            PlayerSettings.Android.textureCompressionFormats=new[]{TextureCompressionFormat.ASTC};
            EditorUserBuildSettings.androidBuildSubtarget=MobileTextureSubtarget.Generic;
        }
        static void Build(string path,BuildTarget target,string reportName)
        {
            Directory.CreateDirectory(Path.GetDirectoryName(path));
            int subtarget=target==BuildTarget.Android?(int)MobileTextureSubtarget.Generic:(int)StandaloneBuildSubtarget.Player;
            var report=BuildPipeline.BuildPlayer(new BuildPlayerOptions{scenes=new[]{ZatodPrototypeSetup.ScenePath,ZatodBattleSceneController.ScenePath},locationPathName=path,target=target,subtarget=subtarget,options=BuildOptions.None});
            var result=new{Result=report.summary.result.ToString(),Target=target.ToString(),Subtarget=subtarget,AndroidTextureFormats=target==BuildTarget.Android?PlayerSettings.Android.textureCompressionFormats.Select(f=>f.ToString()).ToArray():Array.Empty<string>(),Errors=report.summary.totalErrors,Warnings=report.summary.totalWarnings,Seconds=report.summary.totalTime.TotalSeconds,Bytes=report.summary.totalSize,Path=path};
            string folder=Path.GetFullPath("../Artifacts/ZatodLanLoginChecks");Directory.CreateDirectory(folder);
            File.WriteAllText(Path.Combine(folder,reportName),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));
            if(report.summary.result!=BuildResult.Succeeded)throw new Exception("Build failed: "+report.summary.result);
        }
    }
}
