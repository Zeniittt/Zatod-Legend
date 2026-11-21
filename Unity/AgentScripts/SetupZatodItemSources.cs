using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using TMPro;
using Zatod.Presentation;
using Zatod.Heroes;

public static class SetupZatodItemSources
{
 public static object Run()
 {
  if(Application.isPlaying)throw new Exception("Stop Play before authoring.");
  const string icons="Assets/Zatod/Resources/Zatod/World/StageIcons";
  string craft="Assets/Zatod/Resources/Zatod/UI/Crafting";
  AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
  var paths=Directory.GetFiles(icons,"*.png").Concat(new[]{craft+"/package/access_normal.png",craft+"/package/access_unlock.png",craft+"/package/access_arrow.png"}).ToArray();
  AssetDatabase.StartAssetEditing();
  try
  {
   foreach(string path in paths)
   {
    var ti=(TextureImporter)AssetImporter.GetAtPath(path);if(ti==null)throw new Exception("Missing importer: "+path);
    ti.textureType=TextureImporterType.Sprite;ti.spriteImportMode=SpriteImportMode.Single;ti.spritePixelsPerUnit=100;ti.alphaIsTransparency=true;ti.mipmapEnabled=false;ti.npotScale=TextureImporterNPOTScale.None;ti.wrapMode=TextureWrapMode.Clamp;ti.textureCompression=TextureImporterCompression.Uncompressed;ti.filterMode=FilterMode.Bilinear;
    if(path.EndsWith("access_normal.png")||path.EndsWith("access_unlock.png"))ti.spriteBorder=new Vector4(19,30,19,30);
    ti.SaveAndReimport();
   }
  }
  finally{AssetDatabase.StopAssetEditing();}
  var scene=EditorSceneManager.NewPreviewScene();int prefabs=0;
  try
  {
   var material=AssetDatabase.LoadAssetAtPath<Material>("Assets/Zatod/Resources/Zatod/World/ZatodWorldSprite.mat");if(material==null)throw new Exception("Missing world material.");
   foreach(string path in Directory.GetFiles(icons,"stage_*.png").Where(p=>!p.Contains("_locked")&&!p.Contains("stage_node")))
   {
    var sprite=AssetDatabase.LoadAssetAtPath<Sprite>(path);if(sprite==null)throw new Exception("Sprite not imported: "+path);
    string name="crystal_"+Path.GetFileNameWithoutExtension(path);var go=new GameObject(name);UnityEngine.SceneManagement.SceneManager.MoveGameObjectToScene(go,scene);
    try{var sr=go.AddComponent<SpriteRenderer>();sr.sprite=sprite;sr.sharedMaterial=material;PrefabUtility.SaveAsPrefabAsset(go,"Assets/Zatod/Resources/Zatod/World/Visuals/"+name+".prefab");prefabs++;}
    finally{UnityEngine.Object.DestroyImmediate(go);}
   }
   var latin=AssetDatabase.LoadAssetAtPath<TMP_FontAsset>("Assets/Zatod/Resources/Zatod/UI/Formation/ZatodFormationLatin.asset");if(latin==null)throw new Exception("Missing native Latin font.");
   var catalog=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.LoadZatod(catalog);
   string labels=string.Concat(campaign.Data.Chapters.SelectMany(c=>c.Stages).Select(s=>s.Name))+"Normal Elite Ch. · Available from No sources available. Locked";
   string needed=new string(labels.Distinct().Where(c=>!latin.HasCharacter((int)c)).ToArray());
   if(needed.Length>0&&!latin.TryAddCharacters(needed,out string missing))throw new Exception("Missing native English glyphs: "+missing);
   EditorUtility.SetDirty(latin);foreach(var atlas in latin.atlasTextures)if(atlas!=null&&string.IsNullOrEmpty(AssetDatabase.GetAssetPath(atlas)))AssetDatabase.AddObjectToAsset(atlas,latin);
   var holder=new GameObject("SourceViewAuthoring",typeof(RectTransform));UnityEngine.SceneManagement.SceneManager.MoveGameObjectToScene(holder,scene);
   try
   {
    var view=ZatodEquipmentView.Create(holder.transform,latin);if(view.SourceScroll==null||view.RecipeTitle==null)throw new Exception("Updated source UI assembly is not loaded.");
    PrefabUtility.SaveAsPrefabAsset(view.gameObject,craft+"/ZatodEquipmentView.prefab");
   }
   finally{UnityEngine.Object.DestroyImmediate(holder);}
  }
  finally{EditorSceneManager.ClosePreviewScene(scene);}
  AssetDatabase.SaveAssets();return new{Images=paths.Length,StagePrefabs=prefabs};
 }
}
