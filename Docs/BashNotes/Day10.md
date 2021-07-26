Here documents, here strings and quoting
# Phần 1 Here documents and here strings
## 1.1 Thực thi lệnh với Here documents
```
ssh -p 22 root@192.168.10.6 <<EOF
 echo 'printing pwd'
 echo "\$(pwd)"
 ls
 find '*.txt'
EOF
```

Cách khác:
```
ssh -p 22 root@192.168.10.6 <<'EOF'
 echo 'printing pwd'
 echo "\$(pwd)"
 ls
 find '*.txt'
EOF
```
output:
```
root@192.168.10.6's password: 
Last failed login: Wed Jun 30 23:45:11 EDT 2021 from 192.168.10.5 on ssh:notty
There was 1 failed login attempt since the last successful login.
printing pwd
/root
anaconda-ks.cfg
file1.sh
file.sh
helloname.sh
install-wp.sh
text
find: ‘*.txt’: No such file or directory
```
Lệnh được thực thi trên shell từ xa. Và hiện thị tại output shell hiện tại

Lưu ý: `EOF` đóng ở đầu dòng(không có khoảng trắng trước). Nếu cần thụt lè, các tab có thể được sử dụng nếu bạn bắt đầu heredocs của mình bằng `<<-`
## 1.2 Thụt lề
Bạn có thể thụt lề văn bản bên trong tài liệu ở đây và các tab, cần sử dụng toán tử redirection `<<-` thay vì `<<:`
```
cat <<- EOF
Nội dung văn bản line1
    Nội dung văn bản line2
        Nội dung văn bản line3
EOF
```
Output:
```
[root@hd ~]# ./text.sh 
Nội dung văn bản line1
    Nội dung văn bản line2
        Nội dung văn bản line3
```
## 1.3 Tạo file
Cách sử dụng của các tài liệu ở đây là tạo tệp bằng cách nhập nội dung của nó:
```
cat > fruits.txt << EOF
apple
orange
lemon
EOF
#Output
[root@hd ~]# cat fruits.txt 
apple
orange
lemon
```
Here-document là các dòng giữa `<< EOF` và `EOF`

Here-document ở đây trở thành đầu vào và sử dụng chuyển hướng đầu ra `>` đến tệp `fruit.txt`. Nếu `fruit.txt` không tồn tại, nó sẽ được tạo. Nếu nó tồn tại, nó sẽ bị loại bỏ và thêm here-document. Còn nếu nối tiếp vào file hiện có sử dụng chuyển hướng đầu vào `>>`.

## 1.4 Here string
Bạn có thể cung cấp lệnh bằng các sử dụng **here strings** như thế này:
```
[root@hd ~]#  awk '{print $2}' <<< "hello world - how are you?"
world
[root@hd ~]#  awk '{print $3}' <<< "One two three four"
three

[root@hd ~]# awk '{print $1}' <<< "hello how are you
> One two three four"
hello
One
[root@hd ~]# awk '{print $4}' <<< "hello how are you
One two three four"
you
four
```
Lệnh trên dùng để in ra các chuỗi ở vị trí trị định nhất định.
## 1.5 Limit strings
Heredoc sử dụng một chuỗi giới hạn để xác định thời điểm ngừng sử dụng đầu vào. Chuỗi giới hạn kết thúc phải có điều kiện sau:
* Ở đầu dòng
* Là văn bản duy nhất trên dòng. Lưu ý: nếu bạn sử dụng `<<- Limitstring` có thể được bắt đầu bằng tabs \t

```
cat <<limitstring
line 1
line 2
limitstring
```

Output:
```
[root@hd ~]# ./test.sh
line 1
line 2
```

Đây là một cách sử dụng sai:
```
cat <<limitstring
line 1
line 2
 limitstring
```
`limitstring` không đứng ở đầu dòng, nên shell sẽ tiếp tục đợi nhập thêm, đợi cho đến khi limitstring xuất hiện ở đầu dòng thì lệnh `cat` mới thực hiện
# Phần 2 Quoting
## 2.1  Dấu ngoặc kép cho biến và lệnh thay thế
Các phép thay thế biến chỉ nên được sử dụng bên trong dấu ngoặc kép.
```
[root@hd ~]# calculation='2 * 3'

[root@hd ~]# echo "$calculation" 
2 * 3

[root@hd ~]# echo $calculation # In ra số 2 - In ra tất cả thư mục hiện tại - in số 3
2 file fruits.txt helloname.sh text  3

[root@hd ~]# echo "$(($calculation))"
6
```

