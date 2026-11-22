# Khảo sát Inventory Crystal và chuẩn bị phase Zatod

Ngày22/11/2026. Người dùng chọn Inventory là phase kế tiếp, giữ nguồn farm đồEXP ở trạng thái tham khảo. **Chỉ khảo sát, chưa triển khai UI/logic/config runtime.** Các đề xuất tab/action/model chi tiết bên dưới chưa được duyệt. Đối chiếu DesignD12/D17/D22/D28/D29/D30. Không mở rộng sang HeroTrial, sửa drop pool, nâng sao hoặc Market chỉ vì chúng liên quan kho.

**Cập nhật trạng thái22/11:** người dùng đã duyệt phase và yêu cầu thực thi theo docs/zatod-inventory-phase-plan.md. Trong lúc triển khai, đổi yêu cầu từ mỗiGUID/mộtô sang mộticon/xN theo loại, giữ GUID và asset Crystal. D12/D31 đã cập nhật; mọi đoạn mộtGUID/mộtô hoặc chưa triển khai trong bản khảo sát này là lịch sử, không phải layout/trạng thái đích cuối. Dữ liệu sở hữu vẫn giữ từng GUID, UI dùng InventoryStack projection; Sell có chọn số lượng và tiêu đúng tập GUID. Phạm vi/tiến trình nghiệm thu theo kế hoạch và báo cáo triển khai, không dùng các đề xuất chưa duyệt trong khảo sát để mở thêm feature.

**Bổ sung ảnh tham chiếu22/11:** layout Soulstones cuối dùng card Hero sở hữu/chưa sở hữu, gồm cả0 đá, progress tím và Star-Up/Recruit. Stone-only grid và đề xuất không hiện Hero0 đá dưới đây đã được thay bởi chỉ dẫn mới. Card catalog không tạo item/GUID giả.

## 1. Crystal có4 tab chính

Tên English được tra localization chính thức, không tự đặt:

|Tab|Identity source|Nội dung|
|---|---|---|
|Items|package|Đồ tiêu hao và vật phẩm thường/sự kiện/quý/ngoại hình/nuôi dưỡng|
|Shards|fragment|Mảnh trang bị, tiến độ đủ số mảnh để ghép, Compose và Quick Compose|
|Gears|equip|Đồ đã ghép, đồ cơ bản và scroll công thức|
|Soulstones|stone|Đá linh hồn Hero, tiến độ triệu hồi/nâng sao và hành động theo trạng thái sở hữu|

Items có6 filter: All, Common, Events, Precious, Cosmetic, Develop. Gears có4 filter: All, Forged, Primal, Scroll. Hai tab còn lại không dùng cùng dải filter đó; Shards có Quick Compose khi có món đủ điều kiện.

Bố cục Package:initUI: background herolist_bg, panel chi tiết bên trái, lưới đồ cuộn ở vùng chính bên phải,4 tab dọc mép phải, filter con trên lưới. Ô chọn có highlight, lượng sở hữu/tiến độ; kho trống hiện fox/fox_tip. Số cột tính từ chiều rộng thực tế. Package dùng tableview/draglist để tái sử dụng ô.

## 2. Hành vi theo loại

