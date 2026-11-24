# Zatod Legend — Thiết kế đã thống nhất

Cập nhật: **24/11/2026, Asia/Saigon**.

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
- Đối chiếu source khi triển khai: battle_engine.lua đặt tick_interval=0.125, tức8Hz. Mô phỏng Crystal dùng nhịp này. Nhánh prototype/replay trướcCrystal20Hz đã được loại theoD33 ngày22/11/2026; không áp hằng số cũ sang flowCrystal.
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

- **Quyết định mới nhất 24/11/2026:** giữ reference tại `Unity/Assets/Crystal Legend/`; người dùng đã hủy phương án chuyển ra ngoài Assets. Thao tác chuyển vừa hoàn tất đã được hoàn trả, đối chiếu đủ 96.077 file giữ nguyên inode/kích thước/mtime. Không đổi resolver/Gitignore hoặc dọn cache theo phương án đã hủy. D35 còn chờ giải quyết dung lượng để kiểm Editor và build IPA.
- **Trạng thái riêng clone Mac ngày 24/11/2026:** sau lượt dọn phần tải dở, người dùng yêu cầu kéo đủ 28 commit và tự xử lý conflict. Đã cập nhật main từ `0eb6bb073` tới `46d197182`, có đủ 96.077 file reference tại `Unity/Assets/Crystal Legend/`, không khác Git. Giữ source Zatod, tài liệu brainstorm và quy tắc build D37 khi gộp các chỉnh sửa local. 38 source khớp manifest sau quy đổi LF → CRLF trong bộ nhớ để đối chiếu; không sửa file nguồn. Chưa chạy Unity import/build hoặc triển khai D35; xem REVIEW-013.
- **Vị trí hiện hành từ23/11/2026:** người dùng đã di chuyển bộ nguồn tham chiếu vào `Unity/Assets/Crystal Legend/` tính từ repository root; từ thư mục projectUnity là `Assets/Crystal Legend/`. Thư mục root cũ không còn. Chỉ dẫn mới này thay yêu cầu đặt ngoàiUnity/Assets trước đây; giữ nguyên dữ liệu raw và bản gốc trên ổC, không tự di chuyển lại.
- Đây vẫn là bộ nguồn reverse/tham chiếu, không phải toàn bộ nội dung đã được cấu hình hoặc nghiệm thu để dùng trong game. Vị trí nằm trongAssets có thể được Unity quét/import; lượt cập nhật tài liệu này chưa chạyEditor/build hoặc xác nhận kết quả import. Ruleignore `/Crystal Legend/` cũ không khớp vị trí mới. **Cập nhật bàn giao23/11:** đã commit/push96.077 file reference lênmain theo26 lô; clone main đã có source/asset giải nén, trừ các file local được nêu dưới đây. Đã kiểm danh sách tracking và hash38source theo manifest; chưa nghiệmthu Unityimport toàn bộ folderraw.
- Các script import/bake hiện còn đường dẫn root cũ. Agent cần đọc vị trí hiện hành và cập nhật resolver trước khi chạy helper; task tài liệu này chưa sửa script hoặc configruntime.
- **Bổ sung23/11/2026 theo yêu cầu người dùng:** `.gitignore` loại đúng3 file lớn đã báo: browser `chrome-headless-shell.exe` trong `.recovery-deps/browsers/chromium_headless_shell-1234/chrome-headless-shell-win64/`, `install_time_pack.apk` và `recovered/downloads/aab_1.1.100312.zip` dưới reference mới. Giữ các file local, không ignore cả thư mục Crystal hoặc phần source/asset đã giải nén. Helper còn đọc ZIP phải được đổi sang thư mục giải nén hoặc nhận archive riêng khi cần, theo ghi chú bàn giaoD35.
- **Ngoại lệ bàn giao23/11:**3 bản giải mã `network_diagnosis` trong `recovered/scripts/custom_bytecode`(.abc), `lua`(.lua), `lua51_bytecode`(.luac) chứa khóa cloud bên thứ ba và bịGitHub push protection phát hiện; đã ignore đúngpath, giữlocal, không đưa lênGit. Không phải đầu vào D35. Không bypass secret scanning; xem REVIEW-011.
- Chuyển/import từng phần cần dùng vào project Unity theo từng bước; không tự xóa Hero pixel hoặc tài nguyên hiện có. Bổ sung 19/11/2026: D16 cho phép loại định nghĩa cũ khỏi các bảng config hoạt động khi triển khai dọn dữ liệu; không suy rộng thành xóa asset/reference hoặc viết lại lịch sử sở hữu.
- Tận dụng asset Crystal cho assignment. 314 container đã xuất bao gồm Hero, skin và NPC, không phải 314 Hero độc lập.
- Giữ source raw, dấu vết reverse và báo cáo để đối chiếu. Chưa có toàn bộ backend hay công cụ authoring gốc của Crystal.

### D05 — Stats trực tiếp, balance prototype

- **Không dùng STR, AGI, INT làm ba thuộc tính phát triển của Zatod.** Dùng trực tiếp HP, công vật lý, sức mạnh phép, giáp, kháng phép và các stat chiến đấu cần thiết.
- Trước mắt dùng config Crystal làm nguồn tham chiếu balance cho prototype. Sau khi prototype ổn sẽ xây balance riêng; chưa coi số liệu tham chiếu là balance cuối.
- Khi chuyển dữ liệu phải chuyển cả đóng góp/tăng trưởng từ STR/AGI/INT sang stat trực tiếp. Không chỉ xóa các cột làm mất HP/AP/AD/giáp. Skill, item hoặc buff phụ thuộc ba thuộc tính này cần ánh xạ hoặc thiết kế lại tương ứng.
- Bộ 65 thuộc tính combat lõi của Crystal là nguồn tham khảo; thêm stat từ từ khi engine thực sự hỗ trợ, không thêm toàn bộ một lần chỉ để có field.
- **Chốt sửa thiết kế22/11/2026 trong phase Inventory:** bỏ đóng góp stats riêng theo Hero trên item (`ItemDefinition.HeroStats`), giữ các stats trực tiếp chung của item. Đây là ngoại lệ có chủ đích đối với việc giữ đủ phần quy đổi thuộc tính chính từ Crystal phía trên; không chuyển bonus riêng thành bonus chung hoặc bù vào base Hero. Ví dụ Boxing Gloves giữ HP54/giáp0.45, bỏ damage3 riêng cho nhóm Hero. Theo D08, config mới áp dụng khi tính lại cả đồ đang mặc và đã hấp thụ; giữ ItemId/GUID/lịch sử, không reset Hero. Snapshot trận/replay cũ giữ dữ liệu đã chụp. **Trạng thái:** đã triển khai22/11/2026 trong D31: calculator/UI/config/importer cùng bỏ bonus riêng, core và replay archive đã kiểm tra; không cộng bù base.

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
- Giảm mục tiêu tiến bậc từ Tím+4 xuống Xanh Dương. Hiểu Xanh Dương thường là rank 4 của Crystal, gồm đường Trắng → Xanh Lá → Xanh Lá+1 → Xanh Dương; không tự mở rộng sang Xanh Dương+1/+2. Đã triển khai đường bậc này trong prototype. **Mục tiêu phase mới được người dùng mở tới Tím thường ngày23/11/2026 tạiD34; runtime hiện tại vẫn mới tới Xanh Dương.**
- Chưa làm lưu tiến trình phó bản. Mỗi lần mở game bắt đầu lại từ ải đầu; tiến trình trong một lần chơi chỉ giữ trong bộ nhớ. Không khôi phục clear/unlock của lần chơi mới từ replay/archive cũ. Không xóa archive cũ hoặc suy rộng thành reset toàn bộ Hero/item.
- Phạm vi đã được duyệt và yêu cầu thực thi ngày 19/11/2026. Giữ ranh giới Definition/Data/BattleData; trạng thái thực tế ở mục triển khai, không coi các hệ thống ngoài phase là đã được yêu cầu làm.

Kết quả khảo sát và đề xuất: [model Crystal và phạm vi prototype](docs/crystal-prototype-model-review.md). Hợp bộ 5 và các Hero địch chương 1 Thường là 16 Hero; thêm 10 loại quái thường. Config trang bị rank 1–4 của 16 Hero dùng 67 loại item trực tiếp, 108 loại khi tính cả nguyên liệu recipe đệ quy. Theo chốt bypass craft, phạm vi cấp đồ/tiến bậc hiện chỉ cần 67 loại trang bị trực tiếp; 41 loại nguyên liệu bổ sung là tham chiếu cho craft về sau. Đây là số loại, không phải số instance. Phạm vi 67 loại trực tiếp đã nhập Unity; 41 nguyên liệu bổ sung để phase craft sau.

### D12 — GUID từng món; Inventory hiển thị stack theo loại

**Chốt thay đổi22/11/2026 trong lúc triển khai D31:** người dùng đổi yêu cầu sang một icon theo loại kèm xN, giữ GUID để phục vụ Market về sau, tiếp tục dùng asset Crystal. UI Inventory gộp các instance cùng ItemId thành một ô; dữ liệu sở hữu vẫn giữ GUID riêng từng món và không mất định danh khi gộp ô. Giao dịch tiêu đúng tập GUID theo số lượng; không cần xóa/reset hoặc đổi GUID dữ liệu cũ. Những ghi nhận mộtGUID/mộtô dưới đây là lịch sử trước thay đổi này, không còn là layout đích. Market/split/trade vẫn để phase sau. **Trạng thái:** đang sửa UI và kiểm tra lại theo chốt mới, không ghi bản build trước thay đổi là bản nghiệm thu cuối.

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

### D14 — Tên sản phẩm và thành phần project là Zatod

Chốt ngày 19/11/2026: các thành phần do project xây dựng phải mang tên Zatod, dù lấy nguồn tham chiếu Crystal. Áp dụng cho nhãn UI/menu, cửa sổ Editor, scene/prefab, code/công cụ/build và tên tài liệu phục vụ sử dụng project. Crystal chỉ dùng khi nói rõ nguồn tham chiếu, nguồn reverse hoặc mô tả hành vi gốc.

- **Trạng thái 19/11/2026:** đã triển khai theo yêu cầu thực thi sau khảo sát. UI/menu, class/file/scene/resource/build và công cụ hoạt động dùng Zatod; giữ dấu vết nguồn và lớp tương thích save/rules/archive/launch flag cũ. Scene `ZatodPrototype.unity`, executable `Builds/ZatodPrototype/ZatodLegend.exe`.
- Giữ nguyên bộ reference `Unity/Assets/Crystal Legend/` theo D04 và dấu vết nguồn; đổi tên thành phần Zatod không tự xóa/viết lại source tham chiếu.
- Những tên đang là ID lưu trữ/reference/resource/rules/replay cần rà soát migration hoặc lớp tương thích trước khi đổi, giữ Hero/item GUID và archive cũ theo D08/D12/D13. Không replace toàn repo làm hỏng dữ liệu sở hữu/replay. Kế hoạch cụ thể và từng thay đổi sẽ được thực hiện ở lượt triển khai được yêu cầu.

Khảo sát UI ban đầu: [zatod-campaign-ui-review.md](docs/zatod-campaign-ui-review.md). Phạm vi sau đó đã chốt tại D15 và được yêu cầu thực thi cùng D14–D16; ý tưởng ngoài phạm vi ấy vẫn là brainstorm.

### D15 — Phạm vi HUD Phó bản và GameEditor

Chốt ngày 19/11/2026 sau khảo sát UI:

- HUD dùng asset hiện có theo bố cục tham chiếu. **Chưa thêm pause/tăng tốc cho Phó bản** ở lượt UI sắp tới; không xóa chức năng điều khiển replay đã có.
- Auto dùng thao tác ultimate hợp lệ và nhật ký/checker thật; số damage/heal/energy nổi lấy từ kết quả combat thật, không dùng số minh họa hay tính từ animation.
- Vàng/rương **vẫn dựng UI**, hiển thị cố định **0**, chưa nối reward/economy. Quyết định này thay đề xuất ẩn nhóm vàng/rương trước đó.
- Người dùng chọn điểm vào/cửa sổ tên **GameEditor**, có từng tab riêng cho Heroes, Monsters, Items, Stats, Skills, Buffs và Campaign (chương/ải/wave/hook), thay đề xuất menu Config trước đó. Các thành phần project tiếp tục theo tên Zatod tại D14.
- **Trạng thái 19/11/2026:** đã triển khai HUD prefab `Resources/Zatod/UI/ZatodBattleHUD.prefab`, Auto và số combat thật, vàng/rương 0. Menu **GameEditor > Open**, bảy tab, refresh sạch và bảo vệ draft/stale save. Kiểm tra Editor 13 PASS; trận Auto thật được server xác nhận, replay pause/seek/x4 đạt. Chi tiết: `docs/zatod-ui-implementation-progress.md`.
- Kiểm tra Editor hiện tại xác nhận draft/cache cũ 24 Hero/7 Monster/2 Item trong khi file trên đĩa có 40/17/69. Đây là lỗi đồng bộ cửa sổ authoring (BUG-012), không phải thiếu import. Khi triển khai GameEditor cần xử lý phát hiện file thay đổi và bảo vệ draft chưa lưu, không âm thầm bỏ chỉnh sửa hoặc ghi đè file mới.
- **Phản hồi sau nghiệm thu chức năng 19/11/2026:** người dùng chỉ ra UI còn giống control tạm dù có asset. Kiểm tra xác nhận HUD runtime là uGUI, GameEditor là UI Toolkit; HUD mới dùng một phần art, còn helper button/digit/highlight/menu tạm. D15 đã triển khai chức năng nhưng chưa nên coi hình thức UI là hoàn thiện theo ảnh tham chiếu. Theo dõi BUG-018; lượt hỏi này chỉ giải thích, chưa đổi runtime.


- **Bổ sung21/11/2026 — đã triển khai:** người dùng yêu cầu đưa config map lên Editor. Có tab Maps trong GameEditor và menu GameEditor > Maps để xem/chỉnh config độc lập từng đảo, giữ tọa độ authoring local, validate world/portal/asset và bảo vệ draft khi file đổi bên ngoài. Không suy yêu cầu này thành level editor kéo/thả hoặc preview scene Edit Mode. Unity compile sạch, 19 kiểm tra Editor PASS; 19 file config/Owned giữ nguyên SHA256 sau kiểm tra. Hướng dẫn: `docs/zatod-maps-editor.md`. Save áp dụng ở lượt Play tiếp theo trong Editor; bản standalone cần rebuild rồi khởi động lại server/client để nhận config đóng gói mới.

### D16 — Config chỉ giữ bộ mới, ID snake_case và tên tiếng Anh

Chốt hướng ngày 19/11/2026; ban đầu kiểm tra trước, sau đó người dùng đã yêu cầu **thực thi**:

