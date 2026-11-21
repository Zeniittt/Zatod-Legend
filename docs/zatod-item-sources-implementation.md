# Nguồn nhận item và điểm ải Crystal — 21/11/2026

Đã hoàn thành phạm vi D29 theo lệnh thực thi. Bản chạy chuẩn: `Builds/ZatodPrototype/ZatodLegend.exe`, server local TCP7788 dùng data cũ.

## Hành vi hiện tại

- Bấm ô trang bị → Recipe → nguyên liệu không có recipe để xem Available from. Danh sách lấy từ DropItems của39 ải active; không chép8 nguồn native Bracer scroll vào pool prototype chỉ có3 nguồn.
- Mỗi dòng: icon đúng ải → Normal/Elite · Ch.N · tên ải English → mũi tên hình ảnh hoặc Locked. Trạng thái dùng Campaign.IsUnlocked với Cleared hiện tại; danh sách cuộn khi dài, có thông báo rõ khi không có nguồn.
- Các dòng nguồn chỉ hiển thị, không có Button/callback. Bấm không mở popup, vào trận, teleport hay di chuyển avatar. MMO tự đi đến ải là phase sau. Tương tác world khi đứng gần ải vẫn hoạt động.
-39 tên English chính thức từ localization Crystal dùng ở nguồn, popup và nhãn/nút ngoài world. ID và progress không đổi.
-39 stage object dùng art Crystal:13 dedicated/12 ảnh nguồn,26 node thường. Stage23 dùng resid7 theo nguồn.80 PNG normal/locked/generic chỉ crop viền alpha trong suốt, giữ nguyên pixel RGBA. Vị trí, origin, radius, collision, TargetId, spawn/portal và town/TH khác giữ nguyên.

## Kiểm tra

| Hạng mục | Kết quả |
|---|---|
| Core |4.933 assertions PASS |
| Editor/assets |240 checks PASS |
| Sources UI |71 checks PASS,4 kích thước landscape |
| Craft/equip UI |74 checks PASS |
| Live world với server build mới |208 checks PASS,39 marker/nhãn, nút English, thắng/return và locked preview |
| Replay cũ |14 archive giữ nguyên digest/winner/stars/endTick |
| Config/save audit |9 Owned,2 scene giữ SHA256; mọi field gameplay map/Campaign giữ nguyên |
| Windows |Succeeded,0 errors;218 file bundle chuẩn khớp SHA256 |

UI sources/craft dùng account fixture trong RAM; world/battle dùng server17992 và account mới ở thư mục riêng. Không dùng account thật để farm hoặc giả progress. Phase này không benchmark điện thoại hay chạy lại peer PvP vì không đổi network/combat.

Ảnh thực từ Unity Game View: `Artifacts/ZatodItemSourcesChecks/ui-sources-mixed.png`, các bản responsive, `world/04-world-stage-button.png`, `world/04-stage-preview.png`. Ảnh source mixed dùng progress fixture để minh họa một dòng mở/hai dòng khóa; không phải save của người dùng.

## Nguồn và bảo trì

`Prepare-ZatodItemSources.py` resolve Stage ID/resid, nhập localization/art và kiểm tra không đổi gameplay. `SetupZatodItemSources.cs` author sprite/prefab/font bằng Unity API; không sửa prefab YAML tay. `ZatodStageVisuals` dùng chung icon/label; EquipmentView chỉ dựng presentation. Không chạy lại importer legacy hoặc Prepare-ZatodWorld chỉ để đổi tên vì chúng tái tạo nhiều config ngoài phase.

Lần build đầu thiếu dung lượng E, đã giữ report lỗi và build vào workspace C còn chỗ. Build đó đã nghiệm thu rồi copy sang bản chuẩn; không cần chạy từ thư mục C. Toàn bộ restore/audit/report tại `Artifacts/ZatodItemSourcesChecks` và `Unity/Temp/restore/item-sources-20261121/before.zip`.
