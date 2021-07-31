Tùy chỉnh PS1
## 1 Tô màu và tùy chỉnh terminal prompt
Đây là cách tác giả đặt biến PS1 cá nhân của họ:
```
gitPS1(){
 gitps1=$(git branch 2>/dev/null | grep '*')
 gitps1="${gitps1:+ (${gitps1/#\* /})}"
 echo "$gitps1"
}
#Please use the below function if you are a mac user
gitPS1ForMac(){
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
timeNow(){
 echo "$(date +%r)"
}
if [ "$color_prompt" = yes ]; then
 if [ x$EUID = x0 ]; then
 PS1='\[\033[1;38m\][$(timeNow)]\[\033[00m\]
\[\033[1;31m\]\u\[\033[00m\]\[\033[1;37m\]@\[\033[00m\]\[\033[1;33m\]\h\[\033[00m\]
\[\033[1;34m\]\w\[\033[00m\]\[\033[1;36m\]$(gitPS1)\[\033[00m\] \[\033[1;31m\]:/#\[\033[00m\] '
 else
 PS1='\[\033[1;38m\][$(timeNow)]\[\033[00m\]
\[\033[1;32m\]\u\[\033[00m\]\[\033[1;37m\]@\[\033[00m\]\[\033[1;33m\]\h\[\033[00m\]
\[\033[1;34m\]\w\[\033[00m\]\[\033[1;36m\]$(gitPS1)\[\033[00m\] \[\033[1;32m\]:/$\[\033[00m\] '
 fi
else
 PS1='[$(timeNow)] \u@\h \w$(gitPS1) :/$ '
fi
```

Chú ý:
* Thực hiện các thay đổi trong tệp `~/.bashrc` hoặc `/etc/bashrc` hoặc `~/.bash_profile` hoặc `~./profile` (tùy thuộc vào OS) và lưu lại.
* Đối với `root`, bạn cũng có thể cần chỉnh sửa tệp `/etc/bash.bashrc` hoặc `/root/.bashrc` 
* Chạy `source ~/.bashrc` (bản phân phối cụ thể) sau khi lưu tệp.
* Lưu ý: nếu bạn đã lưu các thay đổi trong `~/.bashrc`, thì hãy thêm `soucre ~/.bashrc` để thay đổi trong PS1 sẽ được ghi lại mỗi khi ứng dụng terminal khởi động.

## 2 Hiển thị tên git branch trong  terminal prompt.
Bạn có thể có các hàm trong biến PS1, chỉ cần đảm bảo chích dẫn duy nhất nó hoặc sử dụng thoát cho các ký tự đặc biệt:
```
gitPS1(){
 gitps1=$(git branch 2>/dev/null | grep '*')
 gitps1="${gitps1:+ (${gitps1/#\* /})}"
 echo "$gitps1"
}
PS1='\u@\h:\w$(gitPS1)$ '
```
Bash sẽ cung cấp cho bạn  một lời nhắc như sau:
```
root@hd:~/fol$
- - - -
User@host:/path (master)$
```

