#!/bin/bash 
# Check OS
cat /etc/os-release* |grep 'ubuntu' > /dev/null 2>&1 && OS='Ubuntu'
cat /etc/os-release* |grep 'centos' > /dev/null 2>&1 && OS='CentOS' 

# Khai báo mật khẩu của mysql_root
# upasswd='Password'


# Đường dẫn mà bạn muốn đặt các file backup
#src_folder='source'
src_folder='backup'
if [ -e $src_folder]
then 
    mkdir -p /backup2021-v1
    src_folder=backup2021-v1
else    
    sleep 1
fi
# list database.
echo 'show databases;' | mysql -u root > /tmp/listdb

# Backup folder user chứa code
f_backup_code(){
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
                    echo -e "Backup code Cpanel folder: $src_Code "
                    zip -r file $src_Code > /dev/null 2>&1
                    mv -i *.zip /$src_folder/$Username/"code-$(date "+%H%M%d%m%Y")".zip 
                    echo -e "Backup Done. Folder $src_Code.\n"
                else
                    echo -e "Backup Folder. $Username thư mục $Home_dir"  
                    zip -r file $Home_dir > /dev/null 2>&1 && mv -i file* /$src_folder/$Username/"code-$(date "+%H%M%d%m%Y")".zip
                    echo -e "Backup done $Home_dir \n"
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

f_backup_code