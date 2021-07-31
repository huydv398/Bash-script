* Jobs at specific times
* Handling the system prompt
* Cut Command
* global and local variables

## 1. Jobs at specific times
### 1.1 Thực hiện công việc một lần tại một thời điểm cụ thể
Lưu ý: at không được cài đặt theo mặc định trên hầu hết các bản phân phối mới.

Để thực hiện công việc một lần vào một thời điểm nào đó mà không phải lúc này, Trong ví dụ là 5 giờ chiều, bạn có thể sử dụng:
```
echo "somecommand &" | at 5pm
```

Thêm nhiều định dạng thời gian hơn:
```
echo "somecommand &" | at now + 2 minutes
echo "somecommand &" | at 17:00
echo "somecommand &" | at 17:00 Jul 7
echo "somecommand &" | at 4pm 12.03.17
```
Nếu không có năm hoặc hoặc ngày tháng nào được đưa ra, nó sẽ giả sử thời gian bạn chỉ định xảy ra vào lần tiếp theo. Vì vậy, nếu bạn đưa ra một giờ một thời gian đã trôi qua của ngày hôm nay nó sẽ thực hiện vào ngày hôm sau.

Điều này cũng hoạt động cùng với `nohup` như bạn mong đợi:
```
echo "nohup somecommand > out.txt 2>err.txt &" | at 5pm
```
Có một số lệnh để kiểm soát các công việc được hẹn giờ:
* `atq` liệt kê tất cả các công việc được hẹn giờ(**atq**ueue)
* `atrm` loại bỏ công việc đã hẹn giờ(**atr**e**m**ove)
Tất cả các lệnh áp dụng cho các công việc của người dùng đã đăng nhập. Nếu đăng nhập bằng quyền root, tất nhiên là các công việc trên toàn hệ thống sẽ được xử lý.
### 1.2 Thực hiện các công việc vào những thời điểm cụ thể lặp đi lặp lại bằng cách sử dụng systemd.timer
`systemd` cung cấp một triển khai hiện tại của cron. Để thực thi một tệp lệnh bất kỳ, cần có một dịch vụ và một tệp bộ đếm thời gian. Các tệp dịch vụ và bộ hẹn giờ phải được đặt trong `/etc/systemd/{system,user}`.


```
[Unit]
Description=Kịch bản hoặc chương trình của tôi làm tốt nhất và đây là mô tả
[Service]
# type là quan trọng
Type=simple
# program|script để gọi. Luôn sử dụng các path/đường dẫn tuyệt đối và 
# chuyển hướng STDIN & STDERR vì không có thiết bị đầu cuối trong khi 
#thực thi
ExecStart=/absolute/path/to/someCommand >>/path/to/output 2>/path/to/STDERRoutput
#[Install]
#WantedBy=multi-user.target
```

Tiếp theo tệp hẹn giờ:

```
[Unit]
Description=my very first systemd timer
[Timer]
# Cú pháp cho thông số ngày/giờ Y-m-d H:M:S
# a * = từng(từng giờ, từng phút, mỗi giờ 1 lần, mỗi ngày 1/n lần), và các danh mục được phân tách bằng dấu phẩy cũng có thể được cung cấp
# *-*-* *,15,30,45:00 Cho biết hàng năm, hàng tháng, hàng ngày, hàng giờ 
#ở phút 15,30,45 và 0 giây

OnCalendar=*-*-* *:01:00
# Cái này chạy mỗi giờ ở 1 phút 0 giây e.g. 13:01:00
```
## 2 Xử lý lời nhắc hệ thống
|Ký tự thoát|Chi tiết|
|-|-|
|\a|Một ký tự bell|
|\d|Date-ngày, ở định dạng "Ngày trong tuần, ngày trong tháng" (ví dụ: "Thứ ba ngày 26 tháng 5")|
|\D|Định dạng được chuyển tới strftime(3) và kết quả được chèn vào chuỗi dấu nhắc; trống rỗng. FORMAT dẫn đến biểu diễn thời gian theo ngôn ngữ cụ thể|
|\e|Một ký tự thoát.|
|\h|hostname|
|\H||
|\j|Số lượng công việc hiện được quản lý bởi trình bao|
|\l|Tên cơ sở của tên thiết bị đầu cuối của shell|
|\n|Một dòng mới|
|\r|Một dấu xuống dòng|
|\s|Tên của shell,|
|\t|Thời gian, ở định dạng HH:MM:SS trong 24 giờ|
|\T|Thời gian, ở định dạng HH:MM:SS trong 12 giờ|
|@|Giờ, ở định dạng 12 giờ sáng / chiều.|
|\A|Giờ, ở định dạng HH: MM 24 giờ.|
|\u|username-Tên người dùng của người dùng hiện tại|
|\v|Phiên bản của Bash|
|\V|Việc phát hành Bash, phiên bản + patchlevel|
|\w|Thư mục làm việc hiện tại, với $ HOME được viết tắt bằng dấu ngã|
|\W|Tên cơ sở của $ PWD, với $ HOME được viết tắt bằng dấu ngã|
|!|Số lịch sử của lệnh này|
|#|Số lệnh của lệnh này|
|$|Nếu uid hiệu dụng là 0, #, nếu không thì $|
|\NNN|Ký tự có mã ASCII là giá trị bát phân NNN|
|\|Dấu gạch chéo ngược|
|\[|Bắt đầu một chuỗi các ký tự không in được. Điều này có thể được sử dụng để nhúng chuỗi điều khiển đầu cuối vào dấu nhắc.|
|\]|Kết thúc một chuỗi các ký tự không in được.|

