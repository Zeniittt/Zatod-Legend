# D34 — Tham chiếu mở rộng tới Tím và pool PvP

Cập nhật: **24/11/2026, Asia/Saigon**. Đây là phạm vi nội dung tiếp theo, **sau phase nền D35**. Quyết định hiện hành: [Design.md — D34/D35](../Design.md). Người dùng chọn cả5 mục trong cùng phaseD34 và yêu cầu rà lưu ý trước triển khai; chưa có lệnh code/build/deploy. Giả địnhD35 hoàn thành để bàn kế hoạch không thay trạng thái nghiệm thu thực tế. Agent đang thực thi [phase plan D35](zatod-skill-promote-phase-plan.md) không tự mở thêm các phần ở đây.

## 1. Phạm vi đã đồng ý

- Mở chương3–8 Normal, item/recipe/encounter và phụ thuộc để Hero tớiTím thường, qua Blue+1/Blue+2; chưa mở Tím+1 trởlên.
- Mở đủ đảo/map/portal/điểm tương tác, preview/cost/reward, art/animation/effect/hook và authoring. Giữ ID/lịch sử Hero và item theo D05/D08.
- Pool chọnPvP riêng khoảng40 Hero, giữ HeroDesk hiện có; không cấp40 Hero hoặc tự nângHero sở hữu. Mỗi đội vẫn tối đa5, chưa đổi Arena auto.
- Bộ40:25 hiện có cộng Razor,WR,CM,Naga,SG,TH,OD,Ursa,Sil,Luna,VS,POM,Huskar,Lich,KOTL. Tổng định nghĩa có thể vượt40 do Hero địch của chương mới.
- Preset đã đồng ý:Lv60/3sao/Tím thường/chưa mặc các ôTím, có đóng góp bậc và đồ bậc trước đúng D08. Level skillPvP theohelpernguồn=HeroLevel/basic1 là hướng đã đề xuất, cần ghi rõ khi lập phase-plan D34; không lấy tiến trình HeroDesk làm giới hạn pool.
- Tối nền theo manual ultimate/freeze đã được đồng ý. Bổ sung24/11: đã duyệt cả6 nhóm feelingcombat trong review, gồm Death/fade với các ngoại lệ nguồn; thêm rà/hoàn thiện UIportraitultimate và thanh máu theo nguồn. Chưa triển khai runtime.
- Chưa cần lưu sao/unlock Campaign qua launch; giữ D11. Nângskill/Evo/Promote/QuickEquip đã tách sang D35 làm trước.

**Làm rõ hiện hành24/11:** chi tiết skill/hook đợi codeD35 rồi bàn tiếp; các cơ chế phụ thuộc STR/AGI/INT nêu trong khảo sát tạm chưa làm trong phase này. Sáu map chương3–8 xanh/tím xen kẽ (3/5/7 xanh,4/6/8 tím), config ải lấy Crystal theo các ngoại lệ Zatod đã chốt. PvPrealtime dùng free toàn bộ40Hero Tím, tách sở hữu; không tự coi câu này chốt thêm level skill. Markdown giữ quyết định, Crystal giữ nguồn tham chiếu, Artifacts chỉ là output/evidence; importer không được phụ thuộc duy nhất vào file local trongArtifacts. Khảo sát feelingcombat mới tại [crystal-battle-presentation-review.md](crystal-battle-presentation-review.md). Lưu ý khảo sát cũ bên dưới chỉ còn hiệu lực trong phạm vi không bị làm rõ này thay thế.

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

## 6. Lưu ý triển khai cả 5 mục — khảo sát 24/11/2026

Đã đọc config/code trên đĩa và ChangeLog REVIEW-008/010/011, BUG-048/056/059. Không chạy importer, Unity, build hoặc thiết bị. Checkout được khảo sát vẫn có 25 Hero/14 Monster/142 item/131 skill/52 buff, 2 chương/39 ải/117 wave; các Hero tới Blue và có 3 slot chính. Đây không là kết luận về D35 ở chat/worktree khác. Khi triển khai cần nhận đúng code/report D35 và kiểm lại baseline.

### Import và đường bậc

