# Zatod Legend — Build và cài iPhone

**D39, 25/11/2026:** sau khi có bản D39 trên cả client/server, dùng tab Login hoặc Register, username/password và Server IP. IP chỉ chọn endpoint; file chung `ZatodServerData/datas.json` nằm trên máy Windows hosting và giữ qua đổi mạng/cập nhật build nếu giữ thư mục dữ liệu. Hướng dẫn D39 và trạng thái build mới tại [báo cáo persistence](zatod-player-persistence-implementation.md); các bước Connect/tên guest bên dưới mô tả bản cũ.

23/11/2026. Unity6000.6.2f1. Mac miniM4/Tahoe26.6.2, iPhone11/iOS27. Server vẫn chạy trênPC Windows; không cần clone toàn bộ project Unity lênMac.

**Quy tắc bàn giao đã chốt — Design D37:** sau nhiệm vụ code/kiểm tra trên Mac, mặc định tạo **IPA chưa ký cho Sideloadly** và báo đường dẫn tuyệt đối, thư mục chứa, kết quả kiểm tra. Chế độ khác do người dùng chọn là build/ký development/cài/chạy trực tiếp trên iPhone nối cáp với Mac, không qua Sideloadly. Windows hỏi trước đóng gói nếu chưa được yêu cầu build. Đọc hiểu hoặc sửa tài liệu/skill không kích hoạt build.

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

## 6. Luồng miễn phí từ xa: Mac build, Windows dùng Sideloadly

Chốt23/11/2026. Đây là hướng dẫn bổ sung. Người dùng đã xác nhận remote Windows vào Mac và Sideloadly trên Windows hiện tên iPhone; chưa xác nhận native build IPA, ký/cài Zatod hoặc refresh qua Wi-Fi. Mac không cần thấy iPhone trong luồng này: build app chưa ký, đóng góiIPA, rồi Windows ký/cài bằng Apple Account miễn phí. Không dùng Archive → App Store Connect/TestFlight cho luồng này.

### Chuẩn bị một lần

- Mac: setup Remote Access tại https://remotedesktop.google.com/access bằng Chrome Remote Desktop, đặt PIN và cấp quyền theo trình cài. Thử remote từPC trước khi rờiMac; giữ nguồn/Internet, không sleep lúc cần dùng. NếuMac khởi động lại và dừng ở màn mở khóa ổFileVault, có thể cần người tại chỗ mở khóa. Không tắtFileVault chỉ để tránh tình huống này.
- Mac: mởXcode hoàn tất components/điều khoản; Xcode → Settings → Locations → Command Line Tools chọnXcode đang dùng. Giải nén nguyên folderexport vào ổnội bộ. BảnZIP cũ cần workaroundBUG-062 vàBUG-063 ở mục4; sourcehelper đã có sửa cho lầnexport mới.
- Windows: tảiSideloadly64-bit và các bản **web iTunes/iCloud** từ link trên https://sideloadly.io/ . Nhà cung cấp yêu cầu bảnweb thay bảnMicrosoftStore; kiểm dữliệu đangđồngbộ trước khi thay phầnmềm hiệncó. Khởi động lạiPC sau cài dependency nếu được yêu cầu.
- iPhone: nốiPC bằng cáp truyền dữliệu, mởkhóa vàTrust. TrongiTunes chọnthiếtbị → Summary → Options → Sync with this iPhone over Wi-Fi → Apply/Sync. BậtDeveloperMode nếu chưa bật: Settings → Privacy & Security → DeveloperMode, restart rồi xácnhận. GiữUSB cho lầncài đầu.

### TạoIPA trênMac

Mỗi khi source/art/config game đổi: tạo export Xcode mới từ Unity trên Mac, hoặc chạy helper Export-ZatodXcode.ps1 trên Windows ở mục1 rồi chuyển **nguyên folder export mới** sang Mac. Lưu công việc trước khi đóng hoặc đổi trạng thái Editor. ZIP export không phải IPA. Nếu chỉ gia hạn cùng bản app, không cần chạy Unity/build Mac lại.

MởTerminal trênMac. Gõ `cd ` (có dấu cách), kéo folder chứaUnity-iPhone.xcodeproj từFinder vàoTerminal rồiEnter. Chạyblock sau trongđúngfolder đó. DùngRelease/iphoneos/arm64; khôngbuildSimulator. Khôngchạy đồngthời buildtrongXcode vàTerminal.

