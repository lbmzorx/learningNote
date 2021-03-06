MySQL 存储过程是从 MySQL 5.0 开始增加的新功能。存储过程的优点有一箩筐。不过最主要的还是执行效率和SQL 代码封装。特别是 SQL 代码封装功能，如果没有存储过程，在外部程序访问数据库时（例如 PHP），要组织很多 SQL 语句。特别是业务逻辑复杂的时候，一大堆的 SQL 和条件夹杂在 PHP 代码中，让人不寒而栗。现在有了 MySQL 存储过程，业务逻辑可以封装存储过程中，这样不仅容易维护，而且执行效率也高。
一、MySQL 创建存储过程 
“pr_add” 是个简单的 MySQL 存储过程，这个存储过程有两个 int 类型的输入参数 “a”、“b”，返回这两个参数的和。
drop procedure if exists pr_add;
-- 计算两个数之和
create procedure pr_add
(
   a int,
   b int
)
begin
   declare c int;
   if a is null then
      set a = 0;
   end if;
   if b is null then
      set b = 0;
   end if;
   set c = a + b;
   select c as sum;
   /*
   return c;- 不能在 MySQL 存储过程中使用。return 只能出现在函数中。
    */
end;
二、调用 MySQL 存储过程 

注意时区
select now(); 查看mysql系统时间。和当前时间做对比
set global time_zone = '+8:00';设置时区更改为东八区
flush privileges; 刷新权限
需要高级权限

要使event起作用，MySQL的常量GLOBAL event_scheduler必须为on或者是1。
SHOW VARIABLES LIKE 'event_scheduler';
SET GLOBAL event_scheduler = 1;


call pr_add(10, 20);
执行 MySQL 存储过程，存储过程参数为 MySQL 用户变量。
set @a = 10;
set @b = 20;
call pr_add(@a, @b);
三、MySQL 存储过程特点 
创建 MySQL 存储过程的简单语法为：
create procedure 存储过程名字()
(
   [in|out|inout] 参数 datatype
)
begin
   MySQL 语句;
end;
MySQL 存储过程参数如果不显式指定“in”、“out”、“inout”，则默认为“in”。习惯上，对于是“in” 的参数，我们都不会显式指定。
1. MySQL 存储过程名字后面的“()”是必须的，即使没有一个参数，也需要“()”
2. MySQL 存储过程参数，不能在参数名称前加“@”，如：“@a int”。下面的创建存储过程语法在 MySQL 中是错误的（在 SQL Server 中是正确的）。 MySQL 存储过程中的变量，不需要在变量名字前加“@”，虽然 MySQL 客户端用户变量要加个“@”。
create procedure pr_add
(
   @a int,- 错误
   b int   - 正确
)
3. MySQL 存储过程的参数不能指定默认值。
4. MySQL 存储过程不需要在 procedure body 前面加 “as”。而 SQL Server 存储过程必须加 “as” 关键字。
create procedure pr_add
(
   a int,
   b int
)
as             - 错误，MySQL 不需要 “as”
begin
   mysql statement ...;
end;
5. 如果 MySQL 存储过程中包含多条 MySQL 语句，则需要 begin end 关键字。
create procedure pr_add
(
   a int,
   b int
)
begin
   mysql statement 1 ...;
   mysql statement 2 ...;
end;
6. MySQL 存储过程中的每条语句的末尾，都要加上分号 “;”
   ...
   declare c int;
   if a is null then
      set a = 0;
   end if;
   ...
end;
7. MySQL 存储过程中的注释。
   /*
     这是个
     多行 MySQL 注释。
  */
   declare c int;    - 这是单行 MySQL 注释 （注意- 后至少要有一个空格）
   if a is null then 这也是个单行 MySQL 注释
      set a = 0;
   end if;
   ...
end;
8. 不能在 MySQL 存储过程中使用 “return” 关键字。
   set c = a + b;
   select c as sum;
   /*
   return c;- 不能在 MySQL 存储过程中使用。return 只能出现在函数中。
  */
end;
9. 调用 MySQL 存储过程时候，需要在过程名字后面加“()”，即使没有一个参数，也需要“()”
call pr_no_param();
10. 因为 MySQL 存储过程参数没有默认值，所以在调用 MySQL 存储过程时候，不能省略参数。可以用 null 来替代。
call pr_add(10, null);

 
1，前提 
需要MySQL 5 

