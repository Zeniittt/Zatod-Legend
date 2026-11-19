# Leenald — Hero asset and skill setup

Leenald (`leenald`) is a melee/front Hero. Current PNGs were imported byte-for-byte from `C:/Users/tinnq/Downloads/monk_original_selected` on 2026-11-17, replacing the earlier x4 artwork. The existing icon is unchanged. Source notes and projectile bounding-box JSON are preserved in `Unity/Assets/Zatod/Art/Leenald/`.

## Applied Skill2 / Skill4 fixes — combat-prototype-4

These are implemented changes, replacing the earlier investigation/proposal. Current config version ends in `-origins-1`.

- `HeroDefinition.SpawnPoints` contains named local combat points (`Id`, `Forward`, `Height`). Leenald defines `feet` at the grounded character origin. A skill selects `ProjectileSpawnPointId` and can add local forward/height offsets. Forward is mirrored with facing. `HeroProjectileOrigin.Resolve` is shared by server and native animation preview; battle snapshots deep-copy all points.
- Skill2 selects `feet`. Its art origin is `(144,7)` on the original source canvas. The trailing edge starts at source X=172, one pixel past the planted foot's X=171. Replay preserves that authored gap and ground plane; changing sprite width no longer recenters the eruption. Projectile draw scale now matches the body for this skill.
- The server's swept hit shape starts from the resolved projectile origin, with a configured forward shape offset of 112 combat units derived from the source gap and PPU. Height checks use the Hero's configured projectile hurtbox height. Hit position is the projectile's actual first contact position, including initial overlap, rather than snapping its root to the victim center. The frozen record stores origin ID, height, shape offset and art scale. No runtime Hero ID checks are used.
- Skill4 already displaced enemies only. The apparent caster movement was caused by camera recentering: measured caster world X stayed 0, while its screen X changed from -49.5 to -85.5. Replay now fits one fixed camera to the complete record, so world positions do not slide merely because another fighter is displaced. Measured caster screen X is now -85.5 both before/after, and seeking gives the same framing.
- Verification: 16 targeted origin/camera checks (both facings, original-art foot alignment, grounded hit origin, enemy-only push); 181 art/projectile checks; 36 Sandbox UI checks; 164 Sandbox core checks; 347,507 combat checks; 112 Hero checks. Updated Windows builds: `Builds/LeenaldBattle` and `Builds/Windows`. Native dedicated-server replay/reload/idempotence/restart test passed.

For a fresh test, use **Zatod > Heroes > Combat Sandbox**, reload saved config and press Skill2 or Skill4. Existing replay outcomes are immutable; new origin/hit calculations apply to newly generated fights. `Hero Balance > Heroes` exposes spawn points; `Skills` exposes the point ID, offsets and shape offset. Restore copy: `Artifacts/SkillOriginBefore/20261117-115127/`.

## Assets and review

- Character prefab: `Unity/Assets/Zatod/Resources/Heroes/Leenald/Leenald.prefab`.
- Animator: `Leenald.controller` in the same directory; nine named states, Idle default. Call `HeroAnimationPlayer.Play(state)`; attack/skill states return to Idle, Stun/Death hold until explicitly changed.
- Frame manifest: `AnimationSet.txt` in that directory. It records source order, original-canvas anchor, cropped sprite rectangles and clip resource keys. Runtime art configuration remains JSON, not a custom ScriptableObject config.
- Two separate projectile prefabs/controllers: `Ultimate_Projectile` and `Skill2_Projectile`.
- Icon: `Unity/Assets/Zatod/Resources/HeroPortraits/leenald.png`, used by roster, detail and formation views.
- SpriteAtlas V2: `Unity/Assets/Zatod/Art/Leenald/Leenald.spriteatlasv2`, built-in delivery, point filtering, no rotation/mips, lossless RGBA32 Standalone override. `LeenaldAtlasBuild` ensures packing through the prebuild callback. The actual packer mode was read back as `SpriteAtlasV2`.

Enter Play Mode, open Leenald in Hero detail, then use **Zatod > Heroes > Leenald Animation Preview** to play every animation and flip facing. Preview controls deliberately ignore rank locks and do not change HP/energy/progression. The model also idles in Leenald's detail view; other placeholder Heroes keep their model area empty.

