# Crystal Legends — Cách render chiến trường

Khảo sát source Lua đã giải biên dịch ngày21/11/2026 theo câu hỏi người dùng. Chỉ đọc nguồn, không chạy APK và không đổi code Zatod. Kết luận là hành vi thấy trong source client, không phải quyết định thiết kế mới cho Zatod.

**Cập nhật24/11/2026:** phần so sánh Canvas bên dưới là baseline lịch sử trướcD25; runtime hiện đã dùng Battle scene additive/SpriteRenderer theoD25. Khảo sát feelingcombat mới và bằng chứng code hiện hành ở mục cuối; không áp lại bảng lịch sử thành yêu cầu refactor đã làm xong.

## Kết luận

Crystal dùng scene graph 2D của Cocos2d-x: tạo CCScene chiến đấu, các layer background/content/main/top/zoom, Hero là actor/node animation FCA, projectile/effect là sprite/FCA node. HUD có ui_layer riêng. Không có bằng chứng họ vẽ toàn bộ chiến trường qua một hệ UI Image như Zatod hiện tại. Đồng thời Cocos dùng chung các primitive CCNode/CCSprite/CCLayer cho cả gameplay lẫn UI; không áp cứng phân loại Unity Canvas/SpriteRenderer sang engine gốc.

## Bằng chứng trực tiếp

Gốc nguồn: `E:/viec/Zatod Legend/Unity/Assets/Crystal Legend/recovered/scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data/`.

- `battle/battle_scene.lua:97` createSceneAndLayers tạo CCScene và CCLayer cho background/content/main/top/zoom; nền qua ed.createSprite, background FCA có thể thêm riêng. Dòng134 gọi sceneui:createUILayers(self.scene).
- `battle/battle_scene.lua:473` addActor gắn actor.node vào main_layer. `battle/actor.lua:21` tạo UnitActor có node=CCNode:create(); dòng142 tạo puppet bằng ed.createFcaActor; dòng205 addChild puppet vào actor node. Dòng408 đặt zOrder theo config hoặc âm tọa độ Y.
- `resource_manager.lua:302` createFcaActor gọi native EDFcaSpActor:create cho .sp hoặc ed.createEDFcaActor cho FCA. Đây là actor được gắn trực tiếp vào scene graph; không có bước lấy frame gán vào UI Image như ReplaySprite của Zatod.
- `battle/projectile.lua:258` ProjectileActorCreate dùng ed.createSprite cho .png, ed.createEDFcaEffect cho .cha, ed.createEDFcaSpEffect cho .sp. Dòng331/335 cập nhật vị trí và zOrder node theo trạng thái projectile.
- `battle/battle_scene.lua:519` addEffect phân phối effect vào background_layer/main_layer/top_layer; z=2 đi qua sceneui:addEffect_UI. Vì vậy có cả effect thuộc UI, không khẳng định mọi effect đều nằm ở chiến trường. playEffectOnScene tạo FCA node, đặt view position, scale và zOrder theo origin.
- `battle/battle_sceneui.lua:13` tạo ui_layer, gắn vào CCScene ở z=2, có menu touch và damage batch node. Hero panel, timer/nút và các thành phần HUD thuộc phần scene UI riêng.
- `battle/battle_scene.lua:455/459/466` vào ed.replaceScene(ed.scene). `hello.lua:318` quản lý scene stack; nếu đang ở mainScene có thể pushScene, đường khác gọi CCDirector.replaceScene. Có scene chiến đấu riêng trong Cocos; không suy đây là Unity additive scene, hoặc luôn destroy main scene ở mọi đường.

## So sánh với Zatod hiện tại

| Phần | Crystal | Zatod hiện tại |
|---|---|---|
| Container trận | CCScene chiến đấu, nhiều layer | Battle HUD/actors trong Canvas của scene hiện tại |
| Hero | CCNode + FCA actor | RectTransform + UI Image, sampler SpriteRenderer không vẽ |
| Projectile/effect | Sprite/FCA node; một số effect lên UI | UI Image dưới Actors |
| Thứ tự hiển thị | Layer + zOrder, có sắp theo Y | Canvas hierarchy/presentation hiện có |
| HUD | ui_layer riêng | Canvas |
| Vào trận | Scene stack push/replace | Bật stage UI, ẩn world visual |

