#!/bin/bash 

# Check OS
cat /etc/os-release* |grep 'ubuntu' > /dev/null 2>&1 && OS='Ubuntu'
cat /etc/os-release* |grep 'centos' > /dev/null 2>&1 && OS='CentOS' 
echo $OS

if [ -d /var/lib/mysql ]
then
    yum -y remove mariadb mariadb-server 
    rm -rf /var/lib/mysql  
fi
Install_C7(){
    yum install -y httpd epel-release php php-opcache php-mysql yum-utils epel-release mariadb mariadb-server php-gd
    rpm -Uvh https://rpms.remirepo.net/enterprise/remi-release-7.rpm
    systemctl start httpd
    systemctl enable httpd
    systemctl start mariadb
    systemctl enable mariadb
    yum update epel-release -y
    yum-config-manager --enable remi-php73
}
# Install_C7

config_wp(){
    wget http://wordpress.org/latest.tar.gz -y
    tar xvfz latest.tar.gz
    rm -rf  /var/www/html/*
    cp -Rvf /root/wordpress/* /var/www/html
    cd /var/www/html
    cp wp-config-sample.php wp-config.php
    sed -i -e "s/database_name_here/"$databasename"/g; s/username_here/"$username"/g; s/password_here/"$userpassword"/g; s/localhost/$host/g  " /var/www/html/wp-config.php
    chmod -R 755 /var/www/*
    chown -R apache:apache /var/www/*
    systemctl restart httpd
}
# config_wp

install_mariadb(){
    echo -e "\ny\n$mysqlRootPass\n$mysqlRootPass\ny\ny\ny\ny\ny\n" |mysql_secure_installation --stdin
    mysql -u root -p$mysqlRootPass<<EOF 
    CREATE DATABASE $databasename;
    CREATE USER $username@$host IDENTIFIED BY '$userpassword';
    GRANT ALL PRIVILEGES ON $databasename.* TO $username@$host IDENTIFIED BY '$userpassword';
    FLUSH PRIVILEGES;
    exit
EOF
}
# install_mariadb

if [ "$OS"="CentOS" ]
then
        
    read -p "Nhập mật khẩu cho mysqlroot: " mysqlRootPass
    read -p "Nhập tên cho Database: " databasename
    read -p "Nhập Database username: " username
    read -p "Nhập Database password username: " userpassword
    read -p "Nhập MatiaDB host: (Enter for localhost):" host

    if [ "$host" = "" ]
    then 
    host="localhost"
    fi
    Install_C7
    config_wp
    install_mariadb  
fi
