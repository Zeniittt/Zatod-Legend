using System;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        void MonkSetup(Unit actor)
        {
            if(actor.Data.SourceId!=10028)return;
            var entry=DependentSkill(actor,1288,1);entry.SlotId="native_entry";actor.Skills.Insert(0,entry);
            actor.Cooldowns[entry.Definition.Id]=entry.Definition.Crystal.InitialCooldown;
            ApplyBuff(actor,actor,entry,11002813);
        }
        void MonkStart(Unit actor,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;var cast=actor.Cast;
            if(id==1288)
            {
                foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==11002813))buff.Remaining=0;
                ApplyBuff(actor,actor,skill,11002812);return;
            }
            if(id==1281)cast.Phase=actor.MonkBasics++%2;
            if(id is 1280 or 1282 or 1283)
            {cast.MonkSuper=actor.MonkQi>=3;cast.Phase=cast.MonkSuper?1:0;}
            if(id==1280)
            {
                cast.MonkOriginalInfo=skill.Definition.Crystal.Copy();var info=skill.Definition.Crystal;
                if(cast.MonkSuper)
                {info.PlusRatio=2+actor.MonkQi*.4;info.NoDodge=true;info.BasicAmount=Arg(info,2);info.Growth.RemoveAll(g=>g.Field=="Basic Num");}
                else {info.PlusRatio=.3+actor.MonkQi*.1;info.BasicAmount+=Evo(skill,"MonkWeakDamageBonus");}
                if(Evo(skill,"MonkUltimateGuard")>0)ApplyBuff(actor,actor,skill,11002811);
            }
            if(id is 1280 or 1281 or 1282 or 1283)actor.State.Action=skill.Definition.Crystal.Phases[cast.Phase].Action;
        }
        bool MonkRelease(Unit actor,Unit target,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId,count=actor.Cast?.AttackCounter??1;var cast=actor.Cast;
            if(id==1280)
            {
                if(count==1)
                {
                    double direction=target.State.X>=actor.State.X?1:-1;actor.State.FacingRight=direction>0;
                    actor.State.X=target.State.X-direction*(cast.MonkSuper?75:50);actor.State.Y=target.State.Y;
                    if(cast.MonkSuper && Evo(skill,"MonkUltimateDebuff")>0)ApplyBuff(actor,target,skill,11002815);
                    return true;
                }
                if(cast.MonkSuper && count>=3 || !cast.MonkSuper && count>=13)
                {actor.State.X=cast.OriginX;actor.State.Y=cast.OriginY;return true;}
                var strike=new BattleSkillData{Level=skill.Level,Definition=skill.Definition.Copy()};
                if(!cast.MonkSuper && count==12){strike.Definition.Crystal.NoDodge=true;strike.Definition.Crystal.KnockUp=.8;strike.Definition.Crystal.KnockBack=5;}
                ApplySkill(actor,target,strike);
                if(cast.MonkSuper)
                {
                    var splash=DependentSkill(actor,1289,skill.Level);
                    foreach(var victim in Affected(actor,target,splash.Definition.Crystal).Where(u=>u!=target).ToArray())ApplySkill(actor,victim,splash);
                }
                return true;
            }
            if(id==1282 && cast.MonkSuper && count==3)
            {
                var splash=DependentSkill(actor,12810,skill.Level);splash.Definition.Crystal.PlusRatio=Evo(skill,"MonkSplashRatio",.2);
                foreach(var victim in Affected(actor,actor,splash.Definition.Crystal).ToArray())ApplySkill(actor,victim,splash);
                return true;
            }
            if(id!=1283)return false;
            var push=new BattleSkillData{Level=skill.Level,Definition=skill.Definition.Copy()};var metadata=push.Definition.Crystal;
            if(cast.MonkSuper)
            {
                if(count==1)metadata.BuffId=0;
                else {metadata.PlusRatio=Evo(skill,"MonkPushRatio",metadata.PlusRatio);metadata.NoDodge=Evo(skill,"MonkPushNoDodge")>0;}
            }
            else {metadata.BuffId=0;metadata.KnockUp=.1;metadata.KnockBack=20;}
            foreach(var victim in Affected(actor,target,metadata).ToArray())ApplySkill(actor,victim,push);
            GainEnergy(actor,metadata.GainEnergy*initial.EnergyGainMultiplier);return true;
        }
        void MonkSpendQi(Unit actor,int remaining)
        {
            for(int i=actor.MonkQi;i>remaining;i--)
                foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==11002800+i))buff.Remaining=0;
            actor.MonkQi=remaining;
        }
        void MonkFinish(Unit actor,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;var cast=actor.Cast;
            if(id==1280)
            {
                foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==11002811))buff.Remaining=0;
                if(cast.MonkSuper)MonkSpendQi(actor,0);
                if(cast.MonkOriginalInfo!=null)skill.Definition.Crystal=cast.MonkOriginalInfo;
            }
            if(id is 1282 or 1283 && cast.MonkSuper)MonkSpendQi(actor,actor.MonkQi-1);
            if(id==1288)foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==11002812))buff.Remaining=0;
        }
        void MonkTick(Unit actor)
        {
            var passive=Native(actor,1284);
            if(passive!=null)
            {
                actor.MonkQiElapsed+=StepSeconds;
                if(actor.MonkQi<5 && actor.MonkQiElapsed>=Evo(passive,"MonkQiInterval",4))
                {
                    actor.MonkQi++;actor.MonkQiElapsed=0;ApplyBuff(actor,actor,passive,11002800+actor.MonkQi);
                    actor.Buffs.Last(b=>b.Definition.SourceId==11002800+actor.MonkQi).Modifiers["damage"]=Arg(passive.Definition.Crystal,2)+Evo(passive,"MonkQiAttack");
                }
            }
            foreach(var push in actor.Buffs.Where(b=>b.Definition.SourceId==11002817).ToArray())
            {
                if(push.NativeCharges>0)continue;
                if(push.FearX*(actor.State.X-push.NativeDamage)<0)actor.State.X+=push.FearX*1000*StepSeconds;
                else
                {
                    push.NativeCharges=1;var caster=Find(push.CasterId);if(caster==null)continue;
                    var blast=DependentSkill(caster,1286,push.SourceSkill.Level);
                    foreach(var victim in Affected(caster,actor,blast.Definition.Crystal).ToArray())ApplySkill(caster,victim,blast);
                    Effect(blast.Definition.Crystal.PointEffect,"point",actor);
                }
            }
        }
    }
}
