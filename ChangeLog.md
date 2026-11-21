# Zatod Legend — Lịch sử lỗi và cách xử lý

Cập nhật 21/11/2026 (Asia/Saigon). Tra theo mã/triệu chứng trước khi sửa lỗi. Chỉ ghi nguyên nhân đã có bằng chứng; giả thuyết ghi riêng. Design.md là nguồn quyết định thiết kế.

## BUG-026 — Probe UI chạy trước khi Editor/Canvas nhận trạng thái mới

- **Ngày:** 20/11/2026. **Trạng thái:** workaround đã kiểm tra; đây là lỗi trình tự công cụ kiểm thử, không phải click xuyên ở runtime.
- **Triệu chứng:** eval importer báo không tìm thấy class mới trước refresh/domain reload; probe raycast ngay trong frame mở popup báo Modal click-through. Probe đầu còn lọc sai tên nút ải có newline; script báo cáo build có field trùng tên class.
- **Bằng chứng/nguyên nhân:** sau Refresh + chờ Editor ready, importer tạo prefab thành công; raycast ở frame kế tiếp trả popup trước nút ải. Cùng code UI qua694 checks khi probe chờ NextFrameAsync; vòng cuối766 checks PASS sau bổ sung kiểm tra nút Raid. Đã sửa tên/selector trong script kiểm tra, không đổi luật combat để bù lỗi probe.
- **Xử lý:** chạy AssetDatabase.Refresh, chờ domain reload trước dùng class mới; chờ Canvas qua một frame trước kiểm tra click. Dùng đúng label thực của button. Không clear Console.
- **File:** Unity/AgentScripts/ImportZatodStagePreview.cs, VerifyZatodStagePreview.cs, BuildZatodStagePreview.cs. Kết quả: Artifacts/ZatodStagePreviewChecks/view-checks.json.
- **Liên quan BUG-022:** importer đầu tạo rồi xóa holder trong scene active nên scene bị dirty dù không còn object; importer cuối dùng scene authoring additive riêng và đóng sau khi lưu prefab. Trước build đã xác nhận scene chỉ có Main Camera/ZatodBootstrap, không object dirty, lưu lại thao tác authoring của agent để tránh modal Save.

## BUG-025 — Mục D20 bị ghi trùng trong tài liệu thiết kế

- **Ngày:** 20/11/2026. **Trạng thái:** đã sửa và kiểm tra; chỉ ảnh hưởng tài liệu.
- **Triệu chứng/nguyên nhân xác nhận:** Design.md có hai block D20 giống nguyên nội dung sau lượt bổ sung khảo sát; cùng quyết định bị chèn hai lần. Chưa xác định thêm nguyên nhân cơ chế ghi/tool, không quy lỗi cho gameplay.
- **Xử lý:** đối chiếu hai block bằng phép so chuỗi, giữ một bản và cập nhật các điểm người dùng vừa duyệt; không xóa nội dung khác.
- **Kiểm tra:** sau ghi chỉ còn một heading D20, đủ ghi nhận sao/Raid/Back/Tutorial; model và Campaigns.txt không thay đổi ở lượt kiểm tra này.
- **Nếu tái diễn:** kiểm tra trạng thái file sau mỗi lần ghi, đếm mã quyết định trước khi chèn lại; không giả định báo lỗi của một lần ghi nghĩa là mọi file đều chưa đổi.

- **Tái diễn20/11/2026 khi chốt Hero UI:** D22 và D23 mỗi mục có hai bản giống hệt nhau; đã so chuỗi, giữ một bản rồi cập nhật các điểm người dùng vừa duyệt. Kiểm tra mỗi heading D22/D23 còn đúng một lần. Không xác nhận nguyên nhân công cụ ghi; không ảnh hưởng runtime/config.

## BUG-024 — Lệnh dotnet test config bị chặn đọc NuGet.Config người dùng

- **Ngày:** 20/11/2026. **Trạng thái:** có workaround đã kiểm tra; không thay cấu hình NuGet hoặc quyền máy.
- **Triệu chứng:** `dotnet run --project Tests/CrystalChecks/CrystalChecks.csproj` dừng ở restore, báo UnauthorizedAccess với `C:/Users/tinnq/AppData/Roaming/NuGet/NuGet.Config`.
- **Nguyên nhân xác nhận:** bước restore trong môi trường thực thi không đọc được config NuGet người dùng; không có lỗi biên dịch C# trong thông báo này. Chưa phân tích sâu ACL/sandbox và không gán đây là lỗi gameplay.
- **Workaround/kiểm tra:** dùng `dotnet run --no-restore --project Tests/CrystalChecks/CrystalChecks.csproj` với dependencies/assets đã restore hiện có: 4.429 assertions PASS, gồm config drop D19. Báo cáo `Artifacts/CrystalPhaseChecks/zatod-stage-drops-checks.json`.
- **Nếu tái diễn:** `--no-restore` chỉ dùng khi cache/assets hợp lệ; nếu thiếu dependencies phải restore với config và quyền phù hợp. Không sửa model/drop validation để né lỗi truy cập NuGet.

## BUG-023 — Khảo sát loot ban đầu bỏ sót bảng hệ số Chest

- **Ngày:** 20/11/2026. **Trạng thái:** đã sửa phạm vi kết luận trong tài liệu, kiểm tra trích xuất; thuật toán loot backend vẫn chưa xác minh. Đây là thiếu sót phân tích nguồn, không phải lỗi runtime Zatod.
- **Triệu chứng/nguyên nhân xác nhận:** lượt khảo sát Stage.UI reward, Loot và DropLimit chưa bao quát Chest.lua, dễ dẫn tới hiểu nhầm toàn bộ hệ số tỷ lệ không có trong APK. Chest có 3.085 dòng, trường Hero ID/Rank và 128 cặp Loot ID/Yield.
- **Xử lý:** bổ sung Chest, SpecialLoot, equip.Drop, RankChest; cập nhật docs/crystal-stage-drops-review.md và ghi chú quan sát trong Design.md. Không sửa config/gameplay. Phân biệt hệ số Yield đã thấy với công thức xác suất Campaign cuối cùng chưa có consumer backend.
- **Bằng chứng:** Artifacts/CrystalPhaseChecks/chest-loot-review-20261120.json; Chest1393/Unit101/Rank1 có item101 Yield0.00469, item108 Yield0.00202. Đếm bằng parser return-only Lua; giữ nguyên dữ liệu nguồn.
- **Nếu tra lại:** quét schema mọi bảng liên quan trước khi kết luận dữ liệu không có trong client; không đổi Yield thành phần trăm mỗi trận khi chưa thấy code diễn giải. Server trả _loots là bằng chứng về kết quả loot, không tự chứng minh công thức roll.

## BUG-022 — Build View chọn đội chưa trả kết quả, Editor không nhận lệnh

- **Ngày:** 19/11/2026. **Trạng thái:** đã xử lý và kiểm tra hoàn tất.
- **Bằng chứng:** script eval gọi ZatodPrototypeSetup.Build timeout 240 giây; chưa có `Artifacts/ZatodFormationChecks/build.json`. Log dừng ở preprocess Pipeline, không thấy bước ghi player mới; file mới nhất trong build vẫn 21:19:40. Process 38688 Responding=true, title có dấu *; CLI sau đó STATUS_ALL_UNREACHABLE.
- **Nguyên nhân đã xác nhận:** scene dirty làm BuildPipeline mở hộp thoại native “Scene(s) Have Been Modified”, chờ Save/Don’t Save/Cancel. Người dùng xác nhận và CUA sau reset đọc đúng dialog. Không phải đủ bằng chứng để coi đây là build/compiler lỗi hay Editor crash.
- **Công cụ:** package hiện không có lệnh `editor dialog` (lệnh thử tạo CommandNotFound log, không phải lỗi gameplay); CUA getApp thất bại `unknown or expired node_repl continuation`, chưa quan sát được dialog. Không dùng công cụ UI khác để click mù, không kill Editor của người dùng hoặc mở Editor thứ hai.
- **Ảnh hưởng:** code/Editor View đã qua 365 checks và core 4377 PASS trước build. Tại thời điểm bị chặn: Windows build chưa nghiệm thu, server PID63792 đã dừng để nhả file, auto-tick còn bật. Hiện đã build lại, server PID49516 READY 7788 với data cũ; Play stopped, auto-tick=false.
- **Xử lý:** reset CUA, đọc dialog thật rồi bấm Save qua screenshot của dialog; index click không có geometry nên dùng coordinate dựa trên ảnh vừa đọc. Đã quan sát dialog biến mất, Unity chạy Compiling Scripts/Running Backend. Scene sau lưu giống byte-for-byte checkpoint nghiệm thu trước; không ghi đè một thay đổi scene chưa biết. Chờ build.json/GetLatestReport, không khởi chạy build chồng. Khi build kết thúc, restart server đúng data `Artifacts/ZatodServer`, kiểm tra READY 7788 và console. Không reset ownership.
- **File/báo cáo:** `Unity/Logs/Editor.log`, `docs/zatod-formation-view-review.md`, `Artifacts/ZatodFormationChecks/view-live.json`.
- **Ngăn tái diễn:** `Editor/ZatodPrototypeSetup.cs::Build` kiểm tra mọi scene dirty trước khi gọi BuildPipeline, báo rõ tên scene cần lưu thay vì treo modal. Probe `dirty-scene-guard.json` PASS: đã chặn, không bắt đầu build, lưu lại scene giữ nguyên byte. Build đầu sau Save Succeeded nhưng đếm 1 lỗi chẩn đoán `editor dialog` không có; giữ báo cáo riêng `build-after-save-with-diagnostic-error.json`. Build cuối `build.json`: Succeeded, 0 errors, 0 warnings. Đã mở executable thật, kết nối và vào View chọn đội: art/Latin/CJK hiện đúng, không có missing-glyph/NullReference trong log; đóng client test riêng sau kiểm tra.


## BUG-019 — Import font báo thiếu glyph dù chữ đã bake đầy đủ

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa và kiểm tra import lại/Play.
- **Triệu chứng:** lượt tạo prefab lại báo Native source font missing glyphs cho toàn bộ nhãn, sau khi lần đầu đã hiển thị đúng.
- **Nguyên nhân xác nhận:** TMP package hiện tại `TMP_FontAsset.TryAddCharacters(string, out ...)` trả false khi `m_GlyphsToAdd.Count == 0` và trả lại nguyên chuỗi ở missingCharacters. Importer hiểu sai false là thiếu font/glyph. Kiểm tra font face thành công, HasCharacter(B/启)=true, atlas có 444 character. Giả thuyết ban đầu lỗi reload font face đã bị loại.
- **Sửa:** `Unity/AgentScripts/ImportZatodFormation.cs` lọc HasCharacter trước, chỉ TryAdd phần thật sự thiếu. Dùng Roboto native cho Latin, fallback DFYuan native cho tên/mô tả CN; không sửa nội dung ải hay dùng font OS phụ thuộc máy.
- **Kiểm tra:** importer lặp lại thành công, View live 365 PASS, Chinese description giữ nguyên, console không warning glyph mới.
- **Nếu tái diễn:** kiểm tra HasCharacter/atlas/FontEngine và implementation của TMP đúng version; không coi return false của TryAddCharacters là đủ chứng cứ thiếu glyph.

## BUG-020 — Menu cũ còn active đến hết frame sau khi dựng lại

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa và kiểm tra.
- **Triệu chứng:** probe Back → mở ải lại cùng frame tìm thấy hai button cùng tên (Sequence contains more than one matching element). Đây là tình huống chuyển UI đồng bộ trong probe, chưa quan sát click đôi thực tế của người dùng.
- **Nguyên nhân:** `ZatodPrototypeView.Clear` chỉ Destroy; Unity thực hiện hủy cuối frame, object cũ còn active/raycastable khi menu mới đã được dựng.
- **Sửa:** SetActive(false) child trước Destroy trong helper Clear. Không đổi request/combat; roster View mới cũng ẩn child trước hủy.
- **File:** `Presentation/ZatodPrototypeView.cs`; probe `AgentScripts/VerifyZatodFormation.cs`.
- **Kiểm tra:** Back về chọn ải, không vào trận; mở lại giữ draft, không có active button trùng; bộ 365 checks PASS.
- **Nếu tái diễn:** kiểm tra object chờ Destroy và activeInHierarchy trong cùng frame, đừng xóa chọn đội/save để tránh lỗi lookup.

