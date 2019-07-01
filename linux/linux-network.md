---
title: 细说Linux的网络篇
date: 2018-02-05 21:32:55
tags: Linux
---

再说linux网络前先需要确认设备的一些信息，比如网卡类型，网卡的速度等等。在linux可以通过网卡的设备名称区分网卡的类型，例如

```bash
## 查看网卡的型号
# lspci | grep -i ethernet
00:03.0 Ethernet controller: Red Hat, Inc Virtio network device

## 查看网卡的具体信息 注意Speed字段的值为网卡支支持的速度
# ethtool eth0
Settings for eth0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full 
                                100baseT/Half 100baseT/Full 
                                1000baseT/Full 
        Supports auto-negotiation: Yes
        Advertised link modes:  10baseT/Half 10baseT/Full 
                                100baseT/Half 100baseT/Full 
                                1000baseT/Full 
        Advertised auto-negotiation: Yes
        Speed: 1000Mb/s
        Duplex: Full
        Port: Twisted Pair
        PHYAD: 1
        Transceiver: internal
        Auto-negotiation: on
        Supports Wake-on: pumbag
        Wake-on: g
        Current message level: 0x00000001 (1)
        Link detected: yes
```

判断带宽，服务器的带宽说简单也简单，说难确实也很难，在无配置的情况下可以使用curl和wget请求一个外部文件以此可以判断(反向判断)或者在线个网站测速。而网上很多都会说用iperf测试，但是需要你手上有一台外网的服务器。

## 网络配置

在不同的Linux发型版中网络配置可能有所差别，但其本质都是一致的，在Ubuntu下/etc/network/interfaces以及在/etc/network/options中配置网络信息。而在RedHat系列中则在/etc/sysconfig/network-scripts/ifcfg-ifname配置。无论在哪里配置都可以使用ifconfig命令查看这些网络配置，下面是ifconfig命的常用参数和实例。

```bash
usage : ifconfig [网络设备] [参数]
descript :ifconfig命令用来查看和配置网络设备，当网络环境发生改变时可通过此命令对网络进行相应的配置。
     用ifconfig命令配置的网卡信息，在网卡重启后机器重启后，配置就不存在。要想将上述的配置信息永远的
     存在电脑里，那就要修改网卡的配置文件了。
param:
	- up 		启动指定网络设备/网卡。
	- down 　 	关闭指定网络设备/网卡。该参数可以有效地阻止通过指定接口的IP信息流，
	-a　　　　　　 无论是否激活，显示所有配置的网络接口。
    -add 　　　　  　　 给指定网卡配置IPv6地址
    -del　　　　　　　　  删除指定网卡的IPv6地址
    -arp|-arp　　　 　　  打开或关闭支持ARP协议
    -mtu<字节数>  　　  设置网卡的最大传输单元
    -netmask<子网掩码> 设置网卡的子网掩码
 example:
 	查看网络信息
 	#ifconfig
 	打开和关闭指定网卡
 	# ifconfig eno16777736 down
 	启用和关闭ARP
 	# ifconfig eno16777736 arp
 	# ifconfig eno16777736 -arp 
	设置网卡的mac地址
	# ifconfig eno16777736 hw ether 00:0c:29:4d:a3:dd
```

## 网络可用性测试

网络可用性测试其实很简单，简单的说就是能上网即可。linux中提供了ping、route、traceroute、nslookup、netstat、dig、几个命令即可完整的测试网络的可用性。当然有mrt这样的组合工具，但是其不是所有主机上都有。

#####Ping

它通过向目标主机发送一个个数据包以及接受数据包的回应来判断主机和目标主机之间网络连接情况。ping的两个功能：判断网络是否可达、网络性能统计。