- Các `.txt` config hoạt động chỉ giữ dữ liệu thuộc bộ mới đã import và các phụ thuộc thật của nó. Loại định nghĩa Hero/item/monster/skill cũ không thuộc bộ mới; điều này thay chủ trương trộn định nghĩa cũ và mới trước đây. Không tự xóa art/reference/archive hay reset lịch sử Hero/item.
- Đặt ID dạng tên object viết thường, phân cách từ bằng `_` (snake_case), ví dụ Axe Titan → axe_titan, Zeus → zeus; bỏ dạng crystal_1/crystal_item_*/crystal_skill_* khỏi ID authoring mới.
- Dùng tên tiếng Anh có sẵn của đúng bản game cho item/skill thay chuỗi tiếng Trung. Kiểm tra bảng bản địa hóa gốc trước khi tự dịch; không lấy tên Dota/game khác làm tên chính thức nếu client này dùng tên khác.
- **Trạng thái 19/11/2026:** đã dọn và chuyển tham chiếu: 40→16 Hero, 17→10 Monster, 69→67 Item, 127→86 Skill; giữ 33 buff, 27 stat phụ thuộc, 18 ải/54 wave. ID snake_case; item/skill dùng English gốc theo độ phủ bên dưới. Importer có postprocess idempotent; mapping tương thích nằm trong `ZatodContentIds.cs`. Save remap ID, giữ GUID/equipped/absorbed; sở hữu pixel đã nghỉ được giữ ở RetiredHeroDesk/RetiredInventory/RetiredFormationIds, không xóa lịch sử hay art.
- Skill có tên hiển thị trùng (26 Basic Attack, hai Headshot trong bộ mới). Đã đối chiếu 26 Basic Attack tương ứng một-một với 16 Hero + 10 Monster, ID riêng và Basic Skill trong Unit nguồn khớp toàn bộ; không phải import trùng. Khi thực thi đã dùng prefix owner cho skill ID để phân biệt nhãn trùng, ví dụ `lina_basic_attack`; giữ SourceId để trace đúng cơ chế.
- Khảo sát tên: 67/67 item có bản English trực tiếp; 74/74 skill không ẩn có bản English. Tổng 86 skill có 75 tên trực tiếp, 11 dòng tên `&...` đều bị ẩn; 4 dòng có thể tra tên gốc khi bỏ `&`, 7 dòng chưa tìm thấy nhãn English tương ứng trong bảng đã kiểm tra. Không đánh dấu mọi dòng kỹ thuật ẩn là đã có tên dịch chính thức.

Khảo sát chi tiết: `docs/zatod-data-cleanup-review.md`; bảng tên trích nguồn tại `Artifacts/CrystalPhaseChecks/english-name-audit-20261119.json`.

### D17 — Art của mọi UI/View mới dùng đúng asset Crystal

Chốt ngày 19/11/2026 sau phản hồi BUG-018. **Trạng thái:** đã áp dụng cho View chọn đội D18, dùng 77 file art/font nguồn được đối chiếu SHA256; HUD cũ vẫn giữ theo chấp nhận tạm của người dùng.

- Người dùng tạm chấp nhận HUD hiện tại; không tự mở một đợt sửa lại toàn bộ HUD cũ trong lượt khảo sát chọn đội.
- Từ đây, mọi UI/View mới dùng đúng asset Crystal đã khôi phục: background, panel/frame, button và các trạng thái, portrait, rank, star, selected mark; đối chiếu ảnh/source, không vẽ nền màu/control tạm hoặc dùng một nền nút cho mọi chức năng như trước.
- Giữ nguyên nguồn trong `Unity/Assets/Crystal Legend/`, import phần cần dùng và đặt tên thành phần Zatod theo D04/D14. Không coi việc đã tìm thấy file là đã kiểm định đủ mọi biến thể giống screenshot.
- Làm rõ và duyệt 19/11/2026: tiếp tục dùng **uGUI/Canvas để ghép đúng asset nguồn**; người dùng sửa cách diễn đạt trước đó, không cấm framework. Không dùng control/nền màu tạm thay art game.

### D18 — View chọn đội Phó bản theo ảnh tham chiếu

Chốt yêu cầu ngày 19/11/2026; người dùng đã duyệt toàn bộ khảo sát còn lại và yêu cầu thực thi. **Trạng thái:** đã hoàn thành và kiểm tra. Editor/server 365 checks PASS, 54 wave; Windows build cuối Succeeded/0 errors/0 warnings; client executable kết nối và mở View hiển thị art/font CN thành công. Hộp thoại Save đã gỡ và guard chống tái diễn đã kiểm tra (BUG-022).

- Flow D18 ban đầu được thay bằng D20 ngày20/11: chọn ải → popup preview → Challenge → chọn đội → Battle → vào trận. Back ở chọn đội về popup, X về map; không tự bắt đầu trận.
- Hàng địch trên cùng hiển thị encounter của từng wave, có nút trái/phải và chỉ số wave; đổi preview không thay wave bắt đầu hay thành phần trận thật.
- Hai tab Squad/Tutorial theo ảnh; Tutorial hiện chỉ có hình thức, bấm chưa xử lý/nạp nội dung.
- Danh sách Hero sở hữu là grid scroll dọc, lấy `CharacterData.HeroDesk`, không tự cấp toàn bộ 16 định nghĩa đã import. Ô Hero hiển thị portrait, level, sao và bậc thật.
- Chỉ filter **All / Ago / Middle / Rear**. Ago chỉ hàng trước, ánh xạ Front hiện có; bỏ STR/INT/AGI và Preset. Không tạo stat mới từ các tên filter.
- Tổng lực chiến đặt `?` nếu chưa có hệ thống. Dải đội hình có 5 ô; ô thiếu khuyết từ trái, các Hero được chọn nằm về phải theo ảnh 4 Hero. Không tự thêm drag/reorder hoặc đổi combat placement để khớp hình.
- Khu phải: tên/mô tả ải, thể lực, item drop và nút Battle. Phần chưa implement để trống, không giả dữ liệu. Chốt bổ sung: dùng nguyên Name/Description tiếng Trung hiện có, dịch/bản địa hóa để sau. Ngày 20/11 đã thêm drop fields theo D19; Cost và icon drop đã được nối vào View chọn đội/popup theo D20.
- Battle gửi đội Hero instance đã chọn vào flow Campaign/checker hiện có; chưa yêu cầu sửa luật trận, kho/tiến trình hoặc xây hệ thống stamina/reward/power.
- Khảo sát và tương tác đã được duyệt khi yêu cầu thực thi: `docs/zatod-formation-view-review.md`; các giới hạn không tự mở rộng vẫn giữ nguyên.

### D19 — Danh sách item rơi theo ải, giai đoạn config

Cập nhật21/11/2026: giai đoạn config-only và100% mỗi dòng bên dưới là lịch sử. D26 thay bằng pool tổng100%, MaxDropAmount và logic server cấp thưởng đã được duyệt/triển khai; không áp lại semantics D19 cũ khi chỉnh hoặc import config.

Chốt và yêu cầu triển khai ngày 20/11/2026. **Trạng thái:** đã triển khai model/config/validation và nối pipeline import; 18 ải, 36 dòng/10 loại item, 100%. Core 4.429 assertions PASS, re-import byte-identical và đối chiếu giữ nguyên dữ liệu ải/wave cũ. GameEditor dùng reflection đã có để chỉnh các field mới; không có Editor chạy để kiểm tra live lượt này. UI drop đã nối theo D20; chưa triển khai roll/cấp thưởng.

- Mỗi `CampaignStageDefinition` có `DropItems`; mỗi dòng chứa `ItemId` (ID loại item) và `DropChancePercent` (0–100). Đây không phải GUID của một item instance.
- Lấy danh sách từ `Stage.UI reward` của Crystal cho các ải đã import, chỉ tham chiếu các item có định nghĩa trong Zatod. Hiện đặt mọi tỷ lệ là **100%** theo yêu cầu prototype của người dùng, không coi đó là tỷ lệ Crystal đã reverse.
- Phạm vi hiện tại giữ bộ 67 trang bị; ID20555 là vật phẩm ngoài bộ đã nhập, có điều kiện level81 trong nguồn, được ghi vào báo cáo bỏ qua thay vì tạo reference hỏng.
- Chỉ làm config/model/validation và khả năng chỉnh qua GameEditor Chapter/Stage/Wave; chuẩn bị nguồn dữ liệu cho UI. Chưa xử lý quái chết rơi đồ, random, cấp item vào kho hay thưởng cuối trận. Hiển thị icon drop trong hai View đã được hoàn tất theo D20, không thêm logic trao đồ.
- Bổ sung này thay trạng thái “chưa có drop fields” của D18; phần stamina, economy, power và luật combat vẫn giữ nguyên phạm vi đã chốt.

### D20 — Popup preview ải và hiển thị item reward

Yêu cầu ngày 20/11/2026; người dùng đã duyệt toàn bộ phạm vi và yêu cầu thực thi. **Trạng thái:** đã hoàn thành và kiểm tra. Core4.431 assertions PASS, UI766 checks PASS/18 ải; build Windows Succeeded/0 errors/2 warnings có sẵn. Client Editor + server executable test thắng3 sao, snapshot và popup cùng3; phiên mới cùng tài khoản về0 sao và giữ5 Hero/level. Editor đã dừng Play, auto-tick=false; server thường PID5580 READY7788, dữ liệu Artifacts/ZatodServer. Bổ sung Cost được người dùng yêu cầu thực thi riêng cùng ngày: đã thêm model/config/import/validation `VitalityCost`, 18/18 ải bằng6 theo Crystal, ConfigVersion=`zatod-chapter-one-4`, core4.431 assertions PASS.

- Flow đích mới: chọn ải → popup preview đội địch → View chọn đội → bấm Battle → vào trận. Đã nối vào runtime, thay flow cũ của D18.
- View chọn đội: khu reward hiển thị nhãn `Reward` và icon các item trong `stage.DropItems`, không ghi tỷ lệ. Popup preview dùng cùng nguồn DropItems; chưa cấp thưởng/roll đồ.
- Popup lấy đúng asset Crystal, có nền tối chặn tương tác map phía sau và nút X đóng về màn chọn ải; bảng tên lấy Stage.Name, mô tả giữ tiếng Trung như D18.
- Ba sao đọc số sao thật đã đạt trong phiên chơi: chưa đánh 0/3 sao xám; có sao thì sao đạt vàng, sao thiếu dùng biến thể nâu. Không suy cleared=true thành3 sao; giữ reset tiến trình theo launch của D11.
- Enemies chỉ hiển thị các spawn trong **wave cuối** (hiện wave3), gồm cả Hero phía địch và Monster; giữ các ô trùng loại, không gộp. Boss đọc cờ Boss của spawn và dùng badge nguồn tiếng Anh.
- Cost dùng `CampaignStageDefinition.VitalityCost` kiểu int không âm, lấy nguyên `Stage.Vitality Cost` từ Crystal. Đã điền6 cho cả18 ải và cập nhật importer; GameEditor reflection có sẵn hiển thị field. Đã hiển thị Cost trong popup và View chọn đội; không trừ thể lực hoặc chặn Challenge vì hệ thống thể lực chưa làm. Giá trị0 hợp lệ cho ải miễn phí và config cũ thiếu field.
- Có khu Raid Voucher, nút Raid/Raid x3 và Challenge. Raid chỉ là UI ở phase này, chưa request/thưởng/càn quét; điều kiện3 sao là điều kiện thể hiện trạng thái. Daily Attempts hiển thị `?`. Challenge mở View chọn đội và chưa bắt đầu trận.
- Đã bổ sung StageStars trong account snapshot từ CampaignRun; dùng dữ liệu server thật để render sao. Đã import42 file art/icon nguồn byte-for-byte và dùng icon/frame theo Quality. Không khôi phục tiến trình từ archive cũ.
- **Đã chốt bổ sung ngày 20/11/2026:** dùng số sao thật; Raid dưới3 sao hiện xám, đủ3 sao đổi trạng thái sáng nhưng chưa có xử lý; Raid Voucher hiển thị `?`. Back ở View chọn đội trở lại popup preview của cùng ải, giữ draft đội; X đóng về map. Quyết định Back này đã được triển khai, thay hành vi cũ của D18. Giữ nút Tutorial theo ref, chưa nối code. Daily Attempts vẫn `?`. Sau bước Cost, người dùng đã yêu cầu thực thi UI/protocol sao trong phạm vi D20.
- Bàn giao: `docs/zatod-stage-preview-implementation.md`; asset mapping khảo sát: `docs/zatod-stage-preview-review.md`. Kiểm tra/ảnh/build/network/reset: `Artifacts/ZatodStagePreviewChecks/`; trạng thái cuối `handoff.json`.

### D21 — Thị trấn và map chương dùng chung, nhân vật SPUM

Yêu cầu và làm rõ ngày20/11/2026. **Trạng thái:** đã hoàn thành triển khai và nghiệm thu phạm vi world/chương2 ngày20/11/2026. Core4.740 assertions PASS; UI hai lượt48/131 checks PASS (287 remote interpolation frames); hai client world + hồi quy3 mode/GUID PASS; Windows build cuối Succeeded/0 errors/2 warnings có sẵn. Bằng chứng và giới hạn: docs/zatod-shared-world-implementation.md. Giữ nguyên phạm vi các feature khác.

- Có Thị trấn chung, tài khoản mới spawn tại đó. Các building/NPC đại diện tính năng như Clan, Tháp thất lạc, Phó bản; không suy ra đã duyệt xây logic các feature chưa có.
- Lại gần điểm tương tác hiện nút, đi xa ẩn; bấm mới mở tính năng/teleport. Điểm Phó bản ở thị trấn đưa người chơi tới khu Phó bản.
- Thị trấn, map chương1 và map chương2 đều là không gian chung: những người cùng map nhìn thấy nhau. Tiến trình/sao/quyền mở ải riêng theo từng người; không biến clear cá nhân thành trạng thái global của NPC hoặc map.
- Phó bản có các đảo/map chương liên tiếp và đi qua lại được. Chương1 theme xanh lá/đồng cỏ; chương2 theme xanh xám/rừng undead. Có NPC/building làm điểm ải; bố trí tạm theo quyền người dùng cho phép, cốt truyện/placement chi tiết làm sau.
- Tương tác điểm ải mở popup D20, tiếp tục Challenge → chọn đội → Battle. Trận Phó bản vẫn riêng từng người và theo D03; không tự biến thành đánh quái/co-op trên map chung.
- Chương2 phải có đầy đủ ải/wave theo Crystal (người dùng đã chọn): nguồn Thường có21 ải/63 wave, SourceStageId19..39. Đây là mở rộng phạm vi chương1 của D11; đã nhập/nghiệm thu dữ liệu21 ải/63 wave và runtime trong lượt triển khai20/11.
- Nhân vật world dùng prefab Unit visual do người dùng cung cấp trong TreasureHunter_Export_2026-11-20/TreasureHunter_VisualAssets.unitypackage. Theo chat export được người dùng dẫn chiếu, phạm vi đã thu gọn từ SPUM đầy đủ sang Unit/ba preset và art SPUM phụ thuộc cần thiết; không có SPUM editor riêng. Building/NPC và nền Grass/Undead/White cũng nằm trong gói này. Ngoại hình world mới không đổi art/animation/timing chiến đấu của các Hero Crystal hoặc quy tắc UI D17.
- Tiến trình riêng theo người chơi không tự thay quyết định chưa lưu tiến trình Phó bản qua lần mở game của D11. Chưa yêu cầu authentication/đăng ký tài khoản thật; hiện project vẫn dùng development profile/account GUID.
- **Chốt bổ sung20/11/2026:** main character chỉ là visual/avatar để di chuyển, chưa có combat/stats/skill riêng. Đi lại và chuyển qua lại hai map tự do ở phase này; chưa khóa portal theo tiến trình chương, validation navigation mở rộng làm sau. Điểm ải tham chiếu StageId; sao/unlock là riêng. Khi mở modal/chọn đội khóa di chuyển của chính người chơi; kết thúc trận trở lại map/điểm tương tác đã vào, giữ return context trong phiên. Các điểm này là yêu cầu thiết kế đã duyệt; runtime world đã triển khai/nghiệm thu theo bằng chứng D21. Không suy phạm vi navigation thành bỏ checker/quyền mở ải của combat hiện có.
- **Chốt điều khiển20/11/2026, cập nhật bởi D24:** Editor dùng WASD/phím mũi tên hoặc joystick; mọi Player build dùng Fixed joystick. Avatar chưa có combat/stats riêng.
- **Lựa chọn triển khai prototype:** camera orthographic theo avatar, clamp theo bounds/aspect; vào map và trở lại từ trận dùng target camera đã clamp. Còn mở sức chứa map/channel và lưu vị trí qua đăng nhập. Thị trấn prototype dùng lại bộ đồng cỏ; có thể đổi art sau.
- Lựa chọn schema khi triển khai: WorldDefinition/WorldMapDefinition/WorldInteractionDefinition cho layout, WorldPlayerState cho runtime; portal là loại interaction có map/spawn đích. Chapter tham chiếu WorldMapId, điểm ải tham chiếu StageId ổn định. Không dùng MainCharacter làm HeroData hoặc tái sử dụng MapX/MapY UI chuẩn hóa thành tọa độ world.
- Gói tham chiếu hiện có tại gốc workspace: TreasureHunter_Export_2026-11-20; đã đọc chat export01a1f739-f65e-7e80-8480-872aba5f5de4 và kiểm tra tĩnh package656 asset/76 prefab, checksum đúng, không thấy GUID/path collision với Unity/Assets. Unit visual không có MonoBehaviour/physics; có Animator idle/run và root motion tắt. Package đã import vào Zatod; đã bổ sung shader include còn thiếu từ đúng project nguồn (BUG-027), đã nghiệm thu render/chạy trong Zatod theo báo cáo D21. OriginalEquipmentScripts.zip chỉ giữ làm nguồn tham khảo, chưa bung vào Assets. Nguồn/lưu ý: docs/zatod-treasure-hunter-assets-review.md và docs/zatod-shared-world-design-review.md.

