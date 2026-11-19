# Zatod Legend — Thiết kế đã thống nhất

Cập nhật: **19/11/2026, Asia/Saigon**.

Đây là nguồn quyết định chung của project. Mỗi chat cần đọc file này trước khi làm việc và cập nhật khi người dùng chốt thêm. Đồng ý về thiết kế không đồng nghĩa thay đổi đó đã được triển khai hoặc được yêu cầu triển khai ngay.

## Quyết định đã chốt

### D01 — Ghi nhớ và kiểm tra thiết kế

- Ghi lại các quyết định đã chốt trong file này; không chỉ giữ trong context hội thoại.
- Trước mỗi nhiệm vụ, đối chiếu quyết định liên quan. Nếu một thay đổi sẽ phá quyết định, báo rõ phần xung đột và cùng người dùng brainstorm trước khi thực hiện phần đó.
- Chỉ dẫn mới, rõ ràng của người dùng có thể thay quyết định cũ; cập nhật quyết định và không hỏi lại việc đã được cho phép.
- Tách riêng các đề xuất chưa chốt và các chi tiết backend chưa có bằng chứng.
- Bổ sung đã chốt 19/11/2026: duy trì `ChangeLog.md` cho mọi vấn đề phát hiện/xử lý, gồm triệu chứng, nguyên nhân, cách sửa, trạng thái và bằng chứng để tra lại khi tái diễn. Đọc các mục liên quan trước khi sửa lỗi. Đã thêm quy tắc vào AGENTS.md; lịch sử kỹ thuật không thay thế quyết định thiết kế trong file này.

### D02 — Stack và bộ mô phỏng dùng chung

- Project tiếp tục dùng Unity và Mirror.
- Giữ combat core C# thuần, có thể dùng chung cho client, server/checker và công cụ kiểm tra.
- Đối chiếu source khi triển khai: battle_engine.lua đặt tick_interval=0.125, tức 8 Hz. Mô phỏng Crystal mới dùng nhịp này; bộ prototype/replay cũ 20 Hz giữ nhánh tương thích, không áp hằng số cũ sang flow Crystal.
- Hình ảnh và callback Animator không quyết định damage. Logic chiến đấu thực thi các mốc của timeline; phần hình ảnh thể hiện cùng tiến trình.

### D03 — Ba chế độ tham khảo concept Crystal Legends

Đã triển khai các luồng prototype dưới đây; trạng thái kiểm chứng/build cuối theo mục triển khai và `docs/crystal-phase-implementation.md`:

| Chế độ | Hướng đã thống nhất |
|---|---|
| Phó bản | Client mô phỏng và ghi input theo tick; cuối trận gửi kết quả cùng nhật ký để server chạy lại validate. Người dùng chấp nhận kiểm chứng cuối trận ở prototype. |
| Arena tự động | Hai đội, seed và dữ liệu đầu trận xác định diễn biến; dùng mô phỏng xác định và hỗ trợ replay theo đầu vào. |
| PvP RealTime | Gửi và đồng bộ input hai phía ngay trong trận theo tick; không chờ cuối trận mới trao đổi thao tác. |

Ngày 19/11/2026, người dùng chốt: trước mắt giữ rule Crystal đã xác nhận được từ source, chưa tự cải tiến chính sách input trễ, chờ tick hay mất kết nối. Khi đi sâu từng feature mới xem xét cải tiến. Phần source/backend chưa rõ phải ghi là chưa xác minh, không tự khẳng định một rule là của Crystal.

Không khẳng định backend Crystal tính xong Arena trước phản hồi Start: thời điểm gọi checker của backend gốc chưa được xác nhận. Thiết kế lịch sử input hợp lệ không tự chứng minh đó là lịch sử thao tác thật; các biện pháp bổ sung chưa được chốt.

### D04 — Nguồn Crystal Legends và asset

- Giữ nguyên bộ nguồn tham chiếu tại `Crystal Legend/`, ngoài `Unity/Assets`. Bản gốc trên ổ C: được giữ lại.
- Chuyển/import từng phần cần dùng vào project Unity theo từng bước; không tự xóa Hero pixel hoặc tài nguyên hiện có.
- Tận dụng asset Crystal cho assignment. 314 container đã xuất bao gồm Hero, skin và NPC, không phải 314 Hero độc lập.
- Giữ source raw, dấu vết reverse và báo cáo để đối chiếu. Chưa có toàn bộ backend hay công cụ authoring gốc của Crystal.

