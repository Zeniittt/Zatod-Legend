# Chơi thử Zatod Legend prototype

Scene mới: `Unity/Assets/Zatod/Scenes/ZatodPrototype.unity`. Menu build: **Zatod > Tools > Build Windows Prototype**. Bản Windows ở `Builds/ZatodPrototype/ZatodLegend.exe`.

Cập nhật21/11/2026: mở/chạy **ZatodPrototype** làm scene chính. Game tự nạp **ZatodBattle** additive khi vào Phó bản/Arena/PvP/replay, dùng renderer2D cho chiến trường và Canvas cho HUD; không cần tự mở scene Battle để chơi.

Town/chương1/chương2 cùng tồn tại khi world được khởi tạo. Qua portal chỉ teleport player/camera, giữ các đảo. Xem các root `ZatodMap_*` trong Hierarchy sau khi Play; chưa có map preview Edit Mode mới. Config độc lập nằm tại `Unity/Assets/Zatod/Resources/Data/WorldMaps/town.txt`, `chapter_one.txt`, `chapter_two.txt`; `Worlds.txt` là index. Origin là vị trí đảo trong world; bố trí bên trong dùng local coordinates. Báo cáo: [world/battle phase](zatod-world-battle-implementation.md).

Từ thư mục project, chạy server trước:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\Start-ZatodServer.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\Start-ZatodClient.ps1 -Profile player1
```

Bấm **Kết nối** trong game để xuất hiện tại **Town**. Di chuyển bằng **Fixed joystick ở vùng dưới trái** (kéo bằng chuột khi test Windows). **WASD/phím mũi tên chỉ dùng trong Unity Editor**. Lại gần NPC/building để hiện nút tương tác, đi xa nút tự ẩn. Điểm **Campaign** đưa tới map chương1; cổng cuối map qua chương2 (Undead Forest), có thể đi lại tự do. Điểm ải mở preview → Challenge → chọn đội → Battle; kết thúc trận về đúng vị trí trên map. Clan/Lost Tower là placeholder. Arena/PvP/Hero có NPC ở Town hoặc mở qua nút Menu. Để thử PvP trên cùng máy, mở client thứ hai bằng profile khác:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\Start-ZatodClient.ps1 -Profile player2
```

Chọn đội rồi bấm **PvP online > Tìm trận** ở cả hai client. Server mặc định dùng TCP/Telepathy cổng 7788. Trên máy khác, truyền `-Server <địa chỉ server>` và dùng profile khác. Trong Unity Editor, đặt `DevelopmentProfile` trên ZatodConnection trước khi kết nối nếu muốn tách tài khoản thử nghiệm.

Các lệnh trên dùng execution policy riêng cho process PowerShell chạy script, để tránh lỗi máy đang chặn `.ps1`; không đổi policy vĩnh viễn. Server chạy nền, chỉ mở một lần. Kiểm tra `Get-Content .\Artifacts\ZatodServer\server.log -Tail 10`, chờ dòng `READY port=7788` rồi kết nối. Server không tự tắt khi đóng cửa sổ PowerShell; PID được in khi khởi động, dùng `Stop-Process -Id <PID đó>` để tắt lúc không còn trận đang chạy. Lịch sử lỗi/workaround: [ChangeLog.md](../ChangeLog.md).

## Menu Hero mới (20/11/2026)

Ở góc phải dưới Town/map có Task, Hero, Inventory và mũi tên thu/mở; joystick Fixed nằm ở vùng dưới trái. Bấm **Hero** → List of Heroes → bấm một Hero để mở **Base**. Dùng All/Front/Mid/Rear, cuộn danh sách và cuộn Hero Stats. X của detail về danh sách; Back của danh sách về đúng map/vị trí. Khi View Hero mở, WASD bị khóa.

Ô trang bị hiển thị item thật đã mặc, dấu cộng nếu kho có loại yêu cầu, hoặc trống nếu chưa có. Ô item/dấu cộng và Quick Equip chưa có hành động. Task/Inventory, tab ngoài Base, Lvl Up/Star Up và cộng tài nguyên cũng chưa nối logic. Diamond/gold/stamina/power là ??; EXP dùng giá trị hiện có/ngưỡng ??; shard là ??/??.

Công cụ cấp item/mặc/tiến bậc cũ vẫn ở **Menu → Hero / Đồ**; menu Hero mới không gửi lệnh mặc. Game hỗ trợ bố cục ngang với safe area; không xây layout portrait. Báo cáo triển khai: [zatod-hero-ui-implementation.md](zatod-hero-ui-implementation.md).

## Các luồng trong phase

