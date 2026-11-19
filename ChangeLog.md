# Zatod Legend — Lịch sử lỗi và cách xử lý

Cập nhật 19/11/2026 (Asia/Saigon). Tra theo mã/triệu chứng trước khi sửa lỗi. Chỉ ghi nguyên nhân đã có bằng chứng; giả thuyết ghi riêng. Design.md là nguồn quyết định thiết kế.

## BUG-001 — Hero và projectile di chuyển theo từng nấc

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa và kiểm tra Editor, core, build Windows và network executable cuối.
- **Triệu chứng:** đi bộ/đạn trông giật, như game lag dù animation vẫn phát.
- **Nguyên nhân xác nhận:** view lấy tọa độ model 8 Hz trực tiếp; interpolation chỉ áp vào animation time. Replay còn return sớm giữa tick. Source actor/projectile Crystal có vận tốc hiển thị giữa tick nhưng đoạn này chưa port đầy đủ.
- **Bằng chứng trước sửa:** 5.962 frame/27,90 giây, khoảng 213 FPS; 50.239 cặp frame Hero và 3.729 cặp frame đạn cùng tick, không cặp nào đổi vị trí. Hero thường nhảy 24,75 pixel thiết kế; đạn Lina/Zeus 103,125 pixel. Có 3 frame >50 ms; nguyên nhân hitch riêng lẻ chưa profile. 33 projectile speed import khớp nguồn.
- **Cách sửa:** snapshot vận tốc/độ cao chỉ phục vụ presentation; view dự phóng tối đa một tick và cập nhật mỗi render frame. Cache snapshot theo tick; replay cũng vẽ giữa tick. Giữ core 8 Hz, tốc độ nguồn, va chạm/damage, RNG/digest/replay. Teleport/chuyển wave khớp lại trạng thái mới, không suy vận tốc từ bước nhảy teleport. Motion/timeline không tiếp tục chạy qua manual-ultimate freeze, pause hoặc seek.
- **File:** `Unity/Assets/Zatod/Combat/CrystalPresentationState.cs`, `CrystalMatchDefinition.cs`, `CrystalBattleSimulation.cs`; `Unity/Assets/Zatod/Presentation/CrystalPrototypeView.cs`.
- **Kiểm tra:** CrystalChecks 4.009 PASS, gồm render không đổi model/digest và 3 archive trước sửa giữ nguyên kết quả. `Artifacts/CrystalPhaseChecks/motion-fix-editor.json` PASS: live Hero 13.916/13.916 và projectile 3.415/3.415 cặp frame di chuyển giữa tick; replay x1/x4 đều có chuyển động giữa tick, pause đứng yên, seek đúng tọa độ. Client Editor mới được server executable trước sửa validate. `motion-fix-build.json`: Succeeded, 0 lỗi, 2 cảnh báo cũ. `network-20261119-194824/results.txt`: Phó bản/Arena/PvP PASS, hai client cùng digest 7727497618463703090, 8 input; relaunch reset ải/giữ đúng 24 GUID/type pairs. Baseline tại `movement-observation-summary-20261119.json`; chi tiết trong `docs/crystal-phase-implementation.md`.
- **Nếu tái diễn:** kiểm tra tọa độ thật có đổi giữa các frame cùng tick, cả live và replay/pause/seek; FPS cao hoặc sprite animation mượt chưa đủ chứng minh tọa độ mượt. Không tăng projectile speed/tick rate để che lỗi presentation.
- **Khôi phục:** `Artifacts/CrystalPhaseCheckpoints/20261119-before-motion-fix/source.zip`.

## BUG-002 — Unity Hub báo project đang mở nhưng không có cửa sổ

- **Ngày:** 19/11/2026. **Trạng thái:** đã xử lý và kiểm tra.
- **Nguyên nhân:** Editor do agent mở bằng `-batchmode` vẫn chạy nền và giữ project lock.
- **Xử lý:** xác nhận đúng process/project; dùng Unity CLI close với `--if-saved` để thoát an toàn. Đã xác nhận không scene chưa lưu, không còn Editor của project và UnityLockfile biến mất.
- **Nếu tái diễn:** xem project path và cờ batchmode trong process; không đóng Editor của project khác, không xóa lock khi process còn chạy. Trước bàn giao nên đóng phiên batchmode do agent sở hữu.

## BUG-003 — PowerShell chặn Start-CrystalServer.ps1/Client.ps1

- **Ngày:** 19/11/2026. **Trạng thái:** đã xác định, có workaround; không đổi chính sách máy.
- **Triệu chứng:** PSSecurityException, running scripts is disabled.
- **Nguyên nhân:** execution policy của phiên PowerShell người dùng chặn `.ps1`.
- **Xử lý:** gọi `powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<đường dẫn script>"` cho riêng process đó. Không đặt Bypass toàn máy.
- **Kiểm tra:** người dùng xác nhận đã chạy/kết nối được. Script tại `scripts/Start-CrystalServer.ps1`, `Start-CrystalClient.ps1`.