Nếu quy đổi sang Unity, phương án gần concept render này là BattleRoot/scene có actor renderer 2D và layer/sorting riêng, Canvas dành cho HUD. Đây là diễn giải chuyển engine, chưa phải yêu cầu đã duyệt. Scene additive client vẫn chỉ là một phương án quản lý lifetime, không phải kỹ thuật được chứng minh của Crystal.

Phân biệt render với simulation: nguồn vẫn có battle_engine/entity/projectile model riêng; node là phần biểu diễn. Không suy render node thành damage bắt buộc do collider/physics Unity hoặc animation event quyết định. Không kết luận phương án render nào nhanh hơn nếu chưa đo cùng nội dung/thiết bị.

## Rà feeling combat — 24/11/2026

Người dùng ưu tiên cảm giác combat gần Crystal và yêu cầu kiểm thêm ngoài tối nền. Đây là đối chiếu source/code trên checkout hiện tại, không chạy game Crystal, Unity, build hoặc thiết bị; chưa có video/đối chiếu A/B để kết luận mức giống về cảm giác. Các đề xuất dưới đây chưa là lệnh triển khai hoặc quyết định duyệt thêm tính năng. Skill/hook mới đợi baselineD35; cơ chế STR/AGI/INT đã được người dùng tạm bỏ khỏiD34.

**Duyệt tiếp24/11:** sau lượt khảo sát trên, người dùng đồng ý cả6 nhóm Damaged, buff/layer, số combat, âm thanh, chuyểnwave/kết thúc và xác chết vàoD34; đây thay trạng thái chưa duyệt tương ứng trong khảo sát ban đầu. Chưa có lệnh triển khai/runtime/build. Người dùng yêu cầu kiểm thêm UIultimate và thanh máu, kết quả ở mục cuối; các nhánh skill/stat đã tạm hoãn vẫn giữ phạm vi cũ.

### Nền đã có, cần giữ

- Core8Hz, HAST/MSPD riêng, timelinePhases/AttackTimes, projectile/chain impact và nội suy giữa tick đã có. BUG-001 đã kiểm chứng sửa giật; không đề xuất tăngtick/tốcđộ để tạo cảm giác nhanh hơn. Giữ các khác biệt Zatod đã chốtD05/D08.
- Battle scene additive với SpriteRenderer cho actor/effect, CanvasHUD đã đượcD25 triển khai. Không coi bảng Canvas lịch sử ở trên là hiện trạng.
- HeroAnimationSet đã có clip Move/Damaged/Cheer/Death của các Hero đầu được đọc mẫu (DR/Lina/Zeus/Ench); có AudioCues cho các action chiến đấu. `ZatodBattleStage.Draw` đã phát cue của actor; rương và popup thắng đã có âm riêng. Thiếu được xác nhận ở các đường khác bên dưới, không gọi toàn bộ combat hiện không có âm thanh.
- `ZatodBattleStage` đã có clock cho Death/effect saufinished theoBUG-048; giữ việc effect một lần chạy hết. Clock đó không là cơ chế fade xác.

### Khác biệt xác nhận và đề xuất

