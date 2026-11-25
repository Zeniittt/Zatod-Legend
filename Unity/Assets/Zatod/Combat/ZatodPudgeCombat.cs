using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        BattleSkillData DependentSkill(Unit actor,int sourceId,int level)
        {
            var definition=initial.SkillDependencies.Single(s=>s.Crystal.SourceId==sourceId).Copy();
            foreach(var growth in definition.Crystal.Growth)
                if(growth.Field.StartsWith("Script Arg",StringComparison.Ordinal) && int.TryParse(growth.Field.Substring(10),out int arg) && arg>0 && arg<=definition.Crystal.ScriptArgs.Count)
                    definition.Crystal.ScriptArgs[arg-1]+=(level-1)*growth.Amount;
            SkillEvolution.ApplyParameters(definition,level);
            return new BattleSkillData{Definition=definition,Level=level};
        }
        void PudgeStart(Unit actor,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==730 && Evo(skill,"HookGuard")>0 || id==733 && Evo(skill,"BiteGuard")>0)ApplyBuff(actor,actor,skill,10007307);
        }
        bool PudgeRelease(Unit actor,Unit target,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==730)return true; // Hook contact, not the puppet attack marker, releases it.
            if(id!=733)return false;
            var cast=actor.Cast;int count=cast?.AttackCounter??1;
            target=cast==null?target:Find(cast.TargetId);
            if(target==null || !target.State.Alive){InterruptCast(actor);return true;}
            if(count<=5)
            {
                var bite=new BattleSkillData{Level=skill.Level,Definition=skill.Definition.Copy()};
                if(count>1)bite.Definition.Crystal.BuffId=0;
                double previous=target.State.Hp;ApplySkill(actor,target,bite);Heal(actor,Math.Max(0,previous-target.State.Hp),actor);
                if(cast!=null)cast.PudgeHolding=target.Buffs.Any(b=>b.Definition.SourceId==10007303 && b.CasterId==actor.State.EntityId);
                if(count>1 && target.State.Alive && !Controlled(target,"uncontrollable") && Random()>Get(target,"reshurt")*.001)
                {InterruptCast(target);target.HurtRemaining=target.Data.HurtSeconds;target.State.Action="Damaged";target.State.ActionElapsed=0;target.State.DamageReactionTick=tick;}
            }
            else
            {
                var kick=DependentSkill(actor,737,skill.Level);kick.Definition.Crystal.PlusRatio=Evo(skill,"PlusRatio",kick.Definition.Crystal.PlusRatio);
                ApplySkill(actor,target,kick);
            }
            GainEnergy(actor,skill.Definition.Crystal.GainEnergy*initial.EnergyGainMultiplier);
            return true;
        }
        void PudgeAdvance(Unit actor,double dt)
        {
            var cast=actor.Cast;int id=cast.Skill.Definition.Crystal.SourceId;var target=Find(cast.TargetId);
            if(id!=730 || cast.PudgeHookHit || target==null || !target.State.Alive || Controlled(target,"invulnerable"))return;
            double time=cast.Elapsed+dt;
            if(time<1.5 || time>2.25)return;
            double reach=(1274+(4992-1274)*(time-1.5)/.75)*.0646875*actor.Data.ArtScale;
            double x=actor.State.X+reach*(actor.State.FacingRight?1:-1)-15;
            if(Math.Abs(target.State.X-x)>=50)return;
            cast.PudgeHookHit=true;
            if(!Controlled(target,"stable"))
            {
                target.State.X=actor.State.X+(actor.State.FacingRight?80:-80);target.State.Y=actor.State.Y;
                target.VerticalSpeed=.2*1800/2;target.State.Height=Math.Max(.001,target.State.Height);
            }
            ApplySkill(actor,target,cast.Skill);
            cast.Elapsed=4.083333-.375-dt; // AdvanceCast adds dt immediately after this callback.
        }
        void PudgeFinish(Unit actor,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;if(id is not (730 or 733))return;
            if(id==733)
                foreach(var target in units)
                foreach(var buff in target.Buffs.Where(b=>b.Definition.SourceId==10007303 && b.CasterId==actor.State.EntityId))buff.Remaining=0;
            foreach(var guard in actor.Buffs.Where(b=>b.Definition.SourceId==10007307).ToArray())RemoveEvolutionBuff(actor,guard,false);
            if(id==730 && Native(actor,733) is BattleSkillData bite && Evo(bite,"BiteAfterHook")>0)
            {actor.GlobalCooldown=0;actor.Cooldowns[bite.Definition.Id]=0;}
        }
        void PudgeModifyBuff(Unit actor,Unit target,BattleSkillData skill,ZatodBuffDefinition definition,Dictionary<string,double> modifiers)
        {
            if(definition.SourceId==10007301 && Evo(skill,"RotNoSelfDamage")>0)modifiers["health_regen"]=0;
            if(definition.SourceId==10007302 && Native(actor,732) is BattleSkillData rot)
                modifiers["health_regen"]=modifiers.GetValueOrDefault("health_regen")-Math.Min(actor.State.Hp*Evo(rot,"RotCurrentHealthRatio"),Evo(rot,"RotCurrentHealthCap"));
        }
        void PudgeBuffRemoved(Unit target,ActiveBuff buff,bool expired)
        {
            if(buff.Definition.SourceId!=10007303 || expired)return;
            var caster=Find(buff.CasterId);
            if(caster?.Cast?.Skill.Definition.Crystal.SourceId==733 && !caster.Cast.NativeFinished)InterruptCast(caster);
        }
        void PudgeTick(Unit actor)
        {
            foreach(var rot in actor.Buffs.Where(b=>b.Definition.SourceId==10007301 && b.SourceSkill!=null).ToArray())
            {
                rot.PulseTimer-=StepSeconds;
                if(rot.PulseTimer>=0)continue;
                rot.PulseTimer+=1;
                var enemy=DependentSkill(actor,736,rot.SourceSkill.Level);
                foreach(var victim in Affected(actor,actor,enemy.Definition.Crystal).ToArray())ApplySkill(actor,victim,enemy);
            }
            if(actor.Cast?.Skill.Definition.Crystal.SourceId==733 && actor.Cast.AttackCounter>0 &&
                (Find(actor.Cast.TargetId)?.State.Alive!=true || !actor.Cast.PudgeHolding))InterruptCast(actor);
        }
    }
}
