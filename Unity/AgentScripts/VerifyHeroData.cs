using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Editor;
using Zatod.Heroes;

public static class VerifyHeroData
{
    static int checks;
    static void Check(bool ok, string reason) { checks++; if (!ok) throw new Exception(reason); }
    static void Reject(Action action, string reason)
    {
        bool rejected = false;
        try { action(); } catch (ArgumentException) { rejected = true; }
        Check(rejected, reason);
    }
    static void Click(HeroBalanceWindow window, string name)
    {
        var button = window.rootVisualElement.Q<Button>(name);
        Check(button != null, "Missing UI button: " + name);
        using (var evt = NavigationSubmitEvent.GetPooled()) { evt.target = button; button.SendEvent(evt); }
    }
    static string Status(HeroBalanceWindow window) { return window.rootVisualElement.Q<Label>("config-status").text; }
    static bool Same(HeroConfigDocuments a, HeroConfigDocuments b) { return HeroDataJson.Sections.All(s => a.Get(s) == b.Get(s)); }
    static HeroConfigDocuments Copy(HeroConfigDocuments docs) { return JsonUtility.FromJson<HeroConfigDocuments>(JsonUtility.ToJson(docs)); }
    static void Apply(HeroBalanceWindow window, HeroConfigSection section, string json)
    {
        Click(window, "tab-" + section);
        window.rootVisualElement.Q<TextField>("section-json-input").value = json;
        Click(window, "apply-section-json");
    }

    public static object Run()
    {
        checks = 0;
        var originals = HeroConfigFileStore.Read();
        var catalog = HeroDataJson.LoadBundledCatalog();
        string original = HeroDataJson.WriteCatalog(HeroDataJson.ReadDocuments(originals).Data);
        Check(catalog.Data.Heroes.Count > 0, "Bundled config not loaded");
        Check(HeroDataJson.WriteCatalog(catalog.Data) == original, "Resource JSON differs from source files");
        foreach (var section in HeroDataJson.Sections)
        {
            string json = originals.Get(section);
            Check(File.Exists(HeroDataJson.AssetPath(section)) && json.Contains("\"" + section + "\""), "Missing split table: " + section);
            foreach (var other in HeroDataJson.Sections.Where(s => s != section && s != HeroConfigSection.Stats))
                Check(!json.Contains("\"" + other + "\":"), "Unrelated table in " + section);
        }
        Check(catalog.Data.Stats.Any(s => s.Id == "damage") && catalog.Data.Stats.Any(s => s.Id == "defense")
            && catalog.Data.Stats.All(s => s.Id != "attack" && s.Id != "armor"), "Stat IDs not renamed");
        Check(!original.Contains("AttackScaleBasisPoints") && original.Contains("DamageScaleBasisPoints"), "Skill damage scale name not updated");
        Check(!File.Exists(HeroDataJson.ConfigAssetDirectory + "/HeroCatalog.txt"), "Legacy combined config still exists");
        var mismatched = Copy(originals); mismatched.Items = mismatched.Items.Replace(catalog.Data.ConfigVersion, "mismatched-version");
        Reject(() => HeroDataJson.ReadDocuments(mismatched), "Mixed versions accepted");
        var missing = Copy(originals); missing.Skills = null;
        Reject(() => HeroDataJson.ReadDocuments(missing), "Missing file accepted");
        var bad = HeroDataJson.ReadCatalog(original).Data; bad.Items[0].Stats[0].StatId = "missing_stat";
        Reject(() => HeroDataJson.WriteDocuments(bad), "Dangling stat accepted across files");
        var missingTable = Copy(originals); missingTable.Stats = "{\"SchemaVersion\":1,\"ConfigVersion\":\"test\"}";
        Reject(() => HeroDataJson.ReadDocuments(missingTable), "Missing table treated as empty");
        Check(HeroDataJson.WriteCatalog(HeroDataJson.ReadDocuments(HeroDataJson.WriteDocuments(catalog.Data)).Data) == original, "Split JSON roundtrip changed config");

        var character = new CharacterData { CharacterId = "unity-json-test", Name = "Test", Revision = 3 };
        character.Currencies.Add(new Currency { Id = "gold", Amount = 3000000000L });
        var hero = catalog.CreateHero("training_warrior", "hero-1"); character.HeroDesk.Add(hero);
        foreach (var slot in HeroProgression.CurrentRank(hero, catalog).EquipmentSlots) HeroProgression.Equip(hero, catalog, slot.Id, slot.RequiredItemId);
        HeroProgression.Promote(hero, catalog); hero.Skills[0].Level = 3;
        string saved = HeroDataJson.WriteCharacter(character, catalog);
        Check(!saved.Contains("\"Definition\"") && !saved.Contains("\"BaseStats\"") && !saved.Contains("\"Stats\""), "Save leaked config/computed stats");
        var loaded = HeroDataJson.ReadCharacter(saved, catalog);
        Check(loaded.HeroDesk.Count == 1 && loaded.HeroDesk[0].AbsorbedItems.Count == 6 && loaded.HeroDesk[0].Skills[0].Level == 3, "Roundtrip lost progression");
        Check(loaded.Currencies[0].Amount == 3000000000L && loaded.Revision == 3, "64-bit fields lost precision");
        Check(ReferenceEquals(loaded.HeroDesk[0].Definition, catalog.Hero("training_warrior")), "Definition not resolved");
        Check(HeroStatCalculator.Calculate(loaded.HeroDesk[0], catalog).Get("damage") == 35, "Roundtrip changed damage");
        Check(saved == HeroDataJson.WriteCharacter(loaded, catalog), "Save JSON changed on roundtrip");
        var changed = HeroDataJson.ReadCatalog(original).Data;
        changed.Items.Single(i => i.Id == "axe_basic").Stats[0].Value = 10;
        changed.Heroes[0].BaseStats.Single(s => s.StatId == "damage").Value = 3;
        var balanced = new HeroCatalog(changed);
        Check(HeroStatCalculator.Calculate(HeroDataJson.ReadCharacter(saved, balanced).HeroDesk[0], balanced).Get("damage") == 63, "Saved IDs did not use rebalance");
        Reject(() => HeroDataJson.ReadCharacter(saved.Replace("\"SchemaVersion\": 1", "\"SchemaVersion\": 999"), catalog), "Unknown save schema accepted");
        Reject(() => HeroDataJson.ReadCatalog("{broken"), "Malformed JSON accepted");
        string path = Path.GetFullPath(Path.Combine(Application.dataPath, "../../Artifacts/HeroDataChecks/character.json"));
        HeroDataJson.WriteFileAtomically(path, saved); HeroDataJson.WriteFileAtomically(path, saved);
        Check(HeroDataJson.WriteCharacter(HeroDataJson.ReadCharacter(File.ReadAllText(path), catalog), catalog) == saved, "Disk save/load changed data");
        Check(Directory.GetFiles(Path.GetDirectoryName(path), "*.tmp").Length == 0, "Temporary files leaked");

