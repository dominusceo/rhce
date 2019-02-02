#!/bin/bash
yum install -y expect
expect certificados.exp classroom.example.com  example.com
yum install -y vsftpd ftp
cp -vap /etc/vsftpd/vsftpd.conf{,.rpmori}
cat vsftpd-classroom.conf > /etc/vsftpd/vsftpd.conf
systemctl enable vsftpd && systemctl start vsftpd
firewall-cmd --add-service=ftp 
firewall-cmd --add-service=ftp --permanent
firewall-cmd --reload
echo "Configuration of LDAP users"
usuarios-classroom.sh
