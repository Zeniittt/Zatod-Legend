# Zatod Legend — Lịch sử lỗi và cách xử lý

Cập nhật 25/11/2026 (Asia/Saigon). Tra theo mã/triệu chứng trước khi sửa lỗi. Chỉ ghi nguyên nhân đã có bằng chứng; giả thuyết ghi riêng. Design.md là nguồn quyết định thiết kế.

## D39 — Triển khai persistence và Login/Register, 25/11/2026

- **Đã hoàn tất trên Mac:** runtime/core/Unity/TCP/UI/replay và IPA arm64 chưa ký đã kiểm; chưa build/deploy Windows hoặc cài thiết bị. Nhánh `codex/d39-player-persistence`, baseline `72c543ffd`, restore nhỏ `Artifacts/D39Checks/before.zip`.
- **Triển khai:** một `PlayerDatabaseStore` với mọi Player ở `datas.json`; GUID do server tạo, username/password exact, password nguyên văn theo scope prototype và tách khỏi snapshot/replay. Register riêng, Login không tạo account; một phiên/account. Working copy tách bản commit để save Player B không lẫn thay đổi chưa commit của A. Ghi file tạm/flush/replace/backup; file hỏng không reset trắng; schema mới hơn không tự downgrade bằng backup.
- **Campaign/giao dịch:** nạp và chụp sao/clear; commit với loot/EXP/Gold/stamina/receipt, rollback Run + account khi ghi lỗi. Disconnect bỏ issued battle, giữ entry cost; login về Town và hồi stamina theo giờ server. Đội hình lưu và chuyển account dọn lựa chọn/UI của người trước.
- **Kiểm đã đạt:** persistence36; legacy8.051/native3.017/Hero112/policy46; TCP303 với2Player và restart server/store trong Editor, sai password/thử lại, duplicate account, guest hello bị từ chối, interruption/equip rollback/retry và PvP; UI528 trên4tỷ lệ+safe area, confirm/show-hide;4replay appV4/V5/V6/V7 đạt109 checks, không thưởng/unlock. Hai archive TCP Campaign/PvP khớp khi resimulate bằng.NET. Evidence `Artifacts/D39Checks/`.
- **Lỗi harness đã xử lý:** cleanup GameView test gọi RemoveCustomSize bằng custom index thay vì index tổng, gây log Invalid index; đã sửa và chỉ gỡ các size nhãn D39 của chính lượt này. Lượt UI xác nhận528 đạt, không lỗi mới sau cursor12305. Một fixture replay coreV4 không có Background không phải archive app, nên thử UI ban đầu báo thiếu nền; giữ evidence, không sửa combat/render để ép fixture hợp lệ. Chạy lại từ phiên Play sạch bằng archive app thật đạt109 và console groundTruth0errors. Không clear Console bằng tool.
- **IPA đã kiểm:** `/Users/bloom/Desktop/Zatod Legend/Builds/D39/20261125-135629/ZatodLegend-D39-unsigned.ipa`, 1,650,312,887byte/unsigned; CRC/ZIP64/arm64/plist/LAN/framework/19Data/20TextAsset và3markerD39 đạt. SHA256 `dd44b2fe14ce3fd58abdd782161f1a37757ed3f94da3ea0367694deedceec9c6`. Editor cuối stopped/sạch/auto-tick=false, server/client fixture tắt, console0errors/5warnings. Giữ build D38 và dữ liệu cũ.
- **Giới hạn:** chưa chạy PowerShell/Windows process hoặc máy thật trong lượt này; Mac chưa có Windows support module/pwsh. Không đồng bộ/push, không cài app. Báo cáo và trạng thái artifact cuối tại `docs/zatod-player-persistence-implementation.md`.

## REVIEW-026 — Lưu tiến trình JSON theo username: khảo sát trước phase D39

- **Chốt sửa phạm vi 25/11 mới nhất:** người dùng muốn **một JSON lớn chứa toàn bộ Player**, không phải một file mỗi Player; agent đã hiểu sai cách tổ chức file. Password lưu nguyên văn; hoãn hash/mã hóa đường truyền/auth hoàn chỉnh, giới hạn thử và xử lý Register đồng thời nâng cao; chưa đổi/quên mật khẩu. UI Confirm Password/hiện-ẩn và chỉ nhớ username/IP được đồng ý. Các đề xuất bảo mật/mỗi GUID một file phía dưới là lịch sử, không áp làm yêu cầu D39. Chỉ cập nhật tài liệu, chưa sửa runtime.
- **Kiểm tra Server IP:** `StartServer` lấy thư mục từ `--data-dir` hoặc persistentDataPath, không dùng IP để chọn save; `Start-ZatodServer.ps1` mặc định `Artifacts/ZatodServer`. `ZatodGuestLogin` lưu endpoint vào PlayerPrefs và có LAN discovery ngoài iOS. Đổi mạng/IP cùng server và data directory không reset data; kết nối server/data directory khác không tự đồng bộ. Đây là kiểm tĩnh code, chưa thử chuyển mạng/server trong lượt này. File chung phải giữ dữ liệu mọi Player qua mỗi lần ghi; không gửi credential hoặc cả kho Player cho client.
- **Chốt tiếp 25/11:** giữ GUID account để link account tương lai; `TinBo`/`tinbo` khác tài khoản; thêm password và hai tab Login/Register. Đồng ý không resume trận/đăng nhập về Town và cấu hình tạo account chỉ áp dụng lần đầu; thể lực trận ngắt còn cần ghi rule cụ thể. Không triển khai link account trong lượt này. Các đoạn identity còn mở phía dưới là lịch sử trước chốt mới, đọc theo Design D39.
- **Khảo sát password:** `ZatodConnection.Start` chọn `TelepathyTransport` trực tiếp; Mirror có `EncryptionTransport` nhưng chưa được flow bật. `OnConnected` gửi account GUID do client giữ và `hello` nạp account, chưa xác minh password (đúng phạm vi guest hiện tại). Khi triển khai auth phải thay/cấm đường guest bỏ qua xác thực, gắn connection/session bằng account đã xác thực và không gửi credential trong snapshot. Đây là yêu cầu chuyển từ guest sang password, chưa có bằng chứng lộ mật khẩu vì runtime hiện chưa có password. Username phân biệt hoa/thường phải tra bằng so sánh chính xác, filename dùng GUID để tránh phụ thuộc filesystem. Tham khảo OWASP Password Storage/Authentication/TLS ngày25/11; thuật toán/transport cụ thể chưa chốt hoặc kiểm runtime.
- **Làm rõ tiếp 25/11:** người dùng đồng ý phạm vi dữ liệu, save theo giao dịch và server quản lý/backup/chặn phiên trùng; bỏ yêu cầu giữ/migrate data trước phase, bắt đầu dữ liệu mới. Username/GUID tài khoản vẫn đang giải thích; account GUID không phải yêu cầu bắt buộc nếu dùng username duy nhất bất biến. Không suy bỏ migration thành bỏ GUID Hero/item mới. Các đề xuất giữ data cũ bên dưới là lịch sử đã được D39 thay thế; chưa xóa/reset file thật hoặc đổi runtime. Người dùng đồng ý tách persistence khỏi resume giữa trận, nhưng policy trận dang dở/vị trí login chưa có lựa chọn cụ thể.
- **Ngày:** 25/11/2026. **Trạng thái:** kiểm tra tĩnh/brainstorm, chưa sửa runtime hoặc thử ghi save. Đây là khoảng trống so với phase mới, không coi reset Campaign đã duyệt ở D11 là lỗi.
- **Mục tiêu người dùng:** lưu Player/Campaign/Hero và dữ liệu sở hữu qua đăng nhập; cân nhắc một JSON/người chơi theo username thay database tạm thời.
- **Bằng chứng code:** `ZatodServer.HandleRequest(hello)` nạp `Owned/<GUID>.json` theo account GUID; `GuestIdentity` chỉ chuẩn hóa display name. `SaveOwned` ghi `.tmp` rồi Replace/Move. `ZatodPlayerSession` khởi tạo `CampaignRun` rỗng; `ValidateCampaign` persist thưởng/receipt trước `Run.AcceptValidated`. `MainCampaignProgress` chỉ khai báo ClearedStageIds, chưa có sao và chưa nối vào flow Run. `JoinWorld` hiện luôn spawn Town entry.
- **Rủi ro cần xử lý khi triển khai:** chỉ serialize thêm Campaign sau settlement sẽ không bảo đảm thưởng và clear/sao được commit cùng nhau; dùng tên hiện có để tự gộp save sẽ nhầm khi trùng tên. Cần giữ GUID Hero/item/absorbed, receipt chống xử lý lặp và thời gian hồi stamina server khi mở schema/identity mới. Chưa kiểm bằng lỗi giả lập, không khẳng định đã có mất/nhân thưởng thực tế.
- **Đề xuất chưa duyệt:** ánh xạ username đã chuẩn hóa tới ID ổn định; một nguồn state/server và một phiên sửa mỗi account; commit progression/thưởng/receipt cùng nhau, rollback cả state bộ nhớ khi save lỗi; backup/version/migration; không tự tạo account mới khi file cũ hỏng. Chốt chính sách trận dang dở và vị trí đăng nhập riêng.
- **Kiểm cần có ở lượt thực thi:** đóng/mở app và restart server giữ tiến trình; đổi thiết bị cùng username; chặn đăng nhập trùng; retry không cấp thưởng/trừ tiền lại; lỗi ghi/crash và save hỏng không làm reset account; migration giữ GUID/sao/level/item/skill. Không phục dựng Campaign từ replay lịch sử khi chưa có quyết định migration cho việc đó.
- **File liên quan:** `Unity/Assets/Zatod/ArenaNetwork/ZatodServer.cs`, `ZatodConnection.cs`, `ZatodWorldNetwork.cs`; `Combat/ZatodPlayerSession.cs`; `Heroes/HeroData.cs`, `WaveDefinition.cs`, `GuestIdentity.cs`; `HeroIntegration/HeroDataJson.cs`. Hướng phase và phần chưa chốt nằm tại Design D39; chỉ cập nhật Markdown trong lượt này.

## D38 — Hoàn tất triển khai và IPA trên Mac, 25/11/2026

- **Kết quả:** Equip/7 điểm Town/selector8chương/portal/boss154ải/55key+99minor/preload/PoolManager đã triển khai. Giữ Owned/GUID và simulation/replay rules; không chạy server Windows hoặc app thật để thử.
- **Kiểm:** legacy8.051/native3.017/Hero112/policy46; preload74match; UI52+hit8/8+pointer; WorldTCP130/Equip11/lifecycle11; PvP5v5/116tick/digest10896472758431214544 và replay/.NET khớp. Farm20.510trận clear154/5Tím; stress39vòng/1.205,61s có7.078frame summon/2.011reuseFX. Sửa cleanup/selection cuối được kiểm lại: một vòng33checks, replayUI136checks, pooltextactive0 và console không có lỗi mới. Báo cáo `docs/zatod-world-ui-polish-implementation.md`.
- **Build:** Unity export0lỗi/5warning; Xcode Releasearm64 BUILD SUCCEEDED, signing disabled. IPA `/Users/bloom/Desktop/Zatod Legend/Builds/D38/20261125-105521/ZatodLegend-D38-unsigned.ipa`,1.650.298.553byte; ZIP64/CRC/plist/LAN/framework/unsigned và20TextAsset trongproduct đạt. SHA256 `98068d3c555e1285b61e22e051f1f1dffd3482101da23d474de3df92fd664cec`. Giữ IPA cũ; chưa ký/cài/chạy iPhone hoặc kiểm lại Windows/Android thật; client/server cần cùngD38.
- **Bàn giao:** source/config/art/test nằm trong worktree, chưa commit/push. Source126C# và20Data khớp workspace build; Artifacts giữ evidence. Editor cuối dừngPlayMode, fixtures tắt. Các thử lỗi/các mốc đang triển khai bên dưới là lịch sử điều tra; không dùng chúng thay trạng thái cuối này.

## BUG-084 — World input đọc control UI đã bị hủy

- **Ngày:** 25/11/2026. **Trạng thái:** đã sửa và kiểm pointer click/drag/close, replay UI và console sau return.
- **Triệu chứng/bằng chứng:** sau pointer test đóng/hủy UI, world Update lặp MissingReferenceException ở WorldIntegration InputLocked. EventSystem còn giữ selected GameObject đã Destroy; toán tử `?.` không xử lý Unity fake-null nên GetComponent vẫn được gọi. Reopen selector cũng có thể hủy các nút cũ đang được chọn.
- **Sửa:** kiểm Unity-null trước khi đọc input field; selector clear selection thuộc view trước rebuild và khi Hide. Không đổi khóa input gameplay/modal. Kiểm lại click/drag/close và console sau return.

## BUG-083 — Combat text còn giữ lease khi đã về world

- **Ngày:** 25/11/2026. **Trạng thái:** đã sửa và kiểm lại: một vòng thật/33 assertions và replay UI 136 assertions; pool UI active bằng 0 khi về world, giữ 34 object idle để tái sử dụng.
- **Bằng chứng:** kiểm cuối thấy pool UI còn 9 lease active dù đã rời replay; stage/effect pool đã dọn. `Show` ẩn HUD nhưng chưa gọi ClearFloating, nên các số cuối trận chỉ được release ở lần vào trận sau. Không có bằng chứng tăng vô hạn; đây là sai vòng đời cleanup D38.
- **Sửa:** release số combat khi frame Finished và khi Show rời battle; không dựng lại text từ các event của frame đã kết thúc. Bổ sung assertion pool UI active bằng 0 sau return/exit replay. Scene/simulation/timing/reward không đổi.

## BUG-082 — Vùng trong suốt của đảo chọn chương chặn đảo khác

- **Ngày:** 25/11/2026. **Trạng thái:** đã sửa, kiểm GraphicRaycaster 8/8 đảo, pointer click/drag và responsive đạt.
- **Triệu chứng:** bấm giữa hình chương 6 có thể chọn chương 7. Test gọi trực tiếp onClick vẫn đạt nên không đủ để chứng minh vùng bấm đúng.
- **Nguyên nhân xác nhận:** Image mặc định bắt toàn bộ hình chữ nhật; góc trong suốt của ảnh chương 7 chồng lên chương 6. Probe qua EventSystem xác nhận sai 1/8 điểm giữa đảo; pixel nguồn tương ứng có alpha 0. Sprite đã có mesh Tight 122 vertex nên có thể dùng geometry hiện có, không cần bật đọc texture hoặc đổi pixel/nén.
- **Hướng sửa/kiểm:** giới hạn raycast theo mesh của Sprite, dùng cùng hình học khi vẽ; kiểm lại các tâm đảo, kéo/chọn và responsive. Evidence trước sửa: `Artifacts/D38Checks/hit-probe2.json`. Không đổi điều kiện mở chương hoặc gameplay.
- **Kết quả:** thêm `ZatodSpriteHitArea` dùng mesh Tight có sẵn cho hit test; giữ nguyên ảnh/nén/layout, không bật readable texture. Probe thực nhận đúng cả 8 đảo, Input System mouse chọn một lần và kéo không chọn; 52 checks responsive/cutout vẫn đạt. Evidence `hit-probe-final.json`, `pointer.json`, `Visual-final/`.

## REVIEW-017 — Selector chương, art thị trấn và policy đánh lại ải Crystal

- **Kiểm D38 ngày 25/11:** giao dịch Equip qua TCP đạt 11 ca về nhấn kép, reply trễ sang Hero khác, receipt lặp, GUID stale, rollback khi lưu lỗi, reconnect và flow xem/craft. Lifecycle đạt 11 ca lỗi/hủy/retry loading, reset pool, generation guard và giới hạn giữ object. Ba peer TCP đạt 130 assertions về cùng/khác map, join muộn, Passed cá nhân, request stale, minor/key và guard battle. Preload đạt 74 match (66 Hero và 8 encounter cuối chương), không thiếu dependency bắt buộc.
- **Farm D38 ngày 25/11:** account khởi đầu nguyên trạng vượt 154/154 ải và đủ 5 Hero Tím sau 20.510 trận; Player/Hero 69, tiêu 90.844 thể lực, chờ 348,93 ngày mô phỏng. Chỉ farm lại key và tuân thủ gate chương; không sửa reward/EXP/regen/giá hoặc cấp đồ/level. Balance vẫn nặng; không dùng kết quả này để tự duyệt balance mới. Evidence: `Artifacts/D38Checks/farm.json`, bản gọn `farm-summary.json`.
- **Nguồn item sau policy mới:** 99 loại drop, 81 có nguồn key; 18 chỉ ở minor, trong đó 12 ghép được từ nguồn key. Sáu loại còn lại (`axe_of_plunderer`, `brilliance_scroll`, `dragoncore_scroll`, `grandbow_scroll`, `harpy_eagle`, `satan_scroll`) không có nguồn key/recipe từ key trong phiên. Đối chiếu cả 66 Hero và cây recipe xác nhận chúng không là dependency đồ trước Tím. Không thêm loot/recipe; Get Way giữ art/flow D29 và hiện Passed/gate level đúng policy D38.

- **Bắt đầu thực thi D38, 25/11/2026:** từ baseline `522721a34`, nhánh `codex/d38-world-ui`. Đã nối policy dùng chung selector/portal/begin; nhập 55 Key/99 minor cùng gate Lv1/5/8/16/26/36/46/56 từ source, giữ encounter/reward/Evo. Core 8.051 và policy 46 assertions đạt; Unity đang kiểm, chưa nghiệm thu phase/build. Dùng workspace/profile/port riêng.
- **Đầu vào công trình:** helper bake effect cũ chỉ tra `patch/pfca/effect/`, không thấy bốn container tại `recovered/assets/install_time_pack/remake/pfca/effect/`. Script `Bake-ZatodD38Buildings.py` resolve đúng nguồn đã giải nén, không cần APK/ZIP. Container PeakArena có timeline tham chiếu `a2.png` nhưng atlas container không có sprite này (KeyError khi decode); không tự bỏ layer hoặc coi cờ spine=true là format đã được hỗ trợ. Chọn công trình Crystal `eff_UI_Main_Pvp_fort` cho điểm PvP realtime với nhãn riêng; đây là lựa chọn art Zatod, không khẳng định feature Crystal gốc là realtime. Giữ container/source raw.
- **Công cụ Unity:** lần mở Editor main thoát trước khi ready, log chưa xác định nguyên nhân; chuyển sang workspace kiểm/build cô lập đã có theo quy trình D34, không thay scene/source raw main. Import art vượt timeout30s nhưng vẫn tiếp tục; đã chờ/kiểm asset rồi chạy với timeout dài, xác nhận đủ25resources. Lỗi compile local trùng tên biến effect đã sửa; console/compiler cuối còn phải kiểm sau test.

- **Ngày:** 24/11/2026. **Trạng thái:** đã khảo sát và chốt D38; chưa sửa runtime/import/bake/build.
- **Triệu chứng/yêu cầu:** điểm Phó bản ở làng đi thẳng chapter1; object tính năng còn art world cũ, điểm ải có hai kiếm; người dùng muốn selector Legend World, portal hai đầu, boss đại diện và Passed nhưng vẫn xem preview.
- **Nguyên nhân/xác nhận từ code:** WorldIntegration gọi WorldTravel ngay cho portal, WorldNetwork chưa gate chapter level/progress. CampaignStageDefinition chưa có KeyStage; StagePreview chỉ gate connected/unlocked nên chưa biểu diễn minor đã clear không được đánh. Đây là khoảng trống với thiết kế mới, không quy kết server binary cũ là nguyên nhân của layout này.
- **Bằng chứng nguồn:** legendaryContinent.lua có selector, art nền/đảo1–8/outline/khóa có trên đĩa; mainSceneMapConfig ánh xạ Pve/Guild/Pvp/fancytower/PeakArena sang container Crystal. Stage.lua và stageselect.lua/stagedetail.lua phân biệt ải nhỏ một lần với ải chính đánh lại. Normal1–8 có154ải=55key+99minor; không khóa đánh lại tất cả Normal. Đây là bằng chứng client, backend Crystal chưa phục hồi đầy đủ.
- **Chốt người dùng:** giữ phân biệt minor/key; mở chương cần qua chương trước và đủ account level. PlayerLevel.Chapter nguồn cho1–8: Lv1/5/8/16/26/36/46/56. Minor passed vẫn preview được là yêu cầu riêng Zatod. D38 thay travel tự do củaD21 và art điểm ảiD29 trong phạm vi này; D11 reset Campaign theo launch giữ nguyên.
- **Kiểm tra chỉ đọc:**39ải hiện hành đều có boss (26DefinitionId), AnimationSet resource đều tồn tại; pool20 loại item đều có nguồn tại13key stage, không có loại chỉ ởminor. Chưa kiểm balance/độ phủ115ải mở rộng hoặc render building FCA/Spine; chưa gọi đó là nghiệm thu gameplay.
- **Bàn giao/lưu ý:** `docs/zatod-world-chapter-selector-review.md` ghi asset/source, mốc unlock, phạm vi, migration/giao dịch và ma trận nghiệm thu. Gate phải ở server cho cả portal/selector/bắt đầu ải; Passed là cá nhân trong map chung, không tạo thêm loot hoặc resetOwned. Giữ BUG-067/UX-001 và các thay đổi đang có.
- **Làm rõ tiếp 24/11:** người dùng giữ reset Campaign ở phase này, save progress phase sau; duyệt selector tự cuộn tới chương đang chơi/cao nhất đã mở và lý do khóa rõ, kiểm bộ client/server mới cùng UX-001. Agent đã diễn đạt lưu ý combat quá rộng khiến có thể hiểu phải làm lại phần phase trước; đã làm rõ đây là hồi quy nền simulation/input/checker/replay hiện có, còn presentation D34 giữ checklist đã duyệt. Chưa thêm runtime, kiến trúc tối ưu asset hoặc build trong lượt làm rõ.

- **Hiệu năng — bổ sung phương án 24/11:** người dùng xác nhận cần nghiệm thu performance và hỏi cách làm. Đọc code xác nhận WorldView tạo toàn bộ map trước, BattleSprite load cả AnimationSet, BattleStage tạo/hủy visual theo phát sinh; đây là điểm cần đo khi mở rộng, chưa chứng minh lag/leak hiện tại. Đã ghi baseline, load theo map/trận, world Idle riêng, dependency preload, cache/pool có giới hạn, audit BUG-056 và test20vòng/20phút trong review; chi tiết là đề xuất, chưa sửa runtime hoặc đo FPS/RAM/build.

- **Chốt thay phương án hiệu năng 24/11:** người dùng yêu cầu ignore mục1 baseline trước sửa và mục2 tải/cache map riêng; duyệt mục3 chuẩn bị asset trước trận, mục4 dùng **PoolManager** cho object lặp cùng kiểm texture, mục5 test20vòng/20phút. Đã thay nội dung hiện hành trong D34/review để agent sau không áp lại đề xuất bị bỏ. Pool phải reset sạch trạng thái/callback/context, có giới hạn và cleanup; không thay logic combat/checker. Chưa code/test/build hoặc chốt60FPS.

- **Sửa nhầm ranh giới phase 24/11:** agent đã trình bày gộp D34 (mởTím/chương3–8/PvP40Hero/combat presentation) vào phase sau; người dùng sửa rõ phase hiện tại bắt đầu từ yêu cầu sửa nútOK. Đã ghi phạm vi D38 từ UX-001 trở đi, chuyển quyết định hiệu năng khỏi D34 sang D38 và sửa checklist để không giao lại phần phase trước. Giữ dữ liệu khảo sát và trạng thái kiểm chứng cũ, không suy lời sửa phạm vi thành bằng chứng mới mọi phần cũ đã nghiệm thu. Chỉ cập nhật Markdown.

- **Bàn giao Markdown 24/11 theo yêu cầu người dùng:** tạo `docs/zatod-world-ui-polish-phase-plan.md` riêng cho D38, đủ phạm vi/ngoài phạm vi/source-ignore/migration/giao dịch/checklistA–G/trạng thái và D37. Gắn link ở đầu Design/README/review D38, đánh dấu D34 review và world-battle plan là phase trước. Lưu nguyên byte3ảnh người dùng dưới `docs/reference/d38-world-ui/` (kiểm SHA256 khớp bảnTemp) để clone khác có ref. Không sửa code/config/asset runtime, không mở Unity hoặc build; chưa commit/push trong nhiệm vụ tài liệu.

## BUG-067 — Quick Equip/nâng skill bị server Windows trướcD35 từ chối

- **Ngày:**24/11/2026. **Trạng thái:** đã xác nhận nguyên nhân triển khai, chưa rebuild/restart/sửa runtime trong lượt kiểm tra.
- **Triệu chứng người dùng:** bấmQuickEquip khôngđược, nângskill khôngđược dù đãbỏ gatePlayerLv7. Log `Artifacts/ZatodServer/server.log` hiện nhiều dòng `[ZatodServer] REJECTED connection=1 Unknown Crystal command.`.
- **Bằng chứng:** processZatodLegend PID3248 chạy từDesktop/Zatod Legend LAN Test/Windows/ZatodLegend.exe, start24/11 lúc14:54:55; executable ởDesktop vàBuilds/ZatodPrototype vẫn từ22/11. Log xácnhậnMonoManaged từfolderDesktop. KiểmDLLDesktop `Zatod.Runtime.dll` cóchuỗiUnknownCrystalcommand nhưng khôngcó chuỗiUTF16skill_up/quick_equip, timestamp22/11; codeD35 mới cócase cho cảhai ởZatodServer. KhôngcoiCIMaccessdenied làbằngchứng servertắt; dùngGet-Process đãđọcđượcdúngpath.
- **Đối chiếu điều kiện chỉ đọc:** savegầnnhấtTinBo: PlayerLv3,Gold4334, cả5HeroLv4/skill1Lv1. Theo config hiệnhành, skill đãmở cóthể nâng1→2 với100Gold vàcap4; CocoGreen mởslot1/2, cácHeroWhite mởultimate. QuickEquip cóứngviên thật: CocoBranches1ô; DR/Lina/EnchBranches2ô; ZeusBranches2ô+RingofRegen1ô. Khôngthiếulevel/khôngcókho hợp lệ trongcácứngviên này. Chỉđọc/tính điều kiện, khôngthực hiệnEquip/Upgrade trênaccountthật; hashsave giữnguyên tronglượtđọc.
- **Kết luận/phạmvi:** server đang dùng chưa hỗ trợ hai commandD35, lànguyênnhân xácnhận củarequestbịreject; khôngcógatePlayerLv7 trongSkillProgression.Plan/ZatodHeroSkillPanel hiệnhành. Chưaquan sátUIbằngmắt hoặc bắttừngpacket đểgắn mỗilầnclick vớitừnglogreject; nếu sauđồngbộbuild còn nútkhóa thì kiểmthêm rankunlock,capHero,Gold vàbusy/battle/queue theo reasonUI, khôngbỏ cácguard đãchốt.
- **Cách xử lý cần làm:** build/cậpnhật đúngWindows/server lênD35; chúýStart-ZatodServer.ps1 ưu tiênDesktopWindows trướcBuilds/ZatodPrototype. GiữDataDirectory/Owned/GUID, client/servercùngconfig/rules, thửlạihai command vàreceipt/save/reconnect trướcđánhdấuđãsửa. Người dùng hiệnchỉyêucầu kiểmcase, chưa có lệnhbuild/deploy hoặc tắtserverđangdùng.