## BUG-021 — Roster chuyển từ một hàng sang nhiều hàng nhảy xuống cuối

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa và kiểm tra.
- **Triệu chứng:** thay roster test 5 → 37 Hero, content ở y=369 (cuối danh sách); kéo tiếp lên bị clamp nên probe nhận Scroll drag did not move content.
- **Nguyên nhân xác nhận:** getter verticalNormalizedPosition có thể trả 0 khi content ngắn hơn viewport, dù đang xem từ hàng đầu. Refresh lưu 0 rồi áp vào roster dài, biến thành vị trí cuối. ScrollRect/content/mask không bị thiếu.
- **Sửa:** `ZatodFormationView.RefreshRoster` coi danh sách chưa có overflow là vị trí đầu (1); khi có overflow giữ normalized position thật. Force layout trước restore, dừng quán tính khi thay roster/filter.
- **Kiểm tra:** roster UI riêng 37 Hero có overflow, drag làm đổi content position; filter và lựa chọn giữ đúng, 4 Hero trống trái; 365 checks PASS. Test roster không ghi vào server/profile; ownership thật vẫn 5 Hero.
- **Nếu tái diễn:** so chiều cao content/viewport và normalized position trước/sau refresh; không tăng scrollSensitivity để che lỗi restore vị trí.

## BUG-018 — UI dùng asset chưa đầy đủ, hình thức còn giống prototype

- **Ngày:** 19/11/2026. **Trạng thái:** đã xác nhận qua code sau phản hồi người dùng; chưa sửa giao diện trong lượt giải thích này.
- **Triệu chứng:** người dùng thấy UI giống control dựng tạm, chưa giống UI game dù có bộ asset nguồn; đặt câu hỏi có phải dùng UI Toolkit thay asset hay không.
- **Nguyên nhân xác nhận:** HUD runtime dùng uGUI Canvas/Image/TMP, có sprite portrait/HP/energy/gold/chest/star và background Auto nguồn. Tuy nhiên helper Button dùng chung `battle_auto_bg_2` cho cả Thoát/Tiếp tục/Xem lại, chữ timer/wave/Auto vẫn là TMP, full-energy dùng viền màu dựng tạm theo BUG-014. Menu ngoài trận và replay controls vẫn dùng Image màu/chữ tạm. GameEditor mới là UI Toolkit; lựa chọn framework không phải nguyên nhân ngăn dùng sprite.
- **File:** `Presentation/ZatodBattleHudLayout.cs`, `ZatodPrototypeView.cs`, `Editor/GameEditorWindow.cs`; prefab `Resources/Zatod/UI/ZatodBattleHUD.prefab`.
- **Xử lý hiện tại:** làm rõ phần đã dùng asset và phần tạm, không coi kiểm thử logic/Auto/GUID/build là nghiệm thu độ giống giao diện. Chưa thay runtime/scene/prefab theo một câu hỏi giải thích.
- **Khi xử lý tiếp:** đối chiếu asset và layout riêng của từng control với ảnh/source UI; dùng đúng button/frame/digit/highlight và blend phù hợp, tránh tái dùng nền Auto cho mọi nút. Giữ luồng Auto và combat thật; GameEditor là công cụ authoring riêng.
- **Bằng chứng:** kiểm tra đọc trực tiếp code ở trên và screenshot `Artifacts/ZatodPhaseChecks/hud-live/hud-ready.png` / `hud-result.png`. Chưa kiểm định đầy đủ mọi biến thể asset UI nguồn.

- **Phản hồi tiếp theo 19/11:** Người dùng tạm chấp nhận HUD hiện tại; mọi UI/View mới phải dùng đúng asset nguồn (D17). View chọn đội đang khảo sát tại D18, chưa triển khai. Điều này không biến phần art tạm cũ thành đã sửa hoặc cho phép lặp lại ở View mới.

## BUG-016 — Ký tự đánh dấu không có trong font HUD/menu

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa và kiểm tra Play/console.
- **Triệu chứng:** nhãn đội hình hiện ô vuông, TMP warning U+2713.
- **Nguyên nhân:** FormationFont/LiberationSans không chứa checkmark đang dùng; không phải thiếu glyph tiếng Việt.
- **Sửa:** trạng thái chọn Hero dùng `[x]`, ải hoàn thành dùng “Đã qua”; sao ở portrait dùng sprite native. File `Presentation/ZatodPrototypeView.cs`, `ZatodBattleHudLayout.cs`.
- **Kiểm tra:** lượt HUD cuối/server migration không có warning font mới; screenshot và `hud-live/result.json` PASS. Nếu tái diễn, kiểm tra đúng font/glyph/fallback trước khi đổi nội dung Việt hoặc âm thầm thay toàn bộ font.

## BUG-017 — Probe HUD lấy object inactive / đo pause trước render

- **Ngày:** 19/11/2026. **Trạng thái:** harness đã sửa, không phải chẩn đoán lỗi combat.
- **Triệu chứng:** probe đầu NullReference khi bắt đầu trận; probe sau báo pause không ổn định trong khi tick/seek đúng.
- **Nguyên nhân xác nhận:** FindAnyObjectByType bỏ qua HUD đang inactive trên menu; probe chụp vị trí ngay sau toggle pause, trước DrawBattle chuyển về pose tick paused. Không dùng hai thất bại này để kết luận HUD/gameplay hỏng.
- **Sửa:** `Unity/AgentScripts/VerifyZatodHudLive.cs` đọc reference HUD đã giữ trong view, render pose paused trước khi bắt đầu đo độ ổn định. Không đổi simulation để test pass.
- **Kiểm tra:** kết quả cuối PASS: portraits/loot, Auto 4 inputs/server validated, damage/heal/energy thật, pauseStable/seekCorrect; `Artifacts/ZatodPhaseChecks/hud-live/result.json`.
- **Lưu ý tool:** có một script eval timeout trong lượt Editor auto-tick tắt; trạng thái sau đó là stopped, process vẫn responding. Chưa đủ chứng cứ chốt nguyên nhân timeout; đã bật auto-tick cho phiên Play do agent chạy và xác minh frame tăng. Kết thúc trả auto-tick=false; không kill Editor hay clear console. Nếu tái diễn, đọc trạng thái lifecycle/Play và log thật trước khi thử lại.

## BUG-014 — Texture full-energy che chân dung trong HUD uGUI

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa, xem screenshot HUD live.
- **Nguyên nhân:** `battle_hero_energy_full.png` của nguồn dùng cách blend khác; đặt thẳng vào Image với blend alpha mặc định tạo mảng đỏ che portrait.
- **Sửa:** không phủ texture ấy lên mặt Hero; dùng viền vàng mảnh khi đầy nộ, vẫn giữ portrait/native frame/star assets. Không đổi energy hoặc điều kiện cast.
- **Kiểm tra:** `Artifacts/ZatodPhaseChecks/hud-live/hud-ready.png`: đủ 5 portrait, card ready có viền, Auto tạo 4 input và server validate. HP/energy/damage/heal lấy combat thật; loot 0. Ẩn số nổi khi kết thúc để không giữ chữ cuối vô hạn trên kết quả.
- **File:** `Unity/Assets/Zatod/Presentation/ZatodBattleHudLayout.cs`, `ZatodBattleHud.cs`, prefab `Resources/Zatod/UI/ZatodBattleHUD.prefab`.
- **Nếu tái diễn:** kiểm tra alpha/blend gốc của effect trước khi đưa vào uGUI; không thay đổi texture nguồn để che lỗi material.

## BUG-015 — GameEditor hết dung lượng ClipRect của UI Toolkit

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa.
- **Triệu chứng:** `Exceeded clip rect allocation count` / giới hạn 8.192, xuất hiện lúc Editor rebuild trong lượt build đầu dù player build Succeeded.
- **Nguyên nhân:** dựng tất cả object/nested field của config ngay khi mở, kể cả foldout đóng: khoảng 27.207 VisualElement. Đây là lỗi cửa sổ authoring, không phải dữ liệu combat thiếu.
- **Sửa:** lazy PopulateOnOpen cho list/object/raw JSON. Chỉ dựng children khi người dùng mở foldout; giữ draft/fileStore và stylesheet.
- **Kiểm tra:** GameEditor 13 PASS; tree ban đầu 98 element, sau đổi tab/probe 240; console không phát sinh ClipRect mới. Lượt build đầu có 2 errors này, không sử dụng làm bằng chứng build sạch; xem `build.json` cuối.
- **File:** `Unity/Assets/Zatod/Editor/GameEditorWindow.cs`, `Unity/AgentScripts/VerifyGameEditor.cs`. Build cuối Succeeded/0 errors/2 warnings.
- **Nếu tái diễn:** đo số element thật và collapsed subtree; không tăng limit hay xóa config để tránh lỗi.

## BUG-013 — Tên item/skill import vẫn là tiếng Trung, ID theo số nguồn

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa và kiểm tra sau khi người dùng yêu cầu thực thi D14–D16.
- **Nguyên nhân:** importer đọc equip.Name/SkillGroup.Display Name từ bảng CN nguyên liệu và tạo ID crystal_* theo số nguồn, chưa chạy pipeline bản địa hóa của client. `translatecsv.lua`/`tools.lua` của bản gốc dùng textConfig theo language/context để đổi nhãn.
- **Bằng chứng:** `texttable/texttable.lua` có 29.498 key dịch; 67/67 item và 74/74 skill không ẩn trong bộ mới có nhãn English. Toàn bộ skill là 86 dòng, 75 direct English + 11 hidden tên &...; 4 hidden có nhãn tên nền sau bỏ prefix, 7 còn thiếu ánh xạ nhãn gốc. Không được giả định mọi skill kỹ thuật ẩn có tên bản địa hóa.
- **Ví dụ đúng nguồn:** 小圆盾 → Small Stout Shield; 补刀斧 → Iron Axe; Lina 神灭斩 → Deity Slash. Không thay bằng tên dịch đoán hoặc tên Dota khác.
- **Hướng sửa khi triển khai:** chọn English theo đúng context, tạo mapping ID snake_case có kiểm tra trùng tên, cập nhật tất cả references/importer. Giữ SourceId phục vụ trace/mechanic và GUID instance. Dọn dòng cũ theo D16; bảo toàn save/replay theo mapping/tương thích, không xóa profile để tránh migration.
- **Kiểm tra cần làm:** số lượng retained, dangling references, collision ID, native localization coverage/hidden fallbacks, GameEditor refresh, stat/combat/replay và GUID history. Evidence: `Artifacts/CrystalPhaseChecks/english-name-audit-20261119.json`.
- **Đối chiếu tên trùng:** 26 Basic Attack đúng là 16 Hero + 10 Monster; 26 ID riêng, mỗi dòng đúng một owner, khớp Basic Skill nguồn. Đây là nhãn chung, không phải lỗi import trùng. Evidence: `basic-attack-ownership-20261119.json`.

- **Kết quả sửa 19/11:** active config còn 16 Hero/10 Monster/67 Item/86 Skill/33 Buff/27 Stat; ID snake_case và toàn bộ tham chiếu đã chuyển. Item 67/67 và skill hiển thị 74/74 dùng English gốc; 7 hidden dùng nhãn kỹ thuật có ghi nguồn. Mapping 198 alias, giữ GUID và sở hữu đã nghỉ ở Retired*. Core 4.377 PASS (migration, localization, old archives); không xóa art/save để né migration.

## BUG-012 — Hero Balance giữ draft/cache cũ sau import config

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa trong GameEditor và kiểm tra 13 assertion, giữ draft dirty/chặn save stale.
- **Triệu chứng:** tab Heroes dừng ở [23] berthaxe và Add entry, không có Hero mới dù game đã dùng bộ import.
- **Bằng chứng đọc trực tiếp:** cửa sổ đang mở có 24 Hero/7 Monster/2 Item, importedHeroCount=0, sourceDocuments cached, hasUnsavedChanges=false. File thật có 40 Hero/17 Monster/69 Item; 16 Hero mới ở index 24–39 (Coco, DR, Lina, Zeus,...Ench). Dữ liệu không mất, không cần import lại.
- **Nguyên nhân:** `HeroBalanceWindow.CreateGUI` chỉ đọc file nếu sourceDocuments==null. sourceDocuments/draftJson được serialize nên cache cũ tồn tại khi file bên ngoài đã đổi. `ReloadIfClean` có định nghĩa nhưng chưa được gọi ở nơi khác trong Editor code đã tìm.
- **Workaround:** người dùng bấm Reload files, chọn tab Heroes/Monsters/Items. Nếu có draft chưa lưu thì giữ/bảo toàn chỉnh sửa trước; không tự discard. Lượt xác minh hiện tại không có draft chưa lưu và agent chưa tự reload.
- **An toàn ghi:** `HeroConfigFileStore.Save` so file trên đĩa với expected documents và từ chối nếu khác; không kết luận draft cũ có thể âm thầm ghi đè bộ import.
- **Hướng sửa khi được yêu cầu triển khai:** GameEditor phát hiện file thay đổi, tự refresh khi sạch, báo và giữ draft khi đang chỉnh; nhãn tên + ID và bộ lọc dễ thấy dữ liệu import. Không tự xóa Hero cũ chỉ để che lỗi refresh; D16 sau đó đã cho phép dọn định nghĩa cũ trong một lượt triển khai riêng, chưa thực hiện.
- **Kiểm tra sau sửa:** từ cache 24/7/2 phải thấy 40/17/69 mà không ghi file; mô phỏng thay đổi ngoài cửa sổ; bảo toàn draft dirty và kiểm tra chặn save stale. Evidence: `Artifacts/CrystalPhaseChecks/editor-config-stale-20261119.json`.

