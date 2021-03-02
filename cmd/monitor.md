# title{monitor - Linux下监控的那些命令}

实时张文系统的性能如何，了解CPU、内存、存储的使用情况是一个运维必备的技能，同时也是像我这种宅男的关注点。在Linux下有大量的工具可以监控到这些数据。此文讲一些常见的监控工具。另外如果有线程的监控套件，直接使用线程的监控套件即可。当然也可以对照下图将所有的命令多撸一遍

![aratar](https://st.0opslab.com/img/blog/linux_perf_tools_full.png)

![](https://st.0opslab.com/img/blog/linux_observability_tools.png)

#### sar

sar命令是一个系统状态允许统计工具，它可以将操作系统状态计数器显示出来，它的特点是可以连续的对系统取样，获得大量的取样数据，取样数据和分析的结果都可以存入文件，使用它时消耗的系统很小。

```bash
usage: sar [选项] [参数]
选项：
  -A：显示所有的报告信息；
  -b：显示I/O速率；
  -B：显示换页状态；
  -c：显示进程创建活动；
  -d：显示每个块设备的状态；
  -e：设置显示报告的结束时间；
  -f：从指定文件提取报告；
  -i：设状态信息刷新的间隔时间；
  -P：报告每个CPU的状态；
  -R：显示内存状态；
  -u：显示CPU利用率；
  -v：显示索引节点，文件和其他内核表的状态；
  -w：显示交换分区状态；
  -x：显示给定进程的状态。
参数:
	间隔时间：每次报告的间隔时间（秒）；
	次数：显示报告的次数。
实例:	
	# sar -r 查看内存和交换空间的使用率
	# sar -u 1 3 //每隔1秒显示一次CPU使用信息，总共显示3次
    #sar 1 0 -u -e 11:02:00 > /opt/cpu.log
```

#### iostat

iostat命令被用于监视系统输入输出和CPU的使用情况。它的特点是汇报磁盘活动统计情况，同时也会汇报CPU使用情况，iostat只能对某个进程进行深入分析，仅对系统的整天情况进行分析。

```bash
usage: iostat [选项] [参数]
选项:
  -c：仅显示CPU使用情况；
  -d：仅显示设备利用率；
  -k：显示状态以千字节每秒为单位，而不使用块每秒；
  -m：显示状态以兆字节每秒为单位；
  -p：仅显示块设备和所有被使用的其他分区的状态；
  -t：显示每个报告产生时的时间；
  -V：显示版号并退出；
  -x：显示扩展状态。
参数:
	间隔时间：每次报告的间隔时间（秒）；
	次数：显示报告的次数。
	
实例：
# 观察某设备的IO详细情况
$ iostat -x /dev/disk/by-uuid/49f819fd-e56d-48a4-86d3-7ebe0a68ec88
Linux 3.10.0-514.26.2.el7.x86_64 (VM_0_14_centos) 	2018年03月11日 	_x86_64_	(2 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.16    0.00    0.10    0.06    0.00   99.68

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
vda1              0.00     1.05    0.00    1.96     0.08    12.47    12.76     0.06   29.70    2.31   29.77   1.37   0.27
	
Device	监测设备名称
rrqm/s	每秒需要读取需求的数量
wrqm/s	每秒需要写入需求的数量
r/s 	每秒实际读取需求的数量
w/s	每秒实际写入需求的数量
rsec/s	每秒读取区段的数量
wsec/s	每秒写入区段的数量
rkB/s	每秒实际读取的大小，单位为KB
wkB/s	每秒实际写入的大小，单位为KB
avgrq-sz	需求的平均大小区段
avgqu-sz	需求的平均队列长度
await	等待I/O平均的时间（milliseconds）
svctm	I/O需求完成的平均时间
%util	被I/O需求消耗的CPU百分比

备注：如果 %util 接近 100%，说明产生的I/O请求太多，I/O系统已经满负荷，该磁盘可能存在瓶颈。
如果 svctm 比较接近 await，说明 I/O 几乎没有等待时间；如果 await 远大于 svctm，说明I/O 
队列太长，io响应太慢，则需要进行必要优化。如果avgqu-sz比较大，也表示有当量io在等待。

# 显示所有设备的负载情况
$ iostat
Linux 3.10.0-514.26.2.el7.x86_64 (VM_0_14_centos) 	2018年03月11日 	_x86_64_	(2 CPU)

# cpu属性
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.16    0.00    0.10    0.06    0.00   99.68
# 磁盘IO情况
# tps：该设备每秒的传输次数。“一次传输”意思是“一次I/O请求”。多个逻辑请求可能会被合并为“一次I/O请求”。
# kB_read/s：每秒从设备（drive expressed）读取的数据量；
# kB_wrtn/s：每秒向设备（drive expressed）写入的数据量；
# kB_read：读取的总数据量；kB_wrtn：写入的总数量数据量；
Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
vda               1.97         0.09        12.47     569937   83619604

# 查看设备使用率和响应时间
$ iostat -d -x -k 1 2
Linux 3.10.0-514.26.2.el7.x86_64 (VM_0_14_centos) 	2018年03月11日 	_x86_64_	(2 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
vda               0.00     1.05    0.00    1.97     0.08    12.47    12.74     0.06   29.64    2.30   29.71   1.37   0.27

rrqm/s： 每秒进行 merge 的读操作数目.即 delta(rmerge)/s
wrqm/s： 每秒进行 merge 的写操作数目.即 delta(wmerge)/s
r/s： 每秒完成的读 I/O 设备次数.即 delta(rio)/s
w/s： 每秒完成的写 I/O 设备次数.即 delta(wio)/s
rsec/s： 每秒读扇区数.即 delta(rsect)/s
wsec/s： 每秒写扇区数.即 delta(wsect)/s
rkB/s： 每秒读K字节数.是 rsect/s 的一半,因为每扇区大小为512字节.(需要计算)
wkB/s： 每秒写K字节数.是 wsect/s 的一半.(需要计算)
avgrq-sz：平均每次设备I/O操作的数据大小 (扇区).delta(rsect+wsect)/delta(rio+wio)
avgqu-sz：平均I/O队列长度.即 delta(aveq)/s/1000 (因为aveq的单位为毫秒).
await： 平均每次设备I/O操作的等待时间 (毫秒).即 delta(ruse+wuse)/delta(rio+wio)
svctm： 平均每次设备I/O操作的服务时间 (毫秒).即 delta(use)/delta(rio+wio)
%util： 一秒中有百分之多少的时间用于 I/O 操作,或者说一秒中有多少时间 I/O 队列是非空的，即 delta(use)/s/1000 (因为use的单位为毫秒)

%util 接近 100%，说明产生的I/O请求太多，I/O系统已经满负荷，该磁盘可能存在瓶颈。 
idle小于70% IO压力就较大了
```

#### vmstat

vmstat是虚拟内存统计的缩写，可实时监控操作系统的虚拟内存、进程、CPU活动。

```bash
usage: vmstat [选项] [参数]
选项:
  -a：显示活动内页；
  -f：显示启动后创建的进程总数；
  -m：显示slab信息；
  -n：头信息仅显示一次；
  -s：以表格方式显示事件计数器和内存状态；
  -d：报告磁盘状态；
  -p：显示指定的硬盘分区状态；
  -S：输出信息的单位。
参数:
	事件间隔：状态信息刷新的时间间隔；
	次数：显示报告的次数。
```

下面是一些实例

```bash
# 默认用法
$ vmstat
# Procs 进程信息 
# 	r 运行队列中进程的数量，这个值也可以判断是否增加CPU，长期大于1
#	b 等待IO进程的数量
# Memory 内存信息
#	swpd 使用虚拟内存大小
#	free 空闲内存大小
#	buff 作用缓冲的内存大小
# 	cache 用作缓存的内存大小
# Swap(这俩个值长期大于0可能会营销的性能)
#	si 每秒从交换去到内存的大小，由磁盘调入内存
#	so 每秒写入交换区的内存大小，有内存调入磁盘
# IO(大小为KB,这俩个值越大CPU在等待IO的时间会越大)
# 	bi	每秒读取的块数
#	bo	每秒写入的块数
# system(这俩个值越大，系统内核消耗CPU的时间越大) 
#	in	每秒中断数，包括时钟中断
#	cs	每秒上下文切换数
# CPU(cpu百分比)
#	us 用户进程执行时间百分比
#	sy 内核系统进程执行时间百分比
#	wa IO等待时间百分比
#	id 空闲时间百分比
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 1  0      0 200244 261000 3250708    0    0     0     6    0    2  0  0 100  0  0
```

#### free

free命令可以显示当前系统未使用的已使用的内存数据，还可以显示被内核使用的内存缓冲区。

```bash
usage: free [选项]
选项:
    -b：以Byte为单位显示内存使用情况；
    -k：以KB为单位显示内存使用情况；
    -m：以MB为单位显示内存使用情况；
    -o：不显示缓冲区调节列；
    -s<间隔秒数>：持续观察内存使用状况；
    -t：显示内存总和列；
    -V：显示版本信息。
```

实例

```bash
$ free -m
              total        used        free      shared  buff/cache   available
Mem:           3791         156         204           0        3429        3336
Swap:             0           0           0

total：内存总数；
used：已经使用的内存数；
free：空闲的内存数；
shared：当前已经废弃不用；
buffers Buffer：缓存内存数；
cached Page：缓存内存数。

```



#### dstat

dstat是一个可以取代vmstat、iostat、netstat和ifstat这些命令的多功能产品，同时也客服了这些命令的局限性并增加了一些功能，dstat可以很方便监控系统运行状态并用户检测基准和排除故障。

```bash
usage: dstat [-afv] [optins..] [delay [count]]
```

命令选项

| -c, - -cpu             | 开启cpu统计                                  |
| ---------------------- | ---------------------------------------- |
| -C                     | 该选项跟cpu的编号（0~cpu核数-1,多个用都好隔开）如：0,3,total表示分别包含cpu0、cpu3和total |
| -d, - -disk            | 开启disk统计                                 |
| -D                     | 改选跟具体的设备名（多个用逗号隔开）如：total,hda，hdb表示分别统计total、hda、hdb设备块 |
| -g, - -page            | 开启分页统计                                   |
| -i, - -int             | 开启中断统计                                   |
| -I 5,10                | 开启负载统计量                                  |
| -l, - -load            | 开启负载均衡统计，分别是1m，5m，15m                    |
| -m, - -mem             | 开启内存统计，包括used，buffers，cache，free         |
| -n, - -net             | 开启net统计，包括接受和发送                          |
| -N                     | 该选项可以跟网络设备名多个用逗号隔开，如eth1,total           |
| -p, - -proc            | 开启进程统计，包括runnable, uninterruptible, new  |
| -r, - -io              | io开启请求统计，包括read requests, write requests |
| -s, - -swap            | 开启swap统计，包括used, free                    |
| -S                     | 该选项可以跟具体的交换区，多个用逗号隔开如swap1,total         |
| -t, - -time            | 启用时间和日期输出                                |
| -T, - -epoch           | 启用时间计数，从epoch到现在的秒数                      |
| -y, - -sys             | 开启系统统计，包括中断和上下文切换                        |
| - -aio                 | 开启同步IO统计 (asynchronous I/O)              |
| - -fs                  | 开启文件系统统计，包括 (open files, inodes)         |
| - -ipc                 | 开启ipc统计，包括 (message queue, semaphores, shared memory) |
| - -lock                | 开启文件所统计，包括 (posix, flock, read, write)   |
| - -raw                 | 开启raw统计 (raw sockets)                    |
| - -socket              | 开启sockets统计，包括 (total, tcp, udp, raw, ip-fragments) |
| - -tcp                 | 开启tcp统计，包括(listen, established, syn, time_wait, close) |
| - -udp                 | 开启udp统计 (listen, active)                 |
| - -unix                | 开启unix统计(datagram, stream, listen, active) |
| - -vm                  | 开启vm统计 (hard pagefaults, soft pagefaults, allocated, free) |
| - -stat                | 通过插件名称开启插件扩展，详见[命令插件](http://blog.csdn.net/yue530tomtom/article/details/75443305#t7) ：可能的内置插件为aio, cpu, cpu24, disk, disk24, disk24old, epoch, fs, int, int24, io, ipc, load, lock, mem, net, page, page24, proc, raw, socket, swap, swapold, sys, tcp, time,udp, unix, vm |
| - -list                | 列举内置插件扩展的名称                              |
| -a, - -all             | 是默认值相当于 -cdngy (default)                 |
| -f, - -full            | 相当于 -C, -D, -I, -N and -S                |
| -v, - -vmstat          | 相当于 -pmgdsc -D total                     |
| - -bw, - -blackonwhite | 在白色背景终端上改变显示颜色                           |
| - -float               | 在屏幕上的输出强制显示为浮点值（即带小数）(相反的选项设置为 - -integer) |
| - -integer             | 在屏幕上的输出强制显示为整数值，此为默认值（相反的选项设置为- -float）  |
| - -nocolor             | 禁用颜色(意味着选项 - -noupdate)                  |
| - -noheaders           | 禁止重复输出header，默认会打印一屏幕输出一次header          |
| - -noupdate            | 当delay>1时禁止在过程中更新（即在时间间隔内不允许更新）          |
| - -output file         | 输出结果到cvs文件中                              |

命令参数

| 参数名称  | 参数描述                         |
| ----- | ---------------------------- |
| delay | 两次输出之间的时间间隔，默认是1s            |
| count | 报告输出的次数，默认是没有限制，一直输出知道ctrl+c |



```bash
# 最基本的用法
$ dstat
You did not select any stats, using -cdngy by default.
# total-cpu-usage cpu状态
#	usr 用户使用占比
#	sys 系统使用占比
#	idl 空闲占比
#	wai 等待占比
#	hiq 硬中断
#	siq 软中断
# dsk/total 磁盘统计
#	read 磁盘的读总数
#	writ 磁盘写的总数
# net/total 网络统计
#	recv 显示网络接收的总数
#	send 显示网络发送的总数
# paging 分页统计
#	in 分页换入
#	out 分页换出
# system 系统丛集
#	int 统计中断
#	csw 上下午切换
----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw
  0   0 100   0   0   0|  87B   12k|   0     0 |   0     0 | 174   223
  0   0 100   0   0   0|   0  8192B|1532B 2592B|   0     0 | 264   336
  1   0  99   0   0   0|   0     0 |1151B 1859B|   0     0 | 234   349 
```

另外dstat附带了很多强大的插件，这使得dstat更加强大。可以通过查看/usr/share/dstat目录来查看它们的用户发.但dstat附带大量的插件已经大大扩展其功能，下面是dstat附带插件的一个概述：

| 插件名称               | 插件描述                       |
| ------------------ | -------------------------- |
| - -battery         | 电池电池百分比(需要ACPI)            |
| - -battery-remain  | 电池剩余小时、分钟(需要ACPI)          |
| - -cpufreq         | CPU频率百分比(需要ACPI)           |
| - -dbus            | dbus连接的数量(需要python-dbus)   |
| - -disk-util       | 显示某一时间磁盘的忙碌状况              |
| - -fan             | 风扇转速(需要ACPI)               |
| - -freespace       | 每个文件系统的磁盘使用情况              |
| - -gpfs            | gpfs读/写 I / O(需要mmpmon)    |
| - -gpfs-ops        | GPFS文件系统操作(需要mmpmon)       |
| - -helloworld      | dstat插件Hello world示例       |
| - -innodb-buffer   | 显示innodb缓冲区统计              |
| - -innodb-io       | 显示innodb I / O统计数据         |
| - -innodb-ops      | 显示innodb操作计数器              |
| - -lustre          | 显示lustreI / O吞吐量           |
| - -memcache-hits   | 显示memcache 的命中和未命中的数量      |
| - -mysql5-cmds     | 显示MySQL5命令统计               |
| - -mysql5-conn     | 显示MySQL5连接统计               |
| - -mysql5-io       | MySQL5 I / O统计数据           |
| - -mysql5-keys     | 显示MySQL5关键字统计              |
| - -mysql-io        | 显示MySQL I / O统计数据          |
| - -mysql-keys      | 显示MySQL关键字统计               |
| - -net-packets     | 显示接收和发送的数据包的数量             |
| - -nfs3            | 显示NFS v3客户端操作              |
| - -nfs3-ops        | 显示扩展NFS v3客户端操作            |
| - -nfsd3           | 显示NFS v3服务器操作              |
| - -nfsd3-ops       | 显示扩展NFS v3服务器操作            |
| - -ntp             | 显示NTP服务器的ntp时间             |
| - -postfix         | 显示后缀队列大小(需要后缀)             |
| - -power           | 显示电源使用量                    |
| - -proc-count      | 显示处理器的总数                   |
| - -rpc             | 显示rpc客户端调用统计               |
| - -rpcd            | 显示RPC服务器调用统计               |
| - -sendmail        | 显示sendmail队列大小(需要sendmail) |
| - -snooze          | 显示每秒运算次数                   |
| - -test            | 显示插件输出                     |
| - -thermal         | 热系统的温度传感器                  |
| - -top-bio         | 显示消耗块I/O最大的进程              |
| - -top-cpu         | 显示消耗CPU最大的进程               |
| - -top-cputime     | 显示使用CPU时间最大的进程(单位ms)       |
| - -top-cputime-avg | 显示使用CPU时间平均最大的进程(单位ms)     |
| - -top-io          | 显示消耗I/O最大进程                |
| - -top-latency     | 显示总延迟最大的进程(单位ms)           |
| - -top-latency-avg | 显示平均延时最大的进程(单位ms)          |
| - -top-mem         | 显示使用内存最大的进程                |
| - -top-oom         | 显示第一个被OOM结束的进程             |
| - -utmp            | 显示utmp连接的数量(需要python-utmp) |
| - -vmk-hba         | 显示VMware ESX内核vmhba统计数     |
| - -vmk-int         | 显示VMware ESX内核中断数据         |
| - -vmk-nic         | 显示VMware ESX内核端口统计         |
| - -vz-io           | 显示每个OpenVZ请求CPU使用率         |
| - -vz-ubc          | 显示OpenVZ用户统计               |
| - -wifi            | 无线连接质量和信号噪声比               |

常用插件

| 插件名称          | 插件描述          |
| ------------- | ------------- |
| - -disk-util  | 显示某一时间磁盘的忙碌状况 |
| - -freespace  | 显示当前磁盘空间使用率   |
| - -proc-count | 显示正在运行的程序数量   |
| - -top-bio    | 显示块I/O最大的进程   |
| - -top-cpu    | 显示CPU占用最大的进程  |
| - -top-io     | 显示正常I/O最大的进程  |
| - -top-mem    | 显示占用最多内存的进程   |

实例

```bash
# 内存资源使用情况
$ dstat -glms --top-mem

# CPU资源使用情况
$ dstat -cyl --proc-count --top-cpu

# 监控最消耗IO的进程和最消耗设备IO的进程
$ dstat -t --top-io-adv --top-bio-adv

# 监控swap、process、sockets、filesystem并显示监控的时间
$ dstat -tsp --socket --fs

# 监控最消耗CPU/BLOCK/IO/内存/IO的进程
$ dstat --top-cpu --top-bio --top-mem --top-io

# 查看8颗核心，每颗核心的使用情况和CPU使用情况
$ dstat -cl -C 0,1,2,3,4,5,6,7 --top-cpu

# 显示指定网卡的信息
$ dstat -tn -N eth0

# 每5秒显示一次tcp的统计信息
$ dstat -tn -N eth0 --tcp 5

# 将监控信息写入到一个csv文件中
$ dstat –output /tmp/sampleoutput.csv -cdn
```

#### 分析系统瓶颈

系统响应变慢，首先需要定位大致问题出在哪里，是IO瓶颈、CPU瓶颈、内存瓶颈还是程序导致的。是用top命令能比较全面的看到这些关注点。

```bash
$ top
top - 14:52:03 up 77 days, 17:33,  1 user,  load average: 0.00, 0.01, 0.05
Tasks:  80 total,   1 running,  79 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.2 us,  0.1 sy,  0.0 ni, 99.7 id,  0.1 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem :  3882032 total,   206456 free,   160164 used,  3515412 buff/cache
KiB Swap:        0 total,        0 free,        0 used.  3416744 avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
    1 root      20   0  123092   3752   2432 S   0.0  0.1   5:03.66 systemd
```

进入交互模式后：

* 输入M：进程列表按照内存使用大小排序，便于观察最大内存使用者
* 输入P：进程列表按照CPU使用率排序，便于观察最消耗CPU的进程
* %id ：空闲CPU时间百分比，如果这个值过低，表明系统CPU存在瓶颈
* %wa：等待I/O的CPU时间百分比，如果这个值高，表明IO存在瓶颈
* 通过Mem：free字段很小，表明内存不足

内存/CPU瓶颈

通过top的Mem字段中free、used、total等字段确认是内存瓶颈的话，可以进一步是用free命令来分析。同时也可以使用组合命令查找使用内存最多的进程。

```bash
# 查找使用内存最多的10个进程
$ ps -aux | sort -k4nr | head -n 10

# 查找使用CPU最多的是个进程
$ ps -aux | sort -k3nr | head -n 10
```

查看IO瓶颈

1.开启block_dump,此时会把io信息输入到dmesg中
echo 1 > /proc/sys/vm/block_dump
统计当前占用IO最高的10个进程：
dmesg |awk -F: '{print $1}'|sort|uniq -c|sort -rn|head -n 10
2.测试完后，关闭block_dumpblock_dump参数
echo 0 > /proc/sys/vm/block_dump

网络使用

如果想要监控进程使用的网络资源，建议按照iftop，当流量较大时这些机遇libpcap库的工具边不是那么好用，此时可以直接相关的系统文件即可。比如要看eth0上的信息可以读取如下文件

- /sys/class/net/eth0/statistics/rx_packets: 收到的数据包数据
- /sys/class/net/eth0/statistics/tx_packets: 传输的数据包数量
- /sys/class/net/eth0/statistics/rx_bytes: 接收的字节数
- /sys/class/net/eth0/statistics/tx_bytes: 传输的字节数
- /sys/class/net/eth0/statistics/rx_dropped: 当收到包数据包下降的数据量
- /sys/class/net/eth0/statistics/tx_dropped: 传输包数据包下降的数据量

如下是joemiller大牛发布的脚步可以检测对应文件并显示

测量网口每秒数据包：

```bash
#!/bin/bash
 
INTERVAL="1"  # update interval in seconds
 
if [ -z "$1" ]; then
        echo
        echo usage: $0 [network-interface]
        echo
        echo e.g. $0 eth0
        echo
        echo shows packets-per-second
        exit
fi
 
IF=$1
 
while true
do
        R1=`cat /sys/class/net/$1/statistics/rx_packets`
        T1=`cat /sys/class/net/$1/statistics/tx_packets`
        sleep $INTERVAL
        R2=`cat /sys/class/net/$1/statistics/rx_packets`
        T2=`cat /sys/class/net/$1/statistics/tx_packets`
        TXPPS=`expr $T2 - $T1`
        RXPPS=`expr $R2 - $R1`
        echo "TX $1: $TXPPS pkts/s RX $1: $RXPPS pkts/s"
done
```

网络带宽测量

```bash
#!/bin/bash
 
INTERVAL="1"  # update interval in seconds
 
if [ -z "$1" ]; then
        echo
        echo usage: $0 [network-interface]
        echo
        echo e.g. $0 eth0
        echo
        exit
fi
 
IF=$1
 
while true
do
        R1=`cat /sys/class/net/$1/statistics/rx_bytes`
        T1=`cat /sys/class/net/$1/statistics/tx_bytes`
        sleep $INTERVAL
        R2=`cat /sys/class/net/$1/statistics/rx_bytes`
        T2=`cat /sys/class/net/$1/statistics/tx_bytes`
        TBPS=`expr $T2 - $T1`
        RBPS=`expr $R2 - $R1`
        TKBPS=`expr $TBPS / 1024`
        RKBPS=`expr $RBPS / 1024`
        echo "TX $1: $TKBPS kb/s RX $1: $RKBPS kb/s"
done
```

#### 程序瓶颈分析

当确定是某个程序的问题后，可以根据程序的语言查找对应的工具进行性能的分析。当然也可以使用pstatck和pstrace、straced等跟踪器进行分析。

#### 参考

http://www.brendangregg.com/linuxperf.html

