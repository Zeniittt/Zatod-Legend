# Kiểm tra vòng lặp tiến triển Phó bản

**Cập nhật22/11/2026:** D30 đã triển khai EXP tài khoản/Hero, vàng/thể lực, đồ EXP ở mức định nghĩa và craft thu phí thật; xem [zatod-economy-implementation.md](zatod-economy-implementation.md). Những mục EXP/economy còn thiếu dưới đây là tình trạng trước D30. Phạm vi pool gear/Promote UI còn để sau vẫn giữ nguyên.

Ngày21/11/2026. Chỉ đọc code/config và tổng hợp, chưa có quyết định phase mới hoặc thay runtime. Đối chiếu D08/D11/D12/D23/D26/D28.

Khảo sát bổ sung cùng ngày về EXP tài khoản/Hero, vàng, thể lực và các placeholder liên quan: [crystal-progression-economy-review.md](crystal-progression-economy-review.md). Chưa triển khai economy hoặc thay chính sách phí craft.

Vòng Phó bản -> thưởng item -> mặc/ghép -> tăng stats -> trận sau đã có nền chạy thực tế. Chưa có đường chơi tự nhiên đầy đủ từ account mới đến Blue mà không dùng dev.

## Ba chỗ chặn chính

1. EXP/level: Hero mới tạo Level1; không có thưởng EXP Hero/curve lên level hoặc handler Lvl Up trong view mới. Có DevLevel/Dev Lv40. Mặc đồ giữ LevelRequirement nguồn; ví dụ Lina/DR cầnLv2 cho mọi ô Trắng. Vì vậy có item vẫn có thể không mặc được. Stats tăng theo level đã có, còn thiếu nguồn tiến trình và giao dịch tăng level thật.
2. Nguồn item: config39 ải chỉ drop20 loại; đóng cây recipe đệ quy từ20 loại chỉ mở được29 loại. Để5 Hero khởi đầu tiến từ Trắng đến Blue cần36 loại trang bị cho các bậc có NextRankId, còn14 loại không thể farm/ghép từ pool hiện tại. Đây là khả năng đạt theo loại khi giả sử thắng lặp vô hạn, chưa tính lượng đồ/tỷ lệ/thời gian/độ khó. Thêm36 định nghĩa craft ở D28 không tự thêm nguồn cấp chúng. Evidence Artifacts/ZatodProgressionLoopReview/coverage.json có hash nguồn và danh sách thiếu.
3. Tiến bậc: HeroProgression.CanPromote/Promote và command server đã có, đủ ô thì chuyển đồ sang AbsorbedItems, đổi RankId và mở skill theo rank; giới hạn hiện tại Blue. Menu dev cũ có Tiến bậc, nhưng view Hero Base mới chưa nối luồng/nút Promote. Khi triển khai UI mới cần giao dịch lưu/rollback/retry cho Promote như luồng equip/craft; transaction D28 hiện chỉ bao phủ hai thao tác đó.

## Những phần đã có hoặc chủ động để sau

- Nhận item sau validate thắng, GUID riêng, save Owned, craft/mặc và cập nhật stats thật đã có. Chơi lại ải được mở là lượt battle mới, có loot mới; xem archive/replay không được cấp lại.
- Thắng mở ải kế tiếp theo prerequisite trong phiên chơi. Hero/item/bậc được lưu. Clear/unlock/stars của ải reset theo launch là D11 đã chốt, không phải lỗi mới; muốn chơi dài ngày cần bàn chính sách lưu phần này sau.
- Vàng/EXP ở màn thưởng vẫn placeholder, stamina mới là config/UI chưa có tài nguyên/trừ/hồi; phí ghép bỏ qua theo D28. Chưa có nâng sao, nâng cấp skill qua gameplay, Inventory view đầy đủ và Quick Equip. Skill mở theo bậc đã có, khác với nâng level skill.
- Get Way mới liệt kê nguồn từ drop config, chưa dẫn người chơi đến ải; recipe/input không có drop thì báo chưa có nguồn. Đây là phần trải nghiệm bổ sung sau khi bảo đảm có nguồn farm.

## Đề xuất, chưa chốt

Ưu tiên nguồn Hero EXP/curve level -> rà lại drop/recipe cho5 Hero đến Blue -> nối Promote trong view mới -> chơi thử account mới không dùng DevLevel/AddItem. Giữ balance/stat trực tiếp, tổng tỷ lệ drop100% và các quy tắc hiện hành. Test cần gồm độ khó để không tạo vòng phụ thuộc: cần món từ một ải mà người chơi chưa thể thắng ở lực đội hình hiện có.

Các phần economy/nâng sao/skill/persistence ải là mở rộng sau, không coi tự động thuộc phase mới chỉ vì được liệt kê trong khảo sát.
