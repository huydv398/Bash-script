Tùy chỉnh PS1
## 1.1 Tô màu và tùy chỉnh lời nhắc đầu cuối
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

## 1.2 Hiển thị tên git branch trong dấu nhắc đầu cuối.
Bạn có thể có các hàm trong biến PS1, chỉ cần đảm bảo chích dẫn duy nhất nó hoặc sử dụng thoát cho các ký tự đặc biệt: