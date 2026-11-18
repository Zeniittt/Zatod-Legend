# Lilina

Lilina is the fifth illustrated Hero: rear offensive mage, imported from the approved SalamanderWitch HeroKit v3. **421 unchanged PNG frames / 26 clips** preserve native variable key timing and the final Skill2/Skill4 swap.

- Normal attack: two small fireballs at 280/1,000 ms; 65% damage each.
- Ultimate / Long Viêm Hủy Diệt: summon the dragon, then six line-damage pulses at 2.15–3.55 seconds; 60% damage per pulse, all enemies in the forward line. The actor/dragon and breath use the approved v3 reference reconstruction layers.
- Skill2 / Lôi Quang Xuyên Trận: aim at the farthest enemy, release at 1.36 seconds; one projectile pierces up to five enemies, 160% damage each, resolving as its head travels. Cooldown 9 seconds.
- Skill3 / Song Lôi Truy Mệnh: two seeking orbs, released at 920/1,020 ms, choose two lowest-current-HP enemies. With one living enemy both hit it. 140% damage each; cooldown 8 seconds. Paths are recorded for replay.
- Skill4 / Hỏa Tức Thiêu Đốt: four direct 70% damage pulses on the nearest locked target, followed by four 25% Burn ticks at 400 ms intervals. Refreshing the delayed first tick prevents it occurring during the uninterrupted breath. The residual burn can continue if the caster is interrupted after a successful pulse. Cooldown 10 seconds.

Values are provisional. Base stats: 2,600 HP / 230 damage / 15 defense / range 3,000 / speed 1,300 / attack interval 24 ticks. White/Green/Blue/Purple unlock Ultimate/Skill2/Skill3/Skill4 respectively. Use **Combat Sandbox → Lilina → TEST ALL SKILLS / highest rank**.

The v3 dragon/Flamer layers were reconstructed in the source chat from GIF references; they are sketch assets rather than recovered original Addon#2 PNGs. Original Ultimate/Skill4 body frames are kept as `UltimateOriginal`/`Skill4Original`, separately from the reconstructed actor clips used for playback. Source bytes, metadata and provenance are retained in `Assets/Zatod/Art/Lilina`.

`VerifyLilina.cs`: **4,842 checks** for hashes, keys, rank gates, actual targeting/damage, five-target pierce, two/one-target orbs, four lingering Burn ticks and every replay tick. `VerifyLilinaRuntime.cs`: **42 checks** (including Campaign overlay isolation on the final regression), actual Sandbox actions, dragon/breath/bolt/twin/Burn meshes, pause/seek, unchanged HeroDesk/config and no Mirror startup. Runtime Console is clean. Only after these passed was Campaign work resumed.

Source: `C:/Users/tinnq/OneDrive/Desktop/He/ExportedProject/SalamanderWitch_HeroKit/`. Importer: `Unity/AgentScripts/SetupLilina.cs`. Restore: `Artifacts/LilinaBefore/20261118-110356/`. Evidence: `Artifacts/LilinaChecks/dragon.arena.gz`, `burn.arena.gz`. Shared additions are lowest-HP sequence target ordering and configurable delayed Burn ticks. Rules 10, schema 1. No Hero-ID branch in combat.
