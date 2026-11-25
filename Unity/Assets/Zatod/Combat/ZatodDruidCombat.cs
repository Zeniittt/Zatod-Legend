using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        Unit DruidBear(Unit owner)=>units.FirstOrDefault(u=>u.Summoner==owner && u.Data.SourceId==266 && u.State.Alive);
        void DruidStart(Unit actor,BattleSkillData skill)
        {
            if(skill.Definition.Crystal.SourceId!=1762)return;
            var bear=DruidBear(actor);
            if(bear==null)
            {Start(actor,DependentSkill(actor,1767,skill.Level),actor);actor.Cooldowns[skill.Definition.Id]=skill.Definition.Crystal.Cooldown;}
            else ApplyBuff(actor,bear,skill,11007610);
        }
        bool DruidRelease(Unit actor,Unit target,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==1767)
            {
                ApplyBuff(actor,actor,skill,11007608);
                var parent=Native(actor,1762);
                if(DruidBear(actor)==null)ReleaseSummon(actor,parent.Definition.Id,parent.Definition.Crystal.Summon,actor.State.X>=400?800:0,actor.State.Y-40);
                actor.Cooldowns[parent.Definition.Id]=3;GainEnergy(actor,skill.Definition.Crystal.GainEnergy*initial.EnergyGainMultiplier);return true;
            }
            if(id==1762)
            {
                var bear=DruidBear(actor);if(bear==null || bear.DruidBearDying)return true;
                Start(bear,DependentSkill(bear,26605,skill.Level),bear);
                double ratio=bear.State.Hp/bear.State.MaxHp;
                if(bear.DruidBearStage<5)
                {
                    bear.DruidBearStage++;
                    var upgrade=ZatodMatchFactory.CopyBuff(buffs[11007603]);
                    foreach(var scaling in upgrade.Scaling)scaling.Ratio=Arg(skill.Definition.Crystal,2)/100;
                    ApplyBuff(actor,bear,skill,11007603,overrideDefinition:upgrade);bear.State.Hp=bear.State.MaxHp*ratio;
                }
                if(bear.DruidBearStage>=5)actor.Cooldowns[skill.Definition.Id]=999;
                var shot=CreateShot(actor,bear,skill,0,true);double gravity=shot.Skill.Definition.Crystal.Gravity;
                double duration=(-shot.VZ-Math.Sqrt(shot.VZ*shot.VZ-2*gravity*shot.Height))/gravity;
                if(duration>0){shot.VX=(bear.State.X+10-shot.X)/duration;shot.VY=(bear.State.Y-shot.Y)/duration;}
                GainEnergy(actor,skill.Definition.Crystal.GainEnergy*initial.EnergyGainMultiplier);return true;
            }
            if(id==26605)
            {DruidSetBearForm(actor);return true;}
            if(id!=1760)return false;
            if((actor.Cast?.AttackCounter??1)>1)return false;
            actor.DruidUltimateTick=tick;
            SceneEffect("eff_point_TitanDruid_ult.cha",actor,400,-50,ZatodBuffEffectLayer.AboveBattlefield);
            if(Evo(skill,"DruidBearUltimateBuff")>0 && DruidBear(actor) is Unit strong && !strong.DruidBearDying)
                ApplyBuff(strong,strong,skill,11007613);
            return true;
        }
        void DruidSetBearForm(Unit bear)
        {
            var skill=Native(bear.Summoner,1762);
            if(bear.NativeOriginalSkills!=null)bear.Skills=bear.NativeOriginalSkills;
            var level=Native(bear.Summoner,1763)?.Level??skill.Level;
            foreach(var active in bear.Skills)active.Level=level;
            EnterNativeForm(bear,skill,skill.Definition.Crystal.Summon.Forms[bear.DruidBearStage-1]);
        }
        void DruidSummoned(Unit owner,Unit bear)
        {
            var parent=Native(owner,1762);bear.DruidBearStage=1;
            var inherit=ZatodMatchFactory.CopyBuff(buffs[11007601]);
            foreach(var scaling in inherit.Scaling)scaling.Ratio=Arg(parent.Definition.Crystal,3)/100+Evo(parent,"BearInheritBonus");
            ApplyBuff(owner,bear,parent,11007601,overrideDefinition:inherit);
            bear.State.Hp=bear.State.MaxHp;bear.DruidBearBaseDamage=Get(bear,"damage");
            ApplyBuff(owner,bear,parent,11007617);DruidSetBearForm(bear);
        }
        double DruidTransfer(Unit target,double amount)
        {
            var bear=DruidBear(target);if(bear==null || bear.DruidBearDying || Native(target,1762)==null)return amount;
            Damage(target,bear,amount*.5,"Holy",1,null,true);return amount*.5;
        }
        bool DruidBearLethal(Unit bear)
        {
            if(bear.Data.SourceId!=266 || bear.Summoner?.State.Alive!=true)return false;
            bear.State.Hp=1;bear.DruidBearDying=true;InterruptCast(bear);bear.State.Action="Idle";bear.State.ActionElapsed=0;
            var parent=Native(bear.Summoner,1762);var recovery=ZatodMatchFactory.CopyBuff(buffs[11007615]);
            foreach(var scaling in recovery.Scaling.Where(s=>s.StatId=="health_regen"))scaling.Ratio=Evo(parent,"BearRecoveryRatio",.08);
            ApplyBuff(bear,bear,parent,11007615,999,overrideDefinition:recovery);
            foreach(var poison in bear.Buffs.Where(b=>b.Modifiers.GetValueOrDefault("health_regen")<0))poison.Remaining=0;
            return true;
        }
        void DruidBearDamaged(Unit bear,double lost,bool poison=false)
        {
            if(bear.Data.SourceId!=266 || bear.DruidBearDying || bear.DruidBearStage<2 || lost<=0)return;
            bear.DruidBearDamageReservoir+=Math.Min(poison?625:5000,lost);
            if(bear.DruidBearDamageReservoir<=5000 || Native(bear.Summoner,1763) is not BattleSkillData passive)return;
            bear.DruidBearBonusDamage=Math.Min(bear.DruidBearBaseDamage*1.2,bear.DruidBearBonusDamage+bear.DruidBearBaseDamage*Evo(passive,"BearDamageGrowthRatio",.03));
            bear.DruidBearDamageReservoir-=5000;
        }
        void DruidFearAdded(Unit target,ActiveBuff buff)
        {
            var bear=Find(buff.CasterId);var owner=bear?.Summoner;if(owner==null || Native(owner,1763) is not BattleSkillData passive || Evo(passive,"BearFearAttackReduction")<=0)return;
            ApplyBuff(bear,target,buff.SourceSkill,11007616);var reduction=target.Buffs.Last(b=>b.Definition.SourceId==11007616);
            reduction.Modifiers["damage"]=reduction.Modifiers["ability_power"]=-Evo(passive,"BearFearAttackReduction");
        }
        void DruidAdvance(Unit actor)
        {
            if(actor.DruidUltimateTick<0 || tick-actor.DruidUltimateTick<25)return;
            actor.DruidUltimateTick=-1;var ult=Native(actor,1760);var target=Target(actor,ult.Definition.Crystal,Find(actor.Cast?.TargetId??0)??ClosestEnemy(actor));
            if(target==null)return;
            if(actor.Cast?.Skill.Definition.Crystal.SourceId==1760){actor.Cast.AttackCounter++;actor.Cast.ManualStartup=false;}
            var spell=new BattleSkillData{Level=ult.Level,Definition=ult.Definition.Copy()};
            foreach(var victim in Affected(actor,target,spell.Definition.Crystal).ToArray())ApplySkill(actor,victim,spell);
        }
        void DruidFinish(Unit actor,BattleSkillData skill)
        {
            if(skill.Definition.Crystal.SourceId==1767)
                foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==11007608))buff.Remaining=0;
        }
        void DruidTick(Unit actor)
        {
            if(actor.Cast==null)DruidAdvance(actor);
            foreach(var bonus in actor.Buffs.Where(b=>b.Definition.SourceId==11007617).ToArray())
            {bonus.PulseTimer-=StepSeconds;if(bonus.PulseTimer<=0){bonus.PulseTimer=1;bonus.Modifiers["damage"]=actor.DruidBearBonusDamage;}}
            if(actor.DruidBearDying && actor.State.Hp>=actor.State.MaxHp)
                foreach(var recovery in actor.Buffs.Where(b=>b.Definition.SourceId==11007615).ToArray())RemoveEvolutionBuff(actor,recovery,true);
            foreach(var poison in actor.Buffs.Where(b=>b.Definition.SourceId==11007604).ToArray())
            {
                var caster=Find(poison.CasterId);var bear=caster==null?null:DruidBear(caster);if(bear==null)continue;
                double amount=Math.Min(Math.Max(0,-poison.NativeDamage*StepSeconds),actor.State.Hp)*actor.Data.DamageStatisticsRatio;
                Heal(bear,amount);
            }
        }
    }
}
