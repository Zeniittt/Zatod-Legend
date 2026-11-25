using System;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        bool NativeBuffEligible(Unit actor,Unit target,BattleSkillData skill,ZatodBuffDefinition buff)
        {
            // battle/buff.lua.checkAddBuff; direct BuffCreate/addBuff hooks bypass
            // this check, so keep it at skill delivery rather than ApplyBuff.
            double hitLevel=skill.Level+Get(actor,"ehit"),missLevel=target.Data.Level+Get(target,"emiss");
            if(buff.LevelCheckDice!=0 && hitLevel<missLevel && Random()>=Math.Max(.3,1-(missLevel-hitLevel)*.05))
            {CombatEvent(target,"miss",0,sourceActorId:actor.State.EntityId);return false;}
            if(!string.IsNullOrEmpty(buff.ResistAttribute) && Random()<Get(target,Attribute(buff.ResistAttribute))/100)
            {CombatEvent(target,"resist",0,sourceActorId:actor.State.EntityId);return false;}
            return true;
        }
        void NativeSkillKnock(Unit actor,Unit target,ZatodSkillDefinition info,bool buffLanded)
        {
            if(!buffLanded || !target.State.Alive || Controlled(target,"stable"))return;
            double time=info.KnockUp,distance=info.KnockBack,resistance=Get(target,"knockres",1);
            if(resistance>=0 && resistance<1){time*=Math.Sqrt(resistance);distance*=resistance;}
            if(target.Data.IsTitan && !actor.Data.IsTitan)
            {
                double ratio=target.Data.Stars>actor.Data.Stars?1d/(4*(target.Data.Stars-actor.Data.Stars+1)):.25;
                time*=Math.Sqrt(ratio);distance*=ratio;
            }
            if(time>0){target.VerticalSpeed=time*900;target.State.Height=Math.Max(.001,target.State.Height);}
            if(distance!=0)
            {
                target.KnockRemaining=Math.Max(StepSeconds,time);
                double direction=target.State.X==actor.State.X?(actor.State.FacingRight?1:-1):Math.Sign(target.State.X-actor.State.X);
                target.KnockVelocity=direction*distance/target.KnockRemaining;
            }
        }
    }
}
