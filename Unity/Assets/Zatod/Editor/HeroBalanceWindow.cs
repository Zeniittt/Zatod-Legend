using System;
using System.Collections;
using System.IO;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEditor.UIElements;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Heroes;

namespace Zatod.Editor
{
    public sealed class HeroBalanceWindow : EditorWindow
    {
        [SerializeField] string draftJson, sourceJson, previewJson;
        HeroCatalogData draft;
        CharacterData preview;
        Label status;
        VisualElement previewBody;
        TextField jsonInput;
        const string StylePath = "Assets/Zatod/Editor/HeroBalanceWindow.uss";

        [MenuItem("Zatod/Heroes/Hero Balance")]
        public static void Open() { GetWindow<HeroBalanceWindow>("Hero Balance"); }

        public void CreateGUI()
        {
            minSize = new Vector2(920, 600);
            saveChangesMessage = "Hero config has unsaved changes. Save the JSON balance file?";
            if (string.IsNullOrEmpty(draftJson) && File.Exists(HeroDataJson.CatalogAssetPath))
                sourceJson = draftJson = File.ReadAllText(HeroDataJson.CatalogAssetPath);
            if (!string.IsNullOrEmpty(draftJson))
            {
                try { draft = JsonUtility.FromJson<HeroCatalogData>(draftJson); }
                catch { draft = null; }
            }
            BuildUi();
        }

