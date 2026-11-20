# Zatod Legend — prototype

Đọc [Design.md](Design.md) và [AGENTS.md](AGENTS.md) trước khi làm việc. Phase mới dùng scene `Unity/Assets/Zatod/Scenes/ZatodPrototype.unity`, Mirror TCP cổng 7788, core combat 8 Hz.

**Chơi thử / server / hai client / cấp đồ:** [hướng dẫn Zatod prototype](docs/zatod-prototype-play.md). **Trạng thái kiểm chứng:** [GameEditor / HUD / migration](docs/zatod-ui-implementation-progress.md).

Bộ dữ liệu phase: 16 Hero, 10 quái, chương 1 Thường 18 ải/54 wave, 67 loại trang bị tới Xanh Dương. Client Phó bản gửi nhật ký cuối trận để validate; Arena dùng input replay; PvP đồng bộ input hai phía. Tiến trình ải reset mỗi lần mở ứng dụng; Hero/item/GUID được giữ riêng theo development profile.

**Chọn đội Phó bản:** bấm ải → View native asset → chọn 1–5 Hero / xem wave → Battle. [Chi tiết View chọn đội](docs/zatod-formation-view-review.md).

**Config:** menu **GameEditor > Open**; bảy tab Heroes, Monsters, Items, Stats, Skills, Buffs, Campaign. HUD dùng asset hiện có, Auto và số combat thật; vàng/rương 0. Build: **Zatod > Tools > Build Windows Prototype**.

---

Các mục bên dưới mô tả nhánh pixel/scene ArenaPrototype cũ, được giữ để tham chiếu và tương thích. Các lệnh/cổng/luồng cũ không thay thế hướng dẫn Zatod ở trên.

# Zatod Legend — Arena combat prototype

**Trước khi làm việc:** đọc [Design.md](Design.md) và [AGENTS.md](AGENTS.md). Quyết định đã chốt được duy trì trong Design.md; nếu một thay đổi sẽ phá quyết định thì cần báo lại để brainstorm trước.

**Trước khi làm việc:** đọc [Design.md](Design.md) và [AGENTS.md](AGENTS.md). Quyết định đã chốt được duy trì trong Design.md; nếu một thay đổi sẽ phá quyết định thì cần báo lại để brainstorm trước.

Unity **6000.6.2f1**, Universal 2D (URP), giao diện ngang 16:9. Mirror **v96.11.5**, TCP/Telepathy.

**Campaign chương 1:** 5 ải, mỗi ải 5 Monster chiến đấu thật; map → preview địch → chọn 1–5 Hero → Battle → kết quả/replay/ải tiếp theo. Chạy `scripts/Start-Server.ps1`, mở scene ArenaPrototype hoặc bản Windows, bấm **KẾT NỐI** để lấy tiến độ. Campaign dùng server riêng và giữ tiến độ qua replay đã lưu. Hướng dẫn/config: [docs/campaign.md](docs/campaign.md).

**Combat Campaign:** trận chạy runtime trên dedicated server. Thanh chân dung dưới trận có đúng số Hero đã chọn, HP và nộ; **đầy nộ thì bấm chân dung để dùng Ultimate**. Sau trận có replay đầy đủ. Arena offline vẫn tự dùng Ulti và phát kết quả đã tính trước. Unit đầu phe địch đứng ở độ sâu trên, cùng với Leenald; bố cục trước–sau được giữ nguyên.

**Đội hình Campaign demo hiện ở bậc Tím**, mở đủ 4 kỹ năng để test. Skill2–4 tự dùng theo điều kiện; Ulti vẫn bấm tay. Chỉnh bậc demo bằng `StarterHeroRankId` trong `Campaigns.txt`. Hero mới ở các luồng khác vẫn bắt đầu bậc Trắng. Đội đủ 5 Hero Tím có thể thắng ải đầu trước khi đầy nộ; chọn ít Hero hơn nếu muốn thử bấm Ulti lâu hơn.

**Đội hình Campaign demo hiện ở bậc Tím**, mở đủ 4 kỹ năng để test. Skill2–4 tự dùng theo điều kiện; Ulti vẫn bấm tay. Chỉnh bậc demo bằng `StarterHeroRankId` trong `Campaigns.txt`. Hero mới ở các luồng khác vẫn bắt đầu bậc Trắng. Đội đủ 5 Hero Tím có thể thắng ải đầu trước khi đầy nộ; chọn ít Hero hơn nếu muốn thử bấm Ulti lâu hơn.