```bash
usage: ping 【选项】 目标主机或IP地址
descript: ping使用的是网络层的ICMP协议。
params:
  -c设置数据包的数量
  -s设置数据包的大小，默认为64字节（包括8字节ICMP协议头、56字节测试数据、20字节IP协议头）
  -t设置数据包的生存期（TTL）
  -i设置数据包的间隔，默认为1s
  -R记录路由过程
  -r忽略普通的路由表，直接将数据包发送到远程主机上
  -v详细显示命令的执行过程
  -P设置填满数据包的范本样式
  -f极限检测，以最小的间隔来测试
  -I设置指定的网络接口发送数据包
  
example
  # ping -c 2  www.baidu.com
  PING www.a.shifen.com (61.135.169.125) 56(84) bytes of data.
  64 bytes from 61.135.169.125 (61.135.169.125): icmp_seq=1 ttl=55 time=1.97 ms
  64 bytes from 61.135.169.125 (61.135.169.125): icmp_seq=2 ttl=55 time=1.66 ms
  报文尺寸　　　　目标设备主机名或IP　　　　　　　　　　 序号　　　　生存期  往返时间

  --- www.a.shifen.com ping statistics ---统计信息摘要
  2 packets transmitted, 2 received, 0% packet loss, time 1001ms
  发送包数　　　　　　　　　　接受包数　　　　丢包率　　　　　　响应时间　　　　　　
  rtt min/avg/max/mdev = 1.666/1.821/1.977/0.161 ms
  应答计算最小值/平均值/最大值/


```

##### netstat 

是network statistics的缩写，主要用于检测主机（本机）的网络配置和状况，用于查看与IP、TCP、UDP、ICMP协议相关的统计数据，可以查看显示网络连接（包括进站和出战）、系统路由表、网络接口状态等。

网络状态:

从客户端看其状态变化为:CLOSED->SYN_SENT->ESTABLISHED->FIN_WAIT_1->FIN_WAIT_2->TIME_WAIT->CLOSED

从服务端看其状态变化为:CLOSED->LISTEN->SYN_RECVD->ESTABLISHED->CLOSE_WAIT->LAST_ACK->CLOSED

下面是个个状态的描述:

```bash
*ESTABLISHED
	The socket has an established connection.
	套接字有一个已建立的连接。
*SYN_SENT
	The socket is actively attempting to establish a connection. 
	套接字正在积极地尝试建立连接。
*SYN_RECV
	A connection request has been received from the network.
	已从网络接收到连接请求。
*FIN_WAIT1
	The socket is closed, and the connection is shutting down.
	套接字关闭，连接关闭。
*FIN_WAIT2
	Connection is closed, and the socket is waiting for a shutdown from the remote end.
	连接关闭，而套接字正在等待远程结束的关闭。
*TIME_WAIT
	The socket is waiting after close to handle packets still in the network.
	该套接字在接近处理网络中的数据包后等待。
*CLOSED
	The socket is not being used.
	套接字没有被使用。
*CLOSE_WAIT
 	The remote end has shut down, waiting for the socket to close.
 	远端关闭，等待套接字关闭。
*LAST_ACK
	The remote end has shut down, and the socket is closed. Waiting for acknowledgement.
	远端关闭，套接字关闭。等待确认。
*LISTEN
	The  socket is listening for incoming connections.  套接字是监听传入的连接。
*CLOSING
	Both sockets are shut down but we still don’t have all our data sent.
	两个套接字都关闭了，但我们仍然没有所有的数据发送。
*UNKNOWN
	The state of the socket is unknown.
	套接字的状态未知。

```

