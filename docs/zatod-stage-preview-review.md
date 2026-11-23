# Zatod — Khảo sát popup preview ải

**Cập nhật sau thực thi20/11/2026:** D20 đã hoàn thành; các ghi chú “chưa” dưới đây mô tả thời điểm khảo sát. Trạng thái hiện hành và kiểm tra đầy đủ tại [báo cáo triển khai](zatod-stage-preview-implementation.md).

Ngày 20/11/2026, D20. Người dùng gửi 10 hình và yêu cầu kiểm tra trước; lượt này chỉ đọc source/asset và lưu tài liệu. Không sửa config runtime, C#, prefab, scene, protocol, hoặc import asset Unity.

## Flow và ranh giới

Flow đích: chọn ải → popup preview địch → Challenge → chọn đội → Battle → vào trận. X đóng popup về map, giữ nguyên session. Popup cần chặn click xuyên xuống map; Challenge không gửi bắt đầu trận. Hiển thị Reward + item icons ở View chọn đội, không tỷ lệ. Hai View đọc cùng stage.DropItems.

Tên trên bảng trong ảnh là tên ải (source stagedetail.getStageInformation đọc Stage Name), không phải tên chương. Giữ tên/mô tả CN đã có trong Zatod. Source screenshot dùng campaign_detail_hard_title (banner vàng); source có cả normal_title. Có thể dùng banner vàng theo ảnh cho giao diện mà không thêm chế độ Elite.

Enemies lấy Waves cuối cùng theo dữ liệu thay vì hardcode index2. Bao gồm mọi enemy spawn dù Kind=Hero hay Monster, không gộp các spawn trùng definition. Dùng cờ Boss, không đoán boss từ vị trí cuối/icon. Source Crystal findBoss dời ô Boss xuống cuối danh sách preview và createEnemy phóng lớn ô, gắn badge; có thể làm tương tự trong presentation, không sửa thứ tự spawn/core.

## Asset đã xác nhận

Gốc: `Unity/Assets/Crystal Legend/recovered/assets/install_time_pack/remake/`. Các đường dưới thuộc `UI/alpha/1080P/` nếu không ghi khác. Đã kiểm tra 22 file chính tồn tại; đã mở xem trực tiếp frame, banner normal/hard, nút X, nút Challenge/Raid, các sao/nền sao, badge Boss và vé.

| Thành phần | Asset |
|---|---|
| Viền popup | scale9/frame_common1.png; battle/battle_prepare_9bg_1.png |
| Banner tên | campaign/campaign_detail_normal_title.png; campaign_detail_hard_title.png |
| Nền/nội dung | campaign/campaign_detail_bg.png; campaign_detail_in_bg.png |
| Nền sao | campaign/campaign_detail_star_unlock_bg.png; campaign_detail_star_lock_bg.png |
| Sao vàng/xám/nâu | campaign/main/campaign_stage_star_1.png / _2.png / _3.png |
| Nút đóng | common/break_butt_bj.png + common/butt_off.png |
| Challenge | common/buttion_big.png + battle/battle_prepare_butt_fit_img.png |
| Raid/disabled | common/button_com_big.png; common/button_grey.png |
| Thể lực/vé Raid | icon/vitality.png; icon/raidticke.png |
| Boss tiếng Anh | en/UI/alpha/1080P/campaign/campaign_detail_boss.png |
| Tutorial trong ảnh | campaign/lineup_guide/enter_bg.png; lineup_guide/icon.png |

Badge Boss mặc định trong thư mục UI là tiếng Trung; dùng bản en đã mở xem mới khớp chữ Boss trong ref. Khung là các mảnh Scale9, không kéo giãn cả ảnh hoặc dùng screenshot crop. Font CN/Latin hiện có từ View chọn đội có thể tái dùng, cần kiểm tra label mới lúc thực thi.

10 item của DropItems đều có IconResource và file nguồn tương ứng dưới `UI/DOTA-ITEM/`. Chưa có bộ icon item này trong Resources Unity; cần import đúng ảnh và frame theo Quality. Portrait cho 16 Hero/10 Monster và khung bậc đã có ở bộ Formation. Manifest asset-data-inventory.json ghi chi tiết đường dẫn, EnemyIds/BossIds/SourceVitalityCost của từng ải.

## Dữ liệu đã có và còn thiếu

- Stage.Name, Description, Waves.Enemies, Boss và DropItems đã có trong Zatod. 18 ải hiện đều có3 wave, mỗi wave cuối có1 Boss. Chỉ hiển thị final wave trong popup; View chọn đội vẫn giữ nút xem tất cả wave hiện có.
- CampaignRun giữ sao từng ải và giữ max của các lần thắng trong phiên; server validate mới cập nhật. ZatodAccountSnapshot chỉ gửi Cleared IDs, chưa gửi số sao. Cần gửi thêm danh sách stageId/stars để client render chính xác0..3, không suy cleared thành3 và không dựa vào replay cũ để phục hồi progress. Giữ D11 reset theo launch.
- Cost đã triển khai riêng ngày20/11/2026 sau khảo sát: `CampaignStageDefinition.VitalityCost` là int không âm, 18/18 ải có6 theo source Stage.Vitality Cost. ConfigVersion hiện `zatod-chapter-one-4`; importer gốc có mapping field này. Chưa hiển thị Cost trong View, trừ stamina hay chặn Challenge vì thiếu stamina.
- Daily Attempts `?` theo yêu cầu. Raid Voucher chưa có dữ liệu; đã chốt hiển thị `?` thay vì số617 trong ảnh. Raid dưới3 sao hiện xám; đủ3 sao có thể đổi art trạng thái nhưng chưa gửi request/roll/cấp thưởng.
- Các sao nguồn có3 biến thể đúng ref: chưa đánh dùng3 sao xám; sau khi có sao dùng vàng cho phần đạt và nâu cho phần còn thiếu. Source stagedetail.lua:814 chọn các asset tương ứng.

## Bổ sung đã được người dùng duyệt ngày 20/11/2026

1. Back ở View chọn đội trở lại popup của ải đó, giữ draft đội; X ở popup về map. Thay hành vi đích Back về map của D18; code hiện tại chưa đổi.
2. Raid Voucher hiển thị `?`; cả hai nút Raid chưa xử lý, trạng thái hình ảnh phản ánh điều kiện3 sao. Chưa chốt số lần Raid hàng loạt cho Normal/Elite; phase này chỉ đặt nhãn theo ref, không ngầm thêm daily limit.
3. Giữ nút Tutorial ở popup theo ảnh, chưa nối code hoặc triển khai hướng dẫn.

Không có trở ngại asset chính đã kiểm tra. Vẫn cần nghiệm thu layout/anchors/Scale9/font/khung item và trạng thái0..3 sao bằng Editor khi được yêu cầu triển khai, chưa khẳng định đã khớp từng pixel hay đã chạy được View.

Lịch sử20/11/2026: ở lượt kiểm tra ban đầu Zatod chưa có Cost. Sau yêu cầu thực thi riêng, đã thêm `VitalityCost` vào model/config/importer và xác nhận18/18 giá trị khớp Crystal. Core4.431 assertions PASS (âm bị từ chối,0 hợp lệ, giữ số khi serialize); so bản trước chỉ Cost và version đổi. Báo cáo: `Artifacts/CrystalPhaseChecks/zatod-stage-cost-import.json`. Manifest asset-data-inventory.json là snapshot trước khi thêm Cost; gap Cost trong snapshot đó đã được giải quyết. UI/protocol sao vẫn chưa triển khai.
