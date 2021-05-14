# Part8 Xử lý dữ liệu với AWK
Công cụ `awk` là một tiện ích, nó xử lý dòng dữ liệu đến một mức độ cao hơn so với `sed`. AWK có thể làm được gì:
* Khai báo các biến để lưu trữ dữ liệu.
* Sử dụng toán tử số học và chuỗi để làm việc với dữ liệu.
* Sử dụng các phần tử cấu trúc và cấu trúc điều khiển của ngôn ngữ, chẳng hặn như câu lệnh if-then và vòng lặp, để kích hoạt các thuật toán xử lý dữ liệu phức tạp.
* Tạo báo cáo được định dạng.

Nếu chúng ta chỉ nói về khả năng tạo báo cáo được định dạng dễ đọc và dễ phân tích, thì điều này hóa ra lại rất hữu ích khi làm việc với các tệp nhật ký có thể chứa hàng triệu bản ghi. Nhưng awk không chỉ là một công cụ báo cáo.

## Các tính năng của AWK
Cấu trúc:
```
awk options program file
```

AWK coi dữ liệu đến là một tập hợp các bản ghi. Bản ghi là tập hợp các trường. Nói đơn giản, nếu bạn không tính đến các khả năng tùy chỉnh awk và nói về văn bản hoàn toàn bình thường, các dòng được phân tách bằng các ký tự nguồn cấp dòng, thì một bản ghi là một dòng. Trường là một từ trong các dòng.

Chúng ta hãy xem key dòng lệnh awk được sử dụng phổ biến nhất:

* `-F fs`: Cho phép bạn chỉ định một ký tự phân cách cho các trường trong một bản ghi.
* `-f file`: Chỉ định tên của tệp để đọc tập lệnh awk
* `-v var=value -`: Cho phép bạn khai báo biến và đặt giá trị mặc định của nó mà awk sẽ sử dụng.
* `-mf N`: Đặt số lượng trường tối đa để xử lý trong tệp dữ liệu
* `-mr N -`: Đặt kích thước bản ghi tối đa trong tệp dữ liệu 
* `-W keyword`: Cho phép bạn thiết lập chế độ tương thích hoặc mức cảnh báo cho awk 

Sức mạnh của AWK nằm ở phần lệnh để gọi nó, được đánh dấu trên program. Nó trỏ đến một tệp kịch bản awk được viết bởi một lập trình viên để đọc dữ liệu và xử lý nó--> xuất ra kết quả.

## Các tập lệnh awk từ dòng lệnh
Các tập lệnh awk có thể được viết trực tiếp trên các dòng lệnh được định dạng dưới dạng văn bản lệnh và được đặt trong dấu ngoặc nhọn. Ngoài ra, vì awk giả định rằng tập lệnh là một chuỗi văn bản, bạn phải đặt nó trong dấu ngoặc kép:

`awk '{print "hello, hướng dẫn lệnh awk"}'`

Hãy chạy lệnh này, không gây ra hiệu ứng. Nếu bạn nhập vào một điều gì vào và `Enter` thì nó cũng sẽ chỉ in ra tệp lệnh đã chỉ định ban đầu.

`ctrl +d` để chấm dứt awk

## Các biến vị trí lưu trữ dữ liệu trường
Một trong những tính năng chính của awk là khả năng thao tác trong tệp văn bản. Nó thực hiện điều này bằng cách gắn một biến cho mỗi mục trong chuỗi. Theo mặc định, awk chỉ định các biến sau cho mỗi trường dữ liệu mà nó tìm thấy trong một bản ghi:
* `$0 -` Đại diện cho toàn bộ một dòng văn bản(bản ghi)
* `$1` Trường đầu tên
* `$2` Trường thứ 2
* `$3` Trường thứ 3

Các trường được phân tách nhau bằng dấu cách. Theo mặc định, đây là các ký tự khoảng trắng như dấu cách hoặc ký tự tab.

Hãy xem việc sử dụng các biến này với một ví dụ đơn giản
```
[root@onedata awk]# cat file1 
Một hai ba bốn
Mười
Ba mươi
[root@onedata awk]# awk '{print $1}' file1 
Một
Mười
Ba
[root@onedata awk]# awk '{print $1,$2}' file1 
Một hai
Mười 
Ba mươi
```
Biến $1 được sử dụng ở đây cho phép bạn truy cập và hiển thị ra trường đầy tiên của mỗi dòng trong tệp tin.

