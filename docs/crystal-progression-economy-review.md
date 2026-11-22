# Crystal → Zatod: EXP, vàng và thể lực

**Quyết định mới nhất21/11/2026 — xem Design.md D30:** account và Hero giữ Level/Exp riêng. Người dùng chốt lại **Stamina và StaminaRecoveryTimestamp là hai field trực tiếp trên CharacterData, khai báo kế nhau theo thứ tự này**; Currencies hiện chỉ có vàng, enum loại tiền mới thêm cuối và giữ mã ổn định. Hướng stamina trong Currencies ở ghi nhận cũ đã bị thay thế. Thu GoldCost thật khi thực thi phase vàng; Hero dùng curve EXP chung/tiến trình riêng. Chuẩn bị định nghĩa đồ EXP; dùng chúng để phase sau. Runtime chưa đổi trong lượt tổng hợp; các dòng cũ bên dưới về vị trí lưu/miễn phí là lịch sử khảo sát. Chưa chốt tài nguyên khởi tạo hoặc cách xử lý account dev vượt cap account.

**Cập nhật sau khảo sát21/11/2026:** người dùng đã chốt giữ curve/cap/thưởng EXP, vàng và cơ chế hồi/tiêu thể lực nguồn; chuẩn bị định nghĩa đồ EXP, sử dụng chúng để phase sau. Quyết định hiện hành ở Design.md D30. Các mục đề xuất chưa duyệt bên dưới là lịch sử khảo sát trước lần chốt này; riêng vị trí lưu trong Currencies và editor cụ thể vẫn đang bàn. Chưa sửa runtime.

**Kiểm tra model bổ sung:** down.proto user có `_level` field3 và `_exp` field4, `_money` field6, `_vitality` field9. common.proto hero có `_level` field3 và `_exp` field5. Đây là các field tách riêng, không phải chung danh sách Currency. Player:addExp và Hero:addExp trừ từng ngưỡng khi lên cấp, giữ phần dư; không xóa EXP dư. Ví dụ accountLv1/24EXP nhận8 → Lv2/7EXP (ngưỡng25). vitality là object có current/lastchange/todaybuy/lastbuy. Zatod Currency hiện chỉ Id/Amount, nên gom số vào đó vẫn cần thêm quy tắc tiến trình/hồi và một nguồn dữ liệu duy nhất. Không lưu đồng thời một giá trị ở Currency lẫn field riêng rồi để lệch nhau.

Khảo sát21/11/2026, Asia/Saigon. **Chỉ đọc source/config; chưa triển khai gameplay hoặc thay config runtime.** Không có quyết định economy mới được chốt. D07/D11/D19–D20/D23/D26–D29 vẫn áp dụng, đặc biệt phí craft thực thu 0 theoD28.

Nguồn Lua dưới `Crystal Legend/recovered/scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data/` (gọi là data/); protocol ở nhánh protobuf_utf8 tương ứng. Đây là client decompile/config, không phải toàn bộ backend. Mốc cập nhật client không chứng minh nội bộ transaction/DB server Crystal. Audit máy đọc được: `Artifacts/ZatodEconomyReview_20261121/audit.json`, gồm100 dòng PlayerLevel,120 dòng Levels,39 bộ thưởng ải active,8 consumable mẫu và SHA256 của21 nguồn/config. Trích bảng bằng parser, không chạy Lua game hay test/build Unity.

## 1. EXP tài khoản (Squad/Team Level)

- Player giữ `_level`, `_exp`; EXP là phần dư của level hiện tại. `PlayerLevel.Exp[level]` là ngưỡng lên cấp kế. `player/player.lua:addExp` trừ ngưỡng, lặp lên nhiều cấp; `levelup` cộng `Vitality Reward` từ **dòng level cũ** rồi tăng level.
- PlayerLevel còn quy định Max Hero Level, Max Vitality và unlock chương/tính năng. Đây không phải level riêng của avatar SPUM.
- Nguồn xác nhận trong `player/playerinfo.lua`: takeStageReward dùng Stage.Exp Reward; takeStageFailExp dùng Fail Exp Reward; addRewards hỗ trợ type playerexp với source task. Không suy mọi mode/thoát trận đều có thưởngEXP.
- `parameter.team_level_max` mặc định100; server `_module_switch._open_level` có thể ghi đè qua initModuleSwitch. Ở cap account, client đưa EXP về0. Không suy giới hạn live từ số dòng table.

|Level tài khoản|EXP cấp kế|Cap level Hero|Trần hồi thể lực|Thưởng thể lực khi rời cấp này|
|---|---:|---:|---:|---:|
|1|25|10|60|20|
|2|25|11|62|20|
|5|30|12|65|20|
|10|130|15|70|25|
|20|130|20|80|30|
|40|1500|40|100|70|

