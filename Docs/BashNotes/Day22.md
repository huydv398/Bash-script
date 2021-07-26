* Chain of commands and operations- Chuỗi lệnh và hoạt động
* Type of Shells
* Color script output (crossplatform)
* co-processes
* Typing variables
## 1. Chain of commands and operations- Chuỗi lệnh và hoạt động
Có một số phương tiện để xâu chuỗi các lệnh lại với nhau. Những cái đơn giản như ký tự `;` hoặc phức tạp hơn như chuỗi logic chạy tùy thuộc vào một số điều kiện. Lệnh thứ ba là lệnh đường ống pipe, chuyển giao dữ liệu đầu ra một cách hiệu quả cho lệnh tiếp theo trong chuỗi.
### 1.1 Đếm tỷ lệ xuất hiện của một mẫu văn bản
Sử dụng một pipe làm đầu ra của một lệnh trở thành đầu vào của lệnh tiếp theo.

```
ls -1 | grep -c ".conf"
```

Trong trường hợp này, đầu ra của lệnh ls được sử dụng làm đầu vào của lệnh grep. Kết quả sẽ là số lượng tệp có hậu tố **.config** trong tên của chúng.

Điều này có thể được sử dụng để cấu trúc chuỗi các lệnh tiếp theo miễn là cần thiết:
```
s -1 | grep ".conf" | grep -c .
```
### 1.2 Chuyển đầu ra root cmd sang tệp người dùng
Thường thì một người muốn hiện thị kết quả của một lệnh được thực thi bởi root cho những người khác. Lệnh tee cho phép dễ dàng ghi tệp với quyền của người dùng từ lệnh chạy dưới dạng root

Cmd tee: đọc thông tin nhập vào và viết ra kết quả vào files.
```
su -c <cmd> | tee ~/results-of-cmd.txt
```

Chỉ "<cmd>" được chạy dưới dạng root.
### 1.3 Chuỗi logic các lệnh: Với- &&, và- ||
&& xâu chuỗi 2 lệnh. Lệnh thứ 2 chỉ chạy nếu lệnh đầu tiên thoát thành công. 

|| xâu chuỗi hai lệnh nhưng lệnh thứ 2 chỉ chạy khi lệnh đầu tiên thất bại.

### 1.4 Chuỗi nối các lệnh bằng dấu chấm phẩy
Dấu chấm phẩy chỉ làm nhiệm vụ phân tách 2 câu lệnh.
```
$echo "This is line1" ; echo "This is line2" ; echo "This is line3"
This is line1
This is line2
This is line3
```
### 1.5 Chuỗi lệnh với |
Ký tự `|` trong shell- lấy đầu ra của lệnh bên trái và chuyển bó dưới dạng đầu vào của lệnh bên phải. Lưu ý rằng điều này được thực hiện trong subshell. Do đó, bạn không thể đặt giá trị của các biến của quá trình gọi trong một pipe.
## 2. Type of Shells
### 2.1  Start an interactive shell- bắt đầu một trình bao interactive
```
bash
```
### 2.2 Giới thiệu dot files.
Trong Unix, các tệp và thư mục bắt đầu bằng dấu chấm thường chứa các cài đặt cho một chương trình cụ thể/ một loạt của chương trình. Các tệp thường bị ẩn khỏi người dùng dùng, vì vậy bạn sẽ cần phải chạy lệnh `ls -a` để xem chúng. 

Ví dụ tệp dot: `.bash_history`, chứa các lệnh được thực thi mới nhất, giả sử người dùng đang sử dụng bash.
## 3. Color script output
### color-output.sh 
Trong phần mở đầu của tệp lệnh bash, có thể xác định một số biến có chức năng như trình trợ giúp tô màu hoặc định dạng đầu ra cuối trong quá trình chạy script.

Các nền tảng khác nahu sử dụng các chuỗi khác nhau để thể hiện màu sắc. Tuy nhiêu, có một tiện ích được gọi là tput hoạt động trên tất cả các hệ thống *nix và trả về chuỗi màu thiết bị đầu cuối dành riêng cho nền tảng thông minh qua một API đa nền tảng nhất quán.

Ví dụ: để lưu trữ chuỗi ký tự biến văn bản đầu cuối thành màu đỏ hoặc xanh lá cây:
```
red=$(tput setaf 1)
green=$(tput setaf 2)
```
Hoặc, để lưu trữ chuỗi ký tự đặt lại văn bản về giao diện mặc định:

```
reset=$(tput sgr0)
```

Sau đó, nếu bash script cần thiết để hiện thị các đầu ra có màu khác nhau, điều này có thể đạt được với:
```
echo "${green}{Success!${reset}" && echo "${red}Failure.${reset}"
```
## 4. co-processes
### 4.1 Hello World 

```
# Tạo co-process
coproc bash
# send a command to it (echo a)
echo 'echo Hello World' >&"${COPROC[1]}"
# read a line from its output
read line <&"${COPROC[0]}"
# show the line
echo "$line"

```
output:
```
Hello World
```
## 5. Typing variables- Nhập biến
### Khai báo các biến
`declare` là một lệnh của bash. (Sử dụng lệnh help để hiển thị "manpage"). Nó được sử dụng để hiển thị và xác định các biến hoặc hiển thị các nội dung của function.

```
declare [options] [name[=value]]...
```
```
# Tùy chọn được sử dụng để xác định
# declare -i- Biến được định nghĩa là số nguyên
declare -i myInteger
declare -i anotherInt=10
# Một mảng có giá trị
declare -a anArray=( one two three)
# an assoc Array
declare -A assocArray=( [element1]="something" [second]=anotherthing )
# Lưu ý bash nhận ra ngữ cảnh trong dấu []

# Tồn tại một số bổ ngữ
# -u- Khi biến được gán một giá trị, tất cả các ký tự viết thường sẽ được
# chuyển đổi thành chữ hoa. Thuộc tính chữ thường bị tắt.
declare -u big='this will be uppercase'
# -l: Khi biến được gán một giá trị, tất cả các ký tự viết hoa sẽ được chuyển đổi thành chữ thường. Thuộc tính viết hoa bị tắt.
declare -l small='THIS WILL BE LOWERCASE'
# readonly array- Chỉ đọc mảng
declare -ra constarray=( eternal true and unchangeable )
# Xuất số nguyên ra môi trường
declare -xi importantInt=42
```

Để hiển thị các biến và/hoặc hàm, cũng có một số tùy chọn
```
# in ra các biến và function được xác định
declare -f
# Giới hạn đầu ra chỉ cho các chức năng
declare -F
```
