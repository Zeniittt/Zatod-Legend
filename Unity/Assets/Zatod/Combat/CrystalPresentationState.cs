using System;
using System.Collections.Generic;
using System.Linq;
namespace Zatod.Combat
{
    // Read-only render projection. It never advances the model or resolves collisions.
    [Serializable] public struct CrystalRenderMotion
    {
        public double VX,VY,VZ,Gravity;
        public void Project(double x,double y,double height,double seconds,out double px,out double py,out double ph)
        {
            double t=Math.Clamp(seconds,0,CrystalBattleSimulation.StepSeconds);
            px=x+VX*t;py=y+VY*t;ph=Math.Max(0,height+VZ*t+.5*Gravity*t*t);
        }
    }
    [Serializable] public sealed class CrystalVisualState
    {
        public int Id,ActorId,TargetId;
        public string Resource,Kind;
        public double X,Y,Height,EndX,EndY,EndHeight,Elapsed,Scale=1;
        public bool FacingRight;
        public CrystalRenderMotion Motion;
        public double TimeSpeed=1;
        public CrystalVisualState Copy()=>(CrystalVisualState)MemberwiseClone();
    }
    public sealed partial class CrystalBattleSimulation
    {
        readonly List<CrystalVisualState> visualEffects=new List<CrystalVisualState>();
        int visualId;
        void Effect(string resource,string kind,Unit actor,Unit target=null,double height=0)
        {
            if(string.IsNullOrEmpty(resource))return;
            visualEffects.Add(new CrystalVisualState{Id=++visualId,Resource=resource,Kind=kind,ActorId=actor.State.EntityId,TargetId=target?.State.EntityId??0,X=actor.State.X,Y=actor.State.Y,Height=height,EndX=target?.State.X??0,EndY=target?.State.Y??0,EndHeight=target==null?0:48*target.Data.ArtScale,Scale=actor.Data.ArtScale,FacingRight=actor.State.FacingRight});
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
        List<CrystalVisualState> Visuals()
        {
            var result=visualEffects.ConvertAll(x=>x.Copy());
            bool paused=finished || units.Any(u=>u.Cast!=null && u.Cast.ManualStartup);
            foreach(var effect in result)effect.TimeSpeed=paused?0:1;
            foreach(var shot in shots)result.Add(new CrystalVisualState{Id=shot.VisualId,ActorId=shot.ActorId,TargetId=shot.TargetId,Resource=shot.Skill.Definition.Crystal.ProjectileArt,Kind="projectile",X=shot.X,Y=shot.Y,Height=shot.Height,Elapsed=shot.Elapsed,Scale=Find(shot.ActorId)?.Data.ArtScale??1,FacingRight=shot.VX>=0,TimeSpeed=paused?0:1,Motion=paused?default:new CrystalRenderMotion{VX=shot.VX,VY=shot.VY,VZ=shot.VZ,Gravity=shot.Skill.Definition.Crystal.Gravity}});
            foreach(var actor in units.Where(u=>u.State.Alive))foreach(var buff in actor.Buffs)
                if(!string.IsNullOrEmpty(buff.Definition.Effect))result.Add(new CrystalVisualState{Id=buff.VisualId,ActorId=actor.State.EntityId,Resource=buff.Definition.Effect,Kind="buff",X=actor.State.X,Y=actor.State.Y,Height=actor.State.Height,Elapsed=buff.Elapsed,Scale=actor.Data.ArtScale,FacingRight=actor.State.FacingRight,TimeSpeed=paused?0:1,Motion=PresentationUnit(actor).Motion});
            return result;
        }
        CrystalUnitState PresentationUnit(Unit actor)
        {
            var state=actor.State.Copy();
            bool paused=finished || units.Any(u=>u.Cast!=null && u.Cast.ManualStartup) && (actor.Cast==null || !actor.Cast.ManualStartup);
            if(paused){state.ActionSpeed=0;return state;}
            if(!state.Alive)return state;
            var motion=new CrystalRenderMotion();
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
