---
title: linux-process
date: 2018-03-09 20:50:43
tags: Linux
---

执行中的程序被称作进程，程序执行时会被动态的分配系统资源、内存、安全属性、网络资源、存储资源等等。想要管理好操作系统或者写好程序，就需要掌握查看进程以及进程的状态和资源的分配情况。强烈建议每一个开发人员都应该学习汇编语言。

在Linux的内核中为进程定义了一个task_struct的结构表示进程必须的数据和其他的一些统计数据等。

```c++
struct task_struct {    
     volatile long state;    /* -1 不可运行, 0 可运行, >0 已停止 */    
     void *stack;            /* 堆栈 */    
     atomic_t usage;    
     unsigned int flags; /* 一组标志 */    
     unsigned int ptrace;    
     /* …  */    
     
     int prio, static_prio, normal_prio;  /* 优先级  */    
    /* …  */    
    
    struct list_head tasks;  /* 执行的线程（可以有很多）  */    
    struct plist_node pushable_tasks;    
    
    struct mm_struct *mm, *active_mm;   /* 内存页（进程地址空间）  */    
    
    /* 进行状态 */    
    int exit_state;    
    int exit_code, exit_signal;    
    int pdeath_signal;  /*  当父进程死亡时要发送的信号  */    

    
    pid_t pid;  /* 进程号 */    
    pid_t tgid;    
   
    /* … */    
    struct task_struct *real_parent; /* 实际父进程real parent process */    
    struct task_struct *parent; /* SIGCHLD的接受者，由wait4()报告 */    
    struct list_head children;  /* 子进程列表 */    
    struct list_head sibling;   /* 兄弟进程列表 */    
    struct task_struct *group_leader;   /* 线程组的leader */    
    /* … */    
    
    char comm[TASK_COMM_LEN]; /* 可执行程序的名称（不包含路径） */    
    /* 文件系统信息 */    
    int link_count, total_link_count;    
    /* … */    
    
    /* 特定CPU架构的状态 */    
    struct thread_struct thread;    
   /* 进程当前所在的目录描述 */    
     struct fs_struct *fs;    
    /* 打开的文件描述信息 */    
    struct files_struct *files;    
    /* … */    
};    
```



在Linux系统中提供了，查看所有运行的进程、查看进程消耗资源/限制、进程的管理的命令，掌握这些命令显得至关重要。

###ps

ps命令是Linux中最基础的查看系统进程的命令，能列出系统中运行的进程，包括进程号、CPU使用量、内存使用量等信息。