- `Import-CrystalConfig.py` còn lọc `range(1,5)` và `Unlock<=4`; rank địch ngoài 1–4 thành RankId rỗng. Cần mở rank5–7, skill Tím và rank encounter đúng nguồn. Giữ bậc/slot/ID cũ, ledger GUID và công thức D08; preset Tím không mặc ô Tím nhưng vẫn có đóng góp bậc/đồ các bậc trước. Không cộng trùng tổng UnitRank.
- Importer cũ chưa tạo model Evo D35. Reimport nguyên bộ có thể ghi đè config mới/balance: nên xuất staging, xem diff, kiểm chạy lại không đổi dữ liệu rồi mới áp. Không dùng importer có ghi file để dò nguồn.
- `Import-ZatodChapterTwo.py` bắt buộc đọc mapping tại `Artifacts/CrystalPhaseChecks/zatod-id-mapping.json` rồi sinh lại `ZatodContentIds.cs`. Artifacts bị ignore, nên clone có full reference vẫn có thể thiếu đầu vào này. Mapping cần thiết phải đi theo Git hoặc được suy từ nguồn đã track; không làm mất alias hiện hành khi sinh lại. Helper còn root cũ và nhánh đọc ZIP trực tiếp phải được sửa theo D04/REVIEW-010 trước khi chạy.
- **Phương án không mangArtifacts đã kiểm24/11:** `ZatodContentIds.cs` đượcGittrack, có323alias (39unit/2chapter/112item/131skill/39stage); đốichiếuSourceId khớp25/25Hero,14/14Monster,131/131Skill active. Cóthểdựngmapping từbảngnày vàconfigđãtrack, bổsungIDmới từnguồnCrystal, khôngđoánlạiIDcũ. Helpercũ chạynguyên cóthểlỗi thiếufile; phải sửahelper trướcimport. KhôngcầncopyArtifacts chỉđểgiữmapping; chưasửahelper hoặcchạyimport tronglượtnày.

### Skill, Evo và stat trực tiếp

- **Đã điều chỉnh sau phản hồi24/11:** coverage skill/hook đợi codeD35 mới; các nhánh phụ thuộc STR/AGI/INT tạm chưa triển khai trongD34. Các ghi nhận source dưới đây vẫn là bằng chứng, yêu cầu trình ánh xạ ngay đã được thay thế; chưa có code bỏ/thay nhánh trong lượt này.
- Lập bảng từng Hero/skill/Evo đang mở, gồm hidden skill, buff, projectile và unit triệu hồi. Source `battle/heroes/Naga.lua` tạo NagaMirror (`_tid=145`) từ passive; cần đủ model/skill/art, vòng đời, RNG, target và attribution thống kê. Không coi import Skill JSON là đã port mọi override; không mở các nhánh awake/shard/skin ngoài phạm vi chỉ vì cùng file Lua.
- **Cần thiết kế thêm cho công thức phụ thuộc thuộc tính chính:** `OD.lua` chuyển INT caster/target và ultimate kiểm Main Attrib INT; `Sil.lua` có nhánh Evo chuyển INT. Lọc các mốc thực sự active, trình ánh xạ từng cơ chế theo D05. Không tự thay mọi INT thành AP, giữ INT ẩn hoặc bỏ điều kiện rồi gọi là parity. Ngoại lệ Sniper dùng AD không là phép đổi chung.
- D35 cung cấp hệ thống, không tự bảo đảm skill thứ4/Hero mới đã được port. Snapshot phải chụp đủ dependency mới; khi đổi logic core cần rule compatibility/version và kiểm archive cũ, ConfigVersion riêng không đủ bảo đảm replay giữ kết quả.

### Chương 3–8 và world

- Thêm 6 map chương độc lập, WorldMapId, portal đi/về theo tọa độ local/origin D21/D25. Kiểm spawn/collider không kẹt, điểm ải tiếp cận được, camera, interest riêng map và return context sau trận. World hiện tạo mọi đảo từ đầu; cần đo tài nguyên khi tăng số đảo, không tự đổi lifecycle làm mất presence.
- Đối chiếu đủ 154 ải/462 wave, SourceStageId, prerequisite xuyên chương, rank/level/stars địch, boss/modifier, tên English/icon, background, Cost và EXP/Gold/reward. Portal đi được khác với quyền Challenge. Giữ reset sao/unlock theo launch D11 và chính sách portal hiện hành nếu chưa có quyết định mới.
- World art theo D21, UI/battle theo D17; không dùng map nguồn để tự ghi đè layout world. Config mới phải chỉnh được trong GameEditor. Thiếu asset cần truy nguồn, không dùng control tạm thay art game.

### Đường farm thực tế

