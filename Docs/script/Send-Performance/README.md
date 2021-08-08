# Lấy thông tin Performance
Yêu cầu có sẵn các thông tin:
* Hệ điều hành đã cài đặt CentOS7-Unbuntu
* Có quyền Sudo
* Gửi thông tin về mail>
    * Đã cài đặt SSMTP, [Cài đặt](https://github.com/huydv398/Bash-script/tree/master/Docs/script/Install-ssmtp)
    * Thông tin mail cần gửi thông tin về
* Gửi thông tin về Telegram
    * User ID Telegram
    * API Token

## Thực hiện cấu hình.

Tải các gói cần thiết:
```
yum update -y
yum install -y curl wget 
```

Thực hiện tải file cấu shell về máy:
```
cd 
mkdir script && cd script
wget https://raw.githubusercontent.com/huydv398/Bash-script/master/Docs/script/Send-Performance/script.sh
chmod +x script.sh
```

Thực hiện thay đổi file cấu hình:
```
vi script.sh
```

```
USER_ID="USER_ID_edit"
TOKEN="TOKEN_edit"
TO_MAIL='To_email_edit'
```
Thay đổi 3 dòng cấu hình trên tương ứng với thông tin cá nhân.

Dùng cron tab lấy gửi thông tin về trong khoảng thời gian nhất định ở đây, tôi muốn cứ vào khoảng thời gian là 1:00, 2:00, 3:00 ..., 22:00, 23:00, 1 giờ; thì gửi thông tin về một lần.

Thực hiện lệnh:
```
crontab -e
```

Thêm dòng sau vào và lưu lại:
```
0 * * * * /root/script/script.sh
```
Hoặc 15 phút một lần:
```
*/15 * * * * /root/script/script.sh
```

Chúc các bạn thành công.