```bash
usage:
	ps [选项]
选项：
  -a：显示所有终端机下执行的程序，除了阶段作业领导者之外。
  a：显示现行终端机下的所有程序，包括其他用户的程序。
  -A：显示所有程序。
  -c：显示CLS和PRI栏位。
  c：列出程序时，显示每个程序真正的指令名称，而不包含路径，选项或常驻服务的标示。
  -C<指令名称>：指定执行指令的名称，并列出该指令的程序的状况。
  -d：显示所有程序，但不包括阶段作业领导者的程序。
  -e：此选项的效果和指定"A"选项相同。
  e：列出程序时，显示每个程序所使用的环境变量。
  -f：显示UID,PPIP,C与STIME栏位。
  f：用ASCII字符显示树状结构，表达程序间的相互关系。
  -g<群组名称>：此选项的效果和指定"-G"选项相同，当亦能使用阶段作业领导者的名称来指定。
  g：显示现行终端机下的所有程序，包括群组领导者的程序。
  -G<群组识别码>：列出属于该群组的程序的状况，也可使用群组名称来指定。
  h：不显示标题列。
  -H：显示树状结构，表示程序间的相互关系。
  -j或j：采用工作控制的格式显示程序状况。
  -l或l：采用详细的格式来显示程序状况。
  L：列出栏位的相关信息。
  -m或m：显示所有的执行绪。
  n：以数字来表示USER和WCHAN栏位。
  -N：显示所有的程序，除了执行ps指令终端机下的程序之外。
  -p<程序识别码>：指定程序识别码，并列出该程序的状况。
  p<程序识别码>：此选项的效果和指定"-p"选项相同，只在列表格式方面稍有差异。
  r：只列出现行终端机正在执行中的程序。
  -s<阶段作业>：指定阶段作业的程序识别码，并列出隶属该阶段作业的程序的状况。
  s：采用程序信号的格式显示程序状况。
  S：列出程序时，包括已中断的子程序资料。
  -t<终端机编号>：指定终端机编号，并列出属于该终端机的程序的状况。
  t<终端机编号>：此选项的效果和指定"-t"选项相同，只在列表格式方面稍有差异。
  -T：显示现行终端机下的所有程序。
  -u<用户识别码>：此选项的效果和指定"-U"选项相同。
  u：以用户为主的格式来显示程序状况。
  -U<用户识别码>：列出属于该用户的程序的状况，也可使用用户名称来指定。
  U<用户名称>：列出属于该用户的程序的状况。
  v：采用虚拟内存的格式显示程序状况。
  -V或V：显示版本信息。
  -w或w：采用宽阔的格式来显示程序状况。　
  x：显示所有程序，不以终端机来区分。
  X：采用旧式的Linux i386登陆格式显示程序状况。
  -y：配合选项"-l"使用时，不显示F(flag)栏位，并以RSS栏位取代ADDR栏位　。
  -<程序识别码>：此选项的效果和指定"p"选项相同。
  --cols<每列字符数>：设置每列的最大字符数。
  --columns<每列字符数>：此选项的效果和指定"--cols"选项相同。
  --cumulative：此选项的效果和指定"S"选项相同。
  --deselect：此选项的效果和指定"-N"选项相同。
  --forest：此选项的效果和指定"f"选项相同。
  --headers：重复显示标题列。
  --help：在线帮助。
  --info：显示排错信息。
  --lines<显示列数>：设置显示画面的列数。
  --no-headers：此选项的效果和指定"h"选项相同，只在列表格式方面稍有差异。
  --group<群组名称>：此选项的效果和指定"-G"选项相同。
  --Group<群组识别码>：此选项的效果和指定"-G"选项相同。
  --pid<程序识别码>：此选项的效果和指定"-p"选项相同。
  --rows<显示列数>：此选项的效果和指定"--lines"选项相同。
  --sid<阶段作业>：此选项的效果和指定"-s"选项相同。
  --tty<终端机编号>：此选项的效果和指定"-t"选项相同。
  --user<用户名称>：此选项的效果和指定"-U"选项相同。
  --User<用户识别码>：此选项的效果和指定"-U"选项相同。
  --version：此选项的效果和指定"-V"选项相同。
  --widty<每列字符数>：此选项的效果和指定"-cols"选项相同。
 
ps命令输出字段说明:
  • USER：该 process 属于那个使用者账号的？
  • PID ：该 process 的号码。
  • PPID ：该 process的父进程的号码。
  • %CPU：该 process 使用掉的 CPU 资源百分比；
  • %MEM：该 process 所占用的物理内存百分比；
  • VSZ ：该 process 使用掉的虚拟内存量 (Kbytes)
  • RSS ：该 process 占用的固定的内存量 (Kbytes)
  • TTY ：该 process 是在那个终端机上面运作，若与终端机无关，则显示 ?，另外， tty1-tty6 是本机上面的登入者程序，若为 pts/0 等等的，则表示为由网络连接进主机的程序。
  • STAT：该程序目前的状态，主要的状态有：
    o R ：该程序目前正在运作，或者是可被运作；
    o S ：该程序目前正在睡眠当中 (可说是 idle 状态啦！)，但可被某些讯号 (signal) 唤醒。
    o T ：该程序目前正在侦测或者是停止了；
    o Z ：该程序应该已经终止，但是其父程序却无法正常的终止他，造成 zombie (疆尸) 程序的状态
  • START：该 process 被触发启动的时间；
  • TIME ：该 process 实际使用 CPU 运作的时间。
  • COMMAND：该程序的实际指令为何？
  
实例：
$ ps  //查看当前终端下启动的进程
  PID TTY           TIME CMD
    1 ??         0:09.48 /sbin/launchd
   56 ??         0:00.29 /usr/sbin/syslogd
$ ps aux // 查看所有的进程 
 ps aux | more
USER               PID  %CPU %MEM      VSZ    RSS   TT  STAT STARTED      TIME COMMAND
monsoon            497  14.2  6.7  6448572 558980   ??  S    11:06上午   6:22.40 /Applications/QQMusic.app/Contents/MacOS/QQMusic
$ ps -e | more
  PID 进程ID 
  TTY与进程关联的终端
  TIME 进程使用CPU累计时间
  CMD  执行文件的名称
  PID TTY           TIME CMD
    1 ??         0:09.48 /sbin/launchd
   56 ??         0:00.29 /usr/sbin/syslogd
$ ps -ef | more
  UID  用户ID
  PPID 父进程的ID
  UID   PID  PPID   C STIME   TTY           TIME CMD
    0     1     0   0 11:05上午 ??         0:09.64 /sbin/launchd
    0    56     1   0 11:06上午 ??         0:00.29 /usr/sbin/syslogd
$ ps -axj //查看守护进程
$ ps -u root //查看root的进场

$ watch -n 1 'ps -aux --sort -pmem,-pcpu | head -10' //实时监测内存和cpu使用较高的前10个程序
```

进程的状态在linux中进程的状态有五种：

* TASK_RUNNING（运行）--------进程正在执行，或者在队列中等待执行。这是进程在用户空间中唯一可能的状态，也可以应用到内核空间中正在执行的进程。
* TASK_INTERRUPTIBLE(可中断)--------进程正在睡眠（也就是他被阻塞）等待某些条件达成。一旦这些条件达成，内核就会把进程状态设置为运行，处于此状态的进程也会因为收到信号而提前被唤醒并投入运行。
* TASK_UNINTERRUPTIBALE(不可中断)--------除了会因为接收到信号而被唤醒从而投入运行外，这个状态与可打断状态相同。这个状态通常在进程必须等待时不受干扰或事件很快就会发生时出现。由于处于此状态的任务对信号不作响应，所以较之可中断状态，用的较少。
* TASK_ZOMBIE(僵死)-------该进程已经结束了，但父进程还没有调用wait()系统调用。一旦父进程调用了wait()，进程描述符就会被释放。
* TASK_STOPPED（停止）---------进程停止执行，进程没有投入运行也不能投入运行。

