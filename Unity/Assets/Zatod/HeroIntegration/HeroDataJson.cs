using System;
using System.IO;
using System.Text;
using UnityEngine;

namespace Zatod.Heroes
{
    public static class HeroDataJson
    {
        public const string ConfigAssetDirectory = "Assets/Zatod/Resources/Data";
        public static readonly HeroConfigSection[] Sections =
            { HeroConfigSection.Stats, HeroConfigSection.Items, HeroConfigSection.Skills, HeroConfigSection.Heroes, HeroConfigSection.Monsters, HeroConfigSection.Buffs, HeroConfigSection.CraftRecipes, HeroConfigSection.StarRules };

        public static string AssetPath(HeroConfigSection section) { return ConfigAssetDirectory + "/" + section + ".txt"; }

        public static HeroCatalog LoadBundledCatalog()
        {
            var documents = new HeroConfigDocuments();
            foreach (var section in Sections)
            {
                var asset = Resources.Load<TextAsset>("Data/" + section);
                if (asset == null && (section==HeroConfigSection.Monsters || section==HeroConfigSection.Buffs || section==HeroConfigSection.CraftRecipes)) continue;
                if (asset == null) throw new FileNotFoundException("Missing hero JSON config: " + AssetPath(section));
                documents.Set(section, asset.text);
            }
            return ReadDocuments(documents);
        }

        public static HeroCatalog ReadDocuments(HeroConfigDocuments documents)
        {
            if (documents == null) throw new ArgumentNullException(nameof(documents));
            HeroCatalogData data = null;
            foreach (var section in Sections)
            {
                if((section==HeroConfigSection.Monsters || section==HeroConfigSection.Buffs || section==HeroConfigSection.CraftRecipes) && string.IsNullOrWhiteSpace(documents.Get(section))) continue;
                var table = ReadTable(section, documents.Get(section));
                if (data == null) data = new HeroCatalogData { SchemaVersion = table.SchemaVersion, ConfigVersion = table.ConfigVersion };
                if (table.SchemaVersion != data.SchemaVersion || table.ConfigVersion != data.ConfigVersion)
                    throw new ArgumentException("Config versions differ between files: " + section + ".txt");
                AssignTable(data, section, table);
            }
            return new HeroCatalog(data);
        }

        public static HeroConfigDocuments WriteDocuments(HeroCatalogData data)
        {
            _ = new HeroCatalog(data);
            var documents = new HeroConfigDocuments();
            foreach (var section in Sections) documents.Set(section, WriteSection(data, section));
            return documents;
        }

        public static string WriteSection(HeroCatalogData data, HeroConfigSection section)
        {
            HeroConfigTable table;
            switch (section)
            {
                case HeroConfigSection.Stats: table = new StatsConfigData { Stats = data.Stats }; break;
                case HeroConfigSection.Items: table = new ItemsConfigData { Items = data.Items }; break;
                case HeroConfigSection.Skills: table = new SkillsConfigData { Skills = data.Skills, SkillProgression = data.SkillProgression }; break;
                case HeroConfigSection.Heroes: table = new HeroesConfigData { Heroes = data.Heroes }; break;
                case HeroConfigSection.Monsters: table = new MonstersConfigData { Monsters = data.Monsters }; break;
                case HeroConfigSection.Buffs: table = new BuffsConfigData { Buffs = data.Buffs }; break;
                case HeroConfigSection.CraftRecipes: table = new CraftRecipesConfigData { CraftRecipes = data.CraftRecipes }; break;
                case HeroConfigSection.StarRules: table = new StarRulesConfigData { StarRules = data.StarRules, MaxHeroStars=data.MaxHeroStars }; break;
                default: throw new ArgumentOutOfRangeException(nameof(section));
            }
            table.SchemaVersion = data.SchemaVersion; table.ConfigVersion = data.ConfigVersion;
            return JsonUtility.ToJson(table, true);
        }

        // Allows a temporarily incomplete draft while editing one table; full validation is done on Save.
        public static void ApplySection(HeroCatalogData draft, HeroConfigSection section, string json)
        {
            var table = ReadTable(section, json);
            AssignTable(draft, section, table);
            draft.SchemaVersion = table.SchemaVersion; draft.ConfigVersion = table.ConfigVersion;
        }

        static HeroConfigTable ReadTable(HeroConfigSection section, string json)
        {
            RequireJson(json);
            HeroConfigTable table;
            bool hasEntries;
            switch (section)
            {
                case HeroConfigSection.StarRules:
                    var stars = JsonUtility.FromJson<StarRulesConfigData>(json); table = stars; hasEntries = stars != null && stars.StarRules != null; break;
                case HeroConfigSection.CraftRecipes:
                    var recipes = JsonUtility.FromJson<CraftRecipesConfigData>(json); table = recipes; hasEntries = recipes != null && recipes.CraftRecipes != null; break;
                case HeroConfigSection.Stats:
                    var stats = JsonUtility.FromJson<StatsConfigData>(json); table = stats; hasEntries = stats != null && stats.Stats != null; break;
                case HeroConfigSection.Items:
                    var items = JsonUtility.FromJson<ItemsConfigData>(json); table = items; hasEntries = items != null && items.Items != null; break;
                case HeroConfigSection.Skills:
                    var skills = JsonUtility.FromJson<SkillsConfigData>(json); table = skills; hasEntries = skills != null && skills.Skills != null; break;
                case HeroConfigSection.Heroes:
                    var heroes = JsonUtility.FromJson<HeroesConfigData>(json); table = heroes; hasEntries = heroes != null && heroes.Heroes != null; break;
                case HeroConfigSection.Buffs:
                    var buffs = JsonUtility.FromJson<BuffsConfigData>(json); table = buffs; hasEntries = buffs != null && buffs.Buffs != null; break;
                case HeroConfigSection.Monsters:
                    var monsters = JsonUtility.FromJson<MonstersConfigData>(json); table = monsters; hasEntries = monsters != null && monsters.Monsters != null; break;
                default: throw new ArgumentOutOfRangeException(nameof(section));
            }
            if (!hasEntries || table.SchemaVersion != 1 || string.IsNullOrWhiteSpace(table.ConfigVersion))
                throw new ArgumentException("Invalid " + section + ".txt: expected SchemaVersion 1, ConfigVersion and " + section + " entries.");
            return table;
        }

        static void AssignTable(HeroCatalogData data, HeroConfigSection section, HeroConfigTable table)
        {
            switch (section)
            {
                case HeroConfigSection.Stats: data.Stats = ((StatsConfigData)table).Stats; break;
                case HeroConfigSection.Items: data.Items = ((ItemsConfigData)table).Items; break;
                case HeroConfigSection.Skills: data.Skills = ((SkillsConfigData)table).Skills; data.SkillProgression = ((SkillsConfigData)table).SkillProgression ?? new SkillProgressionDefinition(); break;
                case HeroConfigSection.Heroes: data.Heroes = ((HeroesConfigData)table).Heroes; break;
                case HeroConfigSection.Monsters: data.Monsters = ((MonstersConfigData)table).Monsters; break;
                case HeroConfigSection.Buffs: data.Buffs = ((BuffsConfigData)table).Buffs; break;
                case HeroConfigSection.CraftRecipes: data.CraftRecipes = ((CraftRecipesConfigData)table).CraftRecipes; break;
                case HeroConfigSection.StarRules: data.StarRules = ((StarRulesConfigData)table).StarRules; data.MaxHeroStars=((StarRulesConfigData)table).MaxHeroStars; break;
                default: throw new ArgumentOutOfRangeException(nameof(section));
            }
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
