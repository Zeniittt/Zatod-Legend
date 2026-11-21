using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEditor.Build.Reporting;
using UnityEngine;
if(EditorApplication.isPlaying)throw new Exception("Stop the test Play session before build.");
var scene=UnityEngine.SceneManagement.SceneManager.GetActiveScene();
if(scene.path!="Assets/Zatod/Scenes/ZatodPrototype.unity" || !scene.GetRootGameObjects().Select(g=>g.name).OrderBy(s=>s).SequenceEqual(new[]{"Main Camera","ZatodBootstrap"}))throw new Exception("Unexpected scene before build.");
// The first prefab-authoring pass created/deleted a temporary holder in this scene.
// Only this agent's unsaved authoring operation is being settled; later passes use an additive scene.
if(scene.isDirty)EditorSceneManager.SaveScene(scene);
string path=Path.GetFullPath("../Builds/ZatodPrototype/ZatodLegend.exe");
var report=BuildPipeline.BuildPlayer(new BuildPlayerOptions{scenes=new[]{scene.path},locationPathName=path,target=BuildTarget.StandaloneWindows64,subtarget=(int)StandaloneBuildSubtarget.Player,options=BuildOptions.None});
var result=new BuildResultData{Result=report.summary.result.ToString(),Errors=(int)report.summary.totalErrors,Warnings=(int)report.summary.totalWarnings,Seconds=report.summary.totalTime.TotalSeconds,Executable=path};
string folder=Path.GetFullPath("../Artifacts/ZatodWorldChecks");Directory.CreateDirectory(folder);File.WriteAllText(Path.Combine(folder,"build.json"),JsonUtility.ToJson(result,true));
if(report.summary.result!=BuildResult.Succeeded)throw new Exception("Build failed");return result;
[Serializable] public class BuildResultData {public string Result,Executable;public int Errors,Warnings;public double Seconds;}
