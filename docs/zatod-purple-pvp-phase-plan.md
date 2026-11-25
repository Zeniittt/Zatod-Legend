# D34 — Kế hoạch triển khai và nghiệm thu

Ngày 24/11/2026 (Asia/Saigon). Thiết kế hiện hành nằm ở [D34](../Design.md#d34--mở-rộng-tới-tím-và-danh-sách-hero-pvp-riêng). Người dùng đã giao triển khai và tạo IPA chưa ký. Baseline D35 là `0085e337c`, quyết định sau pull ở `871fa5b2c`.

- [x] Cố định fixture V4 trước khi thêm rules V5. Kiểm lại 25 replay V3, replay V4 có tác động Evo và V5 có chuyển wave.
- [x] Xác định đường authoring và mapping cho nội dung mở rộng từ đầu vào được phép, tái lập từ Git. Thư mục Artifacts giữ kết quả kiểm tra.
- [x] Làm một đường hoàn chỉnh qua chương 3, bậc mới, skill mới và PvP độc lập. Kiểm save bằng fixture riêng và giữ GUID, món đã hấp thụ và level skill cũ.
- [x] Mở Blue+1, Blue+2, Tím thường, trang bị, recipe và đường farm. Kiểm 25 skill thứ tư, 15 Hero mới, 4 skill chính mỗi Hero và các Evo trong cap 80. Bao gồm các phụ thuộc cần thiết như triệu hồi, phân thân, aura, buff và projectile. Giữ stat trực tiếp theo D05.
- [x] Mở thêm 6 world map và 115 ải/345 wave. Kiểm map/portal/return context, preview, encounter và GameEditor. Giữ D11. Áp dụng D26 cho loot mới, dùng MaxDropAmount 5 và tỉ lệ đều trong từng pool mới theo phương án đã trình. Ghi lại đường farm từ account mới và năm Hero đầu, gồm điều kiện cấp, nguồn đồ, Gold, thể lực và vòng phụ thuộc.
- [x] PvP realtime có pool miễn phí 40 Hero và kiểm danh sách hợp lệ từ server. Preset cấp 60, ba sao, Tím thường, ô Tím trống, bốn skill chính cấp 60. Giữ đội tối đa năm Hero. Kiểm queue, cancel, trận, replay và tính độc lập với HeroDesk/Arena/Campaign.
- [x] Kiểm combat từ simulation đến hình ảnh và âm thanh. Gồm manual ultimate, HP nổi, portrait, Damaged, buff/effect layers, số combat, audio, chuyển wave/kết thúc, death/fade. Kiểm seek/pause/x4, caster chết/bị ngắt, hai phía PvP, tỷ lệ màn hình và safe area.
- [x] Kiểm core, Unity, network và các ca thiết bị có thể chạy. Xuất và xác minh IPA arm64 chưa ký theo D37. Ghi bằng chứng kiểm tra, giới hạn thiết bị, vị trí IPA và đầu vào cần chuyển giao.

Đã hoàn tất/kích hoạt nội dung và các kiểm theo checklist; IPA cuối arm64 unsigned đã kiểm. Bằng chứng, chi phí farm nặng,15audio vắng source và giới hạn thiết bị ở [báo cáo D34](zatod-purple-pvp-implementation.md). Dấu hoàn tất không có nghĩa đã mở cơ chế thuộc tính chính/awake/shard/skin hoặc đã chạy trên thiết bị không có trong lượt kiểm.

## Kiểm bản nháp nội dung

Chạy từ root repo. Lấy thư mục Data nền bằng `git archive` hoặc từ checkout của commit đã duyệt. Thư mục Data bản nháp cần chứa các bảng config và thư mục `WorldMaps/` được `Worlds.txt` tham chiếu.

```sh
dotnet run --project Tests/CrystalChecks/CrystalChecks.csproj -- \
  --d34-content-preflight "<baseline Data>" "<candidate Data>"
```

Lệnh đọc hai thư mục và in kết quả ra stdout. Validator kiểm config và các tham chiếu liên bảng, ID và slot hiện có, alias legacy, cửa vào ải, đường portal và loot ải mới. Lỗi trả mã thoát khác 0. Số đếm cho biết độ phủ cấu trúc của bản nháp, ví dụ số Hero cũ có đủ bốn skill ở Tím và số Hero được bật trong PvP. Tài nguyên Unity, skill cụ thể, đường farm thực tế và độ khó vẫn cần nghiệm thu theo checklist.

Sau khi import Data và Resources vào workspace kiểm, chạy Unity Pipeline ở Edit Mode với file `Tests/Unity/D34ResourceAudit.cs`, entry `D34ResourceAudit.Run` và đường dẫn báo cáo JSON. Kiểm danh sách tài nguyên thiếu và các ải dùng icon dự phòng. Kiểm portrait trên màn replay bằng entry `D34ResourceAudit.VerifyPortraitReplays` trong Play Mode ở workspace cô lập `Artifacts/D35BuildWorkspace`.

Xem [báo cáo triển khai](zatod-purple-pvp-implementation.md) để biết phần hệ thống đã được kiểm, các giới hạn và đầu ra.

## Mốc lịch sử: import art Hero — 24/11/2026

`Import-ZatodD34Heroes.py` đọc reference hiện hành và alias từ `ZatodContentIds.cs`, giữ nguyên các dòng cũ/Evo/skill progression rồi sinh một thư mục Data mới. Không chạy importer cũ hoặc ghi config active/Owned. Đầu ra gồm 40 Hero/160 slot/rank 1–7, 228 item, 231 skill, 94 buff và 103 recipe; Campaign vẫn hai chương. Manifest có hash đầu vào, art cần copy và 85 skill/255 mốc Evo chờ port. Không bật roster PvP chỉ từ việc nhập đủ Definition.

```sh
python3 -B scripts/Import-ZatodD34Heroes.py --output Artifacts/D34HeroImport/Data
python3 -B -m unittest discover -s Tests -p test_d34_hero_import.py
dotnet run --project Tests/CrystalChecks/CrystalChecks.csproj -- \
  --d34-content-preflight Unity/Assets/Zatod/Resources/Data Artifacts/D34HeroImport/Data
python3 -B scripts/Bake-CrystalAnimations.py --data Artifacts/D34HeroImport/Data \
  --only razor wr cm naga sg th od ursa sil luna vs pom huskar lich kotl \
  --missing-only --report Artifacts/D34HeroImport/animation-bake.json
```

Thư mục output phải mới/rỗng; chọn tên mới khi chạy lại. Manifest nguồn rút gọn tại `docs/reference/zatod-d34-hero-import.json` đi theo Git. Bộ bake giữ FPS/pivot/rect/timeline; importer Editor dùng `ZatodHeroImportArt.PrepareNativeArt(manifestPath, repositoryRoot)` và `ZatodEvolutionArt.ImportBakedResource(resource, true)`. Kiểm thật bằng `Tests/Unity/D34HeroImport.cs` trong workspace cô lập, không đưa bản nháp chưa port hook vào config active. Các nhánh STR/AGI/INT đã tạm hoãn vẫn theo D34.

Kết quả mốc art: 15 Hero/162 action/5.657 frame, 18.565 kiểm tra tài nguyên và 486 mẫu sprite đạt; có IPA ARM64 unsigned với catalog active 25 Hero. Ở mốc art lịch sử này, bản nháp40 chưa kích hoạt; các hạng mục đó đã được hoàn tất ở kết quả cuối bên dưới. Chi tiết tại báo cáo triển khai, REVIEW-024 và `Artifacts/D34HeroImport/handoff.json`. File mới chưa commit/push.

## Kết quả cuối

Catalog active66Hero/40free,42Monster,154ải/462wave/9map;264main skill/792Evo. Native3.017,legacy8.051,Hero112,Python6; Unity/TCP/cross-runtime/farm đều đạt trong phạm vi đã nêu. Hai lượt farm clear154 và5Tím; bot lùi ải22.286trận. [Manifest active](reference/zatod-d34-content.json) giữ đầu vào/hash/mapping; baseline14Data đi theoTests/Fixtures/D34Baseline. IPA cuối `/Users/bloom/Desktop/Zatod Legend/Builds/D34Complete/20261124-v7-3b14df41db3fe55e/ZatodLegend-D34Complete-unsigned.ipa`,unsigned1,50GiB,ZIP64/CRC/20TextAsset/arm64/plist/LAN đã kiểm. BalanceNormal/recoveryrấtnặng và15cuevắngsourceđượcghirõ; không tựthayquyếtđịnh. Chưa cài/chạy thiếtbị hoặc đồngbộPC/commit/push.
