# D34 — Tham chiếu mở rộng tới Tím và pool PvP

Cập nhật: **23/11/2026, Asia/Saigon**. Đây là phạm vi nội dung tiếp theo, **sau phase nền D35**. Quyết định hiện hành: [Design.md — D34/D35](../Design.md). Chưa triển khai nội dung D34; agent đang thực thi [phase plan D35](zatod-skill-promote-phase-plan.md) không tự mở thêm các phần ở đây.

## 1. Phạm vi đã đồng ý

- Mở chương3–8 Normal, item/recipe/encounter và phụ thuộc để Hero tớiTím thường, qua Blue+1/Blue+2; chưa mở Tím+1 trởlên.
- Mở đủ đảo/map/portal/điểm tương tác, preview/cost/reward, art/animation/effect/hook và authoring. Giữ ID/lịch sử Hero và item theo D05/D08.
- Pool chọnPvP riêng khoảng40 Hero, giữ HeroDesk hiện có; không cấp40 Hero hoặc tự nângHero sở hữu. Mỗi đội vẫn tối đa5, chưa đổi Arena auto.
- Bộ40:25 hiện có cộng Razor,WR,CM,Naga,SG,TH,OD,Ursa,Sil,Luna,VS,POM,Huskar,Lich,KOTL. Tổng định nghĩa có thể vượt40 do Hero địch của chương mới.
- Preset đã đồng ý:Lv60/3sao/Tím thường/chưa mặc các ôTím, có đóng góp bậc và đồ bậc trước đúng D08. Level skillPvP theohelpernguồn=HeroLevel/basic1 là hướng đã đề xuất, cần ghi rõ khi lập phase-plan D34; không lấy tiến trình HeroDesk làm giới hạn pool.
- Tối nền theo manual ultimate/freeze đã được đồng ý. Timeline xác chết vẫn là phần đã hỏi khảo sát; không suy câu đồng ý tối nền thành mọi chi tiết fade xác đã được duyệt.
- Chưa cần lưu sao/unlock Campaign qua launch; giữ D11. Nângskill/Evo/Promote/QuickEquip đã tách sang D35 làm trước.

## 2. Baseline khi khảo sát

Config có25 Hero,14 Monster,142 item,131 skill,52 buff;2 chương/39 ải/117 wave. Rank sở hữu hiện tớiBlue. Account mới cấp5 Hero Coco/DR/Lina/Zeus/Ench; số định nghĩa không phải số Hero sở hữu của từng account.

25 Hero hiện có: Coco,DR,Lina,Zeus,Lion,QOP,OK,TK,Sniper,Bone,Pugna,SNK,NEC,Tiny,Viper,Ench,Med,SP,OM,SF,JUGG,Axe,ES,AV,THD.

BảngUnit nguồn có174 dòngHero,161 Enable và165 có bảnghero_equip. Không coi174 là số Hero đã port/đủasset/chạyđúng;314 container có cảskin/NPC, không phải314 Hero.

Chọn độiPvP hiện lấyHeroDesk ở cả UI vàserver. Pool riêng phải thay projection lựa chọn và đường xác thực/tạo snapshot server, không chỉ đổi roster trên màn hình.

## 3. Chương và đường nguồn item

| Chương thêm | Ải | Wave |
|---|---:|---:|
| 3 | 16 | 48 |
| 4 | 19 | 57 |
| 5 | 20 | 60 |
| 6 | 20 | 60 |
| 7 | 20 | 60 |
| 8 | 20 | 60 |
| Thêm | 115 | 345 |

Tổng sau mở rộng:8 chương/154 ải/462 wave.

Audit lấy toàn bộ UI reward preview củaNormal rồi đóng tập sản phẩm ghép theo equipcraft. Kết quả theo loại item, **không phải xác suất/loot backend Crystal, không phải poolZatod đã được cập nhật**, chưa xét sốlượng/Gold/stamina/độkhó hoặc khả năng thắng.