- Chọn ô cập nhật icon/tên/amount/stat/Description/Comment và nguồn nhận; state chọn/scroll được giữ khi refresh.
- Gears sắp Forged trước Primal rồi loại khác; quality giảm dần rồi ID. Items theo nhóm Activity/Treasure/Normal/Develop/Ugc, cờ batch-use và thứ tựorder. Shards ưu tiên loại đã đủ mảnh để ghép.
- Sell chỉ xuất hiện khi Sell Price>0 và loại tiền được hỗ trợ; popup có chọn số lượng/tổng tiền/confirm. Không tự mặc mọi gear từ kho: nhánh thông thường ẩnUse đối với gear, còn equip hiện tại trong Zatod đi qua HeroBase.
- Shards: amount/needCount, Compose/QuickCompose, trừ mảnh và vàng. Soulstones: amount/need, summon nếu chưa sở hữu Hero, evolve nếu đã sở hữu và đủ điều kiện; cần bảngHero/chi phí/threshold.
- Use của Items phụ thuộc loại: hồi thể lực, rương ngẫu nhiên/chọn thưởng, thẻ tháng… Có batch-use và item hết hạn/instance đặc biệt. Không được gắn một nútUse chung rồi coi mọi món xử lý giống nhau.
- ĐồEXP hiện có ConsumeType经验丹; Package.refreshLeftPanel không bậtUse theo nhánh này, getUseHandler không có nhánh cộngHeroEXP trực tiếp. Luồng dùng thuốc đã xác nhận ở Hero/upgradewindow.lua, chọn targetHero/level rồi consume_exp_items. Không suy Inventory gốc có sẵn popup chọnHero cho thuốc.
- Nguồn Crystal lấy equip.Drop/HowToGet. Zatod giữ D29: nguồn chỉ hiển thị, không tựteleport/auto-walk/openstage khi bấm.

## 3. Dữ liệu Zatod hiện có

117 ItemDefinition, Inventory chỉ giữ GUIDId/ItemId, gold trongCurrencies và stamina riêng trênCharacterData. Chỉ đọc item thật trong Account.Inventory, không đổ toàn bộ117 loại vào kho nếu chưa sở hữu. Equipped/Absorbed/Retired không được tính lại thành đồ rảnh trong kho.

|Tab theoCrystal|Số loại được hỗ trợ trong configactive, không phải số đang sở hữu|
|---|---:|
|Items|5 thuốcEXP, đều SubTabDevelop trong source|
|Shards|16 loại mảnh trang bị|
|Gears|96:39Forged +36Primal +21Scroll|
|Soulstones|Chưa có định nghĩa/flow triệu hồi/nâng sao trong prototype|

ItemKind hiện có Equipment75/Fragment16/Material21/Consumable5. Riêng Material21 hiện đều là scroll, nhưng không nên hardcode mọi Material tương lai đều là scroll. ItemKind.Equipment cũng chưa phân Forged/Primal. Cần metadata presentation tương ứng nếu muốn giữ chính xác bộ lọcCrystal.

ItemDefinition đã có Name/Icon/Quality/LevelRequirement/stats/ItemKind và HeroExpValue. Chưa có Description/Comment, SellPrice/CanSell hoặc phân loại Inventory chi tiết.117/117 mónactive đều có SellPrice dương và SellPriceTypeGold ở nguồn, nên bán đồ hiện tại có thể giới hạn vàng mà không mở currency khác.

42 món có HeroStats phụ thuộc Hero ngoài PreciseStats chung (ví dụ Boxing Gloves có HP54/armor0.45 và thêmdamage3 cho một sốHero). Viewcraft hiện biết Hero nên cộng đúng phần này. Inventory chưa chọnHero: phải chốt hiển thịstats chung hoặc có lựa chọnHero để xem bonus; không chọnHero tùy tiện rồi trình bày nhưstat phổ quát, không đưa STR/AGI/INT đã bỏ trở lạiUI.

## 4. Khác biệt GUID/slot phải giữ

Crystal thường một ô theo loại + số lượng xN; D12 Zatod đã chốt một món mộtGUID/mộtslot. PhaseInventory chưa có chỉ dẫn đổiD12, vì vậy mặc định đề xuất vẫn mỗiGUID một ô. UI có thể hiện tổng số cùngloại ở panelchi tiết mà không stack dữ liệu. Muốn gộpô hiển thị phải xin chốt riêng, không coi lời gợi ý gộp của agent ở roadmap là quyết định người dùng.

Bán/dùng phải xác định đúng GUID đang chọn; batch nếu có cần định nghĩa tậpGUID rõ. Không tiêu đồ đang mặc/hấp thụ/retired; không tin count/GUID/giá client tự khai. Khi list thay đổi giữ item đang chọn nếu còn, nếu đã tiêu thì chọnô hợp lệ kế tiếp, giữ vị tríscroll.

