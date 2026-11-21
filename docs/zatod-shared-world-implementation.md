# Zatod shared world — D21

Ngày20/11/2026. Đã hoàn tất triển khai/nghiệm thu phạm vi D21; các giới hạn prototype được ghi rõ dưới đây.

## Phạm vi

Town dùng Grass tạm; chapter_one đồng cỏ, chapter_two rừng Undead. Các map dùng layout2D độc lập với tọa độ chiến trường. Chapter.WorldMapId liên kết map; điểm ải dùng StageId. World không thêm HeroData/stats/skill cho avatar.

Unit visual, background, NPC và building nằm trong gói TreasureHunter_Export_2026-11-20. Gói đã import nguyên metadata; wrapper Zatod ở Assets/Zatod/Resources/Zatod/World/Visuals. Script MMO giữ nguyên trong ZIP, không compile vào game. BUG-027 bổ sung đúng shader include từ project nguồn.

## Runtime

- Giữ Mirror/Telepathy và kết nối account/combat hiện có. Server quản lý map membership và revision; chỉ gửi snapshot những người cùng map. Không ServerChangeScene toàn server.
- Di chuyển avatar cosmetic do chủ client tính theo render frame, chuẩn hóa đường chéo, giới hạn map và trượt quanh vùng chân building/cây. Gửi pose20Hz, snapshot10Hz, remote interpolation. Server kiểm tra pose hữu hạn/map revision và clamp bounds. Chưa triển khai xác thực đường đi/tốc độ/navigation chống gian lận; không gọi lớp này là server authoritative movement.
- Cổng qua lại không khóa theo progress. Sao/quyền mở ải vẫn thuộc CampaignRun từng tài khoản; Challenge của ải khóa bị disable và server vẫn kiểm tra prerequisite khi bắt đầu.
- Modal preview/chọn đội khóa input avatar. Trận riêng giữ nguyên map/pose; ẩn world khi đánh và trở lại đúng nơi khi tiếp tục/thoát trận.
- Chưa lưu map/pose qua đăng nhập; kết nối mới vào Town. Không đổi quy tắc reset Campaign theo launch, kho GUID hoặc archive.
- Clan/Lost Tower chỉ có điểm tương tác và placeholder. Arena/PvP/Hero mở feature đã có.

## Dữ liệu

Catalog sau mở rộng:25 Hero/14 Monster/76 item/131 skill/52 buff/27 stat. Hai chương18+21 ải,54+63=117 wave. Không tự cấp9 Hero mới vào roster sở hữu. Drop preview giữ tỷ lệ100% theo D19, không roll/cấp thưởng; Cost lấy Crystal. Ngoại lệ20555 vẫn giữ do ngoài phạm vi trang bị/level81.

Worlds.txt chứa bounds/spawn/prop/interaction. Đây là layout prototype, chỉnh được vị trí, art, bán kính và vùng chân trong JSON. GameEditor Campaign vẫn chỉnh được chapter/stage/wave/hook/difficulty; không tự đổi Stage.MapX/MapY UI thành world coordinate.

Pipeline:

1. scripts/Import-ZatodChapterTwo.py mở rộng canonical config mà giữ các định nghĩa/ID cũ. Full Import-CrystalConfig.py khi Worlds.txt có mặt cũng gọi lại bước này để không mất chương2.
2. scripts/Prepare-ZatodWorld.py tạo layout mẫu và copy portrait/drop icon native; chạy lại sẽ tạo lại layout mẫu, không dùng để lưu tay layout custom.
3. Bake-CrystalAnimations.py --missing-only và Bake-CrystalEffects.py giữ bản bake cũ; ImportCrystalSpriteBatch.cs chỉ nhập manifest chưa có evidence.
4. ImportZatodWorld.cs tạo wrapper, sprite/icon và font. UI mới ghép đúng Crystal art qua uGUI; world dùng visual Treasure Hunter được cung cấp.

## Bằng chứng hiện có