### Ghi nhận triển khai D21 — 20/11/2026

- **Xác nhận hướng21/11/2026:** người dùng tiếp tục chọn các đảo cùng tồn tại trên server/client, chuyển bằng teleport theo phần làm rõ20/11. Trạng thái chuyển kiến trúc vẫn CHƯA TRIỂN KHAI; lượt này chỉ rà lưu ý, chưa yêu cầu sửa code. Các đề xuất kỹ thuật/authoring mới trong docs/zatod-world-map-lifecycle.md chưa tự thành quyết định đã duyệt.
- **Chốt bổ sung21/11/2026:** mỗi đảo có config độc lập để setup trước, world tổng tham chiếu các config đảo; định dạng lưu cụ thể/file hay asset chưa chốt. Người dùng duyệt tách phần server logic/client visual, teleport tức thời có reset input/nội suy cũ, và tối ưu chỉ đồng bộ vùng liên quan theo concept interest management. Không tự áp một thuật toán spatial hash hoặc bán kính chưa duyệt; implementation Zatod hiện vẫn lọc snapshot theo MapId. Editor preview/layout đang được giải thích giữa setup và runtime, chưa có yêu cầu tạo tool. Người dùng đang hỏi cơ chế vào trận hiện tại; chưa yêu cầu chuyển combat sang scene riêng hoặc thay trạng thái hiện diện avatar khi vào trận. Chi tiết source/giải thích: docs/zatod-world-map-lifecycle.md.
- World layout: Resources/Data/Worlds.txt; ba map Town/chapter_one/chapter_two,39 điểm ải. Avatar cosmetic dùng Unit native qua wrapper Zatod, WASD/mũi tên, bounds/collision vùng chân và camera follow. Điểm Clan/Lost Tower chỉ placeholder; Arena/PvP/Hero nối feature đã có.
- **Hành vi đã quan sát20/11/2026, chưa đáp ứng hướng world được làm rõ bên dưới:** server tải dữ liệu cả ba map; client chỉ instantiate cụm hình ảnh map hiện tại và thay cụm khi MapId/revision đổi, các map dùng tọa độ riêng. Đây là lựa chọn implementation cũ, không phải yêu cầu người dùng giữ lại. Chi tiết docs/zatod-world-map-lifecycle.md.
- **Làm rõ thiết kế20/11/2026 theo người dùng, CHƯA TRIỂN KHAI:** Town/chương1/chương2 phải cùng tồn tại ở các vùng tọa độ riêng trong world, có các cụm map thực trên server và client; server khởi tạo các đảo khi start, client dựng các đảo khi khởi tạo world. Đi giữa các map là server teleport avatar tới tọa độ world của đảo đích, client cập nhật player/camera; không Destroy map cũ rồi dựng map đích mỗi lần qua portal. Tham chiếu concept Treasure Hunter. Server không cần render toàn bộ art; phạm vi component/collision server cần thiết sẽ thiết kế khi triển khai. Có thể tối ưu render/network theo khoảng cách, nhưng không diễn giải thành chỉ tồn tại một đảo hiện tại. Vị trí cụ thể các đảo và chi tiết tối ưu chưa chốt; tiến trình riêng, trận riêng, input và các feature khác giữ phạm vi đã duyệt. Người dùng chỉ yêu cầu khảo sát, chưa cho phép sửa code trong lượt làm rõ này. Bằng chứng TH và khác biệt: docs/zatod-world-map-lifecycle.md, mục đối chiếu20/11/2026.
- Server sở hữu membership/map revision; avatar cosmetic do client chủ di chuyển mỗi render frame, gửi pose20Hz và nhận snapshot10Hz theo cùng map; remote interpolate. Chưa làm server authoritative navigation/chống speed hack world, channel hoặc lưu vị trí qua login. Không suy cơ chế này thành thay luật combat/checker.
- Tổng catalog hiện25 Hero/14 Monster/76 item/131 skill/52 buff/27 stat; hai chương39 ải/117 wave. Roster sở hữu vẫn5 Hero khởi đầu, không tự cấp mới; dữ liệu kho/archive cũ giữ nguyên.7 file Owned server thường được đối chiếu SHA256 không đổi qua cập nhật/restart.
- Editor bàn giao stopped/auto-tick=false, run-in-background về projectValue=true; server thường PID24584 READY TCP7788, Artifacts/ZatodServer. Cách chơi cập nhật tại docs/zatod-prototype-play.md; lỗi phát hiện/sửa ở ChangeLog.md BUG-027..036.

### D22 — UI responsive cho game màn ngang

Yêu cầu và làm rõ ngày20/11/2026. **Trạng thái:** đã triển khai, kiểm tra Editor/Simulator và build Windows thành công ngày20/11/2026. Xem docs/zatod-hero-ui-implementation.md.

- Game định hướng màn hình ngang; chưa xây bố cục portrait. Hỗ trợ nhiều kích thước/tỷ lệ ngang, bao gồm Device Simulator iPhone X. Không đồng nhất responsive với chỉ thu/phóng nguyên khung1600x900.
- Từ đây UI mới phải bố trí theo vùng khả dụng, có anchor/layout và safe area cho notch, góc bo, vùng cử chỉ; giữ tỷ lệ art/portrait, không kéo méo ảnh. Nền có thể phủ toàn màn hình, nút/chữ quan trọng nằm trong vùng an toàn.
- Khảo sát ban đầu xác nhận HUD world dùng nhiều tọa độ cố định từ góc trên trái và thiếu safe-area container. Đã thêm safe-area root có clamp dữ liệu Simulator cũ, neo HUD theo cạnh, bố cục Hero co giãn và nền full-bleed. Các màn runtime hiện dùng đã qua kiểm tra bố cục trong Editor; giới hạn chưa thử thiết bị vật lý được giữ ở báo cáo.
- Tiếp tục D17: uGUI/Canvas ghép đúng asset Crystal cho UI mới. Không đổi framework hoặc nâng Unity chỉ vì yêu cầu responsive.
- Đã kiểm tra ngang4:3,16:9,19.5:9,20:9,21:9; safe area trái/phải/bottom, thay size lúc View mở; thêm lượt Screen.safeArea của Simulator2436×1125. Phạm vi gồm world HUD, Hero, preview/chọn đội/Battle và các menu Arena/PvP/replay/dev hiện dùng. Không coi đây là chứng nhận cho mọi phần cứng.

### D23 — Thanh truy cập world, danh sách Hero và chi tiết Base

Yêu cầu ngày20/11/2026 qua bộ ảnh tham chiếu. **Trạng thái:** người dùng đã duyệt các mục1–5 của bản khảo sát, gồm responsive liên màn hình, art, dữ liệu thật, placeholder và trạng thái item; đã chốt click item/dấu cộng không có action trong phase này. Thiết kế D22/D23 đã chốt; người dùng đã yêu cầu thực thi ngày20/11/2026. Đã triển khai, kiểm tra Editor/Simulator và build Windows thành công. Kết quả tại docs/zatod-hero-ui-implementation.md.

- **Cập nhật đã chốt20/11/2026:** chuyển cả cụm Task/Hero/Inventory và nút thu/mở sang **góc dưới phải**, thay vị trí dưới trái ban đầu để dành chỗ joystick. Cả trạng thái mở và thu đều neo mép phải trong safe area; dùng art Crystal, chưa red dot. Đã triển khai,73 checks Editor PASS và build Windows thành công0 lỗi.
- Hero mở List of Heroes, lấy HeroDesk sở hữu; không tự đưa toàn bộ25 định nghĩa vào roster. Có Back, nhãn List of Heroes và diamond/gold/stamina hiển thị `??`. Danh sách cuộn dọc, ô gồm portrait/khung bậc/sao/level thật, tên Hero và6 ô theo bậc hiện tại. Filter chỉ All/Front/Mid/Rear; Mid ánh xạ Middle. Bỏ icon/nhóm STR/AGI/INT.
- Thanh nhỏ hình12 là Astrolabe trong source; chỉ hiển thị art khóa, chưa nối tính năng. Bỏ ô đặc biệt hình18. Không suy ra đã yêu cầu Follow, trang bị đặc biệt hoặc hệ thống Astrolabe.
- Ô đã mặc hiển thị icon của ItemId thật trong EquippedItems (giữ D08 nếu recipe đã đổi); ô chưa mặc có loại item yêu cầu trong Inventory hiển thị dấu cộng; không có thì ô trống. Item instance vẫn là GUID riêng, một món không mặc vào hai ô. Dấu cộng theo yêu cầu này báo có item, không tự bỏ điều kiện level/quyền sở hữu khi thực hiện mặc.
- Bấm Hero mở detail, Base active; các tab Skill/Astrolabe/Skin giữ hình thức và không thực hiện hành động. Tranh Hero lớn phía trái, Hero chiến đấu dạng sprite ở giữa với6 ô hai bên; không dùng avatar Unit world làm Hero. Hiển thị tên/khung/bậc thật; Quick Equip chưa nối logic và Power=`??`.
- Cột phải có level/sao thật, khu EXP/đá nâng sao và danh sách stats có scroll dọc. Stats lấy HeroStatCalculator ngoài trận, gồm base/growth/bậc/item hấp thụ/item đang mặc; không cộng buff tạm của trận vào stats sở hữu. Giữ giới hạn tiến bậc hiện tại tới Blue theo D11; ảnh Blue+1 chỉ là tham chiếu bố cục, không tự mở thêm bậc.
- **Chốt ngày20/11/2026:** ô item/dấu cộng trong danh sách và detail chỉ hiển thị trạng thái ở phase này; bấm chưa có action, không mở preview hoặc gửi lệnh mặc. Quick Equip cũng chưa nối logic. Preview/chọn/mặc item qua UI được chuyển sang phase tiếp theo; không xóa API hoặc công cụ mặc đồ hiện có.
- **Đã duyệt qua mục4 ngày20/11/2026:** Task/Inventory mới chỉ có nút, chưa xây thêm View/task system; EXP hiển thị giá trị HeroData.Exp với ngưỡng `??` (chưa có curve Zatod), đá nâng sao=`??/??`; Lvl Up/Star Up/các nút cộng tài nguyên chưa có handler. Không tạo dữ liệu tiến trình hoặc số phần trăm giả để giống ảnh.
- Khảo sát nguồn lịch sử: docs/zatod-hero-ui-review.md. Người dùng đã yêu cầu thực thi sau khi chốt; báo cáo kết quả và giới hạn tại docs/zatod-hero-ui-implementation.md.

### D24 — Joystick cho mobile, bàn phím chỉ trong Editor

Yêu cầu ngày20/11/2026. **Trạng thái:** đã triển khai Fixed joystick/menu dưới phải,73 checks Editor PASS, build Windows thành công0 lỗi; đã kiểm DLL Player không có Keyboard và DLL Editor còn Keyboard.

- Game tiếp tục màn ngang. Đọc WASD/phím mũi tên cho avatar world chỉ ở `#if UNITY_EDITOR`; mọi build ngoài Editor dùng joystick, gồm cả bản Windows/development. Không thêm ngoại lệ bàn phím cho standalone build.
- Dùng joystick/skin từ TreasureHunter_Joystick_Export_2026-11-20 do người dùng cung cấp. Đây là nguồn art riêng cho joystick theo yêu cầu mới; UI khác giữ D17/D23. Joystick cung cấp input cho avatar Town/map qua WorldMovement và đồng bộ hiện có, không đổi rule chiến đấu.
- **Cập nhật20/11/2026:** bỏ dòng hướng dẫn WASD/Arrow keys/joystick khỏi HUD, kể cả Editor. Chỉ bỏ chữ, giữ điều khiển bàn phím trong Editor theo D24.
- Quyết định này cập nhật chốt WASD của D21 về phạm vi nền tảng. Trong Editor vẫn hỗ trợ bàn phím để test; đề xuất vẫn cho thử joystick bằng chuột/Simulator.
- **Chốt bổ sung20/11/2026:** dùng Fixed joystick, luôn ở vị trí cố định trong vùng một phần tư dưới trái màn hình, như cách đặt joystick mobile thông dụng. Đây là vùng đặt, chưa đóng đinh tọa độ pixel cho mọi thiết bị. Bố trí trong safe area; người dùng đã chuyển thanh Task/Hero/Inventory sang dưới phải theo D23 để dành vùng trái cho joystick. Floating/Dynamic không còn là lựa chọn đích.
- Khảo sát lịch sử: docs/zatod-joystick-review.md. Kết quả triển khai: docs/zatod-joystick-implementation.md. Getter AxisOptions đã sửa tối thiểu trên bản import (BUG-039); package nguồn nguyên vẹn.

### D25 — Scene chiến đấu riêng

- **Ngày chốt:** 21/11/2026. **Trạng thái:** đã triển khai và nghiệm thu21/11/2026 sau khi người dùng yêu cầu thực thi phase. Báo cáo docs/zatod-world-battle-implementation.md; Windows build cuối Succeeded/0 lỗi/2 warnings.
- Scene chiến đấu riêng thay phần presentation hiện chỉ bật stage UI trong scene world. Quyết định cập nhật ghi nhận trước đó ở D21 rằng chưa yêu cầu chuyển scene combat; không suy những ghi nhận lịch sử thành cấm đổi scene.
- Phạm vi đề xuất bao gồm Phó bản, Arena tự động, PvP realtime và replay hiện có. Giữ simulation/checker/input/replay theo D02/D03, nguồn art/timing theo D04/D17. Không tự thêm Unity server scene hoặc đổi quyền tính gameplay vì presentation chuyển scene.
- Đã triển khai kế hoạch kỹ thuật được người dùng yêu cầu thực thi: client load Battle scene additive, giữ world đã nạp; Hero/projectile/effect dùng renderer 2D, HUD Canvas; chuyển camera/input và lifetime theo trạng thái rõ ràng, dọn battle khi thoát. Đây là cách quy đổi kiến trúc được đề xuất, không khẳng định Crystal dùng Unity additive. Scene ZatodBattle đã có trong Editor/build; scene world và kết nối được giữ, state transition độc lập UI active.
- Theo phương án phase đã duyệt khi yêu cầu thực thi: avatar giữ vị trí world và dừng di chuyển khi battle; chưa thêm badge/ẩn avatar. Tool preview layout Edit Mode nằm ngoài phạm vi bắt buộc. Phạm vi tổng hợp: docs/zatod-world-battle-phase-plan.md. Quyết định world/config từng đảo/teleport/interest vẫn theo D21.