2，Hello World 
MySQL存储过程之Hello World 
Java代码 复制代码
DELIMITER $$   
  
DROP PROCEDURE IF EXISTS HelloWorld$$   
CREATE PROCEDURE HelloWorld()   
BEGIN   
    SELECT "Hello World!";   
END$$   
  
DELIMITER ;  


3，变量 
使用DECLARE来声明，DEFAULT赋默认值，SET赋值 
Java代码 复制代码
DECLARE counter INT DEFAULT 0;   
SET counter = counter+1;  


4，参数 
IN为默认类型，值必须在调用时指定，值不能返回（值传递） 
OUT值可以返回（指针传递） 
INOUT值必须在调用时指定，值可以返回 
Java代码 复制代码
CREATE PROCEDURE test(a INT, OUT b FLOAT, INOUT c INT)  


5，条件判断 
IF THEN、ELSEIF、ELSE、END IF 
Java代码 复制代码
DELIMITER $$   
  
DROP PROCEDURE IF EXISTS discounted_price$$   
CREATE PROCEDURE discunted_price(normal_price NUMERIC(8, 2), OUT discount_price NUMERIC(8, 2))   
BEGIN   
    IF (normal_price > 500) THEN   
        SET discount_price = normal_price * .8;   
    ELSEIF (normal_price > 100) THEN   
        SET discount_price = normal_price * .9;   
    ELSE   
        SET discount_price = normal_price;   
    END IF;   
END$$   
  
DELIMITER ;  


6，循环 
LOOP、END LOOP 
Java代码 复制代码
DELIMITER $$   
  
DROP PROCEDURE IF EXISTS simple_loop$$   
  
CREATE PROCEDURE simple_loop(OUT counter INT)   
BEGIN   
    SET counter = 0;   
    my_simple_loop: LOOP   
        SET counter = counter+1;   
        IF counter = 10 THEN   
            LEAVE my_simple_loop;   
        END IF;   
    END LOOP my_simple_loop;   
END$$   
  
DELIMITER ;  

WHILE DO、END WHILE 
Java代码 复制代码
DELIMITER $$   
  
DROP PROCEDURE IF EXISTS simple_while$$   
  
CREATE PROCEDURE simple_while(OUT counter INT)   
BEGIN   
    SET counter = 0;   
    WHILE counter != 10 DO   
        SET counter = counter+1;   
    END WHILE;   
END$$   
  
DELIMITER ;  

REPEAT、UNTILL 
Java代码 复制代码
DELIMITER $$   
  
DROP PROCEDURE IF EXISTS simple_repeat$$   
  
CREATE PROCEDURE simple_repeat(OUT counter INT)   
BEGIN   
    SET counter = 0;   
    REPEAT   
        SET counter = counter+1;   
    UNTIL counter = 10 END REPEAT;   
END$$   
  
DELIMITER ;  


7，异常处理 
如果用cursor获取SELECT语句返回的所有结果集时应该定义NOT FOUND error handler来防止存储程序提前终结 
如果SQL语句可能返回constraint violation等错误时应该创建一个handler来防止程序终结 

8，数据库交互 
INTO用于存储单行记录的查询结果 
Java代码 复制代码
DECLARE total_sales NUMERIC(8, 2);   
SELECT SUM(sale_value) INTO total_sales FROM sales WHERE customer_id=in_customer_id;  


CURSOR用于处理多行记录的查询结果 
Java代码 复制代码
DELIMITER $$   
  
DROP PROCEDURE IF EXITS cursor_example$$   
CREATE PROCEDURE cursor_example()   
    READS SQL DATA   
BEGIN   
    DECLARE l_employee_id INT;   
    DECLARE l_salary NUMERIC(8,2);   
    DECLARE l_department_id INT;   
    DECLARE done INT DEFAULT 0;   
    DECLARE cur1 CURSOR FOR SELECT employee_id, salary, department_id FROM employees;   
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;   
  
    OPEN cur1;   
    emp_loop: LOOP   
        FETCH cur1 INTO l_employee_id, l_salary, l_department_id;   
        IF done=1 THEN   
            LEAVE emp_loop;   
        END IF;   
    END LOOP emp_loop;   
    CLOSE cur1;   
END$$   
DELIMITER ;  


