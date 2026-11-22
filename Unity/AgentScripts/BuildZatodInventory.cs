using System;
using System.IO;
using UnityEditor;
using UnityEditor.Build.Reporting;
using UnityEngine;
using Zatod.Presentation;
return BuildZatodInventory.Run();
public static class BuildZatodInventory
{
    public static object Run()
    {
        if(Application.isPlaying)throw new Exception("Stop Play before building.");
        for(int i=0;i<UnityEngine.SceneManagement.SceneManager.sceneCount;i++)if(UnityEngine.SceneManagement.SceneManager.GetSceneAt(i).isDirty)throw new Exception("Save dirty scenes first.");
        string folder=Path.Combine(Path.GetTempPath(),"ZatodInventoryChecks20261122","Player");Directory.CreateDirectory(folder);
        var report=BuildPipeline.BuildPlayer(new BuildPlayerOptions{scenes=new[]{Zatod.Editor.ZatodPrototypeSetup.ScenePath,ZatodBattleSceneController.ScenePath},locationPathName=Path.Combine(folder,"ZatodLegend.exe"),target=BuildTarget.StandaloneWindows64,subtarget=(int)StandaloneBuildSubtarget.Player,options=BuildOptions.None});
        var result=new{Result=report.summary.result.ToString(),Errors=report.summary.totalErrors,Warnings=report.summary.totalWarnings,Seconds=report.summary.totalTime.TotalSeconds,Path=report.summary.outputPath};
        File.WriteAllText(Path.GetFullPath("../Artifacts/ZatodInventoryChecks/build.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));
        if(report.summary.result!=BuildResult.Succeeded)throw new Exception("Build failed");return result;
    }
}
