Các biến bên trong bash 
Tổng quan về các biến nội bộ của bash, ở đâu như thế nào và khi nào cần sử dụng chúng.
## Tóm tắt các biens nội bộ
|Variable|Chi tiết|
|-|-|
|$* / $@|Tham số (đối số) vị trí của Function/script. Mở rộng như sau: <br />$* và $* giống như $1 $2 ..<br />"$*" giống như "$1 $2 ..." 1 (1 ở đây được hiểu là các đối số được phân tách bằng ký tự đầu tiên của $Í, ký tự này không nhất thiết phải là khoảng trắng)<br />"$@" giống như "$1" "$2"... |
|$#|Số tham số vị trí được truyền vào cho Script hoặc function | 
|$!|pROCESS ID của lệnh cuối cùng (gần nhất cho pipeline) trong công việc gần nhất được đưa và nền (lưu ý rằng nó không nhất thiết phải giống với process group ID của công việc khi job control được bật)  |
|$$|ID của quá trình thực thi bash |
|$?|Exit code của lệnh cuối cùng|
|$n|Tham số vị trí, được biểu diễn từ 1,2,3,...,6|
|${n}|Giống bên trên nhưng n có thể lớn hơn 9|
|$0|Trong script, đường dẫn mà tệp lệnh được gọi; với tên bash -c 'printf  "%s\n" "$0"' name args ': name (đối số đầu tiên sau tập lệnh nội tuyến), ngược lại, argv [0] mà bash nhận được. |
|$_|Trường cuối cùng của lệnh cuối cùng|
|$IFS|Dấu phân tách trường nội bộ|
|$PATH|Biến môi trường $PATH được sử dụng để tra cứu các tệp thực thi|
|$OLDPWD|Thư mục làm việc trước đó|
|$PWD |Thư mục làm việc hiện tại|
|$FUNCNAME|Mảng của tên hàm trong stack lệnh gọi thực thi|
|$BASH_SOURCE|Mảng chứa đường dẫn sourcecho các phần tử trong mảng FUNCNAME. Có thể được sử dụng để lấy đường dẫn script|
|$BASH_ALIASES|Mảng liên kết chứa tất cả các bí danh hiện được xác định|
|$BASH_REMATCH|Chuỗi các kết quả phù hợp từ regex match gần nhất|
|$BASH_VERSION |Chuỗi phiên bản BASH |
|$BASH_VERSINFO |Một mảng gồm 6 phần tử với thông tin phiên bản bash |
|$BASH |Đường dẫn tuyệt đối đến Bash shell hiện đang thực thi( được xác định dựa trên csdl trên argv[0] và giá trị $PATH; có thể sai trong các trường hợp nền tảng khác nhau)|
|$BASH_SUBSHELL|Cấp độ Bash subshell|
|$UID|ID người dùng thực của quá trình chạy bash |
|$PS1|Dấu nhăc dòng lệnh chính; xem sử dụng các biến PS*|
|$PS2|Lời nhắc dòng lệnh phụ (được sử dụng cho đầu vào bổ sung)|
|$PS3|Lời nhắc dòng lệnh cấp ba (được sử dụng trong vòng lặp chọn)|
|$PS4|Lời nhắc dòng lệnh bậc bốn (được sử dụng để nối thông tin với đầu ra dài dòng)|
|$RANDOM|Một nguyên ngẫu nhiên từ 0 đến 32767|
|$REPLY|Biến được sử dụng theo cách read theo mặc định khi không có biến nào được chỉ định. Cũng được sử dụng bởi SELECT để trả về
giá trị do người dùng cung cấp|
|$PIPESTATUS|Biến mảng giữ các giá trị trạng thái thoát của mỗi lệnh trong đường dẫn nền trước được thực thi gần đây nhất.|
## 1.1 Đặt biến
Variable Assignment- phép gán biến không được có khoảng trắng trước và sau. `a=123` không được `a = 123`. Ví dụ sau (dấu bằng được bao quanh bởi dấu cách) riêng biệt có nghĩa là chạy lệnh a với các đối số = và 123, mặc dù nó cũng được nhìn thấy trong toán tử so sánh chuỗi (về mặt cú pháp là đối số của [ hoặc [[hoặc bất kỳ thử nghiệm nào bạn đang sử dụng).

## 1.2 $@
`"$@"` mở rộng thành tất cả các đối số trong dòng lệnh dưới dạng từ riêng biệt. Nó khác với `"$*"`, mở rộng thành tất cả các đối số dưới dạng một từ duy nhất.
`"$@"` Đặc biệt hữu ích để lặp qua các đối số và xử lý các đối số có dấu cách.

Thực hiện tạo script.sh và thực hiện như sau để thấy sự khác biệt:
```
./script.sh "␣1␣2␣" "␣3␣␣4␣"
```

Biến $* và $@ sẽ mở rộng thành $1 $2, lần lượt mở rộng là 1 2 3 4 do đó, có vòng lặp:
```
#!/bin/bash 
for var in $*; do # same for var in $@; do
    echo $var
done

echo 
echo "-$1--$2"
echo $3
echo $
```
Sẽ in ra cho cả 2 trưởng hợp $@ và $*:
```
[root@hd ~]# ./myscript.sh ' 1 2 ' ' 3  4 '
1
2
3
4

- 1 2 -- 3  4 

1 2 3 4
```
Trong khi `"$*"` sẽ được mở rộng thành `"$1 $2"` lần lượt sẽ mở rộng thành `" 1 2  3 4 "`
```
#!/bin/bash 
for var in "$*"; do 
    echo "<$var>"
done

echo 
echo "-$1--$2"
echo $3
echo $*
```
Output:
```
[root@hd ~]# ./myscript.sh ' 1 2 ' ' 3  4 '
< 1 2   3  4 >

- 1 2 -- 3  4 

1 2 3 4
```
Trong khi `"$@"` sẽ được mở rộng thành `"$1" "$2"` lần lượt sẽ mở rộng thành `"_1_2_" "_3__4_"`
```
#!/bin/bash 
for var in "$@"; do 
    echo "<$var>"
done

echo 
echo "-$1--$2"
echo $3
echo $*
```
output:
```
[root@hd ~]# ./myscript.sh ' 1 2 ' ' 3  4 '
< 1 2 >
< 3  4 >

- 1 2 -- 3  4 

1 2 3 4
```
Do đó bảo tồn cả khoảng cách bên trong các đối số và sự tách biệt đối số. Lưu ý rằng cáu trúc cho var trong ` for var in "$@"; do ...` rất phổ biến và trở thành mặc định cho vòng lặp for và có thể rút gọn thành ` for var; do ....`
## 1.3 $#
Để nhận số lượng đối số đã nhập vào dòng lệnh hoặc tham số vị trí, trong myscript.sh:
```
#!/bin/bash
echo "$#"
```
Khi đó thực hiện nhập đối số:
```
[root@hd ~]# ./myscript.sh ' 1 2 ' ' 3  4 '
2
[root@hd ~]# ./myscript.sh thu1 thu2 thu3 thu4
4
[root@hd ~]# ./myscript.sh "thu1 thu2 thu3 thu4"
1
```
## 1.4 $HISSIZE
Số câu lệnh mà môi trường nhớ tối đa:
```
[root@hd ~]# echo $HISTSIZE
1000
```
## 1.5 $FUNCNAME
Để lấy tên của hàm hiện tại:
```
#!/bin/bash 
abc_function(){
 echo "Tên của hàm này là $FUNCNAME"
}
abc_function

home_function(){
 echo "---Home--- Tên của hàm này là $FUNCNAME"
}
home_function
```
output:
```
[root@hd ~]# ./myscript.sh 
Tên của hàm này là abc_function
---Home--- Tên của hàm này là home_function
```
## 1.6 $HOME
Thư mục chính của người dùng:
```
[root@hd ~]# echo $HOME
/root

[huydv@hd root]$ echo $HOME
/home/huydv
```
## 1.7 $IFS
Chứa chuỗi dấu phân cách trường nội bộ mà bash sử dụng để chia chuỗi khi lặp lại, Giá trị mặc định là ký tự khoảng trắng, \n (dòng mới), \t(tab) và dấu cách. Thay đổi điều này thành một thứ khác cho phép bạn chia chuỗi bằng các ký tự khác nhau:
vd1:
```
#!/bin/bash 
IFS=","
INPUTSTR="a,b,c,d"
for field in ${INPUTSTR}; do
    echo $field
done
```
output:
```
[root@hd ~]# ./myscript.sh 
a
b
c
d
```
vd2:
```
#!/bin/bash 
IFS=";"
INPUTSTR="a,b;c,d;e,f"
for field in ${INPUTSTR}; do
    echo $field
done
```
output;
```
[root@hd ~]# ./myscript.sh 
a,b
c,d
e,f
```
## 1.8: $OLDPWD
OLDPWD (OLDPrintWorkingDirectory) Chứa thư mục mà làm việc cuối cùng
```
[root@hd backup_data]# pwd
/root/backup_data
[root@hd backup_data]# cd /root/toplevel/
[root@hd toplevel]# echo $OLDPWD
/root/backup_data
```
## 1.9: $PWD
PWD (PrintWorkingDirectory) In ra thư mục đang làm việc hiện tại:
```
[root@hd abc]# pwd
/root/dir/abc
```
## 1.10: $1 $2 $3 etc..
Các tham số được truyền vào một script/function:
```
#!/bin/bash 
echo $1
echo $2
echo $3
```
output
```
[root@hd ~]# ./myscript.sh abc 12345 "hello world"
abc
12345
hello world
```
## 1.11: $*
Sẽ trả về tất cả tham số trong một chuỗi duy nhất:

**myscript.sh**:
```
#!/bin/bash
echo "$*"
```
output:
```
[root@hd ~]# ./myscript.sh abc 12345 "hello world"
abc 12345 hello world
```
## 1.12: $!
Process IP(PID) của jobs cuối cùng chạy nền
```
[root@hd ~]# sleep 5 &
[1] 1943
[root@hd ~]# echo $!
1943
[1]+  Done                    sleep 5
```
## 1.13: $?
In ra Exit code cuối cùng
```
[root@hd ~]# echo "" ; echo $?

0
[root@hd ~]# $ ls; echo $?
bash: $: command not found
127
[root@hd ~]# ls *.blah;echo $?
ls: cannot access *.blah: No such file or directory
2
[root@hd ~]#  $yum install -y sadf;echo $?
install: invalid option -- 'y'
Try 'install --help' for more information.
1
```
## 1.14 $$
PID- Process ID của quy trình hiện tại
```
[root@hd ~]# echo $$
1699
```
## 1.15: $RANDOM
Mỗi khi tham số này được tham chiếu, một số nguyên ngẫu nhiên từ 0 đến 32767 sẽ được tạo ra.
```
[root@hd ~]# echo $RANDOM
17148
[root@hd ~]# echo $RANDOM
14212
[root@hd ~]# echo $RANDOM
31053
[root@hd ~]# echo $RANDOM
21481
```
## 1.16: $BASHPID
Process ID của phiên bản bash hiện tại. Điều này không giống với biến $$, nhưng nõ thường cung cấp cùng một kết quả. Tính năng nà mới trong bash 4 và không hoạt động trong bash 3
```
[hdc@hd root]$ echo "\$\$ pid = $$ BASHPID = $BASHPID"
$$ pid = 2128 BASHPID = 2128
```
## 1.36.17: $BASH_ENV
Một biến môi trường trỏ đến tệp khởi động bash được đọc khi một tập lệnh được gọi.
## 1.18: $BASH_VERSINFO
Một mảng chứa thông tin phiên bản đầy đủ được chia thành các phần tử, thuận tiện hơn nhiều so với  $BASH_VERSION nếu bạn chỉ đang tìm kiếm phiên bản chính:
```
[hdc@hd root]$  for ((i=0; i<=5; i++)); do echo "BASH_VERSINFO[$i] = ${BASH_VERSINFO[$i]}"; done
BASH_VERSINFO[0] = 4
BASH_VERSINFO[1] = 2
BASH_VERSINFO[2] = 46
BASH_VERSINFO[3] = 2
BASH_VERSINFO[4] = release
BASH_VERSINFO[5] = x86_64-redhat-linux-gnu
```
## 1.19: $BASH_VERSION
Hiển thị phiên bản bash đang chạy, điều này cho phép bạn quyết định xem bạn có thể sử dụng bất kỳ tính năng nâng cao nào không:
```
[root@hd ~]# echo $BASH_VERSION
4.2.46(2)-release
```
## 1.20: $EDITOR
Trình chỉnh sửa văn bản đang chạy, nếu điều này cho phép bạn quyết định xem bạn có thể sử dụng bất kỳ tính năng nâng cao nào không:

## 1.21: $HOSTNAME
Tên máy chủ được gán cho hệ thống trong quá trình khởi động.
## 1.22: $HOSTTYPE
Biến này xác định phần cứng, nó có thể hữu ích trong việc xác định mã nhị phân nào sẽ được thực thi:
```
[root@hd ~]# echo $HOSTTYPE
x86_64
```
## 1.23: $MACHTYPE
Tương tự như $ HOSTTYPE ở trên, phần này cũng bao gồm thông tin về hệ điều hành cũng như phần cứng:
```
[root@hd ~]# echo $MACHTYPE
x86_64-redhat-linux-gnu
```
## 1.24: $OSTYPE
Trả về thông tin về hệ điều hành đang chạy trên máy,:
```
[root@hd ~]# echo $OSTYPE
linux-gnu
```
## 1.25: $PATH
Đường dẫn để tìm kiếm mã nhị phân cho các lệnh. Các ví dụ phổ biến bao gồm **/usr/bin** và **/usr/local/bin**.

Khi người dùng hoặc script cố gắng chạy một lệnh, các đường dẫn $PATH sẽ tìm kiếm tệp phù hợp để thực thi

Các thư mục trong $PATH được phân tách bằng ký tự hai chấm:
```
[root@hd ~]#  echo "$PATH"
/root/.vscode-server/bin/2aeda6b18e13c4f4f9edf6667158a6b8d408874b/bin:/root/.vscode-server/bin/2aeda6b18e13c4f4f9edf6667158a6b8d408874b/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
```


## 1.26: $PPID
Process ID của script hoặc shell's parent, có nghĩa là tiến trình được gọi ra tập lệnh hoặc trình bao hiện tại.
```
[root@hd ~]# echo $$
2186
[root@hd ~]#  echo $PPID
1699
```
## 1.27: $SECONDS
Số giây mà một tệp script đã chạy. Điều này có thể khá hơn nếu được hiển thị trong shell:
```
[root@hd ~]# echo $SECONDS
785
```
## 1.28: $SHELLOPTS
Một danh sách chỉ đọc các tùy chọn cơ bản được cung cấp khi khởi động để kiểm soát hành vi của nó:
```
[root@hd ~]# echo $SHELLOPTS
braceexpand:emacs:hashall:histexpand:history:interactive-comments:monitor
```
## 1.29: $_
Xuất ra trường cuối cùng từ lệnh cuối cùng được thực thi
```
[root@hd ~]# ll *.txt ;echo $_
-rw-r--r--. 1 root root   19 Jun 29 14:29 fruits.txt
-rw-r--r--. 1 root root  282 Jul  7 19:24 listactive.txt
-rw-r--r--. 1 root root 2589 Jun 30 04:28 listip.txt
-rw-r--r--. 1 root root  208 Jun 29 04:28 list.txt
list.txt

[root@hd ~]# ll *.sh;echo "$_"
-rwxr-xr-x. 1 root root  288 Jun 28 11:07 file1.sh
-rwxr-xr-x. 1 root root 2176 Jun 15 15:55 file.sh
-rwxr-xr-x. 1 root root  190 Jun 15 17:57 helloname.sh
-rwxr-xr-x. 1 root root 2082 Jun 29 00:34 install-wp.sh
-rwxr-xr-x. 1 root root   22 Jul 17 00:50 myscript.sh
-rwxr-xr-x. 1 root root 2240 Jul 16 22:00 pingnmap.sh
-rw-r--r--. 1 root root  113 Jul 17 00:04 q.sh
-rwxr-xr-x. 1 root root  138 Jun 28 19:15 removemariadb.sh
-rwxr-xr-x. 1 root root  232 Jul 16 21:31 t.sh
t.sh
```
## 1.30: $GROUPS
Một mảng chứa số lượng nhóm mà người dùng đang ở:
## 1.31: $LINENO
Xuất ra số dòng trong tập lệnh hiện tại. Hầu hết hữu ích khi gỡ lỗi tập lệnh.
```
#!/bin/bash
# this is line 2
echo something # this is line 3
echo $LINENO # Will output 4
```
output:
```
[root@hd ~]# ./myscript.sh 
something
4
```
## 1.32: $SHLVL
Khi lệnh bash được thực thi, Một shell mới sẽ được mở. Biến môi trường $SHLVL chứa số lượng cấp shell mà shell hiện tại đang chạy trên đó. Một của sổ đầu cuối mới, việc thực hiện lệnh sau sẽ tạo ra các kết quả khác nhau dựa trên bản phân phối linux đang được sử dụng.
```
[root@hd ~]# echo $SHLVL
5
[root@hd ~]# bash 
[root@hd ~]# echo $SHLVL
6
[root@hd ~]# bash 
[root@hd ~]# echo $SHLVL
7
```

## 1.33: $UID
Biến chỉ đọc lưu trữ số ID của người dùng, Câu lệnh được sử dụng bởi 3 người dùng khác nhau.
```
[root@hd ~]# echo $UID
0

[huydv@hd root]$ echo $UID
1000

[hdc@hd root]$ echo $UID
1002
```
Thanks and best regards