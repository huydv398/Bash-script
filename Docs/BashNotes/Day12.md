Viết kịch bản với các tham số
## 1.1 Phân tích cú pháp nhiều tham số
Để phân tích cú pháp nhiều tham số, các ưu thích của việc này là sử dụng vòng lặp while, lệnh `case, shift`

`shift` được sử dụng để bật tham số đầu tiên trong chuỗi, làm cho giá trị trước là $2, bây giờ là $1. Điều này hữu ích cho các xử lý đỗi số tại một thời điểm.
```
#!/bin/bash
# Load the user defined parameters
while [[ $# > 0 ]]
do
 case "$1" in
 -a|--valueA)
 valA="$2"
shift
;;
 -b|--valueB)
 valB="$2"
shift
;;
 --help|*)
 echo "Usage:"
echo " --valueA \"value\""
 echo " --valueB \"value\""
 echo " --help"
exit 1
;;
 esac
 shift
done
echo "A: $valA"
echo "B: $valB"
```
Input và Output:
```
[root@hd ~]# ./t.sh 
A: 
B: 
[root@hd ~]# ./t.sh a
Usage:
 --valueA "value"
 --valueB "value"
 --help
[root@hd ~]# ./t.sh --help
Usage:
 --valueA "value"
 --valueB "value"
 --help
[root@hd ~]# ./t.sh --help -a 1 -b 2
Usage:
 --valueA "value"
 --valueB "value"
 --help
[root@hd ~]# ./t.sh -a 1 -b 2
A: 1
B: 2
[root@hd ~]# ./t.sh --valueA 25 --valueB 300
A: 25
B: 300
[root@hd ~]# ./t.sh --valueB 100 -a 300
A: 300
B: 100
[root@hd ~]# ./t.sh -b "Hello" -a "Xin chào"
A: Xin chào
B: Hello
```
## 1.2 Phân tích cú pháp đối số bằng vòng lặp for
Một ví dụ đơn giản cung cấp các tùy chọn:
|Option| Alt. Opt||
|-|-|-|
|-h|--help|Hiển thị hướng dẫn|
|-v|--version|Hiển thị thông tin phiên bản|
|-dr path|--doc-root path|một tùy chọn nhận tham số phụ(một đường dẫn)|
|-i|--install|Một tùy chọn boolean (true/false)| 
|-*|--|tùy chọn không hợp lệ|

```
#!/bin/bash
dr=''
install=false
skip=false
for op in "$@";do
    if $skip;then skip=false;continue;fi
    case "$op" in
        -v|--version)
            echo "$ver_info"
            shift
            exit 0
            ;;
        -h|--help)
            echo "$help"
            shift
            exit 0
            ;;
        -dr|--doc-root)
            shift
            if [[ "$1" != "" ]]; then
                dr="${1/%\//}"
                shift
                skip=true
            else
                echo "E: Arg missing for -dr option"
                exit 1
            fi
            ;;
        -i|--install)
            install=true
            shift
            ;;
        -*)
            echo "E: Invalid option: $1"
            shift
            exit 1
            ;;
    esac
done
```
## 1.3 Wraper script
Wraper script là một tập lệnh bao bọc một tệp hoặc lệnh khác để cung cấp các chức năng bổ sung hoặc chỉ để thực hiện một cái gì đó.

Ví dụ, trong hệ thống GNU/Linux mới đang được thay thế bằng một tệp lệnh trình bao bạc có tên egrep. 
```
#!/bin/sh
exec grep -E "$@"
```
Vì vậy khi bạn chạy `egrep` trong các hệ thống như vậy, bạn thực sự đang chạy `grep -E` với tất cả các đối số được chuyển tiếp.
## 1.4 Truy cập các tham số
Khi thực thi tập lện được đặt tên phù hợp với vị trí của chúng: $1 là tên của tham số đầu tiên, $2 là tên của tham số thứ hai, v.v

Một tham số bị thiếu chỉ đơn giản là đánh giá một trống. Kiểm tra sự tồn tại của một tham số có thể được thực hiện như sau:
```
if [ -z "$1" ]; then
 echo "Không được cung cấp đối số"
fi
```
output:
```
[root@hd ~]# ./t.sh
Không được cung cấp đối số
[root@hd ~]# ./t.sh 1
```
### Nhận tất cả các tham số
`$@` và `$*` là các cách tương tác với tất cả các tham số lệnh
* `$*`: Mở rộng đến các tham số vị trí, bắt đầu từ một. Khi mở rộng xảy ra trong pham vi dấu ngoặc kép, nó mở rộng thành một từ duy nhất với giá trị của một tham số được phân tách bằng ký tự đầu tiên của biến đặc biệt IFS
* `$@`: Mở rộng đến các tham số vị trí, bắt đầu từ một. Khi mở rộng xảy ra trong dấu ngoặc kép, mỗi tham số mở rộng thành một từ riêng biệt.
### Nhận số lượng tham số
`$#` nhận số lượng tham số được truyền vào một tệp lệnh. Một trường hợp sử dụng điển hình sẽ là:
```
if [ $# -eq 0 ]; then
 echo "Không được cung cấp đối số"
fi
echo $#
```

Output:
```
[root@hd ~]# ./t.sh 
Không được cung cấp đối số
0
[root@hd ~]# ./t.sh 1 2 4435 672 b
5
[root@hd ~]# ./t.sh 1 2 3 4 5 6 7 8 9 10 11
11
[root@hd ~]# ./t.sh file1 file2 file3 f4 t.sh
5
```
Ví dụ 1: Lặp lại tất cả các đối số và kiểm tra xem chúng có phải một tệp không:
```
for item in "$@"
do
   if [[ -f $item ]]; then
   echo "$item Là một tệp"
   fi
done
```
output;
```
[root@hd ~]# ./t.sh file1 file2 file3 f4 test.sh
file1 Là một tệp
file2 Là một tệp
test.sh Là một tệp
```
Ví dụ 2: 
```
for (( i = 1; i <= $#; ++ i ))
do
 item=${@:$i:1}
 if [[ -f $item ]]; then
 echo "$item là một file"
 fi
done
```

### 1.5 Tách chuỗi thành một mảng trong bash
Giả sử chúng ta có một tham số string và chúng ta muốn chia nó bằng dấu cách.
```
string="Khẩu trang y tế có tác dụng tốt."
```
Để chia string này bằng dấu cách, chúng ta có thể sử dụng:
```
IFS=',' read -r -a array <<< "$string"
```

Ở đây, IFS là một biến đặc biệt được gọi là dấu phân tách trường bên trong, xác định ký tự hoặc các ký tự để tách chuỗi ký tự hoặc mẫu xác định thành các thông báo cho một số hoạt động

Để truy cập vào phần tử riêng lẻ:
```
echo "${array[0]}"
```
Output:
```
[root@hd ~]# ./t.sh
Khẩu
```

Để truy cập vào các phần tử:
```
for i in "${array[@]}"
do
   echo "$i"
done
```
Output:
```
Khẩu
trang
y
tế
có
tác
dụng
tốt.
```
* Để nhận được cả chỉ mục và giá trị:
```
for index in "${!array[@]}"
do
 echo "$index ${array[index]}"
done
```
Output
```
0 Khẩu
1 trang
2 y
3 tế
4 có
5 tác
6 dụng
7 tốt.
```