###top/htop

top是一个很有用的命令，可以监视系统中不同进程所使用的资源，它提供实时的系统状态信息，是一个综合了多方信息的监视工具，通过top命令所提供的交互式的解密，可以用热键管理。另外htop命令是加强版的top命令，但是在常用的发型版中没有默认按照，因此不做讨论。

```bash
usage: top [选项]
选项:
  -b：以批处理模式操作；
  -c：显示完整的治命令；
  -d：屏幕刷新间隔时间；
  -I：忽略失效过程；
  -s：保密模式；
  -S：累积模式；
  -i<时间>：设置间隔时间；
  -u<用户名>：指定用户名；
  -p<进程号>：指定进程；
  -n<次数>：循环显示的次数。
交互命令：
  h：显示帮助画面，给出一些简短的命令总结说明；
  k：终止一个进程；
  i：忽略闲置和僵死进程，这是一个开关式命令；
  q：退出程序；
  r：重新安排一个进程的优先级别；
  S：切换到累计模式；
  s：改变两次刷新之间的延迟时间（单位为s），如果有小数，就换算成ms。输入0值则系统将不断刷新，默认值是5s；
  f或者F：从当前显示中添加或者删除项目；
  o或者O：改变显示项目的顺序；
  l：切换显示平均负载和启动时间信息；
  m：切换显示内存信息；
  t：切换显示进程和CPU状态信息；
  c：切换显示命令名称和完整命令行；
  M：根据驻留内存大小进行排序；
  P：根据CPU使用百分比大小进行排序；
  T：根据时间/累计时间进行排序；
  w：将当前设置写入~/.toprc文件中。
  
实例：
$ top
# top -xxx 当前时间  up xx 系统运行时间  x users当前登录用户数 
# load average 系统负载 即任务队列的平均长度 分别1分钟 5分钟 15分钟前到现在的平均值
top - 13:28:01 up 76 days, 16:09,  2 users,  load average: 0.00, 0.01, 0.05
# 第二、三行为进程和CPU的信息，当有多个CPU时，这些内容可能会超过俩行
# total 进程总数 running 正在运行的进程数 sleeping 睡眠的进程数 
# stoped 停止的进程数 zombie 僵尸进程数
Tasks:  85 total,   1 running,  84 sleeping,   0 stopped,   0 zombie
# CPU信息 多个CPU在数字键盘1 可以按照每个逻辑CPU的状况
# us 用户空间占用CPU百分比 sy内核空间占用CPU百分比 ni用户进场空间内改变优先级的进程占用CPU百分比
# id 空闲CPU百分比 wa 等待输入输出的CPU时间百分比 hi 硬件CPU中断再用百分比 si软中断占用百分比
# 虚拟机占用百分比
%Cpu(s):  0.2 us,  0.1 sy,  0.0 ni, 99.7 id,  0.1 wa,  0.0 hi,  0.0 si,  0.0 st
# 内存信息
# total 物理内存总量 free 空闲内存总量	used 使用的物理内存总量  buff/cache 内核缓存的内存量
KiB Mem :  3882032 total,   211112 free,   166384 used,  3504536 buff/cache
# swap 
# total 交换区总总量	free 空闲交换区总量 used 使用的交换区总量 avail mem有效内存
KiB Swap:        0 total,        0 free,        0 used.  3409756 avail Mem
# PID-进程ID  USER-进程搜有者 PR-进程优先级 NI-nice值负值表示高优先级 正直表示低优先级
# VIRT-进程使用的虚拟内存总量,单位为KB  RES-进程使用的，未被换出来的物理内存大小
# SHR-共享内存大小，单位KB S-进程状态 D=不可中断的睡眠状态 R=睡眠 T=跟踪/停止 Z=僵尸进程
# %CPU-上次更新到现在的CPU时间占用百分比 %MEM-进程使用的物理内存百分比 
# TIME+/进程使用CPU时间总计，单位1/100秒
# COMMAND-进程名称
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
    1 root      20   0  123036   3736   2428 S   0.0  0.1   4:57.39 systemd
    
$ top  -d 2 //每隔俩秒显示所有进程的资源占用情况
$ top -p 4360,4345 //监控制度的进场
```

### pgrep/pkill/kill/w

pgrep命令以名称为依据从进程运行队列中查找进程，并显示查找到的进场id。每一个进程ID以一个十进制数表示，通过一个分割字符串和下一个ID分开，默认的分割字符串是一个新行。对于每个属性选项，用户可以在命令行上指定一个以逗号分割的可能值的集合。pkill命令可以按照进程名杀死进程。如果想要单独杀死某个进程可以使用kill命令，该命令给指定进程发送信号，大多数用于关闭进程。