| Hạng mục | Source Crystal | Code Zatod đọc được | Ý nghĩa khi triển khai |
|---|---|---|---|
| Ultimate tối nền/freeze | `battle_scene.lua:823`: nềnRGB96, dừng effect hiện có; `entity.lua:66`: tint actor bịfreeze0,4; `skill.lua` trảfreeze ởAttackframe | Core cóManualStartup; stage chưa tint nền/actor | Đây là phần đã duyệt hướng. Dùng trạng thái core, xử lý caster/interrupt/death/freeze lồng; không dùng timer/rendercallback tính gameplay |
| Trúng đòn/ngắt action | `unit.lua:1938` hurt ngắt skill/sound, chọnDamaged và trạng tháiHurt; đường damage gọi theo điều kiện threshold/INTR/uncontrollable | `ZatodSkillEffects.Damage` khi proc interrupt đưa action vềIdle; không có nhánh gánDamaged trongcombat đã đọc | Đề xuất khôi phục nhịp giật mình khi đúng điều kiện nguồn. Phải đối chiếu cả thời lượng/điều kiện/RNG/rules; không phátDamaged cho mọi hit hoặc kéo dài cast bằng animation riêng |
| Buff/khống chế trên nhân vật | `buff.lua:479`: Effect, EffectZorder, Shader, ActorScale và cleanup; `actor.lua:303/384` xử lýfrozen/icefrozen khi đổi/tăng tốc action | Cóbuff effect nhưng ZatodBuffDefinition chưa giữShader/EffectZorder/ActorScale; stage không áp shader/tint tương ứng | Đề xuất thể hiện đúng loại trạng thái active và cleanup/refresh. Phân biệt freeze do ultimate với đóng băng như mộtdebuff |
| Layer/attachment của effect | `battle_scene.lua:519`: nền/main/top/UI theoz; actor cóeffectgắn riêng vàcomponent | `ZatodBattleStage.Draw` đặt effect ở2000-Y, actor1000-Y; modelVisual chưa manglayer/attachment đầyđủ | Đề xuất giữ effect dưới chân/trên thân/trên cảnh đúng nguồn, scale/flip/anchor và vòngđời, tránh tất cảeffect đều phủ trênHero. Blend của từngasset vẫn cần kiểm ảnh, chưa kết luậnbake sai |
| Số damage/heal/crit, miss/immune | `popup.lua:22`: pop/scale/ease/fade/lifetime0,8s và delay cácpopup cùngactor; unit phânmàu/crit/text | HUD dùng TMP, baytuyến tính60px/s/lifetime1,25s, critđổi fontsize; dodge/immunity trả về không phát event chữmiss/immune | Đề xuất dùngart/font/nhịpnguồn và event thật cho miss/immune. Không hiệnsốgiả, không random thêm ởview; kiểm nguồn hiểnthịdamage so vớiHPthựcmất khi shield/overkill |
| Chuyểnwave/nhịp cuối trận | `battle_scene.lua:332` đội chạy sang trận kế; actor:543/584/599 cóMove/Idle/Cheer; enginevictory cóshownextbutton/wait/cheer | CoreSupply+SpawnWave ngay trongtick cuối; resetpositions. Stage sample actionmodel, chưa có transit đi/ravào/cheer riêng | Đề xuất thêm nhịp chờ/chạy/chuyểnwave/cheer đúng nội dung. Source cóNextbutton; chưa tựduyệt thêmnút hoặc policyauto. Cần tách nhịppresentation khỏitickinput/checker, khôngcho modelđánhwave kế trước hìnhvà không đổiarchiveâmthầm |
| Death/fade xác | `actor.lua:331`: clipDeath +2s chờ+1s fade, summon/DeathWithEffect/giữxác cóngoạilệ | ClipDeath chạy đếnframecuối, chưa fade/hide theo rule này | Đã được người dùng duyệt bổ sung24/11 trongD34; chưa triển khai. Khôngdùngẩn xác quyếtđịnh chết/hồisinh/damage |
| Âm thanh và nhạc | FCA cócue; scene:245/625/815 chạymusic theo chapter; sound.lua cóguard âmtrùngframe | Actorcue đượcphát. Effectloop trongstage gọiSample nhưng không đọc AudioCues; chưa có battlemusic flow theochapter | Ràcueeffect/impact/voice/BGM/cắtâm khiinterrupt/thoát. Kiểm actualresource, gain vàsoundtrùng; khôngtuyênbốmọi cue bịthiếu |

**Kiểm kê cue chỉ đọc:** 114 AnimationSet cóHeroId bắtđầu `effect_`, tổng15AudioCues; ví dụ `eff_impact_burn`, `eff_impact_burst`, `eff_impact_CM_atk`, `eff_impact_crush`, `eff_impact_freeze`. Stage hiện chỉ duyệtcue trong vòngactor, khôngduyệt trongvòngeffect. Đây là thiếu đườngphát từmetadata đãcó; chưa kiểm mọi fileâm tươngứng cóđủ hoặc nghe trênthiếtbị. Nhạcchương còn cần resolve đúngassetnguồn.

### Rung/zoom và những phần chưa được chứng minh