```
[root@onedata awk]# awk -F: '{print $1}' passwd 
root
bin
daemon
ftp
sshd
chrony
[root@onedata awk]# awk -F: '{print $6}' passwd 
/root
/bin
/sbin
/var/ftp
/var/empty/sshd
/var/lib/chrony

```

`awk -F:` in ra các trường trong tệp `passwd` mà mỗi trường được phân cách nhau bằng dấu `:`

## Sử dụng nhiều lệnh
Gọi awk bằng lệnh xử lý một từ là một cách tiếp cận hạn chế. awk cho phép bạn xử lý dữ liệu bằng cách sử dụng tệp lệnh nhiều dòng. Để chuyển lệnh bạn cần phân tách chúng bằng dấu `;`

```
[root@onedata awk]# echo "tôi tên adsf" | awk '{$3 ="huy"; print $0}'
tôi tên huy
```
Lệnh đầu tiên ghi giá trị mới vào một biến $3 và lệnh thứ 2 hiển thị toàn bộ dòng.
## Lệnh awk từ tệp

Awk cho phép bạn lưu trữ các tệp lệnh trong tệp và tham chiếu chúng tôi bằng một từ khóa `-f`.
```
[root@onedata awk]#echo "{print $1 " có thư mục chính là: " $6}">testawk
[root@onedata awk]# awk -F: '{print $1 " có thư mục chính là: " $6}'  passwd 
root có thư mục chính là: /root
bin có thư mục chính là: /bin
daemon có thư mục chính là: /sbin
ftp có thư mục chính là: /var/ftp
sshd có thư mục chính là: /var/empty/sshd
chrony có thư mục chính là: /var/lib/chrony
[root@onedata awk]# awk -F: -f testawk  passwd root là thư mục: /root
bin là thư mục: /bin
daemon là thư mục: /sbin
ftp là thư mục: /var/ftp
sshd là thư mục: /var/empty/sshd
chrony là thư mục: /var/lib/chrony
[root@onedata awk]# 
```

Ở đây tôi có tệp `passwd` tên người dùng ở trường $1 và thư mục chính ở trường $6, mỗi trường được phân cách nhau bằng dấu `:` Chỉ định 

script có thể chứa nhiều lệnh và mỗi lệnh có thể được viết trên một dòng mới, không cần đặt dấu chấm phẩy sau mỗi lệnh.
```
{
    text=" có thư mục chính là:"
    print $1 text $6
}
```
## Thực thi các lệnh trước khi xử lý dữ liệu
Đôi khi bạn cần thực hiện một số hành động trước khi tệp lệnh bắt đầu xử lý các bản ghi từ luồng đầu vào. Ví dụ tạo một tiêu đề báo cáo hoặc một cái gì đó tương tự.

Để làm được điều này, bạn có thể sử dụng một key BEGIN. Các lệnh tiếp theo BEGIN sẽ được thực hiện xử lý dữ liệu. Ở dạng đơn giản nhất:
```
awk 'BEGIN {print "Hello World"}'
```
```
[root@onedata awk]# awk 'BEGIN {print "Nội dung tệp: "}
{print $0}' file1 
Nội dung tệp: 
Một hai ba bốn
Mười
Ba mươi 
[root@onedata awk]# awk 'BEGIN {print "Nội dung tệp: "}
{print $0}' passwd 
Nội dung tệp: 
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
chrony:x:998:996::/var/lib/chrony:/sbin/nologin
```
Đầu tiên, awk thực thi khối BEGIN, sau đó xử lý dữ liệu. Hãy cẩn thận với các dấu nháy đơn khi sử dụng các cấu trúc dòng lệnh tương tự. Lưu ý rằng khối BEGIN và lệnh xử lý luồng đều nằm trong khung nhìn của `awk`. Thứ hai là sau dấu nhọn đóng của lệnh xử lý dữ liệu.

## Thực hiện các lệnh sau khi kết thúc quá trình xử lý dữ liệu
Từ khóa `END` cho phép bạn thiết lập các lệnh sẽ được thực thi sau khi quá trình xử lý dữ liệu kết thúc:
```
[root@onedata awk]# awk 'BEGIN {print "Nội dung tệp: "}
{print $0}
> END {print "Kết thúc"}' myfile 
Nội dung tệp: 
Đây là hàng thứ nhất
Đây là hàng thứ 2
Đây là hàng thứ 3
Đây là hàng thứ 4
Đây là hàng thứ 5

Kết thúc
```
Sau khi hoàn thành việc hiển thị nội dung của tệp, awk thực hiện các khối lệnh END. Đây là một tính năng hữu ích, bạn có thể tạo chân báo cáo.
```
awk '
BEGIN {
print "The latest list of users and shells"
print " UserName \t HomePath"
print "-------- \t -------"
FS=":"
}
{
print $1 "\t \t " $6
}
END {
print "-----The end----------"
}' passwd
```
Output:
```
The latest list of users and shells
 UserName        HomePath
--------         -------
root             /root
bin              /bin
daemon           /sbin
ftp              /var/ftp
sshd             /var/empty/sshd
chrony           /var/lib/chrony
-----The end----------
```

