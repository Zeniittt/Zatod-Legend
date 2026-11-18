# Prototype verification — 2026-11-18

Environment: Unity 6000.6.2f1, URP 17.6.0, Mirror v96.11.5, Windows x64.

## Lilina and Chapter 1 Campaign — rules 10

- Imported Lilina from approved SalamanderWitch HeroKit v3: **421 unchanged PNG frames / 26 clips**. All four skills, configurable lowest-health sequence targeting and delayed residual Burn were checked before Campaign work resumed. Original body layers are retained separately from the source chat's reconstructed dragon/Flamer sketch layers; see [lilina.md](lilina.md).
- `VerifyLilina.cs`: **4,842 checks pass**, source hashes, timing, gates, six dragon pulses, five-target lightning pierce, two seeking orbs, four delayed Burn ticks and every replay tick. Final `VerifyLilinaRuntime.cs`: **42 checks pass**, including the new Campaign overlay hiding correctly when opening Sandbox, actual skill buttons/body/projectile/effect meshes, no account writes and no Mirror client/host startup.
- Chapter 1 contains five configured encounters, each with five live Monsters. The Campaign development roster owns exactly the five illustrated Heroes. UI covers map, enemy preview, selection of 1–5 Heroes, battle, result, replay, next stage, Back and progress. Scene components were installed with the Editor API; UI uses the existing uGUI framework.
- `VerifyCampaign.cs`: **3,074 checks / 15 real 5v5 fights pass**. All stages clear with the five White starters at seeds 1/55/127. Includes backward seeks, gzip round trips, detached account/config data, party subsets, duplicate/foreign Hero rejection, server-side stage locks, loss behavior and progress rebuilt after restart.
- `VerifyCampaignRuntime.cs`: **139 checks pass** through actual uGUI pointer/button callbacks. Covers raycast reachability, nonempty rendered map/node meshes, all five enemy portraits, empty-party gating, all five battles, results/replay/next/Back, disconnect/reconnect and progress recovery. Frame-count proof advances 157→163; client server remains inactive. Corrected missing CanvasRenderer dependencies discovered by this check. Current runtime Console: **zero errors / zero warnings**.
- Final Windows Campaign smoke: `Artifacts/CampaignSmoke/ea625e1db1bc4f13b0458de7c8f8be52/result.json`. Separate server/client processes complete all five stages, idempotent retries leave exactly five archives, restart restores all clears, and every archive hash remains unchanged. The server commits results before sending replay/progress. No player-host mode was added.
- Ordinary Arena regression with Lilina also passes after the final rebuild: `Artifacts/NetworkSmoke/872d7c158b30444f9e51ce0d35ce59df/result.json`, battle `d11dcafa2fe44998b58560f4dafedacb`, **8,009 bytes**, hash `E78C55D81017A479647DA56352CAF240C055C389BEBCDA7E08D80472F7D8815A`. Covers playback/reload/retry/restart and client server inactive.
- Existing regressions pass: **347,507 combat**, **112 Hero data**, **47,249 Monster** assertions. Blooesperod rules-9 regression passed earlier in this pass: **5,091 / 12 scenarios**. Both `Builds/Windows` and `Builds/LeenaldBattle` were rebuilt with rules 10 and Campaign. Git whitespace checking reports only three Unity-generated blank `m_Name:` fields in the serialized scene; source checks have no whitespace errors.
- Restore points: `Artifacts/LilinaBefore/20261118-110356/`, `Artifacts/CampaignBefore/20261118-105757/`. Prototype boundaries: one server-owned demo account, no rewards/stamina/production authentication; existing server replays preserved. Details and usage: [campaign.md](campaign.md). Guidance used: `sprite-editor` / `references/templates.md`, `ui` / `ui-ugui`, `build-multiplayer-game`, `unity-cli` / `integration-advanced.md` / `playmode-verification-loop.md`.

## Blooesperod Skill2 return — rules 9

- Completing Huyết Trảo now teleports the caster back to its cast-start X/Y and restores its original facing, at the end of the 3.44-second sequence (69 ticks). Normal combat then resumes. Added the generic `SkillCastSequence.ReturnToStartOnEnd` flag, enabled only on Blooesperod Skill2; the saved origin is per cast rather than world zero. Interruption/death still cancels unfinished actions and does not force a return while controlled.
- The server emits a Move state for the return; playback simply applies it. Rules advance to 9 and config version adds `-skill2-return-1`. Old records keep their recorded outcomes and positions; a newly generated fight is required to see the change.
- `Run-BlooesperodChecks.ps1`: **5,091 assertions / 12 scenarios pass**, including a mirrored cast from X=350/Y=-147, exact finish timing, original facing, interruption, last-enemy kill and every forward/backward replay tick. `VerifyBlooesperodRuntime.cs`: **1,105 checks pass**, including the returned caster mesh/state, seeking around the return tick and the victory outro. The 347,507 combat regression assertions also pass. Final runtime Console has zero errors/warnings; `git diff --check` passes.
- If the throw kills the final opponent before the sequence ends, the result and combat-end tick remain fixed. Only the remaining return movement is recorded in the outro; no more AI, hits or effects execute. Evidence: `Artifacts/BlooesperodChecks/skill2-return-victory.arena.gz`.
- Sample: `Artifacts/BlooesperodChecks/skill2-return.arena.gz`. Restore: `Artifacts/BlooesperodReturnBefore/20261118-102913/`. Unity workflow: `unity-cli` / `integration-advanced.md` / `playmode-verification-loop.md`.
- Windows and LeenaldBattle executables rebuilt with rules 9 and the return config.

