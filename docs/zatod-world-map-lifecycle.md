# Zatod — Lịch sử khảo sát vòng đời map

**Trạng thái21/11/2026:** D21/D25 đã triển khai và nghiệm thu các đảo cùng tồn tại + Battle scene additive. Các mục dưới giữ khảo sát implementation cũ và quá trình chốt; không dùng phần mô tả một landscape làm hành vi hiện tại. Xem [báo cáo triển khai](zatod-world-battle-implementation.md).

Kiểm tra source/runtime ngày20/11/2026. Các mục đầu mô tả implementation cũ. Người dùng đã làm rõ yêu cầu các đảo cùng tồn tại và chuyển bằng teleport; D21 đã ghi hướng này, CHƯA triển khai. Xem phần đối chiếu cuối tài liệu.

## Map1/map2 ở đâu khi đang ở Town?

Không có GameObject hình ảnh của map1/map2 trong scene client lúc đó. Client chỉ giữ một cụm ZatodMap_<MapId> của map hiện tại. Zoom out không thấy các map khác vì chúng chưa được instantiate, không phải đang nằm xa Town hoặc trên layer ẩn.

Worlds.txt đã có định nghĩa town/chapter_one/chapter_two: bounds, spawn, prop, NPC/building, portal, StageId. Prefab visual có sẵn trong Resources. Có dữ liệu/asset trên đĩa không đồng nghĩa đã tạo các cụm GameObject trong scene.

Server tải WorldCatalog khi khởi động. Prototype này giữ MapId, position/facing/walking/revision và gửi snapshot theo map; server không dựng các GameObject render địa hình/avatar như client. Không gọi ServerChangeScene cho toàn bộ người chơi.

## Qua portal

1. Client gửi world_portal với ID điểm tương tác.
2. Server tìm portal ở map hiện tại, lấy map/spawn đích từ config.
3. Server đổi player.MapId, position về spawn, Walking=false, tăng MapRevision.
4. Server gửi snapshot theo nhóm MapId; người ở map cũ/đích nhận danh sách tương ứng.
5. Client thấy MapId/revision đổi: reset joystick, Destroy cụm map/avatar cũ, tạo cụm map/nền/props/NPC/avatar mới.
6. Camera snap/clamp theo bounds map mới rồi follow avatar.

Các map dùng tọa độ riêng. Town và chương1 có thể cùng dùng (0,0), được phân biệt bằng MapId. Chuyển map hiện không phải teleport giữa hai vùng địa hình cùng tồn tại trong một scene lớn.

## Đo trực tiếp trong runtime

VerifyZatodFacing.cs ghi Artifacts/ZatodFacingChecks/live/result.json:

| Map hiện tại | Geometry duy nhất | Vị trí cụm | Scene count |
|---|---|---|---|
| town | ZatodMap_town | (0,0) | 1 |
| chapter_one | ZatodMap_chapter_one | (0,0) | 1 |
| chapter_two | ZatodMap_chapter_two | (0,0) | 1 |

Khi vào Battle riêng, world được tạm ẩn và giữ map/pose để quay lại; đây là flow khác với portal giữa các map chương.

## Mô hình được hỏi ở lượt giải thích trước

Lượt trước có nêu lựa chọn đặt sẵn các map ở những vùng tọa độ khác nhau hoặc scene riêng additive. Nay người dùng đã làm rõ yêu cầu các đảo cùng tồn tại trên server/client và chuyển bằng teleport. Đây không còn là đề xuất đang mở. Bố trí tọa độ, component server và tối ưu render/network cần thiết kế khi triển khai; có catalog không đồng nghĩa đã tạo các đảo GameObject thực.

Lượt này chỉ giải thích, chưa dựng lại map/scene hoặc đổi protocol theo hai mô hình đó. Tiến trình/sao riêng và cùng MapId thấy nhau vẫn theo D21.

## Fix đi kèm

