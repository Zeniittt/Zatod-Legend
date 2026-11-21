using System;
using System.IO;
using UnityEditor;
using UnityEditor.Build.Reporting;
using UnityEngine;
using Zatod.Presentation;
public static class BuildZatodWorldBattle
{
    public static object Run(bool handoff=false)
    {
        if(Application.isPlaying)throw new InvalidOperationException("Stop Play Mode before build.");
        for(int i=0;i<UnityEngine.SceneManagement.SceneManager.sceneCount;i++)if(UnityEngine.SceneManagement.SceneManager.GetSceneAt(i).isDirty)throw new Exception("Save dirty authoring scenes before build.");
        string folder=Path.GetFullPath(handoff?"../Builds/ZatodPrototype":"../Artifacts/ZatodWorldBattleChecks/Player");Directory.CreateDirectory(folder);
        var report=BuildPipeline.BuildPlayer(new BuildPlayerOptions{scenes=new[]{Zatod.Editor.ZatodPrototypeSetup.ScenePath,ZatodBattleSceneController.ScenePath},locationPathName=Path.Combine(folder,"ZatodLegend.exe"),target=BuildTarget.StandaloneWindows64,subtarget=(int)StandaloneBuildSubtarget.Player,options=BuildOptions.None});
        var result=new{Result=report.summary.result.ToString(),Errors=report.summary.totalErrors,Warnings=report.summary.totalWarnings,Seconds=report.summary.totalTime.TotalSeconds,Path=report.summary.outputPath};
        File.WriteAllText(Path.GetFullPath(handoff?"../Artifacts/ZatodWorldBattleChecks/build-final.json":"../Artifacts/ZatodWorldBattleChecks/build.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));
        if(report.summary.result!=BuildResult.Succeeded)throw new Exception("Build failed: "+report.summary.result);return result;
    }
}