```bash
useage: netstat 【选项】
descript:查看linux本机的状况
param:
  -r——显示当前主机路由表信息
  -a——显示当前所有开放的端口（比默认还要多几个)
  -t——显示tcp传输协议的连接状况，等加于netstat | grep tcp 但-t更快
  -u——显示udp传输协议的连接状况，等价于netstat | grep udp
  -i——显示所有网络接口的统计信息表
  -l——显示正处于监听状态的服务和端口
  -p——显示正在使用端口的服务进程号和服务程序名称
  -c——持续列出网络状态，监控连接情况
  -n——以数字的形式显示IP地址和端口号
  -e——显示以太网的统计信息，此项可以与a组合使用
example 
  $ netstat -atn
  Active Internet connections (servers and established)
  协议   收　　　送　　　本地地址　　　　　　　　　　与本地连接的远程主机地址　　连接状态
  Proto Recv-Q Send-Q Local Address           Foreign Address         State      
  tcp        0      0 0.0.0.0:42081           0.0.0.0:*               LISTEN         
  tcp        0      1 172.30.0.54:47570       74.125.204.102:443      SYN_SENT     
  tcp        0      0 172.30.0.54:32840       165.254.134.121:80      ESTABLISHED
  tcp        0      1 172.30.0.54:47568       74.125.204.102:443      SYN_SENT   
  tcp6       0      0 :::56937                :::*                    LISTEN       

  State——表示连接状态，
  		常见的状态有listen（表示监听状态，等待接收入站的请求）、
  		established（表示本机已经与其他主机建立好连接）、
  		time_wait(等待足够的时间以确保远程TCP接收连接中断请求的确认)、
  		syn sent（尝试发起连接）、
  		syn recv（接受发起的连接）等
  
  # 查看所有连接
  $ netstat -a
  # 查看所有tcp连接
  $ netstat -at
  # 查看所有udp连接
  $ netstat -au
  # 查看所有unixsocket连接
  $ netstat -ax
  # 同时列出进场信息
  $ netstat -ap
  # 查看服务器当前的网络连接情况
  $ netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
  # 所有链接到本机的IP
  $ netstat -nut | awk '$NF=="ESTABLISHED" {print $5}' | cut -d: -f1 | sort -u
  # 查看网络监听
  $ netstat -ntlp
  $ netstat -nulp
  $ netstat -nxlp
  # 将会显示使用该端口的应用程序的进程id
  $ netstat -nap | grep port 
  # 将会显示包括TCP和UDP的所有连接
  $ netstat -a  or netstat –all
  # 将会显示TCP连接   
  $ netstat --tcp  or netstat –t 
  # 将会显示UDP连接
  $ netstat --udp or netstat –u 
  # 将会显示该主机订阅的所有多播网络。
  $ netstat -g 
  # 有些服务器上没安装telnet等命名跟没有nmap,此时想看远程端口是否开放？
  $ echo >/dev/tcp/8.8.8.8/53 && echo "open"
  # 用netstat显示所有tcp4监听端口
  $ netstat -lnt4 | awk '{print $4}' | cut -f2 -d: | grep -o '[0-9]*'
```

##### route

该命令用来显示并设置Linux内核中的网络路由表，主要设置静态路由。

```bash
usage: route (选项) 参数
选项:
    -A：设置地址类型；
    -C：打印将Linux核心的路由缓存；
    -v：详细信息模式；
    -n：不执行DNS反向查找，直接显示数字形式的IP地址；
    -e：netstat格式显示路由表；
    -net：到一个网络的路由表；
    -host：到一个主机的路由表。
 参数:
    Add：增加指定的路由记录；
    Del：删除指定的路由记录；
    Target：目的网络或目的主机；
    gw：设置默认网关；
    mss：设置TCP的最大区块长度（MSS），单位MB；
    window：指定通过路由表的TCP连接的TCP窗口大小；
    dev：路由记录所表示的网络接口。
 实例:
 	# 显示当前路由
 	$ route
 	# 增加一条到达244.0.0.0的路由。
 	$ route add -net 224.0.0.0 netmask 240.0.0.0 dev eth0
 	# 删除路由
 	$ route del -net 224.0.0.0 netmask 240.0.0.0
 	# 删除网关
 	$ route del default gw 192.168.120.240
```

##### traceroute

命令用于追踪数据包在网络上的传输时的全部路径，它默认发送的数据包大小是40字节

