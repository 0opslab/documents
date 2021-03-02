# title{iptables - 一款功能强大的防火墙}

内建三个表：nat mangle 和 filter
filter预设规则表，有INPUT、FORWARD 和 OUTPUT 三个规则链
vi /etc/sysconfig/iptables    # 配置文件
INPUT    # 进入
FORWARD  # 转发
OUTPUT   # 出去
ACCEPT   # 将封包放行
REJECT   # 拦阻该封包
DROP     # 丢弃封包不予处理
-A	     # 在所选择的链(INPUT等)末添加一条或更多规则
-D       # 删除一条
-E       # 修改
-p	     # tcp、udp、icmp	0相当于所有all	!取反
-P       # 设置缺省策略(与所有链都不匹配强制使用此策略)
-s	     # IP/掩码	(IP/24)	主机名、网络名和清楚的IP地址 !取反
-j	     # 目标跳转，立即决定包的命运的专用内建目标
-i	     # 进入的（网络）接口 [名称] eth0
-o	     # 输出接口[名称] 
-m	     # 模块
--sport  # 源端口
--dport  # 目标端口


iptables -F                        # 将防火墙中的规则条目清除掉  # 注意: iptables -P INPUT ACCEPT
iptables-restore < 规则文件        # 导入防火墙规则
/etc/init.d/iptables save          # 保存防火墙设置
/etc/init.d/iptables restart       # 重启防火墙服务
iptables -L -n                     # 查看规则
iptables -t nat -nL                # 查看转发


```bash
$ ls /lib/modules/3.13.0-24-generic/kernel/net/ipv4/netfilter/
arptable_filter.ko  iptable_raw.ko       ipt_MASQUERADE.ko     nf_defrag_ipv4.ko     nf_tables_arp.ko
arp_tables.ko       iptable_security.ko  ipt_REJECT.ko         nf_nat_h323.ko        nf_tables_ipv4.ko
arpt_mangle.ko      ip_tables.ko         ipt_rpfilter.ko       nf_nat_ipv4.ko        nft_chain_nat_ipv4.ko
iptable_filter.ko   ipt_ah.ko            ipt_SYNPROXY.ko       nf_nat_pptp.ko        nft_chain_route_ipv4.ko
iptable_mangle.ko   ipt_CLUSTERIP.ko     ipt_ULOG.ko           nf_nat_proto_gre.ko   nft_reject_ipv4.ko
iptable_nat.ko      ipt_ECN.ko           nf_conntrack_ipv4.ko  nf_nat_snmp_basic.ko
```
从上图中可以清晰的发现，它是在modules中在内核的net包下，当然ipv4和ipv6包下分别
存放着对应于IPV4和IPV6网络下的模块。从2.6版本的linux开始，开发者希望完成与网络
无关的模块，即同一模块既可以工作IPV4下也可以工作在IPV6下，但就目前来看，还存在
一段的距离。
# netFilter的结构
NetFilter是模块的形式存在于Linux中，这些模块只是提供了某些过滤匹配的功能，如果希
望NetFilter能做些事情，就必须给予相应的规则给NetFilter，有了规则后，NetFilter才
会知道那些数据包是可以被接受的，那些数据包是必须丢弃的，又有那些数据必须以特定的
方式来处理
NetFilter的规则是以表的形式存放在内存中,分别是filter/nat/mangle/raw表，这样是目前
netFilter机制的四大功能。
# filter表
filter是netfilter中最重要的机制，其任务就是执行数据包的过滤操作，也就是防火墙的作用
## INPUT链
网络上其他主机发送给本机进程的数据包
## FORWARD链
数据包对本机而言只是路过，即本机只起转发作用。
## OUTPUT链
本机进程产生的对外的数据包

# nat表
也是防火墙上一个不可以或缺的重要机制，起到IP分享器的作用。
## PREROUTING链
## POSTROUTING链
## OUTPUT链
# Mangle表
是一个特殊的机制，可以通过mangle机制来修改已经过防火墙内数据包的内容
## PREROUTING链
## INPUT链
## FORWARD链
## OUTPUT链
## POSTROUTING链

# raw表
负责加快数据包穿过防火墙机制的速度
## PREROUTING链
## OUTPUT链

# filter的工作机制
![iptables-filter](image/linux/iptables-filter.png)
上图是整个数据包进入防火墙filter表后出来的流程。而每个链中都回存在若干的规则，
这些规则将作用于数据包的匹配，每个链中包含的匹配规则不尽相同，但不论有多少匹配规则，
匹配的方式都以所谓”first match”，即优先匹配，当一个数据包进入INPUT链之后，filter
机制就会根据该数据包的特征，从INPUT链的第一条规则进行匹配，假设该数据包的特征在第
一条规则就被匹配到，将有这条规则决定该数据包的处理方式，如果为丢弃，怎该数据包直接
被丢弃，如果为接受，怎该数据包直接进入到本机进程。

