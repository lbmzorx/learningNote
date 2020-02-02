binlog_row_image = minimal			#默认full ,mimimal 可以减小二进制日志时间

binlog_cache_size = 256KB           #128KB 不够大再加大
eq_range_index_dive_limit=200       #10  200推荐值 in()操作时候多数情况下是超过10个数据的

ft_min_word_len =1 					#中文索引推荐1

innodb_autoinc_lock_mode = 2    # 原本1，2性能上会高很多，缺点：id值不是连续的	

innodb_ft_min_token_size = 1    # 全文索引单词最小长度，推荐1，默认3


#如CPU是2颗8核的，那么可以设置：
# innodb_read_io_threads = 8
# innodb_write_io_threads = 8


###查询参数
```
query_cache_type = 1    //开启查询 
```


###问题
连接池与连接中的线程问题，到底是一个连接池一个线程还是一个连接一个线程，一个连接(池)对应多个线程

一个连接池是一个线程，一个连接也是一个线程，

###查询 
select超时 ，事物是否自动回滚，
select 超时时间是否可以代码上可以设置

###数据库
数据库分表和分库的区别


#2核
4G内存

问题

连接池与连接中的线程问题，到底是一个连接池一个线程还是一个连接一个线程，一个连接(池)对应多个线程
查询

select超时 ，事物是否自动回滚，
select 超时时间是否可以代码上可以设置
数据库

数据库分表和分库的区别


# keepalive  
详细的学习
http://blog.sina.com.cn/s/blog_e59371cc0102ux5w.html

请求过程中 tcp 的keepalive 和 http的 keep-alive 的区别

## free 命令中的 cache/ buffer的区别

在 Linux 的实现中，文件 Cache 分为两个层面，一是 Page Cache ，另一个 Buffer Cache ，每一个 Page Cache 包含若干 Buffer Cache 。内存管理系统和 VFS 只与 Page Cache 交互，内存管理系统负责维护每项 Page Cache 的分配和回收。buffer cache 是块设备的读写缓冲区，更靠近存储设备 2.6内核后。。


## sql Sqlmap

注入 https://blog.csdn.net/wn314/article/details/78872828
    
    git clone https://github.com/sqlmapproject/sqlmap.git