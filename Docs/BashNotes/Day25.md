* Networking With Bash
* Parallel
* Decoding URL
* Design Patterns
* Pitfalls
* Keyboard shortcuts


## 1 Networking With Bash
Bash thường được sử dụng phổ biến trong việc quả lý và bảo trì các server và clusters(cụm máy chủ). Thông tin liên quan đến các lệnh điển hình được sử dụng bởi các hoạt động mạng, khi nào thì sử dụng lệnh nào cho mục đích nào và các ví dụ/mẫu về các ứng dụng
### 1.1 Các lệnh kết nối mạng.
```
ifconfig
```
Lệnh trên sẽ hiển thị tất cả interface đang hoạt động của máy và thời cung cấp thông tin về:
* Chỉ định địa chỉ IP cho interface
* Địa chỉ MAC
* Địa chỉ Broadcast
* Số byte truyền và nhận

Một số ví dụ,

* Hiển thị tất cả các interface(cả interface bị vô hiệu hóa): `ifconfig -a`
* Hiển thị interface theo tên: `ifconfig eth0`
* Gán IP tĩnh cho interface: `ifconfig eth0 10.10.10.3 netmask 255.255.255.0`
* Kịch hoạt interface eth0: `ifup eth0`
* Vô hiệu hóa eth0: `ifdown eth0`
* Lệnh `ping`- (Packet Internet Grouper) là để kiểm tra kết nối giữa 2 node. Lệnh sau sẽ ping/kiểm tra kết nói với máy chủ google trong 2 giây `ping -c2 8.8.8.8`. 
* Lệnh được sử dụng để khác phục sự cố để tìm ra số bước nhảy đã thực hiện để đến đích: `traceroute`
* Lệnh `netstat` - Network Statistics cung cấp thông tin kết nối và trạng thái của chúng
* Lệnh dig-Domain Information grouper truy vấn thông tin liên quan đến DNS: dig `google.com`
* Lệnh truy vấn DNS và tìm ra địa chỉ IP của tên trang web tương ứng: `nslookup www.google.com`
* Lệnh route đươc sử dụng để kiểm tra thông tin tuyến đường network. Về cơ bản, nó hiển thị cho bạn bảng định tuyến. Lệnh sẽ thêm tuyến mặc định của mạng của eth0 thành 192.168.1.1 trong bảng định tuyến: `router add default gw 192.168.1.1 eth0`
* Lệnh sẽ xóa tuyến đường đi mặc định khỏi bảng định tuyến: `route del default`
## 2 Parallel
|Tùy chọn|Mô tả|
|-|-|
|-j n|Chạy n công việc song song|
|-k|Giữ nguyên thứ tự|
|-X|Nhiều đối số với thay thế ngữ cảnh|
|--colsep regexp|Đầu vào tách trên regexp để thay thế vị trí|
|{} {.} {/} {/.} {#}|Chuỗi thay thế|
|{3} {3.} {3/} {3/.}|Chuỗi thay thế vị trí|
|-S sshlogin|Ví dụ: user@google.com|
|--trc {}.bar |Viết tắt của --transfer --return {} .bar --cleanup|
|--onall|Chạy lệnh đã cho với đối số trên tất cả các sshlogins|
|--nonall|Chạy lệnh đã cho mà không có đối số trên tất cả sshlogins|
|--pipe|Chia stdin cho nhiều công việc|
|--recend str|Dấu phân tách cuối bản ghi cho --pipe|
|--recstart str|Ghi lại dấu phân cách bát đầu cho --pipe|
Các công việc tron gGNU Linux có thể được thực hiện song song bằng cách sử dụng song song GNU. Môt công việc có thể là một lệnh đơn hoặc một script phải được chạy cho mỗi dòng trong đầu vào. Đầu vào điển hình là danh sách tệp, danh sách máy chủ lưu trữ, danh sách người dùng, danh sách URL hoặc danh sách bảng. Một công việc cũng có thể là một lệnh đọc từ một pipe. 
## 2.1 Song song hóa các tác vụ lặp đi lặp lại trên danh sách tệp
Nhiều công việc lặp đi lặp lại có thể được thực hiện hiệu quả hơn nếu bạn sử dụng nhiều tài nguyên của máy tính hơn(Cpu, Ram). Dối đây là một số ví dụ về việc chạy song song nhiều công việc.

Giả sử bạn có một `<danh sách tệp>`, Giả sử đầu ra từ `ls`. Ngoài ra, hãy để các tệp này được ném bz2 và thứ tự của các nhiệm vụ cần được vận hành trên chúng.
1. Giải nén tệp bz2 bằng bzcat thành stdout
2. grep các dòng với các từ khóa cụ thể 
3. Đưa đầu ra được nối thành một tệp gzipped duy nhất bằng gzip

Chạy điều này bằng cách sử dụng vòng lặp while có thể trông giống như thế này:
```
filenames="file_list.txt"
while read -r line
do
name="$line"
    ## lấy dòng với những puppies trong đó
    bzcat $line | grep puppies | gzip >> output.gz
done < "$filenames"
```
## 3 Mẫu thiết kế
Hoàn thành một số mẫu thiết kế phổ biến trong bash 
## 3.1 Mẫu Xuất bản/Đăng ký(pub/sub)
Khi một dự án bash chuyển thành thư viện, việc thêm chức năng mới có thể trở nên khó khăn. Tên hàm , biến và các tham số thường cần được thay đổi trong script sử dụng chúng. Trong các tình huống như thế này, Sẽ hữu ích khi tách mã và sử dụng mẫy thiết kế theo hướng sự kiện. Trong mẫu đã nói, một script bên ngoài có thể đăng ký một biến cố. Khi sự kiện đó được kích hoạt (xuất bản). script có thể thực thi mã mà nó đã đăng ký với sự kiện.

pubsub.sh:
```
#!/usr/bin/env bash
#
# Lưu đường dẫn đến thư mục của tập lệnh này trong biến env global
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#
# Mảng sẽ chứa tất cả các sự kiện đã đăng ký
#
EVENTS=()
function action1() {
echo "Action #1 was performed ${2}"
}
function action2() {
echo "Action #2 was performed"
}
#
# @desc :: Đăng ký event
# @param :: string $1 - Tên của event. Về cơ bản là một bí danh cho tên một hàm
# @param :: string $2 - Tên của hàm sẽ được gọi
# @param :: string $3 - Đường dẫn đầy đủ đến tập lệnh bao gồm hàm được gọi
#
function subscribe() {
EVENTS+=("${1};${2};${3}")
}
#
# @desc :: Public an event
# @param :: string $1 - Tên sự kiện đang được xuất bản
#
function publish() {
for event in ${EVENTS[@]}; do
local IFS=";"
read -r -a event <<< "$event"
if [[ "${event[0]}" == "${1}" ]]; then
${event[1]} "$@"
fi
done
}
#
# Đăng ký các sự kiện của chúng tôi và các chức năng xử lý chúng
#
subscribe "/do/work" "action1" "${DIR}"
subscribe "/do/more/work" "action2" "${DIR}"
subscribe "/do/even/more/work" "action1" "${DIR}"
#
# Thực hiện các sự kiện
#
publish "/do/work"
publish "/do/more/work"
publish "/do/even/more/work" "again"
```

## 4 Các lỗi có thể mắc phải.
### 4.1 Khoảng trắng khi đặt biến
Khoảng trắng quan trọng khi gán các biến:
```
var = '123' # Không chính xác
var= '123' # Không chính xác
var='123' # Chính xác
```
Hai lỗi đầu tiên sẽ dẫn đến lỗi cú pháp: syntax erors(hoặc tệ hơn là thực hiện một lệnh không chính xác).
### 4.2 Các lệnh không thành công không ngừng thực thi script
Trong hầu hết các ngôn ngữ viết script, nếu một lệnh gọi hàm không thành công, nó có thể đưa ra một ngoại lệ và ngừng thực thi chương trình.

Các lệnh bash không có ngoại lệ, nhưng chúng có mã thoát gọi là exit code. Tuy nhiên, một mã thoát khác 0 báo lỗi, một mã khác 0 sẽ không ngừng thực hiên chương trình. Điều này có thể dẫn đến các tình huống nguy hiểm, có script sau:
```
#!/bin/bash
cd ~/non/existent/directory #thư mục này không tồn tại
rm -rf *
```

Nếu lệnh cd không thực hiện được, bash sẽ bỏ qua lỗi và chuyển sang lệnh tiếp theo, xóa sạch thư mục từ nơi mà bạn đang thực hiện lệnh.

Cách tốt nhất để giải quyết vấn đề này là sử dụng lệnh `set`:
```
#!/bin/bash
set -e
cd ~/non/existent/directory
rm -rf *
```
`set -e` yêu cầu bash thoát khỏi tập lệnh ngay lập tức nếu bất kỳ lệnh nào trả về trạng thái khác 0.