ab.test php-fpm and swoole

## 1、www.foxdoutests.com

### 1、php-fpm 

>  D:\phpStudy\Apache\bin>ab.exe -c1000 -n1000 http://www.foxdoutests.com/

This is ApacheBench, Version 2.3 <$Revision: 1748469 $><br>
[Copyright 1996 Adam Twiss, Zeus Technology Ltd]( http://www.zeustech.net/)<br>
Licensed to The Apache Software Foundation, http://www.apache.org/<br>

Benchmarking www.foxdoutests.com (be patient)<br>
Completed 100 requests<br>
Completed 200 requests<br>
Completed 300 requests<br>
Completed 400 requests<br>
Completed 500 requests<br>
Completed 600 requests<br>
Completed 700 requests<br>
Completed 800 requests<br>
Completed 900 requests<br>
Completed 1000 requests<br>
Finished 1000 requests<br>

| 名称 | 值 | 
|------|----|
|Server Software:        |nginx
|Server Hostname:        |www.foxdoutests.com
|Server Port:            |80
|Document Path:          |/
|Document Length:        |5341 bytes
|Concurrency Level:      |1000
|Time taken for tests:   |12.198 seconds
|Complete requests:      |1000
|Failed requests:        |0
|Total transferred:      |5697000 bytes
|HTML transferred:       |5341000 bytes
|Requests per second:    |81.98 [#/sec] (mean)
|Time per request:       |12197.698 [ms] (mean)
|Time per request:       |12.198 [ms] (mean, across all concurrent requests)
|Transfer rate:          |456.11 [Kbytes/sec] received

|Connection |Times (ms)|min  |mean[+/-sd] |median   |max|
|-------------|------|----|-------|--------|------|
|Connect:     |   0  |  4 | 94.9   |   1   | 3001 |
|Processing:  | 616 |5169 |1890.1  | 6068   | 8350 |
|Waiting:     | 609 |5165 |1892.6 |  6064  |  8349 |
|Total:       | 617 |5173 |1885.4  | 6069   | 8351 |


```
Percentage of the requests served within a certain time (ms)
  50%   6069
  66%   6340
  75%    6484
  80%    6568
  90%    7574
  95%    7617
  98%    7658
  99%    8291
 100%    8351 (longest request)

 ```


> D:\phpStudy\Apache\bin>ab.exe -c1000 -n1000 http://www.foxdoutests.com/

This is ApacheBench, Version 2.3 <$Revision: 1748469 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking www.foxdoutests.com (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests


Server Software:        nginx
Server Hostname:        www.foxdoutests.com
Server Port:            80

Document Path:          /
Document Length:        5341 bytes

Concurrency Level:      1000
Time taken for tests:   109.634 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      5697000 bytes
HTML transferred:       5341000 bytes
Requests per second:    9.12 [#/sec] (mean)
Time per request:       109634.271 [ms] (mean)
Time per request:       109.634 [ms] (mean, across all concurrent requests)
Transfer rate:          50.75 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.5      0       2
Processing:   759 53359 33704.4  56295  109094
Waiting:      758 53356 33706.4  56292  109093
Total:        759 53360 33704.4  56296  109095

Percentage of the requests served within a certain time (ms)
  50%  56296
  66%  72125
  75%  81774
  80%  87536
  90%  97985
  95%  103248
  98%  106447
  99%  107771
 100%  109095 (longest request)

D:\phpStudy\Apache\bin>ab.exe -c1000 -n1000 http://www.foxdoutests.com/
This is ApacheBench, Version 2.3 <$Revision: 1748469 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking www.foxdoutests.com (be patient)
Completed 100 requests
Completed 200 requests
apr_pollset_poll: The timeout specified has expired (70007)
Total of 226 requests completed


Server Software:        nginx
Server Hostname:        www.foxdoutests.com
Server Port:            80

Document Path:          /
Document Length:        5341 bytes

Concurrency Level:      1000
Time taken for tests:   74.606 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      5697000 bytes
HTML transferred:       5341000 bytes
Requests per second:    13.40 [#/sec] (mean)
Time per request:       74606.267 [ms] (mean)
Time per request:       74.606 [ms] (mean, across all concurrent requests)
Transfer rate:          74.57 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   13 189.4      1    3003
Processing: 29085 43701 6535.5  43685   68188
Waiting:    29078 43699 6535.9  43684   68187
Total:      29086 43714 6539.5  43702   68189

Percentage of the requests served within a certain time (ms)
  50%  43702
  66%  47224
  75%  48319
  80%  49720
  90%  51334
  95%  53821
  98%  55160
  99%  55945
 100%  68189 (longest request)


###swoole 


Server Software:        nginx
Server Hostname:        www.foxdoutests.com
Server Port:            80

Document Path:          /
Document Length:        5308 bytes

Concurrency Level:      1000
Time taken for tests:   1.119 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      5683008 bytes
HTML transferred:       5308000 bytes
Requests per second:    893.60 [#/sec] (mean)
Time per request:       1119.064 [ms] (mean)
Time per request:       1.119 [ms] (mean, across all concurrent requests)
Transfer rate:          4959.33 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   0.6      1       3
Processing:   125  516 263.5    514     982
Waiting:      125  499 262.2    494     968
Total:        127  517 263.5    515     983

Percentage of the requests served within a certain time (ms)
  50%    515
  66%    663
  75%    748
  80%    796
  90%    887
  95%    934
  98%    961
  99%    973
 100%    983 (longest request)


不过有多个连续多次请求时候 出现 错误
apr_pollset_poll: The timeout specified has expired (70007)
Total of 994 requests completed
加大worker 好了一点点