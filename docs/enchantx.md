# Enchantx

Rear ranged Hero imported from `C:/Users/tinnq/OneDrive/Desktop/CentaurLady_HeroKit_v4/CentaurLady_HeroKit`. All 339 PNGs retain their original bytes. The 27 clips preserve per-key source times, including Idle frames 1–18 and the shortened landing in v4. Ten body states include a separate `Skill3Repeat` clip. Art is normalized to 25 PPU like the other imported Heroes; a shared body foot pivot (64,12) replaces the export's actor pivot (64,45), retaining all relative poses. No source PNG is edited.

## Test opening and repeat

1. Open `Unity/Assets/Zatod/Scenes/ArenaPrototype.unity` and **Zatod > Heroes > Combat Sandbox**.
2. Select **Enchantx (enchantx)**; target distance becomes 1,410 to leave room for the entry motion.
3. **TEST ALL SKILLS / highest rank** tests the full kit using a temporary Purple Hero.
4. To compare Skill3 variants: select Purple, set **Single-skill casts = 2**, **Duration = 25**, and press **skill_3 / Enchantx / Hieu Lenh Xung Tran**.
5. The opening begins at the first combat tick. The second cast is around 10 seconds and stays at the reached ground position. Buff bursts are around 4.8 and 12.5 seconds from record start. Pause, seek and ±1-tick controls inspect either cast.

The demo account owns Enchantx at White, so normal Arena initially unlocks normal attack and Ultimate only. Skill2 unlocks at Green, Skill3 at Blue and Skill4 at Purple. The special opening only runs when Skill3 is unlocked. Sandbox does not upgrade the owned Hero or start a network host.

## Prototype kit

| Action | Behavior |
| --- | --- |
| NormalAttack | FrontHeavyAtk, one Arrow, 100% damage. Release at 0.10s, body duration 0.57s. Flight and contact are recorded separately. |
| Ultimate / Xuyen Phong | Four charging phases. Release at 1.80s, 250% damage to enemies ahead at 1.90s, body duration 2.20s. Native StormArrow remains anchored at its origin and grows through its source frames; WindStorm plays at the locked target location. Tornado is visual only in this pass; no additional knock-up or damage. |
| Skill2 / Thien Tien | Rain stays at the target's cast-time position. Radius 220 along the combat axis; four pulses at 0.70/1.10/1.50/1.90s, 45% damage each to living enemies inside the zone. Shallow formation depth remains visual, consistent with current targeting. Source body runs once; rain appears/loops/dissipates on its own clock. Cooldown 8s. |
| Skill3 / Hieu Lenh Xung Tran | First cast starts immediately on entering battle, before ordinary attacks/skills. Jump → shortened landing → run → SummonUp. Later casts only use SummonUp/loop/cast at the current position. FlameWings Entry → flying Walk → Dissipate, with a recorded orange burst ring. Burst grants all living allies, including the caster, **+20% outgoing damage for 8s**. Cooldown 10s, beginning with the opening cast. |
| Skill4 / Lien Tien | Three separate Arrows at 0.10/0.67/1.24s, 80% damage each, body duration 1.71s. Keep the target while alive; unfired arrows select the next enemy if it dies. Stun cancels unfired shots, while released arrows continue. Cooldown 7s. |

Base values are provisional: HP 2,800; damage 225; defense 20; attack range 4,000; movement 1,600; attack interval 26 ticks. Rank/absorbed placeholder gear bonuses still contribute to the calculated Hero stats. No portrait was supplied, so the icon is a Sprite Editor crop of an unchanged Idle PNG.

## Opening, interruption and modifiers

Skill3's two sequences share one skill ID, level, cooldown and buff definition. The opening is consumed when it begins, so interruption never replays the entry movement. Before FlameWings releases, an interrupt prevents the summon/buff. After release, the bird and delayed buff continue independently, including if the caster later dies; dead allies do not receive the buff. Ground movement respects friendly formation spacing and stops before enemies. Jump height is presentation data and grants no invulnerability.

The same skill refreshes its buff duration instead of stacking another copy. Outgoing damage changes in battle; `HeroData`, base attack and the saved catalog do not change. Expiration removes the modifier and is included in the replay. Flight heights are fitted to the current battle viewport, rather than copied directly from demo screen coordinates.

## Shared configuration and replay

`Heroes.txt` contains Enchantx identity, stats, ranks and spawn points; `Skills.txt` contains sequences, time cues, motion keys, damage, radius, cooldown and buff values. Use **Zatod > Heroes > Hero Balance**, save with a new ConfigVersion, then **Reload saved config** in Sandbox and generate a fresh test. `HeroDefinition` and skills still use JSON `.txt`, not ScriptableObjects.

Shared `CastSequences` support opening/repeat variants, multiple releases, fixed ground pulses, delayed effects after release and bounded movement. No Enchantx ID check is present in the combat engine. Runtime uses integer positions and 20 Hz ticks; source key durations remain independent for rendering. Server outcomes, motion, modifiers, bird phases and burst rings are recorded under `combat-prototype-6`. Playback/seek does not rerun skills or use animation events to deal damage. Old replay archives remain immutable.

Verification: `Unity/AgentScripts/VerifyEnchantx.cs` checks source art, key times, damage, entry/repeat, rank gates, modifiers, interruption, retargeting, detached config and every replay tick. `VerifyEnchantxRuntime.cs` exercises actual Sandbox buttons and visible geometry, including body frames, anchored wind arrow, all FlameWings phases, burst, pause and backward seek. A generic native network check accepts `scripts/Test-ArenaNetwork.ps1 -HeroId enchantx`; this uses the server-owned White demo Hero.
