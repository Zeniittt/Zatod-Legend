# Inventory D31 — triển khai và kiểm chứng

Ngày22/11/2026. Phạm vi đã duyệt: docs/zatod-inventory-phase-plan.md; quyết định Design.md D05/D12/D31. **Trạng thái: đã hoàn tất nghiệm thu/build/deploy22/11/2026**, gồm đổi stack, follow ảnh Soulstones và Star-Up trong List of Heroes. Các số liệu dưới đây là bản cuối.

## Hành vi hiện có

- Inventory dùng art Crystal, mở từ shortcut thị trấn;4 tab Items/Shards/Gears/Soulstones, filter con đúng source, grid cuộn tái sử dụng tối đa56 ô. Nền tràn Canvas, controls trong safe area màn ngang, modal khóa điều khiển avatar và trở về đúng map.
- Theo chỉ dẫn mới khi triển khai, UI gộp một ô ItemId với xN. `InventoryStack` chỉ là projection; `CharacterData.Inventory` vẫn giữ Id GUID/ItemId của từng món, không có số dư Quantity song song. Group không cấp/xóa/đổi GUID. Bán/ghép/dùng tiêu đúng tập GUID; stack hết thì biến mất, số dư còn thì giữ nhóm.
-142 định nghĩa:117 loại cũ giữ stats chung/fields cũ, thêm25 loại Soulstone cho25 Hero hiện có. Metadata tab/filter/mô tả/giá bán nhập source; source nhận từ Campaign.DropItems, thiếu nguồn để trống. Không sửa39 ải/drop pool hoặc thêm nguồn farm thuốc/đá.
- Bỏ bonus item theo Hero khỏi model/cách tính/popup và các importer, không cộng bù vào base. Trang bị hiện có/hấp thụ tính theo config mới, ID/lịch sử không reset. Replay dùng snapshot cũ giữ kết quả.
- Sell có chọn lượng−/+/Max trong cùng một nhóm, xem tổng Gold trước khi xác nhận. Server kiểm kho và giá config, cộng Gold/tiêu GUID cùng giao dịch.
- Recipe mở từ Inventory không cần Hero/slot giả; dùng hệ craft hiện có và thu phí thật. Quick Craft chọn/bỏ chọn loại mảnh qua icon/checkmark native, All/None, xem preview sản phẩm/nguyên liệu/tổng vàng, ghép tối đa trực tiếp và giữ mảnh dư. Không craft đệ quy, không tự giảm batch khi thiếu tiền.
-5 đồ EXP dùng từ Hero Detail/Lvl Up hoặc Inventory/chọnHero. Popup chọn level đích, tự tính lượng thuốc nhỏ trước theo kho, hiện lượng tiêu và level thực đạt, giữ dư/cap D30, không tiêu khi không tăng được level. Server tính lại, không tin client khai lượng EXP.
- Soulstones: HeroDefinition liên kết loại đá/InitialStars; StarRules.txt giữ5 dòng source và MaxHeroStars mặc định5. Recruit tạo Hero mới level1/Exp0/bậc đầu/sao config; Star Up tăng một sao giữ progress/gear/history. Đếm đá thật; grid dùng card Hero/level/sao/rank, purple progress, Star-Up/Recruit, nhóm Heroes Not Owned và cả card0 đá chỉ đọc từ catalog, không tạo ItemData/GUID giả; chưa mở gacha/Market/awakening/bậc sau Blue.
- List of Heroes dùng cùng rule đá sao kế/cap và glow/title Star-Up native trên portrait, refresh theo snapshot. Kiểm cả tiêu/nhận đá và max sao.
- GameEditor: metadata/stats chung/valueEXP trong Items, Soulstone/InitialStars trong Heroes, tab StarRules/menu GameEditor/Star Rules có cap và ngưỡng/cost. CraftRecipes/Progression tiếp tục editor hiện có. Draft/validate/discard hoạt động, không tự ghi trước Save; InitialStars không reset sao Hero cũ.

## Giao dịch và lưu trữ

`InventoryCatalog` dùng chung cho preview/server: tính plan và chữ ký gồm Revision, action/target/amount/level, chi phí/EXP và tập GUID. Kho thay đổi thì server từ chối preview cũ, không tự tiêu đồ khác.

`ZatodInventoryActions` mở rộng receipt có RequestKey/GoldReceived/Experience. Server xác thực operation GUID, nhận diện retry cùng payload trước thực hiện; khác payload cùng ID bị từ chối. Một transaction cập nhật Inventory, Gold, Hero level/Exp/stars/roster, revision và receipt; persist lỗi rollback đủ các phần. Guard trận/PvP hiện có được giữ. Receipt vẫn tương thích các thao tác craft/equip trước đó.