## 5. Tái sử dụng và phần cần làm thêm

- NútInventory world hiện chưa cócallback. Cần view/controller, mở từ shortcuts, Back/Close về đúng world/map, khóa WASD/joystick khi modal mở, không đổi đảo/teleport.
- Reuse icon/qualityframe, commoncurrencyrow, craft backend55recipes/GoldCost và operationledger; sources theo poolactive và D29.
- ZatodEquipmentView.Open hiện bắt buộc heroId/slotId và tínhstats theoHero. Muốn mở từInventory cần entrypoint chi tiết theoitem/GUID và contextHero tùy chọn; không fakeHero/slot để tận dụng modal.
- Sell chưa cócommand/transaction. Nếu duyệtSell cần metadata giá và receipt/rollback gồm tiền+GUID, idempotency, chặnthao tác trongtrận theo quy tắc hiện hành và kiểm tra reconnect/retry nhưcraft.
- Use thuốcEXP, mởrương, hồi thểlực bằngitem, Soulstones/summon/starup, batch/QuickCompose chưa được tự mở. Tách rõ nút chỉ hiện art với nút thực hiện server transaction.
- Giữ nativeasset/uGUI, landscape safe area16:9/19.5:9/20:9/4:3; lưới có pooling/virtualization vì mỗiGUID mộtô dễ lên hàngtrăm món. Không tự thêm giới hạn dunglượng kho hoặc red dot.
- Không tự thêm nguồn farm EXP ở phase này theo chỉ dẫn mới nhất; ôthuốc chỉ có nếu Account.Inventory thực sự có GUID (devgrant hiện có dùng đểtest).

## 6. Asset audit

Main package.lua tham chiếu27 ảnh và tìm đủ27/27 trong raw. Các layout fragment/stone/detail/sell/quickcompose/dialog/source cũng tìm đủ đường ảnh được liệt kê. package_item.lua có3 đường literal chưa tìm thấy: HVGA/equip_frame_white.png có native1080P/common/frame/equip_frame_white.png tương ứng sẵn; unlock_icon của SeasonArena treasure và bg_timer là phụ kiệnkhóa/hếthạn, chưa tìm thấy trong bộ recovered. Không kết luận gamegốc bị lỗi vì có thể córemap/native resolver; không giả tạo file hoặc dùngshape tạm. Phạm vicơbản chưa làm hếthạn/treasurelock không phụ thuộc2 ảnh phụ đó.

Audit machine-readable: Artifacts/CrystalInventoryReview_20261122/audit.json, gồm10layout,117mapping item, sourcehash và metadata nguồn. Chưa copy/import sprite hoặc tạo prefab trong lượt khảo sát.

## 7. Các điểm cần duyệt trước thực thi

1. Giữ4 tab nhưCrystal và Soulstones placeholder, hay tạmẩn tab chưa làm; giữfiltercon đầy đủ hay chỉ các filter códata trong phase này.
2. Phạm vi action: chỉxem/recipe/GetWay, hay nốiSell/Compose trongphase này. ThuốcEXP dùng từHeroLvUp hay mở rộng thêm chọnHero từInventory; nguồn farm vẫn đểsau.
3. Cách hiển thị bonusstats khi chưa cóHero context; giữ mộtGUID/mộtô theoD12 trừ khi có chỉ dẫn mới.

Đề xuất agent: lấy layoutCrystal, làm các tab/chi tiết códata thật; reusecraft/source quaentrypointInventory, Soulstones chưa giao dịch. Sell vàconsume chỉ active khi đã chốt đủ flow, không nhận mặc định mọi feature củaCrystal là phạmviphase. Đây chưa phải kế hoạch đã đượcduyệt.

## 8. Đối chứng bốn ảnh người dùng cung cấp ngày 22/11/2026

