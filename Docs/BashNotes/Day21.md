Tách từ
## 1.1 What, When and Why 
Khi shell thực hiện mở rộng tham số, thay thế lẹnh, mở rộng biến hoặc số học, nó sẽ quét các ranh giới từ trong kết quả. Nếu tìm thấy bất kỳ danh giới từ nào, thì kết quả sẽ được chia thành nhiều từ tại vị trí đó. Ranh giới từ được xác định bởi một biến shell IFS. Giá trị mặc định cho IFS la dấu cách, tab và dòng mới, tức là việc tách  từ sẽ xảy ra trên ba ký tự khoảng trắng này nếu không được ngăn chặn một cách rõ ràng.

>Sử dụng câu lệnh `set` để dặt hoặc bỏ đặt các giá trị của các tùy chọn shell và tham số vị trí. Bạn có thể thay đổi giá trị của các thuộc tính shell và tham số vị hoặc hiển thị tren và giá trị của các biến shell bằng lệnh set

```

set -x
var='I am
a
multiline string'
fun() {
 echo "-$1-"
 echo "*$2*"
 echo ".$3."
}
fun $var
```
output:
```
[root@hd ~]# fun $var
-I-
*am*
.a.
```
Ví dụ trên, Hàm fun được thực thi $var được chia thành 5 args, chỉ I am và a được in ra.
### 1.2 Tính hữu dụng của việc tách từ
Có một số trường hợp tách từ có thể hữu ích:
Làm đầy mảng:
```
arr=($(grep -o '[0-9]\+' file))
```
Điều này sẽ điền vào arr với tất cả các giá trị số được tìm thấy trong tệp

Lặp các từ được phân tách bằng dấu cách:
```
words='foo bar baz'
for w in $words;do
 echo "W: $w"
done
```
Output:
```
W: foo
W: bar
W: baz
```

### 1.3 Phân tách các thay đổi vè dấu cách.
Thực hiện thay thế đơn giản các dấu phân cách từ khoảng trắng sang dòng mới
```
[root@hd ~]# sentence='1 2 3 4'
[root@hd ~]# echo $sentence | tr " " "\n"
1
2
3
4
```
Nó tách giá trị và hiển thị nó từng dòng một.
### 1.4 Phân tách với IFS
Để rõ ràng hơn, hãy tạo một tệp lệnh có tên showarg:
```
#!/usr/bin/env bash
printf "%d args:" $#
printf " <%s>" "$@"
echo
```
Bây giờ xem sự khác biệt:
```
[root@hd ~]# var="This is an example"
[root@hd ~]# ./showarg $var
4 args: <This> <is> <an> <example>
```
$var được chia thành 4 args. IFS là các ký tự khoảng trắng và do đó việc tách từ xảy ra trong khoảng trắng.

```
[root@hd ~]# var="This/is/an/example"
[root@hd ~]# ./showarg $var
1 args: <This/is/an/example>
```
Ở trên không xảy ra tách từ vì không tìm thấy ký tự IFS.

Bây giờ đặt IFS=/
```
[root@hd ~]# IFS=/
[root@hd ~]# var="This/is/an/example"
[root@hd ~]# ./showarg $var
4 args: <This> <is> <an> <example>
```
### 1.5 IFS và tách từ
```
set -x
var='I am
a
multiline string'
IFS=' '
fun() {
 echo "-$1-"
 echo "*$2*"
 echo ".$3."
}
fun $var
```
output:
```
[root@hd ~]# fun $var
-I-
*am
a
multiline*
.string.
```
Biến 1: I, biến 2:am a multiline, biến 3: string

```
[root@hd ~]# IFS=$'\n'
[root@hd ~]# fun $var
-I am-
*a*
.multiline string.
```
Phân tách bằng dòng mới
# 
Trong Bash 4.2, một chuyển đổi thời gian tích hợp sẵn shell cho printf đã được giới thiệu: 
## 2.1 Lấy ngày hiện tại

## 2.2 Đặt biến thành thời gian hiện tại

# 3 Sử dụng trap để phản ứng với tín hiệu và sự kiện hệ thống
## 3.1 Giới thiệu: don dẹp các tệp tạm thời
Bạn có thể sử dụng lệnh trap để bẫy các tín hiệu; 

```
#!/bin/sh
# Tạo chức năng dọn dẹp
cleanup() {
 rm --force -- "${tmp}"
}
# Trap nhóm "EXIT" đặc biệt, Nhóm này luôn chạy khi thoát khỏi shell.
trap cleanup EXIT
# Tạo tệp tạm thời
tmp="$(mktemp -p /tmp tmpfileXXXXXXX)"
echo "Hello, world!" >> "${tmp}"
# Không cần rm -f "$tmp". Ưu điểm của việc sử dụng EXIT là nó vẫn hoạt động
# Ngay cả khi có lỗi hoặc nếu bạn đã sử dụng thoát..
```

## 1.2 Bắt SIGINT hoặc ctrl+C
Bẫy được reset cho các subshell, vì vậy chế độ sleep sẽ vẫn hoạt động trên tín hiệu SIGINT được gửi bởi ^C(thường là thoát), Nhưng quy trình cha (tức tệp lệnh shell) sẽ không.
```
#!/bin/sh
# Chạy lệnh trên 2 tín hiệu (SIGINT, ^C gửi)
sigint() {
 echo "Killed subshell!"
}
trap sigint INT
# Hoặc sử dụng no-op để không có đầu ra
#trap : INT
# Điều này sẽ bị kill vào lần đầu tiên ^C
echo "Sleeping..."
sleep 500
echo "Sleeping..."
sleep 500
```
### 3.3 Tích lũy danh sách các công việc trap để chạy khi thoát
Bạn đã bao giờ quên thêm một trap để dọn dẹp tệp tam thời hoặc làm công việc khác khi thoát?

Bạn đã bao giờ đặt một cái trap mà hủy một trap khác chưa?

Code này giúp bạn dễ dàng thêm những việc cần làm khi thoát từng mục một, thay vì có một cái trap lớn câu lệnh ở đâu đó trong đoạn mã của bạn, có thể dễ bị quên.
```
# on_exit and add_on_exit
# Usage:
# add_on_exit rm -f /tmp/foo
# add_on_exit echo "I am exiting"
# tempfile=$(mktemp)
# add_on_exit rm -f "$tempfile"
# Based on http://www.linuxjournal.com/content/use-bash-trap-statement-cleanup-temporary-files
function on_exit()
{
 for i in "${on_exit_items[@]}"
 do
 eval $i
 done
}
function add_on_exit()
{
 local n=${#on_exit_items[*]}
 on_exit_items[$n]="$*"
 if [[ $n -eq 0 ]]; then
 trap on_exit EXIT
 fi
}
```
### 3.4 Xử lý kill process con khi thoát
Biểu thức trap không nhất thiết phải là các hàm hoặc chương trình riêng lẻ, chúng cũng có thể là các biểu thức phức tạp hơn

Bằng cách kết hợp `jobs -p` và `kill`, để kill tất cả cac process con đã sinh ra của shell khi thoát:
```
trap 'jobs -p | xargs kill' EXIT

```
### 3.5 Phản ứng khi thay đổi kích thước cửa sổ thiết bị đầu cuối
Có một tín hiệu WINCH ( WINdowCHange), tín hiệu này được kích hoạt khi một người thay đổi kích thước của sổ terminal 
```
declare -x rows cols
update_size(){
    rows=$(tput lines) # get actual lines of term
    cols=$(tput cols) # get actual columns of term
    echo DEBUG terminal window has no $rows lines and is $cols characters wide
}
trap update_size WINCH
```