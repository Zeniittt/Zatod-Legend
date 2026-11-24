# D35 — Theo dõi triển khai Skill/Promote

Ngày 24/11/2026, Asia/Saigon. **Code/UI và kiểm Editor đã hoàn tất; Unity export + native ARM64 build PASS, IPA đã đóng gói/kiểm thành công; chưa kiểm thiết bị.**

## Cập nhật tiếp quản 24/11/2026

Mục này thay trạng thái chờ Editor/dung lượng trong nhật ký cũ bên dưới.

- Giữ nguyên mọi thay đổi D35 của chat trước, reference tại Unity/Assets/Crystal Legend và Owned thật. Tiếp tục bản sao APFS Artifacts/D35BuildWorkspace/Unity đã chuẩn bị, không mở Editor trên kho raw.
- UI Skill sửa theo ảnh người dùng: bỏ illustration rail trong tab Skill; Hero idle giữa bốn vị trí skill; phía phải có tên, Intro/Details, mốc Evo, chi phí chỉ vàng và Lvl Up. Art lấy từ Crystal; 25 icon Tím/metadata chỉ để hiển thị khóa, không mở rank/content D34 hay thêm slot save. Base trở lại đúng khi đổi tab.
- Import-ZatodSkillUi.py tái tạo metadata bản dịch và art từ source đã giải nén. Presentation.txt là metadata UI; gameplay/cap/Gold/Evo vẫn từ config đã duyệt. Không nhập sách.
- Đã đọc evidence chat trước: editor-config.txt/editor-controls.txt PASS draft/save/read/stale/reference; network-ui.txt PASS TCP thật (bấm/giữ, vàng, retry/stale, QuickEquip/Promote/GUID, guards/reconnect, 25 Hero, đóng về roster). Các ca TCP toàn phần này là kết quả trước sửa bố cục, không nói đã chạy lại toàn bộ trong lần tiếp quản.
- Lần tiếp quản chạy lại CrystalChecks7.970 và HeroChecks112; Unity compile; SkillReferenceUi cho25Hero (Intro/Details khớp resolver, khóaPurple, Base restoration); ResponsiveUi125 kiểm bounds/text/state + ảnh4tỷlệ/safearea. Đã xem ảnh. Chưa kiểm Android/iPhone vật lý hoặc kiểm riêng hiệu ứng Evo bằng mắt trong combat.
- Console từ cursor64 có một lỗi lệnh công cụ `console read` không tồn tại; đã dùng `console get`. Không có lỗi gameplay/C# mới. Export thành công55,95s,0 lỗi/7warning. Xcode Release/iphoneos ARM64, signing disabled: BUILD SUCCEEDED.
- Export: `/Users/bloom/Desktop/Zatod Legend LAN Test/iOS/Xcode-20261124-125109`. Native log và gói: `/Users/bloom/Builds/Zatod-iOS/IPA-D35-20261124-1253/`. Editor đã thoát Play Mode, fixture TCP dừng; không cài/chạy thiết bị, không publish.
- Bản lưu trước chỉnh UI: `Artifacts/D35UiRestore/`; ảnh kiểm `Artifacts/D35BuildWorkspace/Evidence/UI/`. Artifacts bịGitignore và không tự theo clone. Người dùng yêu cầu đưa toàn bộ phase lên main ngày24/11/2026; bản commit gồm code, config, art, fixture và tài liệu. Artifact build/evidence local vẫn ngoàiGit.

- **IPA bàn giao:** `/Users/bloom/Builds/Zatod-iOS/IPA-D35-20261124-1253/ZatodLegend-SkillPromote-unsigned.ipa` (578,034,317 byte), SHA256 `1c69fad4d028dd2ae421d7267e4c3947dad08c9d369b5eac738480c1a753beb1`. ZIP CRC, bundle ID, ARM64 và UnityFramework PASS; codesign xác nhận app/framework chưa ký; không nhúng UnityRuntime. Chi tiết `verification.json` cùng folder. Build/check đã xong; chờ người dùng chơi thử, không khẳng định nghiệm thu thiết bị.

## Phạm vi và điểm khôi phục

- Người dùng đã giao thực thi D35 và xuất IPA chưa ký cho Sideloadly khi hoàn tất.
- Nhánh `codex/skill-promote-d35`, baseline sạch tại `3d774252d`.
- Giữ 25 Hero, 3 slot hiện hành mỗi Hero, rank tới Blue, 2 chương/39 ải. Chưa triển khai D34, Campaign persistence, sách nâng skill hoặc STR/AGI/INT.
- Source Crystal đã có đủ 96.077 file; các archive/diagnostic ngoài Git vẫn theo giới hạn phase-plan. Không chạy các importer cũ chỉ để thử đường dẫn.

## Tiến độ thực tế

