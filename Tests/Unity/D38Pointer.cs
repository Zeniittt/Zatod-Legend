using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.LowLevel;
using UnityEngine.InputSystem.UI;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;
public static class D38Pointer
{
    public static async Task<object> Run(string report)
    {
        var template=UnityEngine.Object.FindAnyObjectByType<ZatodChapterSelectorView>(FindObjectsInactive.Include);var view=ZatodChapterSelectorView.Create(template.transform.parent,template.Notice.font);
        var catalog=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.Load(catalog);var account=campaign.CreateDemoCharacter(catalog);account.Level=80;var snapshot=new ZatodAccountSnapshot{Account=account,Cleared=campaign.Data.Chapters.SelectMany(c=>c.Stages).Select(s=>s.Id).ToList()};
        var previous=InputSystem.settings.backgroundBehavior;var oldMouse=Mouse.current;var mouse=InputSystem.AddDevice<Mouse>("D38VirtualPointer");int clicks=0;
        void Send(Vector2 point,bool pressed)
        {
            InputSystem.QueueStateEvent(mouse,new MouseState{position=point}.WithButton(MouseButton.Left,pressed));InputSystem.Update();((InputSystemUIInputModule)EventSystem.current.currentInputModule).Process();
        }
        try
        {
            InputSystem.settings.backgroundBehavior=InputSettings.BackgroundBehavior.IgnoreFocus;view.Open(campaign,snapshot,campaign.Data.Chapters[0].Id,_=>clicks++);Canvas.ForceUpdateCanvases();await Task.Delay(120);
            var rect=(RectTransform)view.ChapterButtons[0].transform;var point=RectTransformUtility.WorldToScreenPoint(null,rect.TransformPoint(rect.rect.center));
            Send(point,false);await Task.Delay(50);Send(point,true);await Task.Delay(50);Send(point,false);await Task.Delay(80);
            if(clicks!=1)throw new Exception("A real UI pointer click did not select exactly once: "+clicks);
            clicks=0;Send(point,true);await Task.Delay(50);Send(point+new Vector2(80,0),true);await Task.Delay(50);Send(point+new Vector2(150,0),true);await Task.Delay(50);Send(point+new Vector2(150,0),false);await Task.Delay(80);
            if(clicks!=0)throw new Exception("Dragging a chapter must not select it");
            view.Hide();await Task.Delay(80);if(EventSystem.current.currentSelectedGameObject!=null && EventSystem.current.currentSelectedGameObject.transform.IsChildOf(view.transform))throw new Exception("Closing selector must clear its selection");
            var result=new{State="PASS",PointerClick=true,DragDoesNotSelect=true,VirtualInputSystemMouse=true};File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
        }
        catch(Exception e){File.WriteAllText(report,Newtonsoft.Json.JsonConvert.SerializeObject(new{State="FAIL",Error=e.ToString()},Newtonsoft.Json.Formatting.Indented));throw;}
        finally{Send(Vector2.zero,false);InputSystem.RemoveDevice(mouse);if(oldMouse!=null)oldMouse.MakeCurrent();InputSystem.settings.backgroundBehavior=previous;view.Hide();UnityEngine.Object.Destroy(view.gameObject);}
    }
}
