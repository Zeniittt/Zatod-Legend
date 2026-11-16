using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using Zatod.Combat;

static class Program
{
    static int assertions;
    static readonly JsonSerializerOptions Json = new JsonSerializerOptions { IncludeFields = true };
    static void Check(bool condition, string message) { assertions++; if (!condition) throw new Exception(message); }
    static string State(FighterState f) { return JsonSerializer.Serialize(f, Json); }
    static BattleRecord Simulate(string opponent, uint seed) { return new BattleSimulation("test", opponent, seed, PrototypeTeams.Create(opponent)).RunToCompletion(); }

    static void Main()
    {
        MovementScenarios();
        foreach (string opponent in PrototypeTeams.OpponentIds)
        for (uint seed = 1; seed <= 12; seed++)
        {
            var record = Simulate(opponent, seed);
            Check(record.durationTicks > 0 && record.durationTicks <= BattleSimulation.MaxTicks, "Bounded duration");
            Check(record.events.Last().kind == BattleEventKind.Finished, "Terminal event");
            Check(record.events.Any(e => e.kind == BattleEventKind.Damage), "Damage exercised");
            Check(record.events.Any(e => e.kind == BattleEventKind.Action && e.ability != "Attack" && e.ability != "Recover"), "Auto ultimate exercised");
            int previousTick = 0;
            var reference = record.initial.ToDictionary(f => f.id, f => f.Copy());
            var timeline = new ReplayTimeline(record);
            for (int i = 0; i < record.events.Count; i++)
            {
                var e = record.events[i];
                Check(e.sequence == i && e.tick >= previousTick, "Stable total event order");
                previousTick = e.tick;
                if (e.kind == BattleEventKind.Damage && e.ability == "Attack")
                    Check(CombatGeometry.InAttackRange(reference[e.actorId], reference[e.targetId]), "Basic damage applied out of center range");
                if (e.hasState)
                {
                    Check(e.state.hp >= 0 && e.state.hp <= e.state.maxHp && e.state.energy >= 0 && e.state.energy <= 100, "State bounds");
                    reference[e.state.id] = e.state.Copy();
                }
                if (e.kind == BattleEventKind.Move)
                {
                    var moved = reference[e.actorId];
                    foreach (var ally in reference.Values.Where(f => f.Alive && f.team == moved.team && f.slot < moved.slot))
                    {
                        int gap = Math.Max(ally.formationSpacing, moved.formationSpacing);
                        Check(moved.team == 0 ? moved.x <= ally.x - gap : moved.x >= ally.x + gap, "Normal movement crossed a living teammate");
                    }
                }
            }
            timeline.AdvanceTo(record.durationTicks);
            foreach (var f in reference.Values) Check(State(f) == State(timeline.States[f.id]), "Final playback matches server");
            // Every tick: compare seeking via snapshots with sequential outcome playback.
            var sequential = new ReplayTimeline(record);
            for (int tick = 0; tick <= record.durationTicks; tick++)
            {
                sequential.AdvanceTo(tick, false);
                timeline.Seek(tick);
                foreach (var f in sequential.States.Values) Check(State(f) == State(timeline.States[f.id]), "Seek differs at tick " + tick);
            }
            // Backwards seek, end, start, and serialization round trip.
            var roundTrip = JsonSerializer.Deserialize<BattleRecord>(JsonSerializer.Serialize(record, Json), Json);
            var loaded = new ReplayTimeline(roundTrip);
            loaded.Seek(record.durationTicks);
            loaded.Seek(record.durationTicks / 3);
            timeline.Seek(record.durationTicks / 3);
            foreach (var f in timeline.States.Values) Check(State(f) == State(loaded.States[f.id]), "Serialized replay differs");
            Check(JsonSerializer.Serialize(record, Json) == JsonSerializer.Serialize(Simulate(opponent, seed), Json), "Same server inputs are reproducible");
            // Playback stays unchanged even when initial combat stats change after the match.
            var before = timeline.States.ToDictionary(kv => kv.Key, kv => State(kv.Value));
            foreach (var f in record.initial) f.attack = 999999;
            timeline.Seek(record.durationTicks / 3);
            foreach (var f in timeline.States.Values) Check(before[f.id] == State(f), "Replay recalculated combat");
            Console.WriteLine($"PASS {opponent} seed={seed} duration={record.DurationSeconds:F2}s events={record.events.Count} winner={record.winner}");
        }
        var timeoutTeams = PrototypeTeams.Create("balanced");
        foreach (var f in timeoutTeams) { f.maxHp = f.hp = 1000000; f.attack = 0; }
        var timeout = new BattleSimulation("timeout", "balanced", 1, timeoutTeams).RunToCompletion();
        Check(timeout.timedOut && timeout.winner == -1 && timeout.durationTicks == BattleSimulation.MaxTicks, "Timeout draw policy");
        bool rejected = false;
        try { PrototypeTeams.Create("client-invented-stats"); } catch (ArgumentException) { rejected = true; }
        Check(rejected, "Unknown opponent rejected");
        rejected = false;
        try { new ReplayTimeline(new BattleRecord { schemaVersion = 999 }); } catch (ArgumentException) { rejected = true; }
        Check(rejected, "Unknown replay version rejected");
        Console.WriteLine($"ALL PASS: {assertions:N0} assertions across 36 matches plus movement scenarios, every replay tick, snapshots, persistence round trips and timeout.");
    }

