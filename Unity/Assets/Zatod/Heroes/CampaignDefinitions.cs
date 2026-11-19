using System;
using System.Collections.Generic;
using System.Linq;

namespace Zatod.Heroes
{
    [Serializable] public sealed class CampaignDefinition
    {
        public int SchemaVersion=1;
        public string ConfigVersion="campaign-prototype-1";
        public string StarterHeroRankId="white";
        public List<string> StarterHeroIds=new List<string>();
        public List<CampaignChapterDefinition> Chapters=new List<CampaignChapterDefinition>();
    }
    [Serializable] public sealed class CampaignChapterDefinition
    {
        public string Id,Name;
        public List<CampaignStageDefinition> Stages=new List<CampaignStageDefinition>();
    }
    [Serializable] public sealed class CampaignStageDefinition
    {
        public string Id,Name,Description;
        public int SourceStageId, Difficulty = 1;
        public string RequiredStageId;
        public double EnergyGainMultiplier = 1, EnergySupplyPercent;
        public List<WaveDefinition> Waves = new List<WaveDefinition>();
        public float MapX,MapY;
        public List<CampaignMonsterSlot> Monsters=new List<CampaignMonsterSlot>();
    }
    [Serializable] public sealed class CampaignMonsterSlot
    {
        public string MonsterId;
        public int PowerBasisPoints=10000;
    }
    public sealed class CampaignCatalog
    {
        public CampaignDefinition Data{get;}
        readonly Dictionary<string,CampaignStageDefinition> stages;
        readonly Dictionary<string,string> prerequisites=new Dictionary<string,string>();
        public CampaignCatalog(CampaignDefinition data,HeroCatalog heroes)
        {
            if(data==null || data.SchemaVersion!=1 || string.IsNullOrWhiteSpace(data.ConfigVersion) || string.IsNullOrWhiteSpace(data.StarterHeroRankId) || data.Chapters==null || data.Chapters.Count==0)
                throw new ArgumentException("Invalid Campaign config.");
            Data=data;stages=new Dictionary<string,CampaignStageDefinition>(StringComparer.Ordinal);
            if(data.StarterHeroIds==null || data.StarterHeroIds.Count==0 || data.StarterHeroIds.Distinct().Count()!=data.StarterHeroIds.Count)
                throw new ArgumentException("Campaign starter roster needs unique Hero IDs.");
            foreach(string id in data.StarterHeroIds)heroes.RankPath(heroes.Hero(id),data.StarterHeroRankId);
            var chapters=new HashSet<string>();string previous=null;
            foreach(var chapter in data.Chapters)
            {
                if(chapter==null || string.IsNullOrWhiteSpace(chapter.Id) || !chapters.Add(chapter.Id) || string.IsNullOrWhiteSpace(chapter.Name) || chapter.Stages==null || chapter.Stages.Count==0)
                    throw new ArgumentException("Invalid Campaign chapter.");
                foreach(var stage in chapter.Stages)
                {
                    if(stage==null || string.IsNullOrWhiteSpace(stage.Id) || stages.ContainsKey(stage.Id) || string.IsNullOrWhiteSpace(stage.Name)
                        || float.IsNaN(stage.MapX) || float.IsNaN(stage.MapY) || stage.MapX<0 || stage.MapX>1 || stage.MapY<0 || stage.MapY>1
                        || stage.Monsters==null || ((stage.Waves==null || stage.Waves.Count==0) && (stage.Monsters.Count<1 || stage.Monsters.Count>5)))throw new ArgumentException("Invalid Campaign stage.");
                    if (stage.Waves!=null && stage.Waves.Count>0) WaveValidation.Validate(stage,heroes);
                    foreach(var slot in stage.Monsters)
                    {
                        if(slot==null || slot.PowerBasisPoints<1000 || slot.PowerBasisPoints>100000)throw new ArgumentException("Invalid encounter power.");
                        heroes.Monster(slot.MonsterId);
                    }
                    stages.Add(stage.Id,stage);prerequisites.Add(stage.Id,stage.Waves!=null && stage.Waves.Count>0 ? (string.IsNullOrEmpty(stage.RequiredStageId) ? null : stage.RequiredStageId) : previous);previous=stage.Id;
                }
            }
            foreach (var id in stages.Keys)
            {
                var seen = new HashSet<string>(StringComparer.Ordinal);
                string current = id;
                while (current != null)
                {
                    if (!stages.ContainsKey(current) || !seen.Add(current)) throw new ArgumentException("Missing/cyclic Campaign prerequisite.");
                    current = prerequisites[current];
                }
            }
        }
        public CampaignStageDefinition Stage(string id)
        {if(id==null || !stages.TryGetValue(id,out var stage))throw new ArgumentException("Unknown Campaign stage.");return stage;}
        public bool IsUnlocked(string id,IEnumerable<string> cleared)
        {Stage(id);return prerequisites[id]==null || cleared.Contains(prerequisites[id]);}
        public string Prerequisite(string id){Stage(id);return prerequisites[id];}
        public CharacterData CreateDemoCharacter(HeroCatalog heroes)
        {
            var account=new CharacterData{CharacterId="campaign-demo",Name="Campaign"};
            foreach(string id in Data.StarterHeroIds)
            {
                var hero=heroes.CreateHero(id,"campaign-"+id);
                // The prototype roster uses normal promotion so absorbed gear and unlocks agree.
                while(hero.RankId!=Data.StarterHeroRankId)
                {
                    foreach(var slot in HeroProgression.CurrentRank(hero,heroes).EquipmentSlots)
                        HeroProgression.Equip(hero,heroes,slot.Id,slot.RequiredItemId);
                    HeroProgression.Promote(hero,heroes);
                }
                account.HeroDesk.Add(hero);
            }
            return account;
        }
    }
}
