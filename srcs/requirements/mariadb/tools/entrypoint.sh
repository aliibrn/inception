#!/bin/bash
set -e

# Check if database is already initialized
if [ ! -d "/var/lib/mysql/$DB_DATABASE" ]; then
    
    echo "Initializing MariaDB database..."
    
    # Initialize system database if needed
    if [ ! -d "/var/lib/mysql/mysql" ]; then
        mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    fi
    
    # Start MariaDB temporarily for setup
    mysqld_safe --user=mysql &
    MYSQL_PID=$!
    
    # Wait for MariaDB to be ready
    until mysqladmin ping >/dev/null 2>&1; do
        echo "Waiting for MariaDB to start..."
        sleep 1
    done
    
    # Secure installation and create database/user
    mysql -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_ROOT_PASSWORD');"
    mysql -u root -p"$DB_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User='';"
    mysql -u root -p"$DB_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    mysql -u root -p"$DB_ROOT_PASSWORD" -e "DROP DATABASE IF EXISTS test;"
    mysql -u root -p"$DB_ROOT_PASSWORD" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    mysql -u root -p"$DB_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`$DB_DATABASE\`;"
    mysql -u root -p"$DB_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
    mysql -u root -p"$DB_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON \`$DB_DATABASE\`.* TO '$DB_USER'@'%';"
    mysql -u root -p"$DB_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
    
    # Stop temporary MariaDB
    mysqladmin -u root -p"$DB_ROOT_PASSWORD" shutdown
    wait $MYSQL_PID
    
    echo "MariaDB initialization completed."
fi

echo "Starting MariaDB daemon..."

# Start MariaDB daemon in foreground
exec mysqld --user=mysql --console