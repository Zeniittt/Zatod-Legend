using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
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
                result.Maps.Add(ReadMap(resource));
            return result;
        }
        static WorldMapDraft ReadMap(string resource)
        {
            string text=File.ReadAllText(MapAssetPath(resource));
            var map=JsonUtility.FromJson<WorldMapDefinition>(text)??throw new ArgumentException("Invalid island JSON: "+resource);
            return new WorldMapDraft{Resource=resource,SourceText=text,Draft=map};
        }
        public static void Attach(WorldConfigDocuments documents,string resource)
        {
            if(documents==null)throw new ArgumentException("Reload map config first.");
            if(documents.Index.MapResources.Contains(resource,StringComparer.OrdinalIgnoreCase))
                throw new ArgumentException("Worlds.txt already references: "+resource);
            var map=ReadMap(resource);
            if(string.IsNullOrWhiteSpace(map.Draft.Id) || documents.Maps.Any(m=>m.Draft.Id==map.Draft.Id))
                throw new ArgumentException("Island id is missing or already in use: "+map.Draft.Id);
            documents.Index.MapResources.Add(resource);
            documents.Maps.Add(map);
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
            => SaveCampaignAndMaps(documents,campaign,null);

        public static int SaveCampaignAndMaps(WorldConfigDocuments documents,CampaignCatalog campaign,string originalCampaign)
        {
            var transaction=new ConfigFileTransaction();
            int mapsSaved=PrepareSave(documents,campaign,originalCampaign,transaction);
            transaction.Commit("world");
            AcceptSaved(documents,transaction);
            transaction.ImportAssets();
            return mapsSaved;
        }

        internal static int PrepareSave(WorldConfigDocuments documents,CampaignCatalog campaign,string originalCampaign,ConfigFileTransaction transaction)
        {
            if(FilesChanged(documents))throw new IOException("Map config changed on disk. Draft preserved; reload before saving.");
            if(originalCampaign!=null && File.ReadAllText(CampaignDataJson.AssetPath)!=originalCampaign)
                throw new IOException("Campaign config changed on disk. Draft preserved; reload before saving.");
            Validate(documents,campaign);
            if(originalCampaign!=null)
                transaction.Add(CampaignDataJson.AssetPath,originalCampaign,JsonUtility.ToJson(campaign.Data,true));
            int mapsSaved=0;
            if(JsonUtility.ToJson(documents.Index)!=JsonUtility.ToJson(JsonUtility.FromJson<WorldDefinition>(documents.IndexSource)))
            {
                transaction.Add(IndexPath,documents.IndexSource,JsonUtility.ToJson(documents.Index,true));
                mapsSaved++;
            }
            foreach(var map in documents.Maps.Where(m=>m.Changed))
            {
                transaction.Add(map.AssetPath,map.SourceText,JsonUtility.ToJson(map.Draft,true));
                mapsSaved++;
            }
            return mapsSaved;
        }

        internal static void AcceptSaved(WorldConfigDocuments documents,ConfigFileTransaction transaction)
        {
            documents.IndexSource=transaction.SavedText(IndexPath,documents.IndexSource);
            foreach(var map in documents.Maps)map.SourceText=transaction.SavedText(map.AssetPath,map.SourceText);
        }
    }
}
