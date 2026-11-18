# Kavern — prototype

Imported from `C:/Users/tinnq/Downloads/delivery_leaf_original` without modifying source pixels: 197 PNG frames, 21 body/effect clips, 12 FPS, 25 PPU, point filtering. The supplied transparent 256px icon is used. Body, bow, air-bow, beam and ground-effect pivots are distinct. The air attack raises presentation only; the authoritative fighter stays on its ground plane.

## Try it

Open `Unity/Assets/Zatod/Scenes/ArenaPrototype.unity`, then **Zatod > Heroes > Combat Sandbox**. Select **Kavern (kavern)** and press **TEST ALL SKILLS / highest rank**, or use the four individual skill buttons. Selecting Kavern sets target distance to 600; three targets make the two-target limit easy to inspect. Pause, move by one tick or seek in the replay to review projectile contact and effects.

Kavern is also available in the Hero roster and formation. The demo account receives Kavern at White: only Ultimate is unlocked there. Sandbox's temporary Purple Hero unlocks all four skills without changing owned progression. A dedicated Arena server must run the updated build/config before Kavern can be selected in network battles.

## Skills

| Action | Prototype behavior |
| --- | --- |
| NormalAttack | Bow projectile, one enemy, 100% damage. Six flying frames; six impact frames start only on server-recorded contact. |
| Ultimate / Emerald Beam | 100 energy. Horizontal beam hits enemies ahead within range once, for 300% damage. Separate sparks and beam cues follow the cast clock. |
| Skill 2 | One poison arrow: 100% contact damage, then 20% damage each second for four seconds. Six flying frames and eight poison-impact frames. Reapplying the same caster/skill refreshes the poison rather than creating another stack. |
| Skill 3 / Twin Arrowshower | Locks at most the two nearest living enemies in cast range. After the body animation, one ArrowShower appears at each selected enemy's feet; each receives one 180% damage hit. No splash damage or extra targets. If only one enemy exists, only one shower appears. A selected victim dying does not cause a third enemy to replace it. |
| Skill 4 | Air attack releases one descending arrow. Contact deals 140% damage and **Stun for 1 second**; the thorn impact appears at the victim's feet. No root, knockback or ally/self control. |

Skill 3 showers start seven source frames after the 12-frame body animation ends. Damage occurs six shower frames after the effect begins. Source timing is rounded up to the fixed 20 Hz simulation clock. Projectiles use shared configurable spawn points and collision offsets, with no Kavern-specific branch in combat.

Provisional base values: HP 3,000; damage 240; defense 25; attack range 3,000; move speed 1,600; attack interval 28 ticks. Skill 2/3/4 cooldowns: 6/9/7 seconds. The absorbed equipment/rank bonuses still contribute to final stats, so a temporary Purple Hero deals more damage than White. Recipes currently reuse placeholder equipment; these are balance scaffolding.

## Data and replay

- `Unity/Assets/Zatod/Resources/Data/Heroes.txt`: identity, ranks, stats, named spawn points.
- `Unity/Assets/Zatod/Resources/Data/Skills.txt`: targeting, damage, poison, stun, delays and visual cues.
- `Unity/Assets/Zatod/Resources/Heroes/Kavern/AnimationSet.txt`: clip/frame metadata and presentation pivots.
- Edit balance through **Zatod > Heroes > Hero Balance**, save, then **Reload saved config** in Sandbox and generate a fresh test.

Rules `combat-prototype-5` record flight paths, selected-target visuals and poison states alongside outcomes. Pause/seek/archiving uses recorded ticks and target IDs, not a rerun of combat or animation events. Existing archives are not rewritten. The imported plain Skill4 hit is retained as an alternative asset; the configured hit currently uses thorns.

Verification scripts: `Unity/AgentScripts/VerifyKavern.cs` (assets, damage, targeting, control, deterministic outcomes and every replay tick); `VerifyKavernRuntime.cs` (actual Sandbox UI buttons, visible meshes, flight/impact separation, feet placement, pause/expiry/backward seek).
