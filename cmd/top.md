# title{top - 用于实时显示 process 的动态}
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
  


```


			前五行是系统整体的统计信息。
			第一行: 任务队列信息，同 uptime 命令的执行结果。内容如下：
				01:06:48 当前时间
				up 1:22 系统运行时间，格式为时:分
				1 user 当前登录用户数
				load average: 0.06, 0.60, 0.48 系统负载，即任务队列的平均长度。
				三个数值分别为 1分钟、5分钟、15分钟前到现在的平均值。

			第二、三行:为进程和CPU的信息。当有多个CPU时，这些内容可能会超过两行。内容如下：
				Tasks: 29 total 进程总数
				1 running 正在运行的进程数
				28 sleeping 睡眠的进程数
				0 stopped 停止的进程数
				0 zombie 僵尸进程数
				Cpu(s): 0.3% us 用户空间占用CPU百分比
				1.0% sy 内核空间占用CPU百分比
				0.0% ni 用户进程空间内改变过优先级的进程占用CPU百分比
				98.7% id 空闲CPU百分比
				0.0% wa 等待输入输出的CPU时间百分比
				0.0% hi
				0.0% si

			第四、五行:为内存信息。内容如下：
				Mem: 191272k total 物理内存总量
				173656k used 使用的物理内存总量
				17616k free 空闲内存总量
				22052k buffers 用作内核缓存的内存量
				Swap: 192772k total 交换区总量
				0k used 使用的交换区总量
				192772k free 空闲交换区总量
				123988k cached 缓冲的交换区总量。
				内存中的内容被换出到交换区，而后又被换入到内存，但使用过的交换区尚未被覆盖，
				该数值即为这些内容已存在于内存中的交换区的大小。
				相应的内存再次被换出时可不必再对交换区写入。

			进程信息区,各列的含义如下:  # 显示各个进程的详细信息

			序号 列名    含义
			a   PID      进程id
			b   PPID     父进程id
			c   RUSER    Real user name
			d   UID      进程所有者的用户id
			e   USER     进程所有者的用户名
			f   GROUP    进程所有者的组名
			g   TTY      启动进程的终端名。不是从终端启动的进程则显示为 ?
			h   PR       优先级
			i   NI       nice值。负值表示高优先级，正值表示低优先级
			j   P        最后使用的CPU，仅在多CPU环境下有意义
			k   %CPU     上次更新到现在的CPU时间占用百分比
			l   TIME     进程使用的CPU时间总计，单位秒
			m   TIME+    进程使用的CPU时间总计，单位1/100秒
			n   %MEM     进程使用的物理内存百分比
			o   VIRT     进程使用的虚拟内存总量，单位kb。VIRT=SWAP+RES
			p   SWAP     进程使用的虚拟内存中，被换出的大小，单位kb。
			q   RES      进程使用的、未被换出的物理内存大小，单位kb。RES=CODE+DATA
			r   CODE     可执行代码占用的物理内存大小，单位kb
			s   DATA     可执行代码以外的部分(数据段+栈)占用的物理内存大小，单位kb
			t   SHR      共享内存大小，单位kb
			u   nFLT     页面错误次数
			v   nDRT     最后一次写入到现在，被修改过的页面数。
			w   S        进程状态。
				D=不可中断的睡眠状态
				R=运行
				S=睡眠
				T=跟踪/停止
				Z=僵尸进程
			x   COMMAND  命令名/命令行
			y   WCHAN    若该进程在睡眠，则显示睡眠中的系统函数名
			z   Flags    任务标志，参考 sched.h


```bash
# Update every <interval> samples:
#更新每个<interval>样本：
top -i <interval>

# Set the delay between updates to <delay> seconds:
#将更新之间的延迟设置为<delay>秒：
top -s <delay>

# Set event counting to accumulative mode:
#将事件计数设置为累积模式：
top -a

# Set event counting to delta mode:
#将事件计数设置为增量模式：
top -d

# Set event counting to absolute mode:
#将事件计数设置为绝对模式：
top -e

# Do not calculate statistics on shared libraries, also known as frameworks:
#不要计算共享库的统计信息，也称为框架：
top -F

# Calculate statistics on shared libraries, also known as frameworks (default):
#计算共享库的统计信息，也称为框架（默认）：
top -f

# Print command line usage information and exit:
#打印命令行使用信息并退出：
top -h

# Order the display by sorting on <key> in descending order
#通过按降序排序<key>来排序显示
top -o <key>

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