Lượt này tiếp tục khảo sát, không phải lệnh thực thi Inventory. Bốn ảnh lần lượt đúng với Items, Shards, Gears và Soulstones trong `ui_new/modules/package/Package.lua`. Các số lượng, giá và trạng thái trong ảnh là dữ liệu của tài khoản tham chiếu, không phải mặc định cho Zatod.

| Ảnh | Dữ liệu có thể tái sử dụng | Khoảng trống còn lại |
|---|---|---|
| Items | ItemDefinition có tên, ảnh, quality, ItemKind, HeroExpValue; ItemData có GUID; 5 loại đồ EXP đã import | Metadata phân tab/filter, Description/Comment; handler sử dụng theo từng loại nếu được duyệt. Các ticket/rương/sự kiện trong ảnh chưa nằm trong 117 định nghĩa hiện tại |
| Shards | 16 loại mảnh; cả 16 đều xuất hiện trong đúng một recipe hiện tại. Có thể suy item đích, số mảnh cần, sản phẩm và phí từ CraftRecipes | UI tiến độ và entrypoint craft không cần Hero; Quick Craft là thao tác mới, cần chốt phạm vi và xử lý thiếu vàng/nguyên liệu |
| Gears | 96 loại thuộc Forged/Primal/Scroll; stats, quality, level requirement có sẵn | Metadata phân filter; giá bán; giao dịch Sell; cách trình bày bonus phụ thuộc Hero khi chưa chọn Hero |
| Soulstones | HeroDefinition có art/tên, HeroData có level/sao/bậc của Hero sở hữu | Chưa có item Soulstone, liên kết Hero, InitialStars, config triệu hồi/nâng sao và giao dịch tương ứng. Phải có danh sách Hero chưa sở hữu để dựng nửa dưới, không thể chỉ duyệt Account.Inventory |

### Bổ sung model đề xuất, chưa duyệt

- Giữ `ItemData.Id/ItemId`, không thêm Quantity hoặc lớp FragmentData riêng. Thông tin dùng chung đặt trên definition/config, không nhân bản vào từng GUID.
- Thêm metadata hiển thị cho ItemDefinition: nhóm Inventory và nhóm filter; Description và Comment khi nguồn có; SellPrice (Gold trong bộ hiện tại). Giá 0 có thể quy ước không bán; nếu cần chính sách độc lập thì mới thêm CanSell, tránh hai field mâu thuẫn. Không suy mọi Material tương lai đều là Scroll.
- Số lượng sở hữu, tiến độ mảnh, đủ điều kiện craft, selected GUID và trạng thái sở hữu Hero là dữ liệu tính lúc hiển thị. Không lưu thêm một số dư mảnh hoặc thanh tiến độ song song với Inventory.
- Soulstones cần liên kết item với Hero bằng một nguồn config duy nhất; có thể đặt SoulstoneItemId/InitialStars ở HeroDefinition. Bảng rule theo sao chứa ngưỡng và chi phí triệu hồi/nâng sao. Tên field cụ thể chưa chốt. Số sao đang có vẫn lưu HeroData.Stars, không đặt lại từ InitialStars khi load Hero cũ.
- Bằng chứng nguồn chính xác: `ui/readhero.lua:1660` dùng `Unit.Initial Stars` và `HeroStars.Summon Fragments` cho Hero chưa có; Hero đã có dùng hàng sao kế tiếp `HeroStars.Upgrade Fragments`. `getSummonCost` lấy Summon Price. `HeroStars.lua` còn có Upgrade Price; `fragment.lua` liên kết Hero với Fragment ID. Không dùng tên bảng UnitStars (nguồn thực tế là HeroStars).
- Triệu hồi/nâng sao không phải equipment craft thông thường: phải tạo/cập nhật HeroData, tiêu đúng GUID đá và vàng, có receipt/rollback/idempotency nếu được triển khai. Khả năng dùng đá phổ thông trong Crystal không tự trở thành phạm vi Zatod.

### Lưu ý khi lấy layout ảnh