### 2.1 Sử dụng biến môi trường  PROMPT_COMMAND
Khi lệnh cuối cùng trong một interactive bash instance được thực hiện, biến PS1 được đánh giá sẽ hiển thị. Trước khi thực hiện, biến PS1 được đánh giá sẽ hiển thị. Trước khi thực sự hiển thị, hãy xem liệu PROMPT_COMMAND có được đặt hay không. Giá trị của vả này phải là một chương trình hoặc tệp lệnh có thể gọi được. Nếu biến này được đặt, chương trình/script này được gọi trước khi lời nhắc PS1 được hiển thị.
```

```
### 2.2 Sử dụng PS1
PS1 là dấu nhắc hệ thống bình thường chỉ ra rằng bash đợi các lệnh được nhập vào. Nó hiểu một số trình tự thoát và có thể thực thi các chức năng proxy. Vì bash phải định vị con trỏ sau lời nhắc hiển thị, nó cần biết cách tính độ dài hiệu dụng của chuỗi dấu nhắc. Để chỉ ra chuỗi ký tự không in trong ngoặc nhọn thoát biến PS1 được sử dụng: `\[` chuỗi ký tự không in `\]`. Tất cả những gì đang nói đều đúng với tất cả các biến PS*

```
#mọi thứ không phải là một chuỗi thoát sẽ được in theo ký tự
export PS1="String " # lời nhăc bây giờ là:
String ▉

```
Output:
```
[root@hd ~]# export PS1="chuỗi chữ muốn đặt "
chuỗi chữ muốn đặt ls
anaconda-ks.cfg  file.sh  helloname.sh   results-of-ifconfig.txt
file1.sh         fol      install-wp.sh  text
chuỗi chữ muốn đặt pwd
/root
chuỗi chữ muốn đặt date
Thu Jul 22 16:34:50 EDT 2021
```

```
# \u == user \h == host \w == Thư mục làm việc thực tế
# lưu ý các dấu ngoặc kép tránh diễn giải bằng shell
export PS1='\u@\h:\w > ' # \u == user, \h == host, \w thư mục làm việc dir

#output:
[root@hd ~]# export PS1='\u@\h:\w > '
root@hd:~ > pwd
/root
root@hd:~/fol/dir > pwd
/root/fol/dir
```
## 3 The cut command

