using System;
using System.Linq;
using System.Collections.Generic;
using System.IO;
using System.Text.Json;
using Zatod.Heroes;
using Zatod.Combat;

static partial class Program
{
    static void SkillPromoteChecks()
    {
        var catalog=ImportedCatalog();
        using(var source=JsonDocument.Parse(File.ReadAllText("docs/reference/zatod-skill-promote-source.json")))
            catalog.Data.SkillProgression.GoldUpgradeCurve=source.RootElement.GetProperty("GoldUpgradeCurve").EnumerateArray()
                .Select(x=>new SkillUpgradeCost{FromLevel=x.GetProperty("FromLevel").GetInt32(),Gold=x.GetProperty("Gold").GetInt64()}).ToList();
        SkillProgression.Validate(catalog.Data.SkillProgression);
        var definition=catalog.Hero("coco");
        definition.SkillSlots[2].InitialLevel=21;
        var created=catalog.CreateHero("coco","new-coco");
        Check(created.Skills[2].Level==21,"New Hero must use slot InitialLevel, including locked slots");
        Check(HeroProgression.UnlockedSkills(created,catalog).Count==1,"Seed level must not unlock a slot");
        var account=new CharacterData{CharacterId=Guid.NewGuid().ToString("D")};
        var hero=catalog.CreateHero("coco",Guid.NewGuid().ToString("D"));hero.Level=80;account.HeroDesk.Add(hero);
        CurrencyBalance.AddGold(account,100000000);
        string ultimate=definition.SkillSlots.Single(x=>x.IsUltimate).Id;
        var third=hero.Skills[2];third.Level=1;
        catalog.Bind(account);Check(third.Level==1,"Migration changed existing slot progress");
        hero.Skills.Remove(third);catalog.Bind(account);
        Check(hero.Skills.Single(x=>x.SlotId==definition.SkillSlots[2].Id).Level==21,"Missing slot was not seeded by SlotId");
        var high=hero.Skills.Single(x=>x.SlotId==ultimate);high.Level=90;catalog.Bind(account);
        Check(high.Level==90,"Loading must preserve old levels above cap");high.Level=1;
        var campaign=new CampaignCatalog(Read<CampaignDefinition>("Unity/Assets/Zatod/Resources/Data/Campaigns.txt"),catalog);
        var session=new ZatodPlayerSession(catalog,campaign,Guid.NewGuid().ToString("D"),account);
        string Op()=>Guid.NewGuid().ToString("D");
        string State()=>JsonSerializer.Serialize(account,Json);
        void SaveFails(Action action,string label)
        {
            string before=State();bool failed=false;
            try{action();}catch(IOException){failed=true;}
            Check(failed && State()==before,label+" did not rollback the complete account");
        }
        void Fail()=>throw new IOException("fixture persist failure");
        Reject(()=>session.UpgradeSkill(hero.HeroInstanceId,definition.SkillSlots[2].Id,21,1,account.Revision,Op()),"Locked slot upgraded");
        Reject(()=>session.UpgradeSkill(hero.HeroInstanceId,ultimate,2,1,account.Revision,Op()),"Stale skill level accepted");
        Reject(()=>session.UpgradeSkill(hero.HeroInstanceId,ultimate,1,1,account.Revision+1,Op()),"Stale revision accepted");
        Reject(()=>session.UpgradeSkill(hero.HeroInstanceId,ultimate,1,0,account.Revision,Op()),"Zero count accepted");
        long gold=CurrencyBalance.GetGold(account);string operation=Op();long revision=account.Revision;
        SaveFails(()=>session.UpgradeSkill(hero.HeroInstanceId,ultimate,1,2,revision,operation,Fail),"Skill persist failure");
        var receipt=session.UpgradeSkill(hero.HeroInstanceId,ultimate,1,2,revision,operation);
        Check(hero.Skills.Single(s=>s.SlotId==ultimate).Level==3 && CurrencyBalance.GetGold(account)==gold-600,"Batch price must sum source rows 1 and 2");
        Check(receipt.PreviousSkillLevel==1 && receipt.SkillLevel==3 && receipt.GoldCharged==600,"Skill receipt lost result");
        Check(session.UpgradeSkill(hero.HeroInstanceId,ultimate,1,2,revision,operation)==receipt && CurrencyBalance.GetGold(account)==gold-600,"Retry charged twice");
        Reject(()=>session.UpgradeSkill(hero.HeroInstanceId,ultimate,1,1,revision,operation),"Reused operation payload accepted");
        var loaded=JsonSerializer.Deserialize<CharacterData>(State(),Json);catalog.Bind(loaded);
        var reconnected=new ZatodPlayerSession(catalog,campaign,Guid.NewGuid().ToString("D"),loaded);
        Check(reconnected.UpgradeSkill(hero.HeroInstanceId,ultimate,1,2,revision,operation).GoldCharged==600 && loaded.Revision==account.Revision,"Receipt did not survive save/reconnect");
        hero.Level=3;Reject(()=>session.UpgradeSkill(hero.HeroInstanceId,ultimate,3,1,account.Revision,Op()),"Hero level cap bypassed");
        hero.Level=100;hero.Skills.Single(x=>x.SlotId==ultimate).Level=80;
        Reject(()=>session.UpgradeSkill(hero.HeroInstanceId,ultimate,80,1,account.Revision,Op()),"Config level cap bypassed");
        hero.Level=80;hero.Skills.Single(x=>x.SlotId==ultimate).Level=34;
        var zeroGold=CurrencyBalance.GetGold(account);CurrencyBalance.AddGold(account,-zeroGold);var poor=State();
        Reject(()=>session.UpgradeSkill(hero.HeroInstanceId,ultimate,34,1,account.Revision,Op()),"Insufficient gold accepted");
        Check(State()==poor,"Rejected upgrade changed state");CurrencyBalance.AddGold(account,zeroGold);
        session.UpgradeSkill(hero.HeroInstanceId,ultimate,34,1,account.Revision,Op());
        Check(hero.Skills.Single(x=>x.SlotId==ultimate).Level==35 && account.Inventory.Count==0 && account.Level==1,"Evo threshold requires books or PlayerLv7");
        var inv=new ItemInventory(account,catalog);var rank=HeroProgression.CurrentRank(hero,catalog);
        string secondItem=rank.EquipmentSlots[1].RequiredItemId;rank.EquipmentSlots[1].RequiredItemId=rank.EquipmentSlots[0].RequiredItemId;
        inv.AddItemByItemId(rank.EquipmentSlots[0].RequiredItemId);
        var plan=SkillProgression.QuickEquipPlan(account,hero,catalog);
        Check(plan.Count==1,"One GUID was allocated to multiple slots");
        SaveFails(()=>session.QuickEquip(hero.HeroInstanceId,account.Revision,Op(),Fail),"QuickEquip persist failure");
        session.QuickEquip(hero.HeroInstanceId,account.Revision,Op());
        Check(hero.EquippedItems.Count==1 && hero.RankId==rank.Id && account.Inventory.Count==0,"QuickEquip consumed fake items or auto-promoted");
        rank.EquipmentSlots[1].RequiredItemId=secondItem;
        foreach(var slot in rank.EquipmentSlots.Where(x=>!hero.EquippedItems.Any(i=>i.SlotId==x.Id)))inv.AddItemByItemId(slot.RequiredItemId);
        session.QuickEquip(hero.HeroInstanceId,account.Revision,Op());
        var ids=hero.EquippedItems.Select(x=>x.Id).OrderBy(x=>x).ToArray();
        string rankId=hero.RankId,nextRank=rank.NextRankId;long beforePromoteGold=CurrencyBalance.GetGold(account);
        string promoteId=Op();long promoteRevision=account.Revision;
        SaveFails(()=>session.PromoteHero(hero.HeroInstanceId,promoteRevision,promoteId,Fail),"Promote persist failure");
        var promotion=session.PromoteHero(hero.HeroInstanceId,promoteRevision,promoteId);
        Check(hero.RankId==nextRank && hero.EquippedItems.Count==0 && hero.AbsorbedItems.Select(x=>x.Id).OrderBy(x=>x).SequenceEqual(ids),"Promote lost GUID/history or granted equipment");
        Check(hero.AbsorbedItems.All(x=>x.RankId==rankId && x.Quantity==1) && CurrencyBalance.GetGold(account)==beforePromoteGold,"Promote changed provenance or charged gold");
        Check(session.PromoteHero(hero.HeroInstanceId,promoteRevision,promoteId)==promotion && hero.AbsorbedItems.Count==ids.Length,"Promote retry repeated absorption");
        var match=session.BeginCampaign("chapter_one_stage_1",new[]{hero.HeroInstanceId},42,"d35-guard");
        Reject(()=>session.UpgradeSkill(hero.HeroInstanceId,ultimate,35,1,account.Revision,Op()),"Campaign loadout guard failed");
        Reject(()=>session.QuickEquip(hero.HeroInstanceId,account.Revision,Op()),"Campaign QuickEquip guard failed");
        Check(session.PromoteHero(hero.HeroInstanceId,promoteRevision,promoteId)==promotion,"Committed retry should be acknowledged during a battle");
        session.CancelCampaign();
        var reserved=inv.AddItemByItemId(rank.EquipmentSlots[0].RequiredItemId).Single();
        account.RetiredInventory.Add(new ItemData{Id=reserved.Id,ItemId=reserved.ItemId});
        Reject(()=>session.QuickEquip(hero.HeroInstanceId,account.Revision,Op()),"Retired GUID was reused by QuickEquip");
        account.RetiredInventory.Clear();account.Inventory.Remove(reserved);
        var migrationCatalog=ImportedCatalog();var oldSave=new CharacterData{CharacterId=Op()};
        var oldHero=migrationCatalog.CreateHero("coco",Op());oldHero.Skills[0].Level=91;oldSave.HeroDesk.Add(oldHero);
        var oldLevels=oldHero.Skills.Select(x=>x.Level).ToArray();
        migrationCatalog.Hero("coco").SkillSlots.Add(new HeroSkillSlotDefinition{Id="locked_fourth_fixture",SkillId=migrationCatalog.Hero("coco").NormalAttackSkillId,InitialLevel=41});
        migrationCatalog.Bind(oldSave);
        Check(oldHero.Skills.Count==4 && oldHero.Skills.Take(3).Select(x=>x.Level).SequenceEqual(oldLevels) && oldHero.Skills[3].Level==41,"Three-slot migration lost progress or wrong fourth-slot seed");
        Check(!HeroBattleFactory.Create(oldHero,migrationCatalog).Skills.Any(x=>x.SlotId=="locked_fourth_fixture"),"Locked fourth slot entered a battle snapshot");
    }
}
