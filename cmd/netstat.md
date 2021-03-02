# title{netstat - 用于显示网络状态}

### 选项
```bash
-a或–all 显示所有连线中的Socket。
-A<网络类型>或–<网络类型> 列出该网络类型连线中的相关地址。
-c或–continuous 持续列出网络状态。
-C或–cache 显示路由器配置的快取信息。
-e或–extend 显示网络其他相关信息。
-F或–fib 显示FIB。
-g或–groups 显示多重广播功能群组组员名单。
-h或–help 在线帮助。
-i或–interfaces 显示网络界面信息表单。
-l或–listening 显示监控中的服务器的Socket。
-M或–masquerade 显示伪装的网络连线。
-n或–numeric 直接使用IP地址，而不通过域名服务器。
-N或–netlink或–symbolic 显示网络硬件外围设备的符号连接名称。
-o或–timers 显示计时器。
-p或–programs 显示正在使用Socket的程序识别码和程序名称。
-r或–route 显示Routing Table。
-s或–statistice 显示网络工作信息统计表。
-t或–tcp 显示TCP传输协议的连线状况。
-u或–udp 显示UDP传输协议的连线状况。
-v或–verbose 显示指令执行过程。
-V或–version 显示版本信息。
-w或–raw 显示RAW传输协议的连线状况。
-x或–unix 此参数的效果和指定”-A unix”参数相同。
–ip或–inet 此参数的效果和指定”-A inet”参数相同。
```

### 常用命令
```bash
# WARNING ! netstat is deprecated. Look below.
#警告 ！ netstat已弃用。往下看。

# To view which users/processes are listening to which ports:
#要查看哪些用户/进程正在侦听哪些端口：
sudo netstat -lnptu

# To view routing table (use -n flag to disable DNS lookups):
#要查看路由表（使用-n标志禁用DNS查找）：
netstat -r

#显示UDP端口号的使用情况
netstat -apu

#显示网卡列表
netstat -i

# 显示网络统计信息
netstat -s

# 显示监听的套接口
netstat -l


# Which process is listening to port <port>
#哪个进程正在侦听端口<port>
netstat -pln | grep <port> | awk '{print $NF}'

#Example output: 1507/python

# Fast display of ipv4 tcp listening programs
#快速显示ipv4 tcp监听程序
sudo netstat -vtlnp --listening -4

# WARNING ! netstat is deprecated.
#警告 ！ netstat已弃用。
# Replace it by:
#替换为：
ss

# For netstat-r
#对于netstat-r
ip route

# For netstat -i
#对于netstat -i
ip -s link

# For netstat-g
#对于netstat-g
ip maddr
```
