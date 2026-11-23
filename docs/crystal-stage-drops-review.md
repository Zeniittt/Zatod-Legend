# Crystal — Config ải, preview drop và loot thực nhận

Khảo sát 20/11/2026. Chỉ đọc source/config/protocol đã khôi phục, không sửa runtime Zatod, Unity scene/prefab hoặc config hoạt động. Đây là hành vi quan sát từ client Crystal, không phải thiết kế mới được duyệt cho Zatod. Không có đủ backend để khẳng định thuật toán random/commit chính xác.

## Kết luận

Có danh sách ID phần thưởng ngay trong Stage, nhưng không phải một list trang bị với tỷ lệ/số lượng đã biết. Cần phân biệt:

1. **Preview:** Stage có `UI reward1..10`, là Item ID dùng dựng icon trước trận. Code UI quét tới 20 tên cột để chịu nhiều phiên bản, bản Stage đã đọc có 10 field.
2. **Loot lượt đánh:** response enter_stage_reply có `_loots` do server cấp sẵn cùng `_rseed`. Client đọc nó để biết wave/slot quái/phe và Item ID. Không lấy toàn bộ icon preview rồi trao tất cả sau thắng, không thấy client tự random từ UI reward.
3. **Thưởng nền:** Stage còn có Money Reward, Exp Reward, Heroexp Reward, Vitality Cost/Vit Return; tách khỏi list item.
4. **Ngoại lệ:** Battle có FD Bonus 1..5; Stage có Select Reward/Select Reward Yield, Chest For FD; DropLimit chứa một số rule điều kiện đặc biệt. Không coi đây là bảng xác suất đầy đủ của phó bản Thường.
5. **Bổ sung sau đối chiếu sâu 20/11:** `Chest.lua` có 3.085 dòng, các cặp `Loot N ID` / `Loot N Yield` (N=1..128), kèm `Chest ID`, `Hero ID`, `Rank`, `TimelytLoot ID/Yield`. Vì vậy APK **có chứa hệ số loot theo nhân vật/quái và bậc**. Kết luận trước chỉ xét Stage/Loot/DropLimit chưa đủ để nói APK không chứa dữ liệu tỷ lệ. Chưa tìm được code backend tiêu thụ Chest để xác nhận công thức xác suất cuối của Campaign.

## Preview dùng thế nào

`ui_new/modules/stage/stagedetail.lua:974` lấy Stage, đọc từng `UI rewardN`, bỏ ID 0, tra item trong equip. Có kiểm tra isEquipOpen, Invisible và `checkDropSituation` (đọc Loot). Còn có nhánh thêm drop event, nhiệm vụ hoặc phần thưởng được chọn. Vì vậy raw list không nhất thiết giống toàn bộ icon nhìn thấy ở mọi tài khoản.

`equip` là bảng vật phẩm chung: Category gồm trang bị/thành phần, mảnh, linh hồn thạch, vật phẩm tiêu hao… Một số ID được itemType xử lý dạng Hero. Không suy từ tên equip rằng mọi entry là một món đồ mặc trên Hero.

Ví dụ nguồn:

| Ải | UI reward khác 0 |
|---|---|
| 1 | 101 (树枝 / Branches), 102 (力量拳套 / Boxing Gloves of Strength), 20555 (赤晶, vật phẩm tiêu hao) |
| 2 | 101 (Branches), 111 (Ring of Regen) |
| 3 | 108 (Iron Axe), 109 (Small Stout Shield) |
| 10006 Tinh Anh | 381 (linh hồn thạch 光法), 104, 112, 20555 |

Ví dụ ải 3 không có nghĩa mỗi lần thắng chắc chắn nhận cả rìu và khiên. Chương 1 Thường có 11 Item ID khác nhau trong raw preview; 10 ID đã có định nghĩa/mapping trong bộ 67 trang bị Zatod, ID20555 chưa nhập. Loot metadata của 20555 có Drop Situation=Least Level, Situation Param=81, nên UI có điều kiện level khi xét icon này.

## Đường loot trong client

```text
Stage.UI rewardN → tra equip/Loot → icon xem trước

enter_stage(StageId)
  → server reply {rseed, loots}
  → network.lua ghi ed.player.loots
  → quái chết: BattleScene.showMonsterLoots
  → Player.getStageLootOfMonster lọc theo wave, slot quái, phe
  → BattleSceneUI dựng Loot/chest bay, marker thu thập
  → kết thúc: gửi exit_stage(result, stars, heroes, operations,…)
  → reply known và thắng: downExit → takeStageReward
  → client cập nhật tiền/EXP/item và màn kết quả
```

Đây là đường client quan sát được. `_loots` đã có khi vào trận, không phải danh sách tùy chọn để client tự sửa/gửi lên ở exit_stage; message exit_stage đã đọc không có field khai báo loot. Không suy rằng seed combat tự đủ để khôi phục loot vì response có payload loot riêng và không có bằng chứng RNG loot dùng cùng nguồn.

