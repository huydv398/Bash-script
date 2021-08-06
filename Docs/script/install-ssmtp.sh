#!/bin/bash 

# Check OS
cat /etc/os-release* |grep 'ubuntu' > /dev/null 2>&1 && OS='Ubuntu'
cat /etc/os-release* |grep 'centos' > /dev/null 2>&1 && OS='CentOS' 

if [ -e /usr/sbin/ssmtp ]
then
    sta=1
    echo "SSMTP is installed" 
else
    sta=0
fi
# install_mariadb
f_install_ssmtp(){
    if [ "$OS" == "CentOS" ]
    then
        echo "Install SSMTP for: "$OS
        yum install epel-release -y
        yum update -y
        yum install -y ssmtp

    elif [ "$OS" == "Ubuntu" ]
    then
        echo $OS
        apt-get update
        apt install ssmtp -y
    else
        echo "OS none supported"
    fi
}
f_conf_ssmtp(){
    cp /etc/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf.bak
    read -p "SMTP server:(Enter for: smtp.gmail.com): " smtpserver
    read -p "SMTP Username (Ex: user@gmail.com): " smtpuser
    read -p "SMTP Password (password for $smtpuser): " smtppassword
    read -p "SMTP port:(Enter for: 587): " smtpport
    if [ $smtpserver="" ]
    then 
        smtpserver=smtp.gmail.com
    fi 

    if [ $smtpport="" ]
    then 
        smtpport=587
    fi 
    echo -e "root=$smtpuser\nmailhub=smtp.gmail.com:587\nAuthUser=$smtpuser\nAuthPass=$smtppassword\nUseTLS=YES\nUseSTARTTLS=YES\nrewriteDomain=gmail.com\nFromLineOverride=YES\nTLS_CA_File=/etc/pki/tls/certs/ca-bundle.crt" > /etc/ssmtp/ssmtp.conf

    echo " 
    root:$smtpuser:smtp.gmail.com:587
    " >> /etc/ssmtp/revaliases
}
main(){
    set -e
    if [ "$sta" == "0" ]
    then
        f_install_ssmtp
        f_conf_ssmtp
        echo "Install thành công SSMTP."
    fi
}
f_conf_ssmtp_e(){
    cp /etc/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp-"`date +"%d%m%Y%H%M"`".conf.bak
    f_conf_ssmtp
    cat /etc/ssmtp/ssmtp.conf | egrep -v '^$|^#'
}
while getopts ':eh' opt
#Đưa ra: loại bỏ ngay từ đầu các lỗi không hợp lệ
do
case "$opt" in
    'e')
        f_conf_ssmtp_e #Nếu có opt là -e thì thực hiện lệnh này luôn
        ;;
    # 'h'|'--help')
    #     echo "Install SSMTP ..."&& sleep 5  #Nếu có opt là -v thì thực hiện lệnh này luôn
    #     ;;
esac
done
