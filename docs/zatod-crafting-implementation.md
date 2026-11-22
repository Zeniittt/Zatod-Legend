# Mặc đồ và craft prototype Zatod

**Cập nhật D30 ngày22/11/2026:** phí craft đã được nối thu GoldCost thật trong phase kinh tế. Các mô tả phí0/112 item bên dưới là nghiệm thu lịch sử D28; trạng thái mới xem [zatod-economy-implementation.md](zatod-economy-implementation.md).

Ngày21/11/2026, theo D28. Người dùng đã duyệt metadata ItemKind, config craft riêng, bổ sung nguyên liệu, giao dịch server và bypass phí vàng; sau đó yêu cầu thực thi. Không thay ba lớp Hero hoặc quy tắc D08/D12.

## Sử dụng

- GameEditor -> Craft Recipes mở tab CraftRecipes. File `Unity/Assets/Zatod/Resources/Data/CraftRecipes.txt`:55 công thức gồm cả công thức trung gian, sản phẩm/số lượng, Ingredients(ItemId/Amount), GoldCost và SourceItemId để đối chiếu. Editor có LongField cho GoldCost, giữ draft khi đổi tab, validate reference/amount/cycle/duplicate và bảo vệ stale save.
- Tab Items có ItemKind: Equipment, Fragment, Material; kho vẫn mỗi GUID một instance.112 loại gồm76 loại cũ và36 dependency mới, tên English chính thức/ID snake_case; nguyên liệu lặp trong bảng nguồn được cộng đúng số lượng. Không đổi stats của76 món cũ, Hero, skill, buff hoặc encounter.
- Hero list/detail -> bấm ô trang bị -> popup item. Có món/đủ level thì Equip; chưa có thì Recipe/Get Way. Popup công thức hai panel theo art nguồn, bấm nguyên liệu đi xuống cây con, Back về cây cha. Ghép từng món, xong cập nhật Owned và nút Equip; không tự mặc.
- Mảnh có frame/stencil/tag riêng dù có thể dùng chung icon với món hoàn chỉnh. Stats popup tính từ config trực tiếp và phần bonus theo Hero, có scroll. Quality độc lập ItemKind. Dùng font native/fallback Trung; landscape trong safe area.
- Phí thực thu và UI là0. GoldCost nguồn vẫn giữ để tham chiếu; không tạo economy hoặc trừ Currencies. Nguyên liệu vẫn phải đủ và bị tiêu hao. LevelRequirement chặn mặc; craft không tự thêm điều kiện level Hero.
- Bổ sung định nghĩa không tự thay pool drop các ải. Có thể dùng AddItemByItemId hiện có để cấp nguyên liệu test; pool hiện tại giữ nguyên. Get Way ở đây chỉ hiển thị tên ải có ItemId trong DropItems hoặc báo chưa có nguồn, chưa thêm điều hướng farm/teleport hoặc nguồn shop. Quick Equip, one-time craft và ghép hàng loạt chưa được nối trong D28.

## Model và giao dịch

`CraftingDefinitions.cs` thêm ItemKind, CraftRecipeDefinition, CraftIngredient, CraftingCatalog và ItemOperationReceipt. Config craft được tích hợp HeroConfigDocuments/HeroDataJson/HeroCatalog/GameEditor; đọc bộ legacy thiếu bảng craft vẫn được với danh sách recipe rỗng.

Craft chọn đủ GUID riêng theo type trong Inventory, ưu tiên thứ tự GUID ổn định, tạo GUID mới cho sản phẩm. Không dùng đồ đang mặc, đã hấp thụ hoặc retired. Các Hero và lịch sử hấp thụ giữ nguyên. Giá trị ItemKind chỉ phục vụ phân loại, recipe vẫn có thể dùng một Equipment hoàn chỉnh làm nguyên liệu.

