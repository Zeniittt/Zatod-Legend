# Zatod — Kế hoạch phase world đảo và scene battle

**Lưu ý bàn giao 24/11/2026:** đây là phase world/battle trước đây (D21/D25). Phase hiện tại từ sửaOK sauEquip theo [D38](zatod-world-ui-polish-phase-plan.md); không triển khai lại renderer/scene battle từ checklist lịch sử này. Quy tắc travel tự do cũ được D38 thay bằng unlock chapter, còn các map cùng tồn tại được giữ.

**Cập nhật21/11/2026:** người dùng đã yêu cầu thực thi, phạm vi bắt buộc đã nghiệm thu. Nội dung dưới là kế hoạch gốc; trạng thái thực tế và giới hạn ở [báo cáo triển khai](zatod-world-battle-implementation.md), quyết định ở Design.md D21/D25.

Ngày21/11/2026. Nguồn quyết định: Design.md D21/D25; rendering đối chiếu Crystal ở crystal-battle-presentation-review.md. User duyệt scene battle riêng và yêu cầu tổng hợp phase. Đây là kế hoạch để rà/chốt trước triển khai, không phải báo cáo đã thực hiện. Không đổi runtime trong lượt lập kế hoạch.

## 1. Config từng đảo

- Town, chapter_one, chapter_two có config độc lập, world tổng tham chiếu danh sách đảo. Chuyển dữ liệu hiện có, giữ MapId/StageId và tham chiếu tiến trình.
- Config chứa theme/art, world origin/offset, bounds, spawn, props/vật cản, NPC/building/interactions, portal và destination spawn. Layout trong đảo dùng local coordinates, chuyển sang world tại boundary chung để tránh cộng offset nhiều lần.
- Có thể setup dữ liệu trước khi chạy; validate ID/reference, spawn/bounds và các đảo không chồng nhau. File/asset cụ thể chọn trong thiết kế triển khai, không cần đổi Hero config hoặc owned data.

## 2. World cùng tồn tại

- Khởi tạo cụm Town/chương1/chương2 cùng tồn tại khi server start/client tạo world. Server giữ runtime map/interactions/phần phục vụ gameplay; client giữ visual native đã import.
- Portal không Destroy/recreate đảo. Có root đặt tên Zatod rõ ràng để kiểm tra ở runtime; không hứa Edit Mode thấy object chỉ sinh bằng runtime code.
- Giữ phạm vi prototype navigation: chưa mở rộng sang toàn bộ server-authoritative movement/chống cheat hoặc save qua login. Không coi giữ đủ map là buộc server render art.

## 3. Teleport và đồng bộ vùng

- Server chọn map/spawn, đổi membership và world position; reset chuyển động, revision và interpolation/input cũ, snap player/camera rồi tiếp tục chuyển động mượt.
- Dữ liệu gửi theo vùng liên quan và có thể giới hạn khoảng cách; thuật toán/bán kính cụ thể chưa chốt. Không gắn class Mirror interest management rồi mặc định custom snapshot messages đã được lọc; chọn recipient/entity payload tại world replication boundary hiện có hoặc thiết kế migration rõ nếu chuyển sang network identities.
- Client join muộn nhận snapshot hiện tại. Camera clamp theo bounds đảo đang đứng, input đáp ứng D24. Chỉ tối ưu visual/update xa camera, không unload các đảo khi đi qua portal.

## 4. Scene Battle phía client

- Đề xuất tạo scene ZatodBattle và load additive bất đồng bộ; giữ world scene cùng kết nối/account, không dựng NetworkManager/EventSystem trùng. Camera/layer của world và battle tách biệt.
- Trạng thái rõ: World -> LoadingBattle -> InBattle -> ReturningWorld; xử lý start/cancel/thoát/lỗi load/disconnect. Không lấy một UI panel activeSelf làm nguồn quyết định trạng thái game.
- Khi ở battle, khóa input world trên client đó, chuyển camera/render có kiểm soát; không tắt cả world root chứa logic hoặc dừng server/người chơi khác. Thoát battle khôi phục camera/input/map/pose trong phiên, unload đúng scene battle cùng visual/audio/event/animation resource do nó sở hữu.

## 5. Renderer chiến trường

- Đề xuất background, Hero, projectile, buff/effect thành object renderer 2D trong Battle scene, layer/sorting theo chiều sâu và nhóm effect; HUD/portrait/nút/thông tin/damage text có thể giữ Canvas theo chức năng.
- Chuyển sampling từ UI Image sang renderer có thể dùng cùng clip/sprite đã import, không reverse/đổi anim nguồn. Giữ scale, pivot, anchor, transform, thời gian action, mốc release/impact, motion projection và audio cues. Không biến renderer hoặc collider thành nguồn tính damage.
- Giữ asset UI Crystal và responsive/safe area màn ngang theo D17/D22. Phần layout battle camera kiểm tra theo aspect; renderer mới không tự bảo đảm timing/hiệu năng đúng trước khi kiểm tra.

## 6. Nối các mode và giữ dữ liệu

- Phó bản: các view preview/formation tiếp tục flow đã có, scene mới trình bày simulation/checker hiện hành.
- Arena tự động và replay: dùng cùng scene presentation, giữ đầu vào/seed và playback theo mô phỏng.
- PvP realtime: vẫn room/input đồng bộ đang có, renderer scene mới đọc state; không chia sẻ hero/effect trận này với trận khác vì cùng world server.
- Không tự dựng một Unity server scene cho mỗi trận hoặc gọi ServerChangeScene toàn server. Giữ session battle model/checker, config 39 ải/117 wave, roster, GUID item và owned state. Không thêm reward/craft/progression/feature mới.

## 7. Kiểm tra và bàn giao

- Ba đảo tồn tại hai phía; portal đi/về không đổi instance map root. Kiểm tra offsets/bounds/collision/spawn, joystick, facing và camera.
- Hai client cùng/khác đảo, teleport, join muộn, một người vào trận còn người kia tiếp tục world. Chốt presence trước khi đặt expected outcome avatar khi combat.
- Phó bản/Arena/PvP/replay, start/exit/cancel/load fail/disconnect, thoát và vào nhiều trận. So timing/sprite/motion/effect với dữ liệu trước chuyển; kiểm tra combat core/checker/GUID và scope owned state.
- Đo frame/render, số object, lifetime scene/event/PlayableGraph/audio và memory qua nhiều lượt; không khẳng định tăng FPS hoặc memory về 0 khi unload do asset shared/cache.
- Kiểm tra các tỷ lệ landscape/safe area, build client/server local thích hợp, cập nhật tài liệu test/play và ChangeLog; lưu bằng chứng, không báo hoàn thành khi còn hạng mục bắt buộc chưa kiểm tra.

## Hai mục chưa chốt bổ sung

- **Presence khi combat:** đề xuất giữ avatar world tại vị trí hiện tại và khóa điều khiển trên client đang combat, chưa thêm badge/ẩn khỏi người khác. Không coi đề xuất này là quyết định mới.
- **Preview/Edit Mode:** config đảo riêng đã duyệt; tool trực quan để xem/bố trí trước Play chưa được yêu cầu rõ. Đề xuất tách thành hạng mục tùy chọn, tránh biến refactor runtime thành phase xây map editor lớn.

Không thực thi code/config/scene trong lượt này. Các đề xuất additive/renderer và chi tiết phạm vi được trình người dùng trong chat; chỉ cập nhật Design.md khi được chốt tiếp.
