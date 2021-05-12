# Part 3
Dưới là các phần về tệp lệnh bash là gì, cách viết chúng, cách điều khiển luồng chương trình, cách làm việc với tệp. Hôm nay chúng ta sẽ nói về cách thêm tính tương tác vào script, trang bị cho chúng khả năng nhận dữ liệu từ người dùng và xử lý dữ liệu này.

Cách phổ biến nhất để truyền dữ liệu sang các tập lệnh là sử dụng các tham số dòng lệnh. Bằng cách gọi tệp lệnh với tham số, chúng tôi cung cấp cho một số thông tin mà nó có thể hoạt động.

`[root@1data bash]# ./bash.sh 10 20 30 40`

Tập lệnh được truyền vào 4 tham số theo thứ tự Biến của bash là `$1` `$2` `$3`, `$...` 

Thông số dòng lệnh:
* $0: Tên của bash-script:
* $1: Tham số thứ nhất
* $2: Tham số thứ hai và tiếp tục đến biến $9

Input:
```
#!/bin/bash 
echo $0 
echo $1 
echo $2 
echo $3
```

Output:
```
[root@1data bash]# ./bash.sh 10 20 30
./bash.sh
10
20
30
```

Ví dụ 2:
input:
```
#!/bin/bash
total=$[ $1 + $2 ]
echo "Số thứ nhất = $1."
echo "Số thứ hai = $2."
echo "Tổng hai số = $total."
```

output:
```
#!/bin/bash
total=$[ $1 + $2 ]
echo "Số thứ nhất = $1."
echo "Số thứ hai = $2."
echo "Tổng hai số = $total."
```
```
[root@1data bash]# ./bash.sh 1 500
Số thứ nhất = 1.
Số thứ hai = 500.
Tổng hai số = 501.
```

Ví dụ 3:
input:
```
#!/bin/bash
echo "Hello $1"
```

Output:
```
[root@1data bash]# ./bash.sh Huy
Hello Huy 
[root@1data bash]# ./bash.sh "Đường Huy"
Hello Đường Huy
```

Nếu phần tham số bỏ trống

input:
```
#!/bin/bash
if [ -n "$1" ]
then
echo "Hello $1"
else
echo "Chưa điền thông tin"
```
Output:
```
[root@1data bash]# ./bash.sh 
Chưa điền thông tin
[root@1data bash]# ./bash.sh Huy
Hello Huy
```
### Đếm tham số được truyền vào
input:
```
#!/bin/bash
echo "Đã truyền $# tham số."
```
Output:
```
[root@1data bash]# ./bash.sh duong huy VP
Đã truyền 3 tham số.
[root@1data bash]# ./bash.sh 1 2 4 8 16 32 64
Đã truyền 7 tham số.
```

Biến cung cấp tham số cuối cùng
input:
```
#!/bin/bash
echo "Tham số cuối cùng: ${!#}."
```
Output:
```
[root@1data bash]# ./bash.sh 1 2 4 8 16 32 64
Tham số cuối cùng: 64.
```
### Nắm bắt tất cả các tùy chọn dòng lệnh
Trong một số trường hợp, bạn cần nắm bắt tất cả các tham số được truyền cho tệp lệnh. Để làm được điều này, bạn có thể sử dụng các biến `$*` và `$@`. Cả hai đều chứa tất cả các tham số dòng lệnh, giúp bạn có thể truy cập những gì được truyền vào tệp lệnh mà không cần sử dụng các tham số vị trí.

Biến `$*` chứa tất cả các tham số được nhập trên dòng lệnh dưới dạng một từ duy nhất.

Biến `$@` được chia thành các từ riêng biệt

input:
```
#!/bin/bash
count=1
for thamso in "$*"
do
echo "Phương thức \$* Tham số #$count = $thamso"
count=$(( $count + 1 ))
done
count=1
for param in "$@"
do
echo "Phương thức \$@ Tham số #$count = $thamso"
count=$(( $count + 1 ))
done
```

Output:
```
[root@1data bash]# ./bash.sh 1 2 4
Phương thức $* Tham số #1 = 1 2 4
Phương thức $@ Tham số #1 = 1
Phương thức $@ Tham số #2 = 2
Phương thức $@ Tham số #3 = 4
[root@1data bash]# ./bash.sh 1 2 4 8 16 32 64
Phương thức $* Tham số #1 = 1 2 4 8 16 32 64
Phương thức $@ Tham số #1 = 1
Phương thức $@ Tham số #2 = 2
Phương thức $@ Tham số #3 = 4
Phương thức $@ Tham số #4 = 8
Phương thức $@ Tham số #5 = 16
Phương thức $@ Tham số #6 = 32
Phương thức $@ Tham số #7 = 64
[root@1data bash]# 
```
## Câu lệnh Shift
Sử dụng lệnh shift trong lệnh bash một cách cẩn thận, vì nó thực sự thay đổi các giá trị của tham số vị trí.
## Command-line switches - Dòng lệnh điều khiển
Phục vụ để quản lý các script

