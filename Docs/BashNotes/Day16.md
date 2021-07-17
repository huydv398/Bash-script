Mở rộng bằng ký hiệu
## 1.1 Sưa đổi phần mở rộng tên tệp
```
$ mv filename.{jar,zip}
```
Câu lệnh trên thực hiện đổi tên phần mở rộng của tệp filename một cách ngắn ngọn hơn thay vì phải thực hiện câu lệnh `mv filename.jar filename.zip`

## 1.2 Tạo thư mục để nhóm tên theo tháng và năm
```
root@hd:~$ mkdir 20{18..21}-{01..09}
root@hd:~$ ls
2018-01  2018-07  2019-04  2020-01  2020-07  2021-04
2018-02  2018-08  2019-05  2020-02  2020-08  2021-05
2018-03  2018-09  2019-06  2020-03  2020-09  2021-06
2018-04  2019-01  2019-07  2020-04  2021-01  2021-07
2018-05  2019-02  2019-08  2020-05  2021-02  2021-08
2018-06  2019-03  2019-09  2020-06  2021-03  2021-09
```

Bạn có thể đệm các số 0:
```
echo {0001..11}
0001 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011
```
## 1.3 Sử dụng increments
```
root@hd:~$ echo {0..10..2}
0 2 4 6 8 10
root@hd:~$ echo {0..100..50}
0 50 100
root@hd:~$ echo {0..1000..100}
0 100 200 300 400 500 600 700 800 900 1000
```
Tham số thứ 3 để chỉ định giá trị gia tăng, {start..end..increment}

Cũng có thể được áp dụng với chữ:
```
root@hd:~$ for x in {a..z..6}; do echo -n $x; done
agmsy 
```
## 1.4 Sử dụng dấu ngoặc nhọn để tạo danh sách
```
root@hd:~$ echo {a..z}
a b c d e f g h i j k l m n o p q r s t u v w x y z
root@hd:~$  echo {z..a}
z y x w v u t s r q p o n m l k j i h g f e d c b a
root@hd:~$  echo {1..20}
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
root@hd:~$ echo {01..20}
01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20
root@hd:~$ echo {20..1}
20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1
root@hd:~$  echo {a..d}{1..3}
a1 a2 a3 b1 b2 b3 c1 c2 c3 d1 d2 d3
```
## 1.5 Tạo nhiều thư mục với thư mục con
```
root@hd:~$ mkdir -p directories/subdir_{01..09}/{child1,child2,child3}
```
Thao tác này sẽ tạo một thư mục cao nhất **directories** , sau đó tạo 9 thư mục **surdir** bên trong đánh số từ 1 đến 9, sau đó bên trong các subdir bao gồm có 3 thư mục con : **child1**, **child2**, **child3** 
Output:
```
root@hd:~/directories$ tree
.
├── subdir_01
│   ├── child1
│   ├── child2
│   └── child3
├── subdir_02
│   ├── child1
│   ├── child2
│   └── child3
├── subdir_03
│   ├── child1
│   ├── child2
│   └── child3
├── subdir_04
│   ├── child1
│   ├── child2
│   └── child3
├── subdir_05
│   ├── child1
│   ├── child2
│   └── child3
├── subdir_06
│   ├── child1
│   ├── child2
│   └── child3
├── subdir_07
│   ├── child1
│   ├── child2
│   └── child3
├── subdir_08
│   ├── child1
│   ├── child2
│   └── child3
└── subdir_09
    ├── child1
    ├── child2
    └── child3

36 directories, 0 files
```
Và như thế. Tối thấy điều này rất hữu ích để tạo nhiều thư mục và thư mục con cho các thư mục đích cụ thể, chỉ với một lệnh bash. 
## getopts : smart positionalparameter parsing- phân tích cú pháp tham số vị trí thông minh
|Thông số|Chi tiết|
|-|-|
|optstring|Các ký tự tùy chọn được nhận dạng|
|name|Sau đó đặt tên nơi lưu trữ tùy chọn đã phân tích cú pháp|

`getopts` trong script: láy các tùy chọn và đối số của chúng ta từ danh sách các tham số tuân theo cú pháp tùy chọn. Thông thường sử dụng getopts để phân tích các đối số được truyền vào cho chúng.
### pingnmap
Tạo một file script có nôi dung như sau
```
#!/bin/bash
# Script name : pingnmap
# Tình huống: Quản trị viên hệ thống trong công ty phải liên tục làm
# việc với các câu lệnh ping và nmap, vì vậy quyết định đơn giản hóa 
# công việc bằng cách sử dụng một script
# Nhiệm vụ mà script sau khi viết xong phải làm được là
# 1. Ping - với tối đa 5 địa chỉ IP/tên miền. AND/OR
# 2. Kiểm tra xem một port cụ thể có đang mở với một tên miền/IP
# và getopts là để phân tích các đối số
# Tổng quan về các tùy chọn
# n : có nghĩa là nmap
# t : có nghĩa là ping 
# i : Tùy chọn để nhập địa chỉ IP
# p : Tùy chọn để nhập vào số của port 
# v : Tùy chọn để lấy ra phiên bản script

while getopts ':nti:p:v' opt
#Đưa ra: loại bỏ ngay từ đầu các lỗi không hợp lệ
do
case "$opt" in
    'i')ip="${OPTARG}" #Nếu opt = -i thì đặt ip bằng đối số theo sau nó
    ;;
    'p')port="${OPTARG}" #Nếu opt = -p thì đặt port bằng đối số theo sau nó
    ;;
    'n')nmap_yes=1; #opt có -n thì đặt biến nmap_yes=1
    ;;
    't')ping_yes=1; #opt có -t thì đặt biến ping_yes=1
    ;;
    'v')echo "pingnmap version 1.0.0"&& sleep 5  #Nếu có opt là -v thì thực hiện lệnh này luôn
    ;;
    *) echo "Invalid option $opt" # Còn nếu tất cả các case opt theo sau không đủ điều kiện trên thì thực hiện echo text sau.
    echo "Usage : "
    echo "pingmap -[n|t[i|p]|v]"
    ;;
esac
done
if [ ! -z "$nmap_yes" ] && [ "$nmap_yes" -eq "1" ] # nếu biến $nmap_yes có dữ liệu và bằng 1 mới thực hiện lệnh
then
    if [ ! -z "$ip" ] && [ ! -z "$port" ] # Nếu $ip và $port không bỏ trống thực hiện cmd trong then
    then
        nmap -p "$port" "$ip"
    fi
fi
if [ ! -z "$ping_yes" ] && [ "$ping_yes" -eq "1" ]  #Nếu $ping_yes không rỗng và =1 thực hiện cmd trong then
then
    if [ ! -z "$ip" ] #nếu $ip #0 thì thực hiện cmd then
    then
        ping -c 5 "$ip"
    fi
fi
shift $(( OPTIND - 1 )) # Xử lý các đối số bổ sung
if [ ! -z "$@" ]
    then
        echo "Đối số không có ở cuối : $@"
fi
```
