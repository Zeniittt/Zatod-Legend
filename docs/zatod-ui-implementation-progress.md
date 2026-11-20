# Zatod — GameEditor, HUD và chuyển dữ liệu

Cập nhật 19/11/2026 (Asia/Saigon). **Đã triển khai và kiểm tra chức năng D14–D16** theo yêu cầu thực thi. Sau phản hồi người dùng, hình thức UI còn dùng một phần control tạm, chưa nghiệm thu độ giống bản tham chiếu (BUG-018). Hướng dẫn hiện hành: [Chơi thử Zatod](zatod-prototype-play.md). Design.md vẫn là nguồn quyết định; ChangeLog.md là lịch sử lỗi.

## Kết quả

- Config hoạt động chỉ còn bộ nhập mới: **16 Hero, 10 Monster, 67 Item, 86 Skill, 33 Buff, 27 Stat**, 18 ải/54 wave. Định nghĩa pixel cũ đã bỏ khỏi các bảng active; art/source/archive vẫn giữ.
- ID snake_case theo object. Skill có prefix owner để phân biệt nhãn trùng; 26 Basic Attack tương ứng 16 Hero + 10 Monster. `crystal_sword` là tên món Crystal Sword thật, không phải prefix số nguồn cũ.
- 67/67 item và 74/74 skill hiển thị dùng English của client gốc. Tổng 86 skill: 75 nhãn trực tiếp, 4 hidden tra qua tên nền, 7 hidden dùng nhãn kỹ thuật có ghi rõ fallback. Không coi fallback là bản địa hóa chính thức. Bảng nguồn: `Artifacts/CrystalPhaseChecks/english-name-audit-20261119.json`.
- Importer gọi `Prepare-ZatodData.py` để dọn dữ liệu/chuyển ID; mapping tham chiếu tại `Artifacts/CrystalPhaseChecks/zatod-id-mapping.json`, alias tương thích trong `ZatodContentIds.cs`.
- **GameEditor > Open**, hoặc **Zatod > GameEditor**: Heroes, Monsters, Items, Stats, Skills, Buffs, Campaign. Nhãn Name [Id], có chỉnh chương/ải/wave/hook. Refresh file ngoài khi draft sạch; giữ draft dirty và chặn ghi stale. Các foldout chỉ dựng con khi mở, tránh ClipRect exhaustion của UI Toolkit.
- HUD prefab chỉnh được tại `Assets/Zatod/Resources/Zatod/UI/ZatodBattleHUD.prefab`. Dùng 29 sprite UI/portrait từ nguồn, HP/energy, rank/star, báo đầy nộ, wave/countdown, Auto. Vàng/rương cố định 0; Phó bản chưa có pause/tăng tốc. Replay vẫn có pause/seek/x1/x2/x4.
- Damage/heal/energy nổi lấy lượng thực tế sau resolve/cap; LAST HIT dùng energy thật được nhận. Đây là event presentation, không tiêu RNG hay thay digest. Auto gửi ultimate hợp lệ vào nhật ký/checker như bấm tay. Không thay core 8 Hz, tốc độ movement hoặc luật skill.
- Thành phần project đổi sang Zatod: UI/menu, class/file, scene, resource, build/scripts. AssetDatabase move giữ GUID. Scene `Assets/Zatod/Scenes/ZatodPrototype.unity`, art `Art/Imported`, resources `Resources/Zatod`, bản Windows `Builds/ZatodPrototype/ZatodLegend.exe`.

## Giữ save, GUID và replay

`ZatodSaveMigration` ánh xạ Definition/ItemId nhưng không đổi instance ID, GUID đang mặc/kho/hấp thụ. Dữ liệu sở hữu thuộc định nghĩa đã nghỉ được giữ tại RetiredHeroDesk/RetiredInventory/RetiredFormationIds; không xóa lịch sử để né validation. Nếu chỉ còn roster đã nghỉ, cấp roster khởi đầu mới riêng.

PlayerPrefs đọc fallback khóa profile cũ. Rules mới `zatod-prototype-3` vẫn chấp nhận rules cũ `crystal-prototype-3`; đọc `.crystal.gz`, ghi archive mới `.zatod.gz`. Trường JSON source metadata `.Crystal` cố ý giữ cho hợp đồng snapshot cũ; trên Editor hiện là Source Metadata. Snapshot art cũ được normalize resource khi trình chiếu.