### D05 — Stats trực tiếp, balance prototype

- **Không dùng STR, AGI, INT làm ba thuộc tính phát triển của Zatod.** Dùng trực tiếp HP, công vật lý, sức mạnh phép, giáp, kháng phép và các stat chiến đấu cần thiết.
- Trước mắt dùng config Crystal làm nguồn tham chiếu balance cho prototype. Sau khi prototype ổn sẽ xây balance riêng; chưa coi số liệu tham chiếu là balance cuối.
- Khi chuyển dữ liệu phải chuyển cả đóng góp/tăng trưởng từ STR/AGI/INT sang stat trực tiếp. Không chỉ xóa các cột làm mất HP/AP/AD/giáp. Skill, item hoặc buff phụ thuộc ba thuộc tính này cần ánh xạ hoặc thiết kế lại tương ứng.
- Bộ 65 thuộc tính combat lõi của Crystal là nguồn tham khảo; thêm stat từ từ khi engine thực sự hỗ trợ, không thêm toàn bộ một lần chỉ để có field.

Bổ sung đã chốt ngày 19/11/2026 khi triển khai: skill làm chậm thứ ba của Sniper (source 103, mở ở Xanh Dương) dùng tỷ lệ AD trực tiếp của caster/target thay cho tỷ lệ AGI gốc. Giữ hệ số tăng theo tỷ lệ ×1,1 khi tỷ lệ >1, giới hạn 2,5 và giảm dần MSPD/HAST theo thời gian còn lại. Đây là thay đổi balance có chủ đích để phù hợp việc bỏ AGI, không gắn nhãn là công thức Crystal nguyên bản. Đã triển khai và có kiểm tra cap/decay.

### D06 — Giữ cơ chế HAST và MSPD

- Giữ hai cơ chế riêng: `HAST` điều chỉnh tốc độ bộ đếm cooldown; `MSPD` điều chỉnh tốc độ động tác, tiến trình thi triển và di chuyển theo cơ chế Crystal.
- Tốc độ hình ảnh và mốc tác động phải theo cùng tiến trình động tác. Không tăng tốc animation riêng mà giữ nguyên lịch damage.
- Trong đường chung Crystal, buff/projectile dùng thời gian trận và quy tắc riêng, không mặc định nhân theo MSPD.
- `CDR` của Crystal là giảm tiêu hao năng lượng, không phải tên khác của HAST.
- Làm rõ ngày 19/11/2026: giữ việc MSPD ảnh hưởng cả động tác và di chuyển; không tự tách ảnh hưởng di chuyển ra khỏi MSPD. Phương án tách trước đó là đề xuất của agent, không phải quyết định của người dùng. Các quy tắc đặc thù được đối chiếu theo source Crystal khi chuyển từng cơ chế.

### D07 — Config và dữ liệu Hero

- Giữ config JSON trong file `.txt`, có Editor balance. Các bảng được tách và hiển thị theo tab; giữ tên stat `damage`, `defense` đã chọn thay vì tự đổi về tên cũ.
- Giữ ba lớp: `HeroDefinition` (config), `HeroData` (tiến trình sở hữu), `HeroBattleData` (bản dữ liệu riêng của trận).
- Đồng ý ngày 19/11/2026: gom phần config combat chung của Hero/quái vào `CombatantDefinition`; `HeroDefinition` và `MonsterDefinition` giữ phần riêng. Giữ `CombatantBattleData` dùng chung hiện có. Không thêm `MonsterData` chứa tiến trình sở hữu/trang bị cho quái wave. Hero phía địch dùng lại HeroDefinition và tạo HeroBattleData từ thông số encounter, không nhân bản thành một định nghĩa Monster khác. Các model đã refactor trong phase prototype.
- `CharacterData.HeroDesk` là `List<HeroData>`. Save giữ ID config và tiến trình, không đóng đinh tổng stats hoặc sao chép nguyên config vào từng Hero.
- Tên đã chốt gồm `HeroData`, `HeroBattleData`, `Currencies` dưới dạng danh sách Currency. Inventory tối thiểu theo D12 đã được bổ sung vào phạm vi; không tự mở rộng sang Quest, Market hoặc các hệ thống kinh tế khác.
- Buff/debuff của màn và trận không ghi ngược vào config hoặc tiến trình Hero.
- Level, sao và bậc là các trục riêng. Prototype giữ công thức tăng trưởng source, chuyển sang stat trực tiếp; tổng hợp dùng decimal và snapshot/simulation dùng double. Chưa làm vòng farm EXP/nâng sao đầy đủ.

