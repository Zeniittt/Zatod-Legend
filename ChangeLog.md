# Zatod Legend — Lịch sử lỗi và cách xử lý

Cập nhật 20/11/2026 (Asia/Saigon). Tra theo mã/triệu chứng trước khi sửa lỗi. Chỉ ghi nguyên nhân đã có bằng chứng; giả thuyết ghi riêng. Design.md là nguồn quyết định thiết kế.

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
