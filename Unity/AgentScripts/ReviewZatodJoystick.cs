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
using Zatod.Heroes;
using Zatod.World;
using Zatod.Networking;
using Zatod.Presentation;

public static class ZatodJoystickReview
{
    const BindingFlags Flags=BindingFlags.Instance|BindingFlags.Public|BindingFlags.NonPublic;
    static string Folder=>Path.GetFullPath("../Artifacts/ZatodJoystickChecks/live");
    static object Resize(int width,int height)
    {
        var assembly=typeof(Editor).Assembly;var vt=assembly.GetType("UnityEditor.GameView");var view=EditorWindow.GetWindow(vt);var selected=vt.GetProperty("selectedSizeIndex",Flags);
        if(!SessionState.GetBool("ZatodHeroReviewSaved",false)){SessionState.SetInt("ZatodHeroReviewIndex",(int)selected.GetValue(view));SessionState.SetBool("ZatodHeroReviewSaved",true);}
        var st=assembly.GetType("UnityEditor.GameViewSizes");var instance=st.BaseType.GetProperty("instance",BindingFlags.Static|BindingFlags.Public).GetValue(null);
        var group=st.GetMethod("GetGroup").Invoke(instance,new[]{Enum.Parse(assembly.GetType("UnityEditor.GameViewSizeGroupType"),"Standalone")});
        var size=Activator.CreateInstance(assembly.GetType("UnityEditor.GameViewSize"),Flags,null,new object[]{Enum.Parse(assembly.GetType("UnityEditor.GameViewSizeType"),"FixedResolution"),width,height,"Zatod Review "+width+"x"+height},null);
        int count=(int)group.GetType().GetMethod("GetTotalCount").Invoke(group,null);group.GetType().GetMethod("AddCustomSize").Invoke(group,new[]{size});selected.SetValue(view,count);view.Repaint();return count;
    }
    public static async Task<object> Begin()
    {
        Directory.CreateDirectory(Folder);Resize(2436,1125);var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();c.DevelopmentProfile="joystick-"+Guid.NewGuid().ToString("N");c.Port=17994;c.GetComponent<Mirror.TelepathyTransport>().port=17994;c.Connect();
        int frame=Time.frameCount;await Unity.Pipeline.Scripting.Wait.Until(()=>c.WorldSelf!=null,timeoutMs:20000,because:"joystick test login");await Task.Delay(200);
        if(Time.frameCount<=frame+2)throw new Exception("Play frames not advancing");
        return new{Frames=Time.frameCount-frame,Screen.width,Screen.height,Joystick=UnityEngine.Object.FindAnyObjectByType<ZatodWorldView>().Joystick!=null};
    }
    public static async Task<object> Run()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var world=UnityEngine.Object.FindAnyObjectByType<ZatodWorldView>();var host=world.GetComponent<ZatodPrototypeView>();var c=world.GetComponent<ZatodConnection>();var joy=world.Joystick;
        var settings=InputSystem.settings;var oldBackground=settings.backgroundBehavior;var oldRouting=settings.editorInputBehaviorInPlayMode;
        Key[] held=Array.Empty<Key>();Action apply=()=>{if(InputState.currentUpdateType==InputUpdateType.Dynamic && Keyboard.current!=null)InputState.Change(Keyboard.current,new KeyboardState(held),InputUpdateType.Dynamic);};
        settings.backgroundBehavior=InputSettings.BackgroundBehavior.IgnoreFocus;settings.editorInputBehaviorInPlayMode=InputSettings.EditorInputBehaviorInPlayMode.AllDeviceInputAlwaysGoesToGameView;InputSystem.onAfterUpdate+=apply;
        var safe=world.Hud.GetComponentInParent<ZatodSafeAreaRoot>();var sr=(RectTransform)safe.transform;
        PointerEventData Pointer(int id,Vector2 direction)
        {
            var r=(RectTransform)joy.transform;float factor=joy.GetComponentInParent<Canvas>().scaleFactor;
            return new PointerEventData(EventSystem.current){pointerId=id,button=PointerEventData.InputButton.Left,position=RectTransformUtility.WorldToScreenPoint(null,r.position)+direction*r.sizeDelta*.5f*factor};
        }
        void Down(int id,Vector2 direction)=>ExecuteEvents.Execute(joy.gameObject,Pointer(id,direction),ExecuteEvents.pointerDownHandler);
        void Drag(int id,Vector2 direction)=>ExecuteEvents.Execute(joy.gameObject,Pointer(id,direction),ExecuteEvents.dragHandler);
        void Up(int id)=>ExecuteEvents.Execute(joy.gameObject,Pointer(id,Vector2.zero),ExecuteEvents.pointerUpHandler);
        async Task Capture(string name){ScreenCapture.CaptureScreenshot(Path.Combine(Folder,name+".png"));await Task.Delay(100);}
        string before=JsonUtility.ToJson(c.Snapshot.Account);
        try
        {
            Check(joy.AxisOptions==AxisOptions.Both,"Vendor getter fixed");Check(joy.Direction==Vector2.zero,"Initial neutral");Check(UnityEngine.Object.FindObjectsByType<EventSystem>().Length==1,"One EventSystem");
            var hits=new System.Collections.Generic.List<RaycastResult>();EventSystem.current.RaycastAll(Pointer(100,Vector2.zero),hits);
            Check(hits.Count>0 && ExecuteEvents.GetEventHandler<IPointerDownHandler>(hits[0].gameObject)==joy.gameObject,"Joystick must receive real graphic raycasts");
            var heroButton=(RectTransform)world.Hud.Find("Shortcuts/Board/Hero");var heroPointer=new PointerEventData(EventSystem.current){position=RectTransformUtility.WorldToScreenPoint(null,heroButton.TransformPoint(heroButton.rect.center))};hits.Clear();EventSystem.current.RaycastAll(heroPointer,hits);
            Check(hits.Count>0 && ExecuteEvents.GetEventHandler<IPointerClickHandler>(hits[0].gameObject)==heroButton.gameObject,"Hero menu must receive clicks rather than joystick");
            var initial=world.Position;Down(101,new Vector2(2,0));await Task.Delay(300);Check(joy.PointerHeld && joy.Movement.x>.99f && joy.Movement.magnitude<=1.001f,"Drag clamp");Check(world.Position.x>initial.x+.3f,"Joystick moves avatar");
            Down(102,Vector2.left);Drag(102,Vector2.left);Up(102);Check(joy.PointerHeld && joy.Movement.x>.99f,"Second pointer cannot steal or release");
            Drag(101,Vector2.up);Check(joy.Movement.y>.99f,"Owner pointer can steer");await Task.Delay(150);await Capture("pass1-drag");Up(101);Check(!joy.PointerHeld && joy.Movement==Vector2.zero && joy.Direction==Vector2.zero,"Pointer release resets");
            var released=world.Position;await Task.Delay(150);Check(Vector2.Distance(released,world.Position)<.001f,"No movement after release");
            Down(103,new Vector2(.3f,0));Check(Math.Abs(joy.Movement.x-.3f)<.02f,"Analog input preserved");Up(103);
            Down(104,Vector2.right);host.OpenHeroRoster();await Task.Delay(120);Check(!joy.PointerHeld && joy.Direction==Vector2.zero && joy.Movement==Vector2.zero,"Hero modal cancels");
            var roster=(ZatodHeroRosterView)typeof(ZatodPrototypeView).GetField("heroRoster",Flags).GetValue(host);roster.Back.onClick.Invoke();await Task.Delay(100);Check(joy.Movement==Vector2.zero,"No resume after modal");
            Down(105,Vector2.right);joy.SendMessage("OnApplicationFocus",false);Check(!joy.PointerHeld && joy.Direction==Vector2.zero,"Focus loss resets");
            Down(106,Vector2.right);joy.SendMessage("OnApplicationPause",true);Check(!joy.PointerHeld && joy.Direction==Vector2.zero,"App pause resets");
            Down(107,Vector2.right);joy.gameObject.SetActive(false);Check(joy.Direction==Vector2.zero,"Disable resets");joy.gameObject.SetActive(true);await Task.Delay(60);
            var keyboardStart=world.Position;held=new[]{Key.D};await Task.Delay(180);held=Array.Empty<Key>();await Task.Delay(70);Check(world.Position.x>keyboardStart.x+.2f,"Editor keyboard fallback");
            var catalog=WorldDataJson.Load(CampaignDataJson.LoadZatod(HeroDataJson.LoadBundledCatalog()));var portal=catalog.Map(world.MapId).Interactions.First(p=>p.Kind==WorldInteractionKind.Portal);string oldMap=world.MapId;
            Down(108,Vector2.right);c.WorldTravel(portal.Id);await Unity.Pipeline.Scripting.Wait.Until(()=>world.MapId!=oldMap,timeoutMs:5000,because:"test portal");Check(!joy.PointerHeld && joy.Direction==Vector2.zero,"Map travel cancels");
            var rows=new System.Collections.Generic.List<object>();
            int[,] dimensions={{1920,1080},{1600,1200},{2436,1125},{2520,1080}};
            for(int i=0;i<dimensions.GetLength(0);i++)
            {
                Resize(dimensions[i,0],dimensions[i,1]);await Task.Delay(200);safe.Apply();Canvas.ForceUpdateCanvases();joy.Fit();await Task.Delay(60);
                var menu=(RectTransform)world.Hud.Find("Shortcuts");var toggle=(RectTransform)menu.Find("Toggle");
                Bounds(joy.GetComponent<RectTransform>(),sr,Check);Bounds(menu,sr,Check);
                var jp=sr.InverseTransformPoint(joy.transform.position);Check(jp.x<sr.rect.center.x && jp.y<sr.rect.center.y,"Joystick lower-left quarter");
                var mp=sr.InverseTransformPoint(menu.position);Check(mp.x>sr.rect.center.x && mp.y<sr.rect.center.y,"Menu bottom right");
                Check(!RectTransformUtility.RectangleContainsScreenPoint(menu,RectTransformUtility.WorldToScreenPoint(null,joy.transform.position)),"No joystick/menu overlap");
                Vector3 togglePosition=toggle.position;host.ToggleShortcuts();Check(!menu.Find("Board").gameObject.activeSelf && Vector3.Distance(togglePosition,toggle.position)<.1f,"Collapsed menu keeps right anchor");host.ToggleShortcuts();
                Down(201,Vector2.right);Check(joy.Movement.x>.99f,"Drag works after resize");Up(201);await Capture("pass2-layout-"+i);
                rows.Add(new{Width=Screen.width,Height=Screen.height});
            }
            Check(before==JsonUtility.ToJson(c.Snapshot.Account),"UI input changed Hero/item account");
            Down(301,Vector2.right);c.Disconnect();await Task.Delay(150);Check(joy.Direction==Vector2.zero && !joy.PointerHeld,"Disconnect cancels");
            var result=new{Result="PASS",Checks=checks,Resolutions=rows,OwnedAccountUnchanged=true};File.WriteAllText(Path.Combine(Folder,"result.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
        }
        catch(Exception e){File.WriteAllText(Path.Combine(Folder,"result.json"),Newtonsoft.Json.JsonConvert.SerializeObject(new{Result="FAIL",Checks=checks,Error=e.Message},Newtonsoft.Json.Formatting.Indented));throw;}
        finally{joy.CancelInput();InputSystem.onAfterUpdate-=apply;if(Keyboard.current!=null)InputState.Change(Keyboard.current,new KeyboardState(),InputUpdateType.Dynamic);settings.backgroundBehavior=oldBackground;settings.editorInputBehaviorInPlayMode=oldRouting;}
    }
    static void Bounds(RectTransform child,RectTransform parent,Action<bool,string> check)
    {
        var corners=new Vector3[4];child.GetWorldCorners(corners);foreach(var c in corners){var p=parent.InverseTransformPoint(c);check(p.x>=parent.rect.xMin-.5f && p.x<=parent.rect.xMax+.5f && p.y>=parent.rect.yMin-.5f && p.y<=parent.rect.yMax+.5f,"Outside safe area: "+child.name);}
    }
}
