Copying(cp) & find
## 1 copying
|Character|option|Description|
|-|-|-|
|-a|-archive|Kết hợp của các tùy chọn d, p & r|
|-b|-backup|Sao lưu trước khi xóa|
|-d|--no-deference |Giữ các liên kết|
|-f|--force|xóa các điểm đên hiện có mà không cần nhắc người dùng|
|-i|--interactive|Hiển thị tương tác trước khi ghi đè|
|-l|--link|Thay vì sao chép hãy liên kết đến các tệp thay thế|
|-p|--preserve|Bảo vệ các thuộc tính của tệp khi có thể|
|-R|--recursive|Sao chép đệ quy các thư mục|
### 1.1 Sao chép một tệp duy nhất
* Sao chép một tệp vào một thư mục. Có file `text.txt` từ **/home/user1/folder1/test/text.txt** đến thư mục **/user/user2/backup/file/**
```
cp home/user1/folder1/test/text.txt /user/user2/backup/file/
```
Sao chép một tệp đến một tệp khác. Có file `text.txt` từ **/home/user1/folder1/test/text.txt** đến thư mục **/user/user2/backup/file/filenew.txt**
```
cp /home/user1/folder1/test/text.txt /home/user2/backup/file/filenew.txt
```

### 1.2 Sao chép thư mục
Sao chép một thư mục đến một thư mục khác:
```
cp -R /path-folder /path-folder-new
```
Tuy nhiên nếu **path-folder-new** không tồn tại thì sẽ được tạo 



## Find 
Find là một lệnh dùng để tìm kiếm đệ quy một thư mục cho các tệp(hoặc thư mục) phù hợp với một tiêu chí và sau đó thực hiện một số thao tác trên các tệp đã chọn. 
### 2.1 Tìm kiếm một tệp theo tên hoặc phần mở rộng
Để tìm kiếm một tệp/ thư mục có tên cụ thể, liên quan đến pwd:
```
[root@hd ~]# find . -name "t.sh"
./t.sh
./abc/t.sh
./abc/xyz/t.sh
./abc/xyz/abc/t.sh
./abc/xyz/abc/xyz/t.sh
./abc/xyz/abc/xyz/abc/t.sh
./abc/xyz/abc/xyz/abc/xyz/t.sh
[root@hd ~]# 
```
* Tìm kiếm thư mục hoặc file có phần mở rộng cụ thể, hãy sử dụng ký tự đại diện:
```
[root@hd abc]# find -name "*.sh"
./file1.sh
./file.sh
./helloname.sh
./install-wp.sh
./removemariadb.sh
./t.sh
./xyz/file1.sh
./xyz/file.sh
./xyz/helloname.sh
./xyz/install-wp.sh
./xyz/removemariadb.sh
./xyz/t.sh
./xyz/abc/file1.sh
./xyz/abc/file.sh
./xyz/abc/helloname.sh
./xyz/abc/install-wp.sh
./xyz/abc/removemariadb.sh
./xyz/abc/t.sh
```
* Để tìm các tệp/thư mục phù hợp với một trong nhiều phần mở rộng
```
[root@hd abc]# find . -name "*.gz" -o -name "*.cfg"
./anaconda-ks.cfg
./latest.tar.gz
./xyz/anaconda-ks.cfg
./xyz/latest.tar.gz
```
* Tìm tệp và thư mục nằm trong mục cụ thể, nếu chỉ tìm kiếm các tệp sử dụng `-type f`, nếu chỉ tìm kiếm thư mục sử dụng `-type d`
```
find /path-directory
find /path-directory -type f
find /path-directory -type d
```

### 2.2 Thực thi các lệnh đối với một tệp được tìm thấy
Đôi khi cúng ta sẽ cần chạy các lệnh đối với rất nhiều tệp. Điều này có thể được thực hiện bằng cách sử dụng `xargs`.
```
find /path -type d -print | xargs -r chmod 770
```
Lệnh trên sẽ tim một các đệ quy tất cả các thư mục (`-type d`) liên quan đến **/path** (thư mục làm việc) và thực thi chmod 770 trên chúng. Tùy chọn -r chỉ định để `xargs `không chạy chmod nếu không tìm thấy bất kỳ lệnh nào.

