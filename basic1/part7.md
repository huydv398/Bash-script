# Xử lý văn bản với sed

Chủ đề là một công vụ rất hữu ích để xử lý chuỗi - một tiện ích có tên là `sed`. Nó thường được sử dụng để làm việc với văn bản dưới dạng log, config, và các tệp khác.

`sed` là một bước quan trọng trong quá trình phát triển tệp lệnh bash 
## Kiến thức cơ bản về sed
Tiện ích `sed` được gọi là trình soạn thảo văn bản. Trong các trình soạn thảo văn bản như nano, vi, vim, văn bản được thao tắc bằng bàn phím, chỉnh sửa, thêm, xóa, hoặc thay đổi nội dung văn bản. `sed` cho phép bạn chỉnh sửa các luồng dữ liệu dựa trên các bộ quy tắc do các nhà phát triển xác định.

Cấu trúc:

`sed [option] [file]`

Mặc định sed áp dụng các quy tắc đặt lệnh được chỉ định cho `STDIN`. Điều này cho phép dữ liệu được truyền trực tiếp đến `sed`.

~$ echo "This is a test" | sed 's/test/another test/'
This is a another test

Trong trường hợp này, sed thay thế từ test ->another. Đối với định dạng quy tắc xử lý văn bản được đặt trong dấu ngoặc kép, dấu gạch chéo được sử dụng. Lệnh của biểu mẫu được áp dụng s/text/edited/. Chữ s - replace tức là thay thế. Thực hiện lệnh này sẽ quét văn bản sẽ tìm trong văn bản các từ có chứa text và sẽ được thay bằng edited

```
[root@1data huydv]# cat myfile 
Đây là 123test
 
[root@1data huydv]# sed 's/123test/checknow123/' myfile 
Đây là checknow123

[root@1data huydv]# cat myfile 
Đây là 123test
```
Bạn có thể thấy là sử dụng lệnh sed như câu lệnh trên là đang thay thế để hiển thị chứ không có sửa đổi nội dung bên trong văn bản.

## Thực thi lệnh khi gọi sed
Để thực hiện nhiều hành động trên dữ liệu, hãy sử dụng option key `-e` khi gọi `sed`

```
[root@1data huydv]# cat myfile 
Đây là 123test
[root@1data huydv]# sed -e 's/Đây là/Kia là ký tự/; s/123test/999 check/' myfile
Kia là ký tự 999 check
[root@1data huydv]# 
```

Cả hai lệnh đều được áp dụng cho từng dòng văn bản trong tệp. Phân tách chúng bằng dấu chấm phẩy

Kiểu khác có thể riêng biệt trên các dòng, dấu ngoặc kép đầu tiên thì nhấn Enter:
```
[root@1data huydv]# sed -e "
s/Đây là/Kia là ký tự/
> s/123test/999 check/" ./myfile
Kia là ký tự 999 check
```
## Đọc lệnh từ một tệp
Nếu có nhiều lệnh sed để xử lý văn bản, tốt nhất là ghi vào một tệp trước. Để chỉ định một tệp sed hãy sử dụng option key `-f`

```
[root@1data huydv]# cat myfile 
Đây là 123test
[root@1data huydv]# echo " 
> s/Đây là/Kia là/
> s/123test/ 123 quá ok/" >cmd
[root@1data huydv]# sed -f cmd myfile 
Kia là  123 quá ok
```
## Thay thế flag
```
[root@1data huydv]# cat huydv 
Huy tên đủ là Đường Huy
[root@1data huydv]# sed "s/Huy/huydv/; s/18/22/" huydv 
huydv tên đủ là Đường Huy.
22 là số trong ngày sinh 18-22-98
```

Lệnh replace thường xử lý một tệp bao gồm một số dòng, nhưng chỉ những lần xuất hiện đầu tiên của đoạn văn bản mong muốn mỗi dòng thì mới được thay thế

Cấu trúc mới như sau:

`s/pattern/replacement/flags`

Việc thực hiện lệnh này có thể được sửa đổi theo một số cách.
* Khi truyền số, số thứ tự của sự xuất hiện của mẫu trong chuỗi được tính đến; sự xuất hiện cụ thể này sẽ được thay thế.
* flag `g`; chỉ ra để xử lý tất cả các lần xuất hiện của mẫu trong chuỗi.
* Cờ `p`: cho biết hiển thị nội dung của chuỗi gốc, chỉ in ra các dòng phù hợp
* Cờ `w file` ghi kết quả xử lý vào bản vào tệp *file*


flag `p` cho phép bạn in các dòng phù hợp, trong khi tùy chọn `-n` được chỉ định khi gọi sed ngăn chặn đầu ra bình thường:
```
[root@1data huydv]# cat huydv 
Huy tên đủ là Đường Huy.
18 là số trong ngày sinh 18-22-98
[root@1data huydv]# sed -n "s/Huy/huydv/p" huydv 
huydv tên đủ là Đường Huy.
```

## Dấu phân cách

ví dụ có tệp sau:
```
[root@1data huydv]# cat path 
/rop/bash/
/home/bash
/etc/app/bash/ec.conf
/root/dir/bash/best
```

