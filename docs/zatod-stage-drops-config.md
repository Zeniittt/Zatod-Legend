# Zatod — Config item rơi theo ải

Ngày 20/11/2026, quyết định D19 trong Design.md. Đã triển khai config/model/validation; chưa triển khai drop hoặc cấp thưởng. Đây là thiết kế prototype Zatod, không phải thuật toán loot Crystal đã khôi phục.

## Chỉnh config

Mở `GameEditor > Open` → tab `Campaign` → `Chapters` → chọn chương → `Stages` → chọn ải → `DropItems`. Dùng Add/Remove entry; mỗi dòng có:

- `ItemId`: ID loại item có trong tab Items, không phải GUID của vật phẩm trong kho.
- `DropChancePercent`: phần trăm 0–100; 100 nghĩa là 100%. Hiện mọi dòng đặt 100. Không cần cộng tổng tỷ lệ các item thành 100.

Nhấn Validate rồi Save all config. `ConfigVersion` hiện là `zatod-chapter-one-4` (sau bổ sung VitalityCost ngày20/11); khi balance tiếp, đổi version theo quy trình hiện có. Có thể chỉnh trực tiếp JSON tại `Unity/Assets/Zatod/Resources/Data/Campaigns.txt` rồi Reload files nếu không có draft cần giữ.

Ví dụ ải 3:

```json
"DropItems": [
  { "ItemId": "iron_axe", "DropChancePercent": 100 },
  { "ItemId": "small_stout_shield", "DropChancePercent": 100 }
]
```

Catalog từ chối ID không tồn tại, dòng null, ID lặp và tỷ lệ âm, lớn hơn 100, NaN hoặc Infinity. Danh sách rỗng hợp lệ cho ải không có item preview. Model mới khởi tạo list rỗng để giữ tương thích với config cũ thiếu field.

## Nguồn và phạm vi

- Nhập `Stage.UI reward` từ nguồn Crystal theo `SourceStageId`, chuyển sang ID snake_case Zatod; không suy loot từ Chest hoặc FD Bonus.
- 18 ải/54 wave được giữ nguyên; 36 dòng drop, 10 loại trang bị. ID20555 ngoài bộ 67 item đã nhập và có điều kiện level 81 trong nguồn; không tạo định nghĩa tạm/reference hỏng cho nó.
- `DropChancePercent=100` do người dùng chọn, không phải tỷ lệ gốc. Metadata đã được dùng để hiển thị Reward + icon trong popup preview và View chọn đội theo D20; không hiển thị tỷ lệ. Chưa roll, bắt sự kiện quái chết, tạo GUID, thêm kho hay thưởng cuối trận.
- Import lại bằng `python scripts/Import-ZatodStageDrops.py`; pipeline `Import-CrystalConfig.py` gọi bước này sau canonicalization. Đây là thao tác nhập lại từ nguồn, sẽ thay list/chance đã chỉnh bằng danh sách nguồn và 100%; không chạy tự động khi mở game hoặc GameEditor.

## Kiểm tra

- `dotnet run --no-restore --project Tests/CrystalChecks/CrystalChecks.csproj`: 4.429 assertions PASS, bao gồm validation rate/ID và round-trip giá trị thập phân.
- So bản trước: ngoài `DropItems` và ConfigVersion, toàn bộ dữ liệu ải/wave giữ nguyên. Chạy importer lại giữ nguyên byte Campaigns.txt; hai script Python parse thành công.
- `Artifacts/CrystalPhaseChecks/zatod-stage-drops-import.json`: danh sách nhập/bỏ qua; `zatod-stage-drops-checks.json`: kết quả kiểm tra.
- Không có Unity Editor chạy ở lượt kiểm tra. Bộ core đã compile bằng .NET; authoring dùng reflection có sẵn của GameEditor, chưa nghiệm thu live trong Editor hoặc build player mới.

Bổ sung Cost20/11/2026: mỗi stage có `VitalityCost` int không âm; cả18 ải hiện6 theo Crystal. Chỉnh trực tiếp trong cùng tab Campaign của GameEditor. Đây là dữ liệu hiển thị, chưa trừ thể lực. Báo cáo nguồn/kiểm tra: `Artifacts/CrystalPhaseChecks/zatod-stage-cost-import.json` (core4.431 PASS).

Nghiệm thu UI20/11/2026: đã chạy live Editor và server executable;766 UI checks/18 ải PASS, core4.431 PASS, build Windows0 lỗi/2 cảnh báo có sẵn. Xem docs/zatod-stage-preview-implementation.md.
