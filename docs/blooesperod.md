# Blooesperod

Blooesperod (`blooesperod`) is a front-line melee Hero built from the approved **NightLord HeroKit v3** in the Exported Project workspace. Original body/FX PNGs are copied unchanged: **344 frames / 19 unique clips**, plus a SoulReturn alias. Source variable key timing is retained, including the reversed/shortened death fold and the held black shadow. Body art uses 25 PPU and a foot pivot of (100,19) on the original 178×97 canvas. The placeholder portrait is an Idle-frame crop.

There is no battle-start Skill3 or initial lifesteal buff. The Hero moves into combat using the normal movement system. White unlocks Ultimate; Green adds Skill2; Blue adds Skill3; Purple adds the on-death Skill4. The roster/dedicated-server demo profile starts illustrated Heroes at White; Sandbox can create a temporary Purple Hero without changing HeroDesk.

## Current kit

| Action | Behavior and prototype values |
| --- | --- |
| Normal attack / Huyết Liên Trảm | LightAtk → LightAtk2, stationary while in melee range. Two independent hits at 310/880 ms, each 70% damage; each rechecks melee range. No blink or third slash. One completed combo gains 16 energy. |
| Ultimate / Dạ Yến Linh Hồn | Charge → hold → cast, 3.13-second body sequence. Five seeking souls released at 1.59/1.72/1.85/1.98/2.11 seconds, cycling through up to three nearest living enemies. Each deals 80% damage to its chosen victim and steals 30% of actual damage, capped by max HP. Native hit and returning-soul visuals accompany impact. Remaining shots can choose another living enemy; already-released souls remain independent if the caster is interrupted or dies, but cannot heal a dead caster. |
| Skill2 / Huyết Trảo | Locks the farthest enemy and remembers the caster's position at cast start. At 470 ms teleports within 140 combat units of that target; at 650 ms grabs if within 350. The victim is interrupted/held and pulled toward the caster. At 2.85 seconds it is thrown 300 units and knocked up for 600 ms, taking 180% damage once. At the end of the 3.44-second sequence, teleports back to the saved X/Y and restores the original facing, then resumes normal combat. Only that victim is affected. Caster interruption/death releases the held victim and cancels the unfinished throw/damage; an interrupted sequence does not force a return during crowd control. Cooldown 12 seconds. |
| Skill3 / Huyết Ảnh Xuyên Trận | Uses the removed third normal-attack slash, from a stationary caster. Locks the enemy with lowest **current HP**, not lowest percentage. BloodSlash3 releases at 120 ms and damage applies at 370 ms to that victim and enemies behind its position in the cast direction, within 2,000 units. No blink/retreat. 160% damage per victim, 8-second cooldown, 870 ms body duration. |
| Skill4 / Tái Sinh Hắc Ảnh | Passive on death, available at Purple. HP zero immediately starts Skill4 rather than the 5.2-second terminal Death clip. Fold/sink for 750 ms, then hold the black shadow. At exactly **2 seconds from HP zero**, restore **50% max HP** and begin rising; stand-up completes at 3.68 seconds. Prototype: **one revival per match**, **+10% lifesteal for 10 seconds** from revival. The Hero cannot act until stand-up completes and can receive damage once HP is restored. A later terminal death uses the full Death clip. |

Base prototype stats: **4,800 HP, 200 damage, 45 defense, range 150, move speed 1,100, attack interval 24 ticks**. Rank bonuses and absorbed/equipped items still use the existing stat calculator. Damage, cooldowns, lifesteal values, number of souls, sweep radius and revival limit are provisional balance choices in JSON config.

Lifesteal is computed from damage actually removed after defense/critical/remaining HP, not the requested damage amount. The revival buff adds lifesteal to later outgoing damage, including souls; it expires without changing base stats or saved HeroData. The returning soul is presentation; the heal is committed at damage impact.

## Test in Unity

1. Open `ArenaPrototype.unity` and **Zatod > Heroes > Combat Sandbox**.
2. Select **Blooesperod**, choose the enemy Monster team, and use **TEST ALL SKILLS / highest rank** for the active kit. Rank promotion only affects the temporary test Hero.
3. Use Normal attack only or the separate Ultimate/Skill2/Skill3 buttons to inspect individual actions. Use Hero HP below 100% to see Ultimate healing.
4. To test **Skill4**, select Purple, set **Hero HP = 1%**, set duration to **15–30 seconds**, add Guardian or another attacking monster, then press the Skill4 button marked **on death**. The Hero waits for lethal damage; the button does not force a resurrection or bypass the passive trigger. Keep Monster HP high enough that it survives.
5. Pause and seek across death, the two-second hold, restoration and stand-up. The replay feed distinguishes pending resurrection and revived HP.

Sample records: `Artifacts/BlooesperodChecks/all-skills.arena.gz` and `resurrection.arena.gz`. Sandbox uses the server combat core without starting a Mirror host/client or mutating owned data.

## Shared systems and replay

The implementation adds configurable sequence teleport/grab/throw cues, two-hit melee sequences, farthest/weakest-and-behind targeting, skill lifesteal, and an on-death resurrection effect. There are no Blooesperod ID branches in the combat engine. Pending resurrection counts toward a team's continued participation, while the zero-HP shadow cannot be targeted. Both teams can wait for revival concurrently.

Seeking projectiles track their selected living target and record per-tick positions/heights. The client samples the saved path instead of solving homing again. Only one final sample is stored per tick, including a sequence's release tick. Old straight-path projectiles continue using their original fields. Rules are now **combat-prototype-9**, adding the generic `SkillCastSequence.ReturnToStartOnEnd` flag used by Skill2. The return is a recorded server Move event, with no Hero-ID branch. Archive schema remains 1 with additive fields/enums. Existing archives are neither rewritten nor re-simulated; generate a new fight to see the return.

Config: the split `Stats.txt`, `Items.txt`, `Skills.txt`, `Heroes.txt`, `Monsters.txt` tables share one version. Balance Blooesperod under Heroes/Skills in **Zatod > Heroes > Hero Balance**, save, reload saved config in Sandbox, and create a new fight.

Importer: `Unity/AgentScripts/SetupBlooesperod.cs`. Source: `C:/Users/tinnq/OneDrive/Desktop/He/ExportedProject/NightLord_HeroKit/`. Restore copy: `Artifacts/BlooesperodBefore/20261118-094836/`. The source kit was read/copied only.

Checks: `scripts/Run-BlooesperodChecks.ps1` (**5,091 assertions / 12 scenarios**) and `Unity/AgentScripts/VerifyBlooesperodRuntime.cs` (**1,105 checks**) cover source hashes, variable keys, UI/rank gates, visual meshes, actual damage, grab interruption/return to the original position in both facings, moving-target homing, death/50% revival, lifesteal expiry, both teams waiting, Unity gzip/JSON and backward seeking. Return samples: `Artifacts/BlooesperodChecks/skill2-return.arena.gz` and `skill2-return-victory.arena.gz`. When the throw kills the final opponent, the outcome is fixed at the kill tick and the return is still recorded during the outro, with no extra attacks/damage. Restore copy for the return change: `Artifacts/BlooesperodReturnBefore/20261118-102913/`. Existing core, Hero data, Monster, Kavern and Enchantx regressions also pass.

Unity workflow references used: `sprite-editor` with `references/templates.md`, `unity-cli` with `integration-advanced.md` / `playmode-verification-loop.md`, and `ui-uitk` for the passive test button.