- **Kết quả sửa 19/11:** `GameEditorWindow.OnFocus/OnProjectChange` gọi ReloadIfClean, so nội dung thật trên đĩa. Draft sạch tự cập nhật; draft dirty giữ nguyên và báo thay đổi. FileStore tiếp tục từ chối stale save. `Artifacts/ZatodPhaseChecks/gameeditor-checks.json`: 13 PASS, đúng 16/10/67 sau dọn D16, kiểm tra external refresh/draft/stale/Campaign/config restored.

## BUG-010 — Config Hero/Monster/Item khó tìm trong Editor

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa điểm vào: **GameEditor > Open** / **Zatod > GameEditor**, bảy tab cho bộ mới.
- **Triệu chứng:** người dùng không thấy nơi config Hero, Monster và Items.
- **Nguyên nhân xác nhận từ code:** menu chia giữa Zatod/Heroes/Hero Balance và Zatod/Monsters/Monster Balance; Items chỉ là tab trong Hero Balance, không có menu Items riêng. Dữ liệu là JSON `.txt`, không phải config component/ScriptableObject trên prefab. Chưa có bằng chứng menu không đăng ký hoặc mất dữ liệu.
- **Hướng dẫn hiện tại:** mở Hero Balance, chọn tab Heroes/Items/Stats/Skills/Buffs; Monster Balance mở tab Monsters. Folder `Assets/Zatod/Resources/Data`.
- **Hướng đã chốt tiếp theo:** menu/cửa sổ GameEditor, tab riêng cho từng bảng; layout chi tiết chưa triển khai. Lỗi thực tế cửa sổ không thấy Hero mới đã được xác nhận riêng ở BUG-012; xem `docs/zatod-campaign-ui-review.md`.

- **Kết quả sửa 19/11:** dùng menu GameEditor với Heroes, Monsters, Items, Stats, Skills, Buffs, Campaign; mỗi object hiện Name [Id]. Campaign cho chỉnh chương/ải/wave/hook trong cùng cửa sổ. Dữ liệu vẫn là JSON `.txt` ở `Resources/Data`, không phải component trên Hero prefab.

## BUG-011 — Tên Crystal lộ trong thành phần Zatod

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa tên thành phần project, giữ tương thích save/replay và nguồn tham chiếu theo D14.
- **Nguyên nhân:** tên tạm theo nguồn reverse được giữ trong `CRYSTAL PROTOTYPE`, menu `Zatod/Crystal`, title Chapter/Waves, scene/class/tool/build paths.
- **Hướng xử lý:** đặt tên thành phần project là Zatod, Crystal dành cho attribution/source reference. Rà migration trước khi đổi ID/path/rules/save key đang được dùng; không global replace làm hỏng replay hoặc Hero/item history.
- **Kiểm tra khi triển khai:** rà UI/menu/window/build, mở scene/prefab không mất script/reference; đọc save/archive cũ, giữ GUID/ItemId và validate combat. Lượt này mới ghi quyết định và khảo sát.

- **Kết quả sửa 19/11:** đổi class/file prefix, UI/menu, scene, resource, executable/scripts sang Zatod; move asset bằng AssetDatabase giữ GUID. Tên `.Crystal` trong source metadata JSON, rules/flag cũ và `.crystal.gz` là hợp đồng tương thích, không phải branding mới. PlayerPrefs đọc fallback profile cũ; server script sao chép Owned/archive có LegacyBackup; không reset GUID.

## BUG-001 — Hero và projectile di chuyển theo từng nấc

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa và kiểm tra Editor, core, build Windows và network executable cuối.
- **Triệu chứng:** đi bộ/đạn trông giật, như game lag dù animation vẫn phát.
- **Nguyên nhân xác nhận:** view lấy tọa độ model 8 Hz trực tiếp; interpolation chỉ áp vào animation time. Replay còn return sớm giữa tick. Source actor/projectile Crystal có vận tốc hiển thị giữa tick nhưng đoạn này chưa port đầy đủ.
- **Bằng chứng trước sửa:** 5.962 frame/27,90 giây, khoảng 213 FPS; 50.239 cặp frame Hero và 3.729 cặp frame đạn cùng tick, không cặp nào đổi vị trí. Hero thường nhảy 24,75 pixel thiết kế; đạn Lina/Zeus 103,125 pixel. Có 3 frame >50 ms; nguyên nhân hitch riêng lẻ chưa profile. 33 projectile speed import khớp nguồn.
- **Cách sửa:** snapshot vận tốc/độ cao chỉ phục vụ presentation; view dự phóng tối đa một tick và cập nhật mỗi render frame. Cache snapshot theo tick; replay cũng vẽ giữa tick. Giữ core 8 Hz, tốc độ nguồn, va chạm/damage, RNG/digest/replay. Teleport/chuyển wave khớp lại trạng thái mới, không suy vận tốc từ bước nhảy teleport. Motion/timeline không tiếp tục chạy qua manual-ultimate freeze, pause hoặc seek.
- **File:** `Unity/Assets/Zatod/Combat/CrystalPresentationState.cs`, `CrystalMatchDefinition.cs`, `CrystalBattleSimulation.cs`; `Unity/Assets/Zatod/Presentation/CrystalPrototypeView.cs`.
- **Kiểm tra:** CrystalChecks 4.009 PASS, gồm render không đổi model/digest và 3 archive trước sửa giữ nguyên kết quả. `Artifacts/CrystalPhaseChecks/motion-fix-editor.json` PASS: live Hero 13.916/13.916 và projectile 3.415/3.415 cặp frame di chuyển giữa tick; replay x1/x4 đều có chuyển động giữa tick, pause đứng yên, seek đúng tọa độ. Client Editor mới được server executable trước sửa validate. `motion-fix-build.json`: Succeeded, 0 lỗi, 2 cảnh báo cũ. `network-20261119-194824/results.txt`: Phó bản/Arena/PvP PASS, hai client cùng digest 7727497618463703090, 8 input; relaunch reset ải/giữ đúng 24 GUID/type pairs. Baseline tại `movement-observation-summary-20261119.json`; chi tiết trong `docs/crystal-phase-implementation.md`.
- **Nếu tái diễn:** kiểm tra tọa độ thật có đổi giữa các frame cùng tick, cả live và replay/pause/seek; FPS cao hoặc sprite animation mượt chưa đủ chứng minh tọa độ mượt. Không tăng projectile speed/tick rate để che lỗi presentation.
- **Khôi phục:** `Artifacts/CrystalPhaseCheckpoints/20261119-before-motion-fix/source.zip`.

## BUG-002 — Unity Hub báo project đang mở nhưng không có cửa sổ

- **Ngày:** 19/11/2026. **Trạng thái:** đã xử lý và kiểm tra.
- **Nguyên nhân:** Editor do agent mở bằng `-batchmode` vẫn chạy nền và giữ project lock.
- **Xử lý:** xác nhận đúng process/project; dùng Unity CLI close với `--if-saved` để thoát an toàn. Đã xác nhận không scene chưa lưu, không còn Editor của project và UnityLockfile biến mất.
- **Nếu tái diễn:** xem project path và cờ batchmode trong process; không đóng Editor của project khác, không xóa lock khi process còn chạy. Trước bàn giao nên đóng phiên batchmode do agent sở hữu.

## BUG-003 — PowerShell chặn Start-CrystalServer.ps1/Client.ps1

- **Ngày:** 19/11/2026. **Trạng thái:** đã xác định, có workaround; không đổi chính sách máy.
- **Triệu chứng:** PSSecurityException, running scripts is disabled.
- **Nguyên nhân:** execution policy của phiên PowerShell người dùng chặn `.ps1`.
- **Xử lý:** gọi `powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<đường dẫn script>"` cho riêng process đó. Không đặt Bypass toàn máy.
- **Kiểm tra:** người dùng xác nhận đã chạy/kết nối được. Script tại `scripts/Start-CrystalServer.ps1`, `Start-CrystalClient.ps1`.

## BUG-004 — Không mở replay từ history hoặc lỗi khi battle UI bị ẩn

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa, kiểm tra trước phase bàn giao.
- **Nguyên nhân:** record Phó bản được xem như acknowledgment của battle cũ ngay cả khi người dùng yêu cầu history; lookup Button qua parent inactive trả null.
- **Sửa:** phân biệt acknowledgment đúng battle đang hiện với yêu cầu replay khác; giữ reference playbackButton, bỏ draw khi stage inactive. File `CrystalPrototypeView.cs`.
- **Kiểm tra:** `Artifacts/CrystalPhaseChecks/ui-final/regression.json`: hidden battle/history/seek tick 54/x4/raycast đạt.
- **Nếu tái diễn:** kiểm tra BattleId, stage active và nguồn replay; không dùng sự tồn tại của connection.Battle để quyết định mọi replay.

## BUG-005 — Scene thiếu AudioListener

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa, kiểm tra.
- **Sửa:** thêm một AudioListener vào Main Camera qua Editor API; cập nhật `CrystalPrototypeSetup.cs` để scene tạo lại cũng có listener.
- **Kiểm tra:** UI regression ghi nhận đúng 1 AudioListener. Không thêm listener cho từng Hero/effect.

## BUG-006 — PvP từ chối envelope rỗng muộn khi tải sprite

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa, kiểm tra.
- **Nguyên nhân:** 5 tick startup có input rỗng implicit; cold sprite load khiến envelope rỗng tương ứng đến sau tick đã commit, bị nhận như input gameplay trễ.
- **Sửa:** `CrystalServer.AcceptOperation` bỏ qua đúng envelope rỗng của 5 tick implicit đã qua sau khi kiểm tra envelope; input thật trễ, tick sai và gói trùng tiếp theo vẫn bị từ chối.
- **Kiểm tra:** `warmup-gate.json` 5 PASS; `network-20261119-185731/results.txt` hai client cùng digest, input và kết quả.
- **Nếu tái diễn:** phân biệt envelope rỗng startup với input thật; không nới luật nhận mọi input quá hạn.

## BUG-007 — Buff control sai dạng hoặc thiếu stat reference

- **Ngày:** 19/11/2026. **Trạng thái:** đã sửa, kiểm tra.
- **Nguyên nhân:** danh sách control Lua từng bị serialize thành chuỗi dict Python; stat chỉ có trong buff chưa vào Stats. Loader test cũ thiếu bảng Buffs sau khi catalog validate chặt hơn.
- **Sửa:** import control dạng danh sách phân tách dấu phẩy, bổ sung stat phụ thuộc buff; loader đọc Buffs và version. File `scripts/Import-CrystalConfig.py`, `Tests/MonsterChecks/Program.cs`.
- **Kiểm tra:** CrystalChecks kiểm tra control stun; MonsterChecks 48.197 assertion PASS.
- **Nếu tái diễn:** kiểm tra dữ liệu import và loader trước khi thay luật combat để bù cho metadata sai.

## BUG-008 — Một số sound reference không tồn tại trong nguồn

- **Ngày:** 19/11/2026. **Trạng thái:** giới hạn nguồn đã xác nhận, chưa có asset để bổ sung.
- **Thiếu:** `Civ_Human_Wizard_BigAttack.mp3`, `Civ_Wizard_Attack.mp3`.
- **Xử lý:** ghi rõ trong `Artifacts/CrystalPhaseChecks/static-art-audio.json`; không giả vờ đã import hoặc tự thay sound khác.
- **Nếu tái diễn:** đối chiếu báo cáo/source trước khi debug AudioListener hay đường dẫn load.

## BUG-009 — Editor báo UnityConnect token exchange thất bại

- **Ngày:** 19/11/2026, sau build bản sửa chuyển động. **Trạng thái:** đã khoanh vùng dịch vụ Editor; chưa xử lý đăng nhập/kết nối Unity.
- **Thông báo:** `UnityConnectWebRequestException: Token Exchange failed due a failure with the web request.` Stack thuộc `UnityEditor.Connect.TokenExchange` / `UnityConnect.RequestNewServiceToken`, console seq 106, session `2daa4460d44d4802b20eb2ee24ca2628`.
- **Nguyên nhân đã xác nhận:** request đổi token dịch vụ Unity Editor thất bại. Chưa xác định sâu là mạng, certificate hay phiên đăng nhập; không gán đây là lỗi gameplay.
- **Ảnh hưởng quan sát:** build vẫn Succeeded/0 lỗi; core/render test đạt và Mirror local vẫn validate/thi đấu được. Không có bằng chứng lỗi chuyển động xuất phát từ UnityConnect.
- **Xử lý hiện tại:** giữ nguyên console làm bằng chứng; không tự sign-out/sign-in, đổi certificate hay xóa console để làm báo cáo sạch. Nếu còn lỗi tính năng dịch vụ Unity, điều tra riêng request/network và đăng nhập. Không sửa netcode Mirror để xử lý lỗi dịch vụ Editor.
# Các vấn đề phát hiện khi triển khai world — 20/11/2026