```bash
(
  set -e
  test -d Unity-iPhone.xcodeproj
  zatodDerived="$HOME/Builds/Zatod-iOS/DerivedData"
  zatodOutput="$HOME/Builds/Zatod-iOS/IPA-$(date +%Y%m%d-%H%M%S)"
  test ! -e "$zatodOutput"

  xcodebuild -project Unity-iPhone.xcodeproj \
    -scheme Unity-iPhone -configuration Release \
    -sdk iphoneos -destination 'generic/platform=iOS' \
    -derivedDataPath "$zatodDerived" \
    ARCHS=arm64 CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO \
    CODE_SIGN_IDENTITY="" build

  zatodApp="$zatodDerived/Build/Products/Release-iphoneos/ZatodLegend.app"
  test -d "$zatodApp"
  mkdir -p "$zatodOutput/Payload"
  ditto "$zatodApp" "$zatodOutput/Payload/ZatodLegend.app"
  # BUG-064: keep this build-only artifact outside the app before re-signing.
  if [ -d "$zatodOutput/Payload/ZatodLegend.app/Frameworks/UnityRuntime.framework" ]; then
    mkdir -p "$zatodOutput/BuildOnly"
    mv "$zatodOutput/Payload/ZatodLegend.app/Frameworks/UnityRuntime.framework" "$zatodOutput/BuildOnly/"
  fi
  ditto -c -k --keepParent "$zatodOutput/Payload" "$zatodOutput/ZatodLegend.ipa"
  unzip -t "$zatodOutput/ZatodLegend.ipa"
  open "$zatodOutput"
)
```

Chỉ lấyIPA khixcodebuild báoBUILD SUCCEEDED vàunzip khônglỗi. Block dừngkhi buildfailed, khôngđónggóiapp cũ. TênZatodLegend.app đối chiếuPRODUCT_NAME_APP trongpbxprojđãexport; nếuđổitênproductthìđiềuchỉnhpath. FileIPA này chưa ký và khôngcài trực tiếp bằngFiles/Safari; Sideloadly sẽký trênWindows. Chưa chạyblocktrênMac trongchat này. Khi lỗi giữlogđầu tiên; khôngdùngIPA cũ đểcoilàbuildmới.

ChuyểnZatodLegend.ipa vềPC bằngdịchvụchuyểnfile anh đangdùng (vídụDrive/OneDrive); đợi upload/downloadhoàntất. RemoteDesktopđểđiềukhiểnMac khôngtựđồngbộfolderbuild.

### Cài lần đầu trênWindows

1. MởiTunes kiểmđãthấy iPhone; mởSideloadly, chọnđúngiPhone.
2. KéoZatodLegend.ipa vàocửa sổ, nhậpAppleAccount. Nên dùngcùngaccountđãkýappZatodcũ nếuđãcài bằngXcode. Mật khẩu/2FA chỉ nhập vàoapp/Apple khiđượchỏi, khônggửivàochat.
3. Dùng chếđộ AppleID sideload thôngthường, giữ tùychọnmặcđịnh ởlầnđầu; bậtAutomaticRefresh. Khôngthêm tweak/JIT/đổiBundleID/đổiminOS choZatod. Local/iTunes hoặcFakeAnisette làcáchxácthựcmiễnphí hiệnđượcnhàcungcấpmôtả; RemoteAnisette làtùychọnPatreon, khôngchọncholuồngmiễnphí. Nếulỗixácthực, lấylogvàkiểmbảnmới trước, khôngmặcnhiênmuagói.
4. Start, nhậpcredential/2FA theo yêu cầu, giữiPhonemởkhóađếnkhihoàntất. NếuđượchỏiTrustdeveloper: Settings → General → VPN & DeviceManagement → đúngAppleAccount → Trust.
5. MởZatod, cho phépLocalNetwork, nhậptên/IPPCserver vàConnect theo mục5. Mac cóthểởmạngkhác, nhưng gameLAN vẫn cần iPhone kết nốiđượcPCserver; remoteMac khôngtựtạokếtnốiserver.

### Wi-Fi, cập nhật và gia hạn

- CàiUSB thànhcôngrồi rút cáp, đểPC/iPhonecùngLAN; mởiTunes/Sideloadly, mởkhóaiPhone vàkiểmđãthấythiếtbịquamạng. Nếuchưathấy, kiểmWi-Fisync/Bonjour/guestisolation, dùngUSBPCđểphânbiệtlỗimạngvàlỗiký.
- GiữSideloadlyDaemon chạy đểtựrefresh. Profile7ngàykhôngđượckéodàivĩnhviễn; daemon phảikếtnốiđượcthiếtbịvàAppleđểkýlại. Cóthểrefreshthủcôngtrướchếthạn; khôngcầnbuildMaclại nếugamekhôngđổi.
- Bảnmới: exportUnity → build/đónggóiIPAtrênMac → tảiIPA vềWindows → kéoIPA mới vàoSideloadly → giữAppleAccount/BundleIDhiệulực vàAutomaticRefresh → Start. Khônggỡapptrước. Nếuđổi từXcode sangSideloadlymàbáoxungđộtidentifier/signing, dừngvàđốichiếuIDhiệulực/Team, chưaresetapp. Chưanghiệmthu giữGUID/savequachuyểncôngcụký.
- Tàikhoảnmiễnphígiớihạn3appsideloadđanghoạtđộng, khôngphải3lầncậpnhật. Nếuquá7ngàykhôngrefresh, ký/càilạicùngIPA, khôngcầnxóaapp.

