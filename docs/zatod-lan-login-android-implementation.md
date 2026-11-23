# D32 — LAN login, Windows và Android

Ngày nghiệm thu: 22/11/2026. Đã triển khai và thử Windows client trên PC host cùng một OPPO Pad Air qua Wi-Fi. Chưa thử Windows ở máy khác hoặc hai Android đồng thời. Quyết định chung tại Design.md/D32; kinh nghiệm xử lý lỗi tại ChangeLog.md/BUG-058 và BUG-059.

## Chạy game

Thư mục xuất bản Windows/server: `C:\Users\tinnq\OneDrive\Desktop\Zatod Legend LAN Test`.

1. Cho PC và các thiết bị vào cùng LAN/Wi-Fi.
2. Mở `Server\Start-Server.cmd` trên PC host. Dừng bằng `Server\Stop-Server.cmd`.
3. Windows mở `Windows\Play-Zatod.cmd`. Android mở app **Zatod Legend** đã cài.
4. Nhập tên rồi Connect. Client tự dò địa chỉ PC, không ghi IP mạng nhà vào APK.
5. Arena, PvP và Replay mở qua NPC trong Town.

Khi đổi mạng, khởi động lại server rồi kết nối lại client. Router phải cho phép các thiết bị liên lạc với nhau; mạng guest/công ty có thể cô lập client. Game dùng TCP 7788, discovery UDP 47777. Ba firewall rule riêng cho executable Desktop đã được tạo trên PC này, giới hạn LocalSubnet. Chưa đổi router hoặc tắt firewall toàn máy.

Tên là tên hiển thị, GUID thiết bị/profile vẫn là khóa sở hữu. Dữ liệu thật giữ tại `Artifacts/ZatodServer`. Không reset kho, gỡ app hoặc clear data để xử lý kết nối. Bản build dùng joystick; WASD/phím mũi tên chỉ có trong Unity Editor.

## Build Android lần sau

Lưu công việc và đóng Editor của project này trước khi build. Chế độ headless tránh lỗi Editor DX12 vượt bộ nhớ GPU khi xử lý bộ tài nguyên lớn.

```powershell
cd "E:\viec\Zatod Legend"
powershell -ExecutionPolicy Bypass -File .\Scripts\Build-ZatodAndroid.ps1 -Install -DeviceSerial 719d0943
```

Bỏ `-Install` nếu chỉ cần tạo APK. Khi chỉ có một thiết bị đã được cấp quyền USB, có thể bỏ `-DeviceSerial`. Script giữ dữ liệu bằng `adb install -r`; nếu USB báo unauthorized, mở khóa tablet và cho phép USB debugging lại. Không tự gỡ app khi gặp xung đột chữ ký.

APK tạm tại `%TEMP%\ZatodLanTestBuild\Android\ZatodLegend.apk`, không xuất vào Desktop/Android. Bản đã cài có appid `com.zatodlegend.lantest`, version 0.1.0/code 1, ARM64, min API 26/target API 34, landscape hai chiều và OpenGLES3. Manifest thực tế có INTERNET và CHANGE_WIFI_MULTICAST_STATE. Mirror đã có multicast lock cho Android.

Helper chọn Android Generic(0), lấy ASTC từ Player Settings và các override ASTC6x6. Không dùng StandaloneBuildSubtarget.Player(2) cho Android vì cùng giá trị đó là PVRTC. `AndroidBatch` kiểm active target để các callback manifest Android được compile đúng. Script PowerShell mới đã qua kiểm tra cú pháp; lệnh CLI bên trong chính là luồng headless đã build thành công, chưa chạy lại một build đầy đủ chỉ để thử wrapper.

## Thay đổi runtime

Login uGUI dùng art/font Crystal, responsive landscape/safe area, tên tối đa 24 ký tự hợp lệ và tự tìm server. Discovery kiểm protocol/catalog, dùng địa chỉ gói trả lời cùng cổng server quảng bá; timeout hiển thị thông báo thử lại. Tên được server xác nhận/lưu và gửi tới người chơi khác. Không thêm mật khẩu hoặc auth chính thức.

