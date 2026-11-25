using System;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        bool NpcRelease(Unit actor,Unit target,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId,counter=actor.Cast?.AttackCounter??1;
            if(LycanRelease(actor,target,skill))return true;
            if(TerrorRelease(actor,target,skill))return true;
            if(PudgeRelease(actor,target,skill))return true;
            if(LegionRelease(actor,target,skill))return true;
            if(TuskRelease(actor,target,skill))return true;
            if(ClockwerkRelease(actor,target,skill))return true;
            if(UndyingRelease(actor,target,skill))return true;
            if(MonkRelease(actor,target,skill))return true;
            if(DancerRelease(actor,target,skill))return true;
            if(DruidRelease(actor,target,skill))return true;
            if(BroodRelease(actor,target,skill))return true;
            if(id==610)return true;
            if(id==654)
            {
                if(counter==1)
                {
                    if(target==null || target.Summoner==null){NpcDevourUnavailable(actor,skill);return true;}
                    Damage(actor,target,Arg(skill.Definition.Crystal,2)+Evo(skill,"DevourDamageBonus"),"Holy",1);
                    GainEnergy(actor,skill.Definition.Crystal.GainEnergy*initial.EnergyGainMultiplier*(1+Get(actor,"mpratio")/100));
                }
                return true;
            }
            if(id is 950 or 953 && counter==1)
            {
                double direction=target.State.X>actor.State.X?-1:1,x=target.State.X-direction*42;
                if(Controlled(target,"stable") || x>799 || x<1){x+=2*direction*42;direction=-direction;}
                actor.State.X=x;actor.State.Y=target.State.Y;actor.State.FacingRight=direction>0;
                ApplyBuff(actor,actor,skill,10009503);return true;
            }
            if(id==952 && counter==4)
            {
                var finisher=new BattleSkillData{Level=skill.Level,Definition=skill.Definition.Copy()};finisher.Definition.Crystal.PlusRatio=Evo(skill,"FinalHitAttackRatio",1);finisher.Definition.Crystal.NoDodge=true;
                ApplySkill(actor,target,finisher);GainEnergy(actor,skill.Definition.Crystal.GainEnergy*initial.EnergyGainMultiplier);
                if(target.State.Alive && !Controlled(target,"uncontrollable") && !Controlled(target,"invulnerable"))
                {
                    ApplyBuff(actor,target,skill,10009501);
                    if(Random()>Get(target,"reshurt")*.001){FinishSpecial(target);InterruptCast(target);target.HurtRemaining=target.Data.HurtSeconds;target.State.Action="Damaged";target.State.ActionElapsed=0;target.State.DamageReactionTick=tick;}
                }
                return true;
            }
            if(id==512)
            {
                ApplyBuff(actor,actor,skill);GainEnergy(actor,skill.Definition.Crystal.GainEnergy*initial.EnergyGainMultiplier);return true;
            }
            if(id==510)
            {
                if(counter==1)
                {actor.State.X=target.State.X+(actor.State.FacingRight?120:-120);actor.State.Y=target.State.Y;actor.State.FacingRight=!actor.State.FacingRight;actor.Cast.TargetId=target.State.EntityId;return true;}
                target=Find(actor.Cast.TargetId)??target;
                if(counter==2)ApplySkill(actor,target,skill);
                else
                {
                    var splash=new BattleSkillData{Level=skill.Level,Definition=skill.Definition.Copy()};splash.Definition.Crystal.AoeOrigin="target";splash.Definition.Crystal.PointEffect=null;
                    foreach(var victim in Affected(actor,target,splash.Definition.Crystal).ToArray())ApplySkill(actor,victim,splash);
                    actor.State.X=actor.Cast.OriginX;actor.State.Y=actor.Cast.OriginY;
                }
                if(counter==2)Effect(skill.Definition.Crystal.PointEffect,"point",target);
                return true;
            }
            if(id!=440)return false;
            var attack=new BattleSkillData{Level=skill.Level,Definition=skill.Definition.Copy()};var info=attack.Definition.Crystal;
            int[] forward={0,15,10,15,5,15,5,5,5,5};int index=counter-1;
            if(counter==1){info.TrackType="projectile";info.BuffId=0;CreateShot(actor,target,attack,index,false);return true;}
            info.KnockUp=index<5?.1:index==5?.6:.5;info.KnockBack=index<5?10:index==5?20:5;
            info.MoveForward=index<forward.Length?forward[index]:0;
            if(index==5)
            {
                double x=actor.State.X+50*(actor.State.FacingRight?1:-1);
                if(!Controlled(target,"stable")){target.State.X=x+20*(actor.State.FacingRight?1:-1);target.State.Y=actor.State.Y;}
                EffectAt("eff_point_Panda_ult.cha","point",actor,x,actor.State.Y,0);
            }
            foreach(var victim in Affected(actor,target,info).ToArray())ApplySkill(actor,victim,attack);
            actor.State.X=Math.Clamp(actor.State.X+info.MoveForward*(actor.State.FacingRight?1:-1),20,780);
            return true;
        }
        bool NpcRefractionRefresh(Unit actor,BattleSkillData skill)
        {
            var buff=actor.Buffs.FirstOrDefault(b=>b.Definition.SourceId==10005101);if(buff==null)return false;
            buff.NativeCharges=Math.Min((int)Evo(skill,"RefractionMaximum",6),buff.NativeCharges+(int)Evo(skill,"RefractionCharges",Arg(skill.Definition.Crystal,2)));
            buff.Remaining=15;return true;
        }
        void NpcShieldDamaged(Unit target,ActiveBuff buff)
        {
            if(buff.Definition.SourceId!=10005101 || buff.SourceSkill==null)return;
            buff.NativeCharges--;GainEnergy(target,Arg(buff.SourceSkill.Definition.Crystal,3)+Evo(buff.SourceSkill,"RefractionEnergyBonus"));
            buff.Definition.ShieldValue=buff.NativeCharges>0?buff.NativeShieldCapacity:0;
        }
        void NpcHit(Unit actor,Unit target,BattleSkillData skill,double lost)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==682 && actor.Cast!=null)actor.Cast.NativeHitCount++;
            if(id==1223)actor.UndyingDrainDamage+=lost;
            if(id==21502)ApplyBuff(actor,actor,skill,11002204);
            if(id==1434 && lost>0 && actor.Cast?.AttackCounter==2)
            {var stone=DependentSkill(actor,1439,skill.Level);if(NativeBuffEligible(actor,target,stone,buffs[stone.Definition.Crystal.BuffId]))ApplyBuff(actor,target,stone);}
            if(id==1494 && lost>0 && actor.BroodFirstTargets.Contains(target.State.EntityId) && Evo(skill,"BroodMarkedRatio")>0 && !Controlled(target,"uncontrollable"))ApplyBuff(actor,target,skill,11004908);
            if(id==25002 && target.State.Alive && actor.Cast?.AttackCounter==4 && actor.Summoner!=null && Native(actor.Summoner,1492) is BattleSkillData spider && Evo(spider,"SpiderSilence")>0)ApplyBuff(actor,target,skill,11004906);
            if(id==817 && actor.Cast?.Skill==skill && actor.Cast.AttackCounter==1)
                SceneEffect("eff_point_LYC_atk2_1.cha",actor,target.State.X,target.State.Y-1,ZatodBuffEffectLayer.WorldActors,actor.State.FacingRight);
            if(id==440 && target.State.Alive && Evo(skill,"PandaHolyAttackRatio")>0)
                Damage(actor,target,Get(actor,"damage")*Evo(skill,"PandaHolyAttackRatio"),"Holy",0);
            if(id!=514 || lost<=0)return;
            var splash=new BattleSkillData{Level=skill.Level,Definition=initial.SkillDependencies.Single(s=>s.Crystal.SourceId==515).Copy()};
            var info=splash.Definition.Crystal;info.BasicAmount=lost*(Arg(skill.Definition.Crystal,2)+Evo(skill,"BladeSplashBonus"))/100;
            if(Evo(skill,"BladeSplashHoly")>0)info.DamageType="Holy";
            foreach(var victim in Affected(actor,target,info).Where(u=>u!=target).ToArray())ApplySkill(actor,victim,splash);
            Effect(info.PointEffect,"point",target);
        }
        void NpcKilled(Unit killer,Unit victim)
        {
            if(killer==victim || victim.Summoner!=null || Native(killer,512) is not BattleSkillData skill || Evo(skill,"RefractionEntryAndKill")<=0)return;
            var buff=killer.Buffs.FirstOrDefault(b=>b.Definition.SourceId==10005101);
            if(buff!=null){buff.NativeCharges=Math.Min(buff.NativeCharges+2,(int)Evo(skill,"RefractionMaximum",6));buff.Remaining=15;return;}
            ApplyBuff(killer,killer,skill);buff=killer.Buffs.Last(b=>b.Definition.SourceId==10005101);buff.NativeCharges=2;buff.Remaining=15;
        }
        void NpcNativeTick(Unit actor)
        {
            actor.NativeEntryElapsed+=StepSeconds;
            if(!actor.NativeEntryRefractionUsed && actor.NativeEntryElapsed>=1 && Native(actor,512) is BattleSkillData refraction && Evo(refraction,"RefractionEntryAndKill")>0)
            {actor.NativeEntryRefractionUsed=true;actor.Cooldowns[refraction.Definition.Id]=0;}
            var wind=Native(actor,444);if(wind==null)return;
            if(actor.CycloneTimer<0)actor.CycloneTimer=Arg(wind.Definition.Crystal,3);
            actor.CycloneTimer-=StepSeconds;if(actor.CycloneTimer>0)return;
            actor.CycloneTimer=Math.Max(StepSeconds,Arg(wind.Definition.Crystal,2)-Evo(wind,"CycloneIntervalReduction"));
            if(units.Count(u=>u.State.Alive && u.State.Team!=actor.State.Team && u.Summoner==null)<=1)return;
            var target=Target(actor,wind.Definition.Crystal,ClosestEnemy(actor));if(target==null)return;
            foreach(var buff in target.Buffs.Where(b=>b.Definition.Dispel=="YES" && (Find(b.CasterId)==null || Find(b.CasterId).State.Team==target.State.Team)).ToArray())RemoveEvolutionBuff(target,buff,false);
            ApplySkill(actor,target,wind);if(!Controlled(target,"uncontrollable"))Effect("eff_point_DOTsr_atk2","point",target);
        }
    }
}