The initial import script is `Unity/AgentScripts/SetupLeenald.cs`, run through Unity Pipeline. It refuses to overwrite an existing balanced Leenald definition. It uses Sprite Editor data providers with mandatory capability checks; no `.meta` editing. Config before installation is backed up under `Artifacts/LeenaldBefore/20261116-112552/`.

## Rules 12: original formation restored

The original front-to-back formation and shallow alternating depths are restored. Melee reach is now 1,300 center units; Ultimate reaches 1,800, Skill2 1,600 (logic lifetime 1.5 s), and Skill4 radius 1,400. Damage, stun/airborne duration and knockback distance are unchanged. New battle layouts also enable the generic per-clip `StabilizeHorizontalAnchor` option for NormalAttack, removing baked horizontal actor travel from that stationary pose. Native source frames, Sprite pivots and animation clips are unchanged. Old replay layouts keep their former mapping. See `docs/verification.md` for measured body visibility.

## Animation mapping

All clips currently sample at **12 FPS**, in numeric order rather than lexical filename order. There are **137 frames / 11 clips**. Current PNGs have a common 288×128 source canvas. The shared foot/origin is pixel `(144, 7)` in Unity's bottom-left coordinates, equivalent to `(144, 121)` from the top. Cropped rectangles retain this anchor. Import uses **25 PPU**, point filtering and no PNG resampling; SpriteRenderers and replay UI retain the earlier display/world size. Body frames are not recentered.

| State | Folder / frame order | Frames | Behaviour |
|---|---|---:|---|
| Idle | `Idle/idle_1..6` | 6 | Loop |
| Run | `Run/run_1..8` | 8 | Loop |
| Stun | `TakeHit/take_hit_1..6` | 6 | Play once, hold last pose |
| Death | `Death/death_1..18` | 18 | Play once, hold final empty frame |
| NormalAttack | `Attack/2_atk_1..12` | 12 | Return to Idle |
| Ultimate | `Ultimate/sp_atk_1..25` | 25 | Return to Idle |
| Skill2 | `Skill2/3_atk_12..23` | 12 | Return to Idle |
| Skill3 | `Skill3/meditate_1..16` | 16 | Return to Idle |
| Skill4 | `Skill4/air_atk_1..7` | 7 | Return to Idle |
| Ultimate_Projectile | `Ultimate_Projectile/sp_atk_4..24_proj` | 21 | One-shot visual, lifetime 1.75 s |
| Skill2_Projectile | `Skill2_Projectile/3_atk_17..22_proj` | 6 | One-shot visual, lifetime 0.5 s |

Death frame 18 is transparent in the source and remains transparent here. No frame is discarded. Unity object-reference curves include their final frame interval automatically, so clips have exactly N keys and duration N/12, without an extra terminal key.

Projectile art includes authored movement on the shared canvas. Detail-preview prefabs retain that motion. Arena replay uses the recorded path. Skill2 uses an authored foot origin and normalizes travel against the first frame's trailing edge, retaining its original foot-to-effect gap and vertical ground pivot. Other projectile clips retain their previous alignment unless configured with an authored origin. Cropping bounds are not gameplay hitboxes; the combat core uses configured hit radius/offsets.

Close-range contact can resolve in one 20 Hz tick (0.05 s). Previously replay hid the projectile immediately, before its animation could become apparent. On a recorded hit, the visual now finishes its clip at the recorded contact point: Ultimate 21/12 = 1.75 s, Skill2 6/12 = 0.5 s from release. Hit timing/status application are unchanged. Pause, speed and seek drive this presentation interval.

The replacement importer is `Unity/AgentScripts/ReimportLeenaldOriginal.cs`: preflight all source frames and Sprite Editor capabilities, preserve sprite GUID/local file IDs and clip/controller/prefab references, leave icon and Hero config untouched. Restore copy: `Artifacts/LeenaldOriginalBefore/20261117-105852/`. Verification passed: **780 animation/import checks**, **181 original-art/projectile regression checks**, **36 Sandbox UI checks**. No standalone executable was rebuilt for this Editor/asset fix; rebuild normally when a new Windows preview is needed.

## Hero and skill config

