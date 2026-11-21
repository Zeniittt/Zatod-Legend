using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.LowLevel;
using Zatod.Presentation;
using Zatod.Networking;
using Zatod.Heroes;
using Zatod.World;

public static class ZatodFacingReview
{
    static string Folder=>Path.GetFullPath("../Artifacts/ZatodFacingChecks/live");
    public static async Task<object> Run()
    {
        Directory.CreateDirectory(Folder);int checks=0;void Check(bool ok,string reason){checks++;if(!ok)throw new Exception(reason);}
        var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();var world=c.GetComponent<ZatodWorldView>();var joy=world.Joystick;
        c.DevelopmentProfile="facing-"+Guid.NewGuid().ToString("N");c.Port=17995;c.GetComponent<Mirror.TelepathyTransport>().port=17995;c.Connect();
        await Unity.Pipeline.Scripting.Wait.Until(()=>c.WorldSelf!=null,timeoutMs:20000,because:"facing login");int firstFrame=Time.frameCount;await Task.Delay(180);Check(Time.frameCount>firstFrame+2,"Play advancing");
        var settings=InputSystem.settings;var background=settings.backgroundBehavior;var routing=settings.editorInputBehaviorInPlayMode;
        Action apply=()=>{if(InputState.currentUpdateType==InputUpdateType.Dynamic && Keyboard.current!=null)InputState.Change(Keyboard.current,new KeyboardState(),InputUpdateType.Dynamic);};
        settings.backgroundBehavior=InputSettings.BackgroundBehavior.IgnoreFocus;settings.editorInputBehaviorInPlayMode=InputSettings.EditorInputBehaviorInPlayMode.AllDeviceInputAlwaysGoesToGameView;InputSystem.onAfterUpdate+=apply;
        PointerEventData Pointer(Vector2 direction)
        {
            var rect=(RectTransform)joy.transform;return new PointerEventData(EventSystem.current){pointerId=701,position=RectTransformUtility.WorldToScreenPoint(null,rect.position)+direction*rect.sizeDelta*.5f*joy.GetComponentInParent<Canvas>().scaleFactor};
        }
        void Down(Vector2 direction)=>ExecuteEvents.Execute(joy.gameObject,Pointer(direction),ExecuteEvents.pointerDownHandler);
        void Up()=>ExecuteEvents.Execute(joy.gameObject,Pointer(Vector2.zero),ExecuteEvents.pointerUpHandler);
        Transform Visual()=>world.transform.Find("Avatar_"+c.WorldSelfId).GetComponentInChildren<Animator>().transform.parent;
        float FaceDelta()
        {
            var visual=Visual();var eyes=visual.GetComponentsInChildren<Transform>().Where(t=>t.name=="P_LEye" || t.name=="P_REye").ToArray();
            var head=eyes[0].parent.parent;return eyes.Average(t=>t.position.x)-head.position.x;
        }
        try
        {
            Check(world.Hint.text=="","No controls instruction");Check(Visual().localScale.x<0 && FaceDelta()>0,"Initial right facing, even before direction changes");
            var start=world.Position;Down(Vector2.right);await Task.Delay(260);
            Check(world.Position.x>start.x+.3f,"Actually walking right");Check(Visual().localScale.x<0 && FaceDelta()>0,"Rendered eyes face right");Check(c.WorldSelf.Facing==1,"Network +1 still means right");
            ScreenCapture.CaptureScreenshot(Path.Combine(Folder,"01-right.png"));Up();await Task.Delay(120);float x=world.Position.x;
            Check(FaceDelta()>0 && Visual().GetComponentInChildren<Animator>().GetCurrentAnimatorStateInfo(0).IsName("idle"),"Idle keeps last right facing");
            Down(Vector2.left);await Task.Delay(260);Check(world.Position.x<x-.3f,"Actually walking left");Check(Visual().localScale.x>0 && FaceDelta()<0,"Rendered eyes face left");Check(c.WorldSelf.Facing==-1,"Network -1 still means left");
            ScreenCapture.CaptureScreenshot(Path.Combine(Folder,"02-left.png"));Up();await Task.Delay(100);
            // Call the shared facing method on a detached visual clone to cover the
            // same path used for remote snapshots, without a second client account.
            var avatarType=typeof(ZatodWorldView).GetNestedType("Avatar",BindingFlags.NonPublic);
            var copy=UnityEngine.Object.Instantiate(Visual().gameObject);copy.name="FacingReviewDetached";var avatar=Activator.CreateInstance(avatarType,true);
            avatarType.GetField("Visual").SetValue(avatar,copy.transform);avatarType.GetField("Animator").SetValue(avatar,copy.GetComponentInChildren<Animator>());
            var animate=typeof(ZatodWorldView).GetMethod("Animate",BindingFlags.Static|BindingFlags.NonPublic);var offset=copy.transform.localPosition;float oldScale=copy.transform.localScale.x;
            animate.Invoke(null,new object[]{avatar,false,1f});Check(copy.transform.localScale.x<0,"Shared remote right mapping");Check(Math.Abs(copy.transform.localPosition.x+offset.x)<.0001f,"Flip also mirrors centering offset");
            animate.Invoke(null,new object[]{avatar,false,-1f});Check(Math.Abs(copy.transform.localScale.x-oldScale)<.0001f && Math.Abs(copy.transform.localPosition.x-offset.x)<.0001f,"Round trip keeps scale/offset");UnityEngine.Object.Destroy(copy);
            var catalog=WorldDataJson.Load(CampaignDataJson.LoadZatod(HeroDataJson.LoadBundledCatalog()));
            Check(catalog.Data.Maps.Count==3,"Three map definitions loaded");Check(world.transform.Cast<Transform>().Count(t=>t.name.StartsWith("ZatodMap_"))==1,"Only current map geometry exists");
            var mapRows=new System.Collections.Generic.List<object>();
            foreach(string id in new[]{"town","chapter_one","chapter_two"})
            {
                if(world.MapId!=id){var portal=catalog.Map(world.MapId).Interactions.FirstOrDefault(p=>p.Kind==WorldInteractionKind.Portal && p.TargetId==id);if(portal==null)continue;c.WorldTravel(portal.Id);await Unity.Pipeline.Scripting.Wait.Until(()=>world.MapId==id,timeoutMs:5000,because:"map inspection");await Task.Delay(80);}
                var roots=world.transform.Cast<Transform>().Where(t=>t.name.StartsWith("ZatodMap_")).ToArray();Check(roots.Length==1 && roots[0].name=="ZatodMap_"+id,"Map replaced: "+id);mapRows.Add(new{MapId=id,Geometry=roots[0].name,X=roots[0].position.x,Y=roots[0].position.y,SceneCount=UnityEngine.SceneManagement.SceneManager.sceneCount});
            }
            var result=new{Result="PASS",Checks=checks,Maps=mapRows,RootScene=UnityEngine.SceneManagement.SceneManager.GetActiveScene().path};File.WriteAllText(Path.Combine(Folder,"result.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
        }
        catch(Exception e){File.WriteAllText(Path.Combine(Folder,"result.json"),Newtonsoft.Json.JsonConvert.SerializeObject(new{Result="FAIL",Checks=checks,Error=e.Message},Newtonsoft.Json.Formatting.Indented));throw;}
        finally{Up();InputSystem.onAfterUpdate-=apply;if(Keyboard.current!=null)InputState.Change(Keyboard.current,new KeyboardState(),InputUpdateType.Dynamic);settings.backgroundBehavior=background;settings.editorInputBehaviorInPlayMode=routing;}
    }
}
