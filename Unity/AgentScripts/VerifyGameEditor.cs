using System;
using System.IO;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Editor;
using Zatod.Heroes;
GameEditorWindow.Open();var w=Resources.FindObjectsOfTypeAll<GameEditorWindow>().Single();
var flags=BindingFlags.Instance|BindingFlags.NonPublic;int checks=0;
void Check(bool value,string message){checks++;if(!value)throw new Exception(message);}
var draft=(HeroCatalogData)typeof(GameEditorWindow).GetField("draft",flags).GetValue(w);
Check(draft.Heroes.Count==16 && draft.Monsters.Count==10 && draft.Items.Count==67,"GameEditor showed stale content");
foreach(string name in new[]{"Heroes","Monsters","Items","Skills","Stats","Buffs","Campaign"})Check(w.rootVisualElement.Q<Button>("tab-"+name)!=null,"Missing tab "+name);
var source=typeof(GameEditorWindow).GetField("sourceDocuments",flags);
string path=HeroDataJson.AssetPath(HeroConfigSection.Heroes),original=File.ReadAllText(path);
try
{
    File.WriteAllText(path,original+"\n");w.ReloadIfClean();
    Check(((HeroConfigDocuments)source.GetValue(w)).Heroes==original+"\n","Clean editor did not refresh external changes");
    draft=(HeroCatalogData)typeof(GameEditorWindow).GetField("draft",flags).GetValue(w);draft.Heroes[0].Name="Agent draft retention probe";
    typeof(EditorWindow).GetProperty("hasUnsavedChanges").SetValue(w,true);
    File.WriteAllText(path,original+"\n\n");w.ReloadIfClean();
    Check(((HeroCatalogData)typeof(GameEditorWindow).GetField("draft",flags).GetValue(w)).Heroes[0].Name=="Agent draft retention probe","Dirty draft lost on external change");
    bool refused=false;try{HeroConfigFileStore.Save(draft,(HeroConfigDocuments)source.GetValue(w));}catch(IOException){refused=true;}
    Check(refused && File.ReadAllText(path)==original+"\n\n","Stale save was not refused");
}
finally
{
    File.WriteAllText(path,original);typeof(EditorWindow).GetProperty("hasUnsavedChanges").SetValue(w,false);w.ReloadIfClean();
}
typeof(GameEditorWindow).GetField("campaignTab",flags).SetValue(w,true);typeof(GameEditorWindow).GetMethod("BuildUi",flags).Invoke(w,null);
Check(w.rootVisualElement.Q<ScrollView>("page-Campaign")!=null,"Campaign tab did not render");
typeof(GameEditorWindow).GetField("campaignTab",flags).SetValue(w,false);typeof(GameEditorWindow).GetField("activeTab",flags).SetValue(w,HeroConfigSection.Heroes);typeof(GameEditorWindow).GetMethod("BuildUi",flags).Invoke(w,null);
Check(File.ReadAllText(path)==original,"Config probe left a changed file");
var result=new{Result="PASS",Checks=checks,Heroes=16,Monsters=10,Items=67,Tabs=7,CleanRefresh=true,DirtyDraftPreserved=true,StaleSaveRefused=true,ConfigRestored=true};
Directory.CreateDirectory("../Artifacts/ZatodPhaseChecks");File.WriteAllText("../Artifacts/ZatodPhaseChecks/gameeditor-checks.json",Newtonsoft.Json.JsonConvert.SerializeObject(result));return result;