Muốn chỉ thay thế `/rop/bash/` --> `/root/bar/`. Không thể sử dụng `sed 's/bash/bad/' path` vì nó sẽ thay thế hết mà vì dụ có quá nhiều thì không biết nó ở đâu mà phải ghi rõ ra:`/rop/bash/` 

`sed 's/\/rop\/bash/\/root\/bar/' path` chỉ cần đặt dấu chéo ngược trước các khí tự chéo ngăn cách thư mục.

## Chọn các đoạn văn bản để xử lý
sed xử lý một phần của văn bản - một dòng hoặc một nhóm dòng cụ thể. Để đạt được mục tiêu này, bạn có thể thực hiện cách tiếp cận:

* Đặt giới hạn về số dòng xử lý.
* Chỉ định bộ lọc cho các hàng được xử lý

`sed '2s/test/another test/' myfile` tại dòng thứ 2 tìm từ đầu tiên `test` --> `another test`

`sed '2,3s/test/another test/' myfile` tại dòng thứ 2,3, từ đầu tiên `test`  --> `another test` 

`sed '2,3s/test/another test/g' myfile` tại dòng thứ 2,3, tìm tất cả từ `test`  --> `another test` 
## Xóa dòng
sed '3d' myfile : xóa dòng 3
sed '2,3d' myfile : xóa dòng 2 và 3
sed '3,$d' myfile : Xóa từ dòng 3 đến cuối
sed '/test/d' myfile : xóa tất cả các dòng có chứa từ test
sed '/1/,/one/d' myfile: xóa tất cả các dòng có chứa 1 và one
## Chèn văn bản vào luồng
* Lệnh `i` thêm một dòng mới trước dòng đã cho
* Lệnh `a` thêm một dòng mới sau dòng đã cho

```
[root@1data huydv]# echo "Another test" | sed 'a\First test '
Another test
First test 
[root@1data huydv]# echo "Another test" | sed 'i\First test '
First test 
Another test
```
chèn vào trước dòng số 2
```
[root@1data huydv]# sed '2i\duonghuy' num 
count number:
duonghuy
1
2
3
```

Lệnh `c` cho phép thay đổi toàn bộ nội dung của dòng 
```
[root@1data huydv]# sed '2c\newdata' num 
count number:
newdata
2
3`
```

Tất cả các chuỗi khớp thì thay thế.
```
[root@1data huydv]# cat line 
Đây là dòng 1
Đây là dòng 2
Đây là dòng 3
Đây là dòng 4
Hết.

[root@1data huydv]# sed '/Đây là/c newdata' line 
newdata
newdata
newdata
newdata
Hết.
```
## Thay thế ký tự 
Lệnh `y` hoạt động với ký tự riêng lẻ, thay thế chúng theo dữ liệu được truyền cho nó khi được gọi:
```
[root@1data huydv]# sed 'y/123/567/' num 
count number:
5
6
7
4
5
```

Khi sử dụng lệnh này, bạn phải chú ý rằng nó áp dụng cho toàn bộ dòng văn bản, bạn không thể hạn chế nó trong các lần xuất hiện cụ thể của các ký tự.

## Hiển thị số dòng
Nếu bạn gọi sed bằng một lệnh `=`, nó sẽ in số dòng trong luồng dữ liệu:

```
[root@1data huydv]# sed '=' line 
1
Đây là dòng 1
2
Đây là dòng 2
3
Đây là dòng 3
4
Đây là dòng 4
5
Hết.
```

Sử dụng -n dùng để hiển số các số dòng mà phù hợp với điều kiện tìm:
```
[root@1data huydv]# sed -n '/Đây là/=' line 
1
2
4
```

## Đọc dữ liệu để chèn từ một tệp
Ở trên Chúng ta đã xem xét cách chèn dữ liệu vào luồng, chỉ định những gì cần chèn, ngay cả khi gọi sed. Bạn cũng có thể sử dụng tệp làm nguồn dữ liệu.

Sử dụng lệnh `r` cho phép bạn chèn dữ liệu từ tệp được chỉ định vào luồng. Khi gọi nó chỉ định số dòng, sau đó bạn cần chèn nội dung tệp hoặc mẫu

```
[root@1data huydv]#  sed '3r line' myfile 
This is a test.
This is the second test.
This is the
Đây là dòng 1
Đây là dòng 2
đây là dòng 3
Đây là dòng 4
Hết.
```
sed sẽ in ra nội dung sau dòng thứ 3 của file `myfile` sẽ in vào nôi dung của `line` rồi mới tiếp tục in ra nội dung của `myfile` 

```
[root@1data huydv]#  sed '/Đây là/r myfile' line
Đây là dòng 1
This is a test.
This is the second test.
This is the
Đây là dòng 2
This is a test.
This is the second test.
This is the
đây là dòng 3
Đây là dòng 4
This is a test.
This is the second test.
This is the
Hết.
```
Cứ sau mỗi lần tìm thấy điều kiện thì nó lại in file `myfile` vào.