### D08 — Trang bị, hấp thụ và tiến bậc

- Giữ ID loại item thực tế đã mặc/hấp thụ. Theo bổ sung D12, mỗi món mới còn có GUID riêng; lịch sử hấp thụ giữ bậc, ID ô, ItemId và GUID món nguồn. Mỗi món là một instance, không gộp stack; field số lượng trong dữ liệu cũ không được dùng để biến một GUID thành nhiều món.
- Tính stats từ config đang áp dụng: base + bonus bậc độc lập + item đã hấp thụ + item đang mặc, rồi các nguồn khác được thiết kế rõ ràng. Không cộng trùng cùng một nguồn.
- Ví dụ đơn giản đã thống nhất: base 5 + một rìu đã hấp thụ 5 + hai rìu đang mặc 5 = 20. Đổi base thành 3 và mỗi rìu thành 10 thì tính lại thành 33.
- Đổi chỉ số item áp dụng cho các reference hiện có. Đổi recipe rìu sang kiếm không tự đổi item đã hấp thụ hoặc món đã mặc; ô trống dùng yêu cầu mới. Muốn chuyển lịch sử cũ cần quy tắc migration riêng cho trường hợp cụ thể.
- Bậc có ID ổn định, ô trang bị riêng và bậc tiếp theo; không dựa vào index hoặc enum màu để suy tiến trình. Hỗ trợ chèn bậc trung gian về sau.
- Khởi đầu Trắng mở ultimate; Xanh Lá, Xanh Dương, Tím mở các skill tiếp theo. Cách mở thực tế dựa vào config bậc. Danh sách slot skill có thể mở rộng về sau.
- Khi tiến bậc, chuyển trang bị đang mặc vào lịch sử hấp thụ và làm trống bộ ô tiếp theo. Một món không được tính ở cả hai nơi.
- Không nhập nguyên tổng UnitRank của Crystal rồi cộng lại các item hấp thụ nếu chúng đại diện cho cùng đóng góp. Nguồn tạo UnitRank gốc chưa được khôi phục.

### D09 — Buff là hệ thống trạng thái riêng

- Dùng nền buff có vòng đời riêng: thời lượng, tick tác động, stack/refresh/replace, dispel, mất khi chết, modifier/khống chế/shield.
- Skill có thể tạo buff tại sự kiện tác động; không phải mọi effect đều bắt buộc là buff.
- Tham khảo cơ chế Crystal, bổ sung dần; chưa yêu cầu port toàn bộ module buff đặc thù.
- Chưa chốt toàn bộ schema skill, buff hoặc cách mở rộng cơ chế riêng của Hero.

### D10 — Không gian và hình ảnh

