# Zatod — Fixed joystick và menu dưới phải

Ngày20/11/2026; D24 và cập nhật D23. Đã triển khai/kiểm tra Editor và build Windows thành công0 lỗi.

## Hành vi

- Joystick Fixed dùng đúng GameSkin trong package người dùng cung cấp, luôn ở vị trí cố định trong vùng một phần tư dưới trái của safe area. Anchor=(0.14,0.22); đường kính thích ứng theo chiều cao safe area,180–230 đơn vị Canvas. Các số này là lựa chọn bố cục có thể chỉnh, không phải luật gameplay.
- Cụm Task/Hero/Inventory và mũi tên đã chuyển xuống phải; mở hoặc thu đều giữ vị trí toggle ở mép phải. Các chức năng Hero/no-op còn lại giữ như D23.
- Joystick nhận một pointer làm chủ. Pointer khác không đổi hướng hoặc thả thay ngón đang điều khiển. Dùng drag/clamp/Direction của Joystick Pack; giữ analog dưới độ dài1 và tốc độ tối đa WorldMovement hiện có.
- Nhả/cancel, ẩn/disable, mở modal, đổi map, mất focus/pause, disconnect đều đưa input về0. Không tự chạy lại khi đóng modal hoặc trở về ứng dụng.
- WASD/phím mũi tên và using Keyboard chỉ ở `#if UNITY_EDITOR`. Editor ưu tiên phím khi có phím hướng đang giữ, vẫn dùng được joystick bằng chuột/Simulator. Tất cả Player build dùng joystick; Windows có thể kéo bằng chuột. Không mở ngoại lệ bàn phím cho development build.
- Chỉ điều khiển avatar world. Không thay core combat, ba mode, protocol/tốc độ đồng bộ world, collision, Hero/items hoặc save.
- Cập nhật theo yêu cầu sau đó20/11/2026: bỏ dòng Hint WASD khỏi HUD cả Editor/Player; điều khiển bàn phím vẫn chỉ có ở Editor.

## Tích hợp nguồn

- Giữ bản export nguyên vẹn ngoài Assets tại TreasureHunter_Joystick_Export_2026-11-20/. Checksum đúng với Verification.json.
- Import45 asset/8 prefab/5 script bằng AssetDatabase.ImportPackage. Không bung OriginalJoystickSource.zip thành MMO scripts.
- Vendor runtime/Editor nằm trong Zatod.JoystickPack và Zatod.JoystickPack.Editor.asmdef để Zatod.Runtime tham chiếu được, không phụ thuộc Assembly-CSharp.
- Sửa đúng một getter: `return AxisOptions` → `return axisOptions`.44 payload khác bằng byte gốc; package nguồn/ZIP không sửa. BUG-039 đã có kiểm tra đọc getter thành công.
- Adapter: Unity/Assets/Zatod/Presentation/WorldInput/ZatodFixedJoystick.cs. OnDrag nguồn không virtual, nên adapter khai báo lại IDragHandler để mọi drag qua EventSystem đều kiểm tra pointer owner.
- Prefab dùng ở runtime: Unity/Assets/Zatod/Resources/Zatod/UI/World/ZatodFixedJoystick.prefab. Builder Unity/AgentScripts/BuildZatodJoystickPrefab.cs copy native Fixed, giữ sprite/binding, thay controller trên bản riêng và bật preserveAspect. Prefab nguồn không sửa.
- Host WorldView tạo joystick trong HUD hiện có, dùng EventSystem/InputSystemUIInputModule/GraphicRaycaster hiện có; không tạo hệ input thứ hai.

## Kiểm chứng

- ReviewZatodJoystick.Begin xác nhận Play tiến frame; Run qua71 checks ở lượt đầu,73 checks lượt cuối.
- PointerDown/Drag/Up được dispatch qua ExecuteEvents của uGUI; raycast thật xác nhận joystick nhận chạm và nút Hero không bị joystick chặn.
- Đã thử clamp, đổi hướng/di chuyển avatar, giữ analog, ngón thứ hai không giành điều khiển, nhả dừng, Editor keyboard, mở/đóng Hero, focus/pause/disable, portal đổi map, disconnect.
- Bố cục/raycast/drag sau resize PASS ở1920×1080,1600×1200,2436×1125,2520×1080. Joystick trong lower-left quarter, menu ở dưới phải, collapsed toggle giữ mép; cả hai trong safe area và không chồng nhau. Screen.safeArea Simulator được dùng. Chưa thử điện thoại vật lý.
- Hai lượt review có ảnh mới: native drag ban đầu; sau bật preserveAspect và thêm kiểm tra raycast, chụp lại toàn bộ matrix. JSON/ảnh: Artifacts/ZatodJoystickChecks/live/.
- Integrity:44 payload nguyên byte +1 getter patch có chủ đích;8 file Owned server local giữ SHA256. Xem integrity.json và owned-before.json.
- Console cuối trước build: không error mới sau cursor99, compilationFailed=false, consoleErrors=0; giữ lịch sử lỗi, không clear Console.

## Sự cố và khôi phục

- ImportPackage(false) vẫn mở Missing signature; đã xem đúng dialog của Unity Zatod, xác nhận package do người dùng cung cấp sau khi kiểm checksum. Không đổi setting bảo mật.
- Sau import, Unity từng không nhận source mới vào compile graph dù file/importer tồn tại. Đã force-import .cs/.asmdef, yêu cầu CleanBuildCache qua API, và đăng ký lại script bằng AssetDatabase.MoveAsset vào WorldInput, giữ GUID; compile sau đó PASS. Chưa xác nhận nguyên nhân nội bộ engine; không xóa Library. BUG-040 lưu chuỗi bằng chứng.
- Restore trước sửa: Unity/Temp/restore/joystick-20261120/before.zip. Source package nguyên vẹn tại gốc workspace.
- Unity docs đã đọc: uGUI CanvasScaler/BasicLayout/EventSystem/InputModules/GraphicRaycaster, Pipeline scripts/assets/capture/build; skill zatod-design, using-unity/create-ui/uGUI và computer-use cho dialog import.

## Bàn giao

- Windows build Succeeded274.235s,0 lỗi/3 warning từ ArenaView deprecated API, Mirror Weaver Assembly.Location và shader TMP pragma cũ. Không sửa các thư viện/phần cũ ngoài scope.
- Đã kiểm DLL Player Zatod.Runtime chứa ZatodFixedJoystick/get_Movement nhưng không chứa type Keyboard hoặc chuỗi WASD (UTF8/UTF16); DLL Editor vẫn có Keyboard. Bằng chứng player-input-proof.json. Không suy việc build Windows thành đã test APK/iPhone vật lý.
- Executable: Builds/ZatodPrototype/ZatodLegend.exe. Server test TCP17994 đã tắt. Local server đã bật lại PID37136, TCP7788, data Artifacts/ZatodServer; READY ghi trong server.log,8 file Owned giữ SHA256. Log cũ lưu local-server-before-build.log.
- Editor stopped/scene ZatodPrototype.unity sạch, auto-tick=false. Đã dọn10 preset test do lượt này tạo, giữ preset người dùng. Console cuối không error mới sau cursor101, compilationFailed=false/consoleErrors=0.
- Hướng dẫn test: docs/zatod-prototype-play.md. Trong Editor Play → Kết nối; có thể dùng joystick hoặc WASD/mũi tên. Windows Player kéo joystick bằng chuột; không dùng WASD để di chuyển.
