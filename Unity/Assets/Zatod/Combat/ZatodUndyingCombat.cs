using System;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        void UndyingStart(Unit actor,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==1223)actor.UndyingDrainDamage=0;
            if(id==21502)
            {
                actor.Cast.Phase=actor.Buffs.Any(b=>b.Definition.SourceId==11002204)?1:0;
                actor.State.Action=skill.Definition.Crystal.Phases[actor.Cast.Phase].Action;
            }
        }
        bool UndyingRelease(Unit actor,Unit target,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==21401 && actor.Summoner!=null)
            {
                UndyingCreateZombie(actor.Summoner,actor.State.X,actor.State.Y);
                actor.State.Hp=Math.Max(0,actor.State.Hp-1);
                if(!actor.State.Alive)UndyingTombstoneExhausted(actor);
                return true;
            }
            if(id!=1222)return false;
            var tomb=units.FirstOrDefault(u=>u.Summoner==actor && u.State.Alive && u.Data.SourceId==214);
            if(tomb!=null){tomb.State.Hp=Math.Min(tomb.State.MaxHp,tomb.State.Hp+4);Effect("eff_impact_heal.cha","impact",tomb);}
            else ReleaseSummon(actor,skill.Definition.Id,skill.Definition.Crystal.Summon,actor.Data.Team==0?150:650,0);
            GainEnergy(actor,skill.Definition.Crystal.GainEnergy*initial.EnergyGainMultiplier);return true;
        }
        void UndyingTombstoneExhausted(Unit tomb)
        {
            // setHP(0) ends the summon without a damage reward or last-hit MP.
            tomb.State.Action="Death";tomb.State.ActionElapsed=tomb.State.DeathElapsed=0;tomb.State.Energy=0;tomb.State.DeathWave=wave+1;InterruptCast(tomb);
            foreach(var buff in tomb.Buffs.Where(b=>b.Definition.ClearOnDeath).ToArray())RemoveEvolutionBuff(tomb,buff,false);
            RecordDeath(null,tomb);
        }
        void UndyingSummoned(Unit caster,string skillId,Unit unit)
        {
            var skill=caster.Skills.Single(s=>s.Definition.Id==skillId);
            if(unit.Data.SourceId==214)
            {
                var basic=unit.Skills.Single(s=>s.SlotId=="basic");basic.Definition.Crystal.Cooldown=basic.Definition.Crystal.GlobalCooldown=Evo(skill,"TombstoneInterval",7);
                ApplyBuff(unit,unit,skill,11002202);
            }
            else
            {
                unit.Base["health"]=3;unit.State.MaxHp=unit.State.Hp=3;
                ApplyBuff(unit,unit,skill,11002203);
                var passive=Native(caster,1224);
                if(passive!=null && Evo(passive,"ZombieArmorBuff")>0)ApplyBuff(unit,caster,passive,11002205);
            }
        }
        void UndyingCreateZombie(Unit owner,double x,double y)
        {
            var tomb=Native(owner,1222);if(tomb==null)return;
            double radius=15+Random()*20,angle=Random()*2*Math.PI;
            var config=tomb.Definition.Crystal.Summon.Copy();config.MonsterId=config.AlternateMonsterId;config.AlternateMonsterId=null;config.Persistent=false;
            ReleaseSummon(owner,tomb.Definition.Id,config,x+radius*Math.Cos(angle),y+radius*Math.Sin(angle));
        }
        void UndyingSummonDied(Unit unit)
        {
            if(!ExpandedRules || unit.Data.SourceId!=215 || unit.Summoner==null)return;
            var owner=unit.Summoner;var reward=DependentSkill(owner,1227,Native(owner,1222).Level);var passive=Native(owner,1224);
            Heal(owner,Arg(reward.Definition.Crystal,2)+(passive==null?0:Evo(passive,"ZombieDeathHealth")),owner);
            GainEnergy(owner,Arg(reward.Definition.Crystal,3)+(passive==null?0:Evo(passive,"ZombieDeathEnergy")));
        }
        void UndyingFinish(Unit actor,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==1220 && actor.State.Alive && actor.Buffs.Any(b=>b.Definition.SourceId==11002201))EnterNativeForm(actor,skill);
            if(id==12210)
                foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==11002201).ToArray())RemoveEvolutionBuff(actor,buff,false);
            if(id!=1223)return;
            var heal=DependentSkill(actor,1228,skill.Level);
            foreach(var target in units.Where(u=>u==actor || u.Summoner==actor && u.Data.SourceId is 214 or 215).ToArray())
                if(target.State.Alive)ApplySkill(actor,target,heal);
            actor.UndyingDrainDamage=0;
        }
        void UndyingTick(Unit actor)
        {
            foreach(var ult in actor.Buffs.Where(b=>b.Definition.SourceId==11002201).ToArray())
            {
                ult.PulseTimer-=StepSeconds;
                while(ult.PulseTimer<=0)
                {
                    ult.PulseTimer+=2;Heal(actor,actor.State.MaxHp*.02,actor);
                    var pulse=DependentSkill(actor,1226,ult.SourceSkill.Level);
                    var target=Target(actor,pulse.Definition.Crystal,ClosestEnemy(actor));
                    if(target!=null)foreach(var victim in Affected(actor,actor,pulse.Definition.Crystal).ToArray())ApplySkill(actor,victim,pulse);
                    Effect(pulse.Definition.Crystal.PointEffect,"point",actor);
                }
                if(actor.State.Energy<=50 && actor.Cast==null)Start(actor,DependentSkill(actor,12210,ult.SourceSkill.Level),actor);
            }
            if(Native(actor,1224)==null || actor.UndyingReceivedDamage<actor.State.MaxHp*.2*(actor.UndyingZombieCount+1))return;
            UndyingCreateZombie(actor,actor.State.X,actor.State.Y);Effect("eff_point_UD_atk4.cha","point",actor);actor.UndyingZombieCount++;
        }
    }
}
