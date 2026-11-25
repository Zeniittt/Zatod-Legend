using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;
public static class D38Visuals
{
    const BindingFlags All=BindingFlags.Static|BindingFlags.Instance|BindingFlags.Public|BindingFlags.NonPublic;
    public static async Task<object> Run(string output)
    {
        if(!EditorApplication.isPlaying)throw new InvalidOperationException("Use Play Mode");
        Directory.CreateDirectory(output);var host=UnityEngine.Object.FindAnyObjectByType<ZatodPrototypeView>();var c=host.GetComponent<ZatodConnection>();
        var selector=(ZatodChapterSelectorView)typeof(ZatodPrototypeView).GetField("chapterSelector",All).GetValue(host);
        var catalog=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.Load(catalog);
        var snapshot=new ZatodAccountSnapshot{Account=campaign.CreateDemoCharacter(catalog)};snapshot.Account.Level=5;
        snapshot.Cleared=campaign.Data.Chapters[0].Stages.Select(s=>s.Id).ToList();snapshot.StageStars=snapshot.Cleared.Select(s=>new ZatodStageStars{StageId=s,Stars=3}).ToList();
        var editor=typeof(Editor).Assembly;var gameType=editor.GetType("UnityEditor.GameView");var view=EditorWindow.GetWindow(gameType);
        var selected=gameType.GetProperty("selectedSizeIndex",All);int before=(int)selected.GetValue(view);
        var sizes=editor.GetType("UnityEditor.GameViewSizes");var singleton=sizes.BaseType.GetProperty("instance",All).GetValue(null);var enumType=editor.GetType("UnityEditor.GameViewSizeGroupType");
        var groupName=EditorUserBuildSettings.activeBuildTarget==BuildTarget.iOS?Enum.GetNames(enumType).First(n=>n=="iOS" || n=="iPhone"):"Standalone";
        var group=sizes.GetMethod("GetGroup").Invoke(singleton,new[]{Enum.Parse(enumType,groupName)});var type=group.GetType();int added=0,checks=0;
        var safe=selector.GetComponentInParent<ZatodSafeAreaRoot>();var profiles=new List<object>();
        void Check(bool value,string why){checks++;if(!value)throw new Exception(why);}
        void Bounds(RectTransform rect)
        {
            var corners=new Vector3[4];rect.GetWorldCorners(corners);var safeRect=(RectTransform)safe.transform;
            foreach(var point in corners){var local=safeRect.InverseTransformPoint(point);Check(safeRect.rect.Contains(new Vector2(local.x,local.y)),"Control outside safe area: "+rect.name);}
        }
        try
        {
            foreach(var pair in new[]{new[]{1600,900},new[]{2436,1125},new[]{2400,1080},new[]{1600,1200}})
            {
                int w=pair[0],h=pair[1];var size=Activator.CreateInstance(editor.GetType("UnityEditor.GameViewSize"),All,null,new object[]{Enum.Parse(editor.GetType("UnityEditor.GameViewSizeType"),"FixedResolution"),w,h,"D38 responsive"},null);
                int index=(int)type.GetMethod("GetTotalCount").Invoke(group,null);type.GetMethod("AddCustomSize").Invoke(group,new[]{size});added++;selected.SetValue(view,index);view.Repaint();
                var until=EditorApplication.timeSinceStartup+6;while(Screen.width!=w || Screen.height!=h){if(EditorApplication.timeSinceStartup>until)throw new TimeoutException("Game View resize");await Task.Delay(30);}
                selector.Open(campaign,snapshot,null,id=>{});await Task.Delay(250);
                Check(selector.FocusedChapter==campaign.Data.Chapters[1].Id,"Focus highest open chapter");Check(selector.Scroll.horizontal && !selector.Scroll.vertical,"Horizontal selector");
                selector.ChapterButtons[2].onClick.Invoke();Check(selector.Notice.text.Contains("Lv8") && selector.Notice.text.Contains("Complete"),"Locked reason");
                Bounds(selector.Notice.rectTransform);Bounds((RectTransform)selector.transform.Find("Close"));
                string image=Path.Combine(output,"selector-"+w+"x"+h+".png");ScreenCapture.CaptureScreenshot(image);await Task.Delay(180);profiles.Add(new{Width=w,Height=h,SafeArea=false,Image=image});
                if(w==2436)
                {
                    safe.enabled=false;var area=ZatodSafeAreaRoot.Normalized(new Rect(132,63,w-264,h-63),w,h);var rect=(RectTransform)safe.transform;rect.anchorMin=area.min;rect.anchorMax=area.max;await Task.Delay(200);
                    Bounds(selector.Notice.rectTransform);Bounds((RectTransform)selector.transform.Find("Close"));ScreenCapture.CaptureScreenshot(Path.Combine(output,"selector-safe-area.png"));await Task.Delay(150);profiles.Add(new{Width=w,Height=h,SafeArea=true});safe.enabled=true;safe.Apply();
                }
            }
            var result=new{State="PASS",Checks=checks,Profiles=profiles};File.WriteAllText(Path.Combine(output,"responsive.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
        }
        finally{selector.Hide();safe.enabled=true;safe.Apply();selected.SetValue(view,before);for(int i=0;i<added;i++)type.GetMethod("RemoveCustomSize").Invoke(group,new object[]{(int)type.GetMethod("GetTotalCount").Invoke(group,null)-1});view.Repaint();}
    }
}
