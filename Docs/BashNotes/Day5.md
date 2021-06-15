# Control Structures
1. [Control Structures ](#1)
2. [True, false and : commands](#2)
<a name=1></a>

Các tham số dùng để kiểm tra hoặc test:
* Tham số àm việc với file:

|File Operators|Details|
|-|-|
|`-e "$file"`|Trả về true nếu tệp tồn tại|
|`-d "$file"`|Trả về true nếu tồn tại và là một thư mục|
|`-f "$file"`|Trả về true nếu tồn tại và là tệp thông thường|
|`-h "$file"`|Trả về true nếu tồn tại và là một liên kết tượng trưng(a symbolic link) |

* So sánh chuỗi

|File Operators|Details|
|-|-|
|`-z "$str"`|True nếu độ dài chuỗi =0|
|`-n "$str`|True nếu độ dài chuỗi khác 0|
|`"$str" = "$str2"`|True nếu chuỗi `$str` bằng chuỗi `$str2`|
|`"$str" != "$str2"`|True nếu chuỗi `$str` không bằng chuỗi `$str2`|
* So sánh số nguyên(integer)

|`"$int1" {toán tử} "$int2"`|Details|
|-|-|
| `-eq` |**equal** - đúng nếu các số nguyên bằng nhau|
| `-ne` |**not equals** - đúng nếu các số nguyên không bằng nhau|
| `-gt` |**greater than** - đúng nếu `$int1` lớn hơn `$int2` |
| `-ge` |**greater than or equal** - đúng nếu `$int1` lớn hơn hoặc bằng `$int2`|
| `-lt` |**less than** - đúng nếu `$int1` Nhỏ hơn `$int2` |
| `-le` | **less than or equal** - đúng nếu `$int1` Nhỏ hơn hoặc bằng `$int2`|

### 1.1 Thực hiện có điều kiện của danh sách lệnh
* Cách sử dụng có điều kiện của danh sách lệnh
Bất kỳ lệnh, biểu thức  hoặc Function cũng như command hoặc script nào đều có thể sử dụng để thực thi có điều kiện các toán tử `&&` (và) và `||` hoặc
```
[root@hdv Techonogy]# touch file-abc && ls
file  file-abc

[root@hdv Techonogy]# cat file || echo "hello"
bash shell
[root@hdv Techonogy]# cat file1 || echo "hello"
cat: file1: No such file or directory
hello
```

Khi kết hợp nhiều câu lệnh theo cách này, các toán tử không được ưu tiên và Liên kết ngược (left-associative).

```
[root@hdv Techonogy]# cat file  && pwd || echo "No such directory"
bash shell
/home/huydv/Picture/Techonogy
[root@hdv Techonogy]# cat file1  && pwd || echo "None file1"
cat: file1: No such file or directory
None file1
```
* Nếu thực hiện `cat` thành công thì sẽ thực hiện `pwd` và không thực hiện echo
* Nếu cat `file` không thành công thực hiện lệnh `echo`

`cd my_directory && ls file1 || echo "No such directory"`
* Nếu cd không thành công, ls bị bỏ qua và thực thi echo
* Nếu cs thành công, thực thi ls
    * Nếu ls thành công, echo bị bỏ qua
    * Nếu ls không thành công, echo được thực thi

### Tại sao sử dụng thực thi có điều kiện của danh sách lệnh
Thực thi có điều kiện nhanh hơn if...then nhưng lợi thế chính của nó là cho phép các function và script thoát sớm.

Trong một số trường hợp, không phải dọn dẹp bất cứ thứ gì trước khi rời khỏi function. Lệnh `return` sẽ giải quyết mọi thứ trong function và thực thi nhận lại là thứ return trả về trên stack.

Trở lại từ các chức năng hoặc thoát script càng sớm càng tốt, do đó có thể cải thiện hiệu suất và giảm tải hệ thống bằng cách tránh thực thi mã không cần thiết.
### 1.2 Câu lệnh if
trong file có lệnh:
```
a=$1
if [[ a -eq 1 ]]; then
 echo "giá trị a bằng 1"
elif [[ a -gt 1 ]]; then
 echo "Giá trị a lớn hơn 1"
else
 echo "$1"
fi
```
```
[root@hdv ]# ./file s
s
[root@hdv ]# ./file 10
10 Giá trị a lớn hơn 1
[root@hdv ]# ./file 1
giá trị a bằng 1
[root@hdv ]# ./file 0
0
```

Việc dùng `fi` để đóng là bắt buộc, nhưng có thể bỏ qua `elif` hoặc `else` hoặc các mệnh đề khác.

Dấu chấm phẩy là cú pháp tiêu chuẩn để kết hợp hai lệnh trên một dòng, ; có thể được bỏ qua chỉ khi sau đó được chuyển xang dòng tiếp theo.

Dấu ngoặc `[[` không phải là một phần của cú pháp, nhưng được coi như một lệnh; Nó là mã thoát của lệnh khi được kiểm tra. Do đó, bạn phải luôn bao gồm các khoẳng trắng xung quanh dấu ngoặc.

Điều này cũng có nghĩa là kết quả của bất kỳ lệnh nào cũng có thể được kiểm tra. Nếu exit code từ câu lệnh là không, tuyên bố được coi là đúng.
```
if grep "1" num; then
 echo "1 was found"
else
 echo "1 was not found"
fi
```

Các biểu thức toán học, khi được đặt tên bên trong dấu ngoặc kép, cũng trả về 0 hoặc 1 theo cách tương tự
```
if (( $1 + 5 > 91 )); then
 echo "$1 là một số lơn hơn 86"
fi
```
### 1.3 Vòng lặp qua một mảng
* Vòng lặp `for`: Nó cho phép bạn lặp lại các biến có trong mảng.

Khai báo một mảng:

`arr=(a b c d e f)`

```
for i in "${arr[@]}";do
 echo "$i"
done
```

hoặc
```
for ((i=0;i<${#arr[@]};i++));do
 echo "${arr[$i]}"
done
```

Cả hai đều đưa râ kết quả:
```
a
b
c
d
e
f
```

* Vòng lặp `while`: thực thi một đoạn mã nếu biểu thức điều kiện đúng và chỉ dừng lại khi nó sai
```
arr=(a b c d e f)

i=0
while [ $i -lt ${#arr[@]} ];do
    echo "${arr[$i]}"
    i=$(expr $i + 1)
done
```
hoặc
```

arr=(a b c d e f)
i=0
while (( $i < ${#arr[@]} ));do
    echo "${arr[$i]}"
    ((i++))
done

```

Kết quả: 
```
[root@hdv ]# ./file 
a
b
c
d
e
f
```

### 1.4 Sử dụng vòng lặp để liệt kê lặp lại các số.
```
#! /bin/bash
for i in {1..10}
    do
    echo $i
done
```

output:
```
[root@hdv ]# ./file 1
2
3
4
5
6
7
8
9
10
```

Ví dụ 2:
```
#! /bin/bash
for i in {3..11}
    do
    echo $i
done
```
Output:
```
[root@hdv ]# ./file 
3
4
5
6
7
8
9
10
11
```

### 1.5 continue and break
Ví dụ cho continue
```
for i in [series]
do
    command 1
    command 2
        if (condition) # Điều kiện để nhảy qua command 3
            continue # Bỏ qua đến giá trị tiếp theo trong "series"
        fi
    command 3
done

```

Ví dụ cho break
```
for i in [series]
do
    command 4
    if (condition) # Điều kiện vòng lặp cho break
    then
        command 5 # Thực hiện lệnh nếu vòng lặp cần break
        break
    fi
    command 6 # 
done

```
**continue**: bỏ qua các lệnh còn lại bên trong phần thân của vòng lặp đi kèm cho lần lặp hiện tại và chuyển quyền điều khiển chương trình cho lần lặp tiếp theo của vòng lặp.
```
i=0

while [[ $i -lt 5 ]]; do
  ((i++))
  if [[ "$i" == '2' ]]; then
    continue
  fi
  echo "Number: $i"
done

echo 'All Done!'
```
Output
```
Number: 1
Number: 3
Number: 4
Number: 5
All Done!
```
**break**: lệnh kết thúc vòng lặp hiện tại và chuyển điều quyền điều khiển chương trình cho lệnh sau vòng lặp kết thúc. Nó được sử dụng để thoát vòng lặp for, while , until, select. 
```
i=0

while [[ $i -lt 5 ]]
do
  echo "Number: $i"
  ((i++))
  if [[ $i -eq 2 ]]; then
    break
  fi
done

echo 'All Done!'
```
Output
```
Number: 0
Number: 1
All Done!
```
### 1.6 Vòng lặp while 
While để thực hiện vòng lặp đi lặp lại của một danh sách các lệnh, miễn while thực thi thành công
```
while CONTROL-COMMAND; do CONSEQUENT-COMMANDS; done
```

```
#! /bin/bash
i=0
while [ $i -lt 5 ] #While i nhỏ hơn 5
do
    echo "i hiện tại: $i"
    i=$[$i+1] #Thực hiện xong i khai báo ban đầu sẽ cộng thêm 1 để tiếp tục thực hiện vòng lặp. Lưu ý không để khoảng trắng trong dấu ngoặc

done #Kết thúc vòng lặp

```
Output:
```
[root@hdv ]# ./file 
i hiện tại: 0
i hiện tại: 1
i hiện tại: 2
i hiện tại: 3
i hiện tại: 4
```
### 1.7 Vòng lặp với cú pháp kiểu C
`for (( variable assignment; condition; iteration process ))`

* Việc gắn biến trong vòng lặp for có có thể chứa khoảng trắng
* Các biến tên không được đặt trước $

```
#! /bin/bash
for (( i = 0; i < 4; i++ ))
do
 echo "Số lần lặp $i"
done

```
Output:
```
[root@hdv ]# ./file 
Số lần lặp 0
Số lần lặp 1
Số lần lặp 2
Số lần lặp 3
```
### 1.8 Vòng lặp until
Giống như tên của nó thực hiện cho đến khi điều kiện bằng true
```
i=5
until [[ i -eq 10 ]]; do #Check điều kiện cho đến khi i =10
 echo "i=$i" #Print ra giá trị của i
 i=$((i+1)) #Tăng giá trị i + 1
done
```

Output:
```
[root@hdv ]# ./file 
i=5
i=6
i=7
i=8
i=9
```

Khi i =10 điều kiện đúng  và kết thúc vòng lặp.
### 1.9 Switch statement with case
Đối với **case** statement bạn có thể so khớp giá trị với một biến

Đối số được truyền vào case được mở rộng và gắp khớp với từng mẫu.

Nếu một kết quả được tìm thấy là phù hợp, các lệnh ;; được thực hiện.
Lệnh case thường được sử dụng để đơn giản hóa các điều kiện phức tạp khi bạn có nhiều sự lựa chọn khác nhau sẽ giúp bạn làm cho các script của mình dễ đọc hơn và dễ bảo trì hơn.

```
#!/bin/sh

echo "Bạn muốn nói gì ..."
while :
do
  read INPUT_STRING
  case $INPUT_STRING in
	hello)
		echo "Xin chào!"
		;;
    "Who is")
		echo "My computer!"
		;;
	bye)
		echo "Hẹn gặp lại!"
		break
		;;
	*)
		echo "Sorry, Tôi không hiểu"
		;;
  esac
done
echo 
echo "Cám ơn!"
```
Output:
```
[root@hdv ]# ./file 
Bạn muốn nói gì ...
hello
Xin chào!
Who is
My computer!
bye
Hẹn gặp lại!

Cám ơn!
```
Khi bạn gõ `hello` thì exec thực hiện trả về lệnh `echo "Xin chào!"`, gõ `bye` bash sẽ thực thi `echo "Hẹn gặp lại!"; break`
<a name=2></a>

## 2. true, false and : commands
### 2.1 Vòng lặp vô hạn
```
while true; do
 echo ok
done
```
hoặc 
```
while :; do
 echo ok
done
```
hoặc
```
until false; do
 echo ok
done

```
output sẽ in ra ok vô hạn. 
### 2.2 Function Return
```
function positive() {
 return 0
}
function negative() {
 return 1
}

```

### 2.3 Code sẽ luôn luôn hoặc không bao giờ thực thi
```

if true; then
 echo Luôn thực thi
fi
if false; then
 echo không được thực thi
fi
```

>**Tổng kết**: Các phần cần nắm được trong tài liệu
Control Structures. True, false and : commands
* Các tham số dùng để kiểm tra hoặc test.
* Sử dụng && và || 
* Sử dụng if, elif, else.
* Vòng lặp for, while, until, for type-C, case-esac. Kết hợp break và continue
* Hiểu True(:), false