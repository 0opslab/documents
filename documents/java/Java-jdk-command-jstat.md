title: JDK命令jstat
date: 2016-01-19 21:49:02
tags:
    - Java
    - jvm
categories: Java
---
在JDK自带的命令中jstat算是一个很有用的命令，曾经帮助我解决了不少问题（J2EE项目运行一段时间后死机的现象）。
jstat是一个可以监控JVM的运行情况和状态的信息命令行工具。它能现实本地或远程JVM进程中类、内存、GC、JIT等运行de数据。
在linux服务器上它是首选工具。

# 命令格式
```bash
$ jstat [ options | outputOptions vmid [interval[s|ms] [count]] ]
```
# 参数说明
```bash
options                   :选项(执行jstat -options可以看到所有选项) 例如最常用的-gcutil查看gc信息
outputOptions             :一个或多个输出选项，由一个statOption加上任意的-t，-h选项。
                           -t 选项代表打印时间戳
                           -h(num) 表示各几行打印头信息
pid                       :进程号
iterval                   :时间间隔
                           指定单位(秒/s或毫秒/ms)的采样时间间隔，必须是一个正整数。默认单位为毫秒。
                           如果指定了该选项参数，每过指定的间隔时间，jstat就会产生一次输出。
count                     :执行次数 显示的样本数，必须是一个正整数。默认值为无限大
```
# options
```bash
class                   类加载器的行为统计
compiler                HotSpot即时编译器的行为统计
gc                      堆的垃圾回收器的行为统计
gccapacity              Java各代区域以及对应空间的容量统计
gccause                 垃圾回收的摘要信息(等同于-gcutil)， 以及最后的和当前的(如适用)垃圾回收事件的原因。
gcnew                   new generation的行为统计
gcnewcapacity           new generation及其对应空间的大小统计。
gcold                   old和permanent generation的行为统计。
gcoldcapacity           old generation的大小统计。
gcpermcapacity          permanent generation的大小统计。
gcutil                  垃圾回收统计的摘要信息。
printcompilation        HotSpot汇编方法统计。 
```
# 实例查看类加载信息
```bash
$ jstat -class 3388
#Loaded 	加载的类的数量
#Bytes 		加载的Kbyte数
#Unloaded 	已卸载的类的数量
#Bytes 		已卸载的Kbyte数
#Time 		执行类的加载和卸载操作所耗费的时间
Loaded  Bytes  Unloaded  Bytes     Time   
 36856 75360.4        0     0.0      17.41
```
# 实例查看即时变异信息
```bash
$ jstat -compiler 3388
#Compiled 	已执行的编译任务数
#Failed 	失败的编译任务数
#Invalid 	无效的编译任务数
#Time 	执行编译任务所耗费的时间
#FailedType 	最后失败的编译的编译类型
#FailedMethod 	最后失败的编译的类名和方法
Compiled Failed Invalid   Time   FailedType FailedMethod
    5871      0       0    46.55          0     
```
# gc
```bash
$ jstat -gc 3388
#S0C 	survivor space 0的当前容量(KB).
#S1C 	survivor space 1的当前容量(KB).
#S0U 	survivor space 0使用的容量(KB).
#S1U 	survivor space 1使用的容量(KB).
#EC 	Eden space的当前容量(KB).
#EU 	Edenspace的已用容量(KB).
#OC 	Oldspace的当前容量(KB).
#OU 	Old space的已用容量(KB).
#PC 	Permanent space的当前容量(KB).
#PU 	Permanentspace的已用容量(KB).
#YGC 	Younggeneration的GC事件数量
#YGCT 	Younggeneration的垃圾回收事件
#FGC 	Full GC事件的数量
#FGCT 	Full GC的时间
#GCT 	总计的垃圾回收时间 
 S0C    S1C    S0U    S1U      EC       EU        OC         OU       PC     PU    YGC     YGCT    FGC    FGCT     GCT   
4352.0 4352.0  95.6   0.0   34944.0  25601.0   217608.0   163803.2  261688.0 184147.3     80    0.819  10      0.057    0.876

```