## BUG-027 — Gói visual thiếu shader include

- Triệu chứng: AllIn1SpriteShader và UiMask báo không tìm thấy AllIn1OneShaderFunctions.cginc sau import TreasureHunter_VisualAssets.unitypackage.
- Nguyên nhân xác nhận: shader dùng include bằng tên file, dependency này không nằm trong package; quét GUID không phát hiện được dependency dạng include.
- Sửa: khôi phục đúng file .cginc và .meta từ project nguồn Treasure Hunter vào Assets/Packages/AllIn1SpriteShader/Resources, force reimport hai shader. Không sửa shader hoặc thay art.
- Kiểm tra: console groundTruth ngày20/11 sau reimport consoleErrors=0, compilationFailed=false; giữ log hai lỗi lịch sử, không clear Console. Chưa nghiệm thu render Player build tại thời điểm ghi.
- Nếu tái diễn: kiểm tra include shader ngoài serialized GUID trước khi kết luận URP/material không tương thích.

## BUG-028 — Import chương2 tạo tọa độ UI vượt miền chuẩn hóa

- Triệu chứng: CampaignCatalog từ chối Invalid Campaign stage khi thêm chương2.
- Nguyên nhân xác nhận: công thức MapY của importer cũ tính theo SourceStageId toàn cục; ải19 trở đi vượt miền0..1. World coordinate là hệ riêng, không phải nguyên nhân.
- Sửa: tính MapX/MapY chương2 theo index trong chương, lưới7x3; giữ nguyên dữ liệu địch/wave/độ khó. File scripts/Import-ZatodChapterTwo.py.
- Kiểm tra: CrystalChecks chạy toàn bộ39 ải, replay/checker và catalog PASS4.730 assertions sau sửa. Bổ sung world geometry test đang chạy.

## BUG-029 — Editor refresh art mới vượt thời gian chờ công cụ

- Trạng thái: đã hoàn tất import/nghiệm thu. Lệnh AssetDatabase.Refresh timeout30s và lượt tăng timeout đang chờ; đã có thời điểm status ready nhưng CUA raise cũng timeout.
- Chưa xác nhận nguyên nhân ngoài việc đang thêm nhiều sheet nhân vật/effect. Không gọi đây là shader/gameplay lỗi hoặc tự kill Editor của người dùng. Tiếp tục kiểm tra compile/Editor sau import.
- Bổ sung: lượt tăng timeout đã hoàn tất, status ready/compilationFailed=false. Lệnh editor dialog không có trên Pipeline của Editor6000.6, tạo một Console error công cụ (seq28), không phải lỗi runtime. Không lặp lại lệnh ấy hoặc xóa Console. Wrapper18 prefab đã tạo thành công; batch sprite đầu32 resource đã hoàn tất.
- Font source CN không có ký tự em dash của mô tả chương2; dùng glyph từ Latin source/fallback đã có, không thay câu nguồn. Import wrapper/font đã PASS sau chỉnh bộ chọn glyph.

## Bổ sung BUG-008 — Audio nguồn chương2

- Ngày20/11/2026: thêm hai tham chiếu TANKGLOBAL_ATK.mp3 và TANKGLOBAL_DEATH.mp3 không có trong source phục hồi. Import23 background/136 sound có thật; static-art-audio.json ghi4 sound thiếu gồm2 dòng cũ. Không thay âm thanh khác hoặc coi đó là lỗi network.

## BUG-030 — Sprite mới chưa kế thừa định dạng texture Windows

- Ngày20/11/2026, đã xử lý/nghiệm thu. Metadata sprite chương2 mới có default Uncompressed và chưa bật Standalone override; bộ cũ có bước OptimizeCrystalTextures.cs dùng BC7/4096. Lượt build đầu đang nạp/đóng gói nhiều texture; log có Evict-before-extend. Chưa chứng minh định dạng texture là nguyên nhân duy nhất của thời gian build.
- Hướng sửa trong phạm vi prototype: áp dụng lại đúng bước BC7 cho sheet mới, giữ PNG/pivot/sprite rect/độ phân giải; nối vào importer để batch sau không quên. Không hạ độ phân giải hoặc sửa timing để bù performance.
- Kiểm tra cần hoàn tất: metadata Standalone, source PNG checksum, build cuối và render clip/world.
- Hoàn tất:750 texture,207 sheet mới đổi sang BC7/4096; importer hai entry point đã kế thừa override này cho batch sau. Source PNG không được chỉnh; kiểm định146 resource/13.801 sprite/521 clip PASS giữ geometry/timing. Build cuối Succeeded0 errors/2 warnings, hai lượt UI và executable hai client cuối PASS.

## BUG-031 — Script kiểm định art dùng đường dẫn trước đổi tên

- Ngày20/11/2026. Triệu chứng: VerifyCrystalAssets.cs báo Sprite count mismatch ở Assets/Zatod/Art/Crystal/Bone/Idle_0.png sau khi texture import xong.
- Xác nhận: manifest lịch sử giữ path Art/Crystal, asset hiện ở Art/Imported từ lượt đổi tên; lookup trả0 sprite. Chưa có bằng chứng mất sprite runtime/GUID.
- Sửa: script kiểm định giải đường dẫn lịch sử sang Art/Imported trên bản manifest đọc trong bộ nhớ; không sửa file source hoặc clip/pivot để làm test đạt. Đang chạy lại kiểm định geometry/action.
- Kiểm tra lại đã PASS146 resource/13.801 sprite/521 clip. Thêm resolver tương tự vào hai script importer để có thể nhập lại manifest lịch sử.

## BUG-032 — Lượt test Editor bắt đầu khi domain reload chưa ổn định

- Ngày20/11/2026, đã kiểm tra lại phiên sạch. Sau Play có frame1/Pipeline rớt kết nối, test Connect gặp Transport.active=null; kiểm tra sau thấy WorldView tồn tại nhưng transport null và map bounds0, lỗi clamp lặp mỗi frame. Hai client executable cùng build đã PASS.
- Nguyên nhân đang khoanh vùng: compile/domain reload muộn làm mất biến Mirror tĩnh; Unity hot reload có thể phục hồi DTO map null thành object rỗng. Chưa coi kết luận này là nguyên nhân duy nhất trước khi thử phiên sạch.
- Xử lý: dừng phiên Play do agent mở, giữ Console; đánh dấu map là runtime NonSerialized và không cập nhật map thiếu ID. Flush refresh/compile trước phiên test sạch, bật auto tick qua domain reload và chờ frame advance trước Connect.
- Phiên sạch đã có frame advance/Transport=true/WorldHUD=true; lỗi disconnect tiếp theo được tách riêng ở BUG-033, không quy cho reload.
- Hoàn tất nghiệm thu: flush compile trước Play, tick nền qua reload, đợi frame advance trước Connect. Hai phiên UI cuối PASS; Editor đã stopped/auto-tick=false và gỡ override nền. Không phát sinh lại clamp0 trong marker Play cuối.

## BUG-033 — World snapshot disconnect khi tạo sorting cho prop

- Ngày20/11/2026. Xác nhận từ stack: MissingComponentException SortingGroup trên prop_0 khi callback WorldChanged dựng map, Mirror ngắt kết nối vì handler ném exception.
- Nguyên nhân: dùng GetComponent<SortingGroup>() ?? AddComponent; toán tử CLR ?? không kiểm tra Unity fake-null, nên Editor trả wrapper thiếu component mà không chạy AddComponent.
- Sửa: kiểm tra sort==null bằng Unity operator rồi AddComponent. Các wrapper/GUID/renderer nguồn không đổi. Đang nghiệm thu lại UI visual; network smoke không dựng world visual nên chưa bắt được lỗi này.
- Kiểm tra tiếp theo đã kết nối/dựng Town thành công, không còn MissingComponentException. Lỗi màu được tách ở BUG-034.

## BUG-034 — World sprite hiển thị khối cyan thay vì texture

- Ngày20/11/2026. Xác nhận qua ảnh Town và dữ liệu renderer: sprite/UV/texture gốc tồn tại, material Sprite-Lit-Default trong scene hiện tại tạo hình cyan; thay riêng material bằng Sprite-Unlit-Default hiển thị đúng Unit/cây/NPC/building với cùng sprite.
- Sửa: material ZatodWorldSprite.mat tham chiếu shader native URP2D Unlit; wrapper runtime chỉ đổi default Sprite-Lit-Default sang material này, giữ sprite/color/rig và các custom material khác. Không sửa pixel gốc hoặc dùng art thay thế. Chưa kết luận mọi shader của package không tương thích.
- Đang nghiệm thu lại UI/build. Công cụ test keyboard ở Editor không focus cũng được đổi routing tạm và cập nhật input dynamic; khôi phục setting khi kết thúc, không sửa điều khiển runtime để test dễ đạt.
- Hai lượt UI sau sửa đã PASS48 rồi131 kiểm tra; avatar/texture/NPC hiển thị đúng. Keyboard harness áp trạng thái tại InputSystem.onAfterUpdate/Dynamic để tránh native poll ghi đè event giả lập. Đã khôi phục setting input, dừng Play/auto-tick và gỡ override nền sau kiểm tra.
- Build cuối đã PASS0 errors/2 warnings, material Unlit nằm trong Resources nên có shader reference trong Player; executable hai client cuối PASS. NPC custom shader có thể hiện placeholder cyan một frame khi Editor compile shader bất đồng bộ; ảnh lượt cuối đã hiển thị đúng. Không sửa custom shader/pixel nguồn để che frame compile của Editor.

## BUG-035 — Hở nền và tràn tên ở frame chuyển map

- Ngày20/11/2026. Ảnh frame đầu chương1/2 có mép xanh camera ngoài nền; đo renderer bounds vẫn phủ đúng map (-2,5..64,5), nên không phải mất background.
- Nguyên nhân xác nhận từ code: LoadMap đặt camera ngay lên spawn sát biên, rồi mới lerp về vị trí đã clamp ở Update; lúc chuyển map/thoát trận có frame nhìn ra ngoài. Banner mới cũng quá hẹp cho tên chương dài.
- Sửa: snap camera tới target đã clamp ngay khi vào map/trở lại world, tiếp tục follow mượt khi đi; giới hạn ortho theo kích thước map và aspect. Nới banner native và autosize tên. Thay patch nền ô vuông bằng sprite Flower0 native có sẵn.
- Kiểm tra: lượt UI cuối131 checks PASS, xem lại ảnh03/07 hết hở mép/tràn chữ; 301 frame chuyển động avatar và287 frame remote interpolation. File ZatodWorldView.cs, ImportZatodWorld.cs; ảnh tại Artifacts/ZatodWorldChecks/live.

- Quan sát lại khi review joystick20/11: chữ tên chương vẫn có lúc rộng hơn phần giữa banner nguồn ở bố cục mới. Đây là quan sát ảnh, chưa đo overflow glyph hoặc sửa trong task joystick/menu; giữ làm việc cần rà lại khi chỉnh banner, không đánh dấu đã sửa hiện tượng mới này.

## BUG-036 — Harness không ghi được báo cáo Vector2 và input giả lập bị ghi đè

- Ngày20/11/2026, lỗi công cụ kiểm tra. JsonConvert đi theo Vector2.normalized đệ quy nên Finish báo self referencing loop, không tạo result.json. QueueStateEvent trong Editor update không bảo đảm trạng thái phím tồn tại tới MonoBehaviour.Update khi native poll chạy.
- Sửa riêng AgentScripts/VerifyZatodWorldLive.cs: báo cáo vị trí bằng X/Y; kết quả có RUNNING/PASS/FAIL để không đọc nhầm file cũ. Áp KeyboardState tại onAfterUpdate/Dynamic và gỡ callback/khôi phục input setting khi kết thúc. Không thêm input giả lập vào runtime hoặc sửa tốc độ/avatar để làm test đạt.
- Kiểm tra: hai lượt cuối ghi đủ48 và131 checks PASS, frame movement357 và301, remote interpolation287; result JSON đọc được. Không còn lỗi harness sau lượt cuối. Console groundTruth lúc bàn giao consoleErrors=0, compilationFailed=false; captured history vẫn giữ log lỗi cũ, không gọi console clear.

## BUG-037 — HUD/UI lệch khi đổi tỷ lệ màn hình và dùng Simulator

