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
    public sealed partial class GameEditorWindow : EditorWindow
    {
        [SerializeField] string draftJson, sourceJson, previewJson;
        [SerializeField] HeroConfigDocuments sourceDocuments;
        [SerializeField] HeroConfigSection activeTab;
        [SerializeField] bool monsterWindow, campaignTab;
        [SerializeField] string campaignJson, campaignSourceJson;
        CampaignDefinition campaignDraft;
        HeroCatalogData draft;
        CharacterData preview;
        Label status;
        VisualElement previewBody;
        TextField jsonInput;
        const string StylePath = "Assets/Zatod/Editor/GameEditorWindow.uss";

        [MenuItem("GameEditor/Open")]
        [MenuItem("Zatod/GameEditor")]
        public static void Open() { GetWindow<GameEditorWindow>("Zatod GameEditor"); }

        
        public static void OpenMonsters()
        {
            var window=Resources.FindObjectsOfTypeAll<GameEditorWindow>().FirstOrDefault(w=>w.monsterWindow);
            if(window==null)window=CreateInstance<GameEditorWindow>();
            window.monsterWindow=true;window.activeTab=HeroConfigSection.Monsters;
            window.titleContent=new GUIContent("Zatod GameEditor");window.Show();window.CreateGUI();
        }

        [MenuItem("GameEditor/Craft Recipes")]
        public static void OpenCraftRecipes()
        {
            var window=GetWindow<GameEditorWindow>();window.titleContent=new GUIContent("GameEditor");window.campaignTab=false;window.mapsTab=false;window.activeTab=HeroConfigSection.CraftRecipes;window.CreateGUI();window.Show();
        }
        public void CreateGUI()
        {
            minSize = new Vector2(920, 600);
            saveChangesMessage = "Game config has unsaved changes. Save the edited config files?";
            string loadError = null;
            if ((sourceDocuments == null || !hasUnsavedChanges) && HeroConfigFileStore.AnyFileExists)
            {
                try
                {
                    sourceDocuments = HeroConfigFileStore.Read();
                    sourceJson = HeroDataJson.WriteCatalog(HeroDataJson.ReadDocuments(sourceDocuments).Data);
                    if (!hasUnsavedChanges || string.IsNullOrEmpty(draftJson)) draftJson = sourceJson;
                }
                catch (Exception error) { loadError = error.Message; }
            }
            if (!string.IsNullOrEmpty(draftJson))
            {
                try { draft = JsonUtility.FromJson<HeroCatalogData>(draftJson); }
                catch { draft = null; }
            }
            if(string.IsNullOrEmpty(campaignJson) || !hasUnsavedChanges){campaignSourceJson=File.ReadAllText(CampaignDataJson.AssetPath);campaignJson=campaignSourceJson;}
            campaignDraft=JsonUtility.FromJson<CampaignDefinition>(campaignJson);
            try{if(worldDocuments==null || !hasUnsavedChanges)worldDocuments=WorldConfigFileStore.Read();}catch(Exception error){loadError=error.Message;}
            BuildUi();
            if (loadError != null) SetStatus("ERROR / " + loadError);
        }

        void BuildUi()
        {
            rootVisualElement.Clear();
            var style = AssetDatabase.LoadAssetAtPath<StyleSheet>(StylePath);
            if (style != null && !rootVisualElement.styleSheets.Contains(style)) rootVisualElement.styleSheets.Add(style);
            rootVisualElement.AddToClassList("hero-balance");
            rootVisualElement.Add(new Label("ZATOD GAME EDITOR") { name = "hero-title" });
            rootVisualElement.Add(new Label(HeroDataJson.ConfigAssetDirectory + "/{Heroes, Monsters, Items, Stats, Skills, Buffs, Campaigns, Worlds}.txt + WorldMaps/*.txt") { name = "config-source-paths" });
            var toolbar = new VisualElement(); toolbar.AddToClassList("toolbar");
            toolbar.Add(Button("Reload files", "reload-config", () =>
            {
                if (hasUnsavedChanges && !EditorUtility.DisplayDialog("Reload game config", "Discard unsaved config edits?", "Reload", "Cancel")) return;
                ReloadFromFile();
            }));
            toolbar.Add(Button("Validate", "validate-config", () => Guard(() =>
            {
                var catalog=new HeroCatalog(draft);var campaign=new CampaignCatalog(campaignDraft,catalog);WorldConfigFileStore.Validate(worldDocuments,campaign);
                SetStatus("VALID / " + draft.ConfigVersion);
            })));
            toolbar.Add(Button("Save all config", "save-config", SaveConfig));
            if (!HeroConfigFileStore.AnyFileExists) toolbar.Add(Button("Create test config", "create-sample", () => Guard(() => { CreateSampleFiles(); ReloadFromFile(); })));
            rootVisualElement.Add(toolbar);
            status = new Label("Draft changes affect preview only. Save with a new ConfigVersion to apply to future loads.");
            status.name = "config-status"; status.AddToClassList("wrapped"); rootVisualElement.Add(status);

            var columns = new VisualElement(); columns.AddToClassList("columns"); rootVisualElement.Add(columns);
            var authoring = new VisualElement(); authoring.AddToClassList("authoring"); columns.Add(authoring);
            if(mapsTab && worldDocuments!=null)DrawObject(authoring,worldDocuments.Index,"SchemaVersion","ConfigVersion");
            else if(draft!=null)DrawObject(authoring,draft,"SchemaVersion","ConfigVersion");
            var tabs = new VisualElement { name = "config-tabs" }; tabs.AddToClassList("config-tabs"); authoring.Add(tabs);
            foreach (var section in HeroDataJson.Sections)
            {
                var selectedSection = section;
                var tab = Button(section.ToString(), "tab-" + section, () =>
                {
                    campaignTab=false;mapsTab=false;activeTab = selectedSection;
                    BuildUi();
                });
                tab.AddToClassList("config-tab");
                if (section == activeTab && !campaignTab && !mapsTab) tab.AddToClassList("config-tab-active");
                tabs.Add(tab);
            }
            var campaignButton=Button("Campaign", "tab-Campaign",()=>{mapsTab=false;campaignTab=true;BuildUi();});campaignButton.AddToClassList("config-tab");if(campaignTab && !mapsTab)campaignButton.AddToClassList("config-tab-active");tabs.Add(campaignButton);
            var mapsButton=Button("Maps","tab-Maps",()=>{mapsTab=true;campaignTab=false;BuildUi();});mapsButton.AddToClassList("config-tab");if(mapsTab)mapsButton.AddToClassList("config-tab-active");tabs.Add(mapsButton);
            if(mapsTab){DrawMaps(authoring);return;}
            if(campaignTab){var campaignPage=new ScrollView{name="page-Campaign"};campaignPage.AddToClassList("tab-page");authoring.Add(campaignPage);campaignPage.Add(new Label(CampaignDataJson.AssetPath));DrawObject(campaignPage,campaignDraft);return;}
            var page = new ScrollView { name = "page-" + activeTab }; page.AddToClassList("tab-page"); authoring.Add(page);
            page.Add(new Label(HeroDataJson.AssetPath(activeTab)) { name = "section-path" });
            if (draft != null)
            {
                var field = typeof(HeroCatalogData).GetField(activeTab.ToString());
                var list = (IList)field.GetValue(draft);
                if (list == null) { list = (IList)Activator.CreateInstance(field.FieldType); field.SetValue(draft, list); }
                DrawList(page, activeTab.ToString(), list, field.FieldType.GetGenericArguments()[0], true);
            }
            var raw = new Foldout { text = "Raw JSON / " + activeTab + ".txt", value = false };
            jsonInput=null;
            PopulateOnOpen(raw,()=>
            {
            jsonInput = new TextField { name = "section-json-input", multiline = true, value = draft == null ? "" : HeroDataJson.WriteSection(draft, activeTab) };
            jsonInput.AddToClassList("raw-json"); raw.Add(jsonInput);
            raw.Add(Button("Apply this table to draft", "apply-section-json", () => Guard(() =>
            {
                HeroDataJson.ApplySection(draft, activeTab, jsonInput.value);
                Edited(); BuildUi();
            })));
            });
            page.Add(raw);

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

        void DrawObject(VisualElement parent, object target, params string[] fields)
        {
            foreach (var field in target.GetType().GetFields(BindingFlags.Public | BindingFlags.Instance))
            {
                if (Attribute.IsDefined(field, typeof(NonSerializedAttribute))) continue;
                if (fields.Length > 0 && !fields.Contains(field.Name)) continue;
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
                    var input = new IntegerField(label) { value = (int)value, isDelayed = true }; input.name="field-"+field.Name;
                    input.RegisterValueChangedCallback(e => { field.SetValue(target, e.newValue); Edited(); }); parent.Add(input);
                }
                else if (type == typeof(long))
                {
                    var input = new LongField(label) { value = (long)value, isDelayed = true }; input.name="field-"+field.Name;
                    input.RegisterValueChangedCallback(e => { field.SetValue(target, e.newValue); Edited(); }); parent.Add(input);
                }
                else if (type == typeof(double))
                {
                    var input = new DoubleField(label) { value = (double)value, isDelayed = true }; input.name="field-"+field.Name;
                    input.RegisterValueChangedCallback(e => { field.SetValue(target, e.newValue); Edited(); }); parent.Add(input);
                }
                else if (type == typeof(float))
                {
                    var input = new FloatField(label) { value = (float)value, isDelayed = true }; input.name="field-"+field.Name;
                    input.RegisterValueChangedCallback(e => { field.SetValue(target, e.newValue); Edited(); }); parent.Add(input);
                }
                else if (type == typeof(bool))
                {
                    var input = new Toggle(label) { value = (bool)value }; input.name="field-"+field.Name;
                    input.RegisterValueChangedCallback(e => { field.SetValue(target, e.newValue); Edited(); }); parent.Add(input);
                }
                else if (type.IsEnum)
                {
                    var input = new EnumField(label, (Enum)value); input.name="field-"+field.Name;
                    input.RegisterValueChangedCallback(e => { field.SetValue(target, e.newValue); Edited(); }); parent.Add(input);
                }
                else if (typeof(IList).IsAssignableFrom(type))
                {
                    var list = (IList)value;
                    if (list == null) { list = (IList)Activator.CreateInstance(type); field.SetValue(target, list); }
                    DrawList(parent, label, list, type.GetGenericArguments()[0]);
                }
                else if(type.IsClass && (type.Namespace=="Zatod.Heroes" || type.Namespace=="Zatod.World") && value!=null)
                {
                    var nested = new Foldout { text = label, value = false };
                    parent.Add(nested);PopulateOnOpen(nested,()=>DrawObject(nested,value));
                }
            }
        }

        static void PopulateOnOpen(Foldout foldout,Action build)
        {
            bool populated=false;
            void Populate(){if(populated)return;populated=true;build();}
            foldout.RegisterValueChangedCallback(e=>{if(e.target==foldout && e.newValue)Populate();});
            if(foldout.value)Populate();
        }
        void DrawList(VisualElement parent,string label,IList list,Type elementType,bool expanded=false)
        {
            var foldout=new Foldout{text=label+" ("+list.Count+")",value=expanded};parent.Add(foldout);
            PopulateOnOpen(foldout,()=>
            {
                for(int i=0;i<list.Count;i++)
                {
                    int index=i;var entry=new Foldout{text="["+i+"] "+EntryName(list[i]),value=false};foldout.Add(entry);
                    PopulateOnOpen(entry,()=>
                    {
                        entry.Add(Button("Remove entry",null,()=>{list.RemoveAt(index);Edited();BuildUi();}));
                        if(elementType==typeof(string)){var input=new TextField("ID"){value=(string)list[index]??"",isDelayed=true};input.RegisterValueChangedCallback(e=>{list[index]=e.newValue;Edited();});entry.Add(input);}
                        else if(elementType==typeof(double)){var input=new DoubleField("Value"){value=(double)list[index],isDelayed=true};input.RegisterValueChangedCallback(e=>{list[index]=e.newValue;Edited();});entry.Add(input);}
                        else if(list[index]!=null)DrawObject(entry,list[index]);
                        else entry.Add(new Label("Null entry: remove and add a replacement."));
                    });
                }
                foldout.Add(Button("Add entry",null,()=>{list.Add(elementType==typeof(string)?"":Activator.CreateInstance(elementType));Edited();BuildUi();}));
            });
        }

        static string EntryName(object entry)
        {
            if (entry == null) return "null";
            if (entry is string text) return text;
            var nameField=entry.GetType().GetField("Name");var idField=entry.GetType().GetField("ItemId")??entry.GetType().GetField("Id");
            if(nameField!=null && !string.IsNullOrEmpty(nameField.GetValue(entry) as string))return nameField.GetValue(entry)+" ["+idField?.GetValue(entry)+"]";
            foreach (string name in new[] { "ItemId", "Id", "StatId", "Name", "SourceId", "Kind" })
            {
                var field = entry.GetType().GetField(name);
                if (field != null && !string.IsNullOrEmpty(Convert.ToString(field.GetValue(entry)))) return Convert.ToString(field.GetValue(entry));
            }
            return entry.GetType().Name;
        }

        void Edited()
        {
            if(mapsTab){UpdateDirtyState();SetStatus("MAP DRAFT / Validate and save maps. Coordinates remain local to the island.");return;}
            draftJson = JsonUtility.ToJson(draft, true);
            campaignJson=JsonUtility.ToJson(campaignDraft,true);
            UpdateDirtyState();
            if(!campaignTab && !mapsTab && jsonInput!=null) jsonInput.SetValueWithoutNotify(HeroDataJson.WriteSection(draft, activeTab));
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
                var catalog=new HeroCatalog(draft);var campaign=new CampaignCatalog(campaignDraft,catalog);WorldConfigFileStore.Validate(worldDocuments,campaign);
                if(FilesChanged())throw new IOException("Config files changed on disk. Draft preserved; reload before saving.");
                if(HeroDirty)sourceDocuments=HeroConfigFileStore.Save(draft,sourceDocuments??new HeroConfigDocuments());
                string nextCampaign=JsonUtility.ToJson(campaignDraft,true);
                if(CampaignDirty){string backup=Path.GetFullPath("../Artifacts/ZatodConfigBefore/"+DateTime.UtcNow.ToString("yyyyMMdd-HHmmss"));Directory.CreateDirectory(backup);File.WriteAllText(Path.Combine(backup,"Campaigns.txt"),campaignSourceJson);HeroDataJson.WriteFileAtomically(CampaignDataJson.AssetPath,nextCampaign);AssetDatabase.ImportAsset(CampaignDataJson.AssetPath);}
                int mapsSaved=WorldConfigFileStore.Save(worldDocuments,campaign);
                campaignSourceJson=campaignJson=File.ReadAllText(CampaignDataJson.AssetPath);
                sourceJson = draftJson = HeroDataJson.WriteCatalog(draft); UpdateDirtyState();
                SetStatus("SAVED / maps="+mapsSaved+" / "+string.Join(", ",HeroDataJson.Sections.Select(s=>s+".txt"))+" / " + draft.ConfigVersion);
            });
        }

        public override void SaveChanges()
        {
            SaveConfig();
            if (!hasUnsavedChanges) base.SaveChanges();
        }

        public override void DiscardChanges()
        {
            ReloadFromFile();if(!hasUnsavedChanges)base.DiscardChanges();
        }

        void ReloadFromFile()
        {
            Guard(() =>
            {
                var documents = HeroConfigFileStore.Read();
                draft = HeroDataJson.ReadDocuments(documents).Data;
                sourceDocuments = documents;
                sourceJson = draftJson = HeroDataJson.WriteCatalog(draft); hasUnsavedChanges = false;
                campaignSourceJson=campaignJson=File.ReadAllText(CampaignDataJson.AssetPath);campaignDraft=JsonUtility.FromJson<CampaignDefinition>(campaignJson);
                worldDocuments=WorldConfigFileStore.Read();
                BuildUi(); SetStatus("LOADED / " + (mapsTab ? worldDocuments.Index.ConfigVersion : draft.ConfigVersion));
            });
        }

        bool FilesChanged()
        {
            if(sourceDocuments==null)return true;
            var disk=HeroConfigFileStore.ReadExisting();
            return HeroDataJson.Sections.Any(section=>disk.Get(section)!=sourceDocuments.Get(section)) || File.ReadAllText(CampaignDataJson.AssetPath)!=campaignSourceJson || WorldConfigFileStore.FilesChanged(worldDocuments);
        }
        void OnFocus(){if(draft!=null)ReloadIfClean();}
        void OnProjectChange(){if(draft!=null)ReloadIfClean();}
        public void ReloadIfClean()
        {
            if(!FilesChanged())return;
            if(hasUnsavedChanges){SetStatus("FILES CHANGED ON DISK / Draft preserved. Reload or resolve edits before saving.");return;}
            ReloadFromFile();
        }

        public static void CreateSampleFiles()
        {
            if (HeroConfigFileStore.AnyFileExists) throw new IOException("Hero config already exists; sample creation will not overwrite it.");
            HeroConfigFileStore.Save(HeroCatalogSample.Create(), new HeroConfigDocuments());
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