## Biến tích hợp: Tùy chỉnh xử lý dữ liệu
Tiện ích awk sử dụng các biến tích hợp cho phép bạn tùy chỉnh cách dữ liệu được xử lý và cấp quyền truy cập vào cả dữ liệu đang được xử lý và một số thông tin về nó.

Biến vị trí - $1 $2 $3 cho phép bạn lấy lại các giá trị trường. Một số cách được sử dụng phổ biến nhất:
* `FIELDWIDTHS —`: Danh sách các số được phân cách bằng dấu cách chỉ định độ rộng chính xác của từng trường dữ liệu, bao gồm cả các dấu cách phân trường.
* `FS`: Là một biến cho phép bạn đặt ký tự phân tách trường(Ví dụ trên.)
* `RS -`: Một biến cho phép bạn thiết lập ký tự phân tách bản ghi.
* `OFS -`: Phân tách trường trong đầu ra tập lệnh awk
* `ORS `: Dấu phân tách bản ghi trong đầu ra tập lệnh awk.

Theo mặc định, biến được `OFS` đặt để sử dụng khoảng trắng. Nó có thể được thiết lập khi cần thiết cho mục đích đầu ra:


```
chrony-/var/lib/chrony-/sbin/nologin
[root@onedata awk]# cat passwd 
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
chrony:x:998:996::/var/lib/chrony:/sbin/nologin
[root@onedata awk]# awk 'BEGIN{FS=":"; OFS="-"} {print $1,$6,$7}' passwd 
root-/root-/bin/bash
bin-/bin-/sbin/nologin
daemon-/sbin-/sbin/nologin
ftp-/var/ftp-/sbin/nologin
sshd-/var/empty/sshd-/sbin/nologin
chrony-/var/lib/chrony-/sbin/nologin
``` 
Lấy ra trường $1,$6,$7 và thay đổi dấu phân cách `:` và thay thế bằng `-`

Một biến `FIELDWIDTHS` Cho phép bạn đọc các bản ghi mà không cần sử dụng ký tự phân tách trường.

Trong một số trường hợp, thay vì sử dụng dấu phân tách trường, dữ liệu trong bản ghi được sắp xếp trong các cột có chiều rộng không đổi. Trong những trường hợp như vậy, bạn cần phải đặt biến FIELDWIDTHS theo cách sao cho nội dung của nó tương tự với đặc thù của việc trình bày dữ liệu.

Với một tập thế biến, FIELDWIDTHS awk sẽ bỏ qua biến FS và tìm các trường dữ liệu theo thông tin chiều rộng đã cho trong FIELDWIDTHS.

Giả sử:
```
[root@onedata awk]# cat num 
12 234 54 123 234 234
32545 54325 3335 123345
1.23 4.23 9.234 2.534 6.234 3.222
241,24 214,56 645,34 234,55 41,34
[root@onedata awk]# awk 'BEGIN{FIELDWIDTHS="3 5 2 5"}{print $1,$2,$3,$4}' num 
12  234 5 4  123 2
325 45 54 32 5 333
1.2 3 4.2 3  9.234
241 ,24 2 14 ,56 6

[root@onedata awk]# awk 'BEGIN{FIELDWIDTHS="1 2 2 5"}{print $1,$2,$3,$4}' num 
1 2  23 4 54 
3 25 45  5432
1 .2 3  4.23 
2 41 ,2 4 214
```
Giải thích về `FIELDWIDTHS`. Tôi có một file có dữ liệu là các số trong tệp tin. `FIELDWIDTHS="3 5 2 5"` Tại trường `$1` tôi chỉ lấy 3 ký tự đầu tiên. Tại trường `$2` tôi lấy 5 ký tự đầu tiên. Tại trường `$3` tôi chỉ lấy 2 ký tự đầu tiên và cứ như vậy, các thông số `FIELDWIDTHS` ứng với các trường tại `print`.

