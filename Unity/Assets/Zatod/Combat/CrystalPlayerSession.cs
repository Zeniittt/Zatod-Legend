using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;
namespace Zatod.Combat
{
    // One application launch owns its campaign run. Archives never restore stage progress.
    public sealed class CrystalPlayerSession
    {
        public CharacterData Account { get; }
        public CampaignRun Run { get; }
        readonly HeroCatalog catalog;
        readonly CampaignCatalog campaign;
        readonly Dictionary<string,CrystalMatchDefinition> issued=new Dictionary<string,CrystalMatchDefinition>(StringComparer.Ordinal);
        public CrystalPlayerSession(HeroCatalog catalog,CampaignCatalog campaign,string launchId,CharacterData owned=null)
        {
            if(!Guid.TryParse(launchId,out _))throw new ArgumentException("A fresh application launch GUID is required.");
            this.catalog=catalog;this.campaign=campaign;
            Account=owned??campaign.CreateDemoCharacter(catalog);if(owned==null)Account.CharacterId=launchId;
            Run=new CampaignRun(campaign);new ItemInventory(Account,catalog).Validate();
        }
        public List<HeroData> Team(IEnumerable<string> selected)
        {
            var ids=(selected??Account.HeroDesk.Take(5).Select(x=>x.HeroInstanceId)).ToArray();
            if(ids.Length<1 || ids.Length>5 || ids.Distinct().Count()!=ids.Length)throw new ArgumentException("Choose 1-5 unique owned Heroes.");
            return ids.Select(id=>Account.HeroDesk.SingleOrDefault(x=>x.HeroInstanceId==id)??throw new ArgumentException("Hero is not owned.")).ToList();
        }
        public CrystalMatchDefinition BeginCampaign(string stageId,IEnumerable<string> selected,uint seed,string battleId)
        {
            if(!Run.IsUnlocked(stageId))throw new ArgumentException("Stage is locked in this application run.");
            var match=CrystalMatchFactory.Campaign(campaign,catalog,Account,stageId,Team(selected).Select(x=>x.HeroInstanceId),seed,battleId);
            if(issued.Count>0)throw new ArgumentException("Finish or cancel the current campaign first.");
            // Keep a private frozen copy; a client payload cannot replace its initial teams or seed.
            issued.Add(battleId,new CrystalBattleSimulation(match).Replay().Initial);return match;
        }
        public CrystalReplay ValidateCampaign(CrystalReplay claim)
        {
            if(claim==null || claim.Initial==null || !issued.TryGetValue(claim.Initial.BattleId,out var trusted))throw new ArgumentException("No issued battle matches this result.");
            if(!CrystalBattleSimulation.Validate(trusted,claim.Inputs,claim.EndTick,claim.Winner,claim.Stars,claim.Digest))throw new ArgumentException("Combat checker rejected the submitted result.");
            var replay=CrystalBattleSimulation.Resimulate(new CrystalReplay{Initial=trusted,Inputs=claim.Inputs,EndTick=claim.EndTick});
            issued.Remove(trusted.BattleId);Run.AcceptValidated(trusted.StageId,replay.Winner==0,replay.Stars);return replay;
        }
        public void CancelCampaign(){issued.Clear();}
        public void DevItem(string itemId,int amount){if(issued.Count>0)throw new ArgumentException("Finish the battle before changing equipment.");new ItemInventory(Account,catalog).AddItemByItemId(itemId,amount);Account.Revision++;}
        public void Equip(string heroId,string slotId,string guid){if(issued.Count>0)throw new ArgumentException("Finish the battle before changing equipment.");new ItemInventory(Account,catalog).Equip(heroId,slotId,guid);Account.Revision++;}
        public void Promote(string heroId){if(issued.Count>0)throw new ArgumentException("Finish the battle before promoting.");new ItemInventory(Account,catalog).Promote(heroId);Account.Revision++;}
        public void DevLevel(string heroId,int level)
        {
            if(issued.Count>0 || level<1 || level>40)throw new ArgumentException("Prototype level must be 1-40, outside combat.");
            Team(new[]{heroId})[0].Level=level;Account.Revision++;
        }
    }
}