- Đã đọc D35, phase-plan, reference, model/core/server/UI và REVIEW-002/008/009.
- Đã thêm config InitialLevel/cap/curve vàng, migration chỉ thêm slot thiếu, planner nâng level/Quick Equip và transaction Hero có receipt/revision/rollback; nối server/client pending-operation và GameEditor rules.
- Đã map 225 mốc/75 skill active trong `scripts/Import-ZatodSkillEvolution.py` và JSON coverage. Có schema/copy/validation/description, rules V4, snapshot dependencies và runtime hook. Kiểm tra ranh giới, replay toàn bộ 25 Hero, Coco và các hook đặc biệt đã qua core. **Chưa nghiệm thu combat/presentation trong Unity.** Slot Tím 75 mốc giữ reference.
- Runtime V4 giữ buff độc lập khi source không có Stack-and-Refresh, SF cộng dồn soul, SP shallowGrave giữ 1 HP ở cả đòn làm cạn shield, Fear di chuyển, Pugna gỡ control khi channel; không áp các thay đổi này cho replay rules V3.
- Có UI Skill/hold/QuickEquip/Promote và GameEditor fields. Đã copy 84 ảnh native khớp SHA256 nguồn, bake 5 effect/200 frame còn thiếu; `ZatodEvolutionArt.Prepare` sẽ import/slice/clip bằng Unity API. Helper này **chưa được chạy trong Editor**.
- Nâng ConfigVersion của 8 bảng Hero đồng bộ lên `zatod-skill-promote-1`; các bảng Campaign/World/Progression giữ version riêng. Items/Monsters/Stats/CraftRecipes/StarRules chỉ đổi version, không đổi nội dung gameplay.
- Còn thực hiện: import art/compile trong Editor; UI responsive và GameEditor draft/stale; network fixture trên profile/port riêng; kiểm console; export Xcode/native IPA. Không đánh dấu D35 hoàn tất.

## Kiểm tra

- `dotnet run --project Tests/HeroChecks/HeroChecks.csproj`: PASS 112 assertions sau sửa.
- `dotnet run --project Tests/CrystalChecks/CrystalChecks.csproj`: PASS 7.970 assertions sau sửa, gồm 600 oracle stat cases, 25 replay V3 goldens từ baseline, D35 migration/giao dịch/Evo/rules V4. Test bao gồm thêm slot thứ tư khóa, giữ level cũ >80 và chặn GUID thuộc Retired.
- D35 hook tests: Coco 34/35/49/50/69/70, hết hạn/đúng phe; SF soul/Fear; SP shield exhaustion; Pugna cleanse/charge; SNK dispel follow-up; Lion energy steal; NEC first-lethal/cooldown; QOP DOT heal; THD freeze/preview. Validation chặn enum/field/reference/cycle không hỗ trợ.
- Compile offline bằng đúng Roslyn/Unity 6000.6.2f1 references: PASS cả 5 assembly Heroes, Combat, HeroIntegration, Runtime, Editor. Logs ở `Artifacts/D35Compile/`. **Không coi đây là Editor/runtime QA.**
- Editor/import do agent mở đã đóng; không còn PID bị suspend. 100.004 file metadata mới, untracked dưới reference đã được sao lưu nguyên văn rồi xóa đúng danh sách. Source Crystal tracked không đổi; không xóa Library/Owned/old build. Xem REVIEW-015.
- Ổ còn khoảng 5 GB. Người dùng đã hủy phương án chuyển Crystal: thao tác git mv vừa hoàn tất đã được hoàn trả nguyên vẹn đủ 96.077 file, không đổi đường dẫn/Gitignore hoặc dọn cache trong lượt chuyển. Cần giải quyết dung lượng trước khi tiếp tục Editor/build. Chưa xuất Xcode/IPA, chưa cài/chạy thiết bị. Không dùng dữ liệu người chơi thật làm fixture.

## Ghi chú kỹ thuật để tiếp tục

- Config nâng skill đặt trong Skills.txt/SkillsConfigData.SkillProgression; HeroCatalogData giữ cùng field. Không có tiến trình Evo riêng trong save.
- Receipt tái dùng ItemOperations; Hero operation payload có expected skill level và account revision, kiểm receipt trước guard/stale; persist fail rollback đủ.
- Server đã nối 3 command skill_up/quick_equip/promote với receipt/revision; client giữ pending operation để retry/reconnect. Cần kiểm client-server thật sau khi Editor được mở lại.
- Tab Skill và nút chung QuickEquip/Promote đã nối, chưa có screenshot kiểm chứng các tỷ lệ màn hình. Không coi việc compile UI là nghiệm thu hình thức.
- Snapshot đã copy sâu Evo và dependency; rules V3/V4 tách hành vi. Goldens V3 có provenance ở `Tests/CrystalChecks/Fixtures/replays-v3/README.md`.
- `Tests/CrystalChecks.csproj` thực tế ở `Tests/CrystalChecks/CrystalChecks.csproj`; compile C# core qua .NET10.0.302.
- Không mở lại Unity trên nguyên trạng source raw khi chưa xử lý dung lượng: sẽ tạo lại metadata/cache. Người dùng đã chọn giữ reference ở vị trí hiện tại; không tự chuyển lại hoặc hỏi lại phương án vừa hủy.
- Sau khi giải quyết đầu vào: chạy `Zatod.Editor.ZatodEvolutionArt.Prepare()`; dùng existing project build helpers. Không dùng artifact iOS cũ làm bản D35.
