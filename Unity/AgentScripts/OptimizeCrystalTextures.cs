using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
var paths=Directory.GetFiles("Assets/Zatod/Art/Crystal","*.png",SearchOption.AllDirectories).Select(p=>p.Replace('\\','/')).ToArray();
int changed=0;
AssetDatabase.StartAssetEditing();
try
{
    foreach(string path in paths)
    {
        var importer=(TextureImporter)AssetImporter.GetAtPath(path);
        var platform=importer.GetPlatformTextureSettings("Standalone");
        if(platform.overridden && platform.format==TextureImporterFormat.BC7 && platform.maxTextureSize==4096)continue;
        platform.name="Standalone";platform.overridden=true;platform.format=TextureImporterFormat.BC7;platform.maxTextureSize=4096;platform.compressionQuality=50;platform.crunchedCompression=false;
        importer.SetPlatformTextureSettings(platform);importer.SaveAndReimport();changed++;
    }
}
finally{AssetDatabase.StopAssetEditing();}
AssetDatabase.SaveAssets();
File.WriteAllText("../Artifacts/CrystalPhaseChecks/texture-runtime-format.json", "{\"Textures\":"+paths.Length+",\"Changed\":"+changed+",\"StandaloneFormat\":\"BC7\",\"SourcePngUnchanged\":true}");
return new{textures=paths.Length,changed,format="BC7",maxSize=4096};