| Tập Hero | Đồ trực tiếp/closure để vàoTím | Gồm cả ô đồTím | Level đồ tối đa trướcTím/tạiTím |
|---|---|---|---|
| 5 khởi đầu | 69 / 126 | 76 / 144 | 52 / 62 |
| 25 hiện có | 95 / 160 | 102 / 176 | 53 / 65 |
| 40 dự kiến | 96 / 163 | 105 / 183 | 53 / 65 |

Với các tập khảo sát, preview tới chương7 đủ đường loại để vàoTím; tới chương8 đủ ô đồTím. Đây là tổng loại nguồn cần, không phải số item mới cần thêm vào142 định nghĩa hiện tại. Cần trừ phần đã có và không tính Soulstone/EXP vào gear closure. Muốn preset đủ6ôTím cho bộ40 thì nguồn cần tớiLv65; presetLv60 hiện chưa mặc ôTím nên không có mâu thuẫn đó.

## 4. Quan sát presentation Crystal

### Xác chết

`battle/unit.lua:1216` lấy action_duration từ Puppet.Resource/AnimDuration; khi die chuyểnDeath và gọi actor.onUnitDeath. `battle/actor.lua:331` mặc định chờDeathDuration+2s, fade1s rồiẩn; tổngDeathDuration+3s nếu actor/scene chưa cleanup trước.

Ví dụ: Coco4,333s; DR4,167s; Lina3,875s; Zeus4,208s; Ench4,5s. Thời lượng bake hiện có khớpDeath source của5 Hero này. Summoned bỏ2s chờ; DeathWithEffect có nhánhẩn ngay/effectriêng; isDisapearWhenDie=false có thể giữxác. Không dùng thờiđiểmẩn xác để quyếtđịnh chết/damage/hồisinh.

Zatod renderer hiện sampleDeath tới frame cuối, chưa có fade/hide theo rule này. BUG-048 đã sửa clockDeath/effect sau khi trận kếtthúc, không đồngnghĩa đã có fade xác.

### Tối nền

`unit.castManualSkill` gọiengine.freeze rồiunfreeze riêngcaster. `battle_scene.lua:823` tintbackgroundRGB96 vàdừng effect cósẵn; `entity.lua:66` tintentity bịfreeze×0,4. `skill.lua:837` unfreeze ởAttack frame, không chờđạnchạm hoặc hết effect; finish/interrupt/death cũng cóđườnggiảiphóng, freeze_level đếmlồng.

Không phủđen kínUI hoặc ápcho mọi skill tựđộng/mode. Zatodcore đãcóManualStartup nhưngBattleStage chưa tintnền/actor. Đây là kếtluận từsourcephụchồi, chưađối chiếu video gamegốc.

## 5. Evidence và đầu vào khi triển khai D34

Audit/script local: `Artifacts/ZatodPurplePhaseReview_20261123/audit.json` và `review.py`. Source hiện ở `Unity/Assets/Crystal Legend/` theo lần di chuyển23/11/2026. Cập nhật23/11:96.077 file reference đã commit/push lênmain, có qua clone/checkout;3file lớn và3bản diagnostic chứa khóacloud chỉ giữlocal theo D04/REVIEW-011. Kiểm đầu vào thực tế sau checkout. `Artifacts/` vẫn bịignore. Helper audit/import còn đường root cũ phải được cập nhật trước khi chạy. Các con số trên được ghi lại để không phụthuộc hoàn toàn vàoArtifacts.

Khi chuyển sangD34, lập phase-plan riêng từ các quyếtđịnh này và kiểm lạibaseline. Phải rà đủ skill thứ4/hiddenhook, chuyểnSTR/AGI/INT sangstat trực tiếp, đồ/recipe vànguồn farm, giữ ledgerGUID/replay, kiểm độkhó vàtài nguyên trênmobile. Không báo parity hoặc hoànthành chỉ từsốHeroDefinition/importJSON.
