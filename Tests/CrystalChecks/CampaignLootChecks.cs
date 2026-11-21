using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using Zatod.Heroes;
using Zatod.Combat;

static partial class Program
{
    static void CampaignLootChecks()
    {
        var catalog=ImportedCatalog();
        CampaignDefinition Data()=>Read<CampaignDefinition>("Unity/Assets/Zatod/Resources/Data/Campaigns.txt");
        var campaign=new CampaignCatalog(Data(),catalog);
        var stage=campaign.Stage("chapter_one_stage_1");
        string a=stage.DropItems[0].ItemId,b=stage.DropItems[1].ItemId;
        var fixture=new CampaignStageDefinition{MaxDropAmount=5,DropItems=new List<CampaignDropItemDefinition>{
            new CampaignDropItemDefinition{ItemId=a,DropChancePercent=60},new CampaignDropItemDefinition{ItemId=b,DropChancePercent=30},new CampaignDropItemDefinition{ItemId="iron_axe",DropChancePercent=10}}};
        Check(ZatodCampaignLoot.Roll(fixture,bound=>0,()=>throw new Exception("Zero drops drew an item")).Count==0,"Zero count must award nothing");
        var repeated=ZatodCampaignLoot.Roll(fixture,bound=>{Check(bound==6,"Count range must include both 0 and 5");return 5;},()=>0);
        Check(repeated.Count==5 && repeated.All(id=>id==a),"Five draws must allow repeated types");
        var totals=new Dictionary<string,int>{{a,0},{b,0},{"iron_axe",0}};
        for(int n=0;n<10000;n++)totals[ZatodCampaignLoot.Roll(fixture,_=>1,()=>(n+.5)/10000d)[0]]++;
        Check(totals[a]==6000 && totals[b]==3000 && totals["iron_axe"]==1000,"Weighted intervals do not match 60/30/10");
        Check(ZatodCampaignLoot.Roll(fixture,_=>1,()=>.6)[0]==b,"Boundary belongs to next interval");
        Check(ZatodCampaignLoot.Roll(fixture,_=>1,()=>.9999999999999999)[0]=="iron_axe","Largest sample lost an item");
        fixture.DropItems[0].DropChancePercent=0;fixture.DropItems[1].DropChancePercent=100;fixture.DropItems[2].DropChancePercent=0;
        Check(ZatodCampaignLoot.Roll(fixture,_=>5,()=>0).All(id=>id==b),"Zero-percent entry was selected");
        fixture.DropItems[0].DropChancePercent=33.33;fixture.DropItems[1].DropChancePercent=33.33;fixture.DropItems[2].DropChancePercent=33.34;
        Check(ZatodCampaignLoot.Roll(fixture,_=>5,()=>.9).Count==5,"Rounded total 100 rejected");
        fixture.DropItems[2].DropChancePercent=33.33;
        Reject(()=>ZatodCampaignLoot.Roll(fixture,_=>1,()=>0),"99.99% pool accepted");
        fixture.DropItems[2].DropChancePercent=33.34;fixture.MaxDropAmount=0;
        Check(ZatodCampaignLoot.Roll(fixture,_=>0,()=>0).Count==0,"Disabled loot cap failed");
        foreach(var live in campaign.Data.Chapters.SelectMany(c=>c.Stages))
        {
            var roll=ZatodCampaignLoot.Roll(live);
            Check(roll.Count<=5 && roll.All(id=>live.DropItems.Any(d=>d.ItemId==id)),"Secure roll escaped configured pool/range");
        }

        int rollCalls=0;
        var session=new ZatodPlayerSession(catalog,campaign,Guid.NewGuid().ToString("D"),rollLoot:s=>{rollCalls++;return new List<string>{a,a,b};});
        foreach(var hero in session.Account.HeroDesk)session.DevLevel(hero.HeroInstanceId,40);
        var match=session.BeginCampaign(stage.Id,null,11,"loot-win");
        var plan=session.PendingLoot(match.BattleId);plan.Clear();
        Check(session.PendingLoot(match.BattleId).SequenceEqual(new[]{a,a,b}) && session.Account.Inventory.Count==0,"Pending plan leaked or granted early");
        var battle=new ZatodBattleSimulation(match);while(!battle.Finished){foreach(var u in battle.Frame().Units.Where(u=>u.Team==0&&u.Alive))battle.RequestUltimate(u.EntityId);battle.Step();}
        var claim=battle.Replay();Check(claim.Winner==0,"Loot fixture must win");
        ulong digest=claim.Digest;claim.Digest++;
        Reject(()=>session.ValidateCampaign(claim),"Invalid result granted loot");claim.Digest=digest;
        Check(session.Account.Inventory.Count==0 && rollCalls==1,"Rejected result awarded or re-rolled loot");
        long revision=session.Account.Revision;bool failed=false;
        try{session.ValidateCampaign(claim,()=>throw new IOException("test disk failure"));}catch(IOException){failed=true;}
        Check(failed && session.Account.Inventory.Count==0 && session.Account.Revision==revision && !session.Run.IsUnlocked("chapter_one_stage_2"),"Failed save consumed loot or advanced progress");
        claim.Statistics[0].DamageDealt=double.PositiveInfinity;
        claim.Initial.LootDrops.Clear();
        bool persisted=false;var trustedReplay=session.ValidateCampaign(claim,()=>{persisted=true;Check(session.Account.Inventory.Count==3,"Persist callback ran before grant");});
        Check(trustedReplay.Statistics.All(s=>double.IsFinite(s.DamageDealt)),"Client-forged statistics accepted by server settlement");
        Check(trustedReplay.Initial.LootDrops.Count==3,"Client-forged loot placement replaced server plan");
        var items=session.Account.Inventory.ToArray();
        Check(persisted && items.Select(i=>i.ItemId).SequenceEqual(new[]{a,a,b}) && items.All(i=>Guid.TryParseExact(i.Id,"D",out _)) && items.Select(i=>i.Id).Distinct().Count()==3,"Settled item types/GUIDs differ from pending loot");
        Check(session.LastCampaignReward.BattleId==match.BattleId && session.LastCampaignReward.Items.Select(i=>i.Id).SequenceEqual(items.Select(i=>i.Id)),"Receipt missing settled GUIDs");
        Reject(()=>session.ValidateCampaign(claim),"Duplicate claim awarded again");
        ZatodBattleSimulation.Resimulate(claim);
        Check(session.Account.Inventory.Count==3 && rollCalls==1,"Replay/duplicate rerolled or granted items");
        var reconnected=new ZatodPlayerSession(catalog,campaign,Guid.NewGuid().ToString("D"),session.Account);
        Reject(()=>reconnected.ValidateCampaign(claim),"New launch accepted an old claim");
        Check(reconnected.Account.Inventory.Select(i=>i.Id).SequenceEqual(items.Select(i=>i.Id)) && !reconnected.Run.IsUnlocked("chapter_one_stage_2"),"Owned loot failed to survive launch or restored map progress");
        session.BeginCampaign(stage.Id,null,11,"cancel-loot");session.CancelCampaign();
        Check(session.PendingLoot("cancel-loot").Count==0 && session.Account.Inventory.Count==3,"Cancel granted or retained loot");

        var losingData=Data();foreach(var wave in losingData.Chapters[0].Stages[0].Waves){wave.TimeLimitSeconds=1;foreach(var enemy in wave.Enemies)enemy.HpMultiplier=1e9;}
        var losingCampaign=new CampaignCatalog(losingData,catalog);
        var loser=new ZatodPlayerSession(catalog,losingCampaign,Guid.NewGuid().ToString("D"),rollLoot:s=>new List<string>{a});
        var loss=new ZatodBattleSimulation(loser.BeginCampaign(stage.Id,null,11,"loot-loss")).RunToCompletion();
        Check(loss.Winner!=0,"Losing fixture unexpectedly won");loser.ValidateCampaign(loss);
        Check(loser.Account.Inventory.Count==0 && loser.LastCampaignReward.Items.Count==0,"Loss granted pending loot");
        Reject(()=>loser.ValidateCampaign(loss),"Lost battle could be settled twice");

        var empty=new ZatodPlayerSession(catalog,campaign,Guid.NewGuid().ToString("D"),rollLoot:s=>new List<string>());
        foreach(var hero in empty.Account.HeroDesk)empty.DevLevel(hero.HeroInstanceId,40);
        var zero=new ZatodBattleSimulation(empty.BeginCampaign(stage.Id,null,11,"loot-zero")).RunToCompletion();
        Check(zero.Winner==0,"Zero loot fixture must win");empty.ValidateCampaign(zero);
        Check(empty.LastCampaignReward.Items.Count==0 && empty.Run.IsUnlocked("chapter_one_stage_2"),"Zero-loot win failed settlement");
    }
}
