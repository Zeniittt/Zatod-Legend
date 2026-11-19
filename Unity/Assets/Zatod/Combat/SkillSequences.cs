using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class BattleSimulation
    {
        sealed class SequenceCast
        {
            public FighterState actor;
            public SkillDefinition skill;
            public SkillCastSequence definition;
            public int targetId, targetX, targetY, start, startX, startY, direction, releaseX, releaseY;
            public int startFacingDirection;
            public bool committed, interrupted, bodyEnded, grabThrown;
            public int grabbedId, grabStart, grabEnd, grabX, grabDistance;
            public bool[] actions, visuals;
        }
        sealed class DamageBuff
        {
            public int targetId, amount, expires;
            public string skillId;
        }
        readonly List<SequenceCast> sequences = new List<SequenceCast>();
        readonly List<DamageBuff> damageBuffs = new List<DamageBuff>();

        void BeginSequence(FighterState actor, FighterState target, SkillDefinition skill, bool opening, ConfiguredFighter runtime)
        {
            var sequence = skill.CastSequences.FirstOrDefault(s => s.Opening == opening)
                ?? skill.CastSequences.First(s => !s.Opening);
            var cast = new SequenceCast { actor = actor, skill = skill, definition = sequence,
                targetId = target.id, targetX = target.x, targetY = target.y, start = tick, startX = actor.x, startY = actor.y,
                startFacingDirection=actor.facingDirection,
                direction = target.team == actor.team ? (actor.team == 0 ? 1 : -1) : (target.x >= actor.x ? 1 : -1),
                actions = new bool[sequence.Actions.Count], visuals = new bool[sequence.Visuals.Count] };
            runtime.sequence = cast; sequences.Add(cast);
            actor.action = skill.Activation == SkillActivation.UltimateIntent ? BattleAction.Ultimate : BattleAction.Attack;
            actor.actionStartTick = actor.animationStartTick = tick;
            actor.actionEndTick = actor.animationEndTick = tick + Ticks(sequence.DurationMilliseconds);
            actor.movementLockUntilTick = actor.actionEndTick;
            actor.actionTargetId = target.id; actor.animationState = sequence.AnimationState;
            actor.facingDirection=cast.direction;
            Emit(BattleEventKind.Action, actor, actor, 0, skill.Name);
            AdvanceSequence(cast);
        }

        void InterruptSequence(FighterState actor)
        {
            if (!configured.TryGetValue(actor.id, out var runtime) || runtime.sequence == null) return;
            var cast = runtime.sequence;
            cast.interrupted = true; cast.bodyEnded = true; runtime.sequence = null;
            ReleaseGrab(cast);
            actor.presentationHeight = 0;
            // A released bird/rain/beam is independent. Unreleased shots never appear later.
            if (!cast.committed || !cast.definition.ContinueAfterRelease)
            { for (int i = 0; i < cast.actions.Length; i++) cast.actions[i] = true;
              for (int i = 0; i < cast.visuals.Length; i++) cast.visuals[i] = true; }
        }

        void AdvanceSequences()
        {
            for (int i = 0; i < sequences.Count;)
            {
                var cast = sequences[i]; AdvanceSequence(cast);
                if (cast.bodyEnded && cast.actions.All(done => done) && cast.visuals.All(done => done)) sequences.RemoveAt(i);
                else i++;
            }
        }

        void AdvanceSequence(SequenceCast cast)
        {
            var actor = cast.actor; int age = tick - cast.start;
            if (!cast.bodyEnded && (!actor.Alive || actor.stunUntil > tick ||
                (actor.action != BattleAction.Attack && actor.action != BattleAction.Ultimate)))
                InterruptSequence(actor);
            if (!cast.committed && !cast.interrupted && age >= Ticks(cast.definition.ReleaseMilliseconds))
            { cast.committed = true; cast.releaseX = actor.x; cast.releaseY = actor.y; }
            if (!cast.bodyEnded) MoveSequence(cast, age * 1000 / TickRate);
            MoveGrab(cast);
            for (int i = 0; i < cast.visuals.Length; i++)
            {
                var cue = cast.definition.Visuals[i];
                if (cast.visuals[i] || age < Ticks(cue.DelayMilliseconds)) continue;
                cast.visuals[i] = true;
                int x = cue.AtTarget ? cast.targetX : cue.FollowCaster ? actor.x : cast.committed ? cast.releaseX : cast.startX;
                int y = cue.AtTarget ? cast.targetY : cue.FollowCaster ? actor.y : cast.committed ? cast.releaseY : cast.startY;
                record.visualEffects.Add(new BattleVisualEffect { actorId = actor.id, targetId = cue.AtTarget ? cast.targetId : 0,
                    followId = cue.FollowTarget ? cast.targetId : cue.FollowCaster ? actor.id : 0,
                    startTick = tick, endTick = cast.start + Ticks(cue.DelayMilliseconds + cue.DurationMilliseconds), x = x, y = y,
                    forward = cue.Forward, height = cue.Height, direction = cast.direction, state = cue.State,
                    stretchToRange = cue.StretchToRange || cue.StretchToTarget,
                    endX = cue.StretchToTarget ? cast.targetX : x + cast.direction * cast.skill.CastRange,
                    moveForward = cue.MoveForward, moveHeight = cue.MoveHeight, growTicks = Ticks(cue.GrowMilliseconds), shockwave = cue.Shockwave });
            }
            for (int i = 0; i < cast.actions.Length; i++)
            {
                var cue = cast.definition.Actions[i];
                if (cast.actions[i] || age < Ticks(cue.DelayMilliseconds)) continue;
                cast.actions[i] = true;
                if(cue.RequiresGrab && !cast.grabThrown)continue;
                if(cue.Action==SkillSequenceAction.TeleportToTarget || cue.Action==SkillSequenceAction.GrabTarget || cue.Action==SkillSequenceAction.ThrowTarget)
                    SequenceTargetAction(cast,cue);
                else if (cue.Action == SkillSequenceAction.Projectile)
                {
                    var target = Find(cast.targetId);
                    if(cue.SelectTargetByIndex)
                    {
                        var candidates=fighters.Where(f=>f.Alive && f.team!=actor.team && CombatGeometry.CenterDistance(actor,f)<=cast.skill.CastRange)
                            .OrderBy(f=>cue.TargetOrder==SequenceTargetOrder.LowestHealth?f.hp:CombatGeometry.CenterDistance(actor,f)).ThenBy(f=>f.id).ToList();
                        target=candidates.Count>0?candidates[cue.TargetIndex%candidates.Count]:null;
                    }
                    if (target == null || !target.Alive)
                    {
                        target = fighters.Where(f => f.Alive && f.team != actor.team && CombatGeometry.CenterDistance(actor, f) <= cast.skill.CastRange)
                            .OrderBy(f => CombatGeometry.CenterDistance(actor, f)).ThenBy(f => f.id).FirstOrDefault();
                        if (target != null) cast.targetId = target.id;
                    }
                    if (target != null) LaunchProjectile(actor, target, cast.skill);
                }
                else if (cue.Action == SkillSequenceAction.AreaPulse)
                {
                    // A ground area stays where it was cast; depth is presentation, just as normal targeting.
                    foreach (var target in fighters.Where(f => f.Alive && f.team != actor.team &&
                        Math.Abs((long)f.x - cast.targetX) <= cast.skill.EffectRadius).ToList()) ApplyEffects(actor, target, cast.skill, cue.DamageMultiplierBasisPoints>0?cue.DamageMultiplierBasisPoints:10000);
                }
                else
                {
                    var target = Find(cast.targetId) ?? actor;
                    if(cue.RequireAttackRange && (!target.Alive || !CombatGeometry.InAttackRange(actor,target)))continue;
                    foreach (var victim in EffectTargets(actor, target, cast.skill).Where(f => f.Alive)) ApplyEffects(actor, victim, cast.skill, cue.DamageMultiplierBasisPoints>0?cue.DamageMultiplierBasisPoints:10000);
                }
            }
            if (!cast.bodyEnded && age >= Ticks(cast.definition.DurationMilliseconds))
            {
                cast.bodyEnded = true; configured[actor.id].sequence = null;
                ReleaseGrab(cast);
                ReturnSequenceToStart(cast);
                actor.presentationHeight = 0; actor.action = BattleAction.Idle; actor.actionTargetId = 0;
                actor.nextActionTick = tick + actor.attackInterval;
                actor.movementLockUntilTick = tick + Ticks(cast.skill.RecoveryMilliseconds);
                Emit(BattleEventKind.Action, actor, actor, 0, "Recover");
                if(configured[actor.id].basic){actor.energy=Math.Min(100,actor.energy+16);Emit(BattleEventKind.Energy,actor,actor,0,"");}
            }
        }

        void ReturnSequenceToStart(SequenceCast cast)
        {
            if(!cast.definition.ReturnToStartOnEnd || !cast.actor.Alive)return;
            var actor=cast.actor;actor.x=cast.startX;actor.y=cast.startY;actor.facingDirection=cast.startFacingDirection;
            Emit(BattleEventKind.Move,actor,actor,0,cast.skill.Name+" / Return");
        }

        void RecordSequenceReturnsAfterCombat()
        {
            // The result is already fixed. Finish presentation movement without executing more
            // attacks, effects, AI, or changing the combat-end tick.
            foreach(var cast in sequences.Where(c=>!c.bodyEnded && !c.interrupted && c.actor.Alive && c.definition.ReturnToStartOnEnd)
                .OrderBy(c=>c.start+Ticks(c.definition.DurationMilliseconds)).ThenBy(c=>c.actor.id))
            {
                tick=Math.Max(tick,cast.start+Ticks(cast.definition.DurationMilliseconds));
                cast.bodyEnded=true;configured[cast.actor.id].sequence=null;
                ReturnSequenceToStart(cast);
                cast.actor.presentationHeight=0;cast.actor.action=BattleAction.Idle;cast.actor.actionTargetId=0;cast.actor.animationEndTick=tick;
                Emit(BattleEventKind.Action,cast.actor,cast.actor,0,"Recover");
            }
        }

        void SequenceTargetAction(SequenceCast cast,SkillSequenceCue cue)
        {
            var target=Find(cast.targetId);if(target==null || !target.Alive || !cast.actor.Alive)return;
            var actor=cast.actor;
            if(cue.Action==SkillSequenceAction.TeleportToTarget)
            {
                actor.x=target.x-cast.direction*cue.Distance;cast.targetX=target.x;cast.targetY=target.y;
                Emit(BattleEventKind.Move,actor,actor,0,cast.skill.Name+" / Teleport");return;
            }
            if(cue.Action==SkillSequenceAction.GrabTarget)
            {
                if(CombatGeometry.CenterDistance(actor,target)>cast.skill.EffectRadius)return;
                CancelConfiguredVisuals(target);
                target.action=BattleAction.Idle;target.actionTargetId=0;target.animationEndTick=tick;
                target.controlKind=ControlKind.Stun;target.controlStartTick=tick;
                target.stunUntil=target.movementLockUntilTick=target.nextActionTick=tick+Ticks(cue.DurationMilliseconds);
                cast.grabbedId=target.id;cast.grabStart=tick;cast.grabEnd=target.stunUntil;cast.grabX=target.x;cast.grabDistance=cue.Distance;
                Emit(BattleEventKind.Stun,actor,target,0,cast.skill.Name+" / Grab",false,ControlKind.Stun);return;
            }
            if(cast.grabbedId!=target.id)return;
            cast.grabbedId=0;cast.grabThrown=true;target.x+=cast.direction*cue.Distance;
            target.controlKind=ControlKind.KnockUp;target.controlStartTick=tick;
            target.stunUntil=target.knockUpUntil=target.movementLockUntilTick=target.nextActionTick=tick+Ticks(cue.DurationMilliseconds);
            target.knockUpHeight=cue.Height;
            Emit(BattleEventKind.Move,actor,target,0,cast.skill.Name+" / Throw");
            Emit(BattleEventKind.Stun,actor,target,0,cast.skill.Name+" / Throw",false,ControlKind.KnockUp);
        }
        void MoveGrab(SequenceCast cast)
        {
            if(cast.grabbedId==0)return;var target=Find(cast.grabbedId);
            if(!target.Alive || cast.interrupted || tick>=cast.grabEnd){ReleaseGrab(cast);return;}
            int span=Math.Max(1,cast.grabEnd-cast.grabStart);int end=cast.actor.x+cast.direction*cast.grabDistance;
            int x=cast.grabX+(int)((long)(end-cast.grabX)*(tick-cast.grabStart)/span);
            if(x==target.x)return;target.x=x;Emit(BattleEventKind.Move,cast.actor,target,0,cast.skill.Name+" / Pull");
        }
        void ReleaseGrab(SequenceCast cast)
        {
            if(cast.grabbedId==0)return;var target=Find(cast.grabbedId);cast.grabbedId=0;
            if(target==null || !target.Alive)return;
            target.stunUntil=Math.Min(target.stunUntil,tick);target.movementLockUntilTick=Math.Min(target.movementLockUntilTick,tick);
            Emit(BattleEventKind.Cancel,cast.actor,target,0,cast.skill.Name+" / Grab released");
        }

        void MoveSequence(SequenceCast cast, int milliseconds)
        {
            var keys = cast.definition.Motion;
            if (keys.Count == 0) return;
            var a = keys[0]; var b = keys[keys.Count - 1];
            for (int i = 1; i < keys.Count; i++) if (milliseconds < keys[i].TimeMilliseconds) { a = keys[i-1]; b = keys[i]; break; }
            int span = Math.Max(1, b.TimeMilliseconds - a.TimeMilliseconds);
            int time = Math.Max(0, Math.Min(span, milliseconds - a.TimeMilliseconds));
            int forward = a.Forward + (int)((long)(b.Forward-a.Forward)*time/span);
            int height = a.Height + (int)((long)(b.Height-a.Height)*time/span);
            int desired = cast.startX + cast.direction * forward;
            var actor = cast.actor;
            foreach (var other in fighters.Where(f => f.Alive && f.id != actor.id))
            {
                if (other.team == actor.team && other.slot < actor.slot)
                {
                    int gap = Math.Max(other.formationSpacing, actor.formationSpacing);
                    desired = cast.direction > 0 ? Math.Min(desired, Math.Max(actor.x, other.x-gap)) : Math.Max(desired, Math.Min(actor.x, other.x+gap));
                }
                else if (other.team != actor.team && (other.x-actor.x)*cast.direction >= 0)
                    desired = cast.direction > 0 ? Math.Min(desired, Math.Max(actor.x, other.x-150)) : Math.Max(desired, Math.Min(actor.x, other.x+150));
            }
            if (actor.x == desired && actor.presentationHeight == height) return;
            actor.x = desired; actor.presentationHeight = height;
            Emit(BattleEventKind.Move, actor, actor, 0, "Skill movement");
        }

        void ApplyDamageBuff(FighterState actor, FighterState target, SkillDefinition skill, SkillEffectDefinition effect)
        {
            // Same skill refreshes one modifier even if another copy of a Hero casts it.
            var buff = damageBuffs.FirstOrDefault(b => b.targetId == target.id && b.skillId == skill.Id);
            if (buff == null) { buff = new DamageBuff { targetId = target.id, skillId = skill.Id }; damageBuffs.Add(buff); }
            buff.amount = effect.ModifierBasisPoints; buff.expires = tick + Ticks(effect.DurationMilliseconds);
            RefreshDamageBuff(target);
            Emit(BattleEventKind.Buff, actor, target, effect.ModifierBasisPoints, skill.Name);
        }
        void RefreshDamageBuff(FighterState target)
        {
            var active = damageBuffs.Where(b => b.targetId == target.id).ToList();
            target.damageBonusBasisPoints = (int)Math.Min(100000, active.Sum(b => (long)b.amount));
            target.damageBuffUntil = active.Count == 0 ? 0 : active.Max(b => b.expires);
        }
        void AdvanceDamageBuffs()
        {
            foreach (int id in damageBuffs.Where(b => b.expires <= tick).Select(b => b.targetId).Distinct().ToArray())
            {
                damageBuffs.RemoveAll(b => b.targetId == id && b.expires <= tick);
                var target = Find(id); RefreshDamageBuff(target);
                Emit(BattleEventKind.Buff, target, target, target.damageBonusBasisPoints, "Damage buff expired");
            }
        }
    }
}
