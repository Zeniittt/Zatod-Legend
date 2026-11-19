# Campaign prototype — Chapter 1

Chapter 1 has five fixed encounters, each with five fighting Monsters. The parchment-style map connects clickable encounter markers; selecting one opens the enemy preview. Winning unlocks the next stage. Locked encounters can be previewed.

## Play

1. Run `scripts/Start-Server.ps1` in PowerShell. It starts a separate headless server on TCP 7777, saving replays under `ServerData` by default.
2. Play `Unity/Assets/Zatod/Scenes/ArenaPrototype.unity` or run `Builds/Windows/ZatodArena.exe`. The initial screen is the Chapter 1 map. The updated `Builds/LeenaldBattle/ZatodArena.exe` includes this content too.
3. Press **KẾT NỐI** to load existing progress. Choose **1-1 → CHỌN ĐỘI HÌNH**, select one to five Heroes, then **Battle**. Starting the first stage can also connect automatically.
4. Campaign now runs live on the dedicated server. The bottom portrait strip contains exactly the selected Hero count, with HP and energy bars. When energy is full, **click that Hero portrait to request Ultimate**. The frame lights up when ready; dead/controlled/not-ready Heroes are disabled. A queued Ultimate waits for the current action/recovery before it can cast.
5. After combat, choose **XEM LẠI**, **BẢN ĐỒ**, or **ẢI TIẾP THEO** after a win. The fifth stage completes Chapter 1.

The owned starter Heroes are Leenald, Kavern, Enchantx, Blooesperod and Lilina. The Campaign demo now promotes them to **Purple** using the normal equip/absorb/promotion flow so all four skills are available for prototype testing. `StarterHeroRankId` in `Campaigns.txt` controls this demo roster; ordinary newly created Heroes still start at White. Ultimate remains manual in live Campaign. Active Skill2–4 run automatically when their conditions and cooldowns permit. Leenald heals only while injured; Blooesperod's Skill4 triggers on death; Enchantx's unlocked Skill3 starts at battle entry. Campaign does not connect automatically at startup, allowing offline Sandbox use without a pending network request. Opening a Sandbox battle hides the Campaign overlay.

Rules-13 battles retain the original front-to-back formation and shallow alternating depths. The enemy depth pattern now matches the player pattern: the first enemy shares Leenald's upper depth; the next one is below it. Initial horizontal spacing, melee reach and the original walking order remain as in the preceding correction. Start a **new battle** to see the change; older replays retain their recorded positions/layout. Saved progress is preserved.

Map Back opens the regular Hero roster; its bottom **CAMPAIGN** button returns to the map. Formation Back returns to the map. The battle has a **BẢN ĐỒ** button too.

## Configuration

Edit JSON in `Unity/Assets/Zatod/Resources/Data/Campaigns.txt`. Chapters, stage IDs/names/descriptions, normalized map coordinates, starter Hero IDs and Monster slots are data-driven. The current UI displays Chapter 1; more chapter navigation is future work.

| Stage | Encounter | Monsters | Power multiplier |
|---|---|---|---|
| 1-1 | Bìa rừng | 2 Fighter Goblins, Goblin Mage, Archer, Huntress | 0.70 |
| 1-2 | Dấu chân lạ | Guardian, Fighter Goblin, Archer, Goblin Mage, Huntress | 0.80 |
| 1-3 | Trạm gác bỏ hoang | Skeleton Knight, Guardian, Goblin Mage, Evil Wizard, Archer | 0.90 |
| 1-4 | Đường qua thung lũng | Guardian, Skeleton Knight, Huntress, Evil Wizard, Archer | 1.00 |
| 1-5 | Pháo đài hắc ám | Guardian, Skeleton Knight, 2 Evil Wizards, Huntress | 1.15 |

`PowerBasisPoints` scales health/damage/defense in detached battle data only. Each slot gets a distinct Monster instance ID, including repeated definitions. Compositions were chosen once and stay stable between preview and battle.

