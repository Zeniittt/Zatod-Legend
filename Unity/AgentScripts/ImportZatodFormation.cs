using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using TMPro;
using UnityEngine.TextCore.LowLevel;
using Zatod.Presentation;
const string folder="Assets/Zatod/Resources/Zatod/UI/Formation";
AssetDatabase.Refresh();
foreach(string path in Directory.GetFiles(folder,"*.*",SearchOption.AllDirectories).Where(p=>p.EndsWith(".png") || p.EndsWith(".jpg")))
{
    var importer=(TextureImporter)AssetImporter.GetAtPath(path.Replace('\\','/'));
    importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Single;importer.alphaIsTransparency=true;importer.mipmapEnabled=false;importer.filterMode=FilterMode.Bilinear;
    string name=Path.GetFileNameWithoutExtension(path);Vector4 border=Vector4.zero;
    if(name=="battle_prepare_9bg_big")border=new Vector4(40,40,40,40);
    if(name=="battle_prepare_9bg_1")border=new Vector4(32,36,32,36);
    if(name=="battle_prepare_9bg_2")border=new Vector4(20,30,20,30);
    if(name=="battle_prepare_enemy_bg")border=new Vector4(96,45,50,45);
    if(name=="buttion_big")border=new Vector4(24,24,24,24);
    if(name=="battle_prepare_my_fitbg")border=new Vector4(22,20,22,20);
    importer.spriteBorder=border;importer.SaveAndReimport();
}
string fontPath=folder+"/ZatodFormationFont.asset";
var font=AssetDatabase.LoadAssetAtPath<TMP_FontAsset>(fontPath);
if(font==null)
{
    font=TMP_FontAsset.CreateFontAsset(AssetDatabase.LoadAssetAtPath<Font>(folder+"/ZatodFormationSource.ttf"),60,9,GlyphRenderMode.SDFAA,2048,2048,AtlasPopulationMode.Dynamic,true);
    font.name="ZatodFormationFont";AssetDatabase.CreateAsset(font,fontPath);AssetDatabase.AddObjectToAsset(font.material,font);
    foreach(var texture in font.atlasTextures)if(texture!=null)AssetDatabase.AddObjectToAsset(texture,font);
}
string labels="All Ago Middle Rear Squad Tutorial Formation Enemy Battle Disconnected Error 0123456789?";
var campaign=Newtonsoft.Json.Linq.JObject.Parse(File.ReadAllText("Assets/Zatod/Resources/Data/Campaigns.txt"));
labels+=string.Concat(campaign.SelectTokens("$.Chapters[*].Stages[*].Name").Select(x=>(string)x));labels+=string.Concat(campaign.SelectTokens("$.Chapters[*].Stages[*].Description").Select(x=>(string)x));
string needed=new string(labels.Distinct().Where(ch=>!font.HasCharacter((int)ch)).ToArray());
if(needed.Length>0 && !font.TryAddCharacters(needed,out string missing))throw new Exception("Native source font missing glyphs: "+missing);
EditorUtility.SetDirty(font);
var latin=AssetDatabase.LoadAssetAtPath<TMP_FontAsset>(folder+"/ZatodFormationLatin.asset");
if(latin==null)
{
    latin=TMP_FontAsset.CreateFontAsset(AssetDatabase.LoadAssetAtPath<Font>(folder+"/ZatodFormationLatinSource.ttf"),60,9,GlyphRenderMode.SDFAA,1024,1024,AtlasPopulationMode.Dynamic,true);latin.name="ZatodFormationLatin";AssetDatabase.CreateAsset(latin,folder+"/ZatodFormationLatin.asset");AssetDatabase.AddObjectToAsset(latin.material,latin);foreach(var texture in latin.atlasTextures)if(texture!=null)AssetDatabase.AddObjectToAsset(texture,latin);
}
latin.fallbackFontAssetTable=new System.Collections.Generic.List<TMP_FontAsset>{font};latin.TryAddCharacters("All Ago Middle Rear Squad Tutorial Formation Enemy Battle Disconnected Error 0123456789?",out _);EditorUtility.SetDirty(latin);
var holder=new GameObject("ZatodFormationAuthoring",typeof(RectTransform));holder.GetComponent<RectTransform>().sizeDelta=new Vector2(1600,900);
try
{
    var view=ZatodFormationView.Create(holder.transform,latin);
    PrefabUtility.SaveAsPrefabAsset(view.gameObject,folder+"/ZatodFormationView.prefab");
}
finally{UnityEngine.Object.DestroyImmediate(holder);}
AssetDatabase.SaveAssets();return new{Prefab=folder+"/ZatodFormationView.prefab",NativeChineseGlyphs=true};
