# Crystal Legends — Cách render chiến trường

Khảo sát source Lua đã giải biên dịch ngày21/11/2026 theo câu hỏi người dùng. Chỉ đọc nguồn, không chạy APK và không đổi code Zatod. Kết luận là hành vi thấy trong source client, không phải quyết định thiết kế mới cho Zatod.

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
