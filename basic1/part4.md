# part4 
Trong phần này là output input và mọi thứ liên quan đến vấn đề này.

Bạn đã quen thuộc với hai phương pháp làm việc với những gì các tập lệnh dòng lệnh xuất ra:
* Hiển thị dữ liệu trên màn hình.
* Đang chuyển hướng đầu ra thành một tệp.

Đôi khi một điều gì đó cần được hiển thị trên màn hình và một vấn đề gì đó được ghi vào tệp, vì vậy bạn cần hiểu các xử lý đầu vào và đầu ra trong Linux, có nghĩa là bạn cần học các gửi kết quả của các tập lệnh ở đâu. 

## Bộ mô tả tệp tiêu chuẩn
Mọi thứ trong Linux đều là tệp, bao gồm cả đầu vào và đầu ra. Hệ điều hành xác định các tệp bằng cách sử dụng các bộ mô tả. 

Mỗi quy trình được phép có 9 bộ mô tả tệp đang mở. Bash_shell dự trữ 3 bộ mô tả đầu tiên với ID 0, 1 và 2. Đây là ý nghĩa của chúng.
* 0, STDIN - Đầu vào tiêu chuẩn
* 1, STOUT - Đầu ra tiêu chuẩn
* 2, STDERR - Lỗi tiêu chuẩn

Ba bộ mô tả đặc biệt này xử lý đầu vào và đầu ra của tệp lệnh. Bạn cần hiểu rõ các luồng tiêu chuẩn này. Chúng có thể được so sánh với nền tảng mà sự tương tác của script với thế giới bên ngoài xây dụng. Chúng ta hãy xem xét các chi tiết về chúng.
## STDIN
Đây là đầu vào tiêu chuẩn của SHELL. Đối với thiết bị đầu cuối, đầu vào tiêu chuẩn là bàn phím. Khi các tệp lệnh sử dụng ký tự chuyển hướng đầu vào -`<`, Linux sẽ thay thế Trình mô tả tệp đầu vào tiêu chuẩn bằng ký tự được chỉ định trong lệnh. Hệ thống đọc tệp và xử lý dữ liệu như thể nó được nhập từ bàn phím.

Nhiều lệnh bash lấy đầu vào từ STDIN trừ khi một tệp được chỉ định trên dòng lệnh để lấy dữ liệu từ đó. 

Khi bạn nhập một lệnh `cat` trên dòng lệnh mà không chỉ định tham số, nó sẽ chấp nhận đầu vào `STDIN`. Sau khi bạn nhập dòng tiếp theo, `cat` sẽ in ra màn hình.

## STDOUT
Theo mặc định đây là màn hình. Hầu hết các lệnh bash xuất dữ liệu STDOUT ra bảng điều khiển, điều này khiến nó xuất hiện trong bảng điều khiển. Dữ liệu có thể được chuyển hướng đến một tệp bằng cách đính kèm nó với nội dung của nó bằng lệnh `>>`

Vì vậy, chúng tôi có một tệp dữ liệu nhất định, chúng tôi có thể thêm dữ liệu khác vào bằng lệnh này.

```
[huydv@1data ~]$ pwd
/home/huydv

[huydv@1data ~]$ pwd >> myfile 
       
[huydv@1data ~]$ cat myfile 
/home/huydv
```

`Pwd` in ra màn hình thư mục hiện tại. `>>` lấy Dữ liệu đầu ra của lệnh `pwd` đưa vào `myfile`.

Cho đến nay rất tốt, nhưng điều gì sẽ xảy ra nếu bạn cố gắng làm được điều gì đó như minh họa bên dưới, truy cập vào một tệp không tồn tại `xxfile`, suy nghĩ tất cả những điều này để thông báo myfile 
## Chuyển hướng lỗi và luồng đầu ra
Khi viết script, một tình huống có thể phát sinh trong đó bạn cần tổ chức cả chuyển hướng thông báo lỗi và chuyển hướng đầu ra tiêu chuẩn. Để đạt được điều này, bạn cần sử dụng lệnh chuyển hướng cho các bộ mô tả tương ứng, chỉ ra các tệp lỗi và đầu ra tiêu chuẩn sẽ xảy ra:

`ls –l myfile xfile anotherfile 2> errorcontent 1> correctcontent`

Lệnh trên được giải thích:
* Có 3 file: `myfile`, `xfile` và `anotherfil`
* Liệu kê ra thông tin của 3 file.
* Nếu không có file xảy ra lỗi (2>) lấy lỗi in vào file `errorcontent`
* Nếu đúng liệu kê đầu ra tiêu chuẩn vào file `correctcontent`

```
[huydv@1data ~]$ cat correctcontent 
myfile
[huydv@1data ~]$ cat errorcontent 
ls: cannot access –l: No such file or directory
ls: cannot access xfile: No such file or directory
ls: cannot access anotherfile: No such file or directory
```

Có thể chuyển hướng tất cả thông tin đầu ra tiêu chuẩn `STDOUT` và đầu lỗi `STDERR` vào cùng một file bằng việc sử dụng lệnh : `&>`

## Chuyển hướng đầu ra trong các tập lệnh
Có hai phương pháp để chuyển hướng đầu ra trong các tệp lệnh dòng lệnh:
* Chuyển hướng tạm thời, hoặc chuyển hướng đầu ra của một dòng.
* Chuyển hướng vĩnh viễn hoặc chuyển hướng tất cả hoặc một phần đầu ra trong tệp lệnh.

### Tạm thời chuyển hướng đầu ra
Trong một tập lênh, bạn có thể chuyển hướng đầu ra của một dòng đến STDERR. Để làm được điều này, chỉ cần sử dụng lệnh chuyển hướng, chỉ định một bộ mô tả là đủ STDERR và phía số bộ mô tả

### Chuyển hướng đầu ra vĩnh viễn
Nếu một tập lệnh cần chuyển nhiều hướng nhiều dữ liệu được hiện thị, sẽ không thuận tiện gọi `echo` cho mỗi lần gọi. Thay vào đó bạn có thể đặt đầu ra được chuyển hướng đến một bộ mô tả cụ thể trong khoảng thời gian của tập lệnh bằng cách sử dụng lệnh `exec`:

```
#!/bin/bash
exec 1>outfile
echo "văn bản file "
echo "văn bản file 2"
echo "văn bản file 3"
ls -lah /home
```

Output:
```
[root@1data bash]# cat outfile 
văn bản file 
văn bản file 2
văn bản file 3
total 0
drwxr-xr-x.  3 root  root   19 May 10 22:35 .
dr-xr-xr-x. 17 root  root  224 May  3 10:42 ..
drwx------.  2 huydv huydv 154 May 11 10:44 huydv
```

