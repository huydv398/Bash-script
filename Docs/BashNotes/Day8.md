Mở rộng tham số bash 
Ký tự $ giới thiệu để mở rộng tham số thay thế lệnh hoặc mở rộng số học. Tên Tham số hoặc ký hiệu được mở rộng có thể được đặt trong dấu ngoặc nhọn, là tùy chọn nhưng dùng để bảo vệ biến thành được mở rộng từ các ký tự ngay sau nó, có thể được hiểu là một phần của tên.
## 1 Sửa đổi: trường hợp của các ký tự chữ cái
* Chỉ ký tự đầu tiên thành chữ hoa
```
[root@hd ~]#  v="hello"
[root@hd ~]# printf '%s\n' "${v^}"
Hello
```

* Tất cả các ký tự:
```
[root@hd ~]# v="domain.com"
[root@hd ~]# printf '%s\n' "${v^^}"
DOMAIN.COM

[root@hd ~]# v="Bash shell"
[root@hd ~]# declare -u string="$v"
[root@hd ~]# echo "$string"
BASH SHELL
```
* Thành chữ thường: chỉ ký tự đầu tiên
```
[root@hd ~]# v="THANK"
[root@hd ~]# printf '%s\n' "${v,}"
tHANK
```
* Thành chữ thường: tất cả các ký tự
```
[root@hd ~]# v="THANK"
[root@hd ~]# printf '%s\n' "${v,,}"
thank
[root@hd ~]# echo "${v~}"
thank

[root@hd ~]# v="ABCDEF"
[root@hd ~]# declare -l string="$v"
[root@hd ~]# echo "$string"
abcdef
```
* Thay đổi ở tất cả các ký tự.
```
[root@hd ~]# echo "${v~~}"
hELLO wORLD
```
## Độ dài của một tham số
```
[root@hd ~]# v='12345'
[root@hd ~]# echo "${#v}"
5
```
Lưu ý rằng đó là một độ dài được dựa theo các ký tự
* Số phần tử có trong mảng
```
[root@hd ~]# myarr=(1 2 34 5 6 789)
[root@hd ~]# echo "${#myarr[@]}"
6
```
* Làm với các tham số vị trí
```
[root@hd ~]# set -- 1 2 3 4123c 124
[root@hd ~]# echo "${#@}"
5
[root@hd ~]# echo "$#"
5
```
## Thay thế trong chuỗi

```
[root@hd ~]# str='I am a string - is: abcd'
[root@hd ~]# echo "${str/a/A}"
I Am a string - is: abcd
```
* `echo "${str/a/A}"`: phân tích trong ${str/a/A}
    * str tên chuỗi
    * a chữ cần thay
    * A thay đổi chữ a đầu tiên thành A. Muốn thay đổi tất cả chữ a thành A: `"${tr//a/A}`

Thay đổi ký tự đầu tiên:
```
[root@hd ~]# str='I am a string - is: abcd'
[root@hd ~]# echo "${str/#I/this}"
this am a string - is: abcd
```

Thay đổi ký tự cuối cùng:
```
[root@hd ~]# echo "${str/%d/-A-a-@}"
I am a string - is: abc-A-a-@
```

Thay đổi ký tự trong chuỗi thành không có:
```
[root@hd ~]# str='I am a string - is: abcd'
[root@hd ~]# echo "${str/g/}"
I am a strin - is: abcd
```

