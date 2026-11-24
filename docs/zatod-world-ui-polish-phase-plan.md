# D38 — Phase chỉnh Equip, world/UI và PoolManager

Ngày chốt/cập nhật: **24/11/2026, Asia/Saigon**.

**Mốc bắt đầu phase: yêu cầu bỏ bước bấm OK sau khi Equip thành công.** Những việc mở Tím, nhập chương3–8, mở40HeroPvP và cải thiện feeling combat thuộc phase trước, không được gộp lại vào checklist này.

**Trạng thái:** phạm vi đã được người dùng duyệt; bản này là checklist bàn giao. Lượt hiện tại chỉ cập nhật Markdown và lưu ảnh tham chiếu, chưa code/import/bake/test gameplay/build/deploy. Khi được giao thực thi D38, làm theo phạm vi đã chốt; không xin lại các quyết định ở đây. Chỉnh tài liệu riêng không phải lệnh thực thi runtime.

## 1. Đọc trước khi tiếp quản

1. [Design.md](../Design.md): D38 là quyết định phase này; D28/UX-001 về Equip, D11 về reset Campaign, D21/D25 về world và scene, D26 về loot, D37 về bàn giao build vẫn áp dụng ngoài phần được D38 thay thế.
2. [ChangeLog.md](../ChangeLog.md): UX-001, BUG-067, REVIEW-017; BUG-056 khi kiểm texture. Phân biệt source mới với binary server cũ.
3. [Khảo sát source/asset D38](zatod-world-chapter-selector-review.md) và [chỉ dẫn nguồn Crystal](crystal-legends-reference.txt).
4. Report implementation liên quan để xác nhận baseline thực tế của clone. D34/D35 là phần nền/phase trước, không là danh sách tính năng phải làm lại.

Nếu clone chưa có phần nền đã bàn giao, ghi rõ baseline nào đang thiếu và xử lý việc lấy đúng baseline trước khi kết luận nghiệm thu; không âm thầm biến thiếu code cũ thành yêu cầu nhập lại toàn bộ D34. Vẫn tiếp tục các việc độc lập trong D38. Việc phân định phase không tự chứng minh mọi tính năng phase trước đã được kiểm trên thiết bị.

## 2. Phạm vi và ngoài phạm vi

| Trong D38 | Ngoài D38 |
|---|---|
| Equip thành công tự đóng panel | Làm lại hệ thống Skill/Promote/QuickEquip đã có |
| Object tính năng làng dùng asset Crystal | Mở Tím, nhập chương3–8/115ải/345wave, mở pool40HeroPvP |
| Selector chương, unlock và portal trước/sau | Làm lại tối nền/ultimateHUD/HPbar/Damaged/audio/fade/chuyểnwave của phase trước |
| Boss đại diện điểm ải; minor Passed/key đánh lại | Xây combat/AI cho boss ngoài world, Guild/Tower mới |
| Preload trước trận; PoolManager; kiểm texture | Baseline profiling riêng trước sửa; đổi cơ chế tải/cache/unload map |
| Kiểm chức năng bị tác động và20vòng/20phút | Save Campaign progress, Elite/Raid, đổi balance/loot ngoài tác động D38 |

Phạm vi áp dụng trên **catalog và runtime đang có từ phase trước**, không giới hạn cứng hai chương theo số liệu khảo sát cũ và cũng không tự nhập thêm chương nếu thấy thiếu. Giữ hình ảnh/feeling Crystal, avatar SPUM hiện hành và các quyết định gameplay khác.

## 3. Đầu vào và ảnh tham chiếu đi cùng repository