`Player.getStageLoots` decode lại `_loots` để dùng cho settlement. Nhánh hiện tại còn hỗ trợ hpLoots cho mode đặc biệt; không tự mở rộng luật đó cho Campaign thường.

## Bảng Loot và DropLimit

- Loot keyed by Item_ID, có Name, Category, Range, Drop Situation, Situation Param. Không có field chance/yield của từng item theo từng Stage. Chưa xác minh cách backend dùng Range; không gọi Range=1.6 là 1,6% hay tỷ lệ khác.
- DropLimit keyed Stage ID → Monster ID, có Limit Type/ID/Amount và Drop Type/ID/Amount/Location/Loot Yield. Bản này có 33 dòng trên 33 Stage, không dòng nào cho Stage 1..18. Đây không cung cấp toàn bộ quy tắc random thông thường chương 1.
- Các FD Bonus tồn tại trên Battle rows (ví dụ Stage1 wave3 slot1 có item108). UI có nhánh `isSpring && stagefd && !Chest For FD` đọc FD Bonus dạng cặp; dữ liệu ordinary mẫu là list một ID. Không tự coi nhánh UI ấy là chứng cứ đầy đủ về cách backend cấp thưởng đầu của mọi mode.
- Select Reward liên quan chọn item qua UI và dữ liệu người chơi riêng; 18 ải Thường chương 1 đang có list rỗng. Không cần mở hệ thống chọn drop để giải thích raw preview chương 1.

## Giới hạn và đối chiếu Zatod

Chưa có thuật toán backend roll loot thường: xác suất, trọng số, số lần roll/số lượng, bảo hiểm hoặc chống rớt lặp chưa được chứng minh từ các bảng/client đã đọc. Có thể khôi phục preview trực tiếp; muốn mô phỏng loot thật phải có thiết kế riêng hoặc thêm nguồn backend, không tự bịa tỷ lệ rồi gọi là rule Crystal.

### Bổ sung: Chest chứa hệ số loot, chưa có consumer backend

`Chest.lua:811360` là schema; `Chest ID` là khóa thật. `Hero ID` tham chiếu loại Unit (cả Hero và quái), `Rank` là bậc cấu hình; không gọi đây là bảng keyed duy nhất theo (Hero ID, Rank): có 19 tổ hợp lặp trong bản này. Có 127 Unit ID, Rank 0..18, tổng 3.085 dòng.

Ví dụ `Chest.lua:366099`, Chest ID1393, Hero ID101 = Unit Treant, Rank1:

| Item ID | Item nguồn | Loot Yield |
|---|---|---|
| 101 | 树枝 / Branches | 0.00469 |
| 102 | 力量拳套 / Boxing Gloves of Strength | 0.00403 |
| 108 | 补刀斧 / Iron Axe | 0.00202 |
| 109 | 小圆盾 / Small Stout Shield | 0.00202 |

Unit101 xuất hiện ở Stage1, wave1 slot1 và các slot khác. Battle để Rank0; client `battle/unit.lua:276` ước lượng rank khi không chỉ định: floor((level+9)/10), nên Unit level1 được rank1. Đây là đối chiếu dữ liệu nhân vật/bậc, **chưa chứng minh backend chọn Chest1393 khi roll đồ của quái đó**.

Không có consumer `getDataTable("Chest")`/`lookupDataTable("Chest")` hoặc `Loot N Yield` trong recovered Lua đã tìm, ngoài định nghĩa bảng. Không được nhân Yield với100 rồi báo đó là xác suất cuối mỗi lần đánh ải. Chưa biết backend dùng nó trực tiếp, chuẩn hóa, nhân với cost/level/boss/event, nội suy rank, hoặc còn điều kiện khác. Những cách này chỉ là khả năng, chưa phải hành vi đã xác nhận.

`SpecialLoot` có 13 dòng, Type=Consume_Vitality trong mẫu, condition/float và Item Amount. `activityData:getStageExtraDropItem` đọc bảng này theo event stage_extra_drop để thêm icon; không lấy luật event làm công thức ordinary. `equip.Drop` là list Stage ID để hướng dẫn tìm đồ (`ui/fragmentGuide.lua`), không có tỷ lệ. `RankChest.lua` rỗng trong bản khôi phục.

Trích xuất có thể kiểm tra lại: `Artifacts/CrystalPhaseChecks/chest-loot-review-20261120.json`. Lượt này chỉ bổ sung bằng chứng và sửa giới hạn kết luận, không đổi config/gameplay Zatod.