Input:
```
#!/bin/bash
echo
while [ -n "$1" ]
do
case "$1" in
-a) echo "Đã tìm thấy tùy chọn -a" ;;
-b) echo "Đã tìm thấy tùy chọn -b" ;;
-c) echo "Đã tìm thấy tùy chọn -c" ;;
*) echo "$1 không phải là một tùy chọn" ;;
esac
shift
done
```
Output:
```
[root@1data bash]# ./bash.sh -a

Đã tìm thấy tùy chọn -a
[root@1data bash]# ./bash.sh -b

Đã tìm thấy tùy chọn -b
[root@1data bash]# ./bash.sh -h

-h không phải là một tùy chọn
[root@1data bash]# ./bash.sh -1

-1 không phải là một tùy chọn
```

Trong script này có sử dụng cấu trúc `case` kiểm tra key được chuyển đến nó so với danh sách key được sử lý bởi Bash_Scripts. Nếu giá trị truyền vào được tìm thấy trong danh sách này, nhánh tương ứng sẽ được thực thi. Khi tạo script, bất kỳ khóa nào cũng có thể sử dụng, quá trình thực hiện key không phù hợp được với key đã cung cấp thì nó sẽ thuộc nhánh "*" và nhánh này sẽ thực hiện 
## Cách phân biệt giữa keys và tham số
Thông thường, khi viết các Bash_Scripts, một tình huống phát sinh số dòng lệnh và switches. Cách tiêu chuẩn để làm điều này là sử dụng một chuỗi ký tự đặc biệt cho script biết khi nào các keys kết thúc và các tham số bình thường bắt đầu.

Chuỗi này là một dấu gạch ngang kép(--). Shell sử dụng nó để chỉ ra vị trí kết thúc một switches keys kết thúc. Sau khi script phát hiện dấu hiệu kết thúc của keys, những gì còn lại có thể được xử lý dưới dạng tham số mà không phải là keys:
input :

```
#!/bin/bash
while [ -n "$1" ]
do
case "$1" in
-a) echo "Đã tìm thấy tùy chọn -a" ;;
-b) echo "Đã tìm thấy tùy chọn -b";;
-c) echo "Đã tìm thấy tùy chọn -" ;;
--) shift
break ;;
*) echo "$1 không phải là một tùy chọn";;
esac
shift
done
count=1
for param in $@
do
echo "Tham số #$count: $param"
count=$(( $count + 1 ))
done
```
script sử dụng lệnh `break` để ngắt vòng lặp while khi no gặp dấu gạch ngang kép trên một dòng
output:
```
[root@1data bash]# ./bash.sh -a -b -E -12 -- 10 25
Đã tìm thấy tùy chọn -a
Đã tìm thấy tùy chọn -b
-E không phải là một tùy chọn
-12 không phải là một tùy chọn
Tham số #1: 10
Tham số #2: 25  
```
## Sử lý các khóa có đi kèm giá trị
Khi các tệp lệnh của bạn trở nên phúc tạp hơn, bạn sẽ phải đối mặt với các tình huống mà các key thông thường không còn đủ, các khóa này có kèm theo một giá trị nhất định.

input:
```
#!/bin/bash
while [ -n "$1" ]
do
case "$1" in
-a) echo "Tìm thấy tùy chọn -a";;
-b) param="$2"
echo "Tìm thấy tùy chọn -b và giá trị: $param"
shift ;;
-c) echo "Tìm thấy giá trị -c";;
--) shift
break ;;
*) echo "$1 - Giá trị không phù hợp";;
esac
shift
done
count=1
for param in "$@"
do
echo "Parameter #$count: $param"
count=$(( $count + 1 ))
done
```

Output:
```
[root@1data bash]# ./bash.sh -a -b 20 -c -- v 20
Tìm thấy tùy chọn -a
Tìm thấy tùy chọn -b và giá trị: 20
Tìm thấy giá trị -c
Parameter #1: v
Parameter #2: 20
```
Trong ví dụ này 3 khóa được xử lý trong cấu trúc. Khóa -b yêu cầu thêm một tham số bổ sung. Vì khóa đang được xử lý nằm trong biến `$1` nên tham số tương ứng nằm trong `$2`(Lệnh được sử dụng ở đây là shift, do đó quá trình xử lý diễn ra, mọi thứ được chuyển cho tệp lệnh sẽ được chuyển sang bên trái) Cần lệnh `shift` để phím tiếp theo vào được `$1`
## Sử dụng các keys tiêu chuẩn
* `-a`: Liệt kê tất cả các đối tượng
* `-c`: Count dùng để đếm
* `-d`: Directory chỉ định thư mục
* `-f`: Chỉ định tệp để đọc dữ liệu
* `-h`: help hiển thị lệnh trợ giúp
* `-i`: Bỏ qua trường hợp
* `-l`: Thực hiện xuất dữ liệu định dạng đầy đủ
* `-n`: Sử dụng chế độ tương tác hàng loạt
* `-o`: Cho phép bạn chỉ định tệp mà bạn muốn chuyển hướng đầu ra
* `-q`: Thực thi tập lệnh ở chế độ quite 
* `-r`: Xử lý các thư mục và tệp một các đệ quy
* `s`: Thực thi tệp lệnh ở chế độ silient
* `-y`: Trả lời có tất cả câu hỏi
Nếu bạn sử dụng Linux, bạn có thể quen thuộc với nhiều loại key ở trên. Bằng các sử dụng chúng theo cách hiểu thông thường trong các tệp lệnh của bạn, bạn có thể giúp người dùng tương tác với chúng mà không phải lo lắng về việc đọc tài liệu.
## Nhận dữ liệu từ người dùng
Các tham số và chuyển hướng dòng lệnh là một cách tuyệt vời để lấy dữ liệu từ người dùng tập lệnh, nhưng trong một số trường hợp, cần nhiều tương tác hơn.

