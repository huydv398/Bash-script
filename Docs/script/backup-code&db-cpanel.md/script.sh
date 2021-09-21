#!/bin/bash 
# Check OS
cat /etc/os-release* |grep 'ubuntu' > /dev/null 2>&1 && OS='Ubuntu'
cat /etc/os-release* |grep 'centos' > /dev/null 2>&1 && OS='CentOS' 

# Timenow
DATE_EXEC="$(date "+%d/%m/%Y %H:%M")"
# IP Address
IP=$(hostname -I)

# Khai báo mật khẩu của mysql_root
# upasswd='Password'
upasswd=''
# Thông tin telegram
chat_id_tele=''
api_tele=''
to_email=''

MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump
# Đường dẫn mà bạn muốn đặt các file backup
src_folder=''
f_create_folder(){
    if [ -e $src_folder]
    then 
        mkdir -p /backup2021-v1
        
        src_folder=backup2021-v1
    fi
}
mkdir -p /$src_folder/log
# list database.
echo 'show databases;' | mysql -u root > /tmp/listdb

# Backup folder user chứa code
f_backup_code(){
    # list database.
    Count_user=1
    echo 'show databases;' | mysql -u root > /tmp/listdb
    while read info;
    do
        Username=$(echo $info | awk -F: '{print $1}')
        ID_user=$(echo $info | awk -F: '{print $3}')
        Home_dir=$(echo $info | awk -F: '{print $6}')
        src_Code="$Home_dir/public_html"
        Bk_fol="/$src_folder/$Username"
        
        if [[ $ID_user -ge 1000 ]];
            # then
            # echo $Username
            # echo User$Total_user: $Username
            
            
            then
                # echo $Username $ID_user $Home_dir $src_Code $Bk_fol
                if [ -e $Bk_fol ]
                then
                    echo -e "Sao lưu dữ liệu vào thư mục $Bk_fol."
                else
                    mkdir -p $Bk_fol
                fi
                
                if [ -e $src_Code ]
                then
                    echo User$Count_user: $Username
                    echo -e "Backup code Cpanel folder: $src_Code "
                    zip -r file $src_Code > /dev/null 2>&1
                    size=$(du -b file.zip | awk '{print $1}')
                    mv -i *.zip /$src_folder/$Username/"code-$(date "+%H%M%d%m%Y")".zip 
                    echo -e "Backup Done. Folder $src_Code.\n"
                    echo $size
                    ((Total_user=Total_user+1))
                    ((size_file=size_file+$size))
                fi
                f_backup_db
                
        fi  
        
    done < /etc/passwd
}


# Backup full all-databse 
f_backup_db(){
    while read dbname
    do
        mkdir -p /tmp/bk_db > /dev/null 2>&1
        U1=$(echo $dbname | awk -F_ '{print $1}')
        if [[ $U1 == $Username ]]
        then
            echo -e "Backup Database: $dbname."
            mysqldump -u root -p$upasswd $dbname >  /tmp/bk_db/file.sql > /dev/null 2>&1
            zip -q /tmp/bk_db/file.sql.zip /tmp/bk_db/file.sql
            mv -i /tmp/bk_db/*.zip /$src_folder/$Username/"db-$dbname-$(date "+%H%M%d%m%Y")".sql.zip
            rm -rf /tmp/bk_db/* > /dev/null 2>&1
            echo -e "Backup Database $dbname. \n"
        fi

    done < /tmp/listdb
}
f_alert_main(){
    subject_email="Backup DONE. $IP. $DATE_EXEC"
    content=$( echo -e "Tổng số User được backup: $Total_user \nDung lượng backup (Byte): $size_file")
    {
        echo "Subject: $subject_email"
        echo $content
    } | ssmtp $to_email
    curl -s -X POST "https://api.telegram.org/$api_tele/sendMessage" -d chat_id=$chat_id_tele -d text="Subject: $subject_email 
    $content"
}
f_alert(){
    curl -s -X POST "https://api.telegram.org/$api_tele/sendMessage" -d chat_id=$chat_id_tele -d text="$1"
}
f_check(){
    if [ -e $upasswd ]
    then 
        echo 'Biến $upasswd Trống. Đặt mật khật mysql root vào biến'
    fi
    if [ -e $chat_id_tele ]
    then 
        echo 'Biến $chat_id_tele Trống. Dùng để gửi cảnh báo về telegram'
    fi
    if [ -e $api_tele ]
    then 
        echo 'Biến $api_tele Trống. API_telegram dùng để gửi thông khi backup xong về telegram'
    fi
    if [ -e $to_email ]
    then 
        echo 'Biến $to_email Trống. Biến là địa chỉ Email người dùng muốn gửi thông báo backup đến người dùng'
    fi
    if [ -e $upasswd ]
    then 
        echo 'Biến $upasswd Trống'
    fi
}
main(){
    f_alert "Start backup "
    start=`date +%s.%N`
    set -e
    f_check
    echo "Done check"
    f_create_folder
    echo "Done check 1"
    f_backup_code
    echo "Done check 2"
    if [ $? != 0 ]
    then 
        echo Error!!!
    fi
    end=`date +%s.%N`
    runtime=$( echo "$end - $start" | bc -l )
    runtime1=$(cut -c-4 <<< "$runtime")
    f_alert "Back up Done: $DATE_EXEC. Tổng thời gian thực hiện $runtime1  giây"
}
main 2>&1 | tee /$src_folder/log/"log-$(date "+%Y%m%d%H%M")".txt
