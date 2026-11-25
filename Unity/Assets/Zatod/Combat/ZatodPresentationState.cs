using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;
namespace Zatod.Combat
{
    [Serializable] public sealed class ZatodCombatEvent
    {
        public int Id,Tick,EntityId,SourceActorId,Wave;
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
    [Serializable] public struct ZatodHealthBarState
    {
        const double Speed = .8;
        const double HoldSeconds = 1.5;
        public double Hp, Trail, Shield, VisibleFor, TargetHp;

        internal ZatodHealthBarState(double hp) : this()
        {
            Hp = Trail = TargetHp = hp;
        }

        internal void Update(double hp,double shield)
        {
            this = Project(ZatodBattleSimulation.StepSeconds);
            if (TargetHp != hp || Shield != shield) VisibleFor = HoldSeconds;
            TargetHp = hp;
            Hp = Math.Min(Hp,hp);
            Shield = shield;
        }

        public ZatodHealthBarState Project(double seconds)
        {
            double elapsed = Math.Clamp(seconds,0,ZatodBattleSimulation.StepSeconds);
            var result = this;
            double motion = Math.Max(Math.Abs(Hp-TargetHp),Math.Abs(Trail-TargetHp))/Speed;
            result.VisibleFor = Math.Max(0,VisibleFor-elapsed);
            if (motion>0)
                result.VisibleFor = Math.Max(result.VisibleFor,HoldSeconds-Math.Max(0,elapsed-motion));
            result.Hp = MoveTo(Hp,TargetHp,elapsed*Speed);
            result.Trail = Math.Max(result.Hp,MoveTo(Trail,TargetHp,elapsed*Speed));
            return result;
        }

        static double MoveTo(double value,double target,double step)
            => value>target?Math.Max(target,value-step):Math.Min(target,value+step);
    }
    [Serializable] public sealed class ZatodVisualState
    {
        public int Id,ActorId,TargetId;
        public string Resource,Kind;
        public double X,Y,Height,EndX,EndY,EndHeight,Elapsed,Scale=1;
        public bool FacingRight;
        public ZatodRenderMotion Motion;
        public double TimeSpeed=1;
        public ZatodBuffEffectLayer Layer;
        public double HeightOffset;
        public ZatodVisualState Copy()=>(ZatodVisualState)MemberwiseClone();
    }
    public sealed partial class ZatodBattleSimulation
    {
        readonly List<ZatodCombatEvent> combatEvents=new List<ZatodCombatEvent>();
        int combatEventId;
        void CombatEvent(Unit target,string kind,double amount,string damageType="",bool critical=false,int sourceActorId=0)
        {
            if(amount<=.000001 && kind!="dodge" && kind!="immune" && kind!="miss" && kind!="resist")return;
            combatEvents.Add(new ZatodCombatEvent{Id=++combatEventId,Tick=tick,EntityId=target.State.EntityId,SourceActorId=sourceActorId,Wave=wave+1,Kind=kind,Amount=amount,DamageType=damageType,Critical=critical,X=target.State.X,Y=target.State.Y,Height=target.State.Height});
        }
        void GainEnergy(Unit target,double amount,string kind="energy",bool clampMinimum=false)
        {
            if(ExpandedRules && amount>0 && Controlled(target,"noMPGet"))return;
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
        void SceneEffect(string resource,Unit actor,double x,double y,ZatodBuffEffectLayer layer,bool facingRight=true,double scale=1)
        {
            EffectAt(resource,"point",actor,x,y,0);var visual=visualEffects[visualEffects.Count-1];visual.Scale=scale;visual.Layer=layer;visual.FacingRight=facingRight;
        }
        void AdvanceVisualEffects()
        {
            foreach(var effect in visualEffects)effect.Elapsed+=StepSeconds;
            visualEffects.RemoveAll(x=>x.Elapsed>5);
        }
        List<ZatodVisualState> Visuals()
        {
            var result=visualEffects.ConvertAll(x=>x.Copy());
            bool paused=finished || waveEntryTicks>0 || units.Any(u=>u.Cast!=null && u.Cast.ManualStartup);
            foreach(var effect in result)effect.TimeSpeed=paused?0:1;
            foreach(var shot in shots)result.Add(new ZatodVisualState{Id=shot.VisualId,ActorId=shot.ActorId,TargetId=shot.TargetId,Resource=shot.Skill.Definition.Crystal.ProjectileArt,Kind="projectile",X=shot.X,Y=shot.Y,Height=shot.Height,Elapsed=shot.Elapsed,Scale=(Find(shot.ActorId)?.Data.ArtScale??1)*(ExpandedRules && shot.Skill.Definition.Crystal.SourceId==11100?.66:1),FacingRight=shot.VX>=0,TimeSpeed=paused?0:1,Motion=paused?default:new ZatodRenderMotion{VX=shot.VX,VY=shot.VY,VZ=shot.VZ,Gravity=shot.Skill.Definition.Crystal.Gravity}});
            if(ExpandedRules)foreach(var region in regions.Where(r=>!string.IsNullOrEmpty(r.VisualResource)))
                result.Add(new ZatodVisualState{Id=region.VisualId,ActorId=region.Caster.State.EntityId,Resource=region.VisualResource,Kind="buff",X=region.X,Y=region.Y,Elapsed=region.Elapsed,Scale=1,Layer=ZatodBuffEffectLayer.WorldActors,FacingRight=region.Caster.State.FacingRight,TimeSpeed=paused?0:1});
            if(ExpandedRules)foreach(var actor in units.Where(u=>u.State.Alive && u.ClockwerkHeat>0))
                result.Add(new ZatodVisualState{Id=actor.ClockwerkHeatVisual,ActorId=actor.State.EntityId,Resource="eff_buff_CG_heat_"+Math.Min(3,actor.ClockwerkHeat)+".cha",Kind="buff",X=actor.State.X,Y=actor.State.Y,Height=actor.State.Height,Elapsed=actor.NativeEntryElapsed,Scale=actor.Data.ArtScale,Layer=ZatodBuffEffectLayer.InFrontOfActor,TimeSpeed=paused?0:1,FacingRight=actor.State.FacingRight});
            foreach(var actor in units.Where(u=>u.State.Alive))foreach(var buff in actor.Buffs)
            {
                var config=buff.Definition;
                if(ExpandedRules && actor.HiddenBuffEffects.Contains(buff.VisualId))continue;
                if(string.IsNullOrEmpty(config.Effect))continue;
                result.Add(new ZatodVisualState
                {
                    Id=buff.VisualId,ActorId=actor.State.EntityId,Resource=config.Effect,Kind="buff",
                    X=actor.State.X,Y=actor.State.Y,Height=actor.State.Height,Elapsed=buff.Elapsed,
                    Scale=actor.Data.ArtScale*(config.EffectScale>0?config.EffectScale:1),
                    Layer=config.EffectLayer,HeightOffset=config.EffectHeightOffset,
                    FacingRight=actor.State.FacingRight,TimeSpeed=paused?0:1,Motion=PresentationUnit(actor).Motion
                });
            }
            return result;
        }
        bool IsUltimateStartup(Unit actor)=>actor.State.Alive && actor.Cast?.ManualStartup==true && Manual(actor);
        static double HealthFraction(ZatodUnitState state,double amount)
            => Math.Clamp(amount/Math.Max(1,state.MaxHp),0,1);

        void UpdateHudReadiness(Unit actor)
        {
            var state=actor.State;
            if(CanActivateUltimate(actor))
            {if(state.UltimateReadySinceTick<0)state.UltimateReadySinceTick=tick;}
            else state.UltimateReadySinceTick=-1;
            if(state.Alive && state.Energy>=state.MaxEnergy)
            {if(state.FullEnergySinceTick<0)state.FullEnergySinceTick=tick;}
            else state.FullEnergySinceTick=-1;
        }

        void UpdateHealthBars()
        {
            foreach (var actor in units)
            {
                var state = actor.State;
                UpdateHudReadiness(actor);
                state.Shield = 0;
                foreach (var buff in actor.Buffs)
                    state.Shield += Math.Max(0,buff.Definition.ShieldValue);
                state.HealthBar.Update(HealthFraction(state,state.Hp),HealthFraction(state,state.Shield));
            }
        }

        ZatodUnitState PresentationUnit(Unit actor)
        {
            var state=RawPresentationUnit(actor);
            if(ExpandedRules)
            {
                var remaps=actor.NativeForm?.ActionRemaps??actor.Data.ActionRemaps;
                state.Action=remaps.FirstOrDefault(x=>x.Action==state.Action)?.Target??state.Action;
                state.FrozenAction=remaps.FirstOrDefault(x=>x.Action==state.FrozenAction)?.Target??state.FrozenAction;
            }
            return state;
        }
        ZatodUnitState RawPresentationUnit(Unit actor)
        {
            var state=actor.State.Copy();
            state.CanActivateUltimate=CanActivateUltimate(actor);
            state.UltimateStartup=IsUltimateStartup(actor);
            state.RankId=actor.Data.RankId;
            state.Stars=actor.Data.Stars;
            state.SummonerId=actor.Data.SummonerId;
            state.SummonTicks=actor.SummonTicks;
            state.Boss=actor.Data.Boss;
            state.Icebound=state.Alive && (Controlled(actor,"frozen") || Controlled(actor,"icefrozen"));
            var shader=actor.Buffs.LastOrDefault(b=>b.Definition.Shader!=ZatodBuffShader.None);
            state.Shader=shader?.Definition.Shader??ZatodBuffShader.None;
            var scale=actor.Buffs.LastOrDefault(b=>b.Definition.ActorScaleX!=1 || b.Definition.ActorScaleY!=1);
            state.RenderScaleX=scale?.Definition.ActorScaleX??1;state.RenderScaleY=scale?.Definition.ActorScaleY??1;
            state.DeathPresentation=actor.Data.DeathPresentation;
            if(ExpandedRules && actor.Summoner!=null && state.DeathPresentation==ZatodDeathPresentation.Fade)
                state.DeathPresentation=ZatodDeathPresentation.FadeWithoutHold;
            bool paused=finished || waveEntryTicks>0 || units.Any(u=>u.Cast!=null && u.Cast.ManualStartup) && (actor.Cast==null || !actor.Cast.ManualStartup);
            if(paused){state.ActionSpeed=0;return state;}
            if(!state.Alive)return state;
            var motion=new ZatodRenderMotion();
            if(actor.KnockRemaining>0)motion.VX=actor.KnockVelocity;
            if(state.Height>0 || actor.VerticalSpeed>0){motion.VZ=actor.VerticalSpeed;motion.Gravity=-1800;}
            if(state.Action=="Move" && actor.Cast==null && CanAct(actor) && !Controlled(actor,"immoblilize") && (!ExpandedRules || !Controlled(actor,"fix")))
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
