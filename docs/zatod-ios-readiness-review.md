# Khảo sát iOS — 23/11/2026, đã được yêu cầu triển khai

Khảo sát ban đầu chỉ đọc. Thiết bị do người dùng xác nhận: Mac mini công ty, Apple M4, macOS Tahoe26.6.2; iPhone11/iOS27; chưa có Apple Developer Program trả phí. Bổ sung23/11: đã chọn IP trực tiếp cho test iOS ban đầu, sau đó yêu cầu thực thi form Server IP cho iOS/Android và xuất Xcode. Các ghi nhận “chưa có/chưa sửa” bên dưới là hiện trạng trước triển khai; xem Design.md, docs/zatod-ios-build-and-install.md và Artifacts/ZatodIosChecks để đối chiếu kết quả mới.

## Hiện trạng project

- Unity6000.6.2f1; bản Windows hiện có Android/Linux/Windows support, chưa thấy iOS support trong PlaybackEngines.
- Build helper ZatodLanBuild mới xử lý Windows/Android, chưa có helper/profile xuất Xcode. PlayerSettings chưa khai báo applicationIdentifier riêng iOS, TeamID trống, signing chưa bật. Min iOS hiện là15.0 nhưng chưa được build/test.
- Hai scene đang bật: ZatodPrototype và ZatodBattle. Landscape hai chiều, safe area và joystick đã có theoD22/D24; vẫn phải thử notch/home indicator, bàn phím và pause/resume trên iPhone thật.
- Runtime dùng Mirror/Telepathy TCP; ZatodLanDiscovery gửi UDP broadcast qua NetworkDiscoveryBase. Chưa có plist/entitlements hoặc postprocessor iOS về local network/discovery.
- 767sheet Hero/effect mới có override Android ASTC6x6 và Standalone; override Android không áp sang iPhone. Cần cấu hình nén iOS riêng khi được triển khai, giữ pixel/sprite rect/pivot/timeline/GUID theoD04/D10.
- Kiểm danh sách plugin chưa thấy native thư viện Windows mà runtime Zatod đang phụ thuộc bắt buộc. DLL thấy được thuộc Mirror/BouncyCastle/Mono.Cecil; cần compile iOS/IL2CPP và kiểm importer, không coi quét tên file thay thế kiểm tương thích.
- Assets+Packages+ProjectSettings hiện khoảng1,433GiB,9.066file. Nếu chuyển Unity project để phát triển trên Mac, giữ toàn bộ.meta; không cần copy Library/Temp/obj hoặc build/cache cũ. Nguồn reverse Crystal ngoàiAssets không phải đầu vào runtime của bản build hiện tại.

## Môi trường và luồng build đề xuất

Unity xuất project Xcode; Mac/Xcode biên dịch, ký và cài iPhone. Có thể thêm iOS Build Support đúng6000.6.2f1 trên PC để xuất Xcode, chuyển folder kết quả sang Mac. Không bắt buộc cài Unity trên Mac nếu chỉ nhận Xcode project; nếu muốn phát triển/debug đầy đủ trên Mac thì cài cùng Unity/module và chuyển project nguồn.

MacM4/Tahoe26.6.2 đáp ứng yêu cầu macOS26.6+ mà Apple công bố cho Xcode27.2. Đề xuất dùng bản Xcode ổn định phù hợp phiên bản iOS27.x thực tế, không tự cài beta hoặc nâng Unity trong lượt khảo sát. Cần tải SDK/device support, đăng nhập Apple Account trong Xcode, ghép đôi/Trust và Developer Mode trên iPhone. Cáp Lightning truyền dữ liệu là phương án cài/test đề xuất để ổn định, không bắt buộc cho mọi trường hợp: tài liệu Device Hub hiện tại cho phép ghép đôi không dây ngay từ đầu với iOS27+ trên cùngWi-Fi. Sau khi cài app, chơiLAN không cần giữ dây hoặc kết nối vớiMac; PC server vàiPhone cần liên lạc được trênLAN.

Apple Account miễn phí có thể ký bằng Personal Team để test máy cá nhân; profile hết hạn sau7ngày nên cần build/cài lại. Chưa cần mua membership chỉ để bắt đầu thử trên máy anh. TestFlight/phân phối hoặc capability quản lý cần xem gói/quyền tương ứng; trả phí không tự bảo đảm được Apple duyệt multicast.

Cần BundleID ổn định, signing team/profile/certificate do Xcode quản lý, IL2CPP/ARM64, Metal và thiết lập iOS riêng. Dùng lại Hero/UI/SPUM hiện có; chưa cần bộ art mới. Icon/launch screen có thể hoàn thiện sau test nội bộ. Chừa dung lượng cho Xcode/SDK, cache/DerivedData và bản build; chưa đo ổ trống/RAM trên Mac, không lấy kích thướcAPK535MiB suy ra IPA hoặc RAM.