        void BuildUi()
        {
            rootVisualElement.Clear();
            var style = AssetDatabase.LoadAssetAtPath<StyleSheet>(StylePath);
            if (style != null && !rootVisualElement.styleSheets.Contains(style)) rootVisualElement.styleSheets.Add(style);
            rootVisualElement.AddToClassList("hero-balance");
            rootVisualElement.Add(new Label("HERO BALANCE / JSON") { name = "hero-title" });
            rootVisualElement.Add(new Label(HeroDataJson.CatalogAssetPath));
            var toolbar = new VisualElement(); toolbar.AddToClassList("toolbar");
            toolbar.Add(Button("Reload file", "reload-config", () =>
            {
                if (hasUnsavedChanges && !EditorUtility.DisplayDialog("Reload hero config", "Discard unsaved config edits?", "Reload", "Cancel")) return;
                ReloadFromFile();
            }));
            toolbar.Add(Button("Validate", "validate-config", () => Guard(() =>
            {
                _ = new HeroCatalog(draft);
                SetStatus("VALID / " + draft.ConfigVersion);
            })));
            toolbar.Add(Button("Save config", "save-config", SaveConfig));
            if (!File.Exists(HeroDataJson.CatalogAssetPath)) toolbar.Add(Button("Create test config", "create-sample", () => Guard(() => { CreateSampleFile(); ReloadFromFile(); })));
            rootVisualElement.Add(toolbar);
            status = new Label("Draft changes affect preview only. Save with a new ConfigVersion to apply to future loads.");
            status.name = "config-status"; status.AddToClassList("wrapped"); rootVisualElement.Add(status);

            var columns = new VisualElement(); columns.AddToClassList("columns"); rootVisualElement.Add(columns);
            var authoring = new ScrollView(); authoring.AddToClassList("authoring"); columns.Add(authoring);
            if (draft != null) DrawObject(authoring, draft);
            var raw = new Foldout { text = "Raw JSON / import draft", value = false };
            jsonInput = new TextField { name = "catalog-json-input", multiline = true, value = draftJson ?? "" };
            jsonInput.AddToClassList("raw-json"); raw.Add(jsonInput);
            raw.Add(Button("Apply JSON to draft", "apply-json", () => Guard(() =>
            {
                var parsed = JsonUtility.FromJson<HeroCatalogData>(jsonInput.value);
                if (parsed == null) throw new ArgumentException("Expected catalog JSON.");
                draft = parsed; Edited(); BuildUi();
            })));
            authoring.Add(raw);

            var sandbox = new ScrollView(); sandbox.AddToClassList("sandbox"); columns.Add(sandbox);
            sandbox.Add(new Label("HERODESK PREVIEW"));
            sandbox.Add(new Label("Sandbox only. Skills are config/unlock previews; no effect execution or inventory consumption.") { name = "sandbox-note" });
            sandbox.Q<Label>("sandbox-note").AddToClassList("wrapped");
            if (draft != null && draft.Heroes != null && draft.Heroes.Count > 0)
            {
                var ids = draft.Heroes.Where(h => h != null && !string.IsNullOrEmpty(h.Id)).Select(h => h.Id).Distinct().ToList();
                if (ids.Count > 0)
                {
                    string selected = ids[0];
                    if (!string.IsNullOrEmpty(previewJson))
                    {
                        try { selected = JsonUtility.FromJson<CharacterData>(previewJson).HeroDesk[0].HeroDefinitionId; }
                        catch { selected = ids[0]; }
                    }
                    if (!ids.Contains(selected)) selected = ids[0];
                    var heroChoice = new PopupField<string>("Hero", ids, selected) { name = "preview-hero" };
                    heroChoice.RegisterValueChangedCallback(e => Guard(() => ResetPreview(e.newValue)));
                    sandbox.Add(heroChoice);
                    var actions = new VisualElement(); actions.AddToClassList("toolbar");
                    actions.Add(Button("New hero", "new-preview", () => Guard(() => ResetPreview(heroChoice.value))));
                    actions.Add(Button("Fill current gear", "fill-preview", () => PreviewAction((hero, catalog) =>
                    {
                        foreach (var slot in HeroProgression.CurrentRank(hero, catalog).EquipmentSlots)
                            if (!hero.EquippedItems.Any(i => i.SlotId == slot.Id)) HeroProgression.Equip(hero, catalog, slot.Id, slot.RequiredItemId);
                    })));
                    actions.Add(Button("Promote", "promote-preview", () => PreviewAction(HeroProgression.Promote)));
                    sandbox.Add(actions);
                    sandbox.Add(Button("Save + reload preview HeroDesk", "roundtrip-preview", () => Guard(() =>
                    {
                        var catalog = new HeroCatalog(draft);
                        var loaded = HeroDataJson.ReadCharacter(previewJson, catalog);
                        string path = Path.GetFullPath(Path.Combine(Application.dataPath, "../../Artifacts/HeroDeskPreview.json"));
                        HeroDataJson.WriteFileAtomically(path, HeroDataJson.WriteCharacter(loaded, catalog));
                        preview = HeroDataJson.ReadCharacter(File.ReadAllText(path), catalog);
                        previewJson = HeroDataJson.WriteCharacter(preview, catalog);
                        RefreshPreview(); SetStatus("Preview save/load passed: " + path);
                    })));
                }
            }
            previewBody = new VisualElement(); previewBody.name = "preview-body"; sandbox.Add(previewBody);
            RefreshPreview();
        }

        void DrawObject(VisualElement parent, object target)
        {
            foreach (var field in target.GetType().GetFields(BindingFlags.Public | BindingFlags.Instance))
            {
                if (Attribute.IsDefined(field, typeof(NonSerializedAttribute))) continue;
                Type type = field.FieldType;
                object value = field.GetValue(target);
                string label = ObjectNames.NicifyVariableName(field.Name);
                if (type == typeof(string))
                {
                    var input = new TextField(label) { value = (string)value ?? "" }; input.isDelayed = true;
                    input.name = "field-" + field.Name;
                    input.RegisterValueChangedCallback(e => { field.SetValue(target, e.newValue); Edited(); }); parent.Add(input);
                }
                else if (type == typeof(int))
                {
                    var input = new IntegerField(label) { value = (int)value, isDelayed = true };
                    input.RegisterValueChangedCallback(e => { field.SetValue(target, e.newValue); Edited(); }); parent.Add(input);
                }
                else if (type == typeof(bool))
                {
                    var input = new Toggle(label) { value = (bool)value };
                    input.RegisterValueChangedCallback(e => { field.SetValue(target, e.newValue); Edited(); }); parent.Add(input);
                }
                else if (type.IsEnum)
                {
                    var input = new EnumField(label, (Enum)value);
                    input.RegisterValueChangedCallback(e => { field.SetValue(target, e.newValue); Edited(); }); parent.Add(input);
                }
                else if (typeof(IList).IsAssignableFrom(type))
                {
                    var list = (IList)value;
                    if (list == null) { list = (IList)Activator.CreateInstance(type); field.SetValue(target, list); }
                    DrawList(parent, label, list, type.GetGenericArguments()[0]);
                }
            }
        }

        void DrawList(VisualElement parent, string label, IList list, Type elementType)
        {
            var foldout = new Foldout { text = label + " (" + list.Count + ")", value = false }; parent.Add(foldout);
            for (int i = 0; i < list.Count; i++)
            {
                int index = i;
                var entry = new Foldout { text = "[" + i + "] " + EntryName(list[i]), value = false }; foldout.Add(entry);
                entry.Add(Button("Remove entry", null, () => { list.RemoveAt(index); Edited(); BuildUi(); }));
                if (elementType == typeof(string))
                {
                    var input = new TextField("ID") { value = (string)list[i] ?? "", isDelayed = true };
                    input.RegisterValueChangedCallback(e => { list[index] = e.newValue; Edited(); }); entry.Add(input);
                }
                else if (list[i] != null) DrawObject(entry, list[i]);
                else entry.Add(new Label("Null entry: remove and add a replacement."));
            }
            foldout.Add(Button("Add entry", null, () =>
            {
                list.Add(elementType == typeof(string) ? "" : Activator.CreateInstance(elementType));
                Edited(); BuildUi();
            }));
        }

        static string EntryName(object entry)
        {
            if (entry == null) return "null";
            if (entry is string text) return text;
            foreach (string name in new[] { "Id", "StatId", "Kind" })
            {
                var field = entry.GetType().GetField(name);
                if (field != null) return Convert.ToString(field.GetValue(entry));
            }
            return entry.GetType().Name;
        }

        void Edited()
        {
            draftJson = JsonUtility.ToJson(draft, true);
            hasUnsavedChanges = draftJson != sourceJson;
            if (jsonInput != null) jsonInput.SetValueWithoutNotify(draftJson);
            RefreshPreview();
            SetStatus("DRAFT / Preview uses the current edits. Validate and change ConfigVersion before saving a balance update.");
        }

        void ResetPreview(string definitionId)
        {
            var catalog = new HeroCatalog(draft);
            preview = new CharacterData { CharacterId = "editor-sandbox", Name = "Preview" };
            preview.HeroDesk.Add(catalog.CreateHero(definitionId, "preview-hero-1"));
            previewJson = HeroDataJson.WriteCharacter(preview, catalog);
            RefreshPreview();
        }

        void PreviewAction(Action<HeroData, HeroCatalog> action)
        {
            Guard(() =>
            {
                var catalog = new HeroCatalog(draft);
                var character = HeroDataJson.ReadCharacter(previewJson, catalog);
                action(character.HeroDesk[0], catalog);
                previewJson = HeroDataJson.WriteCharacter(character, catalog);
                RefreshPreview();
                SetStatus("PREVIEW UPDATED / Sandbox progression only.");
            });
        }

