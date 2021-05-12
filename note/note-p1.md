# Note1
* `;` ngăn cách các lệnh trên cùng một dòng.
* `#/bin/bash`: phải thêm vào đầu tiên khi thực hiện bash-script
* `\` được thêm trước $: để được hiện thị không hiểu là biến.
* mydir=`pwd` = `mydir=$(pwd)`
* Phép toán học: `$((a+b))`
* Cấu trúc `if then`:
```
if [Điều kiên]
then
[cmd]
fi
```
* `if-the-else`:
```
# Điều kiện
if [Điều kiện]
# Nếu đủ điều kiện thực hiện command then
then
[Commands]

# Không đủ điều kiện thực hiện lệnh else
else
[Commands]
fi
```
* So sánh số
    * `a -eq a`: a=b
    * `a -ge b`: a>=b
    * `a -gt b`: a>b
    * `a -le b`: a<=b
    * `a -lt b`: a<b
    * `a -ne b`: a#b
* So sánh chuỗi:
    * `a = b`: Các giá trị chuỗi giống nhau
    * `a != b`: Các giá trị chuỗi không giống nhau
    * `a < b`: Chuỗi a ít hơn b
    * `a > b`: Chuỗi a nhiều hơn b
    * `-n a`: Độ dài chuỗi lớn hơn 0
    * `-z a`: Độ dài chuỗi bằng 0
* Khi so sánh có dấu `<` và `>` phải đặt dấu `\` phía trước
* Check file:
    * `-d file`: Có tồn tại và là một thư mục
    * `-e file`: có tồn tại
    * `-f file`: tồn tại và là tệp
    * `-r file`: tồn tại và có thể đọc được không
    * `-s file`: tồn tại không và tệp có trống rỗng không
    * `-w file`: tồn tại và có thể ghi được không
    * `-x file`: tồn tại và có thể thực thi không
    * `f1 -nt f2`:f1 mới hơn f2
    * `f1 -ot f2`f1 cũ hơn f2
    * `-O file`: tồn tại và thuộc sở hữu của người dùng hiện tại không
    * `-G file`: tồn tại hay không và ID group khớp với ID group người dùng hiện tại