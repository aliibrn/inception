#!/bin/sh

set -e

echo "Starting script ..." 

adduser -D -h /ftp ${FTP_USER}
echo "user creds : ${FTP_USER}:${FTP_PASS}" 
echo "${FTP_USER}:${FTP_PASS}" | chpasswd

chmod 777 /ftp
chown -R ${FTP_USER}:${FTP_USER} /ftp

echo "Starting FTP server ..."

vsftpd /etc/vsftpd/vsftpd.conf