- Dùng mô hình vị trí mặt đất hai chiều và độ cao riêng cho các cơ chế cần thiết, hiển thị bằng sprite 2D. Không tiếp tục coi chiều sâu luôn chỉ là trang trí nếu cần tái hiện AoE Crystal.
- Tham khảo Crystal: có kiểm tra AoE hai chiều và projectile có height/zSpeed/trọng lực; một số va chạm dùng quy tắc giản lược. Không mặc định đây là mô phỏng vật lý 3D đầy đủ.
- Frame-by-frame đã dùng trong prototype: bake sprite từ FCA, giữ pivot/FPS, sample clip theo timeline của core và nội suy khi hiển thị; Animator callback không tính damage.
- Giữ FPS, pivot, scale, tọa độ logic, layer, thứ tự và thời lượng khi chuyển animation. Không để thay ảnh/skin tự đổi tầm đánh hay lịch damage.
- Chốt ngày 19/11/2026: giữ flow skill/animation của Crystal khi chuyển Hero, trong phạm vi các thay đổi đã thống nhất ở trên. Giữ các mốc thi triển, phát đòn, tạo effect và áp dụng tác động theo từng loại skill; không tự thêm thời gian chờ vì ví dụ diễn giải của người dùng.
- Với đường chain đã đọc, tác động xảy ra ngay trong lần jump và hiệu ứng được tạo cùng sự kiện; không thêm yêu cầu chờ hiệu ứng kết thúc hoặc chờ một mốc chạm mới. Với projectile có kiểm tra va chạm, giữ điều kiện tác động của projectile. `AnimAtkFrame` là mốc phát đòn, không thay thế mọi điều kiện impact. Các đường chain/projectile này đã triển khai và có kiểm tra mốc tác động trong prototype.
- Bổ sung 19/11/2026 sau chơi thử: người dùng yêu cầu sửa giật chuyển động Hero/projectile. Đã triển khai cập nhật presentation mỗi render frame theo vận tốc và độ cao giữa các tick, tham chiếu actor/projectile của Crystal; giữ core 8 Hz, tốc độ config, va chạm/damage và input replay. Replay cũng vẽ giữa các tick; không dùng tăng tốc config để che giật. Đã kiểm tra core/Editor/pause/seek/replay x1/x4, build Windows và hai client executable; archive trước sửa giữ kết quả. Theo dõi BUG-001 trong ChangeLog.md và báo cáo triển khai.

### D11 — Phạm vi prototype tiếp theo

Ngày 19/11/2026, người dùng xác định và tiếp tục điều chỉnh mục tiêu phase:

- Hoàn thành logic Phó bản, Arena tự động và PvP realtime theo D03.
- Import bộ 5 khởi đầu Coco (1), DR (2), Lina (3), Zeus (4), Ench (45) và chương đầu tiên, gồm địch, ải và wave. Bổ sung cả các Hero xuất hiện phía địch dưới dạng Hero đầy đủ, không chỉ tạo bản quái thay thế. Việc import định nghĩa không tự cấp toàn bộ các Hero bổ sung vào HeroDesk khởi đầu.
- Bổ sung lớp wave. Chương 1 Thường có 18 ải/54 wave; đây là phạm vi đang dùng để đối chiếu. Tinh Anh có thêm 6 ải/18 wave và để phase sau cùng các hệ thống phụ.
- Giảm mục tiêu tiến bậc từ Tím+4 xuống Xanh Dương. Hiểu Xanh Dương thường là rank 4 của Crystal, gồm đường Trắng → Xanh Lá → Xanh Lá+1 → Xanh Dương; không tự mở rộng sang Xanh Dương+1/+2. Đã triển khai đường bậc này trong prototype.
- Chưa làm lưu tiến trình phó bản. Mỗi lần mở game bắt đầu lại từ ải đầu; tiến trình trong một lần chơi chỉ giữ trong bộ nhớ. Không khôi phục clear/unlock của lần chơi mới từ replay/archive cũ. Không xóa archive cũ hoặc suy rộng thành reset toàn bộ Hero/item.
- Phạm vi đã được duyệt và yêu cầu thực thi ngày 19/11/2026. Giữ ranh giới Definition/Data/BattleData; trạng thái thực tế ở mục triển khai, không coi các hệ thống ngoài phase là đã được yêu cầu làm.

Kết quả khảo sát và đề xuất: [model Crystal và phạm vi prototype](docs/crystal-prototype-model-review.md). Hợp bộ 5 và các Hero địch chương 1 Thường là 16 Hero; thêm 10 loại quái thường. Config trang bị rank 1–4 của 16 Hero dùng 67 loại item trực tiếp, 108 loại khi tính cả nguyên liệu recipe đệ quy. Theo chốt bypass craft, phạm vi cấp đồ/tiến bậc hiện chỉ cần 67 loại trang bị trực tiếp; 41 loại nguyên liệu bổ sung là tham chiếu cho craft về sau. Đây là số loại, không phải số instance. Phạm vi 67 loại trực tiếp đã nhập Unity; 41 nguyên liệu bổ sung để phase craft sau.