Đôi khi các script cần dữ liệu mà người dùng nhập vào trong quá trình thực thi chương trình. Bash shell có một lệnh `read`

Lệnh này cho phép chấp nhận đầu từ đầu vào tiêu chuẩn(bàn phím) hoặc sử dụng các bộ mo tả tệp khác. Sau khi nhận dữ liệu, lệnh sẽ đặt nó vào một biến:

```
#!/bin/bash
echo -n "Enter your name: "
read name
echo "Xin chào: $name"
```

Output:
```
[root@1data bash]# ./bash.sh
Enter your name: Đường Huy
Xin chào: Đường Huy
```

Khi gọi bạn có thể chỉ định một số biến:
```
#!/bin/bash
read -p "Nhập tên và tuổi của bạn: " ten tuoi
echo "Dữ liệu của bạn: --- Tên của bạn là $ten  --- Tuổi của bạn là: $tuoi"
```

Output:
```
[root@1data bash]# ./bash.sh
Nhập tên và tuổi của bạn: Huy 16
Dữ liệu của bạn: --- Tên của bạn là Huy  --- Tuổi của bạn là: 16
```

Khi không chỉ định biến, dữ liệu do người dùng nhập vào sẽ được đặt trong biến môi trường đặc biệt `$REPLY`

```
#!/bin/bash
read -p "Nhập tên của Bạn "
echo Hello $REPLY
```

Output:
```
[root@1data bash]# ./bash.sh huydv
Nhập tên của Bạn: Huydv
Hello Huydv
```

Nếu tập lệnh vẫn tiếp tục thực thi bất kể người dùng có nhập một số dữ liệu cụ thể hay không, `read` bạn có thể sử dụng phím khi lệnh `-t`. Cụ thể, tham số chính đặt thời gian chờ đầu vào tính bằng giây:

```
#!/bin/bash
if read -t 5 -p "Nhập tên của bạn: " name
then
echo "Xin chào $name"
else
echo "Xin lỗi, Thời gian nhập quá lâu."
fi
```

Output:
```
[root@1data bash]# ./bash.sh
Nhập tên của bạn: Xin lỗi, Thời gian nhập quá lâu.
```

## Nhập vào dạng mã hóa password
Đôi khi tốt hơn là không hiển thị gì người dùng đăng nhập vào để trả lời câu hỏi script. Ví dụ, điều này thường dùng để nhập mật khẩu. Các key `-s` của lệnh `read` ngăn chặn đầu vào không cho phép hiển thị trên màn hình. Trên thực tế, Dữ liệu được xuất ra, nhưng lệnh `read` làm cho màu văn bản giống với màu nền.

```
#!/bin/bash
read -s -p "Nhập mật khẩu: " pass
echo "Mật khẩu của bạn là: $pass "
```

Output:
```
[root@1data bash]# ./bash.sh
Nhập mật khẩu: Mật khẩu của bạn là: 123@@123 
```

## Đọc dữ liệu từ tệp
Lệnh `read` có thể đọc một dòng văn bản từ tệp. Nếu bạn cần lấy toàn bộ nội dung của tệp lệnh, sử dụng đường dẫn, chuyển kết quả của việc gọi lệnh `cat` cho tệp, cấu trúc `while` có chứa lệnh `read`

Input:
```
#!/bin/bash
count=1
ls -f
read -p "Chọn file mà bạn muốn liệt kê: " name
if [ -e $name ]
then 
cat $name | while read line
do
echo "Line $count: $line"
count=$(( $count + 1 ))
done
echo "Hoàn thành"
else
echo "$name : tên file không có."
fi
```
Output:

```
[root@1data bash]# ./bash.sh 
.  ..  bash.sh  new.txt  myfile
Chọn file mà bạn muốn liệt kê: bash.sh
Line 1: #!/bin/bash
Line 2: count=1
Line 3: ls -f
Line 4: read -p "Chọn file mà bạn muốn liệt kê: " name
Line 5: if [ -e $name ]
Line 6: then
Line 7: cat $name | while read line
Line 8: do
Line 9: echo "Line $count: $line"
Line 10: count=$(( $count + 1 ))
Line 11: done
Line 12: echo "Hoàn thành"
Line 13: else
Line 14: echo "Chưa nhập tên file hoặc tên file không có."
Hoàn thành
```

hoặc không nhập và nhập sai:
```
[root@1data bash]# ./bash.sh 
.  ..  bash.sh  new.txt  myfile
Chọn file mà bạn muốn liệt kê: file1
file1: tên file không có.
```
