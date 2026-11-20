# Zatod — Popup preview ải và Reward

Ngày 20/11/2026. Thực thi theo D17–D20; nguồn quyết định Design.md. Đã nghiệm thu đầy đủ UI/build/network/reset phiên mới; trạng thái bàn giao ở cuối tài liệu.

## Hành vi đã nối

- Chọn ải mở popup trước, giữ map phía sau. Modal chặn tương tác xuyên; X đóng về map. Challenge chỉ mở View chọn đội. Battle của View chọn đội mới gửi request Campaign.
- Back ở chọn đội trở về popup cùng ải, giữ draft Hero. Điều hướng các mode khác, vào battle và mở replay đều đóng popup.
- Popup dùng wave cuối của config, giữ mọi spawn kể cả Hero địch và các loại trùng nhau. Boss đọc cờ và hiển thị badge tiếng Anh nguồn; chỉ đổi thứ tự hiển thị để Boss cuối, không sửa spawn/core.
- Tên/mô tả CN hiện có, Cost từ VitalityCost. Reward cả popup và chọn đội dùng cùng DrawDrops, lấy stage.DropItems và catalog ItemId/Quality; không có phần trăm hoặc số lượng giả.
- Server account snapshot bổ sung StageStars từ CampaignRun; UI StarsFor trả0 khi chưa đánh. Vàng cho sao đạt, nâu cho sao thiếu sau khi có sao; cả3 xám khi chưa đánh. Không phục hồi sao từ replay/archive, không thay reset theo launch.
- Raid/Raid x3 khóa dưới3 sao, đủ3 sao đổi art và cho trạng thái button enabled; không có handler càn quét hoặc cấp thưởng. Raid Voucher và Daily Attempts là ?. Tutorial là nút không có handler. Không trừ stamina hay thêm hệ thống vé.

## File và art

- Presentation/ZatodStagePreviewView.cs: controller/prefab builder của popup.
- Presentation/ZatodStageUi.cs: helper asset, layout và row icon item dùng chung.
- Presentation/ZatodFormationView.cs: Cost, Reward và chia sẻ resolver preview enemy.
- Presentation/ZatodPrototypeView.cs: flow map/popup/formation/battle.
- ArenaNetwork/ZatodProtocol.cs và ZatodServer.cs: gửi số sao thật, không thay combat/checker.
- Resources/Zatod/UI/StagePreview/ZatodStagePreviewView.prefab; prefab Formation hiện có được cập nhật. Tất cả đường Unity ở trên nằm dưới Unity/Assets/Zatod/.
- 42 file art nguồn được copy byte-for-byte, gồm10 icon item và quality frame/mask. Manifest SHA256: Artifacts/ZatodStagePreviewChecks/native-art.json. Không dùng screenshot crop hoặc ảnh sinh mới.
- scripts/Prepare-ZatodStagePreviewAssets.py và Unity/AgentScripts/ImportZatodStagePreview.cs tái tạo asset/prefab. Importer cuối dựng trong scene additive riêng, không làm dirty scene người dùng. Restore: Unity/Temp/restore/20261120-stage-preview/before.zip.

## Kiểm tra đã chạy

- Core:4.431 assertions PASS; không đổi tốc độ, timing, input hoặc cấp item.
- UI vòng đầu694 checks/18 ải PASS với tài khoản tạo trong bộ nhớ, không ghi ownership/profile. Đã kiểm tra tất cả enemy/portrait/Boss, state0..3, Cost, item icon, modal raycast và flow Challenge/Back/X; snapshot star JSON round-trip.
- Đã xem ảnh preview-pass1.png, preview-pass2.png và formation-reward.png. Pass2 tăng khả năng đọc bằng dim layer đồng nhất; sao1 vàng/2 nâu đúng asset. Sau ảnh formation đã căn icon Cost gần giá trị hơn.
- Vòng cuối766 checks/18 ải PASS, gồm Raid khóa dưới3 sao và chỉ đổi trạng thái khi đủ3. Script kiểm tra ở AgentScripts, không nằm trong script sản phẩm.
- Scene sau lưu thao tác holder của importer đầu giống byte-for-byte bản trước. BUG-026 ghi trình tự refresh/domain reload và chờ Canvas qua frame; BUG-022 áp dụng guard tránh modal Save khi build.

## Workflow tham chiếu

Đã đọc skill zatod-design và Unity using-unity/create-ui/unity-cli; uGUI guide, ui-visual-design, playmode-verification-loop. Đối chiếu package uGUI2.6 tại Library/PackageCache: UICanvas.md, HOWTO-UIMultiResolution.md, class-RectTransform.md, script-GraphicRaycaster.md. Giữ framework/project6000.6.2f1 hiện có theo yêu cầu; không dùng API mới của6000.7 hoặc nâng version.

## Nghiệm thu và bàn giao cuối

- Build Windows thành công,0 errors,2 warnings,184,96 giây. Hai warning đã xác định thuộc code ArenaView cũ (FindFirstObjectByType obsolete) và shader TMP package (enable_d3d11_debug_symbols deprecated); không phát sinh từ popup. Không sửa feature/package ngoài phạm vi để xóa cảnh báo.
- Server executable test PID57276/cổng7793 dùng thư mục test riêng. Client Editor đi thật qua map → popup0 sao → Challenge → chọn đội → Battle, thắng3 sao và được checker validate. Snapshot StageStars có một entry/3 sao; popup3 sao/Raid sáng. Digest17909688523871435903. network.json ghi kết quả.
- Stop/Start Play tạo launch GUID mới, kết nối lại cùng profile/account:0 sao,0 ải clear,5 Hero vẫn level40. Popup0 sao/Raid khóa. new-launch-reset.json PASS; không sửa tiến trình/người dùng thật để làm test.
- Đã chụp và xem preview-server-three-stars.png; ảnh phiên mới preview-new-launch.png. Ảnh formation-reward.png xác nhận icon drop không có tỷ lệ; icon Cost đã căn sát hơn trong prefab cuối.
- Phiên test đã dọn: Editor PID48524 Play stopped, auto-tick=false, run-in-background override đã trả về; server test7793 đã tắt. Server thường PID5580 READY7788, data Artifacts/ZatodServer; không đổi/xóa dữ liệu sở hữu hay archive cũ. Console groundTruth cuối0 errors/0 warnings, giữ lịch sử Console.
- Báo cáo cuối Artifacts/ZatodStagePreviewChecks/handoff.json; prefab và scene đã lưu. Scene không đổi byte so với bản trước. Bản build hiện hành Builds/ZatodPrototype/ZatodLegend.exe.
- Lượt cuối trước đã bị dừng vì automatic approval review hết spend cap; sau khi người dùng tiếp tục, các lệnh kiểm tra/dọn phiên được duyệt và hoàn tất. Không bỏ qua cơ chế review.
