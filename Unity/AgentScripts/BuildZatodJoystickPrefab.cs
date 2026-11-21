using System;
using System.IO;
using UnityEditor;
using UnityEngine;
using Zatod.Presentation;
const string source="Assets/TreasureHunterJoystickExport/GameSkin/Fixed Joystick.prefab";
const string folder="Assets/Zatod/Resources/Zatod/UI/World";
var original=UnityEngine.SceneManagement.SceneManager.GetActiveScene();
var authoring=UnityEditor.SceneManagement.EditorSceneManager.NewScene(UnityEditor.SceneManagement.NewSceneSetup.EmptyScene,UnityEditor.SceneManagement.NewSceneMode.Additive);
UnityEngine.SceneManagement.SceneManager.SetActiveScene(authoring);
GameObject go=null;
try
{
    go=(GameObject)PrefabUtility.InstantiatePrefab(AssetDatabase.LoadAssetAtPath<GameObject>(source));
    PrefabUtility.UnpackPrefabInstance(go,PrefabUnpackMode.Completely,InteractionMode.AutomatedAction);
    go.name="ZatodFixedJoystick";var vendor=go.GetComponent<FixedJoystick>();if(vendor==null)throw new Exception("Native FixedJoystick missing");
    var old=new SerializedObject(vendor);var joystick=go.AddComponent<ZatodFixedJoystick>();var current=new SerializedObject(joystick);
    foreach(string name in new[]{"background","handle"})current.FindProperty(name).objectReferenceValue=old.FindProperty(name).objectReferenceValue;
    foreach(string name in new[]{"handleRange","deadZone"})current.FindProperty(name).floatValue=old.FindProperty(name).floatValue;
    current.FindProperty("axisOptions").enumValueIndex=old.FindProperty("axisOptions").enumValueIndex;
    foreach(string name in new[]{"snapX","snapY"})current.FindProperty(name).boolValue=old.FindProperty(name).boolValue;
    current.ApplyModifiedPropertiesWithoutUndo();UnityEngine.Object.DestroyImmediate(vendor);
    foreach(var image in go.GetComponentsInChildren<UnityEngine.UI.Image>(true))image.preserveAspect=true;
    var rect=go.GetComponent<RectTransform>();rect.anchorMin=rect.anchorMax=new Vector2(.14f,.22f);rect.pivot=new Vector2(.5f,.5f);rect.anchoredPosition=Vector2.zero;
    Directory.CreateDirectory(folder);AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
    PrefabUtility.SaveAsPrefabAsset(go,folder+"/ZatodFixedJoystick.prefab");AssetDatabase.SaveAssets();
}
finally{if(go!=null)UnityEngine.Object.DestroyImmediate(go);UnityEngine.SceneManagement.SceneManager.SetActiveScene(original);UnityEditor.SceneManagement.EditorSceneManager.CloseScene(authoring,true);}
return new{Prefab=folder+"/ZatodFixedJoystick.prefab",NativeSkin=source,SceneDirty=original.isDirty};