## Blooesperod from approved NightLord v3 — rules 8

- Imported the exported NightLord HeroKit v3 as **Blooesperod**, a front melee Hero in the 22-Hero catalog/roster/formation. **344 original PNG frames / 19 unique clips** retain variable key timing, reversed death phases and the held shadow; an extra manifest alias uses the soul flight clip for return visuals. All imported source hashes match. Original source workspace was read/copied only.
- Configured the final kit: stationary two-hit basics, five seeking/lifestealing souls, teleport to the farthest enemy then grab/pull/throw, stationary lowest-current-HP/behind sweep, and Purple on-death revival. Prototype revival is once per match, exactly **40 ticks from HP zero**, restoring **50% max HP** plus **10% lifesteal / 10 seconds**. Team victory waits for pending revivals, including both teams waiting. The zero-HP shadow cannot be targeted; the resurrected Hero is vulnerable during stand-up.
- Shared configurable combat additions have no Hero-ID special case. Seeking projectiles record their per-tick path; renderer samples those saved points. A sequence's launch and movement on the same tick collapse to one final path sample. Additive state, enum and path fields retain schema 1; rules advance to 8. An existing rules-7 ranged-Monster archive still decodes without changing bytes.
- `Run-BlooesperodChecks.ps1`: **4,294 assertions / 10 scenarios pass**, including rank gates, two hit timings, farthest-only grab/control/interruption, raw HP rather than HP ratio, behind targets, five soul victims, a retreating target, healing/expiry, exact revive timing, second terminal death, simultaneous pending teams and every forward/backward replay tick.
- `VerifyBlooesperodRuntime.cs`: **1,097 checks pass** for source image hashes, frame keys/PPU/compression, roster ownership, actual Sandbox buttons, body/slash/soul/return/throw meshes, shadow alpha/state while HP=0, 50% HP at rise start, Unity gzip/JSON state/path preservation and backward seek. No Mirror host/client started and no HeroDesk/config mutation. Frame proof advances 868→875. Artifacts: `Artifacts/BlooesperodChecks/all-skills.arena.gz` and `resurrection.arena.gz`.
- Regressions pass: **347,507 combat**, **112 Hero data**, **47,249 Monster / 18 fights**, **18,232 Enchantx** and **4,731 Kavern** checks. Source restore point: `Artifacts/BlooesperodBefore/20261118-094836/`.
- Windows and LeenaldBattle executables rebuilt with rules 8. Native Windows test selecting **Blooesperod White** passes separate dedicated server/client creation, playback, reload, idempotent retry and persisted replay after server restart. Evidence: `Artifacts/NetworkSmoke/b2f509e6076c4e799b7d0fdeb8646cb8/result.json`, battle `589e06a02c624986abad7f55abdba2d6`, 9,686 bytes, SHA-256 `E0658E7AD9FF75A3BB5EB9196EFD128951A5AD2CA3D1C05AC8E0567AE99ECAFC`. Purple revival is verified in the shared combat core/Editor; the server demo profile remains White.
- Workflow references: `sprite-editor` / capability-check templates, `unity-cli` / `integration-advanced.md` / `playmode-verification-loop.md`, and `ui-uitk`. Exact values and usage are in [blooesperod.md](blooesperod.md).

## Archer, Huntress and Evil Wizard Monsters — 2026-11-18

- Added three normal-attack-only ranged monsters: Archer arrows (rear), Huntress throwing `Attack3` spears (middle), Evil Wizard spell/explosion (rear). Imported **140 unchanged frames / 19 unique clips**, at 12 FPS / 25 PPU with foot pivots and cropped portraits; preserved supplied license text. Configured named weapon points, release timing and descending aim to hit the shorter Leenald hurtbox as well as taller Heroes.
- A native flip curve corrects the Wizard's left-authored projectile. Shared `ReplaySprite` respects sampled `SpriteRenderer.flipX`, resetting before each sample to prevent orientation leaking into later clips. Body art, other projectile facings and server simulation rules remain unchanged.
- `Run-MonsterChecks.ps1`: **47,249 assertions / 18 real fights pass**, covering all seven definitions, new ranged hits against Leenald/Kavern/Enchantx, repeated Archers, detached snapshots, death/retarget and every forward/backward replay tick.
- `VerifyRangedMonsters.cs`: **272 checks pass** for source hashes, source resolution, RGBA32 import, frame times, loop settings, prefab/portrait, actual Sandbox buttons, Run/Attack meshes, three visible projectile textures, spawn points, real damage, Wizard explosion, both flight facings, clip-flip reset, Unity gzip/JSON and backward seek. Play frame proof advances 4045→4051. No Mirror host/client started; HeroDesk/config were unchanged. Evidence: `Artifacts/RangedMonsterChecks/ranged-monsters.arena.gz`.
- Restore copy: `Artifacts/RangedMonstersBefore/20261118-085328/`. Config version advances by `-ranged-monsters-1`; rules remain 7. Windows executables were not rebuilt for these additions. Workflow references: `sprite-editor`, `references/templates.md`, `unity-cli`, `integration-advanced.md`, `playmode-verification-loop.md`.

