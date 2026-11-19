using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.EventSystems;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Networking;
using Zatod.Presentation;

public static class VerifyLiveCombatUi
{
    public static async Task<object> Run()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var view=UnityEngine.Object.FindAnyObjectByType<CampaignView>();var arena=view.GetComponent<ArenaView>();var connection=view.GetComponent<ArenaConnection>();var formation=view.GetComponent<FormationView>();
        var heroes=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.Load(heroes);var account=campaign.CreateDemoCharacter(heroes);string config=JsonUtility.ToJson(heroes.Data);
        UnityEngine.UI.Button Button(string name)=>UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>(FindObjectsInactive.Include).Single(b=>b.name==name);
        async Task Wait(Func<bool> predicate,string why,int seconds=25)
        {var end=DateTime.UtcNow.AddSeconds(seconds);while(!predicate() && DateTime.UtcNow<end)await Task.Delay(40);Check(predicate(),why+" / "+connection.Status);}
        async Task Click(UnityEngine.UI.Button button)
        {
            Check(button.gameObject.activeInHierarchy && button.interactable,"Disabled "+button.name);Canvas.ForceUpdateCanvases();
            var r=(RectTransform)button.transform;var p=RectTransformUtility.WorldToScreenPoint(null,r.TransformPoint(r.rect.center));var pointer=new PointerEventData(EventSystem.current){position=p};
            var hits=new System.Collections.Generic.List<RaycastResult>();EventSystem.current.RaycastAll(pointer,hits);
            Check(hits.Count>0 && (hits[0].gameObject==button.gameObject || hits[0].gameObject.transform.IsChildOf(button.transform)),"Obstructed "+button.name);
            ExecuteEvents.Execute(button.gameObject,pointer,ExecuteEvents.pointerClickHandler);await Task.Delay(80);
        }
        var legacy=new BattleSimulation(Guid.NewGuid().ToString("N"),"legacy HUD",55,PrototypeTeams.Create("balanced"),maximumTicks:3).RunToCompletion();legacy.loadouts=null;
        arena.LoadSandbox(legacy);if(arena.Playing)arena.TogglePlayback();await Task.Delay(80);
        Check(arena.HeroHudCount==5 && !Button("HeroUltimate-1").interactable,"Legacy replay without loadouts failed");
        foreach(int count in new[]{1,2})
        {
            var setup=CampaignBattleFactory.Prepare(campaign,heroes,account,"chapter_1_stage_1",account.HeroDesk.Take(count).Select(h=>h.HeroInstanceId));
            var record=new BattleSimulation(Guid.NewGuid().ToString("N"),"HUD count",55,setup.Fighters,setup.Loadouts,3).RunToCompletion();
            arena.LoadSandbox(record);if(arena.Playing)arena.TogglePlayback();await Task.Delay(80);Canvas.ForceUpdateCanvases();
            Check(arena.HeroHudCount==count,"HUD count differs from selected squad");Check(!Button("HeroUltimate-1").interactable,"Replay/Sandbox allows live command");
        }
        connection.Connect();await Wait(()=>connection.Connected && connection.CampaignProgressReady,"Dedicated connection");
        Check(view.ManualUltimates,"Campaign not configured for manual ultimates");
        view.Show();view.SelectStage("chapter_1_stage_1");view.ShowFormation();
        foreach(var hero in view.Character.HeroDesk)if(!formation.Selection.Contains(hero.HeroInstanceId))formation.ToggleHero(hero.HeroInstanceId);
        int accepted=0;Action<UltimateResponse> ack=r=>{if(r.accepted)accepted++;};connection.UltimateResponded+=ack;
        await Task.Delay(80);await Click(Button("FormationBattle"));
        await Wait(()=>arena.LiveMode && connection.LiveBattleActive && arena.IsVisible,"No real-time Campaign battle");
        Check(arena.Record.manualUltimateTeams==1 && arena.HeroHudCount==5,"Manual mode/five portraits");
        Check(arena.Record.initial.First(f=>f.team==0).y==arena.Record.initial.First(f=>f.team==1).y,"First opponent is below Leenald");
        await Task.Delay(80);Canvas.ForceUpdateCanvases();
        foreach(var b in UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>(FindObjectsInactive.Exclude).Where(b=>b.name.StartsWith("HeroUltimate-")))
        {var image=b.transform.Find("Portrait").GetComponent<UnityEngine.UI.Image>();Check(image.sprite!=null && image.canvasRenderer.GetMesh().vertexCount>=4,"Undrawn portrait");Check(!b.interactable,"Empty energy enabled ultimate");}
        var f1=UnityEngine.Object.FindObjectsByType<RectTransform>(FindObjectsInactive.Exclude).Single(r=>r.name=="Fighter_1");
        var e1=UnityEngine.Object.FindObjectsByType<RectTransform>(FindObjectsInactive.Exclude).Single(r=>r.name=="Fighter_101");Check(Mathf.Abs(f1.anchoredPosition.y-e1.anchoredPosition.y)<.01f,"Enemy first ground depth mismatch");
        UnityEngine.UI.Button Ready()=>UnityEngine.Object.FindObjectsByType<UnityEngine.UI.Button>(FindObjectsInactive.Exclude).FirstOrDefault(b=>b.name.StartsWith("HeroUltimate-") && b.interactable);
        await Wait(()=>Ready()!=null || !arena.LiveMode,"No Hero filled energy",80);Check(arena.LiveMode && Ready()!=null,"Battle ended without a ready Ultimate");
        await Task.Delay(300);Check(!arena.Record.events.Any(e=>e.actorId<100 && e.kind==BattleEventKind.Action && e.state.action==BattleAction.Ultimate),"Ultimate auto-cast without click");
        Check(arena.Record.DurationSeconds-arena.Playhead<.6f,"Live presentation fell behind server time");
        var ready=Ready();int fighterId=int.Parse(ready.name.Substring("HeroUltimate-".Length));Check(((RectTransform)ready.transform.Find("Energy")).localScale.x>=.999f,"Ready energy bar not full");
        await Click(ready);Check(!ready.interactable,"Portrait did not acknowledge the click immediately");await Wait(()=>accepted>0,"Server did not accept portrait click");
        await Wait(()=>arena.Record.events.Any(e=>e.actorId==fighterId && e.kind==BattleEventKind.Action && e.state.action==BattleAction.Ultimate),"Click did not activate Ultimate");
        await Wait(()=>arena.Timeline.States[fighterId].energy<100,"Energy was not spent");Check(!Button("HeroUltimate-"+fighterId).interactable,"Spent energy button remained enabled");
        var finish=DateTime.UtcNow.AddSeconds(100);
        while(arena.LiveMode && DateTime.UtcNow<finish)
        {var b=Ready();if(b!=null)await Click(b);else await Task.Delay(80);}
        Check(!arena.LiveMode && !connection.Busy && !connection.LiveBattleActive,"Battle not committed");await Wait(()=>view.ResultVisible,"Result view not shown after completion");
        Check(arena.Record.events.Any(e=>e.kind==BattleEventKind.UltimateQueued),"Input absent from replay");Check(!Mirror.NetworkServer.active,"Client started a host");
        Directory.CreateDirectory("../Artifacts/ManualUltimateChecks");File.WriteAllBytes("../Artifacts/ManualUltimateChecks/ui-live.arena.gz",ReplayArchive.Encode(arena.Record));
        string json=JsonUtility.ToJson(arena.Record);await Click(Button("ResultReplay"));Check(!arena.LiveMode && !Button("HeroUltimate-1").interactable,"Replay still accepts inputs");
        arena.Seek(0);await Task.Delay(80);Check(arena.HeroHudCount==5 && JsonUtility.ToJson(arena.Record)==json,"Replay altered battle/HUD");
        Check(JsonUtility.ToJson(heroes.Data)==config,"UI wrote saved config");connection.UltimateResponded-=ack;
        view.Show();view.SelectStage("chapter_1_stage_1");view.ShowFormation();
        return new{passed=true,checks,acceptedInputs=accepted,battle=connection.LastBattleId,counts="1/2/5",firstEnemyDepth="matches Leenald",server=connection.Port};
    }
}
