#!/bin/sh
# http://supervisord.org/subprocess.html?highlight=pidproxy#pidproxy-program
exec /usr/local/bin/pidproxy /var/run/mysqld/mysqld.pid /usr/bin/mysqld_safe 2>&1
