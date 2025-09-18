#!/bin/bash
set -e

mkdir -p /var/run/vsftpd/empty

if ! id "$FTP_USER" >/dev/null 2>&1; then
    useradd -m "$FTP_USER"
    echo "$FTP_USER:$FTP_PASS" | chpasswd
fi

chown -R "$FTP_USER:$FTP_USER" /var/www/html

if [ ! -L "/home/$FTP_USER/wordpress" ]; then
    ln -s /var/www/html "/home/$FTP_USER/wordpress"
fi

exec vsftpd /etc/vsftpd.conf

