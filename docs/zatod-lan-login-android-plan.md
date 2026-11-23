# Khảo sát chuẩn bị Android và login LAN đơn giản

Ngày22/11/2026. Yêu cầu D32: máy PC hiện tại hosting,1 Windows và2 Android client cùng server; thay màn kết nối prototype bằng nhập tên/Kết nối. Chỉ khảo sát trong lượt này, chưa cài/sửa/build.

## Những phần đã đủ nền

Mirror/Telepathy đã hỗ trợ direct LAN; serverWindows lắng nghe toàn interface, port7788; có kiểm chứng cùng host quaIPv4LAN. PC hiện nối SSID Double Meow 5G, Wi-Fi192.168.0.5/gateway192.168.0.1. Thiết bị có thể ở2.4GHz/5GHz hoặc Ethernet nếu cùngLAN và router cho liên lạc. Cần nghiệm thu thực địa3client cùng lúc, không suy từ smoke cùngPC. Không cần Unity trên máy người thử; Windows nhận full build, Android cần APK.

## Chuẩn bị Android

- Cài Android Build Support đúng Editor6000.6.2f1, cùng SDK/NDK/JDK; hiện module AndroidPlayer chưa có.
- Giữ landscape/safe area và Fixed joystick. Kiểm input tên/bàn phím điện thoại, font tên có dấu, chạm/multitouch và Back/Disconnect.
- Cấu hình hiệnARM64/minAPI26; cần đối chiếu thiết bị thực tế trước nghiệm thu. Xác nhận INTERNET permission trong manifest APK cuối; ForceInternetPermission hiệnAuto, chưa có APK để nghiệm thu.
- BundleWindows10.75GiB không dùng làm ước tính APK. Rà Resources/texture compression/phạm vi asset đóng gói để APK cài được và mobile đủRAM; không xóa nguồn tham chiếu hoặc tài nguyên cũ. Cần đo dung lượng/khởi động/FPS trên máy thật.
- ỔE hiện9.3GiB, từng fail build vì thiếu dung lượng theo BUG-051; C74.8GiB. Chọn nơi cài toolchain/output và kiểm cả cache/intermediate; chưa di chuyển/xóa dữ liệu ở lượt khảo sát.

## Login và tên — đề xuất cần chốt

- View art Crystal, landscape: tên người chơi + Kết nối; trạng thái kết nối/lỗi rõ, thành công vào town; không mật khẩu/đăng ký.
- CharacterData đã có Name, WorldPlayerState đã có Name. Hello hiện chưa gửi tên, JoinWorld tạo Player +5ký tựGUID. Khi làm phải nối gửi/lưu/hiển thị tên qua server và snapshot, không chỉ đổi text local.
- Đề xuất giữ GUID hiện tại theo thiết bị và dùng tên để hiển thị. Tên trùng không tự chia kho hoặc đăng nhập account người khác; đổi tên không reset Hero/item. Cần chốt chính sách trùng/đổi tên và cách nhận diện trên3máy.
- Client vẫn cần endpoint server. Đề xuất giấu endpoint trong config test, hướng tới IP PC ổn định hoặc chỗ đổi endpoint khi DHCP đổi; SSID không thay địa chỉ server. Chưa triển khai discovery/broadcast hoặc thay router.
- Panel prototype còn làm menu Arena/PvP/Replay/feature. Tách login khỏi menu chức năng; thay View kết nối không được làm mất luồng vào mode hoặc công cụ test cần dùng. Không suy yêu cầu bỏ màn này thành xóa combat/replay/dev tools.
- PC phải giữ server chạy và tránh sleep khi đang thử. Server có thể chạy cùng một Windows client trên PC; các thiết bị khác cùng bản config/protocol/server. Không thay account GUID theo tên.

## Nghiệm thu dự kiến khi được thực thi

1. Toolchain sẵn; Windows build và APK từ cùng source/config.
2. Login/đổi lỗi/retry hoạt động; server xác nhận tên và3 thiết bị thấy đúng tên/vị trí.
3. World/portal/interest; phó bản/progress riêng; PvP realtime giữa Windows–Android và Android–Android.
4. Kho/receipt và reconnect giữ riêng từng account; input mobile/safe area/memory/khởi động kiểm trên thiết bị thật.

Đây là đề xuất trình trước triển khai; chưa ghi mọi chi tiết trên thành quyết định đã chốt hoặc là công việc đã hoàn thành.

## Làm rõ tiếp22/11

- Đồng ý GUID riêng/tên hiển thị. Khi PC đổi mạng, địa chỉLAN có thể đổi; kỳ vọng cùngLAN vẫn chỉ nhậpTên/KếtNối. Đề xuất discovery tự tìm server, không đóng đinh IP nhà vào APK; chưa sửa code discovery ở lượt rà này. Mạng công ty/guest phải cho peer traffic.
- Arena/PvP/Replay vàoNPC, giữ mode/record hiện có. Town đã có interactionArena/PvP, cần thể hiện bằngNPC và bổ sungReplay; chưa sửaworldconfig/visual.
- Người dùng cho phép tự cài Android dependencies khi thực thi; đã dry-run danh sáchmodule đúng6000.6.2f1, chưa chạyinstaller hoặc chấp nhậnEULA trong lượt rà yêu cầu.
- Desktop thực tế C:/Users/tinnq/OneDrive/Desktop. Đã tạo Zatod Legend LAN Test/{Windows,Android,Server}; buildD32 chưa xuất. Đặt build cuối ở đây theo yêu cầu, không đưa file kiểm tra/historical build vào giả bản mới. Server có thể dùng binaryWindows chung thay nhân đôi11GB.

## Tablet và đổi đích output Android22/11

Người dùng đã cho phép USB debugging trên OPPO Pad Air/OPD2102A. ADB trạng tháidevice; Android13/API33; arm64-v8a/armeabi-v7a/armeabi; data trống11G. Tablet IP192.168.0.2/24, cùngLAN vớiPC192.168.0.5. Đây là xác nhận USB/khả năngđiềukhiểnADB và thông sốthiếtbị, chưa là kiểm thửAPK/game.

Đích Android mới: tạoAPK tạm trênPC rồi cài/chạy quaUSB vào tablet đã chọn, không cần bảnAndroid trong Desktop/Zatod Legend LAN Test/Android. Giữ data app khi cài cập nhật, không tự clear/uninstall nếu signature mismatch. Windows/server vẫn xuấtDesktop. ADB có sẵn ở bộUnity2022 được dùng để kiểmUSB; moduleAndroid/toolchain6000.6.2f1 vẫn cần cài khi triểnkhai. Không dùngadb reverse để thay thế nghiệm thuLAN thật.
