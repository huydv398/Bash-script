# Day 3 Bash shell
1. [Using cat ](#1)
2. [Grep](#2)
3. [alias](#3)
<a name=1></a>
## Using cat
### 1.1 Nối file
`cat file1 file2 file3 >file_all`

Mục đích chính của câu lệnh trên là lấy thông tin từ file1, file2 và file3 rồi ghi vào file_all
ví dụ:
```
[root@hdv ~]# echo "duonghuy" > file1
[root@hdv ~]# echo "techology" > file2
[root@hdv ~]# echo "Onedata-esvn" > file3
[root@hdv ~]# cat file1 file2 file3 > file_all
[root@hdv ~]# cat file_all 
duonghuy
techology
Onedata-esvn

```

cat cũng có thể được sử dụng tương tự để nối các tệp như một phần của đường dẫn:
```
[root@hdv ~]# cat file1 file2 file3 | grep duonghuy
duonghuy
```

### 1.2 Hiển thị ra nội dung của một file
In ra nội dung của tệp:
```
[huydv@hdv]$ cat info.txt 
Username 
1998
Hà Nội Việt Nam
Covid
```

Nếu tệp chứa ký tự khoogn phải ASCII, bạn có thể hiển thị các ký tự đó một cách tượng trưng bằng `cat -v`. Điều này khá hữu ích cho các tình huống mà không thể nhìn thấy.

Tuy nhiên khi cat để hiển thị ra một văn bản quá dài thì bạn chỉ xem được phần cuối cùng còn hiển thị trên màn hình. `less` và `more` sử dụng để tương tác được nhiều hơn và có thể sử dụng mũi tên điều hướng để hiển thị văn bản. 

Để chuyển nội dung của tệp làm input cho một lệnh. Câu lệnh sau đây có chức năng như lệnh cat:

`tr A-Z a-z <file.txt `

Trong trường hợp nội dung cần được liệt kê ngược so với phần cuối của nó, lệnh tac ngược lại với cat liệt kê từ dòng cuối cùng

`tac file.txt`

Nếu bạn muốn hiển thị nội dung có in số dòng:
```
[huydv@hdv Picture]$ cat -n info.txt 
     1  Username 
     2  1998
     3  Hà Nội Việt Nam
     4  Covid
```
### 1.3 Viết vào file
```
[huydv@hdv ]$ cat > file
Vietnam 
bash shell
[huydv@hdv ]$ cat file 
Vietnam
bash shell

[huydv@hdv ]$ cat >> file 
Tutorial   
[huydv@hdv ]$ cat file 
Vietnam
bash shell
Tutorial
```

`>` Bash sẽ xóa hết dữ liệu có trong file và viết dữ liệu mà bạn nhập vào file

`>>` Bash sẽ ghi tiếp dữ liệu mà bạn nhập vào file

Khi bạn muốn kết thúc thực hiện tổ hợp phím **Crl** + **d**

### 1.4 Đọc từ đầu vào tiêu chuẩn

```
[huydv@hdv]$ printf "first line\nSecond line\n" | cat -n
     1  first line
     2  Second line
```
Dấu | dùng để thực hiện lệnh printf rồi mới thực hiện lệnh cat
### 1.5 Display line numbers with output - Hiển thị số dòng với đầu ra
Sử dụng cờ `--number` hoặc `-n` để in số dòng trước mỗi dòng.
```
[huydv@hdv]$ cat --number info.txt 
     1  Username 
     2  1998
     3
     4  Hà Nội Việt Nam
     5  Covid
     6
     7  hcd
```

Sở dụng cờ `-b` in số dòng bỏ qua các dòng không có dữ liệu
```
[huydv@hdv ]$ cat -b info.txt 
     1  Username 
     2  1998

     3  Hà Nội Việt Nam
     4  Covid

     5  hcd
```
### 1.6 Nối các tệp zip
Các file được nén bởi gzip có thể được nối trực tiếp thành các tệp gzipped lớn hơn.
```
[huydv@hdv ]$ gzip file1 file2 file3
[huydv@hdv ]$ ls
file1.gz  file2.gz  file3.gz
[huydv@hdv ]$ cat file1.gz file2.gz file3.gz > combined.gz
```
Khi thực hiện lệnh trên thì sẽ nén file và gộp 3 file nén vào 1 file gzip chung.

Câu lệnh sau thực hiện gọn hơn mà file vẫn giữ nguyên.
```
[huydv@hdv ]$ ls
file file2  file3
[huydv@hdv ]$ cat file1 file2 file3 | gzip > combined.gz
[huydv@hdv ]$ ls
combined.gz  file1  file2 file3
```

Một ví dụ khác:
```
[huydv@hdv ]$ echo 'Hello world!' > hello.txt
[huydv@hdv ]$ echo 'Howdy world!' > howdy.txt
[huydv@hdv ]$ gzip hello.txt
[huydv@hdv ]$ gzip howdy.txt
[huydv@hdv ]$ cat hello.txt.gz howdy.txt.gz > greetings.txt.gz
[huydv@hdv Techonogy]$ gunzip greetings.txt.gz
[huydv@hdv ]$ cat greetings.txt
Hello world!
Howdy world!
```
2 câu lệnh đầu tiên thực hiện tạo 2 file mới. Dong 3 & 4 thực hiện 2 file. Dòng 5 thực hiện nén vào file chung. Dòng 6 thực hiện giải nén. Dòng cuối xem kết quả ở đây không phải là 2 file gzip là là kết quả đầu tiên của 2 file txt gộp lại.
<a name=2></a>
## Grep
Cách tìm kiếm một tệp cho mẫu
* Để tìm từ 'hcd` trong file ~/Picture/info.txt
![](image\Screenshot_2.png)
* Để tìm ra tất cả các dòng không chứa từ hcd
```
[huydv@hdv ~]$ grep -v hcd ~/Picture/info.txt 
Username 
1998

Hà Nội Việt Nam
Covid
```
<a name=3></a>
## Aliasing
Shell alias là một cách đơn giản để tạo các lệnh mới hoặc đặt một tên gợi nhớ hơn cho các lệnh bằng mã của riêng bạn. 
### 3.1 Bypass an alias
Sử dụng lệnh ls mà không cần tắt alias. Bạn có một số tùy chọn:
* Sử dụng nội trang lệnh: lệnh ls
* Sử dụng đường dẫn đầy đủ của lệnh: `/bin/ls`
* Thêm \ vào bất kỳ đâu trong tên lệnh, ví dụ: `\ls` hoặc `l\s`
* Sử dụng trích dẫn lệnh: "ls" hoặc 'ls'
### 3.2 Tạo alias
`alias key= 'command'` hoặc `alas key = 'command [option]'`
Khi sử dụng `key` như một lệnh để gắn cho command mà bạn đã khai báo.

Để bao gồm nhiều lệnh trong một alias, bạn có thể xâu chuỗi chúng lại với nhau bằng `&&`.
```
[huydv@hdv ~]$ alias chao='echo "Xin" && echo "chao" && echo "Viet Nam" '
[huydv@hdv ~]$ chao
Xin
chao
Viet Nam
```
### 3.3 Xóa alias
`unalias {alias_name}`

```
[huydv@hdv ~]$ alias chao='echo "Xin" && echo "chao" && echo "Viet Nam" '
[huydv@hdv ~]$ alias
alias chao='echo "Xin" && echo "chao" && echo "Viet Nam" '
alias ls='ls --color=auto'

...tac
[huydv@hdv ~]$ unalias chao
[huydv@hdv ~]$ chao
bash: chao: command not found
```

>**Lưu ý**: Sau khi bạn đọc xong day 3 những điều cần nhớ:
* Biết cách sử dụng của các lệnh sau: cat [option, printf with cat], less, more, tr, tac, gzip, gunzip, grep, alias. 