```bash
usage: pgrep [选项] [参数]
选项:
  -o：仅显示找到的最小（起始）进程号；
  -n：仅显示找到的最大（结束）进程号；
  -l：显示进程名称；
  -P：指定父进程号；
  -g：指定进程组；
  -t：指定开启进程的终端；
  -u：指定进程的有效用户ID。
参数：
	进程名称，指定要查找的进场名称，同时也支持类似grep指令中匹配模式
实例：
	$ pgrep -u monsoon -l sh //显示用户为monsoon下名称为sh的进程ID
	
usage: pkill [选项] [参数]
选项：
  -o：仅向找到的最小（起始）进程号发送信号；
  -n：仅向找到的最大（结束）进程号发送信号；
  -P：指定父进程号发送信号；
  -g：指定进程组；
  -t：指定开启进程的终端。
参数:
	指定要查找的进程名称，同时也支持类似grep指令中的匹配模式。
实例:
	pkill gaim
	
	
usage: 
	kill [-s signal|-p] [-q sigval] [-a] [--] pid...
    kill -l [signal]
常用信号：
    0）用于测试进程是否存在
    1）SIGHUP:无需关闭进程让其重读配置文件
    2）SIGINT:中止正在运行的进程，相当于ctrl+c
    3) SIGQUIT:退出，相当于ctrl+\
    9) SIGKILL:强制杀死正在运行的进程
    15）SIGTERM:终止正在运行的进程
    18）SIGCONT:继续运行
    19）SIGSTOP:后台睡眠
指定信号方式：
    数字方式,如1
    信号完整名字，如SIGHUP
    信号简写，如HUP
```

w

w命令提供了当前登录的用户及其正在执行的进程的信息。

```bash
$ w
15:35  up  4:30, 3 users, load averages: 1.36 1.51 1.50
USER     TTY      FROM              LOGIN@  IDLE WHAT
monsoon  console  -                11:06    4:28 -
monsoon  s000     -                12:18    1:21 -bash
```



### 后台进程

要在后台启动一个进程，使用&符号，此时该进程不会从用户中读取输入，直到它被移动到前台。当然也可以使用Ctrl+z暂停执行一个程序并把它发送到后台，它会给禁止发送SIGSTOP信号，从而暂停它的执行，它会变为空闲。

```
$ ./weixin &
$ jobs
[1]+ Running  weinxin &

$ tar -cf backup.tar. backup/ ### 按下Ctrl + Z
$ jobs

要在后台继续运行上面被暂停的命令，使用bg命令
$ bg
# 要把后台进程发送到前台,使用fg命令以及人任务的ID，类似
$ jobs
$ fg %1
```

### 更改进程优先级

在linux系统中，所有活跃进程都有一个优先级以及nice值，有比点优先级进程有更高优先级的进场一般会获得更多的CPU时间。可以使用nice和renice命令更改优先级。在top命令的输出中，NI显示了进程的nice值。使用nice命令为进程设置nice值，一个普通用户可以给他拥有的进程设置0到20的nice值，只有root用户可以使用负值的nice值。

```bash
$ renice +8  1314
$ renice +8  2526
```

###进程资源限制

在Linux系统中，资源限制是指一个进程的执行过程中，它所能得到的资源限制，比如进程的core file的最大值，虚拟内存的最大值等。资源限制的大小可以直接影响程序的执行状况，其中资源限制分为soft limit和hard limit限制，soft limit是指内涵所能支持的资源上限。hard limit在资源中只能作为soft limit的上限，当设置了hard limit后，设置soft limit只能小于hard Limit。hard limit只真的对非特权进程。可以使用limits.conf配置该规则。另外可以使用ulimit命令来完成之源限制。

关于limits.conf的配置可以查阅相关文档.例如鸟哥的blog:

http://linux.vbird.org/linux_basic/0410accountmanager.php#limits

```bash
範例一：vbird1 這個用戶只能建立 100MB 的檔案，且大於 90MB 會警告
[root@study ~]# vim /etc/security/limits.conf
vbird1	soft		fsize		 90000
vbird1	hard		fsize		100000
#帳號   限制依據	限制項目 	限制值
# 第一欄位為帳號，或者是群組！若為群組則前面需要加上 @ ，例如 @projecta
# 第二欄位為限制的依據，是嚴格(hard)，還是僅為警告(soft)；
# 第三欄位為相關限制，此例中限制檔案容量，
# 第四欄位為限制的值，在此例中單位為 KB。
# 若以 vbird1 登入後，進行如下的操作則會有相關的限制出現！
```

**ulimit命令**用来限制系统用户对shell资源的访

```bash
usage: ulimit [选项]
选项：
    -a：显示目前资源限制的设定；
    -c <core文件上限>：设定core文件的最大值，单位为区块；
    -d <数据节区大小>：程序数据节区的最大值，单位为KB；
    -f <文件大小>：shell所能建立的最大文件，单位为区块；
    -H：设定资源的硬性限制，也就是管理员所设下的限制；
    -m <内存大小>：指定可使用内存的上限，单位为KB；
    -n <文件数目>：指定同一时间最多可开启的文件数；
    -p <缓冲区大小>：指定管道缓冲区的大小，单位512字节；
    -s <堆叠大小>：指定堆叠的上限，单位为KB；
    -S：设定资源的弹性限制；
    -t <CPU时间>：指定CPU使用时间的上限，单位为秒；
    -u <程序数目>：用户最多可开启的程序数目；
    -v <虚拟内存大小>：指定可使用的虚拟内存上限，单位为KB。
 实例:
 	$ ulimit -a
```

