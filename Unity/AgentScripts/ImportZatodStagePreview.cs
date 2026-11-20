using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using TMPro;
using Zatod.Presentation;
const string folder="Assets/Zatod/Resources/Zatod/UI/StagePreview";
AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
foreach(var path in Directory.GetFiles(folder,"*.*",SearchOption.AllDirectories).Where(p=>p.EndsWith(".png") || p.EndsWith(".jpg")))
{
    var importer=(TextureImporter)AssetImporter.GetAtPath(path.Replace('\\','/'));
    importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Single;importer.alphaIsTransparency=true;importer.mipmapEnabled=false;importer.filterMode=FilterMode.Bilinear;importer.textureCompression=TextureImporterCompression.Uncompressed;
    string name=Path.GetFileNameWithoutExtension(path);Vector4 border=Vector4.zero;
    if(name=="frame_common1")border=new Vector4(25,125,25,125);
    if(name=="battle_prepare_9bg_1")border=new Vector4(32,36,32,36);
    if(name=="buttion_big" || name=="button_com_big" || name=="button_grey")border=new Vector4(24,24,24,24);
    importer.spriteBorder=border;importer.SaveAndReimport();
}
var latin=AssetDatabase.LoadAssetAtPath<TMP_FontAsset>("Assets/Zatod/Resources/Zatod/UI/Formation/ZatodFormationLatin.asset");
string labels="Reward Cost: Enemies: Raid Voucher: Daily Attempts: ? Challenge Tutorial Disconnected Raid x3 0123456789";
string needed=new string(labels.Distinct().Where(ch=>!latin.HasCharacter(ch)).ToArray());
if(needed.Length>0 && !latin.TryAddCharacters(needed,out var missing))throw new Exception("Missing native font glyphs: "+missing);
EditorUtility.SetDirty(latin);
var originalScene=UnityEngine.SceneManagement.SceneManager.GetActiveScene();
var authoringScene=UnityEditor.SceneManagement.EditorSceneManager.NewScene(UnityEditor.SceneManagement.NewSceneSetup.EmptyScene,UnityEditor.SceneManagement.NewSceneMode.Additive);
UnityEngine.SceneManagement.SceneManager.SetActiveScene(authoringScene);
var holder=new GameObject("ZatodStageAuthoring",typeof(RectTransform));holder.GetComponent<RectTransform>().sizeDelta=new Vector2(1600,900);
try
{
    var preview=ZatodStagePreviewView.Create(holder.transform,latin);
    PrefabUtility.SaveAsPrefabAsset(preview.gameObject,folder+"/ZatodStagePreviewView.prefab");
    var formation=ZatodFormationView.Create(holder.transform,latin);
    PrefabUtility.SaveAsPrefabAsset(formation.gameObject,"Assets/Zatod/Resources/Zatod/UI/Formation/ZatodFormationView.prefab");
}
finally{UnityEngine.Object.DestroyImmediate(holder);UnityEngine.SceneManagement.SceneManager.SetActiveScene(originalScene);UnityEditor.SceneManagement.EditorSceneManager.CloseScene(authoringScene,true);}
AssetDatabase.SaveAssets();return new{PreviewPrefab=folder+"/ZatodStagePreviewView.prefab",NativeAssetCount=42};
