using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using TMPro;
using Mirror;
using Zatod.Presentation;
using Zatod.Networking;
public static class D39LoginUi
{
    const BindingFlags All=BindingFlags.Instance|BindingFlags.Static|BindingFlags.Public|BindingFlags.NonPublic;
    public static async Task<object> Run(string output)
    {
        if(!EditorApplication.isPlaying||NetworkClient.active||NetworkServer.active)throw new Exception("Use disconnected Editor Play Mode");
        Directory.CreateDirectory(output);int checks=0;
        var c=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();var host=c.GetComponent<ZatodPrototypeView>();var ui=(ZatodLoginView)typeof(ZatodPrototypeView).GetField("loginView",All).GetValue(host);
        void Check(bool value,string why){checks++;if(!value)throw new Exception(why);}
        var editor=typeof(Editor).Assembly;var gameType=editor.GetType("UnityEditor.GameView");var game=EditorWindow.GetWindow(gameType);var selected=gameType.GetProperty("selectedSizeIndex",All);int previous=(int)selected.GetValue(game);
        var sizes=editor.GetType("UnityEditor.GameViewSizes");var singleton=sizes.BaseType.GetProperty("instance",All).GetValue(null);var enumType=editor.GetType("UnityEditor.GameViewSizeGroupType");
        var groupName=EditorUserBuildSettings.activeBuildTarget==BuildTarget.iOS?Enum.GetNames(enumType).First(n=>n=="iOS"||n=="iPhone"):"Standalone";
        var group=sizes.GetMethod("GetGroup").Invoke(singleton,new[]{Enum.Parse(enumType,groupName)});var groupType=group.GetType();int added=0;
        var safe=ui.GetComponentInParent<ZatodSafeAreaRoot>();var safeRect=(RectTransform)safe.transform;
        void Bounds(RectTransform target)
        {
            var corners=new Vector3[4];target.GetWorldCorners(corners);
            foreach(var point in corners){var p=safeRect.InverseTransformPoint(point);Check(p.x>=safeRect.rect.xMin-1&&p.x<=safeRect.rect.xMax+1&&p.y>=safeRect.rect.yMin-1&&p.y<=safeRect.rect.yMax+1,"Outside safe area: "+target.name);}
        }
        void Controls()
        {
            Bounds(ui.Board);foreach(var button in new[]{ui.LoginTab,ui.RegisterTab,ui.ConnectButton,ui.ShowPassword})Bounds((RectTransform)button.transform);
            foreach(var field in new[]{ui.PlayerName,ui.Password,ui.ServerIp})Bounds((RectTransform)field.transform);
            Bounds(ui.Message.rectTransform);if(ui.RegisterMode)Bounds((RectTransform)ui.ConfirmPassword.transform);
            Check(ui.LoginTab.image.sprite!=null&&ui.RegisterTab.image.sprite!=null,"Missing native tab art");
            foreach(var text in ui.Board.GetComponentsInChildren<TextMeshProUGUI>()){text.ForceMeshUpdate();Check(!text.isTextOverflowing,"Overflow text: "+text.name);}
        }
        try
        {
            Check(ui.gameObject.activeSelf,"Login not visible while disconnected");ui.LoginTab.onClick.Invoke();Check(!ui.RegisterMode&&!ui.ConfirmPassword.gameObject.activeSelf,"Login tab controls");
            ui.RegisterTab.onClick.Invoke();Check(ui.RegisterMode&&ui.ConfirmPassword.gameObject.activeSelf,"Register tab controls");
            ui.Password.text=" Keep CASE ";ui.ConfirmPassword.text=" Keep CASE ";Check(ui.Password.inputType==TMP_InputField.InputType.Password,"Password not hidden");
            ui.ShowPassword.onClick.Invoke();Check(ui.Password.inputType==TMP_InputField.InputType.Standard&&ui.ConfirmPassword.inputType==TMP_InputField.InputType.Standard,"Show password");
            ui.ShowPassword.onClick.Invoke();Check(ui.Password.inputType==TMP_InputField.InputType.Password&&ui.Password.text==" Keep CASE ","Hide changed password");
            ui.PlayerName.text="TinBo";ui.ConfirmPassword.text="mismatch";ui.Submit();Check(!NetworkClient.active&&ui.Message.text.Contains("match"),"Mismatch submitted a request");
            ui.Password.text="";ui.Refresh();Check(!ui.ConnectButton.interactable,"Empty password can submit");ui.PlayerName.text="";ui.ConfirmPassword.text="";
            foreach(var pair in new[]{new[]{1600,900},new[]{2436,1125},new[]{2400,1080},new[]{1600,1200}})
            {
                int w=pair[0],h=pair[1];var size=Activator.CreateInstance(editor.GetType("UnityEditor.GameViewSize"),All,null,new object[]{Enum.Parse(editor.GetType("UnityEditor.GameViewSizeType"),"FixedResolution"),w,h,"D39 Login responsive"},null);
                int index=(int)groupType.GetMethod("GetTotalCount").Invoke(group,null);groupType.GetMethod("AddCustomSize").Invoke(group,new[]{size});added++;selected.SetValue(game,index);game.Repaint();
                double end=EditorApplication.timeSinceStartup+8;while(Screen.width!=w||Screen.height!=h){if(EditorApplication.timeSinceStartup>end)throw new TimeoutException("GameView size");await Task.Delay(30);}
                foreach(bool register in new[]{false,true})
                {
                    ui.SelectTab(register);await Task.Delay(250);Canvas.ForceUpdateCanvases();Controls();
                    string path=Path.Combine(output,(register?"register-":"login-")+w+"x"+h+".png");ScreenCapture.CaptureScreenshot(path);await Task.Delay(200);Check(File.Exists(path),"Screenshot not written");
                }
                if(w==2436)
                {
                    safe.enabled=false;var area=ZatodSafeAreaRoot.Normalized(new Rect(132,63,w-264,h-63),w,h);safeRect.anchorMin=area.min;safeRect.anchorMax=area.max;await Task.Delay(200);Controls();
                    ScreenCapture.CaptureScreenshot(Path.Combine(output,"register-safe-area.png"));await Task.Delay(200);safe.enabled=true;
                }
            }
            var result=new{State="PASS",Checks=checks,Tabs=2,Profiles=4,SafeArea=true,PasswordMask=true,ConfirmMismatch=true};File.WriteAllText(Path.Combine(output,"ui.json"),Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));return result;
        }
        finally
        {
            selected.SetValue(game,previous);for(int n=0;n<added;n++)groupType.GetMethod("RemoveCustomSize").Invoke(group,new object[]{(int)groupType.GetMethod("GetTotalCount").Invoke(group,null)-1});safe.enabled=true;ui.Password.text="";ui.ConfirmPassword.text="";ui.SelectTab(false);
        }
    }
}
