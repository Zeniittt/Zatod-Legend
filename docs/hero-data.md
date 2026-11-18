# HeroDesk data, phase 1

## Giao diện danh sách và chi tiết

`HeroRosterView` và `FormationView` dùng cùng instance `CharacterData` và `HeroCatalog`. Không tạo HeroDesk riêng cho màn chi tiết. Row danh sách hiển thị bậc, tên, level/sao và sáu ô yêu cầu của recipe hiện tại; không lấy trang bị đã hấp thụ làm yêu cầu bậc hiện tại. Bậc cuối chưa có recipe thì ô tương ứng trống. Cả list và Stats dùng ScrollRect/RectMask2D.

`HeroDetailView` hiện chỉ có Base; Skill/Skin/Awaken vô hiệu hóa. Khi mở, level/EXP/sao đọc từ `HeroData`, stats gọi bộ tính hiện hành, rồi hiển thị kết quả. Attack interval của prototype được đổi từ tick 20 Hz sang giây để hiển thị. Xem và đóng chi tiết không sửa dữ liệu tiến trình, currencies hay inventory. Nút đóng giữ vị trí cuộn và bộ lọc danh sách. Nguồn soul có thể cung cấp qua `HeroRosterView.SoulCountProvider`, mặc định 0; chưa có logic sở hữu/nâng sao bằng soul.

Các số Gold/Diamond/Stamina và power là placeholder UI, không thêm vào CharacterData hoặc công thức stats. Khu vực giữa dành cho sáu trang bị/Quick Equip/model được giữ trống. Art đang dùng glyph vai trò của prototype; Sprite tùy chọn theo đường dẫn `HeroPortraits/<HeroDefinitionId>` trong Resources. Các field/config/gameplay Hero không bị thay đổi bởi việc thêm UI này.

## Cách sử dụng trong Editor

Mở **Zatod > Heroes > Hero Balance**. Cửa sổ UI Toolkit có bốn tab, mỗi tab tương ứng một file JSON `.txt` tại `Unity/Assets/Zatod/Resources/Data/`:

| Tab | File | Nội dung |
|---|---|---|
| Stats | `Stats.txt` | Danh sách định nghĩa stat |
| Items | `Items.txt` | Trang bị và đóng góp stats |
| Skills | `Skills.txt` | Kỹ năng, trigger, target và effect |
| Heroes | `Heroes.txt` | Base stats, chuỗi bậc, ô trang bị và skill slot của Hero |

Không có config ScriptableObject hoặc `.asset` trung gian. Mỗi file có `SchemaVersion`, `ConfigVersion` và riêng danh sách dữ liệu của bảng đó; cả bốn phải cùng version. `HeroCatalogData` chỉ là tập hợp trong bộ nhớ sau khi load, không còn là một file config gộp.

Mỗi tab có thể thêm, xóa và sửa từng field. Mở foldout để chỉnh rank, ô trang bị, skill slot, effect. Raw JSON chỉ nhập/xuất bảng đang chọn. Chuyển tab giữ nguyên draft và tiến trình preview. **Validate** kiểm tra ID trùng, reference thiếu giữa các bảng, bậc không tới được/vòng lặp, skill unlock sai, chỉ số trùng và timing/cost không hợp lệ. **Save all config** chỉ ghi bộ config hợp lệ, yêu cầu `ConfigVersion` mới khi đổi nội dung, và kiểm tra cả bốn file có bị thay đổi bên ngoài kể từ lúc load hay không trước khi ghi file nào. **Reload files** đọc lại cả bộ; draft chưa lưu sẽ có xác nhận bỏ thay đổi.

Khi lưu, Unity giữ import tới khi ghi xong cả bốn file. Nếu có lỗi ghi, code thử khôi phục các file đã đổi. Đây chưa phải giao dịch filesystem bảo đảm qua mất điện/crash: loader sẽ từ chối bộ file thiếu hoặc khác version, thay vì dùng lẫn các phiên bản. Khi chỉnh bằng text editor ngoài Unity, phải giữ cùng schema/version giữa bốn file và dùng Reload files để nạp lại.

