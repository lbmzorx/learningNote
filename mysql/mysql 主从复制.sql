Lvs 负载均衡技术

授权
grant all on *.* to user@192.168.110.9 identified by "123";
查看授权用户
grant user,host,password from mysql.user;
查看某个用户权限
show grants for user1@192.168.110.9;

select user from mysql.user
select * from mysql.user where mysql.user.user="yzb"\G

grant privileges on yzbao.* to yzb@"192.168.%" identified by "1234569";
flush privileges;


mysql bin-log 日志
开启mysql bin-log日志
vi /etc/my.cnf
二进制日志，

[mysqld]
port=3306
socked=/var/lib/mysql/mysql.sock
log-show-queries=mysql-slow.log 超过10秒查询的查询语句就会被记录 
log-error=mysql.err 
log=mysql.log
log-bin=mysql-bin  

日志保存的位置
/usr/local/mysql/var/

从服务器通过复制bin-log日志就可以实现同步了

查看bin-log日志  增删改操作，可以恢复数据
通过mysql指令查看

mysql -u -p tests
select database();	
show tables;		查看表
show variables like "%bin%";	log_bin  ON  可以看见开启了log-bin

flush logs; 
-- 就会多一个最新的bin-log日志

show master status; 
查看最后一次的bin-log 日志
reset master;
清空所有日志

mysql > \s
显示字符集

退出mysql
运行 mysqlbinlog
查看二进制日志
mysqlbinlog --no-defaults mysql-00001.bin

truncate t1;
恢复数据

mysqlbinlog --no-defaults mysql-00001.bin | mysql -uroot -p123 test
这样就可以导入到mysql test数据库中了
恢复到指定位置,既可以通过位置position ,也可以通过日期
mysqlbinlog --no-default --stop-position="644"
						--start-position="50"
						--stop-date="2017-01-04 21:17:50"
						--start-date="2017-01-01 03:23:30"

备份数据 
mysqldump -uroot -pwei test -l -F >/tmp/test.sql
-F 即 flush logs重新生成bin-log日志 ,-l 锁定数据库，只能读，不能写

mysql -uroot -pwei test -v -f < /tmp/test.sql
-v 查看详细信息
-f 遇到错误忽略

开启log-bin日志，主从的service-id 值不能相同
my.cnf 
service-id=1
log-bin=mysql-bin

主服务器上设置读锁定有效，确保没有数据库操作，以便获得一个一致性的快照
mysql>flush tables with read lock;

主数据库备份完成后，主数据库可以恢复写操作

主从数据一致


1服务器备份，从服务器备份
mysqldump -uroot -p123 test -l -F > /tmp/test.sql
scp /tmp/test.sql 192.168.110.8:/tmp/		复制
从服务器 
清理一下日志
reset master;
show tables;

从服务器恢复数据
mysql -uroot -p123 test </tmp/test.sql

从服务器 配置
/etc/my.cnf

service-id = 2  唯一

注意从虚拟机复制过来的时候，数据目录下的auto.cnf还需要删掉，
否则会报uuid相同错误
	server-uuid=ed2e964f-ba5f-11e7-9782-000c298550df
	server-uuid=2e1232a8-c231-11e7-8a7c-0050563980cf


连接主服务器,5.1之后不支持这种操作了
master-host = 192.168.10.10  
master-user  =user1
master-password = 123
master-port = 3306

此时启动完数据库后，在从库上执行如下命令；
mysql -uroot -S/tmp/mysql.sock -p
change master to master_host='192.168.0.100', master_user='slave', master_password='******', master_log_file='mysql-bin.000010', master_log_pos=16860;
slave start;
执行:show  slave status\G;时看到的如下状态；
mysql> show slave status\G;

会出现 io_选项为off的现象，原因为service-uuid重复

重启
pkill mysqld 关闭
kill -9 pid号 

不对，mysqld 会重启 
正确的应该是
./mysqladmin -uroot -proot -P3306 -S/tmp/mysql.sock shutdown

ps -ef | grep mysqld  查看进程
/usr/local/mysql/bin/mysqld_safe --user=mysql &

!ps
执行上一次的ps
登录mysql
show tables;
show slave status\G 反转显示

Slave_IO_Running:Yes		从主服务器bin日志记录取回
Slave_SQL_Running:Yes		主服务器一句sql我就执行
Relay_Log_File:localhost-relay-bin.00004 从服务器的binlog日志
Connect_Retray:60 			60一次同步


lnmp 环境下 需要配置mysql.so 默认是没有的，安装
git clone https://github.com/php/pecl-database-mysql     mysql   --recursive

phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make
make install


