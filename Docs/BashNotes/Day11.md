Conditional Expressions (Biểu thức có điều kiện)
# Conditional Expressions
## 1.1 Kiểm tra tệp
Toán tử điều kiện `-e` kiểm tra xem tệp có tồn tại hay không(bao gồm tất cả các loại tệp thư mục, ...).
```
[root@hd ~]# filename=text
[root@hd ~]# if [[ -e $filename ]]; then
>  echo "$filename tồn tại trong thư mục $(pwd)"
> fi
text tồn tại trong thư mục /root
```

Các kiểm tra cho các loại tệp cụ thể.
```
if [[ -f $filename ]]; then
 echo "$filename là một tệp thông thường"
elif [[ -d $filename ]]; then
 echo "$filename là một thư mục"
elif [[ -p $filename ]]; then
 echo "$filename là một named pipe"
elif [[ -S $filename ]]; then
 echo "$filename is a named socket"
elif [[ -b $filename ]]; then
 echo "$filename is a block device"
elif [[ -c $filename ]]; then
 echo "$filename is a character device"
fi
if [[ -L $filename ]]; then
 echo "$filename is a symbolic link (to any file type)"
fi
```
Đối với một liên kết tượng trưng, ngoài -L,  những kiểm tra này áp dụng cho mục tiêu và trả về false cho một liên kết bị hỏng.
```
if [[ -L $filename || -e $filename ]]; then
 echo "$filename tồn tại (nhưng có thể là một liên kết tượng trưng bị hỏng.)"
fi
if [[ -L $filename && ! -e $filename ]]; then
 echo "$filename là một liên kết tượng trưng bị hỏng."
fi
```
## 1.2 So sánh và sự tương đương của chuỗi
So sánh chuỗi sử dụng toán tử `==` giữa các chuỗi được chích dẫn. Toán tử `!=` nếu chuỗi không giống nhau.
```
string1="hello world"
string2="hello world"
string3="Hello World"
if [[ "$string1" == "$string2" ]]; then
    echo "\$string1 và \$string2 giống nhau"
fi
if [[ "$string1" != "$string3" ]]; then
    echo "\$string1 và \$string3 không giống nhau"
fi
```
Output:
```
[root@hd ~]# ./t.sh 
$string1 và $string2 giống nhau
$string1 và $string3 không giống nhau
```

Ví dụ 2:
```
string='abc'
pattern1='a*'
pattern2='x*'
if [[ "$string" == $pattern1 ]]; then
    echo "Chuỗi $string khớp với mẫu $pattern"
fi
if [[ "$string" != $pattern2 ]]; then
    echo "Chuỗi $string không khớp với $pattern"
fi
```
Output:
```
[root@hd ~]# ./t.sh 
Chuỗi abc khớp với mẫu 
Chuỗi abc không khớp với 
```

Toán tử so sánh `<` và `>` các chuỗi theo thứ tự từ vựng.

Các bài kiểm tra một lần cho chuỗi trống.
```
if [[ -n "$string" ]]; then
 echo "$string is không rỗng"
fi
if [[ -z "${string// }" ]]; then
 echo "$string Trống hoặc chỉ có chứa khoảng trắng"
fi
if [[ -z "$string" ]]; then
 echo "$string rỗng"
fi
```

Ở trên, tùy chọn `-z` có thể có nghĩa là **$string** `unset`-chưa được đặt hoặc có được đặt thành một chuỗi rỗng. Để phiên biệt giữa rỗng và unset, sử dụng:
```
if [[ -n "${string+x}" ]]; then
 echo "$string được đặt, có thể là chuỗi rỗng."
fi
if [[ -n "${string-x}" ]]; then
 echo "$string chưa được đặt hoặc có thể là một chuỗi rỗng"
fi
if [[ -z "${string+x}" ]]; then
 echo "$string is unset"
fi
if [[ -z "${string-x}" ]]; then
 echo "$string được đặt thành một chuỗi rỗng"
fi
```
## 1.3 Kiểm tra exit code của lệnh
```
if command;then
 echo 'success'
else
 echo 'failure'
fi
```

Ví dụ:
```
[root@hd ~]# if ping google.e;then
>  echo 'success'
> else
>  echo 'failure'
> fi
ping: google.e: Name or service not known
failure

[root@hd ~]# if ping google.com -c 1;then
>  echo 'success'
> else
>  echo 'failure'
> fi
PING google.com (142.250.66.110) 56(84) bytes of data.
64 bytes from hkg12s28-in-f14.1e100.net (142.250.66.110): icmp_seq=1 ttl=128 time=33.1 ms

--- google.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 33.192/33.192/33.192/0.000 ms
success
```
## 1.4 One liner test
Bạn có thể làm như sau:
```
[[ $s = 'something' ]] && echo 'phù hợp' || echo "không phù hợp"
[[ $s == 'something' ]] && echo 'phù hợp' || echo "không phù hợp"
[[ $s != 'something' ]] && echo "không phù hợp" || echo "phù hợp"
[[ $s -eq 10 ]] && echo 'equal' || echo "not equal"
(( $s == 10 )) && echo 'equal' || echo 'not equal'
```

