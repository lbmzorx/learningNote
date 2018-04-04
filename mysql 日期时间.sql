mysql 日期时间
https://www.cnblogs.com/wenzichiqingwa/archive/2013/03/05/2944485.html
1.1 获得当前日期+时间（date + time）函数：now()
1.2 获得当前日期+时间（date + time）函数：sysdate()
	可以sleep(3)比较结果
	now() 在执行开始时值就得到了， sysdate() 在函数执行时动态得到值。
2. 获得当前日期（date）函数：curdate();
3. 获得当前时间（time）函数：curtime()
4. 获得当前 UTC 日期时间函数：utc_date(), utc_time(), utc_timestamp()
因为我国位于东八时区，所以本地时间 = UTC 时间 + 8 小时。UTC 时间在业务涉及多个国家和地区的时候，非常有用。

转换成时间戳

unix_timestamp(date);
from_timetime(unix_timestamp,format);
unix_timestamp(),
unix_timestamp(date),
from_unixtime(unix_timestamp),
from_unixtime(unix_timestamp,format)


3. MySQL 时间戳（timestamp）转换、增、减函数：

timestamp(date)                                     -- date to timestamp
timestamp(dt,time)                                  -- dt + time
timestampadd(unit,interval,datetime_expr)           --
timestampdiff(unit,datetime_expr1,datetime_expr2)   --

请看示例部分：

select timestamp('2008-08-08');                         -- 2008-08-08 00:00:00
select timestamp('2008-08-08 08:00:00', '01:01:01');    -- 2008-08-08 09:01:01
select timestamp('2008-08-08 08:00:00', '10 01:01:01'); -- 2008-08-18 09:01:01
select timestampadd(day, 1, '2008-08-08 08:00:00');     -- 2008-08-09 08:00:00
select date_add('2008-08-08 08:00:00', interval 1 day); -- 2008-08-09 08:00:00

MySQL timestampadd() 函数类似于 date_add()。

select timestampdiff(year,'2002-05-01','2001-01-01');                    -- -1
select timestampdiff(day ,'2002-05-01','2001-01-01');                    -- -485
select timestampdiff(hour,'2008-08-08 12:00:00','2008-08-08 00:00:00');  -- -12

select datediff('2008-08-08 12:00:00', '2008-08-01 00:00:00');           -- 7

MySQL timestampdiff() 函数就比 datediff() 功能强多了，datediff() 只能计算两个日期（date）之间相差的天数。