<?php
//master mysql server
//if(mysql_connect("192.168.110.10","user9","123")){
//slave mysql server
if(mysql_connect("localhost","root","my730.+-")){
        echo "connect success";
        mysql_select_db("test");

        $sql="select * from t1";
        $rst=mysql_query($sql);
        while($row=mysql_fetch_assoc($rst)){
                echo "<pre>";
                print_r($row);
                echo "</pre>";
        }

}





windows 上

开启bin-log 日志
设置服务id
开启慢查询日志
建立yzbm数据库 作为主数据库
建立yzbs1数据库 作为从数据库

添加到系统服务

使用管理员身份
运行 
mysqld.exe install mysql2
mysqld.exe install 


查看端口占用情况

netstat -aon | findstr "3306"
查看任务
tasklist|findstr "2016"
如果原来有了卸载
sc delete MySQL[服务名称]

 mysql>  grant all privileges on yzbm.* to yzbm@localhost identified by '1234569';
 mysql>  grant all privileges on yzbs1.* to yzbs1@localhost identified by '1234569';

mysql> grant all privileges on yzbm.* to slave1@localhost identified by "1234569";


 主表
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000001 |      107 | yzb-m        | mysql            |
+------------------+----------+--------------+------------------+

mysql> change master to
    -> master_host="localhost",
    -> master_user="yzbm",
    -> master_password="1234569",
    -> master_log_file="mysql-bin.000002",
    -> master_log_pos=107,
    -> master_port=3306;
Query OK, 0 rows affected (0.35 sec)

mysql> start slave;
Query OK, 0 rows affected (0.00 sec)

show slave status\G;

change master to master_host="localhost",master_user="slave1",master_password="1234569",master_log_file="mysql-bin.000001",master_log_pos=107,master_port=3306;

change master to master_host="192.168.1.2",master_user="slave3",master_password="1234569",master_log_file="mysql-bin.000010",master_log_pos=23262,master_port=3306;



change master to master_host="192.168.1.88",master_user="slave1",master_password="1234569",master_log_file="mysql-bin.000194",master_log_pos=4828,master_port=3307;


       GRANT REPLICATION SLAVE ON
mysql> grant replication slave on yzbm.* to slave2@localhost identified by "1234569";
ERROR 1221 (HY000): Incorrect usage of DB GRANT and GLOBAL PRIVILEGES


不行,从服务器连接不上
全部授权
mysql>grant all on *.* to slave1@127.0.0.1 identified by "1234569";


| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000003 |      605 | yzb-m        | mysql            |


D:\phpStudy\MySQL\data\mysql-bin.000003



需要开启 my.ini中配置
log_slave_updates=1;



yii2 运行的特点 

1 有多个从服务器时候 会自动分配，并不是简单轮询，而是随机的
2 当有一个从服务器停掉的时候，会把任务交到另外还在运行的从服务器
3 当所有的从服务器都停掉的时候，会把查询任务交给主服务器
4 当停掉的从服务器重新启动之后，yii2不会立即把任务分配交给这个服务器，需要把runtime清理之后才会，或者等runtime缓存失效时间过了之后才会生效。



5 当配置是多个 主从时候，关于到底是用哪个服务器
yii2 给出的是用随机的方法
随机处理数据库配置
\yii\db\Connection openFromPool() 用随机的方法实现负载均衡 


6 多个主服务器的密码必须是一样的，也就是master_config ，从服务器也一样

 openFromPoolSequentially

7 master 崩溃不可用的时候，直接报错None of the master DB servers is available.



防火墙 编辑
/etc/sysconfig/iptables

添加
-A INPUT -p tcp -m tcp --dport 3307 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 3308 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 3309 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 3310 -j ACCEPT

service iptables restart


linux 添加进程端口 3307，3308，3309

配置文件分别为 my_m2,my_s1,my_s2 添加 服务id，二进制日志，
更新，慢查询记录，错误日志，
关键部位改动为 增加数据目录
启动脚本
开机启动


4个 mysql 服务 ，直接就爆满4G内存
top - 10:46:47 up  1:47,  1 user,  load average: 0.00, 0.00, 0.00
Tasks: 455 total,   1 running, 454 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.1%us,  0.1%sy,  0.0%ni, 99.8%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   3347496k total,  3224156k used,   123340k free,    36128k buffers
Swap:  3489784k total,        0k used,  3489784k free,  1555764k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2282 mysql     20   0 1193m  76m 5876 S  0.0  2.3   0:02.16 mysqld
 9219 mysql     20   0  745m  73m 4608 S  0.0  2.3   0:01.07 mysqld
 9854 mysql     20   0  745m  72m 4612 S  0.0  2.2   0:00.99 mysqld
13273 mysql     20   0  745m  79m 4644 S  0.0  2.4   0:00.81 mysqld