using System;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using UnityEditor;
using UnityEngine;

namespace Zatod.Editor
{
    // The manifest is generated from tracked source by Import-ZatodD34Heroes.py.
    // Art import does not activate a Hero, a skill or the free-PvP roster.
    public static class ZatodHeroImportArt
    {
        [Serializable] public sealed class NativeAsset { public string Source,Target,Sha256; }
        [Serializable] public sealed class HeroRow { public string Id,SourceResource,AnimationSetResource; public int SourceUnitId;public bool Form; }
        [Serializable] public sealed class Manifest
        {
            public bool Draft,RuntimeActivationReady;
            public NativeAsset[] Assets,AudioAssets;
            public HeroRow[] Heroes,Monsters,Forms;
            public HeroRow[] Actors=>(Heroes??Array.Empty<HeroRow>()).Concat(Monsters??Array.Empty<HeroRow>()).Concat(Forms??Array.Empty<HeroRow>()).ToArray();
        }

        static string Within(string root,string relative)
        {
            string directory=Path.GetFullPath(root)+Path.DirectorySeparatorChar;
            string path=Path.GetFullPath(Path.Combine(directory,relative));
            if(!path.StartsWith(directory,StringComparison.Ordinal))throw new ArgumentException("Import path escapes its root: "+relative);
            return path;
        }
        static string Hash(string path)
        {
            using(var sha=SHA256.Create())using(var stream=File.OpenRead(path))
                return BitConverter.ToString(sha.ComputeHash(stream)).Replace("-","").ToLowerInvariant();
        }
        public static int PrepareNativeArt(string manifestPath,string repositoryRoot)
        {
            if(EditorApplication.isPlaying)throw new InvalidOperationException("Stop Play Mode before importing Hero art.");
            var manifest=Newtonsoft.Json.JsonConvert.DeserializeObject<Manifest>(File.ReadAllText(manifestPath));
            if(manifest?.Assets==null || manifest.Heroes==null)throw new ArgumentException("Missing Hero import manifest.");
            var assets=manifest.Assets.Concat(manifest.AudioAssets??Array.Empty<NativeAsset>()).ToArray();
            // Validate every input before copying any file.
            foreach(var asset in assets)
            {
                string source=Within(repositoryRoot,asset.Source);
                if(!asset.Source.StartsWith("Unity/Assets/Crystal Legend/recovered/assets/",StringComparison.Ordinal) || Hash(source)!=asset.Sha256)
                    throw new InvalidDataException("Native art hash/source mismatch: "+asset.Source);
                if(!asset.Target.StartsWith("Zatod/UI/",StringComparison.Ordinal) && !asset.Target.StartsWith("Zatod/Audio/",StringComparison.Ordinal) && !asset.Target.StartsWith("Zatod/Backgrounds/",StringComparison.Ordinal))throw new InvalidDataException("Invalid native resource target.");
                _=Within("Assets/Zatod/Resources",asset.Target);
            }
            foreach(var asset in assets)
            {
                string source=Within(repositoryRoot,asset.Source),target=Within("Assets/Zatod/Resources",asset.Target);
                Directory.CreateDirectory(Path.GetDirectoryName(target));
                if(!File.Exists(target) || Hash(target)!=asset.Sha256)File.Copy(source,target,true);
                string path="Assets/Zatod/Resources/"+asset.Target;
                AssetDatabase.ImportAsset(path,ImportAssetOptions.ForceSynchronousImport);
                if(asset.Target.StartsWith("Zatod/Audio/",StringComparison.Ordinal))continue;
                var importer=(TextureImporter)AssetImporter.GetAtPath(path);
                importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Single;
                importer.mipmapEnabled=false;importer.alphaIsTransparency=true;importer.maxTextureSize=2048;
                importer.textureCompression=TextureImporterCompression.Uncompressed;importer.SaveAndReimport();
                if(asset.Target.StartsWith("Zatod/Backgrounds/",StringComparison.Ordinal))
                {
                    foreach(string platform in new[]{"Android","iPhone"})
                    {
                        var settings=importer.GetPlatformTextureSettings(platform);settings.name=platform;
                        settings.overridden=true;settings.maxTextureSize=2048;settings.format=TextureImporterFormat.ASTC_6x6;
                        importer.SetPlatformTextureSettings(settings);
                    }
                    importer.SaveAndReimport();
                }
            }
            AssetDatabase.SaveAssets();return assets.Length;
        }
    }
}
