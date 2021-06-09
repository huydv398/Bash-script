# Job and Processes & Redirection

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
Các bộ tệp mô tả như 0 và là các con trỏ. Thay đổi trình mô tả file trỏ tới bằng chuyển hướng >/dev/null. Có nghĩa là 1 điểm đến /dev/null

Đầu tiên chúng trỏ 1 (STDOUT) vào /dev/null sau đó trỏ 2(STDERR) vào một điểm bất kỳ nào.

