using System;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using UnityEditor;
using UnityEngine;

namespace Zatod.Editor
{
    public static class ZatodD34WorldArt
    {
        [Serializable] sealed class Art { public string Target,Sha256; }
        [Serializable] sealed class Stage { public int SourceStageId; public string VisualResource,IconResource; }
        [Serializable] sealed class ChapterManifest { public Stage[] StageVisuals; public Art[] DerivedArt; }
        public static int Prepare(string manifestPath)
        {
            if(EditorApplication.isPlaying)throw new InvalidOperationException("Stop Play Mode before authoring world assets.");
            var manifest=Newtonsoft.Json.JsonConvert.DeserializeObject<ChapterManifest>(File.ReadAllText(manifestPath));
            if(manifest?.StageVisuals?.Length!=115)throw new InvalidDataException("Expected the 115 new stage visuals.");
            foreach(var art in manifest.DerivedArt)
            {
                if(!art.Target.StartsWith("Assets/Zatod/Resources/Zatod/World/StageIcons/stage_",StringComparison.Ordinal) || art.Target.Contains(".."))
                    throw new InvalidDataException("Invalid stage art path.");
                using(var sha=SHA256.Create())using(var stream=File.OpenRead(art.Target))
                    if(BitConverter.ToString(sha.ComputeHash(stream)).Replace("-","").ToLowerInvariant()!=art.Sha256)
                        throw new InvalidDataException("Stage art hash mismatch: "+art.Target);
            }
            foreach(var art in manifest.DerivedArt)
            {
                AssetDatabase.ImportAsset(art.Target,ImportAssetOptions.ForceSynchronousImport);
                var importer=(TextureImporter)AssetImporter.GetAtPath(art.Target);
                importer.textureType=TextureImporterType.Sprite;importer.spriteImportMode=SpriteImportMode.Single;
                importer.spritePixelsPerUnit=100;importer.spritePivot=new Vector2(.5f,.5f);
                importer.alphaIsTransparency=true;importer.mipmapEnabled=false;importer.maxTextureSize=2048;
                importer.textureCompression=TextureImporterCompression.Uncompressed;importer.SaveAndReimport();
            }
            string folder="Assets/Zatod/Resources/Zatod/World/Visuals/";
            string buffMaterial="Assets/Zatod/Resources/Zatod/World/ZatodBuffSprite.mat";
            if(AssetDatabase.LoadAssetAtPath<Material>(buffMaterial)==null)
            {
                var shader=Shader.Find("Zatod/Native Buff Sprite");
                if(shader==null)throw new InvalidDataException("Missing native buff shader.");
                AssetDatabase.CreateAsset(new Material(shader){name="ZatodBuffSprite"},buffMaterial);
            }
            var material=Resources.Load<Material>("Zatod/World/ZatodWorldSprite");
            if(material==null)throw new InvalidDataException("Missing world sprite material.");
            foreach(var stage in manifest.StageVisuals)
            {
                if(stage.SourceStageId<40 || stage.SourceStageId>154 || stage.VisualResource!="crystal_stage_"+stage.SourceStageId)
                    throw new InvalidDataException("Invalid stage visual ID.");
                var go=new GameObject(stage.VisualResource);
                try
                {
                    var renderer=go.AddComponent<SpriteRenderer>();renderer.sprite=Resources.Load<Sprite>(stage.IconResource);
                    if(renderer.sprite==null)throw new InvalidDataException("Missing stage sprite: "+stage.IconResource);
                    renderer.sharedMaterial=material;
                    PrefabUtility.SaveAsPrefabAsset(go,folder+stage.VisualResource+".prefab");
                }
                finally{UnityEngine.Object.DestroyImmediate(go);}
            }
            foreach(string suffix in new[]{"background","patch","tree_0","tree_1","tree_2"})
            {
                string source=folder+"undead_"+suffix+".prefab",target=folder+"purple_"+suffix+".prefab";
                var template=AssetDatabase.LoadAssetAtPath<GameObject>(source);
                if(template==null)throw new InvalidDataException("Missing purple theme template: "+source);
                var go=(GameObject)PrefabUtility.InstantiatePrefab(template);
                try
                {
                    go.name="purple_"+suffix;
                    foreach(var renderer in go.GetComponentsInChildren<SpriteRenderer>(true))renderer.color*=new Color(.82f,.60f,1f,1f);
                    PrefabUtility.SaveAsPrefabAsset(go,target);
                }
                finally{UnityEngine.Object.DestroyImmediate(go);}
            }
            AssetDatabase.SaveAssets();return manifest.StageVisuals.Length+5;
        }
    }
}