**Lilina** là Hero có art thứ năm, lấy từ SalamanderWitch HeroKit v3. Đã kiểm tra bốn chiêu trước khi tiếp tục Campaign: rồng phun lửa, tia sét xuyên hàng, hai cầu sét truy đuổi và hơi lửa gây Burn. **Combat Sandbox → Lilina → TEST ALL SKILLS / highest rank**. Mapping, thông số và nguồn art: [docs/lilina.md](docs/lilina.md).

**Blooesperod** đã được dựng từ NightLord HeroKit v3: cận chiến hàng trước, đánh thường hai nhát, Ultimate oan hồn hút máu, Huyết Trảo bắt địch xa nhất, nhát chém địch yếu máu/phía sau và hồi sinh sau 2 giây. Test đủ kit tại **Combat Sandbox → Blooesperod → TEST ALL SKILLS / highest rank**. Riêng Skill4: chọn Purple, Hero HP 1%, cho quái đánh chết để kích hoạt. Thông số prototype và hướng dẫn: [docs/blooesperod.md](docs/blooesperod.md).

**Monster trong Combat Sandbox:** giữ một Hero, chọn 1–5 quái có thể trùng loại bằng **Monster to add / Add Monster**. Đã có Fighter Goblin, Goblin Mage bắn cầu lửa và Skeleton Knight; quái di chuyển, đánh trả, chịu khống chế và chết trong mọi chế độ test. **Monster HP override = 0** dùng HP từ config. Balance tại **Zatod > Monsters > Monster Balance**. Chi tiết: [docs/monsters.md](docs/monsters.md).

Danh sách Monster hiện có thêm **Guardian**, **Archer** bắn tên, **Huntress** ném lao và **Evil Wizard** bắn cầu phép có hiệu ứng nổ. Chọn trong dropdown của từng slot hoặc **Monster to add** rồi tạo trận mới để thử.

**Enchantx** đã có trong roster/đội hình và Combat Sandbox. Skill3 thi triển ngay đầu trận khi đã mở khóa: lần đầu nhảy/chạy nhập trận rồi triệu hồi FlameWings; lần sau đứng tại chỗ triệu hồi. Để xem cả hai: chọn Enchantx/Purple, **Single-skill casts = 2**, **Duration = 25**, bấm Skill3. **TEST ALL SKILLS / highest rank** thử toàn bộ kit. Chi tiết cơ chế và chỉ số prototype: [docs/enchantx.md](docs/enchantx.md).

Hero thứ hai **Kavern** đã có trong danh sách/đội hình và Combat Sandbox. Chọn Kavern rồi **TEST ALL SKILLS / highest rank** để thử đủ bốn chiêu; Skill 3 chỉ chọn hai địch, mỗi địch có một ArrowShower ở chân; Skill 4 choáng 1 giây khi trúng. Config/timing/chỉ số mẫu: [docs/kavern.md](docs/kavern.md).

Thử Leenald: build **Zatod > Build Leenald Battle Preview**, chạy `./scripts/Start-Server.ps1 -BuildFolder LeenaldBattle`, mở `Builds/LeenaldBattle/ZatodArena.exe`. Từ danh sách Hero bấm Back, chọn Leenald và tối đa 4 đồng đội, rồi **Battle**. White mở đánh thường + Ulti; chưa tự mở các skill khóa bậc. Có thể chơi client trong Unity Play Mode với cùng server.

Test nhanh mọi Hero trong Editor: mở scene ArenaPrototype, vào **Zatod > Heroes > Combat Sandbox**, chọn Hero rồi **TEST ALL SKILLS / highest rank**. Công cụ tự vào Play Mode, tạo Hero tạm ở bậc cao nhất và đội Monster đánh trả. Có nút riêng từng chiêu, đánh thường, tùy chỉnh HP/energy/khoảng cách/số mục tiêu/seed; **-1 tick / +1 tick** để quan sát tiếp xúc chính xác. Save balance rồi **Reload saved config** để thử lại, không cần build Windows/server. Đây là preview dùng cùng combat core; không khởi tạo host, ghi HeroDesk hoặc lưu kết quả Arena. Xem [docs/combat-sandbox.md](docs/combat-sandbox.md).

Prototype gồm **combat + bản ghi Arena offline** và nền **data HeroDesk / công cụ balance Hero**. Arena nhận đội hình đã chọn từ HeroDesk sandbox; server tự lấy config và tính stats, client chỉ gửi HeroInstanceId. Chưa có đăng nhập hoặc tài khoản production.

