# Combat and offline Arena replay contract

## Authority and lifetime

The dedicated server process is the only authority. It owns both prototype squads, opponent IDs, RNG seed, simulation, result, and replay persistence. A client sends an opponent ID and an opaque request ID, never fighter stats, damage, RNG, or victory. Client UI uses placeholder templates only for the pre-match preview; it never computes the result.

There is deliberately no player-host route. On Windows a separate headless Player uses `--arena-server`; Linux Dedicated Server builds also select server mode through `UNITY_SERVER`. The GUI client only connects. Telepathy provides ordered reliable TCP transport for this prototype, not a prediction/rollback system.

On challenge, the server freezes both initial squads, runs the pure simulation on a worker task, returns to Unity's main thread, serializes the record, flushes a temporary file and renames it to its immutable ID. Only then does it send a successful replay response. Disconnecting does not cancel the running simulation coroutine; it still persists the match.

The request ID doubles as the battle ID for the single development account. A committed duplicate returns the same stored bytes, even after a process restart; using that ID for another opponent is rejected. Concurrent duplicates are reported as pending. This is not a production authorization scheme. With real accounts, use an authenticated player ID + idempotency key, server-generated battle IDs, ownership checks and transactional storage for result, replay reference and rank settlement.

Atomic rename protects against partially published replay files. Local disk durability still depends on the filesystem/host; rank and replay cannot become a single durable transaction until a database is introduced. No rank settlement is implemented in this prototype.

## Record format, schema 1

Gzip-compressed JSON, `.arena.gz`. Includes schema/rules version, immutable ID, creation UTC, server seed, tick rate, both initial squads, total ordered event stream, five-second snapshots, duration, winner and timeout policy. Each event has tick + sequence, actor/target IDs, resolved amount, ability, critical flag and the complete resulting state of the changed fighter.

The absolute state updates intentionally trade some space for a simple, auditable replay. The replay timeline applies outcomes and never calls AI, RNG or damage formulas. A future balance change does not reroll old damage. Visual fidelity across updates still requires compatible role/ability assets or an explicit replay expiration policy. Unknown schemas are rejected explicitly; they are not guessed.

Entity IDs are per-battle integers, independent of Mirror connection IDs or scene objects. Compressed transfers have SHA-256 integrity checks and 8 KiB ordered chunks. Limits: 4 MiB archive, 16 MiB decompressed JSON, 200,000 events. This checksum detects corruption; it is not a digital signature or an anti-cheat boundary.

Seeking selects the last snapshot at or before the requested tick, restores it, then applies outcomes up to that tick. Snapshots are taken after all events at their tick and store the first unapplied event index. They include position, current action/start/end, normal target, locked action target, movement-lock deadline, attack-cooldown deadline, stun deadline, HP and energy. Seek clears transient popups instead of replaying old sound/VFX; current cast pose is reconstructed from state and the replay clock.

Playback owns its clock. Pause, speed and seek never modify server time or combat. Presentation interpolation is cosmetic and cannot feed back into damage. Rendering runs independently of the 20 Hz combat tick.

## Horizontal combat, rules version 2

`CombatGeometry` measures center-to-center distance on the horizontal axis. The shallow `y` coordinate is recorded display depth, not a navigation lane or part of attack range. Formation order, range, move speed and friendly spacing are independent data. Normal walking preserves front-to-back teammate order; there are no physics colliders or assumed body radii.

A living valid normal target is retained. When it dies, the unit acquires the closest living enemy ahead, with a stable ID tie-break; if none is ahead, it can turn toward the nearest remaining enemy. Target changes are explicit replay events. An out-of-range unit approaches a position slightly inside its attack range, clamps movement steps to that position and follows a moving target. Units already in range remain stationary. Attack cooldown does not block movement; windup and short recovery locks do.

The action target is locked separately at cast start. A pending basic attack or targeted ultimate is cancelled when that victim dies, without transferring damage or refunding ultimate energy. Basic attacks also check center range at impact. Untargeted team heals and area ultimates continue according to their own existing policies. This prototype has no separate projectile-flight phase yet.

Presentation uses one shared camera transform over the recorded centers and a small shallow-depth offset. It does not clamp individual units to a side of the screen. Attack poses animate only the icon, leaving the unit root and health bars at their recorded center. Friendly spacing is simulation data, independent of temporary placeholder-art dimensions.

The archive remains schema 1: new state fields and enum values are additive, preserving existing enum numbers. New matches identify rules `combat-prototype-2`; old matches retain `combat-prototype-1`, apply their recorded outcomes and use an explicitly labeled legacy presentation layout. They are never re-simulated using new rules.

## Prototype boundaries

- One development account shared by all connections; no auth, private replay ownership or real matchmaking.
- Three fixed opponent templates; Arena does not yet consume HeroDesk. A separate JSON Hero config, owned-data model, rank progression and Editor balance sandbox are described in [hero-data.md](hero-data.md). No account database or inventory transactions.
- Ninety-second timeout is a draw. Stable ID order resolves simultaneous actions; this provisional initiative rule needs a competitive fairness pass.
- Position and range are logical coordinates, not Unity physics. No navigation mesh, physical collision or hero-specific movement yet.
- Twenty recent summaries are returned; UI shows three. No pagination, quotas, retention, cloud backup or migrations yet.
- Challenge creation has a one-second per-connection throttle and an eight-job global cap. This is a prototype bound, not comprehensive production rate limiting.
- Client has request deadlines and transfer bounds. Connection loss does not stop viewing an already loaded record; the server copy remains the source for future sessions.
- Replay visual presentation preserves combat outcomes and action state. It does not promise bit-identical particle/audio frames or camera state.

## Live Arena extension

Reuse the same combat state and resolved event stream. Add an explicit control policy per team: auto ultimates in offline mode; validated player intent in live mode. Accepted commands need an authoritative execution tick and sequence; the server continues simulation in real time, broadcasts committed outcomes and records them incrementally.

Before implementing live mode, define input-delay policy, simultaneous commands, disconnect/reconnect/forfeit behavior and timeouts. Store accepted commands alongside outcomes for debugging; user-facing replay still reads resolved outcomes. Spectators and reconnection can consume a current snapshot plus later events from the same protocol model.
