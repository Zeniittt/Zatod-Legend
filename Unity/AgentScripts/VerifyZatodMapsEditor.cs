using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Editor;
using Zatod.Heroes;

public static class VerifyZatodMapsEditor
{
    const BindingFlags Flags=BindingFlags.Instance|BindingFlags.Public|BindingFlags.NonPublic;
    static void Click(Button button)
    {
        if(button==null)throw new Exception("Missing editor button");
        var invoke=typeof(Clickable).GetMethod("Invoke",Flags);if(invoke==null)throw new Exception("Clickable Invoke unavailable");invoke.Invoke(button.clickable,new object[]{null});
    }
    public static object Run()
    {
        if(Application.isPlaying)throw new Exception("Run Maps editor check outside Play Mode.");
        string folder=Path.GetFullPath("../Artifacts/ZatodMapsEditorChecks");Directory.CreateDirectory(folder);
        var originals=Directory.GetFiles("Assets/Zatod/Resources/Data","*.txt",SearchOption.AllDirectories).ToDictionary(p=>p,File.ReadAllBytes);
        var w=ScriptableObject.CreateInstance<GameEditorWindow>();w.titleContent=new GUIContent("Zatod Maps Review");w.position=new Rect(80,70,1120,800);
        typeof(GameEditorWindow).GetField("mapsTab",Flags).SetValue(w,true);w.Show();w.CreateGUI();
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        WorldConfigDocuments Docs()=>(WorldConfigDocuments)typeof(GameEditorWindow).GetField("worldDocuments",Flags).GetValue(w);
        void Reload()=>typeof(GameEditorWindow).GetMethod("ReloadFromFile",Flags).Invoke(w,null);
        bool Unchanged()=>originals.All(p=>File.ReadAllBytes(p.Key).SequenceEqual(p.Value));
        string error=null;
        try
        {
            Check(w.rootVisualElement.Q<Button>("tab-Maps")!=null,"Maps tab missing");Check(Docs().Maps.Count==3,"Expected three island files");Check(!Docs().Changed && !w.hasUnsavedChanges,"Opening Maps dirtied config");
            var choice=w.rootVisualElement.Q<PopupField<string>>("map-choice");Check(choice.choices.Count==3,"Island choices missing");choice.value=choice.choices[1];
            var fields=w.rootVisualElement.Q("map-fields");Check(fields.Q<FloatField>("field-OriginX").value==110,"Origin not shown");
            var spawns=fields.Query<Foldout>().ToList().First(f=>f.text.StartsWith("Spawns ("));spawns.value=true;
            var first=spawns.Query<Foldout>().ToList().First(f=>f!=spawns);first.value=true;
            Check(first.Q<FloatField>("field-X").value==6,"Editor used compiled world coordinate instead of local spawn");
            Check(fields.Query<Foldout>().ToList().Any(f=>f.text.StartsWith("Interactions (")),"NPC/portal list missing");
            fields.Q<FloatField>("field-InterestRadius").value=49;
            Check(w.hasUnsavedChanges && Docs().Changed,"Map edit not tracked");
            Click(w.rootVisualElement.Q<Button>("tab-Heroes"));Check(w.rootVisualElement.Q("page-Heroes")!=null,"Hero tab broken");
            Click(w.rootVisualElement.Q<Button>("tab-Maps"));Check(Docs().Maps[1].Draft.InterestRadius==49,"Switching tabs discarded map draft");
            w.SaveConfig();Check(!w.hasUnsavedChanges,"Save all did not clear map draft");
            var disk=JsonUtility.FromJson<Zatod.World.WorldMapDefinition>(File.ReadAllText(Docs().Maps[1].AssetPath));
            Check(disk.InterestRadius==49 && disk.OriginX==110 && disk.Spawns[0].X==6,"Save changed local coordinate/offset");
            Check(originals.Where(p=>Path.GetFullPath(p.Key)!=Path.GetFullPath(Docs().Maps[1].AssetPath)).All(p=>File.ReadAllBytes(p.Key).SequenceEqual(p.Value)),"Map-only save rewrote unrelated tables");
            foreach(var entry in originals)File.WriteAllBytes(entry.Key,entry.Value);Reload();
            choice=w.rootVisualElement.Q<PopupField<string>>("map-choice");choice.value=choice.choices[1];fields=w.rootVisualElement.Q("map-fields");
            fields.Q<FloatField>("field-InterestRadius").value=-1;Click(w.rootVisualElement.Q<Button>("save-maps"));
            Check(Unchanged() && w.hasUnsavedChanges,"Invalid map saved or draft lost");Check(w.rootVisualElement.Q<Label>("config-status").text.StartsWith("ERROR"),"Validation error not displayed");
            fields.Q<FloatField>("field-InterestRadius").value=50;string mapPath=Docs().Maps[1].AssetPath;
            File.AppendAllText(mapPath,"\n");w.ReloadIfClean();Check(w.hasUnsavedChanges && Docs().Maps[1].Draft.InterestRadius==50,"External change discarded unsaved draft");
            Click(w.rootVisualElement.Q<Button>("save-maps"));Check(w.rootVisualElement.Q<Label>("config-status").text.Contains("changed on disk"),"Stale save not rejected");
            Check(JsonUtility.FromJson<Zatod.World.WorldMapDefinition>(File.ReadAllText(mapPath)).InterestRadius==48,"Stale save overwrote disk");
            bool escaped=false;try{WorldConfigFileStore.MapAssetPath("Data/WorldMaps/../../evil");}catch(ArgumentException){escaped=true;}Check(escaped,"Config path traversal accepted");
        }
        catch(Exception e){error=e.ToString();}
        finally
        {
            foreach(var entry in originals)File.WriteAllBytes(entry.Key,entry.Value);
            w.DiscardChanges();w.titleContent=new GUIContent("Zatod Maps Review");
            foreach(var path in originals.Keys)AssetDatabase.ImportAsset(path);
        }
        var result=new{Result=error==null?"PASS":"FAIL",Checks=checks,Error=error,ConfigBytesRestored=Unchanged(),Window=w.titleContent.text};
        File.WriteAllText(Path.Combine(folder,"checks.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));
        if(error!=null)throw new Exception(error);return result;
    }
}