##### 

###进程分析

经常会遇到哪些名字很奇怪，不确定做什么的进程，次数就需要掌握一定的程序分析能力

#####线程

有时候需要查看某个进程的线程，在linux可以使用ps的top和htop等方式查看线程。

```bash
# ps命令查看线程
$ ps -T -p <pid>
实例
$ ps -ef | grep nginx
root     24827     1  0 3月05 ?       00:00:00 nginx: master process sbin/nginx
nobody   24828 24827  0 3月05 ?       00:00:08 nginx: worker process
opslab   30386 30360  0 23:16 pts/1    00:00:00 grep --color=auto nginx
[opslab@VM_0_14_centos ~]$ ps -T -p 24827
  PID  SPID TTY          TIME CMD
24827 24827 ?        00:00:00 nginx


# 使用Top
# 可以在top交互界面按H查看线程，但是那样不是很清晰
$ top -H -p <pid>
实例：
$ ps -ef | grep nginx
root     24827     1  0 3月05 ?       00:00:00 nginx: master process sbin/nginx
nobody   24828 24827  0 3月05 ?       00:00:08 nginx: worker process
opslab   30514 30360  0 23:19 pts/1    00:00:00 grep --color=auto nginx
$ top -H -p 24827
top - 23:19:46 up 77 days,  2:01,  2 users,  load average: 0.00, 0.01, 0.05
Threads:   1 total,   0 running,   1 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.2 us,  0.1 sy,  0.0 ni, 99.7 id,  0.1 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem :  3882032 total,   171240 free,   165604 used,  3545188 buff/cache
KiB Swap:        0 total,        0 free,        0 used.  3410716 avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND
24827 root      20   0   75952   1824    236 S  0.0  0.0   0:00.00 nginx
```



##### lsof/pstack/strace/ltrace

lsof是一个查看当前文件系统的工具，在linux下一切皆以文件的形式存在。lsof可以打开：

​	1.普通文件目录

​	2.网络文件

​	3.字符或设备文件

​	4.函数共享库

​	5.管道，命令管道

​	6.符号链接

​	7.NFSfile、网络socket、unix socket

关于lsof的输出字段的说明

* command 进程的民粹


* PID 进程的id


* PPID 父进程的ID


* USER 进程所有者
* PGID 进程所属组
* FD 文件描述符

  （1）cwd：表示current work dirctory，即：应用程序的当前工作目录，这是该应用程序启动的目录，除非它本身对这个目录进行更改
  （2）txt ：该类型的文件是程序代码，如应用程序二进制文件本身或共享库，如上列表中显示的 /sbin/init 程序
  （3）lnn：library references (AIX);
  （4）er：FD information error (see NAME column);
  （5）jld：jail directory (FreeBSD);
  （6）ltx：shared library text (code and data);
  （7）mxx ：hex memory-mapped type number xx.
  （8）m86：DOS Merge mapped file;
  （9）mem：memory-mapped file;
  （10）mmap：memory-mapped device;
  （11）pd：parent directory;
  （12）rtd：root directory;
  （13）tr：kernel trace file (OpenBSD);
  （14）v86  VP/ix mapped file;
  （15）0：表示标准输入
  （16）1：表示标准输出
  （17）2：表示标准错误
  一般在标准输出、标准错误、标准输入后还跟着文件状态模式：r、w、u等
  （1）u：表示该文件被打开并处于读取/写入模式
  （2）r：表示该文件被打开并处于只读模式
  （3）w：表示该文件被打开并处于
  （4）空格：表示该文件的状态模式为unknow，且没有锁定
  （5）-：表示该文件的状态模式为unknow，且被锁定
  同时在文件状态模式后面，还跟着相关的锁
  （1）N：for a Solaris NFS lock of unknown type;
  （2）r：for read lock on part of the file;
  （3）R：for a read lock on the entire file;
  （4）w：for a write lock on part of the file;（文件的部分写锁）
  （5）W：for a write lock on the entire file;（整个文件的写锁）
  （6）u：for a read and write lock of any length;
  （7）U：for a lock of unknown type;
  （8）x：for an SCO OpenServer Xenix lock on part      of the file;
  （9）X：for an SCO OpenServer Xenix lock on the      entire file;
  （10）space：if there is no lock.

* TYPE 文件类型，常见的文件类型

  * DIR 表示目录
  * CHR表示字符类型
  * BLK 块设备类型
  * UNIX UNIX套机字
  * FIFO 先进先出队列
  * IPV4 网络协议IP套接字

* DEVICE 指定磁盘的名称

* SIZE 文件的大小

* NODE 索引节点

* NAME 打开文件的确切名称

  ​