- Grid xN trong ảnh khác D12: mặc định Zatod vẫn một GUID một ô. Panel Owned có thể đếm tổng loại đang ở kho; đó không phải thay đổi lưu trữ thành stack. Muốn gộp ô ở riêng tầng hiển thị cần người dùng chốt riêng.
- Shards có thanh owned/required ở ảnh, nhưng áp cho Zatod một GUID một ô sẽ lặp thanh của cùng loại; có thể giữ theo rule hiện tại hoặc bàn cách gộp chỉ trong view. Không tự thay D12 vì thấy ảnh có progress.
- STR trên ảnh Gears không đưa trở lại Zatod. Với 42 món có HeroStats, đề xuất hiển thị stats chung và ghi rõ bonus theo Hero, hoặc bổ sung chọn Hero xem thử; chưa duyệt phương án cuối.
- Nguồn nhận hiện tính được từ 39 ải đang active. Chỉ hiện nguồn đã có dữ liệu; không tạo Quests/Mall/Recruitment giả như ảnh. Giữ D29 nguồn chỉ đọc.
- Cột số lượng/EXP/Soulstone không được điền số giả. Soulstones có thể là tab chưa có dữ liệu/chức năng nếu phase không gồm triệu hồi/nâng sao; đây chỉ là lựa chọn đề xuất.
- UI cần safe area và số cột thích ứng màn ngang; giữ panel chi tiết và bốn tab dễ thao tác. Dùng asset gốc đã audit, không lấy nguyên ảnh screenshot làm giao diện.

Chưa sửa C#, runtime config, scene, prefab, asset hoặc Owned; không chạy build/test gameplay cho lượt chỉ khảo sát này.

## 9. Làm rõ stats, metadata và phương án Soulstones

Ngày22/11/2026. Người dùng xác nhận mỗi item một ô, ảnh chỉ tham khảo; yêu cầu nối phần chức năng trong phase Inventory và để source trống cho item chưa có nguồn. Xem D31 cho phần đã chốt. Các phương án chi tiết dưới đây đang được trình bày, chưa sửa runtime.

### Ví dụ stats đã kiểm tra trực tiếp

`Items.txt` hiện có Boxing Gloves of Strength (`boxing_gloves_of_strength`): PreciseStats health54, defense0.45; HeroStats cộng damage3 cho Coco/OK/SNK/Tiny/Axe/ES. Lina không có dòng damage3 này.

Source equip102 chỉ có STR3, không có AD. `Scripts/Import-CrystalConfig.py:43` quy đổi STR thành health18 và defense0.15 mỗi điểm; phần thuộc tính chính cộng AD được giữ trong HeroStats theo Hero. Vì vậy đây là hệ quả của D05 giữ balance nguồn khi bỏ STR/AGI/INT, không phải hiệu ứng đặc biệt mới của găng. Trong Zatod không cần tra STR ở runtime; phần cộng đã là stat trực tiếp. Đề xuất Inventory hiển thị HP+54, Physical Armor+0.45 và ghi riêng Physical ATK+3 áp dụng cho danh sách Hero, còn view đang chọn Hero hiện số áp dụng thực tế. Không tự thay đóng góp stats hiện tại khi làm Inventory.

### Metadata và các filter

Metadata là thuộc tính mô tả/phân loại chung của loại item, thuộc ItemDefinition/config. Không thêm lặp vào từng GUID.

- InventoryTab xác định một trong bốn tab. InventoryFilter là nhóm con theo tab, không trộn Develop và Forged thành cùng một khái niệm gameplay.
- Items: Common=thông thường; Events=sự kiện; Precious=quý; Cosmetic=ngoại hình; Develop=nuôi dưỡng/nâng cấp. Năm đồ EXP hiện tại thuộc Develop. All là không lọc, không phải nhãn riêng cần gán cho item.
- Gears: Forged=trang bị thành phẩm thuộc nhóm 合成品 của source; Primal=đồ cơ bản/thành phần 零件, không phải một bậc hiếm; Scroll=cuộn công thức, có thể là nguyên liệu craft. Scroll không phải tự bản thân recipe. Giữ recipe riêng với vật phẩm scroll có GUID.
- Ví dụ recipe thật: Bracer of Strength (Forged) cần Bracer of Strength Scroll (Scroll), Boxing Gloves of Strength (Primal), Circlet of Nobility và300 vàng. Mảnh scroll thuộc Shards; ghép mảnh ra scroll rồi scroll có thể được dùng trong recipe ra trang bị.
- Description/Comment và SellPrice nhập từ source; chỉ cần giá vàng cho bộ hiện tại. Source stage tiếp tục suy từ Campaign.DropItems, không cần nhân bản danh sách ải vào từng instance hoặc tạo nguồn Mall/Quests giả.

