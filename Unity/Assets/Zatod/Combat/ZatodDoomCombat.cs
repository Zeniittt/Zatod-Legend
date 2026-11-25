using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        void NpcInterrupted(Unit actor,Cast cast)
        {
            if(cast.NativeFinished)return;
            var info=cast.Skill.Definition.Crystal;
            if(info.SourceId==650)GainEnergy(actor,info.CostEnergy*(1-Math.Min(50,Get(actor,"energy_cost_reduction"))/100));
            if(info.SourceId==654 && cast.AttackCounter==0)actor.Cooldowns[cast.Skill.Definition.Id]=1;
        }
        void NpcDevourUnavailable(Unit actor,BattleSkillData skill)
        {
            InterruptCast(actor);actor.Cooldowns[skill.Definition.Id]=1;actor.GlobalCooldown=skill.Definition.Crystal.GlobalCooldown*.5;
        }
        void DoomBuffAdded(Unit target,ActiveBuff buff)
        {
            if(buff.Definition.SourceId!=10006503 || buff.SourceSkill==null)return;
            var caster=Find(buff.CasterId);caster.DoomActive=true;
            ApplyBuff(caster,caster,buff.SourceSkill,10006504);
            if(!Controlled(target,"undoom"))ApplyBuff(caster,target,buff.SourceSkill,10006508);
        }
        void DoomBuffRemoved(Unit target,ActiveBuff buff)
        {
            if(buff.Definition.SourceId!=10006503)return;
            var caster=Find(buff.CasterId);if(caster!=null)caster.DoomActive=false;
            foreach(var old in target.Buffs.Where(b=>b.Definition.SourceId==10006508))old.Remaining=0;
        }
        void DoomNativeTick(Unit actor)
        {
            foreach(var curse in actor.Buffs.Where(b=>b.Definition.SourceId==10006503).ToArray())
            {
                var caster=Find(curse.CasterId);
                if(caster==null || !caster.State.Alive || !caster.DoomActive || caster.State.Energy<=0){RemoveEvolutionBuff(actor,curse,false);continue;}
                if(actor.State.Hp<=1 && actor.Buffs.Any(b=>b.Definition.SourceId==10006508))
                    Damage(caster,actor,-curse.Modifiers.GetValueOrDefault("health_regen")*StepSeconds,"Holy",0);
            }
            if(actor.DoomActive && actor.State.Energy<=0)actor.DoomActive=false;
            if(!actor.DoomActive)
                foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==10006504).ToArray())RemoveEvolutionBuff(actor,buff,false);
        }
    }
}