## UX-001 — Equip thành công còn phải bấmOK để đóng panelitem

- **Triển khai D38 ngày 25/11/2026:** panel theo dõi operation/Hero/slot/GUID và context mỗi lần mở/đóng; chỉ tự đóng khi snapshot có receipt khớp và đúng GUID đã mặc. Đang kiểm trong Unity với profile riêng. Không coi item đã mặc hoặc một refresh bất kỳ là giao dịch vừa thành công.

- **Ngày:**24/11/2026. **Trạng thái:** đã xácnhận flowcode vàghi quyếtđịnh mớiD28, chưa thayruntime.
- **Triệu chứng/nguyênnhân:** `ZatodEquipmentView.Act` gửiconnection.Equip, `ZatodPrototypeView.OnChanged` gọiRefresh; Refresh thấyEquippedItems cóitem thì đổiActionButton thànhOK, vẫngiữGameObjectactive. `Act` ởtrạngtháiequipped chỉHide khi bấmlầnnữa. Đây làhànhvi code hiệncó, khôngphải equip chưađượclưu.
- **Yêu cầu đãchốt:** tựđóng panel đangEquip saureceipt/snapshot xácnhậnđúngoperation/hero/slot/GUID, cậpnhậtHeroDetail; lỗi/thấthại giữpanel vàreason. Khôngđóngpopupmớiđãmởkháccontext bởireplycũ; khôngsuy mọirefresh/equipped=true thànhoperationvừathànhcông. Xemitemđãmặc hoặccraft khôngtựđổi thànhEquip mới/Promote.
- **File/kiểmtra tiếp:** ZatodEquipmentView.cs, ZatodPrototypeView.cs, ZatodConnection.cs; khi sửa kiểmsuccess/fail/doubleclick/receiptlặp/reconnect/đóngmởpaneltrướcreply, giữGUID vàOwned. Lượtnày chỉđọcsource/log/save, khôngsửaC#/prefab/scene hoặcchạygiaodịch.

## BUG-081 — IPA lớn bị lỗi CRC do kích thước ZIP32 tràn 4 GiB

- **Ngày:**24/11/2026. **Trạng thái:** đã sửa và kiểm gói cuối; chưa ký/cài thiết bị.
- **Triệu chứng:** nativebuildthànhcông nhưngzipfile.testzipbáoCRC lỗiở`Payload/ZatodLegend.app/Data/resources.assets.resS`.
- **Nguyên nhân xác nhận:** ditto ghiZIP32,extract_version20,kíchthước2.980.440.640trongheaderthayvì7.275.407.936byte; chênhđúng2^32,khôngcóZIP64sizeextra. KhôngphảilỗiUnityData/nativecompile. BảngDataexport/appđãkhớp trướcđónggói.
- **Sửa:** `scripts/Package-ZatodUnsignedIos.py` dùngzipfileallowZip64,streamfilevàgiữmodeUnix/symlink; thêm`--package-only`đểdùngnativebuildđãthànhcôngnhưngvẫnkiểmapp/export/Data/binary/payloadtrướczip. Khôngrecompilenativehoặcthayassetsđểchữalỗiarchive. HashstreamtươngthíchPython3.9.6.
- **Kiểm:** gói cuốiCRCtoànbộđạt,entrylớnsize7.275.407.936/extract_version45,executablebitsđúng. HaiBinaryarm64unsigned,iOS15/LAN/BundleID/noUnityRuntimeđạt;20TextAssettrongappđúngbyte. IPA1.611.039.514byte/SHA256631f433067f62b46b4b856583b46610deb3b087f678c6cdff7bf552bf583c6c1. Bằngchứng`Builds/D34Complete/20261124-v7-3b14df41db3fe55e/{ditto-zip-failure,zip64-verification,ipa-verification}.json`;gói lỗi giữtên`ditto-invalid.zip`,khôngbàn giao.
- **Nếu tái diễn:** kiểmextract_version/ZIP64extra/file_sizevớifilePayloadgốc,tránhchỉkiểmfilezipcóthể mở. NativebuildSucceededkhôngthayCRC;khôngdùngIPAartcũđểbáođãbuildbảnD34mới.

## REVIEW-025 — Tiếp tục D34: hook V7 và nội dung encounter ngoài roster PvP

- **Đã hoàn tất/kích hoạt 24/11:** MainData chuyển66Hero/40free,42Monster,154ải/462wave/9map,versionzatod-d34-v7-3b14df41db3fe55e saukhi đủkiểm. Nativeactive3.017,legacyactive8.051,routeactive359 đạt; giữ120C#Main/workspacekhớp và20Datađúngbyte. FixtureReadWorld cònmộtpathResourcesruntimeđãlộsaukíchhoạt66;đãđổisangbaselineWorldMaps,khôngsửaGameWorldđểnétest. Mainfont/sourceCrystal/GUID/Ownedkhôngđổi. Báocáo/Design/phase-plan/manifestactiveđãcậpnhật.
- **Farm đã nghiệm thu:** v33kếtthúc44.082trận,154clear/5Tím,Player71/Hero70;Goldchi12.721.700,thểlực101.969,chờ372,47ngày môphỏng. JSONxácnhận sau40k botfarm7-20thắng5/3.056trận,khôngphảilỗithưởngmấttiền. Harnessbiếtlùiảiđãchạyfreshaccountxong22.286trận,đủ5Tímtừ8.072,Player/Hero71,Goldchi16.947.100,thểlực102.656,chờ393,56ngày. Giảmtrậnkhônggiảmtươngứnglịch vìthểlựchồitrongthời gianđánh; cảhaichỉNormal/recovery,khôngdailies/nguồnbổsung. Đây làfindingbalancenặng,chưađổiEXP/reward/regen/giá/sao. Evidencefarm-comparison.jsonvàhaiJSONđầyđủ; khôngdùngprobeđủđồthayfarm.
- **Bàn giao cuối:** Unityexport0lỗi/5cảnhbáo,XcodeReleasearm64succeeded;IPAunsigned1.611.039.514byteđãCRC/ZIP64,19fileDataexport→product,20TextAssetruntime,plist/LAN/binary/chữký/frameworkPASS. SHA256631f433067f62b46b4b856583b46610deb3b087f678c6cdff7bf552bf583c6c1. FontMainSHA81efe104c04cde2280942707560652ddb8c364a9f8ae6b385a2419a54b9731dbkhôngđổi; Unitybổsung5kerningpairtrongbảnsaoexport,strictdiffchỉthêmcặp,khôngđổiglyph/character/atlas/fontsource. KhôngthayfontMainbằngcachetest. Consoleđoạncuối0lỗimới,khôngxóaConsolelịch sử. Chưa ký/cài/chạy iPhone/Windows/Android mới,khôngcommit/push/đồngbộPC; server/clientphảicùngD34.15audio vắngsourcevàprimarydynamichoãngiữghirõ.

- **Nghiệm thu trước kích hoạt 24/11:** native core3.017 (gồm528 mô tả skill ởLv60/80), legacy8.051, Hero112, Python6 đạt. Unity129.040 kiểm actor/39.244 frame,324FX/1.506 mẫu,126schema,63nativevisual/11shader/8form,547responsive,32migration/36GUID,14audio,9HPbar,19SaveAllrollback đều đạt. PvP V7 thật40roster/5v5/212tick digest760456589888603090; Campaign V7/314tick digest4377234381563837632,15portal/154preview,seek/pause/x4 đạt. Cùng40digest và hai archive thật khớp khi resimulate bằng.NET, không chỉ tự so trongUnity. Console từcursor348 không thêm lỗi, groundTruth0errors. Evidence nằmD34Completion, fixture đi theoTests.
- **Xác triệu hồi:** sourceactor.lua334 dùng0s chờ khi is_summoned, normal2s. Bổ sung projectionFadeWithoutHold chỉV7 cho summon mặc địnhFade, giữHide/Remain vàV6. KiểmV6/V7clone/named template, expiry→death/fade→remove vàUnityreplay đạt; không đổi vòng đời hayrewardcombat.
- **Baseline tái lập:** giữ14fileData25Hero/hai chương trước kích hoạt trongTests/Fixtures/D34Baseline vớiSHA256. Legacytests vàdefaultimport/build đọcfixture; farmCLI mặc định vẫnResources runtime. DựngCandidate-final từbaseline tracked choData byte-identical vớiv33, versionzatod-d34-v7-3b14df41db3fe55e; không cầninputchỉnằmArtifacts. Main25vẫnchờkíchhoạt saufarm.
- **Đang điều tra chiến lược farm:** lượt v33 tới153/154, đã có đoạnGold2241 không đổi qua nhiều lần thử ởfrontier8-12. Probe vớiđội thử1sao/đồhợplệ cho thấy7-20/8-20thắngđượckhiđủlực, khôngdùngprobe thaybằngchứngfarm. Giảthuyếtbotchọnảivừa clear nhưngkhôngfarmổnđịnh; chờJSONlượtcuối đểđốichiếustage/win. Harness mới chỉnéảifarmvừathuađếnkhiminHerotăngcấp hoặcqua64trận,rồithửlại; lùivềảicũđểkiếmGold/EXP. Chạyfreshaccountseed117 bằngFarmRunner-reliable-v2,khôngresume/gánđồ/tàinguyên từlượtcũ. KhôngđổiData,phầnthưởng,giá,nângsao hoặccombatruntime. Chưagọiđườngfarmnghiệmthu.

- **Lỗi Play Mode đã tái hiện:** `MaterialPropertyBlock` tạo tại field initializer của `ZatodBattleStage` gây UnityException CreateImpl trên MonoBehaviour constructor; sau đó renderer NullReference và handler client dừng trước khi gửi operation tiếp theo, kéo theo lỗi tick sequence. Đã chuyển khởi tạo sang Awake; kiểm lại trận TCP V7 5v5 tới hết 215 tick không lệch digest. Fixture còn kiểm kiểu pulse/viền cũ trong khi HUD đã dùng FCA nguồn, đang đổi assertion sang sprite cast thực tế rồi chạy lại toàn luồng. Không sửa bộ rules/network để che lỗi render. Console lỗi cũ được giữ, evidence `console-pvp-v33-errors.json`.
- **HUD tiêu hao năng lượng:** source hp_bar.lua chỉ bật star `eff_UI_battle_skill_cost` tại các hook dạng LYC/TB/UD. Đã nối clock tick khi vào/ra đúng form, giữ marker tại mép thanh energy; không tự bật ở mọi skill cast. Metadata chỉ phục vụ trình bày, không thêm vào digest combat. UD có UnitID10022 nhưng SkillID1220, chọn theo skill để tránh nhầm mã. Đang nghiệm thu Unity bằng fixture shader/form/HUD nguồn.

- **Kiểm lại rules và buff 24/11 (Candidate-v33):** source `buff.lua.checkAddBuff` xác nhận skill thấp cấp có xác suất khống chế giảm với sàn 30%, SILR dùng lượt RNG riêng; direct BuffCreate bỏ qua bước này. Đã thêm metadata và kiểm ở skill delivery, giữ V3–V6. Holy không né phép; RNG critical V7 luôn được lấy trước forceCritical theo source. Knock dùng KnockRES và hệ số sao Titan, chỉ Stable chặn như source. Native 2.489 kiểm tra và legacy 8.051 đạt. Catalog có cờ `UseExpandedCombatRules` serialize qua Heroes.txt để cả trận starter chưa mở skill mới cũng chọn V7; bỏ suy rules từ tên ConfigVersion. Lượt farm v31 trước đó có thể dùng rules cũ ở trận đầu, vì vậy chỉ là bằng chứng tạm; chạy lại từ account mới bằng runner v33, không dùng lại tiến trình tạm.
- **BRsmallspider trùng action nguồn:** Unity import thất bại ở Dictionary.Add vì hai action `Damaged` trong FCA giống hoàn toàn (SHA256 JSON canonical `3e73f2beb41314d147ed793b5eb5bd827a4ee45516178d7eccd8e7c914c81391`). Baker giữ một bản và ghi số bản trùng trong manifest; vẫn từ chối hai action cùng tên nhưng nội dung khác. Không sửa FCA nguồn. Editor importer kiểm tên/action/sheet trùng trước khi ghi. Rebake nhện con 7 action/261 frame; nhập lại toàn sáu dependency cuối đạt, 1.755 frame unique. Bằng chứng `final-actors-import-fixed.log`, Python sáu test đạt. 34 FX bổ sung và 903 native assets/120 world prefabs nhập thành công, đang audit và kiểm Play Mode/TCP.

- **Mốc toàn bộ hook25/11:** Candidate-v30/v31 đã map104skill/312Evo của đủ26Hero encounter, cùng85skill/255Evo poolmới. V7outcome/smoke/replay đạt2.477;corecũ8.051;Python6;preflightzeroissue66Hero/42Monster/40free/154ải462wave;route359. Unity v31JsonUtility+gzip124PASS129094B. Đây là mốc code/schema, chưa activate hoặc nghiệmthu art/UI/network/farm. Lượt farm mới50.000 trận đangchạy vớiV7đầyđủ, khôngđổiphầnthưởng/tàinguyên.
- **Druid/BR và actorform:** thêm5bearformNguồn57, ghépstat/level từngcha vàcomponentvariantkhôngđổiFCA; bearlethalchuyểnbảo vệ/hồiphục, khôngchếtkhiowner sống. Bia mộ/nest/spider/gấu dùng42Monsterđầyđủdependency. NativeV7khôngápteamcap12củaV6;Count/lifetime/MP/hooksnormalnguồnvẫngiớihạnthựctế,V6giữcapcũ.26602làskillplaceholderCD/init999nhưngkhôngcóatk2trongCHA/AnimDurationvàkhôngđượchooknormalgọi;đánhdấuinert,khôngbịaclip. SummonportraitPler/DruidBearkhôngcófilevàkhôngcóthẻHUDnênđểrỗngchỉ5dependency,khônggiảmkiểmportraitHero.
- **Charm/tauntV7:** sourceunitattribsđổifoecampkhienchanted,khôngđổicampsởhữu;trướcđâychỉspecial453đổiteamxấp xỉ. ĐãsửachỉV7chọntargettheofoecampvàgiữwinning/ownershipteam; testDancerđánhnội bộ rồi hếtcharmápdebuffnguồnđãPASS. Tauntdẫntargetvềcastervàdọnkhicasterchết. DruidDOTlink dùngrawHPRnêu rõsourcevàDPSStatisticsRatio,khôngcộngnhầmAPscalingvàoheal. SourceDancerDeath2vàdurationđượcchụplạichoV7.

- **UD/CG/Mars25/11:** Candidate-v24 có88skill/264Evo native của22Hero địch, V7đạt2.392kiểmtra;8051corecũvẫnPASStrướcthayđổicharmV7. Bia mộUD nguồnđứngyênmove_speed0làhợplệ;validatorgiờchấpnhận0vàvẫnchặnâm. TombStone/SmallZombie dùngplaceholderPlerkhôngcófilevàkhôngcóthẻformation/HUD,nênđểPortraitKeyrỗngchohaiSummonnày,khôngchépHeroPortraitkhác. BaartifactUDbake894frame. CGprojectilephụ1148khôngcóAction(s),CreateShotV7chooriginmặcđịnhkhiphasesrỗng;khôngbịaattackframe. TestkiểmMarsbanđầuđợi1,75sgiảđịnhAFsớm,sourceAFthực2,0833s;đãđợiquaAFtheotimeline,khôngđổitimingruntime.
- **Puppetvariant25/11:** khảo sátmọiPuppetselectedtìm3MonsterSwitchTreant/Tauren/Shamanthaycomponenttrongsourcetable. BakertrướcdùngcùngspritesSourceResource,làmvarianthiệnảnhnormal. ĐãđặtResource dẫnxuấtriêngvàthayảnhđúngcặpcomponentkhibake,khôngsửaFCA/source. Bộ3bake710frame; nhữngcặpcảhaiđầukhôngcódrawelementtrongRecoveredFCAđượcghiAbsentDrawableComponents,đầuthiếumộtbênvẫnbáolỗi. ChưaUnityimport/visualQA.Candidate-v25Monksmoke2404PASS,đangkiểmoutcomevàDancer.

- **Pudge/LC/Tusk25/11:** Candidate-v20 thêm native hook và Evo của ba Hero này; V7 đạt2.334 kiểm tra gồm hook contact, bite heal/cleanup, rot pulse, LC10-hit charge/teamhaste và Tuskchargedcrit/snowball→uppercut; core cũ8.051 vẫn PASS sauPudge. MaxHP trước đây chỉ chụp lúc tạoUnit, buffHP có thể thayGet(health) nhưng không đổiState.MaxHp; đối chiếuunitattribs.convertAttribs xácnhận rebuild chỉ clampHP hiện tại, không tự heal. Đã cập nhậtMaxHP/clamp khiadd/refresh/removebuff vàmỗi periodic updateV7, cótest tăng/giảmHP; nhánhV3–V6khôngđổi. TBoutcome2277PASS,FX mớiTBđãbakechờUnity. ĐangportCG, chưaactivatehoặcnghiệmthuphase.

- **TB đang kiểm25/11:** Candidate-v17bổsung2mirrorMonster129/130(normaldependency,khôngliênquanNagaMirrorshard),formTBult,MirrorShader,cloneleveltheoskill472,statskếthừa,stacktheolầncast,đổimirrorkhitransformvàSunderHP. Smoke/replay66Hero/60–80vớibảnnháp64skill192Evođạt2267;chưađủoutcometests/nativeUnitynênchưađánhdấuTBnghiệmthu. Đãbake446frame/13actionTBult,chưaimport. XácnhậnPuppetTB.cha/TBult.chađềuChangeComponentstrống;TB2.cha17cặpthaycomponentkhôngđượcTBnormal/ultdùng,nênkhôngsửabakeTBnormaltheogiảthuyếtoverlap.

- **Unity/media tiếp25/11:** serializer Enabled fix đãqua124kiểmtraUnity, gồm66Hero/40preset,40trậnquaJsonUtility vàgzipReplayArchive thực; khôngcònformgiảởHero thường. ResourceauditV14hiệnchỉcòn13cueaudio khôngcófiletrongnguồn;36backgroundvàmọieffectđượcdeliverydùngđãđủ. Hai tênArachne màbakerbáothiếu chỉnằmởfieldtilekhôngđượcTrackTypeprojectile sửdụng, khônglàthamchiếuFXruntime bắtbuộc; khôngxóadatahoặcđổitênthaythế.
- **OversizedFX:** nềnDOOMcócanvas4471x3830vượtgiới hạn4096củabaker. ChỉeffectquácỡđượcresampleLanczos2048, ghiBakeScale/PixelsPerUnit đểgiữkíchthướcthếgiớivàpivot;81frame/timing/audio giữđủ,16spriteuniquetrên4sheet(10.469.163bytePNG). Actor/cácbakecũkhôngđổi. Import5FXmớiđãPASS, auditkíchthướcPPU đangchạy; khôngcoiđây làbakepixelgiốngnguyênbảnhoặcđãkiểmFPSthiếtbị. LayercảnhDOOM/Luna sửađúngaddEffectbackground/main/UI nguồnvàscale1, chờvisualQA.
- **LYC15NPC/60skill/180Evo:** Candidate-v16V7đạt2249kiểmtra,corecũ8051vẫnPASS. Skillformphải lấyattackframe từpuppetLYCb, khôngdùngtimelineLYChuman; form818có3AFthay2. ĐãthêmLevelSourceId từSubordinateTo đểskillformgiữleveltừngskillcha,khôngmởskillchachưaunlock;range/Hurt/Deathđổitheoform. Đãbake353frame/10actionLYCb, chưaimportUnityhoặckiểmGPUform.

- **Form/serializer25/11:** Unity audit phát hiện `JsonUtility` tạo object inline mặc định cho NativeForm không có trong JSON, trong khi .NET giữnull. Điều này làm validator báo `Invalid native battle form: coco_basic_attack`. Đã bổ sung `Enabled` rõ ràng, chỉ validate/copy/apply form được bật; Candidate-v14 cóPA form bật. Chờ rerun Unity, không coi core .NET PASS là đủ cho serializerUnity. PA chuyển dạng cũng phải đổi attack_range sang basic melee, nếu giữ tầm ném cũ AI có thể đứng ngoài tầm đánh; đã sửa theoPeriod/resetSkillList và thêm test.
- **Phoenix/DOOM25/11:** Phoenix qua kiểm egg6/5hit, miễn AP,1HP mỗihit vật lý/Holy, hồi sinh5s, pháeggkhôngtái sinh vàEmberđổi/khôi phục đòn thường; V12tổng2212PASS. Đangport DOOM650/652/653/654, gồm MP500gate,curse/drain/tắt lúcMP0hoặccasterchết,hitkếtliễuHP1,devourchỉSummon. Phầnbuff chọn theoMainAttrib sauDevour tiếp tục bỏtheoD05/D34, ghi rõmanifest; không tự ánhxạPrimarythànhAP. SourceNoMPGet/stealth/unmanual/doom vàgatedamageTypeADvsSilence cũng đượcđối chiếu choV7; replaycũ8051vẫnPASS.

- **Media/encounter25/11:** audit tổng Candidate-v8 phát hiện36nền trận chưa nằm trong manifest import,24cueaudio và2effect thiếuResources. Bổ sung nền chương3–8 vào manifest hashnguồn, mobileASTC6x6; `Import-ZatodD34Media.py` lấycue từ bake-manifest và chỉ chép file sound đúngstem duy nhất. ImportUnityv10PASS866asset/120prefab; chờ audit lại sau2effect mới. SyncData ban đầu chỉchép top-level bỏWorldMaps, gâyFileNotFound trongworkspace; đãchép đệquy đủmap, khôngphải lỗi authoringmap. SourceCrystal giữ nguyên. V9WD/Nana44skill132Evo đạt2173kiểmtra; cơ chếAGI/STR độngNana tiếp tục hoãn theoD05/D34 và ghi trongmanifest. Candidate-v11 thêmPA form/Evo, đang kiểm kết quả; chưaactivate/báo xong phase.

- **Tiếp25/11/2026:** Candidate-v8 có36 skill/108 Evo native của9Hero encounter (DP/Troll/LOA/WL/Panda/AM/BB/CW/TA); còn17Hero chưa port đủ. BộV7 đạt2.149 kiểm tra và core cũ8.051 đạt. Đã sửa kế thừa control theo `battle/buff.lua.effect_inclusions`: imprisonment phải kéo theo stun/untargetable/invulnerable, trước đó runtime chỉ so tên trực tiếp. Sửa chỉV7, không đổi các replayV3–V6. OD Evo3 được áp damage/MP trong createBuff trước khi attach invulnerable; test kết quả đã qua. POM chọn actor tiền tuyến trong tập va chạm cùng tick theo nguồn.
- **Native encounter mới:** WL Infernal được tạo sau impact, snapshot cấp/sao/skill phụ, stat kế thừa, thay con cũ và dọn khi chủ chết; có test replay. Panda có combo theo attack frame, lốc timer/giải buff trước lốc và burn lúc đáp; bổ sung FireShader đúng công thức nguồn. TA có lá chắn theo số lần trúng, hồi MP mỗi lớp, cộng lớp khi cast/kill, splash và trở về vị trí đầu ultimate. Test TA ban đầu kiểm sau khi actor đã tiếp tục đi và Panda kiểm ngay trong wave entry; đã chỉnh fixture kiểm đúng mốc, không thay gameplay để làm xanh.
- **Art:** auditUnity73.528 kiểm tra/619action/22.436frame,1857 mẫu actor;283effect/445clip/1335mẫu đềuPASS. Infernal229frame đã import. Bản sao Unity đang kiểmCandidate-v8; main vẫn25Hero/2chương. FarmRunner-v7 seed117/20.000 trận đang chạy với vàng/thể lực/loot thực; chưa kết luận vượtải hoặc lênTím. Chưaactivate/IPAcuốiphase. Evidence ở `Artifacts/D34Completion/expanded-combat-v8.log`, `compatibility-tactics.log`, `actors-audit-v7.json`, `actors-samples-v7.json`, `effect-audit-v7.json`.

