Day1-python
## Environments, Conda, Pip, aaaaah!
Chuỗi bài tự tìm hiểu Python, Mô tả một phương pháp hoạt động khá tốt. Một số các giải pháp tuyệt vời, nhưng nói chung đây là cách mà các lập trình viên khuyên dùng, đặc biệt là cho người mới bắt đầu.

Tổng quan ngắn gon về các chủ đề :
1. Python is great, but…
2. A way that works
3. A typical workflow
4. Round up
## 1. Python is great, but…
Như nhiều người khác, tôi thích python. Bạn có thể nhanh chóng dịch ý tượng của mình thành các giải pháp mã code có thể đọc được. Một lý do lớn khiến Python thành công như vậy là cộng đồng rất tích cực, trong đó những người tuyệt vời chia se các giải pháp tuyệt với của họ. Đây là lý do tại sao bạn không thể viết cấu trúc dữ liệu từ đầu, mà bạn chỉ import panda

Thật không may, mọi nỗ lực từ cộng đồng lớn đều phải trả giá. Các gói mà bạn sử dụng được cập nhật, tái cấu trúc, cải tiến hoặc viết lại, chỉ vì các tác giả đã nghĩ ra cách tốt hơn để giải quyết vấn đề của họ. Nhưng thay đổi này có thể có thể phá vỡ các thay đổi đối với code  mà bạn đã viết. Các gói phổ biến, chẳng hạn như Numpy hoặc Matplotlib rất đáng tin cậy và khả năng bạn nhận được các thay đổi phá hỏng là rất nhỏ. Tuy nhiên, việc sử dụng các gói không phổ biến, việc thay đổi có thể xảy ra, đặc biệt là khi nâng cấp gói hoặc chính Python.

Một cách, Cộng đồng Python đã giải quyết vấn đề này là cách sử dụng môi trường ảo. Chúng tạo ra các bản Python riêng biệt với bộ gói riêng của chúng. Thực hành tốt là có một môi trường duy nhất cho mỗi dự án hoặc nhiệm vụ. Điều này đảm bảo rằng các ohuj thược của một dự án sẽ không tạo ra các thay đổi đột phá cho dự án khác. Giải phapsp này hoạt động tuyệt với, nhưng cũng tạo ra một số sổ sách kế toán khi bạn có các ản cài đặt Python khác nhau, mỗi bản có thể đi kèm với một trình quản lý gói PIP của riêng mình. Tất cả các tham chiếu này trỏ Python hoặc PIP có thể tạo một mớ hỗn dọn khá nhanh chóng.

Như với tất cả mọi thứ trong Python, có nhiều các khác nhau để tổ chức điều này, bao gồm một số công cụ tuyệt vời như Poetry, Pipenv, và nhiều công cụ khác. Trong phần tiếp theo sẽ mô tả hệ thống mà lập trình viên đang sử dụng. Điều này hiệu quả đối với tôi và điều này cũng có thể hiệu quả với bạn.

## 2. A way that works- Cách hoạt động
Mặc dù có nhiều các để tổ chức các phiên bản Python, môi trường ảo và gói của bạn,
1. Conda cho Python và môi trường ảo
2. PIP để quản lý gói bên trong môi trường ảo.
### 2.1 Drop the gui and use a shell
Có lẽ có những giao diện người dùng đồ họa-graphical user interfaces (GUIs) đẹp và linh hoạt, tuy nhiên tôi thích dòng lệnh- Command line inteface hơn. Nó có kiểm soát nhiều hơn. Tôi khong chắc chắn điều đó có đúng không, nhưng ít nhất tôi nhận được xác nhận qua từng bước mà tôi đang làm. Có rất nhiều loại shell khác nhau để lựa chọn và nó thực sự không quan trọng lắm. Sử dụng cái bạn sẵn có là dễ nhất. Khi bạn dành nhiều thời gian hơn trong CLI, một ngày nào đó bạn có thể kén chọn hơn và chọn loại khác.

