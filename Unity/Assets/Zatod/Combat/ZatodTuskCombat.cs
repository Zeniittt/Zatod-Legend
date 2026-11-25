using System;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        bool TuskRelease(Unit actor,Unit target,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId,counter=actor.Cast?.AttackCounter??1;
            if(id==1110)
            {
                if(counter==1){ApplyBuff(actor,actor,skill,11001108);CreateShot(actor,target,skill,0,false);}
                return true;
            }
            if(id==1117)
            {
                var punch=new BattleSkillData{Level=skill.Level,Definition=skill.Definition.Copy()};punch.Definition.Crystal.NoDodge=true;
                if(Native(actor,1110) is BattleSkillData ult)punch.Definition.Crystal.PlusRatio=Evo(ult,"TuskPunchRatio",punch.Definition.Crystal.PlusRatio);
                ApplySkill(actor,target,punch);return true;
            }
            if(id!=1112 || counter!=4)return false;
            var finisher=DependentSkill(actor,1116,skill.Level);finisher.Definition.Crystal.PlusRatio=Evo(skill,"TuskLastShotRatio",finisher.Definition.Crystal.PlusRatio);
            CreateShot(actor,target,finisher,0,true);return true;
        }
        void TuskCreateShot(Unit caster,Unit target,Shot shot)
        {
            int id=shot.Skill.Definition.Crystal.SourceId;
            if(id is 1112 or 1113 or 1116)shot.TrackTarget=true;
            if(id==1116){shot.X=caster.State.X+(caster.State.FacingRight?40:-40);shot.Y=caster.State.Y-10;shot.Height=115;}
        }
        void TuskUpdateShot(Unit actor,Shot shot)
        {
            if(shot.Skill.Definition.Crystal.SourceId!=1110)return;
            var target=Find(shot.TargetId);
            if(target==null || !target.State.Alive || Controlled(target,"untargetable"))
            {
                target=Target(actor,shot.Skill.Definition.Crystal,ClosestEnemy(actor));
                if(target==null){TuskTerminateShot(actor,shot);return;}
                shot.TargetId=target.State.EntityId;
            }
            double dx=target.State.X-shot.X,dy=target.State.Y-shot.Y,dz=40-shot.Height;
            if(shot.NativePreviousTargetX!=0 && shot.NativePreviousTargetX*dx<0){shot.VX/=10;shot.VY/=10;shot.VZ/=10;shot.NativePreviousTargetX=0;}
            else shot.NativePreviousTargetX=dx;
            double length=Math.Max(.001,Math.Sqrt(dx*dx+dy*dy+dz*dz));
            shot.VX+=dx/length*30;shot.VY+=dy/length*30;shot.VZ+=dz/length*30;
        }
        void TuskTerminateShot(Unit actor,Shot shot)
        {
            if(shot.Skill.Definition.Crystal.SourceId!=1110 || !shots.Remove(shot))return;
            foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==11001108).ToArray())RemoveEvolutionBuff(actor,buff,false);
            double direction=shot.X>actor.State.X?1:-1;actor.State.X=Math.Clamp(shot.X-direction*70,71,729);actor.State.Y=shot.Y;
            if(!actor.State.Alive)return;
            ApplyBuff(actor,actor,shot.Skill,11001109);
            var punch=DependentSkill(actor,1117,shot.Skill.Level);actor.Cooldowns[punch.Definition.Id]=0;
            var victim=Find(shot.TargetId);
            if(victim?.State.Alive==true && Math.Abs(victim.State.X-actor.State.X)<=punch.Definition.Crystal.MaxRange)Start(actor,punch,victim);
            else foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==11001109))buff.Remaining=0;
        }
        bool? TuskForceCritical(Unit actor,BattleSkillData skill)
        {
            if(skill.Definition.Crystal.SourceId is not (1113 or 1116 or 1117))return null;
            if(!actor.TuskCharged)return null;
            actor.TuskCriticalUsed=true;
            foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==11001107))buff.Remaining=0;
            return true;
        }
        void TuskConsumeCritical(Unit actor)
        {
            if(actor.TuskCriticalUsed){actor.TuskCharged=false;actor.TuskCriticalUsed=false;}
        }
        void TuskFinish(Unit actor,BattleSkillData skill)
        {
            if(skill.Definition.Crystal.SourceId!=1117)return;
            foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==11001109))buff.Remaining=0;
            if(Native(actor,1110) is BattleSkillData ult && Evo(ult,"TuskPunchGuard")>0)ApplyBuff(actor,actor,ult,11001111);
            TuskConsumeCritical(actor);
        }
        void TuskTick(Unit actor)
        {
            var charge=Native(actor,1114);if(charge==null || actor.TuskCharged)return;
            actor.TuskChargeElapsed+=StepSeconds;
            if(actor.TuskChargeElapsed<BasicAmount(charge)-Evo(charge,"TuskChargeReduction"))return;
            actor.TuskChargeElapsed=0;actor.TuskCharged=true;ApplyBuff(actor,actor,charge,11001107);
            var buff=actor.Buffs.Last(b=>b.Definition.SourceId==11001107);
            if(Evo(charge,"TuskChargedPenetration")>0)buff.Modifiers["armor_penetration"]=Evo(charge,"TuskChargedPenetration");
        }
    }
}
