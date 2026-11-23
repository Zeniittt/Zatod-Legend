# Zatod — Khảo sát UI Phó bản và công cụ config

Ngày 19/11/2026. Trạng thái: chỉ khảo sát/brainstorm theo ảnh người dùng, chưa triển khai UI hay đổi runtime. D14 là quyết định đã chốt về tên Zatod; D15 chốt phạm vi HUD/GameEditor sau phản hồi tiếp theo. Các bố cục chi tiết chưa được duyệt vẫn là đề xuất.

## Bố cục quan sát trong ảnh

- Battlefield chiếm phần lớn màn hình ngang, background trải rộng và không có toolbar debug thường trực.
- Góc trên trái: pause và đồng hồ dạng phút:giây. Chính giữa trên: wave hiện tại/tổng wave, ví dụ 2/3. Góc trên phải: bộ đếm vàng và rương/vật phẩm.
- Bên phải battlefield: nút tăng tốc; góc phải dưới có Auto.
- Hàng dưới: portrait đội hình (ảnh có 3 Hero; Zatod cần hỗ trợ 1–5), khung bậc/sao, thanh HP/energy và trạng thái dùng ultimate.
- Trong trận: HP trên actor và số damage/heal/energy nổi. Chữ LAST HIT +300 ENERGY trong ảnh là thông báo chiến đấu; không suy rằng mọi kill của mọi unit đều luôn +300.
- Mảng Prompt ở góc phải dưới trông như overlay công cụ ngoài HUD; chưa có bằng chứng đây là thành phần game nên không đưa vào thiết kế HUD.

## Asset đã xác nhận

Nguồn: `Unity/Assets/Crystal Legend/recovered/assets/install_time_pack/remake/UI/`.

- `alpha/1080P/battle/`: `battle_pause.png`, `battle_auto_bg_1/2.png`, `battle_fastforward_2/3*.png`, `battle_hero_bg.png`, `battle_hero_blood_progress.png`, `battle_hero_energy_progress.png`, `battle_hero_energy_full.png`, `battle_hero_progress_bg.png`, digit/wave separator và `battle_resource_bg*.png`.
- `DOTA-HERO/`: `Coco.jpg`, `DR.jpg`, `Lina.jpg`, `Zeus.jpg`, `Ench.jpg` đều có. Đã xem trực tiếp portrait Lina, pause, khung Hero và thanh HP.
- `alpha/1080P/common/`: có icon gold và chest; chưa coi toàn bộ biến thể là đã ánh xạ/đủ cho mọi trạng thái. Frame bậc/sao sẽ đối chiếu readhero/createIcon khi import.
- Phần lớn các asset HUD này còn ở bộ reference, chưa thành sprite/prefab UI trong Unity. `Resources/UI` hiện chỉ có font; `HeroPortraits` đang chứa portrait pixel cũ. HUD hiện tại chủ yếu dùng màu/chữ tạm và Canvas sinh từ code.
- Nguồn hành vi để đối chiếu: `battle/battle_sceneui.lua`, `battle/battleui/hero_panel.lua`, `battle/battleui/hp_bar.lua`. Timer nguồn dùng `engine.time_limit`; portrait có HP/MP và sự kiện chạm ultimate.

## Phạm vi cập nhật theo D15 và bố cục còn đề xuất

- Giữ uGUI đang dùng. Tạo HUD/panel/prefab Zatod có thể chỉnh và xem trong Editor, chia Battlefield, TopBar, HeroBar, BattleControls và Result; giữ các công cụ dev ở màn riêng thay vì phủ lên battlefield.
- Neo UI theo cạnh, hỗ trợ 16:9 và đội 1–5 Hero; không kéo méo background/portrait hoặc đổi tọa độ logic để vừa HUD.
- Portrait tương ứng đội đang chọn, HP xanh/energy vàng, full-energy highlight; bấm portrait gửi cùng yêu cầu ultimate hợp lệ đang dùng. Chết/khống chế/thiếu năng lượng có trạng thái rõ ràng.
- Timer đếm thời gian còn lại từ core wave, không dùng tổng tick elapsed hiện đang vẽ. Wave hiển thị từ dữ liệu trận, không hardcode 3.
- Đã chốt: damage/heal/energy nổi lấy kết quả combat thật. Hướng kỹ thuật đề xuất là event presentation, không tính damage trong animation hoặc suy mọi tác động từ một chênh lệch HP tổng hợp.
- Đã chốt có Auto thật: phát yêu cầu ultimate hợp lệ và giữ log/checker. Đòn thường vốn đã tự đánh, nên Auto không đồng nghĩa bật/tắt đòn thường. Chưa có nút Auto Phó bản trong runtime hiện tại.
- Đã chốt **chưa thêm pause/tăng tốc Phó bản**. Các điều khiển replay hiện có giữ nguyên. Ghi chú cho phase sau: core live dùng unscaledDeltaTime nên đổi Time.timeScale đơn lẻ không đủ; không tự áp pause/tăng tốc Phó bản lên PvP online.
- Đã chốt dựng UI vàng/rương với giá trị cố định **0**, chưa nối code phần thưởng/economy. Thay đề xuất ẩn trước đó; không coi số 0 này là dữ liệu reward thực.

