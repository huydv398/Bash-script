# Loops -vòng lặp - Bash_Scripts
Trong phần trước là các nguyên tắc cơ bản của lập trình Bash. Ngay cả những thữ đã được sắp xếp cũng cho phép mội người bắt đầu tự động hóa công việc trong Linux. 

Trong bài viết này, Chúng ta sẽ tiếp tục về các cấu trúc điều khiển cho phép bạn thực hiện các hành động lặp lại. Chúng ta đang nói về Chu kỳ `for` và `while`, về phương pháp làm việc.

## Vòng lặp với **for**

```
for var in list
do
<Câu lệnh>
done
```
Trong mỗi lần lặp của vòng lặp, giá trị `var` từ đầu của danh sách sẽ ghi vào biến `list`. Do đó, trong lần vượt qua đầu tiên của vòng lặp, giá trị đầu tiên của danh sách sẽ được sử dụng.
```
#!/bin/bash
for var in duong van huy 1998 esvn 82 dich vong hậu
do 
echo $var
done
```
Output: Theo vòng lặp `for` sẽ in ra từng từ cho mỗi dòng

```
[root@1data bash]# ./bash.sh 
duong
van
huy
1998
esvn
82
dich
vong
hậu
```

### Lặp lại các giá trị phức tạp
Danh sách được sử dụng để khởi tạo vòng lặp `for` không thể có thể chứa các chuỗi đơn giản bao gồm một từ mà còn chứa toàn bộ các cum từ, bao gồm một số từ và dấu câu.

Input:
```
#!/bin/bash
for var in Mười "Mười một" "Mười hai" "Mười ba"
do
echo "Giá trị: $var"
done
```

Output:
```
[root@1data bash]# ./bash.sh 
Giá trị: Mười
Giá trị: Mười một
Giá trị: Mười hai
Giá trị: Mười ba
```
### Khởi tạo vòng lặp với danh sách thu được từ kết quả lệnh
Input:

`[root@1data bash]# echo "1 2 3 4 5 6" > myfile `

```
#!/bin/bash
file="myfile"
for var in $(cat $file)
do
echo " $var"
done
```

Output:
```
[root@1data bash]# cat myfile 
1 2 3 4 5 6
[root@1data bash]# ./bash.sh 
 1
 2
 3
 4
 5
 6
```

### Phân biệt các trường
Lý do cho tính năng này là một biến môi trường đặc biệt gọi là `IFS`-(Internal Field Separator) cho phép bạn chỉ định các dấu phân tách các trường.
* Dấu cách
* Ký tự Tab
* Ký tự nguồn cấp dữ liệu

Nếu bash gặp gặp bất kỳ ký tự nào trong số các ký tự trên trong dữ liệu, nó sẽ giả định rằng giá trị danh sách độc lập tiếp theo nằm trước đó

Ví dụ:

Input:
```
#!/bin/bash
file="/etc/passwd"
IFS=$'\n'
for var in $(cat $file)
do
echo " $var"
done
```
Output:
```
[root@1data bash]# ./bash.sh 
 root:x:0:0:root:/root:/bin/bash
 bin:x:1:1:bin:/bin:/sbin/nologin
 daemon:x:2:2:daemon:/sbin:/sbin/nologin
 adm:x:3:4:adm:/var/adm:/sbin/nologin
```

Khi trong nguồn dữ liệu phân cách bằng xuống dòng thì trước đó được xác định là một biến.

Khi `IFS=:` thì mỗi biến được phân cách nhau bằng dấu `:`
### Bỏ qua các tệp có trong thư mục.
Một trong những cách sử dụng phổ biến nhất trong bash của vòng lặp `for` là duyệt các tệp trong thư mục và xử lý các tệp đó.

Input:
```
#!/bin/bash

# Vòng lặp đươc chạy trong thư mục /root/
for file in /root/*
do

# Nếu biến là một thư mục
if [ -d "$file" ]
then
echo "$file is a directory"

# Nếu biến là file
elif [ -f "$file" ]
then
echo "$file is a file"
fi
done
```

Output:
```
[root@1data bash]# ./bash.sh 
/root/20 is a file
/root/anaconda-ks.cfg is a file
/root/bash is a directory
```

### Vòng lặp `for` kiểu C

Input:
```
#!/bin/bash

for ((i = 0; i <= 5; i++))
do
{
echo " Số: $i"
}
done
```

Output:
```
[root@1data bash]# ./bash.sh 
 Số: 0
 Số: 1
 Số: 2
 Số: 3
 Số: 4
 Số: 5
```

### Vòng lặp `While`
Dùng để đặt một lệnh để kiểm tra một điều kiện nhất định và thực hiện phần nội dung của vòng lặp cho đến khi điều kiện trả về 0 hoặc một tín hiệu về việc hoàn thành thành công một thao tác nhất định. Khi điều kiện vòng lặp trả về giá trị khác không, là có lỗi, vòng lặp sẽ dùng lại.

Cấu trúc:
```
while [ <điều kiện lệnh> ]
do 
<nếu đk đúng chạy lệnh ở đây>
done
```

Input:

```
#!/bin/bash
var=5
#Nếu biến `var` lớn hơn 0 thì mới thực hiện tiếp
while [ $var -gt 0 ]
do
# In ra số 5
echo $var
# Sau khi in biến `var` trừ đi 1 đơn vị,
# Khi nào trừ =0 thì vòng lặp while ở trên không điều kiện
# Dừng thực hiện `do`
var=$[ $var - 1 ]
done
```