- **Ngày:** 24/11/2026. Người dùng giao làm nốt toàn phase. Đang triển khai, chưa nghiệm thu. Đã thêm rules V7 và map 85 skill/255 mốc Evo mới trong staging; các nhánh INT transfer/MainAttrib immunity đã hoãn vẫn ghi rõ không có tác động. Passive nguồn STR/AGI/INT được quy đổi thành tỷ lệ stat trực tiếp, không tạo stat chính runtime.
- **Kiểm hiện tại:** core/catalog đóng gói cũ 8.051 assertions vẫn đạt sau thay đổi. Bản nháp 40 Hero qua 960 ca ranh giới Evo, smoke 40 Hero ở skill level 60/80 và replay V7, tổng 1.688 kiểm tra đạt. Đã kiểm riêng HP passive, hồi sinh SNK 2,5 giây, Chakra hồi năng lượng, second tap KOTL và hệ số tích lực trên projectile. Chưa thay thế kiểm chuyên sâu mỗi hook hoặc nghiệm thu runtime/thiết bị.
- **Bổ sung kiểm cùng lượt:** V7 đã đạt 1.699 kiểm tra sau khi thêm hold Birth nguồn SNK, KOTL bị ngắt tự tung phần tích lực, thứ tự trúng đòn rồi mới áp buff và vùng buff AV tồn tại/rời vùng/hết hạn. Giữ V4 trở xuống qua golden 8.051 ca. Lỗi test rời vùng ban đầu dùng X=750 còn nằm trong bán kính 150 của formation; đã sửa vị trí fixture ra ngoài chắc chắn, không đổi bán kính hoặc handler để test đạt.
- **Bản nháp nội dung v4:** validator đạt 66 Hero/34 Monster, đúng 40 Hero free PvP, 8 chương/154 ải/462 wave/9 đảo. Sáu kiểm importer Python đạt; 359 route tới interaction từ các spawn đạt với code va chạm WorldMovement thật, ô 0,5. Đã sửa BaseStats quái cần đủ sáu trường legacy dạng số nguyên, giữ PreciseStats nguồn; bổ sung stat definition còn thiếu và ngưỡng Unlock For Monster theo nguồn. Chưa thay config active hoặc nghiệm thu encounter-specific hooks.
- **Farm:** lượt provisional seed117/1.000 trận bằng thưởng thật vượt 61/154 ải, PlayerLv30, chưa đạt Tím. Bài kiểm đã mở ngân sách tối đa20.000 trận để đo đường dài, không đổi economy/runtime. Đang chạy seed117/15.000 trên v4; không coi lượt hết budget là PASS.
- **Art:** bake thêm 45 puppet/16.567 frame và khảo sát 257 effect; 31 effect mới được bake. Hai resource `eff_tile_Arachne_atk`, `eff_tile_Arachne_atk3` không có container nguyên bản trong nguồn hiện có; ghi trạng thái thiếu, không thay bằng effect gần giống. Recovery mới ghi vào Artifacts/DerivedCrystalEffects, không sửa reference. Đang import Unity trong workspace cô lập.
- **Kiểm tiếp:** core V3–V6 vẫn đạt8.051 sau clock HUD, Hurt V7 và metadata shader. Bộ V7 mới đạt2.095 ca: 66 Hero smoke/replay ở60/80, 960 boundary cho40Hero, 72mốc encounter của DP/Troll/LOA/AM/BB/CW và kiểm Hurt/RESHURT/shader. Thời lượng Hurt lấy AnimDuration.Damaged, ngăn cast/move đúng clockMSPD; thêm RNGRESHURT mặcđịnh0 theo sourceunitattribs, giữ branch cũ dướiV7.
- **Unity art:** import đầu dừng sau55/59 tạiTreant. Nguyên nhân xác nhận manifest cũ tham chiếu `Assets/Zatod/Art/Crystal/` dù PNG đãởImported; khônglàfile nguồnthiếu. Treant đãbake212frame và4bộcuốiimportPASS. Kiểm thấy101manifestderivedcùngđườngcũ; helper `Repair-ZatodBakePaths.py` kiểm ảnh/rect/name/hash rồichỉđổi path, khôngđổiPNG/metas/GUID. Importer Editor nay báoInvalidDataException rõpath trước xửlý, missing-only khôngchỉkiểmmanifestexists.
- **World/UI/audio:** Unity compilePASS0lỗi; native/world authoringPASS659assetđúnghash+120prefab (115cửaải,5varianttím). Thêm nguồnFCAready/cast/activate/fullpower/cost vàshader7loại theo.fsh, LowHPmask; clockReady/FullEnergyđi qua simulationđểseek/pause/x4 khôngdựaUTC. Code UI mới đang chờPlayMode/ảnhnghiệmthu; khôngcoi import/buildlàđãkiểmvisual. Đang importtoànbộeffectthiếu (kểcảbakeđãcó nhưngchưaResources).
- **Sai fixture đã xác nhận:** ép vị trí/cooldown sau constructor rồi so với replay từ snapshot ban đầu gây lệch digest giả. Fixture replay đã dùng đúng formation và cooldown từ snapshot; các thao tác direct-call kiểm effect được tách khỏi replay. Helper reflection đã bổ sung default arguments khi handler thêm tham số tùy chọn. Không sửa golden digest hoặc bỏ kiểm replay.
- **Nguồn encounter:** 115 ải/345 wave thêm có 26 Hero địch và 20 Monster ngoài catalog 40+14, gồm các biến thể high-ID. Đã xác nhận Hero bổ sung có hero_equip/UnitRank/fragment và animation trong source; đang nhập định nghĩa và dependency theo encounter, không tự đưa các Hero đó vào pool PvP 40. RankStats nguồn 8 dùng nội suy encounter cấp 65, không mở bậc sở hữu trên Tím.
- **Naga:** đọc toàn hook cho thấy init chỉ nối onHitMiss/update triệu hồi NagaMirror khi shard rank đủ. Nhận định khảo sát trước nói phân thân từ passive chưa phân biệt điều kiện shard. Giữ shard khóa theo D34; nền summon V6/V7 vẫn có kiểm tra riêng.
- **Importer:** bản mở rộng gặp icon placeholder x10 vắng trong nguồn. Đang kiểm trường hợp skill đòn thường vốn không có nút UI; không thay icon bằng ảnh phỏng đoán. Tài nguyên thiếu của main slot vẫn phải báo lỗi.

## REVIEW-024 — Import Hero D34 cần tách dữ liệu nguồn khỏi hook combat chưa port

- **Ngày:** 24/11/2026. Người dùng yêu cầu tiếp tục D34, ưu tiên Hero còn thiếu. Catalog active vẫn 25 Hero; nguồn tại `Unity/Assets/Crystal Legend/` có đủ animation cho 15 Hero đã duyệt. Helper cũ còn resolver root cũ và phụ thuộc mapping trong Artifacts (REVIEW-008/010), nên không chạy lại chuỗi import cũ lên Resources.
- **Xử lý:** thêm `scripts/Import-ZatodD34Heroes.py` đọc Lua bằng parser dữ liệu, lấy alias từ C# đã track và giữ nguyên các dòng config/Evo cũ. Sinh bản nháp riêng gồm 40 Hero, 160 slot, rank 1–7, 228 item, 231 skill, 94 buff và 103 recipe. Không đổi Campaign, loot, Owned hay bật free PvP. 85 skill mới/255 mốc Evo nguồn được ghi rõ chờ native hook và nghiệm thu; không đoán ý nghĩa Script Args. Manifest nguồn đi theo Git tại `docs/reference/zatod-d34-hero-import.json`; Artifacts chỉ giữ đầu ra tái tạo được.
- **Kiểm đã xong:** sáu bài kiểm Python đạt, gồm bảo toàn bảng cũ/slot/Evo, ID và đầu ra lặp lại; validator D34 chấp nhận bản nháp 40 Hero/4 slot/Tím. Core 8.051 và HeroChecks 112 đạt. Bake đủ 15 Hero, 5.657 frame. Unity art đạt 18.565 kiểm tra (FPS, duration, sprite keys/rect/pivot và Android/iOS ASTC 6x6), 486 mẫu sprite đạt; ảnh gallery đủ 15 Hero. Console cuối 0 lỗi/0 cảnh báo, Editor thử đã đóng sạch/auto-tick=false. Xcode Release ARM64 và ZIP/Info.plist/kiến trúc/chữ ký đã kiểm; xem handoff bên dưới.
- **IPA mốc art:** `/Users/bloom/Desktop/Zatod Legend/Builds/D34HeroArt/20261124-203343/ZatodLegend-D34HeroArt-unsigned.ipa`, 721.72 MiB, unsigned; Unity export cuối 0 lỗi/1 cảnh báo shader TMP cũ. Đã so 735 file native giữa hai export và 19 file Data trong app với export cuối (font khớp file tracked sau khi bỏ glyph-cache từ fixture). App/UnityFramework ARM64 iOS, Bundle ID và quyền LAN đúng, không nhúng UnityRuntime; CRC ZIP và SHA256 đạt. Catalog trong IPA vẫn 25 Hero, chưa bật bản nháp 40 hoặc nghiệm thu native combat. Chưa ký/cài/chạy iPhone. `Artifacts/D34HeroImport/handoff.json` và `/Users/bloom/Desktop/Zatod Legend/Builds/D34HeroArt/20261124-203343/ipa-verification.json`.
- **Đầu vào/trạng thái:** source reference và alias trong repository đủ tái tạo; bốn cue mới thiếu file nguyên bản đúng tên được ghi trong manifest, không thay âm gần giống. Code, asset và manifest mới đang ở working tree, chưa commit/push. Artifacts/Builds là đầu ra local bị ignore, không coi đã chuyển sang clone khác.
- **Công cụ:** lần mở Editor cô lập đầu tiên đã báo ready rồi process biến mất trước lệnh kế tiếp; không thấy crash report hoặc nguyên nhân chắc chắn trong log. Mở bằng `unity open --wait` để theo dõi toàn phiên. Lệnh recompile 60 giây hết thời gian khi Editor còn import 222 sheet; chờ import, không coi timeout là lỗi C#. JsonUtility qua helper assembly tạm không đọc được manifest; dùng Newtonsoft sẵn trong project đã nhập thành công 216 ảnh và 73 audio đúng hash. Job chuẩn bị clip được chạy sau khi recompile hoàn tất để không mất queue qua domain reload. Giữ Console và source reference nguyên trạng.

## BUG-080 — Preview và đội hình chọn sai khung khi đổi thứ tự các dòng rank

- **Ngày:** 24/11/2026. Snapshot trận đã dùng chuỗi bậc khi có rank chỉ định. Preview, Formation và các màn Hero vẫn tra khung dựa vào vị trí các dòng trong mảng rank, nên cùng bậc có thể hiện khung khác sau khi sắp xếp file.
- **Sửa:** `WaveSpawnDefinition.ResolveRank` dùng chung trong snapshot Campaign và thẻ đội địch. Các màn Hero, Formation và kết quả dùng số bậc từ `HeroCatalog.RankPath`. Replay thiếu metadata vẫn dùng nguồn dự phòng hiện có.
- **Kiểm:** `D34RankProgression` đảo thứ tự các dòng rank và đạt 32 ca Unity Play Mode. Preview Tím khớp cấp, sao và badge boss với snapshot. Formation đúng khung Xanh Dương+1, Tím và preset PvP ba sao. Kết quả replay giữ khung bậc cũ, bản save giữ 36 GUID đồ hấp thụ. Core 8.051 và HeroChecks 112 đạt. Báo cáo `Artifacts/D34Checks/rank-preview.json`.
- **Kiểm TCP:** fixture PvP V6 đi qua Formation, đấu và replay. Hai phía khớp digest sau 72 tick. Báo cáo `Artifacts/D34Checks/pvp-rank-preview/pvp-loopback.json`.

## BUG-079 — Spawn Campaign bỏ qua rank path và kỹ năng quái đã khai báo

- **Ngày:** 24/11/2026. Với Hero địch có rank chỉ định, snapshot dùng thứ tự vật lý của bảng rank và `Crystal.UnlockRank`. Rank mới thiếu dòng stat cũ cũng mất bonus. Với quái, `MonsterDefinition.SkillIds` được kiểm khi tải catalog nhưng snapshot chỉ có đòn thường.
- **Sửa:** `ZatodMatchFactory.Spawn` lấy thứ tự rank và slot mở từ chuỗi `NextRankId` khi dùng rank chỉ định. Rank dùng dòng stat encounter đã có; khi thiếu dòng đó, cộng bonus trên các bậc đã đi qua rồi áp hệ số encounter. Quái đưa `SkillIds` vào snapshot, giữ một bản đòn thường. Hỗ trợ `BaseStats` khi định nghĩa chưa khai báo `PreciseBaseStats`.
- **Kiểm:** bảy ca mới trong core xác nhận đảo thứ tự file rank vẫn giữ Blue, slot thứ tư chỉ mở ở Tím, HP Tím có đủ bonus và hệ số, quái dùng skill đúng từ snapshot và replay khớp. Cả 390 spawn đóng gói đang dùng `EstimateRank`; báo cáo seed 117 sau sửa giống báo cáo trước sửa, vượt 39 ải trong 55 trận. Core 8.051 và HeroChecks 112 đạt. Bằng chứng `Artifacts/D34Checks/campaign-authored-spawns/baseline-comparison.json`. Hero Tím và skill quái mới dùng fixture.
- **Kiểm TCP:** Campaign V5 đóng gói thắng sau 308 tick và khớp digest giữa client/server. Replay dừng, tua và phát x4 đạt. Báo cáo `Artifacts/D34Checks/campaign-authored-spawns/campaign-loopback.json`.

## BUG-078 — Số nộ lệch vị trí lúc vào wave và xác cũ còn nguồn âm

- **Ngày:** 24/11/2026. Khi có hook cấp nộ lúc đầu wave, HUD lấy vị trí mốc đứng cuối đường chạy. Actor lại có offset chạy vào sân, nên số nộ xuất hiện cách Hero. Xác từ wave trước được đặt alpha 0 nhưng vẫn có actor view và cursor âm thanh nên cue Death đến muộn vẫn có thể phát.
- **Sửa:** `ZatodBattleHud.cs` và `ZatodBattleStage.cs` dùng cùng offset vào wave cho actor và số combat gắn với actor còn sống. Stage dừng âm, tắt và hủy actor của xác từ wave trước. Actor và effect rời scene được tắt ngay trước khi Unity hoàn tất hủy cuối frame.
- **Kiểm:** Unity Play Mode xác nhận vị trí số nộ khớp actor ở đầu và giữa wave 2, rồi khớp lại sau khi tua ngược. Ca âm thanh đạt 14 kiểm tra ở x4, gồm cue Death đến sau khi chuyển wave, dọn effect và giữ BGM. Lượt gọi đầu vẫn đang vào Play Mode, đã kiểm trạng thái Editor và chạy lại. Core 8.044 và HeroChecks 112 đạt. Báo cáo `Artifacts/D34Checks/wave-presentation-position.json` và `Artifacts/D34Checks/wave-presentation-audio.json`.
- **Kiểm TCP:** Campaign V5 thắng sau 282 tick, client và server khớp digest. Kiểm đủ sáu tick vào sân ở wave 2 và 3, tua tick 75, dừng và phát x4. Báo cáo `Artifacts/D34Checks/campaign-wave-presentation/campaign-loopback.json`.

## REVIEW-023 — Bài chạy farm dừng trước mốc bậc cần nghiệm thu

- **Ngày:** 24/11/2026. Bài chạy cũ dừng sau ải cuối, nên có thể trả đã clear toàn bộ trong khi chưa đủ đồ lên Tím. Nếu ải kế tiếp đòi nhiều thể lực hơn trần hiện tại, bài chạy cũng không thử farm EXP tài khoản. Ưu tiên loot trước đây bỏ qua nguyên liệu khi kho có bất kỳ số lượng nào, kể cả thiếu cho recipe.
- **Xử lý:** `StarterFarmAudit.cs` và `StarterFarmPlaythrough.cs` nhận thư mục Data bản nháp. Bài chạy có thể nhận bậc đích, tiếp tục farm sau ải cuối và ưu tiên EXP tài khoản khi thiếu trần thể lực. Kiểm đủ lượng đồ và nguyên liệu cho các slot cần mặc. Khi có bậc đích, lệnh chỉ trả thành công nếu vượt hết ải và cả đội khởi đầu đạt bậc. Loader dùng đủ schema, ConfigVersion và MaxHeroStars như config Hero runtime.
- **Kiểm:** bảy ca đạt. Catalog đóng gói seed 117 vẫn vượt 39 ải trong 55 trận, và báo thiếu đường Tím của cả năm Hero khi yêu cầu bậc đó. Fixture hai ải đạt Tím cho năm Hero sau 12 trận, gồm ba trận farm vì trần thể lực và bảy trận sau khi clear. Kiểm thêm dừng vì hết lượt, cost vượt mọi trần thể lực và bảng Items lệch version. Core 8.044 và HeroChecks 112 đạt. Bằng chứng `Artifacts/D34Checks/farm-rank-target/`. Kết quả Tím thuộc fixture, còn nghiệm thu nội dung thực tế D34.

## BUG-077 — Chín Hero có portrait ở màn chọn đội nhưng bị trống trong HUD

- **Ngày:** 24/11/2026. HUD chỉ đọc `Zatod/UI/Portraits/`. Chín Hero `med`, `sp`, `om`, `sf`, `jugg`, `axe`, `es`, `av`, `thd` có ảnh trong `Zatod/UI/Formation/Portraits/`.
- **Sửa:** `ZatodBattleHudLayout.Portrait` ưu tiên đường HUD hiện có rồi tra thư mục Formation qua `ZatodFormationView.FindArt`. `DrawHud` dùng resolver này ở cả trận và replay.
- **Kiểm:** Unity Play Mode mở hai replay để kiểm chín portrait từ GameObject HUD. Cả chín card hiện đúng sprite. `D34ResourceAudit.Run` dùng lookup thật của HUD và StagePreview, xác nhận 25 portrait và 142 icon đồ tải được. Lượt audit đầu tra icon ở thư mục UI gốc nên báo nhầm 142 icon; dùng `ZatodStageUi.Art` loại cảnh báo giả này. Báo cáo cuối còn sáu cue thiếu clip và hai chương chưa đặt nhạc trận. Đã kiểm 146 AnimationSet, các clip, nền trận và prefab world trong catalog hiện tại. Core 8.044 và HeroChecks 112 đạt. Bằng chứng `Artifacts/D34Checks/resource-audit-final.json`.

## REVIEW-022 — Kiểm biên dịch iOS D34 và cảnh báo deployment target của IL2CPP

- **Ngày:** 24/11/2026. Unity 6000.6.2f1 xuất Xcode từ bản sao worktree hiện tại với 0 lỗi và 6 cảnh báo. Xcode 27.2 biên dịch Release cho iPhone arm64 thành công với ký mã tắt trong lệnh build. Đã kiểm app và UnityFramework bằng `lipo`, `vtool`, `otool` và `codesign`. Bundle ID `com.zatodlegend.lantest`, minimum OS 15.0, có khai báo mạng LAN. `UnityRuntime.framework` vắng trong app và hai binary chính không liên kết động tới nó. Bước native vượt các lỗi build từng ghi ở BUG-062 và BUG-063 trên bản xuất này.
- **Cảnh báo:** Xcode ghi 579 dòng cảnh báo, trong đó 536 dòng libc++ về nền tảng cũ. Lệnh clang++ của IL2CPP dùng `-mios-version-min=11.0`, trong khi project và app công bố 15.0. Header SDK iPhoneOS 27.2 phát cảnh báo khi macro min iOS thấp hơn 15.0. Giữ nguyên min OS dự án. Chưa xác nhận chạy thực tế trên iOS 15 hoặc trên thiết bị khác.
- **Bằng chứng:** 44 file Unity đã đổi hoặc thêm trong worktree khớp byte với bản sao dùng build. Core 8.044 và HeroChecks 112 đạt. Log export, log Xcode và báo cáo ở `Artifacts/D34Checks/ios-compile-20261124-sWNqtB/`. Đây là kiểm biên dịch native với catalog hiện tại. IPA D34 và nghiệm thu trên iPhone vẫn mở.

## BUG-076 — Save all có thể lưu nửa bộ config

- **Ngày:** 24/11/2026. Sau cơ chế rollback của BUG-072, GameEditor vẫn ghi các bảng Hero và Progression trước giao dịch Campaign/world. Một lỗi ghi ở đảo có thể trả lỗi nhưng để lại Hero và progression của bản nháp mới trên đĩa.
- **Sửa:** `GameEditorWindow.SaveConfig` chuẩn bị Hero, progression, Campaign, world index và từng đảo trong cùng giao dịch. `ConfigFileTransaction.cs` kiểm file cũ, sao lưu byte gốc, ghi bằng thay thế file và hoàn tác các file đã ghi nếu một lần ghi lỗi. Nếu phát hiện file bị chỉnh tiếp trong lúc hoàn tác, công cụ giữ bản chỉnh mới và báo đường dẫn backup. Mốc so sánh và trạng thái draft chỉ cập nhật sau khi ghi thành công. `Save maps` và thao tác lưu riêng bảng Hero dùng cùng cơ chế ghi.
- **Kiểm:** `D34WorldAuthoring` đạt 19 ca Unity Edit Mode. Qua `SaveConfig` thật, fixture đổi cả bốn nhóm dữ liệu rồi chặn ghi file đảo. So sánh từng byte xác nhận các bảng được khôi phục, gồm BOM của Progression và bản sao lưu. Bỏ chặn rồi thử lại với cùng draft, tải được cả bốn nhóm bằng Resources. Fixture dọn cửa sổ chưa hiển thị bằng `DestroyImmediate` để tránh lỗi từ `EditorWindow.Close`. Cấu hình của workspace kiểm đã được khôi phục. D35 GameEditor UI draft, core 8.044 và HeroChecks 112 đạt. Bằng chứng `Artifacts/D34Checks/full-config-transaction.json`.

## REVIEW-021 — Kiểm config D34 trước khi đưa vào Resources

- **Ngày:** 24/11/2026. Helper cũ ở REVIEW-008 đọc bảng alias trong artifact rồi ghi config. Khi author bậc, Hero và ải mới, có thể dùng catalog trên Git làm mốc để phát hiện đổi ID mà save đang dùng ngay từ bản nháp.
- **Xử lý:** thêm `--d34-content-preflight` trong `Tests/CrystalChecks/ContentPreflight.cs`. Lệnh đọc hai thư mục Data, chạy các validator Hero, Campaign, progression và world, so ID, thứ tự bậc và slot hiện có, rồi kiểm xung đột với alias đã track trong `ZatodContentIds.cs`. Ải mới được kiểm giới hạn năm món và tỷ lệ chia đều. Lệnh xuất số Hero, slot Tím, PvP, chương, ải, wave và world map.
- **Kiểm:** sáu ca đạt. Baseline lấy bằng Git và bản nháp thêm bậc Tím cùng một ải hợp lệ đều được chấp nhận. Bốn bản nháp lỗi bị phát hiện khi đổi ID ô trang bị, tái dùng alias cũ, chia tỷ lệ loot lệch hoặc thiếu cửa vào ải. SHA256 của các thư mục đầu vào khớp trước và sau từng lần chạy. Core 8.039 và HeroChecks 112 đạt. Bằng chứng `Artifacts/D34Checks/content-preflight.json`.

## BUG-075 — Thanh máu nổi mất chuyển động khi tua và che khiên lúc đầy máu

- **Ngày:** 24/11/2026. Renderer giữ HP trượt và thời gian hiển thị trong actor view. Tua replay hủy actor view rồi dựng lại từ HP hiện tại, làm mất đoạn trượt và thời gian chờ. Phần khiên dùng khoảng trống sau HP nên có bề rộng bằng 0 khi HP đầy. Điều kiện hiện theo khiên dương cũng giữ thanh mở tới lúc khiên mất.
- **Sửa:** dựng trạng thái thanh nổi theo tick trong `ZatodPresentationState.cs` và cho Unity đọc snapshot đó trong `ZatodBattleStage.cs`. Mất máu làm lớp HP giảm ngay. Hồi máu và lớp trượt tiến về giá trị thật theo thời gian trận. Khiên có vạch riêng và lần đổi khiên làm mới thời gian hiện của nhóm. Thanh thường ẩn sau 1,5 giây ổn định; boss hiện khi còn sống. Trạng thái trình bày nằm ngoài digest trận.
- **Kiểm:** core 8.039 và HeroChecks 112 đạt. Unity Play Mode đạt 9 kiểm tra với màn replay thật và một trận cấu hình trong bộ nhớ. So sánh đúng bề rộng HP, lớp trượt và khiên trước/sau tua, xác nhận khiên hiện lúc đầy máu, tự ẩn khi ổn định và nhóm hiện lại khi khiên hết. Lượt đầu của test đọc nhầm actor cũ vì Unity hủy GameObject cuối frame. Fixture đã chờ actor cũ bị hủy rồi mới đọc đối tượng mới. Bằng chứng `Artifacts/D34Checks/health-bars-replay.json`.
- **Kiểm TCP:** Campaign thắng sau 270 tick với digest client/server khớp. Replay tua tới tick 75, dừng và phát x4. PvP V6 kết thúc 72 tick, hai phía thấy triệu hồi và khớp digest với archive. Bằng chứng `Artifacts/D34Checks/campaign-health-bars/campaign-loopback.json` và `Artifacts/D34Checks/pvp-health-bars/pvp-loopback.json`.

## BUG-074 — Khác danh sách Hero PvP vẫn vào được hàng chờ

- **Ngày:** 24/11/2026. Khi client thiếu một Hero trong danh sách PvP miễn phí do server công bố, màn đội hình trước đây vẫn cho chọn các Hero có trong bản cài. Yêu cầu vào hàng chờ chỉ gửi đội đã chọn, nên server có thể ghép client này với đối thủ dùng Hero mà client thiếu.
- **Sửa:** `FreePvpRoster.cs` tạo khóa từ `ConfigVersion` và danh sách ID đã sắp xếp. Server công bố khóa khi bật roster miễn phí và xác thực lại khi nhận yêu cầu xếp hàng. `ZatodConnection.cs`, `ZatodServer.cs` và các màn đội hình chặn vào trận khi hai khóa lệch, giữ đội hình đã lưu và báo cần dùng bản cài khớp nhau. Khóa kiểm phiên bản và danh sách Hero. PvP dùng Hero sở hữu, Arena và Campaign giữ đường chọn đội hiện hành.
- **Kiểm:** core 8.028 và HeroChecks 112 đạt. `D34PvpLoopback` qua hai socket TCP xác nhận client thiếu một Hero dù cùng `ConfigVersion` bị chặn cả ở nút vào trận và API client. Server từ chối yêu cầu gửi trực tiếp với khóa cũ hoặc thiếu khóa. Hai bản khớp danh sách chơi hết 72 tick và khớp digest client/server/archive ở V4 và V6. Bằng chứng `Artifacts/D34Checks/pvp-roster-compatibility/` và `Artifacts/D34Checks/pvp-roster-compatibility-v4/`. Hai Hero miễn phí được bật trong catalog thử.

## BUG-073 — Trạng thái hàng chờ PvP lệch giữa client và server