    static FighterState Unit(int id, int team, int slot, int x, int range)
    {
        return new FighterState { id = id, team = team, slot = slot, name = "Fixture", role = FighterRole.Striker,
            x = x, hp = 100000, maxHp = 100000, attack = 100, armor = 0, range = range,
            attackInterval = 10000, moveSpeed = 200 };
    }
    static FighterState Stationary(FighterState f) { f.movementLockUntilTick = BattleSimulation.MaxTicks + 1; return f; }
    static BattleRecord Fixture(params FighterState[] units)
    {
        return new BattleSimulation("fixture", "balanced", 17, new List<FighterState>(units)).RunToCompletion();
    }
    static void MovementScenarios()
    {
        // A dead front target exposes a distant one. Melee chases during recovery cooldown;
        // an archer already in range stays put. The in-flight hit never transfers to the new target.
        var melee = Unit(1, 0, 0, 0, 100);
        var archer = Unit(2, 0, 1, -200, 650); archer.role = FighterRole.Ranger;
        var front = Stationary(Unit(101, 1, 0, 100, 0)); front.hp = front.maxHp = 1;
        var back = Stationary(Unit(102, 1, 1, 400, 0));
        var r = Fixture(melee, archer, front, back);
        var death = r.events.First(e => e.kind == BattleEventKind.Death && e.targetId == 101);
        var chase = r.events.First(e => e.kind == BattleEventKind.Move && e.actorId == 1 && e.tick > death.tick);
        Check(chase.state.targetId == 102, "Melee did not acquire the exposed back target");
        Check(chase.tick < chase.state.nextActionTick, "Cooldown incorrectly blocked movement");
        Check(chase.tick >= death.tick + BattleSimulation.AttackRecoveryTicks, "Recovery animation lock ignored");
        Check(!r.events.Any(e => e.kind == BattleEventKind.Move && e.actorId == 2), "In-range archer moved with the melee unit");
        Check(r.events.Any(e => e.kind == BattleEventKind.Cancel && e.actorId == 2 && e.ability == "Target defeated"), "Dead-target windup was not cancelled");
        Check(!r.events.Any(e => e.kind == BattleEventKind.Damage && e.actorId == 2 && e.targetId == 102 && e.tick == death.tick), "Pending damage transferred to new target");
        var lastMove = r.events.Last(e => e.kind == BattleEventKind.Move && e.actorId == 1);
        Check(lastMove.state.x == 310, "Melee did not stop just inside center range");
        Check(lastMove.state.y == melee.y, "Shallow display depth became a navigation lane");
        Console.WriteLine("PASS front death -> retarget -> chase during cooldown; ranged unit stays; windup cancelled");

        // Depth must not make a rear target appear closer than the front target.
        var a = Unit(1, 0, 0, 0, 150);
        var near = Stationary(Unit(101, 1, 0, 100, 0)); near.y = 100000;
        var far = Stationary(Unit(102, 1, 1, 200, 0));
        r = Fixture(a, near, far);
        Check(r.events.First(e => e.kind == BattleEventKind.Target && e.actorId == 1).state.targetId == 101, "Target selection used visual depth");
        Check(r.events.Any(e => e.kind == BattleEventKind.Damage && e.actorId == 1 && e.targetId == 101), "Center range included visual depth or a body radius");
        a.targetId = 102; a.range = 250;
        r = Fixture(a, near, far);
        Check(!r.events.Any(e => e.kind == BattleEventKind.Target && e.actorId == 1), "Valid target was repeatedly replaced");
        Check(r.events.Any(e => e.kind == BattleEventKind.Damage && e.actorId == 1 && e.targetId == 102), "Stable target not retained");

        // Large movement steps stop inside range rather than crossing the target.
        a = Unit(1, 0, 0, 0, 100); a.moveSpeed = 20000;
        r = Fixture(a, Stationary(Unit(101, 1, 0, 1000, 0)));
        Check(r.events.First(e => e.kind == BattleEventKind.Move).state.x == 910, "Fast movement overshot its attack position");
        Check(r.events.Count(e => e.kind == BattleEventKind.Move && e.actorId == 1) == 1, "Stationary target caused boundary jitter");

        // Target walks away during attack windup; the attacker must miss, then chase after its lock.
        a = Unit(1, 0, 0, 0, 100);
        var bait = Unit(101, 1, 0, 80, 0); bait.targetId = 2; bait.nextActionTick = 10000; bait.moveSpeed = 4000;
        r = Fixture(a, Stationary(Unit(2, 0, 1, 2000, 0)), bait);
        Check(r.events.Any(e => e.kind == BattleEventKind.Miss && e.actorId == 1 && e.tick == 7), "Attack hit a target that had left range");
        Check(!r.events.Any(e => e.kind == BattleEventKind.Move && e.actorId == 1 && e.tick < 10), "Attacker moved during windup/recovery lock");

        // A targeted ultimate locks its victim at cast start; killing that victim cancels it.
        a = Unit(1, 0, 0, 0, 200); a.role = FighterRole.Ranger; a.energy = 100;
        front = Stationary(Unit(101, 1, 0, 100, 0)); front.hp = front.maxHp = 1;
        r = Fixture(a, Unit(2, 0, 1, 0, 200), front, Stationary(Unit(102, 1, 1, 150, 0)));
        var cast = r.events.First(e => e.kind == BattleEventKind.Action && e.actorId == 1 && e.ability == "Deadeye");
        Check(cast.state.actionTargetId == 101, "Ultimate victim was not committed at cast start");
        Check(r.events.Any(e => e.kind == BattleEventKind.Cancel && e.actorId == 1), "Targeted ultimate did not cancel after victim death");
        Check(!r.events.Any(e => e.kind == BattleEventKind.Damage && e.actorId == 1 && e.ability == "Deadeye"), "Ultimate jumped to another victim");
        Console.WriteLine("PASS center distance, front priority, stable targets, no overshoot/jitter, action locks and locked ultimate targets");
    }
}