```
command && echo 'exited with 0' || echo 'non 0 exit'
cmd && cmd1 && echo 'Lệnh thành công' || echo 'Trong số đó có lệnh không thành công'
cmd || cmd1 # nếu cmd không thành công thực hiện cmd1
```
## 1.5 So sánh tệp
```
if [[ $file1 -ef $file2 ]]; then
 echo "$file1 và $file2 là cùng một tệp."
fi
```

Tệp giống nhau có nghĩa là việc sửa đổi một trong các tệp tại chỗ sẽ ảnh hưởng đến tệp kia. Hai tệp có thể giống nhau ngay cả khi chúng có tên khác nhau, ví dụ: nếu chúng là liên kết cúng hoặc nếu chúng là liên kết tượng trưng với cùng một mục tiêu hoặc nếu là một liên kết tượng trưng trở đến cái kia.

Nếu hai tệp có cùng nội dung nhưng chúng là các tệp riêng biệt(Để việc sửa đổi một tệp không ảnh hưởng đến tệp kia), thì `-ef` báo cáo là khác nhau. Nếu bạn muốn so sánh hai tệp từng byte, hãy sử dụng tiện ích **cmp**
```
if cmp -s -- "$file1" "$file2"; then
 echo "$file1 và $file2 có nội dung giống nhau"
else
 echo "$file1 và $file2 khác nhau"
fi
```

```
[root@hd ~]# if cmp -s -- ./file2 ./file1; then  echo "file1 và file2 có nội dung giống nhau"; else  echo "file1 và file2 khác nhau"; fi
file1 và file2 có nội dung giống nhau
```
Để tạo ra một danh sách có thể đọc được của con người về sự khác biệt giữa các tệp văn bản, hãy sử dụng tiện ích **diff**
```
if diff -u ./file1 ./file2; then
    echo "$file1 and $file2 có nội dung giống nhau"
else
    :
fi
```
output:
```
[root@hd ~]# echo "123@@@">file2
[root@hd ~]# if diff -u ./file1 ./file2; then     echo "$file1 and $file2 have identical contents"; else     :; fi
--- ./file1     2021-07-05 23:54:33.072873874 -0400
+++ ./file2     2021-07-06 00:03:56.524947653 -0400
@@ -1 +1 @@
-123@@
+123@@@
```
Sự khác biệt giữa các tệp được liệt kê.

## 1.6 Kiểm tra quyền truy cập tệp
```
if [[ -r $filename ]]; then
 echo "$filename là một tệp có thể đọc được"
fi
if [[ -w $filename ]]; then
 echo "$filename là một tệp có thể ghi"
fi
if [[ -x $filename ]]; then
 echo "$filename Là một tệp có thể thực thi"
fi
```
output:
```
[root@hd ~]# ./t.sh 
./t.sh là một tệp có thể đọc được
./t.sh là một tệp có thể ghi
./t.sh Là một tệp có thể thực thi
[root@hd ~]# ./t.sh 
./list.txt là một tệp có thể đọc được
./list.txt là một tệp có thể ghi
```
Các cách kiểm tra này có tính đến quyền và quyền sở hữu để xác định xem script(hoặc các chương trình đã khởi chạ từ tập lệnh) có thể truy cập tệp.

## 1.7 So sánh số
So sánh số sử dụng các toán tử so sánh:
```
if [[ $num1 -eq $num2 ]]; then
 echo "$num1 == $num2"
fi
if [[ $num1 -le $num2 ]]; then
 echo "$num1 <= $num2"
fi
```

Các toán tử số:
* `-eq`: bằng
* `-ne`: Không bằng
* `-le`: Nhỏ hơn hoặc bằng
* `-lt`: Nhỏ hơn
* `-ge`: Lớn hơn hoặc bằng
* `-gt`: Lớn hơn

Lưu ý rằng các toán tử < và > bên trong `[[...]]` so sánh các chuỗi, không phải số.
```
if [[ 9 -lt 10 ]]; then
 echo "9 đứng trước 10 theo thứ tự số"
fi
if [[ 9 > 10 ]]; then
 echo "9 là sau 10 theo thứ tự từ vựng"
fi
```
Thanks and best regards