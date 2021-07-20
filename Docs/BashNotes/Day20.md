Trình thực thi tệp
.bash_profile, .bash_login, .bashrc, and .profile Đều làm khá giống nhau: thiết lập và xác định các hàm, biến và các loại

Sự khác biệt chính là .bashrc được gọi khi mở một của sổ không đăng nhập nhưng tương tác, .bash_profile và những cái khác được gọi cho một trình shell đăng nhập. Nhiều người có .bash_profile của họ hoặc các gọi tương tự .bashrc
## .profile vs .bash_profile (and .bash_login)
.profile được đọc hầu hết bởi các shell khi khởi động, bao gồm cả bash. Tuy nhiên, .bash_profile được sử dụng cho các cấu hình cụ thể cho bash. Đối với mã khởi tạo chung, hãy đặt nó vào .profile. Nếu nó dành riêng cho bash, sử dụng .bash_profile

.profile không thực sự được thiết kế dành riêng cho bash, thay vào đó .bash_profile. bash sẽ trở lại .profile nếu không tìm thấy .bash_profile.

.bash_login là một dự phòng cho .bash_profile, nếu nó không được tìm thấy. Nói chung, tốt nhất nên sử dụng .bash_bash_profile hoặc .profile để thay thế.

# Tách tệp tin
Đôi khi, rất hữu ích khi chia tệp thành nhiều tệp riêng biệt. Nếu bạn có các tệp lớn, có thể chia nó thành nhiều phần nhỏ.
## 2.1 Tách một tệp
Chạy một lệnh split mà không có bất kỳ tùy chọn nào sẽ chia tệp thành 1 hoặc nhiều tệp riêng biệt có chứa tối đa 1000 dòng
```
split file
```
Thao tác này sẽ tạo các tệp có tên xâ, xab, xac, vv, mỗi tẹp đều chứa tối đa 1000 dòng. Như bạn có thể thấy, tất cả chúng đều là tiền tố chữ x theo mặc định. Nếu tệp ban đầu ít hơn 1000 dòng, chỉ một tệp được tạo.

Để thay đổi tiền tố, hãy thêm tiền tố bạn muốn vào cuối dòng lệnh 
```
split file customprefix
```

Bây giờ các tệp có tên customprefixaa, customprefixab, customprefixac, v.v. sẽ được tạo.

Để chỉ định số dòng cần xuất hiện trên mỗi tệp hãy sử dụng tùy chọn -l. Phần sau sẽ chia một tệp thành tối đa là 5000 dòng.
```
split -l5000 file
```
Hoặc 
```
split --lines=5000 file

```

Ngoài ra, bạn có thể chỉ định số byte tối đa thay vì đầu dòng. Điều này được thực hiện bằng các sử dụng tùy chọn -b hoặc --byte. Ví dụ, Để cho phép tối đa 1MB
```
split --lines=5000 file
```
#  Pipelines
## 3.1 Sử dụng |&
|&  kết nối đầu ra tiêu chuẩn và lỗi tiêu chuẩn của lệnh đầu tiên với lệnh thứ hai trong khi | chỉ kết nói đầu ra tiêu chuẩn của lệnh đầu tiên dến lệnh thứ 2.

Trong ví dụ này, trang được tải xuống qua curl. Với tùy chọn curl -v viết một số thông tin trên stderr bao gồm, trang tải xuống được viết lên stdout/ 