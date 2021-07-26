Thay thế lịch sử Bash 
## Tham khảo nhanh
* Tương tác với lịch sử
    * Liệt kê các lệnh trước đó: `history`
    * Xóa lịch sử: `history -c`
* Người chỉ định sự kiện
```
# Thực hiện dòng lệnh n của lịch sử bash 
!n

# Thực hiện dòng lệnh cuối cùng
!!

# Thực hiện cuối cùng được bắt đầu bằng cat
!cat

# Thực hiện lệnh cuối cùng có chứa text
!?text

# Thực hiện lệnh n dòng trước
!-n

# Mở rộng đến lệnh cuối cùng với sự xuất hiện đầu tiền của "one" và được thay thế bằng "mot"
^one^mot^
```
### Word designators - Bộ chỉ định từ
Chúng được phân tách bằng **:** từ bộ chỉ định sự kiện mà chúng đề cập đến. Dấu hai chấm có thể được bỏ bao nếu từ chỉ định không bắt đầu bằng số `!^`giống như `!:^`
```
# Thực thi đối số đầu tiên của lệnh gần nhất
!^

# Thực thi đến đối số cuối cùng của lệnh gần đây nhất
!$

# Thực thi đến đối số n của lệnh gần đây nhất
!:3

# Mở rộng đến tất cả các từ của lệnh cuối cùng người từ lệnh 0
!* 
```
## 1.3 Tìm kiếm trong lịch sử lệnh theo mẫu
Sử dụng crtl + r và nhập một mẫu.

Ví dụ nếu gần đây bạn đã thực thi lệnh `man systemctl`, bạn có thể tìm thấy nó nhanh chóng bằng cách nhập "systemctl"
```
[root@hd ~]# man chmod
(reverse-i-search)`sy': man systemctl status
```
``sy'` ở đó là chuỗi mà tôi đã gõ cho đến nay. Đây là một tìm kiếm gia tăng, vì vậy khi bạn tiếp tục nhập, kết quả tìm kiếm được cập nhật để khớp với lệnh gần đây nhất có chứa mẫu. 
Theo mặc định, tìm kiếm sẽ được thấy lệnh được thực hiện gần đâ nhất phù hợp với mẫu. Để quay lại lịch sử, nhấn ctrl + r. Bạn có thể nhấn liên tục cho đến khi tìm thấy lệnh mong muốn
## 1.4 Chuyển sang thư mục mới tạo bằng !#:n
```
[root@hd ~]# mkdir backup_data && cd !#:1
mkdir backup_data && cd backup_data
[root@hd backup_data]# 
```
Điều này sẽ thay thế đối số n của lệnh hiện tại. Trong ví dụ `!#:1` được thay thế bằng đối số đầu tiên, tức là **backup_data**
## 1.5 Lặp lại lệnh trước đó với một lệnh thay thế
```
[root@hd fol]# cat file1.txt 
[root@hd fol]# ^1^2^
cat file2.txt 

[root@hd fol]# cat file1.txt 
[root@hd fol]# ^1^3^
cat file3.txt 
```
Lệnh này sẽ thay thế 1 bằng 2 trong lệnh đã thực hiện trước đó. Nó sẽ chỉ thay thế lần xuất hiện đầu tiên của chuỗi và tương đương với `!!:s/1/2/`
Thanks and best regards