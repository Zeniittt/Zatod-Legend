# Zatod GameEditor — Maps

Đã triển khai và kiểm tra 21/11/2026, theo D15. Công cụ chỉnh config, chưa có thao tác kéo/thả layout trong Scene.

## Mở và chỉnh

1. Trong Unity, mở **GameEditor > Maps**. Hoặc **GameEditor > Open**, chọn tab **Maps**.
2. Chọn **Island**: Town, Chapter 1 hoặc Chapter 2 (nhãn lấy từ config).
3. Chỉnh thông tin đảo, bounds, Origin X/Y, Interest Radius; mở các nhóm **Spawns**, **Props**, **Interactions** để xem/chỉnh từng entry.
4. **Validate** kiểm tra world cùng dữ liệu Hero/Campaign đang mở. **Save maps** chỉ lưu các file world thay đổi; **Save all config** lưu cả phần Hero/Campaign đang chỉnh.
5. **Select config asset** chọn file đảo trong Project/Inspector. **Raw JSON** cho phép chỉnh và apply vào draft trước khi lưu.

Các vị trí bên trong đảo là tọa độ **local**; Origin X/Y đặt cả đảo vào world chung. Ví dụ chapter1 spawn local X=6, OriginX=110, runtime X=116. Công cụ đọc file authoring trực tiếp, không ghi ngược bản đã cộng offset của runtime.

## File dữ liệu

- `Unity/Assets/Zatod/Resources/Data/Worlds.txt`: index tham chiếu config các đảo; cửa sổ cho chỉnh schema/config version, chưa có thao tác thêm đảo qua UI.
- `Unity/Assets/Zatod/Resources/Data/WorldMaps/town.txt`
- `Unity/Assets/Zatod/Resources/Data/WorldMaps/chapter_one.txt`
- `Unity/Assets/Zatod/Resources/Data/WorldMaps/chapter_two.txt`

File world thay đổi được backup trước khi lưu tại `Artifacts/ZatodConfigBefore/maps-<timestamp>-<guid>/`. Cửa sổ phát hiện file ngoài thay đổi: draft chưa lưu được giữ và save bị chặn; Reload files yêu cầu xác nhận bỏ draft. Mở/xem config không tự ghi file hoặc thay dữ liệu sở hữu.

Save áp dụng ở lần Play tiếp theo trong Editor. Standalone server/client dùng Resources được đóng gói: cần build lại và chạy lại bản mới. Công cụ không hot reload world đang hoạt động.

## Bằng chứng kiểm tra

- `Artifacts/ZatodMapsEditorChecks/checks.json`: 19 kiểm tra PASS; save, validation, stale/draft guards và local coordinate.
- `Artifacts/ZatodMapsEditorChecks/final-sha-check.json`: 19 file config/Owned nguyên SHA256 sau test.
- `Unity/Temp/MapsEditorReview/`: capture UI review.
- Source: `Unity/Assets/Zatod/Editor/GameEditorWorldMaps.cs`, `WorldConfigFileStore.cs`, `GameEditorWindow.cs`, `GameEditorWindow.uss`.

Unity Script Updating Consent từng chặn compile file mới; sau khi người dùng chọn cập nhật file, Editor compile sạch. Chi tiết xử lý BUG-044 tại `ChangeLog.md`.
