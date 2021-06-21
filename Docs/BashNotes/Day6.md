Arrays
1. [Using cat ](#1)
2. [Grep](#2)
3. [alias](#3)
<a name=1></a>

# Gán mảng
## List Assignment - Gán vào list
Bash sử dụng dấu cách để phân tách các phần tử trong mảng:
```
[root@hdv ~]# array=(1 2 3 4)
[root@hdv ~]# echo ${array[2]}
3
[root@hdv ~]# echo ${array[@]}
1 2 3 4
[root@hdv ~]# city=("Ha Noi" "HCM" "Da Nang" "Hai Phong")
[root@hdv ~]# echo ${city[@]}
Ha Noi HCM Da Nang Hai Phong
[root@hdv ~]# echo ${city[0]}
Ha Noi
[root@hdv ~]# echo ${city[3]}
Hai Phong
[root@hdv ~]# echo ${city[-1]}
Hai Phong
[root@hdv ~]# echo ${city[-2]}
Da Nang
```
* Trong dấu ngoặc vuông là thứ tự của phần trong mảng.
    * `@`: Lấy ra tất cả các phần tử trong mảng
    * Số nguyên dương là từ trái qua phải. Bắt đầu bằng 0 là phần tử đầu tiên
    * Số nguyên âm là lấy từ phải qua trải bắt đầu bằng -1
### Subscript Assignment
Tạo phần tử với chỉ số rõ ràng:

`array=([3]='fourth element' [4]='fifth element')`

ví dụ:
```
[root@hdv ~]# city=([5]="Hue" [6]="Hung Yen")
```
Lưu ý: khi khai báo như trên thì các phần tử cũ sẽ bị xóa. Và khi gọi phải đúng tên số đã khai báo
### Tạo mảng theo chỉ mục
```
[root@hd ~]# array[0]='first element'
[root@hd ~]# array[1]='second element'
[root@hd ~]# echo ${array[1]}
second element
```
### Tạo mảng theo tên
`declare`: Là một lệnh dựng sẵn của bash shell. Nó được sử dụng để khai báo các biến và hàm shell, thiết lập các thuộc tính của chúng và hiển thị các giá trị của chúng.

```
declare -A array1
array1[ho]='Nguyen'
array1[ten]='Abc'
```

### Tạo mảng động.
* Tạo một mảng từ đầu ra của lệnh khác,
```
[root@hd ~]# array=(`seq 1 10`)
[root@hd ~]# echo ${array[5]}
6
[root@hd ~]# echo ${array[@]}
1 2 3 4 5 6 7 8 9 10

```
* Tạo mảng vừ vòng lặp:
Tạo file:
```

```
## 2 Truy cập các phần tử mảng
Khai báo mảng và phần tử trong mảng:
```
[root@hd ~]# array=(`seq 1 10`)
```

### In phần tử ở index 0 
```
[root@hd ~]# echo "${array[0]}"
1
```
Lấy ra phần tử ở vị trí đầu tiên
### In phần tử cuối cùng bằng cú pháp mở rộng chuỗi con 

### In phần tử cuối cùng bằng cú pháp chỉ số 
```
[root@hd ~]# echo "${array[-1]}"
10
```
### In tất cả các phần tử, mỗi phần tử được trích dẫn riêng biệt 
```
[root@hd ~]# echo "${array[@]}"
1 2 3 4 5 6 7 8 9 10
```
### In tất cả các phần tử dưới dạng một chuỗi được trích dẫn duy nhất 
```
[root@hd ~]# echo "${array[*]}"
1 2 3 4 5 6 7 8 9 10
```
### In tất cả các phần tử từ chỉ mục 1, mỗi phần tử được trích dẫn 
```
[root@hd ~]# echo "${array[@]:1}"
2 3 4 5 6 7 8 9 10
[root@hd ~]# echo "${array[@]:3}"
4 5 6 7 8 9 10
```
Đối số sau dấu : là số phần tự bị bỏ qua
### In 3 phần tử từ chỉ mục 1, mỗi phần tử được trích dẫn riêng biệt 

```
[root@hd ~]# echo "${array[@]:1:3}"
2 3 4
[root@hd ~]# echo "${array[@]:4:9}"
5 6 7 8 9 10
```
Lấy ra các phần tử chỉ định từ 1:3 hoặc từ 4:9. Đưa 
### Hoạt động chuỗi
Nếu tham chiếu đến một phần tử, các phép toán chuỗi vd:

`[root@hd ~]# array=(zero one two bashshell )`
* `echo "${array[0]:0:3}"`: Lấy ra phần tử đầu tiên, trong đó 0 khởi đầu và lấy 3 ký tự trong phần tử để in ra 
```
[root@hd ~]# echo "${array[0]:0:3}"
zer
```
* `echo "${array[3]:3:4}"`: Lấy ra phần tử thứ 4, và bắt đầu lấy từ vị trí thứ 2 và lấy 4 ký tự.
```
[root@hd ~]# echo "${array[3]:2:4}"
shsh
```
## 3 Sửa đổi mảng.
### Change Index
Sửa đổi hoặc nhập một phần tử cụ thể trong mảng:
```
[root@hd ~]# array[1]="number one"
[root@hd ~]# echo "${array[1]}"
number one
```

Phần tử `array[1]=one` thay thế nó bằng array[1]="number one"
### Nối tiếp
Sửa đổi mảng, thêm phần tử vào cuối nếu không có chỉ số con nào được chỉ định
```
array+=('new1' 'new2')
```
### Thay thế toàn bộ mảng bằng một danh sách tham số mới.
`array=("${array[@]}" "new1" "new2")`
### Chèn một phần tử ở đầu tiên
`array=("new With Begin" "${array[@]}")`

### Chèn một phần tử tại một vị trí nhất định
```
[root@hd ~]# arr=(a b c d)
[root@hd ~]# arr=("${arr[@]:0:2}" 'new' "${arr[@]:2}")
[root@hd ~]# echo "${arr[*]}"
a b new c d
```
### Xóa phần tử chỉ định

```
[root@hd ~]# num=(12 14 16)
[root@hd ~]# echo "${num[@]}"
12 14 16
[root@hd ~]# echo "${!num[@]}" # In ra vị trí
0 1 2
[root@hd ~]#  unset -v 'num[1]' # Xóa ở vị trị 1
[root@hd ~]# echo "${num[@]}" 
12 16
[root@hd ~]# echo "${!num[@]}"
0 2
```
### Hợp nhất chuỗi
`array3=("${array1[@]}" "${array2[@]}")`

Ví dụ:
```
[root@hd ~]# echo "${arr[@]}"
a new new c d
[root@hd ~]# echo "${num[@]}"
12 16
[root@hd ~]# arr_1=("${arr[@]}" "${num[@]}")
[root@hd ~]# echo "${arr_1[@]}"
a new new c d 12 16
[root@hd ~]# echo "${!arr_1[@]}"
0 1 2 3 4 5 6
```

### Lập lại chỉ mục một mảng.
Điều này hữu ích nếu mạng của bạn bị xóa và chỉ số chỉ mục index không theo một chuỗi nhất đinh. và bạn muốn sắp xếp lại theo tuần tự

`array=("${array[@]}")`
## 4 Lặp lại mảng
Có 2 loại foreach và for-loop:

Cho mảng `num = (1 2 3 4 5)`

* Vòng lặp foreach:
```
for y in "${a[@]}"; do
    echo "$y"
done
```
* for-loop:
```
for ((idx=0; idx < ${#a[@]}; ++idx)); do
    echo "${a[$idx]}"
done
```
## 5 Độ dài của mảng
```
[root@hd ~]# array=('first element' 'second element' 'third element')
[root@hd ~]# echo "${#array[@]}"
3
[root@hd ~]# echo "${array[@]}"
first element second element third element
[root@hd ~]# echo "${#array[@]}"
3
[root@hd ~]# echo "${!array[@]}"
0 1 2
```

* In ra số ký tự của phần tử:
```
[root@hd ~]# echo "${#array[0]}" 
13
[root@hd ~]# echo "${#array[1]}" 
14
```
## 6 Mảng liên kết
Khai báo mảng liên kết là bắt buộc
```
declare -A aa
aa[say]=hello
aa[cmd]=ls
aa["Key world"]="Hello World"
```

Hoặc:
```
declare -A aa
aa=([say]=hello [cmd]=ls ["Key world"]="Hello World")
```
### Truy cập phần tử của mảng kết hợp
```
[root@hd ~]# echo ${aa[say]}
hello
[root@hd ~]# echo ${aa[cmd]}
ls

```
### Lấy ra tất cả các key của mảng kết hợp
```
[root@hd ~]# echo "${!aa[@]}"
say Key world cmd
```
### Lấy các value của mảng kết hợp
```
[root@hd ~]# echo "${aa[@]}"
hello Hello World ls
```
### Lấy ra cả key và value của mảng kết hợp
```
for key in "${!aa[@]}"; do
    echo  ${key} : ${aa[$key]}
done
```

output:
```
[root@hd ~]# for key in "${!aa[@]}"; do
>     echo  ${key} : ${aa[$key]}
> done
say : hello
Key world : Hello World
cmd : ls
```
## 7 Vòng lặp qua một mảng.


arr=(a b c d e f)

* Sử dụng vòng lặp for. Cho i chạy trong mảng arr và in ra i.
```
for i in "${arr[@]}"; do
 echo "$i"
done
```

output:
```
[root@hd ~]# ./file1.sh 
a
b
c
d
e
f
```
* Sử dụng while, $i khi nào nhỏ hơn hoặc bằng chỉ mục có trong mảng thì dừng lại:

```
i=0
while [ $i -lt ${#arr[@]} ]; do
 echo "${arr[$i]}"
 i=$((i + 1))
done
```
hoặc:
```
i=0
while (( $i < ${#arr[@]} )); do
 echo "${arr[$i]}"
 ((i++))
done
```
Output
```
[root@hd ~]# ./file1.sh 
a
b
c
d
e
f
```

Sử dụng vòng lặp Until, Chạy cho đến khi nào i mà bằng số lượng thành phần thì dừng lại:
```
i=0
until [ $i -ge ${#arr[@]} ]; do
 echo "${arr[$i]}"
 i=$((i + 1))
done
```
## 8 Deesstroy, Delete, unset một mảng
```
unset array
```

Xóa hủy ở một vị trí chỉ định:
```
unset array[10]

```
### Mảng từ chuỗi
```
stringVar="Apple Orange Banana Mango"
arrayVar=(${stringVar// / })
```

Câu lệnh dùng để tách thành các biến nhỏ
```
[root@hd ~]# echo ${!stringVar[*]}
0
[root@hd ~]# echo ${!arrayVar[*]}
0 1 2 3
``` 

* $stringVar chỉ có 1 chỉ mục duy nhất
* `${stringVar// / }`: chuỗi được phân chăc nhau bởi khoảng trắng thì tác làm các chỉ mục độc lập. $arrayVar có 4 chỉ mục độc lập.

Ví dụ tương tự:
```
[root@hd ~]# stringVar="Apple+Orange+Banana+Mango"
[root@hd ~]# arrayVar=(${stringVar//+/ })
[root@hd ~]# echo ${arrayVar[0]}
Apple
[root@hd ~]# echo ${arrayVar[3]}
Mango
```
## 10 Đọc toàn bộ tệp thành một mảng
### Đọc trong một bước duy nhất
Sử dụng mapfile hoặc readarray:

`mapfile -t arr < file`

hoặc

`readarray -t arr < file`

Từ dữ liệu từ **file** để đưa vào biến, mỗi dòng trong file được phân tách làm 1 biến.

### Đọc trong vòng lặp
```
arr=()
while IFS= read -r line; do
 arr+=("$line")
done
```

Thực hiện nhập dữ liệu phân tách khi xuống dòng, để thực hiện dừng lại **Ctr Z**.
### Function chèn mảng
Funtion sẽ chèn một phần tử vào một mảng tại một chỉ mục duy nhất:

## Mảng liên kết
### Kiểm tra mảng giả định
Tất cả mức sử dụng cần thiết được hiển thị với đoạn mã:
