using System;
using System.Collections;
using System.Linq;
using Mirror;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;

namespace Zatod.Networking
{
    // Separate-process integration test. Never starts a server in the client.
    public sealed class CampaignSmokeClient : MonoBehaviour
    {
        IEnumerator Start()
        {
            var connection=GetComponent<ArenaConnection>();
            if(Array.IndexOf(Environment.GetCommandLineArgs(),"--campaign-live-smoke")>=0){yield return Live(connection);yield break;}
            float deadline=Time.realtimeSinceStartup+100;
            while(!connection.CampaignProgressReady && Time.realtimeSinceStartup<deadline)yield return null;
            if(!connection.Connected || !connection.CampaignProgressReady){Fail("Initial connection/progress");yield break;}
            var heroes=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.Load(heroes);
            string[] ids=campaign.CreateDemoCharacter(heroes).HeroDesk.Take(5).Select(h=>h.HeroInstanceId).ToArray();
            if(Array.IndexOf(Environment.GetCommandLineArgs(),"--campaign-berthaxe-smoke")>=0)
                ids=ids.Take(4).Concat(new[]{"campaign-berthaxe"}).ToArray();
            bool resume=Array.IndexOf(Environment.GetCommandLineArgs(),"--campaign-resume")>=0;
            if(resume && connection.CampaignClearedStageIds.Length!=5){Fail("Restart lost progress");yield break;}
            foreach(var stage in campaign.Data.Chapters[0].Stages)
            {
                string id;
                if(resume)
                {
                    var saved=connection.Catalog.FirstOrDefault(r=>r.opponentId=="campaign:"+stage.Id);
                    if(string.IsNullOrEmpty(saved.battleId)){Fail("Restart lost stage replay "+stage.Id);yield break;}
                    id=saved.battleId;connection.LoadReplay(id);
                }
                else id=connection.ChallengeCampaign(stage.Id,ids);
                while((connection.LastBattleId!=id || connection.Busy) && Time.realtimeSinceStartup<deadline)yield return null;
                var record=connection.LastRecord;
                if(record==null || record.battleId!=id || record.campaignStageId!=stage.Id || record.winner!=0 || record.initial.Count!=10)
                {Fail("Stage did not produce winning 5v5 replay: "+stage.Id+" "+connection.Status);yield break;}
                foreach(var hero in record.initial.Where(f=>f.team==0))
                    if(!record.events.Any(e=>e.actorId==hero.id && e.kind==BattleEventKind.Action && (e.state.action==BattleAction.Attack || e.state.action==BattleAction.Ultimate)))
                    {Fail("Hero never attacked: "+hero.name+" stage="+stage.Id);yield break;}
                if(record.loadouts.Where(l=>l.kind==CombatantKind.Hero).Any(l=>l.hero.Skills.Count!=4))
                {Fail("Campaign demo did not unlock four skills");yield break;}
                var timeline=new ReplayTimeline(record);timeline.Seek(record.durationTicks);
                foreach(var state in record.snapshots.Last().fighters)
                    if(JsonUtility.ToJson(state)!=JsonUtility.ToJson(timeline.States[state.id])){Fail("Replay final differs");yield break;}
                if(!resume)
                {
                    string json=JsonUtility.ToJson(record);int received=0;Action<BattleRecord> onReplay=_=>received++;connection.ReplayReceived+=onReplay;
                    connection.ChallengeCampaign(stage.Id,ids,id);
                    while(received==0 && Time.realtimeSinceStartup<deadline)yield return null;
                    connection.ReplayReceived-=onReplay;
                    if(received!=1 || JsonUtility.ToJson(connection.LastRecord)!=json){Fail("Retry changed committed result");yield break;}
                    yield return new WaitForSecondsRealtime(1.1f);
                }
                Debug.Log("[CampaignSmoke] stage="+stage.Id+" battle="+id+" winner="+record.winner);
            }
            connection.RefreshCatalog();yield return new WaitForSecondsRealtime(.3f);
            if(NetworkServer.active || connection.CampaignClearedStageIds.Length!=5){Fail("Client authority/progress");yield break;}
            Debug.Log("[CampaignSmoke] PASS stages=5 heroes=5 resume="+resume+" serverActive="+NetworkServer.active);
            Application.Quit(0);
        }
        static void Fail(string reason){Debug.LogError("[CampaignSmoke] FAIL "+reason);Application.Quit(1);}

