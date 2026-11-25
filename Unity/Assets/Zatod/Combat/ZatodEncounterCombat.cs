using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        void NpcSetup(Unit unit)
        {
            MonkSetup(unit);
            var melee=Native(unit,413);var basic=Native(unit,411);var passive=Native(unit,414);
            if(melee!=null && basic!=null)basic.Definition.Crystal.PlusRatio=1.3;
            if(passive!=null)
            {
                if(basic!=null)basic.Definition.Crystal.Cooldown=basic.Definition.Crystal.GlobalCooldown=3-Arg(passive.Definition.Crystal,2);
                if(melee!=null)melee.Definition.Crystal.Cooldown=melee.Definition.Crystal.GlobalCooldown=2.5-Arg(passive.Definition.Crystal,3);
            }
        }
        void RestoreDirect(Unit target,double amount)
        {
            if(!target.State.Alive || amount<=0)return;
            double previous=target.State.Hp;target.State.Hp=Math.Min(target.State.MaxHp,target.State.Hp+amount);
            RecordHealing(target,target.State.Hp-previous);CombatEvent(target,"heal",target.State.Hp-previous,sourceActorId:target.State.EntityId);
        }
        bool NpcApply(Unit actor,Unit target,BattleSkillData skill,double multiplier,double duration,double bonus)
        {
            if(skill.Definition.Crystal.SourceId==1149 && target.State.EntityId==actor.ClockwerkBlinkTarget)return true;
            if(skill.Definition.Crystal.SourceId==11102 && !skill.Definition.Crystal.NoDodge && Evo(skill,"MarsNoDodge")>0)skill.Definition.Crystal.NoDodge=true;
            if(skill.Definition.Crystal.SourceId==1149 && Native(actor,1142) is BattleSkillData blink && Evo(blink,"BlinkSplashStun")>0)ApplyBuff(actor,target,blink,11001409);
            if(skill.Definition.Crystal.SourceId==553 && target.Summoner!=null && skill.Definition.Crystal.BuffId!=10005505)
            {
                var cask=new BattleSkillData{Level=skill.Level,Definition=skill.Definition.Copy()};cask.Definition.Crystal.BuffId=10005505;
                ApplySkill(actor,target,cask,damageMultiplier:multiplier,buffDurationOverride:duration,powerBonus:bonus);return true;
            }
            if(skill.Definition.Crystal.SourceId==432 && skill.Definition.Crystal.BuffId!=10004303 && actor.State.Team!=target.State.Team)
            {
                var curse=new BattleSkillData{Level=skill.Level,Definition=skill.Definition.Copy()};curse.Definition.Crystal.BuffId=10004303;
                ApplySkill(actor,target,curse,damageMultiplier:multiplier,buffDurationOverride:duration,powerBonus:bonus);return true;
            }
            if(skill.Definition.Crystal.SourceId!=422 || skill.Definition.Crystal.DamageType!="Heal" || actor.State.Team==target.State.Team)return false;
            var converted=new BattleSkillData{Level=skill.Level,Definition=skill.Definition.Copy()};
            double ratio=Evo(skill,"EnemyHealDamageRatio",2);
            converted.Definition.Crystal.DamageType="AP";converted.Definition.Crystal.BasicAmount*=ratio;
            converted.Definition.Crystal.PlusRatio*=ratio;
            foreach(var growth in converted.Definition.Crystal.Growth.Where(g=>g.Field=="Basic Num"))growth.Amount*=ratio;
            ApplySkill(actor,target,converted,damageMultiplier:multiplier,buffDurationOverride:duration,powerBonus:bonus);
            return true;
        }
        void NpcModifyBuff(Unit actor,Unit target,BattleSkillData skill,ZatodBuffDefinition definition,System.Collections.Generic.Dictionary<string,double> modifiers)
        {
            PudgeModifyBuff(actor,target,skill,definition,modifiers);
            if(definition.SourceId==11002201 && Evo(skill,"UndyingEnergyDrain")>0)modifiers["energy_regen"]=-Evo(skill,"UndyingEnergyDrain");
            if(definition.SourceId==11011005)
            {modifiers["damage"]=Arg(skill.Definition.Crystal,2)+Evo(skill,"MarsTauntAttack");modifiers["defense"]=Arg(skill.Definition.Crystal,3);modifiers["magic_resistance"]=Arg(skill.Definition.Crystal,4);}
            if(definition.SourceId==11007606 && Evo(skill,"DruidSleepDefenseRatio")>0)
            {modifiers["defense"]=-Math.Max(0,Get(target,"defense"))*Evo(skill,"DruidSleepDefenseRatio");modifiers["magic_resistance"]=-Math.Max(0,Get(target,"magic_resistance"))*Evo(skill,"DruidSleepDefenseRatio");}
            if(definition.SourceId==11004902)BroodRegionModifiers(actor,target,modifiers);
            if(definition.SourceId==10006805 && Native(actor,682) is BattleSkillData press)
                modifiers["haste"]=modifiers["action_speed"]=(actor.Cast?.NativeHitCount??0)*Arg(press.Definition.Crystal,2);
            if(definition.SourceId==10006504 && Evo(skill,"DoomEnergyDrain")>0)modifiers["energy_regen"]=-Evo(skill,"DoomEnergyDrain");
            if(definition.SourceId==10008101 && Evo(skill,"WolfEnergyDrain")>0)modifiers["energy_regen"]=-Evo(skill,"WolfEnergyDrain");
            if(definition.SourceId==10005101)modifiers["damage"]=Arg(skill.Definition.Crystal,4)+Arg(skill.Definition.Crystal,5)*Get(actor,"damage");
            if(skill.Definition.Crystal.SourceId==432 && definition.SourceId==10004303)
            {
                modifiers["health_regen"]=-Arg(skill.Definition.Crystal,2)-Evo(skill,"EnemyDotBonus");
                modifiers["heal_ratio"]=Arg(skill.Definition.Crystal,3)-Evo(skill,"EnemyHealingReduction");
            }
        }
        double NpcPower(Unit actor,Unit target,BattleSkillData skill,double power)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==21502 && actor.Summoner!=null && Native(actor.Summoner,1222) is BattleSkillData tomb)power=.55*Get(actor.Summoner,"ability_power")+Arg(tomb.Definition.Crystal,3);
            if(id==1228)power=actor.UndyingDrainDamage*Arg(skill.Definition.Crystal,2)/100;
            if(id==1494 && actor.BroodFirstTargets.Contains(target.State.EntityId))power*=Evo(skill,"BroodMarkedRatio",1);
            if(id==25002 && actor.Summoner!=null && Native(actor.Summoner,1492) is BattleSkillData spider)
            {
                power=(Get(actor.Summoner,"damage")+Get(actor.Summoner,"ability_power"))*Evo(spider,"SpiderPowerRatio",.05)+Arg(spider.Definition.Crystal,3);
                if(target.Buffs.Any(b=>b.Definition.SourceId==11004903) && Native(actor.Summoner,1493) is BattleSkillData mark)power*=Arg(mark.Definition.Crystal,2);
            }
            if(id==684 && actor.LegionChargePower>0)power=actor.LegionChargePower+Get(actor,"damage")*skill.Definition.Crystal.PlusRatio;
            if(id is 816 or 817 or 818 or 819 && actor.NativeForm!=null && Native(actor,810) is BattleSkillData wolf)
                power+=(Arg(wolf.Definition.Crystal,4)+Evo(wolf,"WolfEnergyAttack"))*skill.Definition.Crystal.PlusRatio*actor.State.Energy/1000;
            if(id==653 && units.Count(u=>u.State.Alive && u.Summoner==null && u.State.Team==actor.State.Team)<units.Count(u=>u.State.Alive && u.Summoner==null && u.State.Team!=actor.State.Team))power*=Evo(skill,"OutnumberedRatio",1.5);
            if(id==553 && target.Summoner!=null)power*=2;
            if(id is 950 or 951 or 952 or 953 && Native(actor,954) is BattleSkillData passive)
                power+=Math.Max(BasicAmount(passive),Arg(passive.Definition.Crystal,2)*target.State.Hp/target.State.MaxHp);
            if(id==460 && Evo(skill,"ManaVoidScaling")>0)power*=1+(target.State.MaxEnergy-target.State.Energy)/target.State.MaxEnergy;
            if(id==500)power+=Math.Min(actor.State.MaxHp*Evo(skill,"MaximumHealthDamageRatio"),Evo(skill,"MaximumHealthDamageCap"));
            return power;
        }
        void NpcReleased(Unit actor,BattleSkillData skill)
        {
            if(skill.Definition.Crystal.SourceId==523)ApplyBuff(actor,actor,skill,10005202);
            if(skill.Definition.Crystal.SourceId==520 && actor.State.Hp<=1)PhoenixLethal(actor);
            if(skill.Definition.Crystal.SourceId!=462 || actor.Cast?.Phase!=1 || Evo(skill,"BlinkShieldBase")<=0)return;
            foreach(var old in actor.Buffs.Where(b=>b.Definition.SourceId==10004601))old.Remaining=0;
            var dependent=initial.SkillDependencies.Single(s=>s.Crystal.SourceId==465).Copy();
            ApplyBuff(actor,actor,new BattleSkillData{Level=skill.Level,Definition=dependent},
                overrideShield:Evo(skill,"BlinkShieldBase")+Evo(skill,"BlinkShieldAttackRatio")*Get(actor,"damage"));
        }
        double NpcImmunity(Unit actor,Unit target,double immunity,bool holy,bool magic)
        {
            var bristle=target.Buffs.FirstOrDefault(b=>b.Definition.SourceId==10004901);
            if(!holy && bristle!=null && actor.State.FacingRight==target.State.FacingRight)
                immunity-=bristle.Modifiers.GetValueOrDefault(magic?"magic_immunity":"physical_immunity");
            return immunity;
        }
        bool NpcUndead(Unit target)=>!target.TrollUndeadUsed && target.Buffs.Any(b=>b.Definition.SourceId==10004101 &&
            b.SourceSkill!=null && Evo(b.SourceSkill,"UndeadWhileUlt")>0);
        void NpcBuffAdded(Unit target,ActiveBuff buff)
        {
            PhoenixBuffAdded(target,buff);
            DoomBuffAdded(target,buff);
            TerrorBuffAdded(target,buff);
            if(buff.Definition.SourceId==10007301)buff.PulseTimer=1;
            if(buff.Definition.SourceId==11002201)buff.PulseTimer=.25;
            if(buff.Definition.SourceId==11002817){var caster=Find(buff.CasterId);buff.FearX=caster.State.X>target.State.X?-1:1;buff.NativeDamage=buff.FearX>0?680:120;}
            if(buff.Definition.SourceId==11004304)DancerTravelAdded(target,buff);
            if(buff.Definition.SourceId==11007617)buff.PulseTimer=1;
            if(buff.Definition.SourceId==11007604 && buff.SourceSkill!=null)
            {
                buff.NativeDamage=buff.Definition.Stats.FirstOrDefault(s=>s.StatId=="health_regen")?.Value??0;
                foreach(var parameter in SkillEvolution.Active(buff.SourceSkill.Definition,buff.SourceSkill.Level).SelectMany(e=>e.ParameterChanges).Where(p=>p.Field=="BuffStat" && p.StatId=="health_regen"))
                    buff.NativeDamage=parameter.Mode==SkillParameterMode.Add?buff.NativeDamage+parameter.Value:parameter.Value;
            }
            if(buff.Definition.SourceId==11007612)DruidFearAdded(target,buff);
            if(HasControl(buff.Definition,"taunt") && target.Cast!=null && target.Cast.TargetId!=buff.CasterId)InterruptCast(target);
            if(buff.Definition.SourceId==10005101 && buff.SourceSkill!=null)
            {
                buff.NativeCharges=(int)Evo(buff.SourceSkill,"RefractionCharges",Arg(buff.SourceSkill.Definition.Crystal,2));
                buff.NativeShieldCapacity=buff.Definition.ShieldValue;
            }
            if(buff.Definition.SourceId==10004001)
            {
                buff.PulseTimer=.375;buff.Definition.Effect="eff_buff_DP_ult.cha";
                buff.Definition.EffectLayer=ZatodBuffEffectLayer.BehindActor;
                buff.Definition.EffectScale=1/Math.Max(.001,target.Data.ArtScale);
            }
            if(buff.Definition.SourceId==10004305)buff.PulseTimer=1;
        }
        void NpcBuffRemoved(Unit target,ActiveBuff buff,bool expired)
        {
            var skill=buff.SourceSkill;if(skill==null)return;
            PhoenixBuffRemoved(target,buff);
            DoomBuffRemoved(target,buff);
            TerrorBuffRemoved(target,buff);
            PudgeBuffRemoved(target,buff,expired);
            if(buff.Definition.SourceId==11002201)ExitNativeForm(target);
            if(buff.Definition.SourceId==11007615)target.DruidBearDying=false;
            if(buff.Definition.SourceId==11004307 && expired && target.State.Alive)
            {var caster=Find(buff.CasterId);if(caster!=null)ApplyBuff(caster,target,DependentSkill(caster,14310,skill.Level));}
            if(buff.Definition.SourceId==10006101)ExitNativeForm(target);
            if(buff.Definition.SourceId==10004405 && target.State.Alive && Evo(skill,"CycloneLandingBuff")>0)
            {var caster=Find(buff.CasterId);if(caster!=null)ApplyBuff(caster,target,skill,(int)Evo(skill,"CycloneLandingBuff"));}
            if(buff.Definition.SourceId==10004001)Heal(target,buff.NativeDamage*Evo(skill,"GhostEndHealRatio",.65),target);
            if(buff.Definition.SourceId==10004101 && buff.CasterId==target.State.EntityId && Evo(skill,"UndeadWhileUlt")>0)target.TrollUndeadUsed=true;
            if(buff.Definition.SourceId==10004202 && (expired || buff.Remaining<0 || buff.Definition.ShieldValue<=0))
            {
                var actor=Find(buff.CasterId);if(actor==null)return;
                var explosion=new BattleSkillData{Level=skill.Level,Definition=skill.Definition.Copy()};
                var info=explosion.Definition.Crystal;info.AffectedCamp=-1;info.AoeOrigin="target";info.AoeShape="circle";info.ShapeArg1=200;
                info.DamageType="AP";info.BuffId=0;info.PointEffect="eff_point_DR_atk3.cha";info.ImpactEffect="eff_impact_LOA_atk2.cha";
                foreach(var victim in Affected(actor,target,info).ToArray())ApplySkill(actor,victim,explosion);
                Effect(info.PointEffect,"point",target);
            }
        }
        void NpcTick()
        {
            foreach(var actor in units.Where(u=>u.State.Alive).ToArray())
            {
                NpcNativeTick(actor);
                DoomNativeTick(actor);
                TerrorNativeTick(actor);
                PudgeTick(actor);
                TuskTick(actor);
                ClockwerkTick(actor);
                UndyingTick(actor);
                MonkTick(actor);
                DancerTick(actor);
                DruidTick(actor);
                BroodTick(actor);
                foreach(var taunt in actor.Buffs.Where(b=>HasControl(b.Definition,"taunt") && Find(b.CasterId)?.State.Alive!=true).ToArray())RemoveEvolutionBuff(actor,taunt,false);
                if(actor.Buffs.Any(b=>b.Definition.SourceId==10006104))
                    foreach(var debuff in actor.Buffs.Where(b=>b.Definition.Dispel=="YES" && Find(b.CasterId)?.State.Team!=actor.State.Team).ToArray())RemoveEvolutionBuff(actor,debuff,false);
                foreach(var burn in actor.Buffs.Where(b=>b.Definition.SourceId==10004305).ToArray())
                {
                    burn.PulseTimer-=StepSeconds;
                    while(burn.PulseTimer<=0)
                    {
                        burn.PulseTimer+=1;var spell=Native(actor,10036);if(spell==null)continue;
                        foreach(var victim in Affected(actor,actor,spell.Definition.Crystal).ToArray())ApplySkill(actor,victim,spell);
                    }
                }
                foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==10004001 && b.SourceSkill!=null).ToArray())
                {
                    if(buff.Elapsed>=9)buff.Definition.Effect=null;
                    if(buff.Elapsed>=8.5)continue;
                    buff.PulseTimer-=StepSeconds;
                    while(buff.PulseTimer<=0)
                    {
                        buff.PulseTimer+=.375;
                        var ghost=new BattleSkillData{Level=buff.SourceSkill.Level,Definition=buff.SourceSkill.Definition.Copy()};
                        var info=ghost.Definition.Crystal;info.BuffId=0;info.DamageType="AP";info.TargetCamp=info.AffectedCamp=-1;info.TargetType="random";info.AoeOrigin=null;
                        var victim=Target(actor,info,ClosestEnemy(actor));if(victim==null)continue;
                        double previous=victim.State.Hp;ApplySkill(actor,victim,ghost);
                        double lost=Math.Max(0,previous-victim.State.Hp);buff.NativeDamage+=lost;
                        if(Evo(buff.SourceSkill,"GhostLeechRatio")>0)Heal(actor,lost*Evo(buff.SourceSkill,"GhostLeechRatio"),actor);
                    }
                }
                var shield=actor.Buffs.FirstOrDefault(b=>b.Definition.SourceId==10004201);
                double poison=-Get(actor,"health_regen");
                if(shield!=null && poison>0 && !Controlled(actor,"noHPR") && !Controlled(actor,"unheal"))
                {
                    double amount=Math.Min(shield.Definition.ShieldValue,poison*(1-Math.Min(.99,Get(actor,"dot_resistance")/100))*StepSeconds);
                    RestoreDirect(actor,2*amount);shield.Definition.ShieldValue-=amount;
                    if(shield.Definition.ShieldValue<=0)shield.Remaining=0;
                }
                var quills=Native(actor,493);
                if(quills!=null && actor.BristleDamage>=actor.State.MaxHp*Evo(quills,"BristleDamageStep",.2))
                {
                    foreach(var victim in Affected(actor,actor,quills.Definition.Crystal).ToArray())ApplySkill(actor,victim,quills);
                    GainEnergy(actor,quills.Definition.Crystal.GainEnergy*initial.EnergyGainMultiplier);
                    actor.BristleDamage-=actor.State.MaxHp*Evo(quills,"BristleDamageStep",.2);
                }
            }
        }
    }
}