Không áp công thức HeroLevel≤AccountLevel vào đầu game Crystal: phải lookup bảng. PlayerLevel có unlock chương2 ởLv5; chưa áp vào Zatod, vốn đã duyệt đi lại tự do giữa map.

## 2. EXP Hero

- Hero giữ `_level`, `_exp` riêng. `Levels.Exp[level]` là curve chung, khác PlayerLevel. Mẫu: Lv1→2=25, Lv2→3=30, Lv3→4=40; dòngLv10=180, Lv20=300, Lv40=2600.
- `hero.lua:addExp/levelup`: đủEXP tự lên level, trừ ngưỡng và giữ dư, có thể lên nhiều cấp. Level là trục riêng với rank trang bị và sao.
- Cap lấy PlayerLevel[AccountLevel].Max Hero Level. Khi chạm cap, Hero giữEXP tối đa bằng ngưỡng cấp hiện tại, phần vượt bị cắt; khác account cap đưaEXP về0. Chưa xác minh toàn bộ refund/overflow của backend khi dùng thuốc sát cap.
- takeStageReward tính `floor(Stage.Heroexp Reward / số Hero tham chiến)` cho mỗi Hero không phải lính thuê. Đoạn cấp thưởng không kiểm tra còn sống; không chỉ thưởng Hero sống. Không phân phối lại phần lẻ hoặc phần bị cap cho Hero khác.
- Stage1 tổng60EXP: đội5 nhận12 mỗi Hero; đội3 nhận20. Account vẫn nhận6 độc lập. Stage18 tổng101, đội5 mỗi Hero20.
- Arena có đường takePVPReward chia PlayerLevel.Arena Hero Exp cho đội; không khẳng định tất cả mode PvP cùng trảEXP.
- `ui_new/modules/hero/upgradewindow.lua`: chọn target level, tính đồ tiêu hao, gửi **consume_exp_items** gồm HeroID + item/count; success thì trừ đồ và reset Hero theo `_hero` server trả. Protocol consume_item cũ cũng hỗ trợ EXP đơn lẻ. Đường nâng level này không khai báo phí vàng riêng.

|ID nguồn|Tên English chính thức|EXP/món|
|---|---|---:|
|169|EXP Potion|60|
|218|EXP Salve|300|
|290|EXP Cheese|1500|
|440|EXP Burger|7500|
|1609|EXP Pizza|75000|

Giá trị equip.Exp, tên từ texttable/texttable.lua. Levels có120 dòng không có nghĩa Hero live chắc lên được120, do cap phụ thuộc account/config server.

## 3. Vàng

- Player giữ `_money` dạng số dư. addMoney chặn thấp hơn0 và phát sự kiện resource UI; clamp client không thay validation server.
- Thắng ordinary stage nhận Stage.Money Reward; không roll theo MaxDropAmount hoặc theo kết quả roll item. stageaccount.dealVictoryParam lấy cùng field để trình bày.
- addRewards hỗ trợ money/gold; còn có sweep, bán đồ, Midas và thưởng hệ thống. Không cần mở toàn bộ các nguồn đó chỉ để thêm vàng Phó bản.
- Sink đọc được trong network/network.lua: equip_synthesis_reply trừ expense, fragment_compose_reply trừ cost, hero_evolve_reply trừ cost; shop có thanh toán money. Không suy mọi lần nâng level Hero đều cần vàng.
- Với Zatod có thể dùng Currencies đã chốt, không tạo itemGUID cho từng đồng. ID currency và balance chưa được chốt trong lượt khảo sát.

## 4. Thể lực

- Protocol vitality giữ `_current`, `_lastchange`, `_todaybuy`, `_lastbuy`; sync_vitality_reply thay trạng thái client bằng server.
- parameter.sync_vitality_gap=360: hồi1 mỗi6phút. player.refreshVitality tính từ getServerTime và lastchange, bù các khoảng thời gian đã qua. Không cần app mở liên tục để suy lượng hồi offline.
- Trần hồi tự nhiên từ PlayerLevel.Max Vitality; Lv1=60, Lv40=100. playerlimit.maxVitality còn có modifier tháng trả phí, không coi một công thức giản lược là toàn bộ rule.
- Đạt/vượt trần thì ngừng hồi tự nhiên. Thưởnglevel/mua/đồ có thể vượt trần hồi. max_vitality_stock=500 là ngưỡng chặn trước một số thao tác mua/dùng đồ UI; **không thấy clamp chung mọi khoản cộng về500** trong addVitality.
- battlePrepare.gotoBattle, sau reply vào trận: trừ `Vitality Cost - Vit Return`. downExit sau thắng được xác nhận: trừ tiếp Vit Return. Thua không chạy bước trừ thêm. Tên Return nhưng code chia khoản trừ thành hai bước.
- 39 ải active nguồn đều Cost6/Return5: vào mất1, thắng tổng6, thua mất1. **Vẫn phải đủ6 để bấm Challenge**, vì stagedetail.checkEnabled/clickgo so với toàn bộ Cost. Fail Exp Reward=1 dùng ở các nhánh fail/timeout gọi takeStageFailExp. Chủ động thoát result2 là nhánh khác, không tự khẳng định cũng có1EXP.
- UI mua mô tả120 thể lực/lần; GradientPrice.Vitality cho hai lần đầu50diamond, lần3=100; giới hạn lượt theoVIP. Server sync số dư. Có đồ hồi6/18/30 và đồ sự kiện. Vitality table có Lunch/Dinner mỗi120 ở các khung giờ config. Chưa duyệt triển khai mua/giờ ăn/VIP trong Zatod.