- Source có `startCameraShakeAnimationX/Y`, `playZoomOnScene`, FVTimeZone. Quét trực tiếp40file Hero đãchọn (25cũ+15mới) không thấy lời gọi `startCameraShakeAnimation` hoặc `playZoomOnScene`; nhiều lời gọi nằm ởBoss/awake/Hero khác. Chưa quét xong mọi assetevent/helper/encounter mới. Vìvậy chưa đủ cơsở thêm rung/zoom chung cho mọiultimate hoặc cho rằng đây là yếu tố nền bắtbuộc của40Hero.
- Không tự thêm hitstop, camerashake, flash/shadow hoặc làm chậm mọiđòn chỉ vì các kỹthuật đó thườngtănggamefeel. Chỉ đềxuất phần có bằngchứng nguồn và xácđịnh đúng nội dung/mốc kíchhoạt.
- Cần nhận baselineD35 rồi kiểm lại các khoảngtrống code trước triểnkhai; mộtchat khác cóthể đãđổi các đường này. Sau đó nghiệmthu visual/audio trênWindows/Android/iOS, replaypause/seek/x4, ultimatechồng, đổiwave vàcleanup; kiểmchecker/archive khi đổi logic.
- HUD hiện lấy mộtphần rank/stars từOwned trong `ZatodBattleHud.DrawHud`; poolPvPfree cần lấy dữliệu trận/preset đểHero chưa sởhữu vẫn hiện3sao/Tím đúng. Đây là giaođiểm D34 vớipresentation, không là thayđổiHeroDesk.

### Thứ tự kỹ thuật đề nghị, phạm vi 6 nhóm đã duyệt24/11

Tối nền theo hướngđãchốt → Damaged/ngắtđòn + buff/layer/effect → sốcombat/âmthanh/UIultimate/thanhmáu → chuyểnwave/Cheer/fadexác. Camera chỉbổsung khi cóHero/encounter/eventnguồn tươngứng. Chi tiết skill/hook tạm đểngỏ theoD34 làmrõ24/11. Phạm vi đượcduyệt khôngđồngnghĩa đãcó lệnh code/build hoặcđãkiểmchứng.

## UI kích hoạt ultimate và thanh máu — kiểm bổ sung24/11/2026

### Ultimate: portrait, điều kiện và phản hồi

- Nguồn `battle/battleui/hero_panel.lua:9` dựng portrait/frame theo tid/rank/stars/fashion qua readhero, nền `common/herobucket.png`, hit area `common/battle_menu_click.png`, HP/nộ và lớp cảnh báo ít máu. `battle_sceneui.lua:1680` dùng `battle_hero_bg.png` làm nền cho cảdải Hero; Zatod helper hiện dùng nền này cho từngcard. Không coi cùngtênasset là đãđúng bố cục/scale.
- `hero_panel.lua:55/80` tap portrait gọi castHandler→engine.manuallyCastSkill và effectcast, khóa nút ởđườngcastthôngthường. `checkManulCanCast:228` dùng unit.can_cast_manual + engine.running, thêm rule freeze_camp khi realtimePvP; `unit.lua:1546` tính can_cast_manual qua chọntarget và canCastWithTarget. Vìvậy ready/clickability phải lấy khả năngcast thực, không chỉEnergy>=MaxEnergy. Kiểm thêm silence/stun/range/target/đangcast/pendinginput và guardmode theo core đãđốichiếu; không làm view tựtiêuMP hoặc quyếtđịnhdamage.
- Các effect nguồn: `eff_UI_battle_skill_will_ready`, `eff_UI_battle_skill_cast`, cácđườngactivate/switch khi skill thựcsựhỗtrợ, `eff_UI_full_power` và `eff_UI_battle_skill_cost` cho thanh nộ. Ready phát soundcdOver; cast thay/clear ready và cóeffect riêng. Giữ cảnh báo HPthấp vàportraitxám khi chết theo nguồn. Không tự mở mọi mode/skilltrigger đặcbiệt trongfile nếu ngoài nội dungactive.
- Zatod `ZatodBattleHudLayout.Create` hiện vẽ readyborder bằng các Image màu, `DrawHud` dùngenergy đầy/alive/đúngteam làmclickability. `ZatodBattleStage` còn cho bấmactortrênsân bằngBoxCollider2D. Nguồn đã xácnhận thao tác portrait; lượt này chưa có bằngchứng toànbộflowCrystal dùngclickactortrênsân hoặc quyếtđịnh bỏshortcutZatod. Khi triểnkhai cần làm portraitđúngnguồn, giữinputtick/checker/replay và chặn gửi lặp, không tự thay luật combat/Auto vì sửaUI.
- Cảnh báo tái diễn BUG-014: không đặt `battle_hero_energy_full.png` vào Imagealpha mặcđịnh đểthayFCA rồi cheportrait; viềnvàng làworkaround cũđượcchấpnhận tạm, không là artđích. Phải giữblend/alpha/scale/layer củaeffectnguồn và kiểmảnhsauimport.