- Source/config/art Crystal: `Unity/Assets/Crystal Legend/` từ repository root; từ projectUnity là `Assets/Crystal Legend/`. Không mặc định dùng root cũ hoặc bản sao ổC.
- Lua: `recovered/scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data/`; asset: `recovered/assets/install_time_pack/remake/` dưới reference trên.
- Nguồn cụ thể: `ui_new/modules/stage/legendaryContinent.lua`, `stageselect.lua`, `stageselectres.lua`, `stagedetail.lua`; `ui_new/configs/mainSceneMapConfig.lua`; bảng `Stage/Battle/Unit/PlayerLevel` và `player/playerlimit.lua`. Review D38 liệt kê resource/layer đã tìm được.
- Ảnh người dùng đã được sao chép nguyên byte khỏi Temp vào `docs/reference/d38-world-ui/`: [hình1 — selector mong muốn](reference/d38-world-ui/chapter-selector.png), [hình2 — world hiện tại](reference/d38-world-ui/current-chapter-world.png), [hình3 — preview có boss](reference/d38-world-ui/stage-preview-boss.png). Ảnh2 là hiện trạng cần cải thiện; ảnh3 cho biết quan hệ boss/ải, không là ảnh mockup boss đã đứng ngoài world. Ảnh là tham chiếu, asset runtime vẫn lấy từ Crystal.
- `Artifacts/` là evidence/output local có thể tạo lại, không là nguồn quyết định hoặc input duy nhất. Mapping/config cần thiết phải từ dữ liệu được track hoặc bổ sung đi cùng source; không yêu cầu agent clone khác mang Artifacts của chat này.
- Theo D04, `install_time_pack.apk`, ZIP download `recovered/downloads/aab_1.1.100312.zip` và browser `chrome-headless-shell.exe` không đi theo Git; các bản diagnostic `network_diagnosis` nhạy cảm cũng bị ignore. D38 ưu tiên source/asset đã giải nén, không cần diagnostic. Nếu helper vẫn mở archive, sửa resolver/loader phù hợp hoặc nêu input thiếu; không tải/build toàn kho raw chỉ để xử lý UI.
- Trước khi import/bake, kiểm helper đang dùng root mới và đọc đúng phần asset cần. Giữ source raw; không xóa metadata/cache/asset hay đổi vị trí reference ngoài yêu cầu.

## 4. Checklist triển khai và nghiệm thu

### A. Equip thành công tự đóng panel

- [ ] Đối chiếu `ZatodEquipmentView`, luồng connection/receipt/snapshot và HeroDetail hiện hành; thực hiện UX-001.
- [ ] Sau đúng thao tác Equip được server xác nhận, đóng panel item và hiện HeroDetail đã cập nhật. Không yêu cầu bấmOK thêm.
- [ ] Lỗi, thiếu điều kiện hoặc persist fail: panel còn mở với reason, Owned không đổi sai. Không đóng ngay lúc gửi request.
- [ ] Ghép đúng operation/Hero/slot/itemGUID/context; reply trễ không đóng popup mới của một món/Hero khác. Nhấn kép/retry/receipt lặp/reconnect không thực hiện giao dịch hai lần.
- [ ] Xem đồ đang mặc hoặc craft vẫn giữ flow riêng; không tự Equip/Promote tiếp.

### B. Art object tính năng làng

- [ ] Dùng đúng asset Crystal cho các interaction tính năng hiện có: Phó bản, Bang hội, Arena, PvP realtime và các điểm tương ứng; giữ IDs/targets.
- [ ] Import/bake dependency, action, layer/alpha/bóng phù hợp. Container FCA/Spine không được coi mặc định là một PNG tĩnh hoặc cùng một loader.
- [ ] Căn chân, scale, sorting, label và vùng tương tác để avatar đi lại/bấm được. Hai điểm Arena/realtime phân biệt rõ; không khẳng định PeakArena là realtime chỉ từ tên asset.
- [ ] Feature chưa có logic giữ trạng thái hiện hành; thay art không mở phạm vi xây Guild/Tower.

### C. Selector chương và quyền mở

- [ ] Tương tác Phó bản tại làng mở selector trước; không tự WorldTravel tới chapter1.
- [ ] Ghép nền, đảo, nhãn, outline và khóa bằng asset Crystal như hình1, kéo ngang/responsive/safe area theo UI hiện có. Đường resource có chữ nguồn `norlmal`, không tự sửa thành `normal`.
- [ ] Chương đã mở sáng/chương khóa tối; hiển thị tên/trạng thái từ dữ liệu thật. Lý do khóa gồm thiếu level, chưa qua chương trước hoặc cả hai.
- [ ] Đưa chương đang chơi trong phiên vào khung nhìn; từ làng không có context thì dùng chương cao nhất đã mở. Chỉ chọn mới travel; kéo không bị nhận thành chọn, đóng view trả input đúng.
- [ ] Chương1 mặc định mở; chương sau cần hoàn tất ải cuối chương trước và đủ **account level**. Mốc Crystal chương1..8 là **Lv1/5/8/16/26/36/46/56**. Chỉ chapter có catalog/world hợp lệ mới có thể tới.
- [ ] Server dùng chung điều kiện cho selector, portal và bắt đầu ải. Reject request sai/khóa/stale không đổi map, trừ thể lực hoặc tạo loot; không chỉ gate bằng màu client.
- [ ] Tab Elite trong ảnh không tự mở Elite; không hiển thị phần chưa có như một đích travel hợp lệ.

