ab是apache自带的压力测试工具，下面是ab命令常用的参数解释说明

```bash
对上面的Options做下解释吧：
-n即requests，用于指定压力测试总共的执行次数。
-c即concurrency，用于指定压力测试的并发数。
-t即timelimit，等待响应的最大时间(单位：秒)。
-b即windowsize，TCP发送/接收的缓冲大小(单位：字节)。
-p即postfile，发送POST请求时需要上传的文件，此外还必须设置-T参数。
-u即putfile，发送PUT请求时需要上传的文件，此外还必须设置-T参数。
-T即content-type，用于设置Content-Type请求头信息，例如：application/x-www-form-urlencoded，默认值为text/plain。
-v即verbosity，指定打印帮助信息的冗余级别。
-w以HTML表格形式打印结果。
-i使用HEAD请求代替GET请求。
-x插入字符串作为table标签的属性。
-y插入字符串作为tr标签的属性。
-z插入字符串作为td标签的属性。
-C添加cookie信息，例如："Apache=1234"(可以重复该参数选项以添加多个)。
-H添加任意的请求头，例如："Accept-Encoding: gzip"，请求头将会添加在现有的多个请求头之后(可以重复该参数选项以添加多个)。
-A添加一个基本的网络认证信息，用户名和密码之间用英文冒号隔开。
-P添加一个基本的代理认证信息，用户名和密码之间用英文冒号隔开。
-X指定使用的代理服务器和端口号，例如:"126.10.10.3:88"。
-V打印版本号并退出。
-k使用HTTP的KeepAlive特性。
-d不显示百分比。
-S不显示预估和警告信息。
-g输出结果信息到gnuplot格式的文件中。
-e输出结果信息到CSV格式的文件中。
-r指定接收到错误信息时不退出程序。
-h显示用法信息，其实就是ab -help。
```

使用实例

```bash
[root@centos7 ~]#ab -c 10 -n 100 http://a.ilanni.com/index.php
    -c    10表示并发用户数为10
    -n    100表示请求总数为100
    http://a.ilanni.com/index.php表示请求的目标URL
    这行表示同时处理100个请求并运行10次index.php文件。

[root@centos7 ~]#ab -c 10 -n 100 http://a.ilanni.com/index.php
Benchmarking 47.93.96.25 (be patient).....done

Server Software:        Apache/2.4.29  ##apache版本 
Server Hostname:        ip地址   ##请求的机子 
Server Port:            80  ##请求端口

Document Path:          index.php
Document Length:        18483 bytes  ##页面长度

Concurrency Level:      10  ##并发数
Time taken for tests:   25.343 seconds  ##共使用了多少时间
Complete requests:      100  ##请求数
Failed requests:        11  ##失败请求
   (Connect: 0, Receive: 0, Length: 11, Exceptions: 0)
Total transferred:      1873511 bytes  ##总共传输字节数，包含http的头信息等
HTML transferred:       1848311 bytes  ##html字节数，实际的页面传递字节数
Requests per second:    3.95 [#/sec] (mean)  ##每秒多少请求，这个是非常重要的参数数值，服务器的吞吐量
Time per request:       2534.265 [ms] (mean)  ##用户平均请求等待时间
Time per request:       253.426 [ms] (mean, across all concurrent requests)  ##服务器平均处理时间，
Transfer rate:          72.19 [Kbytes/sec] received  ##每秒获取的数据长度

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    8   3.9     10      13
Processing:  1222 2453 322.6   2520    3436
Waiting:     1175 2385 320.4   2452    3372
Total:       1222 2461 322.5   2528    3444

Percentage of the requests served within a certain time (ms)
  50%   2528  ## 50%的请求在25ms内返回 
  66%   2534  ## 60%的请求在26ms内返回 
  75%   2538
  80%   2539
  90%   2545
  95%   2556
  98%   3395
  99%   3444
 100%   3444 (longest request)
```