* Window có hai CLI khác nhau được cài đặt theo mặc định, Command line Prompt(cmd) và Window Powershell. Cả hai đều ổn, nhưng Powershell cho cảm giác shell nhiều hơn. Nếu bạn chưa bao giờ sử dụng CLI, có thể hưu ích khi xem hướng dẫn về powershell trên youtube.
* MacOS có bash mặc định (MacOS Catalina có ZSH ). Bạn có thể truy cập shell bằng ứng dụng terminal, Đây là một cách để tương tác với bash hoặc Zsh.
* Linux Người dùng có lẽ đã quen thuộc với shell. Ứng dụng shell và terminal nào được cài đặt, tùy thược vào bản phân phối mà bạn đã cài đặt. Nói chung là tất cả đều ổn, Hãy sử dụng những gì bạn có sẵn.
### 2.2 Cài đặt quản lý gói Conda
Bây giờ chúng ta đã quen thuộc vói shell, hãy lấy yêu cầu tiếp theo: Một bản phân phối Conda. Conda là một trình quản lý gọi phổ biến cho Python(và nhiều ngôn ngữ khác) và cung cấp cho bạn quyền truy cập vào thực tế vào tất cả phiên bản và gói Python. Nó bao gồm một hệ thống dễ dàng để quản lý các môi trường ảo. Trong khi conda có thể được sử dụng để cài các gói, tôi chỉ sử dụng nó cho các môi trường ảo và các phiên bản Python. Conda có một tính năng gọi là kiểm tra sự phụ thuộc, hoạt động khá tốt, nhưng đôi khi có thể hơi chậm. Ngoài ra, Một số gói được cập nhật nhiều hơn bằng cách sử dụng PIP và do đó tôi chỉ sử dụng PIP. Kết hợp cả hai có thể sẽ hiệu quả nhưng tốt hơn nếu sử dụng một công cụ duy nhất.

