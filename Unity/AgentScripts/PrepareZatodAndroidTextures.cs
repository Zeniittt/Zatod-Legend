using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
var paths=AssetDatabase.FindAssets("t:Texture2D",new[]{"Assets/Zatod/Art/Imported"}).Select(AssetDatabase.GUIDToAssetPath).Where(p=>p.EndsWith(".png",StringComparison.OrdinalIgnoreCase)).ToArray();
int changed=0;
try
{
 AssetDatabase.StartAssetEditing();
 foreach(var path in paths)
 {
  var importer=AssetImporter.GetAtPath(path) as TextureImporter;if(importer==null)continue;
  var settings=importer.GetPlatformTextureSettings("Android");
  if(settings.overridden&&settings.format==TextureImporterFormat.ASTC_6x6)continue;
  settings.name="Android";settings.overridden=true;settings.format=TextureImporterFormat.ASTC_6x6;
  settings.maxTextureSize=importer.maxTextureSize;settings.compressionQuality=100;
  importer.SetPlatformTextureSettings(settings);importer.SaveAndReimport();changed++;
 }
}
finally{AssetDatabase.StopAssetEditing();}
var result=new{Textures=paths.Length,Changed=changed,Platform="Android",Format="ASTC_6x6",SourcePixelsAndSpriteGeometry="Unchanged",Standalone="Unchanged"};
File.WriteAllText(Path.GetFullPath("../Artifacts/ZatodLanLoginChecks/android-texture-settings.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));
return result;