Nếu tên tệp hoặc thư mục có ký tự khoảng trắng trong đó, lệnh có thể bị nghẽn, giải pháp là
```
find /path -type d -print0 | xargs -r -0 chmod 770
```

-print0 và -0 là hai flag được sử dụng chỉ định rằng các tên tệp sẽ được phân tách bằng các sử dụng một byte rỗng, và cho phép sử dụng các ký tự đặc biệt, như dấu cách trong tên tệp. 
### 2.3 Tìm tên tệp theo thời gian truy cập sửa đổi
Trên hệ thống mở rộng, mỗi tệp có quyền truy cập, sửa đổi và thay đổi được lưu trữ liên quan đến nó-sử dụng `stat myfile.xtx`; sử dụng với find có thể tìm kiếm các tệp đã được sửa đổi trong một khoảng thời gian nhất định.

* Tìm các tệp đã được sửa đổi trong vòng 2 giờ qua.:
```
find . -nmin -120
```
* Tìm các tệp tin không sửa đổi trong vòng 2 giờ qua:
```
find . -mmin +120
```
* Ví dụ trên chỉ tìm kiếm theo thời gian đã sửa đổi để tìm kiếm theo thời gian truy cập hoặc thời gian đã thay đổi
```
find . -amin -120
find . -cmin +120
```
* Định dạng chung:
    * `mmin n`: Tệp đã được sửa đổi n phút trước
    * `nmin -n`: Tệp đã được thay đổi trong vòng n phút trước
    * `mmin +n`: Tệp đã được sửa đổi hơn n phút rồi.
* Tìm các tệp đã được sửa đổi trong vòng 2 ngày qua:
```
find . -mtime -2
```
* Tìm các tệp Không được sửa đổi trong vòng 2 ngày qua
```
find . -mtime +2
```
* Sử dụng `-atime` và `-ctime` cho thời gian truy cập và thời gian thay đổi trạng thái tương ứng. Định dạng chung:
    * `-mtime n`: File được sửa đổi trong vòng n ngày qua
    * `-mtime -n`: File được sửa đổi ít hơn n ngày
    * `-mtime +n`: File được sửa đổi nhiều hơn n ngày.
* Tìm các tệp được sửa đổi trong một phạm vi ngày, từ 01-02-2003 đến ngày 15-03-2003:
```
find . -type f -newermt 2003-02-01 ! -newermt 2003-03-15 
```
* Tìm tệp được truy cập trong một loạt dấu thời gian (sử dụng tệp làm dấu thời gian), từ 10 giờ trước đến 5 giờ trước:
```
touch -t $(date -d '10 HOUR AGO' +%Y%m%d%H%M.%S) start_date
touch -t $(date -d '5 HOUR AGO' +%Y%m%d%H%M.%S) end_date
timeout 10 find "$LOCAL_FOLDER" -newerat "start_date" ! -newerat "end_date" -print 
```
### 2.4 Tìm tệp theo kích thước
* Tìm tệp lớn hơn 15MB:
```
find -type f -size +15M
```
* Tìm tệp nhỏ hơn 12KB:
```
find -type f -size -12k
```
* Tìm tệp có kích thước chính xác:
```
find -type f -size 12k
find -type f -size 12288c
find -type f -size 24b
find -type f -size 24
```
* `find [options] -size n[cwbkMG]`
    * Tìm tệp có kích thước n-block, trong đó +n có nghĩa là nhiều hơn n-block, -n có nghĩa là nhỏ hơn n-block và n là có nghĩa là chính xác
    1. c: byte
    2. w: 2bytes
    3. b: 512 bytes
    4. k: 1KB
    5. M: 1MB
    6. G: 1 GB
### Tìm kiếm theo đường dẫn
Tham số `-path` cho phép chỉ định một mẫu để khớp với đường dẫn của kết quả. Mẫu cũng có thể phù hợp với tên của chính nó.