```bash
usage: traceroute(选项)(参数)
选项:
  -d：使用Socket层级的排错功能；
  -f<存活数值>：设置第一个检测数据包的存活数值TTL的大小；
  -F：设置勿离断位；
  -g<网关>：设置来源路由网关，最多可设置8个；
  -i<网络界面>：使用指定的网络界面送出数据包；
  -I：使用ICMP回应取代UDP资料信息；
  -m<存活数值>：设置检测数据包的最大存活数值TTL的大小；
  -n：直接使用IP地址而非主机名称；
  -p<通信端口>：设置UDP传输协议的通信端口；
  -r：忽略普通的Routing Table，直接将数据包送到远端主机上。
  -s<来源地址>：设置本地主机送出数据包的IP地址；
  -t<服务类型>：设置检测数据包的TOS数值；
  -v：详细显示指令的执行过程；
  -w<超时秒数>：设置等待远端主机回报的时间；
  -x：开启或关闭数据包的正确性检验。
 实例:
 	# 测试到google.com的路由
 	$ traceroute www.google.com
 	# 设置跳转
 	$ traceroute -m 10 www.google.com
 	# 知道断开
 	$ traceroute -p 10086 www.google.com
 	# 绕过正常的路由表，直接发送到网络相连的主机
 	$ traceroute -r www.google.com
 	# 把对外发探测包的等待响应时间设置为3秒
 	$ traceroute -w 3 www.google.com
 	
```

##### nslookup + dig

Linux中和dns有关的配置分别为:host文件,网卡知道的dns服务地址,resolv.conf指定的服务。在linux可以使用nslookup和dig来查询域名解析的工具。

```bash
usage: nslookup (选项) 参数
选项: 
	-sil：不显示任何警告信息。
实例:
	$ nslookup www.google.com

usage: dig (选项) 参数
选项:
  @<服务器地址>：指定进行域名解析的域名服务器；
  -b<ip地址>：当主机具有多个IP地址，指定使用本机的哪个IP地址向域名服务器发送域名查询请求；
  -f<文件名称>：指定dig以批处理的方式运行，指定的文件中保存着需要批处理查询的DNS任务信息；
  -P：指定域名服务器所使用端口号；
  -t<类型>：指定要查询的DNS数据类型；
  -x<IP地址>：执行逆向域名查询；
  -4：使用IPv4；
  -6：使用IPv6；
  -h：显示指令帮助信息。
实例:
	# 查看域名
	$ dig www.google.com
	# 查看MX记录
	$ dig www.google.com -t MX
	# 查看CNAME
	$ dig www.google.com -t CNAME
	# 指定dns，例如查询8.8.8.8中的0opslab.com记录
	$ dig +short @8.8.8.8 0opslab.com
	# 查看完整的解析信息
	$ dig +trace 0opslab.com
```

## 网络监控

网络监控不论是开发还是运维都应实时掌握的一个数据，在平时开发中有云服务提供的监控界面，和统一部署的监控工具zabbix和nagios等服务。但是利用系统默认提供的命令查看和监控网络也是必备技能。系统提供的常用工具有,tcpdump,dstat等。另外有一些比较好用的第三方监控软件,iftop,iptraf,nload等。

* 监控总体带宽使用――nload、bmon、slurm、bwm-ng、cbm、speedometer和netload
* 监控总体带宽使用（批量式输出）――vnstat、ifstat、dstat和collectl
* 每个套接字连接的带宽使用――iftop、iptraf、tcptrack、pktstat、netwatch和trafshow
* 每个进程的带宽使用――nethogs

### tcpdump

说道网络监控，在linux有款工具不得不说，它就是tcpdump，他是一款命令行下的sniffer工具，dump the traffic on a network，根据使用者的定义对网络上的数据包进行截获的包分析工具。 tcpdump可以将网络中传送的数据包的“头”完全截获下来提供分析。它支 持针对网络层、协议、主机、网络或端口的过滤，并提供and、or、not等逻辑语句来帮助你去掉无用的信息。

