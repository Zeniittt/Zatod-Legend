# Khảo sát rương trong trận và màn thưởng Crystal

Ngày21/11/2026. Theo ba ảnh người dùng cung cấp. Chỉ khảo sát source/asset, chưa sửa code, scene, prefab, config runtime hoặc build. Dữ liệu loot Zatod hiện tại theo D26 vẫn giữ nguyên.

## Kết luận asset

Đủ tài nguyên cho bố cục và hiệu ứng trong ảnh. Đã đọc/giải mã40 ảnh PNG/JPG được6 source UI/Loot tham chiếu, không thiếu ảnh nào trong tập này. Đã xem trực tiếp chest1, banner victory_bg, crest victory_bg_1 và star; khớp các thành phần tương ứng trong ảnh. Báo cáo Artifacts/ZatodLootPresentationReview/asset-audit.json.

Ảnh nguồn dưới Crystal Legend/recovered/assets/install_time_pack/remake/:

- UI/alpha/1080P/common/chest1.png (69x63), chestopen1.png, chest_holo.png, shine.png, holo.png.
- UI/alpha/1080P/battleresult/new_resource/victory_bg.png (1056x190), victory_bg_1.png, victory_light.png, star.png, star_1.png.
- UI/alpha/1080P/battleresult/victory_bg.png (1920x712), progressbar_bg.png, team_expbar.png, heroexp_bg.png, expbar.png, exp.png, splitline.png.
- UI/alpha/1080P/common/button_com_big.png và crusade/btn_statics.png; có frame/tab/bar riêng của cửa sổ thống kê.
- Hero/item portrait, rank/star/quality frame đã có từ các phase trước. Source còn có âm thanh battle_loot.mp3, battle_win.mp3, battledown_star_one.mp3.

Hiệu ứng nguồn dưới Crystal Legend/recovered/downloads/aab_1.1.100312/patch/pfca/effect/: eff_UI_pve_victory_star_1/2/3, eff_UI_pve_victory_wings, eff_UI_pvp_light, eff_UI_pvp_newrecord_particles, eff_UI_levelup. Cả7 FCA đều có cha/plist/sheet.pvr; đã decode atlas và parse CHA, re-encode byte-identical. Các action chạy24FPS. Đây là kiểm tra container/timeline/ảnh, chưa bake hoặc nghiệm thu chuyển động đầy đủ trong Unity.

## Rương trong Crystal

- battle/battle_scene.lua:939 lấy loot theo wave/slot/phe; battle_sceneui.lua:1177 tạo một Loot cho mỗi entry.
- battle/loot.lua:8 dùng chung chest1.png bất kể loại item; position từ quái. Vận tốc ban đầu có độ cao300, gia tốc-1000 và thời gian0,6s để rương văng ra/rơi xuống. shine xoay/nhấp nháy, chest_holo sáng phía sau.
- Chạm: hiện chestopen1 mờ dần0,3s, icon item đi lên rồi bay về bộ đếm. Tự thu: dùng chính hình rương bay về bộ đếm, không cần lộ icon item.
- battle_sceneui.lua:679 tự thu khi chuyển wave; cuối thắng battle_engine.lua:4157 gọi autoCollectLoots(2.8), các rương thu cách nhau1/6s. Bộ đếm tăng khi hiệu ứng bay hoàn tất; không phải thao tác cấp item vào kho.
- Người dùng yêu cầu chỉ hiện rương chung; có thể dùng nhánh tự thu rương của source. Cách thu bằng chạm hay tự thu, thời gian giữ rương và mapping món sang quái là phần đề xuất cần chốt trước triển khai.

## Màn thắng Crystal

- stageaccount.initialize chọn commonBattleWin cho Phó bản thường. dealVictoryParam nhóm loot cùng Item ID thành amount; gold/EXP/Hero EXP là nguồn riêng từ Stage. Group để hiển thị không đồng nghĩa gộp stack trong Inventory Zatod.
- commonBattleWin dựng nền tối/bảng, banner/sao và FCA light/wings; thanh Squad EXP, tối đa5 Hero cùng EXP; reward icons có số lượng và nút Continue. Có trình tự animation cho sao, thanh EXP, portrait, item và nút.
- Nhánh ordinary downExit chỉ dựng màn thắng sau reply known và kết quả thắng; đoạn source có chờ3,6s trước stageaccount.initialize. Không cần chốt giữ nguyên delay này trong Zatod khi chưa có yêu cầu.
- Nút thống kê mở BattleStaticsWin, gồm gây damage, chịu damage, hồi máu và số kill; source có giao diện hai phía và thanh so sánh. Có thể dùng dữ liệu trận local hoặc dữ liệu server ở các mode khác.

## Đối chiếu Zatod và phần cần chốt

