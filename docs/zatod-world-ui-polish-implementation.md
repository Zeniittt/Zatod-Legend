# D38 — Triển khai Equip, world/UI và PoolManager

Cập nhật **25/11/2026, Asia/Saigon**. Baseline `522721a34`, nhánh `codex/d38-world-ui`. Phạm vi theo [phase-plan D38](zatod-world-ui-polish-phase-plan.md), quyết định tại Design D38.

**Trạng thái:** đã triển khai và kiểm core/Unity/UI/TCP/replay/farm/chơi lâu trên Mac; IPA arm64 chưa ký đã build, đóng gói và kiểm thành công. Chưa kiểm bản mới trên Windows, OPPO Pad Air hoặc iPhone thật; không coi Game View là nghiệm thu thiết bị.

## A. Equip và giao dịch

- `ZatodEquipmentView` giữ operation ID, Hero, slot, GUID món và context của lần mở panel. Snapshot phải chứa receipt đúng và đúng GUID đang mặc thì mới tự đóng, trả về Hero Detail đã cập nhật.
- Lỗi giữ panel/reason; nhấn kép không gửi thêm giao dịch. Reply cũ không đóng panel mới dù item/slot trông giống nhau. Xem đồ đang mặc hoặc craft giữ flow riêng.
- Server cho receipt Equip/craft đã commit được xử lý lại trước guard queue/room; giao dịch vẫn kiểm payload theo receipt, không bỏ điều kiện cho yêu cầu mới.
- Kiểm TCP độc lập đạt 11 ca: success/context, double click, reply trễ qua Hero khác, receipt lặp, stale GUID, persist rollback, reconnect, read-only/craft. Evidence `Artifacts/D38Checks/Equipment3/equipment.json`.

## B. Art world

- Cả bảy điểm tính năng ở Town dùng art Crystal. Phó bản/Guild/Arena/Tower/PvP dùng các animation `eff_UI_Main_Pve`, `eff_UI_Main_Guild`, `eff_UI_Main_Pvp`, `eff_UI_Main_fancytower`, `eff_UI_Main_Pvp_fort`; Hero/Replay dùng Coco/Zeus Idle. Giữ ID/target và avatar người chơi SPUM.
- Field `WorldInteractionDefinition.AnimationSetResource` được copy qua world compilation và authoring trong GameEditor. World dùng animation nếu có field; prefab cũ vẫn còn trên đĩa.
- Baker đọc container đã giải nén ở reference hiện hành, giữ frame/FPS/pivot/layer/alpha. Bản nguồn PeakArena thiếu sprite `a2.png` trong atlas nên không bỏ layer để ép bake; chọn variant Pvp_fort cho điểm realtime, không khẳng định đó là mode realtime của Crystal gốc.
- Map vẫn cùng tồn tại; không thêm lazy-load/cache/unload map. World actors chỉ sample Idle/Loop, không có combat, AI hoặc sở hữu.

## C–E. Selector, portal và policy ải

- Làng mở selector trước khi travel. Ghép 20 asset Crystal gốc, kéo ngang, focus chương đang chơi hoặc chương cao nhất mở được. Tên/trạng thái/progress lấy từ catalog và sao cá nhân; khóa hiện đủ các lý do.
- Server dùng chung `CampaignCatalog.ChapterLockReason/StageLockReason`: chương 1 mở; chương 2–8 cần hoàn thành ải cuối chương trước và account Lv5/8/16/26/36/46/56. Kiểm world revision, map/catalog, guard battle/queue trước khi đổi membership. Reject không cấp trận/loot hoặc trừ thể lực.
- Portal trái/phải tới chương liền kề, không wrap. Spawn có khoảng cách với portal và tránh collider; một điểm spawn chương 6 được dời nhẹ để tránh prop. Giữ Town, camera/input/presence và return context.
- Nhập đúng **55 key / 99 minor** từ Stage nguồn. Minor thắng hợp lệ hiện Passed và vẫn preview được; server chặn begin lại trong phiên. Key vẫn farm được. Progress vẫn reset theo launch; replay không mở khóa hay nhận thưởng.
- Toàn bộ 154 điểm ải dùng boss của wave cuối; `WorldBossEnemyId` cho phép authoring trường hợp nhiều boss và validate phải thuộc wave cuối. Giữ StageId/SourceStageId/target và encounter.
- Get Way giữ icon và flow D29, thêm trạng thái Passed/level theo policy mới.
- Sửa BUG-082: vùng trong suốt của đảo 7 từng chặn đảo 6. Filter dùng mesh Tight sẵn có, giữ nguyên pixel/nén/layout. GraphicRaycaster nhận đúng 8/8 tâm đảo; pointer qua Input System chọn một lần, kéo không chọn. Selector clear selection khi hide/rebuild; world kiểm Unity-null để tránh đọc control đã hủy (BUG-084).

