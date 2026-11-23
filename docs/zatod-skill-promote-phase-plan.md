# D35 — Skill, SkillEvo, Quick Equip và Promote

Cập nhật: **23/11/2026, Asia/Saigon**.

**Trạng thái: thiết kế đã duyệt, chưa triển khai.** Đây là bản bàn giao thực thi; [Design.md — D35](../Design.md#d35--hoàn-thiện-hệ-thống-skill-và-promote-trước-mở-rộng-nội-dung) là nguồn quyết định. Người dùng sẽ giao một agent khác thực thi. Việc tạo/cập nhật tài liệu này không tự khởi động implementation, build hoặc deploy.

## 1. Đọc và kiểm tra đầu vào

1. Đọc `AGENTS.md`, skill `.agents/skills/zatod-design/SKILL.md`, `Design.md` D05–D08, D17, D22, D28, D30–D31, D34–D36.
2. Đọc ChangeLog.md mục REVIEW-002, REVIEW-008 và REVIEW-009. Không hỏi lại các quyết định đã được chốt trong D35.
3. Dùng tài liệu này làm checklist. [Bản đối chiếu Crystal](zatod-skill-promote-review.md) chỉ chứa bằng chứng nguồn; [JSON tham chiếu](reference/zatod-skill-promote-source.json) chứa giá vàng, mốc Evo, baseline và hash source.
4. Xem `git status`; giữ mọi thay đổi có sẵn. Đọc trạng thái Editor/server và công cụ đang có trước khi điều khiển hoặc build. Không dừng server/client chính hay dùng Owned thật làm fixture.
5. Xác nhận nguồn tại `Unity/Assets/Crystal Legend/` từ repository root, tương đương `Assets/Crystal Legend/` từ projectUnity. Người dùng đã chuyển folder vào đây23/11/2026; root cũ không còn. Kiểm thư mục `recovered/` và `recovery_tools/`, không dựa vào cwd hoặc đoán lại vị trí cũ.
6. Kiểm trạng thái chuyển source sang clone/worktree: cập nhật23/11,96.077 file reference đã commit/push lênmain theo26 lô; checkout/pull main đã có nguồn giải nén tại vị trí mới. Kiểm đầu vào thực tế sau checkout. Ngoài3file lớn ở mục9,3bản diagnostic chứa khóacloud `recovered/scripts/{custom_bytecode,lua,lua51_bytecode}/.../util/network_diagnosis.{abc,lua,luac}` đượcignore và chỉ giữlocal; không là đầu vào D35. `Artifacts/` vẫn bịignore và không bắt buộc copy toàn bộ. JSON trongdocs không thay Lua hook/art/audio; nếu thiếu đầu vào thì báo phần thiếu và tiếp tục phần độc lập.
7. Các helper import/bake như `scripts/Import-CrystalConfig.py`, `Import-ZatodInventory.py`, `Import-ZatodChapterTwo.py`, `Bake-CrystalAnimations.py` và các scriptPrepare hiện còn ghép đường từ root cũ. Rà/cập nhật resolver sang vị trí hiện hành trước khi chạy, kể cả audithelper local trongArtifacts; không chạy importer thử để dò đường vì có thể ghi config. Task cập nhật tài liệu chưa sửa/chạy cácscript này.
8. Source raw hiện nằm trongUnityAssets: kiểm tác động import thực tế khi mởEditor, không mặc định tất cả file trongfolder đã trở thành asset runtime hợp lệ. Không tự chuyển/xóa reference hoặc đổi chính sáchGitignore trong phase này để xử lý đường dẫn.
9. Bản bàn giao đã loại khỏi Git các file lớn `chrome-headless-shell.exe`, `install_time_pack.apk` và `recovered/downloads/aab_1.1.100312.zip` ; kiểm các thư mục đã giải nén trước khi chạy helper. Browser executable không là đầu vào D35; APK gốc chỉ cần khi phục hồi lại/preview dùng trực tiếp APK. Asset đã giải nén nằm ở `recovered/assets/install_time_pack/remake/`. Riêng `scripts/Bake-CrystalEffects.py`, `Bake_CrystalSupport.py` và `recovery_tools/hero_animation.py` có nhánh đọc ZIP trực tiếp: cần chỉnh loader dùng container trong `recovered/downloads/aab_1.1.100312/patch/` hoặc nhận ZIP riêng trước khi bake/recover mới. Không coi thiếu ZIP là không ảnh hưởng tới các helper chưa sửa. Kiểm23/11 thấy2.400 file `patch/pfca/` tồn tại trong thư mục giải nén và cùng kích thước với archive, gồm effectRum củaCoco; đây chưa phải kiểm SHA256 toàn bộ nội dung. Không xóa bản gốc local chỉ vì không commit.

Đích của phase là người chơi xem/nâng skill, nhận đúng Evo, mặc nhanh và tiến bậc qua UI/server, đồng thời giữ dữ liệu cũ. Chưa có code hoặc kiểm chứng runtime D35 tại lúc bàn giao.

## 2. Phạm vi và baseline

| Trong D35 | Để phase nội dung D34 tiếp theo |
|---|---|
| Hệ quản lý/nâng level skill và UI | Chương3–8, đảo/portal/ải mới |
| Model, config, runtime và UI SkillEvo | Pool40 Hero PvP riêng và các Hero mới |
| Quick Equip/Promote dùng chung nút | Mở tiến trình từ Blue tới Purple |
| Migration, transaction, snapshot/replay | Tối nền, fade xác và các presentation battle khác |
| GameEditor và validation liên quan | Lưu tiến trình Campaign; nguồn farm sách; đưa STR/AGI/INT trở lại |

Baseline trên đĩa:25 Hero,75 slot skill chính đang được định nghĩa,14 Monster,142 item,131 skill,52 buff; rank sở hữu hiện tới Blue;2 chương/39 ải/117 wave. Đây là số config, không phải số Hero một account sở hữu. Agent phải đọc lại baseline hiện tại trước sửa vì chat khác có thể đã cập nhật repository.

Áp dụng hệ thống cho Hero/config hiện hành và các dependency skill/Evo thực sự cần. Không nhập thêm roster/chương/rank hoạt động của D34. Schema/UI hỗ trợ slot thứ4 theo config; nếu cần metadata để hiện slot Tím đang khóa thì nhập đúng nguồn và vẫn giữ khóa, không biến nó thành quyền mở Tím hoặc cam kết mọi skill Tím đã port. Không cấp Hero/item, tăng rank hay sửa tiến trình người dùng để tạo hình thức đã hoàn tất.

JSON tham chiếu có300 dòng Evo của4 slot nguồn ×25 Hero ×3 mốc, gồm cả slot Tím chưa mở. Đó là dữ liệu tham khảo, không phải300 mốc đang hoạt động trong runtime hiện tại. Lập coverage theo SkillId/SourceId hiện có; các Evo của skill chính đang hoạt động và các hook phụ thuộc phải có hành vi thật. Mốc/skill Tím chưa thuộc nội dung hoạt động cần ghi rõ là tham chiếu/khóa, không âm thầm gắn hiệu ứng gần giống.

## 3. Quy tắc skill đã duyệt

- Hero mới khởi tạo level từng slot theo config nguồn. Bộ25 hiện có: slot1/2/3/4 tương ứng1/1/21/41. Bậc quyết định mở slot; level cao không tự mở slot khóa.
- Skill đã mở nâng tối đa `min(Hero.Level, SkillLevelCap)`. **SkillLevelCap mặc định80**, chỉnh được qua GameEditor; không hardcode theo số dòng bảng hoặc account level.
- Chưa áp gate PlayerLv7 trong phase này. Không thêm điểm skill hồi theo giờ, VIP, currency mới hoặc điều kiện ngoài phạm vi.
- Mỗi bước `L → L+1` thu vàng theo hàngL của SkillLevels nguồn. Ba nhóm STR/AGI/INT có giá vàng giống nhau trong mọi bướcLv1→80: dùng chung curve vàng đã trích trong JSON, không cần đưa ba stat hoặc nhóm sách trở lại model gameplay.
- Tạm bỏ mọi phí sách/nguyên liệu nâng skill, gồm mốc Evo: không yêu cầu đủ, không trừ, không thêm phí Evo mới. Không cần import sách hoặc mở nguồn nhận chỉ để vượt điều kiện nguồn.
- Nâng từng cấp, hỗ trợ thao tác giữ nút như UI nguồn. Server tính chi phí của từng bước/batch; chỉ áp mức đã được yêu cầu và hợp lệ. Không tự tiêu hết vàng/nâng tới cap sau một lần bấm ngắn. Cách gửi request có thể chọn theo kiến trúc hiện có, không cần xin lại quyết định kỹ thuật thông thường.
- Level cũ cao hơn cap hoặc dữ liệu dev không được tự hạ/reset khi load; chặn nâng thêm nếu không hợp lệ và giữ dữ liệu. Slot khóa có thể lưu seed cao hơn HeroLevel nhưng không được thi triển/nâng.

## 4. Model và hiệu ứng SkillEvo

### Config và tiến trình

- Thêm `SkillDefinition.Evolutions` trong Skills.txt/tabSkills GameEditor.
- Mỗi mốc có Id ổn định, RequiredSkillLevel, Description, ParameterChanges, TriggeredEffects. Có thể dùng tên class/field chi tiết phù hợp repository, nhưng giữ ý nghĩa đã duyệt.
- Không giới hạn cứng ba mốc; không dùng index dòng làm ID. Validate ID trùng, level không hợp lệ, target/trigger/parameter không hỗ trợ, reference buff/effect thiếu và thứ tự áp dụng mơ hồ.
- ParameterChanges phân biệt add/replace. TriggeredEffects thể hiện trigger logic, mục tiêu và effect/buff; tái sử dụng runtime hiện có, bổ sung handler cho hành vi thực sự thiếu. Không xây một ngôn ngữ script tùy ý hoặc chỉ lưu túi ScriptArg rồi báo đã có hiệu ứng.
- HeroSkillData tiếp tục là SlotId/Level. Không thêm EvoLevel/EvoExp/IsEvolved vào save như nguồn tiến trình thứhai. InitialLevel là config khởi tạo, không phải bản sao level hiện tại.

### Giải mốc và snapshot

- Từ level skill và config snapshot, lấy mọi mốc đủlevel theo thứ tự xác định. Các mốc tích lũy: Lv50 vẫn có tác động của mốc35.
- Evo mở trong cùng giao dịch tăng level qua ngưỡng; không thêm request mở Evo độc lập hoặc slot thứ5.
- Trigger chạy theo sự kiện combat thật, không theo render frame hoặc Animator callback. Không đổi timing damage để khớp một animation minh họa.
- Modifier áp trên bản skill/caster runtime đã tách; không sửa BuffDefinition/SkillDefinition chung. Nếu hai mốc thay cùng tham số, thứ tự/replace phải rõ và deterministic.
- Deep-copy/serialize đầy đủ Evo và buff/effect phụ thuộc qua SkillDefinition.Copy, BattleSkillData, CombatantBattleData, match/replay. Không đọc config live để suy Evo cho replay cũ; không đưa Evo vào snapshot cũ chỉ vì level trong snapshot đủ cao.
- Nếu thay đổi simulation semantics thì giữ nhánh rules tương thích hoặc version hợp lệ. ConfigVersion đơn thuần không chứng minh replay cũ giữ kết quả.

### Ca kiểm chứng nguồn bắt buộc: Coco ultimate

| Level skill | Kỳ vọng |
|---|---|
| 34 | Chưa có Evo rum |
| 35 | Attack frame thêm buff9s/PIMU20/MIMU20 cho Coco và đồng đội còn sống |
| 50 | Giữ rum, thay hệ sốAP1,4→1,6 |
| 70 | Giữ các mốc trước, stun cấu hình5s trước công thức tenacity |

Buff nguồn10000104 và hook Coco là bằng chứng, không phải damage/heal giả để test. Giữ D05 stat trực tiếp khi chuyển các Evo khác; không tái đưa STR/AGI/INT vì source có field đó.

## 5. UI Skill và GameEditor

- Nối tab Skill của Hero Detail hiện có. Dùng đúng art/font/layout Crystal, uGUI và landscape/safe area D17/D22; không thay bằng control màu tạm.
- Hiện skill chính theo slot, icon, tên, level, trạng thái khóa/bậc mở, mô tả thật, giá vàng và nút nâng. Basic/skill ẩn/phụ thuộc không tự thành một hàng nâng độc lập.
- Mô tả/preview hiện hệ số và các mốc Evo đúng level/config: chưa mở, đã mở, mốc sắp đạt. Dùng cùng công thức với runtime; không quảng cáo effect chưa port hoặc cộng aura/buff trong trận vào base save.
- Snapshot mới sau thao tác cập nhật level, Gold, điều kiện và nội dung; giữ Hero đang xem, scroll/selection hợp lý. Đóng UI về world đúng context và input avatar theo flow hiện có.
- GameEditor chỉnh được InitialLevel, SkillLevelCap, curve vàng, metadata skill và các mốc/effect Evo; có validate, draft/stale/save như các tab hiện tại. Không tạo nguồn quyết định thứhai ngoài config đã được chọn.
- Thiếu tài nguyên/art phải truy nguồn hiện có trước; không dùng ảnh tạo mới thay art Crystal. Không cần hoàn thiện Astrolabe/Skin/Power trong phase này.

## 6. Quick Equip và Promote

- Dùng chính vị trí nút Quick Equip hiện có ở Hero Base. Chưa đủ ô thì là Quick Equip; đủ ô và có NextRankId thì đổi thành Promote.
- Quick Equip chỉ lấy món thật trong Inventory, đúng ItemId yêu cầu, level hợp lệ, GUID khác nhau cho từng ô. Có hai ô cùngItemId mà chỉ mộtGUID thì chỉ mặc được mộtô. Không lấy món đang mặc/hấp thụ/Retired hoặc tạo item ảo từ số xN.
- Không tự craft, mua, cấp đồ hoặc mở nguồn nhận. Lần bấm mặc nhanh kết thúc sau mặc; không tự Promote luôn trong cùngclick.
- Promote kiểm ownership, đủ ô, bậc kế và guard trận/queue. Chuyển đúng GUID/ItemId từ EquippedItems sang AbsorbedItems, giữ RankId/SlotId nguồn, làm trống ô mới và đổi NextRankId.
- Giữ level/sao/EXP và skill đã lưu; skill mới chỉ mở theo config. Ở cuối đườngrank, hiển thị trạng thái max phù hợp, không gửi request Promote thất bại liên tục. Không hardcode Blue/Purple bằng index.
- Không tự thu vàng Promote hoặc thêm enchant/refund/awake. Dữ liệu Init1..6 nguồn đều0 cho25 Hero/rank1–7 đã kiểm; không cấp đồ mới sau Promote.
- Stat trước/sau dùng cùng calculator D08, giữ bonus bậc độc lập và lịch sử; không cộng nguyên tổngUnitRank nguồn rồi cộng lại đồ hấp thụ. Không giả định mọi stat phải tăng và không cộng bù base sau thay đổi item D31.

## 7. Save, transaction và dữ liệu được bảo vệ

- Trước validate khi load, migration theoSlotId chỉ thêm slot thiếu theo InitialLevel config. Giữ các dòng skill/level cũ, Hero/Item GUID, rank, equipped/absorbed history, Gold và tiến trình khác. Không tự nâng các slot cũLv1 lên21/41 hoặc tạo lại account.
- Server kiểm điều kiện và tự tính plan/giá từ config; client không quyết định Gold, effect hoặc kết quả Promote. Có kiểm mức level/revision mong đợi để request cũ không nâng khác điều UI vừa thể hiện.
- Receipt định danh cùng OperationId/payload: xử lý lại trả kết quả cũ, khác payload cùngID bị từchối. Nhận receipt trước khi áp một lần mới; reconnect giữ kết quả đã commit.
- Lưu thất bại phải rollback toàn bộ phần thay đổi: skill levels, Gold, RankId, Inventory/EquippedItems/AbsorbedItems nếu liên quan, Revision và receipt. Checkpoint chỉ lưu danh sách Inventory chưa đủ cho Promote.
- Không đổi loadout khi đang Campaign/PvP/queue theo guard hiện có. Nâng skill/Promote sau trận không đổi snapshot/checker/replay trận đã cấp.
- Mọi ca thiếu tiền, persistfail, stale/retry và profile dev phải dùng account/server fixture riêng. Không reset kho người dùng hoặc dùng fixture ghi vào main server data.

## 8. Trình tự thực hiện đề nghị

1. Kiểm baseline/restore point và source. Lập coverage matrix skill/Evo theo catalog hiện tại, ghi mốc nào active và mốc nào thuộc nội dung Tím đểsau.
2. Thêm config/model/validation/copy/serialization, migration và rule/curve vàng; giữ config cũ/replay đọc được.
3. Hoàn thiện giao dịch nâng skill, Quick Equip và Promote; kiểm thành công/thất bại/retry trước khi dựng hoàn chỉnh UI.
4. Port các hiệu ứng Evo trong phạm vi, kiểm từng trigger/mốc/caster/target và deterministic client/checker.
5. Nối UI Skill, nút Quick Equip/Promote và GameEditor, kiểm hình thức/tương tác trên các tỷ lệ màn.
6. Chạy kiểm tra và build phù hợp; cập nhật trạng thái/bằng chứng bàn giao. Có thể điều chỉnh thứ tự kỹ thuật theo dependency, không mở rộng sản phẩm ngoài D35.

## 9. Tiêu chí nghiệm thu

- [ ] Core/model: load catalog cũ/mới, slot khóa/mở, InitialLevel, capHero/cap80, chi phí từng bước/batch, không tiêu sách hoặc yêu cầu PlayerLv7.
- [ ] Evo: ranh giới trước/đúng/sau mốc, cộng dồn, add/replace, buff hết hạn/dispel/death theo nguồn, hook đúng caster/target; Coco35/50/70 đạt và có coverage cho các skill đang hoạt động khác.
- [ ] Giao dịch: thiếu Gold, GUID sai/thiếu/được dùng haiô, savefail rollback, request lặp/stale, reconnect và guard trận/queue. Không có thu phí/cấp effect/tiến bậc lặp.
- [ ] Migration: save3slot đọc được sau bổsungslot, các level/GUID/history cũ giữ nguyên; thêm slot khóa không thành skill dùng được.
- [ ] Snapshot/replay: deep-copy không chia sẻ danh sách, chỉnh config/Hero sau khi cấp trận không đổi trận đó; archive cũ giữ outcome/digest/rules thích hợp; không dựa vào copy JSON nông để khẳngđịnh đạt.
- [ ] UI thật:25 Hero hiện có, locked/unlocked/max/thiếu tiền, hold nâng, cùngnút QuickEquip/Promote, trở về world đúng;16:9,19.5:9/20:9,4:3 vàsafearea. Có ảnh đã xem, không chỉ đếmassertion.
- [ ] GameEditor: chỉnh/lưu/đọc lại rule/curve/Evo, validate reference, draft/stale handling; không ghi config ngoài thao tác Save.
- [ ] Kiểmtra phùhợp từ Tests/HeroChecks, Tests/CrystalChecks và các harness Editor/network hiện có; chỉ sửa/viết ca liên quan D35. Không coi harness prototype cũ là bằngchứng active content nếu đã bị retire.
- [ ] Client-server thật với profile/port riêng; build Windows và smoke hành vi mới. Mobile kiểmresponsive và thiết bị/build khi môi trường sẵn; phần chưa kiểm vật lý phải ghi rõ, không báo đã nghiệmthu Android/iOS chỉ từ GameView.
- [ ] Owned/mainserver/scene/art không liên quan được bảo toàn; console không lỗi mới. Không tự publish/deploy lên môi trường đang dùng chỉ để kết thúc checklist.

## 10. Báo cáo bàn giao sau thực thi

Tạo `docs/zatod-skill-promote-implementation.md` sau khi làm, ghi: hành vi đã triển khai, config/Editor, migration, coverage Evo, kiểmtra/build/network/UI, giới hạn, đường evidence và trạng thái Editor/server cuối. Cập nhật Design D35 bằng trạng thái thực tế, ghi lỗi/cách sửa vào ChangeLog. Nếu một phần chưa đạt, ghi chính xác phần còn thiếu; không đánh dấu phase hoàn tất chỉ vì model compile được.

Không cần đọc chat brainstorm để thực thi phạm vi đã chốt. Khi người dùng giao thực thi theo D35/tài liệu này, tiếp tục trong phạm vi đã duyệt và chỉ hỏi nếu có xung đột thiết kế hoặc đầu vào thực sự thiếu; không xin lại các quyết định đã có.