## 5. Thưởng39 ải đang tham chiếu

|Ải|SourceID|EXP account thắng|TổngEXP Hero|Vàng|Cost|Return|EXP fail|
|---|---:|---:|---:|---:|---:|---:|---:|
|1-1 Embarkation|1|6|60|495|6|5|1|
|1-18 Dogmatic Suffering|18|6|101|652|6|5|1|
|2-1 Endless Journey|19|6|102|489|6|5|1|
|2-21 Swordplay|39|6|119|854|6|5|1|

39/39 Cost6, Return5, account win EXP6, fail EXP1. Hero EXP chương1=60–101/chương2=102–119; tiền không tăng đơn điệu theo thứ tựải. **Zatod chỉ mới importCost; chưa có field thưởngEXP/vàng/Return/fail này trong model active.** Chi tiết audit.json; không nhầm Stage1001 với Stage1 thường.

## 6. Các phần Zatod chưa làm ở phase trước

|Phần|Đã có|Còn thiếu / chủ động để sau|
|---|---|---|
|Account EXP/level|CharacterData.Level=1, Exp; serializeOwned; label SquadLevel|Curve, cộngEXP/lênlevel, thưởngthể lực, capHero theoaccount, UI tiến trình|
|Hero EXP/level|HeroData.Level/Exp; growthstats; level mặcđồ; DevLevel|Curve, thưởng trận, cap/phần dư, dùng đồ EXP, handlerLvlUp và view nâng level|
|Vàng|Currencies; icon; CraftRecipe.GoldCost|Sốdư nhận/tiêu thật, rewardstage; phícraft vẫn0 theoD28|
|Thể lực|VitalityCost, UI Cost39ải|State/timestamp/cap, hồi online/offline, đủ/trừ khi vào, thắng/thua/cancel, sync/persist|
|Thưởngtrận|Server cấp itemGUID sau checker; SaveOwned; receipt/rương/popup|ReceiptEXP/vàng + trước/sau level/EXP; commit/rollback chung, chốngcấp lại|
|UI tài nguyên|Roster/detail cóicon diamond/gold/stamina, nútcộng|??, chưabind/handler; diamond chưa được yêu cầu triển khai|
|UI kết quả|ArtthanhEXP, sao, Hero/item thật|Team EXP0/0, Hero EXP0/0, vàng? theoD27; chưa chạy tăng EXP/level|
|Consumables|112 item Equipment/Fragment/Material; GUID/craft/equip|Chưa metadata tácdụngEXP/vitality và commandconsume; chỉimportảnh chưa đủ|
|GameEditor|Combat/items/craft/maps/campaign|Chưa bảng curvePlayerLevels/HeroLevels/ruleEconomy|

Code đối chiếu trong Unity/Assets/Zatod: Heroes/HeroData.cs, HeroDefinitions.cs, CampaignDefinitions.cs, CraftingDefinitions.cs; Combat/ZatodPlayerSession.cs; ArenaNetwork/ZatodServer.cs; Presentation/ZatodBattleResultView.cs, ZatodHeroDetailView.cs, ZatodHeroUi.cs. Validate hiện chỉ grantItems và rollback appendInventory khiSave lỗi; thêm nhiều loại thưởng cần mở rộng receipt/transaction, không chỉ sửa label.

## 7. Điểm cần bàn trước triển khai — đề xuất, chưa duyệt