- Ngày20/11/2026. **Trạng thái:** đã sửa, kiểm tra Editor/Simulator và build Windows thành công.
- Triệu chứng người dùng báo: đổi nhiều kích thước màn hình làm UI lệch; hiện dùng Device Simulator iPhone X, game định hướng màn ngang.
- Nguyên nhân xác nhận từ code: ZatodPrototypeView.Box/ZatodStageUi.Box đặt nhiều child theo tọa độ cố định từ góc trên trái; CanvasScaler1600x900/Match0.5 chưa thay thế anchor/layout responsive. HUD world chưa có safe-area container. Chưa đo trực tiếp mức lệch/cắt ở từng Simulator nên không gán mọi lỗi UI vào một nguyên nhân duy nhất.
- Phân biệt: Formation/StagePreview có Fit uniform scale, cần rà safe area/readability riêng; không kết luận mọi View đều hoàn toàn thiếu scaling.
- Hướng ở lúc khảo sát: vùng full-bleed riêng, SafeAreaRoot cho nội dung tương tác, anchor/layout/scroll theo vùng khả dụng; giữ art Crystal theo D17. Đã được yêu cầu và triển khai ở lượt tiếp theo, xem bổ sung nghiệm thu dưới đây.
- File liên quan: Presentation/ZatodPrototypeView.cs, ZatodStageUi.cs, ZatodWorldView.cs, ZatodFormationView.cs, ZatodStagePreviewView.cs. Phạm vi D22/D23; docs/zatod-hero-ui-review.md.
- Bằng chứng khảo sát ban đầu: ảnh người dùng + code/docs uGUI; thời điểm đó chưa đổi runtime hoặc chạy test. Kết quả triển khai/test đa aspect sau này được bổ sung phía dưới.


## BUG-038 — Kết nối View Hero native trong lượt triển khai đầu

- Ngày20/11/2026. **Trạng thái:** đã sửa,331+106+9 assertions PASS, build Windows thành công0 lỗi/2 warning cũ.
- Test runtime phát hiện filter không đổi danh sách dù nút hiện đủ. Nguyên nhân xác nhận: listener lambda được gắn trong Create ở Editor không được serialize vào prefab. Đã chuyển wiring Back/filter/Close sang Awake, giữ listener dữ liệu của cell được tạo lúc runtime.
- Builder cũng phát hiện thiếu resource battle_resource_bg do helper mới chỉ tra Hero/StagePreview/Formation. Đã thêm đường resource UI chung hiện có. Không thay art nguồn.
- SafeArea của package hiện cài dùng property Edges viết hoa; lượt compile đầu dùng edges gây CS1061, đã đối chiếu source và sửa.
- Import151 sprite vượt timeout30s của script eval. Đã kiểm tra scene authoring dọn sạch/prefab chưa tạo trước khi chạy lại với timeout180; importer chỉ reimport khi setting thực sự thay đổi.
- File: ZatodHeroUi.cs, ZatodHeroRosterView.cs, ZatodHeroDetailView.cs, ZatodPrototypeView.cs, AgentScripts/ImportZatodHeroUi.cs. Test/capture ở Artifacts/ZatodHeroUiChecks; kết quả cuối bổ sung khi hoàn tất.

### Bổ sung nghiệm thu20/11/2026 — BUG-037/038

- Lỗi chuyển Simulator/Game View xác nhận: Screen.width/height=1920×1080 trong khi Screen.safeArea=(132,63,2172,1062), vốn của2436×1125. SafeArea cũ tạo anchorMax=(1.20,1.04), HUD bị cắt dù đã có component. ZatodSafeAreaRoot clamp anchors vào[0,1], fallback full viewport nếu giá trị không hợp lệ.
- Nền mới là con safe area nên từng lộ world ở notch/bottom. ZatodFullScreenArt dùng Canvas bounds và cover theo aspect nguồn; control vẫn trong safe area, nguồn ảnh không đổi byte.
- BattlePoint thiết kế cố định: bổ sung fit chung Actors/Floating, giữ tọa độ và chain/projectile/text cùng scale. World neo cạnh; legacy menu có khung fit, seek theo chiều rộng.
- Đo bounds/runtime và xem ảnh nhiều lượt: Matrix331 PASS/5 kích thước, Flows106 PASS, NativeSafeArea9 PASS với safe area Simulator iPhone X ngang. Console cuối trước build không lỗi compile/runtime mới; chưa thử thiết bị vật lý.
- Phó bản validate263 tick/4 input/digest5691959244112859857;8 file Owned người dùng giữ SHA256;151 ảnh bằng byte nguồn. Không đổi core/save để test đạt.
- Nếu tái diễn: đọc Screen.width/height và safeArea cùng lúc, kiểm tra normalized anchors; phân biệt nền full-bleed và control. Kiểm tra callback sau Instantiate prefab, không chỉ object vừa Create trong Editor. Báo cáo: docs/zatod-hero-ui-implementation.md; Artifacts/ZatodHeroUiChecks.

- Bàn giao BUG-037/038: Windows Succeeded193.838s,0 lỗi/2 warning cũ, Console sau build không error mới/compilationFailed=false. Editor stopped/scene sạch, auto-tick=false; xóa23 preset test, giữ preset người dùng; server test riêng đã tắt. Build/native/UI/integrity reports cùng nằm trong Artifacts/ZatodHeroUiChecks.

## BUG-039 — Getter AxisOptions đệ quy trong source joystick export

- Ngày20/11/2026. **Trạng thái:** đã sửa getter trên bản import và kiểm tra đọc property thành công; nguồn package/ZIP giữ nguyên.
- Joystick.cs có `public AxisOptions AxisOptions { get { return AxisOptions; } set { axisOptions = value; } }`: getter trả property của chính nó thay vì field, nên đọc getter sẽ đệ quy không dừng. README export cũng ghi giới hạn này; source package giữ byte gốc. Không khẳng định game Zatod đã crash do lỗi này.
- Hướng xử lý khi được yêu cầu tích hợp: cấu hình qua field/Inspector hoặc adapter an toàn, tránh gọi getter; nếu cần sửa vendor phải giữ nguyên bản nguồn để đối chiếu. Direction/Horizontal/Vertical không đi qua getter lỗi này.
- Lưu ý thêm đã đọc tĩnh: ResetHandleAnchoredPosition đặt background về542/537; source chưa có reset OnDisable/focus loss hoặc kiểm soát active pointerId. Chưa báo các điểm này là lỗi tái hiện, cần kiểm tra adapter đa chạm và đóng modal khi triển khai.
- File nguồn trong package: Assets/Packages/Joystick Pack/Scripts/Base/Joystick.cs. Báo cáo docs/zatod-joystick-review.md; Artifacts/ZatodJoystickReview/package-inspection.json. Không sửa runtime/prefab hoặc khởi động Editor/server trong lượt khảo sát.

## BUG-040 — Import joystick chặn ở Missing signature và cache compile thiếu asset mới

- Ngày20/11/2026, đã xử lý,73 checks Editor PASS, Windows build Succeeded0 lỗi. ImportPackage(false) vẫn mở Missing signature, làm CLI timeout180s và các lệnh Editor/Console chờ30s. Đã quan sát đúng dialog trong Unity Zatod, xác nhận import package người dùng cung cấp sau khi checksum/source đã được đối chiếu; không đổi setting bảo mật.
- Sau import, lượt compile báo CS0246 ZatodFixedJoystick. Xác nhận File.Exists=true nhưng AssetDatabase.LoadAssetAtPath<MonoScript>=false; CompilationPipeline của Zatod.Runtime vẫn giữ source/ref cũ. Force-import đúng .cs/.asmdef làm asset tồn tại nhưng source list chưa cập nhật; đã yêu cầu CleanBuildCache qua CompilationPipeline để đồng bộ graph. Chưa coi là đã sửa trước khi compile/UI pass.
- Không chạy import lặp khi đang bị dialog; không xóa Library. File/restore: docs/zatod-joystick-review.md, Unity/Temp/restore/joystick-20261120/before.zip.

### Nghiệm thu joystick20/11/2026 — BUG-039/040

- Getter vendor đã đổi đúng `return AxisOptions` thành `return axisOptions`, giữ toàn bộ byte khác. Test đọc enum Both PASS;44 payload khác nguyên byte, package nguồn checksum đúng. Không dùng hàm ResetHandleAnchoredPosition có tọa độ542/537.
- Đã thêm adapter giữ pointer owner/reset input: nguồn OnDrag không virtual nên phải khai báo lại IDragHandler ở adapter; thử ExecuteEvents.dragHandler từ ngón khác không đổi input, nhả ngón khác không dừng ngón chủ.
- Sau force-import/CleanBuildCache, script được MoveAsset sang Presentation/WorldInput với GUID giữ nguyên; compile graph nhận source mới, compile thành công. Chưa kết luận nguyên nhân nội bộ Unity; không xóa Library.
- Hai lượt71 và73 checks PASS; clamp/analog/avatar/Editor keyboard, raycast Hero, modal/focus/pause/disable/portal/disconnect và4 tỷ lệ ngang. Console sau cursor99 không error mới, compilationFailed=false/consoleErrors=0. Nguồn: docs/zatod-joystick-implementation.md và Artifacts/ZatodJoystickChecks.
-8 file Owned hiện có không thay SHA256; không đổi combat/network/save để test đạt. Windows build Succeeded274.235s,0 lỗi/3 warning legacy/library. DLL Player không Keyboard/WASD, DLL Editor vẫn Keyboard; server local đã bật lại PID37136/TCP7788 với dữ liệu cũ.

- Bàn giao BUG-039/040: Editor stopped/scene sạch, auto-tick=false, Console cuối không error mới sau cursor101/compilationFailed=false. Đã dọn10 preset test.8 file Owned local vẫn đúng SHA256 sau restart; joystick package gốc giữ nguyên. Reports tại Artifacts/ZatodJoystickChecks; báo cáo chuẩn docs/zatod-joystick-implementation.md.

## BUG-041 — Avatar SPUM quay mặt ngược hướng đi ngang

- Ngày20/11/2026. **Trạng thái:** đã sửa,18 checks Editor PASS, Windows build Succeeded0 lỗi.
- User kéo joystick sang phải nhưng avatar nhìn trái, cảm giác chạy lùi. Prefab Unit gốc có eye/head geometry hướng trái ở scaleX dương; Animate lại đặt X dương khi Facing=+1. Read-only runtime cho thấy wrapper âm khi Facing=-1; Animator nằm ở con Unit, không ghi curve lên scale của wrapper.
- Cần đảo mapping art ở wrapper, áp cả frame khởi tạo và remote avatar; giữ Facing trong network theo nghĩa +1 phải/-1 trái. Khi lật wrapper cần lật cả offset X căn giữa để không làm avatar nhảy điểm chân. Không sửa sprite/clip gốc, joystick hoặc tọa độ mô phỏng.
- File: Presentation/ZatodWorldView.cs. Restore: Unity/Temp/restore/avatar-facing-20261120/before.zip. Báo cáo và ảnh/test sẽ ở Artifacts/ZatodFacingChecks.

- Nghiệm thu BUG-041: mắt render nhìn phải khi đi+X, trái khi-X; network vẫn+1/-1. Idle giữ hướng, frame đầu Facing=1 có mirror, flip hai lần giữ scale/offset. Remote path thử visual clone gọi chung Animate, chưa phải hai client mới.18 checks PASS và ảnh tại Artifacts/ZatodFacingChecks/live; Console không lỗi mới sau cursor110.
- Dòng hướng dẫn đã bỏ cả Editor, không tắt WASD Editor. Map được đối chiếu: ba định nghĩa, một cụm geometry hiện tại, một scene; chỉ giải thích docs/zatod-world-map-lifecycle.md, chưa đổi model/lifecycle.

- Bàn giao BUG-041: Windows Succeeded26.111s,0 lỗi/1 warning ArenaView API cũ. Console không error mới sau cursor113, Editor stopped/auto-tick=false, scene sạch. Local server khởi động lại PID49832 READY TCP7788, data Artifacts/ZatodServer;8 file Owned giữ SHA256.

## BUG-042 — Vòng đời map prototype lệch concept các đảo cùng tồn tại

- **Ngày:** 20/11/2026. **Trạng thái:** đã xác nhận khác biệt thiết kế/source; CHƯA sửa runtime theo yêu cầu chỉ khảo sát.
- **Triệu chứng:** ở Town zoom out không thấy chương1/chương2; qua portal thay cụm map. Người dùng mong server/client có các đảo sẵn, chuyển bằng teleport theo concept Treasure Hunter.
- **Nguyên nhân xác nhận:** ZatodWorldView.Snapshot gọi LoadMap khi MapId/revision đổi; LoadMap Destroy landscape/avatar rồi dựng cụm mới. RegisterWorldServer tải catalog/state, không dựng runtime map root; các map dùng tọa độ riêng. Đây là lựa chọn implementation cũ, không phải lỗi camera hoặc thiếu asset. D21 trước đó chưa quy định vòng đời các đảo; người dùng nay làm rõ yêu cầu.
- **Đối chiếu:** TH WorldManager tạo mọi land theo LandCenter; server RuntimeLandData.GenerateMapBehavior Instantiate/NetworkServer.Spawn chunk; client tạo nền mọi đảo, tái dùng tile pool quanh camera. TeleportToLand cộng LandCenter, server SetPosition, client SnapClientState/ResetMap. Bằng chứng source Dev, chưa đo runtime/production TH trong lượt này.
- **Xử lý:** cập nhật D21 và docs/zatod-world-map-lifecycle.md về hướng yêu cầu, evidence và phần chưa làm. Không đổi gameplay, config runtime, scene/prefab, build hoặc trạng thái server. Gói TH export có art/visual, không có code gen world theo phạm vi export đã chốt.
- **Kiểm tra:** đọc source hai checkout TH Dev, serialized BattleManager.prefab, hai chat TH được dẫn trong tài liệu và source Zatod. Chưa có kiểm thử kiến trúc mới; không đánh dấu đã sửa. Khi triển khai cần kiểm tra ba map root hai phía, offsets, teleport/camera/pose revision, hai client theo vùng và tiến trình cá nhân/trận riêng.
- **Nếu tái diễn:** phân biệt catalog map, GameObject server, geometry client, tile pool/culling và network observers; MapId/catalog không chứng minh đảo đã tồn tại trong scene.

