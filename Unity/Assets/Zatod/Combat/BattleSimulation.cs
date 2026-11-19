using System;
using System.Collections.Generic;
using System.Linq;

namespace Zatod.Combat
{
    // Pure C#. No Unity frames, physics, animation callbacks, networking, or wall clock.
    // Both Arena modes can step this same engine; only their command source differs.
    public sealed partial class BattleSimulation
    {
        public const int TickRate = 20;
        public const int MaxTicks = TickRate * 90;
        public const int SnapshotInterval = TickRate * 5;
        public const int AttackRecoveryTicks = 3;
        public const int UltimateRecoveryTicks = 6;
        readonly List<FighterState> fighters = new List<FighterState>();
        readonly BattleRecord record;
        uint random;
        int tick;
        bool finished;
        readonly int maximumTicks;
        readonly HashSet<int> newUltimateRequests = new HashSet<int>();
        public BattleRecord CurrentRecord => record;
        public int CurrentTick => tick;
        public bool Finished => finished;

        public BattleSimulation(string battleId, string opponentId, uint seed, List<FighterState> initial, List<FighterLoadout> loadouts = null, int maximumTicks = MaxTicks, int manualUltimateTeams = 0)
        {
            if (maximumTicks < 1 || maximumTicks > MaxTicks) throw new ArgumentOutOfRangeException(nameof(maximumTicks));
            this.maximumTicks = maximumTicks;
            random = seed == 0 ? 1u : seed;
            record = new BattleRecord { battleId = battleId, opponentId = opponentId, seed = random, tickRate = TickRate, formationLayoutVersion = BattleFormationLayout.Version, manualUltimateTeams = manualUltimateTeams, battleInProgress = true };
            foreach (var fighter in initial) { fighters.Add(fighter.Copy()); record.initial.Add(fighter.Copy()); }
            fighters.Sort((a, b) => a.id.CompareTo(b.id));
            Configure(loadouts);
            Snapshot();
        }

        public BattleRecord RunToCompletion()
        {
            while (!finished) Step();
            return record;
        }

        public bool Step()
        {
            if (finished) return false;
            tick++;
            foreach(int id in newUltimateRequests.OrderBy(id=>id))
            {
                var actor=Find(id);
                if(actor!=null && actor.Alive && actor.ultimateQueued)Emit(BattleEventKind.UltimateQueued,actor,actor,0,"Ultimate queued");
            }
            newUltimateRequests.Clear();
            AdvanceResurrections();
            AdvanceDamageBuffs();
            AdvanceSequences();
            AdvanceScheduledEffects();
            AdvanceProjectiles();
            // Stable ID order is an explicit prototype tie-break; never dictionary iteration order.
            foreach (var fighter in fighters)
            {
                if (!fighter.Alive || fighter.stunUntil > tick) continue;
                var target = AcquireTarget(fighter);
                if (target == null) break;
                if (TryConfiguredAction(fighter, target)) continue;
                if (fighter.action == BattleAction.Attack || fighter.action == BattleAction.Ultimate)
                {
                    var committedTarget = Find(fighter.actionTargetId);
                    if (RequiresLivingTarget(fighter) && (committedTarget == null || !committedTarget.Alive))
                    {
                        CancelAction(fighter);
                        continue;
                    }
                    if (tick < fighter.actionEndTick) continue;
                    Resolve(fighter);
                    if (HasWinner()) break;
                    continue;
                }
                if (tick < fighter.movementLockUntilTick) continue;
                // Cooldown gates the next attack, not target acquisition or movement.
                if (tick >= fighter.nextActionTick && fighter.energy >= 100)
                {
                    fighter.energy = 0;
                    BeginAction(fighter, target, true);
                }
                else if (CombatGeometry.InAttackRange(fighter, target) &&
                    (fighter.action != BattleAction.Moving || CombatGeometry.CenterDistance(fighter, target) <= CombatGeometry.ArrivalDistance(fighter)))
                {
                    StopMoving(fighter);
                    if (tick >= fighter.nextActionTick) BeginAction(fighter, target, false);
                }
                else
                {
                    int nextX = CombatGeometry.ApproachAttackRange(fighter, target, TickRate);
                    // Preserve the original friendly front-to-back walking order.
                    foreach (var ally in fighters)
                    {
                        if (!ally.Alive || ally.team != fighter.team || ally.slot >= fighter.slot) continue;
                        int gap = BattleFormationLayout.WalkingGap(fighter, ally);
                        if (fighter.team == 0 && nextX > fighter.x) nextX = Math.Min(nextX, Math.Max(fighter.x, ally.x - gap));
                        if (fighter.team == 1 && nextX < fighter.x) nextX = Math.Max(nextX, Math.Min(fighter.x, ally.x + gap));
                    }
                    if (nextX == fighter.x)
                    {
                        StopMoving(fighter);
                        if (tick >= fighter.nextActionTick && CombatGeometry.InAttackRange(fighter, target)) BeginAction(fighter, target, false);
                        continue;
                    }
                    if (fighter.action != BattleAction.Moving) fighter.actionStartTick = tick;
                    fighter.action = BattleAction.Moving;
                    fighter.x = nextX;
                    Emit(BattleEventKind.Move, fighter, fighter, 0, "");
                    if (CombatGeometry.CenterDistance(fighter, target) <= CombatGeometry.ArrivalDistance(fighter)) StopMoving(fighter);
                }
            }
            if (HasWinner() || tick >= maximumTicks) Finish();
            else if (tick % SnapshotInterval == 0) Snapshot();
            if(!finished)record.durationTicks=tick;
            return !finished;
        }

