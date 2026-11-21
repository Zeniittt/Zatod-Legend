using System;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;
using Zatod.Presentation;

public static class SetupZatodBattleScene
{
    public static object Run()
    {
        if(Application.isPlaying)throw new InvalidOperationException("Stop Play Mode before scene authoring.");
        var previous=SceneManager.GetActiveScene();
        var scene=EditorSceneManager.NewScene(NewSceneSetup.EmptyScene,NewSceneMode.Additive);
        try
        {
            var root=new GameObject("ZatodBattleStage",typeof(ZatodBattleStage));SceneManager.MoveGameObjectToScene(root,scene);
            if(!EditorSceneManager.SaveScene(scene,ZatodBattleSceneController.ScenePath))throw new Exception("Battle scene was not saved.");
            var settings=EditorBuildSettings.scenes.Where(s=>s.path!=ZatodBattleSceneController.ScenePath).ToList();
            settings.Add(new EditorBuildSettingsScene(ZatodBattleSceneController.ScenePath,true));EditorBuildSettings.scenes=settings.ToArray();
            AssetDatabase.SaveAssets();
            return new{Scene=ZatodBattleSceneController.ScenePath,StageType=typeof(ZatodBattleStage).AssemblyQualifiedName,WorldMaps=Zatod.World.WorldDataJson.Load(Zatod.Heroes.CampaignDataJson.LoadZatod(Zatod.Heroes.HeroDataJson.LoadBundledCatalog())).Data.Maps.Count};
        }
        finally{EditorSceneManager.CloseScene(scene,true);if(previous.IsValid() && previous.isLoaded)SceneManager.SetActiveScene(previous);}
    }
}
