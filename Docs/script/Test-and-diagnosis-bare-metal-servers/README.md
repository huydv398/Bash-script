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
* 
## Storage

`cat /proc/meminfo |grep MemFree | awk '{print $2-1024}'`k 5
