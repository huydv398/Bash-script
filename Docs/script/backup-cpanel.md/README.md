# Script backup cho code và cơ sở dữ liệu của cPanel.

# Giới thiệu
Dưới đây là hướng dẫn sử dụng script dùng để backp code và database cho cpanel
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
* Đã được cài đặt ssmtp (Sử dụng ssmtp để gửi thông báo về mail)
## Thực hiện

Thực hiện tải script:
```
cd 
mkdir script && cd script
curl https://raw.githubusercontent.com/huydv398/Bash-script/master/Docs/script/backup-cpanel.md/script.sh > script.sh && chmod +x script.sh
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
Thực hiện thêm các thông tin cho user nhận thông báo(Điền các thông tin vào trong dấu nháy đơn):
```
chat_id_tele=''
api_tele=''
to_email=''
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

## Xóa các file khi quá lâu

Ở trên crontab sử dụng vào 0 giờ 0 phút hằng ngày nhưng sau nhiều ngày có thể nhiều bản backup được lưu trữ làm khoảng trống dữ liệu bị thu hẹp, ở đây tôi sử dụng câu lệnh sau; mục đích chỉ giữ lại bản ghi backup của 7 ngày gần nhất.
* `/backup2021-v1`: Thư mục mà bạn đặt các file backup.
```
find //backup2021-v1 "*zip" -atime +7 -exec rm {} \;
```

Sử dụng crontab vào 0h00 Thứ hai hàng tuần, thực hiện các bản ghi cũ chỉ để các bản ghi của 7 ngày gần nhất
```
0 0 * * find //backup2021-v1 "*zip" -atime +7 -exec rm {} \;
```

## Sử dụng rsync để chuyển các file backup đến máy chủ riêng biệt khác.
**Rsync** - **Remote Sync** :Đồng bộ hóa dữ liệu từ xa.
* Cài đặt rsync:
    * yum install rsync -y

Thực hiện lệnh:

```
rsync -zvh /backup2021-v1 root@IP:/home/backup
```
* **/backup2021-v1**: thư mục backup
* **root@IP**: Thông tin SSH tối server.
* **/home/backup**: Nơi lưu trữ trên server mới

Cám ơn các bạn đã đọc. Script vẫn đang trong quá trình test và hoàn thiện mong được sự đóng góp ý kiến từ bạn đọc.