### D. Portal trái/phải và Town

- [ ] Mỗi map chương có điểm chuyển ở đầu trái/phải tới chương liền trước/sau tồn tại và đã mở. Chương đầu/cuối không trỏ sai map hoặc wrap vòng.
- [ ] Tương tác portal theo flow hiện hành, giữ nútTown góc trái trên. Spawn đích tránh vùng gây vừa tới đã chuyển ngược lại.
- [ ] Giữ MapRevision, world interest/presence, reset input/interpolation và camera đúng sau travel. Kết thúc trận quay lại map/điểm đã vào, không bị selector mới đưa về chapter1.
- [ ] Giữ các map cùng tồn tại theo D21/D25. **Không thay sang chỉ tải map đang đứng/cache map/lazy-load/unload world** dưới danh nghĩa tối ưu D38.

### E. Boss đại diện và Passed

- [ ] Thay visual điểm ải bằng actor boss Crystal đứngIdle, không chỉ thay một phần node hai kiếm rồi giữ những điểm khác sai phạm vi. Boss phải khớp encounter/preview, ưu tiên boss wave cuối theo D20; cấu hình rõ trường hợp nhiều boss.
- [ ] Resolve Hero/Monster/resource từ ID thật. MageBone là ví dụ của người dùng, không hardcode asset vào Candidate? hoặc sửa encounter chỉ vì ví dụ. Giữ StageId/SourceStageId/TargetId và tọa độ tương tác.
- [ ] Nhập/validate phân loại **Key Stage** từ source cho catalog hiện có, có đường authoring tương ứng; không phân loại bằng hình marker hoặc việc có enemy gắn Boss.
- [ ] Minor (`Key Stage=false`) chỉ đánh một lần: thắng hợp lệ mới clear; sau đó hiệnPassed trên đầu boss, vẫn preview được, Challenge khóa với reason. Server chặn begin lại kể cả request trực tiếp/popup cũ.
- [ ] Key (`Key Stage=true`) đã clear vẫn đánh lại để farm, giữ các điều kiện hợp lệ khác. Không thêm Raid/Raidx3.
- [ ] Passed/sao/unlock là cá nhân; hai người chung điểm ải có thể thấy trạng thái khác nhau. Actor world chỉ là visual, không có AI/combat/stat hoặc thêm vào sở hữu.
- [ ] Thua/load fail/disconnect chưa được xác nhận clear không biến thànhPassed. Replay không cấp thưởng hoặc mở khóa phiên mới.

### F. Chuẩn bị tài nguyên và PoolManager

- [ ] Chuẩn bị Hero/Monster/background/audio và dependency effect/buff/projectile/summon của trận trong bước loading hiện có; body theo đội hình/encounter thực tế, dùng lại catalog của phase trước.
- [ ] Xử lý preload lỗi/hủy/stale context; hoàn tất chuẩn bị nối đúng điều kiện bắt đầu trận/PvP hiện có, không tự dừng tick hoặc thay timing/input/checker để chờ asset giữa trận.
- [ ] Dùng **PoolManager** cho effect, projectile visual, damage/heal/crit text và các object dùng thường xuyên có thể tái sử dụng; acquire/release thay tạo rồi xóa lặp.
- [ ] Prewarm phù hợp và giới hạn object giữ lại. Reset animation/time, transform/parent, scale/facing, renderer/material/alpha/sorting, text, target/entity/battle context, coroutine/tween/event/callback; chặn double-release/callback trễ tác động lượt dùng mới.
- [ ] Cleanup/reset đúng khi hết trận, hủy vào trận hoặc thoát scene; tài nguyên shared chỉ giải phóng khi hết reference. Pool presentation không pool/chuyển state simulation hoặc làm thay kết quả checker/replay.
- [ ] Kiểm texture nén thực theo nền tảng. Nếu sửa padding/BUG-056, giữ frame pixels/rect/pivot/GUID/FPS/timeline và kiểm art; không tự giảm chất lượng/cắt frame/bỏ effect.
- [ ] **Không làm mục1 baseline riêng trước sửa hoặc mục2 tải/cache map** đã bị người dùng bỏ. Không tự đặt60FPS thành ngưỡng nghiệm thu đã duyệt.

