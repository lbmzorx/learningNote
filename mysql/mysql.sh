#!/bin/bash
#myslq.sh

nc -w2 localhost 3306
if [ $? -ne 0 ]
then
	echo "mysql's 3306 port is down,try restart now" | mail user1@g.cn -s "mysql is down" 
	#service mysqld restart
	/usr/local/mysql/bin/mysqld_safe --user=mysql &
	#/usr/local/apache2/bin/apachectl restart
fi