## Guardian Monster — 2026-11-18

- Added front melee Guardian with five source strips, **67 unchanged sprite frames / 5 clips**, native 144-pixel Attack cells and shared foot pivots. KnightShield is TakeHit, also aliased as Stun for the existing control playback. Its sword animation currently applies one normal-attack damage event; no shield reduction or ordinary-hit flinch mechanic was added.
- `VerifyGuardian.cs`: **130 checks pass** for source hashes, frames/PPU/pivots/loop timing, prefab/controller/portrait, Sandbox availability, runtime sprite sampling in both facings, duplicate Guardian identities, movement/damage/death/control, Unity archive round trip, backward seek and unchanged config. The existing user replay was preserved. Evidence: `Artifacts/GuardianChecks/guardian.arena.gz`.
- Console has zero errors. Initial live atlas imports emitted 45 compression warnings before importer settings were applied and one atlas-request warning; no new warning appeared on the second validation run. All five final source textures are verified RGBA32/uncompressed at original dimensions. Existing Console entries were retained.
- `Run-MonsterChecks.ps1`: **28,578 assertions / 12 real fights pass**, now including duplicate Guardians against all three illustrated Heroes. Config version advances by `-guardian-1`; no combat rule change. Restore: `Artifacts/GuardianBefore/20261118-083158/`. Content is available in Editor Sandbox; Windows executables from the prior Monster pass were not rebuilt for this content-only addition.

## Live Monsters and Combat Sandbox — rules 7

- Added Fighter Goblin, Skeleton Knight and Goblin Mage, using original exported artwork: **182 sprite keys / 18 clips**, grounded pivots, native fireball phases, variable key timing and 25 PPU. All starters have normal attacks only; `SkillIds` reserves future monster skills.
- Sandbox retains **one Hero**, with 1–5 selectable opponents, duplicate types, add/remove controls and HP override (0 = config). Monsters move, attack, take control effects, die and retarget in every mode. Single-skill mode suppresses Hero basics only and allows approaching into cast range. HeroDesk and saved config remain unchanged.
- Detached `MonsterBattleData` shares combat data with `HeroBattleData`. Recorded loadouts carry an explicit kind and normalize the unused payload after Unity JSON decoding. Schema remains 1. Close projectile launch sweeps and zero-distance descending projectiles are covered in both facings.
- Pure checks pass: **20,783 Monster assertions / 9 real fights**, **347,507 combat**, **112 Hero data**. Hero regression harnesses pass: **170 Sandbox**, **4,731 Kavern**, **18,232 Enchantx**, **181 Leenald projectile/art**, **16 origin/camera**. Isolated regression targets are configured inside the harnesses; user Sandbox opponents stay active.
- Fresh Editor runtime on 2026-11-18: **256 checks pass**, including actual UI controls, Monster Balance, repeated monsters, Run/NormalAttack/Death meshes, native mage projectile, live single-skill enemies, melee skill approach, Unity gzip/JSON inherited data and backward seeking. Play frames advanced from 664 to 670 during the frame-progress check. Sample replay: `Artifacts/MonsterChecks/live-monsters.arena.gz`.
- Final runtime Console reports **zero errors and warnings**. Build history contains two nonfatal deprecation warnings: existing `FindFirstObjectByType` usage and the bundled TMP shader debug-symbol pragma. Left the sample paused at 3.2 seconds with Kavern and three live monsters; restored Editor auto-tick to disabled. `git diff --check` passes.
- Windows and LeenaldBattle builds updated. Native Windows dedicated server/client check with **Kavern White** passes create, playback, reload, idempotent retry and restart persistence. Evidence: `Artifacts/NetworkSmoke/fdccaa2aa9024557afbe438356cb9355/result.json`, battle `9109fa9727e54b67906c8798c1c86cda`, **8,068 bytes**, SHA-256 `83A179C67E1A087963C0A9CB7247CC43CEA9FFF35D01DEEFDF5366A67A7324D6`. Monster encounter selection is currently Editor Sandbox; native smoke verifies the shared combat/serialization regression, not a campaign or online Monster selector.
- Source restore copy: `Artifacts/MonstersBefore/20261117-201638/`, including the previous open replay. An unsaved older Hero Balance draft was retained; the separate Monster Balance window avoids replacing it. See [monsters.md](monsters.md) for usage and data files.
- Unity workflow references used: `using-unity`, `unity-cli` with `integration-advanced.md`, `projects-templates.md` and `playmode-verification-loop.md`, plus `sprite-editor` capability templates and `ui-uitk`.

## Enchantx opening/repeat skill sequences — rules 6

