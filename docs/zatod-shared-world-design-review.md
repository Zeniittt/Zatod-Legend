# Zatod — Khảo sát concept Thị trấn và map chương chung

Ngày20/11/2026, D21. Chỉ kiểm tra design/source; không sửa runtime, scene, prefab, importer hoặc config gameplay. Người dùng đang tự import SPUM, prefab main Player và background.

## Yêu cầu được làm rõ

Thị trấn và các map chương đều chung nhiều người, nhìn thấy nhau. Tiến trình là riêng từng người. Chương2 phải có đầy đủ21 ải/63 wave từ Crystal. Người chơi mới spawn Thị trấn; tương tác building Phó bản để tới map chương. Chương1 đồng cỏ xanh, chương2 rừng undead xanh xám; đi qua lại được. NPC/building trên map là điểm mở popup D20. Placement tạm được phép, không tự đặt hệ thống cốt truyện.

Main character SPUM là avatar tài khoản dùng di chuyển world, tách đội HeroData/HeroBattleData hiện có. Không có yêu cầu đưa SPUM vào đội chiến đấu, gán battle stats của Hero cho avatar, hoặc đổi flow combat/checker.

## Hiện trạng đã đọc

- CampaignDefinition có danh sách Chapters; runtime View hiện vẫn chỉ đọc Chapters[0] và viết nhãn18 ải/54 wave. Cần bỏ giả định chương1 khi thực thi, không chỉ thêm JSON chương2.
- Chapter hiện chỉ có Id/Name/Stages, chưa có liên kết world map, spawn/portal hoặc interaction point. Stage.MapX/MapY là tọa độ UI chuẩn hóa0..1, không dùng trực tiếp để đặt NPC/collider trên world.
- CharacterData có CharacterId/HeroDesk/inventory; chưa có avatar world và MapId/Position/ReturnContext. Tiến trình hiện thuộc CampaignRun của session, reset theo launch; không tự thêm save vị trí/progress hoặc đăng ký tài khoản thật.
- ZatodConnection đang là đường kết nối dedicated Mirror cho account/combat; chưa có world avatar replication/movement. Cần thêm lớp world cho các client cùng map, giữ kết nối mạng khi vào/ra combat và không tự đổi stack.
- Mirror source hiện có SceneInterestManagement và MatchInterestManagement. NetworkManager.ServerChangeScene mô tả/triển khai gửi SceneMessage cho tất cả client; không dùng cách đó để teleport riêng một người giữa các map chung. Cách chia scene/map instance chọn lúc thực thi, không cần đổi transport chỉ vì thêm world.
- Chưa thấy thư mục SPUM, prefab main Player hoặc theme mới trong Assets tại thời điểm quét. Không kết luận prefab/controller hoạt động trước khi người dùng import xong.

## Chương2 trong nguồn Crystal

Thường chapter2 có SourceStageId19..39,21 ải/63 wave, enemy level6..11. Stage19 yêu cầu Stage18 và Require Stars1 trong source.

Các định nghĩa địch chưa có trong catalog hiện tại:

-9 Hero:16 Med,22 SP,24 OM,25 SF,27 JUGG,28 Axe,30 ES,36 AV,38 THD.
-4 Monster:103 GlaiveThrower,114 SpellBreaker,120 Tank,121 DragonBaby.

Nếu giữ cách nhập đầy đủ Hero xuất hiện phía địch của D11, catalog sẽ tăng16→25 Hero,10→14 Monster. Không tự cấp các định nghĩa mới vào roster sở hữu5 Hero khởi đầu. Cần kiểm tra skill/buff/item/art phụ thuộc trước khi xác định số asset/trang bị cần thêm.

Raw UI reward chương2 có20 Item ID khác nhau. Các ID chưa có trong catalog hiện tại:114,115,116,117,175 và20555;20555 là vật phẩm điều kiện level81 đã ghi ngoại lệ ở D19. Không gán các tỷ lệ Chest chưa reverse làm tỷ lệ Zatod; drop config theo D19 và phạm vi import mới cần được đối chiếu. Chưa sửa danh sách item hoặc các assert số lượng trong importer ở lượt này.

Theme world do người dùng chọn không bắt buộc giống battle background của chapter2 gốc. Tách world background/theme khỏi background từng wave; hiện chưa có yêu cầu thay art chiến trường.

## Model đề xuất — chưa chốt schema

| Model | Trách nhiệm |
|---|---|
| WorldMapDefinition | MapId, scene/layout/theme, bounds vùng đi và các spawn point |
| WorldInteractionDefinition | ID ổn định, visual/prefab, vị trí, bán kính tương tác, loại feature và TargetId |
| WorldPortalDefinition | Map nguồn/đích và SpawnPointId tương ứng |
| PlayerWorldState | AccountId/entity, map instance hiện tại, vị trí/hướng và điểm quay về trong phiên |
| CampaignChapterDefinition | Tham chiếu WorldMapId; giữ danh sách Stage hiện có |

StageId là định danh ải, NPC/building chỉ là một lối vào. Đổi vị trí/art NPC không đổi StageId hoặc sao đã đạt. Giữ ID chương1 và archive/GUID cũ; SourceStageId giữ tham chiếu nguồn, thứ tự hiển thị của chương2 không phải là ID account/item.

