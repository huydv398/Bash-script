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

## Các hoạt động toán học
Để thực hiện các phép toán trong tệp Script, bạn có thể sử dụng  cấu trúc có dạng `$((a+b))`:
```
#!/bin/bash
# Mathematical operations

var1=$(( 10 + 5 ))
echo $var1
var2=$(( $var1 * 2 ))
echo $var2
```

kết quả

```
[huydv@srv1 ~]$ ./file 
15
30
```
## Cấu trúc if- then
Một số tình huống yêu cầu kiểm soát luồng thực thi lệnh. Ví dụ: nếu một số giá trị lớn hơn 5, bạn thực hiện một hành động, nếu không đủ điều kiện thì thì thực hiện hành động khác.
```
if pwd
then
echo "Thư mục của tôi"
fi
```
Trong trường hợp này, nếu thực hiện được lệnh `pwd` thành công, thì `echo` văn bản bên dưới:
```
[huydv@srv1 ~]$ ./file 
/home/huydv
Thư mục của tôi
```

ví dụ, tìm một người dùng trong hệ thống thì phải tìm trong file `/etc/passwd`. Ở đây tôi sử dụng câu lệnh `grep` để tìm user trong file `/etc/passwd`. Nếu tìm thấytuser thì mới in ra:

```
#!/bin/bash
# If-then control construct
user=huydv 
if grep $user /etc/passwd
then
echo "The user $user Tồn tại"
fi
```

Kết quả
```
[huydv@srv1 ~]$ ./file 
huydv:x:1000:1000::/home/huydv:/bin/bash
The user huydv Tồn tại
```

Trong ví dụ này, nếu người dùng được tìm thấy, tập lệnh sẽ hiển thị người dùng. Nếu không tìm thấy người dùng thì tập lệnh sẽ không in ra gì.
## If-then-else control construct - Cấu trúc if-then-else 
Để chương trình có thể báo cáo cả kết quả thành công và không thành công. sử dụng `if-then-else`:
```
# Điều kiện
if [Điều kiện]
# Nếu đủ điều kiện thực hiện command then
then
[Commands]

# Không đủ điều kiện thực hiện lệnh else
else
[Commands]
fi
```

Nêu lệnh đầu trả về 0 có nghĩa được thực thi thành công, điều kiện sẽ true và việc thực thi sẽ không đi xuống nhánh `else`. Ngược lại, nếu trả về khác không, nghĩa là không thành công hoặc kết quả sai, thì các lệnh sau nó sẽ được thực thi `else`
```
user=usernew11
if grep $user /etc/passwd
then
echo "The user $user tồn tại"
else
echo "The user $user không tồn tại"
fi
```
kết quả:
```
[huydv@srv1 ~]$ ./file 
The user usernew11 không tồn tại
```

Số điều kiện tăng lên:
```
if <condition-1>
then
<some-commands>
elif <condition-2>
then
<some-other-commands>
fi
```

vidu
```
#!/bin/bash
# If-then control construct

user=huydv

if grep $user /etc/passwd
then
echo "The user $user tồn tại"
elif ls /home
then
echo "Không có user bạn cần tìm và có user trên tồn tại trong /home"
fi
```

Kết quả
```
[huydv@srv1 ~]$ ./file 
huydv:x:1000:1000::/home/huydv:/bin/bash
The user huydv tồn tại
```
Vidu2:
```
#!/bin/bash
# If-then control construct

user=huydv1

if grep $user /etc/passwd
then
echo "The user $user tồn tại"
elif ls /home
then
echo "Không có user bạn cần tìm và có user trên tồn tại trong /home"
fi
```
kết quả
```
[huydv@srv1 ~]$ ./file 
huydv
Không có user bạn cần tìm và có user trên tồn tại trong /home
```

## So sánh số

num1 -eq num2 Trả về true nếu num1 bằng num2

num1 -ge num2 Trả về true nếu num1 lớn hơn hoặc = num2

num1 -gt num2 Trả về true nếu num1 lớn hơn num2

num1 -le num2 Trả về true nếu num1 nhỏ hơn hoặc bằng num2

num1 -lt num2 Trả về true nếu num1 nhỏ hơn num2

num1 -ne num2 Trả về true nếu num1 không bằng num2

Các giá trị số có thể được so sánh trong các tập lệnh. Dưới đây là danh sách tập lệnh
|command|giá trị trả về true|
|-|-|
|-eq|=|
|-ge|>=|
|-gt|>|
|-le|<=|
|-lt|<|
|-ne|!=|

ví dụ
```
#!/bin/bash

# đặt giá trị cho biến
val1=4

# nếu biến >5 
if [ $val1 -gt 5 ]

then
echo "giá trị $val1 lớn hơn 5"
else
echo "giá trị $val1 không lơn hơn 5"
fi
```

