using System;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        void PrepareNativeFormSkill(Unit actor,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==1221 && actor.NativeForm!=null){skill.Definition.Crystal.PlusRatio=1.2;return;}
            if(id==471)
            {
                var info=skill.Definition.Crystal;info.MaxRange+=150;info.Cooldown=info.GlobalCooldown=1.5;info.GainEnergy=60;
                info.TrackType="projectile";info.AoeOrigin=null;info.PlusRatio=1.6;info.ImpactEffect="eff_impact_TB_atk.cha";
                return;
            }
            int parent=id==817?812:id==818?813:id==819?814:0;
            if(parent==0)return;
            var source=Native(actor,parent);string field=id==817?"WolfShotRatio":id==818?"WolfRushRatio":"WolfFinisherRatio";
            if(source!=null)skill.Definition.Crystal.PlusRatio=Evo(source,field,skill.Definition.Crystal.PlusRatio);
        }
        bool LycanRelease(Unit actor,Unit target,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId,counter=actor.Cast?.AttackCounter??1;
            if(id==813)
            {
                if(counter==1)ApplyBuff(actor,actor,skill,10008102);
                else {foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==10008102).ToArray())RemoveEvolutionBuff(actor,buff,false);return true;}
            }
            if(id==818)
            {
                if(counter==1){ApplyBuff(actor,actor,skill,10008102);return true;}
                if(counter==2)
                {
                    double direction=target.State.X>actor.State.X?1:-1,x=target.State.X-direction*70;
                    if(Controlled(target,"stable") || x>799 || x<1){x-=direction*70;x=x>799?780:x<1?10:x;}
                    actor.State.X=x;actor.State.Y=target.State.Y;return true;
                }
            }
            if(id==814 && counter>=3)
            {
                var attack=new BattleSkillData{Level=skill.Level,Definition=skill.Definition.Copy()};var info=attack.Definition.Crystal;info.PlusRatio=.7;
                if(counter==4){info.ShapeArg1=400;info.ShapeArg2=200;info.AoeShape="rectangle";info.MaxRange=400;}
                foreach(var victim in Affected(actor,target,info).ToArray())ApplySkill(actor,victim,attack);
                GainEnergy(actor,info.GainEnergy*initial.EnergyGainMultiplier);return true;
            }
            return false;
        }
        void LycanFinish(Unit actor,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==810)
            {
                EnterNativeForm(actor,skill);Heal(actor,Arg(skill.Definition.Crystal,2)+actor.State.MaxHp*Arg(skill.Definition.Crystal,3),actor);
                ApplyBuff(actor,actor,skill,10008101);
            }
            if(id is 810 or 813 or 818)
                foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==10008102).ToArray())RemoveEvolutionBuff(actor,buff,false);
        }
    }
}