### Phương án Soulstones để triển khai trong phase

1. Thêm định nghĩa item Soulstone và art tương ứng cho các Hero đã có trong catalog. Mỗi viên là một GUID/một ô, không mở rộng toàn bộ Hero nguồn chỉ vì ảnh có Hero khác. Nếu cần loại ItemKind mới thì thêm cuối enum, không đổi mã đã lưu.
2. HeroDefinition chứa SoulstoneItemId và InitialStars. Config tiến sao riêng chứa ngưỡng đá/chi phí triệu hồi, nâng sao và cap theo HeroStars nguồn; có mục chỉnh trong GameEditor. Không lưu ngưỡng cần trong HeroData.
3. Hero chưa sở hữu: server kiểm đủ đá/vàng, tiêu GUID đá và vàng rồi tạo HeroData mới ở level1/Exp0/bậc khởi đầu/sao InitialStars. Không reset Hero cũ hoặc tạo trùng cùng HeroDefinitionId trong roster theo luồng này.
4. Hero sở hữu: server lấy hàng sao kế tiếp, trừ đá/vàng, tăng Stars một bậc, giữ level/Exp/rank/equipment/history và tính lại stats.25 Hero hiện tại đều có Growth các sao1..5; đây là dữ liệu sẵn có, chưa có giao dịch nâng sao.
5. Tham chiếu nguồn: triệu hồi Hero khởi đầu1 sao cần10 đá/1000 vàng; nâng1→2 sao30 đá/35000 vàng,2→3 sao80 đá/120000 vàng,3→4 sao200 đá/300000 vàng,4→5 sao360 đá/800000 vàng. Đây là cấu hình Crystal đã đọc, đề xuất nhập giữ nguyên chứ chưa phải balance mới Zatod đã được duyệt riêng.
6. Grid chỉ tạo ô cho GUID thật. Panel của viên đang chọn hiện tổng số đá cùng loại và ngưỡng theo trạng thái Hero; đủ thì bật Recruit/Star Up phù hợp. Không tạo ô item giả0 viên để mô phỏng phần Heroes Not Owned của ảnh. Nếu sau này cần bộ sưu tập toàn bộ Hero chưa có, đó là view/projection riêng cần chốt.
7. Khi không có nguồn nhận, vùng source trống; không tự thêm drop pool. Dev grant hiện có dùng cho kiểm tra. Mọi thao tác tiêu đồ/tiền và tạo/nâng Hero cần transaction có receipt, rollback và chống xử lý lặp như craft hiện tại.

Phạm vi dùng item đề xuất cho phase:5 đồ EXP hiện có, cần chọn Hero đích và dùng rule level/cap từ D30. Không suy phải implement Use cho mọi vé/rương/event trong ảnh. Quick Craft cũng là thao tác cần thêm; recipe đơn đã có không đồng nghĩa nút Quick Craft đã hoạt động.

## 10. Các quyết định bổ sung và lưu ý trước thực thi

Ngày22/11/2026, sau giải thích mục9. Người dùng chốt bỏ bonus stats riêng theo Hero của item, duyệt bổ sung metadata theo Crystal và đồng ý phương án Soulstones; mọi config thêm phải có trong GameEditor. D05/D31 là nguồn chốt chính thức. Các mô tả mục3/8/9 về42 item HeroStats và đề xuất hiện bonus là bằng chứng về trạng thái trước thay đổi, không còn là UI đích.