        public bool RequestUltimate(int fighterId)
        {
            var actor=Find(fighterId);
            if(finished || actor==null || !actor.Alive || actor.ultimateQueued || actor.stunUntil>tick ||
                (record.manualUltimateTeams & (1<<actor.team))==0 || !configured.TryGetValue(fighterId,out var runtime))return false;
            var ultimate=runtime.data.Skills.Find(s=>s.IsUltimate);
            if(ultimate==null || ultimate.Definition.Kind!=Zatod.Heroes.SkillKind.Active || actor.energy<ultimate.Definition.EnergyCost)return false;
            actor.ultimateQueued=true;newUltimateRequests.Add(fighterId);return true;
        }

        void BeginAction(FighterState actor, FighterState target, bool ultimate)
        {
            actor.action = ultimate ? BattleAction.Ultimate : BattleAction.Attack;
            actor.actionStartTick = tick;
            actor.actionEndTick = tick + (ultimate ? 12 : 6);
            actor.movementLockUntilTick = actor.actionEndTick;
            // A skill's locked target is independent of the normal-attack target.
            if (ultimate && actor.role == FighterRole.Ranger) target = WeakestEnemy(actor) ?? target;
            actor.actionTargetId = target.id;
            Emit(BattleEventKind.Action, actor, actor, 0, ultimate ? Ability(actor.role) : "Attack");
        }

