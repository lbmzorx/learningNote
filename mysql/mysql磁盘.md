1. 查看实例下各个库磁盘使用量

```sql
use information_schema;

select TABLE_SCHEMA, concat(truncate(sum(data_length)/1024/1024/1024, 3),' GB') as data_size, 
                    concat(truncate(sum(index_length)/1024/1024/1024,3),'GB') as index_size 
                    from information_schema.tables 
                    group by TABLE_SCHEMA 
                    order by data_length desc; 
```

2. 查看单库各表的磁盘使用量


```sql
select TABLE_NAME, concat(truncate(data_length/1024/1024,2),' MB') as data_size,
concat(truncate(index_length/1024/1024,2),' MB') as index_size
from information_schema.tables where TABLE_SCHEMA = '库名'
group by TABLE_NAME
order by data_length desc;
```

3. 查看碎片情况

1. show status
```sql
show table status like "%表名%"
```

数据总大小 = Data_length + Index_length

实际表空间文件大小 = rows * Avg_row_length

碎片大小 = (数据总大小 - 实际表空间文件大小) / 1024 /1024 = 0.63MB

3.2 通过information_schema.tables的DATA_FREE列查看表有没有碎片：

```sql
SELECT t.TABLE_SCHEMA,
       t.TABLE_NAME,
       t.TABLE_ROWS,
       t.DATA_LENGTH,
       t.INDEX_LENGTH,
       concat(round(t.DATA_FREE / 1024 / 1024, 2), 'M') AS datafree
FROM information_schema.tables t
WHERE t.TABLE_SCHEMA = '库名'
```


4. 整理碎片

4.1 使用alter table table_name engine = innodb命令进行整理

4.2 optimize table 表名

该操作会锁表!!!
