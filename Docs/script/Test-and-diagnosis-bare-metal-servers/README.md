# Test and diagnosis bare metal servers

Kiểm tra và chuẩn đoán bare metal servers

Điểm đầu tiên, chúng tôi có một máy chủ không có người giám sát, nó trở thành trạng thái miễn phí hoặc chúng tôi nhận được thiết bị mới từ nhà cung cấp. Thường sẽ là máy chủ. Hệ thống tự động khởi động máy chủ thông qua PXE với nhân linux và bắt đầu tệp lệnh chuẩn đoán. Script kiểm tra tình trạng của mọi thành phần (CPU, RAM, Storage, NET) và kiểm tra hiệu suất của toàn bộ máy chủ.

## CPU
* Kiểm tra tình trạng quá nhiệt của CPU
* Kiểm tra CPU có ổn định không

Để có thể sử dụng mprime-bin thực hiện các bước cài đặt sau để có thể sử dụng:

* Thực hiện tải và giải nén:
```
cd ~ && mkdir mprime
cd mprime
wget http://www.mersenne.org/ftp_root/gimps/p95v303b6.linux64.tar.gz
tar -zxvf p95v303b6.linux64.tar.gz 
```

Đối với CPU Stress, Chúng tôi chạy chương trình mprime-bin, và chạy nó trong vòng 30 phút.
```
/usr/bin/timeout 30m /foleder/mprime -t 
/bin/grep -i error /root/result.txt
```
Mỗi phút kiểm tra nhiệt độ CPU. Nhiệt độ CPU cho phép nhỏ hơn 60*C. Ngoài ra, bạn cần kiểm tra tệp /proc/kmsg và nprime results.txt để biết một số lỗi CPU phức tạp.

* `/proc/kmsg` được sử dụng để chứa các thông báo do kernel tạo ra. Sau đó, các thông báo sẽ được các chương trình khác chọn, chẳng hạn như `sbin.klog` hoặc `/bin/dmesg`.
## RAM - Memtester

Kiểm tra bộ nhớ từ cấp hệ thống hoạt động, không kiểm tra tất cả các ô RAM. Đó là điểm yếu trong các tiếp cận của chúng tôi. 
* Cài đặt memtester:
```
wget http://pyropus.ca/software/memtester/old-versions/memtester-4.2.2.tar.gz
tar zxvf memtester-4.2.2.tar.gz
cd memtester-4.2.2
make && make install
```

Bạn có thể chạy chương trình như sau:
```
memtester [MEMORY] [ITERATIONS]
```
* Khi đó:
    * MEMORY: Dung lượng bộ nhớ để phân bổ kiểm tra, tính bằng megabytes
    * ITERATIONS: Số lần lặp lại. Mặc định là vô hạn

Exit-code của memtester là 0 khi mọi thứ hoạt động bình thường. Nếu không, nó sẽ có các giá trị như sau:
* x01: Lỗi phân bổ, lỗi khóa memory hoặc lỗi yêu cầu khẩn cấp
* x02: Lỗi khi kiểm tra bị kẹt
* x03: Lỗi trong một trong các kiểm tra khác

Ví dụ:
```
memtester `cat /proc/meminfo |grep MemFree | awk '{print $2-1024}'`k 5
```
* Lấy ra dung lượng ram còn trống để thực hiện test và được tính bằng kb(kilobytes)
* `5`: thực hiện lặp lại kiểm tra 5 lần.

Output:
```
[root@centos7 ~]# memtester `cat /proc/meminfo |grep MemFree | awk '{print $2-1024}'`k 5
memtester version 4.2.2 (64-bit)
Copyright (C) 2010 Charles Cazabon.
Licensed under the GNU General Public License version 2 (only).

pagesize is 4096
pagesizemask is 0xfffffffffffff000
want 890MB (934072320 bytes)
got  890MB (934072320 bytes), trying mlock ...locked.
Loop 1/5:
  Stuck Address       : ok
  Random Value        : ok
  Compare XOR         : ok
  Compare SUB         : ok
  Compare MUL         : ok
  Compare DIV         : ok
  Compare OR          : ok
  Compare AND         : ok
  Sequential Increment: ok
  Solid Bits          : ok
  Block Sequential    : ok
  Checkerboard        : ok
  Bit Spread          : ok
  Bit Flip            : ok
  Walking Ones        : ok
  Walking Zeroes      : ok
  8-bit Writes        : ok
  16-bit Writes       : ok

Loop 2/5:

```

Hiện thị Exit-code của trình memtester bằng lệnh( nó là 0 thì mọi thứ bình thường):
```
$ echo $?
```

Output:
```

```


## Storage
Tra cứu các disk đã được cài đặt theo bash.

Tìm bất kỳ thiết bị nào tại `/dev/sd?`, và kiểm tra mọi phần tử có phải là disk không.

```
hdlist() {
    
  HDLIST=$(ls /dev/sd?)
  HDLIST="${HDLIST} $(ls /dev/cciss/c0d? 2>/dev/null)"
  REAL_HDLIST=""
  for disk in ${HDLIST}; do
    if head -c0 ${disk} 2>/dev/null; then
      REAL_HDLIST="${REAL_HDLIST} ${disk}"
    fi
  done
  echo "${REAL_HDLIST}"
}
```


## HDD
Xóa hoàn toàn mọi dữ liệu trong HĐ từ khách hàng cũ:
```
for DISK in $(hdlist)
  do
    echo "Clearing ${DISK}"
    parted -s ${DISK} mklabel gpt
    dd if=/dev/zero of=${DISK} bs=512 count=1
  done
  if [ "($FULL_HDD_CLEAR)" = "YES" ]; then
  echo "Clearing disks full (very slow)"
  wget -O /dev/null -q --no-check-certificate "${STATEURL}&info=slowhddclear"
  for DISK in $(hdlist)
  do
    echo "Clearing ${DISK}"
    dd if=/dev/zero of=${DISK} bs=1M
  done
  fi

```

## Kiểm tra các giá trị thông minh
* 
sysctl -w vm.drop_caches=3 > /dev/null
zcav -c 1 -s ${SKIP_COUNT} -r ${OFFSET} -l /tmp/zcav1.log -f ${DISK}
if [ $? -ne 0 ]; then
        echo err
        exit
fi
SPEED=$(cat /tmp/zcav1.log | awk '! /^#/ {speed+=$2; count+=1}END{print int(speed/count)}')
* zcav -c 1 -s ${SKIP_COUNT} -r ${OFFSET} -l /tmp/zcav1.log -f ${DISK}
    * `zcav`: Chương trình kiểm tra thông lượng ổ cứng
    * `-c count`: Số lần đọc ghi toàn bộ đĩa.
    * `[-s skip-rate]`: -s 10- Nó sẽ đọc mọi block đến thứ 10 và bỏ qua phần còn lại.
    * `-r`: Phạm vi dữ liệu tính bằng Meg để đọc ghi trên mỗi lần vượt qua(mặc định là toàn bộ thiết bị). Hữu ích nếu bạn muốn nhanh chóng kiểm tra một phần của ổ đĩa lớn. Nếu một số được đưa ra thì đó là khối cuối cùng để đọc, nếu 2 số thì đó là đầu và cuối của một dải. Giá trị được tính bằng megs, nhưng chúng được làm tròn xuống kích thước khối.
    * `-l /tmp/zcav1.log`: Đường dẫn lưu log
    * `-f`: tên tệp cho dữ liệu đầu vào. 
    zcav -c 1 -s 10 -l /tmp/zcav1.log -f /dev/sda