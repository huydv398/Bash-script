Debugging - Gỡ lỗi
## 1.1 Kiểm tra cú pháp của script với "-n"
Cờ -n cho phép bạn kiểm tra cú pháp của một tệp lệnh mà không cần phải thực thi chúng
## 1.2 Gỡ lỗi tệp lệnh bash với "-x"
Sử dụng **-x** để kích hoạt debug của các dòng lệnh được thực thi. Nó có thể chạy trên toàn bộ phiên hoặc tệp lệnh, hoặc được bật theo chương trình trong một tập lệnh.
```
bash -x myscript.sh
```
Hoặc
```
bash --debug myscript.sh
```

