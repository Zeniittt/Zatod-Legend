// [UNITY-SKILL:SPRITEATLAS]
using System;
using System.IO;
using UnityEditor;
using UnityEditor.Build;
using UnityEditor.Build.Reporting;
using UnityEditor.U2D;
using UnityEngine;

namespace Zatod.Editor
{
    public sealed class LeenaldAtlasBuild : IPreprocessBuildWithReport
    {
        public const string SpriteFolder = "Assets/Zatod/Art/Leenald";
        public const string AtlasPath = "Assets/Zatod/Art/Leenald/Leenald.spriteatlasv2";
        public int callbackOrder { get { return 0; } }
        public void OnPreprocessBuild(BuildReport report)
        {
            const string root="Assets/Zatod/Art";
            if(!Directory.Exists(root))return;
            foreach(var folder in Directory.GetDirectories(root))
                foreach(var path in Directory.GetFiles(folder,"*.spriteatlasv2")) Ensure(folder.Replace('\\','/'),path.Replace('\\','/'));
        }

        public static void Ensure(string spriteFolder=SpriteFolder,string atlasPath=AtlasPath)
        {
            EditorSettings.spritePackerMode = SpritePackerMode.SpriteAtlasV2;
            if (EditorSettings.spritePackerMode != SpritePackerMode.SpriteAtlasV2) throw new InvalidOperationException("SpriteAtlas V2 packing did not enable.");
            if (!File.Exists(atlasPath))
            {
                var atlas = new SpriteAtlasAsset();
                atlas.Add(new UnityEngine.Object[] { AssetDatabase.LoadAssetAtPath<DefaultAsset>(spriteFolder) });
                SpriteAtlasAsset.Save(atlas, atlasPath); AssetDatabase.ImportAsset(atlasPath);
            }
            var importer = AssetImporter.GetAtPath(atlasPath) as SpriteAtlasImporter;
            if (importer == null) throw new InvalidOperationException("Missing SpriteAtlas V2 importer.");
            importer.includeInBuild = true;
            var packing = importer.packingSettings; packing.enableRotation = false; packing.enableTightPacking = false; packing.padding = 4;
            importer.packingSettings = packing;
            var texture = importer.textureSettings; texture.filterMode = FilterMode.Point; texture.generateMipMaps = false; texture.readable = false;
            importer.textureSettings = texture;
            var platform = importer.GetPlatformSettings("Standalone");
            platform.overridden = true; platform.maxTextureSize = 4096; platform.format = TextureImporterFormat.RGBA32;
            importer.SetPlatformSettings(platform);
            importer.SaveAndReimport();
        }
    }
}