`ZatodInventoryOperations.cs` trong session dùng transaction cho craft/equip: kiểm tra operation GUID, tra receipt đã xử lý, validate, chuẩn bị thay đổi, tăng Revision, thêm receipt và lưu. Lỗi persist khôi phục Inventory/EquippedItems/Revision và bỏ receipt mới. Operation ID cùng payload trả lại kết quả cũ; cùng ID khác payload bị từ chối, GUID chữ hoa/thường được chuẩn hóa. Receipt nằm trong CharacterData.ItemOperations để còn sau save/load/reconnect. Client không gửi danh sách thưởng hay tự trừ kho; snapshot chính thức đến sau save. Chưa prune ledger ở prototype.

Nhánh equip mạng đi qua transaction mới, khắc phục REVIEW-002. Client giữ trạng thái Busy để chặn hai lần bấm trong lúc chờ, giữ request ID nếu đứt kết nối và đối chiếu receipt sau hello để retry đúng thao tác. Campaign đang issued và PvP/queue giữ guard loadout hiện có. Replay snapshot không bị cập nhật theo đồ mới.

## Tài nguyên và kiểm tra

- Importer `scripts/Import-ZatodCrafting.py`; giữ nguồn raw, copy144 ảnh byte-identical, prefab `Resources/Zatod/UI/Crafting/ZatodEquipmentView.prefab`. Helper authoring `Unity/AgentScripts/SetupZatodCrafting.cs` dùng PreviewScene, không sửa scene người dùng.
- Core4.933 assertions PASS: công thức/closure, mảnh, nguyên liệu trùng, GUID, rollback craft/equip khi save fail, retry sau reload, payload ID reuse, không đổi balance/replay/combat hiện có. Evidence `Artifacts/ZatodCraftChecks/core-checks.txt`.
- Editor9 checks PASS: đủ55 recipes/112 items, LongField phí, sửa draft không ghi file, save/roundtrip, stale và invalid guard; test phục hồi nguyên config. `editor.json`.
- UI cuối74 checks PASS: click ô thật, hai panel, drill/back, actual data sau craft/equip, tag fragment, modal raycast, close và safe bounds ở16:9/19.5:9/20:9/4:3. Ảnh trong `Artifacts/ZatodCraftChecks/ui/`; đây là fixture riêng trong Play, không sửa kho người dùng.
- `data-audit.json` xác nhận76 item giữ stats/fields cũ ngoài ItemKind;5 bảng combat giữ nội dung ngoài ConfigVersion; Owned local giữ nguyên. Backup `before.zip`, audit import `import.json`.
- Build, network thật, deploy và trạng thái server được bổ sung theo evidence cuối trong `Artifacts/ZatodCraftChecks/`.

## Những lỗi đã xử lý

Theo ChangeLog REVIEW-002, BUG-049, BUG-050. Dùng font native đúng cho popup; bake glyph nguồn mới, không coi TryAddCharacters=false là thiếu glyph nếu đã có. Authoring phải chạy sau compile/reload; helper kiểm tra Arrow của layout mới để không lưu prefab từ assembly cũ. Sau source edit trong Play phải dừng/chờ rồi mở Play mới trước nghiệm thu, không fake catalog để qua test. CLI beta đang cài không hỗ trợ status --until-ready; dựa log xác nhận Pipeline restart trước kết nối lại.


## Bàn giao

Build Windows Succeeded183,52s/0 errors/2 warnings có sẵn; network thật14 checks PASS trên server17993 với account mới. Đã ghép3 nguyên liệu thành Green Boots rồi mặc đúng GUID, retry không tạo thêm giao dịch, craft5 mảnh thành1 Shortsword, save/reconnect giữ receipt và kho.14 archive cũ giữ nguyên kết quả.218/218 file bundle chuẩn khớp SHA256 với build đã test.

Server test6344/17993 đã dừng; server local33836 READY/listen127.0.0.1:7788, data cũ Artifacts/ZatodServer.7 file Owned giữ nguyên hash. Editor ngoài Play, scene sạch, auto-tick=false; đã mở tab CraftRecipes với55 dòng. Trạng thái này là snapshot; PID đổi khi mở server lần sau. Console0 errors/compilationFailed=false, giữ log lịch sử và warning reconnect Mirror. Evidence cuối handoff.json/deploy-audit.json/owned-after.json/console-final.json trong Artifacts/ZatodCraftChecks.