```bash
usage: lsof [选项]
选项:
  -a：列出打开文件存在的进程；
  -c<进程名>：列出指定进程所打开的文件；
  -g：列出GID号进程详情；
  -d<文件号>：列出占用该文件号的进程；
  +d<目录>：列出目录下被打开的文件；
  +D<目录>：递归列出目录下被打开的文件；
  -n<目录>：列出使用NFS的文件；
  -i<条件>：列出符合条件的进程。（4、6、协议、:端口、 @ip ）
  -p<进程号>：列出指定进程号所打开的文件；
  -u：列出UID号进程详情；
  -h：显示帮助信息；
  -v：显示版本信息。
实例：
$ lsof | more

  COMMAND    PID    USER   FD      TYPE             DEVICE   SIZE/OFF       NODE NAME
  loginwind  106 monsoon  cwd       DIR                1,4        992          2 /
  loginwind  106 monsoon  txt       REG                1,4    1241072 8590278304 /System/Library/CoreServices/loginwindow.app/Contents/MacOS/loginwindow

$ lsof /bin/bash //查找某个文件相关的进程
$ lsof -u username	//列出某个用户打开的文件信息
$ lsof -c mysql //列出某个进程打开的文件信息
$ lsof -u test -c mysql //列出某个用户以某个进程打开的文件信息
$ lsof -p 1314 //列出某个进程打开的文件
$ lsof -l //列出所有的网络连接
$ lsof -i tcp //列出搜优的tcp网络连接信息
$ lsof -i :3306 //列出谁在使用某个端口
$ lsof -a -u test -i //列出某个用户的所有活跃的网络端口
$ lsof -d descript // 根据文件描述符列出对应的文件信息
```

​	

pstack命令可以显示每个进程的栈跟踪，pstack命令必须由相应进程的属主或root运行，此命令允许使用的唯一选项是要检查的进程的PID。

```bash
ps -ef | grep top
opslab   11230 11196  0 16:24 pts/0    00:00:00 top
opslab   11237 11196  0 16:24 pts/0    00:00:00 grep --color=auto top

[1]+  已停止               top
[opslab@VM_0_14_centos ~]$ pstack 11230
#0  0x00007fa21ca991d7 in raise () from /lib64/libc.so.6
#1  0x00000000004071e2 in sig_paused ()
#2  <signal handler called>
#3  0x00007fa21cb51bac in tcsetattr () from /lib64/libc.so.6
#4  0x00000000004033ec in main ()
```

strace能追踪到一个程序所指向的系统调用，当想知道某个程序和操作系统如何交互的时候，使用该命令极其方便的，比如想知道执行了那些系统调用，并且以何种顺序执行。strace后面可以任何命令，它将列出许多的系统调用。

strace的最简单的用法就是执行一个指定的命令，在指定的命令结束之后它也就退出了，在命令执行的过程中，strace会记录和解析命令进程的所有系统调用以及这个进程所接收到的所有的信号值。(strace在linux下用来跟踪某个进程的系统调用,在solaris下，对应的是dtrace,在mac下，对应的命令是：dtruss)

