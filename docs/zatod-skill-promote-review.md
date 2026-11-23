# D35 — Bằng chứng Crystal và hiện trạng Zatod

Cập nhật: **23/11/2026, Asia/Saigon**. Đây là tài liệu khảo sát nguồn, không phải danh sách yêu cầu độc lập. Quyết định hiện hành nằm ở [Design.md — D35](../Design.md); agent thực thi đọc [phase plan D35](zatod-skill-promote-phase-plan.md). Các đề xuất lịch sử như thu sách, gate PlayerLv7 hoặc hoãn SkillEvo đã được người dùng thay đổi; không áp lại từ source khi triển khai.

**Trạng thái:** chỉ khảo sát/tài liệu, chưa có implementation hoặc nghiệm thu runtime D35.

## 1. Đầu vào và mức bằng chứng

Root Lua phục hồi: `Unity/Assets/Crystal Legend/recovered/scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data/`.

- `gamedatatables/skillgrouptable.lua`: skill chính, Init Level theo slot.
- `SkillGroup.lua`, `SkillLevels.lua`, `SkillEvo.lua`, `Buff.lua`: seed, giá, mốc và tham số effect.
- `ui_new/modules/hero/heroDetailSkill.lua`: danh sách skill, khóa theo bậc, giá nâng, thao tác giữ nút và gửi request.
- `ui_new/modules/hero/heroDetailBase.lua`, `ui_new/uieditor/herodetailNormal.lua`: Quick Equip/Promote và layout.
- `hero.lua`, `ui/readhero.lua`, `network/network.lua`: điều kiện nâng bậc, reset ô và reply.
- `battle/skill.lua`, `battle/unit.lua`, `battle/heroes/Coco.lua` và hook từng Hero: tính Growth, suy Evo theo level và tác động combat.

[JSON tham chiếu đi theo Git](reference/zatod-skill-promote-source.json) chứa baseline25 Hero/75 slot, curveGold Lv1→80,300 dòngEvo nguồn của4slot×25Hero, ví dụCoco và hash38 file nguồn. Các dòng slotTím trong đó vẫn là tham chiếu chưa mở; dữ liệu không chứng minh mọi effect đã port. Không chứa Owned, profile hoặc thông tin tài khoản.

Lua/config là bằng chứng về client nguồn đã phục hồi. Không có backend đầy đủ hoặc lượt quan sát game Crystal gốc đang chạy; không suy client gửi request nghĩa là backend tin số liệu client.

**Đổi vị trí23/11/2026:** reference hiện ở `Unity/Assets/Crystal Legend/` từ repository root; root cũ không còn. Ruleignore `/Crystal Legend/` chỉ áp vị trí cũ, không áp folder mới; Git đang báo folder mớiuntracked tại mốc kiểm, chưa bảo đảm clone khác có source. `Artifacts/` vẫn bịignore. JSON trongdocs giúp tra số liệu nhưng không thay hook/art/audio. Các scriptimport/bake còn đường root cũ phải được cập nhật trước khi chạy; lượt này chỉ sửa tài liệu, chưa nghiệmthu Unityimport folderraw.

## 2. Skill trong Crystal

| Nội dung | Bằng chứng nguồn |
|---|---|
| Danh sách nâng | Skill chính theo slot; basic/subordinate không tự thành nút nâng riêng |
| Mở skill | Theo Unlock rank; levelHero cao không tự mở skill bị khóa bậc |
| Khởi tạo | Cả25 Hero khảo sát có slot1/2/3/4 là1/1/21/41 |
| Giới hạn nguồn | UI này cần accountLv7, không nâng quáHeroLevel và dừng ởskill80 |
| Chi phí | SkillLevels: vàng, sách; SkillEvo có nguyên liệu tại các mốc riêng |
| Growth | `battle/skill.lua:11`: tăng field theo `(level-1)*Growth`, có thể tác động skill/buff/script |
| Evo | `battle/skill.lua:172`: suy evo_rank từ các threshold đạt được của chính level skill |
| Preset PvP nguồn | `kingsPvpHeroMgr.lua:74`: skill theo levelHero, basic slot5=1 |

Init Level là seed, không phải bằng chứng cho công thức capHeroLevel trừ20/40. Slot khóa có thể lưu seed cao hơnHeroLevel nhưng chưa được dùng/nâng.

Ba nhóm STR/AGI/INT có cùng giá vàng ở mọi bước từLv1→80; giá hàngL trả cho bướcL→L+1. Sách thường bắt đầu ở bước35→36. Sáu loại trên đường tớiLv60 là20009/20010/20012/20013/20015/20016; equip.Drop rỗng, HowToGet dẫn tới các hoạt động theo nhóm nguồn. Chưa có bằng chứng sách này rơi từ các chươngNormal dự kiến thêm.

**Khác biệt D35 đã chốt:** chỉ thuGold, bỏ sách/nguyên liệu và không áp gatePlayerLv7; chưa thêm hoạt động farm hay đưa STR/AGI/INT trở lại. Cap cấu hình80 và giới hạn theoHeroLevel được ghi trong Design/phase plan. Không chép nguyên điều kiện nguồn vào runtime rồi coi là yêu cầu Zatod.

## 3. Ví dụ SkillEvo thật: Coco — Spectral Ship

Skill nguồn group10 tạo thuyền, gây damage phép/AoE và stun. Base damage75, hệ sốAP1,4; Growth theo level áp riêng. Evo tích lũy thêm:

| Level skill | Thay đổi Evo |
|---|---|
| Dưới35 | Chưa có các Evo bên dưới; skill vẫn có tác dụng cơ bản |
| Từ35 | Attack frame thêm buff9s/PIMU20/MIMU20 cho Coco và đồng đội còn sống |
| Từ50 | Giữ hiệu ứng trước, thay hệ sốAP1,4→1,6 |
| Từ70 | Giữ hiệu ứng trước, stun cấu hình5s trước công thức tenacity |

Bằng chứng: SkillEvo group10; Buff10000104; `Coco.lua:138` thêm buff toàn đội, khoảng dòng179 thay PlusRatio; `skill.lua:172` suy Evo từ level. Nguồn thu thêm5 item20019 ở bước34→35,25 item20019 ở49→50; D35 chủ động bỏ các phí nguyên liệu này.

Evo không phải slot thứ5 hoặc một tiến trình EvoExp độc lập trong đường source đã kiểm. Không cần chờ Hero lênTím để mốcLv35 của ultimate này có hiệu lực, miễn skill đã được mở và đạt level.

## 4. Quick Equip và Promote đúng cùng một nút

Ba bằng chứng khớp nhau:

1. `herodetailNormal.lua:1324`: một DGButton `btn_up`, parent `bg_equip`, sprite `UI/alpha/1080P/package/btn_package2.png`, vị trílocal(199.25,111.25). `label_up` ở khoảng dòng1811 là con của nút đó.
2. `heroDetailBase.lua:1276`: đổi chính label giữa 一键装备 (Quick Equip) và 进阶 (Promote), không tạo nút khác.
3. `heroDetailBase.lua:1007`: nếu có ô mặc được thì mặc rồi return; nhánh Promote nằm sau. Cùng handler được gắn `btn_up` ở khoảng dòng1569.

Quick Equip đếm số món cùngItemId để không dùng một món cho nhiều ô. Nhánh đã kiểm không tự craft. Promote kiểm đủ các ô yêu cầu và chưa maxrank; level chủ yếu đã qua điều kiện mặc đồ. Nút ẩn/đổi trạng thái ở maxrank theo layout nguồn.

`hero.lua:415` tăngrank, xóa6ô cũ và đọc Init1..6 củarankmới. Audit25 Hero/rank1–7 cho thấy mọiInit item đều0. Không suy cho mọiHero/rank khác. Đường click không thấy thuGold riêng; điều này không chứng minh backend chắc chắn không có phí. Zatod giữ không tự thêm phíPromote theo D35.

Nguồn có warning mất bonus enchant và hoàn một phần vật liệu khi có đồ enchant. Zatod chưa có hệ đó nên chưa mở warning/refund/enchant trong phase này.

## 5. Hiện trạng code Zatod và phần phải hoàn thiện

| Đã có | Còn thiếu trong D35 |
|---|---|
| HeroData.Skills giữSlotId/Level; HeroBattleFactory đọc level đã lưu | ConfigInitialLevel/rule/curveGold, tabSkill thực và request nângskill |
| Timeline, target, projectile, buff, passive/aura trong core | Evo model/runtime/hook, coverage thật theo các skill đang hoạt động |
| HeroProgression/ItemInventory.Promote chuyển GUID sangAbsorbedItems | UI chungnút, QuickEquip batch hợp lệ, receipt/rollback đầy đủ choPromote |
| Copy/snapshot/replay hiện hành | Deep-copy/serialize Evo và các dependency, rules tương thích |

HeroCatalog.CreateHero hiện seed mọi slotLv1. ValidateHero đòi sốslot vàSlotId khớp config; nếu chỉ thêm slot4 mà không migration thì save3slot bị từchối. Migration đã duyệt: giữ Hero/3slot cũ/level/GUID/history, chỉ thêm slotthiếu theoconfig; chưa tới bậc thì vẫnkhóa. Không tự đưa cácslotcũLv1 lên21/41.

Promote hiện chưa có rollback/receipt như inventory actions. Khi triển khai phải checkpoint đủ rank, skill, Gold nếu liênquan, Inventory/Equipped/Absorbed,Revision vàreceipt. Retry cùngrequest trả kếtquả cũ; persistfail khôi phục đủ. Đây là thiếu sót xác nhận qua cấu trúc code, chưa thử gây lỗi vớiOwned thật.

D08 chủ động khác cách dùng tổngUnitRank nguồn: giữ ItemId/GUID thực đã mặc/hấp thụ, tính config hiện hành và bonus bậc độc lập, không cộng trùng. Snapshot trận cũ không đổi theo tiến trình sở hữu/config mới. D05 vẫn dùngstat trực tiếp, không đưaSTR/AGI/INT trởlại do hook nguồn tham chiếu chúng.

## 6. Phân biệt model đã duyệt với bằng chứng nguồn

Cấu trúc `SkillDefinition.Evolutions` với Id/RequiredSkillLevel/Description/ParameterChanges/TriggeredEffects là thiết kế Zatod đã duyệt, không phải tên class gốc Crystal. Giữ HeroSkillData chỉSlotId/Level; snapshot chụp đầy đủ config và dependency, runtime suy cácmốc từlevel. Chi tiết hợp đồng và kiểmtra nằm trong phase plan; không tạo bản yêu cầu cạnh tranh tại tài liệu review này.

Chỉ có dữ liệu/schema không chứng minh đã chạy đúng Evo. Agent phải port các handler cần thiết, kiểm trước/đúng/sau mốc, ghi coverage và giữ replay cũ theo rules phù hợp. Phần Tím/40Hero/chươngmới vẫn thuộc D34 tiếp theo.
