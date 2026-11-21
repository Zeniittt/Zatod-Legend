# Khảo sát mặc đồ và ghép đồ Crystal

Ngày21/11/2026. Người dùng yêu cầu kiểm tra source/view và ảnh preview; **chưa triển khai gameplay, model, UI Unity hoặc config runtime**. D08/D12/D23 tiếp tục áp dụng. Không biến đề xuất ở tài liệu này thành quyết định đã duyệt.

**Cập nhật sau lệnh thực thi21/11:** config/UI/craft theo GUID đã triển khai và nghiệm thu; xem [zatod-crafting-implementation.md](zatod-crafting-implementation.md). Nội dung khảo sát/chưa code bên dưới là trạng thái lịch sử.

## Mặc đồ và trạng thái ô Hero

`ui_new/modules/hero/heroDetailBase.lua:325..352` phân biệt ô đã mặc, có món trong kho, thiếu level, có thể ghép và chưa có/không ghép được. Bấm ô gọi `equipcraft.create` với Hero, slot và item cần cho bậc. `equipcraft.lua:1244` tạo nút theo trạng thái: Equip khi có item; xem công thức/Get Way khi thiếu; OK khi đã mặc. Thiếu level có thông báo yêu cầu level.

Popup item dùng `equip/board.lua`: icon/quality, tên, số sở hữu, danh sách stats/mô tả cuộn, level yêu cầu và nút bên dưới. Biểu tượng mảnh ghép góc trên mở công thức. Dòng ghi chú cho biết trang bị gắn với Hero sau khi mặc. Chưa thấy thao tác tháo tự do trong luồng trang bị thường đã đọc; không suy ra mọi hệ thống trang bị khác đều như vậy.

`equipcraft.lua:1043` gửi wear_equip với hero ID và danh sách slot1..6. Crystal dùng số lượng theo loại item ở kho, không chọn GUID như Zatod. Sau reply, `network/network.lua:1680` cập nhật kho/trang bị và callback. Có protocol request/reply không chứng minh mọi kiểm tra backend; mã backend chưa có.

## Công thức và hai kiểu ghép

- `equipcraft.lua` (bảng data) khai báo Item_ID đích, Expense, Rank, Components, Category, Component1..4 và ComponentN Count. Có tối đa4 node nguyên liệu trực tiếp; Count0/nil được consumer coi ít nhất1. Hai node cùng ItemId phải cộng dồn nhu cầu, ví dụ Vital Shield dùng Stockings of Agility hai lần.
- Ví dụ Green Boots200 = Boots112 + Ring of Protection105 + Ring of Regen111; phí nguồn1200 vàng. Công thức có thể lồng: Crossblade260 cần Aurora242 + Noir243, hai món này lại có công thức riêng.
- Ghép mảnh cũng có trong equipcraft: Shortsword222 cần5 mảnh276, phí1500 vàng. `fragment.lua` bổ sung mapping sản phẩm/fragment/count/cost và universal fragments. Không tự đưa universal fragments, soul stone/Hero summon hoặc hệ thống Legendary vào phạm vi Zatod chỉ vì tìm thấy chúng.
- Luồng ghép item gọi equip_synthesis với item đích; luồng mảnh gọi fragment_compose với item đích/số lượng. Xử lý reply cập nhật chi phí, nguyên liệu và sản phẩm. Craft thường là công thức xác định; `_result` của protocol là trạng thái thao tác, không phải bằng chứng có tỷ lệ thất bại ngẫu nhiên.
- `tools.lua:748..845` kiểm tra nguyên liệu theo cây, ưu tiên dùng item trung gian đã có, có thể tính xuống nguyên liệu gốc và cộng phí các cấp. UI có Quick/one-time craft nếu đủ cây; thiếu nguyên liệu hiển thị số đỏ, bấm nguyên liệu mở cây con/breadcrumb. Món không có recipe có thể mở danh sách nguồn nhận (ải/shop/...); nguồn ải không chỉ là bảng recipe.
- Ghép xong tạo món trong kho và cập nhật/làm sáng nút Equip (`equipcraft.lua:920..1030`); **không tự mặc món đó** trong đường này. Người dùng bấm Equip riêng. Ghép và mặc là hai thao tác.
- Kho gốc còn có `PackageComposeWin.lua` cho chọn nhiều loại mảnh và ghép hàng loạt; đây là view phụ, chưa đề xuất bắt buộc làm ở phase đầu.

## View và asset

Một popup item ở giữa; khi mở công thức, popup item trượt sang trái và panel recipe mở bên phải. Panel trái sáng, panel phải tối, sản phẩm ở trên và nguyên liệu phía dưới kèm have/need; chi phí vàng và nút Craft ở đáy. Các node nguyên liệu bấm được, có lịch sử để quay lại công thức cha.

