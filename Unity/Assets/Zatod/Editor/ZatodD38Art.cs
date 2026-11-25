using System;
using System.IO;
using UnityEditor;
using UnityEngine;
namespace Zatod.Editor
{
    public static class ZatodD38Art
    {
        public static string Prepare()
        {
            if(EditorApplication.isPlaying)throw new InvalidOperationException("Stop Play Mode before importing D38 art.");
            int count=0;
            foreach(string path in Directory.GetFiles("Assets/Zatod/Resources/Zatod/UI/ChapterSelector"))
            {
                if(!path.EndsWith(".png") && !path.EndsWith(".jpg"))continue;
                AssetDatabase.ImportAsset(path,ImportAssetOptions.ForceSynchronousImport);
                var importer=(TextureImporter)AssetImporter.GetAtPath(path);importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Single;importer.mipmapEnabled=false;importer.alphaIsTransparency=true;importer.maxTextureSize=4096;importer.textureCompression=TextureImporterCompression.Uncompressed;
                foreach(string platform in new[]{"Android","iPhone"}){var settings=importer.GetPlatformTextureSettings(platform);settings.name=platform;settings.overridden=true;settings.maxTextureSize=4096;settings.format=TextureImporterFormat.ASTC_6x6;importer.SetPlatformTextureSettings(settings);}
                importer.SaveAndReimport();count++;
            }
            foreach(string resource in new[]{"eff_UI_Main_Pve","eff_UI_Main_Guild","eff_UI_Main_Pvp","eff_UI_Main_fancytower","eff_UI_Main_Pvp_fort"}){ZatodEvolutionArt.ImportBakedResource(resource,true);count++;}
            AssetDatabase.SaveAssets();return "D38 imported "+count+" resources";
        }
    }
}
