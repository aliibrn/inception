#!/bin/bash
set -e

echo "[SETUP] Creating certs directory at $CERT_FOLDER ..."
mkdir -p $CERT_FOLDER

echo "[SETUP] Generating self-signed SSL certificate ..."
openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out $CERTIFICATE \
    -keyout $KEY \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$UNIT/CN=$COMMON_NAME"\
    -addext "subjectAltName = DNS:abbouram.42.fr,DNS:localhost"


echo "[SETUP] Setting permissions ..."
chmod 600 $KEY
chmod 644 $CERTIFICATE

echo "[SETUP] Preparing web root ..."
mkdir -p /var/www/html
echo "<h1>Welcome to Nginx HTTPS Container </h1>" > /var/www/html/index.html
chown -R www-data:www-data /var/www/html

echo "[SETUP] Done!"