- Imported **339 byte-identical PNGs and 27 clips** from CentaurLady_HeroKit v4, retaining variable key times, Idle 1–18, native FlameWings/WindStorm and shortened landing. Added Enchantx as the third illustrated Hero in the 21-Hero roster/formation. Art uses shared 25 PPU and a stable foot anchor; placeholder portrait is a Sprite Editor crop of the unchanged Idle frame.
- Generic sequences provide opening/repeat variants, multiple arrow releases, fixed ground pulses, delayed effects after release, bounded skill movement and recorded burst rings. Skill3 starts at the first combat tick when unlocked; the opening consumes its shared cooldown, and repeat casts stay still. The +20% / 8-second outgoing-damage buff reaches living allies and refreshes without stacking; base Hero stats/config remain unchanged. All provisional values are in split JSON config.
- `VerifyEnchantx.cs`: **18,232 checks pass** for image hashes/settings/key timing, all five actions, rank gates, two cast variants, actual buffed/expired damage, refresh, radius boundaries, interrupted casts, released bird after caster death, three-shot retargeting, detached snapshots and every replay tick after gzip/JSON round trip.
- `VerifyEnchantxRuntime.cs`: **74 checks pass** through actual UI buttons, including test-all, variable-duration body frames, anchored wind arrow, target tornado, rain, three projectiles, entry motion, stationary repeat, all bird phases within the battlefield, explosion ring, pause/expiry/backward seek, no Mirror startup and unchanged owned HeroDesk. Editor frame count was verified advancing.
- Regression checks pass: **347,507 pure combat**, **112 Hero data**, **4,731 Kavern asset/core**, **46 Kavern runtime**, **170 Sandbox core**, **36 Sandbox UI**, **181 Leenald projectile/art**, **16 Leenald origin/camera**. The new cast-count control is explicitly reset in single-cast regression harnesses.
- Updated Windows and LeenaldBattle executables. Native Windows dedicated-server/client check now accepts a generic `-HeroId`; **Enchantx White** passes create/playback/reload/idempotent retry and restart persistence with identical archive hash. Evidence: `Artifacts/NetworkSmoke/69029cc055e84347beb79f31e10b2ca3/result.json`, battle `5eeb2045ab414fc8852b4067027eefcb`, 7,604 bytes. Full unlocked Skill3 behavior is verified in the shared core and Editor runtime; the server-owned demo profile remains White.
- An existing rules-5 archive still decodes and retains SHA-256 `e8214e26324a47a69d824cc9fe2924c9b4a8cdae4344ee09f42bac25684ac8cc`. Schema remains 1; existing archives are not re-simulated or rewritten.
- Restore copy: `Artifacts/EnchantxBefore/20261117-185937/`. Workflow references used: `using-unity`, `unity-cli` with `integration-advanced.md` / `playmode-verification-loop.md`, and `sprite-editor` with its capability-check templates. See [enchantx.md](enchantx.md) for exact current behavior and how to compare both Skill3 casts.

## Kavern and selected-target skill effects — rules 5

- Imported 197 original PNG frames into 21 clips at 12 FPS / 25 PPU, preserving pixel bytes and supplied icon. Added Kavern as a rear ranged Hero in the 20-Hero catalog, owned roster and formation. Normal attack, poison arrow, beam, twin ArrowShower and air-arrow stun are configured in the split JSON files; recipes and balance values remain provisional.
- Shared combat now supports separate projectile flight/contact visuals, delayed effects on locked target IDs, caster visual cues, a forward beam, descending projectile height and poison ticks. Skill3 chooses at most two nearest enemies and creates one grounded visual per selected victim; it never splashes the third enemy or replaces a dead selected victim. Skill4 records a 20-tick / one-second Stun on its hit enemy.
- `VerifyKavern.cs`: **4,731 checks pass**, including original-art hashes, import settings/frame order, unlocked ranks, all five actions, four poison ticks, one-second stun, 1/2/3/5-target ArrowShower boundaries at multiple distances, victim death during windup, beam direction, deterministic events/VFX and every backward replay tick after gzip/JSON round trip.
- `VerifyKavernRuntime.cs`: **46 checks pass** through actual Sandbox UI button events: all four skills, visible/nonculled effect meshes, exactly two showers at target feet, flight hidden at impact, elevated air-attack body, paused animation, effect expiry and backward seek. Player frame-count change was verified. Sandbox does not start Mirror or mutate owned HeroDesk.
- Regressions pass: **167 Sandbox core**, **36 Sandbox UI**, **181 Leenald projectile/art**, **16 Leenald origin/camera**, **347,507 pure combat**, **112 Hero data**. No current Console errors/warnings after the runtime checks.
- Windows and LeenaldBattle builds updated. Native Windows dedicated server/client regression passes create, reload, idempotent retry and replay persistence across server restart: `Artifacts/NetworkSmoke/a7e48fc7bd43458e8c588016e3a6fde4/result.json`, 8,239-byte archive. This native smoke selects Leenald; Kavern's new skills are verified in the same combat core and Editor runtime, not a live two-player match.
- Source restore copy: `Artifacts/KavernBefore/20261117-161132/`. Schema remains 1 with additive fields; existing server replay archives were not rewritten. See [kavern.md](kavern.md) for exact prototype behavior and test instructions.

## Applied projectile-origin system and Skill4 camera fix — rules 4