unbounded SELECT语句用于存储过程返回结果集 
Java代码 复制代码
DELIMITER $$   
DROP PROCEDURE IF EXISTS sp_emps_in_dept$$   
CREATE PROCEDURE sp_emps_in_dept(in_employee_id INT)   
BEGIN   
    SELECT employee_id, surname, firstname, address1, address2, zipcode, date_of_birth FROM employees WHERE department_id=in_employee_id;   
END$$   
  
DELIMITER ;  


UPDATE、INSERT、DELETE、CREATE TABLE等非查询语句也可以嵌入存储过程里
Java代码 复制代码
DELIMITER $$   
  
DROP PROCEDURE IF EXITS sp_update_salary$$   
CREATE PROCEDURE sp_update_salary(in_employee_id INT, in_new_salary NUMERIC(8,2))   
BEGIN   
    IF in_new_salary < 5000 OR in_new_salary > 500000 THEN   
        SELECT "Illegal salary: salary must be between $5000 and $500, 000";   
    ELSE   
        UPDATE employees SET salary=in_new_salary WHERE employee_id=in_employee_id;   
    END IF:   
END$$   
  
DELIMITER ;  


9，使用CALL调用存储程序 
Java代码 复制代码
DELIMITER $$   
  
DROP PROCEDURE IF EXISTS call_example$$   
CREATE PROCEDURE call_example(employee_id INT, employee_type VARCHAR(20))   
    NO SQL   
BEGIN   
    DECLARE l_bonus_amount NUMERIC(8,2);   
  
    IF employee_type='MANAGER' THEN   
        CALL calc_manager_bonus(employee_id, l_bonus_amount);   
    ELSE   
        CALL calc_minion_bonus(employee_id, l_bonus_amount);   
    END IF;   
    CALL grant_bonus(employee_id, l_bonus_amount);   
END$$   
DELIMITER ;  


10，一个复杂的例子 
Java代码 复制代码
CREATE PROCEDURE putting_it_all_together(in_department_id INT)   
    MODIFIES SQL DATA   
BEGIN   
    DECLARE l_employee_id INT;   
    DECLARE l_salary NUMERIC(8,2);   
    DECLARE l_department_id INT;   
    DECLARE l_new_salary NUMERIC(8,2);   
    DECLARE done INT DEFAULT 0;   
  
    DECLARE cur1 CURSOR FOR   
        SELECT employee_id, salary, department_id   
        FROM employees   
        WHERE department_id=in_department_id;   
  
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;   
  
    CREATE TEMPORARY TABLE IF NOT EXISTS emp_raises   
        (employee_id INT, department_id INT, new_salary NUMERIC(8,2));   
  
    OPEN cur1;   
    emp_loop: LOOP   
        FETCH cur1 INTO l_employee_id, l_salary, l_department_id;   
        IF done=1 THEN    /* No more rows */  
            LEAVE emp_loop;   
        END IF;   
        CALL new_salary(1_employee_id, l_new_salary); /* Get new salary */  
        IF (l_new_salary <> l_salary) THEN  /* Salary changed */  
            UPDATE employees   
                SET salary=l_new_salary   
            WHERE employee_id=l_employee_id;   
            /* Keep track of changed salaries */  
            INSERT INTO emp_raises(employee_id, department_id, new_salary)   
                VALUES (l_employee_id, l_department_id, l_new_salary);   
        END IF:   
    END LOOP emp_loop;   
    CLOSE cur1;   
    /* Print out the changed salaries */  
    SELECT employee_id, department_id, new_salary from emp_raises   
        ORDER BY employee_id;   
END;  


11，存储方法 
存储方法与存储过程的区别 
1，存储方法的参数列表只允许IN类型的参数，而且没必要也不允许指定IN关键字 
2，存储方法返回一个单一的值，值的类型在存储方法的头部定义 
3，存储方法可以在SQL语句内部调用 
4，存储方法不能返回结果集 
语法： 
Java代码 复制代码
CREATE   
    [DEFINER = { user | CURRENT_USER }]   
    PROCEDURE sp_name ([proc_parameter[,...]])   
    [characteristic ...] routine_body   
  
CREATE   
    [DEFINER = { user | CURRENT_USER }]   
    FUNCTION sp_name ([func_parameter[,...]])   
    RETURNS type   
    [characteristic ...] routine_body   
       
proc_parameter:   
    [ IN | OUT | INOUT ] param_name type   
       
func_parameter:   
    param_name type   
  
type:   
    Any valid MySQL data type   
  
