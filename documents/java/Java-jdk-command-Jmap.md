title: JDK命令jmap
date: 2016-01-08 22:22:22
tags:
    - Java
    - jvm
categories: Java
---
可以输出所有内存中对象的工具，甚至可以将VM 中的heap，以二进制输出成文本。在一段时间后，
使用文本对比工具，可以对比出GC回收了哪些对象。

# 命令格式
```bahs
jmap [ option ] pid
jmap [ option ] executable core
jmap [ option ] [server-id@]remote-hostname-or-IP
```
# 参数说明
## 参数说明：
executable Java executable from which the core dump was produced.
           (产生core dump的java可执行程序)
core 将被打印信息的core dump文件
remote-hostname-or-IP 远程debug服务的主机名或ip
server-id 唯一id,假如一台主机上多个远程debug服务
## 基本参数：
-dump             [live,]format=b,file=<filename> 使用hprof二进制形式,输出jvm的heap内容到文件=.
                  live子选项是可选的，假如指定live选项,那么只输出活的对象到文件.
-finalizerinfo    打印正等候回收的对象的信息.
-heap             打印heap的概要信息，GC使用的算法，heap的配置及wise heap的使用情况.
-histo[:live]     打印每个class的实例数目,内存占用,类全名信息. VM的内部类名字开头会加上前缀”*”.
                  如果live子参数加上后,只统计活的对象数量.
-permstat         打印classload和jvm heap长久层的信息. 包含每个classloader的名字,
                  活泼性,地址,父classloader和加载的class数量. 另外,内部String的数量和占用内存数也会打印出来.
-F                强迫.在pid没有相应的时候使用-dump或者-histo参数. 在这个模式下,live子参数无效.
-h | -help        打印辅助信息
-J                传递参数给jmap启动的jvm.
pid               需要被打印配相信息的java进程id,创业与打工的区别 - 博文预览,可以用jps查问.

```bash
jmap -histo pid。
jmap -histo pid>a.log
jmap -dump:format=b,file=test.bin 4939
```
# 实例查看JVM内存分布
```bash
$ jdk1.6.0_18/bin/jmap -heap 8230
Attaching to process ID 8230, please wait...
Debugger attached successfully.
Server compiler detected.
JVM version is 16.0-b12

using thread-local object allocation.
Parallel GC with 8 thread(s)                     #GC方式

Heap Configuration:                              #堆内存初始化配置
   MinHeapFreeRatio = 40                         #对应JVM启动参数-XX:MinHeapFreeRatio 设置JVM堆最小空闲比率
   MaxHeapFreeRatio = 70                         #对应JVM启动参数-XX:MaxHeapFreeRatio 设置JVM堆最大空闲比率
   MaxHeapSize      = 2621440000 (2500.0MB)      #对应JVM启动参数-XX:MaxHeapSize 设置JVM堆的最大大小
   NewSize          = 4194304 (4.0MB)            #对应JVM启动参数-XX:NewSize 设置JVM堆的新生代的默认大小
   MaxNewSize       = 4294901760 (4095.9375MB)   #对应JVM启动参数-XX:MaxNewSize 设置JVM堆的新生代的最大大小
   OldSize          = 4194304 (4.0MB)            #对应JVM启动参数-XX:OldSize 设置JVM堆的老生代的大小
   NewRatio         = 2                          #对应JVM启动参数-XX:NewRatio 新生代和老生代的大小比率
   SurvivorRatio    = 8                          #对应JVM启动参数-XX:SurvivorRatio 设置新生代中Eden区和Survivor区的大小比值
   PermSize         = 16777216 (16.0MB)          #对应JVM启动参数-XX:PermSize=<value>:设置JVM堆的永生代的初始大小
   MaxPermSize      = 67108864 (64.0MB)          #对应JVM启动参数-XX:MaxPermSize 设置JVM堆的永生代的最大大小

Heap Usage:                                      #堆内存分布
PS Young Generation                              #新生代
Eden Space:                                      #Eden区内存分布
   capacity = 749797376 (715.0625MB)             #Eden区总容量
   used     = 638584440 (609.001579284668MB)     #Eden区已使用
   free     = 111212936 (106.06092071533203MB)   #Eden区剩余容量
   85.16760133340344% used                       #Eden区使用比率
From Space:                                      #其中一个Survivor区的内存分布
   capacity = 44302336 (42.25MB)
   used     = 0 (0.0MB)
   free     = 44302336 (42.25MB)
   0.0% used
To Space:                                        #另一个Survivor区的内存分布
   capacity = 62062592 (59.1875MB)
   used     = 0 (0.0MB)
   free     = 62062592 (59.1875MB)
   0.0% used
PS Old Generation                                #当前的old区内存分布
   capacity = 1747648512 (1666.6875MB)
   used     = 1747648472 (1666.6874618530273MB)
   free     = 40 (3.814697265625E-5MB)
   99.99999771121026% used
PS Perm Generation                               #当前永生代内存分布
   capacity = 59113472 (56.375MB)
   used     = 58799168 (56.07525634765625MB)
   free     = 314304 (0.29974365234375MB)
   99.4683039426275% used
```
# 实例产看堆内存中的对象的数量及大小
```bash
$ jmap -histo 3388|more

 num     #instances         #bytes  class name
----------------------------------------------
   1:        446558       41805088  [C
   2:         36854       41173280  <constantPoolKlass>
   3:        284686       39351240  <constMethodKlass>
   4:        284686       36459024  <methodKlass>
   5:         36853       30879752  <instanceKlassKlass>
   6:        205422       26872480  [B
   7:         29661       20247488  <constantPoolCacheKlass>

```
# 实例将内存的详细信息dump到文件中并查看详细内容
```bash
~$ jmap -dump:format=b,file=heapDump 3388
Dumping heap to /home/ops/heapDump ...
Heap dump file created
# 以下命令会将dump的内容解析到浏览器中
# http://localhost:5000
$ jhat -port 5000 heapDump
Reading from heapDump...
Dump file created Tue Jan 19 21:24:55 CST 2016

```