1. Curveaccount/Hero và39 bộ thưởng theoCrystal cho prototype; chốt cap đích, không nhầmDevLevel40 hoặc sốdòngtable thành cap.
2. Giữ chiaEXP đội/cap/phần dư nhưCrystal hay đổi; cần thuốcEXP ngay hay thưởng trận trước.
3. Thể lực giữ chia1+5 hay cáchkhác; cancel/disconnect/retry, timestamp server/hồi offline, cộngvượttrần. Mua diamond/giờ ăn chưa tự mở.
4. Có vàng không tự bật phícraft: D28 vẫn thực thu 0 tới khi người dùng đổi quyếtđịnh.
5. Server cấp thưởng kinh tế sau kết quả đã kiểm chứng, cùng item/save và receipt trước/sau; replay/Continue/retry không grantlại. Snapshotcombat giữ level đầu trận; lênlevel sau trận không đổi chỉ số đangvalidate.
6. SaveEXP/tài nguyên không thayD11 resetải theo launch; không tự khóa đi map2 theoLv5 như unlockCrystal.
7. EXP chưa giải quyết nguồn14 loại gear cònthiếu để5starter tớiBlue và UI Promote; xem zatod-progression-loop-review.md. Không tự đổi pool, QuickEquip, nâng sao/skill/shop trong lượt này.

Không phát hiện lỗi runtime mới; các placeholder là phần chủ động hoãn. Không ghi chúng thành bug đã sửa.

## Làm rõ mốc hồi online/offline — 21/11/2026

Timestamp hồi là mốc tính chu kỳ thể lực, không phải thời gian đăng xuất. Online/offline dùng cùng công thức thời gian server đã qua; logout/login không reset phần phút đang tích. Ví dụ thiếu thể lực, mốc10:00, đăng xuất10:03 và vào lại10:05: chưa cộng điểm nhưng chỉ còn1 phút tới lần hồi10:06. Nếu online liên tục thì cũng hồi ở10:06. Khi nhiều khoảng6 phút đã qua, cộng đủ số khoảng trong giới hạn trần và tiến mốc theo các khoảng đã xử lý để giữ phần dư. Khi đầy/vượt trần không tích thêm thời gian.

Nguồn Crystal: player/player.lua refreshVitality/refreshVitalityTime/getVitalityNextUpdate dùng _lastchange và getServerTime; ui_new/base/commonscene.lua:getVitalityPromptText gọi refresh và lấy thời gian còn lại. Nguồn này không chứng minh lịch chạy timer nội bộ backend Crystal. Hướng Zatod để triển khai: server tính/commit số dư, kiểm tra định kỳ khi online và trước thao tác liên quan; client chạy countdown/nhận sync. UI countdown không tự cấp thêm số dư server. Chưa chọn tần suất scheduler hay sửa runtime.

## Làm rõ avatar và item đã có ở nguồn — 22/11/2026

Zatod có một tiến trình player ở CharacterData.Level/Exp; avatar SPUM là phần hiển thị của player theoD21, không thêm AvatarLevel độc lập. Năm EXP item đã tồn tại trong equip.lua và có ảnh raw UI/DOTA-ITEM/501.jpg,502.jpg,503.jpg,440.jpg,1609.jpg. Items.txt active112 dòng chưa có5 dòng hoặc reference5 icon này. Import các dòng vào bảng item chung, dùng lại ItemDefinition/ItemData, không tạo5 class/ảnh mới. Hành vi tiêu hao cộngEXP để phase sau, chưa sửa runtime.

## Nguồn nhận đồ EXP Crystal — 22/11/2026

Đã tra equip/ActStageGroup/Stage và localization chính thức: Hero Trial → Tides Temple (潮汐神庙), group20001. Group liệt kê16 độ khó, DailyLimit8, mở tất cả ngày trong tuần, Display Time Schedule mỗi ngày05:00, CD0. Các stage mẫu có VitalityCost0; mức1/source20001 mởLv25, UIreward169/218; mức2/21001 mởLv25 và mức3/22001 mởLv30 có169/218/290; mức8/27001 mởLv50 có290; mức11/29101 mởLv70 có440/290. Đây là danh sách thưởng UI/config, chưa xác minh xác suất/số lượng backend.

How To Get của169/218/290 là Hero Trial;440 là Quests nhưng group/Tides Temple độ khó cao cũng hiển thị440.1609 không có HowToGet/Drop nên chưa kết luận nguồn. equip.Drop của169 còn liệt kê1/4/7/11/15/18/20/23/27/30;218 liệt kê117/120/123/126/129/132/134/137/140/146. Chỉ kết luận metadata nguồn đã liệt kê, không suy drop đảm bảo hoặc tỷ lệ từ danh sách đó; UIreward của stage thường không nhất thiết liệt kê toàn bộ loot. Zatod39ải hiện không có5itemEXP trong DropItems; D30 chỉ thêm định nghĩa/ảnh và thưởngEXP trực tiếp. Chưa tự mở HeroTrial, đổi pool hoặc thêm nguồn nhiệm vụ trong lượt kiểm tra. Evidence Artifacts/CrystalExpItemSources_20261122/audit.json.
