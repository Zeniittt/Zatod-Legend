# Monsters and live Combat Sandbox

Open **Zatod > Heroes > Combat Sandbox** in `ArenaPrototype.unity`. The Hero side remains one temporary Hero, with the existing rank, HP, energy, auto/basic/single-skill, cast-count, seed and playback controls.

## Opponent team

- Choose **Monster to add**, then **Add Monster**. Each row can change type or be removed. Repeated types are supported; the limit is 1–5 monsters.
- **Monster count** resizes the list, repeating the last selected type when adding slots.
- **Target distance** is the initial distance to the first opponent; **Target spacing** controls initial horizontal spacing and friendly formation spacing. New teams default to spacing 220. Execution sorts front/middle/rear and preserves entered order within a position group.
- **Monster HP override = 0** uses each definition's HP. A positive value overrides spawned HP on detached battle copies. Old standing-target settings migrate once to config HP and the live team.
- Monsters move, attack, take damage/control effects, die and cause retargeting in every test mode. **Single-skill mode suppresses Hero basics only**; the Hero can approach into skill range and enemies still fight back or interrupt. After the requested casts, the Hero may be defeated.

Sandbox uses the same pure-C# combat engine as the dedicated server, without starting a Mirror host/client, changing HeroDesk, spending inventory or committing a server replay. This phase adds no extra Hero slots, presets, campaign stages or waves.

## Starter definitions

| ID | Role | HP | Damage | Defense | Range |
| --- | --- | ---: | ---: | ---: | ---: |
| fighter_goblin | Front melee | 900 | 60 | 10 | 1,400 |
| skeleton_knight | Front durable melee | 1,800 | 90 | 35 | 1,400 |
| goblin_mage | Rear ranged; normal fireball | 700 | 45 | 5 | 2,000 |
| guardian | Front melee; sword attack | 1,600 | 100 | 25 | 1,400 |
| archer | Rear ranged; arrow | 750 | 65 | 5 | 2,800 |
| huntress | Middle ranged; thrown spear | 1,000 | 85 | 15 | 2,400 |
| evil_wizard | Rear ranged; spell projectile | 900 | 110 | 10 | 2,600 |

These are provisional values. Definitions include normal-attack timing, move speed/attack interval, position, projectile points/hurtbox, portrait, body prefab and animation manifest. `SkillIds` is empty for all seven starters. Normal attacks reuse shared attack/effect configuration; monsters do not gain role ultimates, even at 100 energy.

### Archer, Huntress and Evil Wizard

Select each name in **Monster to add**, then **Add Monster**, or change an existing slot. The same 1–5 opponent limit applies, including repeated types.

Imported original PNGs from the supplied `Enemies/Archer`, `Enemies/Huntress` and nested `Enemies/Evil Wizard 3/Evil Wizard 3` folders. **140 source frames / 19 unique clips**, plus a Stun alias for each TakeHit clip. Each has Idle, Run, NormalAttack, TakeHit and Death. Archer uses `Character/Attack.png` with `Arrow/Move.png`; Huntress uses the spear-throw `Attack3.png` with `Spear move.png`; Evil Wizard uses `Attack.png`, projectile `Moving.png` and `Explode.png`. Unused attacks are not added as skills. Available CC-0 license text for Huntress and Evil Wizard is retained alongside their art.

All source bytes remain unchanged. Sprite Editor slices full native cells (100×100 Archer, 150×150 Huntress, 140×140 Wizard), at 12 FPS / 25 PPU with fixed ground pivots. Final textures are RGBA32/uncompressed. Texture setup runs outside the atlas folder before moving prepared assets into it. Portraits are crops of the first Idle frame.

Normal attacks use a configurable `weapon` spawn point shared by server collision and replay. Archer releases at 250 ms (forward 100, height 100), Huntress at 333 ms (120, 140), Wizard at 750 ms (150, 150). Projectiles aim down to height 80 to intersect shorter Heroes while retaining the authored weapon origin. Each hits one enemy once; Wizard's explosion is visual rather than area damage. Damage currently uses the shared damage/defense formula for all three.

Wizard's native moving projectile points left. Its clip authors `SpriteRenderer.m_FlipX`; `ReplaySprite` now respects the sampled flip and resets it between clips, so left-authored art and existing right-authored art both follow recorded facing. Server trajectories/damage and replay schema/rules are unchanged.

Importer: `Unity/AgentScripts/SetupRangedMonsters.cs`; validation: `Unity/AgentScripts/VerifyRangedMonsters.cs` (**272 checks**). The full Monster suite passes **47,249 assertions / 18 real fights**, including ranged hits against all three illustrated Heroes and duplicate Archers. Sample: `Artifacts/RangedMonsterChecks/ranged-monsters.arena.gz`. Restore: `Artifacts/RangedMonstersBefore/20261118-085328/`. Current content is available in Editor Sandbox; previous standalone executables have not been rebuilt for these additions.

