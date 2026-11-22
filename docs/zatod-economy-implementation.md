# Phase EXP, vàng và thể lực — D30

Ngày22/11/2026, Asia/Saigon. Người dùng đã yêu cầu thực thi sau các lượt chốt model/curve/craft. **Đã triển khai, kiểm tra và cập nhật bản chuẩn;218 file khớpSHA256.** Mặc định prototype0 vàng/60 thể lực là cấu hình tạm có thể chỉnh trong GameEditor, chưa coi là balance khởi tạo người dùng xác nhận riêng. Không dùng fixture để sửa kho người dùng.

## Model và config

- CharacterData giữ Level/Exp, hai field Stamina và StaminaRecoveryTimestamp khai báo kế nhau; EconomyVersion đánh dấu bổ sung field một lần. Hero giữ Level/Exp riêng, không có AvatarLevel riêng cho SPUM.
- CurrencyType.Gold=0; các loại mới thêm cuối và giữ mã ổn định. Currency.Type dùng enum; Id string cũ còn được đọc tương thích Owned, không tạo thêm số dư thể lực trong Currencies.
- Progression.txt có100 cấp tài khoản,120 cấp Hero, cap tài khoản mặc định100, interval360 giây, cap Hero/trần hồi/thưởng thể lực theo PlayerLevel nguồn. GameEditor → Progression có draft/validate/save/discard và chống ghi đè file đã đổi trên đĩa. Tên config riêng, không nhân curve vào từng Hero.
- Campaigns.txt bổ sung VitalityReturn, PlayerExpReward, HeroExpReward, GoldReward, FailPlayerExpReward đủ39 ải. Drop pools, wave/encounter/hooks và6 bảng combat/craft giữ dữ liệu cũ ngoài ConfigVersion.
- Import5 EXP consumable, tổng117 item; HeroExpValue theo60/300/1500/7500/75000. Dùng ItemDefinition/ItemData chung, ItemKind.Consumable nối cuối enum cũ. Copy ảnh gốc vào UI/Hero/Items và StagePreview/Items. Chưa có request dùng đồEXP/LvlUp; đây là phase sau.

## Authority và giao dịch

ProgressionCatalog là core C# thuần; production server load ProgressionDataJson. Clock server có thể inject trong test; client không gửi lượng thưởng hoặc thời gian hồi. Các session cũ trong regression không truyền progression nên vẫn kiểm tra combat legacy độc lập economy.

- Online: server kiểm tra hồi mỗi giây và trước request liên quan, chỉ save/sync khi có điểm hồi. Login/reconnect bù offline trước snapshot. Giữ phần thời gian dư; khi đầy không ngân thời gian, tiêu từ đầy bắt đầu chu kỳ mới. Client countdown từ ServerTime trong snapshot cộng realtime elapsed, không dùng giờ điện thoại để cấp số dư.
- Start: cần đủ Cost, cố định reward config và đội được chọn; trừ Cost-Return, save rồi mới phát start. Lưu lỗi rollback. Phiên đang issued chặn thêm trận/craft/loadout.
- End: checker dùng snapshot đầu trận; thắng trừ Return, cộngGold, AccountEXP rồi chiaHeroEXP. Thua có FailPlayerExpReward, không có vàng/item/HeroEXP. Cancel chỉ giữ phí vào trận, không cấpEXP chưa xác nhận.
- Tài khoản lên cấp tự trừ ngưỡng, giữ dư, cộng thể lực theo dòng cấp cũ; Hero dùng curve chung/cap theo account, giữEXP tới ngưỡng ởcap. Hero đã dùngDevLevel cao hơncap được giữ nguyênLevel/Exp, dừng nhận thêmEXP đến khi account đủ; không tự nâng account hoặc hạHero.
- Reward receipt gồm account/Hero trước-sau/EXP granted, gold, cost và itemGUID; lưu trong CampaignRewards để reconnect giữ kết quả. Replay/Continue/retry không grant lại. BattleId đã settled không được dùng để bắt đầu lại.
- Craft kiểm tra đủGoldCost và nguyên liệu, thu phí thật. Cùng transaction với GUID/receipt; rollback số dư khi persist throw; retryOperationId không thu thêm. Transaction D28 được mở rộng bằng EconomyCheckpoint cho các field kinh tế.

## UI