        void Resolve(FighterState actor)
        {
            bool ultimate = actor.action == BattleAction.Ultimate;
            var target = Find(actor.actionTargetId);
            actor.action = BattleAction.Idle;
            actor.actionTargetId = 0;
            actor.nextActionTick = tick + actor.attackInterval;
            actor.movementLockUntilTick = tick + (ultimate ? UltimateRecoveryTicks : AttackRecoveryTicks);
            Emit(BattleEventKind.Action, actor, actor, 0, "Recover");
            if (!ultimate)
            {
                // A dead target makes this attack miss; no retargeted invisible hit.
                if (target != null && target.Alive && CombatGeometry.InAttackRange(actor, target)) Damage(actor, target, actor.attack, "Attack");
                else Emit(BattleEventKind.Miss, actor, actor, 0, "Attack missed");
                actor.energy = Math.Min(100, actor.energy + 16);
                Emit(BattleEventKind.Energy, actor, actor, 0, "");
                return;
            }
            string ability = Ability(actor.role);
            if (actor.role == FighterRole.Medic)
            {
                foreach (var ally in fighters)
                {
                    if (ally.team != actor.team || !ally.Alive) continue;
                    int before = ally.hp;
                    ally.hp = Math.Min(ally.maxHp, ally.hp + 650);
                    Emit(BattleEventKind.Heal, actor, ally, ally.hp - before, ability);
                }
            }
            else if (actor.role == FighterRole.Arcanist)
            {
                foreach (var enemy in fighters)
                    if (enemy.team != actor.team && enemy.Alive) Damage(actor, enemy, 480, ability);
            }
            else
            {
                if (target == null || !target.Alive)
                { Emit(BattleEventKind.Miss, actor, actor, 0, "Skill missed"); return; }
                Damage(actor, target, actor.role == FighterRole.Striker ? 1100 : 720, ability);
                if (actor.role == FighterRole.Vanguard && target.Alive)
                {
                    target.stunUntil = tick + 28;
                    target.controlStartTick = tick;
                    target.controlKind = ControlKind.Stun;
                    target.animationEndTick = tick;
                    if (target.action == BattleAction.Attack || target.action == BattleAction.Ultimate)
                    {
                        target.action = BattleAction.Idle;
                        target.actionTargetId = 0;
                        target.nextActionTick = Math.Max(target.nextActionTick, target.stunUntil);
                        target.movementLockUntilTick = target.stunUntil;
                        Emit(BattleEventKind.Cancel, actor, target, 0, "Interrupted");
                    }
                    else if (target.action == BattleAction.Moving) target.action = BattleAction.Idle;
                    Emit(BattleEventKind.Stun, actor, target, 0, ability);
                }
            }
        }

        FighterState AcquireTarget(FighterState actor)
        {
            var current = Find(actor.targetId);
            if (current != null && current.Alive && current.team != actor.team) return current;
            var selected = FrontEnemy(actor);
            int id = selected == null ? 0 : selected.id;
            if (actor.targetId != id)
            {
                actor.targetId = id;
                Emit(BattleEventKind.Target, actor, actor, 0, "Target acquired");
            }
            return selected;
        }

        static bool RequiresLivingTarget(FighterState actor)
        {
            return actor.action == BattleAction.Attack ||
                (actor.role != FighterRole.Arcanist && actor.role != FighterRole.Medic);
        }

        void CancelAction(FighterState actor)
        {
            bool ultimate = actor.action == BattleAction.Ultimate;
            actor.action = BattleAction.Idle;
            actor.actionTargetId = 0;
            actor.nextActionTick = tick + actor.attackInterval;
            actor.movementLockUntilTick = tick + (ultimate ? UltimateRecoveryTicks : AttackRecoveryTicks);
            Emit(BattleEventKind.Cancel, actor, actor, 0, "Target defeated");
        }

        void StopMoving(FighterState actor)
        {
            if (actor.action != BattleAction.Moving) return;
            actor.action = BattleAction.Idle;
            Emit(BattleEventKind.Action, actor, actor, 0, "In position");
        }

        int Damage(FighterState actor, FighterState target, int baseDamage, string ability, bool allowCritical = true)
        {
            baseDamage = (int)Math.Min(int.MaxValue / 200, (long)baseDamage * (10000 + actor.damageBonusBasisPoints) / 10000);
            bool critical = allowCritical && NextRandom() % 100 < 15;
            int damage = Math.Max(1, baseDamage * 100 / (100 + target.armor));
            if (critical) damage = damage * 3 / 2;
            int actual = Math.Min(target.hp, damage);
            target.hp -= actual;
            target.energy = Math.Min(100, target.energy + 10);
            Emit(BattleEventKind.Damage, actor, target, actual, ability, critical);
            if (!target.Alive)
            {
                target.ultimateQueued=false;
                CancelConfiguredVisuals(target);
                target.action = BattleAction.Dead;
                target.actionStartTick = tick;
                target.animationState = "Death";
                target.animationStartTick = tick;
                target.energy = 0;
                Emit(BattleEventKind.Death, actor, target, 0, ability);
                ScheduleResurrection(target);
            }
            StealLife(actor,target,actual,actor.lifestealUntil>tick?actor.lifestealBasisPoints:0,ability,null);
            return actual;
        }

