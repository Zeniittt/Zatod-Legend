# Campaign prototype — Chapter 1

Chapter 1 has five fixed encounters, each with five fighting Monsters. The parchment-style map connects clickable encounter markers; selecting one opens the enemy preview. Winning unlocks the next stage. Locked encounters can be previewed.

## Play

1. Run `scripts/Start-Server.ps1` in PowerShell. It starts a separate headless server on TCP 7777, saving replays under `ServerData` by default.
2. Play `Unity/Assets/Zatod/Scenes/ArenaPrototype.unity` or run `Builds/Windows/ZatodArena.exe`. The initial screen is the Chapter 1 map. The updated `Builds/LeenaldBattle/ZatodArena.exe` includes this content too.
3. Press **KẾT NỐI** to load existing progress. Choose **1-1 → CHỌN ĐỘI HÌNH**, select one to five Heroes, then **Battle**. Starting the first stage can also connect automatically.
4. After combat, choose **XEM LẠI**, **BẢN ĐỒ**, or **ẢI TIẾP THEO** after a win. The fifth stage completes Chapter 1.

The owned starter Heroes are Leenald, Kavern, Enchantx, Blooesperod and Lilina, at White with normal rank unlock rules. Use Combat Sandbox / highest rank to test all four skills. Campaign does not connect automatically at startup, allowing offline Sandbox use without a pending network request. Opening a Sandbox battle hides the Campaign overlay.

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

The client sends a request UUID, stage ID and owned Hero instance IDs. The dedicated server validates ownership, party size and stage unlocks, constructs both teams from its config, runs combat, and commits the immutable replay before returning it. Hero conversion is shared with Arena. No player hosts the battle.

Replay metadata includes stage ID and Campaign config version; loadouts preserve the battle's stats/skills. Playback uses the existing events, projectiles, movement, controls and seeking. Retrying the same UUID and party returns the same committed result.

Winning committed Campaign archives are the durable source for cleared stages. Server startup rebuilds progress from all archives in its data directory, independently of the recent-history limit. Losses/draws do not unlock stages. Keep the same directory across restarts. Use a separate development directory for fresh progress instead of deleting user archives.

This phase uses one server-owned development account, as Arena does. Authentication, per-account persistence, rewards, stamina costs, drops, stars, waves and Elite mode remain future work.

## Verification

- `VerifyCampaign.cs`: **3,074 checks / 15 full 5v5 matches**, every stage clear, backward seeks, archive round trips, subset parties, invalid ownership/duplicates, server unlock gates, loss handling and restart recovery.
- `VerifyCampaignRuntime.cs`: **139 checks**, real uGUI pointer/button callbacks, raycast reachability, map/node meshes, five enemy portraits, full five-stage flow, replay/next/Back and disconnect/reconnect. Client never activates a server.
- `scripts/Test-CampaignNetwork.ps1`: separate Windows server/client processes, all five stages, immutable retries, restart, restored progress and unchanged hashes for all five archives. Uses its own temporary directory.
- [Lilina](lilina.md) was imported and tested before Campaign work resumed.

Restore copies: `Artifacts/CampaignBefore/20261118-105757/` and `Artifacts/LilinaBefore/20261118-110356/`. No user archive was removed or rerolled. Scene changes used Editor APIs. Workflow references: `ui/ui.md`, `ui-ugui/ui-ugui.md`, `unity-cli.md`, `integration-advanced.md`, `playmode-verification-loop.md`, `build-multiplayer-game.md`.