如果一个数据包从第一条规则到最后一条规则都没有被匹配到时，该数据包就会按照默认的规则
进行处理，在规则链中不论有多少匹配规则，默认规则总是在底层，默认规则只有俩种状态不是
ACCEPT就DROP。

# netfilter/iptables的关系
netfilter是以模块的方式被加入到linux内核中,并且其本身也是很多的模块组成，并且为了能
让其完整的按自己的意愿工作，及需要对其进行完整的管理，为此linux中提供了iptables命令
来完成这些工作。

## iptables
iptables命令可以被看做俩部组成：
	-:命令参数
	-:规则语法
iptables的命令使用格式：
```bash
//iptables -t table 操作方式 规则条件
# iptables [-t table] command [match] [-j target/jump]
//基本语法
iptables -t filter -A INPUT -p icmp DROP
//高级语法
iptables -t filter -A INPUT -m mac -mac:source 00:EE:AA:7C:A4:EB -j DROP
```
语法说明
```bash
 -t table
	目前的netfilter中的四个表filter、net、mangel、raw默认是filter
 - 操作方式
   操作方式有很多种，常用的有
	-L: 列出表的内容iptables -t filter -L -line-number以带序号的方式查看
	-F: 清空表的内容
	-A: 加入新的规则
	-P: 设置默认的规则
	-I: 插入心的规则
	-R: 替代规则
	-D: 删除规则

```
基本的语法有/lib/modules/version/kernel/net/ipv4/netfilter/iptable_filter.ko模块提供，
它提供了简单的匹配和过滤方式，基本语法就只是该模块的功能，而高级语法就是借助其他模块来完成的。
## 接口的匹配参数
```bash
参数名称: -i -o
	通过接口匹配数据包
参数值:参数的值为网卡的名词即常见的网卡名称:
	eth0:以太网的接口
	ppp0:ppp接口
	fddi0:光口
补充:
	可搭配”!”进行非操作 - ! eth0匹配除eth0以外的接口
使用实例:
	-i eth0 匹配从eth0接口进来的数据包
	-o eth0 匹配从eth0接口出去的数据包
```
## 协议匹配参数
```bash
参数名称: -p
	通过上层协议来匹配
参数值:关于上层协议可以参考/etc/protocols下面是常见的协议tcp/udp/icmp/all(匹配所有的上层协议)
补充:
	可搭配”!”进行非操作 
使用实例:
	-p tcp匹配TCP协议
	-p icmp匹配icmp协议
```
## 源地址和目标地址匹配

```bash
参数名称:-s -d
参数值:
	通过ip地址（支持网段）进行匹配
	-s 192.168.1.1
	-s 192.168.1.1/24
	-s www.baidu.com
补充:
	可搭配”!”进行非操作 
使用实例:
	-s 192.168.1.111 匹配从192.168.1.111进来的数据包
	-d 192.168.1.111 匹配到192.168.1.111的数据包	
```
## 源端口和目的端口匹配
```bash
参数名称:--sport –dport
参数值:
	可以通过端口来匹配任意服务例如可以使用
	--dport 80来匹配所有要访问http协议的数据包
	--sport 80 来匹配说有http协议的响应数据包
补充:
	可以使用！进行非操作，注意指定端口时 一定要指定协议
使用实例:
	--dport 80来匹配所有要访问http协议数据包
	--sport 80 来匹配说有http协议的响应数据包
```
## 处理方式
```bash
参数名称:-j
参数值:
	比较常见的处理方式有三种
	accept:允许
	drop：将数据包丢弃
	REJECT:将数据包丢弃，并响应一个ICMP数据包
	
```
## 基于状态的配置
因为不论是C/S还是B/S的程序，在进行网络通信的时候客户端的端口号都是随机分配的（1024以上），
所以基于这种原因所以无法对于需要做客户端服务器无法做有效的规则匹配，为此NetFilter提供了基
于状态的匹配规则，该功能有xt_state.ko模块提供.在TCP/IP协议中链接状态被分为12种，但是在state
中只有四种状态，分别是ESTABLISHED，NEW，RELATED和INVALID，并且在该模块中任何数据包都是有链
接状态的，包括UDP数据包。
### ESTABLISHED
- 与TCP数据包的关系：首先在防火墙主机上执行SSH Client，并且对网络上的SSH服务器提出服务请求，
而这时送出的第一个数据包就是服务请求的数据包，如果这个数据包能够成功的穿越防火墙，那么接下 来
SSH Server与SSH Client之间的所有SSH数据包的状态都会是ESTABLISHED。

