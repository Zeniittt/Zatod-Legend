# Rương, màn thưởng và thống kê Phó bản

Ngày21/11/2026. Phạm vi D27 trong Design.md; nguồn khảo sát tại [zatod-loot-presentation-review.md](zatod-loot-presentation-review.md).

## Hành vi

- Khi vào ải, server gắn pending loot D26 vào địch. Nếu có boss thì ưu tiên boss; nếu không thì phân phối trên các địch. Mapping không dùng thêm RNG combat, không tăng hoặc roll lại loot.
- Khi địch chết, mỗi món tạo một rương chung bằng SpriteRenderer trong Battle scene. Rương rơi, sáng rồi tự bay vào bộ đếm HUD. Đây chỉ là presentation; kho chưa được cấp đồ ở bước này.
- Khi thắng, chờ kết quả kiểm chứng và receipt cùng BattleId, đồng thời để rương thu xong, rồi mở màn thưởng. Sao, đội hình và item nhận lấy dữ liệu thật. Các item trùng ItemId nhóm xN trên màn hình; từng instance trong kho vẫn có GUID riêng.
- EXP dùng thanh rỗng và0/0, vàng dùng icon và dấu?. Chưa thêm kinh tế hoặc nâng cấp bằng EXP. Continue chỉ về world, không cấp thưởng lần nữa. Xem replay không nhận thêm item.
- Nút biểu đồ mở Battle Statistics: Damage dealt, Damage taken, Healing, Kills. Hai phía có danh sách cuộn, portrait, số và thanh so sánh. Báo cáo giữ các địch đã xuất hiện ở mọi wave, không chỉ wave cuối; tên địch có nhãn wave. Đổi tab sắp xếp lại theo chỉ số, mở lại trả scroll về đầu.
- Các popup mới dùng đúng ảnh Crystal, portrait/frame hiện có và hiệu ứng sao đã bake từ FCA. Root theo safe area và landscape; giữ cùng bố cục ở16:9,19.5:9,20:9 và4:3.

## Thống kê và giới hạn

`ZatodBattleStatistics.cs` tổng hợp ngay trong core; replay/checker chạy lại để dựng báo cáo. Damage là HP thực mất sau mitigation/shield/clamp, không cộng phần overkill. Healing là lượng HP thực hồi do người tạo heal cung cấp, không cộng overheal hoặc tự nhiên hồi máu vào tên một healer. Kills ghi ở nhánh chết thực tế; damage trực tiếp tự đánh mình không cộng vào báo cáo tấn công theo source đã đọc.

Core hiện gộp các modifier health_regen trước khi áp một delta HP. Attribution DOT/HoT chia delta hiệu lực theo tỷ trọng đóng góp âm/dương và loại phần nền khỏi credit caster. Không đổi cơ chế này thành từng buff tick chỉ để giống source; DOT hiện tại giữ tối thiểu1 HP nên không tự sinh kill mới. Đây là giới hạn mô phỏng hiện có, không khẳng định trùng hoàn toàn mọi skill của Crystal. Không tự thêm summon/reflect/resurrection chưa có trong tập mechanic hiện hành.

Popup thống kê mới gắn vào màn thắng Campaign. Core report dùng được các mode, nhưng màn kết thúc Arena/PvP và thất bại vẫn giữ UI hiện hành. HUD cũ được người dùng tạm chấp nhận trước đó không được thiết kế lại trong D27.

## File và kiểm tra

- Core: `Unity/Assets/Zatod/Combat/ZatodBattleStatistics.cs`, `ZatodSkillEffects.cs`, `ZatodBattleSimulation.cs`, `ZatodCampaignLoot.cs`, `ZatodPlayerSession.cs`.
- Presentation: `ZatodBattleLootView.cs`, `ZatodBattleResultView.cs`, `ZatodBattleStatisticsView.cs`, `ZatodBattleResultPresenter.cs`, `ZatodResultUi.cs` trong `Unity/Assets/Zatod/Presentation/`.
- Prefab: `Unity/Assets/Zatod/Resources/Zatod/UI/BattleResult/ZatodBattleResultView.prefab`.40 ảnh nguồn giữ byte gốc;7 FCA được bake/import. Audit `Artifacts/ZatodBattleResultChecks/native-art.json`.
- Script authoring `scripts/Prepare-ZatodBattleResult.py`, `Unity/AgentScripts/ImportZatodResultEffects.cs`, `SetupZatodBattleResult.cs`. Script kiểm tra ở AgentScripts không được gắn vào gameplay/player.
- Core4.838 assertions PASS, gồm actual damage/heal, attribution, xuyên wave, RNG/digest không đổi, boss placement, giả mạo report/plan bị bỏ qua. `Artifacts/ZatodBattleResultChecks/core-checks.txt`.
- UI pass3:113 checks PASS với14 report rows/5 reward items; đủ4 tab, scroll, responsive, đóng/mở và Continue/scene cleanup. `Artifacts/ZatodBattleResultChecks/pass3/result.json` cùng các screenshot.
- Replay cũ:13 archive supported rules chạy lại giữ digest/winner/stars/endTick; `archive-regression.json`.
- Build, kiểm tra server riêng, audit deploy và trạng thái bàn giao được ghi trong `Artifacts/ZatodBattleResultChecks/`. Chưa coi kiểm tra Simulator là chứng nhận thiết bị Android/iOS thật.
- Bản đã test được copy vào `Builds/ZatodPrototype`,218/218 SHA256 khớp. Server local PID23052 READY TCP7788, data cũ `Artifacts/ZatodServer`; server test đã dừng.19/19 config/Owned không đổi. Editor stopped/scene sạch/auto-tick=false; có thể Play và Connect127.0.0.1:7788 để thử một trận thắng rồi bấm nút biểu đồ. `handoff.json` là snapshot bàn giao, PID có thể đổi ở lượt mở sau.

## Kinh nghiệm đã sửa

ChangeLog BUG-046: TMP dưới root inactive phải có cache renderer/material trước đặt outline. BUG-047: ack trong lúc additive scene đang Loading vẫn thuộc trận đang chơi; không dùng activeSelf của stage để suy ra yêu cầu replay. BUG-048: clock trình bày phải để effect một lần/Death chạy hết khi core đã dừng, không Step thêm core.

Tooling: helper ScriptRun dùng class/static entry riêng, không chép kèm top-level statement từ script cũ (CS8803). Import FCA lớn có thể hoàn thành sau timeout của lời gọi CLI; kiểm tra manifest/evidence trước khi chạy lại, không import chồng. CaptureScreenshot cần qua frame render trước khi chuyển UI sang tab khác.
