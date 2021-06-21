Funtion
## Funtion có đối số
Trong helloname.sh:
```
greet() {
    echo "Hello, $1"
}
greet "$1"

```
output:
```
[root@hd ~]# ./helloname.sh bashshell
Hello, bashshell
[root@hd ~]# ./helloname.sh "viet nam"
Hello, viet nam
```

* Với nhiều đối số
Ví dụ 2:
```
In() {
 echo First Name"$0"
 echo Last Name"$1"
}
In "$@"
```

Output:
```
[root@hd ~]# ./helloname.sh 1 2 a
1 2 a
[root@hd ~]# ./helloname.sh 1 2 4 5 
1 2 4 5
[root@hd ~]# ./helloname.sh bash shell 123 987
bash shell 123 987
```

Ví dụ 3:
```
In() {
 echo "First Name $1"
 echo "Last Name $2"
}
In "$@"
```
```
[root@hd ~]# ./helloname.sh JONY DANG
First Name JONY
Last Name DANG
```
Lưu ý: không được vượt quá 9 đối số $10 sẽ không hoạt động, bạn cần làm là sử dụng ${10}
Ví dụ 4: Đối với các đối số mặc định, sử dụng  `${1:-default_val}`
```
#!/bin/bash
foo() {
 local val=${1:-25}
 echo "$val"
}GoalKicker.com – Bash Notes for Professionals 53
foo
foo 30
foo abc
```
Nó chỉ lấy 25 là giá trị cho $1 trong function còn lại value động.
### 2 Function đơn giản
Trong helloname.sh:
```
greet ()
{
 echo "Hello World!"
}
# Gọi function để thực hiện
greet
```
Output:
```
[root@hd ~]# ./helloname.sh 
Hello World!
```
Chú ý: Việc sử dụng `source` cung cấp tên tệp có các hàm làm cho chúng có sẵn trong phiên bash hiện tại của bạn.
```
[root@hd ~]#  source helloname.sh 
Hello World!
[root@hd ~]# greet
Hello World!
```
Bạn có thể sử dụng `export` Một function trong một số shells để nó tiếp xúc với các process con.
```
[root@hd ~]# bash -c 'greet' 
bash: greet: command not found
```

export trước khi gọi hàm
```
[root@hd ~]# bash -c 'greet' 
Hello World!
```

### 3 Xử lý flag và các tham số tùy chọn
`getopts` phân tích cú pháp các tùy chọn lệnh và đối số , chẳng hạn như những đối số được truyền cho một tập lệnh shell .
### 4 In định nghĩa hàm
```
callfunc() {
    declare -f "$@"
}
function func(){
    echo "Đây là một function"
}
funcd="$(callfunc func)"
callfunc func # hoặc  echo "$funcd"
```
Output:
```
[root@hd ~]# ./file1.sh 
func () 
{ 
    echo "Đây là một function"
}
```
In ra nội dung của một funtion được khởi tạo.
### 5 Một function chấp nhận các tham số được đặt tên
```
foo() {
    while [[ "$#" -gt 0 ]]
    do
        case $1 in
            -f|--follow)
            local FOLLOW="following"
            ;;
            -t|--tail)
            local TAIL="tail=$2"
            ;;
        esac
        shift
    done
    echo "FOLLOW: $FOLLOW"
    echo "TAIL: $TAIL"
}
```

Output:
```
[root@hd ~]# ./file1.sh 
[root@hd ~]# foo -a
FOLLOW: 
TAIL: 
[root@hd ~]# foo -t
FOLLOW: 
TAIL: tail=
[root@hd ~]# foo -t 10
FOLLOW: 
TAIL: tail=10
[root@hd ~]# foo -f
FOLLOW: following
TAIL: 
[root@hd ~]# foo -f -t 10
FOLLOW: following
TAIL: tail=10
```
### 6 Trả về giá trị từ một function
Câu lệnh return trong bash là thoát khỏi hàm với một giá trị return trả về. Có thể coi đó là một trạng thái thoát của function

Nếu bạn muốn trả về một giá trị từ function thì hãy gửi giá trị đến stdout như sau:
```
fun() {
 local var="Heellooooo BASH"
 echo "$var"
}
```

output:
```
[root@hd ~]# ./file1.sh 
[root@hd ~]# fun
Heellooooo BASH
```
### 7 exit code cả một hàm là exit code của lệnh cuối cùng
is_alive() {
 ping -c1 "$1"
}

Function này sẽ gửi một lệnh ping đến một máy chủ được chỉ định bởi tham số đầu tiên. STDOUT và STDERR của lệnh ping đều được gửi đên `.dev.null`, vì vậy hàn sẽ không bao giờ xuất ra bất kỳ thứ gì. Nhưng lệnh ping sẽ có exit code bằng 0 khi thành công và khác 0 khi thất bại vì đây là lệnh thoát cuối cùng của function, exit code của ping sẽ được sử dụng lại cho exit code của function chính.