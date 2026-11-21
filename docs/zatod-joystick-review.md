# Zatod — Khảo sát joystick mobile

Ngày20/11/2026. Đây là khảo sát lịch sử trước triển khai. Người dùng sau đó yêu cầu thực thi và chuyển menu dưới phải; kết quả tại docs/zatod-joystick-implementation.md.

## Yêu cầu đã xác định

- Game màn ngang mobile. WASD và phím mũi tên chỉ tồn tại trong nhánh `#if UNITY_EDITOR`; mọi Player build dùng joystick, kể cả Windows/development build. Trong Editor có thể giữ joystick để thử bằng chuột/Simulator bên cạnh bàn phím.
- Điều khiển avatar Town/map hiện có; input intent đi tiếp qua WorldMovement, collision, animation và đồng bộ world hiện tại. Không đổi điều khiển Hero trong trận hoặc rule combat.
- Riêng joystick dùng skin package Treasure Hunter người dùng cung cấp. Các UI khác tiếp tục quy tắc art D17/D23.

## Package đã kiểm tra

- Nguồn: C:/Users/tinnq/OneDrive/Desktop/TreasureHunter_Joystick_Export_2026-11-20/.
- Đã đọc README_IMPORT.txt, Manifest.json, Verification.json như tài liệu export; không thực hiện các bước import được ghi trong README.
- .unitypackage1.026.408 byte; checksum e7106828833ecb1eaebe198e05e022a4df042ddf3275374ca41e94b09e7a9cfc khớp. ZIP checksum cũng khớp;107 entry gồm directory entries.
- 45 asset,8 prefab,3 script runtime Joystick/FixedJoystick/VariableJoystick và2 custom inspector. Có skin game và PackDefaults. Không thấy trùng GUID/path với Assets hiện có tại thời điểm khảo sát.
- Floating/Dynamic portable dùng VariableJoystick, tránh phần phụ thuộc MMO UIManager/Physics2D của bản gốc. Chưa có clean-project import/Player test ở Zatod; không suy Verification của project nguồn thành đã chạy trong Zatod.
- Giữ OriginalJoystickSource.zip dạng ZIP để tham khảo; không cần bung MMO movement/UIManager vào Assets.
- Bằng chứng: Artifacts/ZatodJoystickReview/package-inspection.json.

## Những điểm cần xử lý khi tích hợp

1. Joystick.cs có getter AxisOptions tự gọi lại chính nó; truy cập gây đệ quy không dừng. Dùng field cấu hình/adapter an toàn; ghi BUG-039, chưa sửa vendor trong lượt này. Không dùng ResetHandleAnchoredPosition vì hàm này còn đặt background về tọa độ cố định542/537 của game gốc.
2. Source không có reset input khi OnDisable/mất focus và không giữ pointerId đang điều khiển. Tích hợp cần chặn ngón thứ hai giành joystick; nhả/cancel/ẩn View, chuyển map, mất focus/disconnect phải xóa input để tránh tiếp tục chạy với giá trị cũ. Đây là yêu cầu kiểm tra cho adapter, chưa báo là lỗi tái hiện trong Zatod.
3. Floating có vùng bắt chạm lớn/raycast. Chỉ nhận vùng trống điều khiển bên trái; menu Task/Hero/Inventory, nút interaction và modal không được kích joystick. Khi modal/battle khóa world phải ngừng nhận input và reset.
4. Package nằm dưới Assets/Packages/Joystick Pack, không có asmdef. ZatodWorldView thuộc Zatod.Runtime.asmdef, nên cần sắp xếp assembly/reference khi import để controller gọi được joystick; không chỉ kéo prefab vào Canvas rồi coi là hoàn tất. Không có xung đột class Joystick được phát hiện ở Assets hiện tại.
5. RectTransform/size trong prefab còn giá trị cố định từ nguồn; cần đặt vào safe area/bố cục responsive của Zatod. Giữ EventSystem và InputSystemUIInputModule đang dùng, không thêm EventSystem thứ hai.
6. WorldMovement hiện giữ input analog dưới độ dài1 và clamp trên1. Có thể giữ tốc độ tối đa hiện tại, kéo nhẹ đi chậm/kéo hết đi nhanh; không cần thay tốc độ world để thêm joystick. Dead zone là tham số có thể chỉnh, chưa chốt con số mới.

## Lựa chọn đã chốt

Người dùng chọn Fixed joystick, cố định trong vùng một phần tư dưới trái màn hình. Giữ đúng vùng này khi đổi kích thước ngang/safe area; chưa chốt tọa độ pixel hay đường kính cố định cho mọi thiết bị. Sau đó người dùng chốt chuyển Task/Hero/Inventory sang dưới phải và yêu cầu thực thi. Fixed dùng vùng trái, không dùng Floating/Dynamic; trạng thái hiện tại xem báo cáo triển khai.
