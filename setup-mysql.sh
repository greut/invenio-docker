#!/bin/bash
set -v
set -o pipefail
IFS=$'\n\t'

if [[ ! -d /var/lib/mysql/mysql ]]; then
    mysql_install_db > /dev/null 2>&1
fi

cd /usr ; /usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "Waiting for MySQL..."
    sleep 2
    mysql -u root -e "status" > /dev/null 2>&1
    RET=$?
done


echo "MySQL root: password: ${MYSQL_PASS}"
mysqladmin -u root password ''
mysql -u root -e "CREATE USER 'admin'@'%' IDENTIFIED BY '${MYSQL_PASS}'"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"

mysqladmin -u root shutdown