Preview là sandbox HeroDesk một Hero: **New hero**, **Fill current gear**, **Promote** và **Save + reload preview HeroDesk**. Các thay đổi này không ghi vào tài khoản hoặc server Arena. Save/load preview dùng `Artifacts/HeroDeskPreview.json` ở workspace. Preview hiển thị tổng stats, breakdown, skill đã mở và JSON tiến trình được lưu. Chưa có HeroDetailView runtime hoặc công thức lực chiến; không tự đặt một công thức lực chiến khi chưa chốt thiết kế.

Hero mẫu `training_warrior`: base damage 5, mỗi `axe_basic` +5 damage; Trắng/Xanh Lá/Xanh Dương mỗi bậc có sáu ô rìu. Tím là bậc cuối, chưa có recipe tiếp theo. Mới nhận có damage 5; mặc sáu rìu thành 35; lên Xanh Lá vẫn 35; mặc tiếp sáu thành 65; lên Xanh Dương vẫn 65; tới Tím có 18 rìu đã hấp thụ và damage 95. ID phòng thủ là `defense`. `attack_range` và `attack_interval` vẫn chỉ tầm/thời gian đánh, độc lập với stat `damage`.

## Data và nguồn dữ liệu chính

- `CharacterData.HeroDesk` là `List<HeroData>`, không có manager/model riêng bao bên ngoài danh sách.
- `CharacterData.Formation.HeroInstanceIds` lưu tối đa năm ID Hero sở hữu, không sao chép HeroData. `HeroFormation` kiểm tra quyền sở hữu/ID trùng, chọn/bỏ chọn, lọc vị trí và xếp Trước → Giữa → Sau. Đây là logic đội hình local, chưa phải validation lệnh Arena trên server.
- `HeroDefinition`: base stats, chuỗi rank và skill slots. `ItemDefinition`: stats của item. `SkillDefinition`: active/passive, trigger, target, timing, energy và danh sách effect. `HeroCatalogData` chứa các config và phiên bản.
- `HeroDefinition.Position` có Front/Middle/Rear; `PortraitKey` chọn icon vai trò tạm. Editor balance chỉnh được các field này trong tab Heroes. Các Hero mẫu UI dùng chung bộ skill/recipe prototype, không đại diện cân bằng cuối cùng.
- `HeroData`: HeroInstanceId, HeroDefinitionId, RankId; trang bị đang mặc, lịch sử hấp thụ, level của từng skill slot. Level/Exp/Stars/Awakened mới là field dự phòng, chưa có luật phát triển hoặc thưởng chỉ số từ các field này.
- `HeroData.Definition` là tham chiếu dùng trong bộ nhớ, đánh dấu `[NonSerialized]`. `HeroDataJson.ReadCharacter` gọi `catalog.Bind` để resolve lại. File tiến trình không chứa bản sao config hoặc tổng stats.
- `HeroBattleData`: bản sao stats và những skill đã mở, cùng HP/energy/cooldown runtime ban đầu. Skill definition và các effect cũng được copy; không chia sẻ object có thể sửa với config hoặc trận khác. Chưa có bộ xử lý skill, buff/debuff hoặc điều kiện phó bản.
- `CharacterData.Currencies` là `List<Currency>` với ID và Amount; không có Wallet. Inventory, campaign, quests, level tài khoản và currencies chỉ có khai báo nền, chưa có nghiệp vụ hoặc định dạng cuối cùng cho các tính năng đó.

`Zatod.Heroes` là assembly C# thuần, `noEngineReferences`, để dùng chung cho server/client hoặc công cụ .NET. `Zatod.HeroIntegration` dùng Unity `JsonUtility` và `Resources.Load<TextAsset>`; `Zatod.Editor` chứa công cụ balance. Không có dependency ngược từ core vào Unity hoặc Mirror.