Definitions are added to the existing split `Heroes.txt` and `Skills.txt`, not to the old combined file. The config set version is `heroes-prototype-1-split-1-formation-1-leenald-1`. Existing Hero balance values and recipes were retained. Leenald currently reuses the prototype six-item rank recipes; final monk gear is not authored in this pass.

| Base stat | Value |
|---|---:|
| Health | 4800 |
| Damage | 220 |
| Defense | 60 |
| Attack range | 1300 |
| Move speed | 1600 |
| Attack interval | 26 combat ticks (1.3 s) |

These are initial balance values. Account/Hero level/star growth remains outside this setup. The demo profile places Leenald first, at initial White rank; existing sample Heroes retain their prior demo rank pattern.

| Skill | Unlock | Configured behaviour | Initial values |
|---|---|---|---|
| Normal attack | Basic action | Nearest enemy, 100% Damage | Range 1300; impact windup 417 ms |
| Ultimate / Earth Seal | White | Projectile toward nearest enemy; Stun on contact | 100 energy, 1500 ms stun; spawn at source frame 4 = 250 ms |
| Skill2 / Rising Stone | Green | Forward projectile; KnockUp on contact | 6 s cooldown; 800 ms airborne, height 100; spawn at source frame 17 = 417 ms into selected clip |
| Skill3 / Meditation | Blue | Automatic self Heal | 8 s cooldown; heal 600 |
| Skill4 / Repelling Palm | Purple | All enemies in range; Knockback | Radius 1400, distance 100, 250 ms; 7 s cooldown |

The two projectiles initially have `ProjectileMaxHits = 1`. Projectile speed/hit radius/lifetime, spawn timing, effects and durations are editable in the Skills tab of Hero Balance. Targets/effects enums were appended so earlier numeric enum values remain unchanged. Native clip timing and spawn timing need to stay aligned if animation playback speed is changed later.

## Authority and current limits

### Gameplay hiện tại để duyệt — 2026-11-17

Đây là hành vi đang có trong config và combat core, không phải đề xuất cho bản sau. Damage đánh thường, lượng heal, cooldown, thời gian khống chế, tốc độ projectile và khoảng đẩy là số prototype do em tự đặt. Phạm vi đo từ tâm trên trục ngang; độ sâu hiển thị không tham gia kiểm tra trúng.

| Hành động | Mở ở bậc | Kích hoạt / mục tiêu | Effect hiện tại |
|---|---|---|---|
| Đánh thường | Có sẵn | Tự động; mục tiêu chiến đấu đang khóa, tầm 1300 | 100% Damage trước defense/crit; không có projectile |
| Ultimate / Earth Seal | Trắng | Tự động khi đủ 100 energy trong Arena offline; chọn kẻ địch gần nhất trong tầm 1800 | Projectile chạm kẻ địch đầu tiên thì Stun 1,5 s; không gây damage |
| Skill2 / Rising Stone | Xanh Lá | Tự động; chọn kẻ địch gần nhất trong tầm 1600; cooldown 6 s, không tốn energy | Projectile bay thẳng, chạm kẻ địch đầu tiên thì KnockUp 0,8 s, độ cao hiển thị 100; không gây damage |
| Skill3 / Meditation | Xanh Dương | Chiêu active tự động khi HP chưa đầy; chỉ bản thân; cooldown 8 s, không tốn energy | Hồi một lần 600 HP, giới hạn bởi Max HP |
| Skill4 / Repelling Palm | Tím | Tự động khi có địch trong tầm 1400; cooldown 7 s, không tốn energy | Đẩy mọi địch còn sống trong khoảng cách tâm 1400 ra xa Leenald 100 đơn vị; khóa hành động 0,25 s; không gây damage |

**Animation:** Đánh thường dùng `Attack`; Ulti dùng `Ultimate` và `Ultimate_Projectile`; Skill2 dùng `Skill2` và `Skill2_Projectile`; Skill3 dùng `Skill3`; Skill4 dùng `Skill4`. Idle/Run/Stun/Death lần lượt là `Idle`/`Run`/`TakeHit`/`Death`. Tất cả 12 FPS, dùng art original, icon giữ nguyên.