## Danh sách và chi tiết Hero

Hero thật đầu tiên: **Leenald**, hàng trước/cận chiến, đã có icon, prefab, chín animation nhân vật và hai projectile. Mở Leenald trong danh sách để thấy model Idle; vào **Zatod > Heroes > Leenald Animation Preview** khi Play để thử các clip. Đã vào Arena: chạy, đánh thường, Ulti projectile gây choáng; skill mở thêm theo bậc. Animation chạy theo thời gian replay. Chi tiết mapping, stats và timing: [docs/leenald.md](docs/leenald.md).

Play scene `Unity/Assets/Zatod/Scenes/ArenaPrototype.unity` mở Campaign trước; bấm Back để vào **Danh sách Hero**. Danh sách hai cột đọc cùng `HeroDesk` với màn đội hình: icon/khung bậc, tên, level/sao và sáu ô trang bị yêu cầu của bậc hiện tại. Bậc Tím mẫu đang là bậc cuối nên sáu ô yêu cầu để trống. Bộ lọc chỉ có **All / Trước / Giữa / Sau**.

Click một Hero để mở **HeroDetailView**. Tab **Base** hiển thị level, EXP, sao và toàn bộ stats từ `HeroStatCalculator`; stats cuộn được. Skill/Skin/Awaken mới là tab chờ. Vùng trang bị/Quick Equip vẫn để trống; Hero đã có prefab như Leenald sẽ hiện model. Đóng chi tiết giữ bộ lọc và vị trí cuộn danh sách.

Gold/Diamond/Stamina và power dùng số mẫu. Soul mặc định 0, có `SoulCountProvider` để nối nguồn mảnh hồn sau. UI không tiêu item, tăng level/sao, hoặc ghi đè stats đã tính vào HeroData. Chân dung dùng icon vai trò tạm; có thể đặt Sprite tại `Resources/HeroPortraits/<HeroDefinitionId>` để thay bằng hình Hero.

Back ở danh sách mở màn đội hình; nút **HEROES** ở màn đội hình quay lại danh sách. Đây là đường đi tạm khi chưa có màn chính. Build bằng **Zatod > Build Hero Preview**, executable ở `Builds/HeroPreview/ZatodArena.exe`.

## Danh sách và chi tiết Hero

Play scene `Unity/Assets/Zatod/Scenes/ArenaPrototype.unity` mở Campaign trước; bấm Back để vào **Danh sách Hero**. Danh sách hai cột đọc cùng `HeroDesk` với màn đội hình: icon/khung bậc, tên, level/sao và sáu ô trang bị yêu cầu của bậc hiện tại. Bậc Tím mẫu đang là bậc cuối nên sáu ô yêu cầu để trống. Bộ lọc chỉ có **All / Trước / Giữa / Sau**.

Click một Hero để mở **HeroDetailView**. Tab **Base** hiển thị level, EXP, sao và toàn bộ stats từ `HeroStatCalculator`; stats cuộn được. Skill/Skin/Awaken mới là tab chờ. Vùng trang bị/Quick Equip/model ở giữa để trống như yêu cầu. Đóng chi tiết giữ bộ lọc và vị trí cuộn danh sách.

Gold/Diamond/Stamina và power dùng số mẫu. Soul mặc định 0, có `SoulCountProvider` để nối nguồn mảnh hồn sau. UI không tiêu item, tăng level/sao, hoặc ghi đè stats đã tính vào HeroData. Chân dung dùng icon vai trò tạm; có thể đặt Sprite tại `Resources/HeroPortraits/<HeroDefinitionId>` để thay bằng hình Hero.

Back ở danh sách mở màn đội hình; nút **HEROES** ở màn đội hình quay lại danh sách. Đây là đường đi tạm khi chưa có màn chính. Build bằng **Zatod > Build Hero Preview**, executable ở `Builds/HeroPreview/ZatodArena.exe`.

## Chọn đội hình

Từ danh sách Hero, bấm Back để mở màn chọn đội hình.