### D12 — Mỗi item có GUID riêng, không stack

Chốt ngày 19/11/2026, thay cho đề xuất kho kiểu ItemId + Quantity:

- Phân biệt ItemId của loại/config item và `Id` của từng món vật phẩm. `Id` là string biểu diễn GUID; hai món cùng ItemId phải có Id khác nhau. GUID thuộc instance, không phải một GUID chung đặt ở dòng ItemDefinition.
- Mỗi món là một phần tử/slot riêng trong kho, không stack, kể cả hai món cùng loại. Chưa chốt dung lượng tối đa hay bố cục UI kho.
- Mặc hoặc chuyển vị trí của cùng một món phải giữ GUID. Khi làm craft ở phase sau, craft tiêu hao các instance nguyên liệu cụ thể và tạo instance mới cho sản phẩm. Món đã hấp thụ không còn là vật phẩm còn sở hữu để mặc/trade; lịch sử nguồn vẫn giữ theo D08.
- Mục đích GUID là chuẩn bị khả năng phân biệt vật phẩm cho Market về sau; chưa yêu cầu xây Market/trade ở phase này.
- Bổ sung hàm dev cấp item theo ItemId; tham số số lượng nếu có sẽ tạo bấy nhiêu instance với GUID riêng, không tạo một stack. Đi qua thao tác thêm kho có kiểm tra ItemId để dùng thử đường mặc/tiến bậc. Hàm AddItemByItemId đã được triển khai và kiểm tra qua Mirror.
- Chốt bổ sung: phase hiện tại bỏ qua craft từ món thấp lên món cao. Hàm dev cấp trực tiếp item đích theo ItemId, không cần nguyên liệu hoặc phí craft; vẫn giữ điều kiện mặc đồ/tiến bậc bình thường. Chưa làm hệ thống craft, phù phép, Market hay các hệ thống phụ khác.
- Công cụ test bổ sung dần theo nhu cầu; chưa yêu cầu xây trọn bộ công cụ chỉnh level/skill hoặc cấp EXP ngay.
- C# hiện dùng ItemData { Id, ItemId }, EquippedItemData và AbsorbedItemData có GUID nguồn; đã kiểm tra kho/mặc/hấp thụ. Chưa có migration tự động cho kho stack cũ có dữ liệu thật; không tự viết lại dữ liệu cũ.

### D13 — Hook và balance ải

Đồng ý ngày 19/11/2026: giữ hook theo ải/wave và hỗ trợ tùy chỉnh để cân bằng encounter về sau.

- Dữ liệu ải/wave và tham số hook phải chỉnh được qua config/Editor; phần handler thực thi luật nằm trong combat core dùng chung cho client, checker và replay.
- Bắt đầu bằng hành vi và tham số Crystal đã đối chiếu. Việc cho chỉnh không đồng nghĩa tự balance lại các ải ngay khi chuyển dữ liệu.
- Phân biệt thay tham số của cơ chế sẵn có với thêm cơ chế hoàn toàn mới: cơ chế mới có thể cần handler mới trong code chung. Không hứa config biểu diễn được mọi hành vi tùy ý.
- Khi bắt đầu trận, dùng cùng dữ liệu/rules đã chốt cho toàn bộ trận và replay đó; chỉnh balance không thay đổi âm thầm dữ liệu của trận đang chạy.
- Hook có handler/selector/amount trong WaveDefinition và Editor authoring; snapshot rules/config/wave/hook được giữ trong input archive của từng trận.

## Bản tổng hợp phase đã được duyệt

Người dùng đã duyệt toàn bộ bản tổng hợp cùng hai lưu ý về chuyển stats và giới hạn source backend, rồi yêu cầu thực thi ngày 19/11/2026. [phase-crystal-prototype-scope.md](docs/phase-crystal-prototype-scope.md) là checklist triển khai. Không yêu cầu xác nhận lại các bước trong phạm vi; chỉ báo xung đột thiết kế hoặc khoảng trống source cần quyết định mới. Trạng thái thực tế được cập nhật tại [crystal-phase-implementation.md](docs/crystal-phase-implementation.md).

## Trạng thái triển khai cần phân biệt với thiết kế đích