```bash
strace  [  -dffhiqrtttTvxx  ] [ -acolumn ] [ -eexpr ] ...
    [ -ofile ] [-ppid ] ...  [ -sstrsize ] [ -uusername ]
    [ -Evar=val ] ...  [ -Evar  ]...
    [ command [ arg ...  ] ]

strace  -c  [ -eexpr ] ...  [ -Ooverhead ] [ -Ssortby ]
    [ command [ arg...  ] ]
    
选项:
  -c 统计每一系统调用的所执行的时间,次数和出错的次数等.
  -d 输出strace关于标准错误的调试信息.
  -f 跟踪由fork调用所产生的子进程.
  -ff 如果提供-o filename,则所有进程的跟踪结果输出到相应的filename.pid中,pid是各进程的进程号.
  -F 尝试跟踪vfork调用.在-f时,vfork不被跟踪.
  -h 输出简要的帮助信息.
  -i 输出系统调用的入口指针.
  -q 禁止输出关于脱离的消息.
  -r 打印出相对时间关于,,每一个系统调用.
  -t 在输出中的每一行前加上时间信息.
  -tt 在输出中的每一行前加上时间信息,微秒级.
  -ttt 微秒级输出,以秒了表示时间.
  -T 显示每一调用所耗的时间.
  -v 输出所有的系统调用.一些调用关于环境变量,状态,输入输出等调用由于使用频繁,默认不输出.
  -V 输出strace的版本信息.
  -x 以十六进制形式输出非标准字符串
  -xx 所有字符串以十六进制形式输出.
  -a column 设置返回值的输出位置.默认 为40.
  -e expr 指定一个表达式,用来控制如何跟踪.格式：[qualifier=][!]value1[,value2]...
  qualifier只能是 trace,abbrev,verbose,raw,signal,read,write其中之一.value是用来限定的符号或数字.默认的 qualifier是 trace.感叹号是否定符号.例如:-eopen等价于 -e trace=open,表示只跟踪open调用.而-etrace!=open 表示跟踪除了open以外的其他调用.有两个特殊的符号 all 和 none. 注意有些shell使用!来执行历史记录里的命令,所以要使用\\.
  -e trace=set 只跟踪指定的系统 调用.例如:-e trace=open,close,rean,write表示只跟踪这四个系统调用.默认的为set=all.
  -e trace=file 只跟踪有关文件操作的系统调用.
  -e trace=process 只跟踪有关进程控制的系统调用.
  -e trace=network 跟踪与网络有关的所有系统调用.
  -e strace=signal 跟踪所有与系统信号有关的 系统调用
  -e trace=ipc 跟踪所有与进程通讯有关的系统调用
  -e abbrev=set 设定strace输出的系统调用的结果集.-v 等与 abbrev=none.默认为abbrev=all.
  -e raw=set 将指定的系统调用的参数以十六进制显示.
  -e signal=set 指定跟踪的系统信号.默认为all.如 signal=!SIGIO(或者signal=!io),表示不跟踪SIGIO信号.
  -e read=set 输出从指定文件中读出 的数据.例如: -e read=3,5
  -e write=set 输出写入到指定文件中的数据.
  -o filename 将strace的输出写入文件filename
  -p pid 跟踪指定的进程pid.
  -s strsize 指定输出的字符串的最大长度.默认为32.文件名一直全部输出.
  -u username 以username的UID和GID执行被跟踪的命令

实例：
  $ strace -p 23488
  Process 23488 attached
  futex(0x817d70, FUTEX_WAIT, 0, NULL)    = 0
  epoll_wait(4, {{EPOLLOUT, {u32=2544143856, u64=140585413676528}}}, 128, 0) = 1
  pselect6(0, NULL, NULL, NULL, {0, 3000}, 0) = 0 (Timeout)
  futex(0x817d70, FUTEX_WAIT, 0, NULL)    = 0
  epoll_wait(4, {{EPOLLOUT, {u32=2544143856, u64=140585413676528}}}, 128, 0) = 1
  pselect6(0, NULL, NULL, NULL, {0, 3000}, 0) = 0 (Timeout)
  futex(0x817d70, FUTEX_WAIT, 0, NULL)    = 0
  epoll_wait(4, {{EPOLLOUT, {u32=2544143856, u64=140585413676528}}}, 128, 0) = 1
  epoll_wait(4, {{EPOLLIN, {u32=2544144240, u64=140585413676912}}}, 128, -1) = 1
  clock_gettime(CLOCK_MONOTONIC, {6636609, 10696304}) = 0
  futex(0x817598, FUTEX_WAKE, 1)          = 1
  accept4(3, {sa_family=AF_INET6, sin6_port=htons(51438), inet_pton(AF_INET6, "::ffff:127.0.0.1", &sin6_addr), sin6_flowinfo=0, sin6_scope_id=0}, [28], SOCK_CLOEXEC|SOCK_NONBLOCK) = 5
  
  // 跟踪系统调用
  $ strace ./xxx
  
  // 系统调用统计
  $ strace -c ./xxx
  
  // 统计现有的进程
  $ strace -p pid
  
  // 显示系统调用之间的相对时间戳
  $ strace -r ls
  
  // 使用保存结果
  $ strace -o process_strace.log -p pid
  
  // 跟踪指定的系统调用 如open、write
  $ strace -e open ls
  
  //查找程序读取的配置文件
  $ strace nginx 2>&1 | grep nginx.conf
```

ltrace命令是用来跟踪进程调用库函数的情况

```bash
usage: ltrace [选项] [参数]
选项:
  -a 对齐具体某个列的返回值。
  -c 计算时间和调用，并在程序退出时打印摘要。
  -C 解码低级别名称（内核级）为用户级名称。
  -d 打印调试信息。
  -e 改变跟踪的事件。
  -f 跟踪子进程。
  -h 打印帮助信息。
  -i 打印指令指针，当库调用时。
  -l 只打印某个库中的调用。
  -L 不打印库调用。
  -n, --indent=NR 对每个调用级别嵌套以NR个空格进行缩进输出。
  -o, --output=file 把输出定向到文件。
  -p PID 附着在值为PID的进程号上进行ltrace。
  -r 打印相对时间戳。
  -s STRLEN 设置打印的字符串最大长度。
  -S 显示系统调用。
  -t, -tt, -ttt 打印绝对时间戳。
  -T 输出每个调用过程的时间开销。
  -u USERNAME 使用某个用户id或组ID来运行命令。
  -V, --version 打印版本信息，然后退出。

实例:
	$ ltrace ./weixin
	
	//输出调用时间开销
	$ ltrace -T ./weixin
	
	// 显示系统调用
	$ ltrace -S ./weixin
	
```

#####ipcs/pmap/ldd/nm/size

ipcs该命令用于报告Linux中进程间通信设施的状态，显示的信息包括消息列表、共享内存和信号量的信息。

    usage: ipcs [选项]
    选项：
      -a：显示全部可显示的信息；
      -q：显示活动的消息队列信息；
      -m：显示活动的共享内存信息；
      -s：显示活动的信号量信息。
    实例:
    ipcs -a
    
    --------- 消息队列 -----------
    键        msqid      拥有者  权限     已用字节数 消息
    
    ------------ 共享内存段 --------------
    键        shmid      拥有者  权限     字节     nattch     状态
    
    --------- 信号量数组 -----------
    键        semid      拥有者  权限     nsems

