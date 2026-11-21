# Zatod — Tiến trình world đảo và battle scene

Bắt đầu và hoàn thành21/11/2026 theo yêu cầu thực thi của người dùng. PHẠM VI PHASE ĐÃ NGHIỆM THU; các mục tiến trình bên dưới giữ lịch sử, trạng thái bàn giao hiện tại ở cuối.

- Restore: Unity/Temp/restore/world-battle-20261121/before.zip (63 file). Owned baseline8 file ở Artifacts/ZatodWorldBattleChecks/owned-before.json.
- Đã thêm schema config đảo riêng/world offsets, loader, server map roots và lọc snapshot theo bán kính48 world units (config được). Đang chuyển WorldView và Battle scene/presentation; chưa compile/test.
- World origin mặc định Town=(0,0), chương1=(110,0), chương2=(220,0); layout nội bộ giữ nguyên.
- Unity được mở đúng project; CLI hiện chưa phát hiện Pipeline. Đang kiểm tra metadata/khởi tạo; chưa chỉnh scene bằng tay hoặc đóng Editor.

## Tiến trình source/compile

- Đã chuyển WorldView sang giữ ba landscape, chọn map bằng reference/camera; không Destroy map khi portal hoặc SetActive toàn world khi battle. SceneController có World/LoadingBattle/InBattle/ReturningWorld.
- Đã tạo ZatodBattle.unity bằng Pipeline, thêm build settings và build entry. BattleStage render Hero/projectile/effect bằng SpriteRenderer, HUD Canvas. GameObject/camera battle layer9, world layer8; giữ motion projection/animation sampling.
- Core test PASS4.748 assertions. Unity compile chưa lỗi; authoring helper lần đầu sai namespace CampaignDataJson, đã sửa về Zatod.Heroes rồi tạo scene thành công.
- Lượt build đầu vào Artifacts/ZatodWorldBattleChecks/Player vượt180s CLI timeout; Editor vẫn xử lý resource/asset, chưa có summary build. KHÔNG chạy build chồng. Chưa bàn giao hoặc nghiệm thu renderer.
- Chuẩn bị VerifyZatodWorldBattleLive.cs và VerifyZatodBattleSpriteParity.cs (chưa chạy). Khi build kết thúc, cần sửa chrome Arena/PvP: root/backdrop Canvas phải clear khi battle hoạt động, không chỉ screen=campaign; đang ghi nhận trước nghiệm thu, chưa gán là lỗi cũ.
- Pipeline target phải đặt trước tên command trong CLI hiện có; dùng tên đầy đủ được quote ("script eval", "console status"). Port metadata đọc được qua quyền local ngoài sandbox; không in token. Console baseline sau compile cursor4, compilationFailed=false.

## Nghiệm thu đã có

- Build test đầu Succeeded412.789s,0 lỗi/2 warnings; CLI timeout180s nhưng file report xuất hiện sau khi Unity hoàn tất. Không build chồng. Đã phát hiện/sửa BUG-043 (Canvas opaque che camera Arena/PvP); ảnh Arena/PvP mới đã xem.
- Live integration PASS48 checks/20.15s: 3 island root IDs không đổi qua portal, global spawn đúng, scene count1->2->1, campaign checker3 sao; peer di chuyển128 mẫu trong lúc battle; 3 replay cycles dọn graph; cancel giữa load trả world.
- PvP Editor+player PASS8 checks/103.27s:18 input Editor, digest3762161378630082765 khớp peer; scene renderer hiện đủ hai đội; disconnect/reconnect dọn scene và trở lại Town.
- Animation parity toàn146 sets:6252 samples/31261 checks PASS. So sprite, sample clock, facing, PPU size, projectile pivot với ReplaySprite cũ; không phải full frame-by-frame mọi clip hoặc benchmark mobile.
- Network regression build test port17997 PASS: Phó bản/Arena/PvP/replay,2 client digest16500148939458051873, reset launch giữ24 GUID/type pairs. Evidence Artifacts/ZatodPhaseChecks/network-20261121-115204.
- Responsive/failure PASS50 checks:1600x900,2436x1125,2400x1080,1600x1200; projection camera/HUD, safe-area buttons,1 scene sau lỗi nạp scene. Rect SafeArea trong report ban đầu serialize vòng normalized, helper đã chuyển sang scalar fields. MissingForLoadFailureTest là scene không tồn tại chủ ý; native Unity đã ghi error dự kiến, giữ Console không clear. Không phải scene ZatodBattle thiếu khỏi build.
- Đã giữ audio pause/seek replay theo cờ playing, không phát cue mới chỉ vì render paused frame. Build cuối đang chạy từ nguồn sau sửa này; chưa kiểm tra smoke interest trên build cuối.
- Unity6.6 loại GetInstanceID, helper live đã dùng GetEntityId. Warnings reconnect từ Mirror thay built-in handler có sẵn, không sửa vendor. Chưa thấy error runtime ngoài lỗi scene thiếu chủ ý.