## REVIEW-001 — Combat render bằng Canvas và world phụ thuộc trạng thái UI

- **Ngày:** 21/11/2026. **Trạng thái:** đã rà source; rủi ro kiến trúc cần đánh giá, chưa sửa hoặc xác nhận lỗi hiệu năng. Không coi dùng Canvas/SetActive tự nó là bug.
- **Quan sát xác nhận:** Background là RawImage; Hero/projectile/effect là các GameObject RectTransform có UI Image dưới Actors/Canvas. ReplaySprite dùng SpriteRenderer tắt render để sample animation rồi gán sprite sang Image. WorldIntegration lấy stage.activeSelf làm BattleVisible; WorldView từ đó ẩn landscape/avatar và ngừng xử lý world ở client này. Server vẫn giữ player state.
- **Rủi ro, chưa coi là triệu chứng tái hiện:** thay sprite/transform UI liên tục có thể tăng chi phí Canvas; world root SetActive sẽ ảnh hưởng component/collider/coroutine nếu gắn gameplay vào đó; trạng thái vào/ra trận đang liên kết UI active; world ẩn vẫn giữ tài nguyên. Chưa đo Profiler, không gán lag cũ cho Canvas, không khẳng định rò bộ nhớ hay lỗi server.
- **Hướng đề xuất chưa duyệt:** tách state transition World/Battle và presentation khỏi UI active; cân nhắc SpriteRenderer dưới BattleRoot hoặc scene battle client additive, HUD giữ Canvas. Không thay simulation/checker/timing hoặc dùng ServerChangeScene toàn server. Chi tiết docs/zatod-world-map-lifecycle.md.
- **Bằng chứng:** đọc ZatodPrototypeView.cs, ReplaySprite.cs, ZatodBattleHudLayout.cs, ZatodBattleHud.cs, ZatodWorldIntegration.cs, ZatodWorldView.cs; package uGUI UICanvas.md/Image.cs xác nhận render mode/draw order và sprite setter dirty. Chưa chạy test/build/runtime; chỉ cập nhật tài liệu. Khi triển khai cần đo mobile Canvas/render/memory và kiểm tra vào/ra nhiều trận, return context, network world và cleanup asset/PlayableGraph.

- **Đối chiếu Crystal21/11/2026:** đã xác nhận nguồn tạo CCScene và background/main/top layer, Hero CCNode + FCA actor, projectile sprite/FCA; HUD có ui_layer riêng. Một số effect có nhánh z=2 lên UI. Scene manager push/replace, không đồng nhất với Unity additive hoặc chứng minh mọi thứ là UI. Zatod render Image dưới Canvas hiện không trùng tổ chức render này; đây là khác biệt source, chưa chứng minh lỗi hiệu năng và chưa duyệt chuyển implementation. Evidence/line tham chiếu: docs/crystal-battle-presentation-review.md. Chỉ đọc source và bổ sung tài liệu.
- **Chốt hướng21/11/2026 sau khảo sát:** người dùng đồng ý scene battle riêng, yêu cầu tổng hợp phase trước thực thi. Đã ghi D25 và docs/zatod-world-battle-phase-plan.md; additive/renderer/lifetime là kế hoạch trình duyệt chi tiết. Chưa sửa code hoặc đo lại hiệu năng; REVIEW-001 vẫn chưa đánh dấu đã xử lý.


## BUG-043 — Chrome menu có thể che renderer Arena/PvP sau đổi scene

- Ngày21/11/2026. Đang sửa trong phase D21/D25, chưa nghiệm thu. Static review: RefreshWorldChrome chỉ clear root/backdrop khi screen=campaign hoặc Hero UI; Arena/PvP screen khác nên Canvas nền opaque sẽ che camera battle mới. Lỗi phát sinh ở tích hợp renderer mới; chưa coi là lỗi production cũ.
- Hướng sửa: chrome dựa trạng thái scene controller để clear background/hide menu/header trong Loading/InBattle/Returning; không suy game state từ UI active. Cần kiểm tra ảnh Arena/PvP và return world sau sửa.
- Liên quan: ZatodWorldIntegration.cs, ZatodBattleSceneController.cs; docs/zatod-world-battle-implementation.md. Đợi lượt build đang chạy hoàn tất trước sửa source/rebuild; chưa đánh dấu đã sửa.

### Tiến trình BUG-042/REVIEW-001 —21/11/2026

- Đã thêm config từng đảo và compiler offset không mutate dữ liệu authoring; server map roots/collider, lọc custom snapshot theo map/radius; client giữ map root và camera layer tách world/battle. Pure core PASS4.748 assertions; compile Editor chưa lỗi.
- Đã tạo scene qua Pipeline; helper authoring từng sai namespace CampaignDataJson được sửa trước khi chạy thành công. Đây là lỗi helper, không đổi gameplay để làm test đạt.
- Build lần đầu vượt CLI180s; chưa có report, Editor đang xử lý assets/cold-content allocations. Không khởi chạy thêm build. Chưa gán nguyên nhân duy nhất hoặc báo build fail vì request timeout.


### Nghiệm thu BUG-043/BUG-042/REVIEW-001 —21/11/2026

- BUG-043 đã sửa chrome theo scene controller, không còn nền Canvas che camera ở Arena/PvP; ảnh07-arena và pvp-live/01-pvp đã kiểm tra. Compile không lỗi.
- Live48 checks, PvP8 checks, parity toàn146 sets/31261 checks, responsive50 checks PASS; chi tiết docs/zatod-world-battle-implementation.md.3 vòng replay dọn scene/PlayableGraph, cancel-load/disconnect/reconnect phục hồi world; root đảo không bị tạo lại.
- Helper từng dùng GetInstanceID bị Unity6.6 chặn compile, sửa GetEntityId; helper responsive serialize Unity Rect tạo vòng normalized, sửa scalar DTO. Không phải lỗi runtime hoặc thay luật gameplay.
- Có native error MissingForLoadFailureTest trong Console từ test lỗi load có chủ ý; controller xử lý và trả World/scene count1. Không clear Console. Phân biệt lỗi kiểm thử dự kiến với scene battle thật bị thiếu trong build.
- Chưa kết luận FPS/mobile hoặc toàn bộ phase bàn giao trước khi build cuối và smoke interest/owned audit hoàn tất.


### Bàn giao D21/D25 —21/11/2026: BUG-042/BUG-043 và REVIEW-001

- BUG-042 đã xử lý/nghiệm thu: config3 đảo riêng, server/client giữ root, global origins, portal teleport/revision, custom interest. Live root IDs không đổi; final world và interest/stale-pose smoke2 client trên build cuối đều PASS.
- BUG-043 đã xử lý/nghiệm thu: chrome theo scene state, ảnh Arena/PvP hiển thị renderer mới, không bị Canvas menu che.
- REVIEW-001 đã xử lý phần tổ chức render/lifetime: Battle scene additive, actor/effect SpriteRenderer, HUD Canvas, transition không suy từ panel active, cleanup graph/scene qua3 replay cycles và lỗi/cancel/disconnect. Không suy đo ngắn Editor thành kết luận hiệu năng mobile hoặc nguyên nhân lag cũ.
- Build cuối Succeeded162.611s/0 errors/2 warnings, bản chuẩn Builds/ZatodPrototype/ZatodLegend.exe. Audio khi pause/seek giữ theo cờ playing. Core4748, parity31261 (146 sets), live48, PvP8, responsive/failure50 PASS; network/GUID24 pairs giữ,8 file Owned local SHA256 nguyên vẹn.
- Các lỗi helper được sửa trong lượt: namespace CampaignDataJson, GetInstanceID obsolete->GetEntityId, Newtonsoft serialize Rect->scalar DTO. Lỗi scene thiếu có chủ ý được controller xử lý; giữ Console/buffer lịch sử, ground truth cuối0 error/compilationFailed=false. Không xóa Library hoặc sửa vendor Mirror để che warning reconnect.
- Báo cáo docs/zatod-world-battle-implementation.md; evidence Artifacts/ZatodWorldBattleChecks. Editor stopped/scene sạch/auto-tick=false, override background trả projectValue=true. Server test do agent tạo đã dọn; main server PID12320 READY TCP7788 với dữ liệu cũ.


## BUG-045 — Reconnect đăng ký callback trùng, gửi hello hai lần

- Ngày21/11/2026. Phát hiện khi nghiệm thu loot; đã sửa và kiểm tra lại PASS.
- Triệu chứng: nhận/lưu loot và reject claim trùng đều đúng; sau disconnect/connect cùng app, server báo `Launch already initialized.`. Log server test có hai hello trên connection mới.
- Nguyên nhân xác nhận: ZatodConnection.Connect cộng OnConnectedEvent/OnDisconnectedEvent/OnErrorEvent mỗi lần gọi, nhưng chỉ trừ khi OnDestroy. Instance sống qua reconnect nên cùng callback chạy nhiều lần.
- Sửa: trừ handler của instance trước khi cộng lại trong Connect; không xóa handler của các subscriber khác. Rebuild để kiểm tra reconnect với receipt và GUID giữ nguyên. File Unity/Assets/Zatod/ArenaNetwork/ZatodConnection.cs; bằng chứng Artifacts/ZatodLootChecks/network.
- Nghiệm thu: build cuối25,04s/0 errors/1 warning. Network cuối13 checks PASS, reconnect giữ4 GUID và receipt; server-final.log không còn Launch already initialized. Lượt trước sửa lưu tại reconnect-before-fix.log/json. Giữ claim duplicate bị REJECTED là kết quả kiểm thử mong đợi, không phải lỗi mới.

## D26 — Loot Phó bản: random số lượng, tổng tỷ lệ100% và settlement

- Ngày21/11/2026. Người dùng duyệt thiết kế và yêu cầu triển khai. Đã nghiệm thu core, network và build.
- Thay semantics D19 từ thử rớt độc lập từng dòng100% thành chọn đúng một loại theo tỷ lệ trên mỗi lượt. Thêm MaxDropAmount=5, migrate39 ải thành50%/50%, tổng100%. Không đổi wave/enemy/cost/layout hoặc dữ liệu owned.
- Thêm ZatodCampaignLoot RNG riêng, server giữ pending loot theo battleId; grant GUID sau validate thắng và lưu Owned. Thua/cancel không thưởng, claim trùng/replay không cấp lại. Khi persist thất bại rollback inventory/revision và giữ pending để retry. Start packet mang ItemId preview, account snapshot có receipt GUID thật. Không thêm animation loot/HUD economy ở lượt này.
- Core4.819 assertions PASS, có kiểm tra biên RNG gần1 (double sang decimal có thể làm tròn1; chọn fallback loại cuối có tỷ lệ dương để không hụt số món), tỷ lệ60/30/10, zero/max count, GUID, duplicate/reject/loss/cancel/save-failure/retry/replay/new launch. Đây là xử lý biên trong code mới, không gán thành lỗi đã tồn tại ở bản game cũ.
- Unity compile không lỗi. Cập nhật cả hai importer để không quay lại100% mỗi dòng; StageDrops re-import39 ải thành78 dòng/20 loại. Audit xác nhận ngoài loot/version dữ liệu ải giữ nguyên. Backup Artifacts/ZatodLootChecks/before.zip; hướng dẫn docs/zatod-stage-drops-config.md.
- Network cuối13 checks PASS: loot plan4 món ở start chưa vào kho; validate thắng thì4 GUID thật được lưu Owned; claim lại bị chặn; replay không cấp thêm; reconnect giữ dữ liệu. Snapshot receipt không lấy item list từ claim. Bản build cuối Succeeded25,04s/0 errors/1 warning; build đầu220,99s/0 errors/2 warnings, sau đó sửa BUG-045 và build lại. Test dùng server riêng17995 và account mới; không farm loot vào Owned local của người dùng.
- Bàn giao: cập nhật Builds/ZatodPrototype, đối chiếu SHA256 đủ218 file khớp build đã test. Copy ban đầu báo mono-2.0-bdwgc.dll còn bị khóa ngay sau Stop-Process; sau khi process thoát, audit xác nhận toàn bộ file đã khớp, không còn file cần sửa. Nếu lặp lại, chờ process thoát trước khi copy và audit bundle thay vì chỉ nhìn exit code Copy-Item.
- Server test17995 đã dừng; server local mới PID30608 READY TCP7788.8 file Owned local giữ nguyên SHA256. Editor stopped,1 scene sạch, auto-tick=false; console ground truth0 errors/compilationFailed=false (giữ lịch sử buffer). Artifacts/ZatodLootChecks/handoff.json là trạng thái bàn giao.