**Projectile Ulti:** chọn đối thủ lúc bắt đầu cast, chốt vị trí lúc phóng sau 250 ms; bay đến vị trí đã chốt, không tự bẻ hướng theo mục tiêu. Tốc độ 1200 đơn vị/s, hit radius 60, thời gian tồn tại logic tối đa 1,75 s. Kẻ địch đầu tiên va chạm nhận Stun; một projectile chỉ trúng một mục tiêu.

**Projectile Skill2:** phóng theo hướng mục tiêu sau 417 ms trong config, thực tế 450 ms do làm tròn tick. Tốc độ 1400 đơn vị/s, hit radius 60, lifetime 1,5 s. Hiện chỉ trúng một kẻ địch rồi kết thúc, chưa xuyên qua nhiều kẻ địch. KnockUp khóa hành động trong 0,8 s và hiển thị đường cong nhấc lên/hạ xuống; mục tiêu vẫn có thể nhận damage trong thời gian này.

**Heal:** bắt đầu được chọn khi HP < Max HP, hồi một nhịp sau 667 ms trong config (thực tế 700 ms). HP không cần xuống dưới ngưỡng phần trăm nào khác. Cooldown tính từ lúc bắt đầu cast.

**Knockback:** lấy danh sách trong tầm khi chiêu resolve sau 167 ms trong config (thực tế 200 ms). Bao gồm kẻ địch trước hoặc sau Leenald. Core cập nhật vị trí ngay 100 đơn vị theo hướng ra xa, đồng thời khóa hành động 250 ms; renderer làm mượt vị trí. Chưa có mô phỏng lực đẩy hoặc kiểm tra va chạm thân nhân vật.

**Nhịp ra chiêu:** khi hết khóa hành động và đến nhịp hành động kế tiếp, ưu tiên Ulti → Skill2 → Skill3 → Skill4 → đánh thường; bỏ qua skill đang cooldown, thiếu energy, ngoài tầm hoặc heal khi HP đầy. Cooldown là lúc chiêu sẵn sàng, không bảo đảm cast đúng ngay thời điểm đó. Sau resolve có thêm nhịp chờ theo attack interval (Leenald 26 tick = 1,3 s) và recovery của chiêu. Core chạy 20 Hz nên các thời gian được làm tròn lên bội 50 ms. Đánh thường resolve cộng 16 energy, hiện cả khi miss; nhận damage cộng 10 energy mỗi lần. Ulti trừ energy khi bắt đầu cast, không hoàn lại khi bị ngắt.

**Bị ngắt:** khống chế trước lúc phóng/resolve sẽ ngắt chiêu đang chuẩn bị. Nếu mục tiêu đã khóa chết trước release, chiêu cũng bị hủy. Khi trận còn diễn ra, projectile đã phóng tiếp tục tồn tại dù người tung chiêu bị khống chế hoặc chết. Hiện chưa có luồng người chơi bấm Ulti online runtime.

**Hình ảnh sau khi trúng:** server áp effect ngay tick va chạm. Riêng animation projectile tiếp tục đến hết clip tại điểm chạm (Ulti 1,75 s, Skill2 0,5 s tính từ release); thời gian này không tạo thêm hit hoặc lặp lại effect.

`HeroAnimationPlayer` remains a detail/asset preview. Arena instead uses `ReplaySprite` with a manually evaluated PlayableGraph: body frames and projectile visuals are sampled from the replay clock, so pause, speed and seek never decide combat hits. Dedicated-server `BattleSimulation` executes active Damage/Heal/Stun/KnockUp/Knockback from detached skill definitions. A 30-tick result-free tail lets the final Death animation finish. Passive/StatBonus triggers remain future work.

Battle snapshots also copy the normal-attack definition when configured. Use `HasNormalAttack` to distinguish the optional entry when reading Unity JSON, whose inline object deserialization can create a default object for a null field.

Arena rules version 3 accepts selected owned instance IDs, validates against a server-owned sandbox profile, and freezes stats/unlocked skills before resolving the fight. The opponent still uses sample fighters. White Leenald has basic attack and Ultimate; the other skills remain locked until progression unlocks them. Replay schema 1 is extended additively; old records remain outcome playback and are never rerolled. The initial centre-distance radius was 100; rules 11 raises it to 1400 to match readable melee separation, independently of padded sprite bounds. Production accounts, passive triggers, live player Ulti commands and final art/coordinate scale tuning remain outside this pass.

