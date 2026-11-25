# D39 — Lưu tiến trình và Login/Register

Ngày **25/11/2026, Asia/Saigon**. Nhánh `codex/d39-player-persistence`, baseline `72c543ffd`. Phạm vi theo [phase-plan](zatod-player-persistence-phase-plan.md), Design D39.

**Đã hoàn tất triển khai/kiểm trên Mac và build/kiểm IPA arm64 chưa ký. Chưa build/deploy Windows, đồng bộ PC hoặc cài/chạy thiết bị thật.**

## Hành vi đã triển khai

- Một file `datas.json` chứa danh sách toàn bộ Player: username/password và CharacterData. GUID tài khoản do server tạo; username/password so khớp đúng hoa/thường. `TinBo` và `tinbo` độc lập. Password nguyên văn đúng yêu cầu prototype, không gửi trong snapshot/world/replay hoặc ghi vào log.
- Login/Register riêng, Confirm Password, hiện/ẩn password; nhớ username và endpoint, không lưu password vào PlayerPrefs. Sai password/username có thể thử lại; Login không tự tạo Player. Register trùng username bị từ chối, một phiên hoạt động/account.
- Giữ level/EXP Player và từng Hero, sao/bậc/level skill, GUID kho/đồ mặc/hấp thụ, vàng/thể lực/mốc hồi, đội hình và clear/sao Campaign. Save chỉ giữ reference/progress, không chụp tổng stats sở hữu.
- Trận thắng lưu clear/sao cùng thưởng và receipt trong một commit. Lỗi ghi khôi phục cả Run, tài nguyên, đồ và receipt. Các thao tác equip/craft/skill/Promote/Inventory dùng store chung và giữ giao dịch hiện có.
- Logout/disconnect bỏ trận chưa settle, không resume; giữ phần thể lực đã trừ lúc bắt đầu, không tự hoàn/trừ thêm. Login về Town; kết quả đã commit giữ dù client chưa mở màn thưởng. Offline stamina theo giờ server như D30.
- Working copy account tách khỏi bản database đã commit: save B không lưu nhầm thay đổi chưa commit của A. Ghi file tạm/flush/replace, giữ `datas.json.bak`; primary hỏng có thể phục hồi backup hợp lệ và giữ bản hỏng `.corrupt-*`. Cả hai hỏng thì dừng load, không tự reset trắng. File thuộc schema mới hơn không tự bị downgrade.
- Lựa chọn đội hình/UI được dọn khi đổi account; free PvP roster vẫn riêng, không ghi preset vào Hero sở hữu. Replay xem lại không thưởng/unlock.

## File và đường dẫn

`PlayerDatabase.cs` là model/store C# thuần, codec được truyền vào (Unity JsonUtility ở runtime, System.Text.Json trong core checks). `ZatodServer` quản lý file và account đang online; credentials nằm trong PlayerRecord, tách khỏi CharacterData. `CampaignRun.Capture/Restore` giữ sao và clear; quyền mở chương/ải tính lại bằng policy D38 và cấp Player.

