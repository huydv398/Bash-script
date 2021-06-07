# Getting started with Bash
1. [Hello Word](#1)
2. [Script shebang](#2)
<a name=1></a>
## Phần 1 Hello Word
### Interactive Shell
Bash Shell thường được sử dụng tương tác: Nó cho phép nhập và chỉnh sửa các lệnh, sau đó thực thi chúng khi bạn nhấn return. Nhiều hệ điều hành Unix-base và Unix-like làm bash mặc định (Đặc biệt là linux và MacOS). Thiết bị đầu cuối tự động nhập một chương trình Bash shell tương tác khi khởi động. Nhập hello world bằng cách gõ như sau:
```
[root@hdv ~]# echo "Helloworld"
Helloworld
[root@hdv ~]# echo "Xin chao"
Xin chao
```
* **echo** là một lệnh trong bash ghi các đối số mà nó nhận được vào đầu ra tiêu chuẩn. Nó thêm một dòng mới vào đầu ra.

### 1.1 Non-Interactive Shell - Shell không tương tác
Bash shell cũng có thể chạy không tương tác từ một script, làm làm shell không cần sự tương tác từ con người. Hành vi tương tác và hành vi theo tập lệnh phải  giống nhau- một cân nhắc phải thiết kế quan trọng của Unix V7 Bourne shele và ạm dịch là bash. Do đó bất cứ điều gì có thể thực hiển được ở dòng lệnh đều có thể được đưa vào script để sử dụng lại.

Làm theo các bước để tạo một script **Hello world**:
* Tạo file mới có tên hello.sh:
`touch hello.sh`
* Thêm quyền thực thi đối với file:
`chmod +x hello.sh`
* Thêm code vào file hello.sh
    * Dòng đầu tiên chuỗi ký tự `#!` được gọi là shebang1. Shebang hướng dẫn hệ điều hành chạy
    * Dòng 2 sử dụng echo để ghi `Hello World` vào đầu ra tiêu chuẩn
```
#!/bin/bash
echo "Hello World"
```
* Thực thi tập lệnh hello.sh từ dòng lệnh bằng cách sử dụng một trong những cách sau
    * Cách mà được sử dụng phổ biến nhất `./hello.sh`
    * `/bin/bash hello.sh`
    * `bash hello.sh`
    * `sh hello.sh`
        * Tất cả đều được kết quả cuối cùng là `Hello World`

Đối với việc sản xuất ra một sản phẩm thực sự, bạn sẽ bỏ qua phần mở rộng `.sh` và có thể di chuyển đến một thư mục trong path của bạn để nó có sẵn cho bạn sử dụng ở bất cứ thư mục nào. Giống như việc thực hiện `cat` hay `ls`.

Các lỗi thường gặp bao gồm:
* Không áp dụng quyền thực thi trên tệp, `chmod +x script.sh` khi thực thi sẽ xuất hiện `-bash: ./script.sh: Permission denied`
* Chỉnh sửa tệp lệnh trên Window, tạo ra các ký tự kết thúc dòng không chính xác mà bash không thể xử lý. 
* Sử dụng `sh ./hello.sh`, không nhận ra rằng bash và sh là các shell riêng biệt(mặc dù bash tương thích ngược). Dù sao chỉ cần dựa vào các dòng shebang của script là rất thích hợp để viết rõ rằng bash hoặc sh(hoặc python ,perl, awk hoặc ruby) trước tên tệp của mỗi script. Một dòng shebang phổ biết được sử dụng để làm cho tập lệnh của bạn dễ di chuyển hơn là sử dụng `#!/usr/bin/env bash` thay vì mã hóa cứng đường dẫn đến bash. Theo cách đó, `/usr/bin/env` phải tồn tại nhưng ngoài thời điểm đó, chỉ cần bash có ở trên PATH của bạn. Trên nhiều hệ thống, /bin/bash không tồn tại và bạ nên sử dụng /usr/local/bin/bash hoặc một số đường dẫn tuyệt đối khác; thay đổi này tránh phải tìm ra các chi tiết của 
### 1.2 Hello World sử dụng biến
Tạo một file `hello.sh` với nội dung và cấp quyền thực thi
```
#!/usr/bin/env bash 
# space cannot be used around the `=` assingment operator - không sử dụng dấu cách cạch dấu =
var_1="World"

# Use printf to safely output the data- xuất data antoan
printf "Hello, %s\n" "$var_1"
```

Thao tác này sẽ in Hello, World ra đầu ra tiêu chuẩn khi được thực thi.

Đoạn mã sau châp nhận một đối số $1 , là đối số dòng lệnh đầu tiên và xuất nó ra một chuỗi định dạng. Nôi dung tệp lệnh như sau:
```
#!/usr/bin/env bash
printf "Hello, %s\n" "$1"
```
Thực hiện lệnh với đối số là ký tự theo sao câu lệnh:
```
[root@hdv ~]# ./hello.sh 
Hello, 
[root@hdv ~]# ./hello.sh Huydv
Hello, Huydv
[root@hdv ~]# ./hello.sh Hà Nội
Hello, Hà
[root@hdv ~]# ./hello.sh  "Hà Nội"
Hello, Hà Nội
[root@hdv ~]# ./hello.sh World
Hello, World
```
* Câu lệnh đầu tiên là không có đối số. 
* Câu lệnh thứ 2, đối số bằng với một chuỗi
* Câu lệnh thứ 3, đối với chuỗi có phân cách nhau bằng dấu cách, đối số `$1` chỉ được ứng với 1 chuỗi đầu tiền sau câu lệnh.
* Để xử lý câu lệnh thứ 3 không hiện thị được chuỗi thì ta cần thêm dấu ngoặc kép cho câu lệnh
### 1.3 Hello World with user Input

Phần sau sẽ nhắc người dùng nhập dữ liệu sau đó lưu thông tin văn bản dưới dạng string (text) trong một biến. Biến sau đó được sử dụng để in thông điệp cho người dùng

```
#!/usr/bin/env bash

echo "Tên của bạn là gì?"
read name
echo "Hello, $name."

```
Lệnh `read` ở đây đọc dữ liệu từ đầu vào tiêu chuẩn vào tên biến. Sau đó sử dụng `$name`  và in ra bằng `echo`

```
[root@hdv ~]# ./hello.sh
Tên của bạn là gì?
Duong Huy
Hello, Duong Huy.
```

Ở đây người dùng nhập tên là Duong Huy và mã này được sử dụng rồi in ra `Hello, Duong Huy`

Nếu bạn muốn nối một cái gì đó vào giá trị biến trong khi in nó, hãy sử dụng dấu ngoặc nhọn quanh biến tên như được hiển thị trong ví dụ sau
```
#!/usr/bin/env bash
echo "Bạn đang làm gì?"
read action
echo "Bạn đang ${action} ở bờ hồ."
```

output:
```
[root@hdv ~]# ./hello.sh
Bạn đang làm gì?
Đứng  
Bạn đang Đứng ở bờ hồ.
[root@hdv ~]# ./hello.sh
Bạn đang làm gì?
chạy
Bạn đang chạy ở bờ hồ.
```
### 1.4 Tầm quan trọng của trích dẫn chuỗi
Trích dẫn rất quan trọng trong việc mở rộng chuỗi trong bash. Với những điều này, bạn có thể kiểm soát bash phân tích cú pháp và mở rộng chuỗi của bạn.

Có hai loại qouting - trích dẫn:
* Weak-Yếu: sử dụng dấu ngoặc kép: ""
* Strong - Mạnh: sử dụng dấu ngoặc đơn: ''

Nếu bạn muốn mở rộng đối số của mình, bạn có thể sử dụng Weak qouting:
```
#!/usr/bin/env bash
world="Vietnamese"
echo "Hello $world"
```
Output:
```
[root@hdv ~]# ./hello.sh
Hello Vietnamese
```

Nếu bạn không muốn mở rộng đối số, hãy sử dụng Strong qouting:
```
#!/usr/bin/env bash
world="Vietnamese"
echo 'Hello $world'
```
Output:
```
[root@hdv ~]# ./hello.sh
Hello $world
```

Bạn cũng có thể sử dụng dấu `\` để ngăn mở rộng:
```
#!/usr/bin/env bash
world="Vietnamese"
echo "Hello \$world"
```
Output:
```
[root@hdv ~]# ./hello.sh
Hello $world
```
### 1.5 Xem thông tin cho tích hợp sẵn của Bash 
`help [command]`: Dùng để xe thông tin, cách sử dụng và các tùy chọn có trong câu lệnh

### 1.6 Chế độ "Debug"
```
[root@hdv ~]# cat hello.sh 
#!/usr/bin/env bash
echo "Hello world"
[root@hdv ~]# bash -x hello.sh 
+ echo 'Hello world'
Hello world
```
Đối số `-x` cho phép bạn xem qua từng dòng lệnh trong tệp.
Ví dụ1:
```
#!/usr/bin/env bash
echo "Hello world "
adding_string_to_number="s"
v=$(expr 5 + $adding_string_to_number)
```
Output:
```
[root@hdv ~]# bash -x hello.sh 
+ echo 'Hello world \n'
Hello world \n
+ adding_string_to_number=3
++ expr 5 + 3
+ v=8
```

Ví dụ 2: thông số đưa vào sẽ không đúng định dạng:

```
[root@hdv ~]# bash hello.sh 
Hello world 
expr: non-integer argument

[root@hdv ~]# bash -x hello.sh 
+ echo 'Hello world '
Hello world 
+ adding_string_to_number=s
++ expr 5 + s
expr: non-integer argument
+ v=
```

`bash hello.sh`- Lỗi được nhắc không thể thực hiện tập lệnh nhưng sử dụng `bash -x hello.sh` sẽ biết lệnh đang bị lỗi ở đâu
<a name=2></a>
## Phần 2 Script shebang
### 2. ENV Shebang
Để thực thi một script với tệp thực thi bash được tìm thấy trong biến môi trường PATH bằng cách sử dụng tệp thực thi env, Dòng đầu tiên của script phải chỉ ra đường dẫn tuyệt đối đến tệp thực thi env với đối số là **bash**:

`#!/usr/bin/env bash`

Đường dẫn env trong shebang được giải quyết và chỉ được sử dụng nếu một tệp lệnh được khởi chạy trực tiếp như thế này:

`script.sh`

Tệp lệnh phải có quyền thực thi

Shebang bị bỏ qua khi một trình thông dịch bash được chỉ định rõ ràng để thực thi một script:

`bash script.sh`

### 2.2 Direct shebang
Để thực thi một tệp script với trình thông dịch bash, dòng đầu tiên của tệp lệnh phải chỉ ra đường dẫn tuyệt đối đến bash thực thi để sử dụng:

`#!/bin/bash`

Đường dẫn bash trong she bang được giải quyết và chỉ được sử dụng khi một script được khởi chạy trực tiếp như này:

`./script.sh`

Script phải được cấp quyền thực thi.

Shebang bị bỏ qua khi một trình thông dịch bash được chỉ định rõ ràng để thực thi một tệp lệnh:

`bash script.sh`
### 2.3 Other shebangs
Có 2 loại chương trình mà kernel biết. Một chương trình nhị phân được xác định bởi tiêu đề ELF(ExtenableLoadableFormat - Định dạng có thể tái mở rộng), thường được tạo bởi trình biên dịch. Thứ hai là kịch bản của bất kỳ loại nào.

Nếu một tệp bắt đầu với dòng đầu tiên bằng chuỗi  #! thì tiếp theo phải là tên đường dẫn của trình thông dịch.

Nếu kernel đọc được dòng này, nó sẽ gọi trình thông dịch được đặt tên theo tên đường dẫn này và đưa các từ trong dòng làm đối số thông dịch.

```
#!/usr/bin/env something 
echo "Không in được"
```
Sẽ không thực thi được câu lệnh vì trong /usr/bin/evn không có trình thông dịch something, something không thể xử lý được lệnh