- Click Hero để chọn/bỏ chọn, tối đa 5. Click một ô Hero đã chọn cũng bỏ chọn được. Ô đội hình tự xếp Trước → Giữa → Sau.
- Bộ lọc **All / Trước / Giữa / Sau**, danh sách cuộn, và một tab **Hero** hiển thị toàn bộ Hero đang có. `FormationView.Tabs` cho phép khai báo thêm tab về sau.
- Hai vùng gợi ý phía trên và thông tin bên phải để trống. Back tạm vô hiệu hóa; không có STR/INT/AGI hoặc preset.
- **Battle** mở Arena hiện tại và tự kết nối server riêng, tạo trận mới khi kết nối thành công. Cần server chạy trước. Nút **SQUAD** trong Arena quay lại đội hình và giữ lựa chọn.

Hiện có **Leenald và 18 Hero mẫu**, khởi tạo `CharacterData.HeroDesk` sandbox từ config. Đội hình lưu HeroInstanceId trong `CharacterData.Formation`; server kiểm tra ID thuộc profile thử nghiệm, xếp Trước → Giữa → Sau rồi dựng trận bằng stats và skill snapshot riêng. Đội phòng thủ vẫn dùng mẫu.

Build UI mới bằng **Zatod > Build Formation Preview**. Executable nằm ở `Builds/FormationPreview/ZatodArena.exe`, tách khỏi bản Windows/server đang chạy. Chạy cùng server trên cổng 7777/TCP. **Zatod > Setup Formation Selector** dùng để cài lại component UI/font/Hero mẫu vào scene hiện tại nếu cần; không dựng lại toàn bộ scene.

## Chọn đội hình

Từ danh sách Hero, bấm Back để mở màn chọn đội hình.

- Click Hero để chọn/bỏ chọn, tối đa 5. Click một ô Hero đã chọn cũng bỏ chọn được. Ô đội hình tự xếp Trước → Giữa → Sau.
- Bộ lọc **All / Trước / Giữa / Sau**, danh sách cuộn, và một tab **Hero** hiển thị toàn bộ Hero đang có. `FormationView.Tabs` cho phép khai báo thêm tab về sau.
- Hai vùng gợi ý phía trên và thông tin bên phải để trống. Back tạm vô hiệu hóa; không có STR/INT/AGI hoặc preset.
- **Battle** mở Arena hiện tại và tự kết nối server riêng, tạo trận mới khi kết nối thành công. Cần server chạy trước. Nút **SQUAD** trong Arena quay lại đội hình và giữ lựa chọn.

Hiện có **Leenald và 18 Hero mẫu**, khởi tạo `CharacterData.HeroDesk` sandbox từ config. Đội hình lưu HeroInstanceId trong `CharacterData.Formation`; server kiểm tra ID thuộc profile thử nghiệm, xếp Trước → Giữa → Sau rồi dựng trận bằng stats và skill snapshot riêng. Đội phòng thủ vẫn dùng mẫu.

Build UI mới bằng **Zatod > Build Formation Preview**. Executable nằm ở `Builds/FormationPreview/ZatodArena.exe`, tách khỏi bản Windows/server đang chạy. Chạy cùng server trên cổng 7777/TCP. **Zatod > Setup Formation Selector** dùng để cài lại component UI/font/Hero mẫu vào scene hiện tại nếu cần; không dựng lại toàn bộ scene.

## HeroDesk và balance Hero

Mở **Zatod > Heroes > Hero Balance** trong Unity. Config JSON được tách thành `Stats.txt`, `Items.txt`, `Skills.txt`, `Heroes.txt` tại `Unity/Assets/Zatod/Resources/Data/`, không dùng ScriptableObject làm config.

- Bên trái có bốn tab **Stats / Items / Skills / Heroes**. Mỗi tab chỉnh một bảng riêng; có thể thêm/xóa entry hoặc nhập raw JSON của file tương ứng. Stat sức đánh dùng ID `damage`, phòng thủ dùng `defense`.
- Bên phải xem tổng stats và nguồn đóng góp, thử **Fill current gear → Promote**. Hero mẫu có bốn bậc Trắng → Xanh Lá → Xanh Dương → Tím; mỗi bậc mở một skill, Ulti mở sẵn từ Trắng.
- **Save + reload preview HeroDesk** ghi tiến trình sandbox ở `Artifacts/HeroDeskPreview.json`, rồi load lại để kiểm tra.
- **Validate** kiểm tra liên kết giữa bốn bảng. Khi cân bằng, đổi `ConfigVersion` rồi **Save all config**; thay đổi draft chưa tự ghi xuống file. Chuyển tab giữ nguyên các chỉnh sửa đang có.

