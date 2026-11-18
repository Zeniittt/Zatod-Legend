using System;
using System.Linq;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;
using Zatod.Networking;

public static class VerifyCampaign
{
    public static object Run()
    {
        int checks=0;void Check(bool ok,string why){checks++;if(!ok)throw new Exception(why);}
        void Reject(Action action,string why){try{action();}catch(ArgumentException){checks++;return;}throw new Exception(why);}
        var heroes=HeroDataJson.LoadBundledCatalog();var campaign=CampaignDataJson.Load(heroes);string original=JsonUtility.ToJson(heroes.Data),config=JsonUtility.ToJson(campaign.Data);
        Check(campaign.Data.Chapters.Count==1 && campaign.Data.Chapters[0].Stages.Count==5,"Chapter/stage count");
        Check(campaign.Data.Chapters[0].Stages.All(s=>s.Monsters.Count==5),"Expected five Monsters per stage");
        var account=campaign.CreateDemoCharacter(heroes);var ids=account.HeroDesk.Select(h=>h.HeroInstanceId).ToArray();string owned=JsonUtility.ToJson(account);
        Check(ids.Length==5 && account.HeroDesk.All(h=>!string.IsNullOrEmpty(heroes.Hero(h.HeroDefinitionId).BodyPrefabResource)),"Five illustrated owned Heroes");
        var cleared=new System.Collections.Generic.List<string>();Check(!campaign.IsUnlocked(campaign.Data.Chapters[0].Stages[1].Id,cleared),"Stage2 starts unlocked");
        int matches=0;BattleRecord sample=null,firstWin=null;
        foreach(var stage in campaign.Data.Chapters[0].Stages)
        {
            Check(campaign.IsUnlocked(stage.Id,cleared),"Progress did not unlock next stage");
            foreach(uint seed in new uint[]{1,55,127})
            {
                var setup=CampaignBattleFactory.Prepare(campaign,heroes,account,stage.Id,ids);
                Check(setup.Fighters.Count(f=>f.team==0)==5 && setup.Fighters.Count(f=>f.team==1)==5,"Full squads");
                Check(setup.Fighters.Where(f=>f.team==1).Select(f=>f.monsterInstanceId).Distinct().Count()==5,"Repeated monster instance IDs");
                var record=setup.Run(Guid.NewGuid().ToString("N"),seed);matches++;
                Check(record.winner==0,"Starter squad could not clear "+stage.Id+" seed="+seed+" winner="+record.winner);
                Check(record.campaignStageId==stage.Id && record.campaignConfigVersion==campaign.Data.ConfigVersion,"Campaign replay metadata");
                var loaded=ReplayArchive.Decode(ReplayArchive.Encode(record));Check(loaded.loadouts.Count(l=>l.kind==CombatantKind.Monster)==5,"Monster archive loadouts");
                var timeline=new ReplayTimeline(loaded);for(int tick=record.durationTicks;tick>=0;tick-=37){timeline.Seek(tick);foreach(var f in record.initial)
                {var expected=record.events.LastOrDefault(e=>e.hasState && e.state.id==f.id && e.tick<=tick)?.state??f;Check(JsonUtility.ToJson(timeline.States[f.id])==JsonUtility.ToJson(expected),"Backward Campaign state");}}
                sample=record;
                if(firstWin==null)firstWin=record;
            }
            cleared.Add(stage.Id);
        }
        var subset=CampaignBattleFactory.Prepare(campaign,heroes,account,campaign.Data.Chapters[0].Stages[0].Id,ids.Take(2));Check(subset.Fighters.Count(f=>f.team==0)==2,"Subset selection ignored");
        Reject(()=>CampaignBattleFactory.Prepare(campaign,heroes,account,"missing",ids),"Unknown stage accepted");
        Reject(()=>CampaignBattleFactory.Prepare(campaign,heroes,account,campaign.Data.Chapters[0].Stages[0].Id,new[]{ids[0],ids[0]}),"Duplicate Hero accepted");
        Reject(()=>CampaignBattleFactory.Prepare(campaign,heroes,account,campaign.Data.Chapters[0].Stages[0].Id,new[]{"preview-leenald"}),"Non-owned Hero accepted");
        Check(JsonUtility.ToJson(account)==owned && JsonUtility.ToJson(heroes.Data)==original && JsonUtility.ToJson(campaign.Data)==config,"Campaign mutated saved config/account");
        var repository=new ReplayRepository("../Artifacts/CampaignChecks/ServerState-"+Guid.NewGuid().ToString("N"));
        var server=new CampaignServerState(campaign,heroes,repository);
        Reject(()=>server.Prepare("chapter_1_stage_2",ids),"Server accepted locked stage");
        Reject(()=>server.Prepare("chapter_1_stage_1",new[]{"preview-leenald"}),"Server accepted foreign Hero");
        var lost=ReplayArchive.Decode(ReplayArchive.Encode(firstWin));lost.winner=1;server.AcceptCommitted(lost);Check(server.Cleared.Length==0,"Loss unlocked progress");
        repository.Save(firstWin.battleId,ReplayArchive.Encode(firstWin));server.AcceptCommitted(firstWin);
        var restarted=new CampaignServerState(campaign,heroes,repository);Check(restarted.Cleared.SequenceEqual(new[]{"chapter_1_stage_1"}),"Server restart lost progress");
        Check(restarted.Prepare("chapter_1_stage_2",ids).StageId=="chapter_1_stage_2","Server did not unlock next stage");
        System.IO.Directory.CreateDirectory("../Artifacts/CampaignChecks");System.IO.File.WriteAllBytes("../Artifacts/CampaignChecks/stage5.arena.gz",ReplayArchive.Encode(sample));
        return new{passed=true,checks,matches,chapter=1,stages=5,heroes=5};
    }
}