### Nghiệm thu D21/D25 —21/11/2026

- Người dùng đã yêu cầu thực thi kế hoạch docs/zatod-world-battle-phase-plan.md: config đảo độc lập, world tồn tại sẵn, teleport/interest, scene battle additive client, renderer 2D và nối các mode/replay. Trạng thái ĐÃ HOÀN THÀNH phạm vi phase ngày21/11/2026. Các ghi nhận trước đó về chưa triển khai là lịch sử trước lượt thực thi.
- Dùng phương án presence đã trình: avatar giữ vị trí world và dừng di chuyển khi vào battle; chưa thêm badge/ẩn avatar. Preview layout Edit Mode là tùy chọn ngoài phạm vi bắt buộc, không xây map editor lớn ở phase này.
- Giữ ID và owned state; cập nhật tiến trình tại docs/zatod-world-battle-implementation.md, bằng chứng Artifacts/ZatodWorldBattleChecks. Các mục lịch sử "chưa yêu cầu thực thi" trước đó đã được chỉ dẫn này thay thế.
- Hiện tại: Worlds.txt là index,3 file WorldMaps/town/chapter_one/chapter_two có origin(0,0)/(110,0)/(220,0), layout local; server/client tạo đủ3 đảo và giữ root qua portal. Custom snapshots lọc cùng map/radius48 configurable; chưa dùng spatial hash/Mirror NetworkIdentity cho từng sprite tĩnh. Navigation authority giữ phạm vi prototype.
- Battle scene client additive, Hero/projectile/effect SpriteRenderer, HUD Canvas; camera/input chuyển theo scene state. Phó bản/Arena/PvP/replay đã nối và nghiệm thu; simulation/checker/timing nguồn không đổi. Core4748, parity146 sets/31261 checks, live48, PvP8, responsive/failure50 PASS;2-client regressions/GUID và interest/stale pose PASS.8 file Owned local giữ nguyên SHA256.
- Build chuẩn Builds/ZatodPrototype/ZatodLegend.exe đã cập nhật. Bàn giao Editor stopped/scene sạch/auto-tick=false/override background restored; local server PID12320 READY TCP7788. Chi tiết giới hạn (không benchmark mobile thật, không editor map preview) trong báo cáo.


### D26 — Random số lượng và loại loot theo ải

- Ngày21/11/2026: người dùng đưa ra thiết kế Zatod gồm `MaxDropAmount` trên từng ải; random số món nguyên từ0 tới giới hạn đó, sau đó chọn loại item cho từng món theo tỷ lệ trong `DropItems`. Ví dụ giới hạn5; ba món chia đều thì mỗi món khoảng33,33% cho mỗi lượt chọn. Tỷ lệ lớn hơn có khả năng được chọn cao hơn. Đây là chọn một loại cho mỗi lượt, thay ý nghĩa thử rớt độc lập từng dòng100% của D19 khi triển khai thiết kế mới.
- Chốt và yêu cầu thực thi21/11/2026: `MaxDropAmount=5` cho các ải prototype; random đều số nguyên0..MaxDropAmount, sau đó chọn từng món có hoàn lại (được trùng loại), GUID riêng cho mỗi instance. Giữ `DropChancePercent` để chỉnh phần trăm trực tiếp; tổng các dòng trên từng ải bắt buộc100%, không âm thầm chuẩn hóa tổng sai. Chia đều theo0,01%, dồn phần dư vào dòng cuối (ba món:33,33/33,33/33,34). Validate phải chặn tổng sai. Đây thay phạm vi config-only/100% mỗi dòng của D19; không áp lại rule cũ khi re-import.
- Quan sát Crystal: `enter_stage_reply` đã chứa `_loots` và `_rseed`; client dùng loot theo wave/slot/phe để hiện lúc quái chết. `exit_stage` gửi kết quả/operations, không có danh sách loot do client khai. Nhánh client ordinary chỉ gọi `takeStageReward` khi reply known và thắng. Không có backend để kết luận chính xác thời điểm commit DB/công thức roll của Crystal.
- Đã duyệt cùng hướng trên: server tạo pending loot gắn battleId khi vào trận; chỉ cấp inventory sau validate thắng, mỗi battle chỉ settlement một lần. RNG loot tách RNG combat. Thua/hủy không nhận loot; replay chỉ xem không cấp lại. Giữ tiến trình ải theo launch và owned GUID theo D11/D12.
- Nghiệm thu21/11/2026:39 ải/78 dòng/20 loại loot, pool50%/50% và MaxDropAmount5, validator tổng đúng100%. Core4.819 assertions PASS; client–server thật13 checks PASS (nhận4 món đúng plan, GUID riêng, lưu Owned, reject duplicate, replay không thưởng, reconnect giữ receipt/GUID). Build Windows0 lỗi. Receipt account có LastCampaignReward; start có LootItems để presentation dùng về sau. Chưa thêm animation loot, popup thưởng hoặc nối vàng/rương trên HUD (giữ D15). Bằng chứng Artifacts/ZatodLootChecks; hướng dẫn docs/zatod-stage-drops-config.md.
- Bằng chứng/đối chiếu: `docs/crystal-stage-drops-review.md`, bổ sung21/11/2026.

### D27 — Rương, màn thưởng và thống kê Phó bản

- Yêu cầu thực thi21/11/2026: bổ sung statistic thật giống Crystal (damage gây ra/nhận vào, hồi máu tạo ra, kill), rồi triển khai rương boss-priority, popup thưởng và view thống kê theo phạm vi đã chốt. Không thêm EXP/economy thật, pause/tăng tốc Phó bản. Rương HUD được nối số thu thực tế, thay trạng thái0 cố định của D15; vàng placeholder dùng `?`. Report được tính trong simulator/checker, không làm thay đổi RNG/damage/tick/replay digest. **Đã triển khai và kiểm tra:** core4.838 assertions, UI113 checks,13 replay cũ và network17 checks PASS; build Windows thành công0 lỗi. Các ghi chú chưa code bên dưới là lịch sử trước lệnh này.
- Bản triển khai: một món một rương, tự thu về HUD, chờ receipt hợp lệ cùng BattleId rồi hiện popup; Continue và replay không cấp thưởng.4 tab thống kê lấy báo cáo checker, giữ địch xuyên wave. Popup mới áp dụng thắng Campaign; màn thua/Arena/PvP giữ UI hiện hành. Chi tiết và giới hạn attribution DOT/HoT theo core hiện tại tại `docs/zatod-battle-result-implementation.md`; nghiệm thu `Artifacts/ZatodBattleResultChecks/`.

- Bổ sung đã chốt21/11/2026 sau khảo sát: loot gắn vào địch, ưu tiên boss nếu ải có boss; không thay số lượng/tỷ lệ đã roll của D26. Popup dùng thưởng thật đã validate, nhóm theo ItemId để hiển thị và giữ GUID riêng trong kho. Thanh EXP dựng bằng art nguồn, tiến trình0/0 (thanh rỗng, không tính phần trăm từ phép chia0); vàng có icon và giá trị `?`, chưa thêm economy/level-up.
- Người dùng yêu cầu kiểm tra lại thống kê và đồng ý làm nếu đủ view/asset/data. Đã tìm được BattleStaticsWin với4 tab (gây damage, chịu damage, hồi máu do đơn vị tạo ra, kill), hai phía và thanh so sánh; ảnh nguồn đã được kiểm tra đủ trong audit. Data Zatod chưa có báo cáo/counter đầy đủ và combat event chưa mang source actor cho damage/heal; chưa đạt điều kiện nối ngay. Có thể bổ sung tổng hợp tại Damage/Heal/death, giữ xuyên wave và dựng lại khi replay; đây là phần công việc cần làm thêm, chưa coi là dữ liệu sẵn có. Lượt phản hồi này chỉ kiểm tra/cập nhật tài liệu, chưa triển khai runtime.

- Ngày21/11/2026: người dùng yêu cầu kiểm tra source/asset theo3 ảnh, **chưa code hoặc triển khai**. Rương trong trận dùng hình chung, không cần hiện loại item bên trong. Màn thắng tham chiếu sao, danh sách item, đội Hero/EXP và nút thống kê trong ảnh; phạm vi dữ liệu EXP/vàng/thống kê chưa chốt.
- Đã đối chiếu40 ảnh UI và7 FCA sao/cánh/ánh sáng/lên cấp có atlas/timeline đọc được. Dữ liệu thật hiện có: receipt GUID D26, sao, đội/portrait/rank/level; còn thiếu mapping loot vào quái/wave, reward EXP/vàng và thống kê attribution theo actor xuyên wave. Đề xuất, chưa duyệt: gắn sẵn loot vào địch, mỗi món một rương, tự thu về HUD; popup dùng receipt sau validate, nhóm xN chỉ để hiển thị, không stack Inventory; Continue không cấp lại.
- Giữ D17/D22/D25: đúng art Crystal, landscape responsive/safe area, rương/effect SpriteRenderer trong Battle scene, popup Canvas. Chưa mở rộng economy hay tự thêm phần chưa có dữ liệu.
- Khảo sát: docs/zatod-loot-presentation-review.md; bằng chứng Artifacts/ZatodLootPresentationReview/asset-audit.json. Không import/bake/thay config runtime trong lượt khảo sát.

### D28 — Hướng UI mặc/ghép đồ, bổ sung nguyên liệu và bỏ qua phí vàng

- **Ngày chốt:**21/11/2026. **Trạng thái:** đã chốt các điểm dưới đây, người dùng đã yêu cầu thực thi; đã triển khai config, nguyên liệu, giao dịch server và UI mặc/ghép, qua core4.933/Editor9/UI74/network14 checks và14 replay cũ; build Windows0 lỗi. Khảo sát và ảnh tĩnh tại `docs/zatod-equipment-crafting-review.md`, `Artifacts/ZatodEquipmentReview/`.
- UI phải theo bố cục/flow Crystal và dùng đúng asset nguồn, giữ responsive landscape/safe area D17/D22. Ảnh preview chỉ là bản dựng tham khảo, không coi đã import hoặc pixel-identical với runtime gốc.
- Người dùng cho phép bổ sung item/nguyên liệu còn thiếu để hỗ trợ các công thức liên quan; không cần hỏi lại quyền thêm từng loại. Audit hiện tại76 item/47 recipe/closure112, cần thêm36 loại; đây là baseline khảo sát, không phải giới hạn cấm bổ sung dependency cần thiết.
- **Lịch sử phase D28:** bỏ qua phí vàng khi ghép trong prototype, vẫn tiêu hao nguyên liệu và kiểm tra điều kiện mặc đồ. **Đã được quyết định mới D30 ngày21/11 thay thế ở thiết kế đích:** khi triển khai phase vàng sẽ thu GoldCost thật. Runtime D28 hiện vẫn thu0 cho tới lượt thực thi mới. Mô hình kho GUID riêng, không stack và hấp thụ giữ theo D08/D12.
- D12 từng bỏ qua toàn bộ craft để cấp item đích là phạm vi phase trước; D28 ghi hướng mở phase craft thật, không chỉ gọi hàm dev để tạo sản phẩm. Theo lệnh thực thi mới, các ô trang bị D23 đã có action mở popup/ghép/mặc. Quick Equip vẫn giữ phạm vi cũ, chưa nối.
- **Chốt bổ sung21/11:** có config craft riêng (hướng CraftRecipes.txt, chỉnh trong GameEditor), khai báo sản phẩm/số lượng, nguyên liệu/số lượng và phí vàng tham chiếu. Người dùng đồng ý các phần giữ model Hero/kho, craft theo GUID, xác nhận/lưu giao dịch ở server và chống xử lý lặp; giữ điều kiện mặc đồ và lịch sử trang bị. Giữ phí nguồn trong config, phí thực thu0 trong bản đã triển khai D28; quyết định D30 sau đó yêu cầu thu thật khi thực thi phase vàng. Đã tích hợp CraftRecipes.txt/GameEditor, ItemKind và operation ledger theo GUID; xem docs/zatod-crafting-implementation.md.
- **Đã chốt và yêu cầu thực thi21/11/2026:** thêm ItemKind ở ItemDefinition để phân biệt Equipment/Fragment/Material khi trình bày. Name/IconResource/Quality đã có. ItemKind chỉ phân loại chính, không quyết định món có được dùng làm nguyên liệu; trang bị hoàn chỉnh vẫn có thể là ingredient của recipe khác. Không nhân metadata vào từng GUID hoặc thêm FragmentData riêng. Công thức là nguồn xác định nguyên liệu/sản phẩm/count, chưa đề xuất lưu thêm FragmentOfItemId/RequiredFragmentCount trùng lặp ở item.
- Quick Craft/batch và phạm vi nguồn nhận/drop pool chưa được chốt riêng; không tự thêm Market/economy/Legendary. Schema đã cụ thể hóa và kiểm tra trong lượt triển khai; bàn giao tại Artifacts/ZatodCraftChecks/handoff.json.

### D29 — Nguồn nhận item và visual ải Crystal

- **Ngày:**21/11/2026. **Trạng thái hiện tại:** đã triển khai và nghiệm thu theo lệnh thực thi sau khảo sát; xem mục Nghiệm thu bên dưới. Các ghi nhận chưa code/runtime trong mục này là lịch sử của lượt review/preview ban đầu, khi người dùng yêu cầu kiểm tra trước.
- Đã đối chiếu Crystal: từ nguyên liệu thiếu mở Get Way, dùng thẻ nguồn Normal/Locked/Special; thẻ stage đã mở sang stagedetail kèm item/count. Nguồn lấy từ equip.Drop + How To Get. Chế độ không có recipe ẩn mainLayer1 và có Back, không dựng cây ghép trống. Đây là hành vi client source, không khẳng định backend đã được khôi phục.
- Zatod hiện theo D28 mới liệt kê tên nguồn từ DropItems; chưa có source-card/điều hướng đầy đủ. Scroll Bracer source116 có8 nguồn trong Crystal, trong khi pool Zatod hiện có3 nguồn2-5/2-8/2-20; giữ phân biệt, không đổi pool hoặc tự mở Elite/chapter/shop. Đề xuất kỹ thuật suy nguồn Campaign từ pool active để tránh lệch hai bảng; chưa triển khai schema/dispatcher mới.
- Đã audit39 ải:13 điểm có art riêng dùng12 ảnh nguồn,26 điểm dùng node thường. Mapping theo SourceStageId và resid, đặc biệt2-5 dùng stage-7.png. Hướng thay visual sau giữ ID, TargetId, tọa độ/radius/collider, unlock/progress và world lifecycle D21/D25; không chọn NPC/công trình bất kỳ hoặc chép đè bố trí world bằng map nguồn. Chưa thay C#/prefab/scene/config/art runtime trong lượt này.
- Ghi nhận lịch sử: trước khi người dùng chốt bổ sung dưới đây, cách nối source-card với world MMO còn để ngỏ. Các nguồn ngoài prototype chưa được chốt chi tiết; không tự thêm shop/summon/economy/backend mới. Giữ D04/D05/D12/D17/D22/D26/D28.
- Preview là dựng từ art/source, không phải capture Crystal đang chạy; inventory/unlock/stars là mẫu. Báo cáo/bằng chứng: `Artifacts/ZatodItemSourcesReview_20261121/README.txt`, `START_HERE.html`, `audit.json`, `stage-visual-mapping.csv`. Scene/config hiện có chưa được đổi.


