using System;
using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class BattleSimulation
    {
        sealed class ConfiguredFighter
        {
            public CombatantBattleData data;
            public SkillDefinition pending;
            public bool basic;
            public bool disableBasicAttacks;
            public int skillCastLimit, casts;
            public List<int> pendingTargets = new List<int>();
            public List<BattleVisualEffect> castVisuals = new List<BattleVisualEffect>();
            public readonly Dictionary<string, int> ready = new Dictionary<string, int>();
            public SequenceCast sequence;
            public readonly HashSet<string> openingUsed = new HashSet<string>();
        }
        sealed class FlyingProjectile
        {
            public BattleProjectile trace;
            public SkillDefinition skill;
            public int x, destination, expires;
            public int height;
            public int launchX;
            public bool firstStep=true;
            public readonly HashSet<int> hits = new HashSet<int>();
        }
        readonly Dictionary<int, ConfiguredFighter> configured = new Dictionary<int, ConfiguredFighter>();
        readonly List<FlyingProjectile> flying = new List<FlyingProjectile>();

        void Configure(List<FighterLoadout> loadouts)
        {
            if (loadouts == null) return;
            foreach (var loadout in loadouts)
            {
                // Detach even from the caller's battle snapshot.
                if(loadout==null || !Enum.IsDefined(typeof(CombatantKind),loadout.kind) || loadout.Data==null)
                    throw new ArgumentException("A combatant must have a valid Hero or Monster loadout.");
                var data=loadout.Data.Copy();
                configured.Add(loadout.fighterId, new ConfiguredFighter { data = data, disableBasicAttacks = loadout.disableBasicAttacks, skillCastLimit = loadout.skillCastLimit });
                record.loadouts.Add(new FighterLoadout { fighterId = loadout.fighterId, kind=loadout.kind,hero = data as HeroBattleData, monster=data as MonsterBattleData,
                    disableBasicAttacks = loadout.disableBasicAttacks, skillCastLimit = loadout.skillCastLimit });
            }
        }

        static int Ticks(int milliseconds) { return Math.Max(0, (milliseconds * TickRate + 999) / 1000); }

        bool TryConfiguredAction(FighterState actor, FighterState enemy)
        {
            if (!configured.TryGetValue(actor.id, out var runtime)) return false;
            if (runtime.sequence != null) return true;
            if (runtime.pending != null)
            {
                // Other actors can interrupt a windup. A released projectile remains independent.
                if (actor.action != BattleAction.Attack && actor.action != BattleAction.Ultimate)
                { CancelConfiguredVisuals(actor); runtime.pending = null; return true; }
                var target = Find(actor.actionTargetId);
                bool targeted = runtime.pending.Delivery == SkillDelivery.TargetedEffect;
                bool hasVictim = targeted ? runtime.pendingTargets.Any(id => Find(id) != null && Find(id).Alive) : target != null && (target.Alive || runtime.pending.Delivery == SkillDelivery.Beam);
                if (!hasVictim)
                { CancelConfiguredVisuals(actor); runtime.pending = null; actor.animationEndTick = tick; CancelAction(actor); return true; }
                if (tick < actor.actionEndTick) return true;
                var skill = runtime.pending; runtime.pending = null;
                runtime.castVisuals.Clear();
                actor.action = BattleAction.Idle; actor.actionTargetId = 0;
                actor.nextActionTick = tick + actor.attackInterval;
                actor.movementLockUntilTick = tick + Ticks(skill.RecoveryMilliseconds);
                Emit(BattleEventKind.Action, actor, actor, 0, "Recover");
                if (skill.Delivery == SkillDelivery.Projectile) LaunchProjectile(actor, target, skill);
                else if (skill.Delivery == SkillDelivery.TargetedEffect) ScheduleTargetedEffect(actor, runtime.pendingTargets, skill);
                else if (runtime.basic && !CombatGeometry.InAttackRange(actor, target))
                    Emit(BattleEventKind.Miss, actor, actor, 0, skill.Name);
                else foreach (var victim in EffectTargets(actor, target, skill)) ApplyEffects(actor, victim, skill);
                if (runtime.basic)
                { actor.energy = Math.Min(100, actor.energy + 16); Emit(BattleEventKind.Energy, actor, actor, 0, ""); }
                return true;
            }
            if (tick < actor.movementLockUntilTick) return true;
            SkillDefinition selected = null; FighterState selectedTarget = null;
            bool opening = false;
            if (runtime.skillCastLimit == 0 || runtime.casts < runtime.skillCastLimit)
            {
                var first = runtime.data.Skills.FirstOrDefault(s => s.Definition.CastAtBattleStart && !runtime.openingUsed.Contains(s.Definition.Id));
                if (first != null && actor.energy >= first.Definition.EnergyCost)
                { selected = first.Definition; selectedTarget = SelectSkillTarget(actor, enemy, selected); opening = true; runtime.basic = false; }
            }
            if (selected == null && tick >= actor.nextActionTick)
            {
                // Stable slot priority: ultimate first, then unlocked active skills.
                foreach (var entry in runtime.data.Skills.OrderByDescending(s => s.IsUltimate))
                {
                    if (runtime.skillCastLimit > 0 && runtime.casts >= runtime.skillCastLimit) break;
                    var skill = entry.Definition;
                    if(entry.IsUltimate && (record.manualUltimateTeams & (1<<actor.team))!=0 && !actor.ultimateQueued)continue;
                    if (skill.Kind != SkillKind.Active || (skill.Activation != SkillActivation.Automatic && skill.Activation != SkillActivation.UltimateIntent) ||
                        actor.energy < skill.EnergyCost || (runtime.ready.TryGetValue(skill.Id, out int ready) && tick < ready)) continue;
                    var target = SelectSkillTarget(actor, enemy, skill);
                    if (target == null || (target != actor && CombatGeometry.CenterDistance(actor, target) > skill.CastRange)) continue;
                    if (skill.Effects.Any(e => e.Kind == SkillEffectKind.Heal) && target.hp >= target.maxHp) continue;
                    selected = skill; selectedTarget = target; break;
                }
                if (selected == null && !runtime.disableBasicAttacks && CombatGeometry.InAttackRange(actor, enemy))
                {
                    selected = runtime.data.HasNormalAttack ? runtime.data.NormalAttack : BasicSkill(actor);
                    selectedTarget = enemy; runtime.basic = true;
                }
                else runtime.basic = false;
            }
            if (selected != null)
            {
                if(selected.Activation==SkillActivation.UltimateIntent)actor.ultimateQueued=false;
                actor.energy -= selected.EnergyCost;
                if (!runtime.basic) runtime.casts++;
                runtime.pending = selected;
                runtime.pendingTargets = selected.Delivery == SkillDelivery.TargetedEffect
                    ? EffectTargets(actor, selectedTarget, selected).Select(f => f.id).Distinct().ToList() : new List<int> { selectedTarget.id };
                runtime.ready[selected.Id] = tick + Ticks(selected.CooldownMilliseconds);
                if (opening) runtime.openingUsed.Add(selected.Id);
                if (selected.CastSequences.Count > 0)
                {
                    BeginSequence(actor, selectedTarget, selected, opening, runtime);
                    runtime.pending = null;
                    return true;
                }
                actor.action = selected.Activation == SkillActivation.UltimateIntent ? BattleAction.Ultimate : BattleAction.Attack;
                actor.actionTargetId = selectedTarget.id; actor.actionStartTick = tick;
                actor.facingDirection=selectedTarget.x>=actor.x?1:-1;
                actor.actionEndTick = tick + Math.Max(1, Ticks(selected.Delivery == SkillDelivery.Projectile ? selected.ProjectileSpawnMilliseconds : selected.WindupMilliseconds));
                actor.movementLockUntilTick = actor.actionEndTick;
                actor.animationState = string.IsNullOrEmpty(selected.AnimationState) ? runtime.basic ? "NormalAttack" : "Ultimate" : selected.AnimationState;
                actor.animationStartTick = tick;
                actor.animationEndTick = actor.actionEndTick + Ticks(selected.RecoveryMilliseconds);
                if (selected.AnimationDurationMilliseconds > 0) actor.animationEndTick = tick + Ticks(selected.AnimationDurationMilliseconds);
                foreach (var cue in selected.CasterVisuals)
                {
                    var visual = new BattleVisualEffect { actorId = actor.id, followId = cue.FollowCaster ? actor.id : 0,
                        x = actor.x, y = actor.y, forward = cue.Forward, height = cue.Height, direction = selectedTarget.x >= actor.x ? 1 : -1,
                        startTick = tick + Ticks(cue.DelayMilliseconds), state = cue.State, stretchToRange = cue.StretchToRange };
                    visual.endTick = visual.startTick + Ticks(cue.DurationMilliseconds);
                    visual.endX = actor.x + visual.direction * selected.CastRange;
                    record.visualEffects.Add(visual); runtime.castVisuals.Add(visual);
                }
                Emit(BattleEventKind.Action, actor, actor, 0, selected.Name);
                return true;
            }
            var mover=actor;
            if (runtime.disableBasicAttacks)
            {
                var approach=runtime.data.Skills.FirstOrDefault(s=>s.Definition.Kind==SkillKind.Active &&
                    s.Definition.Target!=SkillTarget.Self && s.Definition.Target!=SkillTarget.AllAllies && s.Definition.Target!=SkillTarget.LowestHealthAlly);
                if(approach==null || (runtime.skillCastLimit>0 && runtime.casts>=runtime.skillCastLimit)) { StopMoving(actor);return true; }
                mover=actor.Copy();mover.range=approach.Definition.CastRange;
            }
            if (CombatGeometry.InAttackRange(mover, enemy) && (actor.action != BattleAction.Moving || CombatGeometry.CenterDistance(actor, enemy) <= CombatGeometry.ArrivalDistance(mover)))
            { StopMoving(actor); return true; }
            int nextX = CombatGeometry.ApproachAttackRange(mover, enemy, TickRate);
            foreach (var ally in fighters)
            {
                if (!ally.Alive || ally.team != actor.team || ally.slot >= actor.slot) continue;
                int gap = BattleFormationLayout.WalkingGap(mover, ally);
                if (actor.team == 0 && nextX > actor.x) nextX = Math.Min(nextX, Math.Max(actor.x, ally.x - gap));
                if (actor.team == 1 && nextX < actor.x) nextX = Math.Max(nextX, Math.Min(actor.x, ally.x + gap));
            }
            if (nextX == actor.x) { StopMoving(actor); return true; }
            if (actor.action != BattleAction.Moving) actor.actionStartTick = tick;
            actor.action = BattleAction.Moving; actor.x = nextX;
            actor.facingDirection=enemy.x>=actor.x?1:-1;
            Emit(BattleEventKind.Move, actor, actor, 0, "");
            return true;
        }

        static SkillDefinition BasicSkill(FighterState actor)
        {
            return new SkillDefinition { Id = "basic", Name = "Attack", Target = SkillTarget.NearestEnemy,
                WindupMilliseconds = 300, RecoveryMilliseconds = 150,
                Effects = new List<SkillEffectDefinition> { new SkillEffectDefinition { Kind = SkillEffectKind.Damage, DamageScaleBasisPoints = 10000 } } };
        }
        FighterState SelectSkillTarget(FighterState actor, FighterState enemy, SkillDefinition skill)
        {
            if (skill.Target == SkillTarget.Self) return actor;
            if (skill.Target == SkillTarget.LowestHealthAlly || skill.Target == SkillTarget.AllAllies)
                return fighters.Where(f => f.Alive && f.team == actor.team).OrderBy(f => (long)f.hp * 100000 / f.maxHp).ThenBy(f => f.id).FirstOrDefault();
            if (skill.Target == SkillTarget.LowestHealthEnemy) return WeakestEnemy(actor);
            if (skill.Target == SkillTarget.LowestHealthAndBehind) return WeakestEnemy(actor);
            if (skill.Target == SkillTarget.FarthestEnemy)
                return fighters.Where(f=>f.Alive && f.team!=actor.team).OrderByDescending(f=>CombatGeometry.CenterDistance(actor,f)).ThenBy(f=>f.id).FirstOrDefault();
            if (skill.Target == SkillTarget.NearestEnemy || skill.Target == SkillTarget.EnemiesInRange || skill.Target == SkillTarget.NearestEnemies || skill.Target == SkillTarget.EnemiesInLine)
                return fighters.Where(f => f.Alive && f.team != actor.team).OrderBy(f => CombatGeometry.CenterDistance(actor, f)).ThenBy(f => f.id).FirstOrDefault();
            return enemy;
        }
        List<FighterState> EffectTargets(FighterState actor, FighterState target, SkillDefinition skill)
        {
            if(skill.Target==SkillTarget.LowestHealthAndBehind)
            {
                int direction=target.x>=actor.x?1:-1;
                var hits=fighters.Where(f=>f.Alive && f.team!=actor.team && (long)(f.x-target.x)*direction>=0
                    && Math.Abs((long)f.x-target.x)<=skill.EffectRadius).OrderBy(f=>Math.Abs((long)f.x-target.x)).ThenBy(f=>f.id);
                return skill.MaxTargets>0?hits.Take(skill.MaxTargets).ToList():hits.ToList();
            }
            if (skill.Target == SkillTarget.NearestEnemies)
                return fighters.Where(f => f.Alive && f.team != actor.team && CombatGeometry.CenterDistance(actor, f) <= skill.CastRange)
                    .OrderBy(f => CombatGeometry.CenterDistance(actor, f)).ThenBy(f => f.id).Take(skill.MaxTargets > 0 ? skill.MaxTargets : 1).ToList();
            if (skill.Target == SkillTarget.EnemiesInLine)
            {
                int direction = target.x >= actor.x ? 1 : -1;
                var origin = HeroProjectileOrigin.Resolve(configured[actor.id].data.SpawnPoints, skill);
                int start = actor.x + direction * origin.Forward, end = actor.x + direction * skill.CastRange;
                var hits = fighters.Where(f => f.Alive && f.team != actor.team && f.x >= Math.Min(start,end)-skill.ProjectileHitRadius
                    && f.x <= Math.Max(start,end)+skill.ProjectileHitRadius && origin.Height <= (f.projectileHurtboxHeight > 0 ? f.projectileHurtboxHeight : 100)+skill.ProjectileHitRadius)
                    .OrderBy(f => CombatGeometry.CenterDistance(actor, f)).ThenBy(f => f.id);
                return skill.MaxTargets > 0 ? hits.Take(skill.MaxTargets).ToList() : hits.ToList();
            }
            if (skill.Target == SkillTarget.AllAllies) return fighters.Where(f => f.Alive && f.team == actor.team).ToList();
            if (skill.Target == SkillTarget.AllEnemies) return fighters.Where(f => f.Alive && f.team != actor.team).ToList();
            if (skill.Target == SkillTarget.EnemiesInRange) return fighters.Where(f => f.Alive && f.team != actor.team && CombatGeometry.CenterDistance(actor, f) <= skill.EffectRadius).ToList();
            return new List<FighterState> { target };
        }
        void ApplyEffects(FighterState actor, FighterState target, SkillDefinition skill, int damageMultiplierBasisPoints=10000)
        {
            foreach (var effect in skill.Effects)
            {
                if (!target.Alive) break;
                if (effect.Kind == SkillEffectKind.Damage)
                {
                    int raw=Math.Max(0, effect.Amount + actor.attack * effect.DamageScaleBasisPoints / 10000);
                    int dealt=Damage(actor, target, (int)Math.Min(int.MaxValue,(long)raw*damageMultiplierBasisPoints/10000), skill.Name);
                    StealLife(actor,target,dealt,skill.LifestealBasisPoints,skill.Name,skill.LifestealReturnState);
                }
                else if (effect.Kind == SkillEffectKind.Poison || effect.Kind==SkillEffectKind.Burn) ApplyPoison(actor, target, skill, effect);
                else if (effect.Kind == SkillEffectKind.DamageBuff) ApplyDamageBuff(actor, target, skill, effect);
                else if (effect.Kind == SkillEffectKind.Heal)
                {
                    int before = target.hp; target.hp = Math.Min(target.maxHp, target.hp + effect.Amount + actor.attack * effect.DamageScaleBasisPoints / 10000);
                    Emit(BattleEventKind.Heal, actor, target, target.hp - before, skill.Name);
                }
                else if (effect.Kind == SkillEffectKind.Stun || effect.Kind == SkillEffectKind.KnockUp || effect.Kind == SkillEffectKind.Knockback)
                {
                    target.controlStartTick = tick;
                    target.controlKind = effect.Kind == SkillEffectKind.KnockUp ? ControlKind.KnockUp : effect.Kind == SkillEffectKind.Knockback ? ControlKind.Knockback : ControlKind.Stun;
                    target.stunUntil = Math.Max(target.stunUntil, tick + Ticks(effect.DurationMilliseconds));
                    if (effect.Kind == SkillEffectKind.KnockUp)
                    { target.knockUpUntil = tick + Ticks(effect.DurationMilliseconds); target.knockUpHeight = effect.KnockUpHeight; }
                    if (effect.Kind == SkillEffectKind.Knockback)
                        target.x += (target.x == actor.x ? actor.team == 0 ? 1 : -1 : Math.Sign(target.x - actor.x)) * effect.DisplacementDistance;
                    target.action = BattleAction.Idle; target.actionTargetId = 0;
                    CancelConfiguredVisuals(target);
                    target.presentationHeight = 0;
                    target.animationEndTick = tick;
                    target.nextActionTick = Math.Max(target.nextActionTick, target.stunUntil);
                    target.movementLockUntilTick = target.stunUntil;
                    Emit(BattleEventKind.Stun, actor, target, 0, skill.Name, false, target.controlKind);
                }
            }
        }
        void LaunchProjectile(FighterState actor, FighterState target, SkillDefinition skill)
        {
            int direction = target.x >= actor.x ? 1 : -1;
            bool namedPoint = !string.IsNullOrEmpty(skill.ProjectileSpawnPointId);
            bool hasPoint = namedPoint || skill.ProjectileSpawnOffsetForward != 0 || skill.ProjectileSpawnOffsetHeight != 0 || skill.ProjectileHitOffsetForward != 0;
            var origin = HeroProjectileOrigin.Resolve(configured[actor.id].data.SpawnPoints, skill);
            int originX = checked(actor.x + direction * origin.Forward);
            int height = origin.Height;
            var trace = new BattleProjectile { actorId = actor.id, targetId = target.id, startTick = tick, endTick = tick,
                startX = originX, endX = originX, y = actor.y, direction = direction, resource = skill.ProjectileResource,
                hasSpawnPoint = hasPoint, spawnPointId = namedPoint ? skill.ProjectileSpawnPointId : hasPoint ? "root" : null, spawnHeight = height,
                hitOffsetForward = skill.ProjectileHitOffsetForward, visualScaleBasisPoints = skill.ProjectileVisualScaleBasisPoints };
            trace.flightState = skill.ProjectileFlightState; trace.impactState = skill.ProjectileImpactState;
            trace.impactDurationTicks = Ticks(skill.ProjectileImpactDurationMilliseconds);
            trace.hasFlightPath = !string.IsNullOrEmpty(skill.ProjectileFlightState);
            trace.endHeight = height; trace.endY = actor.y;
            trace.hitOffsetHeight = skill.ProjectileHitOffsetHeight;
            record.projectiles.Add(trace);
            if(skill.ProjectileTracksTarget)trace.path.Add(new ProjectilePathPoint{tick=tick,x=originX,y=actor.y,height=height});
            int destination = checked(target.x - direction * trace.hitOffsetForward);
            flying.Add(new FlyingProjectile { trace = trace, skill = skill, x = originX,
                launchX=actor.x,
                destination = direction > 0 ? Math.Max(originX, destination) : Math.Min(originX, destination),
                expires = tick + Math.Max(1, Ticks(skill.ProjectileLifetimeMilliseconds)), height = height });
        }
        void AdvanceProjectiles()
        {
            for (int i = flying.Count - 1; i >= 0; i--)
            {
                var projectile = flying[i]; var trace = projectile.trace; var actor = Find(trace.actorId);
                if(projectile.skill.ProjectileTracksTarget)
                {
                    var tracked=Find(trace.targetId);
                    if(tracked!=null && tracked.Alive)
                    {
                        if(tracked.x!=projectile.x)trace.direction=Math.Sign(tracked.x-projectile.x);
                        projectile.destination=tracked.x-trace.direction*trace.hitOffsetForward;
                    }
                }
                int previous = projectile.x;
                int next = previous + trace.direction * Math.Max(1, projectile.skill.ProjectileSpeed / TickRate);
                if (projectile.skill.ProjectileAim == ProjectileAim.TargetPosition)
                    next = trace.direction > 0 ? Math.Min(next, projectile.destination) : Math.Max(next, projectile.destination);
                int previousHeight = projectile.height;
                if (projectile.skill.DescendingProjectile)
                {
                    long path = Math.Abs((long)projectile.destination-trace.startX);
                    long distance = Math.Max(1, path);
                    long progress = Math.Min(distance, Math.Abs((long)next - trace.startX));
                    if(path==0)progress=distance;
                    projectile.height = trace.spawnHeight + (int)((projectile.skill.ProjectileTargetHeight - trace.spawnHeight) * progress / distance);
                }
                trace.endHeight = projectile.height;
                int hitStart = previous + trace.direction * trace.hitOffsetForward;
                if(projectile.firstStep)
                {
                    // A nearby opponent can be between the caster and an authored muzzle/tip.
                    hitStart=trace.direction>0?Math.Min(hitStart,projectile.launchX):Math.Max(hitStart,projectile.launchX);
                    projectile.firstStep=false;
                }
                int hitEnd = next + trace.direction * trace.hitOffsetForward;
                var targets = fighters.Where(f => f.Alive && f.team != actor.team && !projectile.hits.Contains(f.id) &&
                    (!projectile.skill.ProjectileTargetOnly || f.id==trace.targetId) &&
                    (!trace.hasSpawnPoint || (Math.Min(previousHeight, projectile.height) + trace.hitOffsetHeight <= (f.projectileHurtboxHeight > 0 ? f.projectileHurtboxHeight : 100) + projectile.skill.ProjectileHitRadius
                        && Math.Max(previousHeight,projectile.height) + trace.hitOffsetHeight + projectile.skill.ProjectileHitRadius >= 0)) &&
                    f.x >= Math.Min(hitStart, hitEnd) - projectile.skill.ProjectileHitRadius && f.x <= Math.Max(hitStart, hitEnd) + projectile.skill.ProjectileHitRadius)
                    .OrderBy(f => Math.Abs((long)f.x - hitStart)).ThenBy(f => f.id).ToList();
                projectile.x = next; trace.endX = next; trace.endTick = tick;
                bool consumed = false;
                foreach (var target in targets)
                {
                    projectile.hits.Add(target.id);
                    trace.hit = true; trace.targetId = target.id;
                    trace.endY = target.y;
                    if (trace.hasSpawnPoint)
                    {
                        int center = target.x - trace.direction * projectile.skill.ProjectileHitRadius;
                        center = Math.Max(Math.Min(hitStart, hitEnd), Math.Min(Math.Max(hitStart, hitEnd), center));
                        trace.endX = Math.Max(Math.Min(previous,next),Math.Min(Math.Max(previous,next),center-trace.direction*trace.hitOffsetForward));
                    }
                    else trace.endX = target.x;
                    ApplyEffects(actor, target, projectile.skill);
                    AddImpactVisual(actor, target, projectile.skill, projectile.height + trace.hitOffsetHeight);
                    if (projectile.hits.Count >= projectile.skill.ProjectileMaxHits) { flying.RemoveAt(i); consumed = true; break; }
                }
                if (!consumed && (tick >= projectile.expires || (projectile.skill.ProjectileAim == ProjectileAim.TargetPosition && next == projectile.destination))) flying.RemoveAt(i);
                if(projectile.skill.ProjectileTracksTarget)
                {
                    // A sequence can release immediately before this tick's projectile step.
                    // Store the final state once per tick, including that release tick.
                    var point=new ProjectilePathPoint{tick=tick,x=trace.endX,y=trace.endY,height=trace.endHeight};
                    if(trace.path.Count>0 && trace.path[trace.path.Count-1].tick==tick)trace.path[trace.path.Count-1]=point;
                    else trace.path.Add(point);
                }
            }
        }
    }
}
