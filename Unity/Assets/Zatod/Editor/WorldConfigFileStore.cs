using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using Zatod.Heroes;
using Zatod.World;

namespace Zatod.Editor
{
    [Serializable] public sealed class WorldMapDraft
    {
        public string Resource,SourceText;
        public WorldMapDefinition Draft;
        public string AssetPath=>WorldConfigFileStore.MapAssetPath(Resource);
        public bool Changed=>JsonUtility.ToJson(Draft)!=JsonUtility.ToJson(JsonUtility.FromJson<WorldMapDefinition>(SourceText));
    }
    [Serializable] public sealed class WorldConfigDocuments
    {
        public string IndexSource;
        public WorldDefinition Index;
        public List<WorldMapDraft> Maps=new List<WorldMapDraft>();
        public bool Changed=>JsonUtility.ToJson(Index)!=JsonUtility.ToJson(JsonUtility.FromJson<WorldDefinition>(IndexSource)) || Maps.Any(m=>m.Changed);
    }
    public static class WorldConfigFileStore
    {
        public const string IndexPath="Assets/Zatod/Resources/Data/Worlds.txt";
        public static string MapAssetPath(string resource)
        {
            if(string.IsNullOrWhiteSpace(resource) || !resource.StartsWith("Data/WorldMaps/",StringComparison.Ordinal) || resource.Contains("..") || resource.Contains('\\') || resource.Contains(':'))
                throw new ArgumentException("Island resource must be inside Data/WorldMaps: "+resource);
            string path="Assets/Zatod/Resources/"+resource+".txt";
            string root=Path.GetFullPath("Assets/Zatod/Resources/Data/WorldMaps")+Path.DirectorySeparatorChar;
            if(!Path.GetFullPath(path).StartsWith(root,StringComparison.OrdinalIgnoreCase))throw new ArgumentException("Island config escapes WorldMaps.");
            return path;
        }
        public static WorldConfigDocuments Read()
        {
            string source=File.ReadAllText(IndexPath);var index=JsonUtility.FromJson<WorldDefinition>(source);
            if(index?.MapResources==null || index.MapResources.Count==0)throw new ArgumentException("Worlds.txt must reference the island config files.");
            var result=new WorldConfigDocuments{IndexSource=source,Index=index};
            foreach(string resource in index.MapResources)
            {
                string text=File.ReadAllText(MapAssetPath(resource));var map=JsonUtility.FromJson<WorldMapDefinition>(text);
                if(map==null)throw new ArgumentException("Invalid island JSON: "+resource);
                result.Maps.Add(new WorldMapDraft{Resource=resource,SourceText=text,Draft=map});
            }
            return result;
        }
        public static bool FilesChanged(WorldConfigDocuments documents)
        {
            if(documents==null || !File.Exists(IndexPath) || File.ReadAllText(IndexPath)!=documents.IndexSource)return true;
            return documents.Maps.Any(m=>!File.Exists(m.AssetPath) || File.ReadAllText(m.AssetPath)!=m.SourceText);
        }
        public static WorldCatalog Validate(WorldConfigDocuments documents,CampaignCatalog campaign)
        {
            if(documents==null)throw new ArgumentException("Reload map config first.");
            var catalog=new WorldCatalog(documents.Index,campaign,resource=>documents.Maps.Single(m=>m.Resource==resource).Draft);
            foreach(var map in documents.Maps.Select(m=>m.Draft))
            {
                foreach(string visual in new[]{map.VisualResource}.Concat(map.Props.Select(p=>p.VisualResource)).Concat(map.Interactions.Select(p=>p.VisualResource)))
                    if(string.IsNullOrWhiteSpace(visual) || !File.Exists("Assets/Zatod/Resources/Zatod/World/Visuals/"+visual+".prefab"))throw new ArgumentException("Missing map visual prefab: "+visual);
            }
            return catalog;
        }
        public static int Save(WorldConfigDocuments documents,CampaignCatalog campaign)
        {
            if(FilesChanged(documents))throw new IOException("Map config changed on disk. Draft preserved; reload before saving.");
            Validate(documents,campaign);
            var writes=new List<Tuple<string,string,string>>();
            if(JsonUtility.ToJson(documents.Index)!=JsonUtility.ToJson(JsonUtility.FromJson<WorldDefinition>(documents.IndexSource)))writes.Add(Tuple.Create(IndexPath,documents.IndexSource,JsonUtility.ToJson(documents.Index,true)));
            foreach(var map in documents.Maps.Where(m=>m.Changed))writes.Add(Tuple.Create(map.AssetPath,map.SourceText,JsonUtility.ToJson(map.Draft,true)));
            if(writes.Count==0)return 0;
            string backup=Path.GetFullPath("../Artifacts/ZatodConfigBefore/maps-"+DateTime.UtcNow.ToString("yyyyMMdd-HHmmss-fff")+"-"+Guid.NewGuid().ToString("N"));
            foreach(var item in writes)
            {
                string path=Path.Combine(backup,item.Item1.Substring("Assets/Zatod/Resources/Data/".Length));Directory.CreateDirectory(Path.GetDirectoryName(path));File.WriteAllText(path,item.Item2);
            }
            var completed=new List<Tuple<string,string,string>>();
            try{foreach(var item in writes){HeroDataJson.WriteFileAtomically(item.Item1,item.Item3);completed.Add(item);}}
            catch{foreach(var item in completed.AsEnumerable().Reverse())HeroDataJson.WriteFileAtomically(item.Item1,item.Item2);throw;}
            documents.IndexSource=File.ReadAllText(IndexPath);foreach(var map in documents.Maps)map.SourceText=File.ReadAllText(map.AssetPath);
            foreach(var item in writes)AssetDatabase.ImportAsset(item.Item1);
            return writes.Count;
        }
    }
}