- **Ngày:** 24/11/2026. Client hạ `FindingPvp` khi nhận mọi lỗi, kể cả server vẫn giữ người chơi trong hàng chờ. Server cũng có thể nhận yêu cầu vào PvP khi một trận Campaign còn mở. Lỗi dựng trận sau khi ghép trước đây chỉ trả về người thứ hai đã gửi yêu cầu.
- **Sửa:** server lưu đội đã hợp lệ khi nhận lượt chờ, gửi trạng thái chờ thật kèm lỗi và từ chối queue khi Campaign chưa có kết quả hoặc chưa hủy. Nếu không dựng được trận, server dọn cả hai lượt chờ và báo lỗi cho cả hai người. Client dùng trạng thái từ phản hồi để giữ giao diện chờ đúng và cho phép thử lại. Files `ZatodServer.cs`, `ZatodConnection.cs`, `ZatodProtocol.cs`, `ZatodPlayerSession.cs`.
- **Kiểm:** `D34PvpLoopback` qua TCP kiểm ID ngoài roster, chặn mode, hủy, reconnect và lỗi tạo trận do rank thử không hợp lệ. Sau lỗi hai bên ghép lại, kết thúc 72 tick với digest khớp client/server/archive ở cả V4 và V6. HeroDesk giữ nguyên, Arena/Campaign dùng Hero sở hữu. Core 8.025 và HeroChecks 112 đạt. Evidence `Artifacts/D34Checks/pvp-queue-recovery/` và `Artifacts/D34Checks/pvp-queue-recovery-v4/`. Console có cảnh báo từ yêu cầu bị từ chối có chủ đích, reconnect Mirror và glyph TMP.

## BUG-072 — Map và Campaign có thể lưu lệch nhau

- **Ngày:** 24/11/2026. `WorldCatalog` trước đây kiểm target tồn tại, nhưng không kiểm ải có đủ cửa vào ở đúng đảo hoặc có đường portal đi và về Town. Nút Save maps kiểm bằng Campaign draft rồi chỉ ghi world, có thể tạo config runtime thiếu ải vừa tham chiếu. Save all ghi Campaign trước world mà không có rollback chung cho hai bộ file.
- **Sửa:** `WorldDefinitions.cs` kiểm spawn `town/entry`, map của chương, đúng một cửa vào cho mỗi ải, đích portal và đường hai chiều giữa Town và đảo chương. GameEditor thêm thao tác gắn file đảo vào bản nháp. Save maps kiểm với Campaign đã lưu. Save all sao lưu và ghi Campaign, index và file đảo thành một nhóm, khôi phục file đã ghi nếu gặp lỗi.
- **Kiểm:** core 8.025 và HeroChecks 112 đạt. Fixture 8 chương/154 ải/462 wave giữ đường mở ải theo phiên và từ chối 7 cấu hình sai. Unity Edit Mode đạt 11 kiểm tra, gồm cố ý làm thư mục đảo chỉ đọc để gây lỗi giữa lần lưu, kiểm rollback, tải từ Resources và khôi phục file thử đúng byte. Bằng chứng `Artifacts/D34Checks/world-authoring.json`. Sáu đảo mới chỉ có trong fixture.

## BUG-071 — Cue combat mất đường dẫn và còn phát khi dừng replay

- **Ngày:** 24/11/2026. Kiểm kê 148 cue trong AnimationSet tìm thấy 51 cue trỏ `Crystal/Audio/`. Trong số đó có 48 cue có clip dưới `Zatod/Audio/`. Hàm phát trước đó dùng đường dẫn cũ nguyên văn. Âm cue dùng chung một nguồn nên khó dừng riêng khi một cast bị ngắt. Pause trước đó chỉ điều khiển nhạc nền và seek cuối trận có thể phát cue kết quả.
- **Sửa:** quy đổi prefix khi tải, gộp cue trùng đường dẫn trong mỗi lần vẽ. Cue của nhân vật có nguồn riêng để dừng tại mốc ngắt cast hoặc chết từ snapshot. Pause/resume điều khiển nhạc, cue, âm rương và âm kết quả. Tua đọc mốc cue trên snapshot và kết quả mở khi pause giữ im. Chuyển wave dừng cue cũ, rời trận dọn âm trước khi unload. `ZatodBattleStage.cs`, `ZatodBattleLootView.cs`, `ZatodBattleResultView.cs`, `ZatodBattleResultPresenter.cs`, `ZatodBattleSceneController.cs`, `ZatodBattleSimulation.cs`, `ZatodSkillEffects.cs`.
- **Kiểm:** core 8.014, HeroChecks 112 đạt. Unity 6000.6.2f1 Play Mode đạt 13 kiểm tra với clip thật có sẵn và snapshot thử, gồm pause/resume ở tốc độ x4, ngắt và chết, chuyển wave, tua và kết quả. `Tests/Unity/D34BattleAudio.cs` đợi bộ âm thanh cập nhật rồi mới đọc `isPlaying`. Bằng chứng `Artifacts/D34Checks/battle-audio.json`. Sáu cue chưa có clip và hai chương hiện chưa cấu hình nhạc trận. Chưa nghe kiểm trên iPhone/Android.
- **Kiểm TCP:** lượt đầu mở scene trống nên fixture không tìm thấy controller. Đã thêm kiểm scene vào `D34CampaignLoopback.Arm` trước khi ghi trạng thái `RUNNING`. Lượt đúng scene thắng sau 304 tick, client và server cùng digest, seek tick 75, pause và x4 đạt. Sau ngắt kết nối đã về World và unload scene trận. Console 0 lỗi, 1 cảnh báo TMP thiếu glyph ellipsis từ `InventoryRegular`. Bằng chứng trong `Artifacts/D34Checks/campaign-audio-final/`.

## BUG-070 — Bậc mới làm lỗi màn Hero và kết quả replay đọc bậc hiện tại

- **Ngày:** 24/11/2026. Đã sửa và kiểm trong Unity Play Mode bằng catalog thử có đường Xanh Dương → Xanh Dương+1 → Xanh Dương+2 → Tím.
- **Nguyên nhân:** màn Base/Skill gọi tải sprite bắt buộc theo số thứ tự bậc, trong khi chỉ có bốn nền tên. Fixture xác nhận mất sprite `hero_rank_5` làm dừng refresh. Màn kết quả đọc bậc và sao từ HeroDesk, nên kết quả trận cũ có thể hiển thị bậc đã nâng sau trận và preset không sở hữu có thể hiện sai sao.
- **Sửa:** `ZatodHeroUi.cs`, `ZatodHeroDetailView.cs`, `ZatodHeroSkillPanel.cs` và `ZatodBattleHud.cs` dùng chung màu theo bậc. Nền tên riêng là tài nguyên tùy chọn, dùng nền sẵn có và màu bậc khi thiếu. `ZatodBattleResultView.cs` đọc bậc và sao từ dữ liệu trận, dùng HeroDesk dự phòng cho replay lịch sử thiếu metadata.
- **Kiểm:** Unity compile và console có 0 lỗi/0 cảnh báo. Fixture `Tests/Unity/D34RankProgression.cs` đạt 28 kiểm tra, giữ 36 GUID hấp thụ và các level skill cũ, chỉ mở slot thứ tư khi lên Tím. Trận ghi lúc Xanh Dương vẫn hiện khung Xanh Dương sau khi Hero lên Tím. Kết quả dùng dữ liệu preset không sở hữu hiện đúng khung Tím và ba sao. Core 8.013 và HeroChecks 112 đạt. Bằng chứng `Artifacts/D34Checks/rank-progression.json`.

## BUG-067 — HUD báo sẵn sàng ultimate khi skill chưa thể dùng

- **Ngày:** 24/11/2026. Đã kiểm core và hành vi actor pointer trong Unity Editor. Kiểm portrait trên thiết bị còn mở.
- **Nguyên nhân:** portrait và collider chỉ xem Hero sống và đầy nộ. Chúng không xét target trong tầm, khống chế, startup hoặc input đang chờ. Rank và sao portrait đọc HeroDesk tại thời điểm xem.
- **Sửa:** chiếu khả năng dùng ultimate và metadata vào snapshot hiển thị. Bên client giữ trạng thái input realtime đến khi nhận tick. Core vẫn nhận và xử lý input archive theo rules đã ghi.
- **Kiểm:** fixture đầy nộ nhưng target ngoài tầm, input chờ, startup và release. Bộ replay V3/V4 giữ kết quả. Files `ZatodBattleSimulation.cs`, `ZatodPresentationState.cs`, `ZatodConnection.cs`, `ZatodBattleStage.cs`, `ZatodBattleHud.cs`. Nếu tái diễn, phân biệt điều kiện core với input chờ ở client.
- **Kiểm thêm qua TCP:** client Unity có 6 lần chặn bấm trùng khi input còn chờ. Trận thử ghi 6 ultimate input phía trái và 5 phía phải. Hai phía, server, archive và replay mô phỏng lại khớp digest. Bằng chứng ở `Artifacts/D34Checks/pvp-final/pvp-loopback.json`.
- **Bổ sung 24/11:** thao tác tay từ portrait và actor dùng chung kiểm tra đội, tầm, trạng thái khóa và input chờ ngay lúc bấm. Trước đó đường Campaign gọi thẳng hàm xếp input. HUD dùng viền hiện có để báo nhịp sẵn sàng, báo chờ sau khi nhận thao tác và đổi màu tại tick tung chiêu. Replay dùng tick trận cho hiệu ứng. Core đạt 8.044 ca, thêm silence, stun, hết khống chế và kiểm đội. Qua TCP, nút portrait thật chặn 6 yêu cầu lặp mỗi lượt V4/V6, xác nhận hiệu ứng tại tick 5 và tái hiện khi tua. Hai lượt khớp digest sau 72 tick. HUD đạt 547 ca layout, gồm vùng viền và kiểm viền để tap đi qua. Bằng chứng `Artifacts/D34Checks/pvp-portrait-ultimate[-v4]/` và `Artifacts/D34Checks/hud-portrait-ultimate.json`. Art cuối và kiểm trên thiết bị vẫn mở.

## BUG-068 — Nút replay giữ nhãn của trạng thái trước khi tua

- **Ngày:** 24/11/2026. Đã sửa và kiểm lại qua trận Campaign TCP trong Unity Editor.
- **Nguyên nhân:** `Seek` dừng playback bằng cách gán biến trực tiếp, trong khi nhãn nút chỉ đổi qua callback của nút. `Seek` cũng giữ thời gian lẻ còn lại trước điểm tua.
- **Sửa:** cùng một hàm cập nhật trạng thái và nhãn khi mở, tua hoặc phát replay. Khi tua, đặt lại thời gian lẻ để lần phát tiếp theo bắt đầu tại tick người chơi chọn.
- **Kiểm:** mở replay từ màn kết quả, tua tới tick bắt đầu wave, đặt về 0 thời gian lẻ và hiện “Phát”. Replay đứng đúng tick khi dừng, cập nhật nhãn khi phát và chạy tiếp ở x4. Unity compile 0 lỗi. Bằng chứng ở `Artifacts/D34Checks/final-replay-control/campaign-loopback.json`.

## BUG-069 — Fixture HUD treo Editor khi xóa kích thước tạm

- **Ngày:** 24/11/2026. Fixture ghi 422 kiểm tra đạt trước bước dọn dẹp. CLI `script run` hết thời gian chờ, Pipeline mất kết nối và process Editor cô lập tiếp tục chạy. Đã đóng đúng process thử và giữ backup scene trong `Assets/_Recovery` của bản sao. Lần mở lại kết thúc trước khi Pipeline sẵn sàng. Ổ còn 983 MiB lúc kiểm, chưa xác nhận nguyên nhân lần mở lại thất bại.
- **Nguyên nhân bước dọn:** gọi `RemoveCustomSize` với index tương đối của danh sách custom, trong khi API nhận index trên danh sách toàn bộ kích thước. Số phần tử không giảm và vòng lặp không có giới hạn.
- **Sửa fixture:** dùng index toàn bộ, lặp hữu hạn theo số kích thước mới và kiểm khôi phục số lượng. Chỉ ghi PASS cuối sau khi dọn xong. Bản sửa ở `Tests/Unity/D34HudResponsive.cs`, chưa chạy lại được. Bằng chứng lần đầu ở `Artifacts/D34Checks/hud-responsive.json`.
- **Kiểm thêm:** bản sửa biên dịch được bằng Roslyn với assemblies của Unity 6000.6.2f1. Đọc assembly Editor cùng bản xác nhận `RemoveCustomSize(int)` gọi `TotalIndexToCustomIndex` trước khi xóa. Bằng chứng ở `Artifacts/D34Checks/resume/gameview-index.txt`. Kiểm chạy lại trong Play Mode vẫn mở.
- **Kiểm cuối 24/11/2026:** mở lại bản sao thành công, chạy fixture 422 kiểm tra đạt. Kết quả `RestoredGameView=true`, số kích thước tùy chỉnh trở về ban đầu. Không có lỗi console trong lượt kiểm cuối. `Artifacts/D34Checks/hud-responsive-final.json`.

## REVIEW-017 — D34 và tương thích nhịp vào wave

- **Ngày:** 24/11/2026. Đã thêm rules V5 cho Campaign. Không dùng timer Unity để kéo dài/phát lại logic trận. Trong 6 tick vào wave, không xử lý tác động hay trừ thời gian wave. Trận Arena/PvP dùng V4.
- **Bằng chứng:** core kiểm V5 bắt đầu combat sau khoảng vào wave, V4 không có khoảng chờ và V5 phát lại cùng digest. Fixture V4 sinh bằng runtime Git `871fa5b2c`, có Evo thay đổi kết quả trận. `ZatodBattleSimulation.cs`, `ZatodMatchDefinition.cs`, `Tests/CrystalChecks/Fixtures/replays-v4`.
- **Build:** chưa tạo IPA D34. Ổ hệ thống còn khoảng 4,2 GiB ở preflight, bản sao Unity vẫn compile được. Đo lại trước khi export/build native. Bản iOS mới cần server tạo rules V5 để dùng nhịp vào wave mới.

## REVIEW-018 — Nguồn trang bị cho năm Hero đầu ở catalog hai chương

- **Ngày:** 24/11/2026. Đã kiểm catalog hiện tại qua loot Campaign có xác suất dương, điều kiện mở ải và các nhánh ghép. Đủ nguồn cho 30/30 ô Trắng. Coco và Zeus mỗi Hero thiếu một món ở Xanh Lá. Cả năm Hero đều chỉ có nguồn cho 3/6 ô Xanh Lá+1. Tổng cộng có 27 loại trang bị trong các ô đã khai báo chưa có đường qua Campaign và crafting.
- **Bằng chứng:** `Tests/CrystalChecks/StarterFarmAudit.cs` đọc catalog và xuất `Artifacts/D34Checks/farm/starter-farm-baseline.json`. Đối chiếu bằng cách mở từng mốc ải và lặp tập đồ ghép tới khi không còn thay đổi cho cùng kết quả ở 120 ô. Bảng mốc và lệnh chạy nằm trong báo cáo D34.
- **Giới hạn:** kiểm tra cấu hình giả định thắng và lặp được mọi ải cần thiết, đủ cấp, vàng và thể lực. Cần gắn trang bị/nguyên liệu với nội dung D34 rồi kiểm đường chơi từ account mới. Tất cả loot, recipe và độ khó runtime giữ nguyên ở lượt này.

## REVIEW-020 — Đường chơi và farm hai chương từ account mới

- **Ngày:** 24/11/2026. `StarterFarmPlaythrough.cs` chạy năm Hero khởi đầu qua mô phỏng Campaign và xác thực replay, thưởng, kho, crafting, nâng skill và Promote. Dùng mẫu ngẫu nhiên xác định trong cùng thuật toán loot và đồng hồ giả lập để kiểm hồi thể lực. Giữ catalog, loot và balance runtime.
- **Kết quả:** cả ba seed vượt 39 ải trong 47–55 trận, gồm 6–12 trận farm. Lần thua đầu gặp ở 1-9, 2-14 hoặc 2-20 tùy seed. Cả ba tài khoản kết thúc ở cấp 8–9, Hero cấp 10–11. Bậc cao nhất đạt được là Xanh Lá+1. Hao 272–310 thể lực và đợi hồi tương đương 5 giờ 16 phút đến 7 giờ 42 phút trong mô phỏng.
- **Kiểm:** chạy lại sáu lượt giữ kết quả theo seed. Đối chiếu độc lập 153 lần thử với config các ải, EXP/cap, vàng, thể lực và loot. Core 8.013, HeroChecks 112 đạt. Bằng chứng `Artifacts/D34Checks/farm/starter-playthrough-{117,2026,3408}.json`. Cần lặp trên catalog mở rộng để kiểm đường tự nhiên tới Tím.

## REVIEW-019 — Cơ chế triệu hồi và phân thân trong combat D34

- **Ngày:** 24/11/2026. Core trước đó chỉ tạo đơn vị từ đội hình đầu trận và khi vào wave. Đã thêm cấu hình triệu hồi theo skill, resolve ở mốc release và chụp Monster template trong snapshot. Phân thân dùng đòn thường, giới hạn số lượng và sống theo tick. Đơn vị bị dọn khi hết hạn, người thi triển chết hoặc chuyển wave.
- **Kiểm:** core 8.003 ca và HeroChecks 112 đạt. Replay V6 roundtrip giữ digest và thống kê. Fixture V4/V5 không chạy hook mới. GameEditor, HUD, network và core biên dịch offline với assemblies Unity 6000.6.2f1. Chưa nghiệm thu Play Mode với đơn vị triệu hồi.
- **Kiểm tiếp 24/11/2026:** Unity Play Mode xác nhận sprite của cả phân thân và quái theo template, xuất hiện tick 4, hết hạn tick 12. Snapshot và replay qua `JsonUtility` đạt. Trận PvP V6 thử 72 tick với hai TCP peer cùng quan sát đơn vị, khớp digest và archive. Bằng chứng `Artifacts/D34Checks/summons-presentation.json` và `Artifacts/D34Checks/pvp-summons-v6-final/pvp-loopback.json`.
- **SkillEvo 24/11/2026:** `SkillEvolutionDefinitions.cs` áp dụng và kiểm giới hạn của tham số triệu hồi sau mỗi mốc mở khóa. `SkillDescription.cs` hiển thị cùng giá trị hiệu lực với mô phỏng V6. Core đạt 8.013 kiểm tra và HeroChecks đạt 112. Unity Play Mode xác nhận skill cấp 60 gọi hai đơn vị ở tick 4, hết hạn ở tick 12 và giữ digest qua snapshot/replay cho cả hai kiểu triệu hồi. Bằng chứng `Artifacts/D34Checks/summon-evolution-presentation.json`.
- **File:** `ZatodBattleSummons.cs`, `ZatodMatchDefinition.cs`, `ZatodBattleSimulation.cs`, `ZatodDefinitions.cs`, `HeroCatalog.cs`, `GameEditorWindow.cs`. Log biên dịch tại `Artifacts/D34Checks/summons-compile/`.

## BUG-066 — Tab Skill lệch bố cục ảnh tham chiếu

- **Ngày:** 24/11/2026. **Trạng thái:** đã sửa, kiểm trong Unity; chưa kiểm thiết bị.
- **Triệu chứng/nguyên nhân:** tab vẫn giữ cột illustration của Base, đặt skill thành hàng ngang trên mô tả; chưa có Hero idle giữa bốn vị trí skill, Intro/Details. Chọn nhầm sprite viền chữ nhật và nút có chữ Trung Quốc nằm trong texture.
- **Sửa:** Skill chiếm toàn thân panel, tách trái/phải theo ref, Hero idle và bốn vị trí skill, badge Evo/khóa, viền tròn chọn, Intro/Details dùng bản dịch nguồn và cùng resolver level, mô tả cuộn, footer vàng/Lvl Up. Dùng đúng sprite Crystal không có chữ nhúng; Purple chỉ khóa hiển thị, không thêm tiến trình/config combat.
- **File:** ZatodHeroSkillPanel.cs, ZatodHeroDetailView.cs, ZatodSkillUiAssets.cs, scripts/Import-ZatodSkillUi.py, Resources/Zatod/UI/Hero/Skills, Tests/Unity/D35EditorChecks.cs.
- **Kiểm:** Unity compile PASS; 25 Hero Intro/Details/Base/locked Purple PASS; 125 kiểm bounds/text/state ở 16:9, 19.5:9, 20:9, 4:3 + safe area; đã xem ảnh thực tế. Core PASS7.970/HeroChecks112. Evidence local: Artifacts/D35BuildWorkspace/Evidence/UI. Khôi phục bản trước chỉnh UI từ Artifacts/D35UiRestore; baseline D35 ở3d774252d.
- **Lưu ý công cụ:** gọi nhầm `console read` ghi một lỗi Pipeline; lệnh đúng `console get --since`. Không có lỗi C#/runtime mới trong UI; không xóa Console. Unity export có7 warning, không có lỗi.

## BUG-065 — Mô tả Skill/Evo bị cắt ngang trên màn hẹp

- **Ngày:** 24/11/2026. **Trạng thái:** đã kiểm lại trong Unity sau sửa bố cục BUG-066.
- **Triệu chứng:** ảnh GameView D35 tại 16:9/4:3 cắt cuối mô tả skill/Evo; kiểm RectTransform vẫn qua nên không đủ để phát hiện.
- **Nguyên nhân xác nhận:** Text helper dùng chế độ không xuống dòng; SkillPanel kế thừa cho mô tả dài trong viewport cuộn dọc.
- **Sửa:** bật `TextWrappingModes.Normal` riêng cho mô tả và đoạn Evo; tính lại chiều cao bằng preferred size, giữ ScrollRect.
- **File:** `Unity/Assets/Zatod/Presentation/ZatodHeroSkillPanel.cs`, `Tests/Unity/D35EditorChecks.cs`.
- **Kiểm:** đã chụp/xem ảnh 4 tỷ lệ và safe area; text xuống dòng, nội dung vượt viewport cuộn dọc. 125 kiểm bounds/text/state PASS. Chưa kiểm iPhone vật lý.

## REVIEW-014 — Preflight D35 và dữ liệu kiểm chứng chưa đi cùng clone

- **Kiểm lại checkoutWindows24/11 saupullD35:** code `0085e337c`, HEAD `5a6ab40ec`. Oraclelocal trướccheck chỉ384case/16Hero, fullsuite5846PASS; đãgiữ2fixturegốc tạiArtifacts/ZatodD35PullReview/BeforeFixtures rồichạyhelperđãtrack `python -B -X utf8 scripts/Prepare-ZatodCheckFixtures.py`, tạo600sourcecase/323alias màkhôngđổi configgame. Fullsuite7973PASS, D35riêng745/Hero112PASS; thêm3assertions soMac7970 là3archivenetwork19/11local ngoài25goldensV3. Đây xácnhận khôngcầncopyArtifacts cũ làmđầuvào duy nhất; helpercũChapterTwo/CrystalConfig chưađượcthửchạy hoặc sửaresolver.
- **Giới hạnlượtkiểm:** khôngchạyUnity/UI/network/thiếtbị/build, khôngsửaC#/configgame/save/scene/asset. ReportD35 ghiUI/Editor/nativeIPA đãquaởMac nhưng chưatestthiếtbị; JSONcoverage/checkbox còntrạngtháilịch sử cầnđốichiếumốcmới. ReviewD34 mục7 ghibaseline25Hero/75skill/225Evo/66buff, slotTímchỉUIkhóa vàrủirotươngthíchV4 khimởrộngrules; chưacoi75skillđãbaophủ40Hero/Tím.

- **Ngày:** 24/11/2026. **Trạng thái:** đang xử lý đầu vào kiểm chứng, chưa đánh dấu D35 hoàn tất.
- **Bằng chứng:** baseline HeroChecks PASS112; CrystalChecks compile được nhưng dừng tại ImportedData với DirectoryNotFoundException cho `Artifacts/CrystalPhaseChecks/stat-oracle.json`. Test CanonicalContent còn đọc `zatod-id-mapping.json` trong cùng thư mục bị Git ignore. Đây là thiếu fixture của clone, không phải lỗi gameplay đã tái hiện.
- **Hướng xử lý đang thực hiện:** tạo lại dữ liệu kiểm chứng từ Lua/cấu hình nguồn bằng helper chỉ sinh fixture, không chạy importer cũ làm đổi config/Owned. Giữ test đối chiếu stats; không bỏ qua để báo PASS. Source reference tại Unity/Assets/Crystal Legend đã có, nhưng helper còn resolver root cũ và có nhánh đọc ZIP vắng mặt; rà trước khi chạy.
- **File liên quan:** Tests/CrystalChecks/Program.cs, scripts/Import-CrystalConfig.py, docs/zatod-skill-promote-phase-plan.md. Lệnh triển khai và đầu ra IPA được ghi tại D35/D37; chưa build ở bước preflight.
- **Cập nhật kiểm tra:** helper `Prepare-ZatodCheckFixtures.py` đã tạo 600 ca stat từ Lua và mapping ID. Thư mục replay network 19/11 cũng không có trong clone; giữ kiểm tra archive này khi có, đồng thời thêm 25 replay goldens có provenance từ code Git `3d774252d`, không tạo bằng simulation mới. Core đầy đủ PASS7.255 assertions sau transaction và bước nối runtime Evo; các test Evo chi tiết đang bổ sung, chưa phải nghiệm thu D35.

## REVIEW-015 — Import kho reverse trong UnityAssets gây áp lực dung lượng

