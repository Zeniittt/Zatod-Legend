using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using Zatod.Heroes;

namespace Zatod.Editor
{
    public static class HeroConfigFileStore
    {
        public static bool AnyFileExists { get { return HeroDataJson.Sections.Any(s => File.Exists(HeroDataJson.AssetPath(s))); } }

        public static HeroConfigDocuments Read()
        {
            var documents = ReadExisting();
            _ = HeroDataJson.ReadDocuments(documents);
            return documents;
        }

        public static HeroConfigDocuments ReadExisting()
        {
            var documents = new HeroConfigDocuments();
            foreach (var section in HeroDataJson.Sections)
            {
                string path = HeroDataJson.AssetPath(section);
                documents.Set(section, File.Exists(path) ? File.ReadAllText(path) : null);
            }
            return documents;
        }

        public static HeroConfigDocuments Save(HeroCatalogData data, HeroConfigDocuments expected)
        {
            var transaction = new ConfigFileTransaction();
            var next = PrepareSave(data, expected, transaction);
            transaction.Commit("heroes");
            transaction.ImportAssets();
            return next;
        }

        internal static HeroConfigDocuments PrepareSave(HeroCatalogData data, HeroConfigDocuments expected, ConfigFileTransaction transaction)
        {
            if (expected == null) throw new ArgumentNullException(nameof(expected));
            var next = HeroDataJson.WriteDocuments(data);
            var current = ReadExisting();
            foreach (var section in HeroDataJson.Sections)
                if (current.Get(section) != expected.Get(section))
                    throw new IOException(section + ".txt changed on disk. Reload before saving; no file has been overwritten.");
            if (AnyFileExists)
            {
                var old = HeroDataJson.ReadDocuments(current).Data;
                if (HeroDataJson.WriteCatalog(old) != HeroDataJson.WriteCatalog(data) && old.ConfigVersion == data.ConfigVersion)
                    throw new ArgumentException("Change ConfigVersion before saving a balance update.");
            }

            foreach (var section in HeroDataJson.Sections)
                transaction.Add(HeroDataJson.AssetPath(section), current.Get(section), next.Get(section));
            return next;
        }

        public static void ImportFiles()
        {
            foreach (var section in HeroDataJson.Sections)
                if (File.Exists(HeroDataJson.AssetPath(section))) AssetDatabase.ImportAsset(HeroDataJson.AssetPath(section), ImportAssetOptions.ForceUpdate);
        }

        // One-time conversion of the existing prototype config, preserving every balance value.
        public static object MigrateLegacyFile()
        {
            const string legacyPath = HeroDataJson.ConfigAssetDirectory + "/HeroCatalog.txt";
            if (!File.Exists(legacyPath)) throw new FileNotFoundException("No legacy config to split.");
            if (AnyFileExists) throw new IOException("Split config files already exist; migration will not overwrite them.");
            string original = File.ReadAllText(legacyPath);
            var data = HeroDataJson.ReadCatalog(original.Replace("\"AttackScaleBasisPoints\"", "\"DamageScaleBasisPoints\"")).Data;
            foreach (var stat in data.Stats)
            {
                if (stat.Id == "attack") { stat.Id = "damage"; stat.Name = "Damage"; }
                else if (stat.Id == "armor") { stat.Id = "defense"; stat.Name = "Defense"; }
            }
            Action<IEnumerable<StatValue>> rename = values =>
            {
                foreach (var value in values) value.StatId = RenameStat(value.StatId);
            };
            foreach (var item in data.Items) rename(item.Stats);
            foreach (var hero in data.Heroes)
            {
                rename(hero.BaseStats);
                foreach (var rank in hero.Ranks) rename(rank.BonusStats);
            }
            foreach (var skill in data.Skills)
                foreach (var effect in skill.Effects) effect.StatId = RenameStat(effect.StatId);
            data.ConfigVersion += "-split-1";
            string backup = Path.GetFullPath(Path.Combine(Application.dataPath, "../../Artifacts/HeroConfigBeforeSplit", DateTime.UtcNow.ToString("yyyyMMdd-HHmmss")));
            Directory.CreateDirectory(backup);
            File.Copy(legacyPath, Path.Combine(backup, "HeroCatalog.txt"), false);
            if (File.Exists(legacyPath + ".meta")) File.Copy(legacyPath + ".meta", Path.Combine(backup, "HeroCatalog.txt.meta"), false);
            Save(data, new HeroConfigDocuments());
            if (!AssetDatabase.DeleteAsset(legacyPath)) throw new IOException("Split completed but the old config asset could not be removed.");
            return new { status = "PASS", backup, data.ConfigVersion, files = HeroDataJson.Sections.Select(HeroDataJson.AssetPath).ToArray() };
        }

        static string RenameStat(string id) { return id == "attack" ? "damage" : id == "armor" ? "defense" : id; }
    }
}