- Khi thực thi bỏ cả tính toán và metadata authoring HeroStats trên item active; không chỉ ẩn dòng UI. Giữ PreciseStats chung, không chuyển bonus riêng sang PreciseStats hoặc base Hero. Update importer ban đầu/crafting/chapter để không sinh lại phần này. Các tên control HeroStatsTitle/HeroStatsScroll là danh sách stats của Hero, không đồng nghĩa bonus item theo Hero và không phải đối tượng cần xóa.
- D08 cho phép balance mới tác động trang bị đang mặc và đã hấp thụ thông qua config. Giữ lịch sử/GUID/level/Exp/rank/Stars. Trận mới dùng stats mới, không đổi snapshot đã phát hành hoặc replay cũ. Balance sẽ không còn trùng hoàn toàn Crystal; đây là đổi thiết kế có chủ đích, không phải lỗi mất stats cần cộng bù.
- GameEditor: Items chỉnh metadata và stats chung; Heroes chỉnh SoulstoneItemId/InitialStars; khu config tiến sao chỉnh ngưỡng/GoldCost/cap. CraftRecipes tiếp tục dùng editor hiện có. Thay InitialStars không đặt lại Stars của Hero đã sở hữu. Config validate reference Hero/item/recipe, sao hợp lệ, số lượng/giá không âm.
- Source trống là trạng thái hợp lệ. Không đưa các dòng nguồn giả vào UI và không tự thêm EXP/Soulstones vào39 drop pool; dev grant dùng cho test.
- Đề xuất Quick Craft cho phase: chỉ ghép mảnh thành sản phẩm trực tiếp ở tab Shards, không tự craft đệ quy toàn bộ chuỗi trang bị. Trước khi xác nhận hiện danh sách đầu ra, nguyên liệu và tổng vàng; tính theo kho/vàng hiện có, thứ tự recipe ổn định để kết quả không tùy thứ tự dictionary. Chính sách chọn số lượng/thứ tự ưu tiên cần thể hiện rõ trong flow; chưa coi là quyết định người dùng đã chốt riêng.
- Dùng đồ EXP cần Hero đích; giữ rule EXP dư/cap D30 và không tiêu đồ khi Hero không thể nhận thêm EXP. Không đưa logic tăng level mới vào một nhánh riêng khác với economy đã có.

Lượt này chỉ ghi quyết định và trả lời lưu ý, chưa triển khai runtime/Editor hoặc chạy build.

## 11. Kiểm chứng Quick Craft và preview UI dùng đồ EXP

Ngày22/11/2026. Người dùng chấp nhận giảm stats và để việc cân bằng base về sau, duyệt hướng Quick Craft trực tiếp/chọn Hero dùng EXP, yêu cầu kiểm tra UI Crystal và preview. Không thực thi gameplay.

### Quick Craft: cơ chế đã thấy trong client Crystal

- `Package.lua:7` tạo canComposeList từ kho mảnh, kiểm amount>=need, ánh xạ một makeId trực tiếp và cost từ fragment. Không duyệt graph recipe đệ quy.
- `PackageComposeWin:initData` chọn tất cả loại đủ mảnh mặc định; giá của mỗi loại là cost*floor(amount/need). Người dùng chọn/bỏ chọn loại, có chọn tất cả.
- `doReply` tạo floor(amount/need) sản phẩm, tiêu need*floor(amount/need) mảnh, giữ mảnh dư. Ví dụ12 mảnh, cần5: tạo2 món, còn2 mảnh. Không tự dùng2 món đầu ra để craft bước tiếp theo trong request này.
- Trước request `fragment_compose_auto`, client kiểm tổng vàng và chặn nếu thiếu. Không tự giảm số lượng để vừa số vàng; người chơi bỏ chọn loại. Vì vậy gợi ý cũ tự giới hạn batch theo vàng không phải hành vi nguồn đã kiểm chứng. Đề xuất Zatod giữ lựa chọn loại/số tối đa theo mảnh và báo thiếu vàng tương tự, với GUID riêng và transaction server của mình.

