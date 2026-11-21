using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using TMPro;
using Zatod.Presentation;
const string folder="Assets/Zatod/Resources/Zatod/UI/Hero";
AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
var paths=Directory.GetFiles(folder,"*.*",SearchOption.AllDirectories).Concat(Directory.GetFiles("Assets/Zatod/Resources/Zatod/UI/StagePreview/Items","*.jpg"));
int count=0;
foreach(var p in paths.Where(p=>p.EndsWith(".png") || p.EndsWith(".jpg")))
{
    var path=p.Replace('\\','/');var importer=(TextureImporter)AssetImporter.GetAtPath(path);
    string name=Path.GetFileNameWithoutExtension(path);Vector4 border=Vector4.zero;
    if(name=="bg_hero_normal")border=new Vector4(28,28,28,28);
    if(name=="main_shortcut_board")border=new Vector4(18,20,18,20);
    if(name=="bg_name")border=new Vector4(20,15,20,15);
    if(name=="hero_bg_mid_1")border=new Vector4(20,80,20,80);
    if(name=="hero_info_bg_0")border=new Vector4(25,70,25,70);
    if(name=="hero_info_bg_3")border=new Vector4(20,20,20,20);
    if(name=="hero_exp_progress_bg" || name=="hero_soulstone_progress_bg")border=new Vector4(7,7,7,7);
    bool changed=importer.textureType!=TextureImporterType.Sprite || importer.spriteImportMode!=SpriteImportMode.Single || !importer.alphaIsTransparency || importer.mipmapEnabled || importer.filterMode!=FilterMode.Bilinear || importer.textureCompression!=TextureImporterCompression.Uncompressed || importer.spriteBorder!=border;
    if(changed){importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Single;importer.alphaIsTransparency=true;importer.mipmapEnabled=false;importer.filterMode=FilterMode.Bilinear;importer.textureCompression=TextureImporterCompression.Uncompressed;importer.spriteBorder=border;importer.SaveAndReimport();}count++;
}
var font=AssetDatabase.LoadAssetAtPath<TMP_FontAsset>("Assets/Zatod/Resources/Zatod/UI/Formation/ZatodFormationLatin.asset");
string chars=new string(Enumerable.Range(32,95).Select(i=>(char)i).Concat("·").Where(ch=>!font.HasCharacter(ch)).Distinct().ToArray());
if(chars.Length>0 && !font.TryAddCharacters(chars,out var missing))throw new Exception("Missing font glyphs: "+missing);
EditorUtility.SetDirty(font);
var original=UnityEngine.SceneManagement.SceneManager.GetActiveScene();
var scene=UnityEditor.SceneManagement.EditorSceneManager.NewScene(UnityEditor.SceneManagement.NewSceneSetup.EmptyScene,UnityEditor.SceneManagement.NewSceneMode.Additive);
UnityEngine.SceneManagement.SceneManager.SetActiveScene(scene);
var holder=new GameObject("HeroUiAuthoring",typeof(RectTransform));holder.GetComponent<RectTransform>().sizeDelta=new Vector2(1600,900);
try
{
    var roster=ZatodHeroRosterView.Create(holder.transform,font);PrefabUtility.SaveAsPrefabAsset(roster.gameObject,folder+"/ZatodHeroRosterView.prefab");
    var detail=ZatodHeroDetailView.Create(holder.transform,font);PrefabUtility.SaveAsPrefabAsset(detail.gameObject,folder+"/ZatodHeroDetailView.prefab");
}
finally{UnityEngine.Object.DestroyImmediate(holder);UnityEngine.SceneManagement.SceneManager.SetActiveScene(original);UnityEditor.SceneManagement.EditorSceneManager.CloseScene(scene,true);}
AssetDatabase.SaveAssets();return new{NativeAssets=count,Prefabs=2};