`CharacterData.HeroDesk` là `List<HeroData>`. File lưu chỉ giữ ID và tiến trình; `HeroDefinition` được resolve khi load, stats được tính theo config đang áp dụng. Level, sao, Currencies và các phần dữ liệu nhân vật khác hiện chỉ có khai báo. Arena thực thi các active effect Damage/Heal/Stun/KnockUp/Knockback được dùng cho Leenald. Passive/StatBonus và tăng trưởng level/sao chưa được mở rộng trong combat.

Hợp đồng data, ví dụ code và giới hạn phase này: [docs/hero-data.md](docs/hero-data.md).

## Chạy bản đã build trên Windows

Trong PowerShell tại thư mục này:

```powershell
.\scripts\Start-Server.ps1
.\scripts\Start-Client.ps1
```

Server chạy headless trong **tiến trình riêng**. Client không bao giờ gọi `StartHost`, `ConnectHost` hay `NetworkServer.Listen`. Trong cửa sổ game, bấm **Connect**, chọn Balanced / Fortress / Burst, rồi **Start Challenge**.

Server tính xong trận, ghi file bền vững rồi mới trả kết quả. Màn hình trận đấu phát bản ghi đã hoàn tất. Có Play/Pause, Restart, ±5 giây, kéo timeline, tốc độ 0.5×/1×/2×/4× và tới cuối trận. Server History hiển thị ba trận gần nhất và cho tải lại; server trả tối đa 20 mục trong catalog.

Có thể ngắt kết nối sau khi tải trận và vẫn xem bản ghi đang giữ trong bộ nhớ. Khởi động lại server với cùng thư mục `ServerData` vẫn tải được trận cũ. Khi thoát trước khi nhận xong replay, kết nối lại rồi Refresh History.

Để kết nối máy server khác:

```powershell
.\scripts\Start-Client.ps1 -ServerAddress 192.168.1.20 -Port 7777
```

Đây là cách chạy server riêng để kiểm thử local/LAN; chưa triển khai dịch vụ cloud. Server prototype dùng một tài khoản development chung, không có xác thực hoặc phân quyền xem replay. Cần bổ sung trước khi đưa lên Internet cho người chơi thật.

## Mở và build trong Unity

1. Mở folder `Unity` bằng Unity 6000.6.2f1.
2. Mở `Assets/Zatod/Scenes/ArenaPrototype.unity`.
3. Chạy `Zatod > Build Windows Prototype`. Bản build nằm ở `Builds/Windows/ZatodArena.exe`.
4. Chạy server bằng script trên; bấm Play trong Editor cũng dùng được như một client.

Scene có thể dựng lại bằng `Zatod > Setup Arena Prototype`; thao tác này tạo lại scene prototype. Nếu cần font: chạy `Zatod > Import Text Resources`, đợi import xong rồi Setup.

`Zatod > Build Linux Dedicated Server` tạo build `UNITY_SERVER` ở `Builds/LinuxServer`. Trên Linux:

```bash
chmod +x ZatodArenaServer
./ZatodArenaServer -batchmode -nographics --port 7777 --data-dir /srv/zatod/replays -logFile /srv/zatod/server.log
```

Mount thư mục replay vào volume bền vững khi đóng gói container. Cổng là **7777/TCP**. Mirror vận chuyển dữ liệu; việc thuê máy, TLS, đăng nhập, lưu DB và vận hành là các hạng mục riêng.

## Những gì có trong combat

- Luật **combat-prototype-2**: đội hình trước–sau trên trục ngang, tầm đánh **tâm–tâm**, độ lệch cao–thấp nhỏ chỉ phục vụ hiển thị.
- Unit giữ mục tiêu còn hợp lệ. Mục tiêu chết thì chọn địch phía trước tiếp theo; ngoài tầm thì tự tiến vào tầm, đang trong tầm thì đứng lại.
- Di chuyển độc lập với hồi chiêu, nhưng phải chờ hết phần động tác khóa di chuyển. Đòn chưa trúng bị hủy nếu mục tiêu chết; sát thương không chuyển sang mục tiêu mới.
- Có tốc độ chạy và khoảng đệm đội hình, dừng trong tầm để tránh giật ở ranh giới. Động tác đánh chỉ diễn hoạt biểu tượng; vị trí chiến đấu và thanh máu bám theo bản ghi.
- Góc nhìn chung theo toàn đội hình, bỏ giới hạn ép mỗi phe ở nửa sân của mình. Các replay luật cũ vẫn phát lại được và có nhãn `LEGACY REPLAY`.
- Tick logic cố định 20 Hz, số nguyên cho vị trí/chỉ số, thời hạn 90 giây; còn cả hai đội khi hết giờ thì hòa.
- 5 vai trò giả lập: Vanguard, Striker, Ranger, Arcanist, Medic.
- Chọn mục tiêu, tiến vào tầm, thời gian chuẩn bị đòn, hồi chiêu, sát thương/giáp/chí mạng, năng lượng và tự Ulti.
- Ulti: choáng và ngắt chiêu, dồn sát thương, đánh mục tiêu ít máu, đánh cả đội, hồi cả đội.
- Chiêu đã bị ngắt không gây sát thương tiếp; đánh thường mất mục tiêu thì hụt đòn, không gây một đòn vô hình vào mục tiêu mới.
- Seed ngẫu nhiên được tạo trên server. Thứ tự xử lý đồng thời trong prototype dùng ID cố định; cần thiết kế luật initiative/công bằng kỹ hơn trước Arena cạnh tranh.

