# Navigating directories - Điều hướng thư mục
## 1. Absolute vs relative directories
Absolute vs relative directories - thư mục tuyệt đối và thư mục tương đối. Để thay đổi thành một thư mục được chỉ định tuyệt đối, hãy sử dụng toàn bộ tên, bắt đầu bằng dấu gạch chéo /:

`cd /home/username/dir/sub-dir`

ví dụ:
```
[huydv@hdv ~]$ pwd
/home/huydv
[huydv@hdv ~]$ cd /home/huydv/Picture/Techonogy/
[huydv@hdv Techonogy]$ pwd
/home/huydv/Picture/Techonogy
```
Nếu bạn muốn thay đổi một thư mục gần hiện tại của bạn, bạn có thể chỉ định một vị trí tương đối. Mà hiện tại bạn đang đứng tại Techonogy bạn sử dụng bí danh `..` để thực hiện di chuyển về thư mục Picture thay vì phải sử dụng đường dẫn tuyệt đối, ví dụ:
```
[huydv@hdv Techonogy]$ pwd
/home/huydv/Picture/Techonogy
[huydv@hdv Techonogy]$ cd ..
[huydv@hdv Picture]$ pwd
/home/huydv/Picture
```

Ví dụ, nếu trong thư mục Picture có các thư mục sau: Techonogy, Customer, Subscriptions. Bạn có thể nhập trực tiếp thư mục con thay vì đường dẫn tuyệt đối đến thư mục con.
```
[huydv@hdv Picture]$ cd 
Customer/      Subscriptions/ Techonogy/     
[huydv@hdv Picture]$ cd Subscriptions/
[huydv@hdv Subscriptions]$ pwd
/home/huydv/Picture/Subscriptions
```
Tại dòng 2 khi hiện tên các thư mục con là mình đã gõ tab tab để đề xuất các thư mục con hiện có trong thư mục hiện tại.

## 2 Thay đổi đến thư sử dụng cuối cùng
`cd -`

Được sử dụng để trở về thư mục bạn đã ở trước đó. Nếu sử dụng liên tục nó sẽ đưa bạn đến 2 thư mục mà bạn đã sử dụng lần cuối cùng.

