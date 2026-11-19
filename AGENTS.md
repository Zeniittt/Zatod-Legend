# Zatod Legend: quy tắc làm việc

## Đọc trước khi làm việc

- Trước khi phân tích, đề xuất hoặc chỉnh sửa project, đọc [Design.md](Design.md). Đọc thêm tài liệu trong `docs/` liên quan đến nhiệm vụ; khi cần nguồn reverse, đọc `docs/crystal-legends-reference.txt`.
- Dùng skill của project tại `.agents/skills/zatod-design/SKILL.md` để duy trì các quyết định. `Design.md` là nguồn quyết định chung giữa các chat; không dựa riêng vào trí nhớ của một chat.
- Trước khi chẩn đoán hoặc sửa lỗi, đọc [ChangeLog.md](ChangeLog.md) và tìm mục có triệu chứng liên quan để dùng lại kinh nghiệm đã kiểm chứng.

## Giữ các quyết định đã chốt

- Khi người dùng chốt hoặc thay đổi thiết kế, cập nhật `Design.md` trong cùng lượt làm việc. Ghi rõ quyết định, ngày, phạm vi và trạng thái đã triển khai hay chưa.
- Tách quyết định đã chốt, đề xuất đang brainstorm và hành vi chỉ quan sát được từ Crystal Legends. Không biến đề xuất của agent thành yêu cầu đã được người dùng duyệt.
- Nếu công việc sẽ phá một quyết định đã chốt, nêu mã quyết định, phần xung đột và ảnh hưởng; dừng phần thay đổi đó để cùng người dùng brainstorm trước khi làm. Vẫn có thể tiếp tục phần độc lập không xung đột.
- Chỉ hỏi lại khi thực sự có xung đột chưa được giải quyết. Nếu chỉ dẫn mới của người dùng đã rõ ràng cho phép thay quyết định cũ, cập nhật thiết kế và tiếp tục trong phạm vi được phép; không yêu cầu xác nhận lần nữa.
- Phân biệt đồng ý về hướng thiết kế với yêu cầu triển khai ngay. Khi người dùng đang brainstorm hoặc nói chưa code, chỉ phân tích và duy trì tài liệu đã được yêu cầu; không sửa gameplay, scene, prefab, asset hoặc config runtime.
- Không viết lại lịch sử tiến trình Hero hoặc xóa tài nguyên cũ chỉ vì đổi config/nguồn art. Áp dụng đúng chính sách đã ghi trong `Design.md`.

## Ghi nhận lỗi và cách sửa

- Mỗi khi phát hiện hoặc xử lý một vấn đề, cập nhật `ChangeLog.md` trong cùng lượt: ngày, mã lỗi, triệu chứng, nguyên nhân đã xác nhận (tách giả thuyết), cách sửa/workaround, file liên quan, bằng chứng kiểm tra và lưu ý nếu tái diễn.
- Phân biệt đang điều tra, đang sửa và đã kiểm tra. Chỉ đánh dấu đã sửa sau kiểm tra phù hợp; không ghi chẩn đoán chưa chứng minh thành nguyên nhân chắc chắn.
- Nếu lỗi tái diễn, bổ sung vào mục cũ bằng chứng/nguyên nhân mới; giữ lịch sử có ích. `ChangeLog.md` lưu kinh nghiệm xử lý, `Design.md` vẫn là nguồn quyết định thiết kế.