- **Chốt bổ sung21/11/2026:** mỗi source cell có icon đúng ải ở đầu, sau đó Normal/Elite · Ch.N · phần tên đang hiển thị trong ảnh ref, cuối là mũi tên; nguồn khóa giữ trạng thái khóa/icon mờ. Đây là bổ sung presentation của Zatod có chủ đích so với Crystal gốc, không gắn nhãn là layout native. Icon resolve theo Stage ID/Stage Group/resid; node không có hình riêng dùng marker chung đúng nguồn. Đã dựng preview `Artifacts/ZatodItemSourcesReview_20261121/IconCells/START_HERE.html`; **chưa sửa runtime/scene/config**. Phần tên trong ref là Stage Name; chưa tự đổi thành Chapter Name.

- **Chốt lại21/11/2026 — tên English và không action nguồn:** tên ải hiển thị tiếng Anh từ localization Crystal, đồng nhất ở source cell, tên popup và nút tương tác ngoài map; không dùng tên Trung hoặc số thứ tự1-1 làm nhãn chính. Ví dụ Stage1=Embarkation, Stage23=Easy Prey. Giữ ID/SourceStageId/TargetId ổn định. Điều này thay hướng giữ raw CN Name của khảo sát/D20 trước đó; không tự mở rộng thành dịch các hệ thống khác.
- **Hành vi hiện tại đã chốt:** các source cell đã mở khóa chỉ để xem, chưa gắn action. Không mở popup ải, vào trận, teleport hoặc gọi di chuyển khi bấm nguồn. Mũi tên chỉ là hình ảnh. Về sau nhân vật sẽ tự di chuyển tới object ải trong thế giới MMO; chưa triển khai pathfinding trong lượt này. Không tự tắt action tương tác world hiện có khi avatar đã ở gần ải. Quyết định này thay việc còn để ngỏ cách nối source card trong ghi nhận trước; flow click-to-stagedetail Crystal giữ là tham chiếu lịch sử, không áp vào Zatod lúc này.
- **Trạng thái21/11:** preview IconCells đã dùng English và loại bỏ source hotspots/callback điều hướng; có ảnh nút map dùng tên.46 Stage IDs tham chiếu có tên English chính thức, gồm đủ39 ải active. Runtime config vẫn giữ tên raw CN/Label số, chưa migration trong lượt chỉ kiểm tra; code/prefab/scene/pool/Owned không đổi. Mapping `Artifacts/ZatodItemSourcesReview_20261121/IconCells/english-stage-names.json`.

- **Nghiệm thu21/11/2026 — đã triển khai:**39 tên English chính thức dùng chung source cell/popup/nút và nhãn map; Get Way có icon đúng ải, trạng thái khóa từ Campaign.IsUnlocked và chỉ hiển thị (không Button/callback điều hướng).39 object ải dùng13 hình riêng/26 node thường Crystal; giữ nguyên TargetId, tọa độ, va chạm, progress/pool/combat. Không triển khai tự di chuyển. Core4.933, Editor240, nguồn item UI71, craft/equip UI74, live world208 checks và14 replay cũ PASS. Windows build0 lỗi,218 file bundle khớp SHA256;9 Owned và2 scene giữ hash. Bản chuẩn Builds/ZatodPrototype đã cập nhật, local server22592 READY7788; Editor stopped/scene sạch/auto-tick=false/background override restored. Các ghi nhận chưa runtime bên trên là lịch sử khảo sát trước lệnh thực thi. Báo cáo docs/zatod-item-sources-implementation.md; restore/evidence Artifacts/ZatodItemSourcesChecks.

### D30 — EXP tài khoản/Hero, vàng và thể lực theo Crystal

- **Ngày chốt:**21/11/2026; yêu cầu thực thi22/11/2026. **Trạng thái: đã triển khai và nghiệm thu.** Core4.982, Hero112, Editor37, UI81, network21 và14 replay cũ PASS; Windows build0 lỗi/2 warning có sẵn.218 file build chuẩn khớpSHA256,10 hash Owned/scene giữ nguyên. Editor stopped/scene sạch/auto_tick=false, tab Progression đang mở; server test đã dừng, mainserver giữ trạng thái dừng ban đầu. Bằng chứng Artifacts/ZatodEconomyChecks/handoff.json; hướng dẫn docs/zatod-economy-implementation.md. Các ghi nhận chưa code bên dưới là lịch sử trước thực thi.
- Giữ bảng EXP lên cấp tài khoản, giới hạn level Hero theo cấp tài khoản và trần hồi thể lực từ Crystal PlayerLevel. Giữ curve EXP Hero riêng từ Levels. Không thay curve bằng công thức tự suy, không áp HeroLevel<=AccountLevel ở đầu game; accountLv1 cho Hero tớiLv10 theo bảng. Mặc định cap tài khoản trong client tham chiếu là100; nguồn có override từ server, không coi120 dòng Levels là cap Hero hoạt động độc lập.
- Giữ cơ chế cộng thưởng EXP ải của Crystal: EXP tài khoản riêng; tổng Heroexp Reward chia lấy phần nguyên cho số Hero tham chiến rồi cộng từng Hero hợp lệ. Đủ EXP tự lên cấp và giữ phần dư. Ở cap, giữ phân biệt policy tài khoản và Hero theo source, không dùng một phép reset0 chung. Các nhánh fail/timeout có thưởng theo field Fail Exp Reward đã xác nhận; không suy chủ động thoát cũng có thưởng giống nhau.
- Thêm định nghĩa các đồ EXP Hero còn thiếu theo nguồn: EXP Potion169/60, EXP Salve218/300, EXP Cheese290/1500, EXP Burger440/7500, EXP Pizza1609/75000. Tên/ảnh lấy đúng nguồn; GUID riêng theoD12. **Dùng/tiêu hao các đồ này để tăng EXP Hero để phase sau**, chưa nối nút hoặc request sử dụng trong phase kinh tế đang bàn. Đã import đủ5 dòng config/ảnh trong D30; consume vẫn để phase sau.
- Giữ số thưởng vàng từng ải theo Stage.Money Reward, độc lập với RNG drop itemD26. Bổ sung dữ liệu thưởng còn thiếu khi triển khai. **Chốt bổ sung21/11:** thu phí craft thật bằng CraftRecipe.GoldCost khi thực thi phase này, thay quyết định bỏ phí D28. Cần đủ vàng và nguyên liệu; server trừ vàng, tiêu hao nguyên liệu, tạo itemGUID và lưu receipt trong cùng giao dịch, rollback đủ cả tiền/đồ khi lưu lỗi, retry cùng operation không thu lại. Đã nối và kiểm tra phí thật trong D30.
- Giữ hồi/tiêu thể lực ordinary stage theo Crystal:1 điểm/360 giây, thời gian server, trần hồi theo PlayerLevel, bù thời gian offline; đủ toàn bộ Cost mới Challenge, trừ Cost-VitReturn khi vào và trừ VitReturn thêm sau thắng được xác nhận.39 ải hiện tại Cost6/Return5: thắng tổng6, thua mất1. Giữ thưởng thể lực lên cấp và phân biệt vượt trần hồi với các giới hạn mua/dùng đồ. Chưa tự mở shop diamond/VIP/giờ ăn hay các nguồn ngoài prototype.
- Màn thưởng phải phản ánh **cả EXP tài khoản và EXP của từng Hero tham chiến**; dữ liệu thưởng thật và tiến trình trước/sau sau settlement server. Placeholder0/0 và vàng? củaD27 là trạng thái triển khai cũ, được thay khi phase này có lệnh triển khai; đã nối trong bản D30 nghiệm thu. Replay/Continue/retry không được cấp lại thưởng; level-up sau trận không đổi snapshot level đầu trận dùng validate.
- **Model chốt lại21/11/2026 theo chỉ dẫn mới nhất:** account giữ CharacterData.Level và Exp riêng; từng Hero giữ HeroData.Level và Exp riêng. **Stamina là field riêng trên CharacterData, nằm ngay trước StaminaRecoveryTimestamp; hai field phải khai báo kế nhau để dễ bảo trì.** StaminaRecoveryTimestamp cũng là field trực tiếp trên CharacterData. Không lưu số dư Stamina trong Currencies. Currencies hiện chỉ có vàng, loại currency định danh bằng enum; loại mới chỉ thêm cuối, giữ mã/ý nghĩa đã lưu. Chỉ có một nguồn số dư thể lực. Ngưỡng EXP/cap/trần hồi lấy config chung. Quyết định này thay hướng vàng và stamina cùng nằm trong Currencies trước đó củaD30. Đã thêm field/enum và migration metadata một lần; giữ dữ liệu sở hữu, đọc Id string cũ tương thích.
- **Làm rõ Hero Levels21/11:** các Hero thông thường dùng cùng curve Levels.Exp theo cấp, không tạo một bảng EXP riêng cho mỗi Hero; từng Hero giữ tiến trình độc lập. Growth stats, sao, bậc và skill riêng không trở thành đồng nhất chỉ vì dùng chung curve EXP.
- **Lưu ý triển khai, chưa chốt chính sách mới:** số vàng/thể lực khởi tạo tài khoản mới và xử lý account test có Hero đã dùng DevLevel vượt cap account cần xác định trước thực thi. Giữ nguyên dữ liệu/lịch sử theoD07/D08/D11; không tự hạ Hero hoặc reset Owned. Việc thêm timestamp hồi không biến reset tiến trình ải theo launch thành reset tài nguyên.
- **Editor đã triển khai:** khu Progression trong GameEditor để chỉnh bảng cấp tài khoản, cấp Hero và rule thể lực; file Progression.txt và menu GameEditor/Progression. Ngưỡng EXP, cap Hero và trần thể lực thuộc config chung; Level/Exp hiện tại thuộc dữ liệu sở hữu, không ghi ngưỡng config vào từng người chơi.
- GiữD11 reset tiến trình ải theo launch; không tự áp unlock chương2Lv5 của Crystal vào world đang cho đi tự do. Không tự đổi pool còn thiếu gear, Promote UI, nâng sao/skill hoặc các phần độc lập khác.
- **Chốt bổ sung về các lưu ý21/11/2026:** currency enum mới chỉ thêm ở cuối và giữ mã/ý nghĩa các giá trị đã lưu; khi đầy hoặc vượt trần hồi thể lực thì dừng tích thời gian hồi, lúc giảm xuống dưới trần bắt đầu chu kỳ hồi mới. Giữ cơ chế lên cấp/EXP dư/cap như Crystal đã xác nhận. Giữ tiến trình tài khoản/Hero cũ khi migration; chưa duyệt một cách tự điều chỉnh level account cụ thể và không tự hạ Hero. Timestamp hồi là mốc thời gian server dùng tính chu kỳ chưa hoàn tất, đặt kế field Stamina trực tiếp trong CharacterData; không phải một bản sao số dư. Lượt này chỉ giải thích/cập nhật tài liệu, chưa triển khai.
- **Phạm vi lượt chốt lại model21/11:** người dùng yêu cầu tổng hợp toàn bộ các điểm đã chốt để đọc lại rồi mới thực thi. Chỉ cập nhật tài liệu, chưa sửa C#/config runtime/scene/prefab/Owned. Số vàng/thể lực ban đầu vẫn là đề xuất chưa được duyệt rõ (0vàng, đầy trầnLv1=60); không biến thành quyết định mặc định. Dữ liệu account dev vượt cap cần rà migration, giữ nguyên Hero/history; chưa chốt tự nâng level account để bù.
- **Làm rõ thuật ngữ22/11/2026:** Level/Exp của player là CharacterData.Level/Exp; avatar SPUM là visual của chính player, không đề xuất thêm một hệ AvatarLevel/AvatarExp độc lập. Cụm trước đó về EXP tài khoản không phải level riêng của SPUM chỉ phân biệt với cấp từng Hero trong đội, không chia player thành hai hệ tiến trình.
- **Làm rõ phạm vi item22/11/2026:**5 đồ EXP đã có định nghĩa và ảnh trong nguồn Crystal. Audit Items.txt active hiện112 item, chưa có5 dòng EXP này hoặc reference5 icon501/502/503/440/1609. Thêm định nghĩa ở đây là import/bổ sung các dòng config còn thiếu vào Items.txt của Zatod, dùng chung ItemDefinition/ItemData và ảnh nguồn có sẵn; không thiết kế5 class/model riêng hoặc tạo ảnh mới. Luồng consume vẫn để phase sau. Chưa sửa runtime trong lượt giải thích.
- **Lệnh thực thi22/11/2026:** người dùng đã yêu cầu triển khai phase theo bản tổng hợp và các làm rõ avatar/item. Dùng Progression.txt/tab Progression cho hai curve và rule thể lực, thu GoldCost thật. Đã triển khai và kiểm tra core4.982/Editor37/UI81/network21/14 replay; bản chuẩn đã cập nhật và khớp hash218 file ở bàn giao. Giữ Hero dev trên cap, không tự hạ hoặc tự nâng account, dừng cộng thêmEXP tới khi account đủ. Các câu ghi chưa runtime trước lệnh này là lịch sử, không phải trạng thái hiện tại.
- **Mặc định prototype khi thực thi22/11:**0 vàng và60/60 thể lực đặt trong Progression.txt để bản prototype chạy được ngay, có thể đổi quaGameEditor/Progression. Đây là lựa chọn cấu hình tạm của triển khai theo đề xuất đã trình, **chưa ghi thành balance khởi tạo được người dùng xác nhận riêng**; câu hỏi tùy chọn về giá trị khác vẫn có thể trả lời sau. Không xóa/hạ tiến trình cũ, không chạy profile test vào kho thật. Bản sao Owned/scene ban đầu được giữ hash; triển khai binary không tự migrate file Owned khi chưa đăng nhập.

### D31 — Inventory

- **Lệnh thực thi22/11/2026:** người dùng duyệt bản tổng hợp docs/zatod-inventory-phase-plan.md và yêu cầu thực thi. **Trạng thái: đã triển khai và nghiệm thu22/11/2026.** Core5.068/Hero112/Editor19/UI1.123/network15/replay16 PASS; Windows build0errors/1warning,218 file build chuẩn khớpSHA256.9 Owned/5scene giữ hash; server test đã tắt, Editor stopped/scene sạch/auto_tick=false, tab StarRules mở. Báo cáo docs/zatod-inventory-implementation.md, evidence Artifacts/ZatodInventoryChecks/handoff.json. Các ghi nhận chưa được yêu cầu thực thi bên dưới là lịch sử trước lệnh này. Giữ Owned/GUID/history, kiểm tra core/giao dịch/UI/Editor/replay và build trước nghiệm thu.