### 1.3 Thay đổi đến thư mục chính.
Thư mục mặc định làm việc là thường là thư mục **/root/** đối với user root: 
```
[root@hdv ~]# echo $HOME
/root
```

thư mục **/home/username/** đối với user 
```
[huydv@hdv ~]$ echo $HOME
/home/huydv
```
Biến $HOME là biến môi trường biểu thị thư mục của người dùng hiện tại.
### 1.4 Thay đổi thư mục của script
Có hai loại tệp bash:
* System tool- Các công cụ hệ thống hoạt động từ thư mục làm việc hiện tại
* Project tool công cụ dự án sửa đổi tệp liên quan đến vị trí của chúng trong hệ thống tệp.

Đối với Project tool sẽ hữu ích khi thay đổi thành thư mục nơi script được lưu trữ điều này có thể được thực hiện với lệnh sau:

`cd "$(dirname "$(readlink -f "$0")")"`

Câu lệnh trên thực hiện chạy 3 lệnh:
1. `readlink -f "$0"` xác định đường dẫn đến script hiện tại ($0)
2. `dirname` chuyển đổi đường dẫn đến script thành đường dẫn đến thư mục của nó
3. `cd` Thay đổi thư mục làm việc hiện tại thành thư mục mà nó nhận được từ `dirname`

# Listing Files
## Liệt kê file ở định dạng danh sách dài
Tùy chọn `-l` của lệnh `ls` hiển thị nội dung của thư mục cụ thể ở định dạng danh sách dài. Nếu không có đối số của thư mục chỉ định chỉ nó sẽ hiển thị nội dung của thư mục hiện tại. 
```
[huydv@hdv ~]$ ls -l
total 0
drwxrwxr-x. 5 huydv huydv 60 Jun  7 05:10 Picture
[huydv@hdv ~]$ ls -l /home/huydv/Picture/
total 4
drwxrwxr-x. 2 huydv huydv 21 Jun  7 10:07 Customer
-rw-rw-r--. 1 huydv huydv 58 Jun  7 10:07 info.txt
drwxrwxr-x. 2 huydv huydv  6 Jun  7 05:10 Subscriptions
drwxrwxr-x. 2 huydv huydv  6 Jun  7 05:06 Techonogy
```

Dòng đầu tiên **total** cho biết tông kích tuhuoncwscuar tất cả các tệp trong thư mục được liệu kê. Sau đó hiển thị 8 cột  thông tin:
|Số cột|Ví dụ|Miêu tả|
|-|-|-|
|1.1|d|Loại của tệp|
|1.2|rwxr-xr-x|Chuỗi biểu thị quyền hạn cho user group own(permission)|
|2|1 & 2|Các liên kết (hiểu nôm na với window là có shortcut được ở đâu đó)|
|3|username(huydv,root)|Owner name|
|4|username(huydv,root)|Owner group|
|5|21 (dir Customer)|Kích cỡ của tệp đơn vị bytes|
|6|Jun  7 10:07|Thời gian sửa đổi cuối cùng|
|7|info.txt or Customer|File name|

Ở phần 1.1 loại của tệp: có thể là một trong bất kỳ ký tự nào sau đây:
|Character|File type|
|-|-|
|-|Tệp thông thường|
|b|Chặn các tệp đặc biệt|
|c|Tệp ký tự đặc biệt|
|C|Tệp hiệu xuất cao|
|d|Thư mục|
|D|Door(tệp đặc biệt chỉ có trong Solaris 2.5+)|
|I|Liên kết tượng trưng- Symbolic link|
|M|Off-line (đã được chuyển đi)|
|n|Tệp đặc biệt của mạng(HP-UX)|
|p|FIFO(name pipe)|
|P|port (tệp đặc biệt chỉ có trong Solaris 10+)|
|s|Socket|
|?|Một số loại tệp khác|
### 2.2 Liệt kê ra 10 tệp được sửa đổi gần nhất
Câu lệnh dưới đây sẽ liệt kê 10 tệp được sửa đổi gần nhất trong thư mục hiện tại, sử dụng long listing format(định dạng danh sách dài) -l và sort by time(tìm kiếm theo thời gian) -t.

`ls -lt |head`

head dùng để liệt kê ra 10 dòng muốn liệt kê dài hơn thêm đối số: `ls -lt | head -n 20`
### 2.3 Liệt kê tất cả các tệp bao gồm các tệp Dotfiles(file ẩn)
Dotfiles là một file bắt đầu bằng dấu chấm(.). Khi thực hiện ls thì sẽ không được hiển thị trừ khi được yêu cầu

```
[huydv@hdv ~]$ ls
Picture
```
Tùy chọn -a hoặc --all sẽ liệt kê tất cả các tệp bao gồm các tệp dotfiles.
```
[huydv@hdv ~]$ ls -a
.  ..  .bash_history  .bash_logout  .bash_profile  .bashrc  Picture
```
Tùy chọn -A hoặc --almost-all sẽ liệt kê tất cả các loại tệp, bao gồm các tệp Dotfiles, nhưng không liệt kê implied (.) và (..). 
### Liệt kê các tệp tin mà không cần sử dụng `ls`
Sử dụng bash shell's File name expansion(mở rộng tên tệp) và brace expansion(mở rộng dấu ngoặc nhọn) để lấy các tên tệp:
```
==ls
[huydv@hdv ~]$ printf "%s\n" *
Picture

[huydv@hdv Picture]$ printf "%s\n" *
Customer
info.txt
Subscriptions
Techonogy

#liệt kê file có đuôi txt
[huydv@hdv Picture]$ printf "%s\n" *.txt
info.txt
#Liệt kê các file có đuôi txt,md,conf, nếu không có file thì dấu * sẽ được hiển thị ở đầu
[huydv@hdv Picture]$ printf "%s\n" *.{txt,md,conf}
info.txt
demo.md
*.conf
``` 
### 2.6 Liệt kê ra các file có định dạng giống như cây thư mục
Lệnh tree liệt kê nội dung của một thư mục được chỉ định ở định dạng cây.
```
[huydv@hdv ~]$ tree
.
└── Picture
    ├── Customer
    │   └── Num.txt
    ├── demo.md
    ├── info.txt
    ├── Subscriptions
    └── Techonogy

4 directories, 3 files
```

Để cài đặt và sử dụng lệnh cho Centos7 `sudo yum install tree` hoặc cho Ubuntu `apt install tree`
### 2.7 Liệt kê danh sách các tệp được sắp xếp theo kích thước
Tùy chọn -S của lệnh ls sắp xếp các tẹp theo thứ tự giảm dần về kích thước:
```
-rw-rw-r--. 1 huydv huydv 58 Jun  7 10:07 info.txt
drwxrwxr-x. 2 huydv huydv 21 Jun  7 10:07 Customer
drwxrwxr-x. 2 huydv huydv  6 Jun  7 05:10 Subscriptions
drwxrwxr-x. 2 huydv huydv  6 Jun  7 05:06 Techonogy
-rw-rw-r--. 1 huydv huydv  0 Jun  7 10:46 demo.md
```
Muốn sắp xếp theo thứ tự tăng dần sử dụng `ls -lSr`