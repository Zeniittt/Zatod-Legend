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
    static void Click(HeroBalanceWindow window, string name)
    {
        var button = window.rootVisualElement.Q<Button>(name);
        Check(button != null, "Missing UI button: " + name);
        using (var evt = NavigationSubmitEvent.GetPooled()) { evt.target = button; button.SendEvent(evt); }
    }
    static string Status(HeroBalanceWindow window) { return window.rootVisualElement.Q<Label>("config-status").text; }

    public static object Run()
    {
        checks = 0;
        if (!File.Exists(HeroDataJson.CatalogAssetPath)) HeroBalanceWindow.CreateSampleFile();
        string original = File.ReadAllText(HeroDataJson.CatalogAssetPath);
        var catalog = HeroDataJson.LoadBundledCatalog();
        Check(catalog.Data.Heroes.Count > 0, "Bundled TextAsset config not loaded");
        Check(HeroDataJson.WriteCatalog(catalog.Data) == HeroDataJson.WriteCatalog(HeroDataJson.ReadCatalog(original).Data), "Resource JSON differs from source");
        var character = new CharacterData { CharacterId = "unity-json-test", Name = "Test", Revision = 3 };
        character.Currencies.Add(new Currency { Id = "gold", Amount = 3000000000L });
        var hero = catalog.CreateHero("training_warrior", "hero-1"); character.HeroDesk.Add(hero);
        foreach (var slot in HeroProgression.CurrentRank(hero, catalog).EquipmentSlots) HeroProgression.Equip(hero, catalog, slot.Id, slot.RequiredItemId);
        HeroProgression.Promote(hero, catalog);
        hero.Skills[0].Level = 3;
        string saved = HeroDataJson.WriteCharacter(character, catalog);
        Check(!saved.Contains("\"Definition\"") && !saved.Contains("\"BaseStats\"") && !saved.Contains("\"Stats\""), "Player save leaked config/computed stats");
        var loaded = HeroDataJson.ReadCharacter(saved, catalog);
        Check(loaded.HeroDesk is System.Collections.Generic.List<HeroData> && loaded.HeroDesk.Count == 1, "HeroDesk is not List<HeroData>");
        Check(loaded.HeroDesk[0].AbsorbedItems.Count == 6 && loaded.HeroDesk[0].Skills[0].Level == 3, "Unity roundtrip lost hero progression");
        Check(loaded.Currencies[0].Amount == 3000000000L && loaded.Revision == 3, "64-bit declared fields lost precision");
        Check(ReferenceEquals(loaded.HeroDesk[0].Definition, catalog.Hero("training_warrior")), "Load did not resolve definition");
        Check(HeroStatCalculator.Calculate(loaded.HeroDesk[0], catalog).Get("attack") == 35, "Unity roundtrip changed calculated attack");
        Check(saved == HeroDataJson.WriteCharacter(loaded, catalog), "Player JSON changed on roundtrip");
        var data = HeroDataJson.ReadCatalog(original).Data;
        data.ConfigVersion = "unity-json-rebalance-test";
        data.Items.Single(i => i.Id == "axe_basic").Stats[0].Value = 10;
        data.Heroes[0].BaseStats.Single(s => s.StatId == "attack").Value = 3;
        var balanced = new HeroCatalog(data);
        Check(HeroStatCalculator.Calculate(HeroDataJson.ReadCharacter(saved, balanced).HeroDesk[0], balanced).Get("attack") == 63, "Saved IDs did not use rebalanced config");
        bool rejected = false;
        try { HeroDataJson.ReadCharacter(saved.Replace("\"SchemaVersion\": 1", "\"SchemaVersion\": 999"), catalog); }
        catch (ArgumentException) { rejected = true; }
        Check(rejected, "Unknown save schema accepted");
        rejected = false;
        try { HeroDataJson.ReadCatalog("{broken"); } catch (ArgumentException) { rejected = true; }
        Check(rejected, "Malformed JSON accepted");
        string path = Path.GetFullPath(Path.Combine(Application.dataPath, "../../Artifacts/HeroDataChecks/character.json"));
        HeroDataJson.WriteFileAtomically(path, saved);
        HeroDataJson.WriteFileAtomically(path, saved);
        Check(HeroDataJson.WriteCharacter(HeroDataJson.ReadCharacter(File.ReadAllText(path), catalog), catalog) == saved, "Disk save/load changed hero data");
        Check(Directory.GetFiles(Path.GetDirectoryName(path), "*.tmp").Length == 0, "Temporary write files leaked");

        var window = ScriptableObject.CreateInstance<HeroBalanceWindow>();
        try
        {
            window.titleContent = new GUIContent("Hero Balance QA");
            window.position = new Rect(120, 70, 1120, 760);
            window.Show(); window.CreateGUI();
            var root = window.rootVisualElement;
            Check(root.Q<Label>("stat-attack").text == "Attack: 5", "Preview initial stats missing");
            Check(root.Q<Label>("preview-skills").text == "Unlocked skills: 1", "Preview initial unlocks");
            Click(window, "promote-preview");
            Check(Status(window).StartsWith("ERROR"), "Preview promoted without equipment");
            Click(window, "fill-preview");
            Check(root.Q<Label>("stat-attack").text == "Attack: 35", "Fill button did not equip 6 axes");
            Click(window, "promote-preview");
            Check(root.Q<Label>("preview-rank").text.Contains("Xanh Lá"), "Promote button did not update rank");
            Check(root.Q<Label>("stat-attack").text == "Attack: 35" && root.Q<Label>("preview-skills").text.EndsWith("2"), "Promotion preview stats/unlocks");
            Click(window, "roundtrip-preview");
            Check(Status(window).StartsWith("Preview save/load passed"), "Preview save/load button failed: " + Status(window));
            var changed = HeroDataJson.ReadCatalog(original).Data;
            changed.Items.Single(i => i.Id == "axe_basic").Stats[0].Value = 10;
            changed.Heroes[0].BaseStats.Single(s => s.StatId == "attack").Value = 3;
            root.Q<TextField>("catalog-json-input").value = HeroDataJson.WriteCatalog(changed);
            Click(window, "apply-json");
            Check(window.hasUnsavedChanges && root.Q<Label>("stat-attack").text == "Attack: 63", "Draft balance not reflected in existing HeroDesk");
            Check(File.ReadAllText(HeroDataJson.CatalogAssetPath) == original, "Draft edit wrote config prematurely");
            Click(window, "save-config");
            Check(Status(window).Contains("ConfigVersion") && File.ReadAllText(HeroDataJson.CatalogAssetPath) == original, "Same config version update not rejected");
            // Exercise structured field callbacks, not just raw JSON import.
            root.Q<TextField>("field-ConfigVersion").value = "heroes-editor-save-test";
            Click(window, "save-config");
            Check(Status(window).StartsWith("SAVED") && !window.hasUnsavedChanges, "Config save failed: " + Status(window));
            Check(HeroDataJson.LoadBundledCatalog().Data.ConfigVersion == "heroes-editor-save-test", "Saved config not imported as TextAsset");
            HeroDataJson.WriteFileAtomically(HeroDataJson.CatalogAssetPath, original + "\n");
            Click(window, "save-config");
            Check(Status(window).Contains("changed on disk"), "External file changes silently overwritten");
        }
        finally
        {
            HeroDataJson.WriteFileAtomically(HeroDataJson.CatalogAssetPath, original);
            AssetDatabase.ImportAsset(HeroDataJson.CatalogAssetPath, ImportAssetOptions.ForceUpdate);
            window.DiscardChanges(); window.Close();
        }
        HeroBalanceWindow.Open();
        var visible = EditorWindow.GetWindow<HeroBalanceWindow>();
        visible.position = new Rect(100, 70, 1120, 760);
        return new { status = "PASS", checks, save = path, config = HeroDataJson.CatalogAssetPath };
    }
}
