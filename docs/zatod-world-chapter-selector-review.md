# Khảo sát art thị trấn, chọn chương và boss điểm ải

Ngày 24/11/2026, Asia/Saigon. Quyết định hiện hành: Design.md D38; giữ D11/D17/D20/D21/D22/D26/D34 ngoài phần D38 thay thế. Đây là bằng chứng khảo sát và lưu ý triển khai, chưa là báo cáo đã sửa runtime. Người dùng yêu cầu xem source/asset và nêu lưu ý; chưa yêu cầu code/build.

**Checklist thực thi/nghiệm thu:** [phase-plan D38](zatod-world-ui-polish-phase-plan.md). Tài liệu này giữ bằng chứng khảo sát; checkbox, ngoài phạm vi, migration/giao dịch và trạng thái bàn giao xem phase-plan. Ảnh đã lưu cùng repository ở `reference/d38-world-ui/`.

## Ranh giới phase hiện tại — chốt lại 24/11/2026

Phase bắt đầu từ yêu cầu sửa nútOK sau Equip. Gồm UX-001; art object làng Crystal; selector/unlock/portal chương; boss điểm ải và minor Passed/key replayable; chuẩn bị asset trước trận; PoolManager/texture; kiểm các thay đổi này và20vòng/20phút. Phần mởTím/chương3–8/PvP40Hero/cải thiện feeling combat của D34 thuộc phase trước, không nhập lại hoặc làm lại trong phase này. Áp UI/world mới lên catalog hiện có từ phase trước; tiến trình/save/GUID giữ chính sách hiện hành.

Các con số39/154ải,115ải và độ phủ asset bên dưới là bằng chứng khảo sát ở mốc ghi nhận, không phải checklist yêu cầu nhập thêm nội dung trong phase này. Trạng thái runtime/QA phần trước phải tra report tương ứng; việc phân định phase không tự xác nhận phần đó đã được agent chạy kiểm lại.

## Phạm vi đã chốt

- Equip thành công tự đóng panelitem theo D28/UX-001, thất bại giữ panel/reason; đối chiếu đúng operation/context.
- Dùng asset Crystal cho object tính năng ở làng.
- Làng → tương tác Phó bản → selector chương như ảnh Legend World → chọn chương đã mở → teleport map chương.
- Map chương có portal trái/phải cho chương liền trước/sau; giữ Town góc trái trên.
- Chương sau cần qua ải cuối chương trước và đủ level tài khoản theo Crystal.
- Điểm ải dùng boss trong trận; ải nhỏ đã qua hiện Passed, xem preview được nhưng không đánh lại. Ải chính đánh lại được.
- Không triển khai Guild/Tower, Elite hoặc Raid chỉ vì có asset/nút nguồn. Không đổi SPUM avatar, chính sách Owned hay reset tiến trình D11.

## Nguồn và đầu vào

Mọi đường source bên dưới tính từ repository root:

- Lua root: `Unity/Assets/Crystal Legend/recovered/scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data/`.
- Asset root: `Unity/Assets/Crystal Legend/recovered/assets/install_time_pack/remake/`.
- Công cụ đọc bảng thuần dữ liệu: `Unity/Assets/Crystal Legend/recovery_tools/lua_data.py`; đọc `Stage`, `Battle`, `Unit`, `PlayerLevel`, không chạy game Lua hoặc importer.
- Ba ảnh người dùng cung cấp là tham chiếu bố cục/hành vi mong muốn. File clipboard trong Temp không phải dependency của clone khác; các asset/source nêu ở đây đã có trong reference repository theo D04.
- Không cần Artifacts hoặc ZIP download để đọc các nguồn này. Helper import/bake còn resolver root cũ/đọc archive phải được sửa trước khi dùng, theo D04 và `docs/crystal-legends-reference.txt`.

## Màn Legend World trong Crystal

`ui_new/modules/stage/legendaryContinent.lua` là implementation trực tiếp của view ảnh 1, class `ed.ui.stageBigMap`:

- `createMap`: ghép nền và hỗ trợ kéo ngang.
- `upDataMapNpc`: gắn từng đảo/chương, tên, sao, outline chọn và đổi màu theo StageMax.
- `getMainTouchHandler`: từ chối chương vượt StageMax và chương chưa đủ account level; chương hợp lệ gọi `newChangeChapter` của UI chọn ải Crystal.
- Zatod cần đổi bước cuối thành request teleport world do server kiểm tra. Không sao chép nguyên callback Lua rồi giả định đã có travel multiplayer.

Asset đã kiểm tồn tại dưới asset root:

| Thành phần | Đường tương đối |
|---|---|
| Nền kéo ngang | `UI/alpha/1080P/bg/worldmap_normal.jpg` (3998×1440), `worldmap_normal_1.jpg` (936×1440) |
| Đảo chương 1–8 | `UI/alpha/1080P/campaign/worldmap/worldmap_map_norlmal_1.png` … `_8.png` |
| Outline chọn | cùng thư mục, `worldmap_map_norlmal_choose_*.png` |
| Nhãn chương | cùng thư mục, `worldmap_chapter_normal_bg.png` |
| Khóa | cùng thư mục, `worldmap_chapter_lock.png` |

`norlmal` là tên thật của asset nguồn, không sửa chính tả khi resolve path. Đã mở xem nền gốc; nó chứa vị trí biển/đảo trống để đặt các layer chương, không phải ảnh screenshot đã dính toàn bộ nút/chữ. Ghép đúng layer và tọa độ nguồn; không kéo giãn một ảnh nền thành toàn bộ selector. Cần kiểm safe area, aspect rộng/hẹp, kéo ngang không bị nhận thành chọn chương, overlay khóa joystick/input bên dưới, và điểm chạm không đè nhau.

`player/playerlimit.lua::chapterUnlockLevel` tra `PlayerLevel.Chapter`; mốc đã đọc:

| Chương | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|---|---|---|---|---|---|---|---|---|
| Account Lv tối thiểu | 1 | 5 | 8 | 16 | 26 | 36 | 46 | 56 |

Mốc này là level tài khoản, không phải Hero level/skill level. Native UI còn có server-max chapter và Elite riêng; giới hạn chương Zatod phải theo catalog đang được mở, không cho travel đến đảo có art nhưng chưa có world/config. Chỉ Normal đang trong phạm vi D34. Tên/hiển thị phần trăm nên lấy chapter/stars thật, không copy chữ hoặc 100% từ screenshot.

## Object tính năng ở làng

Nguồn: `ui_new/configs/mainSceneMapConfig.lua::buildingsConfigs`, dùng bởi `ui_new/modules/main/mainScene.lua`.

| Feature nguồn | Resource | Container đã kiểm |
|---|---|---|
| Chapter / stageSelect | `eff_UI_Main_Pve` | `pfca/effect/eff_UI_Main_Pve.fca` |
| Guild | `eff_UI_Main_Guild` | `pfca/effect/eff_UI_Main_Guild.fca` |
| Pvp / PVP (Arena nguồn) | `eff_UI_Main_Pvp` | `pfca/effect/eff_UI_Main_Pvp.fca` |
| SkillTowerScene | `eff_UI_Main_fancytower` | `pfca/effect/eff_UI_Main_fancytower.fca` |
| PeakArenaPvpScene | `eff_UI_Main_PeakArena` | `pfca/effect/eff_UI_Main_PeakArena.fca` |

Các mục này là container hiệu ứng/animation, không đơn giản là một Sprite PNG có thể đổi VisualResource là xong. Cần kiểm dependencies, action Idle/default, atlas/alpha/blend và bake/import theo pipeline hiện có; chưa chạy bake hoặc nghiệm thu render chúng trong lượt khảo sát này. PeakArena được config gắn `spine=true`; phải kiểm format và loader thực tế, không giả định mọi `.fca` dùng cùng renderer. Không khẳng định PeakArena chính là realtime PvP của Zatod: cần chọn object Crystal phù hợp, phân biệt rõ hai điểm Arena/realtime bằng hình/nhãn.