- **Tái diễn Windows 24/11/2026 — kiểm Git theo yêu cầu người dùng:** `git status --porcelain=v1 -uall -z` ghi nhận100.037untracked:100.032file `.meta`,2Markdown và3PNG bàn giao D38; thêm6tracked Markdown đang sửa. Trong100.032meta có100.031dưới `Unity/Assets/Crystal Legend/` và1file `Unity/Assets/Crystal Legend.meta`. Tổng kích thước100.031meta trong reference270.561.560byte (~258MiB), mtime quan sát15:19–16:52 ngày24/11 theo Windows local. Các con số là snapshot lúc kiểm, Editor đang chạy có thể tiếp tục sinh file.
- **Nguyên nhân xác nhận:** kho reference raw ở trongUnityAssets theoD04, EditorInstance của project làPID6044/Unity6000.6.2f1 đang mở; mẫumeta có `fileFormatVersion`,GUID vàDefaultImporter doUnity tạo. Gitignore chỉ có `/Crystal Legend/` root cũ và các ngoại lệ archive/diagnostic, chưa ignore metadata dưới reference mới. `git ls-files` cho meta của reference trả rỗng; đây làfileuntracked, không phải100kfilegameplay mới hoặc thay đổisourceRaw đãtrack. Không dùng lần kiểm này để khẳng định cacheLibrary chiếm thêm bao nhiêu.
- **Xử lý tại lượt kiểm:** chỉ kiểm status/phân nhóm/stat/mẫumeta/process và ghi nhận tái diễn; chưa xóa `.meta`, đóngEditor, di chuyển reference, đổiGitignore hoặc stage/commit/push. Phương án đề xuất tiếp theo là ignore riêng metadata tựsinh của kho reference (kèmmeta root), giữ source/art vàmetadata củaassetgame đãimport. Nếu chỉxóa khiEditorcònquét thìUnitycóthểsinh lại; việcẩnGitkhônggiảmchi phínạp/import/cache, khôngtựthay vịtríD04.

- **Kiểm tiếp 24/11:** Editor build Mac development phục vụ fixture thoát giữa build; ổ còn 1,9 GiB, Temp của đúng workspace kiểm thử chiếm 7,3 GiB. Log chưa xác nhận crash do disk nên đây chỉ là điều kiện quan sát. Đã dọn riêng Temp sinh từ lượt lỗi khi không còn Editor; giữ Assets, reference, Owned, build cũ. Chuyển fixture sang TCP loopback trong cùng Editor, rồi xuất iOS trực tiếp để tránh thêm bản Mac trung gian.

- **Tiếp tục theo yêu cầu build24/11:** giữ nguyên reference; tạo bản sao APFS riêng ở `Artifacts/D35BuildWorkspace/Unity` gồm game Assets, Packages và ProjectSettings, loại raw Crystal khỏi bản sao kiểm/build. Khi cả hai Editor đều đóng, chỉ xóa 5 cache import tái tạo được (`Library/DataStore`, ArtifactDB/lock, SourceAssetDB/lock) của project chính; giữ PackageCache, thiết lập Editor, restore point, Owned và build cũ. Ổ tăng từ3,3GB lên24GB. Helper art nhận `ZATOD_CRYSTAL_REFERENCE` trỏ read-only về source gốc. Đây là bản sao build, không phải di chuyển reference; kiểm tra UI/network/IPA đang tiếp tục.
- **Cập nhật mới nhất24/11:** người dùng hủy phương án chuyển ngay sau khi lệnh git mv hoàn tất. Đã git mv ngược đủ 96.077 file từ `Reference/Crystal Legend` về `Unity/Assets/Crystal Legend`, đối chiếu inode/kích thước/mtime với inventory trước chuyển; staged và working diff của reference đều bằng0. Không sửa đường dẫn/Gitignore, không xóa cache trong lượt này. Evidence: `Artifacts/D35ReferenceMove/cancelled-and-restored.json`. Giữ nguyên code D35; không mở lại Editor khi dung lượng vẫn thiếu.
- **Ngày:** 24/11/2026. **Trạng thái:** đang xử lý; đã hỏi người dùng về việc chuyển reference ra ngoài Assets, chưa được tự coi là đồng ý.
- **Quan sát xác nhận:** lần mở Unity6000.6.2f1 sau pull tạo khoảng100.000 meta cho kho Crystal và tăng cache import; ổ còn15GB xuống5,1GB. Không phải source bị mất. CLI open trả thành công nhưng Editor khởi động cần giữ tiến trình `--wait`; compile giữa lúc đang viết overload gây SafeMode, sau hoàn thiện core đã PASS và Editor bắt đầu import.
- **Bảo toàn:** chưa chuyển/xóa reference, chưa sửa Gitignore. `unity close --if-saved` từ chối vì import khiến không kiểm được trạng thái save. Đã tạm suspend đúng Editor/import process của lượt này (PID40720 và các worker), không kill hoặc đóng server chính. Cần resume có kiểm soát sau khi có phương án dung lượng; không để editor bị suspend khi bàn giao cuối.
- **Liên quan:** phase-plan mục1.8, `Unity/Assets/Crystal Legend`, cache UnityLibrary, log ngoài project `/Users/bloom/Desktop/Zatod-Unity-D35.log`. Tiếp tục code và .NET test độc lập; UI/build chưa kiểm chứng.
- **Trạng thái cuối lượt thực thi độc lập:** đã đóng đúng Editor/import tree do agent mở bằng SIGTERM rồi resume để tiến trình thoát; không còn process bị suspend. Đã backup nguyên văn rồi xóa đúng 100.004 `.meta` mới/untracked trong kho reference, không xóa source. Backup: `Artifacts/D35Assets/generated-reference-metadata.json`. Git diff tracked của reference bằng 0; Library và các bản build cũ giữ nguyên. Còn khoảng 5 GB, chờ người dùng chọn phương án; chưa build IPA.

## REVIEW-016 — Dependency combat và art cần bổ sung cho Evo D35

- **Ngày:** 24/11/2026. **Trạng thái:** core đã kiểm; Editor, UI, network và IPA chưa nghiệm thu.
- **Nguyên nhân đã đối chiếu:** model cũ refresh buff cùng ID dù source `unit.addBuff` giữ nhiều instance khi không Stack-and-Refresh; làm SF không cộng dồn soul. Shield generic bỏ qua loại `shallowGrave` của SP; Fear chỉ khóa hành động mà chưa đi ngược hướng. Pugna channel cần gỡ control/debuff theo `unit.addBuff`. Đây là các dependency của skill active/Evo, giới hạn nhánh rules V4 để giữ replay V3.
- **Cách xử lý:** runtime handler theo hook nguồn; scope buff-duration cho đúng BuffId trong preview (THD freeze không được đổi thời lượng slow), thêm HIT→accuracy, validate parameter/event có handler và dependency cycle. Guard Retired GUID trước QuickEquip; version config 8 bảng đồng bộ.
- **Art:** 5 effect thiếu bake có đủ container giải nén trong `patch/pfca/effect`; loader mới đọc thư mục này trước ZIP. Đã bake 200 frame và copy 84 ảnh UI gốc. Một số Icon nguồn chỉ tên `.png` nhưng file thật `.jpg`; importer resolve đúng cùng stem và kiểm tồn tại. Recovery trung gian ở Artifacts, không ghi lại reference. Unity import/slice/clip chưa chạy.
- **Bằng chứng:** CrystalChecks PASS 7.970, HeroChecks PASS 112; compile offline cả 5 assembly bằng references/compiler Unity 6000.6.2f1. `SkillEvolutionChecks.cs` chứa ca source-specific; 25 goldens V3 vẫn giữ digest/outcome. Chi tiết trong `docs/zatod-skill-promote-implementation.md`; không dùng số assertion làm bằng chứng UI/thiết bị.
- **Nếu tiếp tục:** giải quyết REVIEW-015 trước khi mở Editor; chạy `ZatodEvolutionArt.Prepare`, kiểm UI/Editor/network fixture rồi mới build. Không regenerate goldens cũ bằng simulation mới.

## REVIEW-013 — Kéo đủ 28 commit Crystal và giữ thay đổi tài liệu local

- **Ngày:** 24/11/2026. **Trạng thái:** hoàn tất fetch/fast-forward 28 commit và xử lý conflict; main/remote main cùng `46d197182c1d9e5743fa0e40f62d6a90bf3ab500`, ahead/behind 0/0 tại mốc kiểm. Không tạo commit mới hoặc push.
- **Phạm vi được yêu cầu:** lấy toàn bộ 28 commit đang chờ, gồm 26 lô reference và 2 commit tài liệu, tự gộp conflict; giữ mọi quyết định brainstorm và skill. Không triển khai gameplay hoặc build trong lượt đồng bộ nguồn.
- **Bảo toàn:** trước cập nhật, stash `64f34ad29acb1ba17914b6d08931ac55d53d3ded` lưu đúng 7 file local và cây index, đã đối chiếu nội dung. Giữ stash làm điểm khôi phục. Fetch xác nhận remote tip trước fast-forward; không reset hard, force-push hoặc xóa nội dung chưa commit.
- **Conflict đã xử lý:** áp lại stash phát sinh conflict trong Design.md và ChangeLog.md. So bản stash với remote chứng minh các phần khác là ghi chú khôi phục/D37 thêm ở local; giữ cả nội dung remote và local. Phase-plan tự gộp được đường reference mới từ remote cùng quy tắc build D37. Đã đánh dấu giải quyết, không còn unmerged paths hoặc conflict markers. Các chỉnh sửa tài liệu vẫn ở local, chưa commit/push.
- **Kiểm tra source:** 96.077 đường tracked khớp chính xác 96.077 file trên đĩa, không thiếu/thừa; `git diff HEAD --exit-code -- Unity/Assets/Crystal Legend/` sạch. Cả 38 hash SHA256 raw ban đầu không khớp vì manifest được ghi theo CRLF; đổi LF sang CRLF trong bộ nhớ làm cả 38 khớp, không còn khác biệt khác. Buff.lua trên đĩa trùng byte với Git blob HEAD; giữ nguyên source và manifest, không ghi lại line ending chỉ để ép hash.
- **Editor/tooling:** đọc `unity-cli.md` và `projects-templates.md`; CLI cập nhật 1.0.0 → 1.0.1 theo hướng dẫn công cụ. Console trước thao tác có 0 lỗi/28 cảnh báo, không clear. `unity close --if-saved` trả `PROJECTS_CLOSE_UNSAVED_UNVERIFIED`, không ép đóng; lần kiểm sau xác nhận không còn tiến trình Editor trước khi checkout. CUA kiểm cửa sổ bị timeout; chưa xác định tác nhân khiến Editor thoát. Không mở lại để tránh tự import bộ raw trong nhiệm vụ Git; không coi đây là nghiệm thu Unity/runtime.
- **Bàn giao:** D04 ghi source đã hiện diện trên clone Mac; D34/D35/D36/D37 và các ghi chú local còn nguyên. Ba file `Unity/.vscode/` được giữ. Các archive/diagnostic đã bị loại khỏi remote theo REVIEW-010/011 vẫn không có nhờ pull; helper cần chúng phải đọc bản giải nén hoặc nhận đầu vào riêng như phase-plan đã ghi.

## REVIEW-012 — Khôi phục checkout và dọn riêng phần Crystal tải dở

- **Ngày:** 24/11/2026. **Trạng thái tại lượt dọn:** đã khôi phục project và dọn phần tải dở theo chỉ dẫn rõ lại của người dùng; khi đó chưa pull lại Crystal hoặc chạy build. Lượt pull tiếp theo đã hoàn tất tại REVIEW-013.
- **Triệu chứng/xác nhận:** đường Desktop chỉ còn `Unity/Library/Pipeline/.unity-pipeline-port` và file Finder; `.git`, Design và source không ở đó. Finder cho thấy nguyên thư mục Zatod Legend trong Trash, gồm `.git`, tài liệu và source. Chưa xác định thao tác nào đã đưa project vào Trash; không quy kết nguyên nhân. Lượt dọn trước của chat đã hiểu sai phạm vi và chỉ xóa ZIP skill cũ cùng venv kiểm tra tạm ở ngoài project.
- **Khôi phục:** giữ riêng các file placeholder dưới `~/.codex/recovery/`, đưa nguyên project từ Trash về `/Users/bloom/Desktop/Zatod Legend`. Đối chiếu SHA256 59 file tài liệu/skill trước và sau khi chuyển: không đổi. Không reset branch hoặc lấy HEAD đè lên công việc chưa commit.
- **Phạm vi người dùng xác nhận:** bỏ phần Crystal tải dở để pull lại, giữ toàn bộ Zatod, tài liệu brainstorm/đọc hiểu và skill. Trước khi dọn, Crystal có đúng 68.280 file staged và 68.280 file trên đĩa, không có file riêng ngoài staged hoặc symlink, không có file Crystal trong HEAD hiện tại `0eb6bb073`.
- **Đã dọn:** gỡ staged riêng `Unity/Assets/Crystal Legend/`, xóa bộ tải dở 4.623.803.432 byte và 7 file `.git/objects/pack/tmp_pack_*` bỏ lại 9.685.749.711 byte. Kiểm không có tiến trình Git đang chạy và lsof xác nhận các pack tạm không được mở trước khi xóa. Tổng 14.309.553.143 byte; giữ toàn bộ pack hoàn chỉnh, lịch sử Git và script Fetch-CrystalBatches.sh.
- **Kiểm chứng:** 9.321 entry Git index ngoài Crystal giữ nguyên chính xác; SHA256 của 67 file tài liệu/skill/ignore được bảo vệ không đổi qua bước dọn. Sau đó bổ sung phạm vi dọn vào D04/D36 và khôi phục quy tắc build D37/AGENTS/phase-plan/iOS đang thiếu trong checkout; giữ các mục REVIEW-010/011 hiện hành. Skill/global AGENTS trên Mac vẫn còn. Không sửa gameplay/asset Zatod, commit/push hoặc nghiệm thu runtime.
- **Lưu ý tại lượt dọn:** reference Crystal còn thiếu ở clone Mac và cần pull lại trước công việc cần nguồn; REVIEW-013 ghi kết quả lấy lại sau đó. Các thay đổi tài liệu local vẫn được giữ, chưa coi working tree sạch để chạy script fetch. Không dùng dọn pull làm lý do xóa Design/ChangeLog/docs/skill, reset toàn repository hoặc xóa pack Git hoàn chỉnh.


**Vị trí reference hiện hành:** từ23/11/2026, người dùng chuyển nguồn sang `Unity/Assets/Crystal Legend/` tính từ repository root. Các mục trước REVIEW-010 có thể ghi root cũ hoặc trạng tháiGitignore ở thời điểm lịch sử; tra dữ liệu tương ứng dưới vị trí mới. Script import/bake còn đường cũ chưa được sửa trong task tài liệu này.

## REVIEW-011 — Push reference lớn và kết nối bị ngắt

- **Ngày:**23/11/2026. **Trạng thái hiện tại:** đã chia lô, commit/push và xác nhận remote main; các đoạn khảo sát/phương án bên dưới giữ lịch sử trước khi thực hiện.
- **Triệu chứng người dùng báo:** nhiều thay đổi, kết nối thường đứt giữa chừng khi đưa reference lên repo. Chưa có logpush để xác nhận lỗi cụ thể; không kết luận chắc chắn nguyên nhân là mạng hoặc giới hạnpack.
- **Bằng chứng:** localmain ở2a3336ead (`Add Asset`), thay96.100file; reference có96.080file/5,87GiB dữ liệu gốc. Gitpack toànrepo6,66GiB. Đọc trực tiếp remote23/11 xác nhậnmain vẫn0eb6bb073, làparent củaassetcommit; assetcommit chưa có trênmain ở mốc kiểm. Kết nốiGit từsandbox thất bại nhưng lượt đọc ngoài sandbox thànhcông; không dùng lỗi sandbox làm bằngchứng nguyênnhân lỗi push của người dùng.
- **Giới hạn nguồn chính thức:** GitHub tối đa2GiB mỗi lầnpush, không phải chỉ giới hạn mỗifile. Chia nhiềucommit nhưng gửi chung mộtpush vẫn có thể vượtgiới hạn. Nguồn: https://docs.github.com/en/get-started/using-git/troubleshooting-the-2-gb-push-limit . 5,87GiB là rawblob tổng, chưa phải dung lượngpack nén của lầnpush; không khẳngđịnh đã đo packtransfer thực tế.
- **Phương án đang đề xuất:** upload từnglô nhỏ, khoảng256MiB dữliệu blob hoặc5.000path/lô; grouping hiện cho25lô reference. Có thể chuẩn bị nhánh uploadtạm, push từngtip để remote nhận object từngđợt rồi pushmain bìnhthường khi đủobject; giữmain/file hiệncó, không cầnforcepush. Phương án chưa được triểnkhai hoặc duyệt như quyếtđịnh thiết kế. Nếu chọn chia lạiassetcommit local thì phải giữ dữliệu và kiểm remote trước, không reset hard hoặc sửa lịch sử đã chia sẻ.
- **Evidence:** `Artifacts/ZatodGitUploadReview_20261123/committed-reference-files.json` và `upload-plan.json`. Chưa dùngGitLFS, xóa duplicate/cache, đổiignore hay publish nhánh. Agent chỉ kiểm và ghi phương án trong lượt này.

- **Người dùng yêu cầu thực hiện23/11:** đồng ý chia lô, commit và push. Kiểm lại thấy localmain đã về0eb6bb073, file reference/tài liệu đang chưa commit; không tự khôi phục commitAddAsset cũ. Thực hiện trên nhánh `codex/crystal-reference-upload-20261123`, commit tài liệu/ignore trước, rồi reference theo lô tối đa256MiB/5.000path; kiểm remote vàpush từngtip, cuối cùngfast-forwardmain bìnhthường. Giữ file/baarchive bịignore, khôngforcepush hoặc xóa dữliệu. Tiến trình/receipt ở `Artifacts/ZatodGitUploadReview_20261123/upload-job/`; chỉ ghi hoànthành sau xácnhận remote.

- **Kết quả thực hiện23/11:** đã push riêng từng commit:1 lô tài liệu và26 lô reference; remote/localmain cùng tip `4a92fda6688b3f3300de3e249e018af1efae02be` trước commit cập nhật kết quả này. Fast-forward bình thường, không force-push/reset hard; tiếp tục đúng receipt sau khi chat hết token. Kế hoạch thực tế26 lô reference thay ước lượng25 lô ban đầu.
- **Phát sinh đã xử lý:** GitHub GH013 chặn lô25 vì phát hiện Alibaba Cloud AccessKey ID/Secret trong bản giải mã `recovered/scripts/custom_bytecode/.../util/network_diagnosis.abc`. Quét giá trị ID bị cảnh báo chỉ thấy3 bản `network_diagnosis` tại `custom_bytecode`(.abc), `lua`(.lua), `lua51_bytecode`(.luac). Cả3 thuộc hai lô cuối chưa được remote nhận; thêm ignore đúngpath, giữ nguyên local, amend riêng commit chưa push và cập nhật receipt. Không bypass push protection, không đưa giá trị khóa vào tài liệu; chưa xác minh khóa còn hiệu lực. Hai lô cuối sau đó đã được GitHub chấp nhận. Đây là tiện ích chẩn đoán mạng bên thứ ba, không là đầu vào D35.
- **Kiểm chứng hoàn tất:**96.077 file reference được tracking, khớp chính xác danh sách lô đã điều chỉnh; so với assetcommit ban đầu chỉ thiếu3 bản diagnostic nêu trên. Hash38source trongmanifest và toàn bộ configruntime baseline khớp;3 file quá lớn và3 diagnostic đều cònlocal, bịignore, khôngtracked. Workingtree sạch tại mốc kiểm, localHEAD=remote main. Evidence/receipt: `Artifacts/ZatodGitUploadReview_20261123/upload-job/state.json`, `verification.json`, logpush; Artifacts vẫn chỉlocal. Không chạy Unity/import/bake/build hoặc triển khai D35.
- **Nếu tái diễn:** GH013 là chặn secret, không phải lỗi kết nối; dừng retry kiểu mạng và loại nội dung nhạy cảm khỏi commit chưa xuất bản. Chỉ retry lỗi truyền tải; xác nhận remote receipt trước khi gửi tiếp. Những helper còn đường cũ/đọc ZIP trực tiếp vẫn phải được xử lý trong preflight D35.

## REVIEW-010 — Đường dẫn reference lỗi thời sau khi người dùng chuyển folder Crystal

- **Ngày:**23/11/2026. **Trạng thái:** đã cập nhật tài liệu và trường SourceRoot của JSON tham chiếu; chưa sửa hoặc chạy importer/bake/Unity.
- **Triệu chứng:** root `Crystal Legend/` không còn, trong khi các markdown, reference index và machine-readable SourceRoot vẫn trỏ vào đó; D04/README/phase-plan còn mô tả đặt ngoàiAssets và bịGitignore.
- **Nguyên nhân xác nhận:** người dùng đã chuyển nguyên reference vào `Unity/Assets/Crystal Legend/`. SkillEvo.lua, recovery_tools và các phần nguồn đã kiểm tồn tại ở vị trí mới. Rule `.gitignore` cũ neo `/Crystal Legend/` không khớp đường mới; Git báo folder mớiuntracked tại thời điểm kiểm, không phải đã commit hoặc đã theo clone.
- **Cách xử lý:** cập nhật các đường source đang dùng trong Design/README/docs, AGENTS, `docs/crystal-legends-reference.txt` và `docs/reference/zatod-skill-promote-source.json`; D04 ghi rõ quyết định vị trí mới thay placement cũ. Bổ sung hướng dẫn phân biệt repository root với Unity project root, kiểm trạng tháiGit và resolver helper trước khi chạy. Giữ lịch sử ChangeLog cũ, thêm ghi chú ánh xạ ở đầu file thay vì viết lại bằng chứng lịch sử.
- **Giới hạn:** các script import/bake vẫn ghép root cũ, đã được ghi vào preflight cho agent triểnkhai; không tự sửa code, `.gitignore`, di chuyển lại folder hoặc import/build rawsource trong yêu cầu chỉ chỉnh tài liệu. Việc nằm trongAssets chưa là bằngchứng asset đã được cấu hình/nghiệmthu cho game.
- **Kiểm tra tài liệu:** kiểm đườngsource mới, linkMarkdown, JSON parse và SHA256 cácsource theo manifest; xác nhận không còn đường vận hành `Crystal Legend/recovered` thiếu prefix mới trong bộ tài liệu hiện hành. Báo cáo local: `Artifacts/ZatodReferenceRelocationReview_20261123/validation.json`; không coi đây là testUnity/gameplay.

- **Bổ sung23/11 khi người dùng gặp cảnh báo3file quá lớn:** browser `chrome-headless-shell.exe` không là input D35; `install_time_pack.apk` là archive nguồn, các importer asset hiện dùng bản giải nén. Tuy nhiên Bake-CrystalEffects.py mởPACK ZIP trước khi kiểm bản bake, Bake_CrystalSupport.recover_effect và hero_animation.recover_container cũng đọc ZIP trực tiếp. Vì vậy không được báo bỏZIP là không ảnh hưởng mọi helper; agent phải hỗ trợ đọc thư mục giải nén hoặc nhận ZIP riêng khi cần recover/bake mới. Đã ghi preflight và reference index; chưa sửa loader/Gitignore/index hoặc xóa file.
- **Bằng chứng giải nén:** đọc central directory ZIP và stat cácfile,2.400 entry `patch/pfca/` đều có bản giải nén cùng kích thước, gồm `effect/eff_buff_Coco_ult.fca`. Chưa hash toàn bộ hoặc chạy bake. Báo cáo `Artifacts/ZatodReferenceRelocationReview_20261123/archive-extraction-check.json`. Bản gốc local vẫn giữ; việc không commit không đồng nghĩa xóa hoặc chứng nhận pipeline không còn cầnarchive.

- **Thực hiện theo yêu cầu23/11:** thêm3 rule theo đường dẫn đầy đủ vào `.gitignore` cho đúng browserexe/APK/ZIP được báo, giữ bản local và không ignore thư mục source/asset giải nén. Cả3 chưa nằm trongGitindex nên không cần bỏtracking hoặc sửa lịch sử commit. Kiểm `git check-ignore -v` nhận đúng3 rule; sourceLua và container giải nén mẫu không bịignore. Không sửa code/importer hoặc commit/push.

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

- **Tái diễn24/11 khi reviewcodeD35 trênWindows:** restoremặcđịnh vàrestore vớiconfigpackageSourcesclear riêng ởArtifacts đều cònchạmtớiNuGet.Config bịchặn trongprofile. KhôngđổiACL/configmáy, khôngyêucầunângquyền. `dotnet run --no-restore` dùngassets hiệncó chạyD35Checks745/Hero112/fullcore7973PASS; NuGet.Config thửnghiệm chỉởArtifacts/ZatodD35PullReview, khôngđitrongGit. Khôngcoilàlỗigamehoặcthaycodeđểnérestore.

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

- **Bổ sung24/11/2026 — HUDultimate/thanhmáu:** người dùng yêu cầu kiểm lại vì portraitultimate vàHPbar chưa giốngCrystal. Đọcsource xácnhận actor dùngFloatingBarHPsmall nềnđen/lớpvàng/foregroundxanhđỏ, auto-hide theo chuyểnđộngbar+hide_delay1,5s; groupHP/shield cótimerchung, mode/đơnvịđặcbiệt cóngoạilệ. PortraitHUD dùngHpBar riêng vớiauto_hide=false. CodeStageZatod hiện tạoHP bằngspritewhite tint/scale vàkhôngẩn; HUD dùngviềnreadyImage màu/energyđầy, thiếueffectcast/ready vàcheckkhảnăngcastthật từcore. Đây là nguyênnhânxácnhận bằngcode, chưa nghiệmthu sửa.
- **Nguồn/asset đãkiểm24/11:** actor.lua/useBar, battleui/hp_bar.lua/FloatingBar/FloatingBarGroup, hero_panel.lua/checkManulCanCast/castHandler; PNGHPsmall/herobucket đãxemảnh.4containerwill_ready/cast/full_power/skill_cost trongpatch/pfca/effect đọccha/plist/sheet.pvr vàCRC PASS; chưarecover/bake/import4effect. Báocáo `docs/crystal-battle-presentation-review.md` mụcUIultimate/thanhmáu. Người dùng đãduyệt6nhómfeelingcombat vàtestleveldesign; lượtcheckchỉcậpnhậtDesign/review, khôngsửaC#/scene/prefab/Owned.
- **Lưu ý nghiệmthu tiếp:** thửHPổnđịnh/mất/hồi/liêntục/MaxHP/shield/death, phânbiệtportraitluônhiện vàfloatingauto-hide; ready/cast/pending/clicklặp/silence/stun/range/target/replay/safearea. Khôngẩnthanhportraittheotimeractor, khôngngẫu nhiên/RNG ởview. BUG-014 nhắc giữblendFCA, khôngđưa texturefullenergycheportraittrởlại.

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

