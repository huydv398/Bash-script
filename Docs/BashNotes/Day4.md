# Job and Processes & Redirection
1. [Job and Processes](#1)
2. [Redirection](#2)

<a name=1></a>

## 1.1 Xử lý công việc
### Creating jobs
Để tạo job, chỉ cần thêm dấu `&` sau lệnh. & không phải là một tham số cho chương trình. Nó cho shell. `&` là chạy chương trình ở chế độ nền trong shell.

```
[root@hdv ~]# sleep 50 &
[1] 6821
```
Ví dụ trên là thực hiện sleep trong 50. Nếu không có `&` thì sau 50 giây bạn mới thực hiện được câu lệnh tiếp còn nếu có `&` ở cuối cùng thì bạn có thể thực hiện lệnh ngay lập tức. 

[1] Là thứ tự job đang thực hiện

6821 là PID- Process ID

Bạn có thể thực hiện một lệnh tiếp theo mà không cần đợi job thực hiện xong bằng tổ hợp phím **Ctr + Z**. Sử dụng Crl+z sẽ ngưng lại tiến trình nếu muốn tiếp tục xem lệnh `bg` và `fg` bên dưới
```
[root@hdv ~]# sleep 10
^Z
[3]+  Stopped                 sleep 10
```
### Background(bg) and foreground(fg)(đặt vấn đề lên trước) a process 
To bring the Process to the foreground- để đưa một process lên ưu tiên chạy trước, lệnh `fg` được sử dụng cùng với `%`
```
[root@hdv ~]# sleep 300
^Z
[5]+  Stopped                 sleep 300
[root@hdv ~]# ps -f
UID         PID   PPID  C STIME TTY          TIME CMD
root       4050   4001  0 04:33 pts/1    00:00:00 /bin/bash
root       6849   4050  0 12:00 pts/1    00:00:00 sleep 10
root       6888   4050  0 12:04 pts/1    00:00:00 sleep 30
root       6889   4050  0 12:04 pts/1    00:00:00 sleep 300
root       6890   4050  0 12:04 pts/1    00:00:00 ps -f
[root@hdv ~]# fg %5
sleep 300

```

Lệnh `bg` để tiếp tục thực hiện quy trình của process hoặc jobs.
```
bg %4 #thực hiện tiếp job[4]
bg # thực hiện tất cả các job đang bị hoãn
```

```
[root@hdv ~]# bg %4 
[4]- sleep 200 &
```

Lệnh `job` để biết hiện tại có các job lại đang làm việc hoặc đang bị hoãn:
```
[root@hdv ~]# jobs
[5]-  Stopped                 sleep 300
[6]+  Stopped                 sleep 20
[7]   Running                 sleep 20 &
```
### Killing running jobs 
```
[root@hdv ~]# sleep 200 &
[1] 7072
[root@hdv ~]# jobs
[1]+  Running                 sleep 200 &
[root@hdv ~]# kill %1
[root@hdv ~]# jobs
[1]+  Terminated              sleep 200
```
Process sleep chạy trong nền, các tín hiệu kill mặc định là SIGTERM, cho phép các tiến trình thoát không ảnh hưởng.

Một số tín hiệu của lệnh kill phổ biến. Để xem đầy đủ sử dụng `kill -l`
|Signal name |Signal name |Hiệu ứng|
|-|-|-|
|SIGHUP|1|hangup|
|SIGINT|2|Ngắt từ bàn phím|
|SIGKILL|9|kill signal|
|SIGTERM|15|terminal signal|

### Bắt đầu và kết thúc các quy trình cụ thể
Có lẽ đây là các để kill một process đang chạy là chọn nó thông qua tên process

`pkill -f test.sh`

Hoặc một cách chi tiết hơn bằng cách sử dụng pgrep để kiếm PID thực tế:

`kill $(pgrep -f 'bash test.sh')`

Một cách tương tự có thể đạt được bằng cách sử dụng `grep` với lệnh `ps -ef | grep name_process` sau đó kill process được liệt kê ra.

## Viết script
Bắt đầu tiếp cận script và dùng nó để kill. Giả sử bạn muốn thực thi và kill

## 1.2 Kiểm tra Process đang chạy trên cổng cụ thể
Để kiểm tra quá trình nào đang chạy trên cổng cụ thể 22 hoặc 80
```
[root@hdv huydv]# lsof -i :22
COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
sshd    1111 root    3u  IPv4  20364      0t0  TCP *:ssh (LISTEN)
sshd    1111 root    4u  IPv6  20366      0t0  TCP *:ssh (LISTEN)
sshd    3895 root    3u  IPv4  35655      0t0  TCP hdv:ssh->192.168.10.1:64844 (ESTABLISHED)
sshd    8071 root    3u  IPv4  69039      0t0  TCP hdv:ssh->192.168.10.1:52581 (ESTABLISHED)
sshd    8174 root    3u  IPv4  69103      0t0  TCP hdv:ssh->192.168.10.1:52610 (ESTABLISHED)

[root@hdv huydv]# lsof -i :80
COMMAND  PID   USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
httpd   8426   root    4u  IPv6  70845      0t0  TCP *:http (LISTEN)
httpd   8427 apache    4u  IPv6  70845      0t0  TCP *:http (LISTEN)
httpd   8428 apache    4u  IPv6  70845      0t0  TCP *:http (LISTEN)
httpd   8429 apache    4u  IPv6  70845      0t0  TCP *:http (LISTEN)
httpd   8430 apache    4u  IPv6  70845      0t0  TCP *:http (LISTEN)
httpd   8431 apache    4u  IPv6  70845      0t0  TCP *:http (LISTEN)
```
### 1.3 Từ chối background job
`disown %[job]`
Điều này cho phép một quá trình thoát khỏi job.
### 1.4 Tìm kiếm thông tin về một quy trình đang chạy
`ps aux | grep <search-term>` Hiển thị các quy trình phù hợp với cụm từ tìm kiếm.
```
[root@hdv ~]# ps aux | grep httpd
root       8426  0.0  0.2 230440  5208 ?        Ss   15:34   0:00 /usr/sbin/httpd -DFOREGROUND
apache     8427  0.0  0.1 230440  2984 ?        S    15:34   0:00 /usr/sbin/httpd -DFOREGROUND
apache     8428  0.0  0.1 230440  2984 ?        S    15:34   0:00 /usr/sbin/httpd -DFOREGROUND
apache     8429  0.0  0.1 230440  2984 ?        S    15:34   0:00 /usr/sbin/httpd -DFOREGROUND
apache     8430  0.0  0.1 230440  2984 ?        S    15:34   0:00 /usr/sbin/httpd -DFOREGROUND
apache     8431  0.0  0.1 230440  2984 ?        S    15:34   0:00 /usr/sbin/httpd -DFOREGROUND
root       9128  0.0  0.0 112816   976 pts/7    S+   16:45   0:00 grep --color=auto httpd
```

### 1.5 Liệt kê tất cả các quy trình
Các hai cách phổ biến để liệt kê tất cả các quy trình trên một hệ thống. Liệt kê tất cả các process đang chạy bởi tất cả người dùng chúng khác nhau về định dạng mà chúng xuất ra
* `ps -ef` 
* `ps aux` 
<a name=2></a>


## 2 Redirection- Chuyển hướng
### 2.1 Chuyển hướng đầu ra tiêu chuẩn
`>` Chuyển hướng đầu ra tiêu chuẩn hay còn được gọi là STDOUT của lệnh hiện tại thành một tệp hoặc một bộ mô tả khác.
```
ls >file.txt
> file.txt ls
```

Ví dụ:

```
[root@hdv ~]#  ls
anaconda-ks.cfg  file2  file_all
file1            file3 

[root@hdv ~]# ls > file.txt
  
[root@hdv ~]# cat file.txt 
anaconda-ks.cfg
file1
file2
file3
file_all

[root@hdv ~]# > file1.txt ls
 
[root@hdv ~]# cat file1.txt 
anaconda-ks.cfg
file1
file1.txt
file2
file3
file_all

```
Nếu không tồn tại hoặc không có giá trị nào được chỉ định. Lệnh sẽ in ra lỗi và STDOUT sẽ không có dữ liệu.

```
[root@hdv ~]# ls 1 > file2.txt
ls: cannot access 1: No such file or directory
 
[root@hdv ~]# cat file2.txt 
```

Lưu ý: chuyển hướng được tạo bởi wxecuted shell chứ không phải thực hiện bằng executed command, do đó nó sẽ hoàn thành trước khi thực thi lệnh.
### 2.2 Append vs Truncate
1. Truncate >
Được thực thi như sau:

Ví dụ: 
```
[root@hdv ~]# echo 'hello' > file
[root@hdv ~]# echo 'Xin chào' > file
[root@hdv ~]# cat file
Xin chào
```
* Tạo tệp **file** nếu nó không tồn tại
* Truncate: loại bỏ nội dung của tệp nếu nó tồn tại file
* Ghi nội dung **Xin chào** vào tệp. Vì nó là nội dung ghi vào sau cùng khi sử dụng Truncate >

2. Append >>
* Tạo file được chỉ định nếu nó không tồn tại
* Append- nối tệp(ghi vào cuối tệp)
```
[root@hdv ~]# echo 'hello' > file
[root@hdv ~]# echo 'Vietnam' >> file
[root@hdv ~]# cat file
hello
Vietnam
```

### 2.3 Chuyển hướng cả STDOUT và STDERR
Các bộ tệp mô tả như 0 và là các con trỏ. Thay đổi trình mô tả file trỏ tới bằng chuyển hướng >/dev/null. Có nghĩa là 1 điểm đến /dev/null-là một tệp Thiết bị giả và thuộc loại tệp ký tự đặc biệt, chập nhận và loại bỏ tất cả đầu vào được ghi vào nó.

Mọi thứ trong linux đều là một file, ngay cả các STDIN, STDOUT,STDERR cũng đều là file. Mỗi file đều có một định danh gì đó để có thể cầm lắm hay thao tác được. Còn `/dev/null` cũng là một device hay cũng là một file đặc biệt trong linux thường được sử dụng để chứa các dữ liệu rác từ các Input stream khi chúng ta không muốn sử lý hay muốn hiển thị nó.

Đầu tiên chúng trỏ 1 (STDOUT) vào /dev/null sau đó trỏ 2(STDERR) vào một điểm bất kỳ nào.

`echo 'hello' > /dev/null 2>&1`
### 2.4 Using named pipes
Đôi khi bạn muốn xuất một cái gì đó bằng một chương trình và nhập nó vào bằng một chương trình khác
```
[root@hdv ~]# ls -l |  grep 'h'
-rwxr-xr-x. 1 root root        162 Jun  9 17:23 hello.sh
drwxr-xr-x. 6 root root        247 May 22 07:46 python
-rw-r--r--. 1 root root          0 Jun  5 16:39 script.sh
```

Bạn chỉ có thể ghi vào một tệp tạm thời:
```
[root@hdv dir]# ls /root/ > file
[root@hdv dir]# grep ".txt" <file 
file1.txt
file2.txt
file.txt
logcmd.txt
log.txt
tempFile.txt
```

Điều này làm tốt cho hầu hết các ứng dụng, tuy nhiên, sẽ không ai biết **file** làm gì và ai đó có thể xóa nó nếu nó chứa output của lệnh ls.
```
[root@hdv dir]# mkfifo pipefile
[root@hdv dir]# ls /root/ > pipefile &
[4] 13540
[root@hdv dir]# grep '.txt' <pipefile 
file1.txt
file2.txt
file.txt
logcmd.txt
log.txt
tempFile.txt
[4]   Done                    ls --color=auto /root/ > pipefile
[root@hdv dir]# ls -l
total 4
-rw-r--r--. 1 root root 158 Jun 10 03:07 file
prw-r--r--. 1 root root   0 Jun 10 03:11 pipefile
```

Bạn không thể xem bằng lệnh cat vì pipefile vì nó được liệt kê là môt pipe, không phải file

Khi tôi không sử dụng & ở cuối câu lệnh thì sẽ bị treo và hãy làm như sau: 
```
[root@hdv dir]# echo "hello my love" > pipefile &
[4] 13558
[root@hdv dir]# cat < pipefile 
hello my love
[4]   Done                    echo "hello my love" > pipefile
```

Bạn có thể nhận thấy sau khi lời chào được xuất ra, chương trình trương thiết bị được kết thúc tại đây.

Named pipes có thể hữu ích cho việc di chuyển thông tin giữa các thiết bị đầu cuối hoặc giữa các chương trình.

Một số ví dụ:
```
[root@hdv dir]#  { ls -l /home && cat file; } > mypipe &
[4] 13620
[root@hdv dir]# cat < mypipe 
total 0
drwx------. 3 huydv huydv 180 Jun  9 15:42 huydv
anaconda-ks.cfg
dir
file
file1
file1.txt
test
[4]   Done                    { ls --color=auto -l /home && cat file; } > mypipe


```
### 2.5 Chuyển hướng đến các địa chỉ mạng
Bash coi một số đường dẫn là đặc biệt và có thể thực hiện một só giao tiếp mạng bằng cách viết vào /dev/{udp|tcp}/host/port . Bash không thể thiết lập một máy chủ để lắng nghe, nhưng có thể bắt đầu kết nối và đối với TCP thì có thể đọc được kết quả.
Lệnh exec khi sử dụng sẽ không nhận được STDOUT.
```
exec 3</dev/tcp/www.google.com/80
printf 'GET / HTTP/1.0\r\n\r\n' >&3
cat <&3
```

và kết quả của trang web sẽ được in ra  STDOUT


### 2.6 In thông báo lỗi ra STDERR
THông báo lỗi thường được bao gồm trong một script cho mục đích gỡ lỗi hoặc để cung cấp cho trải nghiệm người dùng phong phú.
```
[root@hdv huydv]# cmd || echo 'cmd failed'
bash: cmd: command not found
cmd failed
```

Có thể hoạt động với các trường hợp đơn giản nhưng không phải cách thông dụng. 
```
if cmd; then
 echo 'success'
else
 echo 'cmd failed' >/dev/stderr
fi
```
Trong ví dụ trên, thông báo success sẽ được in tren estou tron gkhi thông báo error sẽ được in stderr

Cách tốt hơn để in ra thông báo lỗi là xác định một hàm:
```
err(){
 echo "E: $*" >>/dev/stderr
}

```
bây giờ sử dụng function vừa tạo để in ra lỗi:
```
[root@hdv huydv]# err
E: 
[root@hdv huydv]# err "Thông điệp lỗi"
E: Thông điệp lỗi
```

### Chuyển hướng nhiều lệnh đến cùng một file
```
[root@hdv ]# {  echo "contents of home directory";  ls ; } > output.txt
[root@hdv ]# cat output.txt 
contents of directory
file1
file2
file3
output.txt
```
### 2.8 Chuyển hướng STDIN
`<` đọc từ đối số bên phải và ghi vào đối số bên trái.

```
[root@hdv ]# echo "Error 
> messages
> generally
> included
> script
> purposes
> providing">fi
[root@hdv ]# grep "script" < fi
script
[root@hdv huydv]# sort < fi
Error 
generally
included
messages
providing
purposes
script
```
### 2.9 Chuyển hướng STDERR
2 là STDERR

`echo_to_stderr 2>/dev/null`

echo_to_stderr là lệnh ghi "stderr" vào STDERR

```
[root@hdv ]# echo_to_stderr () {
>  echo stderr >&2
> }
[root@hdv ]# echo_to_stderr
stderr
[root@hdv ]# echo_to_stderr () {
>  echo "Lỗi khi thực hiện" >&2
> }
[root@hdv ]# echo_to_stderr
Lỗi khi thực hiện
```

### 2.10 Giải thích STDIN, STDOUT, STDERR 
Câu lệnh có một đầu vào (STDIN) và có 2 đầu ra, đầu ra tiêu chuẩn hay standard output (STDOUT) và Lỗi tiêu chuẩn standard error (STDERR).

**STDIN**

```
[root@hdv huydv]# read
Nhập văn bản vào đây
```
Được sử dụng để cung cấp đầu vào cho một trương trình

**STDOUT**
```
[root@hdv ]# whoami
root
[root@hdv huydv]# ll
total 16
-rw-r--r--. 1 root  root    61 Jun 11 05:22 fi
-rw-r--r--. 1 root  root  1612 Jun 11 04:46 fileout
-rw-r--r--. 1 root  root     0 Jun  9 15:41 log.txt
-rw-r--r--. 1 root  root   185 Jun 11 05:15 output.txt
```
Các câu lệnh sử dụng cho đầu ra bình thường. nội dung xuất ra được gửi đến STDOUT

**STDERR**
```
[root@hdv huydv]# cmd
bash: cmd: command not found
[root@hdv huydv]# haha
bash: haha: command not found
[root@hdv huydv]# ls tệp
ls: cannot access tệp: No such file or directory
```
Được sử dụng cho các thông báo lỗi. Vì thông điệp này không phải danh sách các tệp, nó được gửi đến STDERR

STDIN, STDOUT and STDERR là ba luồng tiêu chuẩn được xác định với shell bằng một con số
0 = Standard in
1 = Standard out
2 = Standard error

Mặc dịnh STDIN là bàn phím. STDOUT và STDERR đều được xuất hiện trong thiết bị đầu cuối(màn hình, remote)

Bạn có thể chuyển hướng STDERR hoặc STDOUT đến bất kỳ thứ gì chúng ta cần. Giả sử bạn chỉ muốn in ra màn hình STDOUT và loại bỏ tất cả cac STDERR

**Redirecting STDERR to /dev/null**
```
[root@hdv huydv]# ls
fi  fileout  log.txt  output.txt  Picture  test.sh
[root@hdv huydv]# ls ls anotherfile 2>/dev/null
[root@hdv huydv]# ls file anotherfile 2>/dev/null
[root@hdv huydv]# ls file anotherfile 
ls: cannot access file: No such file or directory
ls: cannot access anotherfile: No such file or directory
```

Bạn sẽ không thể nhận được bất kỳ đầu ra lỗi nào trên màn hình hiển thị

> **Chú ý**: Những điều cần ghi nhớ và làm được:
Job and Processes & Redirection
* Job và process trong linux? Lệnh dùng để liệt kê process và job
* Lệnh fg và bg sử dụng để làm gì?
* Lệnh kill
* lsof dùng để kiểm tra các process chạy trên poort cụ thể
* Truncate > và Append >>
* lệnh mkfifo sử dụng làm gì?
* Chuyển hướng đến các địa chỉ mạng
* Chuyển hướng STDIN <
* STDIN, STDOUT, STDERR 