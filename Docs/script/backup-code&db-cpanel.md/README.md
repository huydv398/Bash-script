# Script backup cho code và cơ sở dữ liệu cửa panel cPanel.

# Giới thiệu
* Khi backup có dạng thư mục như sau: Thư mục được đặt theo tên của Username. Trong thư mục được đặt file nén code và file nén database. 
* Backup thư mục lưu trữ.
    * Thư mục lưu trữ của cPanel là thư mục **~/public_html**
    * Nếu user không thuộc cpanel và không có thư mục public_html thì backup toàn bộ thư mục `/home/user/`
    * Sau khi được backup thì thư mục được nén lại dưới dạng file **zip**.
    * Sau khi nén được chuyển đến thư mục theo tên người dùng ở trên.
* Backup database:
    * Phải cung cấp cấp mật khẩu database root cho script.
    * Backup theo các database riêng biệt và được nén sau khi backup
    * File nén được chuyển vào thư mục theo tên người dùng ở trên.
## Yêu cầu 
* Hệ điêu hành CentOS-7.
* Cài đặt các phần mềm yêu cầu:
```
yum install -y curl zip
```
## Thực hiện

Thực hiện tải script:
```
cd 
mkdir script && cd script
curl https://raw.githubusercontent.com/huydv398/Bash-script/master/Docs/script/backup-code%26db-cpanel.md/script.sh > script.sh && chmod +x script.sh
```


Tiến hành sửa file `script.sh`:
```
vi script.sh
```
Thực hiện điền mật khẩu cho mysql root :
```
# Khai báo mật khẩu của mysql_root
# upasswd='Password'
upasswd=Passdb@@123

```

Thực hiện chọn nơi lưu trữ cho backup, ở đâu tôi chọn thư mục `/backup` làm nơi lưu trữ backup:
```
# Đường dẫn mà bạn muốn đặt các file backup
src_folder='backup'
```

Thực hiện backup
```
./script.sh
```

Thực hiện crontab chạy 1 ngày 1 lần vào lúc 0 giờ hằng ngày

Thực hiện lệnh 
```
crontab -e
```

Thêm dòng sau vào cuối cùng của file và lưu lại:
```
0 0 * * * /root/script/script.sh
```
* `/root/script/script.sh` là đường dẫn chính xác của file script.