### EXP: flow thực sự của Crystal

- `heroDetailBase.lua:1526` mở upgradewindow với heroId và level hiện tại. Hero đã được chọn từ detail; không có picker Hero trong popup này.
- `upgradewindow.lua:58` dựng `uieditor/heroUpLevelWin.lua`: nút X, tiêu đề nâng cấp, portrait Hero, nhãn Target Level, nút trừ/cộng và nút Use; vùng dưới là icon/số lượng đồ EXP sẽ bị tiêu. Không phải picker số lượng từng loại thuốc.
- Mở popup tự tính level mục tiêu có thể đạt theo tài nguyên và cap. Nút trừ/cộng điều chỉnh level đích, hỗ trợ giữ nút. `calculateConsumeEquip` ưu tiên Potion169 rồi Salve218/Cheese290/Burger440/Pizza1609. Phần resource preview chỉ hiện loại có lượng tiêu>0.
- `confirmUpgradeHero` yêu cầu mục tiêu cao hơn level hiện tại và đủ đồ để tới mục tiêu; request `consume_exp_items` chứa Hero và danh sách loại/lượng. Chưa đủ EXP lên một level hoặc đã chạm cap thì popup có trạng thái không dùng được. Không suy đây là UI dùng một thuốc để cộng dở level.
- Từ Inventory của Zatod cần bước chọn Hero trước khi tái sử dụng popup trên, hoặc đi tới Hero Detail/Lvl Up. Đây là phần đường vào cần thể hiện rõ khi tổng hợp phase, không khẳng định Crystal có sẵn flow picker này từ bag. Đường Hero Detail/Lvl Up hiện có placeholder cần nối khi thực thi phase.

### Preview tĩnh từ nguồn, không phải screenshot game chạy

`Artifacts/CrystalInventoryReview_20261122/hero-exp-source-preview.png` được dựng từ vị trí/quan hệ node của heroUpLevelWin và21 asset gốc (background, khung, nút, portrait Lina, iconEXP). Font/Scale9 được tái dựng để xem bố cục; không cam kết pixel-perfect với engine nguồn. Level5→8 và số lượng thuốc là ví dụ minh họa, không phải tính reward/cost thực hoặc kho thật. Text English là nhãn mô tả để đọc preview.

Script tái tạo: preview_exp_source.py, audit/hash: hero-exp-preview-audit.json trong cùng thư mục. Preview dùng background herolist_bg.jpg và portrait UI/DOTA-HERO/Lina.jpg có thật; không giả lập file herolist_bg.png hoặc dLina.jpg. Không sửa asset nguồn hoặc import vào Unity.

### Kiểm tra thêm về tự tính loại/lượng EXP ngày22/11/2026

`calculateGapExp` cộng ngưỡng Levels.Exp từ level hiện tại tới level đích rồi trừ EXP hiện có. `calculateConsumeEquip` lấy từng món theo thứ tự169/218/290/440/1609 đến khi đủ hoặc hết kho. Đây là ưu tiên đồ EXP nhỏ trước, không tìm tổ hợp tối ưu ít món/ít EXP dư. Ví dụ minh họa cần200EXP và có ít nhất4 Potion60: chọn4 Potion=240EXP, dư40 nếu chưa vướng policy cap; không chọn3 Potion vì mới180EXP.

`getLevelAndExp` tính lại level/EXP từ tổng thuốc, giữ EXP dư theo curve tới giới hạn. `increaseTargetLevel` còn cập nhật targetLevel nếu một món lớn khiến level thực đạt cao hơn mức vừa chọn, tránh hứa sẽ dừng đúng level thấp hơn kết quả dùng thuốc nguyên món. Cap áp dụng theo D30 khi triển khai Zatod. Chưa mô phỏng backend Crystal; các nhận xét này là nhánh client preview đã đọc, không khẳng định đã chạy giao dịch consume trong Zatod.
