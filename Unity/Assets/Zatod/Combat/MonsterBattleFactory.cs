using System;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public static class MonsterBattleFactory
    {
        public static MonsterBattleData Create(string definitionId,string instanceId,HeroCatalog catalog)
        {
            if(string.IsNullOrWhiteSpace(instanceId))throw new ArgumentException("Monster instance ID is required.");
            var definition=catalog.Monster(definitionId);
            return new MonsterBattleData{ConfigVersion=catalog.Data.ConfigVersion,MonsterDefinitionId=definition.Id,MonsterInstanceId=instanceId,
                Stats=definition.BaseStats.ConvertAll(s=>s.Copy()),SpawnPoints=definition.SpawnPoints.ConvertAll(p=>p.Copy()),
                HasNormalAttack=true,NormalAttack=catalog.Skill(definition.NormalAttackSkillId).Copy(),
                Skills=definition.SkillIds.Select(id=>new BattleSkillData{SlotId=id,Level=1,Definition=catalog.Skill(id).Copy()}).ToList(),
                CurrentHp=definition.BaseStats.Single(s=>s.StatId=="health").Value};
        }
        public static FighterState CreateFighter(MonsterDefinition definition,MonsterBattleData data,int team,int slot)
        {
            int Stat(string id){return data.Stats.Single(s=>s.StatId==id).Value;}
            return new FighterState{id=team*100+slot+1,team=team,slot=slot,name=definition.Name,
                monsterDefinitionId=definition.Id,monsterInstanceId=data.MonsterInstanceId,animationSetResource=definition.AnimationSetResource,
                role=(FighterRole)Math.Min(4,(int)definition.Position*2),maxHp=Stat("health"),hp=data.CurrentHp,energy=data.Energy,
                attack=Stat("damage"),armor=Stat("defense"),range=Stat("attack_range"),moveSpeed=Stat("move_speed"),attackInterval=Stat("attack_interval"),
                projectileHurtboxHeight=definition.ProjectileHurtboxHeight,deathVisualTicks=Math.Max(1,(definition.DeathAnimationMilliseconds*BattleSimulation.TickRate+999)/1000)};
        }
    }
}
