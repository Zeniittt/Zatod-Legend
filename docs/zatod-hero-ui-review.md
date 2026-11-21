# Zatod — Khảo sát UI Hero và responsive

Ngày20/11/2026, D22/D23. Đây là bản khảo sát lịch sử trước triển khai. Sau đó người dùng đã yêu cầu thực thi; xem kết quả và giới hạn kiểm tra ở [zatod-hero-ui-implementation.md](zatod-hero-ui-implementation.md). Các câu chưa implement bên dưới mô tả thời điểm khảo sát, không phải trạng thái hiện tại.

## Kết luận khảo sát

Có các nhóm art chính để ghép thanh thu/mở, danh sách Hero và detail Base theo ảnh. Tranh lớn của25/25 Hero trong catalog có trong nguồn;25 AnimationSet hiện có để dùng Hero Idle ở giữa.76/76 loại item có icon nguồn, nhưng đường resource dùng drop UI hiện mới có20 loại, nên cần import bổ sung khi triển khai. Không coi có file nguồn là đã import/kiểm định UI mới trong Unity.

Nguồn UI: Crystal Legend/recovered/assets/install_time_pack/remake/. Source Lua: Crystal Legend/recovered/scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data/.

## Đối chiếu art và source

| Phần | Asset/source đã xác nhận |
|---|---|
| Ba nút | UI/alpha/1080P/main/main_task_button.png, main_hero_button.png, main_package_button.png |
| Thu/mở | main/main_shortcut_board.png, main_bj_button.png, main_img_button.png; ui_new/base/commonscene.lua dựng board/menu/arrow và switchMenu |
| Ô Hero | herolist/bg_hero_normal.png, bg_name.png; common/frame/hero_icon_frame_* và portrait nguồn đã dùng trong formation |
| Ô trang bị | herolist/icon_unequip.png, icon_equip.png; hero/equip/equip_add_*; ItemDefinition.IconResource |
| Thanh hình12 | astrolabe/astrolabe_herolist_bg_1.png + astrolabe_herolist_lock.png; HeroPackageMainScene.lua xác nhận dùng cho Astrolabe |
| Detail Base | hero/hero_info_bg_*, hero_bg_mid_*, hero_level_bg.png, hero_exp_*, hero_soulstone_*, hero_star_*, hero/rank/*; uieditor/herodetailNormal.lua |
| Tab/đóng | hero/hero_tab_choose.png, hero_tab_unchoose.png; common/break_butt_bj.png, butt_off.png; uieditor/herodetail.lua |
| Tranh Hero | Unit.Art → gamedatatables/unittable.lua::getUnitArt/recoverColum; UI/art/card_bg_big_*.jpg. Đã đối chiếu đủ25 Hero |

Đã xem trực tiếp native main_hero_button, bg_hero_normal, Astrolabe background/lock và tranh Lina. Ảnh title_herolist có trong nguồn là chữ Trung; chưa tìm thấy bản English cùng basename dưới nguồn đã quét (chỉ base/tw). Không dùng ảnh chữ Trung để thay nhãn List of Heroes. Có thể dựng nhãn động với font game như các View trước, giữ style/khung/icon nguồn; không hứa mọi chữ English trong screenshot đều có một PNG tương ứng.

Texttable có English display name cho25/25 Hero, ví dụ Coco→Captain, DR→Shadow, Lina→Vulcano. Đây là tên bản địa hóa nguồn, không cần đổi ID/save để hiển thị. Chính sách dùng alias này hay giữ tên hiện tại chưa được chốt riêng; không tự đổi ID/config trong lượt khảo sát.

Source list: ui_new/uieditor/HeroItem.lua và ui_new/modules/heropackage/HeroPackageMainScene.lua. Source detail: ui_new/modules/hero/heroDetailBase.lua. Crystal còn phân biệt canWear/cannotwear/canCraft/canUse/notHave; Zatod đang được yêu cầu hiển thị ba trạng thái đơn giản. Không tự đưa craft vào phase này.

## Dữ liệu thật và phần còn thiếu

| Thông tin | Hiện trạng / hướng hiển thị đề xuất |
|---|---|
| Roster | CharacterData.HeroDesk; mặc định5 Hero sở hữu, không phải25 Hero trong catalog |
| Level, sao, bậc | HeroData.Level/Stars/RankId, HeroDefinition.Ranks; dùng giá trị thật |
| Trang bị đã mặc | HeroData.EquippedItems có SlotId/ItemId/GUID; icon theo món thực tế, không ghi đè bằng recipe mới |
| Yêu cầu ô trống | HeroProgression.CurrentRank().EquipmentSlots.RequiredItemId |
| Có item trong kho | CharacterData.Inventory theo ItemId, mỗi instance có GUID; khi mặc phải gửi đúng instance và server xác nhận |
| Stats | HeroStatCalculator.Calculate().PreciseStats; hiện có27 stat config, cần nhãn/đơn vị dễ hiểu, không đổ tên kỹ thuật/debug ra UI |
| EXP | Có HeroData.Exp, nhưng chưa có curve/award/level-up loop Zatod. Crystal đọc bảng Levels.Exp. Đề xuất hiện current/??, không bịa phần trăm hoặc tự import hệ EXP |
| Đá nâng sao | Chưa có số lượng/luật shard cho Hero trong hệ Zatod đang dùng; đề xuất ??/?? |
| Diamond/gold/stamina/power | ?? theo yêu cầu. Không dùng số minh họa hoặc số0 để giả hệ thống đã hoạt động |

ItemInventory.Equip đã kiểm tra quyền sở hữu Hero/GUID, slot bậc hiện tại, ItemId, ô chưa mặc và level requirement. Một GUID chỉ có thể được tiêu thụ từ kho một lần. Nếu nhiều ô/Hero cùng cần một ItemId mà kho chỉ có một món, dấu cộng không đồng nghĩa có đủ để mặc tất cả. Đã chốt click ô item/dấu cộng không có action trong phase này; Quick Equip cũng no-op. Preview/chọn/mặc qua UI chuyển sang phase sau.

Các nút chưa được yêu cầu logic: Quick Equip, tab ngoài Base; đề xuất Lvl Up/Star Up/cộng tài nguyên/Task/Inventory cũng chỉ thể hiện UI cho tới khi được chốt. Follow, kính lúp stats và hệ Elemental không tự thêm hệ thống vì có trong ảnh.

## Responsive và nguyên nhân hiện tại

ZatodPrototypeView.Box/ZatodStageUi.Box neo mặc định góc trên trái. Root có CanvasScaler1600x900/Match0.5 nhưng các child HUD world vẫn có x/y cố định (Menu1370, interaction605/750...). Không có safe-area container ở phần đã kiểm tra. Điều này giải thích việc bố cục không bám đúng mép/vùng an toàn khi aspect thay đổi; chưa đo pixel Simulator trực tiếp trong lượt chỉ đọc.

Formation và StagePreview đã có Fit thu/phóng đều theo khung thiết kế, nên không giống hoàn toàn world HUD; vẫn cần rà safe area và kích thước chữ/nút, không coi uniform scale là đầy đủ responsive.

Hướng đề xuất:

- Root chung tách full-bleed background với SafeAreaRoot. Đặt nút, chữ, danh sách và modal trong vùng khả dụng. uGUI package hiện cài có SafeArea component và docs tương ứng; không cần nâng Unity.
- Thanh truy cập bám góc trái dưới theo lời người dùng, đổi hướng mở/mũi tên cho phù hợp bên trái. Ảnh đặt bên phải chỉ là tham chiếu art.
- Hero list: top bar, nội dung co theo vùng còn lại; grid ưu tiên2 cột như ref, kích thước cell/gap theo bề rộng khả dụng; filter rail riêng và scroll có mask. Giữ tỷ lệ portrait/frame và6 ô item, không scale méo để nhét đầy.
- Detail: phân bố ba vùng tranh/hero+equipment/stats theo bề rộng khả dụng, có giới hạn tối thiểu; header và stats scroll tách nhau. Tranh giữ aspect và crop có kiểm soát; Hero Idle giữ FPS/pivot/scale tương đối, không đổi timing combat.
- Hero detail X về danh sách, Back danh sách về map trước đó, giữ map/pose và filter/scroll trong phiên. Khóa WASD/tương tác world trong khi View mở theo D21.
- Rà cùng nền responsive cho world HUD và các View phó bản hiện tại; chi tiết phạm vi sửa UI cũ cần chốt khi yêu cầu triển khai. Không tự mở đợt redesign tất cả UI legacy.

Nghiệm thu đề xuất:4:3,16:9,19.5:9,20:9/21:9; Device Simulator iPhone X hai chiều ngang, notch/vùng cử chỉ; đổi size khi menu/View đang mở; tên dài, scroll, chỉ5 Hero, nhiều Hero bằng roster test riêng; trạng thái item trùng loại/GUID, thiếu level, recipe đã đổi. Chưa chạy các phép kiểm tra này trong lượt khảo sát.

Docs uGUI đã đọc tại Library/PackageCache/com.unity.ugui@0f30cee369f3/Documentation~/: HOWTO-UIMultiResolution.md, script-CanvasScaler.md, UIBasicLayout.md, script-ScrollRect.md, script-SafeArea.md. Dùng hướng dẫn của package đang cài cùng code project, không suy API Unity6000.7 vào project6000.6.2f1.

## Trạng thái chốt phạm vi

1. Đã chốt: click ô item/dấu cộng không có action; chỉ hiển thị trạng thái thật. Preview/chọn/mặc qua UI làm ở phase kế tiếp.
2. Người dùng đã duyệt placeholder EXP/shard/nút level/star/Task/Inventory qua mục4 ngày20/11. Tên Hero mặc định dùng dữ liệu hiện tại; alias English nguồn là khả năng đã khảo sát, chưa có yêu cầu đổi tên/ID và không chặn scope UI.
3. Không làm portrait; hướng màn ngang đã được xác nhận, không hỏi lại.

Cập nhật chốt20/11/2026: người dùng duyệt các mục1–5, yêu cầu responsive đồng bộ các màn runtime đang dùng; trạng thái hiển thị item được xác nhận. Sau đó người dùng chốt click ô item/dấu cộng không có action ở phase này, preview/mặc qua UI chuyển sang phase sau. Chưa yêu cầu implement. Design.md D22/D23 là nguồn quyết định chính.
