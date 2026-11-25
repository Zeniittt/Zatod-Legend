using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;

namespace Zatod.Editor
{
    public sealed partial class GameEditorWindow
    {
        [SerializeField] bool mapsTab;
        [SerializeField] int mapSelection;
        [SerializeField] WorldConfigDocuments worldDocuments;

        [MenuItem("GameEditor/Maps")]
        public static void OpenMaps()
        {
            var window=Resources.FindObjectsOfTypeAll<GameEditorWindow>().FirstOrDefault(w=>!w.monsterWindow);
            if(window==null)window=CreateInstance<GameEditorWindow>();
            window.progressionTab=false;window.mapsTab=true;window.campaignTab=false;window.titleContent=new GUIContent("Zatod GameEditor");window.Show();window.CreateGUI();window.Focus();
        }
        void DrawMaps(VisualElement authoring)
        {
            var page=new ScrollView{name="page-Maps"};page.AddToClassList("tab-page");authoring.Add(page);
            if(worldDocuments==null || worldDocuments.Maps.Count==0){page.Add(new HelpBox("Reload Worlds.txt and its island configs.",HelpBoxMessageType.Error));return;}
            page.Add(new HelpBox("Positions inside each island are LOCAL; Origin X/Y places it in the shared world. Saved changes apply on the next Play in Editor. Rebuild and restart standalone server/client to update their bundled config.",HelpBoxMessageType.Info));
            page.Add(new Label(WorldConfigFileStore.IndexPath){name="world-index-path"});
            var resource=new TextField("Island config resource"){name="new-map-resource",tooltip="Resource path such as Data/WorldMaps/new_island, without .txt"};
            page.Add(resource);
            page.Add(Button("Add island draft","attach-map",()=>Guard(()=>
            {
                WorldConfigFileStore.Attach(worldDocuments,resource.value?.Trim());
                mapSelection=worldDocuments.Maps.Count-1;Edited();BuildUi();
            })));
            var choices=worldDocuments.Maps.Select(m=>m.Draft.Name+" ["+m.Draft.Id+"]").ToList();mapSelection=Mathf.Clamp(mapSelection,0,choices.Count-1);
            var choice=new UnityEngine.UIElements.PopupField<string>("Island",choices,mapSelection){name="map-choice"};
            choice.RegisterValueChangedCallback(e=>{mapSelection=choices.IndexOf(e.newValue);BuildUi();});page.Add(choice);
            var document=worldDocuments.Maps[mapSelection];
            var actions=new VisualElement();actions.AddToClassList("toolbar");
            actions.Add(Button("Select config asset","select-map-asset",()=>{Selection.activeObject=AssetDatabase.LoadAssetAtPath<TextAsset>(document.AssetPath);EditorGUIUtility.PingObject(Selection.activeObject);}));
            actions.Add(Button("Save maps","save-maps",()=>Guard(()=>
            {
                var heroes=Zatod.Heroes.HeroDataJson.ReadDocuments(HeroConfigFileStore.ReadExisting());
                var savedDefinition=JsonUtility.FromJson<Zatod.Heroes.CampaignDefinition>(File.ReadAllText(Zatod.Heroes.CampaignDataJson.AssetPath));
                var campaign=new Zatod.Heroes.CampaignCatalog(savedDefinition,heroes);
                int saved=WorldConfigFileStore.Save(worldDocuments,campaign);UpdateDirtyState();SetStatus("SAVED MAPS / "+saved+" file(s). Next Editor Play; rebuild/restart standalone server and client.");
            })));page.Add(actions);
            page.Add(new Label(document.AssetPath){name="map-config-path"});
            page.Add(new Label((document.Draft.Spawns?.Count??0)+" spawn(s) | "+(document.Draft.Props?.Count??0)+" prop(s) | "+(document.Draft.Interactions?.Count??0)+" interaction(s)"){name="map-summary"});
            var form=new VisualElement{name="map-fields"};page.Add(form);DrawObject(form,document.Draft);
            var raw=new Foldout{text="Raw JSON / "+document.Draft.Id+".txt",value=false};page.Add(raw);
            PopulateOnOpen(raw,()=>
            {
                var input=new TextField{multiline=true,value=JsonUtility.ToJson(document.Draft,true),name="map-json-input"};input.AddToClassList("raw-json");raw.Add(input);
                raw.Add(Button("Apply JSON to map draft","apply-map-json",()=>Guard(()=>{document.Draft=JsonUtility.FromJson<Zatod.World.WorldMapDefinition>(input.value)??throw new ArgumentException("Invalid map JSON.");Edited();BuildUi();})));
            });
        }
        bool HeroDirty=>draftJson!=sourceJson;
        bool CampaignDirty=>JsonUtility.ToJson(campaignDraft)!=JsonUtility.ToJson(JsonUtility.FromJson<Zatod.Heroes.CampaignDefinition>(campaignSourceJson));
        void UpdateDirtyState()=>hasUnsavedChanges=ProgressionDirty || HeroDirty || CampaignDirty || (worldDocuments?.Changed??false);
    }
}