Town hiện dùng các art `goddess`, `main_building`, `watch_tower`, `npc_varn`, `npc_celeste` từ bộ world cũ. Chuyển art giữ interaction IDs/feature targets, chỉnh chân/pivot/scale/độ sâu sorting và vùng tương tác theo kích thước mới. Không lấy collision của toàn bộ sprite animation làm vùng cản đường; kiểm người chơi không bị kẹt hoặc bị building che hoàn toàn. Feature chưa có logic tiếp tục thể hiện trạng thái hiện hành.

## Crystal phân biệt ải nhỏ và ải chính

Nguồn quyết định: `Stage.lua` field `Key Stage`; không suy loại ải từ hình hai kiếm hoặc từ việc encounter có Boss.

- `ui_new/modules/stage/stageselect.lua::getStageRes` tạo current/locked/passed theo field này và sao cá nhân.
- `doStageTouch::canTouch` chỉ nhận current, hoặc passed có `info.eid` (điểm ải chính). Ải nhỏ passed không nhận thao tác chọn lại.
- `ui_new/modules/stage/stagedetail.lua::createRepeatBattle` trả ngay khi `Key Stage` không true; nguồn có cơ chế đánh lại/sweep cho ải chính.
- `stageselectres.lua` map chương 1: Stage1 có eid, Stage2/3 không có, Stage4 có eid. Không kết luận mọi ải Normal đều một lần.
- Đây là bằng chứng client Crystal; không phải đã phục hồi backend gốc hoặc đã chạy lại game gốc. Server Zatod phải tự thực thi policy D38 đã chốt.

Thống kê trực tiếp bảng Stage, Normal chương1–8:

| Chương | Tổng ải | Ải chính | Ải nhỏ |
|---|---:|---:|---:|
| 1 | 18 | 6 | 12 |
| 2 | 21 | 7 | 14 |
| 3 | 16 | 6 | 10 |
| 4 | 19 | 7 | 12 |
| 5 | 20 | 7 | 13 |
| 6 | 20 | 8 | 12 |
| 7 | 20 | 7 | 13 |
| 8 | 20 | 7 | 13 |
| Tổng | 154 | 55 | 99 |

Hiện CampaignStageDefinition chưa nhập KeyStage/Repeatable; cần field rõ và nhập từ nguồn, dùng chung server/UI/GameEditor/checker. Chính sách cho xem preview ải nhỏ passed là bổ sung của Zatod theo yêu cầu người dùng; disable Challenge, có lý do Already passed, không biến thành khóa luôn popup. Ải chính vẫn challenge được theo điều kiện thể lực/roster hiện hành. Không mở thêm feature Raid trong phạm vi này.

Kiểm pool 39 ải hiện hành: 20 loại item xuất hiện, cả 20 đều có ít nhất một nguồn trong 13 ải chính; không phát hiện item chỉ rơi từ 26 ải nhỏ. Đây là kiểm độ phủ nguồn, chưa chứng minh đủ tốc độ farm/EXP. Sáu chương mới, recipe, bậc Tím và level gate cần kiểm tiếp khi có config: random 0–5 loot cộng policy một lần có thể làm kẹt nếu item/EXP cần thiết chỉ nằm ở ải nhỏ. Không tự tăng drop hoặc cấp bù đồ để che vấn đề.

## Boss đứng ở điểm ải