### Hai loại thanh máu có quy tắc khác nhau

**Thanh nổi trên actor:** `actor.lua:58` dùng `FloatingBar.create(model,"HP")`, groupHP/shield, vịtrínguồnY134,5 vàscale2/3 (còn điều chỉnh theo mode). `hp_bar.lua:672` chọn `hp_black_small.png`, `hp_yellow_small.png`, `hp_green_small.png` phía mình/`hp_red_small.png` phíađịch. Đã mở ảnh nguồn herobucket/HPgreen/HPyellow để xem; không tạo ảnh thay thế.

- `FloatingBar.create:742` khởi tạo tỷlệ thật vào cảforeground/midlayer, hide_timer0; mặcđịnh auto_hide=true nên HPổnđịnh khônghiện liêntục.
- `FloatingBar.update:793`: mấtHP làmforegroundgiảmngay, lớpvàng chạyđuổi với inc_speed0,8 tỷlệ/giây; hồiHP làmforeground tăngdần. Khi animationbar cậpnhật, timer đượcrefresh `hide_delay=1.5`; hếtchuyểnđộng thì giữthêmkhoảng1,5s rồiẩn. Vìvậy khôngnên giảnlược thành1,5s cứng tính từ lúc trúngđòn.
- `FloatingBarGroup:885` lấy timerlớnnhất trong nhóm HP/shield (Fury táchriêng); shieldthayđổi cóthể làmHPbar vẫnhiện dùHPkhôngđổi. `percent==0`/khôngCanBeSeen ẩn; force_hide đượcgiữ. `isFixedHpBar`/still_show vàboss córulekhác; MultiArena là multiarena_mode theo battle_engine_extra.lua, không tự đồngnhất với PvPrealtime.

**HP/nộ dưới portraitHUD:** `hero_panel.lua:92/96` đặt auto_hide=false cho cảhai. Đường này dùng `battle_hero_progress_bg`, `battle_hero_blood_progress`, `battle_hero_energy_progress`, lớpđuổivàng vàmask/cảnhbáo tươngứng trong `HpBar`. Không áp auto-hide thanhtrênđầu cho portrait.

**Zatod hiện tại:** thanhtrênactor trong `ZatodBattleStage.Draw` là Spritewhite tintxanh/đỏ, scaleX theoHP, khôngtimerẩn/đuổivàng. Phảnánh người dùng khớpcode. ThanhHUD đã cómộtphầnassetnguồn nhưng chưađủ nativeflow/mask/midlayer; cần ràriêngcảhai, không gom thànhmộtbar.

### Asset có thật và giới hạn kiểm tra

- PNG HPsmall/herobucket đãtồn tại trong `recovered/assets/install_time_pack/remake/UI/alpha/1080P/common/`. HPsmall/herobucket chưa có trong Resources/Zatod/UI được quét; assetbattleheroHUD đãcómộtphần. Tồn tại nguồn khôngđồngnghĩa đãđượcimport/đặtđúngruntime.
- 4 container `eff_UI_battle_skill_will_ready`, `eff_UI_battle_skill_cast`, `eff_UI_full_power`, `eff_UI_battle_skill_cost` cótrong thưmụcgiảinén `recovered/downloads/aab_1.1.100312/patch/pfca/effect/`; đọcZIPcontainerthànhcông, cócha/plist/sheet.pvr, CRCtừngcontainerPASS. Chưa có recovered/heroes/<name>/animation.json trongcheckoutđãkiểm; cầnrecover/bake bằng loaderđãsửaresolver/đọcfoldergiảinén. KhôngcầnarchiveaabZIP bịignore hoặcArtifacts đểlấy4đầuvàonày.
- Chưa chạyCrystal/Editor/Play/build, chưanghiệmthuultUI hoặcHPbartrênthiếtbị. Khi triểnkhai kiểm: HPkhôngđổi/giảm/hồi/liêntục/thayMaxHP/shield/death; portraitbar luônhiện; ready/cast/silence/stun/target/pending/replay; màu/layer/scale ởtỷlệmànhình vàsafearea. Dữliệu phải từsnapshottrận, nhấtlà40HeroPvPfree; khôngđọcOwned đểđoánrank/sao.
