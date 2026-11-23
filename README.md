# Zatod Legend

Unity 6000.6.2f1, URP2D, Mirror/Telepathy. Đọc [Design.md](Design.md), [AGENTS.md](AGENTS.md) và [ChangeLog.md](ChangeLog.md) trước khi làm việc.

Project hiện dùng bộ Crystal: 25 Hero, 14 quái, 39 ải/117 wave trong hai chương; combat core8Hz. Phó bản client mô phỏng và server validate, Arena tự động và PvP realtime dùng chung core. Kho, Hero và lịch sử GUID lưu riêng theo development profile; tiến độ ải reset mỗi lần mở ứng dụng.

- Chơi/server/hai client: [docs/zatod-prototype-play.md](docs/zatod-prototype-play.md).
- Scene: `Unity/Assets/Zatod/Scenes/ZatodPrototype.unity` và `ZatodBattle.unity`.
- Config: `GameEditor > Open`, các bảng Hero/Monster/Items/Stats/Skills/Buffs/Campaign, craft, sao, progression và maps.
- BuildWindows: `Zatod > Tools > Build Windows Prototype`; bản chuẩn `Builds/ZatodPrototype/ZatodLegend.exe`, serverTCP7788.
- Kiểm tra core: `dotnet run --no-restore --project Tests/CrystalChecks/CrystalChecks.csproj`; model Hero: `Tests/HeroChecks/HeroChecks.csproj`.

Theo D33 ngày22/11/2026, nhánh pixel trướcCrystal, scene ArenaPrototype, combat20Hz, UI/network/preview và các bản build cũ đã được loại khỏi source hiện hành. Save và archive trên đĩa được giữ; player mới không còn hỗ trợ replay outcome của prototype trướcCrystal. ReplayCrystal/Zatod vẫn được hỗ trợ.

Tài liệu các Hero pixel và kiến trúc20Hz còn trong `docs/` là lịch sử triển khai, không phải hướng dẫn chạy hiện tại. Nguồn reverse ở `Crystal Legend/` nằm ngoài Unity/Assets và được giữ để đối chiếu.