## F. Preload và pool

- `ZatodBattleAssets` giữ asset của đội/encounter/summon/form và skill dependency liên quan trước khi tạo simulation mới. Chuẩn bị clip/background/audio/FX; chỉ tải projectile/chain khi đúng delivery. Audio thiếu từ nguồn D34 được ghi nhận, không thay clip giả.
- Scene loading prewarm FX; lỗi/hủy/stale loading trả về world và dọn scene. Snapshot/tick/input/rules không đổi để chờ asset.
- `ZatodPoolManager` tái sử dụng effect, projectile/chain visual và số damage/heal/crit. Lease có generation để chặn double/late release. Reset transform, graph/time, material/property block/alpha/sorting, text, audio và coroutine. FX giữ tối đa 96 object idle/4 mỗi resource; text giữ tối đa 64, prewarm 12; FX prewarm một object cho tối đa 12 resource của trận.
- Khi rời scene, stage pool đi theo scene; pool text sống cùng HUD để tái sử dụng. BUG-083 được sửa để release text ngay khi Finished/thoát trận, không chỉ ở trận sau. Kiểm cuối world: **0 active / 34 idle** ở pool text.
- Texture mới giữ chất lượng/geometry, dùng ASTC 6x6 trên iPhone/Android; không đổi pixel hoặc rect/pivot/GUID của bộ cũ, không tự đặt 60 FPS thành tiêu chí.

## G. Bằng chứng kiểm tra

Evidence local dưới `Artifacts/D38Checks/`; source test ở `Tests/Unity/`, `Tests/CrystalChecks/`, script ở `scripts/`.

| Kiểm tra | Kết quả |
|---|---|
| Core legacy / native V7 / Hero / policy D38 | 8.051 / 3.017 / 112 / 46 đạt |
| Preload | 74 match: 66 Hero và 8 encounter cuối chương, không thiếu dependency bắt buộc |
| UI selector | 52 checks: 1600×900, 2436×1125, 2400×1080, 1600×1200 và cutout; hai lượt sửa hình/layer có ảnh mới |
| Hit/pointer | GraphicRaycaster 8/8 đúng; click một lần, drag không chọn, close clear selection |
| World TCP | 3 peer, 130 assertions: cùng/khác map, join muộn, Passed cá nhân, stale request, minor/key, guard battle |
| Equip TCP | 11 ca, bao gồm rollback và reconnect |
| Lifecycle | 11 ca lỗi/hủy/retry loading, reset/generation/giới hạn pool |
| PvP TCP thật | 5v5, hai phía có input, 116 tick; digest `10896472758431214544` khớp hai peer/server/replay/.NET; Owned giữ nguyên |
| Archive cũ | .NET giữ kết quả V4/V5/V6/V7; core còn kiểm baseline cũ. Không có archive app V3 local cho lượt UI này |
| Replay trong Unity | 5 archive, 136 checks: tua tiến/lùi, pause, outcome, native actor, effect lease, UI text cleanup; không reward/unlock phiên mới |
| Farm tự nhiên | 154/154 ải, đủ 5 Tím sau **20.510 trận**, Player/Hero69; chỉ reward thật, key farm, nâng/ghép/mặc và chờ hợp lệ |
| Chơi lâu | **39 vòng / 1.205,61 giây**, 7.078 frame có summon, 2.011 lượt reuse FX; `Acceptance/validation.json` |
| Cleanup cuối | Một vòng thật/33 checks và replay UI có assertion mới; pool text active=0; console không có lỗi mới |