Các biến `RS` và `ORS` thiết lập thứ tự xử lý các bản ghi. Theo mặc định `RS` và `ORS` được đặt thành ký tự nguồn cấp dữ liệu. awk coi mỗi dòng là một bản ghi và in mỗi bản ghi trên một dòng mới.

Đôi khi xảy ra trường hợp trong một luồng dữ liệu nằm rải rác trên nhiều dòng. Ví dụ:
```
Đường Văn Huy
53 Nguyễn Ngọc Vũ
03987444444

Nguyễn Ngọc G
Trung Hòa Cầu Giấy
0987654332
```

Nếu bạn cố gắng đọc dữ liệu này với `FS` và `RS` được đặt thành mặc định của chúng, awk sẽ coi mỗi dòng mới là một mục nhập riêng biệt và các trường được đánh dấu dựa trên dấu cách. Đây không phải là những gì chúng ta cần trong trường hợp này.

Để giải quyết vấn để, `FS` bạn cần phải viết một ký tự nguồn cấp dữ liệu dòng vào. Để điều này cho awk biết rằng mỗi dòng dữ liệu là một trường riêng biệt.

Ngoài ra, trong ví dụ này, bạn cần phải viết một chuỗi `RS` rỗng vào biến. Lưu ý rằng trong tệp, các khối dữ liệu về những người khác nhau được phân cách bằng một dòng trống. Kết quả là awk sẽ coi các dòng trống là dấu phân cách các bản ghi. 
```
awk 'BEGIN{FS="\n"; RS=""} {print $1,$3}' info 
Đường Văn Huy 03987444444
Nguyễn Ngọc G 0987654332
```

Như bạn có thể thấy, nhờ các cài đặt biến này, awk coi các dòng từ tệp là trường và các dòng trống trở thành dấu phân cách các bản ghi.

## Biến tích hợp: Thông tin dữ liệu và môi trường
Ngoài các biến tích hợp mà chúng ta đã thảo luận, các những biến khác cung cấp thông tin về dữ liệu và môi trường mà awk chạy:

* `ARGC`: Số lượng đối số dòng lệnh.
* `ARGV`: Mảng các đối số dòng lệnh.
* `ARGIND`: Chỉ mục của tệp hiện đang được xử lý trong mảng `ARGV`
* `ENVIRON`: Mảng kết hợp với các biến môi trường và giá trị của chúng.
* `ERRNO`: Mã lỗi hệ thống có thể xảy ra khi đọc hoặc đóng tệp đầu vào.
* `FILENAME`: Tên của tệp dữ liệu đầu vào.
* `FNR`: Số lượng bản ghi hiện tại trong tệp dữ liệu.
* `IGNORECASE`: Nếu biến này được đặt thành giá trị khác 0, trường hợp sẽ bị bỏ qua trong quá trình xử lý.
* `NF`: Tổng số trường dữ liệu trong bản ghi hiện tại.
* `NR`: Tổng số bản ghi đã xử lý.

## Biến người dùng
awk cho phép lập trình viên khai báo các biến. Tên biến có thể bao gồm chữ cái, sô, dấu gạch dưới. Tuy nhiên, chúng không thể bắt đầu bằng số. Bạn có thể khai báo 1 biến, gán một giá trị cho nó và sử dụng nó trong mã của bạn như sauL
```
[root@onedata awk]# awk '
> BEGIN{
> test="Đây là test"
> print test
> }'
Đây là test
```
## Điều hành có điều kiện
awk hỗ trợ định dạng câu lệnh điều kiện là tiêu chuẩn trong nhiều ngôn ngữ lập trình `if-then-else`. 

ví dụ:
```
[root@onedata awk]# cat list 
12
23
1
7
123
10.1
....
[root@onedata awk]# awk '{if ($1 >7) print $1}' list 
12
23
123
10.1
```
In ra các số trong danh sách list và có điều kiên lớn hơn 7

ví dụ 2:
```
[root@onedata awk]# cat list 
12
23
1
7
123
10.1
....
[root@onedata awk]# awk '{if ($1 >12)
{
x= $1*3
print x
}
}' list
69
369
```

Điều kiện là các số phải lớn hơn 12 và lấy số đó nhân 3 và in ra kết quả cuối cùng.

ví dụ 3: else
```
[root@onedata awk]# awk '{if ($1 > 11) print $1; else print $1 + 0.01}' list 
12
23
1.01
7.01
123
10.11
0.01
```
nếu các số lớn hơn 11 thì in ra còn lại thì cộng thêm 0.01 rồi in ra