- **Ngày22/11/2026:** người dùng chọn Inventory cho phase kế tiếp, yêu cầu kiểm tra tab và phần chuẩn bị trước; chưa yêu cầu triển khai. Nguồn farm đồEXP/HeroTrial tiếp tục để tham khảo, không tự mở hệ đó hoặc sửa drop pool.
- Trạng thái khảo sát: source có4tab Items/Shards/Gears/Soulstones vàfiltercon;117địnhnghĩa active chia5goods/16shards/96gear, chưaSoulstones. Chi tiết docs/crystal-inventory-review.md; evidence Artifacts/CrystalInventoryReview_20261122/audit.json. Chưa sửa C#/config runtime/scene/prefab/Owned.
- GiữD12 mỗiGUID mộtslot, không biến gợi ý gộpô củaagent thành quyết định. Tabactive/placeholder, actionSell/Compose/Use/Summon và stats khi không chọnHero còn cần duyệt; không suy chọnphaseInventory là đã cho phép mọi chức năng khoCrystal. GiữD17/D22 artnative/responsive vàD29 sources chỉhiểnthị.
- **Đối chứng bổ sung22/11/2026:** người dùng cung cấp4 ảnh Items/Shards/Gears/Soulstones và yêu cầu làm rõ phần model còn thiếu, chưa yêu cầu thực thi. Kết quả tại mục8 của docs/crystal-inventory-review.md: giữ kho GUID hiện tại; đề xuất metadata tab/filter/mô tả/giá bán, tái sử dụng recipe cho mảnh; Soulstones còn thiếu config liên kết Hero/InitialStars/triệu hồi/nâng sao. Đây là khảo sát và đề xuất, chưa phải duyệt các field hoặc mở phạm vi Sell/QuickCraft/Use/Summon. Ảnh gộp xN không tự thay D12; STR trên ảnh không thay D05.
- **Chốt bổ sung22/11/2026 sau đối chứng:** người dùng nhắc lại mỗi item một ô; ảnh chỉ tham khảo, không gộp ô cùng loại ở tầng hiển thị. Áp dụng cả mảnh, đồ tiêu hao và Soulstone nếu được bổ sung. Người dùng yêu cầu phần chức năng đã nêu phải được thực hiện trong phase Inventory, item chưa có nguồn nhận để phần source trống. Ghi phạm vi chức năng đang tổng hợp là Sell/craft từ Inventory/Quick Craft/dùng đồ EXP/Soulstones triệu hồi và nâng sao; không tự mở các hệ ticket/rương/sự kiện/Market ngoài nội dung hiện tại. Nguồn nhận vẫn chỉ hiển thị theo D29; không tự thêm drop để lấp chỗ trống. **Trạng thái:** đang làm rõ thiết kế stats/metadata/Soulstones theo câu hỏi hiện tại, chưa triển khai runtime. Phương án cụ thể tại mục9 bản khảo sát là đề xuất để duyệt, không coi câu đồng ý phạm vi là đã duyệt mọi chi tiết.
- **Duyệt thiết kế tiếp22/11/2026:** bỏ bonus item theo Hero như cập nhật D05; cho phép bổ sung metadata cần cho Inventory theo Crystal (tab/filter/mô tả/giá bán). Người dùng đồng ý phương án Soulstones tại mục9 bản khảo sát: item GUID riêng, liên kết Hero/sao khởi đầu, rule triệu hồi/nâng sao theo Crystal, giao dịch server và grid chỉ gồm item thật. Các config bổ sung phải chỉnh được trong GameEditor để balance, gồm metadata item, liên kết Hero/Soulstone và bảng ngưỡng/chi phí/số sao. Không có nguồn nhận thì để source trống; không tự sửa drop pool. **Trạng thái:** đang tổng kết lưu ý trước thực thi, chưa sửa C#/runtime config/Editor/assets/Owned. Chi tiết thao tác Quick Craft ở mục10 bản khảo sát vẫn là đề xuất, chưa biến thành hành vi đã duyệt riêng.
- **Chốt tiếp22/11/2026:** người dùng chấp nhận giảm sức mạnh do bỏ bonus riêng; cân bằng bằng base stats sẽ xem về sau, không cộng bù base ngay. Đồng ý Quick Craft chỉ ghép mảnh thành sản phẩm trực tiếp, không tự chạy chuỗi recipe đệ quy, có xem trước và xác nhận; đồng ý chọn Hero đích khi dùng đồ EXP và giới hạn theo D30. Tiếp tục yêu cầu kiểm tra flow Crystal/preview trước, chưa yêu cầu triển khai runtime. Mục11 bản khảo sát ghi quan sát nguồn: Quick Craft chọn loại và ghép tối đa theo số mảnh, thiếu vàng thì báo lỗi; EXP qua Hero Detail/Lvl Up, chọn level đích và tự tính đồ tiêu. Chi tiết popup EXP/đường từ Inventory được trình để đối chiếu, chưa suy là user đã duyệt mọi khác biệt với Crystal.
- **Xác nhận tiếp22/11/2026:** người dùng đồng ý các phần stats/Quick Craft sau đối chiếu (chọn loại, tối đa theo mảnh, báo thiếu vàng thay vì tự giảm batch), hỏi lại việc hệ thống tự chọn loại/lượng đồ EXP theo level đích. Đã kiểm tra source: ưu tiên lần lượt Potion/Salve/Cheese/Burger/Pizza theo kho, không phải thuật toán tối ưu tổ hợp ít dư nhất; EXP thuốc nguyên món có thể vượt mức cần và UI điều chỉnh level đích nếu thực tế lên nhiều cấp hơn. Đây là giải thích hành vi nguồn, chưa có lệnh triển khai runtime hoặc chốt mới về thuật toán dùng EXP trong lượt hỏi này.
- **Tổng hợp phase22/11/2026:** sau phần giải thích EXP, người dùng nói oke và yêu cầu trình bày lại những phần sẽ triển khai. Bản tổng hợp để duyệt trước thực thi: docs/zatod-inventory-phase-plan.md. Bao gồm4 tab UI native/responsive/mỗiGUID một ô, metadata và bỏ bonus item theo Hero, Sell, craft/Quick Craft trực tiếp, dùng5 đồEXP bằng popup level đích (hai đường Hero Detail và Inventory/chọnHero), Soulstones Recruit/Star Up theo rule nguồn, config GameEditor và kiểm tra giao dịch/save/replay. Chưa có lệnh thực thi runtime ở lượt tổng hợp này; các chi tiết kỹ thuật trong kế hoạch không tự trở thành feature mới ngoài phạm vi.
- **Đổi hướng khi đang triển khai22/11/2026:** người dùng yêu cầu stack UI mộticon/xN thay mộtGUID/mộtô, vẫn giữ GUID; nhắc lại art Crystal. Áp dụng cập nhật D12: group theo ItemId để hiển thị, giữ từng instance sở hữu; Sell chọn số lượng trong nhóm và tiêu đúng GUID. Cập nhật kế hoạch, UI và các bài kiểm tra; không reset kho hoặc nhập một số dư Quantity cạnh danh sách GUID. Bản build/check trước chỉ dẫn này là kết quả trung gian, cần kiểm tra/build lại bản mới.
- **Làm sát UI tham chiếu22/11/2026:** người dùng gửi lại4 ảnh sau khi đổi stack, yêu cầu follow bố cục Crystal, nhấn mạnh Soulstones hiện chưa giống. Soulstones chuyển sang projection Hero: Hero đã sở hữu và Heroes Not Owned, có cả Hero0 đá, level/sao/khung bậc thật (Hero chưa có dùng sao khởi đầu, không giả level), progress tím owned/required và trạng thái Star-Up/Recruit theo đủ đá. Những card0 đá là thông tin catalog, không tạo ItemData hoặc GUID giả trong Inventory. Panel trái dùng icon đá, grid dùng portrait Hero. Chỉ dẫn này thay bố cục stone-icon/không hiện Hero0 đá trước đó. Các tab khác theo lưới8 cột ở bố cục tham chiếu, tab selected/normal, font/asset nguồn, Source rows và thông tin giá phù hợp; giữ responsive/safe area. Đã triển khai và kiểm tra lại theo layout này; ảnh reference-final-* trong Artifacts/ZatodInventoryChecks/ui. Không coi preview cũ là bản cuối.

- **Bổ sung đã chốt22/11/2026:** danh sách List of Heroes cũng phải hiện glow/nhãn Star-Up trên portrait khi Hero chưa chạm trần sao và đủ loại Soulstone/ngưỡng sao kế. Cùng điều kiện với Inventory Soulstones; không lấy tổng đá của Hero khác hoặc dùng ngưỡng triệu hồi. Snapshot mới sau tiêu/nhận đá hoặc nâng sao cập nhật dấu hiệu. Chỉ báo đủ đá, chi phí Gold vẫn được kiểm khi xác nhận giao dịch. Đã triển khai và kiểm chứng hiển thị/tắt/bật lại khi đá đổi và khi chạm cap trong UI1.123 checks.

### D32 — Chuẩn bị Android và màn vào server LAN đơn giản

- **Nghiệm thu22/11/2026:** đã triển khai login tên + tự dò LAN, NPC Arena/PvP/Replay và Formation dùng chung với Phó bản. Windows build cuối0 lỗi/2 warnings; core5075, UI86 và hai client Campaign/Arena/PvP/LAN reconnect PASS. APK ARM64 đã build headless thành công0 lỗi/33 warnings; file cài561.661.890byte (535,64MiB), đúng appid/quyền mạng, install-r thành công trên OPPO Pad Air. Đã quan sát Android vào Town, thấy nhân vật Windows và mở Inventory; server xác nhận kết nối Wi-Fi192.168.0.2→192.168.0.5:7788, không dùngadb reverse. Chưa nghiệm thu Android thứ2 hoặc trận đấu vật lý Windows–Android; không coi kiểm thử standalone cùngPC thay thế các bước đó.
- Server thật và Windows client được giữ chạy từ bản Desktop, kho cũ không reset. APK chỉ tạo ở thư mục tạm PC rồi cài USB. Quy trình Android ưu tiên headless để tránh Editor DX12 vượt VRAM (BUG-059); helper đã sửa subtarget Android không dùng giá trị StandalonePlayer (BUG-058). Chi tiết và cách build lại: docs/zatod-lan-login-android-implementation.md, Scripts/Build-ZatodAndroid.ps1. Bằng chứng: Artifacts/ZatodLanLoginChecks/. Các ghi nhận chưa cài/build bên dưới là lịch sử khảo sát trước thực thi.




- **Chốt UI bổ sung22/11/2026 khi đang thực thi:** chọn đội Arena/PvP dùng đúngViewFormation củaPhóbản (roster/filter/team/battle), phầnchưacódữliệuenemy/wave/description/cost/reward/power đểtrống. Không dựngstagegiảđểdùngUI; callbackphânbiệtmode. NPCReplayvẫn mởdanhsáchreplay. Đangápphạmvivàkiểmtralại.

- **Lệnh thực thi22/11/2026:** người dùng đã nói “Oke giờ em thực thi đi”. Triển khai login tên/GUID riêng, tự tìm server LAN khi đổi mạng, NPC Arena/PvP/Replay, toolchain Android, Windows/server xuấtDesktop và AndroidAPK tạmPC cài/chạy trên tablet. Các ghi nhận chỉ khảo sát phía dưới là lịch sử trước lệnh này. Giữ tiến trình/GUID/history; không tự xóa app/data tablet khi deploy. Đang triển khai, chưa nghiệm thu3thiếtbị.

- **Yêu cầu22/11/2026:** người dùng muốn chuẩn bị build Android; máy PC hiện tại chạy server chung trên LAN (mạng DoubleMeow), thử1 Windows client và2 Android client. Thay màn kết nối prototype trong ảnh bằng View nhập tên + Kết nối, vào world chung, chưa có đăng ký/mật khẩu/auth chính thức. Giữ art Crystal/responsive landscape D17/D22 và điều khiển D24.
- **Trạng thái:** đang kiểm tra/làm rõ trước triển khai theo câu hỏi “kiểm tra xem có lưu ý gì không” và giới hạn chưa code của lượt trước. Chưa cài module, đổi mạng/router/firewall, sửa runtime hoặc build APK trong lượt khảo sát này. Không tự biến việc đồng ý hướng thành đã triển khai hoặc đã nghiệm thu3 thiết bị.
- Phát hiện hiện trạng: PC nối Double Meow 5G, IPv4 Wi-Fi192.168.0.5. AndroidPlayer module chưa có; ổC74.8GiB trống/ổE9.3GiB. CharacterData đã có Name nhưng JoinWorld vẫn tạo nhãn Player +5ký tựGUID. Màn prototype cũ còn được dùng bởi menu Arena/PvP/Replay, cần tách phần kết nối khỏi menu chức năng khi thực thi.
- **Đề xuất đang chờ chốt, không là hành vi đã duyệt riêng:** tên chỉ là display name, giữ GUID riêng theo thiết bị để giữ kho/progress và tránh dùng tên làm account key; server xác nhận tên và đồng bộ cho peers. Địa chỉ server nằm trong cấu hình test thay ô IP ở màn chính; cần chính sách IP ổn định/đổi địa chỉ khi DHCP thay đổi. Không reset Owned hoặc giả định cùng tên trên hai máy là cùng account. Chưa chọn chính sách tên trùng/đổi tên hoặc giao diện chỉnh endpoint.
- Khảo sát/lưu ý tại docs/zatod-lan-login-android-plan.md. Kiểm tra LAN cùng host trước đây không thay kiểm thử1 Windows +2 Android vật lý.

- **Làm rõ yêu cầu tiếp22/11/2026:** người dùng đồng ý giữ GUID theo thiết bị/tên hiển thị; muốn di chuyển PC sang mạng khác và các client cùngLAN vẫn vào server chung, không phụ thuộc IP ở nhà. Yêu cầu Arena/PvP/Replay chuyển sang NPC; tự cài các thành phần Android còn thiếu khi thực thi và tạo thư mục build trên Desktop. Không cần hỏi lại quyền cài dependency hoặc ghi build ở Desktop trong phạm vi này.
- **Hướng triển khai đề xuất cho đổi mạng:** discovery LAN tự tìm server Zatod và endpoint hiện tại, thay việc cố định IP192.168.0.5 trong APK. Cùng Wi-Fi/LAN cần router cho phép peer traffic; office/guest isolation có thể chặn discovery lẫn game. Không tự đổi router/profile/firewall trong lượt rà yêu cầu. Chưa có discovery runtime ở bản hiện tại.
- **Đích output đã xác nhận và tạo:** C:/Users/tinnq/OneDrive/Desktop/Zatod Legend LAN Test, gồm Windows/Android/Server. Chưa có build phaseD32 trong các folder này. Preflight CLI nhận đủ Android/SDK/NDK/JDK cho6000.6.2f1; mới dry-run, chưa cài/accept license/đổi target/sửa runtime. Editor đang Play của người dùng được giữ nguyên. Lượt này tiếp tục rà yêu cầu; các câu “tự cài”/“tạo folder” là quyền cho phần chuẩn bị và output, không coi dry-run là đã có APK.


- **Đổi đích Android22/11/2026:** người dùng đã cắm tablet, yêu cầu khi build Android thì cài/chạy trực tiếp trên tablet quaUSB, không cần xuất vào thư mụcAndroid trênDesktop. Build vẫn biên dịch/tạoAPK tạm trênPC trước khi deploy; Windows/server vẫn dùng thư mụcDesktop đã yêu cầu. Không xóa dữ liệu app/Owned hoặc gỡ app cũ chỉ để cài nếu có xung đột.
- **Thiết bị đã kiểm tra:** Windows nhận OPPO Pad Air (OPD2102A), ADB ban đầu unauthorized; sau người dùng chọn Cho phép USB debugging, trạng thái device. Đọc được Android13/API33, arm64-v8a (có tương thích32bit), dung lượng /data trống khoảng11G, Wi-Fi192.168.0.2 cùngsubnetPC192.168.0.5. Chưa cài/chạy APK hoặc nghiệm thu gameplayAndroid; kiểm nc TCP không thực hiện vì thiết bị không có tùy chọn zero-I/O. ADB lấy từ bộ Unity2022 có sẵn để kiểm thiết bị; không đồng nghĩa toolchainAndroid6000.6.2f1 đã cài.

### D33 — Loại bỏ prototype trước Crystal và các bản build cũ

