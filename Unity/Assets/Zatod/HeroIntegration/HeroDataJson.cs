using System;
using System.IO;
using System.Text;
using UnityEngine;

namespace Zatod.Heroes
{
    public static class HeroDataJson
    {
        public const string ResourceKey = "Data/HeroCatalog";
        public const string CatalogAssetPath = "Assets/Zatod/Resources/Data/HeroCatalog.txt";

        public static HeroCatalog LoadBundledCatalog()
        {
            var asset = Resources.Load<TextAsset>(ResourceKey);
            if (asset == null) throw new FileNotFoundException("Missing hero JSON config: " + CatalogAssetPath);
            return ReadCatalog(asset.text);
        }

        public static HeroCatalog ReadCatalog(string json)
        {
            RequireJson(json);
            return new HeroCatalog(JsonUtility.FromJson<HeroCatalogData>(json));
        }

        public static string WriteCatalog(HeroCatalogData data)
        {
            _ = new HeroCatalog(data);
            return JsonUtility.ToJson(data, true);
        }

        public static CharacterData ReadCharacter(string json, HeroCatalog catalog)
        {
            RequireJson(json);
            var data = JsonUtility.FromJson<CharacterData>(json);
            catalog.Bind(data);
            return data;
        }

        public static string WriteCharacter(CharacterData data, HeroCatalog catalog)
        {
            catalog.Bind(data);
            return JsonUtility.ToJson(data, true);
        }

        // Caller chooses the persistence location. A future server account repository owns revisions
        // and multi-resource transactions; this helper only prevents partially written JSON files.
        public static void WriteFileAtomically(string path, string json)
        {
            string full = Path.GetFullPath(path);
            Directory.CreateDirectory(Path.GetDirectoryName(full));
            string temporary = full + "." + Guid.NewGuid().ToString("N") + ".tmp";
            try
            {
                using (var stream = new FileStream(temporary, FileMode.CreateNew, FileAccess.Write, FileShare.None))
                {
                    byte[] bytes = new UTF8Encoding(false).GetBytes(json);
                    stream.Write(bytes, 0, bytes.Length);
                    stream.Flush(true);
                }
                if (File.Exists(full)) File.Replace(temporary, full, null);
                else File.Move(temporary, full);
            }
            finally { if (File.Exists(temporary)) File.Delete(temporary); }
        }

        static void RequireJson(string json)
        {
            if (string.IsNullOrWhiteSpace(json) || !json.TrimStart().StartsWith("{", StringComparison.Ordinal))
                throw new ArgumentException("Expected a JSON object.");
        }
    }
}
