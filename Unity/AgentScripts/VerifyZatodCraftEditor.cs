using System;
using System.IO;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Heroes;
using Zatod.Editor;
public static class VerifyZatodCraftEditor
{
 const BindingFlags Flags=BindingFlags.Instance|BindingFlags.NonPublic;
 public static object Run()
 {
  if(Application.isPlaying)throw new Exception("Stop Play first.");var original=HeroConfigFileStore.Read();int checks=0;
  void Check(bool v,string why){checks++;if(!v)throw new Exception(why);}
  var w=ScriptableObject.CreateInstance<GameEditorWindow>();w.titleContent=new GUIContent("Zatod Craft Test");typeof(GameEditorWindow).GetField("activeTab",Flags).SetValue(w,HeroConfigSection.CraftRecipes);w.Show();w.CreateGUI();
  string error=null;
  try
  {
   Check(w.rootVisualElement.Q<UnityEngine.UIElements.Button>("tab-CraftRecipes")!=null,"CraftRecipes tab absent");
   var data=(HeroCatalogData)typeof(GameEditorWindow).GetField("draft",Flags).GetValue(w);Check(data.CraftRecipes.Count==55 && data.Items.Count==112,"Editor stale content");
   var first=w.rootVisualElement.Query<Foldout>().ToList().First(f=>f.text.StartsWith("[0]"));first.value=true;
   Check(w.rootVisualElement.Q<LongField>("field-GoldCost")!=null,"GoldCost is not editable");Check(w.rootVisualElement.Q<TextField>("field-OutputItemId")!=null,"Output item field missing");
   var cost=w.rootVisualElement.Q<LongField>("field-GoldCost");long previous=cost.value;cost.value=previous+7;Check(w.hasUnsavedChanges && data.CraftRecipes[0].GoldCost==previous+7,"Editor failed to keep recipe draft");
   var docs=HeroConfigFileStore.Read();Check(docs.CraftRecipes==original.CraftRecipes,"Editing draft wrote a file");
   data.ConfigVersion+="-editor-check";HeroConfigFileStore.Save(data,original);var saved=HeroConfigFileStore.Read();Check(HeroDataJson.ReadDocuments(saved).Data.CraftRecipes[0].GoldCost==previous+7,"Recipe save did not roundtrip");
   bool stale=false;try{HeroConfigFileStore.Save(data,original);}catch(IOException){stale=true;}Check(stale,"Stale save guard missed recipes");
   data.CraftRecipes[0].Ingredients[0].Amount=0;bool invalid=false;try{HeroConfigFileStore.Save(data,saved);}catch(ArgumentException){invalid=true;}Check(invalid,"Invalid ingredient saved");
  }
  catch(Exception e){error=e.ToString();}
  finally
  {
   foreach(var section in HeroDataJson.Sections)File.WriteAllText(HeroDataJson.AssetPath(section),original.Get(section));HeroConfigFileStore.ImportFiles();w.DiscardChanges();w.Close();
  }
  var result=new{Result=error==null?"PASS":"FAIL",Checks=checks,Error=error};Directory.CreateDirectory("../Artifacts/ZatodCraftChecks");File.WriteAllText("../Artifacts/ZatodCraftChecks/editor.json",Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));if(error!=null)throw new Exception(error);return result;
 }
}