## Config hiện tại và khả năng tìm thấy

| Dữ liệu | Điểm vào đang có |
|---|---|
| Hero | Zatod → Heroes → Hero Balance → tab Heroes |
| Monster | Zatod → Monsters → Monster Balance (mở tab Monsters) |
| Item | Zatod → Heroes → Hero Balance → tab Items |
| Stats, skill, buff | Cùng cửa sổ, tab Stats / Skills / Buffs |
| Chương/ải/wave/hook | Zatod → Crystal → Chapter and Wave Balance |

Các bảng nằm tại `Unity/Assets/Zatod/Resources/Data/{Stats,Items,Skills,Heroes,Monsters,Buffs,CrystalCampaigns}.txt`, là JSON `.txt`, không phải ScriptableObject gắn trên prefab. Editor có Validate, Save all config, foldout từng entry và preview stat breakdown. Thay config cần nạp lại/rebuild client/server như hướng dẫn hiện tại; chưa có hot reload server.

Người dùng đã chọn menu/cửa sổ **GameEditor** có các tab riêng Heroes / Monsters / Items / Stats / Skills / Buffs / Campaign, thay đề xuất Config. Chưa triển khai. Đề xuất về UX: cho thấy tên Hero/item bên cạnh ID và phát hiện dữ liệu ngoài cửa sổ thay đổi.

## Vì sao cửa sổ hiện tại không có Hero mới (đã xác nhận)

Đọc trực tiếp Editor đang chạy: cửa sổ Hero Balance tab Heroes, `hasUnsavedChanges=false`, sourceDocuments đã có cache; draft có 24 Hero, 7 Monster, 2 Item, entry cuối berthaxe, version kết thúc `berthaxe-1`. File trên đĩa có 40 Hero (24 cũ + 16 import), 17 Monster (7 cũ + 10 import), 69 Item (2 cũ + 67 import), version thêm `six-hero-reach-1-crystal-p1`.

`HeroBalanceWindow.CreateGUI` chỉ đọc file khi sourceDocuments==null; draftJson/sourceDocuments được SerializeField nên bản cũ có thể tồn tại qua reload Editor. `ReloadIfClean` có định nghĩa nhưng chưa thấy nơi gọi. Nút Reload files đọc lại file và dựng lại danh sách. `HeroConfigFileStore.Save` đã chặn ghi khi file khác expected cache, nên bản nháp cũ không được âm thầm ghi đè file mới.

Workaround để người dùng tự xem: bấm Reload files (lượt kiểm tra này không có draft chưa lưu), rồi tab Heroes sẽ có các entry từ index 24: crystal_1/Coco, 25: crystal_2/DR, 26: crystal_3/Lina, 27: crystal_4/Zeus, ... 39: crystal_45/Ench. Nhãn entry hiện ưu tiên ID nên tên hiển thị cần cải thiện. Không cần import lại hoặc xóa bộ Hero cũ. Chưa tự reload, sửa code hay runtime config trong lượt khảo sát. Xem BUG-012.

## Ranh giới đổi tên

D14 yêu cầu tên project là Zatod. Trước hết rà các chữ lộ trên UI/menu/window; tiếp theo scene/prefab/class/tool/build phù hợp. ID như crystal_*, resource paths, rules string, PlayerPrefs/profile keys và archive readers cần migration/tương thích có kiểm tra. Không đổi GUID món đồ, không viết lại lịch sử hấp thụ, không xóa source/pixel/archive cũ.