Server script mới lần đầu sao chép Owned/archive cũ có LegacyBackup, giữ nguyên nguồn. Một profile thật đã được nạp qua server mới: giữ đủ 5 Hero instance/level/rank và tạo `.before-zatod-ids`. Hai file Owned trong LegacyBackup khớp SHA256 bản nguồn. Các wrapper Start-Crystal/Test-Crystal còn để tương thích lệnh cũ.

## Kiểm tra hoàn tất

| Kiểm tra | Kết quả / bằng chứng |
|---|---|
| Core | **4.377 PASS**: localization, ID/ref, save/GUID/retired migration, actual combat events và 3 archive golden cũ |
| GameEditor | **13 PASS**, 7 tab, đúng 16/10/67, clean refresh, dirty draft, stale save, Campaign; `Artifacts/ZatodPhaseChecks/gameeditor-checks.json` |
| HUD live | **PASS**, đủ 5 portrait, loot 0, có damage/heal/energy thật, **4 input Auto** được server xác nhận; replay pause/seek/x4 đạt; `hud-live/result.json` |
| Windows build cuối | **Succeeded, 0 errors, 2 warnings**; `Artifacts/ZatodPhaseChecks/build.json` |
| Executable hai client | Phó bản/Arena/PvP **PASS**, cùng digest **290907702718236382**, 7 inputs; `network-20261119-212235/results.txt` |
| Relaunch | Reset ải, giữ đúng **24 cặp GUID/ItemId**; cùng network report |
| Save cũ qua server mới | **PASS**, `owned-migration-live.json`; LegacyBackup khớp hash nguồn |
| Console cuối | Không có error mới, compilationFailed=false; console history cũ được giữ, không clear |

Các đường dẫn ngắn trong bảng thuộc `Artifacts/ZatodPhaseChecks/`. Báo cáo tổng: `verification-final.json`. Hai cảnh báo build: ArenaView cũ gọi FindFirstObjectByType đã obsolete; TMP shader dùng debug pragma cũ. Không phải lỗi compile hoặc combat.

Ảnh HUD thật: `Artifacts/ZatodPhaseChecks/hud-live/hud-ready.png` và `hud-result.png`. Bộ đếm DamageTexts/HealTexts/EnergyTexts trong probe là số lần quan sát text qua render frame, không phải số event duy nhất.

Lượt build đầu Succeeded nhưng có 2 error UI Toolkit ClipRect từ GameEditor; đã sửa lazy foldout và build lại sạch. Probe HUD đầu thất bại vì lookup HUD inactive; lần sau đo pause trước lần render paused đầu tiên. Đã sửa thứ tự trong harness; kết quả cuối PASS, không thay gameplay để chiều test. Một lệnh script eval timeout lúc Editor chưa được auto-tick; chưa xác định đầy đủ nguyên nhân timeout, sau bật auto-tick các lệnh và Play hoạt động. Không dùng ready endpoint làm bằng chứng game đang tiến frame.

## Bàn giao

- Server local mới đang chạy **TCP 7788**, PID **63792**; log `Artifacts/ZatodServer/server.log` có READY. Server thử nghiệm 17888/17990 đã dừng.
- Editor của người dùng vẫn mở, **đã dừng Play**, auto-tick override đã tắt; không giữ Editor batchmode nền.
- Đọc `docs/zatod-prototype-play.md` để mở server/client/GameEditor. Server hiện đã chạy nên chưa cần mở thêm một server ở cùng cổng.
- Backup trước thay đổi: `Artifacts/CrystalPhaseCheckpoints/20261119-before-gameeditor-hud/source-config-save.zip` (5.035 file).
- Checkpoint sau nghiệm thu: `Artifacts/ZatodPhaseCheckpoints/20261119-gameeditor-hud/source-config-save.zip` + manifest/SHA256. Checkpoint chứa source/config/meta và UI import mới, không nhân đôi toàn bộ source APK/art.

Giới hạn phase cũ còn nguyên: chưa nối reward/economy, craft/Market, server production, Tinh Anh/awakening; 2 sound reference không có trong nguồn. Đây là prototype port từ phần source đã kiểm tra, không suy rằng biết toàn bộ backend Crystal.