## BUG-044 — Config đảo chưa được đưa vào GameEditor

- Ngày21/11/2026. Đã triển khai và kiểm tra theo yêu cầu đưa config map lên Editor.
- Nguyên nhân xác nhận: GameEditorWindow chỉ có7 tab Hero/Monster/Item/Stat/Skill/Buff/Campaign, không đọc Worlds.txt/WorldMaps. Config đã tồn tại và runtime dùng được nhưng phải mở text ngoài.
- Đang thêm tab Maps/menu GameEditor > Maps, editor đọc authoring local riêng từng đảo, validation và save bảo vệ stale/draft; không đổi runtime layout hoặc owned data.
- Trong compile file mới GameEditorWorldMaps.cs, Unity API Updater bật Script Updating Consent. Source đầu dùng UnityEditor.UIElements.PopupField bị CS0234; đã đổi sang PopupField cùng using như editor hiện có. Unity vẫn chờ hộp thoại updater từ lượt import trước. User đã cung cấp ảnh; hướng dẫn chọn Yes, just for these files, không đồng ý updater toàn project. Backup trước thay đổi và bản file trước updater tại Unity/Temp/restore/maps-editor-20261121.
- Lệnh Pipeline main-thread bị timeout do hộp thoại; background Console vẫn trả kết quả. Chưa gán timeout này thành lỗi runtime hoặc phải reset Library/scene. Tiếp tục compile/UI/save/stale checks sau khi dialog được xử lý.
- Nghiệm thu sau khi người dùng bấm consent: API Updater đổi tham chiếu thành `UnityEngine.UIElements.PopupField<string>`; compile sạch. `WorldConfigFileStore.cs`, `GameEditorWorldMaps.cs` và tích hợp `GameEditorWindow.cs`/`.uss` thêm chọn đảo, form local, raw JSON, validate/save maps, backup và guard stale/draft. Tabs cho phép xuống hàng; đường dẫn dài wrap.
- Kiểm tra `VerifyZatodMapsEditor.Run`: 19 PASS, gồm ba đảo, local spawn chapter1 X=6/origin110, đổi tab giữ draft, save map không ghi lại bảng khác, chặn radius sai và stale save, không mất draft khi file ngoài thay đổi, chặn path traversal. Test khôi phục nguyên byte config. So SHA256 baseline: 19/19 file config và Owned không đổi. Hai lượt source/style đều chạy lại PASS; capture review/final tại `Unity/Temp/MapsEditorReview/`, kết quả tại `Artifacts/ZatodMapsEditorChecks/`.
- Bàn giao mở `GameEditor > Maps`, Editor ngoài Play; không build/restart server vì chỉ thay công cụ Editor. Nếu tái diễn timeout, kiểm tra hộp thoại API Updater trước; không xóa Library hoặc reset config. Hướng dẫn `docs/zatod-maps-editor.md`.
- Lưu ý tooling lúc bàn giao: CLI/Pipeline beta dùng `editor set_auto_tick` và `console get --since`, không dùng `editor set-auto-tick`/`console read`. Hai lệnh sai tên đã sinh hai entry CommandNotFound trong Console; đã xác nhận stack thuộc Pipeline, không phải lỗi compile/game. Lệnh đúng trả auto-tick=false; console kiểm tra cuối compilationFailed=false/compiling=false. Giữ log lịch sử, không clear Console.


## DOC-001 — Trùng nội dung quyết định loot trong Design.md

- Ngày21/11/2026. Phát hiện khi đọc trước khảo sát D27: có hai section D26 giống hệt và một đoạn ghi chú D19 lặp. Đã giữ một bản nguyên nội dung của mỗi mục, không đổi quyết định hoặc runtime. Chưa xác minh cơ chế phát sinh; thấy sau các lượt cập nhật tài liệu trước đó. Kiểm tra còn một heading D26, một D27 và một ghi chú D19; không sửa code/config/asset.

- Tái kiểm21/11/2026: hai dòng bàn giao D27 giống hệt đã bị lặp liên tiếp; giữ một bản, không đổi bằng chứng hoặc runtime. Khi tool báo lỗi sau ghi, đọc lại trạng thái thực tế trước khi áp lại để tránh lặp nội dung; chưa khẳng định cơ chế phát sinh.

## BUG-046 — TMP outline lỗi khi dựng popup dưới root inactive

- Ngày21/11/2026, phát hiện trong triển khai D27. SetupZatodBattleResult dựng prefab dưới root inactive; TMP.Awake chưa chạy nên SetOutlineThickness dùng cache CanvasRenderer chưa có, gây NullReferenceException trong ZatodStageUi.Text. Đã đọc implementation TMP của package đang dùng để đối chiếu stack.
- Sửa: truy cập canvasRenderer và gán fontSharedMaterial từ font trước khi đặt outline. Giữ cùng font/outline, không bỏ style hoặc sửa package vendor. Đã kiểm tra prefab/live; file ZatodStageUi.cs, helper SetupZatodBattleResult.cs. Không có gameplay/config/Owned thay đổi vì lỗi authoring này.
- Live fixture xác nhận cùng lỗi còn ở helper Text riêng của ZatodFormationView.CreateCard khi tạo portrait bên trong popup inactive; đã áp dụng cùng khởi tạo cache/material tại helper này. Lỗi khiến popup không mở và lặp exception mỗi frame; không phải thiếu receipt hoặc loot mapping. Giữ log lịch sử; kiểm tra lại sau compile/Play mới.

- Kiểm tra21/11: prefab tạo thành công, Play pass3 qua113 checks, cả portrait và popup không còn exception. Nếu tái diễn ở helper khác, kiểm tra vòng đời inactive/TMP cache trước khi nghi thiếu font hoặc receipt.


## BUG-047 — Kết quả tới lúc scene đang tải bị hiểu thành mở replay

- Ngày21/11/2026, phát hiện và tái hiện bằng VerifyZatodBattleResultUi: invoke kết quả đúng battleId ngay sau Enter khi scene còn LoadingBattle; biến replay bị tạo dù đây là ack trận đang chơi.
- Nguyên nhân: OnReplay dùng stage.gameObject.activeSelf để phân biệt ack với yêu cầu xem lại. Panel còn inactive khi scene tải nên nhánh ack bị bỏ qua; trái hướng lifecycle D25.
- Sửa: dùng battleScene.OccupiesClient cùng mode/battleId và trạng thái replay. Đã nghiệm thu UI113 checks và network17 checks: ack sớm vẫn thuộc trận live, popup dùng receipt, yêu cầu xem lại sau về World vẫn vào replay. File ZatodPrototypeView.cs; bằng chứng Artifacts/ZatodBattleResultChecks/early-ack-before-fix.json.


## BUG-048 — Effect một lần đứng ở frame cuối trận phía sau popup

- Ngày21/11/2026, xác nhận qua capture pass1: sét đòn cuối còn đứng yên phía sau reward popup. Nguyên nhân: model đã finished nên elapsed của effect không tiến nữa, renderer vẫn giữ sprite effect.
- Sửa: sau finished, renderer cho effect một lần và clip Death tiến hết bằng thời gian trình bày; projectile ẩn sau nhịp cuối. Không Step core, không đổi tick/damage/RNG/digest hoặc tiếp tục effect gây damage. Reset clock khi đổi simulation/seek/Clear. Đã kiểm tra ảnh pass2/pass3; file ZatodBattleStage.cs.
- Kiểm tra21/11: ảnh pass2/pass3 xác nhận sét cuối đã chạy hết;13 archive cũ resimulate giữ nguyên digest/winner/stars/endTick. Cửa sổ thống kê mở lại cũng reset scroll về đầu qua113 checks UI pass3; không dùng normalized position còn sót của lần xem trước.

## D27 — Nghiệm thu rương, thưởng và thống kê

- Ngày21/11/2026. Đã triển khai theo yêu cầu; chi tiết `docs/zatod-battle-result-implementation.md`. Core4.838 assertions PASS, UI113 checks với14 dòng report/5 món thưởng,13 archive cũ giữ nguyên kết quả, server thật17 checks PASS với1 item GUID. Chống claim trùng, replay không thưởng, reconnect giữ receipt và Owned; dùng server17994/account mới, không thử trên inventory người dùng.
- Nguồn art:40 ảnh byte gốc và7 FCA bake/import; có sao động, rương SpriteRenderer/shine, receipt popup/4 tab report responsive. EXP0/0 và vàng? đúng phạm vi; loot mapping ưu tiên boss không dùng thêm RNG combat. Không thay model drop hoặc bảng config ở phase này.
- Build Windows Succeeded256,30s/0 errors/2 warnings: FindFirstObjectByType obsolete tại ArenaView cũ và pragma debug shader TMP vendor. Không sửa nguồn/package ngoài phạm vi để che warning. Console get mới sau lượt network không có runtime exception/missing glyph. Warning reconnect Mirror thay handler đã có trong những lượt trước; giữ nguyên vendor.
- Helper network ban đầu dùng overload Zip mới không có trong Unity runtime; đã dùng overload selector tương thích. So sánh double qua JSON tuyệt đối bằng bit báo FAIL tại3 dòng với chênh1,776e-15, trong khi digest/HP/kết quả giữ nguyên. Đã lưu `network/report-mismatch-details.json` và sửa phép so của helper thành sai số tương đối1e-10; không đổi core hoặc làm tròn dữ liệu runtime để né test. Lượt cuối `network/result.json`17 PASS.
- Tooling import: helper cũ có top-level statement không dùng được làm ScriptRun class (CS8803); wrapper named entry riêng khắc phục. Import FCA lớn/build có thể kéo dài hơn timeout; kiểm tra evidence/report trước khi chạy lại để tránh chạy chồng. `console status` timeout trong build không phải bằng chứng Editor chết; build đã hoàn thành256,30s. Không clear Console.
- Bàn giao:218/218 file deployed khớp SHA256;19/19 file config/Owned giữ nguyên byte. Server riêng21876/17994 đã dừng; server local23052 READY/listen TCP7788 với data cũ. Editor stopped, chỉ ZatodPrototype sạch, auto-tick=false; Console ground truth0 errors/compilationFailed=false. `Artifacts/ZatodBattleResultChecks/handoff.json`, `deploy-audit.json`, `protected-after.json`, `console-final.json`.


## REVIEW-002 — Đường mặc đồ chưa rollback bộ nhớ khi lưu Owned lỗi

- **Ngày:**21/11/2026. **Trạng thái:** đã sửa và kiểm tra trong triển khai D28; phần khảo sát ban đầu bên dưới giữ làm bằng chứng trước sửa.
- **Bằng chứng cấu trúc xác nhận:** ZatodServer.cs nhánh equip gọi session.Equip trước SendAccount; ZatodPlayerSession.Equip gọi ItemInventory.Equip rồi tăng Revision; ItemInventory chuyển GUID từ Inventory sang EquippedItems ngay trong Account. SendAccount mới gọi SaveOwned. Nếu SaveOwned throw, nhánh equip không có restore Account/Revision. SaveOwned có file tạm/Replace giúp ghi đĩa, không tự rollback bộ nhớ.
- **Giới hạn kết luận:** đây là rủi ro luồng lỗi, không phải đã quan sát item mất/nhân đôi trong trận hoặc save thực tế. Không thử phá file Owned, không thay dữ liệu người dùng. Chưa có bằng chứng đây là nguyên nhân một lỗi chơi được báo.
- **Đề xuất khi triển khai:** giao dịch account dùng state tạm/rollback khi persist thất bại cho equip/craft; chỉ gửi snapshot thành công sau save, chống xử lý lặp cùng mã yêu cầu. Tham khảo rollback loot đã có ở ZatodPlayerSession.ValidateCampaign; không mặc định đủ cho mọi thao tác khác. Cần kiểm tra lỗi persist, retry, GUID chỉ ở một nơi và reconnect bằng account riêng.
- **Nguồn:** Unity/Assets/Zatod/ArenaNetwork/ZatodServer.cs; Combat/ZatodPlayerSession.cs; Heroes/ItemInventory.cs. Thiết kế D08/D12/D28; phân tích docs/zatod-equipment-crafting-review.md.


- Nghiệm thu D28: EquipItem/Craft dùng chung transaction, rollback khi persist throw và giữ receipt sau load. Core4.933 PASS có cả hai lỗi save được giả lập, network14 PASS xác nhận GUID/receipt/Owned và replay request không thực thi lại; không thử phá Owned thật.

