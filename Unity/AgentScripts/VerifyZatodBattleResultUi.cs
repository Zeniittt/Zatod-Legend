using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;
public static class VerifyZatodBattleResultUi
{
    const BindingFlags Flags=BindingFlags.Instance|BindingFlags.Static|BindingFlags.Public|BindingFlags.NonPublic;
    public static async Task<object> Run(string pass="pass1")
    {
        if(!Application.isPlaying)throw new Exception("Enter Play Mode first.");
        var connection=UnityEngine.Object.FindAnyObjectByType<ZatodConnection>();if(connection.Connected)throw new Exception("Use disconnected Editor for offline UI fixture.");
        var host=connection.GetComponent<ZatodPrototypeView>();var controller=host.GetComponent<ZatodBattleSceneController>();
        string folder=Path.GetFullPath("../Artifacts/ZatodBattleResultChecks/"+pass);Directory.CreateDirectory(folder);
        var catalog=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.LoadZatod(catalog);var stage=campaign.Stage("chapter_one_stage_1");
        var session=new ZatodPlayerSession(catalog,campaign,Guid.NewGuid().ToString("D"),rollLoot:s=>new List<string>{s.DropItems[0].ItemId,s.DropItems[0].ItemId,s.DropItems[0].ItemId,s.DropItems[1].ItemId,s.DropItems[1].ItemId});
        foreach(var hero in session.Account.HeroDesk)session.DevLevel(hero.HeroInstanceId,40);
        var match=session.BeginCampaign(stage.Id,null,11,"result-ui-"+Guid.NewGuid().ToString("N"));var battle=new ZatodBattleSimulation(match);
        while(!battle.Finished){foreach(var u in battle.Frame().Units.Where(u=>u.Team==0&&u.Alive))battle.RequestUltimate(u.EntityId);battle.Step();}
        var record=session.ValidateCampaign(battle.Replay());
        typeof(ZatodConnection).GetProperty("Snapshot",Flags).SetValue(connection,new ZatodAccountSnapshot{Account=session.Account,LastCampaignReward=session.LastCampaignReward});
        typeof(ZatodConnection).GetProperty("Battle",Flags).SetValue(connection,battle);typeof(ZatodConnection).GetProperty("LastReplay",Flags).SetValue(connection,record);
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        void RequestShot(string file)=>ScreenCapture.CaptureScreenshot(Path.Combine(folder,file+".png"));
        async Task Shot(string file){RequestShot(file);await Task.Delay(180);}
        var assembly=typeof(Editor).Assembly;var viewType=assembly.GetType("UnityEditor.GameView");var view=EditorWindow.GetWindow(viewType);var selected=viewType.GetProperty("selectedSizeIndex",Flags);int oldIndex=(int)selected.GetValue(view);
        var sizesType=assembly.GetType("UnityEditor.GameViewSizes");var sizes=sizesType.BaseType.GetProperty("instance",BindingFlags.Public|BindingFlags.Static).GetValue(null);
        var group=sizesType.GetMethod("GetGroup").Invoke(sizes,new[]{Enum.Parse(assembly.GetType("UnityEditor.GameViewSizeGroupType"),"Standalone")});var groupType=group.GetType();int initialCount=(int)groupType.GetMethod("GetTotalCount").Invoke(group,null);
        async Task Resize(int w,int h)
        {
            var size=Activator.CreateInstance(assembly.GetType("UnityEditor.GameViewSize"),Flags,null,new object[]{Enum.Parse(assembly.GetType("UnityEditor.GameViewSizeType"),"FixedResolution"),w,h,"ZatodResultReview "+w+"x"+h},null);
            int index=(int)groupType.GetMethod("GetTotalCount").Invoke(group,null);groupType.GetMethod("AddCustomSize").Invoke(group,new[]{size});selected.SetValue(view,index);view.Repaint();
            await Unity.Pipeline.Scripting.Wait.Until(()=>Screen.width==w && Screen.height==h,timeoutMs:8000,because:"result UI resolution");await Task.Delay(200);
        }
        string error=null;var profiles=new List<object>();int firstChestCount=-1;
        Action firstCapture=()=>{if(controller.Phase==ZatodScenePhase.InBattle && firstChestCount<0){firstChestCount=controller.Stage.GetComponent<ZatodBattleLootView>()?.VisibleChestCount??0;RequestShot("01-boss-chests");}};
        controller.Changed+=firstCapture;
        try
        {
            await Resize(1600,900);typeof(ZatodPrototypeView).GetMethod("OnMatch",Flags).Invoke(host,null);
            typeof(ZatodPrototypeView).GetMethod("OnReplay",Flags).Invoke(host,null);
            Check(typeof(ZatodPrototypeView).GetField("replay",Flags).GetValue(host)==null,"Current battle acknowledgement became a replay while scene was loading");
            await Unity.Pipeline.Scripting.Wait.Until(()=>controller.Phase==ZatodScenePhase.InBattle,timeoutMs:10000,because:"result battle scene");
            var loot=controller.Stage.GetComponent<ZatodBattleLootView>();Check(firstChestCount>0,"Boss chests were not rendered on their first frame");
            var result=(ZatodBattleResultView)typeof(ZatodPrototypeView).GetField("battleResult",Flags).GetValue(host);
            await Unity.Pipeline.Scripting.Wait.Until(()=>result.gameObject.activeSelf,timeoutMs:10000,because:"validated native reward popup");await Task.Delay(1400);
            Check(result.RewardCount==5 && session.Account.Inventory.Count==5,"Popup receipt differs from actual reward");Check(result.TeamExp.text=="EXP 0/0" && result.GoldValue.text=="?","Placeholder values changed");
            Check(result.Report.Count==record.Statistics.Count && result.Report.Sum(s=>s.Kills)>0,"Validated statistics missing");
            Check(loot.Collected==5 && loot.VisibleChestCount==0,"Chests not collected exactly once");await Shot("02-reward-popup");
            result.StatisticsButton.onClick.Invoke();await Task.Delay(220);var stats=result.StatisticsView;Check(stats.gameObject.activeSelf,"Statistics button did nothing");
            for(int tab=0;tab<4;tab++)
            {
                stats.Tabs[tab].onClick.Invoke();await Task.Delay(180);Check(stats.SelectedTab==tab && stats.RowCount==record.Statistics.Count,"Statistics tab data mismatch");await Shot("03-statistics-"+tab);
            }
            stats.RightScroll.verticalNormalizedPosition=0;await Task.Delay(180);Check(stats.RightContent.rect.height>stats.RightScroll.viewport.rect.height,"Enemy scroll fixture did not overflow");await Shot("04-enemies-scrolled");
            stats.Close.onClick.Invoke();
            foreach(var pair in new[]{new[]{2436,1125},new[]{2400,1080},new[]{1600,1200}})
            {
                await Resize(pair[0],pair[1]);result.Fit();await Task.Delay(120);
                var safe=(RectTransform)result.transform;
                foreach(var r in new[]{result.Continue.GetComponent<RectTransform>(),result.StatisticsButton.GetComponent<RectTransform>(),result.Banner})
                {var corners=new Vector3[4];r.GetWorldCorners(corners);foreach(var corner in corners)Check(safe.rect.Contains(safe.InverseTransformPoint(corner)),"Reward element outside safe area: "+r.name);}
                await Shot("05-reward-"+pair[0]+"x"+pair[1]);result.StatisticsButton.onClick.Invoke();await Task.Delay(120);Check(stats.RightScroll.verticalNormalizedPosition>.99f,"Statistics did not reopen at the top");
                foreach(var b in stats.Tabs.Concat(new[]{stats.Close}))
                {var corners=new Vector3[4];b.GetComponent<RectTransform>().GetWorldCorners(corners);foreach(var corner in corners)Check(((RectTransform)stats.transform).rect.Contains(((RectTransform)stats.transform).InverseTransformPoint(corner)),"Stats control outside safe area");}
                await Shot("06-stats-"+pair[0]+"x"+pair[1]);await Task.Delay(120);stats.Close.onClick.Invoke();profiles.Add(new{Width=pair[0],Height=pair[1]});
            }
            result.Continue.onClick.Invoke();await Unity.Pipeline.Scripting.Wait.Until(()=>controller.Phase==ZatodScenePhase.World,timeoutMs:10000,because:"return from result");
            Check(!result.gameObject.activeSelf && SceneManager.sceneCount==1,"Continue leaked UI/battle scene");Check(session.Account.Inventory.Count==5,"Continue granted twice");
        }
        catch(Exception e){error=e.ToString();}
        finally
        {
            controller.Changed-=firstCapture;selected.SetValue(view,oldIndex);
            while((int)groupType.GetMethod("GetTotalCount").Invoke(group,null)>initialCount){int count=(int)groupType.GetMethod("GetTotalCount").Invoke(group,null);groupType.GetMethod("RemoveCustomSize").Invoke(group,new object[]{count-1});}
            if(controller.OccupiesClient)controller.Leave();
        }
        var summary=new{Result=error==null?"PASS":"FAIL",Checks=checks,Error=error,Profiles=profiles,Digest=record.Digest,ReportRows=record.Statistics.Count,RewardItems=5,Folder=folder};
        File.WriteAllText(Path.Combine(folder,"result.json"),Newtonsoft.Json.JsonConvert.SerializeObject(summary,Newtonsoft.Json.Formatting.Indented));if(error!=null)throw new Exception(error);return summary;
    }
}
