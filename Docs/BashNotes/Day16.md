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

```