- **Ngày chốt22/11/2026:** người dùng yêu cầu xóa Hero/art, logic combat/network/replay, UI, scene và công cụ prototype trước khi import Crystal vì không còn sử dụng; bổ sung xóa cả các bản build cũ. Đây là lệnh triển khai, không chỉ khảo sát.
- Chỉ dẫn này thay yêu cầu giữ art/runtime pixel cũ tạiD04/D10/D16 và nhánh prototype20Hz tạiD02 trong phạm vi phần không còn được flowCrystal hiện tại dùng. Loại các entrypoint/bản preview cũ và build kiểm thử đã lỗi thời; giữ phần model, serializer, animation/UI helper hoặc validation vẫn được gameCrystal hiện tại dùng. Không suy tên file không có tiền tốZatod là đồ cũ phải xóa.
- Giữ nguyên GUID/sở hữu/lịch sử Hero,item,save và replay trên đĩa; không reset dữ liệu người dùng. Có thể bỏ player/logic xem replay của prototype trướcCrystal, các archive của nhánh đó giữ làm dữ liệu lịch sử, không còn cam kết xem được bằng bản mới. Replay Crystal/Zatod hiện hành và snapshot của chúng vẫn phải hoạt động. Giữ nguồn reverseCrystal và assetCrystal đang dùng.
- Đo riêng dung lượng source/project và bản build sau khi dọn; chưa sửa lỗi nénBC7 củaBUG-056 hoặc tự đổi cách bake/quality/timeline trong lượt này. Xóa build lịch sử và các bảnPlayer trongArtifacts, giữ report/save/bằng chứng nhỏ; thay bản đang dùng sau kiểm chứng để tránh xóa file đang chạy.
- **Trạng thái22/11/2026:** đã loại nhánh cũ và kiểm tra core5068/Hero112/Editor235; build Windows0errors/2warnings, standalone Campaign/Arena/PvP/replay/reset/GUID PASS. Xóa10build lịch sử trong project(~48,92GiB),5build ngoàiC(~53,62GiB) sau người dùng cho phép riêng. Project đo97,83→48,85GiB; giữ1bản chuẩn đang chạy. Build kiểm tra10,75→10,69GiB(~66,73MiB giảm), đo trước khi khôi phục nguyên packContent/TreasureHunter hậuCrystal; số này không phải buildD32 cuối.993asset/metaContent được phục hồi nguyênHEAD, quét không còn reference mới gãy.115file protected ban đầu giữhash; lần cuối chỉtown.txt đổi bởiD32 song song, Owned/archive không đổi. Không sửaBC7/padding/quality. Đã xóaPlayer test sau đo/kiểm, nhườngEditor và deploy bản chuẩn cuối cho chatD32 để tránhrestart chồng; giữ mainserver/client cũ đang chạy. Điểm khôi phục source/asset đãtrack: gitHEAD1f9cc6ce4a2bcdc2520c76c9fd7ea6b7f2ba5d3e; evidenceArtifacts/ZatodLegacyCleanup/handoff.json. Các file sửa có bản nhỏedited-before; không tạo backupfullPlayer mới.


### Chuẩn bị iOS — được yêu cầu triển khai (23/11/2026)

- Người dùng yêu cầu kiểm tra setup/tài nguyên iOS, chưa thực thi. Đã xác nhận có Mac mini AppleM4/macOS Tahoe26.6.2, iPhone11/iOS27, chưa có membership Apple Developer trả phí. Chưa cài module/SDK, switch target, sửa gameplay/config hoặc export/build iOS.
- Project chưa có iOS module ở Editor Windows, helper/profile/signing/BundleID iOS và cấu hình quyền LAN riêng. Khảo sát tại docs/zatod-ios-readiness-review.md, nhật ký REVIEW-007. Hướng Unity xuất Xcode rồi Mac ký/cài, Personal Team miễn phí có thời hạn, Metal/ARM64 và dùng lại art là kết quả đánh giá/đề xuất, chưa phải lệnh thực thi.
- **Chốt bổ sung23/11/2026:** dùng IP trực tiếp/unicast cho bản test iOS ban đầu. Đây là ngoại lệ có phạm vi iOS đối với yêu cầu tự dò ởD32; không đổi discovery Windows/Android. Server tiếp tục ởPC Windows. Chưa triển khai runtime/UI, cài module hoặc build; Bonjour/broadcast iOS chưa chọn.
- Cùng LAN cho phép các máy liên lạc, không tự cung cấp địa chỉ server khi dùng IP trực tiếp. Khi PC đổi mạng và nhận IPv4 LAN mới, client iOS cần cập nhật địa chỉ PC; port game hiện7788. Hướng UI đề xuất là Name + Server IP + Connect, lưu IP gần nhất và cho sửa để không cần rebuild khi đổi mạng; không hardcode IP gia đình. Ô IP này chưa có trong bản hiện tại.
- Không bắt buộc clone toàn bộ Unity project lênMac nếu chỉ nhận folder Xcode export từWindows để ký/build/cài bằngXcode. Clone/chuyển source chỉ cần khi phát triển hoặc chạyUnity trênMac. Dùng IP trực tiếp vẫn phải khai báo/xin quyền Local Network của iOS.
- **Lệnh triển khai23/11/2026:** người dùng yêu cầu thêm Server IP cho iOS vàAndroid, Android tự dò/điền để không phải gõ khi mạng không đổi, thiết lập và xuấtXcode cùng hướng dẫn mang sangMac ký/build/cài. Áp dụng form chung cảdesktop để nhất quán; iOS directTCP, Android/desktop tự dò điền trước và vẫn nhập tay được. Lưu địa chỉ đã kết nối thành công theoprofile, không hardcodeIP mạng nhà. NútFind LAN tìm lại khi đổi mạng; nhập tay không bị kết quả tự dò ghi đè. Không thay account/GUID/kho/replay/serverdata.
- **Đang thực thi:** đã cài iOS Build Support6000.6.2f1; source login và helper xuấtXcode đang chỉnh/kiểm. XuấtWindows headless theoBUG-059; cấu hình iOS ARM64/Metal/landscape, giữminOS15.0, BundleIDcom.zatodlegend.lantest, ASTC6x6 riêng cho sheets nhập, Local Network purpose string. Team/signing trênMac do người dùng chọn bằngApple Account; chưa coi exportWindows là đã nativecompile/ký/cài hoặc testiPhone.
- **Kiểm chứng23/11:** source login PASS27UI+7TCP/UDP/reconnect trêncổngtest riêng, giữGUID. Xcode exportSucceeded0errors/6warnings; thưmụcDesktop/Zatod Legend LAN Test/iOS/Xcode-20261123-103416, ZIP774MiB/4.989file CRC PASS. Audit767sheet giữGUID/vùngsprite/Androidoverride; 36fileconfig/save giữhash. CPPiOS xácnhậnCanDiscoverLan=false, plist cóquyềnLAN vàchỉlandscape. ĐãdừngEditor/server test. AndroidAPK cóUI mới đangbuild; chưacàiAPK này hoặc nghiệmthuMac/iPhone. Hướngdẫntrongdocs/zatod-ios-build-and-install.md vàSTART-HERE.md trongZIP. Lỗicôngcụ/harness đượcghitrongBUG-061, khôngcoilàlỗigame đãsửa.
- **Bàn giao23/11:** hoàn tất yêu cầu source login iOS/Android và xuấtXcode. AndroidAPK mớiSucceeded0errors/6warnings, ARM64/IL2CPP/ASTC,561.668.262byte(~535,65MiB); đãkiểm manifest/appid/INTERNET, chuỗiUI Server IP/Find LAN, CRC vàchữký. FileDesktop/Zatod Legend LAN Test/Android/ZatodLegend-ServerIP-20261123.apk. Khôngcótablet trongADB nênchưacàiAPK mới. XcodeZIP811.635.589byte(~774MiB),3,33GiB giảinén, bảo toànquyềnchạytoolMac. NativeXcodecompile/ký/càiiPhone cầnthực hiệntrênMac; khôngbáođãtestiPhone. Khôngrebuild/restartWindowsserver/client cũtrongphase này. EditorZatod trởvềđóng nhưbanđầu, active targetAndroid; khôngđụngEditorTreasureHunter. BằngchứngtổnghợpArtifacts/ZatodIosChecks/handoff.json.
- **Bảo trì build23/11 — BUG-062:** người dùng build trênMac gặpGameAssembly sandboxdeny mkdir/read IL2CPP. Helper export bổ sung `ENABLE_USER_SCRIPT_SANDBOXING=NO` riêng targetGameAssembly cho mọi cấu hình; giữ Team/BundleID, quyềnLAN và sandboxruntime củaapp. Đã kiểm setter bằngSDKUnity6000.6.2f1 trênbảnsaopbxproj,4configs/roundtrip/idempotence PASS; chưa có xácnhậnMacbuild sau sửa. ZIP đãgiao không thayđổi; hướngdẫn chỉnhsetting trực tiếp trênMac trongdocs/zatod-ios-build-and-install.md.
- **Bảo trì build23/11 — BUG-063:** ảnhMac tiếp theo khớp lỗiModule Verifier củaUnityFramework. Helper đặt `ENABLE_MODULE_VERIFIER=NO` riêngUnityFramework cho4configs; giữmodulecompiler, signing vàheaderengine. SDKPBXProject roundtrip/idempotence PASS cùngBUG-062; nativeMacbuild sauworkaround chưa được xácnhận. ZIPcũ cầnchỉnhsettingtrực tiếp, khôngcoiđã cóbảnZIP mới hoặcđã sửaheaderFramework đểphânphốiđộclập.

- **Chốt luồng test từ xa23/11/2026:** người dùng chọn Sideloadly và yêu cầu hướng dẫn đầy đủ phương án miễn phí. Mac biên dịch app iOS/đóng góiIPA; PC Windows ở nhà dùng Apple Account miễn phí ký/cài và gia hạn quaUSB hoặcWi-Fi sau ghép đôi. Không yêu cầu muaAppleDeveloper/TestFlight, không cần iPhone nốiMac cho mỗi lầnbuild. Profile miễn phí vẫn hết hạn7ngày; tựrefresh phụ thuộc PC/thiết bị kết nối được. GiữAppleAccount/BundleID hiệu lực khi cập nhật, không gỡapp/reset dữ liệu để giải quyết xung đột. **Trạng thái:** bổ sung hướng dẫn trongdocs/zatod-ios-build-and-install.md; người dùng đã xác nhận remote Windows vàoMac vàSideloadly trênWindows hiện tên iPhone; chưa xác nhận nativebuildIPA, ký/càiZatod hoặc refreshWi-Fi. Hướng dẫn không đồng nghĩa đã tự động hóa build/deploy.

- **Bảo trì cài iOS 23/11 — BUG-064:** người dùng cài qua Sideloadly gặp lỗi xác minh chữ ký UnityRuntime.framework. Đã kiểm IPA tải về và tạo IPA workaround bỏ riêng artifact build-only này, giữ 44 entries khác theo SHA256. Helper export bỏ nhúng UnityRuntime ở main app, vẫn giữ linker reference ở UnityFramework; SDK roundtrip/idempotence/linker/signing checks PASS. Bản `Artifacts/ZatodIosChecks/SigningFix/ZatodLegend-SigningFix.ipa` cần Sideloadly ký/cài lại; chưa xác nhận cài/chạy iPhone. Không đổi quyết định miễn phí, Team/Bundle ID hay dữ liệu app.

### D34 — Mở rộng tới Tím và danh sách Hero PvP riêng

- **Ngày chốt:**23/11/2026. **Trạng thái:** đã đồng ý hướng/phạm vi chính, chưa triển khai; làm sau phase nềnD35. Khảo sát nguồn: `docs/zatod-purple-pvp-phase-review.md`. Các nhận định chưa chốt từ lượt khảo sát ban đầu được thay bằng quyết định hiện hành ở đây.
- Mở chương3–8 Normal để Hero phát triển tới **Tím thường**, gồm các bậc trung gian Blue+1/Blue+2. Điều này thay giới hạn Blue củaD11 cho phase nội dung, chưa mở Tím+1 trở lên. GiữD05 stat trực tiếp vàD08 lịch sử trang bị/hấp thụ, không chỉ đổi màu rank.
- Phạm vi nguồn được đồng ý: thêm115 ải/345 wave; tổng8 chương/154 ải/462 wave. Cần đủ world map/portal/điểm tương tác, encounter, preview/cost/reward, item/recipe, animation/effect/hook và GameEditor. Không chỉ thêm Stage JSON.
- Khoảng40 Hero chọn riêng cho PvP realtime, gồm25 hiện có và15 Hero Razor/WR/CM/Naga/SG/TH/OD/Ursa/Sil/Luna/VS/POM/Huskar/Lich/KOTL. Dùng định nghĩa chung, server tạo dữ liệu trận test riêng; **giữ HeroDesk hiện có**, không cấp40 Hero vào sở hữu hoặc nâng rank sở hữu để testPvP. Mỗi đội vẫn tối đa5; chưa yêu cầu đổi Arena auto.
- Preset đã đồng ý:Lv60/3sao/Tím thường, chưa mặc các ô đồTím; giữ đóng góp đúng của các bậc trước theoD08. Mức skillPvP đã được đề xuất theohelpernguồn=HeroLevel/basic1, cần đưa rõ vào bản kế hoạchD34 trước thực thi; không coi việc tạo modelD35 là đã áp preset này vào runtime.
- TổngHeroDefinition toàn project có thể vượt40 do encounter chương mới;40 là mục tiêu poolPvP, không phải giới hạn cấm nhập Hero địch cần thiết.
- Source preview/recipe khảo sát cho thấy tới chương7 đủ loại để tiến vàoTím và tới chương8 đủ ô đồTím theo các tập Hero đã audit. Đây không phải xác nhận loot backend Crystal hoặc poolZatod đã hoàn tất; cần kiểm lượng đồ, Gold/stamina, độ khó và vòng phụ thuộc farm khi triển khai nội dung.
- Người dùng đã đồng ý tối nền theo đường manual ultimate/freeze đã đối chiếu. Fade xác/timeline chết được hỏi khảo sát; kết luận nguồn là DeathDuration từngHero+2s chờ+1s fade, có ngoại lệ; chưa tự coi câu đồng ý tối nền là chốt mọi thay đổi xác chết. Cả hai presentation chưa thuộcD35.
- **Chưa cần lưu tiến trình ải**: giữ reset sao/unlock theo launchD11. Không hỏi lại persistence như việc bắt buộc củaD34. Quyết định đã chốt không cần xin lại; vẫn phân biệt đồng ý thiết kế với lệnh triển khai.

### D35 — Hoàn thiện hệ thống skill và Promote trước mở rộng nội dung

- **Tiếp tục và chỉnh UI ngày 24/11/2026:** người dùng yêu cầu tiếp quản chat bị kẹt và làm UI Skill theo ảnh ref. Đã chuyển sang bố cục hai vùng: Hero idle giữa bốn vị trí skill bên trái; Intro/Details, mốc Evo và nâng cấp bên phải. Slot Tím chỉ là metadata/icon khóa từ Crystal, chưa mở D34; vẫn chỉ thu vàng. Kiểm 25 Hero, Intro/Details/Base và responsive 4 tỷ lệ + safe area đã qua; core 7.970/HeroChecks 112 vẫn PASS. Unity export và Xcode ARM64 unsigned build đã thành công; IPA đã đóng gói và kiểm ZIP CRC/bundle/arm64/unsigned thành công. Chưa kiểm cài/chạy iPhone. Xem báo cáo thực thi để lấy artifact/trạng thái cuối; các ghi chú dung lượng trước đây là lịch sử.

