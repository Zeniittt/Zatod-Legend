using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEngine;
using Zatod.Combat;
using Zatod.Heroes;

namespace Zatod.Networking
{
    public sealed class CampaignServerState
    {
        readonly CampaignCatalog campaign;
        readonly HeroCatalog heroes;
        readonly CharacterData account;
        readonly HashSet<string> cleared=new HashSet<string>(StringComparer.Ordinal);
        public CampaignServerState(CampaignCatalog campaign,HeroCatalog heroes,ReplayRepository repository)
        {
            this.campaign=campaign;this.heroes=heroes;account=campaign.CreateDemoCharacter(heroes);
            // Committed battle archives are the durable source of progress. No second file/commit
            // can get out of sync with a replay if the server stops between write and response.
            foreach(var file in Directory.EnumerateFiles(repository.DirectoryPath,"*.arena.gz"))
            {
                try{var record=ReplayArchive.Decode(repository.Read(Path.GetFileName(file).Substring(0,32)));AcceptCommitted(record);}
                catch(Exception e){Debug.LogWarning("[Campaign] Skipped unreadable progress archive: "+e.Message);}
            }
        }
        public string[] Cleared=>cleared.OrderBy(id=>id,StringComparer.Ordinal).ToArray();
        public CampaignBattleSetup Prepare(string stageId,string[] selected)
        {
            if(!campaign.IsUnlocked(stageId,cleared))throw new ArgumentException("Complete the previous stage first.");
            return CampaignBattleFactory.Prepare(campaign,heroes,account,stageId,selected);
        }
        public void AcceptCommitted(BattleRecord record)
        {
            if(string.IsNullOrEmpty(record.campaignStageId) || record.winner!=0)return;
            try{campaign.Stage(record.campaignStageId);cleared.Add(record.campaignStageId);}catch(ArgumentException){}
        }
    }
}
