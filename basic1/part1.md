# Bắt đầu 
Chúng là các tệp lệnh được viết cho bash shell. Có nhưng Shell khác nhau như zsh, tcsh, ksh, nhưng tôi tập chung vào bash.

Command-line Script là tập hợp các lệnh giống nhau có thể được nhập từ bàn phím, được tập hợp thành các tệp thống nhất với nhau theo một số mục đích chung. Đồng thời kết quả công việc có thể có giá trị độc lập hoặc dùng làm dữ liệu đầu vào cho các đội khác. Scripting là một cách mạnh mễ để tự động hóa các hành động được thực hiện thường xuyên. Vì vậy, nói về dòng lệnh, nó cho phép bạn thực hiện một sso lệnh cùng một lúc, nhập chúng được phân tách bằng dấu chấm phẩy.
```
[huydv@cmk-server ~]$ pwd
/home/huydv

[huydv@cmk-server ~]$ whoami
huydv

[huydv@cmk-server ~]$ pwd ; whoami
/home/huydv
huydv

[huydv@cmk-server ~]$ pwd ; whoami ; timedatectl
/home/huydv
huydv
      Local time: Wed 2020-09-16 12:07:42 +07
  Universal time: Wed 2020-09-16 05:07:42 UTC
        RTC time: Wed 2020-09-16 05:07:41
       Time zone: Asia/Ho_Chi_Minh (+07, +0700)
     NTP enabled: yes
NTP synchronized: yes
 RTC in local TZ: no
      DST active: n/a
[huydv@cmk-server ~]$

```
Trên thực tế nếu bạn đã thử nó trong thiết bị của mình, thì tập lệnh bash đầu tiên của bạn sử dụng, nó sẽ sử dụng câu lệnh `pwd` tiếp nối `whoami` và `timedatectl`

Mục đích của cách này là bạn có thể kết hợp nhiều lệnh chỉnh trên một dòng, giới hạn chỉ nằm ở số lượng đối số(arguments) tối đa có thể được truyền cho chương trình. 

Xác định hạn chế này bằng lệnh :

```
# getconf ARG_MAX

2097152
```
## Cách hoạt động của Bash Scripts
Tạo 1 file bàng lệnh `touch`. trong dòng đầu tiên, khai báo sẽ sử dụng loại `shell` nào. Và đó là `bash`, vì vậy dòng đầu tiên của tệp sẽ như thế này:

`#!/bin/bash`

Trong các dòng còn lại của tệp này dấu `#` đánh dấu đó là một dòng ghi chú mà shell không bao giờ sử lý. Tuy nhiên, dòng đầu tiên là một trường hơp đặc biệt, ở sau dấu `#` là dấu `!` chuỗi này được gọi là `shebang` và đường dẫn đén `bash`, cho hệ thống biết tệp lệnh được tạo cho `bash`.

Các lệnh shell được phân cách bằng xuống dòng
```
#!/bin/bash
# This is a comment
pwd
whoami
```
Cũng giống như trong dòng lệnh, bạn có thể viết lênh trên một dòng và phân biệt bằng dấu `;`. Tuy nhiên nên viết trên các dòng riêng biệt để cho tệp dễ đọc hơn. Shell sẽ xử lý chúng bằng mọi cách.

## Phân quyền cho file
Lưu một file với tên bash và cho nó có quyền được thục thi file:

```
touch file
chmod +x file
```
thêm nội dung cho file như sau:

```
#!/bin/bash
# This is a comment
pwd
whoami
```

Xem lại thông tin file

`ls -alh`

`-rwxrwxr-x 1 huydv huydv 43 Sep 16 12:29 file`

![](/image/Screenshot_41.png)

file đã có quyền thục thi

Bây giờ thực thi file:
```
# ./file

/home/huydv
huydv
```

## Hiển thị văn bản
Lệnh này được sử dụng để xuất ra văn bản ra Linux console, 

`vi file`

sửa nội dung như sau:
```
#!/bin/bash

# This is a comment
echo "Thu muc hien tai la:"
pwd
echo "User dang nhap:"
whoami
```

Thực thi: 
```
# ./file
Thu muc hien tai la:
/home/huydv
User dang nhap:
huydv
```