- **Đã duyệt tiêu chí nghiệmthu24/11:** test kỹ leveldesign/nguồnđồ/recipe/EXP-capHero/Gold/stamina/độkhó vàvòngkẹt ởcácmốc tớiTím. Kiểm bằng đườngchơi hợp lệ củaaccountmới/5Herođầu, táchfixturedev vàpresetPvPfree; thốngkê configđủ loại làbướcđầu, không thay thế thựcchơi. Chưa tựquyết mọi buff/nerf hoặcđổi pool đểlàmtestđạt; phát hiệnvấnđề phải ghi bằngchứng vàphươngán xửlý.
- **Giải thích24/11:** kiểm farm nghĩa là kiểm một ô đồ có đường nhận nguyên liệu/ghép hợp lệ và người chơi có thể đạt các điều kiện dùng nó. Ví dụ giả định (không là recipe thậtCrystal): cần10mảnhA+5mảnhB+Gold để ghép món tiếnbậc; nếuB chỉ ởải sau mà chưa có món đó thì không thắng nổi, có vòng kẹt. Có đủ item/recipe trong catalog chưa tự chứng minh có đường chơi này. Kiểm tra trước; chưa là quyền tự buff/nerf hoặc thay pool/balance.
- Audit cũ chỉ kiểm tập loại từ UI reward/recipe. Phải rà đồ thị nguồn→nguyên liệu→recipe→ô đồ, món thiếu và vòng phụ thuộc; kiểm mốc tiến bậc của account mới/5 Hero đầu mà không dùng DevLevel/AddItem. Kiểm cả lượng đồ, Gold craft/skill, EXP/cap Hero theo account, stamina và độ khó.
- Giữ D26: số món 0..MaxDropAmount, chọn có hoàn lại, tổng pool 100%, RNG loot riêng combat, chỉ cấp sau validate thắng/một lần. UI reward không phải đồ được bảo đảm hay tỷ lệ Crystal. **Đề xuất chưa chốt riêng:** kế thừa MaxDropAmount5/chia đều cho các pool ải mới; ghi rõ vào phase-plan. Không tự đổi pool39 ải cũ để lấp mọi nguồn thiếu.
- Nâng skill vẫn chỉ thu Gold theo D35; không mở nguồn sách chỉ để vượt điều kiện đã bỏ. Pool Hero PvP không tự mở nguồn sở hữu/Soulstone cho các Hero mới.

### Pool PvP riêng

- `ZatodFormationView` hiện lấy account.HeroDesk; server ở queue và Pair đều gọi `session.Team`. Cần projection riêng ở UI và allowlist/preset server; server tự dựng snapshot từ ID hợp lệ. Giữ đường Campaign/Arena theo sở hữu, không nới guard chung để biến mọi Hero catalog thành Hero sở hữu.
- Chặn ngoài pool/trùng Hero trong cùng đội, giữ tối đa5; selection PvP tách Formation sở hữu. Queue/cancel/retry/disconnect không ghi preset vào Owned hoặc phụ thuộc account cap/rank sở hữu. Chụp dữ liệu trận xác định, không đọc config live giữa trận.
- Preset đã chốt Lv60/3sao/Tím/chưa mặc ô Tím. **Level skill cần chốt rõ:** đề xuất theo helper nguồn là 4 skill chính Lv60/basic1, tự nhận các Evo đủ level theo D35. InitialLevel1/1/21/41 không phải level preset; không tự mở mọi Evo. Preset/pool nên chỉnh và validate được trong GameEditor.

### Tối nền và nghiệm thu

- Lấy trạng thái manual startup/freeze từ simulation, giữ caster/UI và freeze actor/effect đúng nguồn. Trả sáng ở Attack frame và đường interrupt/death/finish/cancel; kiểm ultimate chồng, replay pause/seek/x4, clear/load scene để tránh kẹt tint. Không dùng timer Unity riêng hoặc thêm freeze cho mode không có luật đó.
- Fade xác DeathDuration+2s+1s và ngoại lệ vẫn chưa được duyệt; chọn cả5 mục không tự bao gồm phần này. BUG-048 chỉ sửa clock Death/effect sau kết thúc trận.
- Theo BUG-056, kiểm texture format thực, sheet không chia hết cho4/fallback BC7, kích thước build và peak RAM/VRAM khi tăng Hero/effect/map. Nếu xử lý padding phải giữ pixel/GUID/pivot/rect/FPS/timeline và đo lại. Build headless theo BUG-059 là workaround công cụ, không thay kiểm gameplay Android/iOS thật.
- Mỗi Hero/skill active cần case target/timing/Evo; thêm tương tác buff/aura/summon/projectile/freeze lồng và client/checker/replay parity. Kiểm LAN Windows–Android–iOS trên thiết bị phù hợp, phân biệt build thành công với đã thử battle. Dùng profile/port/Owned test riêng, giữ dữ liệu chính.

**Thứ tự đề nghị trong cùng phase:** nhận baseline D35 → sửa đầu vào helper/lập coverage/chốt công thức còn mở → kiểm một đường xuyên suốt chương3/Blue+1/skill mới/PvP roster → mở đủ chương3–8/Tím/pool40 → rà farm/độ khó → hoàn thiện tối nền và nghiệm thu toàn phase. Đây là mốc kỹ thuật, không giảm phạm vi đã chọn. Chưa tạo phase-plan D34 hoặc triển khai runtime trong lượt khảo sát này.
