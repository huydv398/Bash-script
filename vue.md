VuePress bao gồm 2 thành phần: 
* một trình tạo trang web tĩnh tối giản với hệ thống chủ đề do Vue cung cấp và Plugin API
* Một chủ đề mặc định được tối ưu hóa để viết tài liệu kỹ thuật. Nó được tạo ra để hỗ trợ nhu cầu tài liệu của các dự án phụ.

Mỗi trang web được tạo bởi VuePress đều có HTML tĩnh được kết xuất trước của riêng nó, mang lại hiệu suất tải tuyệt vời và thân thiện với SEO. Tuy nhiên khi tải trang xong, Vue sẽ tiếp quản nội dung tĩnh và biến nso thành Single-Page Application(SPA)- Một ứng dụng trang. Các trang bổ sung được tìm nạp theo yêu cầu khi người dùng điều hướng xung quanh trang web.

## Sử dụng Vue trong Markdown 
### Giới hạn truy cập API trình duyệt
Bởi vì các ứng dụng VuePress được máy chủ hiển thị trong node.js khi tạo các bản dựng tĩnh, mọi cách sử dụng Vue phải tuân thủ theo các yêu cầu về mã chung.