- **Phó bản**: chọn ải đã mở để xem popup tên/mô tả, sao thật, Cost, địch wave cuối/Boss và Reward. Bấm **Challenge** để vào View chọn đội; bấm portrait để thêm/bỏ 1–5 Hero, dùng All/Ago/Middle/Rear hoặc cuộn roster, xem địch từng wave bằng mũi tên; bấm **Battle** mới bắt đầu trận. Back về popup preview; X đóng về chọn ải. Tutorial và Raid chưa có xử lý; Raid khóa dưới3 sao, số vé/Daily Attempts là ?. Trong trận, bấm chân dung Hero khi đầy năng lượng để dùng ultimate, hoặc bật AUTO. Auto gửi thao tác hợp lệ, được ghi vào nhật ký và kiểm tra trên server như bấm tay. Client mô phỏng, gửi input/cuối trận để checker server chạy lại. Chỉ kết quả được validate mới mở ải tiếp theo.
- **Arena**: chọn đội, bắt đầu; xem replay từ dữ liệu đầu trận/seed/input. Đội đối thủ prototype dùng năm Hero khởi đầu ở level tương ứng, chưa có ranked/MMR.
- **PvP online**: hai client online gửi operation theo tick 8 Hz. Sau năm tick đầu, server chờ operation của cả hai phía, rồi chuyển cùng batch cho hai client chạy core. Giữ ưu tiên host cho manual cast cùng tick theo phần client Crystal đã đọc. Envelope rỗng đến muộn trong đúng năm tick implicit được bỏ qua; input gameplay gửi vào tick đã qua vẫn bị từ chối. Transport dùng Mirror TCP; không giả định backend Crystal gốc cũng triển khai như server prototype này. Mất kết nối/hủy trận kết thúc thử nghiệm mà không ghi kết quả thắng thua.
- **Replay**: mở bản ghi từ danh sách; phát/tạm dừng, tốc độ 1/2/4 và kéo thanh để chạy lại từ đầu tới tick muốn xem. Dữ liệu trận và skill/buff được đóng băng trong bản ghi; config balance mới không đổi trận đang chạy. Runtime hiện dùng rules `zatod-prototype-3`.
- **Hero / Đồ**: chọn Hero, dùng **Dev Lv 40** nếu cần kiểm thử. **Cấp món** thêm đúng ItemId của ô; **Mặc** lấy một instance có GUID trong kho; đủ sáu ô thì **Tiến bậc**. Dừng ở Xanh Dương. Có thể nhập ItemId vào ô **AddItemByItemId** để cấp thành phẩm trực tiếp, không qua craft.

Kho không stack. Mặc giữ GUID; hấp thụ giữ GUID và ItemId nguồn. Bản lưu không đóng đinh tổng stats; thay config item/base sẽ tính lại theo reference thật. Item có bonus trực tiếp riêng theo Hero để giữ đóng góp Main Attrib từ nguồn mà không đưa STR/AGI/INT vào mô hình runtime. Slow của Sniper dùng tỷ lệ AD thay AGI theo quyết định trong Design.md.

## Phân biệt tiến trình và dữ liệu sở hữu

Mỗi lần mở ứng dụng tạo một launch GUID mới và reset clear/unlock Phó bản về ải đầu, kể cả server còn chạy. Replay không khôi phục tiến trình ải. Hero, level, đồ đang mặc/kho và lịch sử hấp thụ của development profile được lưu riêng tại `<data-dir>/Owned/<account GUID>.json`; chúng không bị reset cùng ải. PlayerPrefs giữ GUID của development profile. Đây là định danh thử nghiệm, chưa phải hệ thống đăng nhập/Market.

Archive mới là `<data-dir>/*.zatod.gz`; server vẫn đọc `.crystal.gz` đã lưu. Lần khởi động script mới đầu tiên sao chép dữ liệu server cũ sang `Artifacts/ZatodServer`, có `LegacyBackup`, không xóa nguồn. ID config được ánh xạ khi đọc save, giữ GUID Hero/item và lịch sử hấp thụ; định nghĩa pixel không còn hoạt động được giữ trong các trường Retired của save. Archive outcome và scene pixel cũ được giữ nguyên, với runtime/luồng tương thích riêng. Các bản input archive v1/v2 trong thư mục báo cáo lượt build đầu là artifact nội bộ trước nghiệm thu.

## View chọn đội

View dùng prefab `Assets/Zatod/Resources/Zatod/UI/Formation/ZatodFormationView.prefab`. Mỗi card có portrait/level/sao/khung bậc thật; dải đội hình thiếu ô bên trái khi chưa đủ 5. Lực chiến `?`, Cost đọc từ VitalityCost, Reward hiển thị icon DropItems không ghi tỷ lệ; mô tả giữ tiếng Trung. Không tự cấp toàn bộ Hero đã import vào roster. Chi tiết và ảnh kiểm tra: [View chọn đội](zatod-formation-view-review.md), [Popup preview và Reward](zatod-stage-preview-implementation.md).