        void RefreshPreview()
        {
            if (previewBody == null) return;
            previewBody.Clear();
            try
            {
                var catalog = new HeroCatalog(draft);
                if (string.IsNullOrEmpty(previewJson))
                {
                    preview = new CharacterData { CharacterId = "editor-sandbox", Name = "Preview" };
                    preview.HeroDesk.Add(catalog.CreateHero(draft.Heroes[0].Id, "preview-hero-1"));
                    previewJson = HeroDataJson.WriteCharacter(preview, catalog);
                }
                preview = HeroDataJson.ReadCharacter(previewJson, catalog);
                var hero = preview.HeroDesk[0];
                var rank = HeroProgression.CurrentRank(hero, catalog);
                previewBody.Add(new Label(hero.Definition.Name + " / " + rank.Name) { name = "preview-rank" });
                previewBody.Add(new Label("Gear: " + hero.EquippedItems.Count + "/" + rank.EquipmentSlots.Count
                    + "  |  Absorbed: " + hero.AbsorbedItems.Sum(i => i.Quantity)
                    + "  |  Can promote: " + HeroProgression.CanPromote(hero, catalog)));
                var result = HeroStatCalculator.Calculate(hero, catalog);
                foreach (var stat in result.Stats)
                    previewBody.Add(new Label(catalog.Stat(stat.StatId).Name + ": " + stat.Value) { name = "stat-" + stat.StatId });
                var unlocked = HeroProgression.UnlockedSkills(hero, catalog);
                previewBody.Add(new Label("Unlocked skills: " + unlocked.Count) { name = "preview-skills" });
                foreach (var slot in unlocked)
                    previewBody.Add(new Label(slot.Id + " / " + catalog.Skill(slot.SkillId).Name));
                var breakdown = new Foldout { text = "Stat breakdown", value = false };
                foreach (var item in result.Breakdown) breakdown.Add(new Label(item.Source + " / " + item.StatId + ": " + item.Value));
                previewBody.Add(breakdown);
                var progress = new Foldout { text = "Saved HeroDesk JSON (no computed stats/config)", value = false };
                var text = new TextField { multiline = true, isReadOnly = true, value = previewJson }; text.AddToClassList("raw-json"); progress.Add(text); previewBody.Add(progress);
            }
            catch (Exception error)
            {
                previewBody.Add(new HelpBox(error.Message, HelpBoxMessageType.Error));
            }
        }

        public void SaveConfig()
        {
            Guard(() =>
            {
                string json = HeroDataJson.WriteCatalog(draft);
                string current = File.Exists(HeroDataJson.CatalogAssetPath) ? File.ReadAllText(HeroDataJson.CatalogAssetPath) : null;
                if (current != sourceJson) throw new IOException("Config changed on disk. Reload before saving; this draft has not overwritten it.");
                if (!string.IsNullOrEmpty(sourceJson) && json != HeroDataJson.WriteCatalog(JsonUtility.FromJson<HeroCatalogData>(sourceJson))
                    && draft.ConfigVersion == JsonUtility.FromJson<HeroCatalogData>(sourceJson).ConfigVersion)
                    throw new ArgumentException("Change ConfigVersion before saving a balance update.");
                HeroDataJson.WriteFileAtomically(HeroDataJson.CatalogAssetPath, json);
                AssetDatabase.ImportAsset(HeroDataJson.CatalogAssetPath, ImportAssetOptions.ForceUpdate);
                sourceJson = draftJson = json; hasUnsavedChanges = false;
                SetStatus("SAVED / " + draft.ConfigVersion);
            });
        }

        public override void SaveChanges()
        {
            SaveConfig();
            if (!hasUnsavedChanges) base.SaveChanges();
        }

        public override void DiscardChanges()
        {
            draftJson = sourceJson; base.DiscardChanges();
        }

        void ReloadFromFile()
        {
            Guard(() =>
            {
                string json = File.ReadAllText(HeroDataJson.CatalogAssetPath);
                draft = HeroDataJson.ReadCatalog(json).Data;
                sourceJson = draftJson = json; hasUnsavedChanges = false;
                BuildUi(); SetStatus("LOADED / " + draft.ConfigVersion);
            });
        }

        public static void CreateSampleFile()
        {
            if (File.Exists(HeroDataJson.CatalogAssetPath)) throw new IOException("Hero config already exists; sample creation will not overwrite it.");
            HeroDataJson.WriteFileAtomically(HeroDataJson.CatalogAssetPath, HeroDataJson.WriteCatalog(HeroCatalogSample.Create()));
            AssetDatabase.ImportAsset(HeroDataJson.CatalogAssetPath, ImportAssetOptions.ForceUpdate);
        }

        void Guard(Action action)
        {
            try { action(); }
            catch (Exception error) { SetStatus("ERROR / " + error.Message); }
        }

        void SetStatus(string message) { if (status != null) status.text = message; }
        static Button Button(string text, string name, Action action) { return new Button(action) { text = text, name = name }; }
    }
}
