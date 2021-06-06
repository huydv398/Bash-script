# Signals and Background Tasks
## Linux singals - Tín hiệu Linux
* SHIGUP: Nếu bash nhận được tín hiệu SHIGUP thì khi bạn đóng Terminal thì nó sẽ gửi đến tất cả các chương trình đang chạy và đóng nó lại
* SHIGNT: Tín hiệu này dùng để tạm dùng công việc
## Sending signals to scripts 
* **Terminal the process** Khi bạn gõ ctrl + c thì nó sẽ gửi một tín hiệu SHIGNT nó sẽ dừng các chương trình đang chạy.
* Temporarily stoping the process : Khi bạn gõ crl + z thì sẽ gửi một tín hiệu SHIGNT nó sẽ tạm dừng các chương trình đang chạy. Một quá trình như thế còn trong bộ nhớ và có thể tiếp tục chạy lệnh shell

```
[root@1data huydv]# sleep 100
^Z
[2]+  Stopped                 sleep 100
```
Số trong ngoặc vuông là số công việc mà shell gắn cho quá trình. Shell gắn với các quá trình chạy trong đó là những công việc được đánh số duy nhất. 

Bạn có thể xem các tác vụ bị tạm ngưng với lệnh sau: `ps -l`

```
[root@1data huydv]# ps -l
F S   UID    PID   PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
4 S     0  34308   1755  0  80   0 - 28887 do_wai pts/4    00:00:00 bash
0 T     0  35678  34308  0  80   0 - 28322 do_sig pts/4    00:00:00 bash.sh
0 T     0  35679  34308  0  80   0 - 27014 do_sig pts/4    00:00:00 sleep
0 R     0  35681  34308  0  80   0 - 38332 -      pts/4    00:00:00 ps
```
Nếu bạn muốn chấm dứt quá trình đang tạm dừng bạn có thể sử dụng câu lệnh `kill`

`kill [ProcessID]`

## Intercept signals
Để bật theo dõi tín hiệu linux trong script, ta có thể dùng lệnh `trap`.

Nếu script nhận được tín hiệu chỉ định ra gọi lệnh này, nó sẽ tự xử lý nó, và shell sẽ không sử lý tín hiệu như thế.

```
#!/bin/bash
trap "echo ' Trapped Ctrl-C'" SIGINT
echo This is a test script
count=1
while [ $count -le 10 ]
do
echo "Loop #$count"
sleep 1
count=$(( $count + 1 ))
done
```

Output:
```
[root@1data huydv]# ./bash.sh 
This is a test script
Loop #1
Loop #2
Loop #3
^C Trapped Ctrl-C
Loop #4
Loop #5
Loop #6
Loop #7
^C Trapped Ctrl-C
Loop #8
Loop #9
Loop #10
```
Ở đây ta gắn mỗi tổ hợp ctrl + c thì nó sẽ tạo ra một tín hiệu SHIGNT và script này chỉ dùng lại khi chạy hết shell không can thiệp vào quá trình này.

## Intercepy the script exit signal
```
#!/bin/bash
trap "echo Goodbye..." EXIT
count=1
while [ $count -le 5 ]
do
echo "Loop #$count"
sleep 1
count=$(( $count + 1 ))
done
```
output:
```
[root@1data huydv]# ./bash.sh 
Loop #1
^Z
[3]+  Stopped                 ./bash.sh
[root@1data huydv]# ./bash.sh 
Loop #1
Loop #2
Loop #3
Loop #4
Loop #5
Goodbye...
```
Khi nhận được tín hiệu exit thì nó sẽ dừng luôn script và không thực hiện nữa.

## Sửa đổi các tín hiệu bị đánh chặn và hủy bỏ việc đánh chặn
Để hủy tín hiệu mà ta đã gán ta có thể sử dụng lệnh `trap --SIGINT`. Trong đó SHIGNT là tín hiệu mà ta đã gắn.
```
#!/bin/bash
trap "echo 'Ctrl-C is trapped.'" SIGINT
count=1
while [ $count -le 5 ]
do
echo "Loop #$count"
sleep 1
count=$(( $count + 1 ))
done
trap "echo ' I modified the trap!'" SIGINT
count=1
while [ $count -le 5 ]
do
echo "Second Loop #$count"
sleep 1
count=$(( $count + 1 ))
done
```

Output:
```
[root@1data huydv]# ./bash.sh 
Loop #1
Loop #2
Loop #3
^CCtrl-C is trapped.
Loop #4
Loop #5
Second Loop #1
Second Loop #2
Second Loop #3
^C I modified the trap!
Second Loop #4
Second Loop #5
^C I modified the trap!
```

##  Thực thi các tập lệnh dòng lệnh trong nền
Khi chúng ta muốn chạy script và muốn làm thêm nhiều việc nữa thì ta để script chạy trong nền và không hiển thị ra

Để làm được điều này thì ta thêm dấu `&` vào sau lệnh script
```
#!/bin/bash
count=1
while [ $count -le 10 ]
do
sleep 1
count=$(( $count + 1 ))
done
```

```
[root@1data huydv]# ./bash.sh &
[4] 35803
```

## Khởi động lại tiến trình đã tạm dừng
* Để restart script mà ta đã dừng khi ctrl + z thì ra có thể sử dụng câu lệnh `bg`
* Để khởi động lại nhiệm vụ trong chế độ bình thường, hãy sử dụng `fg`

## Đặt thời gian để thực thi lệnh
Ta có thể hẹn giờ để chạy lệnh như cron tab

`at [ -f filename ] time`
* Tiêu chuẩn xác định ngày giờ được viết trên mẫu  MMDDYY, MM/DD/YY hoặc DD.MM.YY.
* now, noonm, midnight.
    * now + 25 minutes
    * 1-:15PM tomorrow
    * 10:15 + 7 days.

## Xóa tác vụ
Để xóa tác vụ cần xử lý ta có thể dùng lệnh `atrm` và kèm theo thứ tự của tác vụ đó.

` atrm 1 `