Arena/PvP dùng đúng ZatodFormationView của Phó bản, giữ roster/filter/đội hình/Battle. Wave/enemy/cost/reward và các mục chưa có dữ liệu để trống, không tạo stage giả. Back hủy hàng đợi PvP. Replay dùng archive view riêng. Header/menu kết nối prototype đã được bỏ khỏi flow chơi.

767 sheet tại Assets/Zatod/Art/Imported có Android override ASTC6x6. Audit sau đổi target xác nhận chỉ block Android thay đổi; PNG, sprite geometry và Standalone override không đổi. Ba texture lớn kiểm mẫu thực sự có format ASTC6x6, toàn bộ 767 importer không có warning. Không coi đây là sửa BC7/BUG-056 trên Windows. Backup meta tại Artifacts/ZatodLanLoginChecks/android-texture-metas-before.zip.

## Kết quả kiểm tra

- Core: 5.075 assertions PASS, gồm kiểm tên guest/Unicode.
- UI: 86 checks PASS trên 1600x900, 2436x1125 và 2000x1200, với server test thật; login/NPC/Formation/filter/queue/back.
- Windows: build 0 lỗi/2 warnings; thư mục cuối 218 file, 11.475.824.437 byte (khoảng 10,69 GiB).
- Android: headless build Succeeded, 0 lỗi/33 warnings, BuildReport 1.029,15 giây. APK thực tế 561.661.890 byte (535,64 MiB). BuildReport.totalSize bao gồm dữ liệu build, không phải kích thước APK chuyển qua USB.
- APK được kiểm appid, API, ABI và quyền mạng bằng aapt; install-r báo Success. App mở ở landscape 2000x1200, đã vào Town, thấy peer Windows và mở Inventory.
- Kết nối vật lý xác nhận từ tablet 192.168.0.2 tới PC 192.168.0.5:7788. Không dùng adb reverse. Windows client hiện chạy ngay trên PC host và discovery chọn virtual NIC 192.168.56.1; đây chưa phải thử một PC Windows khác qua Wi-Fi.
- Hai client standalone qua Phó bản/Arena/PvP PASS, cùng digest 10498469602584259995/9 inputs. Discovery/Unicode/đổi tên/reconnect/giữ GUID và inventory cũng PASS trên standalone.
- Mười file sở hữu có từ trước giữ nguyên Hero/item/GUID. Những tài khoản mới do người dùng nhập tên trên Windows/tablet được giữ lại. Không dev-grant hoặc reset kho thật trong test.

Chưa nghiệm thu trận đấu trên Android, reconnect sau đóng/mở app Android, Windows ở máy khác hoặc Android thứ hai. Người dùng đang trực tiếp thử trên tablet nên không cưỡng bức đóng app hay thay tên/đội hình để chạy test.

## Lỗi và giới hạn đã ghi nhận

Lượt APK đầu chọn nhầm subtarget PVRTC, chưa được cài. Editor GUI sau đó crash do log xác nhận VRAM sử dụng 15,39 GB vượt budget 3,28 GB. Build headless/Null Device với helper đã sửa đã thành công; chưa coi nguyên nhân giữ VRAM trong Editor GUI được sửa tận gốc. Không đổi renderer của game để xử lý lỗi Editor.

Log build có một thông báo licensing validation bị bỏ qua lúc startup, sau đó build vẫn thành công; không coi là lỗi gameplay. Warnings còn lại xem android-warning-review.json và log. Log riêng của app có ClassNotFoundException cho AssetPackManager lúc startup, nhưng app tiếp tục vào Town; nguồn gọi chưa xác định, chưa thêm plugin Play Asset Delivery hoặc ghi đã sửa. Theo dõi riêng nếu mở rộng sang AAB/Play Store.

Bằng chứng chính tại Artifacts/ZatodLanLoginChecks: windows-build.json, android-build.json, android-provenance.json, output-sizes.json, android-texture-verification.json, android-meta-audit-final.json, physical-connections.json, owned-final.json, tablet-install.log, ui/result.json, final-network-current.json và thư mục tablet/. Server thật/client Windows được giữ chạy; server test đã dừng.