- LastCampaignReward đã có danh sách item GUID thực nhận; sao/kết quả, đội vào trận, level/rank/stars và icon đã có. Reward UI phải dùng receipt cùng battleId sau validate, không dùng DropItems preview hoặc coi pending plan là đồ đã nhận. Server hiện gửi replay trước account receipt; cần chờ đủ receipt để không hiện thưởng thiếu/sai.
- PendingCampaignLoot hiện chỉ là list ItemId, chưa có wave/slot/entity phân phối rơi. Đề xuất gắn trước mỗi món vào một địch tại start; một món tương ứng một rương, một quái có thể mang nhiều rương,0 món thì không tạo rương. Không random lại loại/số lượng trong presentation.
- Theo D25, rương và glow trong trận nên là SpriteRenderer ở Battle scene; popup/HUD dùng Canvas đúng art nguồn. Mô phỏng nhảy/bay của rương chỉ presentation, không đổi damage hoặc quyết định thưởng. Giữ landscape responsive/safe area D22, dọn effect khi cancel/disconnect/replay seek/scene unload, không thu hoặc cấp hai lần.
- Zatod chưa có reward gold/Squad EXP/Hero EXP và đường level-up hoàn chỉnh. Model Character/Hero có Exp nhưng chưa đủ để dựng thanh tăng EXP thật. Đề xuất placeholder trung thực hoặc tạm ẩn; chưa có quyền triển khai economy/EXP trong lượt khảo sát.
- Combat events hiện có amount/target EntityId nhưng thiếu source/caster cho thống kê gây damage/heal theo Hero. Cần bổ sung attribution và tổng hợp xuyên wave, xử lý DOT/reflect/summon/resurrect phù hợp trước khi tuyên bố thống kê giống Crystal. Chưa có report4 loại hoàn chỉnh sẵn để nối nút.
- Có thể nhóm reward theo ItemId để hiển thị xN, nhưng từng GUID Inventory vẫn riêng theo D12. Nút Continue chỉ đóng/return world; không phát request cấp thưởng lần nữa.

Các đề xuất phía trên là trạng thái khảo sát ban đầu; quyết định bổ sung sau khảo sát ghi bên dưới. Chưa có thay đổi runtime trong tài liệu này.

## Chốt bổ sung và kiểm tra thống kê

Phản hồi người dùng21/11/2026: gắn loot vào địch, ưu tiên boss; thưởng cuối trận dùng receipt thật; EXP chỉ dựng thanh0/0, vàng có icon và dấu?. Không bổ sung logic EXP/economy. Điều kiện làm thống kê là có đủ view/asset/data.

Đã tìm đúng view thống kê: ui_new/modules/battleResult/BattleStatics.lua (BattleStaticsWin), uieditor/BattleStaticWin.lua, BattleStaticItemLeft.lua và BattleStaticItemRight.lua. Có4 tab: gây damage, chịu damage, lượng hồi máu tạo ra và kill; hai danh sách hai phía có icon/số liệu/thanh so sánh, scroll và chuyển tab. Tập ảnh của cả view đã nằm trong40 ảnh decode PASS.

Kiểm tra dữ liệu: nhánh Crystal initDataByBattle dùng getDamage/getBearDamage/getTakeHeal/getKillNum. Dù tên getTakeHeal dễ gây nhầm, battle/unit.lua:2127 ghi addTakeHeal vào source (người hồi); buff.lua:192 cũng ghi vào caster. Vì vậy tab hồi máu này phải cộng cho người tạo ra heal, không tự đổi thành lượng máu nhận được của mục tiêu. Source còn gộp pet/summon về chủ trong battle_engine.lua:3447..3465.

Zatod Damage(actor,target,...) và Heal(target,amount,source) đã có chỗ tính amount hiệu lực và biết người gây tác động, nhưng event hiện chỉ lưu target EntityId/amount. Chưa có counter lũy kế theo actor cho đủ4 tab; chưa có kill report và cơ chế gộp/sống qua wave. Do đó **view/art đủ; data report chưa đủ sẵn để nối ngay**. Có thể bổ sung tại core rồi dùng báo cáo trận đã validate, không suy ngược từ hình ảnh hoặc tự nhận đây là report hiện có. Chưa chỉnh core/scene/config trong lượt kiểm tra này.

Lưu ý trình bày đã chốt: gộp xN chỉ trên popup, không stack GUID; gắn vào boss không làm roll lại hoặc tăng thưởng; EXP0/0 phải vẽ rỗng và tránh chia0; popup dùng receipt cùng battleId, Continue không cấp thêm.

Gốc Lua: Crystal Legend/recovered/scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data/. File chính: battle/loot.lua, battle/battle_sceneui.lua, ui_new/modules/stage/stageaccount.lua, ui_new/modules/battleResult/commonBattleWin.lua, BattleStatics.lua, ui_new/uieditor/commonBattleWin.lua và BattleStaticWin.lua.
