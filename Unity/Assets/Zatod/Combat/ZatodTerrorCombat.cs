using System;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        void TerrorStart(Unit actor,BattleSkillData skill)
        {
            if(skill.Definition.Crystal.SourceId!=470)return;
            foreach(var buff in actor.Buffs)actor.HiddenBuffEffects.Add(buff.VisualId);
            actor.TerrorTransforming=true;ApplyBuff(actor,actor,skill,10004704);
        }
        bool TerrorRelease(Unit actor,Unit target,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId,counter=actor.Cast?.AttackCounter??1;
            if(id==472){SpawnTerrorMirrors(actor,skill,actor.State.X,actor.State.Y);GainEnergy(actor,skill.Definition.Crystal.GainEnergy*initial.EnergyGainMultiplier);return true;}
            if(id==473){if(counter==1)TerrorSunder(actor,target,skill);return true;}
            if(id!=470)return false;
            if(counter==1){SceneEffect("eff_point_TB_ult3.cha",actor,actor.State.X,actor.State.Y,ZatodBuffEffectLayer.AboveBattlefield,actor.State.FacingRight,.85);return true;}
            ApplySkill(actor,actor,skill);
            if(Evo(skill,"DemonFearBuff")>0)
                foreach(var enemy in units.Where(u=>u.State.Alive && u.State.Team!=actor.State.Team && !Controlled(u,"invulnerable") && !Controlled(u,"uncontrollable")).ToArray())ApplyBuff(actor,enemy,skill,(int)Evo(skill,"DemonFearBuff"));
            var mirror=Native(actor,472);if(mirror==null)return true;
            SpawnTerrorMirrors(actor,mirror,actor.State.X,actor.State.Y);
            if(Evo(skill,"MirrorConvertOnTransform")>0)
                foreach(var old in units.Where(u=>u.State.Alive && u.State.Team==actor.State.Team && u.Data.SourceId==129 && u.Buffs.Any(b=>b.Definition.SourceId==10004702)).ToArray())
                {
                    KillNativeSummon(old);SpawnTerrorMirrors(actor,mirror,actor.State.X-50*Random(),actor.State.Y-100*Random(),true);
                }
            return true;
        }
        void SpawnTerrorMirrors(Unit actor,BattleSkillData skill,double x,double y,bool single=false)
        {
            var config=skill.Definition.Crystal.Summon.Copy();
            if(actor.TerrorDemon)config.MonsterId=config.AlternateMonsterId;
            if(single)config.Count=1;
            var before=units.Select(u=>u.State.EntityId).ToHashSet();ReleaseSummon(actor,skill.Definition.Id,config,x,y);
            int index=0;
            foreach(var unit in units.Where(u=>!before.Contains(u.State.EntityId)).OrderBy(u=>u.State.EntityId))
            {
                unit.State.X=x+(index==0?10:25);unit.State.Y=y+(index==0?45:-45);unit.PreviousX=unit.State.X;index++;
            }
        }
        void TerrorMirrorStats(Unit actor,string skillId,Unit mirror)
        {
            var skill=Native(actor,472);var inherited=ZatodMatchFactory.CopyBuff(buffs[10004703]);
            foreach(var scaling in inherited.Scaling)scaling.Ratio=Arg(skill.Definition.Crystal,3)/100;
            ApplyBuff(actor,mirror,skill,10004703,overrideDefinition:inherited);ApplyBuff(actor,mirror,skill,10004702);
            mirror.State.MaxHp=mirror.State.Hp=Math.Max(1,Get(mirror,"health"));mirror.State.MaxEnergy=Math.Max(1,Get(mirror,"energy_max"));mirror.State.HealthBar=new ZatodHealthBarState(1);
        }
        void TerrorBuffAdded(Unit actor,ActiveBuff buff)
        {
            if(buff.Definition.SourceId==10004701)
            {
                actor.TerrorDemon=true;EnterNativeForm(actor,buff.SourceSkill);
                var basic=Native(actor,471);actor.Cooldowns[basic.Definition.Id]=1.5;actor.GlobalCooldown=1.5;
            }
            if(buff.Definition.SourceId is 10004706 or 10004707 or 10004708 && Native(actor,474) is BattleSkillData passive)
            {
                double factor=buff.Definition.SourceId-10004705;buff.Modifiers["haste"]=Arg(passive.Definition.Crystal,2)*factor;buff.Modifiers["action_speed"]=Arg(passive.Definition.Crystal,3)*factor;
                if(factor<3)buff.Remaining=Arg(passive.Definition.Crystal,4);
            }
        }
        void TerrorBuffRemoved(Unit actor,ActiveBuff buff)
        {
            int id=buff.Definition.SourceId;
            if(id==10004701)
            {
                actor.TerrorDemon=false;ExitNativeForm(actor);var basic=Native(actor,471);if(basic!=null)actor.Cooldowns[basic.Definition.Id]=1;
                foreach(var haste in actor.Buffs.Where(b=>b.Definition.SourceId is 10004706 or 10004707 or 10004708).ToArray())RemoveEvolutionBuff(actor,haste,false);
                if(actor.State.Alive){actor.State.Action="Birth";actor.State.ActionElapsed=0;actor.BirthRemaining=actor.Data.BirthSeconds;}
                SceneEffect("eff_point_TB_ult.cha",actor,actor.State.X,actor.State.Y-1,ZatodBuffEffectLayer.WorldActors,actor.State.FacingRight);
            }
            if(actor.TerrorDemon && actor.State.Alive && id is 10004706 or 10004707 && Native(actor,474) is BattleSkillData passive)
                ApplyBuff(actor,actor,passive,id+1);
        }
        void TerrorFinish(Unit actor,BattleSkillData skill)
        {
            if(skill.Definition.Crystal.SourceId!=470)return;
            double x=actor.State.X-(actor.State.FacingRight?127:-127);if(x>0 && x<800)actor.State.X=x;
            foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==10004704).ToArray())RemoveEvolutionBuff(actor,buff,false);
            if(Native(actor,474) is BattleSkillData passive)ApplyBuff(actor,actor,passive,10004706);
            actor.HiddenBuffEffects.Clear();actor.TerrorTransforming=false;
        }
        void TerrorNativeTick(Unit actor)
        {
            if(Native(actor,473) is BattleSkillData skill && !actor.TerrorSunderUsed && actor.State.Hp/actor.State.MaxHp<.3)
            {actor.GlobalCooldown=0;actor.Cooldowns[skill.Definition.Id]=0;}
            if(actor.TerrorDemon && actor.State.Energy<=0)
                foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==10004701).ToArray())RemoveEvolutionBuff(actor,buff,false);
        }
        void TerrorSignedHeal(Unit actor,double amount)
        {
            if(!actor.State.Alive || Controlled(actor,"unheal"))return;
            double before=actor.State.Hp;actor.State.Hp=Math.Clamp(before+amount*(1+Math.Max(-1,Get(actor,"heal_ratio")/100)),0,actor.State.MaxHp);
            if(actor.State.Hp>before){RecordHealing(actor,actor.State.Hp-before);CombatEvent(actor,"heal",actor.State.Hp-before,sourceActorId:actor.State.EntityId);}
        }
        void TerrorSunder(Unit actor,Unit target,BattleSkillData skill)
        {
            actor.TerrorSunderUsed=true;actor.Cooldowns[skill.Definition.Id]=9999;var info=skill.Definition.Crystal;
            double oldHp=target.State.Hp,ownRatio=actor.State.Hp/actor.State.MaxHp;
            double desired=Math.Clamp(target.State.Hp/target.State.MaxHp,(Arg(info,2)+Evo(skill,"SunderMinimumBonus"))/100,(Arg(info,5)+Evo(skill,"SunderMaximumBonus"))/100);
            TerrorSignedHeal(actor,desired*actor.State.MaxHp-actor.State.Hp);
            double targetHp=Math.Max(Math.Max(ownRatio,Arg(info,3)/100)*target.State.MaxHp,target.State.Hp-Arg(info,4));
            if(targetHp<=oldHp)target.State.Hp=targetHp;else if(!target.Data.Boss)TerrorSignedHeal(target,targetHp-oldHp);
            if(oldHp>targetHp)GainEnergy(target,(oldHp-targetHp)/target.State.MaxHp*Get(target,"damage_energy_rate",1000)*(1+Get(target,"mpratio")/100));
            string art=actor.TerrorDemon?"eff_tile_TB_atk3.cha":"eff_tile_TB_atk3_2.cha";
            var beam=new BattleSkillData{Level=skill.Level,Definition=skill.Definition.Copy()};beam.Definition.Crystal.VisualOnly=true;beam.Definition.Crystal.ProjectileArt=art;
            CreateShot(actor,target,beam,0,true);var back=CreateShot(actor,actor,beam,0,true);back.X=target.State.X;back.Y=target.State.Y+5;
            double dx=actor.State.X-back.X,dy=actor.State.Y-back.Y,length=Math.Max(.001,Math.Sqrt(dx*dx+dy*dy));back.VX=dx/length*info.ProjectileSpeed;back.VY=dy/length*info.ProjectileSpeed;
            foreach(var unit in new[]{actor,target})
            {
                SceneEffect(unit==actor?"eff_impact_TB_atk3_2.cha":"eff_impact_TB_atk3.cha",actor,unit.State.X,unit.State.Y-1,ZatodBuffEffectLayer.AboveBattlefield,unit.State.FacingRight);
                SceneEffect(actor.TerrorDemon?"eff_impact_TB_atk3_4.cha":"eff_impact_TB_atk3_3.cha",actor,unit.State.X,unit.State.Y-1,ZatodBuffEffectLayer.AboveBattlefield,unit.State.FacingRight);
            }
        }
    }
}