pmap命令用于报告进程的内存映射关系，其实它原本是sun机器上的，在linux只有有限的功能。

    usage: pmap [选项] [参数]
    选项：
      -x：显示扩展格式；
      -d：显示设备格式；
      -q：不显示头尾行；
      -V：显示指定版本。
    实例:
      pmap -x 5371
      5371:   nginx: worker process                
      Address           Kbytes     RSS   Dirty Mode   Mapping
      0000000000400000     564     344       0 r-x--  nginx
      000000000068c000      68      68      60 rw---  nginx
      000000000069d000      56      12      12 rw---    [ anon ]
      000000000a0c8000    1812    1684    1684 rw---    [ anon ]
      0000003ac0a00000     112      40       0 r-x--  ld-2.5.so

ldd命令用于查看进程动态加载库的信息，运维的时候有时候需要定位依赖关系，可以使用该命令查看。

    usage: ldd [选项] [参数]
    选项：
      --version：打印指令版本号；
      -v：详细信息模式，打印所有相关信息；
      -u：打印未使用的直接依赖；
      -d：执行重定位和报告任何丢失的对象；
      -r：执行数据对象和函数的重定位，并且报告任何丢失的对象和函数；
      --help：显示帮助信息。
    参数：
    	指定可执行的程序或文件
    实例:
    $ ldd /bin/ls
    linux-vdso.so.1 (0x00007ffeeffc3000)
    libselinux.so.1 => /lib/x86_64-linux-gnu/libselinux.so.1 (0x00007f8e631c7000)

nm命令被用于显示二进制目标文件的符号表

    usage: nm [选项] [参数]
    选项:
      -A：每个符号前显示文件名；
      -D：显示动态符号；
      -g：仅显示外部符号；
      -r：反序显示符号表。

size 可以查看查询被映射到内存映像所占用的大小消息，程序映射到内存中，从低地址到高地址会分为不同的段。这些段依次为（并不一定固定）：

* 代码段

  该段自读，可共享.代码段code segment通常是指用来存放程序执行代码的一块内存区域。该部分的大小在程序运行前已经确定。（很重要的一个段）

* 数据段

  存储已被初始化了的静态数据，数据段data segment通常是指用来存放程序中已被初始化的全局变量的一块内存区域。

* BSS段

  BSS是Block STARTED BY SYMBOL的简称，该段属于静态内存分配，通常用是用来存放程序中未被初始化的全局变量的一块内存区域

* 堆Heap

  堆是用于存放进程运行中被动态分配的内存段，它的大小并不哭的，可动态伸缩。

* 栈stack

  栈又被成为堆栈，用来存放程序临时创建的变量，函数调用时参数等。

```bash
$ size /usr/bin/ls
   text	   data	    bss	    dec	    hex	filename
 102801	   4792	   3360	 110953	  1b169	/usr/bin/ls
```

##### objdump/readelf

objdump是用来显示二进制文件的信息，就是以一种可阅读的格式展现二进制文件可能附加信息.

```bash
usage: objdump [选项] [参数]
常用选项:
  -f 显示文件头信息
  -D 反汇编所有section (-d反汇编特定section)
  -h 显示目标文件各个section的头部摘要信息
  -x 显示所有可用的头信息，包括符号表、重定位入口。-x 等价于 -a -f -h -r -t 同时指定。
  -i 显示对于 -b 或者 -m 选项可用的架构和目标格式列表。
  -r 显示文件的重定位入口。如果和-d或者-D一起使用，重定位部分以反汇编后的格式显示出来。
  -R 显示文件的动态重定位入口，仅仅对于动态目标文件有意义，比如某些共享库。
  -S 尽可能反汇编出源代码，尤其当编译的时候指定了-g这种调试参数时，效果比较明显。隐含了-d参数。
  -t 显示文件的符号表入口。类似于nm -s提供的信息
  
实例:
	$ objdump -i //查看文本是大端还是小端
	$ objdump -d main.o //反汇编
	
```

readelf 该用具和objdump命令提供的功能类似，只是更具体些，并且它不依赖于BFD库。

```bash
usage: readelf [选项] [参数]
常用选项:
	a –all 全部 等价于: -h -l -S -s -r -d -V -A -I

	-h –file-header 文件头

	-l –program-headers 程序 

	–segments An alias for –program-headers

	-S –section-headers 段头 Display the sections’ header

	--sections	
	An alias for –section-headers

	-e –headers 全部头 等价于: -h -l -S
	
实例：
	$ readelf -h /usr/bin/ls
    ELF 头：
      Magic：  7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
      Class:                             ELF64
      Data:                              2's complement, little endian
      Version:                           1 (current)
      OS/ABI:                            UNIX - System V
      ABI Version:                       0
      Type:                              EXEC (可执行文件)
      Machine:                           Advanced Micro Devices X86-64
      Version:                           0x1
      入口点地址：              0x404b48
      程序头起点：              64 (bytes into file)
      Start of section headers:          115696 (bytes into file)
      标志：             0x0
      本头的大小：       64 (字节)
      程序头大小：       56 (字节)
      Number of program headers:         9
      节头大小：         64 (字节)
      节头数量：         30
      字符串表索引节头： 29
```