- Restore point trước D21: Artifacts/ZatodWorldChecks/before/source.zip (120 file, sao từ Temp sang nơi bền vững).
- Chapter2 import report: Artifacts/ZatodWorldChecks/chapter-two-import.json.
- Core: CrystalChecks4.740 assertions PASS, gồm39 ải/replay/checker, portal graph và geometry world. Đây chưa phải chứng nhận parity mọi custom Hero hook với source Crystal.
- Native animation:13 character mới,3.929 frame; effect bake tổng107 resource. Đã kiểm định146 resource/13.801 sprite/521 clip PASS (geometry/pivot/FPS/loop/action).750 texture,207 sheet mới áp Standalone BC7/4096.
- Hai audio tham chiếu mới thiếu trong nguồn: TANKGLOBAL_ATK.mp3, TANKGLOBAL_DEATH.mp3; giữ báo cáo static-art-audio.json, không thay bằng sound giả.
- Hai client world: network-20261120-134622/results.txt PASS peer movement/map isolation/chapter1/chapter2/private battle. Client phải map giống nhau mới nhận snapshot cùng nhau.
- Hồi quy3 mode: Artifacts/ZatodPhaseChecks/network-20261120-134724/results.txt PASS, PvP cùng digest2245283970019442502/9 input, relaunch giữ24 cặp GUID/type.
- UI live: Artifacts/ZatodWorldChecks/live/first-pass.json PASS48 checks/357 moving frames; lượt cuối result.json PASS131 checks/301 moving frames và287 remote interpolation frames. Đã quan sát avatar peer có SpriteRenderer thật. Toàn bộ flow NPC → preview → formation → battle3 sao → return đúng map/pose → chapter2/locked challenge → close đã qua.
- Đã xem ảnh03/04/07, sửa sorting/material/camera/title theo BUG-033..035. Layout vẫn là prototype tạm theo phạm vi được duyệt.
- Build cuối Succeeded/0 errors/2 warnings có sẵn,345,77 giây; Artifacts/ZatodWorldChecks/build.json. Bản đầu có3 warnings, warning biến test không dùng đã bỏ. Hai cảnh báo còn lại thuộc ArenaView API obsolete và TMP shader pragma đã có.


## Bàn giao cuối

- Executable cuối được kiểm tra lại bằng hai client: Artifacts/ZatodWorldChecks/network-20261120-142546/results.txt PASS, private-battle digest17909688523871435903. Không dùng kết quả Editor thay cho phép kiểm tra executable này.
- Server test/peer đã dừng. Server thường PID24584 READY TCP7788, dữ liệu Artifacts/ZatodServer;7 file Owned giữ nguyên SHA256 (normal-owned-before.json/normal-owned-after.json). Chưa có client test nào ghi vào kho người dùng ở thư mục thường.
- Editor stopped/auto-tick=false, override background đã gỡ (projectValue=true). Console groundTruth consoleErrors=0, compilationFailed=false, compiling=false; captured log vẫn giữ lịch sử lỗi. final-editor-log-check.json xác nhận không có4 nhóm exception/disconnect đã gặp sau marker Play cuối.
- Mở scene Assets/Zatod/Scenes/ZatodPrototype.unity, Play → Kết nối → Town. WASD/mũi tên; tới Campaign → map1; tới điểmải → popup → Challenge → chọn đội → Battle. Cổng Chapter2 ở cuối map1; cổng quay lại/map Town luôn mở. Quyền Challenge vẫn theo progress riêng, không tự mở39 ải vì đi được tới map2.
- Mô hình/chương/wave đầy đủ theo metadata nguồn trong phạm vi này; test deterministic/checker không phải chứng minh tương đương từng hook Lua/native/RNG của Crystal. Custom behavior mở rộng của các Hero, thức tỉnh và hệ thống ngoài D21 vẫn cần review theo từng feature; không đánh đồng việc có config với đã reverse toàn bộ backend/game gốc.
- Nguồn quy trình Unity đã đọc: unity-cli.md, integration-advanced.md, playmode-verification-loop.md; source InputSettings/InputState/InputSystem của package hiện cài. Không dùng screenshot làm bằng chứng frame chạy: đã kiểm tra frame advance trước cả hai phiên UI cuối.