Nguồn côngcụ: https://sideloadly.io/ , https://sideloadly.io/faq.html , https://sideloadly.io/changelog.html . XcodeCLI: https://developer.apple.com/library/archive/technotes/tn2339/_index.html . Remote: https://support.google.com/chrome/answer/1649523 . Các bước buildđónggói làhướngdẫnápdụngchoexportZatodhiệntại, chưalàbằngchứngnativetest.

### BUG-064: Sideloadly không xác minh được UnityRuntime.framework

Ngày 23/11/2026. Người dùng cài IPA bằng Sideloadly gặp `ApplicationVerificationFailed`, mã `3892346881` / `0xe8008001`, chỉ rõ `ZatodLegend.app/Frameworks/UnityRuntime.framework`. Chưa cài được nên không xử lý bằng Trust Developer, đổi IP hoặc retry cùng file liên tục.

Đã kiểm trực tiếp `C:/Users/tinnq/Downloads/ZatodLegend.ipa`: có framework này trong app; hai binary ZatodLegend và UnityFramework không có load-command dependency tới UnityRuntime. Project export nhúng UnityRuntime vào app, đồng thời liên kết nó ở target UnityFramework. Unity ghi nhận UUM-151138: UnityRuntime là artifact lúc build và bản sửa của Unity bỏ nhúng nó vào app. Đây là bằng chứng cho workaround; lỗi thiết bị cụ thể còn cần cài lại để kiểm chứng.

Đã tạo `Artifacts/ZatodIosChecks/SigningFix/ZatodLegend-SigningFix.ipa` từ chính IPA tải về, chỉ loại 10 ZIP entries thuộc UnityRuntime.framework. Cả 44 entries còn lại giữ SHA256 nội dung, input giữ hash; Bundle ID/app binary/data không đổi. IPA mới cần Sideloadly **Apple ID Sideload** ký lại, không dùng Normal Install cho package vừa chỉnh. Giữ Apple Account/Bundle ID và app hiện có. Không sửa hoặc thu hồi certificate để thử lỗi này.

Tạo lại bản tương tự bằng Python trên Windows (đường output phải chưa tồn tại):

```powershell
python .\Scripts\Repair-ZatodIpa.py "C:\Users\tinnq\Downloads\ZatodLegend.ipa" ".\Artifacts\ZatodIosChecks\SigningFix\ZatodLegend-SigningFix.ipa"
```

Helper ZatodIosBuild.ConfigureUnityRuntimeEmbedding đã bỏ UnityRuntime khỏi build phases của **main app**, giữ nguyên phase liên kết của UnityFramework và embed của UnityFramework.framework. Đã kiểm bằng SDK Unity 6000.6.2f1: write/read, idempotence, linker phases và signing settings PASS. Export cũ trên Mac có thể chỉnh target Unity-iPhone → Build Phases → Embed Frameworks → bỏ riêng UnityRuntime.framework; không bỏ khỏi Link Binary With Libraries của UnityFramework, không xóa thư mục Frameworks nguồn. Cần clean output khi build lại project đã đổi. Khối đóng gói phía trên cũng chuyển bản sao UnityRuntime ra ngoài Payload để không đóng gói artifact còn sót trong build cũ.

**Trạng thái:** bản IPA workaround và helper đã qua kiểm tra cấu trúc; chưa xác nhận Sideloadly ký/cài và game chạy trên iPhone. Nguồn: https://issuetracker.unity.com/issues/24433/minimumosversion-value-in-infoplist-does-not-change-when-setting-target-minimum-ios-version-in-the-editor . Theo dõi BUG-064 trong ChangeLog.md.

## Nguồn chính thức

- Unity: https://docs.unity.com/en-us/engine/6000.6/manual/platform-specific/iphone/getting-started/ios-environment-setup
- Xcode/macOS: https://developer.apple.com/xcode/system-requirements
- Ghépđôi: https://developer.apple.com/documentation/xcode/managing-your-simulated-and-physical-devices-in-device-hub
- DeveloperMode: https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device
- PersonalTeam: https://developer.apple.com/help/account/basics/about-your-developer-account
- LocalNetwork: https://developer.apple.com/documentation/technotes/tn3179-understanding-local-network-privacy