Bài 20 phút dùng account/server/port riêng và năm Hero triệu hồi Lv60/Tím làm fixture, luân phiên ba key encounter để tạo nhiều summon/ultimate/FX; không dùng fixture này làm bằng chứng farm. Nhóm đo trong Editor có cả server giữ replay và tài nguyên Editor: allocated 862,3–1.586,5 MiB, object 3.706–4.021 theo encounter; không quy các số này thành FPS/RAM trên iPhone. Bản sửa hit-area/selection và cleanup text cuối được kiểm lại có mục tiêu sau bài chơi lâu; chúng không đổi simulation hay đường pool FX đã stress.

## Dữ liệu, nguồn và giới hạn

- Đối chiếu trước/sau xác nhận encounter/reward/prerequisite/Evo/stat/recipe giữ nguyên ngoài field D38, config version Campaign và world layout/visual cần thiết. Save Owned, GUID/trang bị/hấp thụ, level/skill và archive thật không được dùng làm fixture hoặc reset.
- 99 loại drop, 81 có nguồn key; 18 chỉ ở minor nhưng 12 ghép được từ key. Sáu loại không có nguồn key/recipe từ key trong phiên (`axe_of_plunderer`, `brilliance_scroll`, `dragoncore_scroll`, `grandbow_scroll`, `harpy_eagle`, `satan_scroll`) không thuộc dependency đồ trước Tím của cả 66 Hero. Không tự bổ sung loot/recipe. Farm vẫn nặng: 90.844 thể lực và 348,93 ngày chờ mô phỏng; balance mới chưa được duyệt.
- Giữ các giới hạn D34: 15 cue thiếu file gốc, các cơ chế STR/AGI/INT đã hoãn và nội dung awake/shard/skin ngoài phạm vi. D38 không triển khai Elite/Raid, Guild/Tower logic hoặc save Campaign.
- Script resolver dùng `Unity/Assets/Crystal Legend/`. D38 dùng source/asset đã giải nén, không cần APK/ZIP download hoặc diagnostic bị ignore. Runtime art, mapping, config, source và test được bổ sung trong worktree; chưa commit/push, nên chưa có ở clone khác. `Artifacts/` chỉ giữ evidence/output, không phải đầu vào runtime duy nhất.
- Client/server phải cùng code/config D38 để hỗ trợ `world_chapter`, chapter gate và minor policy. Lượt này không cập nhật server Windows đang dùng hoặc cài app lên thiết bị.

## Build và bàn giao

Build root: `/Users/bloom/Desktop/Zatod Legend/Builds/D38/20261125-105521`.

- IPA: `/Users/bloom/Desktop/Zatod Legend/Builds/D38/20261125-105521/ZatodLegend-D38-unsigned.ipa` — 1,650,298,553 byte (1.54 GiB), **unsigned**, cho Sideloadly ký/cài.
- Unity export thành công, 0 lỗi/5 warning; Xcode Release arm64 BUILD SUCCEEDED với signing disabled.
- ZIP64/CRC toàn bộ đạt; app/plist/Bundle ID `com.zatodlegend.lantest`/iOS15/LAN/arm64 và hai binary chưa ký đạt. Không nhúng UnityRuntime.framework. Đối chiếu toàn bộ Unity Data export với product và đủ20 TextAsset đóng trong app.
- SHA256: `98068d3c555e1285b61e22e051f1f1dffd3482101da23d474de3df92fd664cec`. Bằng chứng: `unity-export.json`, `native-build.log`, `ipa-verification.json` trong build root.
- Editor cuối dừng Play Mode, server/client fixture đã tắt; không thay server Windows hay app thật. Source126 file C# và20 Data TextAsset trong workspace build khớp worktree trước export.

Giữ bản build cũ. Mặc định là IPA chưa ký cho Sideloadly; chưa ký/cài/chạy iPhone, không upload/publish. Windows/OPPO/iPhone runtime và FPS/RAM trên thiết bị còn chưa kiểm trong lượt này.