## HUD và GameEditor

HUD dùng prefab `Assets/Zatod/Resources/Zatod/UI/ZatodBattleHUD.prefab`. HP/energy, chân dung và số damage/heal/energy phản ánh trận thật. Vàng/rương cố định 0, chưa nối reward. Phó bản không có pause/tăng tốc; replay giữ pause/seek/x1/x2/x4.

Mở **GameEditor > Open** (hoặc **Zatod > GameEditor**). Bảy tab: Heroes, Monsters, Items, Stats, Skills, Buffs, Campaign. Mở mũi tên để xem từng object/nested config; dữ liệu con chỉ dựng khi mở để giữ Editor nhẹ. Cửa sổ tự đọc lại file ngoài khi không có draft; nếu đang chỉnh sẽ giữ draft và từ chối save stale.

Bộ mới dùng ID snake_case: `lina`, `zeus`, `small_stout_shield`, skill có prefix owner để phân biệt các Basic Attack. 76 item và các skill hiển thị dùng nhãn English gốc. Bảy skill kỹ thuật ẩn chưa có nhãn English xác nhận dùng nhãn kỹ thuật có ghi nguồn trong báo cáo, không coi là bản dịch chính thức.

## Dữ liệu và công cụ

- Năm Hero sở hữu khởi đầu: Coco, DR, Lina, Zeus, Ench. Định nghĩa đầy đủ trong phase có25 Hero và14 quái; import không tự cấp20 Hero bổ sung.
- Chương1 Thường18 ải/54 wave, chương2 Thường21 ải/63 wave (tổng39/117). World layout: Resources/Data/Worlds.txt; nguồn/link nghiệm thu D21: zatod-shared-world-implementation.md. Config: `Resources/Data/Campaigns.txt`. Editor: **GameEditor > Open > Campaign**; có validate tham chiếu và bản sao trước khi save. Sau khi sửa config, restart PlayMode hoặc build/restart client và server để nạp cùng phiên bản mới; chưa có hot reload balance trên server đang chạy.
- Config Hero/item/stats/skill/buff: `Resources/Data/*.txt`; **GameEditor > Open**. Dữ liệu JSON trong `.txt`, không chuyển thành ScriptableObject.
- 76 loại trang bị trực tiếp đủ cho đường Trắng → Xanh Lá → Xanh Lá+1 → Xanh Dương. Không nhập thêm 41 nguyên liệu craft vì phase bypass craft.
- Source frame PNG giữ nguyên trong `Assets/Zatod/Art/Imported`; clip/controller/prefab/AnimationSet ở `Resources/Zatod`. Bản Windows dùng BC7 ở độ phân giải gốc. Animation được sample theo timeline, không dùng callback Animator để tính damage.
- Bốn sound reference của quái không có trong nguồn đã khôi phục (`Civ_Human_Wizard_BigAttack.mp3`, `Civ_Wizard_Attack.mp3`, `TANKGLOBAL_ATK.mp3`, `TANKGLOBAL_DEATH.mp3`). Báo cáo tại `Artifacts/CrystalPhaseChecks/static-art-audio.json`; không tự thay bằng sound khác.

Chưa gồm Tinh Anh, Tím/Cam/thức tỉnh, craft/enchant, Market/trade, quest/economy, farm EXP/sao đầy đủ hay lưu tiến trình ải dài hạn. Source backend Crystal không đầy đủ; core C# là bản port các luật trong phạm vi đã kiểm tra, chưa chứng minh tương đương từng bit với native engine/RNG gốc.

## Kiểm tra lại

```powershell
dotnet run --project Tests/CrystalChecks/CrystalChecks.csproj --no-restore
./scripts/Test-ZatodNetwork.ps1
```

Báo cáo lượt UI/đổi ID nằm ở `Artifacts/ZatodPhaseChecks/`; báo cáo phase gốc ở `Artifacts/CrystalPhaseChecks/`. Kết quả mới nhất: `docs/zatod-ui-implementation-progress.md`.


Bàn giao world D21 ngày20/11: [báo cáo triển khai](zatod-shared-world-implementation.md). Build cuối0 lỗi/2 cảnh báo có sẵn, Editor đã dừng Play. Town và hai map chung đã qua hai client/remote interpolation; tổng39 ải/117 wave. Server thường được khởi động lại với dữ liệu cũ. Khi vào Town, đi lên phía trên tới điểm Campaign; chữ/nút tương tác xuất hiện khi đủ gần. Clan và Lost Tower chưa có gameplay ở phase này.
