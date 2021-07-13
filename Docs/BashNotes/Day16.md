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