Thêm ký tự vào các item có trong một mảng:
```
[root@hd ~]# A=(Linux Bash Shell )
[root@hd ~]# echo "${A[@]/#/R_}"
R_Linux R_Bash R_Shell
[root@hd ~]# echo "${A[@]/%/_E}"
Linux_E Bash_E Shell_E
```       
## 4 Substrings và subarrays
Đặt biến cho chuỗi ký tự:
```
var='0123456789abcdef'
```
* `${var:n}` Lấy từ vị trí số n đến hết
```
[root@hd ~]# printf '%s\n' "${var:3}"
3456789abcdef
[root@hd ~]# printf '%s\n' "${var:10}"
abcdef
```
* `${var:n:y}` Lấy từ vị trí `n`, lấy ra `y` ký tự.
```
[root@hd ~]# printf '%s\n' "${var:1:9}"
123456789

[root@hd ~]# printf '%s\n' "${var:4:6}"
456789

[root@hd ~]# printf '%s\n' "${var:2:10}"
23456789ab
```
* `${var:n:-y}` Số lượng độ dài âm tính từ cuối chuỗi. Lấy từ vị trí `n` và bỏ lại `y` ký tự
```
[root@hd ~]# printf '%s\n' "${var:5:-5}"
56789a

[root@hd ~]# printf '%s\n' "${var:10:-0}"

[root@hd ~]# printf '%s\n' "${var:10:-1}"
abcde

```
* `${var: -n}` : Lấy số ký tự tính từ cuối. Khoảng trắng là cần thiết và khác với `${var:-n}`, có thể thay thế `${var:(-n)}`
```
[root@hd ~]# printf '%s\n' "${var:-6}"
0123456789abcdef

[root@hd ~]# printf '%s\n' "${var: -6}"
abcdef

[root@hd ~]# printf '%s\n' "${var: -8}"
89abcdef

[root@hd ~]# printf '%s\n' "${var:(-6)}"
abcdef
```
* Đối với mảng
```
[root@hd ~]# myarr[0]='0123456789abcdef'
[root@hd ~]#  printf '%s\n' "${myarr[0]:7:3}"
789
```
### 5 Hướng tham số
Bash indirection cho phép nhận của một biến có tên được chứa trong mọt biến khác.
```
A="Đây là chữ A"
B="Đây là chữ B"
C="Đây là chữ C"

[root@hd ~]# i=C 
[root@hd ~]# echo "${!i}"
Đây là chữ C
[root@hd ~]# i=A
[root@hd ~]# echo "${!i}"
Đây là chữ A
```
Chuyển hướng biến i đến biến C và biến A được khai báo hướng

* Một số ví dụ:
```
# foo=10
# x=foo
# echo ${x} #In ra biến theo kiểu cơ bản
foo

# foo=10
# x=foo
# echo ${!x} 
10
```
## 6 Mở rộng tham số và tên tệp
Bạn có thể sử dụng Bash Parameter Expansion để mô phỏng các hoạt động xử lý tên tệp phổ biến như `basename` và `dirname`

Ví dụ: Cho đường dẫn `/tmp/ex/myfolder/file.txt`

Để mô phỏng **dirname** và trả về tên thư mục của đường dẫn tệp:
```
# FILENAME="/tmp/ex/myfolder/file.txt"
# echo "${FILENAME%/*}"
/tmp/ex/myfolder
```

Để mô phỏng **basename** `$FILENAME` và trả về tên tệp của đường dẫn tệp:
```
# echo "${FILENAME##*/}"
file.txt
```

Để mô phỏng **basename** `$FILENAME` `.txt` và trả về tên tệp không có tên mở rộng `.txt`:
```
[root@hd myfolder]# BASENAME="${FILENAME##*/}"
[root@hd myfolder]# echo "${BASENAME%%.txt}"
file
```
## Thay thế giá trị mặc định
`${parameter:-word}`: Nếu tham số không được đặt hoặc null, sự mở rộng của từ sẽ được thay thế. Nếu không, giá trị của tham số được thay thế.
```
$ unset var
$ echo "${var:-XX}" # Tham số chưa được đặt -> Xảy ra mở rộng
XX
$ var="" # Tham số là null -> Xảy ra mở rộng
$ echo "${var:-XX}"
XX
$ var=23 # Tham số không rỗng -> kết quả ban đầu
$ echo "${var:-XX}"
23
```

`${parameter:=word}`: Nếu tham số không được đặt hoặc null, phần mở rộng của ký tự được gán cho tham số. Giá trị của tham số sau đó được thay thế. Các tham số vị trí và tham số đặc biệt có thể không được gán theo cách này.
```
# unset var
# echo "${var:=XX}" # Tham số chưa được đặt -> được gắn vào XX
XX
# echo "$var"
XX
# var="" # Tham số null -> từ được gắn cho XX
# echo "${var:=XX}"
XX
# echo "$var"
XX
# var=23 # Tham số đã có giá trị -> Không gắn được
# echo "${var:=XX}"
23
# echo "$var"
23
```