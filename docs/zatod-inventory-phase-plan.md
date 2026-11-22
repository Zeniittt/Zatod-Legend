# Phase Inventory — bản tổng hợp trước thực thi

Ngày22/11/2026. Nguồn quyết định: Design.md D05/D08/D12/D17/D22/D28/D29/D30/D31. Người dùng yêu cầu trình bày lại phạm vi để duyệt trước thực thi. Đây là kế hoạch, chưa sửa runtime/Editor/config sở hữu. Các mô tả lịch sử trong crystal-inventory-review.md chỉ được áp dụng khi không trái các chốt sau cùng.

**Cập nhật khi thực thi22/11:** người dùng đã duyệt và yêu cầu triển khai; sau đó đổi sang stack UI mộticon/xN, giữ GUID và asset Crystal. Phạm vi dưới đây đã sửa theo chỉ dẫn mới. Kiểm tra/build trước lần đổi này là bằng chứng trung gian; chưa coi phase hoàn thành nếu bản cuối chưa kiểm tra lại.

## 1. Inventory UI

- Mở từ nút Inventory hiện có; Back/Close về đúng world/map, chặn input avatar khi modal mở.
- Dùng art Crystal và bố cục tham chiếu: panel chi tiết trái, grid cuộn,4 tab phải; responsive màn ngang/safe area16:9,19.5:9,20:9,4:3.
- Một ô theo ItemId với số lượng xN cho Items/Shards/Gears; Soulstones dùng card Hero và tổng đá/nhu cầu theo ảnh tham chiếu mới. Dữ liệu bên dưới giữ các GUID riêng; không tạo thêm số dư Quantity độc lập hoặc đổi GUID cũ. Chỉ nhóm món rảnh trong Inventory, không thêm đồ đã mặc/hấp thụ/Retired hoặc ItemData ảo0 món. Card Hero0 đá trong Soulstones chỉ là projection catalog, không là món đồ sở hữu.
- Chọn ô hiện icon/khung quality, tên/mô tả, tổng số cùng loại đang trong kho, stats hoặc thông tin nguyên liệu phù hợp, nguồn nhận và hành động hợp lệ. Tổng số ở detail là dữ liệu tính từ GUID, không lưu Quantity.
-4 tab Items/Shards/Gears/Soulstones. Items filter All/Common/Events/Precious/Cosmetic/Develop; Gears All/Forged/Primal/Scroll. Filter/tab không có đồ hiện empty state đúng, không tự cấp đồ hoặc thêm ticket/event/rương chưa có.
- Sources đọc từ dữ liệu thực, không có thì để trống; giữ D29 chỉ hiển thị, không tự thêm nguồn hoặc teleport. Header dùng Gold/Stamina thật đã có; diamond chưa có giữ placeholder, không thêm currency mới.
- List tái sử dụng tối đa56 ô/virtualization cho các nhóm item và card Hero. Giữ selection/scroll hợp lý sau giao dịch.

## 2. Item config và stats

- Bổ sung metadata trên ItemDefinition: tab/filter, Description/Comment khi cần, giá bán Gold; giữ ItemData.Id/ItemId. Data lấy Crystal cho bộ active; giữ reference và ID snake_case.
- Bỏ hoàn toàn bonus item riêng theo Hero khỏi config active/calculator/preview và authoring. Cập nhật importer để không sinh lại HeroStats. Giữ stats chung, không cộng bù vào item/base Hero.
- Thay đổi balance tính lại cả đồ đang mặc và đã hấp thụ theo D08, giữ GUID/ItemId/history; không rewrite snapshot trận đã cấp hoặc replay cũ.

## 3. Sell

- Chọn nhóm item và số lượng bán; popup xem giá nhận trước khi xác nhận, cộng Gold và bỏ đúng tập GUID tương ứng khỏi kho. Một món vẫn giữ định danh tới lúc bị tiêu.
- Chỉ bán khi config cho phép/giá hợp lệ. Không bán đồ đang mặc, đã hấp thụ hoặc ngoài Inventory.
- Chọn lượng trong cùng nhóm item; không tự thêm auto-sell hoặc chọn nhiều loại khác nhau.

## 4. Craft và Quick Craft

- Tái sử dụng CraftRecipes và giao dịch craft hiện có, thêm đường mở recipe/craft từ Inventory không cần fake Hero/slot.
- Shards hiện tiến độ tổng mảnh/nhu cầu; ghép đủ mảnh/vàng theo recipe, mỗi sản phẩm GUID riêng.
- Quick Craft chỉ ghép mảnh thành sản phẩm trực tiếp. Popup chọn/bỏ chọn loại, chọn tất cả, xem lượng nguyên liệu/sản phẩm/tổng vàng. Mỗi loại chọn ghép floor(amount/need) lần và giữ mảnh dư.
- Thiếu vàng báo lỗi, không tự cắt batch; không tự craft đệ quy chuỗi trang bị. Batch phải kiểm/lưu toàn bộ một lần, không áp nửa giao dịch khi một dòng thất bại.

