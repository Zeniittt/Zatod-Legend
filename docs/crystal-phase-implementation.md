# Crystal prototype — trạng thái triển khai

Cập nhật 19/11/2026. Phạm vi đã được duyệt trong `phase-crystal-prototype-scope.md`; quyết định chung ở `Design.md`.

**Trạng thái: hoàn thành triển khai và kiểm tra phase prototype trong phạm vi đã được duyệt, ngày 19/11/2026.** Build Windows và kiểm tra mạng trên executable cuối đều PASS. Đây là kết quả kỹ thuật của prototype; các giới hạn nguồn và phần ngoài phase được giữ rõ bên dưới.

## Nội dung đã triển khai và kiểm tra

- [x] Shared `CombatantDefinition`, `HeroDefinition/HeroData/HeroBattleData`, dữ liệu trận tách khỏi config/sở hữu; quái không có tiến trình sở hữu riêng.
- [x] 16 Hero, 10 quái, 67 loại trang bị; 18 ải/54 wave của chương 1 Thường, đội địch/hook/background/modifier tham chiếu source.
- [x] Stats trực tiếp sau chuyển STR/AGI/INT; 384 trường hợp oracle ở level 40, nhiều sao/bậc/trang bị. Rank residual không cộng lại đóng góp trang bị đã hấp thụ.
- [x] Core 8 Hz dùng chung client/server/replay; action theo MSPD, cooldown theo HAST, marker/phase, projectile/chain/AoE, buff và các hook đang dùng. Đây là bản port prototype, không chứng nhận tương đương từng bit với native Crystal/RNG.
- [x] Phó bản client sim/input log, server giữ đầu vào tin cậy và resimulate cuối trận; claim sai/incomplete/đã dùng bị từ chối. Tiến trình ải chỉ trong launch hiện tại.
- [x] Arena auto và input replay; PvP hai client nhận cùng batch input, có thao tác cả hai đội và cùng kết quả/digest.
- [x] GUID từng món, không stack; cấp theo ItemId, mặc giữ GUID, hấp thụ giữ nguồn. Lina đi Trắng → Xanh Dương và mặc đủ bộ Blue qua Mirror; 24 cặp GUID/ItemId giữ nguyên khi mở lại, trong khi ải reset.
- [x] 102 tài nguyên animation (26 nhân vật + 76 effect): 8.867 sprite / 358 clip. Kiểm tra rect, pivot, thứ tự/thời gian frame, FPS/loop, prefab và action skill.
- [x] 543 atlas dùng BC7 cho Windows, giữ PNG và độ phân giải/pivot/timeline nguồn. 13 background, 92 sound timeline gốc và voice tham chiếu. Hai sound reference không có trong nguồn được báo rõ bên dưới.
- [x] UI chọn đội/ải, kho/mặc/tiến bậc, replay pause/seek/x4, pointer raycast; Editor balance Hero/stats/item/skill/buff và chapter/wave/hook mở được. Scene có AudioListener.
- [x] Lượt build + network smoke cuối sau sửa transport envelope rỗng (không thay input gameplay): Phó bản, Arena, PvP hai client, reset ải và giữ nguyên 24 cặp GUID/ItemId.

## Bằng chứng

| Kiểm tra | Kết quả / báo cáo |
|---|---|
| CrystalChecks | PASS 4.009 assertion sau sửa chuyển động; stats, ownership, toàn bộ 54 wave, các Hero ở Blue, source timing/damage/heal/energy/DPS/ground/contact, replay/checker, presentation và archive trước sửa |
| HeroChecks | PASS 112 assertion |
| CombatChecks cũ | PASS 347.507 assertion / 36 trận và movement/snapshot/persistence |
| MonsterChecks cũ | PASS 48.197 assertion / 18 trận; loader đã đọc thêm Buffs |
| Unity asset verifier | `Artifacts/CrystalPhaseChecks/unity-assets.json`: 102 / 8.867 / 358, PASS |
| Build Windows cuối | `Artifacts/CrystalPhaseChecks/final-build.json`: Succeeded, 0 lỗi, 2 cảnh báo; rules `crystal-prototype-3` |
| Network executable cuối | `Artifacts/CrystalPhaseChecks/network-20261119-185731/results.txt`: hai client digest 13622350145935873978, 8 input; campaign/Arena/PvP và 24 GUID/type pairs qua relaunch đều PASS |
| PvP có hiển thị | `Artifacts/CrystalPhaseChecks/ui-pvp-final/`: Editor UI + client riêng cùng digest 1143131409373739758, 16 input, tối đa 26 sprite/effect; input từ cả hai đội, replay khớp |
| UI | `Artifacts/CrystalPhaseChecks/ui-final/`: runtime interpolation, item grant/equip GUID, 18 ải/1 mở, hidden battle, history replay, seek tick 54, x4, raycast, 1 AudioListener |
| Transport khởi động | `warmup-gate.json`: 5 kiểm tra PASS; rỗng muộn trong 5 tick implicit được bỏ qua, input thật muộn/tick sai/gói trùng vẫn bị từ chối |

