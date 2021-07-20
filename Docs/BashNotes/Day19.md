Đọc tệp(Luồng dữ liệu, biến) từng dòng(và/hoặc từng trường)
|Thông số|Chi tiết|
|IFS|Dấu tách trường nội bộ|
|file|Tên tệp/ đường dẫn tệp|
|-r|Ngăn thông dịch gạch chéo ngược khi được sử dụng với read|
|-t|Loại bỏ một dòng mới ở cuối mỗi dòng được đọc với readarray|
|-d DELIM|Tiếp tục cho đến khi ký tự đầu tiên của DELIM được đọc (với read), thay vì dòng mới|

## 1.1 Lặp qua từng dòng với một tệp
```
while IFS=; read -r line1; do
 echo "$line1"
done <file1

```