- Generic named Hero spawn points and per-skill offsets resolve on the server and native animation preview. Snapshots deep-copy the points; records include origin, height, collision offset and art scale. Source config contains Leenald's grounded `feet` point and source-derived Skill2 collision offset, with no Leenald branch in runtime code. Editor balance reflection exposes the new config fields.
- Skill2 art uses the authored ground pivot/trailing edge rather than changing opaque image centers. Original-art alignment passes in both facings: the eruption begins one source pixel past the planted foot, with zero vertical gap. Close-hit effect lifetime, pause and backward seek still pass.
- Skill4 caster world X stays 0; fixed record framing keeps caster screen X at -85.5 before/after impact, fixing the old -49.5 to -85.5 camera-induced slide. Only enemy IDs 101/102 move in the test. Backward seeking uses identical framing.
- Final checks pass: **16 targeted origin/camera**, **181 original-art/projectile**, **36 Sandbox UI**, **164 Sandbox core**, **347,507 combat**, **112 Hero**. Generic server tests use another Hero identity, mirrored muzzle offsets, config freeze, earlier contact when origin shifts and a high projectile missing a lower hurtbox.
- Windows builds updated in `Builds/LeenaldBattle` and `Builds/Windows`. Native network test passes create/reload/idempotent retry/server restart with unchanged replay bytes: `Artifacts/NetworkSmoke/78b87f61549b4576969ebb86350c7c83/result.json`, 7,850-byte archive. Schema remains 1 with additive fields; existing archives are not re-simulated or rewritten.
- Restore copy: `Artifacts/SkillOriginBefore/20261117-115127/`. New calculations require a newly generated fight. Camera and art presentation improvements also apply when viewing old records, without changing their outcomes.

## Original Leenald artwork and projectile visibility — 2026-11-17

- Replaced all 137 body/projectile PNGs with unchanged bytes from `monk_original_selected`: 288×128 canvas, common pivot (144,7), 25 PPU. Existing icon PNG/metadata and all sprite GUID/local file IDs remain unchanged; eleven clip references, timing and controls are retained. Hero/skill balance data was not edited.
- Reproduced both missing-projectile reports by inspecting replay Images/meshes: records existed with valid sprites, but nearby hits ended visibility after one tick (0.05 s). Presentation now completes the projectile clip at its recorded impact point without changing the hit/status tick. Opaque bounds remove double horizontal movement, and replay draw size respects source PPU.
- **780 animation/import checks pass**, including source hashes, anchor/order/timing, animation playback, prefab spawning and cleanup. **181 regression checks pass** for icon equality, stable IDs, and both projectiles after impact: nonculled canvas geometry, advanced frame, draw size, pause, expiry and backward seek. **36 Sandbox UI checks pass**. No new Console errors since the saved cursor.
- Restore copy: `Artifacts/LeenaldOriginalBefore/20261117-105852/`. Reimport via `ReimportLeenaldOriginal.cs`; the protected initial x4 setup script is historical. No standalone executable was rebuilt for this Editor/asset fix.

## Generic Hero Combat Sandbox

- Editor menu **Zatod > Heroes > Combat Sandbox** loads all Hero definitions, supports selected/highest temporary rank, auto/basic/single-skill tests, starting HP/energy, stationary target count/spacing/distance/HP, fixed seed and short duration. It automatically enters Play Mode and reuses Arena playback with a closer sandbox camera. No Mirror startup, account mutation or server archive write.
- Single-skill cast budgets and disabled-basic controls are trusted simulation inputs with defaults preserving ordinary Arena. Control metadata is additive and distinguishes Stun/KnockUp/Knockback; older records fall back to the legacy stun label. HP healing appears in the feed. Pause and ±1-tick controls support frame/contact inspection.
- **164 factory/effect checks** across all 19 Heroes and all four Leenald skills pass. **36 UI checks** dispatch actual UI Toolkit button events for each skill, stepping, rank gates, highest-rank test and unchanged owned data. Shared-core regressions: **347,493 combat / 106 Hero checks** pass.
- A ScriptableObject constructor lifecycle error found during repeated Play/Stop was fixed by deferring pending-session recovery through Editor initialization callbacks. Automatic entry from Edit Mode and window reconstruction after domain reload are verified.
- Usage, limitations and evidence: [combat-sandbox.md](combat-sandbox.md). No standalone build is required for this Editor tool.

## Leenald in Arena — combat-prototype-3