- 与UDP数据包的关系：假设我们在防火墙主机上用firefox应用程序来浏览网页（通过域名方式），
而浏览网页的动作需要DNS服务器的帮助才能 完成，因此firefox会送出一个UDP数据包给DNS Server，以
请求名称解析服务，如果这个数据包能够成功的穿越防火墙，那么接下来DNS Server与firefox之间的所有
数据包的状态都会是ESTABLISHED。
- 与ICMP数据包的关系：假设我们在防火墙主机ping指令来检测网络上的其他主机时，ping指令所送出
的第一个ICMP数据包如果能够成功的穿 越防火墙，那么接下来刚才ping的那个主机与防火墙主机之间的所有
ICMP数据包的状态都会是ESTABLISHED。
由以上的解释可知，只要数据包能够成功的穿越防火墙，那么之后的所有数据包（包含反向的所有数据包）
状态都会是ESTABLISHED。

### NEW
    
首先我们知道，NEW与协议无关，其所指的是每一条连接中的第一个数据包，假如我们使用SSH client连接
SSH server时，这条连接中的第一个数据包的状态就是NEW。

### RELATED

RELATED状态的数据包是指被动产生的数据包。而且这个连接是不属于现在任何连接的。RELATED状态的数据
包与协议无关，只要回应回来的数据包是 因为本机送出一个数据包导致另一个连接的产生，而这一条新连接上的
所有数据包都是属于RELATED状态的数据包。

### INVALID

INVALID状态是指状态不明的数据包，也就是不属于以上三种状态的封包。凡是属于INVALID状态的数据包都
视为恶意的数据包，因此所有INVALID状态的数据包都应丢弃掉，匹配INVALID状态的数据包的方法如下：
iptables -A INPUT -p all -m state INVALID -j DROP
应将INVALID状态的数据包放在第一条。
# 实例
```bash
#0.设置filter的默认规则
iptables -t filter -P DROP
#1.将192.168.0.200进入本机的icmp丢弃
iptables -t filter -A INPUT -p icmp -s 192.168.0.200 -j DROP
#2.丢弃192.168.0.200通过本机信息DNS解析
iptables -t filter -A INPUT -p udp -s 192.168.0.200 --dport 53 -j DROP
#3.允许192.168.0.100链接本机的SSH服务
iptables -t filter -A INPUT -p tcp -s 192.168.0.100 --dport 22 -j ACCEPT
#4.只允许从eth0接口访问tcp/80端口
iptables -t filter -A INPUT -p tcp -i eth0 --dport 80 -j ACCEPT
#5.不允许通过本主机访问外部的任务网站
iptables -t filter -A INPUT -p tcp -o eth0 --dport 80 -j DROP
```
使用shell脚本
```bash
#!/bin/bash

#
#@summary:
#   演示通过shell脚本配置并管理防火墙规则
#


# Set Variable 设置变量
IPT=/sbin/iptables
SERVER=10.10.10.123
PARTENR=10.10.10.110

#
$IPT -t filter -F

#
$IPT -t filter -A INPUT -p all -m state --state INVALID -j DROP

$IPT -t filter -A INPUT -p tcp -d $SERVER --dport 80 -j ACCEPT
$IPT -t filter -A INPUT -p tcp -d $SERVER --dport 25 -j ACCEPT
$IPT -t filter -A INPUT -p tcp -d $SERVER --dport 100 -j ACCEPT
$IPT -t filter -A INPUT -p tcp -s $PARTENR -d $SERVER --dport 22 -j ACCEPT
$IPT -t filter -A INPUT -p tcp -s $PARTENR -d $SERVER --dport 23 -j ACCEPT

$IPT -t filter -A INPUT -p tcp -m state --state ESTABLISHED,RELATED -j ACCEP
```