### G. Kiểm tra tổng hợp và chơi lâu

- [ ] Dùng client/server cùng code/config phù hợp. Với QuickEquip/nângskill, đọc BUG-067: trước đây server binary cũ không nhận command; xác nhận vận hành bản mới trước khi quy lỗi gameplay/gỡ guard. Đây là kiểm hồi quy, không làm lại Skill/QuickEquip.
- [ ] Kiểm Equip thành công/thất bại/nhấn kép/reply trễ/reconnect; selector/portal với thiếu clear, thiếu level, thiếu cả hai, vừa đủ điều kiện, request sai và context cũ.
- [ ] Hai client cùng/khác map, tiến trình khác nhau, join muộn, một người vào battle; camera/input/presence/return context đúng.
- [ ] Minor trước/sau thắng, key farm sau clear, thua/disconnect/replay; reject không tiêu tài nguyên hoặc nhận thưởng thêm. Rà tác động minor một lần và gate chương lên đường farm hiện có, không dùng dev cấp đồ/level che vòng kẹt, không thiết kế lại toàn bộ progressionD34.
- [ ] Giữ UI landscape/safe area, tương tác/kéo/joystick/khóa modal trên thiết bị phù hợp.
- [ ] Chạy **20 vòng làng→chương→trận→làng** và phiên liên tục **ít nhất20phút**, nhiều ultimate/summon/effect; kiểm pool thật sự tái sử dụng, object/callback không sót, bộ nhớ không tăng vô hạn/độ mượt không xấu dần và quay về world tiếp tục được.
- [ ] Kiểm Windows và OPPO Pad Air/iPhone11 khi có thiết bị; ghi rõ nền tảng/cảnh thực tế đã thử và phần thiếu. Quan sát FPS/RAM trong bài chơi lâu không mở lại bước baseline riêng đã bỏ; không hứa ngưỡng số chưa được duyệt.
- [ ] Chạy core/model/UI/network/replay checks phù hợp phần đổi; bảo vệ snapshot/replay rules cũ. Chỉ thêm test cần thiết cho policy/travel/receipt/pool lifecycle, không viết lại suite phase trước nếu không có thay đổi cần hồi quy.

## 5. Dữ liệu, migration và giao dịch

- Giữ ID/GUID Hero/item, trang bị/đã hấp thụ, levelskill/account, saveOwned và archive cũ. D38 không reset dữ liệu để thuận tiện import hoặc test.
- Bổ sung field loại ải/gate/visual bằng migration config cần thiết, validate mapping từ source; tránh chạy importer cũ ghi đè catalog/Evo/rules của phase trước. Không có lệnh reimport toàn bộ nội dungD34.
- Campaign progress vẫn theo phiên D11, reset khi mở game mới; save progress để phase sau. Không phục hồi clear từ replay/archive, không xóa archive.
- Equip dùng receipt/revision/persist/rollback hiện có. Chapter travel và request begin bị từ chối không thay map hoặc trừ thể lực/loot. Settlement thắng một lần theo D26; đổiPassed không tạo thêm đường nhận thưởng.
- Dùng profile/data directory/port test riêng; giữ dữ liệu người dùng và process đang dùng ngoài phạm vi thực thi được giao.

## 6. Bàn giao và trạng thái thực tế

Khi được giao triển khai, report phải ghi từng nhómA–G: đã sửa gì, file nào, kiểm gì, kết quả và phần chưa kiểm. Cập nhật Design/ChangeLog và implementation report tương ứng; không dùng việc build thành công để thay bằng chứng UI/network/thiết bị/pool.

Build theo D37: macOS sau nhiệm vụ triển khai/kiểm tra phù hợp tự tạoIPA chưa ký choSideloadly, USB riêng khi người dùng chọn; Windows hỏi trước đóng gói nếu chưa được yêu cầu build. **Lượt Markdown này không kích hoạt build/deploy.** Không gỡ app/resetOwned để cập nhật bản mới.

**Tại lúc lập bản bàn giao:** chỉ tài liệu và ba ảnh nguồn tham chiếu đã được cập nhật/lưu; mọi checkbox triển khai còn trống. Không có Unity/gameplay/network/device test hoặc build mới từ nhiệm vụ này.