- Formation now sends selected owned IDs; the dedicated server validates them against its development profile and derives stats/unlocked skills from server config. Tested one-Hero and five-Hero squads, invalid ownership and duplicate rejection. The defense remains a prototype squad; no production authentication was added.
- White Leenald uses basic attacks and projectile Stun. Promoted Leenald additionally exercises projectile KnockUp, self Heal and radius-100 Knockback. Casts, contact and status changes resolve at 20 Hz in pure C#, never through animation callbacks. Passive/StatBonus triggers remain deferred.
- Replay schema stays 1 with additive fields and rules version 3: frozen loadouts, animation timing, controls, projectile outcomes and a 30-tick terminal animation tail. Archived rules-1/2 records were decoded and sought to the end successfully; their stored bytes were not rewritten.
- **1,585 Leenald battle checks** pass: server selection, White gating, promotion effects, projectile-hit timing, detached skill config, every-tick seek including the Death tail, and exact sprite sampling after backward seek. Existing **347,493 combat** and **106 Hero** assertions passed during integration.
- **9 runtime checks** through the actual Formation Battle callback passed against a separate server: five selected IDs, front slot, native sprite frame, pause/backward seek and a projectile hit. Editor screenshot: `Artifacts/leenald-battle.png`.
- Native Windows client visibly entered Arena with selected Leenald, ran into range, attacked and cast Earth Seal; the event feed recorded the enemy stun. Other fighters retain role-symbol placeholders. A final-death animation truncation observed in this pass was fixed with the recorded tail.
- Separate Windows server/client smoke tests pass creation, playback, reload, idempotent retry and persisted archive hash after server restart, both for selected Leenald and the original sample-squad path. Final post-tail build: `Artifacts/NetworkSmoke/472f76d15db842a59e3d05295a65c1c6/result.json` (7,596-byte archive, unchanged through restart). Final nine UI checks passed again against the rebuilt server. The native final replay reached 12.95s with Death completed and Leenald hidden, then was sought backward to 1.99s for user review; the client remains paused there with a separate server on TCP 7777. Final Editor runtime Console has zero errors/warnings; standalone startup retains the known unused URP post-processing notices.
- Build: `Builds/LeenaldBattle/ZatodArena.exe`. Server helper accepts `-BuildFolder LeenaldBattle`; server and client are separate processes. Arena values and hit radius remain center-distance logic, independent of sprite bounds. Current balance and camera/art scale are provisional.

## Leenald first Hero assets and skill config

- Imported **137 unchanged PNG frames**, nine character clips and two projectile clips, at 12 FPS. Numeric ordering is verified for every frame. Sprite Editor capability checks run before metadata edits; every cropped rect retains source anchor `(576, 28)` and PPU 100. Source notes/projectile bounds retained. Death's transparent last frame is preserved.
- Created character/projectile prefabs, native Animator controllers, icon, JSON animation manifest and built-in SpriteAtlas V2 with point filtering/no rotation and a lossless Standalone override. Sprite packing readback: `SpriteAtlasV2`.
- Leenald is front/melee at White in the preview profile: HP 4800, Damage 220, Defense 60, range 100. Normal attack, nearest-target projectile stun, projectile knock-up, automatic self heal and radius-100 knockback are configured in the split tables. Runtime skill snapshots now preserve both normal attack and special-skill projectile/effect parameters independently of config.
- **106 core assertions pass**, including new delivery/control validation and deep-copy checks.
- **779 Leenald assertions pass**: all source hashes, key order/count/timing, pivot invariance, correct folders/loops/hold states, rank unlocks/config, normal attack snapshot, visual spawn alignment/cancellation/facing/lifetime, and preview camera/RenderTexture cleanup.
- **247 roster/detail assertions pass** with 19 Heroes and the real icon/model available. Final runtime Console before build has zero errors/warnings.
- Screenshot: `Artifacts/leenald-idle.png`. Full mapping, values, review controls and limitations: [leenald.md](leenald.md).
- Windows build at `Builds/LeenaldPreview/ZatodArena.exe` is **visually verified after resuming on 2026-11-16**. After the user approved Computer Use, the running build was selected by its returned app/window, Leenald's first roster row was clicked, and detail was observed twice: real portrait/model, changing Idle pose, White rank and HP 4800/Damage 220/Defense 60/range 100 all displayed correctly after packed-atlas loading. Preview remains open for review. No reimport or balance change was needed.
- The standalone log contains no gameplay exception. It retains the known URP template notices about stripped, unused post-processing shaders; those did not prevent the sprite/model preview from rendering.

This is asset/animation setup and effect configuration. Visual projectiles are instantiated in preview; the old Arena engine does not execute the new crowd-control/heal definitions. No new replay schema or simulation rules were introduced.

## Hero roster and Base detail UI

- Two-column owned Hero roster, rank-colored portraits, names, level/stars and six current-rank requirement cells. Terminal-rank cells stay empty. Only All/Front/Middle/Rear filters; currency counters are preview values.
- Base detail reads owned level/EXP/stars and calculated stats, supports stat scrolling and closes back to the same list/filter/scroll. Skill/Skin/Awaken are disabled; the equipment/Quick Equip/model area stays empty. Soul is 0 unless a provider is attached; power is an explicit preview number.
- **237 UI assertions pass** in the final run after close-button layering: owned row/config references, six gear cells, filters, scrolling/last-row reachability and raycasts, opening the matching Hero, exact calculated values, reserved area/tabs, readonly data, supplied soul count and changed progress, and shared-profile navigation to/from formation.
- Existing navigation/replay regression passes: **127 formation assertions** (including the new HEROES navigation frame) and **35 Arena UI assertions**. Dedicated-server battle IDs: `23b1e06a8ee64da1aa5ca050dffafe5f` and `0962f55030424adc8f3a513d5d2958d9`. Client never hosts a server.
- Final UI Console has zero errors/warnings. No hero balance values, core combat rules or replay schema changes in this phase.
- Windows build succeeds at `Builds/HeroPreview/ZatodArena.exe`; the interactive client is launched for review. It uses its own output folder, leaving the prior client and dedicated server builds intact.
- Screenshots: `Artifacts/hero-roster.png`, `Artifacts/hero-detail.png`. Scene updated through Editor APIs with a backup under `Artifacts/FormationBefore/`.