### Guardian

Select **Guardian / Front (guardian)** in **Monster to add**, then **Add Monster**, or change an existing slot to Guardian. Use HP override 0 to test its configured HP.

Imported unchanged PNG strips from `E:/hoc/TinIT/TinUnity/MyProject/Zatod Legend/Assets/Graphics/Enemies/Guardian/`: Idle → KnightIdle (15 frames), Run → KnightRun (8), NormalAttack → KnightAttack (22), Death → KnightDeath (15), TakeHit → KnightShield (7). **67 source frames / 5 clips**, with Stun referencing the same clip as TakeHit. The shared combat view displays this reaction during control effects; ordinary damage does not introduce a new flinch mechanic or shield damage reduction.

Slicing uses the actual strip cells: Idle 64×64, Attack 144×64, other states 96×64. The source Attack `.meta` uses 140-wide slices; it is not copied. The imported 144-wide cells preserve all 22 frames without cumulative clipping. All clips use provisional 12 FPS / 25 PPU, a shared ground at source Y=20, and only Idle/Run loop. The portrait is a Sprite Editor crop of the first Idle frame.

Guardian moves at 900, attacks at interval 44 ticks (2.2 seconds), with one damage application after a 420 ms windup. Its full 22-frame sword sequence is visual; it does not apply a separate hit on every swing. These timings and stats can be balanced in Monsters/Skills.

Importer: `Unity/AgentScripts/SetupGuardian.cs`; validation: `Unity/AgentScripts/VerifyGuardian.cs` (**130 checks**). The Monster suite now passes **28,578 assertions / 12 real fights**, including duplicate Guardians. Sample replay: `Artifacts/GuardianChecks/guardian.arena.gz`; restore copy: `Artifacts/GuardianBefore/20261118-083158/`. The previously open replay was preserved rather than replaced. Unity workflow: `sprite-editor` / `references/templates.md` and `unity-cli` / `integration-advanced.md`.

## Balance and data

Use **Zatod > Monsters > Monster Balance**, then the **Monsters** tab. This uses the existing balance editor while preserving an already-open unsaved Hero draft. `Monsters.txt` is the fifth JSON `.txt` table beside Stats/Items/Skills/Heroes; normal attacks live in Skills. Save with a new shared ConfigVersion, then **Reload saved config** in Sandbox and generate a fresh fight. Older four-table datasets load with an empty Monster catalog.

`MonsterDefinition` is shared config. `MonsterBattleData` is a detached per-spawn snapshot with a unique battle instance ID, HP, energy and skills. It shares `CombatantBattleData`/`BattleSkillData` with `HeroBattleData`; HeroData and HeroDesk remain Hero-only. `MonsterBattleFactory` is usable by future encounter/server code without Sandbox dependencies.

Rules `combat-prototype-7` add Monster identity and an explicit Hero/Monster loadout kind. This kind is required because Unity serializes inline class fields as values rather than reliably preserving null payloads. Archive decoding normalizes the unused payload; older records default to Hero. Existing archives remain immutable, and playback does not rerun combat.

The first projectile step also checks the segment between the caster and authored muzzle/tip, so adjacent enemies are not missed behind the muzzle. Descending projectiles still descend when horizontal travel is zero. Both facings are covered by tests.

## Artwork

Unchanged sheets/texture bytes were imported from the user's `ExportedProject/SpriteExport`: FighterGoblin, FemaleGoblin, SkeletonKnight and native SmalFireball. There are **182 sprite keys across 18 clips**. Sprite Editor slicing preserves per-key timing and adjusts pivots to a shared foot plane, at 25 PPU with point filtering. Every monster has Idle, Run, NormalAttack, Stun/TakeHit and Death; the mage also has separate cast/flight/contact clips. Source files were not edited.

## Checks and restore

- `scripts/Run-MonsterChecks.ps1`: live fights, repeated instances, normal attacks without implicit ultimates, melee/projectiles, death/retarget, detached data, replay ticks and close descending shots in both directions.
- `Unity/AgentScripts/VerifyMonstersRuntime.cs`: real UI add/remove/type/count controls, one Hero, Monster Balance, animation/projectile meshes, HP override, live single-skill enemies, approach into range, Unity gzip/JSON, backward seek and unchanged HeroDesk.
- Hero regression harnesses explicitly isolate opponents through `HeroCombatSandbox.Prepare`; the user Sandbox has no passive-opponent mode.
- Replay: `Artifacts/MonsterChecks/live-monsters.arena.gz`.
- Restore copy: `Artifacts/MonstersBefore/20261117-201638/`, including the previously open `current-preview.arena.gz`.

An older unsaved Hero Balance draft was preserved. Its stale save is rejected by the existing concurrent-change check; preserve any edits before reloading it from the newer files.
