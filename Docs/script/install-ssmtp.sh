#!/bin/bash 

# Check OS
cat /etc/os-release* |grep 'ubuntu' > /dev/null 2>&1 && OS='Ubuntu'
cat /etc/os-release* |grep 'centos' > /dev/null 2>&1 && OS='CentOS' 

# install_mariadb
f_install_ssmtp(){
    if [ -e /usr/sbin/ssmtp ]
    then
        sta=1
        echo "SSMTP is installed" 
    else
        sta=0
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
    fi
    
}
f_conf_ssmtp(){
    cp /etc/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp-q.conf.bak

    if [ $smtpserver="" ]
    then 
        smtpserver=smtp.gmail.com
    fi 

    if [ $smtpport="" ]
    then 
        smtpport=587
    fi 
    echo "
root=$smtpuser
mailhub=smtp.gmail.com:587
AuthUser=$smtpuser
AuthPass=$smtppassword
UseTLS=YES
UseSTARTTLS=YES
rewriteDomain=gmail.com
FromLineOverride=YES
TLS_CA_File=/etc/pki/tls/certs/ca-bundle.crt
    " > /etc/ssmtp/ssmtp.conf

    echo " 
    root:$smtpuser:smtp.gmail.com:587
    " >> /etc/ssmtp/revaliases
    sleep 5
    
}
f_in_info_main(){
    read -p "SMTP server:(Enter for: smtp.gmail.com): " smtpserver
    read -p "SMTP Username (Ex: user@gmail.com): " smtpuser
    read -p "SMTP Password (password for $smtpuser): " smtppassword
    read -p "SMTP port:(Enter for: 587): " smtpport
}
main(){
    set -e
    f_in_info_main
    f_install_ssmtp
    if [ "$sta" == "0" ]
    then
        f_conf_ssmtp
        echo "Install thành công SSMTP."
    fi
}
main