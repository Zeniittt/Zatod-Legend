# Zatod — Khảo sát View chọn đội Phó bản

Ngày 19/11/2026. Người dùng đã duyệt khảo sát và yêu cầu thực thi, làm rõ tiếp tục uGUI/Canvas với asset gốc, mô tả giữ tiếng Trung. Design.md D17/D18 là quyết định hiện hành. View đã hoàn thành kiểm tra Editor/server và Windows. Build cuối Succeeded/0 errors/0 warnings; executable thật kết nối và mở View hiển thị art/font thành công. BUG-022 đã xử lý và có guard chống tái diễn.

## Kết quả triển khai

- View prefab: `Unity/Assets/Zatod/Resources/Zatod/UI/Formation/ZatodFormationView.prefab`; runtime `Presentation/ZatodFormationView.cs`. Mở Phó bản, bấm ải để vào View, Battle mới gửi yêu cầu vào trận. Back giữ draft trong phiên, không thêm persistence.
- 77 file art/font được copy nguyên byte từ nguồn, có SHA256 và đường dẫn tại `Artifacts/ZatodFormationChecks/source-assets.json`. Hero/Monster có đủ 26 portrait; font Roboto native + DFYuan fallback cho tiếng Trung. Không đổi font toàn project.
- Khung lớn/khung panel, back nền+mũi tên, Battle+swords, tab, filter, selected mark, level background, rank frames, stars và bộ 5 ô đội hình là asset native. Power `?`; Cost/Rewards rỗng; Tutorial không có nội dung xử lý. Panel là các lớp sprite gốc, không dùng Image màu để giả khung.
- Background hiện dùng `battle_bg/bbg_spring_forest.jpg` gốc. Source UI cũ trỏ common/bg.jpg chưa tìm thấy trong bộ đã kiểm tra; không khẳng định backdrop giống từng pixel ảnh tham chiếu. Tutorial dùng icon sách native `fireforge/book_icon.png`. Hai lựa chọn art này có ghi nguồn trong manifest, không phải ảnh tự vẽ/crop screenshot.
- Click thêm/bỏ, tối đa 5 Hero, filter All/Ago/Middle/Rear giữ selection; 4 Hero trống ô trái. Hero bar trình bày từ hàng sau sang trước; danh sách gửi vào core vẫn giữ identity/order bản chọn, không đổi cách tính vị trí combat.
- Preview lấy đúng từng spawn/wave, kể cả quái lặp; frame bậc resolve từ encounter cùng công thức rank ban đầu của source. Wave preview không cho bỏ qua wave đầu khi Battle.
- Không thêm Hero vào ownership thật, không thay stamina/reward/power/rules/combat. Roster 37 Hero trong screenshot scroll chỉ là bản copy dùng kiểm tra UI, chưa từng gửi lên server.

## Bằng chứng kiểm tra

- `Artifacts/ZatodFormationChecks/view-live.json`: **PASS 365 checks**, preview đủ 18 ải/54 wave, filter/selected/back/Tutorial, empty/full team, 37-card scroll drag, raycast nút Battle, latch chống bấm lặp.
- Battle thật từ View mới: 5 Hero gốc, 4 Auto inputs, server checker xác nhận digest/kết quả. Owned Hero count/instance IDs giữ nguyên.
- `layout.json`: layout nằm trong viewport ở 1600×900, 1792×828, 2400×1080, 1440×1080. Screenshot live chính ở 1920×1080; không coi kiểm tra bounds là kiểm định ảnh ở mọi độ phân giải.
- Core cũ: **4.377 assertion PASS**, không đổi combat/rules trong lượt UI này.
- Ảnh `formation-final.png` và `formation-four.png` dùng roster thật 5 Hero. `formation-scroll-test-roster.png` dùng roster UI test riêng 37 Hero.
- Lỗi phát hiện/sửa: BUG-019 importer TMP hiểu nhầm khi glyph đã có; BUG-020 object menu chờ Destroy còn active trong frame; BUG-021 roster ngắn đổi sang dài bị restore scroll xuống đáy. ChangeLog.md ghi nguyên nhân và kiểm tra.
- Backup trước: `Artifacts/ZatodPhaseCheckpoints/20261119-before-formation-view/before.zip`. Runtime source và prefab chỉnh bằng C#/AssetDatabase/PrefabUtility, không hand-edit YAML/meta.

## Phạm vi từ ảnh và yêu cầu

