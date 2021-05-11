## Note
### Cấu trúc vòng lặp **for**
```
for var in <giá trị>
do
<Câu lệnh>
done
```

```
for <var-name> in <source>
do
if [ Điều kiện ]
then
<command>
elif [ điều kiện ]
then
<command>
fi
done
```
### Vòng lặp while
```
#Biến cho trước
var =5

# Xét điều kiện
while [ $var -gt 0 ]
do
echo $var
var=$[ $var -1 ]
done
```
### Vòng lặp lồng nhau

```
for (( a = 1; a <= 3; a++ ))
    do
    echo "$a"
        for (( b = 1; b <= 3; b++ ))
            do
            echo "$b"
            done
    done
```

## Lệnh Break
```
for var1 in 1 2 3 4 5 6
do
if [ $var1 -eq 5 ]
then
break
fi
echo "Số: $var1"
done
```
```
#!/bin/bash
var1=1
while [ $var1 -lt 10 ]
do
    if [ $var1 -eq 5 ]
    then
    break
    fi
    echo "số: $var1"
    var1=$(( $var1 + 1 ))
done
```

```
#!/bin/bash
for (( var1 = 1; var1 < 15; var1++ ))
do
    # Nếu biến var1 nhỏ hơn bằng 5 và lớn hơn bằng 10 thực hiện lệnh
    if [ $var1 -gt 5 ] && [ $var1 -lt 10 ]
    then
    continue
    fi
    echo "Số: $var1"
done
```
```
for (( a = 1; a < 6; a++ ))
do
echo "Số $a"
done > myfile.txt
echo "Hoàn thành."
```


* Nếu là chuỗi ký tự phải đặt trong ngoặc kép
* Vòng lặp cho file: `file="myfile" \ for var in $(cat $file)`
* Phân biệt trường đặc biệt: `IFS=$'\n'`, `IFS=:`
* Vòng lặp được chạy trong thư mục: `for file in /root/*`
* Vòng lặp ký tự số: for ((i = 0; i <= 5; i++))