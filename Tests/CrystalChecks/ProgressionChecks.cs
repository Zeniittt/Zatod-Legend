using System;
using System.IO;
using System.Linq;
using System.Text.Json;
using Zatod.Heroes;
using Zatod.Combat;
static partial class Program
{
    static void ProgressionChecks()
    {
        var rules=new ProgressionCatalog(Read<ProgressionDefinition>((BundledData+"/Progression.txt")));var heroes=ImportedCatalog();
        var campaign=new CampaignCatalog(Read<CampaignDefinition>((BundledData+"/Campaigns.txt")),heroes);
        var natural=campaign.CreateDemoCharacter(heroes);long naturalTime=1000000;
        var naturalSession=new ZatodPlayerSession(heroes,campaign,Guid.NewGuid().ToString("D"),natural,progression:rules,clock:()=>naturalTime);
        for(int run=0;run<5;run++)
        {
            var freshMatch=naturalSession.BeginCampaign("chapter_one_stage_1",null,(uint)(50+run),Guid.NewGuid().ToString("N"));
            var sim=new ZatodBattleSimulation(freshMatch);
            while(!sim.Finished){foreach(var unit in sim.Frame().Units.Where(u=>u.Team==0&&u.Alive))sim.RequestUltimate(unit.EntityId);sim.Step();}
            Check(sim.Replay().Winner==0,"Fresh level-one party cannot win first stage");naturalSession.ValidateCampaign(sim.Replay());
        }
        Check(natural.Level==2&&natural.Exp==5&&natural.HeroDesk.All(h=>h.Level>=3),"Natural battle-to-EXP progression loop");
        var owned=campaign.CreateDemoCharacter(heroes);long now=1000000;rules.Initialize(owned,now);
        Check(owned.Stamina==60&&CurrencyBalance.GetGold(owned)==0,"Fresh account defaults");
        rules.SpendStamina(owned,10,now);Check(owned.Stamina==50&&owned.StaminaRecoveryTimestamp==now,"Full-to-deficit anchor");
        Check(!rules.Recover(owned,now+359),"Recovery early");Check(rules.Recover(owned,now+1200)&&owned.Stamina==53&&owned.StaminaRecoveryTimestamp==now+1080,"Offline recovery lost remainder");
        rules.SpendStamina(owned,1,now+1200);Check(owned.StaminaRecoveryTimestamp==now+1080,"Spending reset partial interval");
        rules.Recover(owned,now+100000);Check(owned.Stamina==60,"Recovery exceeds cap");rules.SpendStamina(owned,1,now+200000);Check(!rules.Recover(owned,now+200001)&&owned.Stamina==59,"Banked recovery while full");
        Check(!rules.Recover(owned,now-1),"Backward server clock minted stamina");
        owned.Exp=24;var change=rules.AddPlayerExp(owned,8,now+200001);Check(owned.Level==2&&owned.Exp==7&&owned.Stamina==79,"Player EXP remainder or level stamina bonus");
        owned.Level=1;owned.Exp=0;var h=owned.HeroDesk[0];h.Exp=24;rules.AddHeroExp(owned,h,12);Check(h.Level==2&&h.Exp==11,"Hero EXP remainder");rules.AddHeroExp(owned,h,10000000);Check(h.Level==10&&h.Exp==180,"Hero cap or retained EXP");
        h.Level=40;h.Exp=99;rules.AddHeroExp(owned,h,500);Check(h.Level==40&&h.Exp==99,"Legacy dev Hero downgraded");
        owned.Level=99;owned.Exp=0;rules.AddPlayerExp(owned,1000000,now);Check(owned.Level==100&&owned.Exp==0,"Player max EXP");
        Check(heroes.Data.Items.Count(x=>x.ItemKind==ItemKind.Consumable&&x.HeroExpValue>0)==5,"EXP consumables not imported");
        Check(campaign.Data.Chapters.SelectMany(c=>c.Stages).All(s=>s.PlayerExpReward==6&&s.VitalityReturn==5&&s.FailPlayerExpReward==1),"Stage economy source mismatch");
        owned=campaign.CreateDemoCharacter(heroes);rules.Initialize(owned,now);foreach(var hero in owned.HeroDesk)hero.Level=10;
        var session=new ZatodPlayerSession(heroes,campaign,Guid.NewGuid().ToString("D"),owned,progression:rules,clock:()=>now);
        string Before()=>JsonSerializer.Serialize(owned,Json);string before=Before();
        try{session.BeginCampaign("chapter_one_stage_1",null,5,Guid.NewGuid().ToString("N"),()=>throw new IOException("start save"));throw new Exception("Start save error swallowed");}catch(IOException){}
        Check(before==Before(),"Start rollback");
        var battle=session.BeginCampaign("chapter_one_stage_1",null,5,Guid.NewGuid().ToString("N"));Check(owned.Stamina==59,"Entry cost not one");
        var replay=new ZatodBattleSimulation(battle).RunToCompletion();Check(replay.Winner==0,"Economy fixture must win");before=Before();
        try{session.ValidateCampaign(replay,()=>throw new IOException("settle save"));throw new Exception("Settlement save error swallowed");}catch(IOException){}
        Check(before==Before(),"Settlement rollback lost gold/EXP/items");session.ValidateCampaign(replay);
        var reward=session.LastCampaignReward.Economy;
        Check(owned.Stamina==54&&CurrencyBalance.GetGold(owned)==495&&owned.Exp==6,"Settled resources");
        Check(reward.Player.Granted==6&&reward.Heroes.Count==5&&reward.Heroes.All(x=>x.Granted==12),"Reward receipt missing EXP split");
        Reject(()=>session.ValidateCampaign(replay),"Duplicate result rewarded");
        var saved=JsonSerializer.Deserialize<CharacterData>(Before(),Json);var reconnect=new ZatodPlayerSession(heroes,campaign,Guid.NewGuid().ToString("D"),saved,progression:rules,clock:()=>now);
        Check(reconnect.LastCampaignReward.BattleId==battle.BattleId&&CurrencyBalance.GetGold(saved)==495,"Receipt lost after reconnect");
        owned.Stamina=5;Reject(()=>session.BeginCampaign("chapter_one_stage_1",null,2,Guid.NewGuid().ToString("N")),"Entry checked net instead of full cost");
        // Losing and cancelling must not grant victory rewards.
        var hard=Read<CampaignDefinition>((BundledData+"/Campaigns.txt"));
        foreach(var enemy in hard.Chapters[0].Stages[0].Waves.SelectMany(w=>w.Enemies)){enemy.Level=40;enemy.HpMultiplier=100;enemy.DamageMultiplier=100;}
        var hardCatalog=new CampaignCatalog(hard,heroes);var loser=hardCatalog.CreateDemoCharacter(heroes);
        var losingSession=new ZatodPlayerSession(heroes,hardCatalog,Guid.NewGuid().ToString("D"),loser,progression:rules,clock:()=>now);
        var defeat=new ZatodBattleSimulation(losingSession.BeginCampaign("chapter_one_stage_1",null,19,Guid.NewGuid().ToString("N"))).RunToCompletion();Check(defeat.Winner!=0,"Defeat fixture");losingSession.ValidateCampaign(defeat);
        Check(loser.Stamina==59&&loser.Exp==1&&CurrencyBalance.GetGold(loser)==0&&loser.Inventory.Count==0&&loser.HeroDesk.All(x=>x.Exp==0),"Defeat rewards/cost");
        losingSession.BeginCampaign("chapter_one_stage_1",null,19,Guid.NewGuid().ToString("N"));losingSession.CancelCampaign();Check(loser.Stamina==58&&loser.Exp==1,"Cancel rewards or cost");
        var offline=JsonSerializer.Deserialize<CharacterData>(JsonSerializer.Serialize(loser,Json),Json);offline.Stamina=50;offline.StaminaRecoveryTimestamp=now-1200;
        var offlineSession=new ZatodPlayerSession(heroes,hardCatalog,Guid.NewGuid().ToString("D"),offline,progression:rules,clock:()=>now);Check(offline.Stamina==53&&offline.StaminaRecoveryTimestamp==now-120,"Login offline recovery");
        var crafting=new CraftingCatalog(heroes);var recipe=crafting.ForItem("green_boots");foreach(var i in recipe.Ingredients)new ItemInventory(owned,heroes).AddItemByItemId(i.ItemId,i.Amount);
        before=Before();Reject(()=>session.Craft(recipe.Id,Guid.NewGuid().ToString("D")),"Craft accepted insufficient gold");Check(before==Before(),"Rejected craft consumed materials");
        CurrencyBalance.AddGold(owned,5000);before=Before();
        try{session.Craft(recipe.Id,Guid.NewGuid().ToString("D"),()=>throw new IOException("craft save"));throw new Exception("Craft save swallowed");}catch(IOException){}
        Check(before==Before(),"Craft rollback lost gold");
        var receipt=session.Craft(recipe.Id,Guid.NewGuid().ToString("D"));Check(receipt.GoldCharged==1200&&CurrencyBalance.GetGold(owned)==4295,"Craft did not charge source cost");
        long balance=CurrencyBalance.GetGold(owned);session.Craft(recipe.Id,receipt.OperationId);Check(CurrencyBalance.GetGold(owned)==balance,"Retry charged gold twice");
    }
}
