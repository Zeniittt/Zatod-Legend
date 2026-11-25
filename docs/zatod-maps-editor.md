# Zatod GameEditor — Maps

Đã triển khai và kiểm tra 21/11/2026, theo D15. Công cụ chỉnh config, chưa có thao tác kéo/thả layout trong Scene.

## Mở và chỉnh

1. Trong Unity, mở **GameEditor > Maps**. Hoặc **GameEditor > Open**, chọn tab **Maps**.
2. Chọn **Island**. Để thêm bản đồ đã soạn, đặt JSON tại `Resources/Data/WorldMaps/`, nhập resource như `Data/WorldMaps/new_island` và bấm **Add island draft**. Thao tác này chỉ đưa file vào bản nháp.
3. Chỉnh thông tin đảo, bounds, Origin X/Y, Interest Radius; mở các nhóm **Spawns**, **Props**, **Interactions** để xem/chỉnh từng entry.
4. **Validate** kiểm tra world cùng dữ liệu Hero/Campaign đang mở. Dùng **Save maps** khi chỉ sửa world. Nút này kiểm với Campaign đã lưu. Nếu đảo và Campaign cùng thay đổi, dùng **Save all config** để lưu các tham chiếu mới cùng nhau.
5. **Select config asset** chọn file đảo trong Project/Inspector. **Raw JSON** cho phép chỉnh và apply vào draft trước khi lưu.

Các vị trí bên trong đảo là tọa độ **local**; Origin X/Y đặt cả đảo vào world chung. Ví dụ chapter1 spawn local X=6, OriginX=110, runtime X=116. Công cụ đọc file authoring trực tiếp, không ghi ngược bản đã cộng offset của runtime.

## File dữ liệu

- `Unity/Assets/Zatod/Resources/Data/Worlds.txt` giữ danh sách resource của các đảo.
- `Unity/Assets/Zatod/Resources/Data/WorldMaps/town.txt`
- `Unity/Assets/Zatod/Resources/Data/WorldMaps/chapter_one.txt`
- `Unity/Assets/Zatod/Resources/Data/WorldMaps/chapter_two.txt`

Mỗi ải cần đúng một cửa vào trên đảo khai báo tại chương. Portal phải có map và spawn đích. Từ Town phải đi được tới từng đảo Campaign và quay lại, kể cả qua các đảo trung gian.

**Save all config** sao lưu các bảng Hero, progression, Campaign, world index và file đảo có thay đổi vào `Artifacts/ZatodConfigBefore/all-<timestamp>-<guid>/`. **Save maps** dùng thư mục `world-<timestamp>-<guid>/`. Nếu một lần ghi lỗi, công cụ khôi phục các file đã ghi theo byte gốc và giữ draft để thử lại. Nếu file trên đĩa đã đổi từ lúc mở draft, công cụ chặn lưu.

Save áp dụng ở lần Play tiếp theo trong Editor. Standalone server/client dùng Resources được đóng gói: cần build lại và chạy lại bản mới. Công cụ không hot reload world đang hoạt động.

## Bằng chứng kiểm tra

- `Artifacts/ZatodMapsEditorChecks/checks.json`: 19 kiểm tra PASS; save, validation, stale/draft guards và local coordinate.
- `Artifacts/ZatodMapsEditorChecks/final-sha-check.json`: 19 file config/Owned nguyên SHA256 sau test.
- `Unity/Temp/MapsEditorReview/`: capture UI review.
- Source: `Unity/Assets/Zatod/Editor/GameEditorWorldMaps.cs`, `WorldConfigFileStore.cs`, `GameEditorWindow.cs`, `GameEditorWindow.uss`.

Unity Script Updating Consent từng chặn compile file mới; sau khi người dùng chọn cập nhật file, Editor compile sạch. Chi tiết xử lý BUG-044 tại `ChangeLog.md`.

Ngày 24/11/2026, `Tests/Unity/D34WorldAuthoring.cs` đạt 11 kiểm tra về attach draft, lưu và tải lại qua Resources, phát hiện file stale và rollback khi một file không ghi được. Xem BUG-072 và `Artifacts/D34Checks/world-authoring.json`.

Sau khi mở rộng Save all, cùng fixture đạt 19 kiểm tra. Lỗi ghi ở đảo đã hoàn tác cả bảng Hero và progression, sau đó lưu lại được từ cùng draft. Xem BUG-076 và `Artifacts/D34Checks/full-config-transaction.json`.