Cập nhật 19/11/2026: **đã hoàn thành triển khai và kiểm tra phase prototype trong phạm vi được duyệt**. Build Windows cuối thành công, không có lỗi build; executable cuối đã qua Phó bản, Arena, PvP hai client và reset ải/giữ dữ liệu sở hữu. Báo cáo chuẩn: [crystal-phase-implementation.md](docs/crystal-phase-implementation.md).

- Đã nhập 16 Hero, 10 quái, 67 loại trang bị, 18 ải/54 wave; inventory GUID, dev cấp đồ, tiến bậc tới Blue và model dùng chung.
- Client/checker/input replay và ba mode Mirror đã chạy thực tế. Executable cuối: hai client cùng digest 13622350145935873978 với 8 input; lượt PvP có UI cũng khớp replay. Launch mới reset ải, giữ 24 cặp GUID/ItemId của Lina Blue. Bằng chứng cuối: `Artifacts/CrystalPhaseChecks/network-20261119-185731/results.txt`.
- 102 tài nguyên / 8.867 sprite / 358 clip đã kiểm tra geometry/pivot/FPS/loop/action. Giữ nguồn pixel/scene/archive cũ; runtime Crystal có scene và hướng dẫn riêng.
- Hai sound reference không có trong nguồn và giới hạn native/backend được ghi rõ trong báo cáo; không suy rằng đã khôi phục toàn bộ game/backend.

## Những phần để phase sau hoặc cần bàn tiếp

- Cơ chế đặc thù ngoài các Hero/bậc/wave đang dùng, skin/shard/awakening và schema mở rộng khi có feature mới.
- Backend production, xác thực, Market/trade, reconnect/timeout hoặc netcode cải tiến; không tự coi server prototype là bằng chứng về backend Crystal.
- Migration kho stack có dữ liệu thật, tiến trình/rank mới, nguồn cấp Hero bổ sung, farm level/sao và kinh tế.
- Tương thích rules cho replay qua các lần thay code mô phỏng sau này; trong cùng rules, snapshot dữ liệu giữ balance cũ. Archive outcome cũ vẫn có nhánh đọc riêng.
- Không đưa lại thành câu hỏi các điểm đã chốt: bỏ STR/AGI/INT, giữ HAST/MSPD, flow skill Crystal, Sniper dùng AD, item GUID không stack, bypass craft, 54 wave và reset ải theo launch.

## Bằng chứng kỹ thuật để tra lại

Gốc Lua: `Crystal Legend/recovered/scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data/`.

- `battle/unitattribs.lua`: danh sách 65 thuộc tính và chuyển đổi STR/AGI/INT của bản gốc.
- `battle/unit.lua`: MSPD -> dt_action; HAST -> dt_cd; init skill, damage và buff.
- `battle/actor.lua`: nhận hệ số tốc độ từ model để phát puppet.
- `battle/skill.lua`: resolve SkillGroup/Skill; dựng phase từ AnimDuration/AnimAtkFrame; Attack -> projectile/chain/region/tác động.
- `battle/chain.lua`: tạo chain gọi jump; jump gọi takeEffectOn trước khi tạo hiệu ứng chain. Không có yêu cầu chờ hiệu ứng bay chạm đích ở lần jump này.
- Lina: `atk` dài 1,333333 giây, Attack 0,625; `ult` dài 2,25 giây, Attack 1,541667 (thời gian action gốc, chưa suy thành thời điểm thực ở mọi trạng thái).
- AnimDuration/AnimAtkFrame là dữ liệu điều phối timeline, không tự bảo đảm hình và HP không lệch nếu player, quy tắc impact hoặc clock hiển thị khác nhau. Chưa quan sát game gốc chạy để kết luận một lỗi hình ảnh thực tế.
- `battle/buff.lua`, `battle/battle_tick.lua`, `battle/battle_check.lua`: lifecycle buff, đồng bộ input và kiểm chứng.

Tham khảo thêm: [ghi chú reverse và hai chat](docs/crystal-legends-reference.txt), [Hero data](docs/hero-data.md), [Campaign hiện tại](docs/campaign.md). Tài liệu lịch sử có thể mô tả prototype cũ; đối chiếu trạng thái trong code và file này.
