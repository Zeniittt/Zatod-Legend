using System;
using System.IO;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using Zatod.Presentation;
public static class SetupZatodCrafting
{
 public static object Run()
 {
  if(Application.isPlaying)throw new Exception("Stop Play before authoring.");
  const string root="Assets/Zatod/Resources/Zatod/UI/Crafting";int count=0;
  foreach(string folder in new[]{root,"Assets/Zatod/Resources/Zatod/UI/StagePreview/Items"})
   foreach(string path in Directory.GetFiles(folder,"*",SearchOption.AllDirectories))
   {
    if(!path.EndsWith(".png")&&!path.EndsWith(".jpg"))continue;
    AssetDatabase.ImportAsset(path,ImportAssetOptions.ForceSynchronousImport);var importer=(TextureImporter)AssetImporter.GetAtPath(path);
    importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Single;importer.spritePixelsPerUnit=100;importer.alphaIsTransparency=true;importer.mipmapEnabled=false;importer.npotScale=TextureImporterNPOTScale.None;importer.wrapMode=TextureWrapMode.Clamp;importer.textureCompression=TextureImporterCompression.Uncompressed;importer.filterMode=FilterMode.Bilinear;
    if(path.Replace('\\','/').EndsWith("/common/com_new_1.png"))importer.spriteBorder=new Vector4(50,40,52,42);
    if(path.Replace('\\','/').EndsWith("/common/com_new_2.png"))importer.spriteBorder=new Vector4(50,40,29,42);
    if(path.Contains("equip_prop_bg_"))importer.spriteBorder=new Vector4(18,9,18,9);
    importer.SaveAndReimport();count++;
   }
  var view=UnityEngine.Object.FindAnyObjectByType<ZatodPrototypeView>();if(view==null)throw new Exception("Open ZatodPrototype scene first.");
  var nativeFont=AssetDatabase.LoadAssetAtPath<TMPro.TMP_FontAsset>("Assets/Zatod/Resources/Zatod/UI/Formation/ZatodFormationLatin.asset");
  var cjk=AssetDatabase.LoadAssetAtPath<TMPro.TMP_FontAsset>("Assets/Zatod/Resources/Zatod/UI/Formation/ZatodFormationFont.asset");
  var catalog=Zatod.Heroes.HeroDataJson.LoadBundledCatalog();var campaign=Zatod.Heroes.CampaignDataJson.LoadZatod(catalog);
  string labels=string.Join("",System.Linq.Enumerable.SelectMany(campaign.Data.Chapters,c=>System.Linq.Enumerable.Select(c.Stages,s=>s.Name)));
  labels+=string.Join("",System.Linq.Enumerable.Select(catalog.Data.Items,i=>i.Name));
  string needed=new string(System.Linq.Enumerable.ToArray(System.Linq.Enumerable.Where(System.Linq.Enumerable.Distinct(labels),ch=>!cjk.HasCharacter((int)ch))));
  if(needed.Length>0 && !cjk.TryAddCharacters(needed,out string missing))throw new Exception("Missing native glyphs: "+missing);
  EditorUtility.SetDirty(cjk);foreach(var atlas in cjk.atlasTextures)if(atlas!=null && string.IsNullOrEmpty(AssetDatabase.GetAssetPath(atlas)))AssetDatabase.AddObjectToAsset(atlas,cjk);
  var scene=EditorSceneManager.NewPreviewScene();var holder=new GameObject("CraftAuthoring",typeof(RectTransform));UnityEngine.SceneManagement.SceneManager.MoveGameObjectToScene(holder,scene);
  try{var modal=ZatodEquipmentView.Create(holder.transform,nativeFont);if(modal.TreeBack.transform.Find("Arrow")==null)throw new Exception("Updated UI assembly has not loaded; refresh and wait before authoring.");PrefabUtility.SaveAsPrefabAsset(modal.gameObject,root+"/ZatodEquipmentView.prefab");}
  finally{UnityEngine.Object.DestroyImmediate(holder);EditorSceneManager.ClosePreviewScene(scene);}
  AssetDatabase.SaveAssets();return new{Images=count,Recipes=Zatod.Heroes.HeroDataJson.LoadBundledCatalog().Data.CraftRecipes.Count};
 }
}