- **Lưu ý24/11 khi mởlạiHUDultimate:** viềnvàng làworkaround19/11 đượcchấpnhận tạm, người dùng naymuốnready/castđúngCrystal trongD34. ĐãkiểmcontainerFCA nguồn cósẵn ởfoldergiảinén; chưabake hoặcđổiruntime. Phảigiữalpha/blend/scale/layer, khôngápPNGfullenergyvàoImagealpha mặcđịnh đểtáihiệnlỗi cũ. ĐốichiếuBUG-018 vàreviewcombat24/11; chưađánhdấuđãhoànthiệnUI mới.

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

- Rà phạm vi economy D30 ngày21/11: transaction craft hiện snapshot Inventory/EquippedItems/Revision, chưa snapshot Currencies vì runtime vẫn bỏ phí. Khi thêm GoldCost thật cần đưa số dư vào rollback và receipt, kiểm tra đủ vàng trước tiêu hao, retry không thu lại. Đây là yêu cầu mở rộng khi triển khai, chưa phải lỗi mất vàng đã quan sát; chưa đổi C# hay thử lỗi lưu trong lượt brainstorm.


## BUG-049 — Popup craft dùng font bootstrap thiếu glyph tên ải

- Ngày21/11/2026, phát hiện khi kiểm tra Get Way. Popup mới được author bằng FormationFont cũ từ bootstrap, không có fallback; tên ải chương2 xuất hiện warning10 glyph thiếu. Không phải thiếu text/asset item hoặc recipe.
- Sửa: SetupZatodCrafting dùng ZatodFormationLatin và fallback ZatodFormationFont native; bake thêm ký tự tên39 ải và112 tên item với HasCharacter trước TryAddCharacters, giữ kinh nghiệm BUG-019. Không đổi tên ải hoặc dùng font OS. Lượt Play sạch cuối qua74 UI checks, Console0 glyph warning; prefab đúng font native và clipping.

## BUG-050 — Prefab authoring còn layout của assembly trước compile

- Ngày21/11/2026. Source đã đổi nút Back/vị trí Message nhưng ảnh Play vẫn dùng nút X, StatsHeight285/MessageY-735. Probe runtime xác nhận prefab giữ giá trị cũ trong khi dynamic icon renderer đã là bản mới.
- Nguyên nhân xác nhận: helper authoring chạy trước lượt reload hoàn tất nên Create dùng assembly cũ rồi lưu prefab; sửa source không tự dựng lại hierarchy trong prefab. Khắc phục: Stop Play, Refresh ngoài Play, đợi reload, author lại; helper kiểm tra child Arrow của layout mới trước SaveAsPrefabAsset. Không sửa scene của người dùng hoặc reset Library.
- Một lượt Play bắt đầu chồng reload có catalog nonserialized=null dù frame vẫn tiến. Đã xác nhận bằng probe, dừng Play/chờ stopped và compiling=false rồi mở phiên mới; không inject catalog giả vào runtime để né lỗi. Giữ ui-reload-before-restart.json. Đây là vấn đề trình tự authoring/test, chưa có bằng chứng phát sinh trong Player build.


- Bổ sung22/11 phase D30: UI fixture ban đầu gặp NullReference khi mở HeroDetail. Probe runtime xác nhận Host.catalog=false dù frame tiến; sau Stop Play, xác nhận compiling=false rồi Play mới, UI77 checks PASS. Không inject catalog vào host để né lỗi; không sửa scene/Owned. Evidence Artifacts/ZatodEconomyChecks/ui/result.json; dùng lại workflow BUG-050.

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

## D30 — Tiến trình, vàng và thể lực đang triển khai

- Ngày22/11/2026. Đã mở rộng rollback craft từ kho/Revision sang cả số dư vàng; core kiểm tra persist fail và idempotent receipt thu GoldCost thật. Thưởng trận rollback cả item/level/EXP/vàng/stamina và ledger khi lưu lỗi; start cost cũng rollback. Đây là triển khai mở rộng REVIEW-002, không tuyên bố Promote đã được transaction hóa.
- Core4.982, Editor37, UI77 và14 archive PASS; build/network/deploy còn đang chạy. Chi tiết docs/zatod-economy-implementation.md, Artifacts/ZatodEconomyChecks.
- Unity CLI cài trong Program Files không tự cập nhật được do quyền file; dùng bản sao trong Artifacts/Tools/UnityCLI và cập nhật thành1.0.1, không thay bộ CLI global.

## BUG-051 — Build Player thiếu dung lượng ổ đĩa khi nhân bản resources

- Ngày22/11/2026, phaseD30. Trạng thái đã kiểm tra workaround thành công. Build đầu314s/1 lỗi: copy resources.assets.resS báo There is not enough space on the disk. Bundle chuẩn cũ có resource11.314.723.168 byte; build còn tạo output Bee/cache trênE, sau fail E chỉ còn khoảng9,4GB. Không kết luận lỗi compile/gameplay.
- Workaround đang thực hiện: build kiểm tra sang thư mục TEMP/ZatodEconomyChecks20261122/Player trênC còn hơn120GB; giữ source/Owned/bản chuẩnE, không xóa tài nguyên hoặc Library. HelperBuildZatodEconomy.cs; evidence Artifacts/ZatodEconomyChecks/build-first-failed.json. Chỉ đánh dấu đã kiểm tra sau build mới.

- **Khảo sát tái diễn22/11/2026 — project gần100GB:** đã đo dung lượng, chưa dọn hoặc tối ưu. Quét162.549 file dưới project, không lỗi đọc/không bỏ qua reparse point: tổng105.038.582.549 byte =97,83GiB (tổng độ dài file, không đo allocated size). Artifacts42,74GiB, Unity27,84GiB (Library26,36GiB; Assets1,45GiB), Builds17,55GiB, Crystal Legend7,63GiB, .git1,92GiB. Đây là ảnh chụp trước khi ghi báo cáo khảo sát.
- **Nguyên nhân dung lượng đã xác nhận:** bốn bản Player tại Artifacts/ZatodBattleResultChecks, ZatodCraftChecks, ZatodLootChecks và ZatodWorldBattleChecks cộng45.233.853.504 byte (~42,13GiB); mỗi bản giữ resources.assets.resS ~10,19–10,53GiB. Bản chuẩn Builds/ZatodPrototype10,75GiB có resources.assets.resS10,569GiB; Library/PlayerDataCache cũng giữ file10,569GiB, Library/DataStore13,65GiB. Sáu thư mục build khác ngoài bản chuẩn cộng6,80GiB. Việc giữ nhiều bản kiểm thử và cache giải thích phần lớn mức tăng; không quy cho source code hoặc save sở hữu.
- **Giới hạn chẩn đoán texture:** Assets có3.415 PNG tổng1,336GiB; metadata default có3.125 textureCompression=0 nhưng đã thấy override Standalone BC7 ở sprite Crystal (ví dụ eff_UI_pvp_light/Loop_0.png.meta và ImportCrystalSprites.cs). Không kết luận toàn bộ build dùng texture không nén, không lấy tổng pixel RGBA32 làm RAM/build size thực tế. Chưa trích packed-asset attribution để xác định từng asset đóng góp vào resources.assets.resS.
- **Xử lý/kiểm tra:** chỉ ghi evidence Artifacts/ZatodStorageReview/20261122.json và textures-20261122.json; chưa xóa file, đổi import/config/runtime, build hoặc dừng process. ỔE còn9,32GiB khi kiểm tra. Đề xuất ưu tiên xem xét dọn bốn Player kiểm thử (~42,13GiB), sau đó các build lịch sử (~6,80GiB), giữ report/backup nguồn/Owned/replay và bản chuẩn; chưa thực hiện vì người dùng chỉ yêu cầu kiểm tra. Giữ nguồn Crystal/assets cũ theoD04/D16. Nếu tái diễn, đo lại trước và kiểm nơi helper giữ full Player; không xóa toàn bộ Artifacts vì chứa save/server và bằng chứng kiểm thử, không coi xóa Library là giải pháp ngăn build sao chép tái phát.

## REVIEW-004 — MonsterChecks cũ tham chiếu định nghĩa đã loại khỏi config

- Ngày22/11/2026 khi mở rộng regressionD30. Tests/MonsterChecks/Program.cs:26 đòi fighter_goblin và bộHero prototype cũ; active config hiện không còn ID này theoD16. Lượt chạy fail Unknown monster ID: fighter_goblin; dữ liệu Monsters/Skills/Heroes không đổi ngoài ConfigVersion qua auditHEAD nên không quy lỗi vào economy. Chưa sửa bài test lịch sử trong phase này; kiểm tra active combat bằng CrystalChecks4.982 và14 replay cũ. HeroChecks112 PASS. Không ghi MonsterChecks PASS.

## D30 — Nghiệm thu cuối22/11/2026

- EXP tài khoản/Hero, vàng, thể lực và thu phí craft thật đã triển khai; core4.982/Hero112/Editor37/UI81/network21/14 archive PASS. Windows build cuối0errors/2warnings có sẵn,218 file chuẩn khớpSHA256;10 hash Owned/scene giữ nguyên. Artifacts/ZatodEconomyChecks/handoff.json, deploy-audit.json, docs/zatod-economy-implementation.md.
- BUG-051: chuyển build sangTEMP trênC đã thành công143,92s; giữ backup build chuẩn cũ trênC và cập nhật Builds/ZatodPrototype. Không xóaLibrary/rawassets để lấy chỗ.
- Fixture mạng phải dùng launchGUID mới khi đổi development profile; Stop/StartPlay trước mỗi lượt profile mới. Fixture GreenBoots phải giữ Hero đủ level mặc, tách khỏi đội kiểm traEXP thấp cấp. Các lỗi fixture đầu không được quy thành lỗi gameplay.
- Dừng server test: chuẩn hóa cả process.Path và buildreport.Path bằng Path.GetFullPath trước so sánh, vì một bên dùng\ và một bên dùng/. Kiểm tra PID từ listener và executable đúng thư mục test rồi mới dừng; không dừng process lạ. Server test cuối đã dừng.
- Mainserver giữ trạng thái dừng như ban đầu, Editor stopped/scene sạch/auto_tick=false, tab Progression mở. Console hiện hành không có lỗi compile/runtime; warning ReplaceHandler khi reconnect Mirror giữ theo lịch sử, không clearConsole. MonsterChecks cũ còn REVIEW-004 như đã ghi.

## REVIEW-005 — Inventory source có đường asset literal cũ và phụ kiện chưa tìm thấy

- Ngày22/11/2026. Trạng thái kiểm tra tĩnh, chưa triển khai/chưa quan sát lỗi runtime. Mainpackage27/27 ảnh có sẵn, cáclayoutphụ chính có đủ. package_item.lua tham chiếu3 đường không có đúngliteral trong recovered: HVGA/equip_frame_white.png cóframe1080Pnative tươngứng; SeasonArena/treasure/unlock_icon.png và package/bg_timer.png chưa tìm thấy quafileinventoryrecovered. Hai iconphụ dùng khóa/hếthạn ngoài phạmvicơbản đang bàn.
- Không kết luận thiếu file gốc hay sửa bằngshapegiả: cần xét resolver/remap nếu sau này bật2feature đó. Khảo sát hiện không thay runtime. Bằng chứng Artifacts/CrystalInventoryReview_20261122/audit.json, docs/crystal-inventory-review.md.
- Bổ sung22/11/2026 khi dựng preview EXP ngoài Unity: lần đầu script tra nhầm herolist_bg.png, trong raw thực là herolist_bg.jpg; Unit.Portrait dùng tên dLina.jpg trong khi ảnh có thật là UI/DOTA-HERO/Lina.jpg. Chỉ sửa đường lookup của script preview, không rename/copy giả vào nguồn. Script chạy thành công,21 ảnh đọc được và preview đã kiểm tra trực quan; không phải lỗi asset runtime của game. File Artifacts/CrystalInventoryReview_20261122/preview_exp_source.py và hero-exp-preview-audit.json. Nếu tái diễn kiểm file inventory/remap thay vì suy thiếu art.

## BUG-052 — Công cụ kiểm tra D31: license/TCP sandbox và API TMP

- Ngày22/11/2026, đang kiểm tra phase Inventory. Unity tự khởi động lần đầu báo license entitlement/timeout; không kết luận license tài khoản bị mất. Người dùng mở project qua Hub, CLI trong sandbox vẫn không nhận Pipeline, CLI được cấp quyền kết nối local trả ready đúng6000.6.2f1. Dùng Editor đã mở, không đổi Unity version/license/project settings. Chỉ dừng process23692 do agent tự mở; không dừng Editor người dùng.
- Compile đầu báo CS0619 enableWordWrapping trong ZatodInventoryView: TMP hiện tại yêu cầu textWrappingMode. Đổi sang TextWrappingModes.Normal; chờ compile/visual checks trước nghiệm thu.
- dotnet restore không đọc được NuGet.Config profile trong sandbox. Dùng --no-restore với assets đã restore có sẵn, không sửa NuGet.Config hệ thống. Core5053 assertions PASS. Lượt oracle đầu dùng alias crystal_1 để tra fixture bonus mới nên mismatch; sửa lookup theo HeroDefinitionId đã resolve, không sửa số nguồn để che regression.
- Bằng chứng Artifacts/ZatodInventoryChecks/editor*.log, before.zip, core và Editor reports khi hoàn tất. Script compile Roslyn ngoài Editor thử gộp asmdef vào Assembly-CSharp gây type conflict; không coi đó là lỗi Unity runtime, nghiệm thu bằng compile đúng Editor/asmdef.

## BUG-053 — Inventory thiếu khung quality tím/cam khi tái sử dụng popup craft

- Ngày22/11/2026, phát hiện qua UI checks D31: EXP Pizza/icon quality có sprite null. ZatodEquipmentView.ItemIcon chỉ tra Crafting/common/frame; bộ Crafting cũ chỉ import equip trắng/xanh lá/xanh dương, trong khi đồ EXP có bậc4/5 và Soulstone cũng cần khung khác.
- Bổ sung đủ khung có thật trong raw vào Inventory/Native và fallback lookup từ EquipmentView.Native sang InventoryView.Native; không tạo shape giả hoặc đổi quality config. Đang compile/import và chạy lại kiểm tra sprite/responsive. File Scripts/Import-ZatodInventory.py, ZatodEquipmentView.cs; evidence Artifacts/ZatodInventoryChecks/ui/result.json.
- Lượt safe-area check ban đầu dùng Rect.Contains ở biên max loại trừ góc đúng trên biên; mở tolerance1 pixel cho phép sai số float, vẫn kiểm mọi control nằm trong safe area. Đây là chỉnh fixture, không phải dịch UI để che clipping.

## BUG-054 — D31: cache script Editor và review popup Quick Craft

- Ngày22/11/2026. Editor eval không thấy field MaxHeroStars dù source đã có: DLL Heroes vẫn timestamp17:13 trong khi source17:25. RequestScriptCompilation đơn lẻ chưa nhập file đổi trên đĩa. Gọi AssetDatabase.Refresh(ForceUpdate), chờ compile xong; sau đó Editor19 checks/Owned round-trip và16 archive PASS. Không sửa dữ liệu để né cache.
- Review ảnh Quick Craft sau stack: checkbox ký tự Unicode không có glyph (ô vuông), chữ trắng trên nền sáng thiếu tương phản; lớp dim gắn theo board chưa phủ vùng ngoài safe area. Đổi sang lưới icon mảnh và sprite package/selected.png native, text số lượng trên bar gốc; dim lấy bounds Canvas toàn màn. Đang chạy lại visual checks/build, không coi UI cũ là bản cuối.
- Fixture mạng lần đầu kết nối trước server lạnh READY nên timeout/Disconnected,0 checks; Stop/Start Play launch mới sau READY đã qua15 checks. Không kết luận gameplay disconnect. Khi tái diễn chờ log READY trước Connect, giữ test data/port17996 riêng.
- Trong cleanup importer bỏ loop HeroStats để lại elif trống ở Import-ZatodChapterTwo.py; py_compile phát hiện và đã bỏ nhánh rỗng. Cả5 importer liên quan đã qua syntax check; không chạy importer cũ vào Owned/config balance của người dùng.

## BUG-055 — Inventory/Soulstones chưa đúng bố cục Crystal tham chiếu

- Ngày22/11/2026, người dùng đối chiếu preview và yêu cầu sửa: grid Soulstones đang dùng icon item đá và nhãn Recruit/Star Up, thiếu card Hero, level/sao/rank, progress tím và nhóm Heroes Not Owned; cả view còn dùng font/tỷ lệ khác ảnh.
- Nguyên nhân xác nhận: controller tái sử dụng ZatodEquipmentView.ItemIcon cho cả grid Soulstones, dùng projection kho thay vì Hero. Source Package:createStoneIcon thực tế dùng readhero.createIcon, getStoneAmount/getStoneNeed và unHeroList; font English là DFPYuanW7-GB/FZCQJW trong multilanguage.lua, không phải Roboto đang dùng cho draft.
- Đang chuyển grid sang projection Hero sở hữu/chưa sở hữu (kể cả0 đá), giữ raw Inventory/GUID nguyên vẹn; tái dùng FormationCard/native rank/stars, bar tím, dấu đủ điều kiện và effect background/title lấy từ FCA gốc. Thay font Inventory riêng, không thay font chung của world; chỉnh tỷ lệ panel,8 cột, selected tab, Source rows và giá ở footer. Chưa ghi hoàn tất cho đến visual/responsive/build mới.
- Effect FCA có internal name prefix effect/, nên helper recovery dành cho Hero từ chối so sánh tên. Đọc trực tiếp ChaReader/atlas/render_frame của công cụ recovery, giữ SHA256 nguồn trong Artifacts/ZatodInventoryChecks/source-effects/audit.json; không rename hoặc sửa FCA nguồn.

- BUG-055 bổ sung kiểm tra22/11: preview đầu còn tên món bị mất nét khi dùng font bold và filter Forged bị cắt. Chuyển label thường sang font normal gốc, sửa khung tên (bg_number thay vì kéo giãn seg_normal là đường trang trí), hạ min-size filter. TMP_SDF-Mobile có shader_feature OUTLINE_ON; bật keyword trên material font riêng để viền chữ thực sự được render, bỏ outline ở body tối màu. Đồng bộ description25 đá với tên roster active (Lina thay alias locale Vulcano); không sửa stats/drop/Owned. UI cuối1119 checks PASS/4tỷ lệ, gồm card0 đá không GUID giả, nhóm Hero và mở confirmation. Ảnh reference-final-* đã review; đang hoàn tất build/deploy.

- BUG-055 bổ sung theo yêu cầu mới: dùng chung HasUpgradeStones và glow/title native cho List of Heroes, kiểm đủ ngưỡng sao kế/cap. Fixture đầu tìm Transform ngay sau Destroy nên thấy card cũ đã inactive (Unity hủy cuối frame), chưa chứng minh lỗi hiển thị; chờ frame trước kiểm card mới. Đang chạy lại kiểm chứng thay đổi đá và cap. Build trước bổ sung roster đã Succeeded215,82s/0errors/2warnings; eval chờ120s timeout nhưng build tiếp tục, không chạy build trùng.

## D31 — Nghiệm thu Inventory, stack và layout tham chiếu cuối22/11/2026

- BUG-052/053/054/055 đã qua kiểm chứng trong phạm vi phase: Unity compile không lỗi; core5068/Hero112/Editor19/UI1123/network15/replay16 PASS. UI có đủ native quality frames, glyph/filter đọc được, dim toànCanvas, card Hero/nhóm0 đá/progress tím và Star-Up ở Inventory lẫn List of Heroes. Roster tắt badge khi tiêu đá/cap và hiện lại khi đủ đá; dùng chung HasUpgradeStones, không sửa số dư hoặc tự cấp vật phẩm.
- Build cuối Succeeded0errors/1warning26,97s;218 file bản chuẩn khớpSHA256. Đã dừng server test17996 đúng PID3680/path; Editor stopped/scenes sạch/auto_tick=false, GameEditor StarRules mở, Console groundTruth0errors.9 Owned/5scene giữhash, không tạo thêm Owned trong hai kho thật. Chưa benchmark mobile vật lý.
- Nguồn và bằng chứng: docs/zatod-inventory-implementation.md; Artifacts/ZatodInventoryChecks/handoff.json, ui/result.json, ui/reference-final-*, network/result.json, build.json, deploy-audit.json, data-audit.json, owned-check.json, before.zip/owned-before.zip. Khi tái diễn stale Editor, làm Refresh(ForceUpdate)/chờcompile/Play mới; server lạnh phải READY trước Connect; Destroy kết thúc frame thì test UI mới kiểm hierarchy; build eval timeout không có nghĩa build dừng, đọc build.json/log trước khi chạy lại.

## REVIEW-006 — Mức sẵn sàng LAN Windows/Android (chỉ khảo sát)

- Ngày22/11/2026. Theo yêu cầu kiểm tra, không sửa runtime/config/firewall hoặc build/cài module. Windows đã kiểm2 cặp standalone qua IP Wi-Fi192.168.0.5:17997, world movement/portals/isolation/private battle và Campaign/Arena/PvP PASS; hai phía PvP cùng digest và8inputs. Listener mọi interface, firewall cho executable chuẩn đã có rule AllowTCP Private/Public. Chưa kiểm2 thiết bị vật lý/router; không ghi đã nghiệm thu LAN thực địa.
- Android hiện chưa có APK/AAB và Editor6000.6.2f1 thiếu AndroidPlayer module. Đây là bước chuẩn bị nền tảng chưa thực hiện, chưa kết luận lỗi gameplay Android. WASD chỉ Editor theo chốtD24; Windows Player dùng chuột kéo joystick. Arena vẫn đấu đội mẫu, PvP mới là hai người online. Chưa sửa những hành vi này.
- Evidence/report: docs/zatod-lan-readiness-review.md; Artifacts/ZatodLanChecks/20261122-192258/result.json và client logs. Test PID23104/client đã dừng; mainserver7788/PID33916 có sẵn được giữ chạy. Test dữ liệu riêng, không reset hoặc grant vào kho thật. Khi test máy khác nhập IP LAN server thay127.0.0.1, dùng cùng bản build; cần nghiệm thu riêng Windows–Android sau khi có APK.

- REVIEW-006 bổ sung khảo sát D32 ngày22/11: Wi-Fi thực tế Double Meow 5G/IP192.168.0.5; C74.8GiB/E9.3GiB trống, áp dụng kinh nghiệm BUG-051 cho kế hoạch build. CharacterData.Name có sẵn nhưng World Name vẫn Player+GUID; prototype header còn dùng cho menu mode. Ghi lưu ý tách login/định danh/endpoint và toolchain tại docs/zatod-lan-login-android-plan.md; chưa sửa runtime/config/cài module/đổi mạng.

- REVIEW-006 rà yêu cầu tiếp22/11: đã tạo folderDesktop Zatod Legend LAN Test/{Windows,Android,Server} theo yêu cầu; CLI Androidmodule dry-run thành công với đúng dependency. Chưa cài/sửa runtime/đổi network hoặc dừngPlay hiện có. Đề xuất LANdiscovery để hỗ trợ IP đổi theo mạng; NPC Arena/PvP/Replay và outputDesktop được ghi vàoD32, không báo đã có APK.

## BUG-056 — Sprite sheet không chia hết cho4 làm BC7 rơi về RGBA32, build hơn10GiB

- **Ngày:**22/11/2026. **Trạng thái:** đã xác nhận nguyên nhân bằng kiểm tra chỉ đọc, chưa sửa/bake/reimport/build. Liên quan BUG-051; bổ sung chẩn đoán texture còn để mở trong lượt khảo sát dung lượng trước.
- **Triệu chứng:** Builds/ZatodPrototype tổng10,75GiB; resources.assets.resS11.348.332.096 byte (10,569GiB). Bảng build trong Unity/Logs/Editor.log:35945 ghi Textures10,5gb/99,3% user assets, animation clip2,4mb và sound6mb. Đây là log buildD30 trước bản incrementalD31; không ghi nó là packed-asset report mới củaD31. BuildReport hiện tại trỏ outputD31 và có packedAssets.Length=0/contentSummary=null, nên không rebuild chỉ để lấy báo cáo mới.
- **Nguyên nhân đã xác nhận:**767PNG trong Assets/Zatod/Art/Imported có Standalone overrideBC7;430 ảnh có width hoặc height không chia hết cho4. TextureImporter.GetImportWarnings trả cùng cảnh báo cho đúng430ảnh: `Only textures with width/height being multiple of 4 can be compressed to BC7 format`. Sáu mẫu đối chứng: AV/atk3_1(3858x4050), eff_UI_pvp_light/Loop_0(3970x3780), Coco_HD/Rage_0(3808x3710) thực tếRGBA32; AV/Idle_0(1404x1764), AV/Damaged_0(1092x1180), Axe/atk3_0(2860x984) thực tếBC7. GPU RTX3050/D3D12 hỗ trợBC7, active targetWindows64; không quy lỗi thiếu hỗ trợGPU hoặc toàn bộ texture đều không nén.
- **Nguồn tạo kích thước:** scripts/Bake-CrystalAnimations.py:29 tạo sheet bằng `(width*cols,height*actual_rows)` và chưa pad kích thước sheet để chia hết cho4. Bake-CrystalEffects.py/Bake_CrystalSupport.py dùng lại baker đó. ImportCrystalSprites.cs/ImportCrystalSpriteBatch.cs/ImportZatodResultEffects.cs chọnBC7 và npotScale=None nên chỉ cấu hìnhBC7 không chứng minh output thực sự đã nén. Ảnh AV/atk3_1 PNG1.643.069byte có pixelRGBA32 62.499.600byte, khớp khoảng59,7MiB trong log.
- **Phạm vi đóng gói:** AssetDatabase.GetDependencies của2.441 root asset trong các Resources thuộcAssets xác nhận cả767PNG imported đều được kéo theo. Resources luôn đóng gói root và dependency dù scene không trực tiếp dùng hết; đây là phạm vi cần rà riêng, chưa kết luận767ảnh đều thừa hoặc import toàn bộ314container. SourceCrystal ngoàiAssets vẫn được giữ theoD04/D16.
- **Đề xuất chưa triển khai:** pad viền trong suốt của sheet cho đủ bội số4 và cập nhật sprite rect theo tọa độ ảnh mới, giữ nguyên pixel frame/pivot/FPS/timeline/GUID; kiểm art/replay rồi mới reimport/build để đo.430ảnh có tổngRGBA32 8.781.936.604byte; BC7 với padding tối thiểu ước2.198.077.168byte, chênh khoảng6,13GiB. Đây chỉ là phép tính dữ liệu texture, chưa phải dung lượng build tiết kiệm đã kiểm chứng. Rà thêm phạm vi clip/Resources sau đó; không tự xóa asset cũ hoặc đổi cơ chế animationD10.
- **Bằng chứng/kiểm tra:** Artifacts/ZatodStorageReview/{texture-import-audit.json,editor-texture-audit.json,build-size-summary.json}; script audit chỉ nằmArtifacts, không import vàoAssets. Chỉ đọc importer/dependency/6texture mẫu, không thay config/runtime/asset, không đổiPlay hoặc dừngprocess. Console cuối groundTruth0errors/compilationFailed=false; giữ lịch sử. Helper đầu truy cập contentSummary của incremental report bịNullReference, đã thêm guard; đây là lỗi truy vấn chẩn đoán, không phải lỗi game. CLI trong sandbox không thấyEditor, đọc ngoài sandbox đã thấy đúngPID18344/projectUnity; self-update check bịERR_NETWORK, giữCLI1.0.1 hiện có. Đã đọc skill references unity-cli/integration-advanced.md và using-unity trước kiểm tra.
- **Nếu tái diễn:** kiểm GetImportWarnings và Texture2D.format thực tế cùng kích thước sheet; không chỉ kiểm `.meta`/platform.formatBC7. Xóa cache hoặc dọn bản build cũ không sửa được điều kiện kích thước ảnh gây fallback.

