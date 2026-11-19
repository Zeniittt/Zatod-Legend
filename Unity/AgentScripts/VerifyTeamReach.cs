using System;
using System.Linq;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Networking;

public static class VerifyTeamReach
{
    public static object Run()
    {
        int checks=0,matches=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        var heroes=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.Load(heroes);var account=campaign.CreateDemoCharacter(heroes);
        account.HeroDesk=campaign.Data.StarterHeroIds.Select(id=>heroes.CreateHero(id,"campaign-"+id)).ToList();
        var ids=account.HeroDesk.Select(h=>h.HeroInstanceId).ToArray();string config=JsonUtility.ToJson(heroes.Data),owned=JsonUtility.ToJson(account);
        for(int mask=1;mask<(1<<ids.Length);mask++)
        {
            var selected=ids.Where((id,i)=>(mask&(1<<i))!=0).ToArray();
            if(selected.Length>5)continue;
            var setup=CampaignBattleFactory.Prepare(campaign,heroes,account,"chapter_1_stage_1",selected);
            // Long-lived stationary targets isolate formation reach from early kills/retargets.
            foreach(var f in setup.Fighters)
            {
                f.maxHp=f.hp=100000;
                if(f.team==1){f.moveSpeed=1;f.attack=1;}
            }
            var record=new BattleSimulation(Guid.NewGuid().ToString("N"),"formation reach",55,setup.Fighters,setup.Loadouts,400,manualUltimateTeams:1).RunToCompletion();matches++;
            foreach(var fighter in record.initial.Where(f=>f.team==0))
            {
                Check(record.events.Any(e=>e.actorId==fighter.id && e.kind==BattleEventKind.Action && e.state.action==BattleAction.Attack),"Never attacked: "+fighter.name+" mask="+mask);
                Check(record.events.Any(e=>e.actorId==fighter.id && e.kind==BattleEventKind.Damage),"Never dealt damage: "+fighter.name+" mask="+mask);
                Check(record.events.Any(e=>e.actorId==fighter.id && e.kind==BattleEventKind.Energy && e.state.energy>0),"Never gained energy: "+fighter.name+" mask="+mask);
                Check(fighter.y==(fighter.slot%2==0?120:-140),"Formation depth changed");
            }
            var loaded=ReplayArchive.Decode(ReplayArchive.Encode(record));var timeline=new ReplayTimeline(loaded);
            for(int tick=0;tick<=loaded.durationTicks;tick+=19)
            {
                timeline.Seek(tick);foreach(var fighter in loaded.initial)
                {var expected=loaded.events.LastOrDefault(e=>e.hasState && e.state.id==fighter.id && e.tick<=tick)?.state??fighter;Check(JsonUtility.ToJson(timeline.States[fighter.id])==JsonUtility.ToJson(expected),"Formation replay mismatch");}
                var line=timeline.States.Values.Where(f=>f.team==0 && f.Alive).OrderBy(f=>f.slot).ToArray();
                for(int i=1;i<line.Length;i++)Check(line[i-1].x>=line[i].x,"Hero order changed");
            }
            if(mask==31)
            {
                System.IO.Directory.CreateDirectory("../Artifacts/TeamReachChecks");System.IO.File.WriteAllBytes("../Artifacts/TeamReachChecks/all-five.arena.gz",ReplayArchive.Encode(record));
                var report=record.initial.Where(f=>f.team==0).Select(f=>new{hero=f.name,range=f.range,
                    normalAttacks=record.events.Count(e=>e.actorId==f.id && e.kind==BattleEventKind.Action && e.state.action==BattleAction.Attack),
                    damageHits=record.events.Count(e=>e.actorId==f.id && e.kind==BattleEventKind.Damage),
                    energy=record.snapshots.Last().fighters.Single(s=>s.id==f.id).energy});
                System.IO.File.WriteAllText("../Artifacts/TeamReachChecks/all-five.json",Newtonsoft.Json.JsonConvert.SerializeObject(report,Newtonsoft.Json.Formatting.Indented));
            }
        }
        Check(JsonUtility.ToJson(heroes.Data)==config && JsonUtility.ToJson(account)==owned,"Saved Hero data changed");
        return new{passed=true,checks,matches,allNonemptySquads=true,allHeroesAttackDamageAndGainEnergy=true};
    }
}
