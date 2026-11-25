using System;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        void LegionStart(Unit actor,BattleSkillData skill)
        {
            if(skill.Definition.Crystal.SourceId!=684)return;
            actor.Cast.Phase=1;actor.LegionCrossed=false;
            var old=actor.Buffs.FirstOrDefault(b=>b.Definition.SourceId==10006801 && b.Remaining<5);
            if(old!=null)old.Remaining=Arg(skill.Definition.Crystal,2)-5;
        }
        bool LegionRelease(Unit actor,Unit target,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==684)return true;
            if(id!=680)return false;
            int count=actor.Cast?.AttackCounter??1;
            if(count==1 && !Controlled(target,"stable")){target.State.X=actor.State.X+(actor.State.FacingRight?140:-140);target.State.Y=actor.State.Y;}
            var strike=new BattleSkillData{Level=skill.Level,Definition=skill.Definition.Copy()};var info=strike.Definition.Crystal;
            info.ShapeArg1=351;info.KnockUp=count==1?.15:count==2?.8:count==7?.5:count==8?.7:.25;
            info.KnockBack=count==1?20:count==8?100:1;info.NoDodge=Evo(skill,"DuelNoDodge")>0;
            if(count==8)info.PlusRatio=Evo(skill,"DuelFinisherRatio",2);
            foreach(var victim in Affected(actor,target,info).ToArray())ApplySkill(actor,victim,strike);
            SceneEffect("eff_point_LC_atk2_2.cha",actor,target.State.X,target.State.Y,ZatodBuffEffectLayer.BehindBattlefieldActors);
            if(count==1)ApplyBuff(actor,actor,skill,10006809);
            if(count==8)
            {
                SceneEffect("eff_point_LC_ult2.cha",actor,400,0,ZatodBuffEffectLayer.BehindBattlefieldActors);
                if(!target.State.Alive)
                {
                    SceneEffect("eff_point_LC_ult1.cha",actor,actor.State.X,actor.State.Y,ZatodBuffEffectLayer.WorldActors);
                    ApplySkill(actor,actor,DependentSkill(actor,687,skill.Level));
                }
                if(Native(actor,682) is BattleSkillData press)actor.Cooldowns[press.Definition.Id]=.01;
            }
            return true;
        }
        void LegionAdvance(Unit actor,double dt)
        {
            if(!actor.LegionCharging || actor.Cast?.Skill.Definition.Crystal.SourceId!=684)return;
            var cast=actor.Cast;var info=cast.Skill.Definition.Crystal;
            foreach(var victim in Affected(actor,actor,info).ToArray())
                if(cast.NativeAffected.Add(victim.State.EntityId))ApplySkill(actor,victim,cast.Skill);
            double direction=actor.State.FacingRight?1:-1;
            if(!actor.LegionCrossed && (direction>0 && actor.State.X>739 || direction<0 && actor.State.X<61))
            {actor.State.X=direction>0?-250:1050;actor.LegionCrossed=true;cast.NativeAffected.Clear();}
            if(actor.LegionCrossed && (direction>0 && actor.State.X>cast.OriginX-80 || direction<0 && actor.State.X<cast.OriginX+80))
                actor.LegionVelocity=(cast.OriginX-actor.State.X)/.25;
            actor.State.X+=actor.LegionVelocity*dt;
        }
        void LegionFinish(Unit actor,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==682 && actor.Cast.NativeHitCount>0)
            {
                var speed=DependentSkill(actor,686,skill.Level);
                foreach(var ally in Affected(actor,actor,speed.Definition.Crystal).ToArray())ApplySkill(actor,ally,speed);
            }
            if(id!=684)return;
            var old=actor.Buffs.FirstOrDefault(b=>b.Definition.SourceId==10006801 && b.Remaining<5);
            if(old!=null)old.Remaining=Arg(skill.Definition.Crystal,2)-5;
            else if(actor.State.Alive)ApplyBuff(actor,actor,skill,10006801,Arg(skill.Definition.Crystal,2));
            actor.LegionCharging=false;actor.LegionVelocity=0;
        }
        void LegionBeforeDamage(Unit target)
        {
            if(!ExpandedRules || target.Data.SourceId!=68 || Native(target,684) is not BattleSkillData charge)return;
            target.LegionDamageCount++;target.LegionDamageCycle++;
            if(target.LegionDamageCycle<10)return;
            target.LegionChargePower=target.LegionDamageCount*(BasicAmount(charge)+Evo(charge,"ChargeDamageBonus"));
            target.LegionDamageCycle-=10;target.Cooldowns[charge.Definition.Id]=.1;
        }
    }
}
