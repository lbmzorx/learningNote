--一、 基本数据库

DROP TABLE IF EXISTS `test_request_api_log_open`;
CREATE TABLE `test_request_api_log_open` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` int(11) DEFAULT NULL COMMENT '应用id',
  `app_status` tinyint(1) DEFAULT NULL,
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `koufei` decimal(11,3) NOT NULL DEFAULT '0.000' COMMENT '扣费',
  `url` varchar(255) DEFAULT NULL COMMENT '请求地址',
  `params` varchar(500) DEFAULT NULL COMMENT '请求的参数',
  `ip` varchar(50) DEFAULT NULL COMMENT '用户ip',
  `info` varchar(50) DEFAULT NULL COMMENT '备注',
  `interface_english_name` varchar(255) DEFAULT NULL COMMENT '接口的英文名',
  `interface_id` int(11) DEFAULT NULL COMMENT '接口id',
  `sys_status` tinyint(1) DEFAULT '0' COMMENT 'api系统级调用状态0失败，1成功',
  `status` tinyint(1) DEFAULT '0' COMMENT '服务级（业务级）状态码0失败、1成功',
  `response` varchar(500) DEFAULT NULL,
  `code` varchar(20) DEFAULT '0',
  `add_time` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16385 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;



二、添加索引
-- 普通索引 默认
ALTER TABLE `yzb_request_api_log_open`
ADD INDEX (`user_id`) ;

ALTER TABLE `yzb_request_api_log_open`
ADD INDEX (`user_id`, `interface_id`) ;
-- 唯一索引 哈希
ALTER TABLE `yzb_request_api_log_open`
ADD INDEX (`user_id`, `interface_id`) ,
ADD UNIQUE INDEX (`status`) USING HASH ;
-- 综合
ALTER TABLE `yzb_request_api_log_open`
ADD INDEX `user_i` (`user_id`, `interface_id`) ,
ADD UNIQUE INDEX `status` (`status`) USING HASH ,
ADD INDEX `uid_add` (`user_id`, `add_time`) USING BTREE ;

-- 删除
ALTER TABLE `test_request_api_log_open`
DROP INDEX `app_id`;


-- 三、添加主键
ALTER TABLE `yzb_request_api_log_open`
DROP PRIMARY KEY,
ADD PRIMARY KEY (`id`);

-- 本来是可以为空的要改为不为空
ALTER TABLE `yzb_request_api_log_open`
MODIFY COLUMN `code`  varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' AFTER `response`,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`id`, `add_time`, `code`);



select user_id,count(`user_id`),app_id,count(`app_id`),interface_id,count(`interface_id`) from yzb_request_api_log_open group by user_id;


user_id | count(`user_id`) | 
+---------+------------------+
|       2 |          1717023 |

 user_id | count(`user_id`) | app_id | count(`app_id`) | interface_id | count(`interface_id`) |
+---------+------------------+--------+-----------------+--------------+-----------------------+
|       2 |            32091 | 100000 |           32091 |            2 |                 32091 |
|       2 |          1684836 | 100000 |         1684836 |            6 |               1684836 |
|       2 |               30 | 100001 |              30 |           14 |                    30 |
|       2 |                1 | 100002 |               1 |           24 |                     1 |
|      16 |                1 | 100003 |               1 |            2 |                     1 |
|       2 |                2 | 100004 |               2 |           22 |                     2 |
|       2 |               52 | 100005 |              52 |           23 |                    52 |
|       2 |                9 | 100006 |               9 |           34 |                     9 |
|       2 |                2 | 100007 |               2 |           35 |                     2 |

#1717025
#啥也不加	 加add_time主键		user_id索引	 app_id索引	 interface_id索引	add_time索引(最优)	
#45.34,44.89 	29.06,28.94			46.46 		36.37 		24.90 				0.0
SELECT
 (
 	SELECT count(*) 
 	FROM `yzb_request_api_log_open` 
 	WHERE (app_id=a.app_id and interface_id=i.id) AND (`add_time` >= 1516636800) AND (`add_time` <= 1516723199) AND (`status`=1)
 	) as success_num,
 (
 	SELECT count(*) FROM `yzb_request_api_log_open` 
 	WHERE (app_id=a.app_id and interface_id=i.id) AND (`add_time` >= 1516636800) AND (`add_time` <= 1516723199)
 	) as count_num, `i`.`name`, `i`.`id` 
 FROM `yzb_interface` `i` 
 inner join `yzb_api_app_open` `a` ON i.service_id=a.service_id 
 WHERE `a`.`app_id`='100000'

#啥也不加	 加add_time主键		user_id索引	 app_id索引	interface_id索引	add_time索引(最优)
#7.54,7.52	 4.84,4.86			9.70 			6.23	 	7.11 				0.0

SELECT c.success_num as success_num,c.count_num as count_num, `i`.`id`, `i`.`name` 
FROM `yzb_interface` `i` 
inner join `yzb_api_app_open` `a` ON i.service_id=a.service_id 
left join (SELECT count(*) count_num, SUM(CASE status WHEN 1 THEN 1 ELSE 0 END) as success_num, `r`.`interface_id` 
	FROM `yzb_request_api_log_open` `r` 
	WHERE ((`r`.`user_id`=2) AND (`r`.`app_id`='100000')) AND (`r`.`add_time` >= 1516636800) AND (`r`.`add_time` <= 1516723199) 
	GROUP BY `r`.`interface_id`) `c` 
ON c.interface_id=i.id 
WHERE `a`.`app_id`='100000'



-- 五、自动化任务

-- 开启


-- 2、分区存过如下
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


删除分区

ALTER TABLE `test_ee` DROP PARTITION p2018_01_17, p2018_01_31, p2018_02_07, p2018_02_12, p2018_02_17 ;

删除表的所有分区:
Alter table emp removepartitioning;--不会丢失数据

二、 事件

-- 开启事件
-- 查看事件是否开启
show variables like '%event_scheduler%';
-- 开启事件
set global event_scheduler=1;

CREATE EVENT `NewEvent`
ON SCHEDULE EVERY 7 DAY STARTS '2018-01-25 1:00:00'
ON COMPLETION NOT PRESERVE
ENABLE
DO
CALL update_partition_add_last_day('test','test_ee',7);


-- ----------------------------
-- 一、 分区无最大值
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



 解释
声明异常处理的语法 详细https://www.cnblogs.com/datoubaba/archive/2012/06/20/2556428.html

DECLARE
{EXIT | CONTINUE}
HANDLER FOR
{error-number | SQLSTATE error-string | condition}
SQL statement
上述定义包括：

Handler Type （CONTINUE,EXIT）//处理类型 继续或退出
Handler condition （SQLSTATE,MYSQL ERROR,CONDITION）//触发条件
Handler actions（错误触发的操作）

注意：
1、exit只退出当前的block。exit 意思是当动作成功提交后，退出所在的复合语句。即declare exit handler for... 所在的复合语句。
2、如果定义了handler action，会在continue或exit之前执行
发生错误的条件有：
1、MYSQL错误代码
2、ANSI-standard SQLSTATE code
3、命名条件。可使用系统内置的SQLEXCEPTION,SQLWARNING和NOT FOUND


使用游标
http://blog.csdn.net/huang1004943336/article/details/52122451

使用事件
http://blog.csdn.net/u013755987/article/details/52294656