- BUG-041: Unit gốc nhìn trái ở scaleX dương nhưng mapping cũ giả định nhìn phải. Đảo mapping wrapper, giữ Facing=+1 phải/-1 trái; lật cả offset căn giữa để tránh nhảy điểm chân. Áp ngay lần đầu và hàm dùng cho remote, không sửa art/clip.
- Bỏ chữ WASD / Arrow keys or joystick cả Editor; vẫn giữ WASD Editor theo D24. Hint trống phục vụ thông báo feature chưa làm, không còn gán dòng hướng dẫn lúc khởi tạo.
-18 checks Editor PASS: di chuyển thật + mắt render, idle, network facing, shared facing/offset và geometry ba map. Đã xem ảnh01-right/02-left. Remote path thử bằng visual clone gọi chung Animate, chưa phải hai client mới trong lượt này.
- Console không error mới sau cursor110. Restore: Unity/Temp/restore/avatar-facing-20261120/before.zip. Windows build Succeeded26.111s,0 lỗi/1 warning ArenaView cũ; báo cáo build.json trong Artifacts/ZatodFacingChecks. Editor stopped/auto-tick=false, server local PID49832/TCP7788 đã chạy lại với dữ liệu cũ;8 file Owned giữ SHA256. Console cuối không error mới sau cursor113.

Nguồn: Presentation/ZatodWorldView.cs (Snapshot/LoadMap/Animate), ArenaNetwork/ZatodWorldNetwork.cs (RegisterWorldServer/UseWorldPortal/UpdateWorldServer), Heroes/WorldDefinitions.cs và Resources/Data/Worlds.txt. Lifecycle map không đổi trong lượt này.

## Đối chiếu Treasure Hunter — 20/11/2026

Chỉ đọc chat/source/serialized config, không chạy Editor hoặc đổi trạng thái server. Nguồn là checkout Dev hiện có, không khẳng định cấu hình đang chạy trên production.

### Chat đã đọc