Bên ngoài dấu ngoặc kép, **$var** nhận giá trị của var, chia nó thành các phần được phân tách bằng khoảng trắng và diễn giải mỗi phần dưới dạng một ký tự đại diện. Trừ khi bạn muốn hành vi này, hãy luôn đặt **$var** bên trong dấu ngoặc kép: `"$var"`.

Điều tương tự cũng áp dụng cho các thay thế lệnh: `"$(mycommand)"` là đầu ra của `mycommand`.
```
[root@hd ~]# echo "$(pwd)"
/root
[root@hd ~]# echo "$(whoami)"
root
```

Câu lệnh thay thế có ngữ cảnh trích dẫn của riêng chúng. Viết các thay thế lồng vào nhau tùy ý rất dễ dàng vì trình phân tích cú pháp sẽ theo dõi độ rộng lồng nhau.
```
[root@hd ~]# c=8
[root@hd ~]# echo "formatted text: $(printf "a + b = %04d" "${c}")"
formatted text: a + b = 0008
```

## 2.2 Sự khác biệt giữa dấu ngoặc kép và dấu ngoặc đơn.
|Dấu ngoặc kép- `""`|Dấu ngoặc đơn- `''`|
|-|-|
|Cho phép mở rộng biến|Ngăn chặn mở rộng biến|
|Cho phép mở rộng lịch sử nếu được bật|Ngăn mở rộng lịch sử|
|Cho phép thay thế lệnh|Ngăn chặn thay thế lệnh|
|`*` và `@`có thể có nghĩa đặc biệt|`*` và `@` luôn là chính nó|
|Có thể chứa ngoặc đơn hoặc ngoặc kép|Không cho phép ngoặc đơn bên trong ngoặc đơn|
|`$`,`,",\ có thể thoát bằng `\` để ngăn ý nghĩa đặc biệt của chúng|Tất cả đều là chữ|

Thuộc tính chung cho cả hai:    
* Ngăn chăn hiện tượng globbing
* Ngăn tách từ

```
[root@hd ~]# echo "!cat"
echo "cat text "
cat text 

[root@hd ~]# echo '!cat'
!cat

[root@hd ~]# a='var'
[root@hd ~]# echo $a
var
[root@hd ~]# echo '$a'
$a
[root@hd ~]# echo "$a"
var
```
## 2.3 Dòng mới và ký tự điều khiển
Một dòng mới có thể được bao gồm trong một chuỗi được chích dẫn đơn hoặc chuỗi được trích dẫn kép. Lưu ý rằng dấu gạch chéo ngược
```
newline1='
'
newline2="
"
newline3=$'\n'
empty=\

```
Output:
```
[root@hd ~]# ./test.sh 
Line
break
Line
break
Line
break
No line break here
```

Bên trong chuỗi ký tự đô la, có thể sử dụng ký tự gạch chéo ngược hoặc hoặc dấu gạch chéo ngược bát phân để chèn các ký tự điều khiển giống như nhiều ngôn ngữ lập trình khác
```
[root@hd ~]# echo $'Tab: [\t]'
Tab: [  ]

[root@hd ~]# echo $'Tab again: [\009]'
Tab again: [

[root@hd ~]# echo $'Form feed: [\f]'
Form feed: [
            ]

[root@hd ~]# echo $'Line\nbreak'
Line
break
```
## 2.4 Trích dẫn văn bản theo đúng nghĩa gốc.
Tất cả các ký tự đặc biệt được hiển thị dưới dòng sau:
```
!"#$&'()*;<=>? @[\]^`{|}~
```

Dấu gạch chéo ngược trích dẫn ký tự tiếp theo, tức là ký tự tiếp theo được hiểu theo nghĩa đen.
```
[root@hd ~]# echo \!\"\#\$\&\'\(\)\*\;\<\=\>\?\ \ \@\[\\\]\^\`\{\|\}\~
!"#$&'()*;<=>?  @[\]^`{|}~
```

Tất cả các văn bản giữa các dấu ngoặc đơn được in theo nghĩa gốc. Dấu gạch chéo ngược chẵn là viết tắt của chính nó, và khổng thể bao gồm một chích dẫn duy nhất; thay vào đó, bạn có thể dừng chuỗi ký tự, bao gồm một ngoặc đơn theo nghĩa đen với dấu gạch chéo ngược và bắt đầu lại chuỗi ký tự.
```
[root@hd ~]# echo '!"#$&'\''()*;<=>? @[\]^`{|}~'
!"#$&'()*;<=>? @[\]^`{|}~
```
So sánh lại chuỗi ký tự sau khi in ra, 4 ký tự `'\''` cho phép cắt tách chuôi ký tự đặc biệt.
```
'!"#$&'	\''	()*;<=>? @[\]^`{|}~'
 !"#$&'		()*;<=>? @[\]^`{|}~
```
Thanks and best regards