Asset native expbar/team_expbar được import Sprite. Màn thưởng có EXP tài khoản và từngHero, level/ratio thật và tween tiến trình trước-sau; vàng từreceipt. HeroBase có ngưỡngEXP thật. HeroList/Base resource row có vàng, stamina/cap và countdown; diamond vẫn placeholder. Craft hiển thị phí thật/màu thiếu vàng và reject rõ thiếu tiền.

Giữ responsive landscape/safe area hiện có, chưa benchmark hardware mobile. QuickEquip, nâng sao, dùng thuốcEXP, shop/mua stamina/giờ ăn, pool gear còn thiếu và Promote UI không tự mở trong phase này. Progress ải vẫn reset theolaunch D11, Owned vẫn lưu.

## Bằng chứng hiện có

Artifacts/ZatodEconomyChecks: core4.982 assertions PASS; editor37 checks PASS; ui81 checks PASS ở1600x900,2436x1125,2400x1080,1600x1200;14 archive cũ giữ digest/winner/stars/endTick. Fixture không dùngDevLevel đã thắng5 lượt ải1 từHeroLv1, accountLv2/5EXP và Hero tăng cấp.

Data-audit xác nhận112 item cũ giữ nguyên,39 encounter/drop pools giữ nguyên,6 bảngcombat/craft không đổi ngoài version;10 hash Owned/scene ban đầu giữ nguyên. UI đầu gặp catalog nonserialized=null do Play chồng reload; probe xác nhận và restartPlay sạch đã qua81 checks, cùng kinh nghiệm BUG-050. Build/network/deploy/handoff được bổ sung sau nghiệm thu, không coi các mục đang chạy là hoàn thành.

## Kiểm chứng mạng và build cuối

- HeroChecks112 PASS, CrystalChecks4.982 PASS, Editor37 PASS, UI81 PASS,14 archive PASS, clientEditor–serverWindows21 checks PASS. Network kiểm tra thuGoldCost1200, nguyên liệu/GUID, retry/reconnect, hồi online, thắngtrận495 vàng/6AccountEXP/12EXP mỗiHero, accountLv2 và thưởng thểlực20; replay không cấp lại. Fixture cuối server khởi động lại từ executable build cuối, data riêng17994.
- Build Windows cuối Succeeded143,92s/0errors/2warnings có sẵn. Build đầu thất bại do ổE thiếu dung lượng; đổi output sangTEMP trênC đã thành công. Backup bản chuẩn cũ tại TEMP/ZatodEconomyChecks20261122/BeforePlayer. Đây là output kiểm tra ngoài source, không chuyển referenceAPK hay project.
- MonsterChecks cũ fail vì ID fighter_goblin đã bỏ từD16; ghi REVIEW-004, không sửa dữ liệu/bộtest lịch sử để che lỗi, không ghi PASS. Active combat đã qua4.982 checks và14 replay ở trên.
- Helper/script kiểm tra D28 có kỳ vọng miễn phí là lịch sử; khi kiểm tra phase này dùng VerifyZatodEconomyEditor/Ui/Network/Archives.cs và core ProgressionChecks.cs. Build helper cần giữ đường dẫn TEMP vì resource hơn11GB.

## Bàn giao cuối

- Bản chạy chuẩn Builds/ZatodPrototype/ZatodLegend.exe đã cập nhật;218/218 file khớpSHA256 với build được kiểm tra trênC.10 hash Owned/scene giữ nguyên. deploy-audit.json/handoff.json là bằng chứng cuối.
- Editor stopped, ZatodPrototype scene sạch, auto_tick=false, đã mở GameEditor → Progression. Server test17994 đã dừng đúng executable; server chuẩn7788 giữ trạng thái dừng như đầu lượt. Mở lại bằng scripts/Start-ZatodServer.ps1 rồi Play/client như trước.
- Điều chỉnh curve/rule ở GameEditor → Progression, thưởng từngải ở Campaign, phí ở CraftRecipes. Save config rồi Play mới trong Editor; standalone cần build/restart để nhận configbundle mới. InitialGold=0/InitialStamina=60 hiện là mặc định prototype có thể đổi, chưa coi lựa chọn đó là balance được xác nhận riêng. Đổi mặc định chỉ áp dụng lần khởi tạo/migration, không reset số dư hiện có.
- Console cuối không có lỗi compile/runtime hiện hành;15 warning ReplaceHandler của Mirror khi reconnect (đã có từ flow cũ) được giữ, không clear Console. Build có2 warning cũ. Bản build cũ được sao lưu ở TEMP/ZatodEconomyChecks20261122/BeforePlayer; không xóa reference/source hoặc dữ liệu thật.
