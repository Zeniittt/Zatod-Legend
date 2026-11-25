using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;
namespace Zatod.Combat
{
    // One application launch owns its campaign run. Archives never restore stage progress.
    public sealed partial class ZatodPlayerSession
    {
        public CharacterData Account { get; }
        public CampaignRun Run { get; }
        public bool CampaignInProgress => issued.Count > 0;
        public ZatodCampaignReward LastCampaignReward { get; private set; }
        readonly HeroCatalog catalog;
        readonly CampaignCatalog campaign;
        sealed class IssuedCampaign { public ZatodMatchDefinition Match; public string[] Loot,HeroIds; public CampaignStageDefinition Reward; }
        readonly ProgressionCatalog progression;readonly Func<long> clock;
        long Now=>clock();
        readonly Dictionary<string,IssuedCampaign> issued=new Dictionary<string,IssuedCampaign>(StringComparer.Ordinal);
        readonly Func<CampaignStageDefinition,List<string>> rollLoot;
        public ZatodPlayerSession(HeroCatalog catalog,CampaignCatalog campaign,string launchId,CharacterData owned=null,Func<CampaignStageDefinition,List<string>> rollLoot=null,ProgressionCatalog progression=null,Func<long> clock=null)
        {
            if(!Guid.TryParse(launchId,out _))throw new ArgumentException("A fresh application launch GUID is required.");
            this.catalog=catalog;this.campaign=campaign;this.progression=progression;this.clock=clock??(()=>DateTimeOffset.UtcNow.ToUnixTimeSeconds());
            this.rollLoot=rollLoot??ZatodCampaignLoot.Roll;
            Account=owned??campaign.CreateDemoCharacter(catalog);if(owned==null)Account.CharacterId=launchId;
            Run=new CampaignRun(campaign);new ItemInventory(Account,catalog).Validate();
            if(progression!=null){progression.Initialize(Account,Now);progression.Recover(Account,Now);Account.CampaignRewards=Account.CampaignRewards??new List<EconomyBattleReceipt>();}
            var last=Account.CampaignRewards?.LastOrDefault();if(last!=null)LastCampaignReward=new ZatodCampaignReward{BattleId=last.BattleId,StageId=last.StageId,Items=last.Items,Economy=last};
        }
        public List<HeroData> Team(IEnumerable<string> selected)
        {
            var ids=(selected??Account.HeroDesk.Take(5).Select(x=>x.HeroInstanceId)).ToArray();
            if(ids.Length<1 || ids.Length>5 || ids.Distinct().Count()!=ids.Length)throw new ArgumentException("Choose 1-5 unique owned Heroes.");
            return ids.Select(id=>Account.HeroDesk.SingleOrDefault(x=>x.HeroInstanceId==id)??throw new ArgumentException("Hero is not owned.")).ToList();
        }
        public ZatodMatchDefinition BeginCampaign(string stageId,IEnumerable<string> selected,uint seed,string battleId,Action persistOwned=null)
        {
            string lockReason=campaign.StageLockReason(stageId,Account.Level,Run.Stars.Keys);
            if(lockReason!=null)throw new ArgumentException(lockReason);
            var heroIds=Team(selected).Select(x=>x.HeroInstanceId).ToArray();
            var match=ZatodMatchFactory.Campaign(campaign,catalog,Account,stageId,heroIds,seed,battleId);
            if(issued.Count>0)throw new ArgumentException("Finish or cancel the current campaign first.");
            // Keep a private frozen copy; a client payload cannot replace its initial teams or seed.
            var loot=this.rollLoot(campaign.Stage(stageId)).ToArray();
            if(loot.Length>campaign.Stage(stageId).MaxDropAmount || loot.Any(id=>!campaign.Stage(stageId).DropItems.Any(d=>d.ItemId==id)))throw new ArgumentException("Invalid server loot plan.");
            match.LootDrops=ZatodCampaignLoot.Assign(match,loot);
            var source=campaign.Stage(stageId);
            var reward=new CampaignStageDefinition{VitalityCost=source.VitalityCost,VitalityReturn=source.VitalityReturn,PlayerExpReward=source.PlayerExpReward,HeroExpReward=source.HeroExpReward,GoldReward=source.GoldReward,FailPlayerExpReward=source.FailPlayerExpReward};
            var frozen=new ZatodBattleSimulation(match).Replay().Initial;
            if(progression!=null)
            {
                if(Account.CampaignRewards.Any(r=>r.BattleId==battleId))throw new ArgumentException("Battle was already settled.");
                var checkpoint=new EconomyCheckpoint(Account);
                try{progression.Recover(Account,Now);if(Account.Stamina<reward.VitalityCost)throw new ArgumentException("Not enough stamina.");progression.SpendStamina(Account,reward.VitalityCost-reward.VitalityReturn,Now);Account.Revision++;persistOwned?.Invoke();}
                catch{checkpoint.Restore();throw;}
            }
            issued.Add(battleId,new IssuedCampaign{Match=frozen,Loot=loot,HeroIds=heroIds,Reward=reward});return match;
        }
        public List<string> PendingLoot(string battleId)=>issued.TryGetValue(battleId,out var pending)?pending.Loot.ToList():new List<string>();
        public ZatodReplay ValidateCampaign(ZatodReplay claim,Action persistOwned=null)
        {
            if(claim==null || claim.Initial==null || !issued.TryGetValue(claim.Initial.BattleId,out var pending))throw new ArgumentException("No issued battle matches this result.");
            var trusted=pending.Match;
            if(!ZatodBattleSimulation.Validate(trusted,claim.Inputs,claim.EndTick,claim.Winner,claim.Stars,claim.Digest))throw new ArgumentException("Combat checker rejected the submitted result.");
            var replay=ZatodBattleSimulation.Resimulate(new ZatodReplay{Initial=trusted,Inputs=claim.Inputs,EndTick=claim.EndTick});
            var reward=new ZatodCampaignReward{BattleId=trusted.BattleId,StageId=trusted.StageId};
            int originalCount=Account.Inventory.Count;long revision=Account.Revision;var checkpoint=new EconomyCheckpoint(Account);
            try
            {
                if(replay.Winner==0)
                {
                    var inventory=new ItemInventory(Account,catalog);
                    foreach(string itemId in pending.Loot)reward.Items.AddRange(inventory.AddItemByItemId(itemId));
                }
                if(progression!=null)
                {
                    var r=pending.Reward;var receipt=new EconomyBattleReceipt{BattleId=trusted.BattleId,StageId=trusted.StageId,Gold=replay.Winner==0?r.GoldReward:0,StaminaSpent=r.VitalityCost-r.VitalityReturn};
                    if(replay.Winner==0){progression.SpendStamina(Account,r.VitalityReturn,Now);receipt.StaminaSpent+=r.VitalityReturn;CurrencyBalance.AddGold(Account,r.GoldReward);}
                    receipt.Player=progression.AddPlayerExp(Account,replay.Winner==0?r.PlayerExpReward:r.FailPlayerExpReward,Now);
                    if(replay.Winner==0)foreach(var id in pending.HeroIds)receipt.Heroes.Add(progression.AddHeroExp(Account,Account.HeroDesk.Single(h=>h.HeroInstanceId==id),r.HeroExpReward/pending.HeroIds.Length));
                    receipt.Items=reward.Items.ConvertAll(item=>new ItemData{Id=item.Id,ItemId=item.ItemId});
                    Account.CampaignRewards.Add(receipt);reward.Economy=receipt;
                }
                Account.Revision++;persistOwned?.Invoke();
            }
            catch
            {
                Account.Inventory.RemoveRange(originalCount,Account.Inventory.Count-originalCount);checkpoint.Restore();Account.Revision=revision;throw;
            }
            // Consume only after the inventory save succeeds. Retries cannot re-roll or double-grant.
            issued.Remove(trusted.BattleId);Run.AcceptValidated(trusted.StageId,replay.Winner==0,replay.Stars);
            reward.Items=reward.Items.ConvertAll(item=>new ItemData{Id=item.Id,ItemId=item.ItemId});LastCampaignReward=reward;return replay;
        }
        public void CancelCampaign(){issued.Clear();}
        public bool RefreshEconomy(Action persistOwned=null)
        {
            if(progression==null)return false;var checkpoint=new EconomyCheckpoint(Account);
            try{if(!progression.Recover(Account,Now))return false;Account.Revision++;persistOwned?.Invoke();return true;}
            catch{checkpoint.Restore();throw;}
        }
        public void DevItem(string itemId,int amount){if(issued.Count>0)throw new ArgumentException("Finish the battle before changing equipment.");new ItemInventory(Account,catalog).AddItemByItemId(itemId,amount);Account.Revision++;}
        public void Equip(string heroId,string slotId,string guid){EquipItem(heroId,slotId,guid,Guid.NewGuid().ToString("D"));}
        public void Promote(string heroId){PromoteHero(heroId,Account.Revision,Guid.NewGuid().ToString("D"));}
        public void DevLevel(string heroId,int level)
        {
            if(issued.Count>0 || level<1 || level>40)throw new ArgumentException("Prototype level must be 1-40, outside combat.");
            Team(new[]{heroId})[0].Level=level;Account.Revision++;
        }
    }
}
