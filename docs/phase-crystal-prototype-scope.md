# Phạm vi phase Crystal prototype — bản trình chốt

Ngày: 19/11/2026. **Trạng thái: người dùng đã duyệt và yêu cầu thực thi; phase prototype đã hoàn thành triển khai và kiểm tra ngày 19/11/2026.** Kết quả và giới hạn xem [crystal-phase-implementation.md](crystal-phase-implementation.md). Các quyết định đã thống nhất nằm trong [Design.md](../Design.md); tài liệu này giữ phạm vi giao việc/kiểm tra đã duyệt, không thay thế Design.md.

## Hai giới hạn cần hiểu đúng

- Giữ flow và rule Crystal đã xác minh từ client/checker. Không có toàn bộ backend gốc, nên không hứa mọi chính sách backend (đặc biệt timeout/reconnect) đều được khôi phục. Chỗ thiếu bằng chứng phải được nêu rõ khi xử lý, không tự gắn một cải tiến mới là rule gốc.
- Bỏ STR/AGI/INT là thay đổi có chủ đích. Phải quy đổi đóng góp vào stat trực tiếp, tăng trưởng và item; đối chiếu Main Attrib và UnitRank để tránh mất/cộng đôi stats. Giữ balance Crystal làm tham chiếu prototype, chưa tự balance riêng. Schema/công thức ánh xạ đã được triển khai và đối chiếu 384 trường hợp source oracle; thay đổi thiết kế tiếp theo vẫn tuân theo D01.

## 1. Nền tảng dữ liệu và config

- Giữ Unity + Mirror và combat core C# thuần dùng chung client/server/checker/replay.
- Giữ HeroDefinition → HeroData → HeroBattleData; gom config giống nhau vào CombatantDefinition, MonsterDefinition giữ phần riêng. Dùng CombatantBattleData chung; không thêm MonsterData sở hữu/nâng bậc cho quái wave.
- Hero phe địch dùng cùng HeroDefinition; thông số encounter tạo bản dữ liệu riêng của trận. Mỗi thực thể spawn có ID trận riêng.
- Giữ JSON trong file .txt và Editor balance; cập nhật schema/reference và công cụ hiện có để chỉnh dữ liệu mới. Không chuyển sang ScriptableObject.
- Thêm dữ liệu wave và spawn; tham chiếu bằng ID ổn định, tách config, dữ liệu sở hữu và dữ liệu trận.

## 2. Ba chế độ và replay

| Chế độ | Việc triển khai | Kết quả cần kiểm tra |
|---|---|---|
| Phó bản | Server cấp dữ liệu đầu trận/seed; client mô phỏng và ghi input; cuối trận server chạy lại validate, xác nhận kết quả và cập nhật clear/unlock trong phiên | Đi hết chuỗi wave; thao tác ulti hợp lệ; claim khác kết quả mô phỏng không được công nhận |
| Arena tự động | Dùng hai đội, seed và dữ liệu đầu trận; auto điều khiển theo rule; checker và replay dùng cùng core | Cùng đầu vào sinh cùng kết quả, xem lại nhiều lần không đổi |
| PvP realtime | Luồng tối thiểu ghép/đưa hai client vào trận, chọn/xác nhận đội, start, đồng bộ input theo tick, kết thúc và xem lại | A dùng ulti thì B thấy cùng diễn biến; hai phía kết thúc nhất quán; xử lý chờ/input theo rule source đã xác minh |

- Trước mắt giữ rule Crystal; chưa thêm rollback, chính sách mạng hoặc cơ chế cải tiến riêng ngoài yêu cầu.
- Tách input điều khiển khỏi presentation; animation/VFX/audio không quyết định damage.
- Dữ liệu đầu trận và rules/config của trận phải giữ ổn định để checker/replay không bị balance mới làm đổi kết quả. Bổ sung phiên bản/dữ liệu cần thiết; giữ khả năng đọc replay outcome cũ hoặc nhánh tương thích rõ ràng, không xóa archive cũ.
- Replay theo input gồm toàn bộ các wave và hook, không chỉ wave cuối. Không dùng GUID sinh ngẫu nhiên trong lúc mô phỏng làm thay đổi RNG combat.
- Chưa xây ranked/MMR/mùa giải, kinh tế hay bộ tính năng dịch vụ đầy đủ quanh các mode.

## 3. Nội dung chương 1