- **Lệnh triển khai ngày 24/11/2026:** người dùng giao thực thi phase này và build IPA chưa ký sau khi code/kiểm tra hoàn tất. Đang triển khai trên nhánh `codex/skill-promote-d35`, restore point `3d774252d`. Phạm vi/tiêu chí theo phase-plan; chưa đánh dấu nghiệm thu. Theo dõi `docs/zatod-skill-promote-implementation.md`.
- **Ngày chốt:**23/11/2026, gồm các lượt đối chiếu source, giải thích ví dụ và đồng ý model cuối. **Trạng thái cập nhật 24/11:** đang triển khai; core PASS 7.970 assertions, HeroChecks PASS 112; UI/Editor/network đã kiểm trong bản sao cô lập, native build đã qua; thiết bị chưa kiểm lại. Bản bàn giao: `docs/zatod-skill-promote-phase-plan.md`; bằng chứng nguồn: `docs/zatod-skill-promote-review.md` và `docs/reference/zatod-skill-promote-source.json`. Dữ liệu trongArtifacts chỉ là evidence local, không là đầu vào duy nhất cho agent khác.
- Phase hiện tại hoàn thiện hệ thống quản lý/nâng skill, **giữ SkillEvo**, Quick Equip và Promote trên model/combat core đã có. Các chương3–8, pool40 PvP và mở rộng nội dung Tím củaD34 tiếp tục sau phần nền này. GiữD11 reset tiến trình ải theo launch; chưa làm persistence Campaign.
- **Model SkillEvo đã được duyệt:** thêm `SkillDefinition.Evolutions` trong configSkills.txt/tabSkills GameEditor. Mỗi mốc cóId ổn định, RequiredSkillLevel, Description, ParameterChanges và TriggeredEffects. Biểu diễn thay/add tham số rõ ràng, tái sử dụng buff/effect/hook cho tác động mới. Không giới hạn cứng ba mốc hoặc dùng index dòng làm ID. Các class/copy/validation đã triển khai và kiểm core ngày24/11; không đồng nghĩa toàn phase đã nghiệm thu.
- `HeroSkillData` tiếp tục lưu SlotId/Level, **không thêm EvoLevel/EvoExp song song**. Evo xác định từ level skill trên config; áp các mốc đủ điều kiện theo thứ tự xác định, tích lũy tác động của các mốc trước. Nâng qua ngưỡng mở Evo trong cùng giao dịch nâng skill, không thêm slot thứ5 hoặc thao tác mở Evo riêng. Skill vẫn phải được mở theo bậc trước khi sử dụng.
- `BattleSkillData`/snapshot chụp level và đầy đủ configEvo, buff/effect phụ thuộc. Client/checker/replay giải cùng luật từ dữ liệu đã chụp. Apply thay đổi lên skill/caster runtime riêng, không sửa config chung. Đổi config hoặc tiến trình sở hữu sau đó không làm replay cũ tự nhậnEvo mới; khi thay logic cần rules compatibility/version phù hợp.
- **Khởi tạo skill mới:** theo Init Level của từngslot/config nguồn; bộ25 Hero hiện có là1/1/21/41. Level hiện tại là tiến trình trongHeroData, không phải dữ liệu config. Các slot đang khóa có thể giữ seed cao hơnHeroLevel nhưng chưa được dùng/nâng.
- **Save cũ và giao dịch đã duyệt:** migration theoSlotId, chỉ thêm slot thiếu, giữHero/GUID/trang bị và level cácslot cũ; không tự nâng đồng loạt slot cũLv1 lên21/41 hoặc reset Owned. Nâng skill/Promote cần save/rollback đầy đủ và receipt xử lý lại cùng yêu cầu chỉ một lần, giữ snapshot/replay cũ. Không hỏi lại phần kỹ thuật đã được giải thích và đồng ý này.
- **Chi phí hiện hành:** nâng skill chỉ thu vàng, tạm bỏ qua phí sách; không kiểm thiếu sách để chặn nâng và không tiêu sách. Giữ chính sách này khi thêmEvo, không tự phát sinh phí mới. Chưa cần mở hoạt động farm/import sách chỉ để vượt điều kiện nguồn. Khóa tính năng nâng skill theo PlayerLv7 để các phase sau, chưa áp trong phase này. Mởslot theo bậc và giới hạn level skill theoHero là các điều kiện riêng.
- **Cap skill:** giữ mặc định SkillLevelCap80 theo đề xuất đã được người dùng đồng ý khi kết thúc brainstorm; chỉnh được quaGameEditor. Cap nâng thực tế=min(HeroLevel,SkillLevelCap) cho skill đã mở; không suy số dòngSkillLevels hoặc accountLevel thành cap hoạt động.
- **UI Quick Equip/Promote đã duyệt theo source:** cùng một nút dưới cụm trang bị; mặc nhanh món có sẵn/hợp lệ, đủ ô thì đổi nhãn thànhPromote. Không tự craft thiếu đồ hoặc tựPromote tiếp ngay trong một click mặc nhanh. Đã xác nhận từ layout herodetailNormal.btn_up/label_up và cả checkHeroUpgrade/doClickUpgrade. Điều này thay placeholder QuickEquip ởD23/D28; code UI/server đã nối ngày24/11, chưa kiểm tương tác/hình thức trong Editor.
- **Promote:** giữ D08 hấp thụ đúngItemId/GUID vào lịch sử, làm trống ô kế và mở skill theo đườngNextRankId; không cộng trùng tổngUnitRank với ledger hoặc viết lại đồ đã hấp thụ theo recipe mới. Giữ D07 Definition/Data/BattleData, D17/D22 art/responsive. Không tự thêm phí vàng, enchant/refund hoặc dữ liệu ngoài phạm vi đã chốt.
- **Stats:** giữ D05 stat trực tiếp và bỏ bonus item riêng theoHero đã triển khai. STR/AGI/INT chỉ là khả năng người dùng cân nhắc về sau, chưa đưa trở lại. Cần port đúng Evo/hook/buff được mở trong nội dung hiện hành; schema có sẵn không đồng nghĩa mọi Evo của25/40 Hero đã được hỗ trợ.

### D36 — Workflow brainstorm và bàn giao qua markdown

- **Làm rõ ngày 24/11/2026:** dọn file phát sinh từ pull Crystal phải giữ toàn bộ tài liệu brainstorm/đọc hiểu, Design, ChangeLog, phase-plan và skill. Người dùng chỉ cho phép bỏ phần Crystal tải dở cùng file tải tạm để pull lại; không suy rộng thành xóa project Zatod hoặc đặt lại quyết định thiết kế.
- **Ngày chốt:**23/11/2026. Người dùng muốn brainstorm/chốt thiết kế cùng agent hiện tại, lưu tài liệu để một agent khác thực thi. Không dựa vào lịch sử chat như đầu vào bắt buộc của agent triển khai.
- Design.md là nguồn quyết định; mỗi phase có một phase-plan hiện hành chứa phạm vi, hợp đồng, checklist và tiêu chí nghiệm thu. Review chứa bằng chứng nguồn/khảo sát, ChangeLog giữ lỗi và kinh nghiệm. Không trộn đề xuất bị thay thế với yêu cầu đang có hiệu lực hoặc tạo nhiều bản quyết định cạnh tranh.
- Agent được giao thực thi theo phase-plan phải làm tiếp trong phạm vi đã duyệt, không hỏi lại model/rule đã chốt. Chỉ hỏi khi có xung đột thiết kế, đầu vào thực sự thiếu hoặc yêu cầu mở rộng ngoài phạm vi. Cập nhật implementation report/Design/ChangeLog theo kết quả thực tế.
- Việc brainstorm, đồng ý thiết kế hoặc chuẩn bị markdown không tự khởi động runtime, build, deploy, tạo chat hay gửi việc cho agent khác. Người dùng sẽ giao agent thực thi; yêu cầu thực thi rõ ràng về sau là đủ quyền cho phạm vi được giao.
- Tài liệu bàn giao phải nêu đầu vào thực sự hiện diện và trạng tháiGit. Nguồn Crystal hiện ở `Unity/Assets/Crystal Legend/` theoD04 cập nhật23/11; ruleignore root cũ không khớp đường mới nhưng folder đanguntracked tại mốc kiểm, nên chỉ có ởclone khác sau khi được commit hoặc chuyển riêng. `Artifacts/` vẫn bịignore. JSON tham chiếu trongdocs không thay fullsource/art; không khẳng định đã commit/push chỉ vì đã viết tài liệu hoặc di chuyển folder.

### D37 — Bàn giao build theo hệ điều hành

- **Ngày chốt:** 23/11/2026; khôi phục nội dung vào tài liệu clone Mac ngày 24/11/2026. Áp dụng cho project local có iOS app target. Đây là quy tắc làm việc của agent, không phải watcher chạy nền.
- **macOS:** sau khi hoàn tất code/kiểm tra sản phẩm trong phạm vi được giao, tự build và đóng gói **IPA chưa ký cho Sideloadly**. Báo đường dẫn tuyệt đối của IPA, thư mục chứa, các kiểm tra đã chạy và trạng thái chưa ký. Không đồng nhất export project Xcode hoặc ZIP source với IPA đã build.
- **Chế độ USB riêng khi người dùng chọn:** build trên Mac, ký development, cài và chạy trực tiếp trên iPhone nối cáp, không qua Sideloadly. Dùng lại pairing/signing còn hợp lệ; cấu hình lần đầu nếu thiếu. Chỉ báo cài/chạy thành công sau kiểm chứng thực tế.
- **Windows:** hoàn tất code/test rồi hỏi có muốn đóng gói bản build không, trừ khi người dùng đã yêu cầu build trong nhiệm vụ hiện tại. Compile phục vụ test không cần hỏi đóng gói.
- **Ngoại lệ:** đọc hiểu, brainstorm, tài liệu/skill-only và dọn file tải dở không tự kích hoạt build. Không tự thêm iOS target cho project không liên quan; đóng gói local không tự cho phép upload/publish hoặc cài thiết bị.
- **Chia sẻ quy tắc:** chỉ cần lưu skill hoặc Markdown cho agent Windows đọc; không phải cài từ xa hay tạo ZIP chuyển máy. AGENTS của project dẫn tới D37 để quy tắc đi cùng checkout.
- **Trạng thái:** skill `local-build-handoff` và AGENTS ở Codex home trên Mac đã có; cập nhật chỉ dẫn project/phase-plan/iOS. Chưa thêm menu/helper IPA mới trong Unity, chưa chạy build từ nhiệm vụ tài liệu này.

### Mốc xác nhận đa nền tảng — 23/11/2026

- Người dùng xác nhận Android, iOS, Windows và server đều đã ổn và chuyển sang bàn phase tiếp theo. Đây là xác nhận vận hành từ người dùng, bổ sung cho các giới hạn kiểm chứng thiết bị ở những lượt bàn giao trước; không phải một lượt agent chạy lại ma trận kiểm thử hoặc bằng chứng mọi trường hợp đã được kiểm tra.
- Sau đề xuất ban đầu, người dùng đã mở rộng hướng phase theoD34; các chi tiết còn mở và trạng thái chưa triển khai được ghi tại đó. Các quyết định hiện hành ngoài phần đượcD34 thay thế, gồmD11 reset tiến trình ải theo launch, tiếp tục áp dụng.

## Bản tổng hợp phase đã được duyệt

Người dùng đã duyệt toàn bộ bản tổng hợp cùng hai lưu ý về chuyển stats và giới hạn source backend, rồi yêu cầu thực thi ngày 19/11/2026. [phase-crystal-prototype-scope.md](docs/phase-crystal-prototype-scope.md) là checklist triển khai. Không yêu cầu xác nhận lại các bước trong phạm vi; chỉ báo xung đột thiết kế hoặc khoảng trống source cần quyết định mới. Trạng thái thực tế được cập nhật tại [crystal-phase-implementation.md](docs/crystal-phase-implementation.md).

## Trạng thái triển khai cần phân biệt với thiết kế đích

**Mốc lịch sử:** phần dưới ghi trạng thái ngày19/11/2026. Phạm vi/rule đã được các quyết định mới hơn thay thế phải đọc theo D12/D28–D36; không áp lại các giới hạn54wave, bypasscraft hoặc mô tả UI kho cũ làm yêu cầu hiện hành.

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

Gốc Lua: `Unity/Assets/Crystal Legend/recovered/scripts/lua/com.farlightgames.dgame.gp.apac/assets/remake/data/`.

- `battle/unitattribs.lua`: danh sách 65 thuộc tính và chuyển đổi STR/AGI/INT của bản gốc.
- `battle/unit.lua`: MSPD -> dt_action; HAST -> dt_cd; init skill, damage và buff.
- `battle/actor.lua`: nhận hệ số tốc độ từ model để phát puppet.
- `battle/skill.lua`: resolve SkillGroup/Skill; dựng phase từ AnimDuration/AnimAtkFrame; Attack -> projectile/chain/region/tác động.
- `battle/chain.lua`: tạo chain gọi jump; jump gọi takeEffectOn trước khi tạo hiệu ứng chain. Không có yêu cầu chờ hiệu ứng bay chạm đích ở lần jump này.
- Lina: `atk` dài 1,333333 giây, Attack 0,625; `ult` dài 2,25 giây, Attack 1,541667 (thời gian action gốc, chưa suy thành thời điểm thực ở mọi trạng thái).
- AnimDuration/AnimAtkFrame là dữ liệu điều phối timeline, không tự bảo đảm hình và HP không lệch nếu player, quy tắc impact hoặc clock hiển thị khác nhau. Chưa quan sát game gốc chạy để kết luận một lỗi hình ảnh thực tế.
- `battle/buff.lua`, `battle/battle_tick.lua`, `battle/battle_check.lua`: lifecycle buff, đồng bộ input và kiểm chứng.

Tham khảo thêm: [ghi chú reverse và hai chat](docs/crystal-legends-reference.txt), [Hero data](docs/hero-data.md), [Campaign hiện tại](docs/campaign.md). Tài liệu lịch sử có thể mô tả prototype cũ; đối chiếu trạng thái trong code và file này.

## Lượt triển khai GameEditor/HUD/dọn config — 19/11/2026

Người dùng đã yêu cầu thực thi các phần D14–D16 sau khi xác nhận 26 Basic Attack là 16 Hero + 10 Monster. Đã triển khai config chỉ bộ mới, ID snake_case/tên English, GameEditor và HUD Phó bản với Auto/số combat thật, vàng/rương 0; chưa thêm pause/tăng tốc Phó bản. Giữ GUID/save/replay qua chuyển ID. Core 4.377 PASS; GameEditor 13 PASS; HUD live server validate + replay pause/seek/x4 PASS. Build/network cuối và bằng chứng bàn giao được ghi tại `docs/zatod-ui-implementation-progress.md`; hướng dẫn hiện hành `docs/zatod-prototype-play.md`.

Khảo sát nguồn 20/11/2026 (chưa chốt/triển khai loot Zatod): Crystal Stage có UI reward1..10 để preview, loot lượt đánh do enter_stage_reply._loots cấp riêng. Đối chiếu sâu tìm thấy Chest.lua có Loot N ID/Yield theo Chest ID, Hero ID và Rank (3.085 dòng); APK có chứa hệ số loot, nhưng chưa có code backend để xác nhận cách dùng/chuyển thành xác suất cuối của Campaign. Tỷ lệ random ordinary chưa được khôi phục đầy đủ. Xem [crystal-stage-drops-review.md](docs/crystal-stage-drops-review.md); không biến raw preview thành danh sách vật phẩm được bảo đảm nhận.


