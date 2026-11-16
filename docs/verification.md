# Prototype verification — 2026-11-16

Environment: Unity 6000.6.2f1, URP 17.6.0, Mirror v96.11.5, Windows x64.

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

Visuals are procedural role symbols for observing combat, without Hero artwork or audio. The work deliberately follows the requested minimal combat scope; character content, full game shell and production live services are deferred.

Unity workflow guidance used: `new-unity-project/SKILL.md`, `unity-cli/SKILL.md`, its `references/projects-templates.md`, `references/integration-advanced.md` and `references/playmode-verification-loop.md`, `unity-pipeline/SKILL.md`, and `ui` / `ui-ugui` skills. The project uses the installed Editor, a bare Universal 2D template, and no Unity Cloud link.
