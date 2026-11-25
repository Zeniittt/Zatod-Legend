using System.IO;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Heroes;
namespace Zatod.Editor
{
    public sealed partial class GameEditorWindow
    {
        [SerializeField] bool progressionTab;
        [SerializeField] string progressionSource,progressionJson;
        ProgressionDefinition progressionDraft;
        bool ProgressionDirty=>progressionDraft!=null && JsonUtility.ToJson(progressionDraft)!=JsonUtility.ToJson(JsonUtility.FromJson<ProgressionDefinition>(progressionSource));
        [MenuItem("GameEditor/Progression")]
        public static void OpenProgression()
        {var w=GetWindow<GameEditorWindow>();w.progressionTab=true;w.mapsTab=w.campaignTab=false;w.titleContent=new GUIContent("GameEditor");w.CreateGUI();w.Show();}
        void LoadProgression(bool force=false)
        {
            if(force||string.IsNullOrEmpty(progressionJson)||!hasUnsavedChanges){progressionSource=File.ReadAllText(ProgressionDataJson.AssetPath);progressionJson=progressionSource;}
            progressionDraft=JsonUtility.FromJson<ProgressionDefinition>(progressionJson);
        }
        void DrawProgression(VisualElement parent)
        {
            var page=new ScrollView{name="page-Progression"};page.AddToClassList("tab-page");parent.Add(page);
            page.Add(new Label(ProgressionDataJson.AssetPath));
            page.Add(new HelpBox("Shared level curves. Current player/Hero progress belongs to Owned, not config. Changes apply to future loads; rebuild/restart standalone server and client.",HelpBoxMessageType.Info));
            DrawObject(page,progressionDraft);
            page.Add(Button("Validate progression","validate-progression",()=>Guard(()=>{new ProgressionCatalog(progressionDraft);SetStatus("VALID progression");})));
        }
    }
}