# gccapacity选项
```bash
$ jstat -gccapacity 3388
#NGCMN 	newgeneration的最小容量(KB).
#NGCMX 	newgeneration的最大容量(KB).
#NGC 	newgeneration的当前容量(KB).
#S0C 	survivor space 0的当前容量(KB).
#S1C 	survivor space 1的当前容量(KB).
#EC 	Eden space的当前容量(KB).
#OGCMN 	Old generation的最小容量(KB).
#OGCMX 	Oldgeneration的最大容量(KB).
#OGC 	Oldgeneration的当前容量(KB).
#OC 	Old space的当前容量(KB).
#PGCMN 	Permanentgeneration的最小容量(KB).
#PGCMX 	Permanentgeneration的最大容量(KB).
#PGC 	Permanentgeneration的当前容量(KB).
#PC 	Permanent space的当前容量(KB).
#YGC 	Younggeneration的GC事件数
#FGC 	Full GC事件的数量 
 NGCMN    NGCMX     NGC     S0C   S1C       EC      OGCMN      OGCMX       OGC         OC      PGCMN    PGCMX     PGC       PC     YGC    FGC 
 43648.0 256000.0  43648.0 4352.0 4352.0  34944.0    87424.0   512000.0   217608.0   217608.0  21248.0 358400.0 261688.0 261688.0     82    10

```
# 新生代的统计
```bash
$ jstat -gcnew 3388
#S0C 	survivor space 0的当前容量(KB).
#S1C 	survivor space 1的当前容量(KB).
#S0U 	survivor space 0的已用容量(KB).
#S1U 	survivor space 1的已用容量(KB).
#TT 	期限阈值
#MTT 	最大的期限阈值
#DSS 	所需的幸存者(survivor)大小(KB).
#EC 	Eden space的当前容量(KB).
#EU 	Eden space的已用容量(KB).
#YGC 	Young generation的GC事件数
#YGCT 	Young generation的垃圾回收时间

 S0C    S1C    S0U    S1U   TT MTT  DSS      EC       EU     YGC     YGCT  
4352.0 4352.0   84.7    0.0  6   6 2176.0  34944.0   9784.0     82    0.828

```
# old和permanent的统计信息
```bash
$ jstat -gcold 3388
#PC 	permanent space的当前容量(KB).
#PU 	Permanent space的已用容量(KB).
#OC 	old space的当前容量(KB).
#OU 	old space的已用容量(KB).
#YGC 	young generation的GC事件数
#FGC 	Full GC事件的数量
#FGCT 	Full GC的时间
#GCT 	总计的垃圾回收时间 
   PC       PU        OC          OU       YGC    FGC    FGCT     GCT   
261688.0 184147.3    217608.0    163804.9     82    10    0.057    0.885

```
# gcutil很常用的选项
```bash
jstat -gcutil -t 3388 5s 5
#S0 	Survivor space 0已用容量占当前容量的百分比
#S1 	Survivor space 1已用容量占当前容量的百分比
#E 	Eden space已用容量占当前容量的百分比
#O 	Old space已用容量占当前容量的百分比
#P 	Permanent space已用容量占当前容量的百分比
#YGC 	young generation的GC事件数
#YGCT 	Young generation的垃圾回收时间
#FGC 	Full GC 事件的数量
#FGCT 	Full GC的时间
#GCT 	总计的垃圾回收时间 
Timestamp         S0     S1     E      O      P     YGC     YGCT    FGC    FGCT     GCT   
         5053.5   1.95   0.00  72.42  75.28  70.37     82    0.828    10    0.057    0.885
         5058.5   1.95   0.00  72.64  75.28  70.37     82    0.828    10    0.057    0.885
         5063.5   1.95   0.00  74.39  75.28  70.37     82    0.828    10    0.057    0.885
         5068.5   1.95   0.00  75.87  75.28  70.37     82    0.828    10    0.057    0.885
         5073.5   1.95   0.00  76.52  75.28  70.37     82    0.828    10    0.057    0.885
```