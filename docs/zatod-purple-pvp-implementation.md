# D34 — Triển khai và nghiệm thu

Ngày 24/11/2026 (Asia/Saigon). Quyết định hiện hành: [Design D34](../Design.md#d34--mở-rộng-tới-tím-và-danh-sách-hero-pvp-riêng). Checklist: [phase-plan](zatod-purple-pvp-phase-plan.md).

**Trạng thái hiện tại:** đã triển khai và kích hoạt catalog D34, hoàn tất kiểm core/Unity/TCP và hai lượt farm từ account mới; đã xuất/biên dịch/kiểm IPA arm64 chưa ký. Các giới hạn nguồn, balance và thiết bị được ghi bên dưới; không gọi các nhánh STR/AGI/INT tạm hoãn là parity đầy đủ. Các mốc art 25 Hero trước đây là lịch sử.

## Nội dung và combat

| Hạng mục | Phạm vi đã triển khai |
| --- | --- |
| Hero | 66 definition: 25 cũ +15 bổ sung vào pool +26 Hero encounter |
| PvP miễn phí | Đúng 40 Hero; tối đa 5; Lv60/3 sao/Tím thường; ô đồ Tím trống; 4 skill chính Lv60 |
| Quái | 42 definition, gồm các dependency summon bình thường cần thiết |
| Kỹ năng | 449 definition; 264 skill chính của 66 Hero, đủ 792 mốc Evo trong cap80 |
| Phần mới | 85 skill/255 Evo của pool và 104 skill/312 Evo của encounter, cùng hook/dependency |
| Tiến bậc | Blue → Blue+1 → Blue+2 → Purple; không mở Purple+ |
| Đồ/recipe/stat | 267 item, 109 recipe, 30 stat trực tiếp |
| Campaign/world | 8 chương, 154 ải/462 wave, 9 map kể cả Town; thêm 115 ải/345 wave |
| Loot mới | MaxDropAmount5, tỷ lệ đều trong từng pool, tổng100%; giữ39 ải/loot cũ trừ gắn BGM |

Catalog có version `zatod-d34-v7-3b14df41db3fe55e`, hash từ toàn bộ Data canonical. Cờ `Heroes.txt.UseExpandedCombatRules` chọn V7 cho mọi trận mới của catalog, kể cả starter chưa mở skill thứ tư. Snapshot giữ đầy đủ buff, skill/dependency, summon/form và Evo; archive V3–V6 tiếp tục phát lại theo rules đã chụp.

Các hook đã port gồm aura/region, projectile/chain, shield/reflect/absorb, charm/taunt/stealth, summon và lifetime/death, Phoenix egg, PA/LYC/TB/UD form, gấu Druid và nhện/bia mộ. Buff kiểm accuracy theo chênh lệch skill/target level, resist, điều kiện điều khiển; knock có hệ số Titan/KnockRES. Static passive thuộc tính chính chuyển thành stat trực tiếp theo D05; không đưa STR/AGI/INT trở lại runtime.

## Bằng chứng kiểm tra

Báo cáo chi tiết local nằm ở `Artifacts/D34Completion/`; fixture trong `Tests/` và scripts trong `scripts/` đi theo repository. Không cần mang Artifacts làm đầu vào importer.

| Kiểm tra | Kết quả/bằng chứng |
| --- | --- |
| Legacy core / Hero | 8.051 /112 đạt, dùng baseline cố định; `compatibility-final.log`, `hero-checks-final.log` |
| Native core | 3.017 kiểm: boundary960, encounter312, smoke66 Hero ở skill60/80,528 mô tả, replay và outcome; `expanded-combat-final.log` |
| Importer | 6 Python tests đạt; `python-import-final.log` |
| Nội dung / đường đi | Preflight0 issue, routes359; `content-preflight-final.log`, `world-routes-v33.log` |
| Art nhân vật | 129.040 kiểm;1.145 action/39.244 frame;3.435 sprite samples; `all-actors-audit-v33.json`, `all-actors-samples-v33.json` |
| FX | 324 resource/502 clip/1.506 samples;3 kiểm world-size của FX lớn; `effect-audit-v33.json` |
| Native/world art | 903 assets,120 prefabs; `native-art-v33.json` |
| Resources | 2.958 kiểm/419 AnimationSet; chỉ15 audio thiếu ngay trong nguồn; `resource-audit-v33.json` |
| Unity JSON/archive | 126 kiểm,40 preset,snapshot/gzip129.410 byte; `schema-roundtrip-final.json` |
| Unity ↔ .NET | 40 digest preset cùng kết quả; hai gzip replay TCP thật cùng digest/end/winner; `cross-runtime-final.log`, `native-*-cross-runtime.log` |
| PvP TCP V7 | 5v5,40 roster,212 tick; digest760456589888603090; `native-pvp-v33-final/pvp-loopback.json` |
| Campaign TCP V7 | 314 tick; digest4377234381563837632;6 tick vào sân ở cả wave2/3;495 Gold; `native-campaign-world-final/campaign-loopback.json` |
| World/preview TCP | 15 lượt portal qua9 map và về; preview toàn154 ải theo fixture Campaign |
| Save all/GameEditor | 19 kiểm; lỗi giữa chừng rollback đúng byte, giữ draft, retry thành công; `native-world-authoring-v33.json` |
| Save/Promote/UI | 32 kiểm,36 GUID đồ hấp thụ giữ nguyên; `native-rank-v33.json` |
| Native visual | 63 kiểm,11 shader/8 form, layer/freeze/death/HUD; `native-visuals-v33.json` |
| Audio/wave/HP | 14/nhịp vào wave/9 kiểm đạt; `native-audio-v33.json`, `native-wave-v33.json`, `health-bars-final.json` |
| Tỷ lệ màn hình | 547 kiểm:1600×900,2436×1125,2400×1080,1600×1200 và cutout; `native-responsive-v33.json` |
| Summon trình bày | V6 vàV7 đều qua clone/named template, Unity serialize/replay; V7 giữ death/fade; `summons-v[67]-final.json` |

PvP TCP dùng catalog thật và các Hero mới, không sửa sát thương/kỹ năng để làm fixture thắng. Đã kiểm server chặn quá5/trùng Hero/ID owned instance; roster key thiếu hoặc cũ; UI không cho roster lệch; queue/cancel/reconnect, lỗi ghép cặp rồi thử lại. Cả hai team có manual input, chặn bấm lặp khi chờ, cast cue hiện lại khi tua; HeroDesk trước/sau không đổi. Arena/Campaign vẫn dùng Hero sở hữu.

## Đường farm

Lượt nghiệm thu dùng seed117, account và năm Hero khởi đầu nguyên trạng, đúng phần thưởng Campaign, nâng cấp/ghép/mặc đồ và chờ hồi thể lực hợp lệ. Không cấp đồ/vàng/sao từ fixture vào lượt farm. Sau một lần thua, bot farm ba trận rồi thử lại; dành Gold cho món đã đủ nguyên liệu trước khi nâng skill; dừng khi cả154 ải đã qua và năm Hero đều đạt Tím. Tiếp tục mặc ô Tím khi còn tiến Campaign nhưng không promote vượt Tím.

**Đã đạt hai lượt tự nhiên**, cùng seed117 và Data active:

| Chỉ số | Auto/farm cũ | Farm biết lùi ải |
| --- | --- | --- |
| Tổng trận / thắng | 44.082 /11.317 | 22.286 /15.679 |
| Clear / bậc | 154/154,5 Hero Tím | 154/154,5 Hero Tím |
| Đủ cả5 Tím trước trận | 25.280 | 8.072 |
| Player / Hero cuối | 71 /70 | 71 /71 |
| Skill cuối | 53–56 | 59–62 |
| Gold chi | 12.721.700 | 16.947.100 |
| Thể lực chi | 101.969 | 102.656 |
| Chờ hồi thể lực mô phỏng | 372,47 ngày | 393,56 ngày |
| Tổng thời gian mô phỏng | 406,40 ngày | 409,26 ngày |

Chiến lược mới không thay economy: nếu một ải đã clear nhưng thua khi farm, bot tạm lùi ải cho đến khi min Hero tăng cấp hoặc đã qua64 trận, rồi thử lại. Ở lượt cũ sau trận40.000, bot farm7-20 tới3.056 lần nhưng chỉ thắng5 lần; đây là nguyên nhân xác nhận của đoạn Gold gần như đứng yên. Lượt mới đã hoàn tất đủ154 vàTím sau22.286 trận, không dùng account/tài nguyên từ lượt cũ.

**Kết luận balance:** đã chứng minh đường đi hợp lệ, nhưng farm chỉ bằng thưởng Normal/recovery hiện hành rất nặng. Giảm số trận không giảm tương ứng thời gian lịch vì XP/thể lực và lượng hồi trong thời gian đánh. Chưa chỉnh reward/EXP/giá/regen hay cấp sao để làm báo cáo đẹp; daily quest/nguồn tài nguyên khác không nằm trong bài chạy. Đây là số liệu để cân bằng ở lượt được duyệt tiếp, không phải lời bảo đảm người chơi thông thường phải chơi đúng số ngày này. D11 vẫn giữ reset tiến trình ải/star mỗi app launch, Hero/đồ tiếp tục được giữ.

Bằng chứng: `farm-comparison.json`, `farm-acceptance-summary.json`, `farm-playthrough-v33-117.json`, `farm-playthrough-reliable-v2-117.json`. Các lượt v7/v31 trước đó chỉ giữ tạm vì chưa đủ hook hoặc starter còn có thể chọn rules cũ.

Probe riêng dùng đội thử đủ đồ/cấp để chẩn đoán khó, không dùng làm bằng chứng farm. Ải7-20 và8-20 đều thắng được với đội1 sao đủ lực; thua ở cấp thấp hơn cho thấy phải kiểm chi phí/cấp/skill thực tế. Không sửa balance/loot để ép kết quả.

## Tái tạo và migration

`Tests/Fixtures/D34Baseline/` giữ14 file Data trước kích hoạt, kèm SHA256; đây là definition, không có save cá nhân. Nó giữ đầu vào legacy/import ổn định sau khi catalog runtime mở rộng. Lệnh mặc định CrystalChecks chạy phần legacy rồi tự kiểm native3017 trên Resources khi cờ V7 đã bật, nên không bỏ qua catalog đang dùng. Reference gốc vẫn ở `Unity/Assets/Crystal Legend/`, alias ở `ZatodContentIds.cs`. Các mapper parse Lua như dữ liệu, không thực thi Lua.

```sh
python3 scripts/Build-ZatodD34Content.py --output Artifacts/D34Rebuild/Data
python3 -B -m unittest discover -s Tests -p test_d34_hero_import.py
dotnet run --project Tests/CrystalChecks -- --d34-content-preflight Tests/Fixtures/D34Baseline Artifacts/D34Rebuild/Data
dotnet run --project Tests/CrystalChecks -- --d34-combat Artifacts/D34Rebuild/Data
dotnet run --project Tests/CrystalChecks -- --d34-farm-playthrough 117 100000 Artifacts/D34Rebuild/Data purple
```

Bản dựng từ baseline tracked có Data byte-identical với Candidate-v33. 8.040 GUID tài nguyên hiện hữu đối chiếu không đổi;1.228 file Art/Resources được bổ sung/cập nhật từ workspace kiểm. Giữ alias/ID item/slot, GUID đã hấp thụ, level skill cũ và lịch sử Hero; không chỉnh Owned thật. Bind save cũ bổ sung slot mới bằng InitialLevel, slot vẫn khóa theo rank; preset PvP tách biệt với save. D11 tiếp tục reset tiến trình/star Campaign theo mỗi lần mở app. Giao dịch chỉnh config có rollback và receipt/revision gameplay vẫn theo hệ hiện hành.

Nguồn FCA có hai action `Damaged` giống hệt ở nhện con BR; baker chỉ canonicalize bản trùng và giữ source bất biến, từ chối bản cùng tên khác nội dung. Các component variant của Treant/Tauren/Shaman/DruidBear là output riêng, không sửa FCA. FX Doom quá lớn được resample với PPU/pivot tương ứng, đã đối chiếu world size; không bỏ frame/timing/cue.

## Giới hạn có chủ đích và đầu vào thiếu

STR/AGI/INT động tạm bỏ theo D05/D34: OD transfer/MainAttrib; Sil transfer; Nana AGI-difference/minimum-STR; AM/UD-zombie maximum-INT; Tusk maximum-AGI; CG minimum-STR; DOOM chọn buff sau nuốt theo MainAttrib. Giữ các tác dụng độc lập, ghi SourceNote và sửa mô tả; không gọi những nhánh này là parity đầy đủ. Không mở awake/shard/skin. NagaMirror chỉ nối từ shard nên không kích hoạt.

15 cue không có file gốc: CM_DEATH2, Civ_Human_Wizard_BigAttack, Civ_Wizard_Attack, KOTL_RAGE, LC_ATK33, OD_ATK3, OD_DEATH2, SMALLZOMBIE_ATK2, SORCESRESS_ATK2, SORCESRESS_DEATH, TANKGLOBAL_ATK, TANKGLOBAL_DEATH, TBULT_ATK3, TB_ATK3, TITANDRUID_ATK2SUB. Không thay bằng âm gần giống. Hai tên ProjectileArt Arachne thiếu nguồn chỉ nằm trong metadata không được nhánh TrackType runtime sử dụng; không có load FX thất bại trong audit.

Các kiểm thiết bị thực Android/iPhone/Windows mới chưa được thực hiện trong lượt này; không coi Editor TCP hoặc build IPA là đã chạy trên thiết bị. Client/server PvP cần cùng catalog/roster key. Chưa commit/push, đồng bộ PC, cài máy hoặc upload.

## Bản iOS cuối

Đã hoàn tất farm và kích hoạt dữ liệu. Theo D37, đã tạo unsigned IPA cho Sideloadly; không cài hoặc upload. Xcode export dùng `Zatod.Editor.ZatodIosBuild.ExportTo(path)` ở workspace cô lập sau khi đồng bộ Main, rồi:

```sh
python3 scripts/Package-ZatodUnsignedIos.py --build-root "<folder chứa Xcode>" --data Unity/Assets/Zatod/Resources/Data
```

Helper compile Release/iphoneos/arm64 với signing tắt riêng invocation; kiểm kiến trúc, chữ ký, Info.plist/LAN/framework, hash toàn bộ Unity Data, đúng byte20 TextAsset runtime trong app và CRC IPA. IPA art trước đây vẫn được giữ, không phải IPA cuối phase.


**IPA đã kiểm:** `/Users/bloom/Desktop/Zatod Legend/Builds/D34Complete/20261124-v7-3b14df41db3fe55e/ZatodLegend-D34Complete-unsigned.ipa`, 1611039514 byte (1,50 GiB), unsigned. Thư mục chứa: `/Users/bloom/Desktop/Zatod Legend/Builds/D34Complete/20261124-v7-3b14df41db3fe55e`. SHA256 `631f433067f62b46b4b856583b46610deb3b087f678c6cdff7bf552bf583c6c1`.

Unity export6000.6.2f1 đạt0 lỗi/5 cảnh báo (shader TMP cũ và tách C++ method lớn), Xcode27.2 Release/iphoneos/arm64 thành công. App vàUnityFramework không có chữ ký, không nhúng/không phụ thuộc UnityRuntime; BundleID, iOS15 và LAN đúng. Đối chiếu19file Unity Data export→product và đúng byte20 TextAsset runtime trong app, CRC toàn ZIP đạt. File `resources.assets.resS`7.275.407.936byte cần ZIP64: ditto ZIP32 ban đầu bị tràn size/CRC, được giữ dưới tên `ditto-invalid.zip`; IPA cuối dùng ZIP64 đúng kích thước. Đã giữ quyền executable/symlink. Font Main không đổi; export chỉ tự bổ sung5kerning pair, không đổi glyph/character table, atlas hoặc font source; `font-export-verification.json` ghi hash.

Báo cáo cuối: `Artifacts/D34Completion/handoff.json` và `ipa-verification.json` trong thư mục build. Mã/data/tài nguyên vẫn trong working tree; không commit/push, chuyển PC hoặc cài/chạy thiết bị.
