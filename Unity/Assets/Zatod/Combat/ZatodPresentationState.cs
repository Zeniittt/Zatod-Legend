using System;
using System.Collections.Generic;
using System.Linq;
namespace Zatod.Combat
{
    [Serializable] public sealed class ZatodCombatEvent
    {
        public int Id,Tick,EntityId;
        public string Kind,DamageType;
        public double Amount,X,Y,Height;
        public bool Critical;
        public ZatodCombatEvent Copy()=>(ZatodCombatEvent)MemberwiseClone();
    }
    // Read-only render projection. It never advances the model or resolves collisions.
    [Serializable] public struct ZatodRenderMotion
    {
        public double VX,VY,VZ,Gravity;
        public void Project(double x,double y,double height,double seconds,out double px,out double py,out double ph)
        {
            double t=Math.Clamp(seconds,0,ZatodBattleSimulation.StepSeconds);
            px=x+VX*t;py=y+VY*t;ph=Math.Max(0,height+VZ*t+.5*Gravity*t*t);
        }
    }
    [Serializable] public sealed class ZatodVisualState
    {
        public int Id,ActorId,TargetId;
        public string Resource,Kind;
        public double X,Y,Height,EndX,EndY,EndHeight,Elapsed,Scale=1;
        public bool FacingRight;
        public ZatodRenderMotion Motion;
        public double TimeSpeed=1;
        public ZatodVisualState Copy()=>(ZatodVisualState)MemberwiseClone();
    }
    public sealed partial class ZatodBattleSimulation
    {
        readonly List<ZatodCombatEvent> combatEvents=new List<ZatodCombatEvent>();
        int combatEventId;
        void CombatEvent(Unit target,string kind,double amount,string damageType="",bool critical=false)
        {
            if(amount<=.000001)return;
            combatEvents.Add(new ZatodCombatEvent{Id=++combatEventId,Tick=tick,EntityId=target.State.EntityId,Kind=kind,Amount=amount,DamageType=damageType,Critical=critical,X=target.State.X,Y=target.State.Y,Height=target.State.Height});
        }
        void GainEnergy(Unit target,double amount,string kind="energy",bool clampMinimum=false)
        {
            double before=target.State.Energy;
            target.State.Energy=clampMinimum?Math.Clamp(before+amount,0,target.State.MaxEnergy):Math.Min(target.State.MaxEnergy,before+amount);
            CombatEvent(target,kind,target.State.Energy-before);
        }
        readonly List<ZatodVisualState> visualEffects=new List<ZatodVisualState>();
        int visualId;
        void Effect(string resource,string kind,Unit actor,Unit target=null,double height=0)
        {
            if(string.IsNullOrEmpty(resource))return;
            visualEffects.Add(new ZatodVisualState{Id=++visualId,Resource=resource,Kind=kind,ActorId=actor.State.EntityId,TargetId=target?.State.EntityId??0,X=actor.State.X,Y=actor.State.Y,Height=height,EndX=target?.State.X??0,EndY=target?.State.Y??0,EndHeight=target==null?0:48*target.Data.ArtScale,Scale=actor.Data.ArtScale,FacingRight=actor.State.FacingRight});
        }
        void EffectAt(string resource,string kind,Unit actor,double x,double y,double height)
        {
            if(string.IsNullOrEmpty(resource))return;Effect(resource,kind,actor,null,height);var visual=visualEffects[visualEffects.Count-1];visual.X=x;visual.Y=y;
        }
        void AdvanceVisualEffects()
        {
            foreach(var effect in visualEffects)effect.Elapsed+=StepSeconds;
            visualEffects.RemoveAll(x=>x.Elapsed>5);
        }
        List<ZatodVisualState> Visuals()
        {
            var result=visualEffects.ConvertAll(x=>x.Copy());
            bool paused=finished || units.Any(u=>u.Cast!=null && u.Cast.ManualStartup);
            foreach(var effect in result)effect.TimeSpeed=paused?0:1;
            foreach(var shot in shots)result.Add(new ZatodVisualState{Id=shot.VisualId,ActorId=shot.ActorId,TargetId=shot.TargetId,Resource=shot.Skill.Definition.Crystal.ProjectileArt,Kind="projectile",X=shot.X,Y=shot.Y,Height=shot.Height,Elapsed=shot.Elapsed,Scale=Find(shot.ActorId)?.Data.ArtScale??1,FacingRight=shot.VX>=0,TimeSpeed=paused?0:1,Motion=paused?default:new ZatodRenderMotion{VX=shot.VX,VY=shot.VY,VZ=shot.VZ,Gravity=shot.Skill.Definition.Crystal.Gravity}});
            foreach(var actor in units.Where(u=>u.State.Alive))foreach(var buff in actor.Buffs)
                if(!string.IsNullOrEmpty(buff.Definition.Effect))result.Add(new ZatodVisualState{Id=buff.VisualId,ActorId=actor.State.EntityId,Resource=buff.Definition.Effect,Kind="buff",X=actor.State.X,Y=actor.State.Y,Height=actor.State.Height,Elapsed=buff.Elapsed,Scale=actor.Data.ArtScale,FacingRight=actor.State.FacingRight,TimeSpeed=paused?0:1,Motion=PresentationUnit(actor).Motion});
            return result;
        }
        ZatodUnitState PresentationUnit(Unit actor)
        {
            var state=actor.State.Copy();
            bool paused=finished || units.Any(u=>u.Cast!=null && u.Cast.ManualStartup) && (actor.Cast==null || !actor.Cast.ManualStartup);
            if(paused){state.ActionSpeed=0;return state;}
            if(!state.Alive)return state;
            var motion=new ZatodRenderMotion();
            if(actor.KnockRemaining>0)motion.VX=actor.KnockVelocity;
            if(state.Height>0 || actor.VerticalSpeed>0){motion.VZ=actor.VerticalSpeed;motion.Gravity=-1800;}
            if(state.Action=="Move" && actor.Cast==null && CanAct(actor) && !Controlled(actor,"immoblilize"))
            {
                var enemy=ClosestEnemy(actor);
                if(enemy!=null && Distance(actor,enemy)>Math.Max(0,Get(actor,"attack_range")/10))
                {
                    double dx=enemy.State.X-state.X,dy=enemy.State.Y-state.Y;dx*=Math.Abs(dx);dy*=Math.Abs(dy);
                    double length=Math.Max(.00001,Math.Sqrt(dx*dx+dy*dy)),speed=Get(actor,"move_speed")/10*state.ActionSpeed;
                    motion.VX+=dx/length*speed;motion.VY=dy/length*speed;
                }
            }
            state.Motion=motion;return state;
        }
    }
}