- Rà vòng lặp21/11 sau D28: phạm vi đã sửa của REVIEW-002 là equip/craft. Nhánh Promote vẫn gọi thay đổi rank/AbsorbedItems rồi mới SendAccount/SaveOwned; chưa có rollback/retry receipt cho Promote. Mới đọc cấu trúc, chưa giả lập lỗi ghi hoặc quan sát mất dữ liệu thực tế; ghi để xử lý cùng phase UI tiến bậc, không coi toàn bộ thao tác account đã được transaction hóa.

## BUG-049 — Popup craft dùng font bootstrap thiếu glyph tên ải

- Ngày21/11/2026, phát hiện khi kiểm tra Get Way. Popup mới được author bằng FormationFont cũ từ bootstrap, không có fallback; tên ải chương2 xuất hiện warning10 glyph thiếu. Không phải thiếu text/asset item hoặc recipe.
- Sửa: SetupZatodCrafting dùng ZatodFormationLatin và fallback ZatodFormationFont native; bake thêm ký tự tên39 ải và112 tên item với HasCharacter trước TryAddCharacters, giữ kinh nghiệm BUG-019. Không đổi tên ải hoặc dùng font OS. Lượt Play sạch cuối qua74 UI checks, Console0 glyph warning; prefab đúng font native và clipping.

## BUG-050 — Prefab authoring còn layout của assembly trước compile

- Ngày21/11/2026. Source đã đổi nút Back/vị trí Message nhưng ảnh Play vẫn dùng nút X, StatsHeight285/MessageY-735. Probe runtime xác nhận prefab giữ giá trị cũ trong khi dynamic icon renderer đã là bản mới.
- Nguyên nhân xác nhận: helper authoring chạy trước lượt reload hoàn tất nên Create dùng assembly cũ rồi lưu prefab; sửa source không tự dựng lại hierarchy trong prefab. Khắc phục: Stop Play, Refresh ngoài Play, đợi reload, author lại; helper kiểm tra child Arrow của layout mới trước SaveAsPrefabAsset. Không sửa scene của người dùng hoặc reset Library.
- Một lượt Play bắt đầu chồng reload có catalog nonserialized=null dù frame vẫn tiến. Đã xác nhận bằng probe, dừng Play/chờ stopped và compiling=false rồi mở phiên mới; không inject catalog giả vào runtime để né lỗi. Giữ ui-reload-before-restart.json. Đây là vấn đề trình tự authoring/test, chưa có bằng chứng phát sinh trong Player build.


## D28 — Nghiệm thu config craft và UI mặc/ghép

- Ngày21/11/2026. Theo lệnh thực thi và yêu cầu thêm view config lên Editor. Import36 dependency mới, tổng112 item/55 recipe, ItemKind Equipment/Fragment/Material; không đổi stats/fields khác của76 món cũ hoặc pool drop.144 ảnh nguồn byte-identical, prefab Crafting, native font có fallback Trung. GoldCost giữ số nguồn, phí thực thu0.
- GameEditor có tab CraftRecipes/menu GameEditor -> Craft Recipes; GoldCost là LongField, nested ingredient editor, validate/stale/draft/save cùng hệ thống hiện có. Editor9 checks PASS. Nguồn recipe và validator cycle/duplicate/reference/amount nằm trong core, không chỉ là JSON để UI đọc.
- Core4.933 assertions PASS; UI74 checks PASS (slot, recipe tree/back, fragment tag, actual equipped state, raycast modal, responsive); network14 PASS trên server riêng17993/account mới, bấm hai lần, retry cùng ID, thiếu nguyên liệu, craft5 GUID mảnh, equip giữ GUID, persist và reconnect.14 archive cũ giữ nguyên digest/winner/stars/endTick. Build Windows Succeeded183,52s/0 errors/2 warnings có sẵn (ArenaView obsolete API và TMP shader pragma).
- File/bằng chứng: docs/zatod-crafting-implementation.md; Artifacts/ZatodCraftChecks/core-checks.txt, editor.json, ui/result.json, network/result.json, archive-regression.json, data-audit.json, before.zip.7 Owned local giữ hash như trước lượt thực thi; không reset account hoặc farm vào kho thật.
- Test đầu đã kỳ vọng một GUID Boots cụ thể phải còn lại, trong khi thuật toán chọn GUID theo thứ tự ổn định được phép dùng một trong hai Boots tương đương. Đã sửa assertion kiểm đếm/uniqueness/đúng loại thay vì ép ngẫu nhiên một GUID; không sửa thuật toán để né test. CLI beta không có status --until-ready, dùng log xác nhận Pipeline restart trước kết nối lại.
- Lúc deploy Stop-Process với PID23052 báo NullReference của PowerShell; đã dùng CIM đối chiếu đúng executable Builds/ZatodPrototype/ZatodLegend.exe, dừng nếu còn sống và xác nhận process/cổng đã nhả trước copy. Đây là lỗi thao tác công cụ đã có workaround, không quy thành lỗi server gameplay.

- Bàn giao D28: bundle11,5GB/218 file đối chiếu SHA256 khớp toàn bộ, server test6344 đã dừng; local33836 READY TCP7788 với data cũ.7 Owned giữ hash, Editor stopped/scene sạch/auto-tick=false và tab CraftRecipes đã mở55 công thức. Evidence Artifacts/ZatodCraftChecks/handoff.json.

## REVIEW-003 — Get Way mới liệt kê tên ải, chưa có thẻ nguồn và điều hướng đầy đủ

- **Ngày:**21/11/2026. **Trạng thái:** đã xác minh source/data và dựng preview; chưa sửa runtime theo yêu cầu kiểm tra trước.
- **Triệu chứng:** bấm scroll116 trong recipe121 hiện Crafting formula với root trống và danh sách tên ải bằng chữ. Icon scroll vẫn hiện trong ingredient. Đây là feature Get Way sơ khai của D28, không kết luận item/IconResource thiếu.
- **Nguyên nhân đã xác nhận:** ZatodEquipmentView.DrawTree nhánh recipe==null chỉ tạo Sources Text rồi return, không dựng source buttons hoặc đổi decoration theo chế độ Get Way. Asset scroll UI/DOTA-ITEM/246+.jpg và định nghĩa bracer_of_strength_scroll đều tồn tại. Crystal components==0 chủ động ẩn mainLayer1, dùng accessNormalItem/accessLockItem/accessSpecialItem và Back; thiếu root product icon một mình không phải bằng chứng thiếu art.
- **Đối chiếu:** PackageSourceWin.packageGetWay đọc equip.Drop/How To Get; equipcraft.clickGetWay chỉ cho Normal đi tiếp và giữ getWayItemId/getWayItemNeed. Native scroll có8 nguồn; Zatod DropItems có3 nguồn2-5/2-8/2-20. Không sửa mapping drop để ép hai nguồn dữ liệu trùng nhau.
- **Visual ải:**39 interaction đã map đúng SourceStageId/resid,13 dùng hình riêng/12 ảnh,26 node thường. Stage23 cố ý dùng resid7; stage-23.png không tồn tại không phải asset bị mất. Các đường locked art theo mapping cũng tồn tại. Xem CSV trong artifact.
- **Kiểm tra:**48 native ảnh đã mở/đo kích thước/hash;9 ảnh preview có file; JavaScript preview qua node --check; font native DFPYuanW7-GB đủ glyph tên39 ải/8 nguồn. Hai lượt visual review đã thay font ảnh do SourceHanSans-Heavy thiếu glyph và sửa nền modal; không sửa font runtime. SHA2568 file code/config trước/sau không đổi; không vào Play/build hoặc đọc/ghi Owned.
- **Giới hạn:** preview source-art reconstruction, không phải game Crystal chạy thật; unlock/stars/count mẫu. Chưa thêm button Get Way vào Unity, dispatcher/world navigation, shop/Elite hoặc thay visual ải trong scene. Yêu cầu/ranh giới theo D29.
- **Bằng chứng:** `Artifacts/ZatodItemSourcesReview_20261121/README.txt`, `audit.json`, `verification.json`, `stage-visual-mapping.csv`, ảnh và `START_HERE.html`. Giữ nguồn raw Crystal và mọi runtime asset hiện có.
- Bổ sung preview21/11 theo yêu cầu: thêm icon ải vào đầu cell, giữ text như ref và action/Locked. Mười stage references gồm Normal/Elite/current pool đã resolve đúng asset, Stage Group/resid và kiểm tra hash icon gốc; chữ giới hạn305px không chạm action. Lưu bản riêng IconCells, giữ baseline Crystal không icon. Giải thích rõ Unity chỉ có Sources Text, còn chuyển ảnh ở HTML là demo ngoài game. Chưa sửa runtime;8 hash code/config giữ nguyên.
- Chốt lại21/11: tên ải English và source cells hiện chỉ để xem. Đã xác minh runtime Campaign.Name còn raw CN và WorldMap Label là số; English tồn tại trong texttable (Embarkation/Easy Prey). Preview trước lấy nhầm raw name và có hotspot mở ảnh stagedetail; preview mới dùng46 English mappings/đủ39 active, nút map có tên và không có source navigation callbacks. Chưa sửa runtime. Không tiếp tục coi thiếu action nguồn ở phase này là lỗi cần tự nối; tự di chuyển avatar là hướng về sau.8 hash runtime giữ nguyên. Xem D29 và IconCells/verification.json.


## D29 — Nghiệm thu nguồn nhận item và marker Crystal

- Ngày21/11/2026, theo lệnh thực thi sau duyệt phase. Đã thay Sources Text/cây ghép trống bằng mode Available from với icon/tên English/trạng thái thật, danh sách cuộn và No sources available; giữ Back/craft/equip. Không gắn Button hay callback click vào source row theo yêu cầu mới nhất, không coi việc chưa điều hướng là lỗi.
-39 Campaign.Name dùng localization English chính thức;39 world interaction Label/VisualResource/Height đổi đúng mapping,13 dedicated/26 generic. Stage23 dùng resid7.80 PNG marker runtime chỉ crop vùng alpha rỗng, kiểm tra RGBA crop trùng nguồn;3 ảnh source-card byte-identical. Prefab/texture/font được author qua Editor API; không sửa scene YAML. Importer lấy English để tránh tái xuất tên raw CN.
- Core4.933 assertions, Editor240, source UI71, craft/equip UI74, live world208 checks PASS;14 replay cũ giữ digest/winner/stars/endTick. Live server/account riêng17992: đủ39 marker/nhãn, di chuyển thật, nút Embarkation, mở preview/formation, thắng trận và trở lại đúng vị trí, chapter2 khóa đúng. UI kiểm tra1600x900/2436x1125/2400x1080/1600x1200. Không claim thêm kiểm thử peer/mobile thật trong phase này.
- Lần build đầu thất bại do ổ E thiếu dung lượng khi copy resources.assets.resS (console1098), không phải lỗi compile. Đã giữ build-failed-disk.json, chuyển output sang workspace ổ C đủ chỗ; build sau Succeeded39,25s/0 errors/0 warnings trong report incremental. Hai warning nguồn có sẵn ở lượt đầu (ArenaView obsolete API, TMP shader pragma) không được coi là đã sửa. Không xóa cache/build cũ của người dùng.
- Helper live cũ nhắm tọa độ local9,8.1 sau khi map có OriginX110 nên bị kẹt biên; probe xác nhận position110.28,7.93. Sửa riêng helper cộng origin, chạy fresh Play thành công; giữ helper-before-origin-fix.json. Tách capture nút world và popup khác frame để tránh ảnh đầu bị ghi đè. Không thêm autopath vào runtime.
- Bundle218 file/11.506.444.240 byte khớp SHA256 với bản test trước khi chạy lại local server22592 READY TCP7788. Chỉ dừng đúng process server chuẩn33836 và server thử35936, giữ data cũ.9 Owned/2 scene/3 map gameplay và toàn bộ Campaign fields ngoài Name/ConfigVersion giữ nguyên. Editor stopped, không scene dirty, auto-tick=false, background override restored.
- Bằng chứng: docs/zatod-item-sources-implementation.md; Artifacts/ZatodItemSourcesChecks/{import,editor,ui,archive-regression,build,data-audit,deploy,handoff}.json; craft-regression/result.json và world/result.json. Restore Unity/Temp/restore/item-sources-20261121/before.zip. Không thay loot/economy/combat/Owned hoặc các TH object ngoài39 stage marker.

- Công cụ cuối phase: lệnh background ban đầu dùng nhầm group editor tạo console1107; đã tra metadata và chạy đúng editor.playmode set_run_in_background=false (overridden=false/projectValue=true). Helper script top-level cũ không hợp CLI hiện tại được bọc class/entry trước chạy. Console cuối không có lỗi runtime mới ngoài lỗi build disk đã giải thích và lỗi lệnh đã sửa; giữ console-final.json, không clear lịch sử.
