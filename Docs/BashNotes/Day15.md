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