Kinh nghiệm BUG-058/059: helper phải tách thông số từng nền tảng; ưu tiên xuất headless ở Windows để tránh lặp tình huống Editor DX12 vượt VRAM. Metal của app vẫn render bình thường. Chưa chạy export hoặc đo dung lượng/thời gian iOS.

## LAN — đã chốt IP trực tiếp ban đầu, chưa sửa

Cần NSLocalNetworkUsageDescription và xử lý lần người dùng cho phép/từ chối Local Network; không coi timeout15giây hiện tại là cách phân biệt đầy đủ mọi trạng thái quyền.

Apple quy định IP multicast/broadcast cần entitlement com.apple.developer.networking.multicast, thuộc diện Apple cấp quyền. Không mặc định Personal Team hiện tại đã có entitlement hợp lệ. Đây là yêu cầu nền tảng và khoảng trống cấu hình, chưa là lỗi đã tái hiện trên iPhone.

Quyết định và các phương án còn lại:

1. **Đã duyệt23/11:** kết nối trực tiếp IP/unicast cho test iOS đầu, vẫn cần quyền Local Network. Ngoại lệD32 chỉ áp dụng iOS; discovery Windows/Android giữ nguyên. Chưa sửa code/UI. Hướng đề xuất: Name + Server IP + Connect, lưu IP gần nhất và cho sửa; không hardcode địa chỉ trong build.
2. Giữ UX tự tìm bằng Bonjour hệ thống với service type cụ thể: cần thêm quảng bá service ở PC và native browse/resolve iOS, khai báo NSBonjourServices. Chưa có trong project. Không đổi raw UDP sang tự gửi mDNS rồi coi đã tránh entitlement.
3. Giữ broadcast hiện có: kiểm signing capability và xin entitlement theo Apple, không coi đăng ký Developer trả phí là đã được duyệt.

Server tiếp tục chạy trên PC Windows. Khi thử LAN, iPhone và PC cần cùng mạng và router cho phép peer traffic; Mac chỉ dùng build/ký/cài, không bắt buộc phải làm server hoặc luôn ở cùng LAN. Cần thử thiết bị thật vì Simulator không thay kiểm quyền Local Network.

Cùng LAN không đồng nghĩa client tự biết IP server. Discovery hiện tại lo bước dò endpoint trên Windows/Android; flow IP trực tiếp sẽ dùng địa chỉ người dùng nhập. Khi chuyển router/mạng, DHCP có thể cấp PC một IPv4 LAN khác: đọc IPv4 của adapter Wi-Fi/Ethernet đang nối LAN bằng ipconfig hoặc Windows Settings, cập nhật Server IP rồi Connect; port TCP7788 giữ nguyên nếu server không đổi cấu hình. Ví dụ192.168.0.5 ở nhà thành192.168.1.23 tại công ty. Đây là IP PC host, không phải IP internet, iPhone hay Mac. Không cần rebuild chỉ để đổi IP với UI đề xuất; hiện tại login mới có Name/Connect, chưa có ô IP.

## Nghiệm thu cần làm khi được phép triển khai

Cài module/SDK và tạo cấu hình iOS; compile/export, ký và cài; đo texture/package/RAM/FPS; kiểm login/joystick/UI/notch/keyboard; kiểm kết nối và từ chối/cấp lại quyền LAN; kiểm trận Phó bản, Arena và PvP/replay/digest giữa Windows–Android–iOS. Giữ dữ liệu GUID, không tự reset/gỡ app để xử lý signing.

Không đổi gameplay/server/config hiện có trong khảo sát này. Chỉ ghi nhận yêu cầu, hiện trạng và các phương án để người dùng chốt sau.

## Nguồn chính thức đối chiếu

- Unity6.6 iOS setup: https://docs.unity.com/en-us/engine/6000.6/manual/platform-specific/iphone/getting-started/ios-environment-setup
- Unity6.6 compatibility/Metal: https://docs.unity.com/en-us/engine/6000.6/manual/platform-specific/iphone/ios-introducing/ios-requirements-and-compatibility
- Apple Xcode/macOS: https://developer.apple.com/xcode/system-requirements
- Apple Personal Team/7ngày: https://developer.apple.com/help/account/basics/about-your-developer-account
- Apple Developer Mode: https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device
- Apple Device Hub/cable/wireless pairing iOS27+: https://developer.apple.com/documentation/xcode/managing-your-simulated-and-physical-devices-in-device-hub
- Apple local network: https://developer.apple.com/documentation/bundleresources/information-property-list/nslocalnetworkusagedescription
- Apple multicast entitlement: https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.developer.networking.multicast
- Apple managed capabilities: https://developer.apple.com/help/account/reference/provisioning-with-managed-capabilities
- Apple LAN/Bonjour/unicast/Simulator: https://developer.apple.com/documentation/technotes/tn3179-understanding-local-network-privacy
