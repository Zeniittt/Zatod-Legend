using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using TMPro;
using Zatod.Presentation;
var paths=Directory.GetFiles("Assets/Zatod/Resources/Zatod/UI","*.*",SearchOption.AllDirectories).Where(p=>p.EndsWith(".png") || p.EndsWith(".jpg")).ToArray();
foreach(string path in paths)
{
    var importer=(TextureImporter)AssetImporter.GetAtPath(path.Replace('\\','/'));
    importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Single;
    importer.spritePixelsPerUnit=100;importer.alphaIsTransparency=true;importer.mipmapEnabled=false;importer.filterMode=FilterMode.Bilinear;
    if(Path.GetFileNameWithoutExtension(path)=="battle_resource_bg" || Path.GetFileNameWithoutExtension(path)=="battle_hero_bg")importer.spriteBorder=new Vector4(5,5,5,5);
    importer.SaveAndReimport();
}
var font=Resources.Load<TMP_FontAsset>("UI/FormationFont");
var holder=new GameObject("ZatodHudPrefabAuthoring",typeof(RectTransform));
try
{
    var hud=ZatodBattleHudLayout.Create(holder.transform,font);
    PrefabUtility.SaveAsPrefabAsset(hud.gameObject,"Assets/Zatod/Resources/Zatod/UI/ZatodBattleHUD.prefab");
}
finally{UnityEngine.Object.DestroyImmediate(holder);}
var scene=UnityEngine.SceneManagement.SceneManager.GetActiveScene();
if(scene.path=="Assets/Zatod/Scenes/ZatodPrototype.unity")
{
    foreach(var root in scene.GetRootGameObjects())if(root.name=="CrystalBootstrap")root.name="ZatodBootstrap";
    EditorSceneManager.SaveScene(scene);
}
var old=EditorBuildSettings.scenes.Where(s=>!s.path.EndsWith("CrystalPrototype.unity") && !s.path.EndsWith("ZatodPrototype.unity")).ToArray();
EditorBuildSettings.scenes=new[]{new EditorBuildSettingsScene("Assets/Zatod/Scenes/ZatodPrototype.unity",true)}.Concat(old).ToArray();
AssetDatabase.SaveAssets();
Zatod.Editor.GameEditorWindow.Open();
return new{ImportedSprites=paths.Length,Prefab="Resources/Zatod/UI/ZatodBattleHUD",Scene=scene.path,Editor="Zatod GameEditor"};