## Formation selection UI

- Added uGUI formation screen matching the reference layout: scrolling six-column Hero grid, All/Front/Middle/Rear filters, five selected slots, extensible left tabs with one current roster tab, reserved empty top/right panels, deferred Back, and Battle transition. No attribute filters or preset controls.
- Eighteen sample Hero definitions initialize a local HeroDesk for this UI. Portraits are existing code-native role glyphs; no final character art or production ownership/account service is implied. Formation stores owned instance IDs separately from Hero data and sorts front-to-back.
- **93 pure C# assertions pass**, including 17 formation ownership/filter/limit/order/rebinding cases in addition to the existing data checks.
- **126 UI assertions pass** in the final version: pointer callbacks, raycast reachability, wheel scrolling/last-row reachability, all filters, five-hero cap, deselection from slots, tab/filter preservation, serialization, separate-server Battle transition and return through the SQUAD button. Final server battle ID: `8995a731a9f84ffdbbe338033a4afaf0`.
- **35 existing Arena UI assertions pass**: challenge, playback, pause/seek/speed, render meshes and no client hosting. Core combat and replay format remain unchanged.
- Fixed the font-overflow warning by using Truncate; the dynamic LiberationSans formation font includes Vietnamese labels. Initial UI and interaction verification have zero new errors/warnings after the fix.
- Scene/config before installation backed up under `Artifacts/FormationBefore/`. Reference screenshot: `Artifacts/formation-selector.png`.
- Final Windows preview built successfully at `Builds/FormationPreview/ZatodArena.exe`, separately from the existing Windows/server build. Interactive preview launched for review; existing dedicated server remains on port 7777. Final Editor Console has zero errors/warnings after the UI run.

Battle currently opens the existing Arena prototype and asks its dedicated server for a match using its existing sample squads. Selected Hero IDs are retained and emitted through a view event, but are not yet sent as an authoritative formation command. This phase implements the requested selection UI/navigation, not the account/server squad integration.

## Split config and tabbed Hero Editor — heroes-prototype-1-split-1

- Config migrated from the combined asset to four separate JSON TextAssets: `Stats.txt`, `Items.txt`, `Skills.txt`, `Heroes.txt`. Original asset/meta backed up in `Artifacts/HeroConfigBeforeSplit/20261116-083431/` before removal through AssetDatabase.
- Stat IDs and references renamed to `damage` and `defense`, including item stats, Hero base/rank stats and passive effect references. Skill scale field is now `DamageScaleBasisPoints`. Values and Hero progress formulas preserved.
- **76 pure C# assertions pass** after the rename, including 20→33, detached battle snapshots and progression.
- **81 Unity assertions pass**: four-file loading/roundtrip, missing table/file, mismatched versions, cross-table references, stat labels, independent tab contents, draft/progression preservation while switching tabs, per-table JSON edits, save/version checks, and external edits detected before overwriting any file. Test restores all four files.
- Final compilation and Console: zero errors/warnings. Captured and visually inspected tabbed layout at `Artifacts/hero-balance-tabs.png`.
- No combat/replay/network code changed; no standalone rebuild needed for this Editor/data adjustment.

## HeroDesk foundation — heroes-prototype-1

- **76 pure C# assertions**: six-slot promotion, absorbed-item provenance and no double counting, four rank-based skill unlocks, terminal rank, multiple instances of one definition, invalid/duplicate IDs, the exact `20 → 33` balance example, grandfathered recipe changes, insertion/reordering of intermediate ranks, minimums/overflow and detached battle/skill snapshots.
- **35 Unity assertions** through `AgentScripts/VerifyHeroData.cs`: actual bundled JSON TextAsset, JsonUtility roundtrip excluding config/computed stats, 64-bit declaration fields, reference binding, recomputation after rebalance, rejected unknown schema/malformed JSON, atomic file save/load and actual UI Toolkit button/field callbacks. Verifies draft isolation, config version requirement and refusal to overwrite externally changed source. The source config is restored after testing.
- Existing combat/replay regression rerun unchanged: **347,493 assertions / 36 matches** plus focused movement scenarios pass. No Arena protocol, simulation, scene or replay schema changes in this phase.
- Final Unity compilation succeeds with zero Console errors/warnings. `Hero Balance` window captured and visually inspected; readable two-column authoring/preview layout. Source config remains `heroes-prototype-1`.

Evidence: `Artifacts/hero-balance.png`, `Artifacts/HeroDataChecks/character.json`, `Artifacts/HeroDeskPreview.json`. Reproduce core checks with `scripts/Run-HeroChecks.ps1`; Editor checks with `Unity/AgentScripts/VerifyHeroData.cs` via Pipeline.

This is data/authoring infrastructure. HeroDesk is not connected to the live Arena squads or an account repository yet. Level/star/economy/quests remain declarations; skill effects, stage modifiers and migrations are not executed. No new standalone build was needed for this Editor/data-only phase. See [hero-data.md](hero-data.md).

