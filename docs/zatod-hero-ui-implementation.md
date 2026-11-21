# Zatod — Hero UI và responsive

Ngày 20/11/2026; D22/D23. Đã triển khai, kiểm tra Editor/Simulator và build Windows thành công. Không thêm package hoặc nâng Unity.

## Phần đã làm

- Menu Task/Hero/Inventory góc trái dưới world, thu/mở, không red dot. Hero và NPC Hero mở danh sách mới; Task/Inventory chỉ có hình thức.
- List of Heroes đọc HeroDesk sở hữu, không cấp thêm Hero. Filter All/Front/Mid/Rear, cuộn dọc, portrait/khung bậc/level/sao/tên thật, Astrolabe khóa và sáu ô đồ theo bậc. Bỏ STR/AGI/INT, Follow và ô đặc biệt chưa thuộc scope.
- Detail Base dùng tranh nguồn riêng của từng Hero và Idle từ AnimationSet chiến đấu, không dùng avatar world. Khung/tên bậc, sáu ô đồ, level/sao thật, scroll stats từ HeroStatCalculator.PreciseStats. Scale Idle theo bounds gốc, không đổi clip/timeline chiến đấu.
- Ô đã mặc dùng ItemId thật của instance, kể cả khi recipe mới khác; có loại yêu cầu trong kho thì dấu cộng; thiếu thì trống. Ô item/dấu cộng và Quick Equip không gửi thao tác mặc. Giữ API và công cụ dev cũ.
- Diamond/gold/stamina/power: `??`; EXP: HeroData.Exp / `??`; shard: `?? / ??`. Skill/Astrolabe/Skin, Lvl Up/Star Up/cộng tài nguyên chưa có handler.
- Detail X về list, list Back về đúng map/vị trí; giữ filter/scroll trong phiên. Mở Hero UI khóa điều khiển world.

## Responsive

- ZatodSafeAreaRoot tính anchors theo Screen.safeArea, giới hạn trong Canvas, cập nhật khi thay size. Đã đo được Simulator giữ safe area của2436×1125 khi Game View đổi1920×1080; clamp tránh anchors vượt1.
- Hero UI dùng khối co giãn; header thành hai hàng khi vùng ngang hẹp, grid có thể thành một cột khi cần. Các tỷ lệ nghiệm thu vẫn hai cột như ref.
- ZatodFullScreenArt cover/crop nền theo tỷ lệ gốc ra toàn Canvas; tương tác trong safe area. Giữ tỷ lệ tranh/portrait.
- World HUD neo Town/Menu/banner/interaction/menu dưới theo góc/cạnh. Các màn phát triển cũ dùng ZatodResponsiveLayout trong safe area. Formation/StagePreview giữ Fit hiện có, nhận kích thước safe area; nền formation phủ toàn màn hình.
- Battlefield và floating text cùng khung1600×900 fit trong safe area, giữ hệ tọa độ Hero/projectile/chain/text. Không đổi core8Hz, damage, vận tốc, va chạm, input/checker hoặc save. Seek replay co theo chiều rộng.

## Art và file

- scripts/Prepare-ZatodHeroUi.py nhập151 ảnh audit SHA256, gồm25 tranh và đủ76 icon item. Không sửa nguồn ngoài Unity; Artifacts/ZatodHeroUiChecks/native-art.json.
- Prefab ở Unity/Assets/Zatod/Resources/Zatod/UI/Hero/: ZatodHeroRosterView.prefab và ZatodHeroDetailView.prefab. Image/TMP/ScrollRect là hierarchy có thể xem trong Editor; cell/row dựng từ dữ liệu khi mở View.
- Controller Presentation/ZatodHeroRosterView.cs, ZatodHeroDetailView.cs, ZatodHeroUi.cs, ZatodHeroIntegration.cs. Tích hợp ở ZatodPrototypeView.cs/ZatodWorldIntegration.cs/ZatodWorldView.cs; responsive ở ZatodSafeAreaRoot.cs, ZatodResponsiveLayout.cs, ZatodFullScreenArt.cs.
- Builder lặp lại: Unity/AgentScripts/ImportZatodHeroUi.cs; author prefab trong additive scene và dọn bằng finally, không sửa scene gameplay.
- Restore trước thay đổi: Unity/Temp/restore/hero-ui-20261120/before.zip. Không stash/reset thay đổi sẵn có.

## Kiểm chứng

- Play mode tiến frame thật trước đọc/capture; server riêng TCP17993, data Artifacts/ZatodHeroUiChecks/Server, profile test riêng.
- ReviewZatodHeroUi.Matrix:331 assertions PASS ở1920×1080,1600×1200,2436×1125,2400×1080,2520×1080, thay size khi View mở. Cutout trái/phải và bottom bằng anchors test, trả component native sau test. Kiểm tra bounds, filter, scroll dài mock25 Hero,25 tranh/76 icon, ba trạng thái đồ, stats, no-op và không đổi dữ liệu.
- ReviewZatodHeroUi.Flows:106 assertions PASS: world HUD, preview/chọn đội, Back/Challenge, Arena/PvP/history/dev đồ ở4:3 và21:9; Battle start/tiến tick, bounds Auto/hero bar/battlefield/floating.
- ReviewZatodHeroUi.NativeSafeArea:9 assertions PASS với Screen.safeArea của Unity Simulator ở2436×1125: x132,y63,width2172,height1062. Chưa thử điện thoại vật lý.
- Tổng446 assertions; JSON/ảnh ở Artifacts/ZatodHeroUiChecks/live/. pass1-roster trước chỉnh panel/callback; ảnh matrix/native-safe/flow cuối sau sửa. Review nhiều lượt: callback/panel, full-bleed/safe area, scale Idle/battlefield.
- Phó bản test validate263 tick,4 input,digest5691959244112859857; archive và dòng VALIDATED ở Server/server.log. Core không thay đổi.
- data-integrity.json:151 ảnh byte-identical,8 file Owned hiện có giữ SHA256. Không migration/reset tài khoản cũ.
- Console cuối trước build: compilationFailed=false, consoleErrors=0, không error mới sau cursor5. Giữ lịch sử lỗi, không console clear.

## Nguồn quy trình đã đọc

Skills create-ui/uGUI/visual-design/scrollview, unity-cli/playmode verification, unity-pipeline; docs package đang cài: UICanvas, CanvasScaler/MultiResolution, UIBasicLayout/RectTransform, AutoLayout/GridLayoutGroup, ScrollRect, SafeArea; Pipeline scripts/capture/editor lifecycle/build. API theo Unity6000.6.2f1 hiện có.

## Bàn giao

- Windows build Succeeded,193.838 giây,0 lỗi/2 warning cũ: ArenaView dùng FindFirstObjectByType đã obsolete và shader TMP dùng pragma debug cũ. Không sửa hai phần ngoài scope. BuildReport: Artifacts/ZatodHeroUiChecks/build.json; executable Builds/ZatodPrototype/ZatodLegend.exe.
- Editor stopped, auto-tick=false, scene ZatodPrototype.unity sạch/không dirty. Đã xóa23 preset Zatod Review do test tạo và trả selected size ban đầu; không sửa preset người dùng. Server test PID55800/TCP17993 đã tắt; không tự mở server7788.
- Console cuối sau build: compilationFailed=false, consoleErrors=0; không error mới sau cursor14. Cách mở/test: docs/zatod-prototype-play.md. Preview/mặc item thuộc phase tiếp theo.
