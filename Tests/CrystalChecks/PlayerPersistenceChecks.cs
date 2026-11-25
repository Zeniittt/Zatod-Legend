using System;
using System.IO;
using System.Linq;
using System.Text.Json;
using Zatod.Heroes;
using Zatod.Combat;
static partial class Program
{
    static void PlayerPersistenceChecks()
    {
        var catalog=ImportedCatalog(RuntimeData);
        var campaign=new CampaignCatalog(Read<CampaignDefinition>(Path.Combine(RuntimeData,"Campaigns.txt")),catalog);
        var progression=new ProgressionCatalog(Read<ProgressionDefinition>(Path.Combine(RuntimeData,"Progression.txt")));
        string folder=Path.Combine(Path.GetTempPath(),"ZatodD39-"+Guid.NewGuid().ToString("N"));Directory.CreateDirectory(folder);
        string path=Path.Combine(folder,"datas.json");long now=2000000;
        CharacterData Fresh(){var a=campaign.CreateDemoCharacter(catalog);progression.Initialize(a,now);a.Formation.HeroInstanceIds=a.HeroDesk.Take(5).Select(h=>h.HeroInstanceId).ToList();return a;}
        PlayerDatabaseStore Open()=>new PlayerDatabaseStore(path,d=>JsonSerializer.Serialize(d,Json),s=>JsonSerializer.Deserialize<PlayerDatabase>(s,Json),a=>
        {catalog.Bind(a);new ItemInventory(a,catalog).Validate();new HeroFormation(a,catalog);new CampaignRun(campaign).Restore(a.MainCampaignProgress);});
        string Encode(object o)=>JsonSerializer.Serialize(o,Json);
        try
        {
            var store=Open();Check(store.Count==0,"Fresh store was not empty");
            var upper=store.Register("TinBo"," Keep CASE ",Fresh);var lower=store.Register("tinbo","different",Fresh);
            Check(store.Count==2&&upper.CharacterId!=lower.CharacterId,"Case-sensitive accounts did not get distinct GUIDs");
            Check(Directory.GetFiles(folder,"*.json").Length==1,"Expected one shared JSON");
            Check(File.ReadAllText(path).Contains(" Keep CASE "),"Prototype password must retain exact plaintext");
            Reject(()=>store.Register("TinBo","other",Fresh),"Duplicate username accepted");
            foreach(var credentials in new[]{("TINBO"," Keep CASE "),("TinBo","keep case"),("TinBo","Keep CASE"),("missing","different")})
                Reject(()=>store.Login(credentials.Item1,credentials.Item2),"Invalid login accepted");
            Reject(()=>PlayerIdentity.Username("../other"),"Invalid username accepted");
            Reject(()=>PlayerIdentity.Password("line\nbreak"),"Line-break password accepted");
            upper=store.Login("TinBo"," Keep CASE ");var unchangedLower=Encode(store.Login("tinbo","different"));
            var working=store.Login("TinBo"," Keep CASE ");working.Level=19;store.Save(lower);
            Check(store.Login("TinBo"," Keep CASE ").Level==1,"Another player's save captured a dirty working copy");
            foreach(var h in upper.HeroDesk)h.Level=10;
            upper.Revision++;store.Save(upper);
            var session=new ZatodPlayerSession(catalog,campaign,Guid.NewGuid().ToString("D"),upper,progression:progression,clock:()=>now);
            var ids=upper.HeroDesk.Select(h=>h.HeroInstanceId).ToArray();
            session.SetFormation(ids.Take(3),()=>store.Save(upper));
            Check(Open().Login("TinBo"," Keep CASE ").Formation.HeroInstanceIds.Count==3,"Formation did not persist");
            var before=Encode(upper);try{session.SetFormation(ids.Take(2),()=>throw new IOException("injected save failure"));throw new Exception("Formation failure swallowed");}catch(IOException){}
            Check(before==Encode(upper),"Formation rollback changed player");
            session.SetFormation(ids,()=>store.Save(upper));
            var stage=campaign.Data.Chapters[0].Stages[0];var battleId=Guid.NewGuid().ToString("N");
            var match=session.BeginCampaign(stage.Id,ids,117,battleId,()=>store.Save(upper));
            int entered=upper.Stamina;
            Check(Open().Login("TinBo"," Keep CASE ").Stamina==entered,"Battle entry was not durable");
            var simulation=new ZatodBattleSimulation(match);
            while(!simulation.Finished){foreach(var u in simulation.Frame().Units.Where(u=>u.Team==0&&u.Alive))simulation.RequestUltimate(u.EntityId);simulation.Step();}
            var claim=simulation.Replay();Check(claim.Winner==0,"D39 natural rules fixture must win");
            before=Encode(upper);string disk=File.ReadAllText(path);
            try{session.ValidateCampaign(claim,()=>throw new IOException("injected settlement failure"));throw new Exception("Settlement failure swallowed");}catch(IOException){}
            Check(Encode(upper)==before&&session.Run.Stars.Count==0&&session.CampaignInProgress,"Settlement did not rollback progress/rewards/issued battle");
            Check(File.ReadAllText(path)==disk,"Failed settlement changed shared file");
            session.ValidateCampaign(claim,()=>store.Save(upper));
            var loaded=Open().Login("TinBo"," Keep CASE ");var restarted=new ZatodPlayerSession(catalog,campaign,Guid.NewGuid().ToString("D"),loaded,progression:progression,clock:()=>now);
            Check(restarted.Run.Stars[stage.Id]==claim.Stars&&!restarted.CampaignInProgress,"New launch did not restore stars or resumed a battle");
            Check(loaded.MainCampaignProgress.Stages.Single(s=>s.StageId==stage.Id).Stars==claim.Stars,"Saved stage stars missing");
            Check(loaded.CampaignRewards.Count==1&&restarted.LastCampaignReward.BattleId==battleId,"Confirmed receipt lost before reward screen");
            Check(loaded.Stamina==entered-stage.VitalityReturn&&CurrencyBalance.GetGold(loaded)==stage.GoldReward,"Settlement economy drift");
            string settled=File.ReadAllText(path);Reject(()=>restarted.ValidateCampaign(claim,()=>store.Save(loaded)),"Old claim rewarded after restart");Check(settled==File.ReadAllText(path),"Old claim changed shared file");
            Check(Encode(Open().Login("tinbo","different"))==unchangedLower,"Other player's progress changed");
            Check(loaded.HeroDesk.Select(h=>h.HeroInstanceId).SequenceEqual(ids),"Hero GUID changed after restart");
            Check(loaded.Inventory.Select(i=>i.Id).SequenceEqual(upper.Inventory.Select(i=>i.Id)),"Loot GUID changed after restart");
            // Abandon a valid key battle: keep entry cost; no settlement, clear, or reward for it.
            var key=campaign.Data.Chapters[0].Stages.First(s=>s.KeyStage&&campaign.StageLockReason(s.Id,loaded.Level,restarted.Run.Stars.Keys)==null);
            int receipts=loaded.CampaignRewards.Count;long gold=CurrencyBalance.GetGold(loaded);
            restarted.BeginCampaign(key.Id,ids,118,Guid.NewGuid().ToString("N"),()=>store.Save(loaded));int abandoned=loaded.Stamina;
            restarted.CancelCampaign();now+=360;
            var afterAbort=Open().Login("TinBo"," Keep CASE ");var relog=new ZatodPlayerSession(catalog,campaign,Guid.NewGuid().ToString("D"),afterAbort,progression:progression,clock:()=>now);
            Check(!relog.CampaignInProgress&&afterAbort.CampaignRewards.Count==receipts&&CurrencyBalance.GetGold(afterAbort)==gold,"Aborted battle received rewards or resumed");
            Check(afterAbort.Stamina==abandoned+1,"Offline stamina recovery or interruption cost changed");
            // A failed file replacement must leave both the committed document and account map intact.
            var failing=Open();string beforeFailedWrite=File.ReadAllText(path);File.Move(path,path+".held");Directory.CreateDirectory(path);
            try{failing.Register("FailWrite","test",Fresh);throw new Exception("Write failure swallowed");}catch(IOException){}catch(UnauthorizedAccessException){}
            Check(failing.Count==2,"Failed registration published an account");Directory.Delete(path);File.Move(path+".held",path);
            Check(File.ReadAllText(path)==beforeFailedWrite,"Failed registration changed committed data");
            Check(File.Exists(path+".bak"),"Known-good backup was not created");
            string current=File.ReadAllText(path);var future=JsonSerializer.Deserialize<PlayerDatabase>(current,Json);future.SchemaVersion=2;string newer=Encode(future);File.WriteAllText(path,newer);
            try{Open();throw new Exception("Newer schema silently downgraded");}catch(NotSupportedException){}
            Check(File.ReadAllText(path)==newer,"Newer schema overwritten by older backup");File.WriteAllText(path,current);
            File.WriteAllText(path,"broken-json");var recovery=Open();Check(recovery.RecoveredBackup&&recovery.Count==2,"Backup recovery failed");
            Check(Directory.GetFiles(folder,"*.corrupt-*").Length==1,"Corrupt primary not retained");
            File.WriteAllText(path,"{}");File.WriteAllText(path+".bak","{}");
            try{Open();throw new Exception("Corrupt database reset to empty");}catch(InvalidDataException){}
            Check(File.ReadAllText(path)=="{}","Corrupt data was overwritten");
            Console.WriteLine("[D39Persistence] PASS / "+checks+" assertions");
        }
        finally{Directory.Delete(folder,true);}
    }
}