```bash
iptables -L INPUT                   # 列出某规则链中的所有规则
iptables -X allowed                 # 删除某个规则链 ,不加规则链，清除所有非内建的
iptables -Z INPUT                   # 将封包计数器归零
iptables -N allowed                 # 定义新的规则链
iptables -P INPUT DROP              # 定义过滤政策
iptables -A INPUT -s 192.168.1.1    # 比对封包的来源IP   # ! 192.168.0.0/24  ! 反向对比
iptables -A INPUT -d 192.168.1.1    # 比对封包的目的地IP
iptables -A INPUT -i eth0           # 比对封包是从哪片网卡进入
iptables -A FORWARD -o eth0         # 比对封包要从哪片网卡送出 eth+表示所有的网卡
iptables -A INPUT -p tcp            # -p ! tcp 排除tcp以外的udp、icmp。-p all所有类型
iptables -D INPUT 8                 # 从某个规则链中删除一条规则
iptables -D INPUT --dport 80 -j DROP         # 从某个规则链中删除一条规则
iptables -R INPUT 8 -s 192.168.0.1 -j DROP   # 取代现行规则
iptables -I INPUT 8 --dport 80 -j ACCEPT     # 插入一条规则
iptables -A INPUT -i eth0 -j DROP            # 其它情况不允许
iptables -A INPUT -p tcp -s IP -j DROP       # 禁止指定IP访问
iptables -A INPUT -p tcp -s IP --dport port -j DROP               # 禁止指定IP访问端口
iptables -A INPUT -s IP -p tcp --dport port -j ACCEPT             # 允许在IP访问指定端口
iptables -A INPUT -p tcp --dport 22 -j DROP                       # 禁止使用某端口
iptables -A INPUT -i eth0 -p icmp -m icmp --icmp-type 8 -j DROP   # 禁止icmp端口
iptables -A INPUT -i eth0 -p icmp -j DROP                         # 禁止icmp端口
iptables -t filter -A INPUT -i eth0 -p tcp --syn -j DROP                  # 阻止所有没有经过你系统授权的TCP连接
iptables -A INPUT -f -m limit --limit 100/s --limit-burst 100 -j ACCEPT   # IP包流量限制
iptables -A INPUT -i eth0 -s 192.168.62.1/32 -p icmp -m icmp --icmp-type 8 -j ACCEPT  # 除192.168.62.1外，禁止其它人ping我的主机
iptables -A INPUT -p tcp -m tcp --dport 80 -m state --state NEW -m recent --update --seconds 5 --hitcount 20 --rttl --name WEB --rsource -j DROP  # 可防御cc攻击(未测试)

# Show hit for rules with auto refresh
#使用自动刷新显示规则命中
watch --interval 0 'iptables -nvL | grep -v "0     0"'

# Show hit for rule with auto refresh and highlight any changes since the last refresh
#显示自动刷新的规则，并突出显示自上次刷新以来的任何更改
watch -d -n 2 iptables -nvL

# Block the port 902 and we hide this port from nmap.
#阻止端口902，我们将此端口隐藏在nmap中。
iptables -A INPUT -i eth0 -p tcp --dport 902 -j REJECT --reject-with icmp-port-unreachable

# Note, --reject-with accept:
#注意， -  return-with accept：
#	icmp-net-unreachable
#ICMP网无法到达
#	icmp-host-unreachable
#ICMP主机不可达
#	icmp-port-unreachable <- Hide a port to nmap
#icmp-port-unreachable < - 将端口隐藏到nmap
#	icmp-proto-unreachable
#ICMP-原可达
#	icmp-net-prohibited
#ICMP网禁止
#	icmp-host-prohibited or
#icmp-host-prohibited或
#	icmp-admin-prohibited
#ICMP管理员禁止
#	tcp-reset
#TCP重置

# Add a comment to a rule:
#为规则添加评论：
iptables ... -m comment --comment "This rule is here for this reason"


# To remove or insert a rule:
#要删除或插入规则：
# 1) Show all rules
#1）显示所有规则
iptables -L INPUT --line-numbers
# OR iptables -nL --line-numbers
#或iptables -nL --line-numbers

# Chain INPUT (policy ACCEPT)
#Chain INPUT（政策接受）
#     num  target prot opt source destination
#num target prot opt source destination
#     1    ACCEPT     udp  --  anywhere  anywhere             udp dpt:domain
#1 ACCEPT udp  -  udp dpt：domain的任何地方
#     2    ACCEPT     tcp  --  anywhere  anywhere             tcp dpt:domain
#2 ACCEPT tcp  -  tcp dpt：domain的任何地方
#     3    ACCEPT     udp  --  anywhere  anywhere             udp dpt:bootps
#3接受udp  - 在任何地方udp dpt：bootps
#     4    ACCEPT     tcp  --  anywhere  anywhere             tcp dpt:bootps
#4 ACCEPT tcp  -  tcp dpt：bootps的任何地方

# 2.a) REMOVE (-D) a rule. (here an INPUT rule)
#2.a）删除（-D）规则。 （这里是INPUT规则）
iptables -D INPUT 2

# 2.b) OR INSERT a rule.
#2.b）或插入规则。
iptables -I INPUT {LINE_NUMBER} -i eth1 -p tcp --dport 21 -s 123.123.123.123 -j ACCEPT -m comment --comment "This rule is here for this reason"


#iptables基本语法#
#基本语法类似如下形式:
iptables -t filter -A INPUT -p icmp -j DROP

#0.设置filter的默认规则
iptables -t filter -P DROP

#1.将192.168.0.200进入本机的icmp丢弃
iptables -t filter -A INPUT -p icmp -s 192.168.0.200 -j DROP

#2.丢弃192.168.0.200通过本机信息DNS解析
iptables -t filter -A INPUT -p udp -s 192.168.0.200 --dport 53 -j DROP

#3.允许192.168.0.100链接本机的SSH服务
iptables -t filter -A INPUT -p tcp -s 192.168.0.100 --dport 22 -j ACCEPT

#4.只允许从eth0接口访问tcp/80端口
iptables -t filter -A INPUT -p tcp -i eth0 --dport 80 -j ACCEPT

#5.不允许通过本主机访问外部的任务网站
iptables -t filter -A INPUT -p tcp -o eth0 --dport 80 -j DROP


# INPUT chain
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

## CCS
iptables -A INPUT -s 1.1.1.1 -p tcp -m tcp --dport 22 -m state --state NEW -j ACCEPT
iptables -A INPUT -s 1.1.1.1 -p icmp -m icmp --icmp-type 8 -j ACCEPT


#yewu
iptables -A INPUT -p tcp -m multiport --dports 1440,1450,8099,8085 -j ACCEPT


## SMOKEPING
iptables -A INPUT -s 1.1.1.1 -p icmp -j ACCEPT

## Zabbix
iptables -A INPUT -s 1.1.1.1 -p tcp -m tcp --dport 10050 -j ACCEPT
iptables -A INPUT -s 1.1.1.1 -p icmp -m icmp --icmp-type 8 -j ACCEPT

## Log Backup Server
iptables -A INPUT -s 1.1.1.1 -p tcp -m tcp --dport 19666 -j ACCEPT

## JiaGu
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT

## Default INPUT
iptables -P INPUT DROP


# OUTPUT chain
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

## Statistical system transmission
iptables -A OUTPUT -d 1.1.1.1 -p tcp --dport 20001 -j ACCEPT

## syscenter
iptables -A OUTPUT -d 1.1.1.1 -p tcp --dport 8090 -j ACCEPT

## Log Backup
iptables -A OUTPUT -d 1.1.1.1 -j ACCEPT

## SYSLOG
iptables -A OUTPUT -d 1.1.1.1 -p udp -m udp --dport 514 -j ACCEPT

## Time Sync
iptables -A OUTPUT -d 1.1.1.1 -p udp -m udp --dport 123 -j ACCEPT

## Puppet
iptables -A OUTPUT -d 1.1.1.1 -p tcp --dport 55120 -j ACCEPT
iptables -A OUTPUT -d 1.1.1.1 -p tcp --dport 8140  -j ACCEPT

## DNS
iptables -A OUTPUT -p udp  -m udp  --dport 53    -j ACCEPT
iptables -A OUTPUT -p tcp  -m tcp  --dport 53    -j ACCEPT
iptables -A OUTPUT -p tcp  -m tcp  --dport 123   -j ACCEPT
iptables -A OUTPUT -p tcp  -m tcp  --dport 2258  -j ACCEPT
iptables -A OUTPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

## Mysql
iptables -A OUTPUT -p tcp  -m tcp  --dport 3306 -j ACCEPT

## Vesta
iptables -A OUTPUT -p tcp -m multiport --dports 8081,9094,9095,9096,9097 -j ACCEPT

## Yum
iptables -A OUTPUT -p tcp -m tcp --dport 88 -j ACCEPT

## Zabbix
iptables -A OUTPUT -p tcp -m multiport --dports 10050,10051 -j ACCEPT

## SALT
iptables -A OUTPUT -p tcp -m multiport --dports 4505,4506 -j ACCEPT

## Billing 
iptables -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT

## JiaGu
iptables -A OUTPUT -p tcp -m tcp --dport 443 -j ACCEPT

## SRCYNC
#iptables -A OUTPUT -p tcp -m tcp --dport 873 -j ACCEPT

## Default OUTPUT
iptables -P OUTPUT DROP


# FORWARD chain
iptables -P FORWARD DROP

/etc/init.d/iptables save

```