|Tham số|Chi tiết|
|-|-|
|-f, --fields |Lựa chọn dựa trên trường|
|-d, --delimiter|Delimiter để lựa chọn dựa trên trường|
|-c, --characters|Lựa chọn dựa trên ký tự, dấu phân cách bị bỏ qua hoặc lỗi|
|-s, --only-delimited|Chặn dòng không có ký tự phân tách (được in dưới dạng khác)|
|--complement|Đảo ngược lựa chọn (trích xuất tất cả ngoại trừ các trường / ký tự được chỉ định|
|--output-delimiter|Chỉ định khi nào nó phải khác với dấu phân cách đầu vào|

Lệnh `cut` là một cách nhanh chóng để trích xuất các phần của dòng tệp văn bản. Nó thuộc về các lệnh Unix lâu đời nhất. Các triển khai phổ biến nhất của nó là phiên bản GNU được tìm thấy trên Linux và phiên bản FreeBSD trên MacOS, nhưng mỗi phiên bản Unix đều có đặc điểm riêng. Xem bên dưới để biết sự khác biệt. Các dòng đầu được đọc từ stdin hoặc từ các tệp được liệt kê dưới dạng đối số trên dòng lệnh.
### 3.1 Chỉ một ký tự phân cách
Bạn không thể có nhiều hơn một ký tự phân tách: nếu bạn chỉ định một cái gì đó như `-d ":;,"`, một số triển khai sẽ chỉ sử dụng ký tự đầu tiên làm dấu phân tách (trong trường hợp này sẽ là dấu phẩy),
```
# cut -d ",;:" -f2 <<<"Nguyễn Vân A, Cầu Giấy, Hà Nội, SĐT:0987654321; job:IT"
cut: the delimiter must be a single character
Try 'cut --help' for more information.
```
### 3.2 Dấu phân cách lặp lại là một trường trống.
```
# cut -d, -f1,3 <<<"a,,b,c,d,e"
a,b
```
Khá rõ ràng, nhưng với các chuỗi được phân tách bằng dấu cach, nó có thể ít rõ rằng hơn:
```
# cut -d ' ' -f1,3 <<<"a  b c d e"
a b

```
cut không thủ được sử dụng để phân tích cú pháp các đối số như shell và và chương trình khác
### 3.3 Không trích dẫn
Không có cách nào để bảo vệ dấu phân cách. Bảng tính và phần mềm sử lý CSV tương tự thường có thể nhận ra một ký tự trích dẫn văn bản, điều này giúp bạn có thể xác định các chuỗi có chứa dấu phân cách. Với `cut` bạn không thể.
```
# cut -d, -f3 <<<'name,Smith,"1, Co Street"'
"1
```
### 3.4 Trích xuất, không thao tác
Bạn chỉ có thể trích xuất các phần của dòng, không thể sắp xếp lại hoặc lặp lại các trường.
```
[root@hd ~]# cut -d, -f2,1 <<<'Duong,Huy,VN'
Duong,Huy
[root@hd ~]# cut -d, -f2,2 <<<'Duong,Huy,VN'
Huy
```
### 3.5 Hiện thị cột đầu tiên của file
Giả sử bạn có tệp nội dung như sau:
```
Now call function 
First Name
Last Name
```

Tệp này có 3 cột được phân tách bằng dấu cách. Để chỉ lấy cột đầu tiên, hãy làm như sau.
```
cut -d ' ' -f1 filename
```

Flag -d, chỉ định dấu cách hoặc cái gì ngăn cách các bản ghi. flag -f chỉ định số trường hoặc số cột. Output
```
# cut -d ' ' -f1 filename 
Now
First
Last
```

### 3.6 Hiển thị các cột từ x đến y của một tệp
Đôi khi rất hữu ích khi hiển thị một loại các cột trong một tệp. Giả sử bạn có tệp này:
```
Hà Nội, Cầu Giấy, Trung Hòa, 2021, red
Hà Nội, Cầu Giấy, Dịch Vọng, 2000, red
Vĩnh Phúc, Phúc Yên, Phúc Thắng, 1993, green

```
Thực hiện lấy 3 cột đầu tiên ngăn cách nhau bằng dấu phẩy:
```
# cut -d ',' -f1-3 filename 
Hà Nội, Cầu Giấy, Trung Hòa
Hà Nội, Cầu Giấy, Dịch Vọng
Vĩnh Phúc, Phúc Yên, Phúc Thắng
```
## 4 global and local variables
Theo mặc định, mọi biến trong bash là global- biến toàn cục đối với mọi hàm, tập lệnh và thậm chí cả bên ngoài nếu bạn đang khai báo các biến của bạn bên trong một tệp lệnh.

Nếu bạn muốn biến của mình là biến cục bộ cho một hàm, bạn có thể sử dụng `local` để biến đó trở thành một biến mới độc lập với phạm vi toàn cục và giá trị của nó sẽ chỉ có thể truy cập được bên trong hàm đó.
## 4.1 Global variables
```
var="hello"
function foo(){
    echo $var
}
foo
```
Sẽ xuất ra `"hello"`, nhưng điều này cũng hoạt động theo cách khác:
```
function foo() {
    var="hello"
}
foo
echo $var
```
Cũng sẽ xuất ra `hello`

### 4.2 Local variables
```
function foo() {
    local var
    var="hello"
}
foo
echo $var
```
Sẽ không xuất ra gì, vì var là một biến local của hàm foo và giá trị của nó không được nhìn thấy từ bên ngoài.

### 4.3 Trộn cả hai với nhau.
```
var="hello"
function foo(){
    local var="sup?"
    echo "inside function, var=$var"
}
foo
echo "outside function, var=$var"
```