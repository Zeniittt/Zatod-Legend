# Hero Combat Sandbox

The opponent side is a **live Monster team**. Keep one Hero and choose/add/remove 1–5 Monsters; repeats are allowed. HP override 0 uses config HP. Monsters fight in auto, basic-only and single-skill tests; the Hero can approach into its selected skill's range. See [monsters.md](monsters.md) for definitions and balance instructions.

Open `Assets/Zatod/Scenes/ArenaPrototype.unity`, then **Zatod > Heroes > Combat Sandbox**. This Editor-only tool loads the saved split Hero config and uses the same pure-C# combat engine as the dedicated server. It does not start Mirror, persist a replay archive, or alter the formation account's HeroDesk. It is a fast combat/effect preview; test networking separately in Arena.

## Quick use

1. Select a Hero from the catalog dropdown. New definitions appear after **Reload saved config**; no per-Hero sandbox code is required.
2. Press **TEST ALL SKILLS / highest rank**. The tool selects the last reachable rank, creates a temporary Hero through the normal promotion/gear-absorption path, then runs a short fight. It enters Play Mode automatically if needed.
3. Use **Auto fight / selected rank**, **Normal attack only**, or a named skill button. A single-skill preview starts a fresh test and attempts one cast, with basic attacks suppressed. It preserves the configured effect/timing/cost and cooldown; it is not a forced hit.
4. Use Pause/Play and ±1 tick in the tool, or the existing replay slider and speed controls in Game view. Animation and projectile visuals follow the replay clock.

Starting defaults: highest rank, 50% HP, 100 energy, 15 seconds, three live monsters using config HP, spacing 220 and seed 123. The selected Hero determines a useful initial target distance; saved settings may differ. Use **Monster to add / Add Monster**, change a row's type, or remove a row to build the enemy team. **Monster HP override = 0** keeps definition HP; a positive value changes only the battle copy. Use HP below 100% to test self-healing. Single-skill tests respect range and energy: the Hero approaches when necessary, while monsters can interrupt or kill it. Radius skills use the enemies' positions at impact, so moving monsters can change the number hit.

For Leenald, the four named buttons test Earth Seal/Stun, Rising Stone/KnockUp, Meditation/Heal and Repelling Palm/Knockback. White rank keeps the three later skills disabled; the highest-rank button unlocks them on the temporary Hero only. The runtime labels distinguish stunned, airborne and knockback, and the event feed includes healing.

Save changes in Hero Balance before reloading here. Existing account objects and previously generated replays remain unchanged. The sandbox camera uses a closer display scale to inspect small logical ranges; Arena's camera scale is unchanged. Render assets still come from the Hero's configured animation manifest. Heroes without an animation set use role markers.

Rules version 4 adds named projectile spawn points on Hero definitions, selected by each skill and frozen into battle data. Skill2 now preserves its original grounded cast-foot alignment, and its server hit shape uses the resolved origin/offset. Replay camera framing is fixed for the complete test so knockback does not make the caster slide on screen. Press a skill button to generate a new record after config changes; an already saved battle retains its original outcomes.

## Boundaries and checks

Enchantx raises the catalog to 21 Heroes. **Single-skill casts (1–5)** defaults to 1; set it to 2 and increase duration to test an opening cast and a later repeat without bypassing cooldowns or energy. Enchantx Skill3 opens immediately when unlocked, then uses a stationary summon sequence on repeat. Its selected target distance includes space for configured opening movement. Details: [enchantx.md](enchantx.md).

Active Damage/Heal/Stun/KnockUp/Knockback/Poison effects are supported by the current core, including delayed effects on selected targets and a forward beam. Passive/event triggers and StatBonus application are not implemented yet; passive buttons are disabled. A new effect kind still needs a combat implementation before this tool can test it. Preview does not replace a server/network or multiplayer command test.

Kavern is included in the 20-Hero catalog. Selecting a Hero sets a useful target distance from its base attack range (70–600); Kavern uses 600. **TEST ALL SKILLS / highest rank** unlocks its four skills on the temporary Hero. Skill3 creates at most two grounded ArrowShowers; Skill4 stuns one hit victim for one second. See [kavern.md](kavern.md) for configuration, effects and provisional balance values. Rules 5 preserve poison and separate flight/impact/target visuals in the replay.

`VerifyCombatSandbox.cs`: 164 checks for all four isolated skills, AoE boundaries, repeatable seed, detached source config, replay seeking and basic attacks across all 19 catalog Heroes. `VerifyCombatSandboxUi.cs`: 36 checks through actual UI Toolkit button events, including all four casts, tick stepping, rank gates, highest-rank test, no network startup and unchanged owned HeroDesk. The window was also checked through Play/Stop and domain reload, including automatic entry from Edit Mode.

Artifacts: `Artifacts/combat-sandbox-window.png`, `Artifacts/combat-sandbox-runtime.png`. Existing 347,493 combat and 106 Hero checks pass after the shared-core changes. This feature is Editor-only, so no standalone build is needed to use it.
