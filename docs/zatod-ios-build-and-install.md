# Zatod Legend — Build và cài iPhone

23/11/2026. Unity6000.6.2f1. Mac miniM4/Tahoe26.6.2, iPhone11/iOS27. Server vẫn chạy trênPC Windows; không cần clone toàn bộ project Unity lênMac.

## 1. Xuất Xcode trên Windows

Lưu và đóng Editor của **Zatod** trước khi xuất headless. Chạy PowerShell:

```powershell
cd "E:\viec\Zatod Legend"
powershell -NoProfile -ExecutionPolicy Bypass -File .\Scripts\Export-ZatodXcode.ps1
```

Cần iOS Build Support khớp6000.6.2f1. Output là folder mới `Desktop\Zatod Legend LAN Test\iOS\Xcode-<timestamp>`. Có thể truyền `-OutputPath "D:\Exports\Zatod-iOS"` với folder trống; script không ghi đè bản đã xuất. Log/report: `Artifacts/ZatodIosChecks/ios-export.json` và log cùng folder. Export thành công chưa phải đã compile native hoặc ký/cài iPhone.

Nếu xuất từ Editor: chuyển active platform sangiOS trongBuild Profiles, sau đó chọn **Zatod → Build LAN Test → iOS Xcode Project**. Không dùngBuild And Run trênWindows để cài iPhone.

## 2. Mang sang Mac

Copy **nguyên folder Xcode-<timestamp>**, gồm `Unity-iPhone.xcodeproj`, `Classes`, `Libraries`, `Data`, `Il2CppOutputProject` và mọi file/folder khác được xuất. Không chỉ copy file `.xcodeproj`. Có thể nén cả folder thànhZIP để chuyển bằngUSB hoặc qua mạng.

Giải nén/copy vào ổ nội bộ Mac, ví dụ`~/Projects/Zatod-iOS/`, trước khi build. Không cần mangLibrary/cacheUnity hoặc nguồn reverseCrystal. Nếu xuất hiện `.xcworkspace` do plugin sau này, mở workspace theo hướng dẫn plugin; bản hiện tại không dùngCocoaPods.

## 3. Xcode và Apple Account

1. Cài Xcode bản ổn định hỗ trợ iOS27.x thực tế. Bảng Apple khảo sát23/11: Xcode27.2 cầnTahoe26.6+, phù hợp26.6.2. Không cần beta theo mặc định.
2. Mở Xcode lần đầu, chấp nhận điều khoản và càiSDK/components được yêu cầu. Nếu thiếuplatform, tải trongXcode Settings → Components.
3. TrongXcode Settings → Apple Accounts/Accounts, thêmApple Account của anh. Dùng **Personal Team** nếu chưa trả phí. Không gửi mật khẩu/certificate vào chat.
4. Mở `Unity-iPhone.xcodeproj` trong folder đã copy.

## 4. Ký và cài lên iPhone

1. Cắm iPhone vàoMac bằng cápLightning truyền dữ liệu, mở khóa và chọn **Trust This Computer**. iOS27 cũng cho ghép đôi không dây: Mac/iPhone cùngWi-Fi, Xcode → Open Developer Tool → Device Hub → Add Device → Pair Nearby Device. Cáp là phương án đơn giản cho lần đầu.
2. Bật **Settings → Privacy & Security → Developer Mode** trêniPhone theo yêu cầu; khởi động lại/xác nhận nếu được hỏi. Mục này có thể chỉ xuất hiện sau khi bắt đầu ghép đôi bằngXcode.
3. TrongXcode chọn project ở cột trái, target **Unity-iPhone**, tab **Signing & Capabilities**. Bật **Automatically manage signing**, chọn **Personal Team** của anh.
4. Bundle Identifier mặc định: `com.zatodlegend.lantest`. Nếu Xcode báoID thuộcteam khác, đổi thànhID riêng, ví dụ`com.tinnq.zatodlegend.lantest`. GiữID đã chọn cho các lầnbuild sau để không thànhapp khác. Không gỡapp/xóa data để xử lýsigning.
5. Nếu targetUnityFramework báo thiếuTeam/signing, chọn cùngTeam theo hướng dẫnXcode. Không thêm multicast/AppGroups/GameCenter chỉ để bỏ cảnh báo; bản này dùngTCP trực tiếp.
6. Chọn scheme **Unity-iPhone**, run destination là **iPhone thật**, không phảiSimulator hoặcAny iOS Device.
7. Nhấn **Run ▶ / Cmd+R**. Xcode biên dịchnative, ký, cài và chạygame. Nếu iPhone yêu cầuTrust developer: Settings → General → VPN & Device Management, tin cậy đúngtài khoản rồi chạy lại. Chỉ làm khi thiết bị thực sự yêu cầu.

Lầnbuild đầu có thể lâu. Nếu lỗiSDK/device support: đối chiếu iOS thực tế vàXcode/components. Nếu lỗiC++/IL2CPP, lưu lỗiđầu tiên đầy đủ; chưa coiWindows export là đã nghiệm thuMac. PersonalTeam miễn phí có profiletest hạn7ngày; hết hạn thì ký/build/cài lại bằngXcode. TestFlight/phân phối chính thức nằm ngoài quy trình miễn phí này.

### Lỗi GameAssembly: Sandbox deny mkdir/file-read-data (BUG-062)

Nếu log chặn tạo `artifacts`, `Il2CppTempDirArtifacts` hoặc đọc `il2cpp`/`libhostfxr.dylib`, chỉnh ngay trong project Xcode đang mở:

1. Bấm project xanh **Unity-iPhone** ở đầu cột trái.
2. Trong **TARGETS**, chọn **GameAssembly**.
3. Mở **Build Settings**, chọn **All** thay vì Basic, tìm `User Script Sandboxing` hoặc `ENABLE_USER_SCRIPT_SANDBOXING`.
4. Đặt **No** cho cả **Debug**, **Release**, **ReleaseForRunning**, **ReleaseForProfiling**. Nếu dòng hiện Multiple Values, mở mũi tên để chỉnh từng cấu hình.
5. Chọn **Product → Clean Build Folder** (Shift+Command+K), rồi **Run** (Command+R).

Thiết lập này áp dụng riêng bước build IL2CPP của GameAssembly. Giữ Team/Bundle ID đã chọn; không thay entitlement sandbox của app hoặc cài đặt bảo vệ macOS. Nguồn helper đã bổ sung tự đặt No cho các lần export tiếp theo. ZIP Xcode-20261123-103416 ban đầu vẫn là bản trước sửa, cần chỉnh một lần trên Mac. Đã kiểm PBXProject bằng thư viện Unity6000.6.2f1: cả4 cấu hình đúng, signing/BundleID giữ nguyên; chưa có xác nhận native build Mac sau sửa.

### Lỗi UnityFramework: header/module verifier (BUG-063)

Nếu Issue navigator hiện nhóm lỗi AppDelegateListener/RedefinePlatforms/UnityFramework/Test như: `double-quoted include ... expected angle-bracketed`, thiếuFoundation/expected a type, umbrella header thiếuheader, `could not build module Test`, thử tắt bước kiểm framework riêng:

1. Bấm project xanh **Unity-iPhone** → trong **TARGETS** chọn **UnityFramework**.
2. **Build Settings → All**, tìm **Enable Module Verifier** (`ENABLE_MODULE_VERIFIER`).
3. Đặt **No** cho cả4 cấu hình **Debug**, **Release**, **ReleaseForRunning**, **ReleaseForProfiling**.
4. Giữ **Enable Modules (C and Objective-C)** như cũ. Không đổi từngheader củaUnity hoặc tắt toàn bộ warnings-as-errors để xử lý nhóm này.
5. **Product → Clean Build Folder** (Shift+Command+K), rồi **Run** (Command+R). Thiết lậpGameAssembly củaBUG-062 vẫn giữNo riêng như trên.

Đây là workaround tương thích cho bước Module Verifier, chưa phải sửa toàn bộ header để phân phốiUnityFramework độc lập. Nếu lỗi vẫn còn sau khi verifier đãNo, lấy lỗiđầu tiên từbuildlog mới để phân biệt compiler thật vớiVerifyModule. Helper đã bổ sung cấu hình này cho lầnexport mới; ZIP banđầu vẫn cầnchỉnh trực tiếp trênMac. Test bằngPBXProjectSDK xácnhận4configsđúng và signing/modulecompiler settings khôngđổi; nativeMacbuild vẫn chờxácnhận.

## 5. Kết nối LAN

1. TrênPC chạy `Desktop\Zatod Legend LAN Test\Server\Start-Server.cmd`, giữserver hoạt động.
2. ChoPC vàiPhone vào cùngLAN. Wi-Fi guest/công ty có thể bật cô lậpthiết bị dù cùngSSID.
3. TrênPC chạy`ipconfig`, lấy **IPv4 củaWi-Fi/Ethernet đang dùng**. Không lấyIPVirtualBox/vEthernet/VPN, IPinternet hayIPMac. Ví dụ`192.168.1.23`.
4. Tronggame nhậptên và **Server IP**, bấmConnect. Chỉ gõIPv4, không gõ`http://` hoặc`:7788`; portmặc định7788.
5. Khi iOS hỏi **Local Network**, chọnAllow. Nếu lỡ từchối: cấp lại trongSettings củaapp hoặcPrivacy & Security → Local Network.
6. AppnhớIP saukhi kết nối thành công. ĐổiWi-Fi thì sửaIPPC mới, không cầnbuild lại. Android/desktop tựdòđiềnIP khi mởlogin, có nút **Find LAN** để tìm lại và vẫn nhập tay được. ĐểtrốngIP rồiConnect cũngtìm lại trênAndroid/desktop. iOSkhông dùngbroadcast/Find LAN.
7. Cài xong có thể rút cáp, đóngXcode/Mac. Chơi chỉ cầnPCserver vàiPhone liên lạcđược quaLAN. `127.0.0.1` trênđiện thoại trỏchínhđiện thoại, khôngphảiPC.

iPhone cóaccountGUID riêng; nhập cùngtênAndroid không tự chuyểnkho. Kiểm Town/joystick/peers, UIhai chiều/notch/bànphím/quyềnLAN, Phóbản, Arena, PvP/replay giữa cácnền tảng saucài. Các bước thiết bị thật này chưa được kiểm bằngWindows export.

## Nguồn chính thức

- Unity: https://docs.unity.com/en-us/engine/6000.6/manual/platform-specific/iphone/getting-started/ios-environment-setup
- Xcode/macOS: https://developer.apple.com/xcode/system-requirements
- Ghépđôi: https://developer.apple.com/documentation/xcode/managing-your-simulated-and-physical-devices-in-device-hub
- DeveloperMode: https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device
- PersonalTeam: https://developer.apple.com/help/account/basics/about-your-developer-account
- LocalNetwork: https://developer.apple.com/documentation/technotes/tn3179-understanding-local-network-privacy