Đã đọc và giải mã128 ảnh trong tập phục vụ preview/audit nguyên liệu, gồm frame/com_new, nền/package, decor/crafting, các quality/fragment frames, tag, icon, button, close và icon của112 loại trong closure.36 nguyên liệu bổ sung đều có tên English chính thức trong texttable. Có container eff_UI_craft_above/below.fca trong supplementary CDN đã lưu; lượt khảo sát chỉ xác nhận file, chưa bake/nghiệm thu hiệu ứng craft động.

Ảnh ở `Artifacts/ZatodEquipmentReview/01-equip.png`, `02-craft-items.png`, `03-craft-fragments.png` là **ảnh tĩnh dựng lại từ art, tọa độ và bố cục source**, không phải screenshot game Crystal đang chạy và không phải UI đã import. Số lượng kho minh họa; nhãn và số nguồn dùng để đọc bố cục. Một số tương tác/scroll/animation chưa thể thể hiện trong ảnh. Preview Green Boots còn STR/INT/AGI của nguồn; Zatod giữ stat trực tiếp D05, không khôi phục ba thuộc tính này khi chuyển view.

## Đối chiếu Zatod hiện tại

-76 loại item active;47 loại có công thức Crystal. Nếu hỗ trợ toàn bộ recipe đệ quy của76 loại, closure là112 loại, **cần thêm36 định nghĩa nguyên liệu**. Con số67/108/+41 trong khảo sát chương1 cũ không dùng thay cho bộ hiện tại đã có chương2 và item preview drop. Audit ánh xạ từ source ID/alias, không đoán theo icon vì mảnh và sản phẩm có thể dùng cùng icon.
- `ItemInventory.Equip` đã có: kiểm tra Hero sở hữu, GUID trong kho, đúng ô/recipe bậc, ô trống và đủ level; chuyển instance cùng GUID từ Inventory sang EquippedItems. API mạng đã có, UI hiện chưa gọi theo D23.
- `ItemDefinition` chưa có schema recipe; chưa có service/câu lệnh craft. Không chỉ nối button là hoàn tất hệ thống ghép. Hàm dev cấp item tiếp tục hữu ích cho test nhưng không phải craft.
- Theo D12, craft Zatod phải chọn/tiêu hao từng GUID nguyên liệu trong kho, cộng đúng nhu cầu trùng ItemId, tạo GUID mới cho sản phẩm. Số have/need vẫn có thể đếm theo ItemId để hiển thị, không biến kho thành stack. Không lấy món đang mặc hoặc đã hấp thụ làm nguyên liệu; giữ lịch sử D08. Server phải xác nhận sở hữu/nguyên liệu và lưu giao dịch trước khi UI cập nhật chính thức.
- Battle đang chạy giữ snapshot/khóa thay trang bị hiện hành. Khi bổ sung craft phải giữ cùng ranh giới; không thay item trong snapshot/replay cũ.

## Đề xuất ban đầu, trước phản hồi bổ sung

Giữ flow Crystal: Hero -> ô item -> thông tin -> Equip; thiếu món thì Recipe -> ghép -> Equip. Giai đoạn đầu có thể làm ghép từng món/cây con, rồi quyết định có thêm one-time craft/ghép hàng loạt ngay hay chưa. Không tự triển khai các nhánh này trong lượt khảo sát.

Vàng hiện chưa có economy: cần chốt có giữ Expense trong config nhưng bypass phí lúc prototype, hay thêm số dư/chi phí thật. Ghép mảnh còn cần nguồn cấp36 nguyên liệu; có thể test bằng hàm add item trước, chưa tự thay pool drop các ải. Chưa chốt model recipe tách bảng hay đặt trong ItemDefinition; nên có OutputItemId, OutputAmount, Ingredients(ItemId/Amount), GoldCost và validator vòng lặp/tham chiếu/amount, cùng Editor phù hợp.

Bằng chứng: `Artifacts/ZatodEquipmentReview/audit.json`, script dựng preview ngay trong Artifacts. Không sửa file trong Unity, không chạy giao dịch mặc/ghép trên account người dùng.


## Phản hồi bổ sung21/11 và kiểm tra model

Đã chốt theo D28: UI theo đúng Crystal/asset nguồn, được thêm item/nguyên liệu thiếu và bỏ phí vàng lúc prototype. Người dùng yêu cầu tiếp tục kiểm tra, chưa yêu cầu triển khai Unity. Phần nguyên liệu vẫn tiêu hao; level/ô yêu cầu vẫn kiểm tra khi mặc. Các câu cần chốt phí vàng trong phần lịch sử phía trên đã được giải quyết bằng phản hồi này.