- REVIEW-006 tablet22/11: Windows đã nhận OPPO Pad Air +ADB Interface OK nhưngadbdevices báo unauthorized, chưa phải lỗi driver/game. Người dùng mở khóa vàCho phépUSB debugging; sau đó trạng tháidevice và đọc đượcAndroid13/API33/ARM64, data trống11G, Wi-Fi192.168.0.2/24. Dùngadb từUnity2022 có sẵn, không cài SDK mới trong lượtkiểm. Lưu kinh nghiệm: thấy MTP không chứng minhADB sẵn; cầntrạng tháidevice. Nếu lạiunauthorized phải đểngườidùngchấpnhậntrust trênthiếtbị. Chưa deployAPK hoặc xácnhậnTCP/gameplay; nc khônghỗtrợzero-I/O nên probe đãskip. ĐíchAndroidD32 đổi sang cài/chạyUSB, APKtạmPC, không cầnxuấtDesktop/Android.

## BUG-057 — Nhánh prototype trước Crystal còn trong source và build

- **Ngày22/11/2026; quyết địnhD33:** người dùng yêu cầu xóa Hero/art/logic/UI trướcCrystal và cả build cũ. Trạng thái đang kiểm tra build sau dọn, chưa nghiệm thu cuối.
- **Đã xác nhận:** runtime còn combat20Hz/BattleRecord, ArenaConnection/UI pixel, sceneArenaPrototype, Hero pixel và importer/preview cũ; config hoạt động đã dùng bộCrystal nên các nhánh đó không còn phục vụ flow hiện tại. Không xóa model Hero/serializer/helper animation đang được Crystal dùng. HeroAnimationData/ReplaySprite giữ; serializer ReplayArchive giữ phần payload gzip/hash có giới hạn, bỏ outcome replay/repository cũ; fixture model chuyển ra Tests/Fixtures, GameEditor bỏ nút tái tạo config pixel. Giữ migration/RetiredHeroDesk, GUID, config, save và archive trên đĩa.
- **Đã dọn build:**10 thư mục trong projectE, tổng52.530.693.004byte (~48,92GiB). Lệnh bao gồm5 bản ngoài projectC ban đầu bị auto-review từ chối vì chưa có quyền riêng; đã tiếp tụcE, hỏi rõ, người dùng cho phép xóa5bảnC sau khi giải thích các phase.5bảnC tổng57.572.806.432byte (~53,62GiB) đã xóa; chỉPlayer/BeforePlayer, giữreport/save và bản chuẩn đang chạy.
- **Kiểm chứng hiện tại:** core5068/Hero112/Editor235 PASS;115 hash protected Owned/config/scene/archive không đổi sau dọn source. Dependency closure từ Resources+hai scene hiện tại không trỏ vào danh sách xóa cuối. Quét rộng serialized assets phát hiện các prefab TreasureHunter chưa dùng cũng có reference vào Content; đang khôi phục toàn bộ packContent hậuCrystal từHEAD để giữ cả prefab dự phòng, không chỉ những prefab map đang sử dụng. Không xóa TreasureHunter world/joystick hoặc sourceCrystal.
- **Công cụ/lưu ý:** domain reload sau DeleteAsset làm hai log Pipeline ObjectDisposedException/HttpListenerResponse do response mất khi reload; compilationFailed=false, không phải lỗi gameplay, không clearConsole. Probe đầu giả định25Hero đều có portraitUI thất bại ởmed; HEAD đã chỉ có16portrait và không cómed, không do dọn. Probe cuối kiểm25animation và5portrait khởi đầu, catalog25/14/39; không tự mở rộng importportrait trong nhiệm vụ này. Unity build Windows đang chạy; chưa sửa điều kiệnBC7/BUG-056.
- **Bằng chứng:** Artifacts/ZatodLegacyCleanup/{plan.json,assets-deleted.json,tools-deleted.json,old-builds-deleted.json,external-builds-deleted.json,protected-before.json,integrity-after-source.json,editor-checks.json}. Restore source/asset từHEAD1f9cc6ce4a2bcdc2520c76c9fd7ea6b7f2ba5d3e; các file được sửa có bản nhỏ edited-before. Không tạo thêm backupfullPlayer.
- **Nghiệm thu D33 cuối22/11:** đã hoàn tất dọn nhánh trướcCrystal. Runtime không còn ArenaConnection/ArenaView/BattleSimulation20Hz/HeroAnimationPlayer; giữ shared model/animation và serializer payload hiện hành.55root asset/source legacy còn bị xóa sau khi đã khôi phục toàn bộContent/TreasureHunter hậuCrystal;57target tool/test/wrapper cũ được loại, model fixture chuyểnTests/Fixtures. README dẫn flowCrystal, không còn hướng dẫn chạy scene/cổng cũ. Quét tất cả GUID của asset đã xóa so với serialized assets còn lại:0reference mới gãy; Content không có diff nội dung vớiHEAD.
- **Build và network:** Succeeded327,59s/0errors/2warnings. Player kiểm tra217file/11.475.769.914byte(10,68764GiB), so bản chuẩn218file/11.545.739.776byte(10,75281GiB), giảm69.969.862byte=66,73MiB. Build đo trước phục hồi packContent nguyên bản; không coi là kích thước bảnD32 cuối hoặc mức giảm riêng đã nghiệm thu sau đổiLAN. Hai client port17998 quaCampaign/Arena/PvP, cùngdigest10171958501778039467/8inputs; relaunch resetải và giữ28cặpGUID/type. Player test đã xóa sau đo/kiểm, không giữ thêm11GB; server/client test được script dừng.
- **Dung lượng/handoff:** project97,8298→48,8461GiB; giảm48,9837GiB tính tổng file tại thời điểm đo, chưa xóaLibrary. CònLibrary khoảng26GiB,1bản chuẩn10,7528GiB, referenceCrystal7,63GiB vàgit1,92GiB.5build ngoàiC thu hồi thêm53,62GiB; toolchainAndroid đang cài/cập nhật bởiD32 có thể làm số trốngC biến động, không lấyfreeC làm kích thước dọnproject. Sau người dùng cho phép nhắn phối hợp, đã báo chatLAN/Android và nhườngEditor; không deploy/restartmain33916/client34800 để tránh chồngD32.
- **Integrity cuối:** protected115file, Owned/archive không đổi; chỉWorldMaps/town.txt được D32 song song sửa có chủ đích.993fileContent/meta đã khôi phục từHEAD bằngEditor, giữGUID. Helper ZIP ban đầu thiếuassemblyRoslyn, chưa chạy/mutate; đã chuyểnstagedtree vàCopy quaEditor. Không ghi raw hand-craftedYAML hoặc sửa vendor để che lỗi. Compile/UI/gameplayD32 và bảnbuild cuối thuộc phaseD32, không nhập vào kết quảcleanup.
- **Bằng chứng cuối:** Artifacts/ZatodLegacyCleanup/{build.json,player-size-comparison.json,content-pack-restored.json,content-dependency-restore-plan.json,protected-final.json,after-size.json,handoff.json}; network tạiArtifacts/ZatodPhaseChecks/network-20261122-201833/results.txt. Nếu tái diễn, tách current runtime/shared imports và prototype đã bỏ, kiểm mọi retained prefab kể cảngoàiResources; không xóafolder theo tên cũ nếuworld/joystick mới dùng. BUG-056430sheetkhôngnénBC7 vẫn chưa sửa theo phạmvi người dùng.

## BUG-058 — D32 Android module elevation và login/native NPC

- Ngày22/11/2026, đang triển khai. Lần install-modules đầu trả ELEVATION_CANCELLED, chưa tải/cài; sau user chọnYes trongWindows, retry đã cài đủAndroid/SDK/NDKr27c/JDK17/CMake. Editor nhận Android target supported=true, không cần restart ở lượt này. Evidence Artifacts/ZatodLanLoginChecks/android-install*.log.
- Editor commands trong lúc buildD33 đang chạy timeout trước khi được thực thi, không coi là compile lỗi. Sau phối hợp được người dùng cho phép và chatD33 nhườngEditor, Refresh(ForceUpdate) compile PASS; mànlogin đầu xuất hiện, Console groundTruth0errors. Core5075 assertions PASS gồm7kiểm tên guest; chưa nghiệm thu network/UI/mobile.
- Reviewlogin đầu thấyplaceholder tối trênnativebg_soldout nâu; chuyển sangbg_number parchment sáng trướcnghiệmthu. ThêmNameLabel update/richText=false để tên từserver được refresh an toàn khi peer đổi tên/reconnect, giữGUID.

- BUG-058 bổ sung visual: title đổi từfontregular sangbold sau khiTMPTextđã tạo bịsai glyph; probe runtime resetfontSharedMaterial sangmaterialfontđangdùng +ForceMeshUpdate cho title đọc đúng. Trướcprobe texture/material cùngtên nên chưa khẳng định atlasfilehỏng; sửa đúngcache/material củaText, giữassetfontnguồn. LANstandaloneđãPASS autodiscovery/UnicodeName/peerName/renameReconnect/GUID; endpointcùnghost có thể làvirtualNIC192.168.56.1, không coi đó là testphysicalWi-Fi. UI149checksPASS nhưng reviewảnh phát hiệntitle nên đangchạy lạivisual/buildsaufix.

- BUG-058 cập nhật: resetmaterial sửa đượcprobe tức thời nhưngtitlebold vẫnsai khi tạoViewmới/resize; chưa đủbằngchứng kếtluậnfilefont hoặcmateriallànguyênnhângốc. BảncuốidùngfontnormalCrystal sẵnđọcđược +TMPboldstyle cho title, không thayfontassettoànproject. Chạy lạicaptureở3tỷlệ trướcbuild; giữlogprobe để điều tra nếu cầnfontboldriêng sau.

- BUG-058 phục hồi sau mất điện: tablet USB nhận nhưngadb unauthorized; sau người dùngAllow lại trở vềdevice. PC Wi-FiDoubleMeow/IP192.168.0.5 giữ nguyên, server test/main không còn chạy sau reboot; Windows buildDesktop vẫn có reportSucceeded0errors. Code đang giữa chuyểnUIFormArena/PvP có lời gọiOpenReplays chưa hoàn thành, đã nối xong archive và cập nhậtUIChecks trướccompile; chưa coi build trước thayUI là bản cuối.

- BUG-058 kiểm chứng sau phục hồi22/11: hoàn tất methodOpenReplays còn dở do mấtđiện; Editor mở lại/compile không lỗi. UIFormation chung Arena/PvP86checks PASS (3tỷlệlogin, roster/filter/blankfields/PvPqueue/backcancel); Windows buildcuối0errors/2warnings/236,95s. Campaign/Arena/PvP standalone2clientPASS cùngdigest10498469602584259995/9inputs. MainserverDesktopREADY7788, firewall3rulecònEnabled; tabletADB=device. ĐangimportAndroidASTC6x6 riêng cho767sheet, cóbackupmeta trước; không sửasourcePNG/spriterect/StandaloneBC7 hoặc ghiAndroidđãnghiệmthu.

- BUG-058 bổ sung lỗi helper Android: BuildPlayerOptions.subtarget dùng chung (int)StandaloneBuildSubtarget.Player (=2), trong Android lại tương ứng MobileTextureSubtarget.PVRTC (=2). Log build phát cảnh báo PVRTC obsolete và reimport thêm dù767sheet có Android overrideASTC hợp lệ. Đã sửa helper chọn MobileTextureSubtarget.Generic(0) để tôn trọng PlayerSettings.Android.textureCompressionFormats=ASTC và các overrideASTC6x6, đồng bộ androidBuildSubtarget; Windows giữ Player. Lượt APK đầu đang chạy sẽ không được deploy; chờ kết thúc rồi compile/build lại đúng subtarget. Không hủy Editor hoặc server thật để tránh mất dữ liệu. Kiểm chứng cuối đang chờ. Tham chiếu enum chính thức: UnityCsReference/Editor/Mono/EditorUserBuildSettings.bindings.cs và XML API đi kèm6000.6.2f1.

## BUG-059 — Editor DX12 vượt bộ nhớ GPU khi build Android

- Ngày22/11/2026, đang điều tra/áp workaround; chưa đánh dấu đã sửa. Lượt APK đầu bị crash sau import, chưa có APK hợp lệ và chưa cài tablet.
- Nguyên nhân trực tiếp được log xác nhận: d3d12 Device removed/reset, CurrentUsage15.388.385.280byte vượt Budget3.280.702.660byte, Unrecoverable GPU device error; stack ở GfxDeviceWorker. Chưa chứng minh texture/callback cụ thể nào giữ toàn bộ VRAM, không quy chung do driver hoặc do tablet.
- Workaround đang thực hiện: build lại bằng Unity CLI batchmode -nographics với helper đã sửa subtarget ởBUG-058, tránh Editor cấp phát ảnh preview trên GPU. Không đổi renderer/graphics API của game hoặc xóa cache/data để che lỗi. Editor crash đã thoát; server26292/client24896 vẫn chạy, TCP7788 và kết nối giữ nguyên.
- Evidence: Artifacts/ZatodLanLoginChecks/android-first-crash.txt, crash folder Crash_2026-11-22_160516281. APK headless cần build/install/kiểm chứng thật trước khi đóng lỗi.