```csharp
var catalog = HeroDataJson.LoadBundledCatalog();
var character = HeroDataJson.ReadCharacter(savedJson, catalog);
var hero = character.HeroDesk[0];
var stats = HeroStatCalculator.Calculate(hero, catalog);
int damage = stats.Get("damage");
int defense = stats.Get("defense");

// Tạo snapshot trước khi áp dụng điều kiện phó bản, không sửa HeroData/config.
var battleHero = HeroBattleFactory.Create(hero, catalog);
```

Bốn file `.txt` được Unity đóng gói thành TextAsset trong Resources. `HeroDataJson.LoadBundledCatalog` đọc và ghép chúng sau khi kiểm tra schema/version và reference. Code server ngoài Unity có thể đọc cùng JSON bằng serializer tương thích vào `StatsConfigData`, `ItemsConfigData`, `SkillsConfigData`, `HeroesConfigData`, ghép thành `HeroCatalogData` rồi `new HeroCatalog(data)`. Đây chưa phải hệ thống phân phối/hot reload config từ server. Mỗi đợt áp dụng config phải dựng catalog mới và bind lại HeroDesk; không sửa catalog đang được gameplay sử dụng. Các DTO config có field public phục vụ authoring, nên quy tắc không sửa live catalog thuộc về caller. Battle snapshot đã tạo không bị ảnh hưởng khi đổi catalog.

## Tính stats

Chỉ cộng flat stats trong phase này:

```text
BaseStats
+ tổng BonusStats của các bậc đã đạt (mỗi bậc cộng một lần)
+ stats của ItemId thực tế trong AbsorbedItems × Quantity
+ stats của các item đang mặc
= tổng thường trực, sau đó áp dụng Minimum của từng stat
```

Không suy ra trang bị đã hấp thụ từ recipe hiện hành. Không cộng bonus level/sao, passive hoặc hiệu ứng phó bản vào chỉ số thường trực ở phase này. Chưa có modifier phần trăm, công thức tăng theo cấp skill hoặc công thức lực chiến. Stat ID là string mở rộng được; value là số nguyên. Tính toán có kiểm tra overflow, không để wrap âm. Breakdown ghi từng nguồn để kiểm tra cân bằng.

Ví dụ gốc của thiết kế được kiểm chứng bằng fixture riêng: bậc Trắng có một ô rìu và bậc Xanh Lá có hai ô rìu. Một rìu đã hấp thụ + hai đang mặc: `5 + 5 + 2×5 = 20`. Thay base thành 3 và rìu thành 10: cùng tiến trình đó cho `3 + 10 + 2×10 = 33`.

## Bậc, trang bị và skill unlock

Rank dùng string ID ổn định và `NextRankId`, không dùng enum màu hoặc index trong list. Mỗi Hero có recipe theo từng rank. Mỗi ô có ID riêng, dù sáu ô cùng yêu cầu một loại rìu. Thứ tự list không quyết định đường lên bậc.

`Equip` chỉ nhận item khớp recipe hiện hành và ô còn trống. `CanPromote` yêu cầu đầy đủ các ô và có bậc tiếp theo. `Promote` chuyển các món thực tế sang ledger `{RankId, SlotId, ItemId, Quantity}`, xóa trang bị đang mặc và đổi rank. Skill unlock được suy ra từ các `UnlockSkillSlotIds` trên đường tới rank hiện tại; không lưu số lượng skill đã mở hoặc flag trùng với config. Tiến trình cấp skill được lưu theo SlotId, kể cả slot hiện chưa mở.

Bốn bậc mẫu mở lần lượt ultimate / skill_2 / skill_3 / skill_4. Có thể chèn `green_plus_1` không mở skill, hoặc sắp lại list, mà Hero đang ở `blue` vẫn giữ đúng rank. Việc chèn bậc không tự tặng các item mà người chơi chưa từng hấp thụ. BonusStats của bậc mới trên đường đã đạt sẽ tham gia công thức, vì đây là config cân bằng hiện hành; cần xem preview trước khi áp dụng.

## Thay recipe

