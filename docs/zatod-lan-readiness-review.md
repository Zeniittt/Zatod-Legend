# Kiểm tra mức sẵn sàng LAN — Windows và Android

Ngày22/11/2026, Asia/Saigon. Người dùng yêu cầu chỉ kiểm tra hiện trạng, chưa sửa code/gameplay/config, chưa build Android hoặc cài module. Giữ Mirror/Telepathy hiện có theo Design D02/D03/D24. Script chạy kiểm thử chỉ nằm trong Artifacts, không import vào Unity/Assets.

## Kết luận

- Windows: kiến trúc hỗ trợ LAN trực tiếp qua TCP, bản chuẩn đã qua hai cặp standalone client dùng IP Wi-Fi của host192.168.0.5. Đây là kiểm tra cùng máy dùng địa chỉ LAN; chưa chứng minh kết nối qua router giữa hai thiết bị vật lý.
- Android: chưa sẵn bản để phát cho người thử. Không có APK/AAB trong Builds; Unity6000.6.2f1 hiện thiếu PlaybackEngines/AndroidPlayer (Android Build Support). Chưa build/cài/chạy trên điện thoại hoặc kiểm thử Windows–Android. Có joystick, UI landscape và cấu hình ARM64/minAPI26; đây là cấu hình nguồn, không thay nghiệm thu thiết bị. ForceInternetPermission hiện0 (Auto), chưa có manifest build để xác nhận permission thực tế.

## Bằng chứng Windows

- ZatodConnection nhận --server và --zatod-port, mặc định127.0.0.1:7788. Client có ô IP và nút Kết nối, Start-ZatodClient.ps1 có tham số Server/Port. Mỗi máy phải trỏ về IP LAN máy chạy server;127.0.0.1 chỉ trỏ chính thiết bị đang chạy client.
- Server dùng NetworkServer.Listen(32); Telepathy.Server tạo TcpListener.Create(port), lắng nghe mọi interface, không khóa loopback.32 là giới hạn cấu hình, chưa load test32 người.
- Test port17997, listener IPv6Any(::)/IPv4 dual stack; world_left/right cùng thấy nhau di chuyển, đi chương1/2, interest theo map, tiến trình riêng và private battle PASS. left/right hoàn tất Campaign/Arena/PvP; hai phía PvP cùng digest8563948108897214882,8 inputs. Dữ liệu fixture riêng trong thư mục evidence/server; không chạy dev/grant vào server7788.
- Server test PID23104 và các client đã tự dừng. Server có sẵn PID33916/path Builds/ZatodPrototype/ZatodLegend.exe/cổng7788 đang chạy từ19:01:37; giữ nguyên, không dừng hoặc khởi động lại.
- Wi-Fi hiện192.168.0.5/gateway192.168.0.1, profile Public. Windows Firewall có rule Allow TCP/UDP Private,Public cho đúng executable bản chuẩn, port/remote Any. Không sửa firewall hoặc network profile. Chưa kiểm chứng guest isolation/router hoặc chính sách máy client khác.

## Những điểm ảnh hưởng buổi thử

- Windows Player di chuyển bằng kéo joystick với chuột; WASD/mũi tên chỉ có trong Editor theo D24 đã chốt. Đây là hành vi hiện tại, không tự đổi lại.
- PvP realtime ghép hai người online. Arena hiện dùng đội mẫu tạo bởi CreateDemoCharacter, chưa lấy đội phòng thủ của tài khoản người khác. Có trận Arena/replay không có nghĩa đã có hệ xếp hạng Arena.
- Phó bản riêng từng người; world chung cùng server/map. Kho/Hero/Gold giữ riêng theo GUID account dev trong PlayerPrefs; nhiều client trên cùng Windows cần Profile khác nhau để tránh account đã online. Chưa có màn đăng ký/đăng nhập tài khoản chính thức.
- Bản Windows218 file tổng10.75GiB; phải chia sẻ cả thư mục build, không chỉ file.exe. Chưa tối ưu gói phát thử trong lượt khảo sát.
- Để thử Windows thực tế: máy server giữ7788; các máy cùngLAN mở bản client cùng phiên bản, nhập192.168.0.5 rồi Kết nối. Nếu IP Wi-Fi đổi phải cập nhật. Android còn cần chuẩn bị toolchain/build/cài và nghiệm thu sau khi có lệnh thực thi.

Nguồn: Unity/Assets/Zatod/ArenaNetwork/ZatodConnection.cs, ZatodServer.cs, ZatodSmokeClient.cs; Mirror/Transports/Telepathy/Telepathy/Server.cs; Scripts/Start-ZatodClient.ps1, Start-ZatodServer.ps1; ProjectSettings.asset; docs/zatod-joystick-implementation.md. Evidence Artifacts/ZatodLanChecks/20261122-192258/result.json và4 log/result client. Không suy kiểm thử cùng host thành đã kiểm chứng LAN nhiều thiết bị hoặc Android.