Thông thường, Conda được cài đặt bằng Anaconda, đây là một bản phân phối chính thức, bao gồm nhiều gói, công cụ và GUI. Nó cài đặt nhiều gói mà bạn có thể sẽ không sử dụng bao giờ và Gui thì sẽ hoạt động chậm. Tùy chọn khác để cài đặt conda là sử dụng Miniconda, một bản phân phối khác nhỏ hơn nhiều giống với tên gọi. Miniconda là một cài đặt cơ bản với hệ thống Python, pip, conda và một số công cụ khác. Trong quá trình cài đặt diễn ra thẳng, đây là một số dòng hướng dẫn đơn giản:
* Cài đặt trong thư mục chính của bạn **nếu và chỉ khi** bạn không có khoảng trắng trong đường dẫn đầy đủ, Ví dụ: nếu bạn có tên người dùng sủ dụng khoảng trắng, "Denis Huy", đường dẫn thư mục chính của bạn cũng sẽ chứa một khoảng trắng(/home/dennis Huy). Điều này có thể gây ra sự cố với một số gói vì không phải tất cả các lần nhập đều sử dụng dấu ngoặc kép xung quanh đường dẫn, bắt buộc đối với tên thư mục khoản trăng Nếu bạn tính cờ có khoảng trống trong thư mục, Hãy cài đặt miniconda ở vị trí khác.
    * Cài đặt: [tại trang chủ](https://docs.conda.io/en/latest/miniconda.html#linux-installers)
* Sau khi cài đặt miniconda, bạn có sẵn lệnh conda trong trình shell. Để kiểm tra, mở shell thực hiện lệnh `conda --version`. Nếu lệnh không được tìm thấy, đường dẫn đến miniconda phải được thêm vào biến path global.
* Đối với người dùng powershell, có một bước bổ sung cần được nhập vào powershell: `conda init powershell`

Trên là tất cả những gì có trong việc cài đặt các công cụ cần thiết để hoạt động với môi trường ảo python env.
## 3. A typical workflow- Quy trình làm việc điển hình
Miniconda đi kèm mà không có bất kỳ GUI nào do đó, điểm khởi đầu của bạn luôn là shell.

### 3.1 Tạo môi trường cho một dự án hoặc nhiệm vụ
Nếu bây giờ bạn mở một shell, bạn có sẵn Python, conda và pip mới cho việc cài đặt. Bạn có thể cài đặt các gói thẳng vào môi trường 'base' của mình, tuy nhiên, tôi thực sự không nên. Nếu bạn, vì lý do nào đó làm cho môi trường 'base' của bạn trở lên lộn xộn, thì không có cách nào để xóa nó. Các tùy chọn là cài đặt lại(thực sự không tệ như vậy) hoặc gỡ bỏ các gói bằng tay. Có thể có những thủ thuật, nhưng dễ dàng hơn nhiều là chỉ cần tạo môi trường ảo.

Tôi sẽ tạo ra một môi trường cho từng dự án hoặc nhiệm vụ, chỉ để giữ mọi thứ riêng biệt. Như đã đề cập trước đây, tôi tạo môi trường bằng conda:
```
conda create --name name-tutorial python=2.7
```
hoặc
```
conda create --name name-tutorial python=3.7
```
Điều này sẽ tạo ra một môi trường mới với tên **name-tutorial** và phiên bản Python. Bởi vì sử dụng 1 dấu =, yêu cầu conda sử dụng phiên bản mới nhất trong Python. Nếu sử dụng 2 dấu bằng '==', sẽ yêu cầu conda cung cấp chính xác phiên bản.

Sau khi môi trường được tạo, chúng ta phải chuyển sang môi trường mới được tạo. Đối với conda này có lệnh kích hoạt:
```
conda activate name-tutorial
```

Bây giờ bạn đang ở trong môi trường python bị cô lập có tên là 'name-tutorial' có phiên bản Python, conda và pip riêng. Có thể bạn không hoàn toàn chắc chắn về một môi trường đã tạo trước đó được gọi. Để kiểm tra các môi trường có sẵn, bạn luôn có thể sử dụng:
```
conda env list
(tutorial) [root@hd tutorial]# conda env list
# conda environments:
#
base                     /root/miniconda2
tutorial              *  /root/miniconda2/envs/tutorial
```

Lệnh trên cho thấy tất cả các môi trường có sẵn. Đây là những thu mục con bên trong thư mục miniconda của bạn. Môi trường hiện đang hoạt động được hiển thị với môi trường riêng biệt. Bây giờ hãy cài đặt một số gói trong môi trường.
### 3.2 Cài đặt các gói bằng pip
Trong môi trường đã kích hoạt của bạn, thật dễ dàng để thay đổi các gói bằng lệnh `pip install`. Đối với ví dụ này, chúng tôi sẽ cài đặt các gói numpy, pandas, jupyterlab, matplotlib. Mặc dù việc kiểm tra sự phụ thuộc của pip không phức tạp như conda, tuy nhiên, nó sẽ biết rằng pandas phụ thuộc vào nupy và sẽ cài đặt tệp phụ thuộc nếu nó bị thiếu. Để cài đặt loại gói:
```
pip install pandas matplotlib jupyterlab
```
Sau khi cài đặt, các gói đã sẵn sàng để sử dụng. Ví dụ để bắt đầu JupyterLab:
```
jupyter lab
```

Đôi khi nó xảy ra khi bạn làm việc trong một notebook, bot quên cài đặt một số gói đó. Ví dụ: Muốn sử dụng tqdm để có một số thanh tiến trình. Để cài đặt gói đó, hãy mở một trình shell khác kích hoạt env và sử dụng pip để cài đặt tqdm. Gói ngay lập tức sẵn sàng để sử dụng trong notebook bạn đang làm việc.

Hoặc cài đặt trực tiếp
```
(tutorial) [root@hd tutorial]# pip install tqdm
Collecting tqdm
  Downloading https://files.pythonhosted.org/packages/7a/ec/f8ff3ccfc4e59ce619a66a0bf29dc3b49c2e8c07de29d572e191c006eaa2/tqdm-4.61.2-py2.py3-none-any.whl (76kB)
     |████████████████████████████████| 81kB 2.1MB/s 
Installing collected packages: tqdm
Successfully installed tqdm-4.61.2
```


```
pip freeze > requirements.txt
```
Câu lệnh `pip freeze` cung cấp chính xác các gói được sử dụng. Khi sử dụng câu lệnh trên tất cả các gói đăng sử dụng trong dự án được làm đầu vào tiêu chuẩn cho file **requirements.txt**. Có thể dùng để tái tạo môi trường từ các dự án trước đó.

Nếu bạn mở tệp hoặc chạy tệp mà có requirements.txt, Bạn cung cấp tệp này  trong thư mục chính của dự án hoặc git-repo, những người khác có thể cài đặt tất cả các gói bắt buộc bằng một lệnh duy nhất:
```
pip install -r requirements.txt
```
Như bạn có thể thấy, tệp requirements.txt là một cách tuyệt vời để chia sẻ và tái tạo môi trường.
### 3.3 Xóa môi trường và các lệnh khác
Sau một thời gian, bạn sẽ thu thập được một số môi trường, có thể tạo ra một số lộn xộn bên trong hệ thống. Để xóa các môi trường không cần thiết nữa, chúng ta có thể xóa chúng một cách đơn giản. Nếu bạn yêu cầu nó một lần nữa, bằng cách sử dụng requirements.txt, rất dễ dàng để tạo lại môi trường. Trước khi chúng tôi có thể xóa một môi trường, chúng tôi phải hủy kích hoạt nó.
```
conda deactivate
```

Xóa một môi trường:
```
conda env remove --name name-tutorial
```

Để xác minh môi trường đã thực sự biến mất:
```
conda env list
```

Một số lệnh có thể hữu ích:
* Sao chép một môi trường hiện có:
```
conda create --clone tutorial --name tutorial2
```
* Tìm kiếm các gói có sẵn:
```
pip search tensorflow
```

## 4. Round up
Đây là nó để quản lý Pythons, ENVs, PIPs, và tất cả. Như đã đề cập trước đây, đây là một cách để làm điều đó và có nhiều cách khác. Các cách khác có thể hoạt động tốt hơn, nhưng cách này phù hợp với mọi người.