**Chú ý:**
* Thực hiện thay đổi trong tệp **~/.bashrc** hoặc **/etc/bashrc** hoặc **~/.bash_profile** hoặc **~./profile** và lưu nó
* Chạy `source ~/.bashrc` sau khi lưu tệp
## 3 Hiện thì thời gian trong  terminal prompt
```
timeNow(){
 echo "$(date +%r)"
}
PS1='[$(timeNow)] \u@\h:\w$ '
```
Nó sẽ cung cấp cho bạn một terminal prompt:
```
[08:29:34 AM] root@hd:~/fol$ 
```
**Chú ý:**
* Thực hiện thay đổi trong tệp **~/.bashrc** hoặc **/etc/bashrc** hoặc **~/.bash_profile** hoặc **~./profile** và lưu nó
* Chạy `source ~/.bashrc` sau khi lưu tệp
## 4 Hiển thị một nhánh git bằng PROMPT_COMMAND
Nếu bạn đang ở trong một thư mục của kho lưu trữ git, có thể rất tuyệt khi hiển thị nhánh hiện tại mà bạn đang sử dụng. Trong **~/.bashrc** hoặc **/etc/bashrc** thêm phần sau(cần có git để thực hiện hoạt động này):
```
function prompt_command {
    # Kiểm tra xem chúng ta có đang ở trong kho lưu trữ git không
    if git status > /dev/null 2>&1; then
        # Chỉ lấy tên branch
        export GIT_STATUS=$(git status | grep 'On branch' | cut -b 10-)
    else
        export GIT_STATUS=""
    fi
}
# Hàm này được gọi mỗi khi PS1 được hiển thị
PROMPT_COMMAND=prompt_command
PS1="\$GIT_STATUS \u@\h:\w\$ "
```
Nếu chúng ra đang ở trong một thư mục bên trong kho lưu trữ git, điều này sẽ xuất ra:
>branch user@machine:~$


Nếu chúng ra đang ở trong một thư mục bình thường:
>user@machine:~$
## 5 Thay đổi PS1 prompt
Để thay đổi PS1, bạn chỉ cần thay đổi giá trị của biến shell PS1. Giá trị có thể được đặt trong tệp ~/.bashrc hoặc /etc/bashrc, tùy thuộc vào từng bản distro. PS1 có thể được thay đổi thành bất kỳ văn bản thuần túy nào.

```
PS1="hello "
```
Bên cạnh văn bản thuần túy, một số ký tự đặc biệt thoát ra sau dấu gạch chéo ngược được hỗ trợ:

|Định dạng|Hành động|
|-|-|
|\a|Ký tự chuông ASCII|
|\d|Ngày ở định dạng "Thứ ngày tháng"(thứ 6 ngày 31 tháng 2)|
|\D{format}|Định dạng được chuyển tới strftime(3) và kết quả được chèn vào chuỗi dấu nhắc ';' định dạng trống dẫn đến biểu diễn thời gian theo ngôn ngữ cụ thể|
|\e|một ký tự thoát|
|\h|hostname tối đa là dấu '.' đầu tiên|
|\H|hostname|
|\j|Số lượng jobs được quản lý bởi shell|
|\l|tên cơ sở của thiết bị đầu cuối shell\|
|\n|dòng mới|
|\r|xuống dòng|
|\s|shell|
|\t|time HH:MM:SS 24 giờ|
|\T|time HH:MM:SS 12 giờ|
|\@|12 giờ am/pm|
|\A|HH:MM 24 giờ|
|\u|user hiện tại|
|\v|version bash|
|\V|phát hành cấp đọ bahs, viersion + bản vá |
|\w|Thư mục làm việc hiện tại|
|\W|Tên cơ sở của thư mục làm việc hiện tại với $HOME được viết thành ~|
|\!|Số lịch sử lệnh|
|\#|Số lệnh của lệnh|
|\$|nếu UID hiệu dụng là 0, a #, nếu không thì là $|

Vì vậy, ví dụ, chúng ta có thể đặt PS1 thành:
```
PS1="\u@\h:\w\$ "
```
## 6 Hiển thị trạng thái và thời gian trả lại lệnh trước đó
Đôi khi chúng ta cần một gợi ý trực quan để chỉ ra trạng thái trả về của lệnh trước đó.
```
# -ANSI-COLOR-CODES- #
Color_Off="\033[0m"
###-Regular-###
Red="\033[0;31m"
Green="\033[0;32m"
Yellow="\033[0;33m"
####-Bold-####
function __stat() {
    if [ $? -eq 0 ]; then
        echo -en "$Green ✔ $Color_Off "
    else
        echo -en "$Red ✘ $Color_Off "
    fi
}
PS1='$(__stat)'
PS1+="[\t] "
PS1+="\e[0;33m\u@\h\e[0m:\e[1;34m\w\e[0m \n$ "
export PS1
```

![image](image/Screenshot_3.png)

Thanks and best regards