- Chương 1 Thường: 18 ải, 3 wave/ải, tổng 54 wave.
- Import đầy đủ đội địch từng wave, level/rank/sao/MP, boss/modifier, background và hook liên quan; kiểm tra các phụ thuộc art/skill cần cho từng encounter.
- Giữ luật chuyển wave Crystal: đội sống/chết và HP/MP được xử lý liên tục theo luật; tiếp tế, buff, Init CD, sắp lại vị trí và time limit theo source. Không tự hồi đầy đội sau mỗi wave.
- Hook có loại/handler trong core chung và tham số trong config/Editor để balance về sau. Dữ liệu ban đầu theo Crystal.
- Clear/unlock chỉ giữ trong phiên chơi; mỗi lần mở game lại bắt đầu từ ải đầu, kể cả dedicated server chưa tắt. Không khôi phục tiến trình lần chơi mới từ archive cũ, không xóa archive để đạt reset.
- Không triển khai lưu tiến trình phó bản dài hạn trong phase này.

## 4. Hero, quái và hình ảnh

- Bộ 5 khởi đầu: Coco, DR, Lina, Zeus, Ench.
- Import thêm các Hero xuất hiện phía địch: Lion, QOP, OK, TK, Sniper, Bone, Pugna, SNK, NEC, Tiny, Viper. Tổng 16 Hero riêng biệt; không tự cấp toàn bộ 16 vào HeroDesk khởi đầu.
- 10 loại quái: Treant, DOT, Ghoul, Necromancer, MeatWagon, CGjr, Goblinjr, SkeletonWarrior, SkeletonArcher, Golem.
- Chuyển asset được chọn từ reference sang Unity; tạo prefab/animation và gắn config để dùng trong gameplay. Giữ folder reference và tài nguyên pixel hiện có.
- Dùng frame-by-frame theo hướng đã chốt, giữ timing/pivot/scale/layer và ánh xạ Puppet.Resource (ví dụ Coco.cha → Coco_HD).
- Nối đòn thường, ulti, skill/buff và projectile/chain/region cùng VFX/audio cần cho giới hạn bậc và encounter trong phase. Không coi preview animation đơn lẻ là Hero đã hoàn thành.
- Giữ AnimDuration/AnimAtkFrame và quy tắc phát đòn/impact theo source; chain có thể tác động tức thì, projectile theo điều kiện của nó.
- Giữ HAST cho cooldown; MSPD cho động tác/thi triển/di chuyển. Clock visual và logic tương ứng; không mặc định tăng tốc mọi projectile/buff theo MSPD.
- Không gian: vị trí mặt đất 2D và độ cao riêng khi cần; AoE, khoảng cách, depth hiển thị và projectile theo cơ chế đang tái hiện.
- Skill mở ở Tím tiếp tục khóa trong progression của phase giới hạn Xanh Dương. Không tự kích hoạt nhánh awakening/shard/skin/endgame.

## 5. Stats và tiến bậc

- Stats trực tiếp, bỏ STR/AGI/INT như D05. Triển khai các stat và buff/mechanic mà nội dung phase thực sự cần, không thêm toàn bộ 65 field mà không có xử lý.
- Level/sao/level skill là đầu vào cần cho việc tính đúng dữ liệu tham chiếu; đối chiếu tăng trưởng và scaling khi chuyển. Chưa làm trọn vòng farm EXP/nâng sao hay hệ thống kinh tế nâng skill.
- Đường bậc: Trắng → Xanh Lá → Xanh Lá+1 → Xanh Dương thường (rank 4). Không mở Xanh Dương+1/+2 hoặc Tím trong phase.
- Mặc đúng món, đủ sáu ô thì tiến bậc; giữ điều kiện level. Khi tiến bậc, ghi các item thật vào ledger hấp thụ và làm trống bộ ô mới.
- Tính stats từ config hiện hành và lịch sử thật theo D08; không cộng đôi UnitRank Crystal và các món hấp thụ. Không sửa lịch sử item chỉ vì recipe mới khác.

## 6. Kho item và cấp đồ test

