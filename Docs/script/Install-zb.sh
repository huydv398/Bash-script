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


#Set LAMP
Set_LAMP(){
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo -e "\nIntalled HTTP ..... \n" && sleep 5
}


#Setup_initial 
Setup_C7(){
    yum update -y
    yum install chrony -y
    systemctl enable --now chronyd
    timedatectl set-timezone Asia/Ho_Chi_Minh
    timedatectl set-local-rtc 0
    hwclock --systohc
    hostnamectl set-hostname zabbix-srv
    yum install -y epel-release yum-utils
    yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
    yum-config-manager --enable remi-php72
    yum install -y php php-common php-opcache php-mcrypt php-cli php-gd php-curl php-mysqlnd
    systemctl disable firewalld
    systemctl stop firewalld
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
    echo -e ">>>\n Done Setup Initail...\n>>>" && sleep 5
}

# config_mariadb
install_mariadb(){

    echo -e "[mariadb]\nname = MariaDB\nbaseurl = http://yum.mariadb.org/10.4/centos7-amd64\ngpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB\ngpgcheck=1" >> /etc/yum.repos.d/MariaDB.repo
    sudo yum makecache fast
    yum -y install MariaDB-server MariaDB-client
    systemctl enable --now mariadb
    echo -e "\ny\ny\n$mysqlRootPass\n$mysqlRootPass\ny\ny\ny\ny\ny\n" | mysql_secure_installation


    echo -e "CREATE DATABASE $databasename CHARACTER SET UTF8 COLLATE UTF8_BIN;\nCREATE USER $username@$host IDENTIFIED BY '$userpassword';\nGRANT ALL PRIVILEGES ON $databasename.* TO $username@$host IDENTIFIED BY '$userpassword';\nFLUSH PRIVILEGES;\nexit" | mysql -u root -p$mysqlRootPass
    echo 
}


# Install_zb

config_zb(){
    rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
    yum clean all
    yum install -y zabbix-server-mysql zabbix-agent zabbix-get
    yum-config-manager --enable zabbix-frontend
    yum -y install centos-release-scl
    yum install -y centos-release-scl-rh
    yum install -y rh-php72-php-common
    yum -y install zabbix-web-mysql-scl zabbix-apache-conf-scl
    
    sed -i '11 d' /etc/yum.repos.d/zabbix.repo
    sed -i '10 a enabled=1' /etc/yum.repos.d/zabbix.repo

    sed -i '$ d' /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf
    sed -i '$ a php_value[date.timezone] = Asia/Ho_Chi_Minh' /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf
    
    zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -u$username -p$userpassword $databasename
    sed -i "s/# DBHost=localhost/DBHost=localhost/g; s/DBName=zabbix/DBName="$databasename"/g; s/DBUser=zabbix/DBUser="$username"/g; s/# DBPassword=/DBPassword="$userpassword"/g  " /etc/zabbix/zabbix_server.conf
    echo -e ">>>\nDone Setup Zabbix .....\n" && sleep 5
}


if [ "$OS"="CentOS" ]
then
    mysqlRootPass="P123@@123"
    databasename="zabbix"
    username="zabbix"
    userpassword="Pw123@@123"
    host="localhost"
    Set_LAMP
    Setup_C7
    install_mariadb
    config_zb
    systemctl restart zabbix-server zabbix-agent httpd rh-php72-php-fpm
    systemctl enable zabbix-server zabbix-agent httpd rh-php72-php-fpm
    systemctl restart httpd
<<<<<<< Updated upstream
    IP=$(hostname -I |  awk '{print $1}')
    hostname=$(hostname)
    echo -e "Access link http://$IP/zabbix.\nInfomation:\nDatabase port: 3306\nDatabase name: $databasename\nUser: $username\nPassword: $userpassword\nZabbix Name: $hostname\nLogin: Admin/zabbix"
=======
<<<<<<< HEAD
    echo -e "Truy cập theo đường dẫn http://ip-address/zabbix. \nRồi thực hiện cấu hình với các thông in sau.\nDatabase port: 3306\nDatabase name: zabbix\nUser: zabbix\n Password: Pw123@@123\n\nZabbix Name: zabbix-srv\nHoàn thành..."
    echo -e "Thông tin đăng nhập: Admin/zabbix"
=======
    IP=$(hostname -I |  awk '{print $1}')
    hostname=$(hostname)
    echo -e "Access link http://$IP/zabbix.\nInfomation:\nDatabase port: 3306\nDatabase name: $databasename\nUser: $username\nPassword: $userpassword\nZabbix Name: $hostname\nLogin: Admin/zabbix"
>>>>>>> 8ea5524929089b030e543f039f6525e6eee0d8dd
>>>>>>> Stashed changes
fi
