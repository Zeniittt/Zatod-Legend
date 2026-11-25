# D39 — Checklist lưu Player và Login/Register

Ngày 25/11/2026, Asia/Saigon. Đã được người dùng giao thực thi; quyết định hiện hành ở Design D39.

## Phạm vi

- Một `ZatodServerData/datas.json` chứa tất cả tài khoản trên máy server. GUID server tạo, username phân biệt hoa/thường, password nguyên văn theo yêu cầu prototype.
- Login/Register riêng; Confirm Password, hiện/ẩn password; chỉ nhớ username/IP trên client. Register không ghi đè username đã có; Login không tự tạo account.
- Giữ Player, Hero/skill/bậc/đồ/hấp thụ, inventory GUID, đội hình, tài nguyên/thời gian hồi, clear/sao Campaign và receipt.
- Ghi thưởng/clear/sao cùng commit; lỗi ghi rollback trong bộ nhớ, giữ file cũ/backup. Save một Player phải bảo toàn mọi Player khác; credential không vào snapshot/replay.
- Không resume trận; đăng nhập lại ở Town. Giữ chi phí bắt đầu đã trừ, chưa settle không thưởng/clear; settle đã commit giữ qua reconnect/restart.
- Bắt đầu dữ liệu mới; không nhập Owned/replay cũ hoặc xóa source/assets. Cùng host/data directory không đổi data khi đổi IP.

## Ngoài phạm vi

Auth hoàn chỉnh, hash/TLS/rate-limit, link provider, đổi/quên mật khẩu, migration data trước D39, Windows remote deploy, cài thiết bị hoặc publish. Không thay combat/rules/replay/balance/D38.

## Triển khai và kiểm

- [x] Store JSON chung, version/backup/ghi an toàn, hỏng file không reset im lặng.
- [x] Login/Register, case/password exact, GUID ổn định, một phiên/account, lỗi có thể thử lại.
- [x] Campaign load/save + transaction/rollback + offline stamina + gián đoạn trận.
- [x] Đội hình và chuyển tài khoản không mang state/UI của Player trước.
- [x] Core persistence; hồi quy legacy/native/Hero và D38 policy.
- [x] Unity compile/JSON roundtrip + TCP nhiều Player/restart + giao dịch/replay.
- [x] UI hai tab, input/submit/confirm/show-hide; landscape/safe area và ảnh xem trực quan.
- [x] Script Windows dùng folder dữ liệu cố định, không nhập data cũ; cập nhật hướng dẫn.
- [x] IPA iOS arm64 unsigned theo D37; CRC/plist/framework/runtime Data. Không cài/upload.

## Đầu vào và bàn giao

Runtime dùng Data/art đang tracked, không cần reverse local/Artifacts để khởi tạo tài khoản. Tests dùng account và port/folder riêng. `Artifacts/D39Checks` chỉ chứa evidence; save người dùng ở `ZatodServerData/` bị Git ignore. Chưa chuyển code/build sang Windows nếu chưa thực hiện thực tế.

## Kết quả cuối

Đã hoàn tất trên Mac ngày25/11/2026; xem implementation report để lấy IPA/source handoff, số kiểm và giới hạn. Script Windows được cập nhật và rà tĩnh, chưa chạy PowerShell/build executable Windows trên Mac; không coi đó là đã deploy PC. IPA unsigned không đồng nghĩa cài/chạy iPhone.