## Kiến trúc

```text
Unity/Assets/Zatod/Combat/         Pure C# simulation, replay DTO và timeline
Unity/Assets/Zatod/Heroes/         Pure C# HeroDesk, config DTO, stats và lên bậc
Unity/Assets/Zatod/HeroIntegration/ JSON codec, load TextAsset và ghi file nguyên vẹn
Unity/Assets/Zatod/Resources/Data/ Config JSON .txt dùng cho Editor và build tương lai
Unity/Assets/Zatod/ArenaNetwork/   Mirror protocol, dedicated server, lưu và tải replay
Unity/Assets/Zatod/Presentation/   uGUI/TMP, biểu diễn trạng thái đã ghi
Unity/Assets/Zatod/Editor/         Dựng scene và build
Tests/CombatChecks/               Kiểm chứng core bằng .NET, không cần chạy Unity
Tests/HeroChecks/                 Kiểm chứng data Hero bằng .NET
scripts/                         Chạy server/client và kiểm chứng
docs/architecture.md             Hợp đồng bản ghi, giới hạn và hướng mở rộng
```

Mirror được vendor từ mã nguồn chính thức có tag cố định, giữ nguyên `.meta` và license; không kèm Examples, Tests hoặc dịch vụ hosting của Mirror. Unity Pipeline 1.0.0 phục vụ kiểm tra Editor, không bật runtime agent trong bản phát hành.

## Kiểm chứng

```powershell
.\scripts\Run-CombatChecks.ps1
.\scripts\Run-HeroChecks.ps1
```

Bộ kiểm chứng chạy 36 trận và các tình huống mục tiêu chết, đổi mục tiêu, tiến vào tầm trong lúc hồi chiêu, tướng đánh xa đứng nguyên, ngắt đòn, không vượt quá điểm dừng và giữ khoảng đệm đồng đội. Seek và playback được so sánh ở **từng tick**; có kiểm tra trạng thái cuối, snapshot, serialize/deserialize, seed lặp lại, timeout và phiên bản replay không hỗ trợ. Log kiểm thử thực tế và ảnh giao diện được lưu trong `Logs` và `Artifacts` tại máy này.

Chi tiết kết quả và phạm vi đã kiểm tra: [docs/verification.md](docs/verification.md). Kiểm tra server/client thật (tự tạo và dừng server thử nghiệm riêng ở cổng 17877):

```powershell
.\scripts\Test-ArenaNetwork.ps1
```

Thử client headless với server đang chạy:

```powershell
.\Builds\Windows\ZatodArena.exe -batchmode -nographics --arena-smoke --server 127.0.0.1 --port 7777 -logFile Logs/smoke.log
```

Client smoke tạo trận thật qua Mirror, kiểm tra phát replay, tải lại và gửi lại cùng request ID. Dùng `--replay-id <ID>` để kiểm tra tải bản ghi sau khi restart server. Exit code 0 và `[ArenaSmoke] PASS` là thành công.


## Crystal Legends reference

Nguồn APK, script và asset đã khôi phục nằm nguyên bộ trong `Crystal Legend/`, ngoài `Unity/Assets`. Đọc [ghi chú tham chiếu và context hai chat](docs/crystal-legends-reference.txt) trước khi tiếp tục chuyển đổi Campaign, Arena hoặc PvP RealTime. Thư mục nguồn được giữ local và bỏ qua bởi Git; chỉ import asset cần dùng vào Unity theo từng bước.