characteristic:   
    LANGUAGE SQL   
  | [NOT] DETERMINISTIC   
  | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }   
  | SQL SECURITY { DEFINER | INVOKER }   
  | COMMENT 'string'  
  
routine_body:   
    Valid SQL procedure statement  

各参数说明见CREATE PROCEDURE and CREATE FUNCTION Syntax 
例子： 
Java代码 复制代码
DELIMITER $$   
  
DROP FUNCTION IF EXISTS f_discount_price$$   
CREATE FUNCTION f_discount_price   
    (normal_price NUMERIC(8,2))   
    RETURNS NUMERIC(8,2)   
    DETERMINISTIC   
BEGIN   
    DECLARE discount_price NUMERIC(8,2);   
  
    IF (normal_price > 500) THEN   
        SET discount_price = normal_price * .8;   
    ELSEIF (normal_price >100) THEN   
        SET discount_price = normal_price * .9;   
    ELSE   
        SET discount_price = normal_price;   
    END IF;   
  
    RETURN(discount_price);   
END$$   
  
DELIMITER ;  


12，触发器 
触发器在INSERT、UPDATE或DELETE等DML语句修改数据库表时触发 
触发器的典型应用场景是重要的业务逻辑、提高性能、监控表的修改等 
触发器可以在DML语句执行前或后触发 
Java代码 复制代码
DELIMITER $$   
  
DROP TRIGGER sales_trigger$$   
CREATE TRIGGER sales_trigger   
    BEFORE INSERT ON sales   
    FOR EACH ROW   
BEGIN   
    IF NEW.sale_value > 500 THEN   
        SET NEW.free_shipping = 'Y';   
    ELSE   
        SET NEW.free_shipping = 'N';   
    END IF;   
  
    IF NEW.sale_value > 1000 THEN   
        SET NEW.discount = NEW.sale_value * .15;   
    ELSE   
        SET NEW.discount = 0;   
    END IF;   
END$$   
  
DELIMITER ;  
 

一、语句

1、无结尾
ALTER TABLE `test_request_api_log_open ADD PARTITION` (
  PARTITION `p2018_02_07` VALUES LESS THAN (1517932800)
  );

2、含有结尾
ALTER TABLE `test_request_api_log_open ADD PARTITION` (
  PARTITION `p2018_02_07` VALUES LESS THAN (1517932800),
  PARTITION `p2018_02_14` VALUES LESS THAN (MAXVALUE)
  );


二、 事件

CREATE EVENT `NewEvent`
ON SCHEDULE EVERY 7 DAY STARTS '2018-01-25 1:00:00'
ON COMPLETION NOT PRESERVE
ENABLE
DO
CALL update_partition_add_last_day('test','test_ee',7);


## 日期相关
#
select last_day(curdate()); #获取本月最后一天

select date_add(curdate(), interval - day(curdate()) + 1 day); #获取本月第一天

select date_add(curdate() - day(curdate()) + 1, interval 1 month); #获取下个月第一天

select day(last_day(curdate())); #获取本月天数

select date_sub(curdate(), interval 1 month); #获取一个月前那一天

select datediff(curdate(), date_sub(curdate(), interval 1 month)); #获取当前时间与一个月之间的天数
#
#


-- ----------------------------
-- 一、 分区无最大值
-- 注意 分区时候分区字段一定是主键或者是唯一索引
-- 也就是 当存在primary key 时候，primary key里一定要有 该分区字段
-- 当存在 unique key 时候 ，unique key内一定有 该分区字段
-- Procedure structure for update_partition_add_last_day
-- ----------------------------
DROP PROCEDURE IF EXISTS `update_partition_add_last_day`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_partition_add_last_day`(IN databaseName varchar(40),IN tableName varchar(40),IN `date_add` int)
L_END:BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
START TRANSACTION;

SELECT REPLACE(PARTITION_NAME,'p','') INTO @LAST_PARTITION  
   FROM INFORMATION_SCHEMA.PARTITIONS  
   WHERE ( TABLE_SCHEMA=databaseName ) AND (TABLE_NAME = tableName ) 
   ORDER BY partition_ordinal_position DESC LIMIT 1;  
  
SELECT @LAST_PARTITION;

SET @NEXT_NAME=DATE_FORMAT(DATE_ADD(@LAST_PARTITION,INTERVAL `date_add` DAY),"%Y_%m_%d");
SELECT @NEXT_NAME;
SET @NEXT_TIMESTAMP=UNIX_TIMESTAMP(@NEXT_NAME);

SELECT @NEXT_TIMESTAMP;

SET @addpartition=CONCAT('ALTER TABLE ',tableName,' ADD PARTITION (PARTITION `p',@NEXT_NAME,'` VALUES LESS THAN ( ',@NEXT_TIMESTAMP,'))');
      /* 输出查看增加分区语句*/
      SELECT @addpartition;
      PREPARE stmt2 FROM @addpartition;
      EXECUTE stmt2;
      DEALLOCATE PREPARE stmt2;
COMMIT ;
end
;;
DELIMITER ;

-- ----------------------------
-- 二、分区含有最大值
-- Procedure structure for update_partition_rewrite_last_day
-- ----------------------------
DROP PROCEDURE IF EXISTS `update_partition_rewrite_last_day`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_partition_rewrite_last_day`(IN `databaseName` varchar(40),IN `tableName` varchar(40),IN `date_add` int)
BEGIN