        void Finish()
        {
            finished = true;
            record.battleInProgress=false;
            bool left = TeamAlive(0), right = TeamAlive(1);
            record.winner = left && !right ? 0 : right && !left ? 1 : -1;
            record.timedOut = left && right;
            record.combatEndTick = tick;
            RecordSequenceReturnsAfterCombat();
            // Keep a recorded, outcome-free tail so the final hero's Death clip can finish.
            // Timeline pause/seek still owns this time; no client-side timer changes the result.
            if (!record.timedOut && fighters.Exists(f => !string.IsNullOrEmpty(f.animationSetResource)))
                tick = Math.Max(tick, record.combatEndTick + Math.Max(30, fighters.Max(f => f.deathVisualTicks)));
            record.durationTicks = tick;
            Emit(BattleEventKind.Finished, null, null, 0, record.timedOut ? "Timeout draw" : "Battle finished");
            Snapshot();
        }

        void Snapshot()
        {
            var snapshot = new BattleSnapshot { tick = tick, nextEventIndex = record.events.Count };
            foreach (var fighter in fighters) snapshot.fighters.Add(fighter.Copy());
            record.snapshots.Add(snapshot);
        }

        void Emit(BattleEventKind kind, FighterState actor, FighterState target, int amount, string ability, bool critical = false, ControlKind control = ControlKind.None)
        {
            record.events.Add(new BattleEvent
            {
                sequence = record.events.Count, tick = tick, kind = kind,
                actorId = actor == null ? 0 : actor.id, targetId = target == null ? 0 : target.id,
                amount = amount, ability = ability, critical = critical, controlKind = control, hasState = target != null,
                state = target == null ? new FighterState() : target.Copy()
            });
        }

        bool TeamAlive(int team) { foreach (var f in fighters) if (f.team == team && (f.Alive || f.reviveAtTick>tick)) return true; return false; }
        bool HasWinner() { return !TeamAlive(0) || !TeamAlive(1); }
        FighterState Find(int id) { foreach (var f in fighters) if (f.id == id) return f; return null; }
        FighterState FrontEnemy(FighterState actor)
        {
            FighterState best = null;
            long distance = long.MaxValue;
            bool bestAhead = false;
            int direction = actor.team == 0 ? 1 : -1;
            foreach (var f in fighters)
            {
                if (f.team == actor.team || !f.Alive) continue;
                bool ahead = ((long)f.x - actor.x) * direction >= 0;
                long d = CombatGeometry.CenterDistance(actor, f);
                if (best == null || (ahead && !bestAhead) || (ahead == bestAhead &&
                    (d < distance || (d == distance && f.id < best.id))))
                { best = f; distance = d; bestAhead = ahead; }
            }
            return best;
        }
        FighterState WeakestEnemy(FighterState actor)
        {
            FighterState best = null;
            foreach (var f in fighters)
                if (f.team != actor.team && f.Alive && (best == null || f.hp < best.hp || (f.hp == best.hp && f.id < best.id))) best = f;
            return best;
        }
        uint NextRandom() { random ^= random << 13; random ^= random >> 17; random ^= random << 5; return random; }
        public static string Ability(FighterRole role)
        {
            switch (role)
            {
                case FighterRole.Vanguard: return "Shield Break";
                case FighterRole.Striker: return "Execution";
                case FighterRole.Ranger: return "Deadeye";
                case FighterRole.Arcanist: return "Arcane Storm";
                default: return "Restoration";
            }
        }
    }
}