To try: build **Zatod > Build Leenald Battle Preview**, start `./scripts/Start-Server.ps1 -BuildFolder LeenaldBattle`, then open `Builds/LeenaldBattle/ZatodArena.exe` (or Play the Unity scene). Back from the Hero list opens formation; choose Leenald and optional teammates, then Battle. New records include frozen loadouts and projectile paths. `VerifyLeenaldBattle.cs` checks data/effects/seek; `VerifyLeenaldRuntime.cs` checks the Formation-to-server UI path. Network smoke accepts `-BuildFolder LeenaldBattle -Leenald`.

The Hero model uses a separate layer/camera/RenderTexture preview and releases it when detail closes. Flip, cast timing, authored offsets and cleanup are verified independently of gameplay effects.

## Verification

- `scripts/Run-HeroChecks.ps1`: 106 core assertions, including projectile/delivery/normal-attack copying and invalid control configs.
- `Unity/AgentScripts/VerifyLeenald.cs`: 779 assertions for frame counts/numeric order, timing, source PNG hashes, common anchor, loop/hold/return behaviour, skill unlock/config, normal-attack snapshot isolation, atlas setup, runtime projectile spawn/cancellation/facing/lifetime, and camera/texture cleanup.
- Editor screenshots and the final build are recorded in `docs/verification.md` after the complete run.

## Checkpoint — paused at the user's request, 2026-11-16

**Resume result: completed on 2026-11-16.** The earlier pause/checklist below is retained as history. The user approved retrying Computer Use; the standalone Leenald Preview was launched, its returned window selected, and Leenald opened from the roster. Portrait, model and Idle pose changes were visually observed in the actual Windows build, with the configured stats/rank shown correctly. No asset/config overwrite or rebuild was needed. The game is left open on Leenald detail. Startup log has no gameplay exception; known stripped-postprocessing notices are unchanged. Asset/animation/config setup and its final standalone check are complete. Arena execution of the new skill effects remains outside this setup.

Implementation is complete for asset import/animation setup and skill effect configuration. Do not repeat the import: Leenald already exists, and the setup script deliberately refuses to overwrite balanced data.

Completed: 137 original PNGs imported, nine Hero clips/two projectile clips, controllers/prefabs/icon, atlas built-in V2, Hero/skill JSON, normal-attack/special-skill snapshot isolation, model in detail view, and the Editor animation preview controls. Tests passed: **106 core / 779 Leenald / 247 roster-detail**. Editor Play Mode verification had zero runtime errors/warnings. Sprite source hashes and original anchor are checked for every frame. Frame timing was corrected to exactly N/12 seconds; no extra terminal key.

The final Windows build **succeeded** at `Builds/LeenaldPreview/ZatodArena.exe`. It was launched with log `Logs/leenald-preview.log` (PID 28164 at launch; recheck before using). The final native-window check is unfinished: Computer Use returned **"Computer Use was not approved to use zatodarena"** before a usable window observation. No native click or screenshot verification was completed. Do not claim that this standalone UI was visually verified yet.

Remaining when the user resumes:

1. Inspect the new standalone startup log for exceptions/warnings. Check the running process or reopen the built executable if needed.
2. Visually open Leenald (first Hero) in that standalone build and verify icon/model/Idle after packed-atlas loading. Use an approved Computer Use surface or user review; no need to reimport or rebuild unless a real issue is found.
3. Optionally open **Zatod > Heroes > Leenald Animation Preview** in Editor Play Mode for the user to review each clip. It previews all animations regardless of rank.
4. Update `docs/verification.md` with that final standalone result and report completion. Gameplay CC/heal integration into Arena is outside this setup and remains deferred.

Important defaults to discuss later if desired: 12 FPS; Death frame 18 is intentionally empty; both projectiles currently hit one target in config; Skill3 auto cooldown 8 s/heal 600; Skill4 logical radius 100/distance 100. Native projectile animation already contains authored motion, so the current visual preview does not translate it a second time. Scene/config backups and source notes remain in place. No git commit or push was made.