## So sánh chuỗi
Bạn cũng có thể so sánh cách giá trị trong chuỗi trong tệp lệnh. Các toán tử so sánh trong khá đơn giản, nhưng các phép toán so sánh chuỗi có một số đặc biệt nhất định mà chúng ta sẽ đề cập bên dưới. đây là danh sách:
|command|Giá trị khi true|
|-|-|
|str1 = str2|Các giá trị chuỗi bằng nhau|
|str1 != str2|Các giá trị chuỗi không giống nhau|
|str1 < str2|Chuỗi str1 ít hơn str2|
|str1 > str2|Chuỗi str1 nhiều hơn str2|
|-n str1|Độ dài chuỗi lớn hơn 0|
|-z str1|Đọ dài chuỗi bằng 0|

vd1:

```
#!/bin/bash
user="huydv"
if [ $user = $USER ]
then
echo "$user là người dùng đăng nhập hiện tại"
fi
```

kq:
```
[huydv@srv1 ~]$ ./file 
huydv là người dùng đăng nhập hiện tại
```

Đây là một tính năng đáng đề cập về so sanh chuỗi. Cụ thể, các toán tử ">" và "<" phải được thoát bằng dấu gạch chéo ngược \, nếu không, tập lệnh sẽ không hoạt động chính xắc, mặc dù không có thông báo lỗi nào xuất hiện. Tập lệnh diễn giải dấu ">" như một lệnh chuyển hướng đầu ra.

Đây là cách làm việc với các toán tử này trông giống như sau:

```
#!/bin/bash
val1=text
val2="another text"
if [ $val1 \> $val2 ]
then
echo "$val1 is greater than $val2"
else
echo "$val1 is less than $val2"
fi
```

kết quả:
```
./file: line 4: [: too many arguments
texsdfsdfdfsdfsd is less than another text
```

Để loại bỏ cảnh báo này hãy đặt $val2 trong ngoặc kép

```
#!/bin/bash
val1=text
val2="another text"
if [ $val1 \> "$val2" ]
then
echo "$val1 is greater than $val2"
else
echo "$val1 is less than $val2"
fi
```
Một đặt điểm khác của toán tử "> và <" là cách chúng hoạt động với các ký tự viết hoa và viết thường. Để hiểu tính năng này, chuẩn bị một tệp văn bản như sau:

`vi myfile`

thêm vào văn bản:

```
abc
1
Abe
Cde
```

thực hiện trong terminal:

`sort myfile`

Kết quả:

```
1
abc
Abe
Cde
```

Lệnh `sort`, theo mặc định, sắp xếp các dòng theo thứ tự tăng dần, nghĩa các chữ cái thường trong ví dụ của chúng tra ngắn hơn chữ cái viết hoa. Bây giờ, chuẩn bị một tệp so sánh các chuỗi giống nhau:

```
#!/bin/bash
val1=Duonghuy
val2=duonghuy
if [ $val1 \> $val2 ]
then
echo "$val1 dài hơn $val2"
else
echo "$val1 ngắn hơn $val2"
fi
```

Nếu chạy nó, hiện thị điều ngược lại là đúng:

Lệnh so sánh có ít chữ hoa hơn. So sánh chuỗi ở đây được thực hiện bằng cách so sánh các mã ký tự ASCII, thứ tự sắp xếp do đó phụ thuộc vào các mã ký tự.

Câu lệnh `sort`, lệnh sắp xếp sử dụng thứ tự sắp xếp được chỉ định trong cài đặt ngôn ngữ hệ thống.

## File checks
Các lệnh dưới đây được sử dụng phổ biến nhất trong các tệp lệnh bash. Chúng cho phép bạn kiểm tra các điều kiện khác nhay liên quan đến tệp. Đây là danh sách lệnh.

|Lệnh| Ý nghĩa|
|-|-|
|-d file|Kiểm tra file có tồn tại và là một thư mục hay không|
|-e file|Kiểm tra file có tồn tại không|
|-f file|Kiểm tra file có tồn tại và là tệp không|
|-r file|Kiểm tra file có tồn tại và có thể đọc được không|
|-s file|Kiểm tra file có tồn tại không và tệp có trống rỗng không|
|-w file|Kiểm tra file có tồn tại và có thể ghi được không|
|-x file|Kiểm tra file có tồn tại và có thể thực thi không|
|file1 -nt file2|Kiểm tra nếu `file1` mới hơn `file2`|
|file1 -ot file2|Kiểm tra nếu `file1` cũ hơn `file2`|
|-O file|Kiểm tra xem tệp có tồn tại và thược sở hữu của người dùng hiện tại không|
|-G file|Kiểm tra xem tệp có tồn tại hay không và ID group của nó có khớp với ID group của người dùng hiện tại không|

Ví dụ:
Script này để kiểm tra trong thư mục `/home/huydv` có file nào tồn tại và có phải là thư mục hay không:

```
#!/bin/bash
mydir=/home/huydv
if [ -d $mydir ]
then
echo "Thư mục $mydir tồn tài"
cd $mydir
ls
else
echo "Thư mục $mydir không tồn tài"
fi
```

Kết quả:

```
[huydv@srv ~]$ ./file
Thư mục /home/huydv tồn tài
file  file1  myfile
```

Thư mục tồn tại và có 3 file bên trong

Hãy thử với các ví dụ còn lại để có cái nhìn tổng quan hơn

Cám ơn các bạn đã xem.

Link tham khảo:

https://medium.com/introduction-into-bash/bash-scripts-part-1-getting-started-2a6cec26852