Nền model đáp ứng kho/mặc, **chưa đủ cho craft**. Có thể giữ ba lớp Hero, CharacterData.Inventory, ItemData và các ledger đang mặc/đã hấp thụ. Không cần model FragmentData riêng: mỗi mảnh cũng là ItemData có ItemId và GUID;5 mảnh nghĩa là5 instance. Cần phân biệt loại item ở metadata config để UI dùng tag/frame nguồn; Quality độc lập với loại item, không suy mảnh từ icon vì chúng có thể dùng chung hình với sản phẩm.

Đề xuất config riêng CraftRecipeDefinition trong CraftRecipes.txt, gồm Id, OutputItemId, OutputAmount, Ingredients(ItemId/Amount), GoldCost, và tab Crafting trong GameEditor. Đây là đề xuất schema, chưa triển khai/chưa coi là tên field đã được người dùng duyệt. Cần validator reference/amount/ID trùng/vòng lặp; gộp cùng loại nguyên liệu khi tính nhu cầu và không dùng một GUID hai lần. Snapshot dữ liệu người chơi không cần sao chép recipe hoặc lưu tổng stats.

Server giải nguyên liệu/kiểm tra GUID trong kho của đúng account; chỉ dùng item rảnh trong Inventory, không lấy đang mặc/đã hấp thụ/retired. Craft chỉ tạo item; equip là lệnh riêng giữ nguyên GUID của món được mặc. LevelRequirement kiểm tra lúc mặc, không tự thêm level Hero tối thiểu cho thao tác craft. Chưa thay drop pool của ải chỉ vì thêm nguyên liệu; có hàm dev cấp đồ để kiểm tra trước.

Cần xử lý một giao dịch server đủ các bước validate -> chuẩn bị thay đổi -> lưu thành công -> công bố snapshot; save thất bại phải giữ/khôi phục trạng thái cũ. Bảo vệ gửi lại cùng thao tác bằng mã yêu cầu/kết quả đã xử lý; click craft mới có mã mới. Revision hiện có hỗ trợ xác định snapshot cũ nhưng một mình Revision chưa thực hiện cơ chế này. Quick Craft sau này phải tính toàn cây dùng chung một tập GUID và đủ nguyên liệu trước commit, không ghép dở dang rồi hụt nguyên liệu.

Qua đọc code, Equip hiện đổi Account trước SendAccount/SaveOwned, không có rollback ở nhánh equip nếu ghi file lỗi. Đây là rủi ro xác nhận qua cấu trúc code, chưa thử gây lỗi lưu hoặc quan sát mất đồ thực tế. Loot D26 đã có rollback riêng; không tự suy đường Equip cũng đã có. Ghi theo dõi REVIEW-002 trong ChangeLog.md, chưa sửa runtime ở lượt kiểm tra này.

Giữ phí GoldCost/Expense nguồn làm tham chiếu; phía server prototype tính phí hiệu lực0, không kiểm/trừ Currencies cho phí này. UI nên hiện0/Free theo phí hiệu lực thay vì thu giả hoặc báo thiếu vàng. Giữ stat trực tiếp D05, snake_case/tên English, GUID/history và snapshot trận cũ. Không cần đổi model Hero hoặc mở thêm rank chỉ vì bổ sung craft.


## Chốt config craft và giải thích metadata

Phản hồi tiếp theo21/11: người dùng đồng ý thêm config craft và các điểm về giữ model Hero/kho, xử lý GUID/giao dịch server đã trình bày. Vẫn đang hỏi để hiểu metadata, chưa yêu cầu thực thi. Nguồn quyết định D28 đã cập nhật; các đoạn schema chưa chốt ở trên là lịch sử trước phản hồi này.

Metadata ở đây là thông tin chung của một loại item trong ItemDefinition. Đề xuất mới tối thiểu một field ItemKind (Equipment, Fragment, Material); không cần tạo một tập model sở hữu khác. Name, IconResource và Quality đã có. Quality là độ hiếm/màu khung, độc lập ItemKind. UI dùng Kind để thêm biểu tượng mảnh/kiểu frame/nhãn loại hoặc lọc đúng nhóm; không dùng nó thay điều kiện server về Hero, level, slot, recipe và quyền sở hữu.

Ví dụ Shortsword có Kind Equipment; Shortsword Fragment có Kind Fragment; một cuộn công thức có Kind Material. Ba cách hiển thị khác nhau dù mảnh và món hoàn chỉnh dùng cùng ảnh gốc. Equipment vẫn có thể được một recipe khác tiêu hao; Material không phải tập tất cả item có thể làm nguyên liệu. Quan hệ nguyên liệu do Ingredients của recipe quyết định.

ItemData của từng instance tiếp tục chỉ có Id (GUID) và ItemId, resolve metadata từ config. Recipe quy định số mảnh cần, không cần lặp RequiredFragmentCount hoặc FragmentOfItemId vào định nghĩa item; một loại nguyên liệu có thể dùng trong nhiều recipe. OwnedCount, canCraft và canEquip là trạng thái tính từ account/công thức/Hero hiện tại, không phải metadata config cố định.
