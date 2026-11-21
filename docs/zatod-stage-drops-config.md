# Zatod — Config và cấp loot Phó bản

Cập nhật21/11/2026 theo D26, thay quy tắc D19 cũ100% từng dòng. Đã nghiệm thu core4.819 assertions, network13 checks và build Windows0 lỗi; bằng chứng tại Artifacts/ZatodLootChecks.

## Chỉnh config

Mở **GameEditor > Open > Campaign > Chapters > Stages**. Mỗi ải có:

- MaxDropAmount: số món tối đa, prototype5. Random đều số nguyên từ0 tới giới hạn, gồm cả hai đầu. Giá trị0 tắt số lượng rơi; vẫn giữ pool hợp lệ để preview.
- DropItems: ItemId và DropChancePercent. Tổng tỷ lệ của từng ải phải đúng100%. Đây là xác suất chọn loại trong một lượt, không phải thử rớt độc lập từng dòng.
- Pool không được rỗng, ItemId không trùng/không thiếu; mỗi tỷ lệ0..100 hữu hạn. Không tự chuẩn hóa khi tổng sai. Nếu muốn không rơi món nào, đặt MaxDropAmount=0.
- Chia đều3 món:33,33% +33,33% +33,34%. Dùng phần dư ở dòng cuối để đúng100%. Dữ liệu39 ải hiện có2 loại/ải, mỗi loại50%, MaxDropAmount=5.

Validate và Save all config dùng cùng validation với runtime. ConfigVersion hiện zatod-campaign-loot-1. File: Unity/Assets/Zatod/Resources/Data/Campaigns.txt. Save áp dụng lần Play tiếp theo; standalone cần rebuild/restart.

## Luồng server

1. BeginCampaign tạo snapshot combat tin cậy, random số món rồi chọn từng món có hoàn lại, giữ list ItemId riêng theo battleId. Loot RNG tách combat RNG. Chưa tạo GUID/chưa cộng Inventory lúc vào trận.
2. ZatodStart.LootItems gửi bản sao list cho client; chỉ phục vụ presentation, không dùng list phía client để quyết định thưởng. Client có PendingCampaignLoot; lượt này chưa thêm animation quái rơi đồ, popup nhận thưởng hoặc thay vàng/rương0 trên HUD của D15.
3. ValidateCampaign kiểm chứng claim bằng snapshot/inputs. Thắng hợp lệ: tạo một ItemData GUID riêng mỗi món, tăng revision và lưu Owned trước khi xác nhận. Thua: không cấp item. Cancel bỏ pending loot. Số0 vẫn là một trận thắng hợp lệ.
4. Lỗi lưu: rollback các item mới/revision trong RAM, giữ battle và loot chờ để retry; không random lại. Thành công thì consume battle. Claim trùng bị từ chối. Replay chỉ xem, không settlement.
5. Account snapshot có LastCampaignReward (battleId/stageId và item GUID đã cấp). Đây là receipt trong session, không phải tiến trình ải được lưu qua app launch. Owned giữ item như trước; tiến trình ải vẫn reset theo launch.

Phạm vi prototype: pending battle/receipt nằm trong session server; chưa thêm khôi phục trận đang chơi sau server restart. Không tuyên bố đây là transaction backend Crystal.

## Import và nguồn

Preview vẫn tham chiếu Stage.UI reward của Crystal, chỉ giữ item có trong catalog. scripts/Import-ZatodStageDrops.py và Import-ZatodChapterTwo.py xuất tổng100%, không quay lại100% mỗi dòng. Re-import chủ động thay pool/chance theo nguồn và phân phối đều; không chạy tự động lúc mở game. StageDrops giữ MaxDropAmount hiện có, thêm5 nếu thiếu; importer chương2 tái tạo config chương2 theo mặc định5.

Bộ hiện tại39 ải/117 wave,78 dòng drop/20 loại item. Chỉ các field loot và ConfigVersion đổi trong lần migration này; không đổi wave/enemy/cost/layout hoặc GUID đã có. Thuật toán hai bước là thiết kế Zatod, không gắn nhãn là thuật toán Crystal đã reverse.

## Kiểm tra

- Tests/CrystalChecks: validator tổng/range/ID, weighted intervals60/30/10, biên0/5, zero-percent, lặp loại, mẫu RNG gần1, GUID, không cấp trước validate, reject/duplicate/cancel/loss, lỗi persist và retry, replay/new launch.
- Artifacts/ZatodLootChecks: config-audit.json, core-checks.txt, build.json, network/result.json và handoff.json khi nghiệm thu xong.
- Backup source trước sửa: Artifacts/ZatodLootChecks/before.zip. ChangeLog.md ghi trạng thái kiểm tra cuối.
