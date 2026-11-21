# Zatod — Kiểm tra gói visual Treasure Hunter

Ngày20/11/2026. Chỉ đọc folder, archive và chat do người dùng chỉ định; không import vào Unity/Assets, sửa prefab/scene hoặc code gameplay. Đã lưu lựa chọn WASD/phím mũi tên của người dùng vào D21.

## Nguồn

- Folder trong workspace: TreasureHunter_Export_2026-11-20/.
- Chat đã đọc các lượt liên quan: [Kiểm tra lưu ý khi export package](codex://threads/01a1f739-f65e-7e80-8480-872aba5f5de4). Phạm vi cuối trong chat: bỏ SPUM riêng, lấy Unit/ba bộ mẫu cùng art phụ thuộc, vùng Grass/Undead/White, building/NPC visual; script MMO gốc giữ trong ZIP.
- README_IMPORT.txt, Manifest.json, Verification.json, UnitSpriteBindings.json và VisualPrefabPreview.jpg đi kèm. Đã xem contact sheet76 prefab; đó là ảnh export từ project nguồn, không phải ảnh chạy trong Zatod.

## Kết quả kiểm tra thực tế ở Zatod

- Package7.386.387 byte,656 entry/76 prefab. SHA256 cad7df2caebd69de2f11f95b84c7eb01ea0aeee5ac1bd274c0047ba71b2ad31c khớp Verification.json.
- ZIP nguồn SHA256 khớp; nằm riêng bên ngoài và còn được kèm trong package. Không có file .cs riêng sẽ được compile khi import package visual. Không giải nén ZIP vào Assets.
- Quét GUID/meta và đường dẫn hiện có dưới Unity/Assets: không tìm thấy GUID/path collision với gói. Đây là kiểm tra tĩnh tại thời điểm này, không thay thế kiểm tra danh sách import lúc thực hiện.
- Prefab visual cả gói có0 MonoBehaviour,0 Rigidbody/collider; có Animator/SpriteRenderer/SortingGroup và một số ParticleSystem. Các class ID199 là ParticleSystemRenderer, không được đếm nhầm thành physics.
- Không tìm thấy GUID serialized chưa giải quyết trong tập asset đã quét (trừ reference built-in). Export report còn nêu phụ thuộc URP; source và Zatod hiện cùng Unity6000.6.2f1/URP17.6.0. Chưa chạy import/material/render trong Zatod nên chưa khẳng định runtime không lỗi shader/sorting.
- Gói nằm ở gốc workspace, ngoài Unity/Assets; folder có mặt không có nghĩa Unity đã import gói.
- Bằng chứng đầy đủ: Artifacts/TreasureHunterReview/package-inspection.json.

## Nhân vật dùng làm avatar

Đường prefab trong package: Assets/TreasureHunterVisualExport/Characters/Unit.prefab. Đây là bản visual được tạo từ Unit gốc; không dùng Unit.prefab nguyên MMO bên trong ZIP làm player trực tiếp. Có thêm Unit Basic2/3 để tham khảo ngoại hình, không tạo thêm HeroData hoặc roster chiến đấu từ các preset.

Unit có31 SpriteRenderer và1 Animator, không script/collider, root motion tắt. Controller Assets/Content/Character/Graphics/SPUM_Sprites/Unit/Animation/Unit_Animation.controller có idle, run và các biến thể/animation khác. Khi triển khai dùng wrapper/controller Zatod cho WASD/phím mũi tên, collision, đồng bộ Mirror và input lock modal; điều khiển Animator cho idle/run. Không có yêu cầu tích hợp combat hoặc đổi trang bị avatar lúc này.

OriginalEquipmentScripts.zip là tham khảo cho phase visual equipment sau này. Code gốc phụ thuộc CharacterVisual, PlayerBody/CharacterBody, CharacterBodySprites, CharacterCopySprite, Card, AssetManager/UIManager và dữ liệu MMO. Không tự port vào Zatod, không gán equipment/combat stats của Hero cho avatar. UnitSpriteBindings.json giữ slot index/path nếu cần về sau; một số renderer path có khoảng trắng cuối, không tự trim/đổi hierarchy gốc mà không kiểm tra animation bindings.

## Map, NPC và building

- Có Grass Background, Undead Background, White Background trong Assets/TreasureHunterVisualExport/Environment/Backgrounds/. Mỗi prefab nền chỉ có1 SpriteRenderer với màu vùng đã lưu. Bộ ảnh cây/cỏ/đá/viền nằm trong các dependency được kèm; không phải map đã bố trí hoàn chỉnh và không có code sinh map.
- Có35 prefab building và35 prefab NPC/biến thể, ngoài3 Unit và3 background. Không cần thêm SPUM editor để dùng hình có sẵn.
- Các prefab là visual đã tách. Cần thêm vùng tương tác/collider/world sorting phù hợp Zatod khi dựng map. Cấp building là asset/art có sẵn, không có script tự đổi cấp.
- Gốc source có8 dangling sprite reference ở Event Tournament/Obnit/Merchandise variants; exporter đã dọn trên bản sao và ghi rõ không thêm art thay thế. Đây là giới hạn nguồn đã được báo cáo, không kết luận package mới có missing-script hoặc cần sửa gameplay Zatod.
- Export report kiểm tra reference/native preview ở project nguồn, chưa clean-project import hoặc Player build. Giữ riêng kết quả export và nghiệm thu tích hợp Zatod.

## Bước tiếp theo khi được yêu cầu triển khai

Kiểm tra import list và giữ metadata/GUID; import visual package trước, để ZIP script nguyên trạng. Dùng Unit visual qua wrapper Zatod; tạo map layout/collision/portal/interaction từ asset Grass và Undead; tiếp tục UI và battle D20 hiện có. Thị trấn dùng Grass tạm hoặc White là lựa chọn art còn mở, không ảnh hưởng việc kiểm tra package hiện tại.