## BUG-004 — Không mở replay từ history hoặc lỗi khi battle UI bị ẩn

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa, kiểm tra trước phase bàn giao.
- **Nguyên nhân:** record Phó bản được xem như acknowledgment của battle cũ ngay cả khi người dùng yêu cầu history; lookup Button qua parent inactive trả null.
- **Sửa:** phân biệt acknowledgment đúng battle đang hiện với yêu cầu replay khác; giữ reference playbackButton, bỏ draw khi stage inactive. File `CrystalPrototypeView.cs`.
- **Kiểm tra:** `Artifacts/CrystalPhaseChecks/ui-final/regression.json`: hidden battle/history/seek tick 54/x4/raycast đạt.
- **Nếu tái diễn:** kiểm tra BattleId, stage active và nguồn replay; không dùng sự tồn tại của connection.Battle để quyết định mọi replay.

## BUG-005 — Scene thiếu AudioListener

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa, kiểm tra.
- **Sửa:** thêm một AudioListener vào Main Camera qua Editor API; cập nhật `CrystalPrototypeSetup.cs` để scene tạo lại cũng có listener.
- **Kiểm tra:** UI regression ghi nhận đúng 1 AudioListener. Không thêm listener cho từng Hero/effect.

## BUG-006 — PvP từ chối envelope rỗng muộn khi tải sprite

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa, kiểm tra.
- **Nguyên nhân:** 5 tick startup có input rỗng implicit; cold sprite load khiến envelope rỗng tương ứng đến sau tick đã commit, bị nhận như input gameplay trễ.
- **Sửa:** `CrystalServer.AcceptOperation` bỏ qua đúng envelope rỗng của 5 tick implicit đã qua sau khi kiểm tra envelope; input thật trễ, tick sai và gói trùng tiếp theo vẫn bị từ chối.
- **Kiểm tra:** `warmup-gate.json` 5 PASS; `network-20261119-185731/results.txt` hai client cùng digest, input và kết quả.
- **Nếu tái diễn:** phân biệt envelope rỗng startup với input thật; không nới luật nhận mọi input quá hạn.

## BUG-007 — Buff control sai dạng hoặc thiếu stat reference

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa, kiểm tra.
- **Nguyên nhân:** danh sách control Lua từng bị serialize thành chuỗi dict Python; stat chỉ có trong buff chưa vào Stats. Loader test cũ thiếu bảng Buffs sau khi catalog validate chặt hơn.
- **Sửa:** import control dạng danh sách phân tách dấu phẩy, bổ sung stat phụ thuộc buff; loader đọc Buffs và version. File `scripts/Import-CrystalConfig.py`, `Tests/MonsterChecks/Program.cs`.
- **Kiểm tra:** CrystalChecks kiểm tra control stun; MonsterChecks 48.197 assertion PASS.
- **Nếu tái diễn:** kiểm tra dữ liệu import và loader trước khi thay luật combat để bù cho metadata sai.

## BUG-008 — Một số sound reference không tồn tại trong nguồn

- **Ngày:** 19/11/2026. **Trạng thái:** giới hạn nguồn đã xác nhận, chưa có asset để bổ sung.
- **Thiếu:** `Civ_Human_Wizard_BigAttack.mp3`, `Civ_Wizard_Attack.mp3`.
- **Xử lý:** ghi rõ trong `Artifacts/CrystalPhaseChecks/static-art-audio.json`; không giả vờ đã import hoặc tự thay sound khác.
- **Nếu tái diễn:** đối chiếu báo cáo/source trước khi debug AudioListener hay đường dẫn load.

## BUG-009 — Editor báo UnityConnect token exchange thất bại

- **Ngày:** 19/11/2026, sau build bản sửa chuyển động. **Trạng thái:** đã khoanh vùng dịch vụ Editor; chưa xử lý đăng nhập/kết nối Unity.
- **Thông báo:** `UnityConnectWebRequestException: Token Exchange failed due a failure with the web request.` Stack thuộc `UnityEditor.Connect.TokenExchange` / `UnityConnect.RequestNewServiceToken`, console seq 106, session `2daa4460d44d4802b20eb2ee24ca2628`.
- **Nguyên nhân đã xác nhận:** request đổi token dịch vụ Unity Editor thất bại. Chưa xác định sâu là mạng, certificate hay phiên đăng nhập; không gán đây là lỗi gameplay.
- **Ảnh hưởng quan sát:** build vẫn Succeeded/0 lỗi; core/render test đạt và Mirror local vẫn validate/thi đấu được. Không có bằng chứng lỗi chuyển động xuất phát từ UnityConnect.
- **Xử lý hiện tại:** giữ nguyên console làm bằng chứng; không tự sign-out/sign-in, đổi certificate hay xóa console để làm báo cáo sạch. Nếu còn lỗi tính năng dịch vụ Unity, điều tra riêng request/network và đăng nhập. Không sửa netcode Mirror để xử lý lỗi dịch vụ Editor.