        IEnumerator Live(ArenaConnection connection)
        {
            float deadline=Time.realtimeSinceStartup+110;
            while(!connection.CampaignProgressReady && Time.realtimeSinceStartup<deadline)yield return null;
            if(!connection.Connected){Fail("Live connection failed");yield break;}
            var heroes=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.Load(heroes);
            // A full Purple squad clears stage 1 before filling energy; one Hero isolates manual input.
            string[] ids=campaign.CreateDemoCharacter(heroes).HeroDesk.Take(1).Select(h=>h.HeroInstanceId).ToArray();
            int frames=0,accepted=0;connection.LiveFrameReceived+=_=>frames++;connection.UltimateResponded+=r=>{if(r.accepted)accepted++;};
            float start=Time.realtimeSinceStartup;string id=connection.ChallengeCampaign("chapter_1_stage_1",ids,manualUltimates:true);
            int readyAt=-1;bool sentAny=false;var pending=new System.Collections.Generic.HashSet<int>();
            while(Time.realtimeSinceStartup<deadline)
            {
                var record=connection.LastRecord;
                if(record!=null && record.battleId==id)
                {
                    if(!record.battleInProgress && !connection.Busy)break;
                    var timeline=new ReplayTimeline(record);timeline.Seek(record.durationTicks);var states=timeline.States;
                    if(readyAt<0 && states.Values.Any(f=>f.team==0 && f.energy>=100))readyAt=record.durationTicks;
                    if(!sentAny && record.events.Any(e=>e.actorId<100 && e.kind==BattleEventKind.Action && e.state.action==BattleAction.Ultimate))
                    {Fail("Live ultimate activated without input");yield break;}
                    if(readyAt>=0 && record.durationTicks>=readyAt+20)
                    {
                        foreach(var f in states.Values.Where(f=>f.team==0))
                        {
                            if(f.energy<100)pending.Remove(f.id);
                            if(f.Alive && f.energy>=100 && f.stunUntil<=record.durationTicks && !f.ultimateQueued && pending.Add(f.id))
                            {connection.RequestUltimate(f.id);sentAny=true;}
                        }
                    }
                }
                yield return null;
            }
            var final=connection.LastRecord;
            if(final==null || final.battleId!=id || final.battleInProgress || connection.Busy || frames<5 || accepted<1 || Mirror.NetworkServer.active)
            {Fail("Live completion/input/authority check: "+connection.Status);yield break;}
            if(Time.realtimeSinceStartup-start<final.combatEndTick/(float)final.tickRate-.5f){Fail("Battle was precomputed");yield break;}
            foreach(var cast in final.events.Where(e=>e.actorId<100 && e.kind==BattleEventKind.Action && e.state.action==BattleAction.Ultimate))
                if(!final.events.Any(e=>e.actorId==cast.actorId && e.kind==BattleEventKind.UltimateQueued && e.tick<=cast.tick)){Fail("Uncommanded ultimate");yield break;}
            string json=JsonUtility.ToJson(final);int loaded=0;connection.ReplayReceived+=_=>loaded++;connection.LoadReplay(id);
            while(loaded==0 && Time.realtimeSinceStartup<deadline)yield return null;
            if(loaded!=1 || JsonUtility.ToJson(connection.LastRecord)!=json){Fail("Manual battle reload differs");yield break;}
            Debug.Log("[CampaignLiveSmoke] PASS battle="+id+" frames="+frames+" inputs="+accepted+" winner="+final.winner+" serverActive="+Mirror.NetworkServer.active);
            Application.Quit(0);
        }
    }
}
