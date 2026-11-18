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
            float deadline=Time.realtimeSinceStartup+100;
            while(!connection.CampaignProgressReady && Time.realtimeSinceStartup<deadline)yield return null;
            if(!connection.Connected || !connection.CampaignProgressReady){Fail("Initial connection/progress");yield break;}
            var heroes=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.Load(heroes);
            string[] ids=campaign.CreateDemoCharacter(heroes).HeroDesk.Select(h=>h.HeroInstanceId).ToArray();
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
    }
}