DECLARE done INT DEFAULT 0; 
DECLARE PARTITION_NAME_LOOP VARCHAR(40);
DECLARE PARTITION_VALUE_LOOP INT;
DECLARE partition_alter LONGTEXT;


DECLARE count_partition INT;

DECLARE ALL_PARTITION CURSOR for 
    SELECT PARTITION_NAME,PARTITION_DESCRIPTION 
    FROM information_schema.PARTITIONS  
    WHERE TABLE_SCHEMA = `databaseName` AND TABLE_NAME = `tableName` 
    ORDER BY PARTITION_ORDINAL_POSITION ASC ;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;  


DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
START TRANSACTION;

SELECT PARTITION_NAME INTO @LAST_MAXVALUE FROM information_schema.PARTITIONS  
    WHERE TABLE_SCHEMA = `databaseName` AND TABLE_NAME = `tableName` 
    ORDER BY PARTITION_ORDINAL_POSITION DESC LIMIT 1;    

SET @LAST_MAXVALUE_DATE=REPLACE(@LAST_MAXVALUE,'p','');
SET @LAST_TIMESTAMP=UNIX_TIMESTAMP(@LAST_MAXVALUE_DATE);

SET partition_alter=CONCAT('ALTER TABLE ',`tableName` ,' PARTITION BY RANGE(add_time)(');

OPEN ALL_PARTITION;

emp_loop: LOOP  
        FETCH ALL_PARTITION INTO PARTITION_NAME_LOOP,PARTITION_VALUE_LOOP;

        IF @LAST_MAXVALUE=PARTITION_NAME_LOOP THEN
          SET partition_alter=CONCAT(partition_alter,' PARTITION `',PARTITION_NAME_LOOP,'` VALUES LESS THAN (',@LAST_TIMESTAMP,'),');
          
          SET @NEXT_PARTITION_NAME=DATE_FORMAT(DATE_ADD(@LAST_MAXVALUE_DATE,INTERVAL `date_add` DAY),"%Y_%m_%d");          

          SET partition_alter=CONCAT(partition_alter,' PARTITION `p',@NEXT_PARTITION_NAME,'` VALUES LESS THAN ( MAXVALUE ))');
          SET done=1;
        ELSE
          SET partition_alter=CONCAT(partition_alter,' PARTITION `',PARTITION_NAME_LOOP,'` VALUES LESS THAN (',PARTITION_VALUE_LOOP,'),');
        END IF;

        IF done=1 THEN  
             LEAVE emp_loop;  
        END IF;  
     END LOOP emp_loop;
CLOSE ALL_PARTITION;

SET @PARTITION_SENTENS=partition_alter;
PREPARE stmt_NAME FROM @PARTITION_SENTENS;
      EXECUTE stmt_NAME;
      DEALLOCATE PREPARE stmt_NAME;

COMMIT ;
END
;;
DELIMITER ;



# drop with datatime is int and sub partition with user_id
#