```bash
usage :tcpdum (选项)
选项:
  -a：尝试将网络和广播地址转换成名称；
  -c<数据包数目>：收到指定的数据包数目后，就停止进行倾倒操作；
  -d：把编译过的数据包编码转换成可阅读的格式，并倾倒到标准输出；
  -dd：把编译过的数据包编码转换成C语言的格式，并倾倒到标准输出；
  -ddd：把编译过的数据包编码转换成十进制数字的格式，并倾倒到标准输出；
  -e：在每列倾倒资料上显示连接层级的文件头；
  -f：用数字显示网际网络地址；
  -F<表达文件>：指定内含表达方式的文件；
  -i<网络界面>：使用指定的网络截面送出数据包；
  -l：使用标准输出列的缓冲区；
  -n：不把主机的网络地址转换成名字；
  -N：不列出域名；
  -O：不将数据包编码最佳化；
  -p：不让网络界面进入混杂模式；
  -q ：快速输出，仅列出少数的传输协议信息；
  -r<数据包文件>：从指定的文件读取数据包数据；
  -s<数据包大小>：设置每个数据包的大小；
  -S：用绝对而非相对数值列出TCP关联数；
  -t：在每列倾倒资料上不显示时间戳记；
  -tt： 在每列倾倒资料上显示未经格式化的时间戳记；
  -T<数据包类型>：强制将表达方式所指定的数据包转译成设置的数据包类型；
  -v：详细显示指令执行过程；
  -vv：更详细显示指令执行过程；
  -x：用十六进制字码列出数据包资料；
  -w<数据包文件>：把数据包数据写入指定的文件。
实例:
	# 截取所有数据包
	$ tcpdump
	# 监视指定接口上的数据包
	$ tcpdump -i eth1
	# 打印所有进入或离开sundown的数据包
	$ tcpdump host sundown
	# 也可以指定ip,例如截获所有210.27.48.1 的主机收到的和发出的所有的数据包
	$ tcpdump host 210.27.48.1 
	# 打印所有hello 月hot或者与ace之间的通信包
	$ tcpdump host hello and \( hot or ace \)
	# 主机210.27.48.1 和主机210.27.48.2 或210.27.48.3的通信
	$ tcpdump host 210.27.48.1 and \ (210.27.48.2 or 210.27.48.3 \)
	# 打印ace与任何其他主机之间通信的IP 数据包, 但不包括与helios之间的数据包.
	$ tcpdump ip host ace and not helios
	# 如果想要获取主机210.27.48.1除了和主机210.27.48.2之外所有主机通信的ip包，使用命令：
	$ tcpdump ip host 210.27.48.1 and ! 210.27.48.2
	# 截获主机hostname发送的所有数据
	$ tcpdump -i eth0 src host hostname
	# 监视所有送到主机hostname的数据包
	$ tcpdump -i eth0 dst host hostname
 	# 如果想要获取主机210.27.48.1接收或发出的telnet包，使用如下命令
	$ tcpdump tcp port 23 and host 210.27.48.1
	# 对本机的udp 123 端口进行监视 123 为ntp的服务端口
	$ tcpdump udp port 123 
```

### dstat

dstat命令是一个用来替换vmstat、iostat、netstat、和ifstat这些工具的。是一个全能系统信息统计工具。dstat非常强大，可以实时的监控cpu、磁盘、网络、IO、内存等使用情况,与sysstat相比，dstat拥有一个彩色的界面，在手动观察性能状况时，数据比较显眼容易观察；而且dstat支持即时刷新，譬如输入`dstat 3`即每三秒收集一次，但最新的数据都会每秒刷新显示。和sysstat相同的是，dstat也可以收集指定的性能资源，譬如`dstat -c`即显示CPU的使用情况。

