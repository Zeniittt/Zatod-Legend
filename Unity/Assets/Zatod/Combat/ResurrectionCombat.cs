using System;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class BattleSimulation
    {
        void ScheduleResurrection(FighterState fighter)
        {
            if(!configured.TryGetValue(fighter.id,out var runtime))return;
            var passive=runtime.data.Skills.Select(s=>s.Definition).FirstOrDefault(s=>s.Kind==SkillKind.Passive && s.Activation==SkillActivation.OnDeath
                && s.Effects.Any(e=>e.Kind==SkillEffectKind.Resurrect && fighter.revivesUsed<e.MaxTriggersPerBattle));
            if(passive==null)return;
            var effect=passive.Effects.First(e=>e.Kind==SkillEffectKind.Resurrect && fighter.revivesUsed<e.MaxTriggersPerBattle);
            fighter.revivesUsed++;fighter.reviveAtTick=tick+Ticks(effect.ReviveDelayMilliseconds);
            fighter.animationState=passive.AnimationState;fighter.animationStartTick=tick;
            fighter.animationEndTick=tick+Ticks(passive.AnimationDurationMilliseconds);
            fighter.presentationHeight=0;fighter.stunUntil=fighter.knockUpUntil=fighter.poisonUntil=fighter.burnUntil=0;
            fighter.lifestealBasisPoints=0;fighter.lifestealUntil=0;
            runtime.pending=null;runtime.castVisuals.Clear();
            Emit(BattleEventKind.ResurrectionPending,fighter,fighter,0,passive.Name);
        }
        void AdvanceResurrections()
        {
            foreach(var fighter in fighters)
            {
                if(fighter.lifestealUntil>0 && fighter.lifestealUntil<=tick)
                {fighter.lifestealBasisPoints=fighter.lifestealUntil=0;Emit(BattleEventKind.Buff,fighter,fighter,0,"Lifesteal expired");}
                if(fighter.reviveAtTick==0 || tick<fighter.reviveAtTick)continue;
                var passive=configured[fighter.id].data.Skills.Select(s=>s.Definition).First(s=>s.Kind==SkillKind.Passive && s.Activation==SkillActivation.OnDeath);
                var effect=passive.Effects.First(e=>e.Kind==SkillEffectKind.Resurrect);
                fighter.reviveAtTick=0;fighter.hp=Math.Max(1,(int)((long)fighter.maxHp*effect.ReviveHealthBasisPoints/10000));
                fighter.action=BattleAction.Idle;fighter.actionTargetId=fighter.targetId=0;
                fighter.nextActionTick=fighter.movementLockUntilTick=Math.Max(tick,fighter.animationEndTick);
                fighter.stunUntil=fighter.knockUpUntil=fighter.poisonUntil=fighter.burnUntil=0;fighter.controlKind=ControlKind.None;
                poisons.RemoveAll(p=>p.targetId==fighter.id);
                fighter.lifestealBasisPoints=effect.ModifierBasisPoints;fighter.lifestealUntil=tick+Ticks(effect.DurationMilliseconds);
                Emit(BattleEventKind.Revive,fighter,fighter,fighter.hp,passive.Name);
            }
        }
        void StealLife(FighterState actor,FighterState victim,int dealt,int basisPoints,string ability,string returnState)
        {
            if(!actor.Alive || dealt<=0 || basisPoints<=0)return;
            int before=actor.hp;actor.hp=Math.Min(actor.maxHp,actor.hp+(int)((long)dealt*basisPoints/10000));
            if(actor.hp>before)Emit(BattleEventKind.Heal,actor,actor,actor.hp-before,ability+" / Lifesteal");
            if(string.IsNullOrEmpty(returnState))return;
            int direction=actor.x>=victim.x?1:-1;
            record.visualEffects.Add(new BattleVisualEffect{actorId=actor.id,targetId=actor.id,x=victim.x,y=victim.y,direction=direction,
                startTick=tick,endTick=tick+8,state=returnState,moveForward=Math.Abs(actor.x-victim.x),height=80,moveHeight=80});
        }
    }
}
