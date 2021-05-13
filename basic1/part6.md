# Chức năng và phát triển thư viện
Khi chúng ta viết một tập lệnh bash và muốn sử dụng lại một đoạn code thì ta có thể tạo ra các hàm và sử dụng lại chúng
## Khai báo hàm
```
function Name {}
```
Hoặc 
```
function Name() {}
```
## Sử dụng functions
```
#!/bin/bash
function myfunc {
echo "Ví dụ cho function"
}
count=1
while [ $count -le 3 ]
do
myfunc
count=$(( $count + 1 ))
done
echo "Đây là phần cuối của vòng lặp"
myfunc
echo "Kết thúc script"
```

Output
```
[root@1data huydv]# ./bash.sh 
Ví dụ cho function
Ví dụ cho function
Ví dụ cho function
Đây là phần cuối của vòng lặp
Ví dụ cho function
Kết thúc script
```

Trong đoạn script tren hàm `myfunc` được gọi ra 4 lần`

Lưu ý: Hàm phải được khai báo trước xong mới được sử dụng và tên hàm phải là duy nhất, nếu trùng thì hàm khai báo sau sẽ đè lên và chỉ dùng được làm khai báo sau.

## Sử dụng câu lệnh return
Câu lệnh return quy định mã số nguyên được trả về bởi hàm
```
#!/bin/bash
function myfunc {
read -p "Nhập giá trị: " value
echo "Thêm giá trị $value + 10"
return $(( $value + 10 ))
}
myfunc
echo "Giá trị cuối $?"
```

Output
```
[root@1data huydv]# ./bash.sh 
Nhập giá trị: 2
Thêm giá trị 2 + 10
Giá trị cuối 12
```
## Viết output của function vào biến -Writing the output of a function to a variable
Một cách khác để trả về kết quả công việc của một function là viết ra dữ liệu bằng function cho biến.

```
#!/bin/bash
function myfunc {
read -p "Nhập giá trị: " value
echo $(( $value + 10 ))
}
ketqua=$(myfunc)
echo "Giá trị cuối $ketqua"

```

Output:
```
[root@1data huydv]# ./bash.sh 
Nhập giá trị: 1
Giá trị cuối 11
```
## Đối số của hàm
```
#!/bin/bash
function myfunc {
echo $(( $1 + $2 ))
}
if [ $# -eq 2 ]
then
value=$( myfunc $1 $2)
echo "Kết quả $value"
else
echo "Usage: script  a b"
fi
```
 Output:
```
[root@1data huydv]# ./bash.sh 10
Usage: script  a b
[root@1data huydv]# ./bash.sh 10 20
Kết quả 30
```

Điều này có nghĩa là nếu hàm sử dụng thông số được truyền đến script khi được gọi. Bạn phải truyền đủ thông số khi thực hiện script.
## Làm việc với biến trong function
### Biến chung - Global variables
Là biến được hiển thị ở bất cứ đâu trong tệp lệnh bash và theo mặc định thì tất cả các biến đươc khai báo trong tệp đều được coi là biến Global

```
#!/bin/bash
function myfunc {
value=$(( $value + 10 ))
}
read -p "Nhập giá trị: " value
myfunc
echo "Giá trị mới: $value"
```
Output
```
[root@1data huydv]# ./bash.sh
Enter a value: 3
The new value is: 13
```

Khi biến được gắn một giá trị mới trong hàm, giá trị mới đó không bị mất khi tệp lệnh gọi nó sau khi hàm kết thúc.
### Biến Local 
Là các biến được khai báo bên trong function. Để làm được điều này ta phải thêm `local` trước khi gắn biến

`local [ten]=$(( $value + 5 ))`

Nếu có một biến cùng tên bên ngoài hàm thì nó sẽ không bị ảnh hưởng
```
#!/bin/bash
function myfunc {
local value1=$[ $value + 5 ]
echo "value1 từ bên trong function $value1"
}
value1=4
myfunc
echo "vulue1 từ bên ngoài $value1"

```

Output:
```
[root@1data huydv]# ./bash.sh
value1 từ bên trong function 5
vulue1 từ bên ngoài 4
```
## Truyền mảng đến function dưới dạng đối số
```
#!/bin/bash
function myfunc {
local newarray
newarray=("$@")
echo "Giá trị mảng mới ${newarray[*]}"
}
myarray=(1 2 3 4 5)
echo "Mảng ban đầu là ${myarray[*]}"
myfunc ${myarray[*]}
```

Output:
```
[root@1data huydv]# ./bash.sh 
Mảng ban đầu là 1 2 3 4 5
Giá trị mảng mới 1 2 3 4 5
```

## Hàm đệ quy
## Tạo và sử dụng thư viện
Bạn đã biết và viết các hàm và cách gọi chúng trong cùng một tệp lệnh mà chúng được khai báo. Điều gì sẽ xảy ra nếu bạn cần sử dụng một hàm, khối code của nó, trong một script khác, mà không cần sử dụng sao chép vào dán

Lệnh `source` sử dụng để liên kết các thư viện với các tập lệnh. Kết quả là các hàm đươc khai báo trong thư viện sẽ có sẵn trong tệp lệnh, nếu không, các hàm từ thư viện sẽ không khả dụng trong phạm vi của các tệp lệnh khác.

`source` có thể viết tắt là dấu chấm

* Tạo một file có tên `myfuncs`

`vi myfuncs`
thêm vào dữ liệu
```
function addnum {
echo $(( $1 + $2 ))
}
```

Thực hiện gọi function tạo bên trên

```
#!/bin/bash
. ./myfuncs
result=$(addnum 10 20)
echo "The result is: $result"
```

Uotput:
```
[root@1data huydv]# ./bash.sh
The result is: 30
```
Chúng tôi vừa một hàm thư viện bên trong một script