using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using TMPro;
using UnityEngine.TextCore.LowLevel;
using Zatod.Heroes;
using Zatod.Editor;
return PrepareZatodInventory.Run();
public static class PrepareZatodInventory
{
 public static object Run()
 {
  if(Application.isPlaying)throw new Exception("Stop Play first.");
  var root="Assets/Zatod/Resources/Zatod/UI/Inventory/Native/UI/alpha/1080P/";int imported=0;
  var paths=Directory.GetFiles(root,"*",SearchOption.AllDirectories).Where(p=>p.EndsWith(".png")||p.EndsWith(".jpg")).Concat(Directory.GetFiles("Assets/Zatod/Resources/Zatod/UI/Hero/Items","soulstone_*.*").Where(p=>!p.EndsWith(".meta"))).Concat(Directory.GetFiles("Assets/Zatod/Resources/Zatod/UI/StagePreview/Items","soulstone_*.*").Where(p=>!p.EndsWith(".meta")));
  foreach(var raw in paths)
  {
   string path=raw.Replace('\\','/');var t=(TextureImporter)AssetImporter.GetAtPath(path);if(t==null){AssetDatabase.ImportAsset(path);t=(TextureImporter)AssetImporter.GetAtPath(path);}
   t.textureType=TextureImporterType.Sprite;t.spriteImportMode=SpriteImportMode.Single;t.mipmapEnabled=false;t.alphaIsTransparency=true;t.textureCompression=TextureImporterCompression.Uncompressed;
   if(path.StartsWith(root))
   {
    string key=path.Substring(root.Length);var old=AssetImporter.GetAtPath("Assets/Zatod/Resources/Zatod/UI/Crafting/"+key) as TextureImporter;
    if(old!=null)t.spriteBorder=old.spriteBorder;
    else if(new[]{"bg_normal","com_new_","9bg_big","bg_soldout","btn_package1","box_bg","bg_number"}.Any(x=>Path.GetFileNameWithoutExtension(path).Contains(x)))t.spriteBorder=new Vector4(18,18,18,18);
   }
   t.SaveAndReimport();imported++;
  }
  string fonts="Assets/Zatod/Resources/Zatod/UI/Inventory/Fonts/";
  foreach(var pair in new[]{new[]{"DFPYuanW7-GB.ttf","InventoryRegular"},new[]{"FZCQJW.ttf","InventoryBold"}})
  {
   AssetDatabase.ImportAsset(fonts+pair[0]);string path=fonts+pair[1]+".asset";var font=AssetDatabase.LoadAssetAtPath<TMP_FontAsset>(path);
   if(font==null){font=TMP_FontAsset.CreateFontAsset(AssetDatabase.LoadAssetAtPath<Font>(fonts+pair[0]),90,9,GlyphRenderMode.SDFAA,1024,1024,AtlasPopulationMode.Dynamic,true);font.name=pair[1];AssetDatabase.CreateAsset(font,path);AssetDatabase.AddObjectToAsset(font.material,font);}
   font.material.EnableKeyword("OUTLINE_ON");
   font.fallbackFontAssetTable=new System.Collections.Generic.List<TMP_FontAsset>{Resources.Load<TMP_FontAsset>("Zatod/UI/Formation/ZatodFormationLatin")};
   font.TryAddCharacters(new string(Enumerable.Range(32,95).Select(x=>(char)x).ToArray())+"×−→…·",out var missing);
   foreach(var texture in font.atlasTextures)if(texture!=null&&!AssetDatabase.Contains(texture))AssetDatabase.AddObjectToAsset(texture,font);EditorUtility.SetDirty(font);AssetDatabase.SaveAssetIfDirty(font);
  }
  var c=HeroDataJson.LoadBundledCatalog();if(c.Data.Items.Count!=142||c.Data.StarRules.Count!=5)throw new Exception("Inventory catalog incomplete.");
  if(c.Data.Items.Any(i=>i.ItemKind==ItemKind.Soulstone&&Resources.Load<Sprite>("Zatod/UI/Hero/Items/"+i.DefinitionId)==null))throw new Exception("Missing Soulstone sprite.");
  GameEditorWindow.OpenStarRules();var result=new{Result="PASS",ImportedSprites=imported,Items=c.Data.Items.Count,StarRules=c.Data.StarRules.Count};
  File.WriteAllText(Path.GetFullPath("../Artifacts/ZatodInventoryChecks/editor.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
 }
}