DROP PROCEDURE IF EXISTS `update_partition_sub_partition_add_last_day`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_partition_sub_partition_add_last_day`(IN databaseName varchar(40),IN tableName varchar(40),IN subcolumn varchar(40),IN hashnum INT,IN `date_add` int)
    L_END:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
    START TRANSACTION;

    SELECT REPLACE(PARTITION_NAME,'p','') INTO @LAST_PARTITION
    FROM INFORMATION_SCHEMA.PARTITIONS
    WHERE ( TABLE_SCHEMA=databaseName ) AND (TABLE_NAME = tableName )
    ORDER BY partition_ordinal_position DESC LIMIT 1;

    IF @LAST_PARTITION IS NULL THEN
      SET @LAST_PARTITION=UNIX_TIMESTAMP(date_add(curdate(), interval - day(curdate()) + 1 day));
    END IF ;
    SELECT @LAST_PARTITION;

    SET @NEXT_NAME=DATE_FORMAT(DATE_ADD(FROM_UNIXTIME(@LAST_PARTITION,"%Y_%m_%d"),INTERVAL `date_add` DAY),"%Y_%m_%d");
    SELECT @NEXT_NAME;
    SET @NEXT_TIMESTAMP=UNIX_TIMESTAMP(@NEXT_NAME);

    SELECT @NEXT_TIMESTAMP;

    SET @addpartition=CONCAT('ALTER TABLE ',tableName,' ADD PARTITION  SUBPARTITION  BY HASH(',subcolumn,') SUBPARTITIONS ',hashnum,' (PARTITION `p',@NEXT_NAME,'` VALUES LESS THAN ( ',@NEXT_TIMESTAMP,'))');
    /* 输出查看增加分区语句*/
    SELECT @addpartition;
    PREPARE stmt2 FROM @addpartition;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
    COMMIT ;
  end
;;
DELIMITER ;

-- -------------------------------------
-- 加分区，根据月 ，需要计算下一个月，因此时区要设置正确，另外要分区字段为Int类型
-- -------------------------------------
DROP PROCEDURE IF EXISTS `update_partition_add_month_with_int`;
DELIMITER ;;
CREATE PROCEDURE `update_partition_add_month_with_int`(IN databaseName varchar(40),IN tableName varchar(40),IN `month_add` int)
    L_END:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
    START TRANSACTION;

    SELECT REPLACE(PARTITION_NAME,'p','') INTO @LAST_PARTITION
    FROM INFORMATION_SCHEMA.PARTITIONS
    WHERE ( TABLE_SCHEMA=databaseName ) AND (TABLE_NAME = tableName )
    ORDER BY partition_ordinal_position DESC LIMIT 1;

    SELECT @LAST_PARTITION;

    SET @NEXT_NAME=DATE_FORMAT(DATE_ADD(@LAST_PARTITION,INTERVAL `month_add` MONTH),"%Y_%m_%d");
    SELECT @NEXT_NAME;
    SET @NEXT_TIMESTAMP=UNIX_TIMESTAMP(@NEXT_NAME);

    SELECT @NEXT_TIMESTAMP;

    SET @addpartition=CONCAT('ALTER TABLE ',tableName,' ADD PARTITION (PARTITION `p',@NEXT_NAME,'` VALUES LESS THAN ( ',@NEXT_TIMESTAMP,'))');
    /* 输出查看增加分区语句*/
    SELECT @addpartition;
    PREPARE stmt2 FROM @addpartition;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
    COMMIT ;
  end
;;
DELIMITER ;

-- --------------------------------
-- 加分区，根据日，，因此时区要设置正确，另外要分区字段为Int类型
-- --------------------------------
DROP PROCEDURE IF EXISTS `update_partition_add_day_with_int`;
DELIMITER ;;
CREATE PROCEDURE `update_partition_add_day_with_int`(IN databaseName varchar(40),IN tableName varchar(40),IN `day_add` int)
    L_END:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
    START TRANSACTION;

    SELECT REPLACE(PARTITION_NAME,'p','') INTO @LAST_PARTITION
    FROM INFORMATION_SCHEMA.PARTITIONS
    WHERE ( TABLE_SCHEMA=databaseName ) AND (TABLE_NAME = tableName )
    ORDER BY partition_ordinal_position DESC LIMIT 1;

    SELECT @LAST_PARTITION;

    SET @NEXT_NAME=DATE_FORMAT(DATE_ADD(@LAST_PARTITION,INTERVAL `day_add` DAY),"%Y_%m_%d");
    SELECT @NEXT_NAME;
    SET @NEXT_TIMESTAMP=UNIX_TIMESTAMP(@NEXT_NAME);

    SELECT @NEXT_TIMESTAMP;

    SET @addpartition=CONCAT('ALTER TABLE ',tableName,' ADD PARTITION (PARTITION `p',@NEXT_NAME,'` VALUES LESS THAN ( ',@NEXT_TIMESTAMP,'))');
    /* 输出查看增加分区语句*/
    SELECT @addpartition;
    PREPARE stmt2 FROM @addpartition;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
    COMMIT ;
  end
;;
DELIMITER ;

-- --------------------------
-- 每隔多少天加分区 注意分区字段为datetime型
-- --------------------------
DROP PROCEDURE IF EXISTS `update_partition_add_last_day_with_TO_DAYS`;
DELIMITER $$
CREATE  PROCEDURE `update_partition_add_last_day_with_TO_DAYS`(IN databaseName varchar(40),IN tableName varchar(40),IN `date_add` int)
    L_END:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
    START TRANSACTION;

    SELECT REPLACE(PARTITION_NAME,'p','') INTO @LAST_PARTITION
    FROM INFORMATION_SCHEMA.PARTITIONS
    WHERE ( TABLE_SCHEMA=databaseName ) AND (TABLE_NAME = tableName )
    ORDER BY partition_ordinal_position DESC LIMIT 1;

    SELECT @LAST_PARTITION;

    SET @NEXT_NAME=DATE_FORMAT(DATE_ADD(@LAST_PARTITION,INTERVAL `date_add` DAY),"%Y_%m_%d");
    SELECT @NEXT_NAME;
    SET @NEXT_TIMESTAMP=TO_DAYS(@NEXT_NAME);

    SELECT @NEXT_TIMESTAMP;

    SET @addpartition=CONCAT('ALTER TABLE ',tableName,' ADD PARTITION  (PARTITION `p',@NEXT_NAME,'` VALUES LESS THAN ( ',@NEXT_TIMESTAMP,'))');
    /* 输出查看增加分区语句*/
    SELECT @addpartition;
    PREPARE stmt2 FROM @addpartition;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
    COMMIT ;
  end
$$
DELIMITER ;

-- ---------------------
-- 加一个分区  注意分区字段为datetime型
-- ---------------------
DROP PROCEDURE IF EXISTS `update_partition_add_month_with_TO_DAYS`;
DELIMITER $$
CREATE  PROCEDURE `update_partition_add_month_with_TO_DAYS`(IN databaseName varchar(40),IN tableName varchar(40),IN `date_add` int)
    L_END:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
    START TRANSACTION;

    SELECT REPLACE(PARTITION_NAME,'p','') INTO @LAST_PARTITION
    FROM INFORMATION_SCHEMA.PARTITIONS
    WHERE ( TABLE_SCHEMA=databaseName ) AND (TABLE_NAME = tableName )
    ORDER BY partition_ordinal_position DESC LIMIT 1;

    SELECT @LAST_PARTITION;

    SET @NEXT_NAME=DATE_FORMAT(DATE_ADD(@LAST_PARTITION,INTERVAL `date_add` MONTH),"%Y_%m_%d");
    SELECT @NEXT_NAME;
    SET @NEXT_TIMESTAMP=TO_DAYS(@NEXT_NAME);

    SELECT @NEXT_TIMESTAMP;

    SET @addpartition=CONCAT('ALTER TABLE ',tableName,' ADD PARTITION  (PARTITION `p',@NEXT_NAME,'` VALUES LESS THAN ( ',@NEXT_TIMESTAMP,'))');
    /* 输出查看增加分区语句*/
    SELECT @addpartition;
    PREPARE stmt2 FROM @addpartition;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
    COMMIT ;
  end
$$
DELIMITER ;



-- ----------
-- 删除分区
-- ----------
DROP PROCEDURE IF EXISTS `drop_last_partition`;
DELIMITER $$
CREATE  PROCEDURE `drop_last_partition`(IN databaseName varchar(40),IN tableName varchar(40))
    L_END:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
    START TRANSACTION;

    SELECT PARTITION_NAME INTO @LAST_PARTITION
    FROM INFORMATION_SCHEMA.PARTITIONS
    WHERE ( TABLE_SCHEMA=databaseName ) AND (TABLE_NAME = tableName )
    ORDER BY partition_ordinal_position DESC LIMIT 1;

    SELECT @LAST_PARTITION;

    SET @addpartition=CONCAT('ALTER TABLE ',tableName,' DROP PARTITION ',@LAST_PARTITION);
    /* 输出查看增加分区语句*/
    SELECT @addpartition;
    PREPARE stmt2 FROM @addpartition;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
    COMMIT ;
  end
$$
DELIMITER ;
