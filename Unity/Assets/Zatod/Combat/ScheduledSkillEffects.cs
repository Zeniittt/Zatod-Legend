using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class BattleSimulation
    {
        sealed class TargetedImpact
        {
            public int actorId, starts, impacts;
            public List<int> targets;
            public SkillDefinition skill;
            public bool started;
        }
        sealed class PoisonTick
        {
            public int actorId, targetId, damage, interval, next, expires;
            public string skillId, name;
            public bool burn;
            public BattleVisualEffect visual;
        }
        readonly List<TargetedImpact> targetedImpacts = new List<TargetedImpact>();
        readonly List<PoisonTick> poisons = new List<PoisonTick>();

        void CancelConfiguredVisuals(FighterState actor)
        {
            InterruptSequence(actor);
            if (!configured.TryGetValue(actor.id, out var runtime)) return;
            foreach (var cue in runtime.castVisuals) cue.endTick = Math.Min(cue.endTick, Math.Max(cue.startTick, tick));
            runtime.castVisuals.Clear();
        }
        void ScheduleTargetedEffect(FighterState actor, List<int> ids, SkillDefinition skill)
        {
            targetedImpacts.Add(new TargetedImpact { actorId = actor.id, targets = ids.Distinct().ToList(), skill = skill,
                starts = tick + Ticks(skill.TargetEffectDelayMilliseconds),
                impacts = tick + Ticks(skill.TargetEffectDelayMilliseconds) + Ticks(skill.TargetEffectImpactMilliseconds) });
        }
        void AddImpactVisual(FighterState actor, FighterState target, SkillDefinition skill, int hitHeight)
        {
            if (string.IsNullOrEmpty(skill.ProjectileImpactState)) return;
            record.visualEffects.Add(new BattleVisualEffect { actorId = actor.id, targetId = target.id,
                x = target.x, y = target.y, startTick = tick, endTick = tick + Ticks(skill.ProjectileImpactDurationMilliseconds),
                state = skill.ProjectileImpactState, direction = actor.team == 0 ? 1 : -1,
                height = skill.ImpactOnGround ? 0 : Math.Max(0, Math.Min(target.projectileHurtboxHeight > 0 ? target.projectileHurtboxHeight : 100, hitHeight)) });
        }
        void ApplyPoison(FighterState actor, FighterState target, SkillDefinition skill, SkillEffectDefinition effect)
        {
            var poison = poisons.FirstOrDefault(p => p.actorId == actor.id && p.targetId == target.id && p.skillId == skill.Id);
            if (poison == null) { poison = new PoisonTick { actorId = actor.id, targetId = target.id, skillId = skill.Id }; poisons.Add(poison); }
            poison.damage = Math.Max(1, effect.Amount + actor.attack * effect.DamageScaleBasisPoints / 10000);
            poison.interval = Math.Max(1, Ticks(effect.TickIntervalMilliseconds));
            poison.next = tick + (effect.FirstTickDelayMilliseconds>0?Ticks(effect.FirstTickDelayMilliseconds):poison.interval); poison.expires = tick + Ticks(effect.DurationMilliseconds);
            poison.burn=effect.Kind==SkillEffectKind.Burn;poison.name = skill.Name + (poison.burn?" / Burn":" / Poison");
            if(poison.burn)target.burnUntil=Math.Max(target.burnUntil,poison.expires);
            else target.poisonUntil = Math.Max(target.poisonUntil, poison.expires);
            if(!string.IsNullOrEmpty(effect.VisualState))
            {
                if(poison.visual==null)
                {poison.visual=new BattleVisualEffect{actorId=actor.id,targetId=target.id,followId=target.id,startTick=tick,x=target.x,y=target.y,state=effect.VisualState,direction=actor.team==0?1:-1};record.visualEffects.Add(poison.visual);}
                poison.visual.endTick=poison.expires;
            }
            Emit(poison.burn?BattleEventKind.Burn:BattleEventKind.Poison, actor, target, 0, poison.name);
        }
        void AdvanceScheduledEffects()
        {
            for (int i = targetedImpacts.Count - 1; i >= 0; i--)
            {
                var entry = targetedImpacts[i]; var actor = Find(entry.actorId);
                if (!entry.started && tick >= entry.starts)
                {
                    entry.started = true;
                    foreach (int id in entry.targets)
                    {
                        var target = Find(id); if (target == null || !target.Alive) continue;
                        record.visualEffects.Add(new BattleVisualEffect { actorId = actor.id, targetId = id, followId = id,
                            x = target.x, y = target.y, startTick = tick, endTick = tick + Ticks(entry.skill.TargetEffectDurationMilliseconds),
                            direction = 1, state = entry.skill.TargetEffectState });
                    }
                }
                if (tick < entry.impacts) continue;
                foreach (int id in entry.targets)
                { var target = Find(id); if (target != null && target.Alive) ApplyEffects(actor, target, entry.skill); }
                targetedImpacts.RemoveAt(i);
            }
            for (int i = poisons.Count - 1; i >= 0; i--)
            {
                var poison = poisons[i]; var target = Find(poison.targetId);
                if (target == null || !target.Alive || tick > poison.expires) { if(poison.visual!=null)poison.visual.endTick=Math.Min(poison.visual.endTick,tick);poisons.RemoveAt(i); continue; }
                if (tick < poison.next) continue;
                Damage(Find(poison.actorId), target, poison.damage, poison.name, false);
                poison.next += poison.interval;
                if (poison.next > poison.expires) poisons.RemoveAt(i);
            }
        }
    }
}
