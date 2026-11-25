// Run with Unity Pipeline script run in the isolated build workspace.
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using Zatod.Combat;
using Zatod.Networking;
using Zatod.Presentation;

public static class D34HudResponsive
{
    const BindingFlags All = BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic;
    static void Require(bool ok, string reason)
    {
        if (!ok) throw new InvalidOperationException(reason);
    }
    static async Task Until(Func<bool> ready, string reason)
    {
        var limit = EditorApplication.timeSinceStartup + 8;
        while (!ready())
        {
            if (EditorApplication.timeSinceStartup > limit) throw new TimeoutException(reason);
            await Task.Delay(45);
        }
    }
    public static async Task<object> Run(string archive, string output)
    {
        Require(EditorApplication.isPlaying && Application.dataPath.Contains("/Artifacts/D35BuildWorkspace/"),
            "Use the isolated validation Editor in Play Mode.");
        var host = UnityEngine.Object.FindAnyObjectByType<ZatodPrototypeView>();
        var scenes = host.GetComponent<ZatodBattleSceneController>();
        var hud = (ZatodBattleHudLayout)typeof(ZatodPrototypeView).GetField("hud",All).GetValue(host);
        var replay = (ZatodReplay)typeof(ReplayArchive).GetMethod("DecodePayload",All).MakeGenericMethod(typeof(ZatodReplay))
            .Invoke(null,new object[]{File.ReadAllBytes(archive)});
        typeof(ZatodPrototypeView).GetMethod("LoadReplay",All).Invoke(host,new object[]{replay});
        await Until(()=>scenes.Phase==ZatodScenePhase.InBattle,"Battle scene did not load");
        typeof(ZatodPrototypeView).GetMethod("Seek",All).Invoke(host,new object[]{Math.Min(32,replay.EndTick/3)});

        var activeGroup = EditorUserBuildSettings.activeBuildTarget;
        var editor = typeof(Editor).Assembly;
        var gameViewType = editor.GetType("UnityEditor.GameView");
        var gameView = EditorWindow.GetWindow(gameViewType);
        var selected = gameViewType.GetProperty("selectedSizeIndex",All);
        int oldIndex = (int)selected.GetValue(gameView);
        var sizesType = editor.GetType("UnityEditor.GameViewSizes");
        var singleton = sizesType.BaseType.GetProperty("instance",All).GetValue(null);
        var enumType = editor.GetType("UnityEditor.GameViewSizeGroupType");
        var groupName = activeGroup==BuildTarget.iOS ? Enum.GetNames(enumType).First(n=>n=="iOS" || n=="iPhone") : "Standalone";
        var group = sizesType.GetMethod("GetGroup").Invoke(singleton,new[]{Enum.Parse(enumType,groupName)});
        var groupType = group.GetType();
        var total = groupType.GetMethod("GetTotalCount");
        int initialTotal = (int)total.Invoke(group,null);
        var safe = hud.GetComponentInParent<ZatodSafeAreaRoot>();
        var safeRect = (RectTransform)safe.transform;
        int checks = 0;
        var profiles = new List<object>();
        void Check(bool passed,string why) { checks++;Require(passed,why); }
        void Bounds(RectTransform target)
        {
            var corners = new Vector3[4];
            target.GetWorldCorners(corners);
            var bounds=safeRect.rect;
            foreach(var c in corners)
            {
                var local = safeRect.InverseTransformPoint(c);
                Check(local.x>=bounds.xMin-1 && local.x<=bounds.xMax+1 && local.y>=bounds.yMin-1 && local.y<=bounds.yMax+1,
                    "Outside safe layout: "+target.name+" at "+Screen.width+"x"+Screen.height+" / "+local+" / "+bounds);
            }
        }
        void HudBounds()
        {
            var cards = hud.Cards.Where(c=>c.Root.gameObject.activeSelf).ToArray();
            Check(cards.Length==5,"Expected full five Hero HUD from the archived run.");
            foreach(var card in cards)
            {
                Check(card.Portrait.sprite!=null && card.StarIcons.Any(x=>x.gameObject.activeSelf),"Missing snapshot portrait or stars.");
                Bounds(card.Root);
                Bounds(card.Health.rectTransform);
                Bounds(card.Energy.rectTransform);
                Bounds(card.Ready.rectTransform);
                Check(!card.UltimateSignal.blocksRaycasts,"The cast signal can intercept portrait taps.");
            }
            Bounds((RectTransform)hud.Exit.transform);
            Bounds(hud.Time.rectTransform);
            Bounds(hud.Wave.rectTransform);
            Bounds(hud.ReplayControls);
        }
        try
        {
            foreach(var pair in new[]{new[]{1600,900},new[]{2436,1125},new[]{2400,1080},new[]{1600,1200}})
            {
                int width=pair[0],height=pair[1];
                var size=Activator.CreateInstance(editor.GetType("UnityEditor.GameViewSize"),All,null,
                    new object[]{Enum.Parse(editor.GetType("UnityEditor.GameViewSizeType"),"FixedResolution"),width,height,"D34 HUD fixture"},null);
                int index=(int)groupType.GetMethod("GetTotalCount").Invoke(group,null);
                groupType.GetMethod("AddCustomSize").Invoke(group,new[]{size});selected.SetValue(gameView,index);gameView.Repaint();
                await Until(()=>Screen.width==width && Screen.height==height,"Game view did not resize");
                await Task.Delay(180);
                HudBounds();
                foreach(var point in new[]{new Vector3(-7,-.7f),Vector3.zero,new Vector3(7,2)})
                {
                    var fromHud=RectTransformUtility.WorldToScreenPoint(null,hud.Actors.TransformPoint(point*100));
                    var fromStage=scenes.Stage.BattleCamera.WorldToScreenPoint(point);
                    Check(Vector2.Distance(fromHud,fromStage)<1.5f,"HUD world projection drift at "+width+"x"+height);
                }
                profiles.Add(new{Width=width,Height=height,Area="Editor"});
                if(width==2436)
                {
                    safe.enabled=false;
                    var area=ZatodSafeAreaRoot.Normalized(new Rect(132,63,width-264,height-63),width,height);
                    safeRect.anchorMin=area.min;safeRect.anchorMax=area.max;
                    await Task.Delay(180);
                    HudBounds();
                    profiles.Add(new{Width=width,Height=height,Area="Simulated landscape cutouts"});
                    safe.enabled=true;safe.Apply();
                }
            }
        }
        finally
        {
            safe.enabled=true;safe.Apply();
            selected.SetValue(gameView,oldIndex);
            var remove = groupType.GetMethod("RemoveCustomSize");
            for(int index=(int)total.Invoke(group,null)-1; index>=initialTotal; index--)
                remove.Invoke(group,new object[]{index});
            typeof(ZatodPrototypeView).GetMethod("Show",All).Invoke(host,new object[]{"campaign"});
        }
        Require((int)total.Invoke(group,null)==initialTotal,"Temporary Game View sizes were not restored.");
        var result=new{State="PASS",Checks=checks,Profiles=profiles,RestoredGameView=true};
        File.WriteAllText(output,Newtonsoft.Json.JsonConvert.SerializeObject(result,Newtonsoft.Json.Formatting.Indented));
        return result;
    }
}