## Sử dụng biến
Các biến cho phép bạn lưu trữ thông tin trong Script file, ví dụ: kết quả của các lệnh để các lệnh khác sử dụng.

Có 2 loại biến có thể được sử dụng trong lệnh bash:
* Environment Variable
* User Variable 

### Environment Variable
Đôi khi các lệnh shell cần hoạt động với một số dữ liệu hệ thống. Ví dụ đây là cách hiển thị thư mục chính của người dùng:
```
#!/bin/bash
# This is a comment
echo "Trang chủ cho người dùng hiện tại: $HOME"
```

Kết quả:
```
[huydv@srv1 ~]$ ./file 
Trang chủ cho người dùng hiện tại: /home/huydv
```

Lưu ý rằng `$HOME` là biến hệ thống nên có thể sử dụng bên trong dấu ngoặc kép.

**Vd1**:

```
#!/bin/bash
# This is a comment
echo "tôi có: $1"
```

kết quả:
```
[huydv@srv1 ~]$ ./file 
tôi có: 
```

**Vd2**:
```
#!/bin/bash
# This is a comment
echo "tôi có: $100"
```
Kết quả:

```
[huydv@srv1 ~]$ ./file 
tôi có: 00
```
Hệ thống phát hiện ký hiệu `$` trong chuỗi và nó cố gắng tham chiếu đến  một biến không xác định.

Muốn hiển thị được dấu `$` thêm dấu `\` trước `$`:


```
#!/bin/bash
# This is a comment
echo "tôi có: \$100"
```

Kết quả:
```
[huydv@srv1 ~]$ ./file 
tôi có: $100
```

## Biến người dùng User Variable
Ngoài các biến môi trường, tệp lệnh bash cho phép bạn thiết lập và sử dụng các biến của riêng mình trong tệp lệnh. Các biến này giữ giá trị của chúng cho đến khi tập lệnh kết thúc thực thi.
*vd1*:
```
#!/bin/bash
# Test user variables

# Khai báo biến
tuoi=20
ten="huy"

#Thực thi
echo "tôi tên là: $ten và năm nay tôi: $tuoi"
```

Kết quả:
```
[huydv@srv1 ~]$ ./file 
tôi tên là: huy và năm nay tôi: 20
```

**vd2**:
```
#!/bin/bash
# Test user variables

# Khai báo biến
tuoi="Hai mươi"
ten="Đường Huy"

#Thực thi
echo "tôi tên là: $ten và năm nay tôi: $tuoi"
```

Kết quả:
```
[huydv@srv1 ~]$ ./file 
./file: line 5: mươi: command not found
tôi tên là: Đường Huy và năm nay tôi: 
[huydv@srv1 ~]$ ./file 
tôi tên là: Đường Huy và năm nay tôi: Hai mươi
```

Lưu ý chuỗi ký tự có dấu cách phải đặt trong nháy kép `"Chuỗi ký tự"`

## Command substitution - Thay thế lệnh

Một trong những tính năng hữu ích nhất của bash Script là khả năng trích xuất thông tin từ đầu ra của tệp lệnh và gắn cho nó các biến, cho phép thông tin được sử dụng trong bất kỳ đâu của Script

Được thực hiện theo hai cách:

* với `""`
* với cấu trúc `$()`

Sử dụng cách tiếp cận đầu tiên, hãy cẩn thận không sử dụng một trích dẫn duy nhất thay vì biểu tưởng nền(**Lấy lệnh gắn làm biến**). Lệnh phải đặt trong biểu tượng như vậy:

**Vd1**:

```
#!/bin/bash
# Test backtick  variables

# Khai báo biến
mydir=`pwd`

#Thực thi
echo $mydir
```

Hoặc

```
#!/bin/bash
# Test construction variables

# Khai báo biến
mydir=$(pwd)

#Thực thi
echo $mydir
```
Kết quả:
```
[huydv@srv1 ~]$ ./file 
/home/huydv
```
vd2:
```
#!/bin/bash
# Test Command substitution

# Khai báo biến
new=$(echo "tạo file và xem" > new.txt; cat new.txt)

#Thực thi
echo $new
```


Kết quả:

```
[huydv@srv1 ~]$ ./file 
tạo file và xem
```

