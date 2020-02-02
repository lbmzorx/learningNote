mysql> show status like 'Threads%';

| Variable_name     | Value | 说明    |
|-------------------|-------|---------|
| Threads_cached    | 58    |  管理的线程池中还有多少可以被复用的资源  |
| Threads_connected | 57    |   这个数值指的是打开的连接数|
| Threads_created   | 3676  |          |
| Threads_running   | 4     | 这个数值指的是激活的连接数，这个数值一般远低于connected数值，代表真正在运行的（等于1一般就是这个show status命令本身|
|-------------------|-------|-----------|
 