Thay chỉ số một item làm thay đổi đóng góp của tất cả reference tới ID đó ở lần tính tiếp theo. Thay required item từ rìu sang kiếm không tự đổi ID item đã hấp thụ hoặc đang mặc. Món đã mặc ở ô còn tồn tại vẫn hợp lệ; ô trống phải mặc món theo recipe mới. Khi lên bậc, ledger giữ chính món đã mặc.

Lịch sử đã hấp thụ không yêu cầu SlotId cũ còn tồn tại trong recipe hôm nay. Tuy nhiên ID item cũ và rank cũ phải còn resolve được; không xóa chúng khi người chơi còn tham chiếu. Xóa/đổi ID ô đang mặc hoặc xóa rank/item là thay đổi cần chính sách chuyển đổi dữ liệu. Chưa implement migration; sẽ thiết kế riêng khi có case cụ thể. Không có code tự thay lịch sử người chơi.

## Kỹ năng và ranh giới combat

Config có Active/Passive độc lập với trigger: Automatic, UltimateIntent, BattleStart, AfterBasicAttack. UltimateIntent dành cho ý định dùng Ulti từ AI Arena offline hoặc lệnh người chơi được server chấp nhận ở Arena live sau này. Target hỗ trợ self/front enemy/weakest enemy/all enemies/weakest ally/all allies. Effect mẫu gồm Damage/Heal/Stun/StatBonus; hệ thống thực thi và các effect mở rộng như độc, đẩy lùi, hất tung chưa làm.

Các timing skill dùng milliseconds. DamageScaleBasisPoints dùng 10000 = 100%; sample Ulti 12000 = 120% damage và stun 1000 ms. Các con số này hiện chỉ là config và snapshot, chưa điều khiển `BattleSimulation` cũ.

Arena vẫn dùng `PrototypeTeams` và các skill hardcode trước đó. Không sửa schema/rules replay, seed, authority hoặc kết quả trận cũ. Chưa nối HeroDesk vào account persistence, network commands, squad selection hay combat. `HeroProgression.Equip/Promote` là thao tác dữ liệu tin cậy cho sandbox/future server, không kiểm tra hoặc trừ Inventory; không được expose trực tiếp cho client như một API cấp đồ miễn phí. Server tương lai phải kiểm tra sở hữu và lưu thay đổi inventory/HeroData trong cùng transaction.

JSON save/load helper kiểm tra schema và HeroDesk, resolve references và ghi file qua temp + flush + replace. Đây chưa phải account repository, chưa xử lý concurrency/revision hoặc giao dịch nhiều tài nguyên. Các khai báo placeholder của những hệ thống ngoài Hero không được xem là validation nghiệp vụ hoàn chỉnh.

## Kiểm chứng

```powershell
.\scripts\Run-HeroChecks.ps1
```

93 assertions .NET kiểm tra rank/gear, không cộng trùng, skill unlock, terminal rank, HeroInstanceId, ví dụ 20→33, recipe grandfathering, chèn bậc, battle snapshot tách biệt, config/owned data không hợp lệ, overflow và chọn/lọc/lưu đội hình bằng ID Hero sở hữu.

`Unity/AgentScripts/VerifyHeroData.cs` có 81 assertions chạy bằng Unity Pipeline để kiểm chứng JsonUtility thật, bốn TextAsset, thiếu file/lệch version, reference giữa bảng, save/load disk và các nút/callback của từng tab. Script khôi phục cả bốn file ban đầu sau test save. Ảnh UI: `Artifacts/hero-balance-tabs.png`.

Config gộp cũ đã được chuyển một lần sang bộ file mới, giữ mọi giá trị balance và đổi stat ID/reference `attack` → `damage`, `armor` → `defense`, cùng field skill `DamageScaleBasisPoints`. Bản gốc có trong `Artifacts/HeroConfigBeforeSplit/20261116-083431/`. Đây chỉ là chuyển đổi định dạng config prototype, không sửa HeroDesk người chơi hoặc replay Arena.