## Lưu ý chức năng và đề xuất

1. Shared world chứa avatar, layout và NPC/building. Sao, stage unlock, cửa sổ preview và đội hình là dữ liệu/UI từng người. Một người thắng không làm NPC biến mất hoặc mở ải cho mọi người; popup của hai người cùng NPC có thể hiện sao khác nhau.
2. Đã chốt bổ sung20/11: đi lại/chuyển map tự do, chưa khóa portal theo tiến trình. Validation navigation mở rộng làm sau. Không tự bỏ checker hoặc prerequisite Challenge hiện có; source stage19 yêu cầu18 không tự áp thành khóa portal world.
3. Gần nhiều điểm tương tác: đề xuất chọn một điểm gần nhất/phù hợp, giữ lựa chọn ổn định để nút không nhấp nháy ở ranh giới. Nút chỉ hiện trong phạm vi; server xác nhận map/điểm tương tác/quyền vào feature khi nhận yêu cầu.
4. Đã duyệt: mở popup/chọn đội khóa input di chuyển của chính người chơi; world của người khác tiếp tục chạy. Battle riêng dùng core hiện có; sau trận về đúng map/điểm tương tác đã vào, giữ return context trong phiên.
5. SPUM prefab cần kiểm tra input/controller, Animator, pivot ở chân, collider, sorting trước/sau building, scale và hướng nhìn. Không gắn2 controller hoặc2 input module cùng xử lý. Project hiện dùng Input System.
6. Background ảnh cần thêm vùng đi được, vật cản, bounds camera, spawn và portal; không suy ảnh phẳng đã chứa collision. Chờ asset để chọn top-down/isometric và cách che khuất phù hợp; không tự cắt/sửa ảnh trong lượt này.
7. World movement cần hiển thị mượt và đồng bộ phù hợp; tick combat8Hz không tự trở thành nhịp vẽ avatar. Chưa chốt tick/send rate/capacity; giữ logic này tách khỏi timing damage/animation combat.
8. Building Clan/Tháp thất lạc là điểm feature, không tự mở rộng thành triển khai Clan, tower, chat, market hay nhiệm vụ. Chức năng chưa có cần để trạng thái chưa triển khai rõ ràng khi làm prototype.
9. Giữ rule reset tiến trình theo launch D11. Việc lưu qua lần mở game, vị trí đăng nhập lại, xác thực tài khoản hoặc chia channel/map capacity chưa được người dùng chốt.

Không cần implementation ở lượt này. Sau khi import xong mới kiểm tra đúng prefab Player chuẩn, background/tiles và building/NPC được cung cấp trước khi đề xuất scene cụ thể.

## Chốt bổ sung và chuẩn bị asset20/11/2026

Main character hiện chỉ phục vụ ngoại hình và di chuyển; không có bộ stats/skill chiến đấu riêng. Người dùng đã duyệt sao/unlock riêng, StageId của điểm tương tác, khóa input khi modal mở và trở về đúng map sau trận. Hai map đi qua lại tự do; chưa mở thêm validation navigation. Vẫn đang brainstorm, chưa sửa runtime.

Asset nên import:

- Gói SPUM cùng các phụ thuộc của prefab chuẩn (sprite, animation/controller, material, script); giữ folder/meta của package. Chỉ rõ prefab Player sẽ dùng; khi thực thi ưu tiên wrapper/variant Zatod thay vì sửa thẳng nguồn vendor.
- Background hoặc tiles cho đồng cỏ và rừng undead; có scene/prefab demo thì giữ để tham chiếu bố cục. Cần nhìn cùng góc với player/building; scale/pivot/collider/sorting sẽ đối chiếu sau import.
- Một số prefab building/NPC/đồ trang trí; không cần39 prefab khác nhau cho39 điểm ải, có thể tái dùng art và cấu hình StageId khác nhau. NPC tĩnh đủ cho bản đầu nếu chưa có animation.
- Có3 khu vực world (Thị trấn +2 chương). Nếu chưa có bộ art thị trấn riêng, đề xuất dùng lại bộ đồng cỏ để dựng khu town; đây là phương án tạm, chưa tự chốt thay người dùng.
- Portal/cổng/biển chỉ đường nếu có; không bắt buộc tìm thêm package riêng trước khi kiểm tra bộ đã import.

Sau import mới kiểm tra prefab, input/Animator, các phụ thuộc render và vùng đi được. Không cần người dùng tự thêm collider hoặc chỉnh lại prefab trước lượt kiểm tra. Không có rào cản thiết kế nào buộc dừng import; gameplay/scene vẫn chưa được triển khai ở lượt này.

## Cập nhật gói tài nguyên20/11/2026

Đã nhận TreasureHunter_Export_2026-11-20 tại gốc workspace, kiểm tra package và đọc chat export người dùng dẫn chiếu. Phạm vi cuối không có SPUM/editor đầy đủ; Unit visual,3 preset, art cần thiết và bộ môi trường/building/NPC đã có. Người dùng chốt WASD/phím mũi tên. Package chưa import vào Zatod. Các ghi chú “chưa thấy asset” ở phần khảo sát ban đầu là lịch sử; hiện trạng/giới hạn: [kiểm tra package](zatod-treasure-hunter-assets-review.md).