## Kiểm tra đã có

- Core **5.068 assertions PASS**, Hero112 PASS; có bán nhiều món/rollback/retry, nhóm giữ mọi GUID, batch nhiều loại thiếu vàng/rollback, EXP/cap/priority, Recruit/Star Up/save fail và cap chỉnh được.
- Editor19 checks PASS: JSON round-trip142 items/StarRules/cap, không còn HeroStats item, dirty/discard config sao, đọc/round-trip7 Owned chỉ trong RAM.9 file Owned gốc giữ SHA256.
- UI cuối theo reference **1.123 checks PASS** trên1600x900,2436x1125,2400x1080,1600x1200. Kiểm count theo loại và tổng GUID, pooling, icon, bounds/safe area, empty state, EXP, quantity Sell và Quick Craft. Ảnh reference-final-* đã xem trực quan; kiểm thêm Hero0 đá/không GUID giả và mở xác nhận nâng sao; popup checkbox ký tự thiếu glyph được thay bằng sprite gốc, dim phủ Canvas.
-16 replay archive cũ PASS, giữ digest/winner/stars/endTick. Không dùng catalog balance mới để viết lại snapshot cũ.
- Network15 checks PASS trên server Windows riêng port17996, dữ liệu fixture tách kho thật: Sell2 món, duplicate receipt, Quick Craft/GUID dư, EXP, Recruit/Star Up, save, reconnect/retry và stale preview. Lượt đầu fixture Connect trước READY timeout0 checks; launch mới sau READY đã qua. Đã chạy lại15 checks trên bản build cuối sau thêm roster Star-Up; server test đã dừng.
- Data audit:117 item cũ giữ fields/stats chung,25 Hero giữ fields cũ ngoài bổ sung metadata; Campaigns/Skills/Monsters/Buffs/Stats/CraftRecipes không đổi nội dung ngoài ConfigVersion của bộ catalog.

## Bằng chứng, giới hạn và thao tác dùng

Artifacts/ZatodInventoryChecks chứa before.zip, owned-before.zip, hash/audit, import.json, core/editor/UI/network/build/deploy reports. UI dựng trong ZatodInventoryView bằng factory runtime theo cấu trúc UI sẵn có; scene/prefab battle/world không bị viết lại. Không thêm package. Font Inventory lấy DFPYuanW7-GB/FZCQJW từ raw, TMP font riêng để giữ các view cũ; ảnh glow đủ đá lấy frame FCA gốc, audit SHA trong source-effects/audit.json. Bộ native package/frame/source rows dùng asset gốc, không vẽ thay.

Skill/doc dùng: project zatod-design và Unity create-ui/uGUI/pipeline; đọc tài liệu package cài sẵn CanvasScaler/ScrollRect cùng Pipeline scripts/capture, giữ Unity6000.6.2f1 và uGUI hiện có. Không nâng phiên bản theo guide mới.

Mở game/kết nối server rồi Inventory ở shortcut dưới phải. Config: GameEditor/Open -> Items/Heroes/StarRules hoặc GameEditor/Star Rules. Item chưa có nguồn dùng dev grant hiện có để kiểm thử; không tự cấp bộ đồ vào account thật. Thay config cần reload/rebuild và restart standalone server/client như các phase trước.

Chưa benchmark trên thiết bị mobile thật, chưa triển khai nguồn farm EXP/Soulstones hoặc Market/split/trade. GUID từng món đã được giữ để dùng khi triển khai sau. Mirror RegisterHandler warning khi reconnect giữ theo lịch sử, không tự sửa transport trong phase này.

## Bàn giao cuối

Windows build cuối **Succeeded/0 errors/1 warning/26,97s** (TMP shader warning đã biết).218/218 file bản chuẩn Builds/ZatodPrototype khớpSHA256 với bundle đã kiểm thử; có bản sao BeforePlayer trên ổC trước phase. Server riêng17996/PID3680 đã dừng sau kiểm đúng executable path. Editor stopped, scene sạch, auto_tick=false, tab GameEditor/StarRules mở; Console groundTruth0 errors/không compiling.9 Owned không đổi/không có account mới trong kho thật và5scene giữ hash. Báo cáo handoff.json, deploy-audit.json, owned-check.json và data-audit.json.

Preview: ui/reference-final-Soulstones.png, reference-final-hero-roster.png cùng Items/Shards/Gears/exp/quickcraft; ảnh dùng fixture trong RAM, không cấp đồ hoặc sửa account thật. Glow đủ đá lấy ảnh frame FCA; không thêm runtime animation player riêng cho effect này.