- Import 67 loại trang bị trực tiếp cho 16 Hero ở rank 1–4. Tập 108 loại gồm 41 nguyên liệu bổ sung chỉ còn là dữ liệu tham khảo cho craft tương lai.
- ItemDefinition dùng ItemId của loại. ItemData có Id string GUID riêng và ItemId; kho là danh sách từng món, không stack. Hai món cùng loại phải khác GUID.
- Mặc/chuyển món giữ GUID; món hấp thụ không còn là món dùng được trong kho nhưng giữ dấu vết ItemId/GUID nguồn.
- Hàm dev dự kiến AddItemByItemId(string itemId, int amount = 1): cấp trực tiếp thành phẩm, mỗi món một GUID, kiểm tra ItemId tồn tại; không cần nguyên liệu/phí craft.
- Điều kiện mặc đồ và tiến bậc vẫn thực thi. Công cụ test level/skill/EXP bổ sung vừa đủ khi cần kiểm thử, không xây cả bộ công cụ trước.
- Chưa làm craft, phù phép, Market/trade hoặc dung lượng/UI kho hoàn chỉnh kiểu sản phẩm thương mại.

## 7. Scene, UI và Editor phục vụ chơi thử

- Tận dụng scene/UI hiện có, cập nhật để chọn đội, chọn ải, chạy các wave, dùng ulti thủ công, xem kết quả và replay.
- Có luồng prototype đủ để kiểm tra kho, mặc item và tiến bậc, cùng hàm cấp đồ test.
- Có luồng vào Arena tự động và PvP hai client để kiểm tra end-to-end; không dừng ở unit test hoặc mô phỏng headless.
- Editor/config chỉnh được Hero/stats/item/skill và chương/ải/wave/hook trong phạm vi hỗ trợ. Không yêu cầu thiết kế lại toàn bộ giao diện game hay clone UI Crystal.

## 8. Tiêu chí hoàn thành

1. Build/compile và các kiểm tra phù hợp với thay đổi đi qua; cập nhật tài liệu đúng trạng thái thực tế.
2. Kiểm tra coverage dữ liệu/asset của 16 Hero, 10 quái, 18 ải/54 wave và 67 loại trang bị; phát hiện reference thiếu thay vì bỏ qua âm thầm.
3. Client/checker/replay dùng cùng đầu vào cho cùng kết quả; log input và hook/wave được tái hiện nhất quán.
4. Campaign chơi được qua các wave/ải, validate xong mới công nhận kết quả trong phiên; mở game lại về ải đầu.
5. Arena auto chạy và replay nhất quán; PvP chạy thực tế với hai client riêng, cùng nhận input và kết quả.
6. Kiểm tra timing animation/tác động, HAST/MSPD, projectile/buff và cơ chế đặc thù đang dùng; đối chiếu source ở các trường hợp dễ sai.
7. Cấp hai món cùng ItemId có GUID khác nhau; mặc giữ GUID; tiến bậc giữ lịch sử đúng và không cộng đôi stats. Ít nhất một Hero đi được từ Trắng tới Xanh Dương và mặc được bộ Xanh Dương khi đủ level.
8. Kiểm tra đổi base/item config vẫn tính lại stats từ reference thật; buff trận không ghi ngược vào config/HeroData.
9. Giữ dữ liệu/reference và archive cũ; không làm mất nội dung của project hiện có để nhập Crystal.

Các tiêu chí trên đã được kiểm tra trong phạm vi prototype. Bằng chứng, số assertion, build Windows cuối, hai client PvP, UI, các reference thiếu trong nguồn và giới hạn native/backend được ghi tại [báo cáo triển khai](crystal-phase-implementation.md); không suy rộng kết quả này thành tương đương toàn bộ game Crystal gốc.

## Ngoài phase

Tinh Anh, Tím/Tím+4/Cam, thức tỉnh, shard/skin nâng cao, craft, phù phép, Market/trade, quest/economy, vòng farm EXP/nâng sao đầy đủ, lưu tiến trình phó bản lâu dài, ranked/MMR/mùa giải, cải tiến netcode riêng và nhập toàn bộ asset/Hero/item Crystal ngoài nội dung đã chọn.

## Thứ tự dự kiến

Data/config + core dùng chung → chuyển Hero/quái/asset và kiểm tra timing → item GUID + tiến bậc Xanh Dương + cấp đồ → chương 1/wave/hook → Campaign validate/replay → Arena auto/replay → PvP hai client → kiểm tra tích hợp và cập nhật tài liệu.

Có thể đi theo các lát nhỏ để chơi thử sớm; việc chia thứ tự không thay đổi phạm vi và không đánh dấu hoàn thành trước khi kiểm tra.