Dùng helper trên Windows từ repository:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\Start-ZatodServer.ps1 -Executable "Builds/ZatodPrototype/ZatodLegend.exe"
```

Chọn đúng executable **đã rebuild D39**, hoặc bỏ `-Executable` nếu bản Desktop LAN Test đã được cập nhật. Helper mặc định giữ dữ liệu ở **<repository>/ZatodServerData/datas.json**, ngoài output build; tạo file khi Register đầu tiên. Có thể truyền `-DataDirectory` với đường dẫn cố định tuyệt đối. Dòng khởi động in executable và đường dẫn file để kiểm đúng bản.

Chạy executable server trực tiếp: `--player-data-dir` chọn thư mục chứa `datas.json`; `--data-dir` chọn thư mục replay/log. Nếu chỉ có `--data-dir`, Player ở thư mục con `ZatodServerData`; nếu không có cả hai, dùng persistentDataPath. Không dùng IP làm khóa save. Đổi IP/mạng cùng host/data directory không mất Player; chuyển host cần mang theo thư mục dữ liệu. Chưa có đồng bộ cloud hoặc kết nối xuyên mạng tự động.

Muốn sửa JSON bằng tay thì dừng server trước; server giữ bản đang chạy trong bộ nhớ. File save/backup không phải asset Resources và bị Git ignore ở đường dẫn mặc định.

## Khởi tạo và giới hạn

- Bắt đầu dữ liệu mới; không migrate/import Owned hoặc dựng tiến trình từ replay cũ, không xóa các file cũ trên đĩa. Các giá trị khởi đầu lấy config hiện hành (năm Hero, bậc khởi đầu, 0 Gold/60 Stamina từ Progression), không reset lại khi Login.
- Quy tắc input prototype: username 1–24 chữ Latin/số/underscore/gạch ngang, không tự đổi case; password 1–128 ký tự, không ký tự điều khiển, giữ nguyên dấu cách/case. Đây là lựa chọn triển khai tạm, không thêm chính sách độ mạnh mật khẩu.
- Chưa hash/TLS/rate-limit, đổi/quên mật khẩu hoặc link provider theo phạm vi người dùng hoãn. Giữ GUID để có thể link account phase sau.
- Combat/simulation/rules/balance/loot/pooling không đổi. D39 thay D11 reset Campaign theo launch.

## Bằng chứng kiểm tra

Các test/script đi theo `Tests/`; evidence local trong `Artifacts/D39Checks/`, không dùng account thật.

| Kiểm | Kết quả |
|---|---|
| Shared JSON/persistence .NET | 36 đạt: case/password exact, distinct GUID, nhiều Player, dirty working copy, durable entry/settlement, rollback, restart, offline stamina, backup/corrupt/future schema |
| Core regression | 8.051 đạt; hai assertion reset cũ đổi sang giữ Campaign theo D39 |
| Native V7 / Hero / D38 policy | 3.017 /112 /46 đạt |
| Unity compile / JsonUtility | Compile đạt; TCP load/save thực dùng JsonUtility cho root database và Player |
| TCP cuối | 303 assertions, hai Player: Login/Register/sai password/thử lại/đăng nhập trùng, reject guest hello, Campaign, formation, disconnect, restart server transport/store, GUID/item giữ, equip save failure/rollback/retry và PvP |
| UI | 528 checks, hai tab, confirm/show-hide, bốn tỷ lệ ngang 1600×900/2436×1125/2400×1080/1600×1200, cutout safe area, không overflow; ảnh UiPass1/UiFinal/UiVerified |
| Replay UI | 109 checks trên bốn archive app V4/V5/V6/V7, pause/seek/outcome/cleanup, không cấp thưởng hoặc thay progress |
| Unity ↔ .NET | Archive Campaign/PvP TCP khớp digest khi resimulate bằng .NET; cross-campaign.log/cross-pvp.log |
| Console cuối runtime | groundTruth0errors, compilationFailed=false; không clear Console bằng tool |

Lượt đầu UI cleanup dùng sai index RemoveCustomSize, đã sửa và gỡ đúng các size D39 do test tạo. Một replay fixture core V4 thiếu Background không thích hợp cho UI; giữ báo cáo fail, chạy lại bằng archive app thật trong phiên Play sạch đạt109. Không sửa simulation/render để ép fixture hợp lệ.

TCP/restart ở đây là server transport/store và các peer TCP thật trong Unity Editor trên Mac; không coi là đã chạy Windows process hoặc thiết bị vật lý. Mac không có Windows build-support module/pwsh, nên chưa chạy helper PowerShell hoặc build lại Windows. Không cài module/remote Windows trong lượt này.

## Build và bàn giao

- IPA: `/Users/bloom/Desktop/Zatod Legend/Builds/D39/20261125-135629/ZatodLegend-D39-unsigned.ipa` — **1,650,312,887 byte (1.54 GiB), unsigned**, cho Sideloadly.
- Thư mục chứa: `/Users/bloom/Desktop/Zatod Legend/Builds/D39/20261125-135629`.
- Unity6000.6.2f1 export thành công0errors/5warnings, texture overrides0. Xcode27.2 Release/iphoneos/arm64 BUILD SUCCEEDED với signing tắt riêng invocation.
- ZIP64/CRC toàn gói đạt; Bundle ID `com.zatodlegend.lantest`, iOS15, Local Network và hai binary arm64 chưa ký đạt. Không nhúng/phụ thuộc UnityRuntime. Đối chiếu19file Unity Data export→product và đủ20 TextAsset runtime.
- Marker `PlayerDatabaseStore`, `ConfirmPassword`, thông báo persistence có trong metadata của product đã đóng gói;127C#Main/workspace khớp trước export. Runtime Data và rules giữ catalogD34/D38.
- SHA256 IPA: `dd44b2fe14ce3fd58abdd782161f1a37757ed3f94da3ea0367694deedceec9c6`.
- Có gói **source** cho Windows: `/Users/bloom/Desktop/Zatod Legend/Builds/D39/20261125-135629/ZatodLegend-D39-Windows-source.zip`; không phải executable. Manifest và hướng dẫn yêu cầu baseline `72c543ffd` và build lại client/server D39 trước kết nối. Không tự áp vào máy PC.
- Giữ bản D38. Khi export/native build gần đầy ổ, chỉ dùng APFS clone cho các file output/cache đã đối chiếu SHA256 giống byte; không xóa build cũ hoặc đổi Data/art. Bằng chứng clone trong Artifacts/D39Checks.
- Editor bàn giao stopped/scene sạch/auto-tick=false; server/client fixture đều tắt. Console cuối0errors,5warnings engine/export, compilationFailed=false. Không có module Windows/pwsh trên Mac nên chưa kiểm executable/PowerShell Windows hoặc thiết bị thật.

Bằng chứng build: `unity-export.json`, `native-build.log`, `ipa-verification.json`, `d39-code-verification.json` trong thư mục build.

Source/docs vẫn ở working tree; chưa commit/push, chưa chuyển sang clone Windows. Restore nhỏ trước thay đổi: `Artifacts/D39Checks/before.zip`. Client/server cần cùng D39; app mới không dùng guest protocol cũ.
