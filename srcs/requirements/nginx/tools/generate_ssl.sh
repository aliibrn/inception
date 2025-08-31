#!/bin/bash

set -e

# # Build arguments for certificate generation
CERT_FOLDER=/etc/nginx/certs
CERTIFICATE=/etc/nginx/certs/server.crt
KEY=/etc/nginx/certs/server.key
COUNTRY=MA
STATE=Marrakesh-Safi
LOCALITY=Benguerir
ORGANIZATION=42Network
UNIT=Student
COMMON_NAME=abbouram.42.fr

mkdir -p ${CERT_FOLDER} && \
    openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out ${CERTIFICATE} \
    -keyout ${KEY} \
    -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${UNIT}/CN=${COMMON_NAME}"

# set proper permissions
chmod 600 ${KEY}
chmod 644 ${CERTIFICATE}

mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html