Output:
```
[root@1data bash]# ./bash.sh 
5
4
3
2
1
```
### Vòng lặp lồng nhau

Input:
```
#!/bin/bash

for (( a = 1; a <= 3; a++ ))
    do
    echo "Cột $a:"
        for (( b = 1; b <= 3; b++ ))
            do
            echo " Hàng: $b"
            done
    done
```

Output:
```
[root@1data bash]# ./bash.sh 
Cột 1:
 Hàng: 1
 Hàng: 2
 Hàng: 3
Cột 2:
 Hàng: 1
 Hàng: 2
 Hàng: 3
Cột 3:
 Hàng: 1
 Hàng: 2
 Hàng: 3
```
Giải thích: biến `a` là hàng và biến b là 1. Khi biến a đủ điều kiện thì biến `b` được thực hiện vòng lặp. Khi vòng lặp của biến `b` kết thúc. Vòng lặp biến `a` lần tiếp theo được khởi động và đủ điều kiện thực hiện biến `b`. Cứ như vậy. Khi mà biến `b` kết thúc mà biến a không đủ điều kiện thì vòng lặp kết thúc.

### Xử lý nội dung của tệp
Việc sử dụng phổ biến nhất của các vòng lặp lồng nhau là xử lý tệp. Vì vậy, vòng lặp bên ngoài đang bận lặp lại trên các dòng của tệp và vòng bên trong đã làm việc với từng dòng. 

Input:
```
[root@1data bash]# cat /etc/passwd
chrony:x:998:996::/var/lib/chrony:/sbin/nologin
huydv:x:1000:1000::/home/huydv:/bin/bash
```
Bash:

```
#!/bin/bash
IFS=$'\n'
for entry in $(cat /etc/passwd)
do
echo "Values in $entry –"
IFS=:
for value in $entry
do
echo " $value"
done
done
```

Output:

```
Values in chrony:x:998:996::/var/lib/chrony:/sbin/nologin –
 chrony
 x
 998
 996
 
 /var/lib/chrony
 /sbin/nologin
Values in huydv:x:1000:1000::/home/huydv:/bin/bash –
 huydv
 x
 1000
 1000
 
 /home/huydv
 /bin/bash
```
## Quản lý vòng lặp
Nếu biến quá nhiều bạn cần dừng khi đến một giá trị nào đó,điều này không tương ứng với điều kiện được chỉ định ban đầu để kết thúc vòng lặp. Liệu có cần thiết cho một tình huống như vậy để chờ đợi sự hoàn thành bình thường của chu kỳ? Tất nhiên là không, và trong những trường hợp như vậy, hai lệnh có ích:
* `break`
* `continue`
### Lệnh Break
Lệnh này cho phép bạn ngắt việc thực hiện vòng lặp. Nó có thể được sử dụng cho cả hai vòng lặp `for` và `while`:

**For**

Input:
```
#!/bin/bash
for var1 in 1 2 3 4 5 6
do
if [ $var1 -eq 5 ]
then
break
fi
echo "Số: $var1"
done
```

Output:
```
[root@1data bash]# ./bash.sh 
số: 1
số: 2
số: 3
số: 4
```

**while**
Input:
```
#!/bin/bash
var1=1
while [ $var1 -lt 10 ]
do
    if [ $var1 -eq 5 ]
    then
    break
    fi
    echo "số: $var1"
    var1=$(( $var1 + 1 ))
done
```
Output:
```
[root@1data bash]# ./bash.sh 
số: 1
số: 2
số: 3
số: 4
```

### Lệnh continue
Input:
```
#!/bin/bash
for (( var1 = 1; var1 < 15; var1++ ))
do
    # Nếu biến var1 nhỏ hơn bằng 5 và lớn hơn bằng 10 thực hiện lệnh
    if [ $var1 -gt 5 ] && [ $var1 -lt 10 ]
    then
    continue
    fi
    echo "Số: $var1"
done
```

Output:
```
[root@1data bash]# ./bash.sh 
Số: 1
Số: 2
Số: 3
Số: 4
Số: 5
Số: 10
Số: 11
Số: 12
Số: 13
Số: 14
```

### Xử lý đầu ra được thực hiện trong vòng lặp
Đầu ra dữ liệu từ vòng lặp có thể được xử lý bằng cách chuyển hướng đầu ra hoặc piping. Điều này được thực hiện bằng cách thêm các lệnh xử lý đầu ra sau khi thêm câu lệnh được thực hiện.

Input:
```
#!/bin/bash
# Vòng lặp bắt đầu từ a. biến a =1 
for (( a = 1; a < 6; a++ ))
do
echo "Số $a"
```

Output:
```
[root@1data bash]# ./bash.sh 
Số 1
Số 2
Số 3
Số 4
Số 5
```

Nhưng bạn muốn in tất cả các giá trị số vào file:

Input:
```
#!/bin/bash
# Vòng lặp bắt đầu từ a. biến a =1 
for (( a = 1; a < 6; a++ ))
do
echo "Số $a"
done > myfile.txt
echo "Hoàn thành."
```

Output:
```
[root@1data bash]# ./bash.sh 
Hoàn thành.
[root@1data bash]# cat myfile.txt 
Số 1
Số 2
Số 3
Số 4
Số 5
```

Nó sẽ không in các số ra màn hình mà tạo 1 file có tên *myfile.txt* và ghi vào tệp tin. Sau khi ghi xong hiện chữ hoàn thành
