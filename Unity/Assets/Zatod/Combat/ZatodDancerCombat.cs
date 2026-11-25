using System;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        string NativeDeathAction(Unit actor)
        {
            if(ExpandedRules && actor.Data.SourceId==10043 && tick>=300 && Random()<.1 && actor.Data.AlternateDeathSeconds>0)
            {actor.Data.DeathSeconds=actor.Data.AlternateDeathSeconds;return "Death2";}
            return "Death";
        }
        void DancerStart(Unit actor,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId;
            if(id==1432){ApplyBuff(actor,actor,skill,11004301);SceneEffect("eff_point_Luna_night.cha",actor,400,0,ZatodBuffEffectLayer.WorldActors);}
            if(id==1434 && Evo(skill,"DancerComboGuard")>0)ApplyBuff(actor,actor,skill,11004305);
        }
        bool DancerRelease(Unit actor,Unit target,BattleSkillData skill)
        {
            int id=skill.Definition.Crystal.SourceId,count=actor.Cast?.AttackCounter??1;
            if(id==1430)
            {
                var candidates=units.Where(u=>u!=target && u.State.Alive && CampMatches(actor,u,skill.Definition.Crystal.TargetCamp) && !Controlled(u,"untargetable") && !Controlled(u,"uncontrollable") && !HiddenFrom(actor,u) && u.State.X>=0 && u.State.X<=800)
                    .Select(u=>new{Unit=u,Score=Random()}).OrderByDescending(u=>u.Score).ToArray();
                foreach(var victim in candidates.Length>0?new[]{target,candidates[0].Unit}:new[]{target})
                {
                    var shot=CreateShot(actor,victim,skill,0,true);double duration=(shot.Height-30)/-shot.VZ;
                    if(duration>0){shot.VX=(victim.State.X-shot.X)/duration;shot.VY=(victim.State.Y-shot.Y)/duration;}
                }
                return true;
            }
            if(id==1432 && Evo(skill,"DancerTeamSlow")>0)
            {
                var slow=DependentSkill(actor,1437,skill.Level);
                foreach(var victim in units.Where(u=>u.State.Alive && CampMatches(actor,u,slow.Definition.Crystal.AffectedCamp)).ToArray())ApplyBuff(actor,victim,slow);
                return false;
            }
            if(id!=1434)return false;
            if(count==1){actor.State.X=target.State.X+(target.State.X>actor.State.X?-100:100);actor.State.Y=target.State.Y;return true;}
            if(count>=5){actor.State.X=actor.Cast.OriginX;actor.State.Y=actor.Cast.OriginY;return true;}
            var strike=new BattleSkillData{Level=skill.Level,Definition=skill.Definition.Copy()};var info=strike.Definition.Crystal;
            var victimTarget=Target(actor,new ZatodSkillDefinition{TargetType="nearest",TargetCamp=-1,MaxRange=800},target)??target;
            if(count==4){info.TrackType="projectile";CreateShot(actor,victimTarget,strike,Math.Min(count-1,info.Phases[0].AttackTimes.Count-1),false);}
            else
            {
                if(count==3){info.AoeOrigin="self";info.AoeShape="circle";info.ShapeArg1=130;}
                foreach(var victim in Affected(actor,victimTarget,info).ToArray())ApplySkill(actor,victim,strike);
            }
            GainEnergy(actor,info.GainEnergy*initial.EnergyGainMultiplier);return true;
        }
        void DancerFinish(Unit actor,BattleSkillData skill)
        {
            int buff=skill.Definition.Crystal.SourceId==1432?11004301:skill.Definition.Crystal.SourceId==1434?11004305:0;
            if(buff!=0)foreach(var guard in actor.Buffs.Where(b=>b.Definition.SourceId==buff).ToArray())RemoveEvolutionBuff(actor,guard,false);
        }
        ActiveBuff DancerPrepare(Unit caster,Unit target,BattleSkillData skill,int id,double x,double y,bool hasPoint)
        {
            ApplyBuff(caster,target,skill,id);var buff=target.Buffs.LastOrDefault(b=>b.Definition.SourceId==id && b.CasterId==caster.State.EntityId);
            if(buff!=null){buff.NativeTravelPoint=hasPoint;buff.NativeDestinationX=x;buff.NativeDestinationY=y;buff.NativeCharges=0;buff.Elapsed=0;}
            return buff;
        }
        void DancerTravelAdded(Unit target,ActiveBuff travel)
        {
            var caster=Find(travel.CasterId);var skill=travel.SourceSkill;if(caster==null)return;
            double direction=caster.Data.Team==0?1:-1;
            if(!Controlled(target,"building") && !Controlled(target,"stable"))
            {
                var far=Target(caster,DependentSkill(caster,1438,skill.Level).Definition.Crystal,null);
                double offset=60;
                if(far==null){far=units.Where(u=>u.State.Alive && CampMatches(caster,u,1) && u.State.X>=0 && u.State.X<=800).OrderByDescending(u=>Distance(caster,u)).ThenByDescending(u=>u.State.EntityId).FirstOrDefault();offset=20;}
                double x=far!=null?far.State.X+direction*offset:target.State.X+200*direction;
                travel.NativeTravelPoint=true;travel.NativeReturnX=target.State.X;travel.NativeReturnY=target.State.Y;
                DancerPrepare(caster,target,skill,11004309,x,target.State.Y,true);
            }
            var enemy=units.Where(u=>u.State.Alive && CampMatches(caster,u,-1) && !Controlled(u,"building") && !Controlled(u,"stable") && !Controlled(u,"untargetable") && !Controlled(u,"invulnerable") && !Controlled(u,"uncontrollable") && !HiddenFrom(caster,u) &&
                direction*(u.State.X-caster.State.X)>=-200 && direction*(u.State.X-caster.State.X)<=80 && Math.Abs(u.State.Y-caster.State.Y)<=100)
                .OrderBy(u=>Distance(caster,u)).ThenByDescending(u=>u.State.EntityId).FirstOrDefault();
            if(enemy!=null)DancerPrepare(caster,enemy,skill,11004310,caster.State.X+direction*350,enemy.State.Y,true);
        }
        void DancerTick(Unit actor)
        {
            if(Native(actor,1432)!=null && !actor.DancerLeading)
            {actor.DancerLeading=true;actor.State.X=actor.Data.Team==0?170:630;actor.State.FacingRight=actor.Data.Team==0;}
            foreach(var buff in actor.Buffs.Where(b=>b.Definition.SourceId is 11004309 or 11004310).ToArray())
            {
                if(buff.Elapsed<.5)continue;
                if(!buff.NativeTravelPoint || Controlled(actor,"building") || Controlled(actor,"stable")){RemoveEvolutionBuff(actor,buff,false);continue;}
                if(buff.NativeCharges==0){actor.VerticalSpeed=.75*900;actor.State.Height=Math.Max(.001,actor.State.Height);buff.NativeCharges=1;}
                if(buff.Elapsed<1)continue;
                actor.State.X=buff.NativeDestinationX;actor.State.Y=buff.NativeDestinationY;actor.State.Height=200;actor.VerticalSpeed=0;
                SceneEffect("eff_point_Dancer_atk3b.cha",actor,actor.State.X,actor.State.Y,ZatodBuffEffectLayer.AboveBattlefield);
                RemoveEvolutionBuff(actor,buff,false);
            }
            foreach(var travel in actor.Buffs.Where(b=>b.Definition.SourceId==11004304 && b.Elapsed>=10).ToArray())
            {
                bool finalEvent=actor.Cast!=null && actor.Cast.Phase==actor.Cast.Skill.Definition.Crystal.Phases.Count-1 && actor.Cast.Event>=actor.Cast.Skill.Definition.Crystal.Phases[actor.Cast.Phase].AttackTimes.Count;
                if(actor.Cast?.ManualStartup==true || actor.Cast!=null && !finalEvent)continue;
                var caster=Find(travel.CasterId);
                if(caster!=null && travel.NativeTravelPoint && !Controlled(actor,"building") && !Controlled(actor,"stable"))
                    DancerPrepare(caster,actor,travel.SourceSkill,11004309,travel.NativeReturnX,travel.NativeReturnY,true);
                RemoveEvolutionBuff(actor,travel,false);
            }
        }
    }
}