- Dùng định danh enemy có Boss trong encounter đã cấu hình, resolve đúng Hero/Monster và body animation Crystal. Giữ liên kết StageId với preview; không dò bằng tên hiển thị hoặc lấy ngẫu nhiên một quái trong wave.
- 39 ải hiện hành đều có boss ở wave3; tổng cộng có 42 enemy slot gắn Boss do chương2 ải8 còn có boss wave1/2 và ải9 còn có boss wave1. Có 26 DefinitionId boss khác nhau, tất cả có AnimationSet resource trên đĩa. Chưa nghiệm thu Idle/world scale, chưa kiểm độ phủ asset của 115 ải dự kiến thêm.
- `stageselectres.lua::getStageBossId` của Crystal lấy wave đầu có Boss Position >0. Config hiện hành đã có boss ở nhiều wave (chương2 ải8/9), nên không copy nguyên hàm này cho world: đại diện phải khớp boss ở wave cuối đang dùng trong preview D20; nếu wave cuối có nhiều boss thì cần field override hoặc thứ tự chọn rõ ràng.
- Ví dụ Candidate? trong config hiện hành và Battle source đều có Boss Pugna, SourceUnitId18/Pugna.cha. Tên MageBone người dùng nêu là ví dụ mô tả hình đại diện; không dùng tên đó để sửa config combat hoặc hardcode object Candidate?. Nếu muốn đổi boss thật thì là thay đổi encounter riêng.
- Render Idle tại vị trí ải, không gắn battle brain, không tạo HeroData/Owned, không chạy logic skill/buff ngoài combat. Có thể dùng lại renderer animation hiện có nhưng tách clock khỏi replay trận.
- Giữ foot anchor, ground shadow, scale và sorting để nhân vật đứng trên mặt đất. Collider/hotspot theo vị trí config, nhãn tên/Passed đặt theo bounds đã chuẩn hóa; nhiều ải có cùng boss vẫn là các interaction khác nhau.
- Đối với ải chính đang dùng hình riêng theo D29, cần áp dụng phạm vi boss đại diện D38 đồng nhất; không mặc định giữ hình cũ vì chỉ 26 node generic hiện có hình hai kiếm. Get Way/source-card icon là UI riêng D29, không tự đổi thành actor hoặc bật điều hướng.

## Travel, giao dịch và migration cần giữ

- `ZatodWorldIntegration.cs` hiện gửi WorldTravel ngay khi tương tác portal Campaign ở town; phải đổi thành mở selector và khóa input nền.
- `ZatodWorldNetwork.cs::UseWorldPortal` hiện chỉ resolve interaction từ map hiện tại rồi đổi MapId/spawn/revision; chưa kiểm unlock chapter hoặc account level. Không tái dùng một request cho arbitrary map ID mà thiếu validation.
- Selector và portal dùng cùng service CanEnterChapter. Validate target/catalog, origin/interaction hợp lệ, player state không đang combat/modal có giao dịch, prerequisite và level. Không tin màu sáng từ client. Reject không đổi map, không trừ thể lực hoặc tạo pending loot.
- Chương đầu/cuối không có portal tới map không tồn tại. Spawn hai đầu tách vùng portal; sau travel camera/world interest và MapRevision cập nhật đúng, hai client chỉ thấy người cùng map.
- Điều kiện ải không chỉ ở StagePreview: từ chối BeginCampaign với cleared minor stage, kể cả request trực tiếp, popup cũ hay nhấn kép. Thắng được settlement một lần theo D26; thua/disconnect chưa clear vẫn thử lại được theo flow hiện có. Replay xem lịch sử không phát thưởng.
- Passed/sao/unlock lấy snapshot riêng từng tài khoản, không ghi lên global map definition hoặc broadcast chung trạng thái cá nhân. Kết thúc trận trở lại đúng map/điểm theo D21, không rơi về chapter1 vì selector mới.
- Giữ nguyên ID/SourceStageId/Item GUID, owned history và replay/archive cũ. Config bổ sung loại ải/unlock không reset save Owned; tiến trình Campaign theo phiên D11 vẫn reset khi mở game mới. Cần kiểm kết hợp reset này với level tài khoản đã cao và cổng chương còn khóa theo clear mới.

## Hiệu năng mobile — phạm vi đã chốt 24/11/2026

Quyết định mới nhất của người dùng thay phương án đề xuất trước đó. Chỉ cập nhật tài liệu; chưa sửa runtime, prewarm/pool, import texture, build hoặc kiểm hiệu năng trong lượt ghi nhận.

### Hai mục đã bỏ khỏi phase