## Server and replay

The client sends a request UUID, stage ID and owned Hero instance IDs. The dedicated server validates ownership, party size and stage unlocks, constructs both teams from its config, and runs at 20 ticks/second. Client portrait clicks send intent only; the server validates the battle/connection, team, living/unlocked Hero, energy and control state. Duplicate queued input cannot spend energy twice. No player hosts or simulates the authoritative match.

Live updates use one frozen initial header, followed by compressed, hashed deltas for new events/snapshots and changed projectiles/effects at up to 10 Hz. The existing chunk transport respects Telepathy's message size limit. The client plays server events and samples sprite animation; it never computes damage or spends authoritative energy locally. Timeline pause/seek/speed controls are disabled during a live battle. After completion they work normally for replay, whose Hero cards are read-only.

The server commits the complete immutable archive after the actual battle ends, before the final result/progress response. Accepted Ultimate commands and their activation/energy events are retained. Ordinary offline Arena keeps its earlier auto-Ultimate, resolve-before-playback behavior. The development `ManualUltimates` setting permits the existing automated Campaign regression path; the Campaign UI defaults to manual.

Replay metadata includes stage ID, Campaign config version and manual-input mode; loadouts preserve stats/skills. Retrying the same UUID, mode and party returns the same committed result. An in-progress frame is not accepted as a finished archive by the replay decoder.

Winning committed Campaign archives are the durable source for cleared stages. Server startup rebuilds progress from all archives in its data directory, independently of the recent-history limit. Losses/draws do not unlock stages. Keep the same directory across restarts. Use a separate development directory for fresh progress instead of deleting user archives.

This phase uses one server-owned development account, as Arena does. Authentication, per-account persistence, rewards, stamina costs, drops, stars, waves and Elite mode remain future work.

Disconnecting does not pause the dedicated simulation: the server finishes and archives it, with no further manual inputs. Active-session resume after reconnect is not implemented in this phase; reconnect and load the finished battle from history once it has completed.

## Verification

- `VerifyCampaign.cs`: **3,074 checks / 15 full 5v5 matches**, every stage clear, backward seeks, archive round trips, subset parties, invalid ownership/duplicates, server unlock gates, loss handling and restart recovery.
- `VerifyCampaignRuntime.cs`: **139 checks**, real uGUI pointer/button callbacks, raycast reachability, map/node meshes, five enemy portraits, full five-stage flow, replay/next/Back and disconnect/reconnect. Client never activates a server.
- `scripts/Test-CampaignNetwork.ps1`: separate Windows server/client processes, all five stages, immutable retries, restart, restored progress and unchanged hashes for all five archives. Uses its own temporary directory.
- `VerifyManualUltimates.cs`: **2,586 checks**, all five Heroes, no auto-cast at full energy in manual mode, input validation, exactly one Ultimate per accepted request, delta reconstruction/savings and backward seeking. Offline auto mode remains intact.
- `VerifyLiveCombatUi.cs`: **46 checks**, real pointer clicks, 1/2/5 portraits, bars/readiness, matching enemy/Leenald depth, server command/energy consumption, result/replay, read-only replay cards, legacy records, pending-click feedback and bounded live presentation delay.
- `scripts/Test-CampaignLive.ps1`: real-time dedicated combat, manual inputs, live deltas, final immutable archive and identical replay after server restart.
- [Lilina](lilina.md) was imported and tested before Campaign work resumed.

Restore copies: `Artifacts/CampaignBefore/20261118-105757/` and `Artifacts/LilinaBefore/20261118-110356/`. No user archive was removed or rerolled. Scene changes used Editor APIs. Workflow references: `ui/ui.md`, `ui-ugui/ui-ugui.md`, `unity-cli.md`, `integration-advanced.md`, `playmode-verification-loop.md`, `build-multiplayer-game.md`.
