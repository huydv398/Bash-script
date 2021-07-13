Thay thế quy trình
## 1.1 So sánh hai tệp từ web
So sánh hai tệp có sự khác biệt bằng cách sử dụng thay thế quy trình thay vì tạo tệp tạm thời.
```
diff <(curl http://www.example.com/page1) <(curl http://www.example.com/page2)
```
## 1.2 Nối các tệp
Bạn không thể sử dụng cùng một tệp cho đầu vào và đầu ra trong cùng một lệnh. Ví dụ,
```
[root@hd dir]# cat header.txt body.txt >body.txtcat: body.txt: input file is output file
```
Không làm những gì bạn muốn. `cat` đọc hearder.txt, nó bị cắt ngắn bởi chuyển hướng và nó trống. Kết quả cuối cùng sẽ là body.txt sẽ chỉ chứa nội dung của hearder.txt

Người ta có thể nghĩ rằng để tránh điều này bằng cách thay thế quy trình, tưc là lệnh 
```
cat header.txt <(cat body.txt) > body.txt
```
Sẽ buộc nội dung gốc của body.txt bằng cách nào đó được lưu vào bộ nhớ đệm nào đó ở đâu đó trước khi tệp được bị cắt bớt bởi chuyển hướng. Nó không hoạt động. `cat` trong ngoặc đơn chỉ bắt đầu đọc tệp sau khi tất cả các ký tự đệ trình đã được thiết lập, giống như tệp bên ngoài. Không có ích gì khi cố gắng sử dụng thay thế quy trình trong trường hợp này.

Cách duy nhất để thêm một tệp vào một tệp khác là tạo một tệp trung gian:
```
[root@hd dir]# cat header.txt body.txt >body.txt.new
[root@hd dir]# ls
body.txt  body.txt.new  header.txt
[root@hd dir]# mv body.txt.new body.txt
mv: overwrite ‘body.txt’? y
```
Khi đó là những gì `sed` hoặc `perl` hoặc các chương trình tương tự thực hiện bên dưới khi được gọi với tùy chọn chỉnh sửa tại chỗ
## 1.3 Truyền một tệp qua nhiều chương trình cùng một lúc
Điều này đếm số dòng trong cùng một bằng `wc -l` trong khi nén đồng đồng thời bằng `gzip`. Cả hai đều chạy đồng thời.
```
[root@hd ]# tee >(wc -l >&2) < file.txt | gzip > file.txt.gz
5
[root@hd dir]# ls
file.txt  file.txt.gz 
```
Thông thường `tee` ghi đầu vào của nó vào một hoặc nhiều tệp (và stdout). Chúng ta có thể ghi vào các lệnh thay vì các tệp có `tee > (command)`.

Ở đây, lệnh `wc -l >&2` đếm các dòng được đọc từ tee(lần lượt được đọc từ file). (Số dòng được gửi đến stderr(>&2) để tránh trộn lẫn với đầu vào cho `gzip`). Stdout của tee được đồng thời đưa vào `gzip`. 
## 1.4 Paste command
Thay thế quy trình bằng lệnh paste là phổ biến. Để so sánh nội dung của hai thư mục.
```
[root@hd ~]# paste <(ls dir) <(ls dir1)
$       $
 a       a
body.txt        body.txt
file.txt.gz     file.txt
header.txt      file.txt.gz
nnn*    header.txt
        nnn*
```
## 1.5 Để tránh sử dụng sub-shell
Một khía canh chính của thay thế quy trình là có cho phép chúng ta trính sủ dụng sub-shell khi đặt các lệnh từ trình bao.

Điều này có thể được chứng minh bằng một ví dụ đơn giản dưới đây. Tôi có các tệp sau trong thư mục của mình:
```
[root@hd dir]# find . -maxdepth 1 -type f -print
./file1.txt
./file.txt
./check.conf
```
Nếu tôi chuyển một vòng lặp read/write làm tăng bộ đếm như sau:
```

```