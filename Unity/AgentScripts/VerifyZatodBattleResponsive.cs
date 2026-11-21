using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;
using Zatod.Combat;
using Zatod.Networking;
using Zatod.Presentation;
public static class VerifyZatodBattleResponsive
{
    const BindingFlags Flags=BindingFlags.Instance|BindingFlags.Public|BindingFlags.NonPublic;
    public static async Task<object> Run()
    {
        var host=UnityEngine.Object.FindAnyObjectByType<ZatodPrototypeView>();var controller=host.GetComponent<ZatodBattleSceneController>();
        var actors=(RectTransform)typeof(ZatodPrototypeView).GetField("actors",Flags).GetValue(host);
        var hud=(ZatodBattleHudLayout)typeof(ZatodPrototypeView).GetField("hud",Flags).GetValue(host);
        var decode=typeof(ReplayArchive).GetMethod("DecodePayload",BindingFlags.Static|BindingFlags.NonPublic).MakeGenericMethod(typeof(ZatodReplay));
        var replay=(ZatodReplay)decode.Invoke(null,new object[]{File.ReadAllBytes(Directory.GetFiles(Path.GetFullPath("../Artifacts/ZatodWorldBattleChecks/Server"),"*.zatod.gz")[0])});
        typeof(ZatodPrototypeView).GetMethod("LoadReplay",Flags).Invoke(host,new object[]{replay});
        await Unity.Pipeline.Scripting.Wait.Until(()=>controller.Phase==ZatodScenePhase.InBattle,timeoutMs:10000,because:"battle scene ready");
        typeof(ZatodPrototypeView).GetMethod("Seek",Flags).Invoke(host,new object[]{Math.Min(32,replay.EndTick/2)});
        var assembly=typeof(Editor).Assembly;var viewType=assembly.GetType("UnityEditor.GameView");var view=EditorWindow.GetWindow(viewType);var selected=viewType.GetProperty("selectedSizeIndex",Flags);int oldIndex=(int)selected.GetValue(view);
        var sizesType=assembly.GetType("UnityEditor.GameViewSizes");var sizes=sizesType.BaseType.GetProperty("instance",BindingFlags.Public|BindingFlags.Static).GetValue(null);
        var group=sizesType.GetMethod("GetGroup").Invoke(sizes,new[]{Enum.Parse(assembly.GetType("UnityEditor.GameViewSizeGroupType"),"Standalone")});
        var groupType=group.GetType();int initialCount=(int)groupType.GetMethod("GetTotalCount").Invoke(group,null),checks=0;
        string folder=Path.GetFullPath("../Artifacts/ZatodWorldBattleChecks/responsive");Directory.CreateDirectory(folder);var profiles=new List<object>();
        void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        try
        {
            foreach(var pair in new[]{new[]{1600,900},new[]{2436,1125},new[]{2400,1080},new[]{1600,1200}})
            {
                int w=pair[0],h=pair[1];var size=Activator.CreateInstance(assembly.GetType("UnityEditor.GameViewSize"),Flags,null,new object[]{Enum.Parse(assembly.GetType("UnityEditor.GameViewSizeType"),"FixedResolution"),w,h,"ZatodWBReview "+w+"x"+h},null);
                int index=(int)groupType.GetMethod("GetTotalCount").Invoke(group,null);groupType.GetMethod("AddCustomSize").Invoke(group,new[]{size});selected.SetValue(view,index);view.Repaint();
                await Unity.Pipeline.Scripting.Wait.Until(()=>Screen.width==w && Screen.height==h,timeoutMs:8000,because:"Game View resize");await Task.Delay(250);
                controller.Stage.Fit(actors);await Task.Delay(100);
                foreach(var point in new[]{new Vector3(-7,-.7f),Vector3.zero,new Vector3(7,2),new Vector3(-4,1)})
                {
                    var ui=RectTransformUtility.WorldToScreenPoint(null,actors.TransformPoint(point*100));var projected=controller.Stage.BattleCamera.WorldToScreenPoint(point);
                    Check(Vector2.Distance(ui,projected)<1.5f,"Renderer/HUD projection drift at "+w+"x"+h+": "+Vector2.Distance(ui,projected));
                }
                var safe=(RectTransform)hud.GetComponentInParent<ZatodSafeAreaRoot>().transform;
                foreach(var button in new[]{hud.Exit,hud.Auto})
                {var corners=new Vector3[4];((RectTransform)button.transform).GetWorldCorners(corners);foreach(var p in corners){var local=safe.InverseTransformPoint(p);Check(safe.rect.Contains(local),"HUD outside safe area: "+button.name);}}
                ScreenCapture.CaptureScreenshot(Path.Combine(folder,w+"x"+h+".png"));await Task.Delay(120);
                profiles.Add(new{Width=w,Height=h,SafeArea=new{X=Screen.safeArea.x,Y=Screen.safeArea.y,Width=Screen.safeArea.width,Height=Screen.safeArea.height},Memory=UnityEngine.Profiling.Profiler.GetTotalAllocatedMemoryLong(),Renderers=controller.Stage.GetComponentsInChildren<SpriteRenderer>(true).Length});
            }
        }
        finally
        {
            selected.SetValue(view,oldIndex);
            while((int)groupType.GetMethod("GetTotalCount").Invoke(group,null)>initialCount)
            {
                int count=(int)groupType.GetMethod("GetTotalCount").Invoke(group,null);var remove=groupType.GetMethod("RemoveCustomSize");
                try{remove.Invoke(group,new object[]{count-1});}catch(TargetInvocationException){}
                if((int)groupType.GetMethod("GetTotalCount").Invoke(group,null)==count)remove.Invoke(group,new[]{(object)((int)groupType.GetMethod("GetCustomCount").Invoke(group,null)-1)});
            }
            typeof(ZatodPrototypeView).GetMethod("Show",Flags).Invoke(host,new object[]{"campaign"});
        }
        await Unity.Pipeline.Scripting.Wait.Until(()=>controller.Phase==ZatodScenePhase.World,timeoutMs:10000,because:"return from layout review");
        var fixture=new GameObject("ZatodLoadFailureFixture",typeof(ZatodBattleSceneController));var failing=fixture.GetComponent<ZatodBattleSceneController>();string expectedError=null;
        try
        {
            typeof(ZatodBattleSceneController).GetField("battleScenePath",Flags).SetValue(failing,"Assets/Zatod/Scenes/MissingForLoadFailureTest.unity");failing.Failed+=message=>expectedError=message;failing.Enter();
            await Unity.Pipeline.Scripting.Wait.Until(()=>expectedError!=null,timeoutMs:10000,because:"load failure handled");
            Check(failing.Phase==ZatodScenePhase.World && failing.Stage==null,"Load failure did not reset state");Check(SceneManager.sceneCount==1,"Load failure leaked scene");
        }
        finally{UnityEngine.Object.Destroy(fixture);}
        var result=new{Result="PASS",Checks=checks,Profiles=profiles,ExpectedLoadError=expectedError,SceneCount=SceneManager.sceneCount};File.WriteAllText(Path.Combine(folder,"result.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
    }
}
