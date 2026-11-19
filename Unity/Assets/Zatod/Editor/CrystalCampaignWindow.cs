using System;
using System.Collections;
using System.IO;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using Zatod.Heroes;
namespace Zatod.Editor
{
    public sealed class CrystalCampaignWindow : EditorWindow
    {
        const string Path="Assets/Zatod/Resources/Data/CrystalCampaigns.txt";
        CampaignDefinition data;Label status;bool dirty;
        [MenuItem("Zatod/Crystal/Chapter and Wave Balance")]
        public static void Open(){GetWindow<CrystalCampaignWindow>("Crystal Chapter / Waves");}
        public void CreateGUI()
        {
            minSize=new Vector2(900,650);data=JsonUtility.FromJson<CampaignDefinition>(File.ReadAllText(Path));Build();
        }
        void Build()
        {
            rootVisualElement.Clear();var sheet=AssetDatabase.LoadAssetAtPath<StyleSheet>("Assets/Zatod/Editor/HeroBalanceWindow.uss");if(sheet!=null)rootVisualElement.styleSheets.Add(sheet);
            rootVisualElement.AddToClassList("hero-balance");rootVisualElement.Add(new Label("CRYSTAL / CHAPTER · STAGE · WAVE · HOOK"));
            var toolbar=new VisualElement();toolbar.style.flexDirection=FlexDirection.Row;
            toolbar.Add(new Button(()=>Guard(()=>{new CampaignCatalog(data,HeroDataJson.LoadBundledCatalog());status.text="VALID · chapter references, waves, spawns and hooks";})){text="Validate"});
            toolbar.Add(new Button(()=>Guard(Save)){text="Save balance"});
            toolbar.Add(new Button(()=>{data=JsonUtility.FromJson<CampaignDefinition>(File.ReadAllText(Path));dirty=false;Build();}){text="Reload"});rootVisualElement.Add(toolbar);
            status=new Label(dirty?"UNSAVED":"Loaded "+data.ConfigVersion);rootVisualElement.Add(status);var scroll=new ScrollView();rootVisualElement.Add(scroll);scroll.style.flexGrow=1;Draw(scroll,data);
        }
        void Guard(Action action){try{action();}catch(Exception error){status.text=error.Message;}}
        void Save()
        {
            new CampaignCatalog(data,HeroDataJson.LoadBundledCatalog());string old=File.ReadAllText(Path),next=JsonUtility.ToJson(data,true);
            if(old!=next){string backup=System.IO.Path.GetFullPath("../Artifacts/CrystalBalanceBefore/"+DateTime.UtcNow.ToString("yyyyMMdd-HHmmss"));Directory.CreateDirectory(backup);File.WriteAllText(System.IO.Path.Combine(backup,"CrystalCampaigns.txt"),old);File.WriteAllText(Path,next);AssetDatabase.ImportAsset(Path);}
            dirty=false;status.text="SAVED · existing matches and archived replays keep their frozen initial data";
        }
        void Edited(){dirty=true;status.text="UNSAVED · Validate and Save to apply to new matches";}
        void Draw(VisualElement parent,object target)
        {
            foreach(var field in target.GetType().GetFields(BindingFlags.Instance|BindingFlags.Public))
            {
                object value=field.GetValue(target);Type type=field.FieldType;string label=field.Name;
                if(type==typeof(string)){var input=new TextField(label){value=(string)value??""};input.RegisterValueChangedCallback(e=>{field.SetValue(target,e.newValue);Edited();});parent.Add(input);}
                else if(type==typeof(int)){var input=new IntegerField(label){value=(int)value};input.RegisterValueChangedCallback(e=>{field.SetValue(target,e.newValue);Edited();});parent.Add(input);}
                else if(type==typeof(double)){var input=new DoubleField(label){value=(double)value};input.RegisterValueChangedCallback(e=>{field.SetValue(target,e.newValue);Edited();});parent.Add(input);}
                else if(type==typeof(float)){var input=new FloatField(label){value=(float)value};input.RegisterValueChangedCallback(e=>{field.SetValue(target,e.newValue);Edited();});parent.Add(input);}
                else if(type==typeof(bool)){var input=new Toggle(label){value=(bool)value};input.RegisterValueChangedCallback(e=>{field.SetValue(target,e.newValue);Edited();});parent.Add(input);}
                else if(type.IsEnum){var input=new EnumField(label,(Enum)value);input.RegisterValueChangedCallback(e=>{field.SetValue(target,e.newValue);Edited();});parent.Add(input);}
                else if(value is IList list)
                {
                    var fold=new Foldout{text=label+" ("+list.Count+")",value=false};parent.Add(fold);
                    for(int i=0;i<list.Count;i++)
                    {
                        int index=i;var element=list[i];var item=new Foldout{text=label+" ["+i+"] "+(element?.GetType().GetField("Id")?.GetValue(element)??""),value=false};fold.Add(item);
                        item.Add(new Button(()=>{list.RemoveAt(index);Edited();Build();}){text="Remove"});
                        if(element is string text){var input=new TextField{value=text};input.RegisterValueChangedCallback(e=>{list[index]=e.newValue;Edited();});item.Add(input);}
                        else if(element!=null)Draw(item,element);
                    }
                    fold.Add(new Button(()=>{var elementType=type.GetGenericArguments()[0];list.Add(elementType==typeof(string)?"":Activator.CreateInstance(elementType));Edited();Build();}){text="Add "+label});
                }
            }
        }
        void OnDisable(){if(dirty)Debug.LogWarning("Crystal chapter window closed with unsaved balance changes.");}
    }
}