- [Kiểm tra lưu ý khi export package](codex://threads/01a1f739-f65e-7e80-8480-872aba5f5de4): đọc cả5 lượt. Phạm vi export đã chốt là art/Unit/building/NPC, không lấy code gen map. Gói đã import không tự mang kiến trúc world TH sang Zatod.
- [Kiểm tra lỗi AutomationTile âm](codex://threads/01a1d51b-e688-79a2-9df3-601035d0effe): đọc lượt duy nhất; chủ đề đường auto về làng, không phải quyết định preload đảo. Kết luận topology/teleport bên dưới lấy từ code thực, không suy từ tiêu đề chat.

### Khởi tạo TH

Gốc server: `E:/viec/Treasure Hunter/Project/mmo_nft_server_dev/Code/`.
Gốc client: `E:/viec/Treasure Hunter/Project/mmo_nft_client_dev/Code/`.

- Server `Assets/MMOCore/Manager/GameLogicBehavior.cs` gọi InitializeMapData(false) lúc khởi tạo. Client `Assets/MMOCore/Manager/ClientManager.LoginInit.cs` yêu cầu world config rồi InitializeMapData(true) trong bước create_world.
- `Assets/MMOCore/World/Runtime/WorldManager.cs:InitializeMapData/GeneratePresetLands` lặp toàn bộ CurrentWorldConfig.landConfigs, tạo RuntimeLandData theo LandCenter. RuntimeLandData.GenerateTiles dùng worldPos=LandCenter+localPos. Các đảo cùng hệ tọa độ, không chồng lên một gốc rồi thay lần lượt.
- Prefab mặc định server `Assets/Content/Scenes/Prefabs/BattleManager.prefab`: CenterLand=(0,0), BeginnerLand=(700,0), UndeadLand=(900,0), WarLand=(-700,0), MazeLand=(0,700), SurvivalLand=(-700,-110), ShipLand=(-700,100). Runtime có thể dùng config khác theo scene/server; không lấy các tọa độ này làm quy tắc Zatod.
- Server RuntimeLandData.GenerateMapBehavior tạo container `[RuntimeLand]: <landName>` và Instantiate + NetworkServer.Spawn các chunk MapBehavior ở tọa độ world. Server có GameObject runtime vùng, không chỉ catalog; không đồng nghĩa phải render mọi sprite cây/cỏ. WorldManager.GenerateNetworkObjects hiện chỉ chứa code comment, không dùng hàm đó làm bằng chứng spawn.
- Client WorldManager.InitializeMapData lặp mọi land gọi MapManager.GenerateMapBackground. MapBackground.Generate giữ dictionary nền theo landId, Instantiate tại LandCenter; nền nhiều đảo cùng tồn tại.
- Chi tiết tile được tối ưu: MapManager.GenerateMapTile/UpdateMapTile/ForceUpdateAllMapObject dùng pool ô quanh camera, đổi vị trí và LoadData từ world. Đồ trang trí có visibility zones và SetActive(false) khi xa. Không phải mọi ô toàn thế giới đều có GameObject riêng luôn active.

### Teleport TH

Server `Assets/MMOCore/Characters/PlayerBehavior/PlayerBehaviorMovement.cs`:

1. TeleportToLand tìm land/area, đổi tọa độ cục bộ sang world bằng cộng LandCenter hoặc area.Position; cập nhật landId/lockAreaId.
2. TeleportToPosition_Internal clamp vị trí, khóa movement, gọi authoritative movement SetPosition, UpdateLandData và TargetSetPosition_Internal.
3. Client RPC gọi SnapClientState(worldPos), cập nhật landId/areaId, MapManager.ResetMap ở normal teleport rồi acknowledge. ResetMap gọi ForceUpdateAllMapObject để cập nhật pool hiển thị; không gọi lại InitializeMapData hoặc hủy toàn bộ đảo để dựng đảo đích.
4. Dynamic network object còn chịu interest management; client Dev có MMOSpatialInterestManagement kế thừa SpatialHashingInterestManagement. Không suy mọi player ở mọi đảo đều luôn instantiate trên mỗi client. World server, nền client, tile pool và network observers là các phạm vi khác nhau.

### Đối chiếu và hướng Zatod theo người dùng

| Phần | Zatod hiện tại | Hướng vừa làm rõ, chưa triển khai |
|---|---|---|
| Tọa độ | MapId phân biệt tọa độ riêng | Các đảo ở vị trí world khác nhau |
| Server | Catalog và state player | Các cụm map runtime thực khởi tạo sẵn |
| Client | Một landscape, Destroy/tạo lại khi qua portal | Các cụm đảo cùng tồn tại từ lúc khởi tạo world |
| Portal | Đổi MapId/revision rồi LoadMap | Teleport player/camera tới đảo đã tồn tại |
| Tiến trình | Riêng từng player | Giữ riêng từng player |
| Combat | Trận riêng, return context | Giữ phạm vi đã duyệt |

Khi triển khai cần xử lý offset/bounds/spawn/interactions, clamp/collision tọa độ world, map root hai phía, pose/revision qua teleport, camera snap và visibility player. Chưa chốt vị trí cụ thể hoặc sao chép hệ tile/chunk TH. Không cần gắn NetworkIdentity/NetworkServer.Spawn cho từng sprite trang trí chỉ để đạt concept các đảo cùng tồn tại.

Đã ghi D21 và BUG-042. Chưa sửa code/config runtime/scene/prefab/package; chưa có kiểm thử runtime cho kiến trúc mới.

## Lưu ý trước khi triển khai — 21/11/2026

Người dùng xác nhận hướng các đảo cùng tồn tại và hỏi lưu ý. Không yêu cầu triển khai trong lượt này. D21 là quyết định chung; các lựa chọn dưới đây là đề xuất kỹ thuật, chưa ghi thành luật gameplay mới.

1. **Tọa độ:** đề xuất mỗi map có world origin/offset, props/NPC/spawn tiếp tục author theo tọa độ cục bộ; chuyển đổi qua một nơi dùng chung. Cần đưa bounds/collision, radius tương tác, camera, portal và return context vào cùng quy ước. Giữ MapId/StageId ổn định; offset không trở thành ID. Không đặt các đảo chồng bounds.
2. **Server/client:** dựng map root/runtime logic trên server, visual trên client; không cần render cây/cỏ trên dedicated server hoặc NetworkServer.Spawn từng sprite tĩnh. Phạm vi collider/runtime interaction cần thiết sẽ xác định khi triển khai; chuyển topology không tự mở rộng sang server-authoritative navigation toàn bộ.
3. **Teleport:** server quyết định map/spawn và vị trí world, giữ revision để pose cũ không ghi đè vị trí mới. Reset input/đích nội suy cũ và snap camera/player lúc teleport, sau đó tiếp tục chuyển động mượt bình thường. Không nội suy avatar xuyên khoảng trống giữa đảo.
4. **Đồng bộ:** các đảo cùng tồn tại không buộc gửi mọi player trên mọi đảo tới mỗi client. Giai đoạn đầu có thể giữ lọc theo MapId đã có, tính interest theo khoảng cách cân nhắc sau. Client vào muộn cần nhận trạng thái hiện tại; không chỉ trông vào sự kiện spawn từng xảy ra.
5. **Mobile và authoring:** đề xuất dựng đủ ba cụm map trước, tối ưu render/update ngoài camera khi cần; chưa bê nguyên tile pool/chunk TH. Map sinh runtime chỉ xuất hiện trong Hierarchy sau khi Play/start world; muốn xem và bố trí trong Edit Mode cần thêm preview/layout tool hoặc authoring prefab. Đây là lựa chọn authoring cần người dùng biết, không hứa runtime spawn làm map hiện sẵn trong scene lúc chưa Play.
6. **Phạm vi gameplay:** tiến trình riêng theo người chơi, modal khóa input người mở, trận Phó bản riêng và return context giữ nguyên D21/D03. Một người vào trận không được ẩn/tạm dừng các đảo trên server hay trên máy người khác. Camera bám bounds đảo hiện tại và responsive D22. Chuyển đảo tự do prototype vẫn giữ; không thêm khóa chương hoặc tính năng save/channel chưa duyệt.

Nguồn rà: WorldDefinitions.cs (bounds/spawn/MapRevision), ZatodWorldNetwork.cs (membership/pose/revision/snapshot), ZatodWorldView.cs (LoadMap/CameraTarget/battle visibility) và đối chiếu TH ở trên. Không có sửa runtime hoặc nghiệm thu kiến trúc mới trong lượt này.

## Làm rõ config, authoring và vào trận — 21/11/2026

- Người dùng duyệt mỗi đảo có config riêng để setup trước; world tổng tham chiếu config đảo. Đã ghi D21. File/asset cụ thể chưa chốt; hiện Worlds.txt vẫn là một WorldDefinition chứa Maps, chưa tách config runtime trong lượt này. Các phần server logic/client visual, teleport reset và chỉ đồng bộ vùng liên quan được duyệt; thuật toán/bán kính interest management chưa chốt.
- Setup/Edit Mode là nơi chỉnh dữ liệu đảo (theme, world origin, bounds, NPC/building, spawn/portal). Runtime đọc dữ liệu để dựng các cụm đảo trên server/client một lần khi khởi tạo world. Preview Editor nếu làm sẽ chỉ dùng xem/bố trí trước khi Play; không phải chạy server hoặc load/unload đảo khi đi qua portal. Chưa yêu cầu implement tool preview.
- TH Dev hiện có MMOSpatialInterestManagement kế thừa SpatialHashingInterestManagement; đây là lọc network observers. MapManager visibility zones/tile pool là tối ưu hiển thị riêng. Zatod hiện gửi snapshot theo GroupBy(MapId), chưa gắn class TH hoặc spatial hash đó vào world.
- Combat hiện KHÔNG mở Unity scene riêng: ZatodPrototypeView.Build tạo HUD/actors dưới Canvas; OnMatch bật stage, ClearBattle rồi DrawBattle; Arena replay đi qua LoadReplay và bật cùng stage. Phó bản/Arena/PvP dùng presentation này trong scene đang chạy. Tìm SceneManager/LoadScene/ServerChangeScene trong Assets/Zatod chỉ thấy authoring/editor code, không có runtime battle scene transition.
- ZatodWorldIntegration gán BattleVisible theo stage.activeSelf. ZatodWorldView.Update SetActive(false) landscape và avatar trên máy đang xem trận, ẩn HUD, ngừng xử lý input world; camera trở về cấu hình battle. Khi đóng battle, bật world và camera trở lại map/pose được giữ. Không destroy map vì vào battle, khác LoadMap khi qua portal của implementation cũ.
- Server vẫn giữ WorldPlayerState và gửi UpdateWorldServer theo MapId trong khi session battle chạy; không remove world player khi vào trận (remove khi disconnect). Vì vậy avatar không tự bị rút khỏi world của người khác. Chưa có quyết định người dùng về biến mất/huy hiệu đang chiến đấu; không suy tách combat session thành Unity scene riêng hoặc tự implement presence mới.

Lượt này chỉ cập nhật tài liệu; không sửa code/config runtime/scene/prefab hoặc chạy test/build.

## Rà render combat và rủi ro vòng đời — 21/11/2026

Theo câu hỏi người dùng, đây là khảo sát tĩnh, chưa đo Profiler hoặc thay architecture. Không coi UI Image hoặc SetActive tự nó là lỗi.

- ZatodPrototypeView.Build tạo Canvas ScreenSpaceOverlay. ZatodBattleHudLayout.Background là RawImage; Actors/Floating là RectTransform. DrawBattle tạo Actor/Effect dưới Actors bằng GameObject/RectTransform thật, nhưng hình ảnh được vẽ bằng UI Image. BattlePoint đổi tọa độ mô phỏng sang anchoredPosition, không dùng transform world làm nguồn logic.
- ReplaySprite.Initialize tạo UI Image và một ReplaySpriteSampler con có Animator/SpriteRenderer. rendererSource.enabled=false; PlayableGraph manual lấy sprite/frame rồi Sample gán image.sprite, sizeDelta/pivot/scale. SpriteRenderer sampler không phải renderer đang vẽ Hero trên world. Projectile/buff/chain visuals dùng cùng ReplaySprite. Visual tạo cục bộ, không phải mỗi Hero/effect được NetworkServer.Spawn. Simulation/input/replay mới quyết định gameplay theo D02/D03.
- Code hiện dùng stage.activeSelf làm BattleVisible và ảnh hưởng InputLocked; ZatodWorldView.Update từ đó SetActive landscape/avatar, đổi camera và return trước xử lý world. Xác nhận có liên kết trực tiếp giữa trạng thái UI và vòng đời/presentation world. Thêm background/camera/world scripts trong tương lai có thể làm luồng này khó quản lý; chưa tái hiện lỗi cụ thể do liên kết này.
- Rủi ro cần đo: sprite/RectTransform đổi liên tục có thể tăng chi phí cập nhật geometry/Canvas; Image.cs của uGUI installed gọi SetAllDirty khi sprite thay. Không kết luận Canvas là nguyên nhân lag trước đây hoặc luôn chậm hơn SpriteRenderer. SpriteRenderer/particle/material/sorting/camera world khi dùng lại cùng UI overlay cần tích hợp riêng. SetActive toàn root cũng tác động component/collider/coroutine nếu về sau gắn chúng vào đó; ẩn không đồng nghĩa giải phóng asset/bộ nhớ hoặc rút player khỏi server.
- Đề xuất để brainstorm: tách World lifecycle, BattleSession và BattlePresentation rõ ràng; transition có trạng thái vào/đang/thoát battle thay vì suy từ UI active. World giữ được khởi tạo; camera/input/render chuyển có kiểm soát, tránh tắt toàn bộ root có gameplay. Nếu muốn chiến trường là object world, chuyển Hero/projectile/effect sang SpriteRenderer dưới BattleRoot hoặc một scene battle client load additive, HUD vẫn Canvas; giữ nguyên simulation/timing. Chưa chốt lựa chọn root/scene, chưa được phép triển khai trong lượt này. Scene client riêng không đồng nghĩa phải tạo Unity server scene cho mỗi trận hoặc ServerChangeScene toàn server.

Bằng chứng: ZatodPrototypeView.cs:Build/DrawBattle/ClearBattle, ReplaySprite.cs:Initialize/Sample/OnDestroy, ZatodBattleHudLayout.cs, ZatodBattleHud.cs:BattlePoint, ZatodWorldIntegration.cs:BuildWorld, ZatodWorldView.cs:Update. Đã đọc package uGUI UICanvas.md và Image.cs; ghi nhận REVIEW-001 trong ChangeLog.md.
