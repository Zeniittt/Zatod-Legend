using System;
using System.Linq;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Networking;

public static class VerifyManualUltimates
{
    public static object Run()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var heroes=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.Load(heroes);string config=JsonUtility.ToJson(heroes.Data);
        foreach(string heroId in campaign.Data.StarterHeroIds)
        {
            var account=campaign.CreateDemoCharacter(heroes);
            account.HeroDesk=campaign.Data.StarterHeroIds.Select(id=>heroes.CreateHero(id,"campaign-"+id)).ToList();
            CampaignBattleSetup Setup(int energy=100,int stun=0,bool dead=false)
            {
                var setup=CampaignBattleFactory.Prepare(campaign,heroes,account,"chapter_1_stage_1",new[]{"campaign-"+heroId});
                foreach(var f in setup.Fighters){f.maxHp=f.hp=100000;if(f.team==1)f.attack=1;}
                setup.Fighters[0].energy=energy;setup.Fighters[0].stunUntil=stun;if(dead)setup.Fighters[0].hp=0;
                return setup;
            }
            BattleSimulation Sim(CampaignBattleSetup setup,int mask=1)=>new BattleSimulation(Guid.NewGuid().ToString("N"),"manual-test",55,setup.Fighters,setup.Loadouts,200,mask);
            var data=Setup();Check(data.Fighters[0].y==data.Fighters.First(f=>f.team==1).y,"Enemy first unit must share Leenald depth");
            var sim=Sim(data);var cursor=new LiveBattleCursor();BattleRecord streamed=null;long deltaBytes=0,fullBytes=0;
            void Transfer()
            {
                if(sim.Finished || sim.CurrentTick%2!=0)return;
                var bytes=LiveBattleCodec.Encode(sim.CurrentRecord,cursor);streamed=LiveBattleCodec.Decode(bytes,streamed);
                deltaBytes+=bytes.Length;fullBytes+=ReplayArchive.Encode(sim.CurrentRecord).Length;
                Check(JsonUtility.ToJson(streamed)==JsonUtility.ToJson(sim.CurrentRecord),"Live delta differs "+heroId+" tick="+sim.CurrentTick);
            }
            for(int i=0;i<40;i++){sim.Step();Transfer();}
            Check(sim.CurrentRecord.manualUltimateTeams==1 && sim.CurrentRecord.battleInProgress,"Live mode metadata");
            Check(!sim.CurrentRecord.events.Any(e=>e.actorId==1 && e.kind==BattleEventKind.Action && e.state.action==BattleAction.Ultimate),"Ultimate auto-cast before click: "+heroId);
            Check(!sim.RequestUltimate(999) && !sim.RequestUltimate(101),"Invalid/hostile ultimate accepted");
            Check(!Sim(Setup(0)).RequestUltimate(1),"Insufficient energy accepted");
            Check(!Sim(Setup(stun:100)).RequestUltimate(1),"Stunned hero accepted");Check(!Sim(Setup(dead:true)).RequestUltimate(1),"Dead hero accepted");
            var partial=ReplayArchive.Decode(ReplayArchive.Encode(sim.CurrentRecord),true);Check(partial.battleInProgress,"Live transfer decode");
            bool rejected=false;try{ReplayArchive.Decode(ReplayArchive.Encode(sim.CurrentRecord));}catch(System.IO.InvalidDataException){rejected=true;}Check(rejected,"Unfinished battle accepted as saved replay");
            Check(sim.RequestUltimate(1),"Ready ultimate refused: "+heroId);Check(!sim.RequestUltimate(1),"Duplicate click accepted");
            while(!sim.Finished){sim.Step();Transfer();}var record=sim.CurrentRecord;
            Check(deltaBytes<fullBytes*.7,"Live updates resent too much history");
            Check(record.events.Any(e=>e.actorId==1 && e.kind==BattleEventKind.UltimateQueued && e.tick==41),"Accepted input not recorded at next tick");
            Check(record.events.Count(e=>e.actorId==1 && e.kind==BattleEventKind.Action && e.state.action==BattleAction.Ultimate)==1,"One click did not produce exactly one ultimate: "+heroId);
            Check(!record.battleInProgress && !sim.RequestUltimate(1),"Finished battle still accepts inputs");
            var loaded=ReplayArchive.Decode(ReplayArchive.Encode(record));var timeline=new ReplayTimeline(loaded);
            for(int tick=record.durationTicks;tick>=0;tick-=3)
            {
                timeline.Seek(tick);foreach(var f in loaded.initial)
                {var expected=loaded.events.LastOrDefault(e=>e.hasState && e.state.id==f.id && e.tick<=tick)?.state??f;Check(JsonUtility.ToJson(timeline.States[f.id])==JsonUtility.ToJson(expected),"Manual replay seek mismatch "+heroId+" tick="+tick);}
            }
            var automatic=Sim(Setup(),0);for(int i=0;i<50;i++)automatic.Step();
            Check(automatic.CurrentRecord.events.Any(e=>e.actorId==1 && e.kind==BattleEventKind.Action && e.state.action==BattleAction.Ultimate),"Offline auto-ultimate changed");
        }
        Check(JsonUtility.ToJson(heroes.Data)==config,"Changed saved Hero config");
        return new{passed=true,checks,heroes=5,manualInputs=true,offlineAutoPreserved=true};
    }
}