- BUG-058 nghiệm thu22/11: helper Android cuối dùng Generic(0) + PlayerSettings ASTC, report xác nhận Subtarget0/ASTC, log mới0 cảnh báo PVRTC. Headless APK Succeeded0 build errors/33 warnings, file561.661.890byte, aapt đúng ARM64/API26–34/appid/quyền mạng. ADB daemon khởi động lại sau build khiến unauthorized; người dùng Allow lại, install-r Success. Native Android đã vào Town, thấy peer Windows và mở Inventory; TCP xác nhận192.168.0.2→192.168.0.5:7788, không adb reverse. Không ghi đã thử Android thứ2 hoặc battle Android. Người dùng đang thao tác tablet nên không gõ đè tên hoặc cưỡng bức restart app.10 file sở hữu cũ giữ nguyên. Evidence: android-build.json, output-sizes.json, physical-connections.json, tablet-install.log, tablet/* và owned-final.json trong Artifacts/ZatodLanLoginChecks.
- BUG-059 workaround đã kiểm chứng22/11: CLI build tự dùng -batchmode/-nographics; Null Device được log xác nhận, APK thành công, không lặp crash. Chưa sửa tận gốc việc Editor GUI giữ VRAM. Không truyền -nographics qua --args cho unity build hiện tại vì CLI quản lý sẵn và từ chối cờ trùng. Có Scripts/Build-ZatodAndroid.ps1 yêu cầu đóng Editor trước build, tùy chọn -Install giữ data; cú pháp PowerShell PASS. Đang mở lại Editor bằng -force-d3d11 cho phiên làm việc, không đổi graphics API của player.

## BUG-060 — Android log thiếu AssetPackManager lúc khởi động

- Ngày22/11/2026, đang theo dõi, chưa sửa. Log riêng PID app28998 ghi java.lang.ClassNotFoundException com.google.android.play.core.assetpacks.AssetPackManager. App vẫn chạy, vào Town/LAN và mở Inventory; chưa thấy fatal AndroidRuntime từ PID này. Chưa xác định nguồn gọi, không coi là nguyên nhân mất input hoặc lỗi mạng. Lúc đọc screenshot đầu, người dùng đã nhập tên/vào game nên ô tên không còn nhận text của lượt automation; không sửa input dựa trên ảnh cũ.
- Bản hiện tại là single APK, không triển khai AAB/PAD. Không thêm plugin/dependency chỉ để che log khi chưa có bằng chứng ảnh hưởng. Cần xem lại nếu dùng Play Asset Delivery hoặc có lỗi load asset cụ thể. Evidence: Artifacts/ZatodLanLoginChecks/tablet/app-errors.log; tablet/town-two-players.png quan sát hai player, tablet/inventory-gears.png quan sát Inventory.
- Bàn giao D32 cuối22/11: Editor đã mở lại và xác nhận Direct3D11/Android target, stopped, compilationFailed=false, scenes sạch, auto_tick=false. Server7788 và client Windows/tablet được giữ hoạt động; handoff.json/resume-state.json ghi giới hạn test rõ ràng. Build Android tương lai dùng script headless khi Editor đã đóng. Không coi việc mở lại DX11 là đã sửa gốc lỗi GPU DX12 hoặc đã nghiệm thu hai Android.


## REVIEW-007 — Mức sẵn sàng build iOS, chỉ khảo sát23/11/2026

- User xác nhận MacminiM4/Tahoe26.6.2 và iPhone11/iOS27, chưa Apple Developer trả phí. Đã đối chiếu tài liệu Unity6.6/Apple; Mac phù hợp yêu cầu macOS của Xcode27.2. Chưa kiểm trực tiếp Mac, chưa cài/switch target/export/ký/cài app.
- Kiểm filesystem thấy iOS support chưa có; helper chỉ Windows/Android, iOSBundleID/signing trống, quyền/plist/entitlement discovery iOS chưa có. 767sheet có Android override, cần iPhone override riêng; đây là khoảng trống trước triển khai, chưa phải lỗi runtime đã chứng minh trên thiết bị.
- Nguồn Mirror cho thấy client gửi IPAddress.Broadcast. Apple yêu cầu local-network purpose string và entitlement cho raw multicast/broadcast; entitlement thuộc managed capability cần Apple cấp. Không khẳng định free signing tự có quyền hoặc trả phí sẽ tự được duyệt. Đề xuất unicast tạm/Bonjour hệ thống/giữ broadcast có entitlement, chưa chọn và chưa sửa D32.
- Build sẽ cần kiểm Metal/IL2CPP và LAN/digest trên thiết bị thật. Giữ kinh nghiệm BUG-058/059 về subtarget/nén riêng và headless; không áp quy trình ADB hoặc tham số Android cho iOS. Source Assets+Packages+ProjectSettings đo khoảng1,433GiB; không cần mang Library/build cũ để phát triển trên Mac.
- Report và nguồn chính thức: docs/zatod-ios-readiness-review.md. Lượt này chỉ cập nhật tài liệu khảo sát; không phát sinh build hoặc thay đổi runtime/config.
- Bổ sung23/11: người dùng đã chọn IP trực tiếp cho test iOS đầu, cập nhật ngoại lệD32 trongDesign; discovery Windows/Android giữ nguyên. Làm rõ DHCP có thể đổi IPv4 PC host khi đổi mạng, cùngLAN không thay bước biết địa chỉ server. Đề xuất ôServer IP sửa/lưu được để không rebuild; hiện chưa có ô này và chưa sửa runtime. Không cần clone toàn bộUnity project sangMac nếu chỉ chuyểnXcode export để ký/build. Đây là làm rõ thiết kế, không phải lỗi kết nối đã tái hiện hoặc bản iOS đã nghiệm thu.
- Tiếp23/11 sau lệnh thực thi: đang thêmServer IP form chung, tựdòđiềnAndroid/desktop, nhập tay vànhớIP thành công; iOS chặnbroadcast discovery trongnativeplayer. ĐãcàiiOS Build Support6000.6.2f1 bằngCLI; helperARM64/Metal/landscape/ASTC6x6 vàpostprocessLocalNetwork đangđượcbuild/exportheadless. KhôngresetOwned/GUID/configgameplay. Restorepointsource/settings: Artifacts/ZatodIosChecks/Before; chưaghi đãnativecompile/ký/càiMac/iPhone. Hướngdẫn: docs/zatod-ios-build-and-install.md. Kếtquảkiểm sẽbổsung sauexport.

## BUG-061 — Pipeline run --command lỗi phản hồi khi khởi động Editor để kiểm Server IP

- Ngày23/11/2026, đang kiểm workaround. `unity run --command "script eval"` mở Editor rồi trả COMMAND_FAILED/Invalid response format from Pipeline server; log cóObjectDisposedException ởHttpListenerResponse củaPipeline quaPOST/api/exec và descriptor viết lại khireload. Chưa xác nhận nguyên nhân sâu; không coi là lỗiTCP/gameplay hoặc lỗiXcode export. Chưa có kết quảUI/network từ lượt này.
- Đã đọc lại hướng dẫnCLI vềlifecycle/ready và kiểmSafeMode: không có lỗiC# Zatod tronglượtbuild, Editor test đãthoát; khôngdừngEditorTreasureHunter. Workaround đangthử: mởheadless/nographics qua`unity open --batchmode --until-ready`, chờổnđịnh rồi gửi lệnhkiểm riêng. Không tựgửi log choUnity.
- Evidence: Artifacts/ZatodIosChecks/login-runtime.log, CheckAll.cs. iOS export đãSucceeded0errors/6warnings, ZIP774MiB CRC PASS vàexport-audit.json PASS độc lập với lỗi công cụ này.
- **Workaround đã kiểm23/11:** tách`unity open --batchmode --until-ready` vàđợiimport/domainreload ổnđịnh, sauđó gọi`unity command script eval` trênđúngproject. Editor32208 khôngGPU đãchạyPASS27UI+7TCP/UDP/reconnect. ĐãđónggracefulEditor test, bỏsceneUntitled chỉchứaobjecttest; khôngsửa/lưu scenegame. Khôngcoi lỗigốcPipelineđãđược sửa. Khônggửi log raUnity.
- Lưuý harnessEditor: objectinactive khôngnhận`SendMessage Update`; épRectTransform cậpnhật vàgọihàmUpdate bằngreflectionđểđo. Mirror.InitReadWriters đượckhởi tạo tựđộng ởPlay/Player nhưngkhôngtựchạy ởEditMode; bộkiểm cầnkhởi tạoGeneratedNetworkCode trước thửdiscovery. Các lỗiNoWriter/SendMessage banđầu làharness, khôngváMirror/gameđểchechúng. LượtPASS cuối khôngcóconsoleerror mới saucursor19. Evidence: endpoint-editor.log, login-checks.json, network-checks.json; server test17998/47998 và dữliệuNetworkData riêng đãdừng. Kho/configthật36file giữhash.
- Review6warnings củaexportiOS: Mirror UAC0007 vềAssembly.Location, TMP shaderpragma debugdeprecated và4IL2CPP thôngbáo táchmethodlớn sangcpp riêng. Chưađổi thưviệnthứba/shader chỉđểxóa cảnhbáo. Nativecompile/ký/càiiPhone vẫn cầnMac.
- Bàn giao23/11: APKAndroid mớiSucceeded0errors/6warnings,561.668.262byte; đúngARM64/IL2CPP/appid/INTERNET vàcóchuỗiUI mới trongmetadata. aapt/apksigner/CRC PASS; dùngSDK build-tools36.0.0 đangcài, khônggáncứng34.0.0 chỉvìtargetSdk34. ADB khôngcóthiếtbị nênkhôngcài/clear/uninstall app. ZIPXcode811.635.589byte/CRC PASS; 767sheet + 36filesave/server giữdữliệu, cácbảngResources/Data khôngcógitdiff. LogCLI Android ghiLicensingClient failedvalidation/ignoring nhưngsauđóbuildSucceeded/exit0; chưacoilàlỗibuild hoặcchủđộngđổi/activate license. Evidence: android-delivery.json, android-signature.txt, android-badging.txt, xcode-package.json, export-audit.json, handoff.json. Khôngbáođãnativecompile hoặcchạytrêniPhone.

## BUG-062 — Xcode GameAssembly bị User Script Sandboxing chặn IL2CPP

- **Ngày:**23/11/2026. **Trạng thái:** đã sửa helper và kiểm cấu hình trên bản sao; chờ người dùng xác nhận native build Mac sau sửa. Không ghi đã build/cài thành công trên iPhone.
- **Triệu chứng người dùng cung cấp:** targetGameAssembly/ReleaseForRunning-iphoneos có4 báo lỗi: mkdir deny file-write-create cho DerivedData/.../artifacts và PROJECT_DIR/Il2CppTempDirArtifacts; il2cpp deny file-read-data cho deploy_arm64/il2cpp vàlibhostfxr.dylib.
- **Bằng chứng/nguyên nhân:** log xác nhận sandbox của build script đang chặn các đường đọc/ghi. Bảnpbxproj Windows đã giao có targetGameAssembly và script thực sự dùng những đường này, nhưng chưa đặt ENABLE_USER_SCRIPT_SANDBOXING=NO rõ ràng. Apple mô tả settingYES sẽ chặn input/output chưa khai báo. Chưa đọc trực tiếp effective setting trênMac hoặc xác nhận vì saoXcode27.2 bật/inherit sandbox, không quy lỗi cho account, POSIX permissions hoặc thiếuSDK từ log này.
- **Sửa/workaround:** trongMac, TARGETS→GameAssembly→Build Settings→All→User Script Sandboxing=No choDebug/Release/ReleaseForRunning/ReleaseForProfiling, Clean Build Folder rồiRun. HelperZatodIosBuild.SetLocalNetworkPermission gọiConfigureGameAssemblyScripts, dùngPBXProject.SetBuildProperty để đặtNO cho4configs riêng target này. Không đổi Team/BundleID, entitlement/app sandbox hoặc bảo vệ macOS. Không sửa ZIP cũ đã giao để tránh mâu thuẫnchecksum; project trênMac chỉnhsettingmộtlần, lầnexporttiếptheo sourcehelper tựápdụng.
- **Kiểm chứng:** chạy chính thân hàm mới vớiUnityEditor.iOS.Extensions.Xcode.dll từUnity6000.6.2f1 trênbảnsaopbxproj; 4configs=NO sauwrite/read, idempotence PASS; Team/BundleIDs củaUnity-iPhone/UnityFramework khôngđổi. Chưa reexporttoànbộgame hoặc chạyxcodebuild trênMac. Evidence: Artifacts/ZatodIosChecks/SandboxFix/{Program.cs,result.json,project.pbxproj,ZatodIosBuild.before.cs}. Guide: docs/zatod-ios-build-and-install.md.
- **Nếu tái diễn:** kiểm đúngtargetGameAssembly vàconfig ReleaseForRunning (không chỉ Debug), xemsettinginherited/overridden; nếu lỗi mới làPermission denied/missingfile khôngcóSandboxdeny thì chẩn đoán riêng, không tựchmod/xóaDerivedData hoặcđổi signing. BộtestSDK dùngGetUnityMainTargetGuid/GetUnityFrameworkTargetGuid để đọc main/framework; TargetGuidByName chỉdùngtargetGameAssembly.

## BUG-063 — UnityFramework header bị Module Verifier báo lỗi

- **Ngày:**23/11/2026. **Trạng thái:** đang kiểm workaround trênMac; helper đã sửa và kiểm cấu hình bằngSDK, chưa có xácnhận nativebuild thànhcông.
- **Triệu chứng:** sau khi người dùng đổi sandboxtheoBUG-062, ảnhXcode báoUnityFramework13issues: AppDelegateListener.h double-quoted LifeCycleListener.h/expectedangle-bracketed, expectedatype vàFoundation.NSString chưaimport; RedefinePlatforms.h yêu cầuUndefinePlatforms.h; umbrellaUnityFramework thiếuAppDelegateListener/RedefinePlatforms/UndefinePlatforms/UnityViewControllerListener; syntheticmoduleTest buildfailed.
- **Đối chiếu:** Apple mô tả đúng double-quotedinclude vàumbrellaheader lỗi từModule Verifier. Mẫuảnh khớp rất rõ verifier, nhưngchưa córawbuildlog/Maceffectivesettings đểkếtluậnmọilỗi đều từVerifyModule. Nguồnexport chứaAppDelegateListener.h cóincludequote vàheaderkhôngtựimportFoundation; pbxprojgốc chưađặtENABLE_MODULE_VERIFIER rõràng. Khôngsuy raC#gameplay, account hoặcasset bịlỗi.
- **Workaround:** TARGETS→UnityFramework→Build Settings→All→Enable Module Verifier=No cho4configs, Clean Build Folder rồiRun. Chỉtắt lượtkiểmframework, giữCLANG_ENABLE_MODULES vàwarnings-as-errors hiệncó. Khôngchỉnh loạtgeneratedheader hoặcđổi signing. HelperZatodIosBuild.ConfigureUnityFrameworkModules dùngGetUnityFrameworkTargetGuid vàSetBuildProperty(...ENABLE_MODULE_VERIFIER,NO); gọi trongpostprocess cùngBUG-062.
- **Kiểm chứng:** thực thi chínhhàmhelper vớiUnityEditor.iOS.Extensions.Xcode.dll6000.6.2f1 trênbảnsaopbxproj;4configs UnityFrameworkverifierNO vàGameAssemblysandboxNO, write/read/idempotence PASS. Team/BundleIDs/CLANG_ENABLE_MODULES/GCC_TREAT_WARNINGS_AS_ERRORS khôngđổi. Chưa reexportZIP hoặcbuildMac; cầnngười dùngxácnhận. Evidence: Artifacts/ZatodIosChecks/ModuleVerifierFix/{Program.cs,result.json,project.pbxproj}; ảnhcodex-clipboard-e2158612-070a-4def-9288-7f822d558d96.png trongmessageuser. Guide: docs/zatod-ios-build-and-install.md.
- **Nếu vẫn lỗi:** kiểm effectiveENABLE_MODULE_VERIFIER ởUnityFramework/ReleaseForRunning; xemcommandgây lỗi cóVerifyModule hayCompileC/CompileSwift thật. Compilererror ngoàiverifier cầnchẩnđoán riêng, khôngcoiNo làđãsửahết hoặcchépheader tùytiện vàoumbrella.

## REVIEW-008 — Khoảng trống trước phase Tím/PvP và presentation Crystal

- **Đối chiếu bổ sung24/11 sau phản hồi người dùng:** chi tiết skill/hook đợi codeD35; cơ chế STR/AGI/INT tạm bỏ khỏiD34, không còn yêu cầu chốt ánhxạ ngay. Mapchương3–8 xanh/tím xen kẽ, configải nguồnCrystal theo ngoại lệZatod; PvPrealtime free40Hero Tím. Artifacts chỉ làoutput/evidence, phụthuộcmappinglocal ởhelper làgiớihạn cần sửa khi triểnkhai, không là nguồndesign hoặc đầu vào bắtbuộc hợp lệ chohandoff.
- **Feelingcombat, khácbiệt xácnhận bằngcode24/11:** Crystal `unit.hurt` chuyểnDamaged/Hurt, trongkhi Zatodinterrupt vềIdle; buffnguồn cóShader/EffectZorder/ActorScale màmodel/presentationZatod chưa giữđủ; stage đặtmọieffect2000-Y trênactor1000-Y. Corechuyểnwave ngay bằngSupply/SpawnWave, chưa có nhịpchạy/wait/Cheer nhưđường client nguồn. HUD códamage/heal thật nhưngmotion/font/textmiss/immune khác; chưa cóbattlemusic flow vàchưađọc AudioCues trongvòngeffect (114effectsets có15cue). Đâylà khoảngtrống so với nguồn đãđọc, chưa làlỗi đãtáihiện hoặc đãsửa trênthiếtbị.
- **Bằngchứng/giớihạn24/11:** source `actor.lua`, `entity.lua`, `unit.lua`, `buff.lua`, `popup.lua`, `battle_scene.lua`, `battle_sceneui.lua`, `battle_engine.lua`, `sound.lua`; codeStage/Sprite/Hud/PresentationState/Simulation/SkillEffects vàAnimationSet. Quét40fileHero khôngthấycallrung/zoomtrựctiếp; chưabaoquát mọihelper/assetevent hoặcencounter, khôngtựthêmrungchung. Chỉđọcsource/code/config, chưa chạyAPKCrystal/Unity/build/testthiếtbị hoặc chấm mứcgiống quaA/B. Report `docs/crystal-battle-presentation-review.md` cậpnhật24/11 phânbiệt nềnđãcó/thiếu/đềxuất; giữBUG-001/048 làcácsửa đãkiểmchứng, fade vẫnchưaduyệt. BảngCanvas21/11 đượcđánhdấu lịch sử trướcD25, tránh mởlại refactorđãhoànthành.
- **Workaround/quy trình:** khi cólệnh thựcthi, nhậnbaselineD35 mới, đốichiếu từngkhoảngtrống rồi triểnkhai theo nguồn vàngoạilệ đãchốt. NếuđụnglogicHurt/transition phải kiểmRNG/timing/rules/checker/replay; eventview khôngrandom/thêmhit hoặcghiOwned. Lượtnày chỉsửaDesign/review/ChangeLog, khôngsửa runtime/helper; chưađánh dấu khắcphục.

- **Rà lại 24/11/2026, chỉ khảo sát trước triển khai cả5 mục D34:** checkout vẫn có25Hero/14Monster/142item/131skill/52buff, 2chương/39ải/117wave, rank tớiBlue/3slot. Người dùng giả địnhD35 hoàn thành để bàn phase, chưa xác nhận nghiệm thuD35 trên checkout này. Không sửa runtime/import/build.
- **Giới hạn helper xác nhận thêm:** `Import-ZatodChapterTwo.py` bắt buộc đọc mapping trongArtifacts bịignore rồi sinh lại `ZatodContentIds.cs`; clone cófullreference vẫn có thể thiếu đầu vào. `Import-CrystalConfig.py` lọc rank1–4/Unlock<=4, gán RankId rỗng cho spawn rank ngoài phạm vi, chưa tạo modelEvoD35. Cần sửa resolver/giới hạn và merge bảo toàn alias/configD35 trước import mới; không chạy helper để dò vì có ghi file. Đây là giới hạn công cụ phase trước, chưa có ca importerD34 đã chạy lỗi hoặc đã sửa.
- **Nguồn skill mới xác nhận:** `battle/heroes/OD.lua` có chuyểnINT và ultimate kiểm MainAttribINT; `Sil.lua` có nhánhEvo chuyểnINT; `Naga.lua` tạoNagaMirror `_tid=145` từpassive. Cần lọc nhánh active rồi chốt ánh xạ stat/dependency, không tự coi AP thay INT đã được duyệt. UI chọn đội và server queue/Pair đều dùngHeroDesk/session.Team, cần đổi đồng bộ projection và xác thực preset.
- **Cách xử lý/bằng chứng:** ghi lưu ý và chi tiết còn mở tại mục6 `docs/zatod-purple-pvp-phase-review.md`; cập nhậtD34 về phạm vi cả5 mục. Đã đọc helper, code và config, đối chiếuD05/D08/D21/D26/D34/D35, BUG-056/059. Chưa kiểm parity/farm/mobile hoặc đánh dấu sửa; khi triển khai nhận baselineD35 mới, dùng profile test, giữ Owned/replay và không áp config trướcD35 đè Evo/save.

- **Ngày:**23/11/2026. **Trạng thái:** xác nhận bằng đọc source/config, chưa kiểm live hoặc sửa runtime. Yêu cầu hiện tại là khảo sát phase, không phải lỗi mới được người dùng báo tái hiện.
- **Hiện trạng:** config25 Hero/14 Monster/142 item/131 skill/52 buff,2 chương39 ải117 wave. PvP UI và server lấy HeroDesk sở hữu; chưa có pool40 Hero Tím độc lập theo yêu cầu mớiD34. Account mới cấp5 Hero, không suy25 định nghĩa thành25 Hero sở hữu mỗi account.
- **Giới hạn mở Tím xác nhận:** importer lọc rank1–4/skill Unlock<=4; cần rank5–7 và skill/hook Tím. Một số passive/aura mới dùngSTR/AGI/INT nhưng runtime Attribute mapping không có đóng góp sang stat trực tiếp; phải chuyển đúngD05 khi port. Đây là thiếu hỗ trợ cho nội dung sắp mở, chưa gọi là bug của skill đã có. Promote chưa có rollback/retry receipt theo REVIEW-002 và UI mới chưa nối Promote.
- **Khác biệt presentation xác nhận từ code:** ZatodBattleStage/ZatodBattleSprite sample Death tới frame cuối, chưa có lịch fade/hide xác; core có ManualStartup nhưng BattleStage chưa tint nền/actor. Không nhầm vớiBUG-048 đã sửa clock Death/effect sau kết thúc trận. Source Crystal actor.lua:331 mặc định chờDeathDuration+2s, fade1s rồi ẩn; unit triệu hồi/DeathWithEffect/giữ xác có ngoại lệ. battle_scene.lua:823 đổi nềnRGB96 khi freeze, entity.lua:66 tint×0,4, caster unfreeze riêng; skill.lua:837 trả sáng ởAttack frame hoặc finish/interrupt/death. Không phải mọi skill hoặc phủ đen toàn UI.
- **Hướng xử lý khi được yêu cầu triển khai:** pool PvP tách dữ liệu sở hữu, server kiểm preset; audit đủ dependency/logic bậcTím và Promote transaction; nếu nối presentation phải giữ timing damage và replay/pause/seek/freeze lồng. Chưa chọn timer Unity hoặc thay simulation trong lượt khảo sát.
- **Bằng chứng:** `docs/zatod-purple-pvp-phase-review.md`, `Artifacts/ZatodPurplePhaseReview_20261123/review.py` và `audit.json`. Đã đọc AnimDuration của5 Hero đầu và thời lượng bake tương ứng. Coverage UI reward/recipe cho thấy chương7 đủ loại để vàoTím, chương8 đủ ôTím theo các tập Hero khảo sát; đây không phải xác nhận loot backend Crystal hoặc pool Zatod. Chưa chạy Unity/build/thiết bị; không ghi đã sửa hoặc đã đạt parity.
- **Nếu triển khai sau:** cập nhật mục này bằng bằng chứng runtime, giữ khác biệt giữa source quan sát, giả thuyết và lựa chọn thiết kế; không dùng việc tăng số HeroDefinition làm bằng chứng mọi skill đã đúng.

- **Bổ sung khảo sát23/11 sau câu hỏi về level skill:** HeroData.Skills và HeroBattleFactory đã lưu/đọc level từngslot; CreateHero hiện seedLv1, chưa có giao dịch/UI nângskill. Không gọi phần này là chưa có engine skill. Source PvP kingsPvpHeroMgr.lua:74 đặt skill bằng levelHero/basic slot5=1; Init Level là seed theo skillgrouptable.lua, không phải công thức cap trừoffset. Bộ5 đầu cóInit1/1/21/41. SkillDetail nguồn giới hạn nâng tớiHeroLevel và dùng vàng/nguyên liệu theoSkillLevels; bước35→36 bắt đầu cần sách,6 loại cho đườngLv60 chưa có trongItems active. Đây là dependency của phạm vi đề xuất, chưa tự import/đổi pool/Owned.
- **Migration slot mới xác nhận từ cấu trúc:** HeroCatalog.ValidateHero đòi ownedSkills.Count bằng SkillSlots.Count và đủ từngslot; ZatodSaveMigration chưa bổ sung slot. Khi thêm slot4 vào config, cần migration thêm slot còn thiếu theoSlotId trước validate, giữ level các slot cũ. Đây là lỗi tương thích có thể phát sinh khi mở rộng nếu bỏ qua migration, chưa xảy ra trên config hiện hành và chưa giả lập lỗi vớiOwned thật. Cần kiểm load save3slot sau khi triển khai, không reset Hero hoặc replay.
- **Quyết định mới cùng ngày:** D34 đã nhận đồng ý chương3–8, pool40 và presetLv60/3sao/Tím chưa mặc đồ hiện tại, đủ thành phần chương mới và tối nền; chưa cần lưu tiến trìnhải. Hệ nângskill/Promote đang bàn, chưa có lệnh sửa runtime. Báo cáo khảo sát được bổ sung nguồn và khuyến nghị tương ứng.

- **Khảo sát sâu23/11 cho phaseD35:** đã xác nhận toàn bộ25 Hero active có Init Level1/1/21/41 theo4slot chính; cùng25 Hero/rank1–7 đều không có Init1..6 item khác0. Source Promote kiểm đủô và chưa maxrank, nútBase kiêm QuickEquip/Promote; nhánhclick chưa thấy trừGold riêng. Không suy backend chắc chắn miễn phí hoặc tự cấp đồrankmới. GiữD08 ledgerGUID, không chép tổngUnitRank rồi cộngtrùng đồ hấp thụ.
- **Dependency mới xác nhận:** SkillEvo xuất hiện từmốcLv35, thêm nguyên liệu và patch hiệuứng, khác level skill thường và khác HeroPromote. Với bộ25 tớiTím có các mốc35..80; tớiLv60 dùng3 loại20019/20020/20021 ngoài6 sách thường. Trước đây mới chỉ ràSkillLevels, chưa đủ bằngchứng gọi chi phí nângskill Crystal chỉ gồm6 sách. Nếu chọnhoãnEvo thì phải ghi là giới hạnphạmvi cóchủđích, không báoparity đầyđủ.
- **Gate/cap và giao dịch:** UI nguồn yêu cầuaccountLv7, chặn ởskillLv80 và không nângvượtHeroLevel; dùngconfig khi chuyển, không suy sốdòng bảngthànhcap. Sourceclient cóđường dựđoánlevel/tài nguyên, không sao chép thành quyền quyếtđịnh của clientZatod. Promote hiện cần mởrollback đủRankId/Equipped/Absorbed/Skills/Revision vàreceipt, không dùngcheckpoint chỉInventory để khẳngđịnh rollback toànHero.
- **Trạng thái:** D35 đãchốt ưu tiên hệskill/Promote trướcnội dung; chi tiếtEvo/cost/gate/migration/QuickEquip đangđềxuất. Chưa sửa/kiểm runtime. Báo cáo `docs/zatod-skill-promote-review.md`, evidence `Artifacts/ZatodSkillPromoteReview_20261123/audit.json`; configđược băm để đốichiếu, không thửlỗi trênOwnedthật.

- **Làm rõ tiếp23/11 theo phản hồi:** source Evo Coco ultimate group10 ởLv35 thêm buff10000104 cho đồng đội còn sống khi Attack frame (Time9/PIMU20/MIMU20); Lv50 thayPlusRatio1,4→1,6; Lv70 tăngstun cấu hình5s trước tenacity. RuntimeSkill.create suyEvo từlevel, không phải slot thứ5. Đã kiểm cảSkillEvo/Buff/Coco hook, không chỉ dịch mô tả. UI `herodetailNormal.lua` dùng mộtDGButton btn_up dướibg_equip vàlabel_up là con; controller đổiQuickEquip/Promote cùngnút, xác nhận vịtrí người dùng nhớ.
- **D35 đã được điều chỉnh:** phase nângskill chỉthuvàng, bỏphísách; gatePlayerLv7 đểphase sau; STR/AGI/INT vẫnchưa trởlại. QuickEquip/Promote dùngchungnút đượcđồngý. SkillEvo vàcách điều chỉnh levelskill trongsavecũ vẫnđanggiảithích, chưa tự thayOwned. Mục6 được minh họa thànhhai phần: bổsungslotthiếu khiđọcsavecũ và save/retry chỉxửlý giao dịch mộtlần. Chỉcậpnhật tài liệu, chưa sửa runtime hoặc xácnhận đã kiểmnetwork.

- **Kiểm lại UI và modelEvo23/11:** theo yêu cầu người dùng chưa chắc về chungnút, đã đọc lại layout btn_up/label_up, checkHeroUpgrade đổi cùnglabel và doClickUpgrade mặcđồ rồireturn trướcPromote; xác nhận cùngnút từcảlayout vàhandler. Người dùng muốngiữSkillEvo và đồngý mục6. Đềxuất model: config SkillDefinition.Evolutions, save tiếp tụcSlotId/Level, runtime suy mọimốcđủlevel từsnapshot; không lưuEvoLevel song song. Đây là đềxuất schema, chưa sửaC#/JSONruntime hoặc test.
- **Lưu ý snapshot khi triểnkhai:** phải deep-copy/serialize đủEvo vàbuff/effectphụthuộc vào dữliệu trận; không suyEvo của replaycũ từconfiglive. Apply modifier vào bảnruntime của skill/caster, không sửa configbuffchung. Model hiệnchưa cóEvo nên đây là yêu cầu tươngthích khi bổsung, không phải lỗi đã táihiện hoặc đãsửa. Chi tiết và trạngthái ởD35/`docs/zatod-skill-promote-review.md`.

## REVIEW-009 — Tài liệu brainstorm chưa đủ rõ để bàn giao agent khác

- **Ngày:**23/11/2026. **Trạng thái:** đã chỉnh tài liệu và kiểm tra; không phải thay đổi runtime.
- **Triệu chứng:** reviewD35 còn xen các câu chưa duyệt/đề xuất cũ về sách, PlayerLv7, hoãnEvo và model dù đã được người dùng chốt lại; D34 cũng giữ trạng thái đề xuất cạnh phạm vi đã đồngý. Chưa có phase-planD35 riêng, evidence chủ yếu trỏ vàoArtifacts local.
- **Nguyên nhân xác nhận:** nội dung được nối tiếp theo các lượt brainstorm, thiếu tách quyết định hiện hành/nguồn khảo sát/checklist. `.gitignore` loại cả `Crystal Legend/` và `Artifacts/`, nên chỉ clone Git không đem theo source/evidence được link.
- **Cách xử lý:** tổng hợp D34/D35 sạch trongDesign, ghi workflowD36 vàAGENTS; tạo `docs/zatod-skill-promote-phase-plan.md` chứa phạm vi, hợp đồng model/UI/server, migration, trình tự và tiêu chí nghiệmthu; viết lại hai review thành bằng chứng nguồn/phạm vi nội dung tươngứng. Trích `docs/reference/zatod-skill-promote-source.json` đi theoGit: baseline25Hero/75slot,300mốcEvo nguồn gồm cảslotTím khóa,79bướcgiávàng vàhash38source. JSON không thay thế fullLua/art, không chứaOwned/profile. Cap80 đã được người dùng đồngý khi kết thúc brainstorm, ghi vàoD35 vàplan.
- **Kiểm tra:** linkMarkdown củaAGENTS/Design/ba tài liệu phase đều tồn tại; D34/D35/D36 mỗiheading mộtlần; JSON parse được và sốdòng khớp. `git diff --check` PASS; configruntime giữSHA256 theo baselineaudit. Báo cáo `Artifacts/ZatodDocsHandoffReview_20261123/validation.json`. Chưa chạyUnity/build/thiếtbị, chưa commit/push hoặc giaoagent thựcthi.
- **Lưu ý:** giao agent triểnkhai bằngAGENTS→DesignD35→phase-plan, review chỉ làm bằngchứng. Agent ởclone/worktree khác phải kiểm source/artlocal, không coi việc cóJSONaudit là đã đủ mọihook/assets. Những mốc triểnkhai19/11 trongDesign được đánh dấu lịch sử, không áp lại54wave/bypasscraft/nonstackUI như yêu cầu mới.

## BUG-064 — Sideloadly từ chối chữ ký UnityRuntime.framework trong IPA

- **Cập nhật nghiệm thu từ người dùng 23/11/2026:** người dùng xác nhận Android, iOS, Windows và server đều đã ổn, chuyển sang bàn phase tiếp theo. Ghi nhận iOS hoạt động theo xác nhận này; agent chưa chạy lại cài/chạy thiết bị hoặc xác minh riêng mọi bước workaround. Giữ bằng chứng và giới hạn điều tra nguyên nhân bên dưới; các câu chờ nghiệm thu là trạng thái trước xác nhận mới.
- **Ngày:** 23/11/2026. **Trạng thái:** đã tạo workaround IPA và sửa helper, kiểm cấu trúc PASS; chờ ký/cài lại trên iPhone. Chưa đánh dấu lỗi thiết bị đã sửa.
- **Triệu chứng:** người dùng gửi log Installation failed 3892346881 / ApplicationVerificationFailed, `0xe8008001`, đường dẫn `Payload/ZatodLegend.app/Frameworks/UnityRuntime.framework`. Dòng “I think we should just retry!” là thông báo công cụ, không chứng minh retry sẽ giải quyết lỗi.
- **Đã xác nhận:** IPA `C:/Users/tinnq/Downloads/ZatodLegend.ipa` (567138378 byte, SHA256 475745cbda751dc647bd5f233dded58d6011708ba89259f9d8610d1b0ae892b7) nhúng UnityRuntime.framework. PBX export có UnityRuntime ở Embed Frameworks main app, liên kết ở UnityFramework. Mach-O chính/app framework không có LC_LOAD_DYLIB tới UnityRuntime; Unity UUM-151138 xác định UnityRuntime là build-time artifact và bản sửa mới không nhúng nó. Framework đóng gói chứa binary FAT arm64/MH_DYLIB 33136 byte cùng signature resources; không gọi binary trong IPA là static archive vì binary sau copy có dạng khác source library. Chưa chứng minh toàn bộ nguyên nhân nội bộ chữ ký 0xe8008001, chưa kết luận tài khoản/chứng chỉ hỏng.
- **Xử lý:** Scripts/Repair-ZatodIpa.py tạo file mới chỉ bỏ 10 entries UnityRuntime.framework; từ chối ghi đè input/output và từ chối nếu hai binary chính có dependency động tới framework. Giữ nguyên byte của 44 entries khác và Bundle ID; Sideloadly phải ký lại bằng Apple ID Sideload. Không gỡ app, reset save/GUID, đổi account hoặc thu hồi certificate. File cho người dùng: Artifacts/ZatodIosChecks/SigningFix/ZatodLegend-SigningFix.ipa; SHA256 59f5ebfa08fe3fcaaf68b9329b3438c000bbf3337db941dfd9607c7c1506cb02.
- **Phòng tái diễn:** helper Unity/Assets/Zatod/Editor/ZatodIosBuild.cs thêm ConfigureUnityRuntimeEmbedding, RemoveFileFromBuild chỉ main target, giữ UnityFramework linker reference và UnityFramework embed. docs/zatod-ios-build-and-install.md sửa bước đóng gói: chuyển artifact còn sót ra ngoài Payload của bản sao trước zip; không xóa file nguồn/framework cần để build.
- **Kiểm chứng:** input/output ZIP đọc CRC và SHA256 mọi entry giữ lại PASS; original hash nguyên vẹn. Test thực thi chính method helper với SDK Unity6000.6.2f1 PASS: runtime embed removed, UnityFramework embed retained, tất cả PBXFrameworksBuildPhase giữ nguyên, signing/build settings giữ, roundtrip/idempotence PASS. Report: SigningFix/ZatodLegend-SigningFix.report.json và pbx-result.json. Test dotnet run bị chặn đọc NuGet.Config ngoài workspace; đã compile offline trực tiếp bằng csc SDK10.0.401, không đọc/sửa config bị chặn. Chưa reexport Unity hoặc native build Mac mới, chưa nghiệm thu cài/chạy iPhone.
- **Nếu tái diễn:** giữ log đầy đủ, kiểm đúng IPA mới và Signing Mode; phân biệt đường dẫn framework bị từ chối. Không xóa UnityFramework.framework; nếu lỗi đổi sang nó hoặc app chính, cần điều tra chữ ký đầu ra Sideloadly riêng. Nguồn: https://issuetracker.unity.com/issues/24433/minimumosversion-value-in-infoplist-does-not-change-when-setting-target-minimum-ios-version-in-the-editor .