        var window = ScriptableObject.CreateInstance<HeroBalanceWindow>();
        try
        {
            window.titleContent = new GUIContent("Hero Balance QA"); window.position = new Rect(120, 70, 1120, 760);
            window.Show(); window.CreateGUI(); var root = window.rootVisualElement;
            Check(root.Q<Label>("stat-damage").text == "Damage: 5" && root.Q<Label>("stat-defense").text == "Defense: 10", "Preview labels not renamed");
            Check(root.Q<Label>("preview-skills").text == "Unlocked skills: 1", "Initial unlocks");
            foreach (var section in HeroDataJson.Sections)
            {
                Click(window, "tab-" + section);
                Check(root.Q<ScrollView>("page-" + section) != null && root.Q<Label>("section-path").text.EndsWith(section + ".txt"), "Tab page/path mismatch");
                Check(root.Q<TextField>("section-json-input").value == HeroDataJson.WriteSection(catalog.Data, section), "Tab JSON contains wrong table");
                Check(root.Query<ScrollView>().ToList().Count(v => v.name != null && v.name.StartsWith("page-")) == 1, "Multiple table pages rendered");
            }
            Click(window, "promote-preview"); Check(Status(window).StartsWith("ERROR"), "Promoted without gear");
            Click(window, "fill-preview"); Check(root.Q<Label>("stat-damage").text == "Damage: 35", "Fill did not equip six axes");
            Click(window, "promote-preview");
            Check(root.Q<Label>("preview-rank").text.Contains("Xanh Lá") && root.Q<Label>("stat-damage").text == "Damage: 35", "Promotion preview");
            Check(root.Q<Label>("preview-skills").text.EndsWith("2"), "Promotion unlock");
            Click(window, "roundtrip-preview"); Check(Status(window).StartsWith("Preview save/load passed"), "Preview disk roundtrip failed");
            Apply(window, HeroConfigSection.Items, HeroDataJson.WriteSection(changed, HeroConfigSection.Items));
            Check(window.hasUnsavedChanges && root.Q<Label>("stat-damage").text == "Damage: 65", "Item draft not applied");
            Apply(window, HeroConfigSection.Heroes, HeroDataJson.WriteSection(changed, HeroConfigSection.Heroes));
            Check(root.Q<Label>("stat-damage").text == "Damage: 63", "Hero tab lost item draft");
            Click(window, "tab-Stats");
            Check(window.hasUnsavedChanges && root.Q<Label>("stat-damage").text == "Damage: 63" && root.Q<Label>("preview-rank").text.Contains("Xanh Lá"), "Tab switch lost draft/progression");
            Check(Same(HeroConfigFileStore.Read(), originals), "Draft wrote files prematurely");
            Click(window, "save-config"); Check(Status(window).Contains("ConfigVersion") && Same(HeroConfigFileStore.Read(), originals), "Same-version update accepted");
            root.Q<TextField>("field-ConfigVersion").value = "heroes-editor-split-test"; Click(window, "save-config");
            Check(Status(window).StartsWith("SAVED") && !window.hasUnsavedChanges, "Save failed: " + Status(window));
            var afterSave = HeroConfigFileStore.Read();
            foreach (var section in HeroDataJson.Sections) Check(afterSave.Get(section).Contains("heroes-editor-split-test"), "Mixed version after Save");
            var bundled = HeroDataJson.LoadBundledCatalog();
            Check(HeroStatCalculator.Calculate(HeroDataJson.ReadCharacter(saved, bundled).HeroDesk[0], bundled).Get("damage") == 63, "Bundled split load did not use save");
            HeroDataJson.WriteFileAtomically(HeroDataJson.AssetPath(HeroConfigSection.Items), afterSave.Items + "\n");
            var external = HeroConfigFileStore.ReadExisting(); Click(window, "save-config");
            Check(Status(window).Contains("Items.txt changed on disk") && Same(HeroConfigFileStore.ReadExisting(), external), "Conflict failed to protect all files");
        }
        finally
        {
            foreach (var section in HeroDataJson.Sections) HeroDataJson.WriteFileAtomically(HeroDataJson.AssetPath(section), originals.Get(section));
            HeroConfigFileStore.ImportFiles(); window.DiscardChanges(); window.Close();
        }
        HeroBalanceWindow.Open(); var visible = EditorWindow.GetWindow<HeroBalanceWindow>(); visible.position = new Rect(100, 70, 1120, 760);
        return new { status = "PASS", checks, save = path, config = HeroDataJson.ConfigAssetDirectory };
    }
}
