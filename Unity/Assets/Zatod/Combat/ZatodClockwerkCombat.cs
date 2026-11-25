using System;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        void ClockwerkStart(Unit actor,Unit target,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==1143){actor.ClockwerkTargetX=target.State.X;actor.ClockwerkTargetY=target.State.Y;}
            if(id==1147){actor.ClockwerkOverheat=true;ApplyBuff(actor,actor,skill,11001410);}
        }
        bool ClockwerkRelease(Unit actor,Unit target,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId,count=actor.Cast?.AttackCounter??1;
            if(id==1140 && count==1)return true;
            if(id!=1142)return false;
            if(count==1){ApplyBuff(actor,actor,skill,11001405);return true;}
            if(count==2)
            {
                actor.ClockwerkBlinkTarget=target.State.EntityId;
                double offset=target.State.X+35>=750 || target.State.X+35<=50?-35:35;
                actor.State.X=target.State.X+offset;actor.State.Y=target.State.Y;ApplySkill(actor,target,skill);
                GainEnergy(actor,skill.Definition.Crystal.GainEnergy*initial.EnergyGainMultiplier);return true;
            }
            var splash=DependentSkill(actor,1149,skill.Level);
            foreach(var victim in Affected(actor,actor,splash.Definition.Crystal).ToArray())ApplySkill(actor,victim,splash);
            InterruptCast(actor);return true;
        }
        void ClockwerkFinish(Unit actor,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id is 1140 or 1142 or 1143 && Native(actor,1144)!=null)
            {actor.ClockwerkHeat++;actor.ClockwerkHeatVisual=++visualId;}
            if(id==1142)foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==11001405))buff.Remaining=0;
            if(id==1147)
            {
                actor.ClockwerkOverheat=false;actor.ClockwerkHeat=0;actor.ClockwerkHeatVisual=0;
                foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==11001410))buff.Remaining=0;
            }
        }
        void ClockwerkTick(Unit actor)
        {
            foreach(var mark in actor.Buffs.Where(b=>b.Definition.SourceId==11001403 && b.Stacks>=2).ToArray())
            {
                var caster=Find(mark.CasterId);if(caster==null)continue;
                ApplySkill(caster,actor,DependentSkill(caster,1146,mark.SourceSkill.Level));RemoveEvolutionBuff(actor,mark,false);
            }
            if(actor.Data.SourceId!=10014 || Native(actor,1144)==null || actor.ClockwerkHeat<3 || actor.ClockwerkOverheat ||
               Controlled(actor,"stun") || actor.Cast==null || actor.Cast.Skill.Definition.Crystal.SourceId==1140)return;
            Start(actor,DependentSkill(actor,1147,Native(actor,1144).Level),actor);
        }
        double ClockwerkReduction(Unit target)
        {
            var passive=Native(target,1144);if(passive==null)return 1;
            double reduction=(Arg(passive.Definition.Crystal,2)+Evo(passive,"HeatReductionBonus"))*target.ClockwerkHeat*.01;
            if(target.ClockwerkOverheat)reduction+=(Arg(passive.Definition.Crystal,3)+Evo(passive,"OverheatReductionBonus"))*.01;
            return Math.Max(0,1-reduction);
        }
        void ClockwerkDamageReceived(Unit actor,Unit target,string type,double lost,bool transferred)
        {
            if(!ExpandedRules || transferred || type!="AD" || lost<=0 || !actor.State.Alive || !target.ClockwerkOverheat || Native(target,1144) is not BattleSkillData passive || Evo(passive,"OverheatReflectBase")<=0)return;
            Damage(target,actor,Evo(passive,"OverheatReflectBase")+Evo(passive,"OverheatReflectRatio")*Get(target,"damage"),"AD",1,null,true);
        }
        bool ClockwerkUpdateShot(Unit actor,Shot shot)
        {
            if(shot.Skill.Definition.Crystal.SourceId!=1143 || Math.Abs(shot.X-shot.NativeOriginX)<100)return false;
            shots.Remove(shot);
            SceneEffect("eff_point_CG_atk3.cha",actor,shot.X,shot.Y-1,ZatodBuffEffectLayer.AboveBattlefield,shot.VX>=0);
            visualEffects[visualEffects.Count-1].Height=shot.Height;
            int[][] offsets={new[]{0,0},new[]{-45,0},new[]{-70,30},new[]{0,0},new[]{-70,-30},new[]{-100,0}};
            var skill=DependentSkill(actor,1148,shot.Skill.Level);skill.Definition.Crystal.PlusRatio=Evo(shot.Skill,"MissileRatio",skill.Definition.Crystal.PlusRatio);
            for(int i=0;i<3;i++)
            {
                var missile=CreateShot(actor,Find(shot.TargetId)??actor,skill,0,false);var info=skill.Definition.Crystal;
                double duration=(-info.ProjectileZSpeed-Math.Sqrt(info.ProjectileZSpeed*info.ProjectileZSpeed-2*info.Gravity*shot.Height))/info.Gravity;
                var offset=offsets[actor.ClockwerkMissiles%2*3+i];double x=actor.ClockwerkTargetX+offset[0]*(actor.Data.Team==0?1:-1),y=actor.ClockwerkTargetY+offset[1];
                missile.X=shot.X;missile.Y=shot.Y;missile.Height=shot.Height;missile.VX=(x-shot.X)/duration;missile.VY=(y-shot.Y)/duration;
            }
            actor.ClockwerkMissiles++;return true;
        }
    }
}
