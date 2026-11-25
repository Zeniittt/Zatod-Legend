using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        void CaptureBroodBaseline()
        {
            foreach(var unit in units.Where(u=>u.State.Alive && !u.BroodBaselineCaptured))
            {unit.BroodBaselineDamage=Get(unit,"damage");unit.BroodBaselineCaptured=true;}
        }
        Unit BroodSpiderTarget(Unit actor)
        {
            var preferred=Find(actor.BroodPreferredTarget);
            if(preferred?.State.Alive==true && preferred.Summoner==null && !Controlled(preferred,"untargetable") && !HiddenFrom(actor,preferred))return preferred;
            return units.Where(u=>u.State.Alive && CampMatches(actor,u,-1) && u.Summoner==null && !Controlled(u,"untargetable") && !HiddenFrom(actor,u) && u.State.X>=0 && u.State.X<=800)
                .OrderBy(u=>u.State.Hp).ThenBy(u=>u.State.EntityId).FirstOrDefault();
        }
        void BroodStart(Unit actor,Unit target,BattleSkillData skill)
        {
            if(skill.Definition.Crystal.SourceId!=1494)return;
            ApplyBuff(actor,actor,skill,11004904);
            var selected=units.Where(u=>u.State.Alive && CampMatches(actor,u,-1) && u.Summoner==null && !Controlled(u,"untargetable") && !Controlled(u,"invulnerable") && u.State.X>=0 && u.State.X<=800)
                .OrderByDescending(u=>100+(Controlled(u,"stun") || Controlled(u,"frozen") || Controlled(u,"icefrozen") || Controlled(u,"immoblilize") || Controlled(u,"building")?75:0)).ThenBy(u=>u.State.EntityId).FirstOrDefault();
            if(selected!=null)actor.Cast.TargetId=selected.State.EntityId;
        }
        bool BroodRelease(Unit actor,Unit target,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId,count=actor.Cast?.AttackCounter??1;
            if(id==1490)
            {
                foreach(var victim in Affected(actor,target,skill.Definition.Crystal).ToArray())ApplySkill(actor,victim,skill);
                if(!actor.BroodHasNest){ReleaseSummon(actor,skill.Definition.Id,skill.Definition.Crystal.Summon,actor.Data.Team==0?100:700,0);actor.BroodHasNest=true;}
                return true;
            }
            if(id==24903 && actor.Summoner!=null)
            {
                var owner=actor.Summoner;var spawn=Native(owner,1492);if(spawn==null)return true;
                double radius=35+Random()*(5-35),angle=(180+Random()*180)*Math.PI/180;
                owner.State.Energy-=Arg(spawn.Definition.Crystal,2)-Evo(spawn,"SpiderCostReduction");
                ReleaseSummon(owner,spawn.Definition.Id,spawn.Definition.Crystal.Summon,actor.State.X+radius*Math.Cos(angle),actor.State.Y+radius*Math.Sin(angle));return true;
            }
            if(id!=1494)return false;
            if(count==1)
            {
                actor.BroodSlamX=target.State.X;actor.BroodSlamY=target.State.Y;actor.State.X=target.State.X;actor.State.Y=120;actor.BroodAbove=true;
                actor.BroodFirstTargets.Clear();foreach(var victim in Affected(actor,target,skill.Definition.Crystal,actor.BroodSlamX,actor.BroodSlamY))actor.BroodFirstTargets.Add(victim.State.EntityId);
                SceneEffect("eff_point_BR_atk4.cha",actor,actor.BroodSlamX,actor.BroodSlamY,ZatodBuffEffectLayer.BehindBattlefieldActors);return true;
            }
            if(count==2)
            {CreateShot(actor,target,skill,Math.Min(1,skill.Definition.Crystal.Phases[0].AttackTimes.Count-1),false);GainEnergy(actor,skill.Definition.Crystal.GainEnergy*initial.EnergyGainMultiplier);return true;}
            actor.State.X=actor.Cast.OriginX;actor.State.Y=actor.Cast.OriginY;actor.BroodAbove=false;return true;
        }
        void BroodSummoned(Unit caster,string skillId,Unit unit)
        {
            var parent=caster.Skills.Single(s=>s.Definition.Id==skillId);
            if(unit.Data.SourceId==249)
            {
                ApplyBuff(unit,unit,parent,11004901);CaptureBroodBaseline();
                var field=Native(unit,24902);CreateRegion(unit,unit,field);var region=regions[regions.Count-1];
                region.VisualResource="eff_point_BR_ult_2.cha";region.VisualId=++visualId;region.X=caster.Data.Team==0?800:0;region.Y=0;
            }
            else
            {
                ApplyBuff(unit,unit,parent,11004907);
                unit.BroodPreferredTarget=units.FirstOrDefault(u=>u.State.Alive && u.State.Team!=unit.State.Team && u.Buffs.Any(b=>b.Definition.SourceId==11004903))?.State.EntityId??0;
                if(unit.Data.BirthSeconds>0){unit.BirthRemaining=unit.Data.BirthSeconds;unit.State.Action="Birth";unit.State.ActionElapsed=0;}
            }
        }
        double BroodCampWeight(Unit owner,int team)
        {
            var ult=Native(owner,1490);
            return units.Where(u=>u.State.Alive && u.State.Team==team).Sum(u=>u.Summoner==null?1:Controlled(u,"building")?0:team==owner.State.Team?Evo(ult,"NestSummonWeight",.1):.1);
        }
        void BroodRegionModifiers(Unit nest,Unit target,Dictionary<string,double> modifiers)
        {
            var owner=nest.Summoner;if(owner==null || Native(owner,1490) is not BattleSkillData ult)return;
            double number=BroodCampWeight(owner,target.State.Team);if(number<=0)return;
            var info=ult.Definition.Crystal;
            modifiers["damage"]=target.State.Team==owner.State.Team?
                (Arg(info,2)+Arg(info,3)/100*target.BroodBaselineDamage)*number:
                -(Arg(info,4)+Arg(info,5)/100*target.BroodBaselineDamage)/number;
        }
        void BroodCreateShot(Unit actor,Unit target,Shot shot)
        {
            if(shot.Skill.Definition.Crystal.SourceId==1493)Ballistic(shot,actor,target,0,0);
            if(shot.Skill.Definition.Crystal.SourceId==1494)
            {shot.X=actor.BroodSlamX;shot.Y=actor.BroodSlamY;shot.Height=150;shot.VX=shot.VY=shot.VZ=0;}
        }
        void BroodFinish(Unit actor,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==25002){KillNativeSummon(actor);return;}
            if(id!=1494)return;
            if(actor.BroodAbove && actor.Cast!=null){actor.State.X=actor.Cast.OriginX;actor.State.Y=actor.Cast.OriginY;actor.BroodAbove=false;}
            foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId==11004904))buff.Remaining=0;
        }
        void BroodTick(Unit actor)
        {
            if(Native(actor,1490)!=null)
            {
                CaptureBroodBaseline();var spawn=Native(actor,1492);
                var nest=units.FirstOrDefault(u=>u.Summoner==actor && u.Data.SourceId==249 && u.State.Alive);
                if(nest!=null && spawn!=null && nest.Cast==null && actor.State.Energy>=Arg(spawn.Definition.Crystal,2)-Evo(spawn,"SpiderCostReduction"))
                {var attack=Native(nest,24903);var target=ClosestEnemy(nest);if(target!=null)Start(nest,attack,target);}
            }
            foreach(var aura in actor.Buffs.Where(b=>b.Definition.SourceId==11004902).ToArray())
            {var nest=Find(aura.CasterId);if(nest!=null)BroodRegionModifiers(nest,actor,aura.Modifiers);}
        }
    }
}