## Current movement upgrade — combat-prototype-2

- **347,493 core assertions** across 36 full matches plus focused scenarios: front target dies, stable reacquisition, melee chase during cooldown, in-range archer staying put, windup cancellation, locked ultimate victim, center distance excluding shallow visual depth, no overshoot/boundary jitter, friendly order/spacing, and impact range validation. Every replay tick still matches snapshot seeking.
- **49 Unity archive assertions**, including loading three real rules-version-1 archives and verifying their final outcomes after the additive state/enum upgrade.
- **35 UI assertions** through actual Connect/Challenge/Playback buttons and the timeline slider. Requires the dedicated server to return the current rules version.
- **103 formation/presentation assertions** against an actual server match: one shared affine camera transform, shallow depth without fixed lanes, attack animation leaving the logical root in place, defeated units hidden, late-fight positions, legacy replay display, and a recorded retarget/chase. In the verified match, B2 changed from A1 to A2 and moved from x=1440 to x=540 while attack cooldown was still active. The captured comparison is 8.60s versus 10.05s.
- Final Windows executable network test passes create, replay, reload, idempotent retry, server restart and identical persisted archive hash. The tested archive is 18,514 bytes. Client never starts a server.
- Unity compile succeeds and the final Editor runtime console contains zero errors and warnings. Windows binary rebuilt; dedicated server on TCP 7777 and interactive client started again for review.

Current evidence:

- `Logs/combat-movement-checks.log`
- `Artifacts/ArchiveChecks/982402e9de964c74b96c35d4a98be577/`
- `Logs/movement-ui-checks.log`
- `Logs/movement-formation-checks.log`
- `Logs/movement-network-checks.log`
- `Artifacts/NetworkSmoke/0a4f08cf2eea49648e8a87ed281420f2/result.json`
- `Artifacts/formation-before.png`, `Artifacts/formation-after.png`

The previous source was backed up under `Artifacts/CombatBefore-20261116-125118/`. No server replay archive was deleted or re-simulated. The Linux build/deployment and production-service boundaries below are unchanged.

## Initial prototype checks — combat-prototype-1

- Pure C# combat: **36 matches, 349,237 assertions**. Every tick of snapshot seeking matches sequential playback. Also checks final state, serialization round trips, repeatable server inputs, timeout draw, unknown opponent and unknown replay version.
- Unity archive checks: **19 assertions** using the actual `JsonUtility`, gzip, immutable disk files and reopening the repository. Includes corrupted archive, invalid event order, invalid snapshot offset and path traversal rejection.
- UI checks: **34 assertions** through the actual button callbacks and timeline slider. Connects to a separate dedicated process, challenges the Burst defense, pauses, seeks, moves ±5 seconds, changes speed, resumes, jumps to the end and restarts. Verifies replay state and nonempty meshes for all procedural graphics. Client never activates a server.
- Windows executable integration: actual separate headless server/client processes create a match, replay it, fetch it again, retry the same request ID without rerolling, stop/restart the server and fetch the identical persisted archive. Passed again after the executable rebuild.
- Editor Play Mode advances frames; runtime console was checked with zero errors and warnings after the UI run.
- Final GUI pass confirms live fighter counts and readable front-line health bars. All 34 UI assertions pass again after these fixes.
- The final Windows client was launched with a visible, responding game window, alongside a separate server listening on 7777/TCP (`localClient=False`). The URP 2D template emits startup shader-stripping warnings for unused post-processing shaders in the standalone client; the prototype uses overlay UI and no post-processing. No gameplay exception was observed in the client log.

Evidence on this machine:

- `Logs/combat-checks.log`
- `Artifacts/ArchiveChecks/4e923cb9202142acac93dc152526222e/`
- `Artifacts/NetworkSmoke/185bb7d8ba76445b944bbb3be95f7f0e/result.json`
- `Logs/final-network-checks.log`
- `Artifacts/arena-final.png`

The final network smoke result contains a 15,307-byte replay and confirms `dedicatedServer=true`, `clientServerActive=false`, `idempotentRetry=true`, `persistedAcrossRestart=true`.

Reproducible checks are in `scripts/Run-CombatChecks.ps1`, `scripts/Test-ArenaNetwork.ps1`, `Unity/AgentScripts/VerifyArchive.cs` and `Unity/AgentScripts/VerifyUi.cs`.

## Scope and limits

Windows client plus a separate Windows headless server have been built and exercised. The Linux Dedicated Server build entry point is provided but has not been built or deployed in this pass. No public cloud host, authentication, real leaderboard or live two-player Arena has been provisioned.

Combat now uses five illustrated Heroes and seven Monster definitions, with recorded sprite animation and effects. Campaign UI uses procedural prototype map/encounter graphics. Audio, a full game shell, reward economy and production live services remain deferred.

Unity workflow guidance used: `new-unity-project/SKILL.md`, `unity-cli/SKILL.md`, its `references/projects-templates.md`, `references/integration-advanced.md` and `references/playmode-verification-loop.md`, `unity-pipeline/SKILL.md`, and `ui` / `ui-ugui` skills. The project uses the installed Editor, a bare Universal 2D template, and no Unity Cloud link.