- Bỏ mục1: không làm bước đo baseline riêng trước khi tối ưu; không coi việc lập trace/đo CPU-GPU/p95/p99 trước sửa là điều kiện bắt buộc để bắt đầu.
- Bỏ mục2: không đổi sang chỉ tạo visual map đang đứng hoặc thêm vòng đời/cache map theo đề xuất cũ. Không đưa lại hướng này dưới tên lazy-load, streaming hay cache gần đây. Nguồn art, boss Idle theo D38 và layout world vẫn làm trong phạm vi riêng đã chốt; chúng không tự cho phép đổi cơ chế tải map.

### Ba mục đã duyệt

**Mục3 — Chuẩn bị tài nguyên trong bước vào trận.**

- Từ snapshot đội hình/encounter, chuẩn bị Hero/Monster, background, audio và dependency effect, buff, projectile, summon có thể xuất hiện trong trận. Danh sách40Hero ở màn chọn dùng portrait; body combat được chuẩn bị cho đội hình/địch thực tế cùng dependency của chúng.
- Tận dụng bước loading battle hiện có. Nạp tài nguyên và prewarm pool trước khi bắt đầu trình bày combat; xử lý thiếu asset/thất bại/hủy loading rõ ràng, không gắn kết quả load cũ vào trận mới.
- Giữ giao thức bắt đầu trận/tick/input PvP hiện có, checker/replay và return context. Chuẩn bị asset không cho phép tự dừng simulation giữa trận hoặc đổi thời điểm damage/freeze để chờ effect.

**Mục4 — PoolManager và texture.**

- Người dùng yêu cầu dùng **PoolManager** cho object xuất hiện thường xuyên và có thể tái sử dụng: effect, projectile visual, số damage/heal/crit và các visual tương tự. Khi hết lượt sử dụng trả object về pool, lượt sau lấy lại, giảm tạo rồi xóa liên tục.
- Pool quản lý theo prefab/resource/type phù hợp, có số lượng giữ lại hữu hạn và prewarm theo nhu cầu trận. Không tăng cache theo tổng số lần cast hoặc giữ mọi tài nguyên từ mọi trận mãi mãi.
- Khi acquire/release phải reset elapsed time/animation, parent/transform/facing/scale, renderer/material/alpha, sorting, text, target/entity/battle context, coroutine/tween và callback/event gắn lần dùng cũ. Chặn trả hai lần và callback cũ tác động object đã được tái sử dụng. Reset PlayableGraph theo đúng renderer, không để đồ họa/timing của lần trước lọt sang lần sau.
- Pool là vòng đời object presentation; entity/buff/projectile logic vẫn được simulation quản lý như trước. Không dùng reuse để đổi SourceId/EntityId, sát thương, input, GUID hoặc kết quả checker/replay.
- Cleanup/reset đúng khi kết thúc trận, thoát scene hoặc hủy vào trận. Asset chỉ được giải phóng khi không còn object/pool/reference dùng đến. Kiểm pool còn trong giới hạn khi spam skill/chuyển nhiều trận.
- Giữ kiểm format nén texture thực trên từng nền tảng. Nếu sửa BUG-056 về sheet/padding thì giữ frame pixels, sprite rect/pivot/GUID/FPS/timeline và kiểm hình; không tự giảm resolution, bỏ effect hoặc cắt frame. Đây không phải lệnh đổi toàn bộ hệ quản lý asset.

**Mục5 — Kiểm sử dụng lặp và chơi lâu.**

