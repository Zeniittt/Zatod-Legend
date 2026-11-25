using System;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        Unit NativeTaunter(Unit actor)=>ExpandedRules?actor.Buffs.Where(b=>HasControl(b.Definition,"taunt")).Select(b=>Find(b.CasterId)).LastOrDefault(u=>u?.State.Alive==true):null;
        void MarsStart(Unit actor,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==11101){actor.Cast.Phase=Random()<.5?0:1;actor.State.Action=skill.Definition.Crystal.Phases[actor.Cast.Phase].Action;}
            if(id==11104 && Evo(skill,"MarsTauntGuard")>0)ApplyBuff(actor,actor,skill,11011009);
        }
        void MarsTauntFrame(Unit actor,BattleSkillData skill)
        {
            ApplyBuff(actor,actor,skill,11011005);
            SceneEffect("eff_impact_TitanMars_atk4.cha",actor,actor.State.X,actor.State.Y,ZatodBuffEffectLayer.WorldActors,actor.Data.Team==0);
        }
        double MarsReduceDamage(Unit actor,Unit target,string type,double amount)
        {
            var parry=Native(target,11103);
            if(type!="AD" || parry==null || (target.State.FacingRight?1:-1)*(target.State.X-actor.State.X)>=0)return amount;
            double stopped=amount*(Arg(parry.Definition.Crystal,2)+Evo(parry,"MarsParryBonus"))/100;
            SceneEffect("eff_impact_TitanMars_atk3.cha",target,target.State.X,target.State.Y,ZatodBuffEffectLayer.WorldActors,!target.State.FacingRight,.85);
            if(Evo(parry,"MarsParryThreshold")>0)
            {
                bool hadParry=target.MarsParriedDamage>0;target.MarsParriedDamage+=stopped;
                if(hadParry && target.MarsParriedDamage>=target.State.MaxHp*Evo(parry,"MarsParryThreshold") && Native(target,11102) is BattleSkillData bash)
                {target.Cooldowns[bash.Definition.Id]=0;target.GlobalCooldown=0;target.MarsParriedDamage=0;}
            }
            return Math.Max(0,amount-stopped);
        }
        void MarsProjectileHit(Unit caster,Unit victim,Shot shot)
        {
            if(shot.Skill.Definition.Crystal.SourceId!=11100)return;
            var next=units.Where(u=>u.State.Alive && CampMatches(caster,u,-1) && u!=victim && !Controlled(u,"untargetable") && !Controlled(u,"enchanted") &&
                Math.Abs(victim.State.X-u.State.X)<=120 && (caster.State.FacingRight?1:-1)*(u.State.X-victim.State.X)>=0 && Math.Abs(victim.State.Y-u.State.Y)<=100)
                .OrderBy(u=>Math.Abs(victim.State.X-u.State.X)).ThenBy(u=>u.State.EntityId).FirstOrDefault();
            if(next!=null)
            {var follow=DependentSkill(caster,11105,shot.Skill.Level);follow.Definition.Crystal.PlusRatio=shot.Skill.Definition.Crystal.PlusRatio;ApplySkill(caster,next,follow);}
            var field=DependentSkill(caster,11106,shot.Skill.Level);CreateRegion(caster,victim,field);var region=regions[regions.Count-1];
            region.VisualResource="eff_buff_TitanMars_ult.cha";region.VisualId=++visualId;
        }
    }
}
