# Zatod — Khảo sát dọn config và tên tiếng Anh

Ngày 19/11/2026. Chỉ khảo sát theo yêu cầu; chưa xóa/đổi ID/Name/runtime config hay code. Hướng thiết kế ghi tại D16.

## Phạm vi dọn bảng

| Bảng | Hiện tại | Bộ mới giữ | Định nghĩa cũ loại |
|---|---:|---:|---:|
| Heroes | 40 | 16 | 24 |
| Monsters | 17 | 10 | 7 |
| Items | 69 | 67 | 2 |
| Skills | 127 | 86 | 41 |
| Buffs | 33 | 33 | 0 |
| Stats | 27 | 27 được tham chiếu | 0 |

Khảo sát chuỗi reference của định nghĩa mới không tìm thấy liên kết tới định nghĩa Hero/Monster/Item/Skill cũ trong bốn bảng này. Tuy nhiên `Campaigns.txt` là campaign cũ, `CrystalCampaigns.txt` là 18 ải/54 wave mới; cần xử lý entry point/campaign loader và công cụ cũ khi dọn, không chỉ xóa vài dòng Heroes.txt. Stats dùng chung còn được bộ mới tham chiếu nên không xóa theo độ cũ của field.

Code/tools còn hardcode training_warrior, axe_basic, monster pixel, crystal_3, crystal_item_108, starter IDs, sourceId→definitionId builder; importer hiện cố ý trộn legacy rows. Khi triển khai cần sửa các phụ thuộc và chống reimport tái tạo bộ cũ. SourceId số vẫn cần trace/hook/dispatch trong core; nó khác ID authoring dạng string.

## Nguồn English đã xác nhận

- File `Crystal Legend/recovered/scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data/texttable/texttable.lua`: 29.498 key top-level, nested context/language; không execute Lua, chỉ parse các entry liên quan bằng reader return-only.
- `tools.lua` khoảng dòng 1791–1835: loadTextCache/formatText đọc bảng và chọn `en` theo key/context. `translatecsv.lua`: dữ liệu bảng CN được bản địa hóa khi chọn language khác CN. Vì importer chưa chạy bước này nên các Name Unity còn tiếng Trung.
- Toàn bộ **67/67 item** có tên English trực tiếp, không trùng khi normalize snake_case. Ví dụ:

| Tên nguồn | English trong client | ID ví dụ |
|---|---|---|
| 小圆盾 | Small Stout Shield | small_stout_shield |
| 补刀斧 | Iron Axe | iron_axe |
| 力量拳套 | Boxing Gloves of Strength | boxing_gloves_of_strength |
| 回复戒指 | Ring of Regen | ring_of_regen |
| 小魔棒 | Simple Staff | simple_staff |

- **74/74 skill không ẩn** có tên English trực tiếp. Tổng bộ mới là 86 skill, 75 dòng có direct English (gồm một hidden); 11 dòng &... đều Hide On Card. Bỏ prefix chỉ tìm được nhãn nền cho 4/11; 7 dòng còn lại chưa có exact mapping: OK_evo, OK_fashion, Bone_warschool, Pugna_warschool, Tiny_warschool, Ench_evo, Ench_fashion_cake. Tên kỹ thuật vẫn có English code nhưng không phải nhãn bản địa hóa chính thức. Không được xóa hidden skill chỉ vì không có bản dịch trước khi kiểm tra phụ thuộc.
- Lina có Basic Attack, Deity Slash, Draco Strike, Radiant Array trong đúng bảng English này. Không tự thay bằng tên skill của một game Dota khác.
- Hero có thể có internal code khác localized display: Coco→Captain, DR→Shadow, Lina→Vulcano, Zeus→Zeus, Ench→Lil' Deer. Đây là bằng chứng hai loại tên, chưa tự quyết định đổi Lina thành Vulcano trong Zatod. Quy tắc người dùng chốt là ID theo tên object snake_case; danh sách display name Hero còn phải đối chiếu mong muốn Zatod khi lập mapping.

## Điểm cần xử lý khi đổi ID (đề xuất kỹ thuật)

- Hero Zeus→zeus, Axe Titan→axe_titan theo ví dụ người dùng; các ví dụ item ở trên là mapping đề xuất, chưa ghi runtime.
- 26 skill khác nhau cùng tên Basic Attack; hai dòng Headshot. Cần scope tên ID theo Hero/cơ chế/biến thể, ví dụ lina_basic_attack, zeus_basic_attack, lina_deity_slash. ID tạo một lần ổn định; đổi nhãn hiển thị sau này không tự viết lại ID đang dùng.
- Cập nhật liên kết item slots/absorbed history, skill slots, enemy wave/hook, starters, validators, test profiles/dev grants và importer. Preserve GUID instance, SourceId và config snapshot/replay; không reset profile hoặc rename bằng replace mù.
- Xóa legacy definitions khỏi config hoạt động không đồng nghĩa xóa art/source/raw/reference. Đóng gói tài liệu/backup/mapping trước khi triển khai.

Bằng chứng đầy đủ 67 item/86 skill: `Artifacts/CrystalPhaseChecks/english-name-audit-20261119.json`. Không cần đoán bản dịch item hay lấy bảng của game khác; nhóm hidden chưa có nhãn phải được ghi rõ riêng.

## Đối chiếu lại 26 Basic Attack

Đã kiểm tra ngày 19/11/2026: bộ mới có **16 Hero + 10 Monster = 26 combatant definitions**, không phải 26 Hero. Mỗi definition có một NormalAttackSkillId riêng; 26 ID đều khác nhau, mỗi skill có đúng một owner, toàn bộ SourceSkillId khớp trường Basic Skill của Unit gốc. Không có Basic Attack mồ côi hoặc hai unit trỏ vào cùng ID basic. Tên hiển thị chung Basic Attack là nhãn bản địa hóa của đòn thường; thông số/range/projectile/phase của mỗi dòng vẫn riêng. Evidence: `Artifacts/CrystalPhaseChecks/basic-attack-ownership-20261119.json` (PASS). Không sửa runtime.