* Để tìm các tệp chứa **log** ở bất kỳ đâu:
```
[root@hd ~]# find . -type f -path '*log*'
./.bash_logout
./wordpress/wp-admin/images/wordpress-logo-white.svg
./wordpress/wp-admin/css/login.min.css
./wordpress/wp-admin/css/login-rtl.min.css
./wordpress/wp-admin/css/login-rtl.css
./wordpress/wp-admin/css/login.css
./wordpress/wp-blog-header.php
./wordpress/wp-login.php
./abc/log.txt
```
* Để tìm các file có trong thư mục có tên là **log** ở bất kỳ đâu:
```
[root@hd log]# find . -type f -path '*/log/*'
./log/anaconda-ks.cfg
find . -type f -path '*/log/*' -o -path '*/data/*'

```
* Tìm các tệp ngoại trừ trong thư mục **bin**, **bin** hoặc tệp tin có tên **log**
```
find . -type f -not -path '*/bin/*'
find . -type f -not -path '*log' -not -path '*/bin/*'
```
### 2.6 Tìm tệp theo loại
* Tìm tệp, sử dụng `-type f`
```
find . -type f
```
* Tìm các thư mục:
```
find . -type d
```
* Tìm block devices:
```
find /dev -type b
```
* Tìm symlinks:
```
find . -type l
```

### 2.7 Tìm tệp theo phần mở rộng cụ thể 
Ví dụ, muốn tìm tất cả các tệp các phần mở rộng là `.sh` từ thư mục hiện tại:
```
[root@hd log]# find . -maxdepth 1 -type f -name "*.sh"
./file1.sh
./file.sh
./helloname.sh
./install-wp.sh
```
sort: để sắp xếp dữ leieuj trong các tệp theo một trình tự
## 1.1 Câu lệnh sort -output
Sort dùng để sắp xếp một danh sách các dòng
* Đầu vào từ một file
```
sort text.txt
```
* Đầu vào từ một lệnh: Bạn có thể sắp xếp bất kỳ lệnh đầu ra nào. Trong ví dụ, danh sách tệp tên text.txt.
```
cat text | sort
```
## 1.2 Tạo đầu ra duy nhất
Nếu mỗi dòng của đầu ra cần phải là duy nhất, hãy thêm tùy chọn `-u`-(unique)

Liệt kê size của tệp trong thư mục, hiển thị được lọc để không trùng lặp
```
[root@hd ~]# ls -l | awk '{print $3}' | sort -u

nobody
root
```
sourcing
## 2.1 Tìm nguồn cung cấp tệp
Tìm nguồn cung ứng với một tệp khác với việc thực thi, ở chỗ tất cả các lệnh được đánh giá trong ngữ cảnh của phiên bash hiện tại - điều này có nghĩa là bất kỳ biến, hàm hoặc bí danh nào được xác định sẽ tồn tại trong xuốt phiên của bạn.

Tạo một file **test.sh**
```
#!/bin/bash 
export A="alo 123"
alias sayhi="echo Hello Mygirl"
sayHello() {
 echo "Hello Everyone"
}
```

Từ phiên của bạn, thực hiện source file:
```
source test.sh
```
Bạn có thể sử dụng sẵn tài nguyên từ tệp vừa được hiện làm source
Output:
```
[root@hd ~]# source t.sh 
[root@hd ~]# echo $A
alo 123
[root@hd ~]# sayhi
Hello Mygirl
[root@hd ~]# sayHello
Hello Everyone
```
* Sử dụng cách sau có chức năng tương tự với `source`, đơn giản ngắn gọn hơn:
```
[root@hd ~]# . test.sh 
```
## 2.2 Sourcing một môi trường ảo
Khi phát triển một số ứng dụng trên máy, việc tách các phần phụ thuộc thành các phần phụ thuộc ra môi trường ảo sẽ trở nên hữu ích.

Với việc sử dụng virtualenv, các môi trường được lấy nguồn từ shell của bạn để khi bạn chạy một lệnh, nó đến từ môi trường ảo đó. Điều này được cài đặt phổ biến nhất bằng cách sử dụng pip.

