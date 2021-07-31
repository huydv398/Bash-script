* CGI Scripts
* Select keyword
* When to use eval


## 1 CGI Scripts
### 1.1 Request Method: GET
Khá dễ dàng để gọi một CGI-Script thông qua GET. Trước tiên, bạn sẽ cần url được mã hóa của tệp lệnh.

Sau đó, bạn thêm một dấu chấm hỏi:? theo sau là các biến.
* Mọi biến phải có hai phần cách nhau bởi `=.`. Phần đầu tiên phải luôn là một tên duy nhất cho mỗi biến, phần thứ hai chỉ có các giá trị trong đó
* Các biến được phân tách bằng `&`
* Tổng độ dài các chuỗi không được vượt quá 255 ký tự
* Tên và giá trị cần được mã hóa html(thay thế: `</,/?:@&=+$`), gợi ý:
    * Khi sử dung html-form, request method có thể được tạo ra bởi chính nó.
    * Với Ajax, bạn có thể mã hóa tất cả thông qua **encodeURL** và **encodeURIComponent**

## 2 Select Keyword
Select Keyword có thể được sử dụng để lấy đối số đầu vòa ổ định dạng menu.
### Chọn từ khóa có thể được sử dụng để lấy đầu vào đối số trong một định dạng menu.
Giả sử dụng bạn muốn người dụng SELECT từ khóa từ một menu, có thể tạo một tập lệnh tương tự như:
```
#!/usr/bin/env bash
select os in "linux" "windows" "mac"
do
    echo "${os}"
    break
done
```
Output:
```
[root@hd ~]# ./helloname.sh 
1) linux
2) windows
3) mac
#? 1
linux
[root@hd ~]# ./helloname.sh 
1) linux
2) windows
3) mac
#? 3
mac
```
Ở đây **SELECT keyword** được sử dụng đẻ lặp qua danh sách các mục sẽ được trình bày trong lệnh nhăc người dùng chọn từ. Lưu ý **break keyword** để thoát ra khỏi vòng lặp khi người dùng thực hiện sự lựa chọn. Sau khi chọn, giá trị sẽ được hiển thị và quay lại dấu nhăc lệnh.
## 3 Khi nào sử dụng eval
Đầu tiên và quan trọng nhất: biết bạn đang làm gì. Thứ 2, trong khi bạn nên tránh sử dụng eval, nếu việc sử dụng nó làm cho mã gọn hơn, hãy tiếp tục
### 3.1 Sử dụng Eval
Ví dụ: hãy xem xét điều sau đây đặt nội dung của $@ thành nội dung cửa một biến nhất định: 
```
a=(1 2 3)
eval set -- "${a[@]}"
```
Code này thường đi kèm với `getopt` hoặc `getopts` để đặt $@ thành đầu ra của trình phân tích cú pháp tùy chọn nói trên, tuy nhiên, bạn cũng có thể sử dụng nó để tạo một hàm **pop** đơn giản có thể hoạt đọng trên các biến:
```
#!/usr/bin/env bash
isnum(){
    #Có phải là một số nguyên không?
    local re='^[0-9]+$'
    if [[ -n $1 ]]; then
        [[ $1 =~ $re ]] && return 0 && echo yes
        return 1
    else
        return 2
    fi
}
isvar(){
    if isnum "$1"; then
        return 1
    fi
    local arr="$(eval eval -- echo -n "\$$1")"
    if [[ -n ${arr[@]} ]]; then
        return 0
    fi
        return 1
}
pop(){
    if [[ -z $@ ]]; then
        return 1
    fi
    local var=
    local isvar=0
    local arr=()

    if isvar "$1"; then # Kiểm tra đây có phải là một biến hay một mảng trống
        var="$1"
        isvar=1
        arr=($(eval eval -- echo -n "\${$1[@]}")) # nếu là var, hãy lấy nội dung của nó
    else
        arr=($@)
    fi

    # Chúng ta cần đảo ngược nội dung $@ để có thể thay đổi
    # Phần tử cuối cùng thành rỗng
    arr=($(awk <<<"${arr[@]}" '{ for (i=NF; i>1; --i) printf("%s ",$i); print $1; }'
    # đặt $@ thành ${arr[@]} để chúng tôi có thể thay đổi nó.
    eval set -- "${arr[@]}"

    shift # loại bỏ phần tử cuối cùng

    # đặt mảng trở lại thứ tự ban đầu
    arr=($(awk <<<"$@" '{ for (i=NF; i>1; --i) printf("%s ",$i); print $1; }'

    # echo các nội dung vì lợi ích của người dùng và các mảng trống
    echo "${arr[@]}"
    if ((isvar)); then
    # Đặt nội dung của var thành mảng mới được sửa đổi
        eval -- "$var=(${arr[@]})"
    fi
}
```
### 3.2 Sử dụng Eval với Getopt
Mặc dù eval có thể không cần thiết cho một hàm pop like, tuy nhiên, nó là bắt buộc bất cú khi nào bạn sử dụng getopt:

Hãy xem xét hà sau chấp nhận -h như một tùy chọn:

```
f()
{
    local __me__="${FUNCNAME[0]}"
    local argv="$(getopt -o 'h' -n $__me__ -- "$@")"
    eval set -- "$argv"

    while :; do
        case "$1" in
            -h)
                echo "LOLOLOLOL"
                return 0
                ;;
            --)
                shift
                break
                ;;
    done

    echo "$@"
}
```
