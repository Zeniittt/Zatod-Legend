using System;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public static class HeroCombatantFactory
    {
        public static FighterState Create(HeroDefinition definition,HeroBattleData data,int team,int slot)
        {
            int Stat(string id,int fallback)=>data.Stats.FirstOrDefault(s=>s.StatId==id)?.Value??fallback;
            var fighter = new FighterState{id=team*100+slot+1,team=team,slot=slot,name=definition.Name,role=(FighterRole)Math.Min(4,(int)definition.Position*2),
                maxHp=Stat("health",data.CurrentHp),hp=data.CurrentHp,energy=data.Energy,attack=Stat("damage",100),armor=Stat("defense",0),range=Stat("attack_range",1100),
                attackInterval=Stat("attack_interval",26),moveSpeed=Stat("move_speed",1600),
                heroDefinitionId=definition.Id,animationSetResource=definition.AnimationSetResource,projectileHurtboxHeight=definition.ProjectileHurtboxHeight,
                deathVisualTicks=Math.Max(1,(definition.DeathAnimationMilliseconds*BattleSimulation.TickRate+999)/1000)};
            BattleFormationLayout.Place(fighter);
            return fighter;
        }
    }
}
