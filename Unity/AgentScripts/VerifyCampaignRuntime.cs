using System;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using Zatod.Networking;
using Zatod.Presentation;

public static class VerifyCampaignRuntime
{
    public static async Task<object> Run()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var view=UnityEngine.Object.FindAnyObjectByType<CampaignView>();var formation=view.GetComponent<FormationView>();var arena=view.GetComponent<ArenaView>();var connection=view.GetComponent<ArenaConnection>();
        async Task Wait(Func<bool> condition,string why)
        {var end=DateTime.UtcNow.AddSeconds(25);while(!condition() && DateTime.UtcNow<end)await Task.Delay(40);Check(condition(),why+" / "+connection.Status);}
        Button Button(string name)=>UnityEngine.Object.FindObjectsByType<Button>(FindObjectsInactive.Include).Single(b=>b.name==name);
        async Task Click(string name)
        {
            await Task.Delay(60);var b=Button(name);Check(b.gameObject.activeInHierarchy && b.interactable,"Disabled "+name);Canvas.ForceUpdateCanvases();
            var rect=(RectTransform)b.transform;var center=RectTransformUtility.WorldToScreenPoint(null,rect.TransformPoint(rect.rect.center));
            var pointer=new PointerEventData(EventSystem.current){position=center};var hits=new System.Collections.Generic.List<RaycastResult>();EventSystem.current.RaycastAll(pointer,hits);
            Check(hits.Count>0 && (hits[0].gameObject==b.gameObject || hits[0].gameObject.transform.IsChildOf(b.transform)),"Obstructed button "+name);
            ExecuteEvents.Execute(b.gameObject,pointer,ExecuteEvents.pointerClickHandler);await Task.Delay(60);
        }
        connection.Connect();await Wait(()=>connection.Connected && connection.CampaignProgressReady,"Dedicated server unavailable");
        view.Show();await Task.Delay(80);
        Check(!Mirror.NetworkServer.active,"Client became host");Check(view.IsVisible && !formation.IsVisible && !arena.IsVisible,"Initial map visibility");
        var nodes=UnityEngine.Object.FindObjectsByType<CampaignNodeGraphic>(FindObjectsInactive.Include);Check(nodes.Length==5,"Expected five encounter nodes");
        Canvas.ForceUpdateCanvases();foreach(var node in nodes)Check(!node.canvasRenderer.cull && node.canvasRenderer.GetMesh().vertexCount>20,"Undrawn map node");
        await Click("CampaignStage-chapter_1_stage_2");Check(view.PreviewVisible && !Button("CampaignChooseSquad").interactable,"Locked stage must preview but not launch");await Click("StagePreviewClose");
        for(int i=1;i<=5;i++)
        {
            if(!view.PreviewVisible)await Click("CampaignStage-chapter_1_stage_"+i);
            Check(view.SelectedStageId=="chapter_1_stage_"+i,"Next stage selection");
            var cards=GameObject.Find("EnemyPreview");Check(cards.transform.childCount==5,"Preview lacks five enemies");
            foreach(var image in cards.GetComponentsInChildren<Image>())Check(image.sprite!=null,"Missing Monster portrait");
            await Click("CampaignChooseSquad");Check(formation.IsVisible && !view.IsVisible && formation.VisibleHeroCount==5,"Campaign roster not five owned Heroes");
            if(i==1)
            {
                Check(!Button("FormationBattle").interactable,"Empty party allowed");
                await Click("FormationBack");Check(view.IsVisible && !formation.IsVisible,"Formation back failed");
                await Click("CampaignStage-chapter_1_stage_1");await Click("CampaignChooseSquad");
            }
            foreach(var hero in view.Character.HeroDesk)if(!formation.Selection.Contains(hero.HeroInstanceId))formation.ToggleHero(hero.HeroInstanceId);
            Check(formation.Selection.Selected.Count==5,"Could not select five Heroes");
            string previous=connection.LastBattleId;await Click("FormationBattle");
            await Wait(()=>connection.LastBattleId!=previous && !connection.Busy && arena.IsVisible,"No battle presentation");
            Check(arena.Record.campaignStageId=="chapter_1_stage_"+i && arena.Record.initial.Count==10 && arena.Record.winner==0,"Wrong encounter/result");
            if(arena.Playing)arena.TogglePlayback();arena.Seek(Mathf.Min(1,arena.Record.DurationSeconds));await Task.Delay(60);Canvas.ForceUpdateCanvases();
            Check(UnityEngine.Object.FindObjectsByType<ReplaySprite>(FindObjectsInactive.Exclude).Count(s=>s.GetComponent<Image>().sprite!=null)>=10,"Hero/Monster sprite bodies missing");
            arena.Seek(arena.Record.DurationSeconds);await Wait(()=>view.ResultVisible,"Result popup absent");
            await Wait(()=>view.ClearedCount==i,"Progress not committed");
            if(i<5){await Task.Delay(1100);await Click("ResultNext");}else Check(!Button("ResultNext").interactable,"Chapter5 next not disabled");
        }
        await Click("ResultReplay");Check(arena.IsVisible && !view.IsVisible && arena.Playhead<1 && arena.Playing,"Replay button failed");
        await Click("BattleCampaignBack");Check(view.IsVisible && view.ClearedCount==5,"Return map/progress failed");
        await Click("CampaignBack");Check(view.GetComponent<HeroRosterView>().IsVisible,"Map back to roster failed");await Click("OpenCampaign");
        connection.Disconnect();await Wait(()=>!connection.Connected && !connection.Busy,"Disconnect failed");await Click("CampaignConnect");
        await Wait(()=>connection.Connected && connection.CampaignProgressReady && view.ClearedCount==5,"Reconnect lost progress");
        Check(!Mirror.NetworkServer.active,"Client authority changed");
        return new{passed=true,checks,stages=5,heroes=5,monsters=5,network="dedicated",frames=Time.frameCount};
    }
}