## Kết quả bàn giao hiện tại

- Scene chính vẫn ZatodPrototype.unity. Scene ZatodBattle.unity nạp thêm phía client và dọn sau khi thoát; không mở Battle scene làm entry, không tạo Unity server scene cho từng trận.
- Build cuối Succeeded162.611s,0 errors/2 warnings, đường dẫn Builds/ZatodPrototype/ZatodLegend.exe. Bằng chứng build-final.json. Đã dùng chính bản cuối để chạy interest/world smoke.
- Interest smoke2 client PASS: xa bị ẩn khỏi snapshot, gần hiện lại, world offset đúng, pose cũ bị từ chối sau portal. Artifacts/ZatodWorldBattleChecks/interest-20261121-120809/results.txt.
- Final world smoke2 client PASS: movement, tách map, hai chương, tiến trình cá nhân, private battle giữ vị trí world; digest17909688523871435903. Artifacts/ZatodWorldChecks/network-20261121-121109/results.txt.
- Editor sample2s/mode: World181 FPS, BattleReplay175 FPS, ReturnedWorld185 FPS; allocated~1.50GB ->1.59GB ->1.59GB (Editor/resource cache). BattleSprite count0->7->0. Không suy đây là benchmark mobile hoặc bộ nhớ Player; đo ngắn để kiểm tra frame vẫn chạy và visual được dọn, không khẳng định cải thiện so bản cũ.
- Các test quan trọng khác: core4748 assertions; parity146 sets/6252 samples/31261 checks; live48; PvP8 (18 input, digest3762161378630082765); responsive/failure50; network mode/GUID24 pairs. Xem các JSON và ảnh trong Artifacts/ZatodWorldBattleChecks, báo cáo network mode ở Artifacts/ZatodPhaseChecks/network-20261121-115204.
- Camera/HUD đã xem ảnh Campaign, Arena, PvP và các tỷ lệ landscape.3 replay cycles dọn graph; cancel-load, intentional load failure, disconnect/reconnect đều về world. Test scene thiếu chủ ý để lại2 error trong buffer Pipeline lịch sử; Console ground truth cuối0 errors, compilationFailed=false, không gọi Console clear.
- Editor đã dừng, active scene ZatodPrototype sạch, chỉ1 scene authoring; auto-tick=false, override RunInBackground được trả lại projectValue=true. Đã dừng server test17996/17999 do agent tạo; các harness17997/17998 tự dọn process.
- Local server mới PID12320 READY TCP7788, data Artifacts/ZatodServer. owned-before.json và owned-after.json trùng chính xác cả8 file; không reset profile/hero/item để làm test đạt.

## Config và source chính

- Unity/Assets/Zatod/Resources/Data/Worlds.txt tham chiếu3 file Data/WorldMaps/*.txt. Mỗi đảo có OriginX/Y, bounds/spawn/props/interactions local và InterestRadius48 (world units). Không tự cộng offset vào từng point khi chỉnh dữ liệu; WorldCatalog compile đúng một lần ra world coordinates.
- WorldDefinitions.cs/WorldDataJson.cs: index/loader/validation/compiled copy; Prepare-ZatodWorld.py sinh cùng cấu trúc mới. ZatodWorldMapRuntime.cs ở ArenaNetwork tạo root/collider server; WorldNetwork.cs lọc custom snapshots theo cùng map/radius, self luôn nhận.
- ZatodWorldView giữ3 cụm visual và camera world layer8; chọn map chỉ đổi context/camera. Unity camera culling loại phần ngoài viewport; không deactivate toàn root chứa logic khi battle.
- ZatodBattleSceneController quản lý lifetime/states và async cancellation; ZatodBattleStage render actor/effect/background layer9, pointer hit, health, audio; ZatodBattleSprite sample imported clips theo render time. Gameplay/core không lấy damage từ Collider/Animator events.
- ZatodPrototypeView/WorldIntegration nối các mode, chrome và HUD hiện có. ReplaySprite cũ vẫn phục vụ UI preview khác; không xóa art/source cũ.

## Giới hạn đã giữ theo scope

- World movement vẫn cosmetic owner-driven; server sở hữu membership/revision/bounds, chưa chuyển thành navigation authoritative/chống speed hack đầy đủ. Không thêm channel/capacity/save world progress qua login.
- Interest hiện là lọc custom payload theo map+distance, chưa spatial hash cho quy mô đông người. Static NPC/building/terrain có sẵn từ config, không NetworkServer.Spawn từng sprite.
- Không có map editor/preview Edit Mode mới: object đảo xuất hiện khi Play/start world. Config mỗi đảo chỉnh riêng bằng text/editor ngoài; GameEditor hiện có không tự biến thành level editor.
- Render/bộ nhớ mới chưa benchmark trên thiết bị mobile thật; mẫu FPS/allocated nêu trên là Editor. Tài nguyên dùng chung/cache có thể ở lại sau unload, khác với leaked scene/graph.
