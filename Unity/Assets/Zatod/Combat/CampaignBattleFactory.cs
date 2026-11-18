using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed class CampaignBattleSetup
    {
        public string StageId,ConfigVersion;
        public List<FighterState> Fighters=new List<FighterState>();
        public List<FighterLoadout> Loadouts=new List<FighterLoadout>();
        public BattleRecord Run(string battleId,uint seed)
        {
            var record=new BattleSimulation(battleId,"campaign:"+StageId,seed,Fighters,Loadouts).RunToCompletion();
            record.campaignStageId=StageId;record.campaignConfigVersion=ConfigVersion;return record;
        }
    }
    public static class CampaignBattleFactory
    {
        public static CampaignBattleSetup Prepare(CampaignCatalog campaign,HeroCatalog heroes,CharacterData account,string stageId,IEnumerable<string> selected)
        {
            var stage=campaign.Stage(stageId);var ids=selected?.ToList();
            if(ids==null || ids.Count<1 || ids.Count>5 || ids.Distinct(StringComparer.Ordinal).Count()!=ids.Count)throw new ArgumentException("Choose 1–5 owned Heroes.");
            // Formation validates ownership. Never accept Hero stats, Monster data, or outcomes from the client.
            var request=new CharacterData{CharacterId=account.CharacterId,HeroDesk=account.HeroDesk,Formation=new HeroFormationData{HeroInstanceIds=ids}};
            var formation=new HeroFormation(request,heroes);var setup=new CampaignBattleSetup{StageId=stageId,ConfigVersion=campaign.Data.ConfigVersion};int slot=0;
            foreach(var hero in formation.Selected)
            {
                var data=HeroBattleFactory.Create(hero,heroes);var fighter=HeroCombatantFactory.Create(heroes.Hero(hero.HeroDefinitionId),data,0,slot++);
                setup.Fighters.Add(fighter);setup.Loadouts.Add(new FighterLoadout{fighterId=fighter.id,hero=data});
            }
            slot=0;
            foreach(var entry in stage.Monsters.Select((s,i)=>new{slot=s,index=i}).OrderBy(s=>heroes.Monster(s.slot.MonsterId).Position).ThenBy(s=>s.index))
            {
                var def=heroes.Monster(entry.slot.MonsterId);var data=MonsterBattleFactory.Create(def.Id,stageId+"-monster-"+entry.index,heroes);
                foreach(var stat in data.Stats.Where(s=>s.StatId=="health" || s.StatId=="damage" || s.StatId=="defense"))
                    stat.Value=Math.Max(stat.StatId=="defense"?0:1,(int)((long)stat.Value*entry.slot.PowerBasisPoints/10000));
                data.CurrentHp=data.Stats.Single(s=>s.StatId=="health").Value;
                var fighter=MonsterBattleFactory.CreateFighter(def,data,1,slot);fighter.x=2300+slot*850;fighter.y=slot%2==0?-120:140;fighter.formationSpacing=650;slot++;
                setup.Fighters.Add(fighter);setup.Loadouts.Add(new FighterLoadout{fighterId=fighter.id,kind=CombatantKind.Monster,monster=data});
            }
            return setup;
        }
    }
}