Lỗi UI đã tìm và sửa: thiếu AudioListener; bản ghi Phó bản không mở từ history khi còn battle cũ; lookup Button qua parent inactive. Capture console cũ giữ bằng chứng lỗi đã sửa. Các lượt kiểm tra sau sửa không có lỗi runtime mới. Lượt PvP render tìm được envelope rỗng muộn khi tải sprite; guard transport đã sửa, qua 5 kiểm tra riêng và lượt network executable cuối.

Hai cảnh báo build còn lại: API tìm object đã obsolete trong Arena pixel cũ và pragma debug đã deprecated của shader TMP đi kèm. Build chứa cả tài nguyên cũ được giữ lại, tổng kích thước báo cáo khoảng 6,60 GB; chưa thực hiện tối ưu dung lượng phân phối.

## Điểm vào và sử dụng

- Scene: `Unity/Assets/Zatod/Scenes/CrystalPrototype.unity`.
- Build: `Builds/CrystalPrototype/ZatodCrystal.exe`; menu **Zatod > Crystal > Build Windows Prototype**.
- Hướng dẫn chạy server, hai development profile, thao tác và balance: [crystal-prototype-play.md](crystal-prototype-play.md).
- Core hiện tại: `crystal-prototype-3`. Archive input đóng băng đội/seed/stats/skill/buff/wave/hook; file `*.crystal.gz`.
- CampaignRun không lưu; Hero/item lưu riêng theo development account GUID tại `<data-dir>/Owned`. Chưa có authentication/Market.
- Config balance mới cần nạp lại/rebuild cả client và server; không có hot reload server trong phase này.

## Giới hạn và ngoài phạm vi

### Phát hiện sau chơi thử: chuyển động projectile bị khựng (19/11/2026)

- Người dùng báo projectile tạo cảm giác chậm/lag. Đọc code xác nhận `CrystalPrototypeView.DrawBattle` lấy tọa độ projectile trực tiếp từ snapshot 8 Hz (125 ms/lần); biến interpolation hiện chỉ cộng vào thời gian sample animation, chưa áp dụng cho vị trí. Vị trí Hero cũng đang lấy trực tiếp từ snapshot.
- Đối chiếu 33 skill projectile đã nhập: ProjectileSpeed khớp Tile XY Speed của source Skill. Ví dụ speed 300 đi 37,5 đơn vị/tick, tương đương 61,875 pixel thiết kế ở scale X hiện tại; giữ nguyên vị trí giữa các tick gây bước nhảy nhìn thấy rõ.
- Source `battle/projectile.lua`, actor `update` (khoảng dòng 305), có cập nhật vị trí/độ cao hiển thị bằng velocity/zSpeed/gravity giữa các tick model. Phần này chưa được port đầy đủ sang view mới. Kiểm tra interpolation trước đó mới xác nhận animation time, chưa xác nhận tọa độ bay mượt.
- Replay đang chơi còn return sớm khi chưa đủ một tick, nên không vẽ lại mỗi render frame. Đây là một thiếu sót presentation bổ sung.
- Editor đang dừng Play tại thời điểm kiểm tra; console không có error. Chưa đo FPS/frame-time của trận người dùng vừa chơi, nên chưa loại trừ hitch khi nạp effect hoặc nguyên nhân hiệu năng khác. Không suy kết quả này thành lag mạng.
- Lượt chẩn đoán ban đầu chỉ đọc code/config. Hướng xử lý phù hợp D02/D06/D10: cập nhật presentation giữa các tick, giữ tick core, tốc độ nguồn và lịch va chạm/damage; không tăng ProjectileSpeed để che giật.

Kiểm tra trực tiếp tiếp theo trong trận Phó bản do người dùng chơi (19/11/2026):

- Ghi được 5.962 frame trong 27,90 giây, tick 121–344; FPS trung bình 212,6, frame median 4,47 ms, p95 5,75 ms, p99 7,69 ms. Có 3 frame >50 ms, trong đó 1 frame >100 ms (max 149,45 ms); chưa profile để quy nguyên nhân các hitch riêng lẻ.
- Hero: 52.198 mẫu, 50.239 cặp frame cùng tick và **0 lần đổi vị trí trong cùng tick**. Bước nhảy median khi có di chuyển là 24,75 pixel thiết kế. Không dùng jump lớn ở chuyển wave để kết luận tốc độ đi bộ.
- Projectile: 3.878 mẫu, 3.729 cặp frame cùng tick và **0 lần đổi vị trí trong cùng tick**. Bước nhảy median 103,12 pixel thiết kế; đạn Lina/Zeus khoảng 103,125 pixel/tick. Nhịp logic vẫn tương ứng thời gian thực; không có bằng chứng tụt FPS kéo dài trong đoạn quan sát.
- Kết luận trong đoạn đã đo: thiếu chuyển động presentation giữa tick ảnh hưởng cả Hero lẫn projectile, là nguyên nhân chính của cảm giác giật liên tục. FPS cao không làm mượt được tọa độ chỉ đổi ở 8 Hz. Không suy thành lag mạng hay tự tăng tốc config.
- Raw/summary: `Artifacts/CrystalPhaseChecks/movement-observation-20261119.json`, `movement-observation-summary-20261119.json`. Bộ quan sát chỉ đọc, tự gỡ cuối trận; source đo chuyển vào thư mục artifact, không nằm trong Assets hay thay gameplay/scene. Lượt đầu chỉ bắt được cuối trận nên không dùng làm bằng chứng chuyển động. Console cuối lượt không có error.