- Chạy20 vòng làng→chương→trận→làng, gồm vào/thoát trận, nhiều ultimate/effect/triệu hồi và trường hợp hủy loading khi phù hợp; kiểm pool được tái sử dụng và không để sót object/callback.
- Chơi liên tục ít nhất20phút để kiểm RAM có tăng không giới hạn, khựng hình/độ mượt có xấu dần hoặc giảm theo nhiệt máy không. Kiểm khả năng quay về đúng map và tiếp tục tương tác.
- Kiểm trên OPPO Pad Air/iPhone11 khi có thiết bị và Windows đối chứng; báo rõ phần thực tế đã thử và phần còn thiếu. Theo dõi FPS/RAM/thời gian chờ trong các bài này không đồng nghĩa mở lại mục1 baseline riêng đã bỏ.
- Chưa chốt60FPS hoặc ngân sách RAM/load cụ thể; không dùng ngưỡng đề xuất cũ làm yêu cầu của người dùng. Giữ chất lượng/feeling Crystal đã chốt và hồi quy phần combat/checker/replay chịu tác động bởi preload/pooling.

### Bằng chứng khảo sát giữ để tham khảo

`ZatodWorldView` hiện tạo sẵn các map; `ZatodBattleSprite.Initialize` đọc toàn bộ clip trong AnimationSet; `ZatodBattleStage` tạo/hủy actor/effect khi phát sinh; `ZatodBattleSceneController` đã có load/unload scene bất đồng bộ. Đây là quan sát code từ lượt trước, chưa chứng minh app hiện lag/leak; không lấy quan sát này để tái đưa mục1/2 vào phạm vi. BUG-056 là lỗi texture đã được xác nhận trước đây, không khẳng định tái diễn trên bản mobile mới khi chưa kiểm.

## Kiểm tra nghiệm thu khi được giao triển khai

Làm rõ 24/11/2026 sau rà lưu ý: người dùng giữ reset Campaign theo phiên ở phase hiện tại và để save progress sang phase sau. Đã đồng ý selector mở tại chương đang chơi/chương cao nhất đã mở và hiển thị lý do khóa cụ thể. Bàn giao dùng client/server đồng bộ bản mới, kèm UX-001 tự đóng panel sau equip thành công. Nền simulation/checker/replay tiếp tục dùng phần đã làm; chỉ kiểm hồi quy sau thay đổi liên quan. Hiệu năng theo quyết định mới nhất ở trên: bỏ mục1/2, duyệt preload trước trận, PoolManager/texture và kiểm20vòng/20phút; giữ nguyên chất lượng art đã chốt.

1. Nguồn asset đầy đủ, import/bake chọn lọc; town building/boss có art đúng, không placeholder hai kiếm; mobile safe area/drag/joystick/modal/input đúng.
2. Mở selector từ town, không tự teleport; chọn chương đã mở, chương khóa do thiếu clear, thiếu level, thiếu cả hai; hiển thị rõ lý do. Mốc level kiểm cả ngay trước/ngay đủ; không render island ngoài catalog thành nơi có thể đến.
3. Cổng trái/phải áp cùng rule, chương1/chương cuối, spam/double click, request trực tiếp hoặc stale state; spawn/camera/return context/interest của hai người cùng và khác map.
4. Minor trước clear/thua/thắng: chỉ thắng hợp lệ mới Passed; sau đó preview vẫn mở, Challenge chặn cả client/server, không trừ thể lực/cấp loot. Key Stage đã clear vẫn farm được. Replay cũ không cấp thưởng và không mở khóa phiên mới.
5. Hai người đứng cùng một boss có progress khác nhau phải thấy trạng thái riêng. Launch mới reset Campaign đúng D11 và giữ Hero/item/GUID/level.
6. Rà tác động của minor một lần và chapter gate lên đường chơi hiện có: còn nguồn farm ở key stage, qua chương trước nhưng thiếu account level vẫn có đường tiếp tục chơi; không dùng dev cấp đồ/level để che vòng kẹt. Không nhập lại chương3–8, mởTím hoặc triển khai lại balance/progression thuộc phase trước.
7. Kiểm UX-001 đúng receipt/context; preload/PoolManager/texture cùng20vòng/20phút theo phần hiệu năng. Hồi quy các flow hiện có bị tác động, dùng client/server đồng bộ bản mới.

Lượt hiện tại chỉ đọc source/config, stat asset và xem nền gốc, ghi tài liệu. Không chạy Unity, sửa runtime, bake/import, test gameplay, restart server hoặc build.