## 5. Đồ EXP và UI nâng level Hero

- Hỗ trợ5 loại đã có: Potion60/Salve300/Cheese1500/Burger7500/Pizza75000. Không tự thêm vào pool thưởng hoặc mở nguồn farm.
- Đường vào Hero Detail/Lvl Up mở popup cho Hero hiện tại; từ Inventory dùng đồ EXP chọn Hero trước rồi mở cùng popup. Không tạo hai bộ logic cộng EXP.
- Popup theo layout Crystal đã preview: portrait, level đích−/+, Use, danh sách icon/lượng EXP item sẽ tiêu. Tự tính theo EXP hiện tại, curve và cap D30, ưu tiên Potion→Salve→Cheese→Burger→Pizza theo kho.
- Tiêu nguyên món, không tối ưu tổ hợp; giữ EXP dư theo D30. Nếu một món khiến vượt level vừa chọn, hiện level thực đạt trước xác nhận. Không thể tăng level hoặc đã cap thì không tiêu item.
- Server tự kiểm/tính phương án và chọn GUID hợp lệ, client chỉ preview; nếu kho/Hero thay đổi phải cập nhật lại trước xác nhận, không tiêu khác preview một cách âm thầm.

## 6. Soulstones, triệu hồi và nâng sao

- Thêm item/art Soulstone cho các Hero hiện có config, không mở rộng toàn bộ roster nguồn. Mỗi viên giữ GUID; UI dùng card Hero với tổng đá, tiến độ tím, level/sao/rank, trạng thái đủ đá và nhóm đã/chưa sở hữu.
- HeroDefinition thêm liên kết Soulstone và InitialStars; bảng tiến sao riêng nhập từ Crystal, gồm ngưỡng/cost triệu hồi và nâng sao, cap5 theo nguồn đã kiểm tra.
- Chọn viên đá: panel hiện Hero, tổng đá hiện có, ngưỡng, chi phí và Recruit/Star Up theo trạng thái sở hữu. Hiển thị cả card Hero chưa sở hữu0 đá theo catalog; không tạo ItemData/GUID hoặc cộng đá giả. Panel trái dùng icon đá, grid dùng portrait Hero. Card đủ đá mở xác nhận Recruit/Star Up.
- Recruit: đủ tài nguyên thì tạo Hero mới level1/Exp0/bậc khởi đầu/sao theo config; không tạo trùng Hero đang sở hữu.
- List of Heroes cũng có glow/Star-Up khi đủ đá sao kế, bỏ dấu khi thiếu đá hoặc đạt cap; cập nhật theo snapshot.
- Star Up: tăng một sao, tính lại stats theo Growth có sẵn, giữ level/Exp/rank/gear/history; không mở thêm bậc sau Blue hoặc hệ thức tỉnh.
- Nguồn đá chưa có để trống; dùng dev grant hiện có để kiểm thử. Không tự thêm drop hoặc mở Recruitment/gacha khác.

## 7. GameEditor

- Items: metadata, nhóm/filter, mô tả, giá bán, stats chung, giá trị EXP.
- Heroes: SoulstoneItemId/InitialStars; không reset Stars của Hero cũ khi chỉnh InitialStars.
- Khu tiến sao: ngưỡng đá, giá Gold triệu hồi/nâng sao, giới hạn sao. CraftRecipes tiếp tục editor hiện có; EXP curve/cap dùng Progression đã có.
- Validate reference, group theo tab, recipe và số lượng/chi phí hợp lệ; thêm giá trị enum ở cuối, không đổi ý nghĩa mã đã lưu.

## 8. Dữ liệu, kiểm tra và bàn giao khi thực thi

- Server quyết định mọi tiêu/cấp đồ/Gold/EXP/Hero; receipt/idempotency, rollback đầy đủ và reconnect/retry không lặp thưởng hoặc thu phí. Giữ guard loadout/trận hiện có.
- Giữ toàn bộ Owned/instance/history, không reset kho/Hero. Snapshot/replay cũ cần regression sau bỏ bonus theo Hero.
- Kiểm tra Sell/craft/batch/EXP/Recruit/Star Up cả thành công, thiếu tài nguyên, GUID không hợp lệ, cap, request lặp và lưu lỗi; xác nhận save/reconnect.
- Kiểm UI bằng dữ liệu thật và nhiều tỷ lệ màn ngang, empty state, kho nhiều ô, đóng/mở và input avatar. Build/check phù hợp sau khi có lệnh thực thi; cập nhật Design/ChangeLog và báo cáo bàn giao.

Phạm vi này không thêm nguồn farm EXP/Soulstones, sự kiện/shop/gacha/Market hoặc tự balance base. Stack UI là chỉ dẫn mới đã duyệt trong lúc thực thi; Market và thao tác split/trade để sau. Trạng thái triển khai/kiểm chứng cuối được ghi riêng trong báo cáo bàn giao.