Sửa theo yêu cầu người dùng ngay sau chẩn đoán (19/11/2026), theo dõi BUG-001 ở `ChangeLog.md`:

- Frame cung cấp velocity/height/gravity chỉ cho render, không ghi ngược vào model. Hero di chuyển dùng cùng hướng/tốc độ/MSPD đang áp dụng, gồm knockback/knockup; projectile dùng vận tốc đang có. Projection bị giới hạn một tick, freeze/pause/seek không chạy tiếp. Wave/blink khớp vị trí tick mới, không suy velocity từ chênh lệch vị trí lớn.
- View cache snapshot theo simulation/tick, vẽ cả live và replay mỗi render frame, dùng residual time của replay ở x1/x4. Không thay core tick, config speed, input/va chạm/damage/RNG hay rules version.
- CrystalChecks: **4.009 assertion PASS**, gồm 3 archive rules v3 trước sửa cho cùng digest/winner/endTick.
- `Artifacts/CrystalPhaseChecks/motion-fix-editor.json`: **PASS**. Live: 13.916/13.916 cặp Hero có motion và 3.415/3.415 cặp projectile đổi vị trí giữa tick, không còn cặp đứng nguyên khi phải di chuyển. Replay x1: 3.718 Hero/513 projectile; x4: 1.697 Hero/296 projectile đều đổi vị trí. Pause đứng yên, seek khớp tọa độ, trận được server executable trước sửa validate.
- `Artifacts/CrystalPhaseChecks/motion-fix-build.json`: build Windows cập nhật **Succeeded, 0 lỗi, 2 cảnh báo cũ**. `network-20261119-194824/results.txt`: executable mới chạy Phó bản/Arena/PvP PASS; hai client digest 7727497618463703090, 8 input; relaunch reset ải và giữ đúng 24 GUID/type pairs. Server chơi thử đã được khởi động lại tại 7788; Editor để stopped, không để test tiếp tục điều khiển phiên của người dùng.
- Console sau build có một exception riêng của `UnityEditor.Connect.TokenExchange` khi đổi token dịch vụ Unity; không có compile/gameplay exception từ bản sửa trong lượt kiểm tra. Không xóa console; ghi BUG-009 trong ChangeLog.md để điều tra dịch vụ Editor riêng nếu cần.

- Không có đầy đủ backend Crystal. Mirror TCP và server prototype không được gắn nhãn là backend gốc; chưa chứng minh native RNG/numerics giống từng bit. Kiểm chứng thực tế ở Windows và Unity Editor.
- Thiếu ngay trong bộ nguồn hai sound `Civ_Human_Wizard_BigAttack.mp3`, `Civ_Wizard_Attack.mp3`. Báo cáo `static-art-audio.json`; không tự thay sound khác.
- Sniper skill 103 dùng tỷ lệ AD thay AGI theo chốt của người dùng, giữ cap 2,5 và decay. Item có direct bonus theo Hero để giữ đóng góp Main Attrib, không có runtime STR/AGI/INT.
- Chỉ Trắng tới Xanh Dương thường; Tinh Anh, Tím/Cam, awakening/shard, craft/enchant, Market, kinh tế/quest/farm và lưu tiến trình ải dài hạn để sau.
- Nhánh pixel và archive outcome cũ giữ nguyên; scene/runtime cũ có hướng dẫn lịch sử riêng. Input archive v1/v2 trong các thư mục test là artifact nội bộ trước nghiệm thu, không tự đổi rules để phát bằng v3.
- Inventory mới dùng development profile mới; chưa có migration tự động cho kho stack cũ có dữ liệu thật. Không dùng thay schema để viết lại lịch sử sở hữu.

## Điểm khôi phục và bàn giao

- Trước phase: `Artifacts/CrystalPhaseBefore/20261119-151857/source-config.zip`.
- Lúc người dùng tạm dừng: `Artifacts/CrystalPhaseCheckpoints/20261119-pause/` (241 file source/config + SHA-256 manifest).
- Bàn giao phase: `Artifacts/CrystalPhaseCheckpoints/20261119-final/` (source/config/docs và SHA-256 manifest; không sao chép lại PNG/build dung lượng lớn). Tổng hợp kiểm tra cuối: `Artifacts/CrystalPhaseChecks/final-verification.json`.
- Lịch sử các checkpoint kỹ thuật đã chuyển sang `Artifacts/CrystalPhaseChecks/implementation-history.md`.
- `Unity/Assets` hiện tại là source chuẩn. `Artifacts/CrystalRuntimeDraft` chứa bản staging có thể cũ; không chép đè chúng lên code hiện tại.
- Không có git commit được tạo; code, asset và báo cáo nằm trong workspace.