View gồm back về chọn ải; preview từng wave với hai mũi tên; tab Squad/Tutorial (Tutorial chưa nối); grid Hero sở hữu cuộn dọc; filter All/Ago/Middle/Rear; 5 ô đội hình dưới, thiếu ô bên trái; lực chiến `?`; mô tả/cost/drop (chưa có thì trống); Battle bắt đầu trận. Mỗi ô Hero cần portrait/level/stars/rank thật. Không làm filter STR/AGI/INT/Preset.

## Đối chiếu project

- `Presentation/ZatodPrototypeView.cs::RenderMenu`: chọn Hero và ải chung một menu, click ải gọi connection.Campaign ngay. Cần thêm bước preview/chọn đội, không chỉ thay skin nút.
- `HeroData`: level/stars/rank/instance ID sẵn có, catalog lấy portrait/source và Position; `HeroPosition` Front/Middle/Rear. Năm Hero khởi đầu là Coco/DR/Lina/Zeus/Ench; 16 Hero là số định nghĩa, không phải số Hero đang sở hữu.
- `HeroFormation.cs`: capacity 5, toggle/filter sẵn có ở lớp dữ liệu. Runtime view mới cần chọn cách kết nối draft với session, không tự lưu selection vĩnh viễn vì phase này chỉ yêu cầu View.
- `CampaignDefinitions.cs`: Stage có Name/Description, cả 18 ải có Description nhưng hiện là CN. Không có cost/drop runtime fields. Lực chiến chưa có hàm/contract tổng hợp; PowerBasisPoints ở encounter legacy là hệ số độ khó, không phải team power.
- `WaveDefinition.cs`: từng wave có Enemies với spawn Id/DefinitionId/Kind/Level/Stars/RankId/EstimateRank; quái/Hero trùng loại có thể là nhiều spawn, không gộp thành một icon. Preview đọc dữ liệu encounter, không dùng HeroData sở hữu để đo level/sao/bậc địch.
- Spawn EstimateRank dùng công thức source trong `ZatodMatchFactory.Spawn`; RankId có thể rỗng. Khi làm preview cần cùng phép resolve bậc, tránh tự gán rank Hero sở hữu hoặc màu tùy ý. Core hiện xếp vị trí đầu trận bằng attack_range, tie SourceId; không sửa core để khớp thứ tự icon.
- `ZatodConnection.Campaign(stageId, heroes)` và server đã kiểm tra đội hình/quyền sở hữu/unlock; View mới nối lại luồng này, không thêm combat engine.

## Asset nguồn và mức xác minh

Root `Crystal Legend/recovered/assets/install_time_pack/remake/UI/alpha/1080P/`.

- Đã xác nhận trên đĩa bộ `battle/battle_prepare_*`: panel, enemy panel, filter states, team/icon/power backgrounds, các `9bg` frame.
- Đã xem ảnh `battle/battle_prepare_my_team_head.png`: bộ 5 ô đội hình trống đúng cấu trúc ref. Có thể giữ nguyên nền rồi đặt icon theo slot, không vẽ ô màu thay thế.
- Đã xem `common/battle_prepare_lift_but_1.png`: nền tab; còn các biến thể 2/3/4 và line pieces trên đĩa cần đối chiếu normal/selected/pressed.
- Đã xem `battle/battle_prepare_shai_xuan_but_1.png`: filter tròn; có states 2/3. Labels là nội dung thay đổi trên art, không phải yêu cầu dùng nút mặc định.
- `common/frame/hero_icon_frame_1..18.png`, hero_icon_bg và mask có sẵn; đã xem frame 4 màu Blue. Source `hero.lua::getIconFrameByRank`, `ui/readhero.lua::createIcon/addLevel/addFrame/addStars` là nguồn xác định cấu tạo và rank; dùng đúng frame, không chỉ đổi tint một khung chung.
- `common/backbtn.png` có trên đĩa nhưng biến thể vừa xem khác nút Back trong screenshot. Chưa kết luận tìm đúng toàn bộ biến thể ảnh. Cần map theo asset/source, không gán đại để báo đủ.
- Một số source Lua cũ còn trỏ HVGA như `prepare_go_battle.png`; chưa thấy file basename ấy trong `recovered/assets` đã tìm. Không kết luận cả bộ nguồn thiếu: còn mapping đường dẫn/bản UI mới/atlas cần đối chiếu. Nút Battle cần xác nhận art đúng trước khi dựng.
- Đã có 16 portrait Hero import trong Unity; cần bổ sung portrait Monster cho wave preview từ source. Chưa dùng ảnh screenshot crop hay ảnh tự vẽ thay nguồn.

