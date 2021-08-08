#!/bin/bash 
# Check OS
cat /etc/os-release* |grep 'ubuntu' > /dev/null 2>&1 && OS='Ubuntu'
cat /etc/os-release* |grep 'centos' > /dev/null 2>&1 && OS='CentOS' 
# ID Telegram
USER_ID="USER_ID_edit"
#API Token
TOKEN="TOKEN_edit"
#URL send message API
ULR_Mess="https://api.telegram.org/bot$TOKEN/sendMessage"
# IP Address
IP=$(hostname -I)
# EMAIL 
TO_MAIL='To_email_edit'
# mpstat lấy info cpu
if [ -e /usr/bin/mpstat ]
then
    echo "Get Infomation ..."
else
    f_install_mpstat
fi
f_install_mpstat(){
    if [ "$OS" == "CentOS" ]
    then
        yum install -y mpstat

    elif [ "$OS" == "Ubuntu" ]
    then
       sudo apt-get install sysstat
    else
        echo "OS none supported"
    fi
}
# Thời gian hệ thống
DATE_EXEC="$(date "+%d %b %Y %H:%M")"

#Performance
INFO=$(mpstat | head -n 1)
TOTAL=$(free -m | grep Mem | awk '{print $2}')
USED=$(free -m | grep Mem | awk '{print $3}')
FREE=$(free -m | grep Mem | awk '{print $4}')
CPU_USer=$( mpstat | grep all | awk '{print $4}')
CPU_Kernel=$( mpstat | grep all | awk '{print $6}')
CPU_FREE=$( mpstat | grep all | awk '{print $13}')
DISK=$(df -h /)

# Tạo thông tin Performance
TEXT=$( echo -e "Thời gian: $DATE_EXEC\n\nInformation Host: $OS-$IP \n$INFO \n\nInfo RAM:\nMemory Total: $TOTAL MB \nMemory Used: $USED MB\nMemory Free: $FREE MB\n\nInfo CPU\nUser used: $CPU_USer %\nSystem used: $CPU_Kernel%\nKhông tải: $CPU_FREE%\n\nInfo Disk\n$DISK"  )

# Gửi thông tin về tele và gamil
curl -s -X POST "$ULR_Mess" -d chat_id=$USER_ID -d text="$TEXT"> /dev/null

{
    echo "Subject: Performance $OS-$IP: $DATE_EXEC"
    echo "$TEXT"
} | ssmtp $TO_MAIL
