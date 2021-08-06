# Send message to Gmail

## Cài đặt & Cấu hình SSMTP 
Yêu cầu:
* Sử dụng quyền root
* Sử dụng SMTP để gửi mail cảnh báo
* Cần biết được các thông điệp muốn gửi
### Cài đặt cấu hình tự động
Thực hiện lệnh sau và nhập thông tin đăng nhập gmail:
```
yum install wget -y
wget https://raw.githubusercontent.com/huydv398/Bash-script/master/Docs/script/install-ssmtp.sh && chmod +x install-ssmtp.sh 
./install-ssmtp.sh
```
### Cài đặt SSMTP thủ công
* Trên Ubuntu, Update repo, cài đặt dịch vụ SSMTP và cài đặt các gói hỗ trợ:
```
apt-get update
apt-get -y install ssmtp mailutils
```
* Trên CentOS-7:
```
yum update
yum -y install ssmtp
```
### Cấu hình 
File cấu hình SSMTP: **/etc/ssmtp/ssmtp.conf**

```
#
# /etc/ssmtp.conf -- a config file for sSMTP sendmail.
#
# See the ssmtp.conf(5) man page for a more verbose explanation of the
# available options.
#
# The person who gets all mail for userids < 1000
# Make this empty to disable rewriting.
root=YOURMAIL@gmail.com

# The place where the mail goes. The actual machine name is required
# no MX records are consulted. Commonly mailhosts are named mail.domain.com
# The example will fit if you are in domain.com and your mailhub is so named.
mailhub=smtp.gmail.com:587

# Example for SMTP port number 2525
# mailhub=mail.your.domain:2525
# Example for SMTP port number 25 (Standard/RFC)
# mailhub=mail.your.domain        
# Example for SSL encrypted connection
# mailhub=mail.your.domain:465

# Where will the mail seem to come from?
RewriteDomain= gmail.com
AuthUser=YOURMAIL@gmail.com
AuthPass=YOURMAILPassword
# The full hostname
Hostname=ssmtpServer

# Set this to never rewrite the "From:" line (unless not given) and to
# use that address in the "from line" of the envelope.
FromLineOverride=YES

# Use SSL/TLS to send secure messages to server.
UseTLS=YES
#IMPORTANT: The following line is mandatory for TLS authentication
TLS_CA_File=/etc/pki/tls/certs/ca-bundle.crt

# Use SSL/TLS certificate to authenticate against smtp host.
UseTLSCert=YES

# Use this RSA certificate.
#TLSCert=/etc/pki/tls/private/ssmtp.pem

# Get enhanced (*really* enhanced) debugging information in the logs
# If you want to have debugging of the config file parsing, move this option
# to the top of the config file and uncomment
#Debug=YES
```
### Cho phép ứng dụng truy cập Gmail
Nếu bạn sử dụng gmail làm địa chỉ người gửi thì bạn phải cho phép dụng truy cập gmail của bạn.

Truy cập đường dẫn: https://myaccount.google.com/lesssecureapps

Đăng nhập bằng gmail của bạn rồi thực hiện bật chế độ: **Cho phép ứng dụng kém an toàn: BẬT**
### Tạo Alias user local.
**/etc/revaliases**, cho phép bạn ánh xạ người dùng cục bộ đến một địa chỉ '**From:**' cụ thể trên thư đi và định tuyến thư đó qua một hộp thư cụ thể. Nhưng nó sẽ không viết lại địa chỉ '**To:**' theo người dùng cục bộ, người sẽ nhận thư.
Thực hiện lệnh sau:
```
echo " 
root:$smtpuser:smtp.gmail.com:587
" >> /etc/ssmtp/revaliases
```

### Thực hiện test mail:
Dùng lệnh `ssmtp`:
```
ssmtp -v To.Email@mail.com
```
Sau đó nhập nội dung mail. Kết thúc bằng cách ấn tổ hợp **Ctr+D**

Dùng lệnh `ssmtp`, lấy nội dung từ file:
```
ssmtp des_email@gmail.com < file
```
Dùng lệnh `echo`:
```
echo "Nội dung email" | ssmtp To.Email@mail.com
```
Thêm chủ đề cho mail:
```
{
    echo Subject: subject_email
    echo Nội dung email
} | ssmtp To.Email@mail.com
```