Source hành vi tham chiếu: `ui_new/modules/battlePrepare/` (uiview, uireturn, uienterbattle, uichannel, uiheroselect, uiscrollbuttom), `ui_new/utils/BattlePrepareUITool.lua`, `battleprepareUiFun.lua`, `ui/readhero.lua`, `hero.lua`. Source tọa độ/biến thể có nhiều thế hệ; không khẳng định ảnh người dùng và APK giống từng pixel trước khi map xong.

## Tương tác đã được duyệt và triển khai

- Click Hero ở grid để thêm/bỏ; click Hero ở dải dưới để bỏ. Đội tối đa 5, không chọn lặp cùng instance; Battle chỉ khả dụng khi có 1–5 Hero và ải hợp lệ. Chưa được hiểu là luôn phải đủ 5.
- Giữ 5 ô cố định, 4 Hero → trống ô trái nhất, 3 → trống 2 ô trái; đổi filter chỉ lọc roster hiển thị, giữ selection.
- Mũi tên dừng ở đầu/cuối, preview 1/N từ Waves.Count; không hardcode luôn 3 dù chương hiện tại có 3 wave/ải. Không bọc vòng nếu chưa có yêu cầu.
- Giữ selection/scroll khi đổi wave; back về map có thể giữ draft trong session; không ghi save/progression mới.
- Scroll viewport có clipping, kéo không bị hiểu thành click chọn Hero. Test với roster thử trong bộ kiểm tra riêng để có nhiều hàng, không tự cấp Hero vào profile người dùng.
- Bộ khung/UI phải co giãn đúng tỉ lệ reference; hỗ trợ 16:9 và các tỉ lệ ngang khác bằng anchor/mask, không kéo méo portrait hay cắt nút Battle.
- UI asset và framework là hai lớp. Người dùng đã làm rõ dùng uGUI/Canvas để ghép asset game; không dùng control màu tạm. Framework đã chốt theo D17.

## Phần không tự mở rộng

Không cấp thêm Hero, thêm stamina/reward/economy/combat power, persist đội hình/progress mới, Tutorial content, Preset, kéo sắp xếp Hero, hoặc sửa timing/đội hình core. Mô tả giữ nguyên tiếng Trung theo chốt sau khảo sát; phần chưa có dữ liệu để trống như yêu cầu, không bịa mô tả/drop/cost.

## Bàn giao hoàn tất

- Build Windows `Builds/ZatodPrototype/ZatodLegend.exe`: **Succeeded, 0 errors, 0 warnings** ở lượt cuối; báo cáo `Artifacts/ZatodFormationChecks/build.json`.
- Executable thật đã kết nối server 7788, click Ải 1 mở đúng View chọn đội với 5 Hero, đầy đủ portrait/khung/sao/level và mô tả CN. Đã quan sát trực tiếp cửa sổ game; log `standalone-client.log` không có exception/missing-glyph. Client test profile riêng đã đóng, không cấp roster test vào dữ liệu sở hữu.
- Server **PID49516**, TCP **7788**, data `Artifacts/ZatodServer`, log có READY. Dữ liệu Owned/archive cũ không bị reset.
- Editor người dùng vẫn mở, ready, Play stopped, auto-tick override đã tắt. Không mở Editor batchmode thứ hai.
- BUG-022: người dùng và CUA xác nhận hộp thoại Scene(s) Have Been Modified. Đã Save; scene trên đĩa giống checkpoint trước. Build đầu sau Save đếm 1 lỗi do lệnh chẩn đoán không tồn tại, giữ riêng lịch sử; build lại cuối 0/0. Dirty-scene guard PASS, giúp báo rõ scene cần lưu trước khi mở BuildPipeline.
- Console history giữ lỗi chẩn đoán CommandNotFound (seq179), không clear. Không có compile/runtime error mới sau xử lý; groundTruth cuối consoleErrors=0.
- Checkpoint source hiện hành: `Artifacts/ZatodPhaseCheckpoints/20261119-formation-view/source.zip`, manifest và SHA256. Có Editor guard, prefab/art/font mới và báo cáo; không nhân đôi toàn bộ build 6,6 GB hay nguồn APK.

## Cập nhật20/11/2026 — D20

Đã nối popup preview trước chọn đội; Back từ chọn đội về popup, X về map. Cost và Reward icon lấy config đã hiển thị. Server snapshot có sao từng ải, UI/checker/reset phiên mới đã kiểm tra;766 UI checks và core4.431 PASS. Build mới0 lỗi/2 cảnh báo có sẵn; server thường PID5580 READY7788. Xem [báo cáo triển khai D20](zatod-stage-preview-implementation.md). Các ghi chú trước mục này là lịch sử D18.