```bash
usage:
	dstat [-afv] [options] [delay [count]]
params:
	# dstat --list 可以查看dstat能使用的所有参数
	-c,--cpu 统计CPU状态，包括 user, system, idle, 等待磁盘IO,硬件中断,软件中断等；
	-d, --disk 统计磁盘读写状态
	-D total,sda 统计指定磁盘或汇总信息
	-l, --load 统计系统负载情况，包括1分钟、5分钟、15分钟平均值
	-m, --mem 统计系统物理内存使用情况，包括used, buffers, cache, free
	-s, --swap 统计swap已使用和剩余量
	-n, --net 统计网络使用情况，包括接收和发送数据
	-N eth1,total  统计eth1接口汇总流量
	-r, --io 统计I/O请求，包括读写请求
	-p, --proc 统计进程信息，包括runnable、uninterruptible、new
	-y, --sys 统计系统信息，包括中断、上下文切换
	-t 显示统计时时间，对分析历史数据非常有用
	--fs 统计文件打开数和inodes数
	--nocolor 不显示颜色
	--socket 显示网络统计数据
	--tcp 显示常用的tcp统计
	--udp 监听的UDP接口及其当前用量的一些动态数据
另外dstat附带了一些强大的插件，可以通用/usr/share/dstat查看。常用的有
	--dist-util 显示某一时间磁盘的忙碌情况
	--freespace 显示当前磁盘的使用率
	--proc-count 显示正在运行的程序数量
	--top-bio 显示块I/O最大的进场
	--top-cpu 显示CPU占用最大的进程
	--top-io 显示正常I/O最大的进程
	--top-mem 显示占用最多内存的进场
	
example:
# dstat
//cpu-usgae
//usr 用户进场消耗cpu的时间百分比 sys内核进程消耗的CPU时间百分比 
//idl CPU处在空闲状态时间百分比
//wai IO等待消耗的CPU时间百分比 
//hiq 硬中断 siq 软中断
----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw
  0   0  99   0   0   0|7706B  164k|   0     0 |   0     0 | 189   225
  0   0 100   0   0   0|   0     0 |4436B  826B|   0     0 | 195   248
  
# dstat --top-mem --top-io --top-cpu
--most-expensive- ----most-expensive---- -most-expensive-
  memory process |     i/o process      |  cpu process
systemd-jour23.0M|weixin        0     0 |barad_agent  0.0

//查看系统负载
# dstat -l
//查看系统内存
# dstat -m
// 查看内存占用
# dstat -g -l -m -s --top-mem
// 输出一个csv文件
# dstat --output /tmp/sampleoutput.csv -cdn
// 查看cpu、disk、net、page、system的信息 没10秒更新一次
# dstat 10
//将监控信息保存的文件中
# dstat 10 --output /tmp/ds.csv
//监控swap，process，sockets，filesystem并显示监控的时间
# dstat -tsp --socket --fs
// 监控当前最消耗IO的进程和最消耗块设备IO的进程
# dstat -t --top-io-adv --top-bio-adv
// 监控当时最耗CPU/BLOCK IO/内存/IO的进程
# dstat --top-cpu --top-bio --top-mem --top-io
//查看全部内存都有谁在占用
# dstat -g -l -m -s --top-mem
//显示一些关于CPU资源损耗的数据
#dstat -c -y -l --proc-count --top-cpu
```

对于高速主机上利用iftop等基于libpacp库的工具来说不能完美的工作，此时可以直接查看相应的系统文件记录。利润eth0网卡是的数据信息，可以直接查看对应的文件

- /sys/class/net/eth0/statistics/rx_packets: 收到的数据包数据
- /sys/class/net/eth0/statistics/tx_packets: 传输的数据包数量
- /sys/class/net/eth0/statistics/rx_bytes: 接收的字节数
- /sys/class/net/eth0/statistics/tx_bytes: 传输的字节数
- /sys/class/net/eth0/statistics/rx_dropped: 当收到包数据包下降的数据量
- /sys/class/net/eth0/statistics/tx_dropped: 传输包数据包下降的数据量

这些数据会根据内核数据发生变更的时候自动刷新。因此，你可以编写一系列的脚本进行分析并计算流量统计