Tại thời điểm khảo sát ban đầu, Zatod chưa có drop-table/cấp thưởng ải. Sau đó người dùng chốt D19 ngày20/11/2026: đã thêm `CampaignStageDefinition.DropItems` (`ItemId`, `DropChancePercent`) cho 18 ải, 36 dòng/10 loại trang bị có sẵn; mọi tỷ lệ là100 theo yêu cầu prototype, không phải tỷ lệ reverse. ID20555 nằm ngoài catalog nên ghi vào báo cáo bỏ qua. Icon Reward đã nối trong hai View theo D20; chưa roll hoặc cấp thưởng. Hướng dẫn authoring: `docs/zatod-stage-drops-config.md`; inventory GUID và phạm vi67 gear giữ nguyên.

Lưu ý trạng thái Zatod cập nhật21/11/2026: mô tả config-only phía trên là lịch sử ngày20/11. Người dùng đã duyệt và triển khai D26: MaxDropAmount, tổng tỷ lệ100%, server pending loot/cấp sau validate thắng. Đây là thiết kế Zatod riêng; giới hạn bằng chứng backend Crystal trong báo cáo vẫn giữ nguyên. Xem docs/zatod-stage-drops-config.md.

## Đối chiếu thời điểm roll/nhận đồ —21/11/2026

Đọc lại protocol và consumer để trả lời thiết kế MaxDropAmount của Zatod, chưa sửa runtime/config:

- `down.proto:353`: `enter_stage_reply` có `_rseed` và repeated `_loots`. Danh sách loot của lượt chơi đã được xác định trước khi trả response vào ải. Chưa có backend để nói server roll ngay trong handler enter_stage hay chuẩn bị trước đó.
- `network/network.lua:1579`: seed đưa vào ed.srand, `_loots` lưu riêng vào player.loots. Chưa chứng minh loot RNG và combat RNG là cùng một chuỗi.
- `player/playerinfo.lua:1173` và `battle/battle_scene.lua:939`: lấy loot đã cấp theo wave/slot/phe để hiển thị khi quái chết; không random lại từ Stage.UI reward ở đường này.
- `up.proto:267` và `battle/battle_engine.lua:3720`: exit_stage gửi claim kết quả/sao/operations, không có field danh sách item để client tự quyết định thưởng.
- `battle/battle_engine.lua:3309`: handler downExit chỉ gọi takeStageReward khi isKnown và result==0; `player/playerinfo.lua:1247` cộng phần thưởng vào trạng thái client. Đây là bằng chứng thời điểm cập nhật phía client; không phải bằng chứng về transaction/DB server đã commit lúc nào.

Không tìm thấy bằng chứng Crystal dùng quy trình random0..MaxDropAmount rồi chọn item theo trọng số. Chest chứa các cặp ID/Yield nhưng chưa có consumer backend để suy phép chuẩn hóa, số lượt chọn hoặc cho phép rơi trùng.

Đối với Zatod, hướng người dùng nêu tách hai bước: random số món N, rồi chọn đúng một loại cho mỗi trong N lượt. Phần trăm mỗi dòng là xác suất chọn loại trong một lượt, khác với tỷ lệ rớt độc lập từng loại của config D19. Có thể dùng trọng số chuẩn hóa (1/1/1 cho ba món bằng nhau), UI hiển thị33,33%; đây là đề xuất biểu diễn, chưa chốt schema. Cho phép lặp cùng loại, default giới hạn và thời điểm roll/cấp vẫn cần hoàn thiện thiết kế. Đã ghi phạm vi chưa triển khai tại D26.

## Bằng chứng để tra lại

Gốc source Lua: `Unity/Assets/Crystal Legend/recovered/scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data/`.

- `Stage.lua:125126`: các UI reward field; Stage1/2/3 đọc bằng recovery_tools/lua_data.py, không execute Lua.
- `ui_new/modules/stage/stagedetail.lua:12,974`: filter và dựng preview.
- `network/network.lua:1579`: enter_stage_reply; `:1588`: exit_stage_reply.
- `player/playerinfo.lua:1149,1173,1247`: loot cả ải, lọc theo quái và cập nhật reward client.
- `battle/battle_scene.lua:939`, `battle/battle_sceneui.lua:1177`, `battle/battle_engine.lua:3309,3720`: vẽ loot, nhánh reply/settlement, dựng request cuối trận.
- `Loot.lua`, `DropLimit.lua`, `Battle.lua` headers: schema đọc trực tiếp.
- `recovered/scripts/protobuf_utf8/.../data/down.proto:353` enter_stage_reply; up.proto enter_stage/exit_stage. Comment bit width trong proto không hoàn toàn khớp globalConfig hiện tại (waveIDBitNum=7); khi cần decode phải theo code/globalConfig thực, không chỉ comment cũ.
- Trích dữ liệu chương 1: `Artifacts/CrystalPhaseChecks/stage-drops-review-20261120.json`.
