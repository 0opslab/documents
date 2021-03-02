# title{nmap - 是一款开放源代码的网络探测和安全审核工具，它的设计目标是快速地扫描大型网络}

### 选项
```bash
-O：激活操作探测；
-P0：值进行扫描，不ping主机；
-PT：是同TCP的ping；
-sV：探测服务版本信息；
-sP：ping扫描，仅发现目标主机是否存活；
-ps：发送同步（SYN）报文；
-PU：发送udp ping；
-PE：强制执行直接的ICMPping；
-PB：默认模式，可以使用ICMPping和TCPping；
-6：使用IPv6地址；
-v：得到更多选项信息；
-d：增加调试信息地输出；
-oN：以人们可阅读的格式输出；
-oX：以xml格式向指定文件输出信息；
-oM：以机器可阅读的格式输出；
-A：使用所有高级扫描选项；
--resume：继续上次执行完的扫描；
-P：指定要扫描的端口，可以是一个单独的端口，用逗号隔开多个端口，使用“-”表示端口范围；
-e：在多网络接口Linux系统中，指定扫描使用的网络接口；
-g：将指定的端口作为源端口进行扫描；
--ttl：指定发送的扫描报文的生存期；
--packet-trace：显示扫描过程中收发报文统计；
--scanflags：设置在扫描报文中的TCP标志。
```

### 常用命令
```bash
# 先ping在扫描主机开放端口
nmap -PT 192.168.1.1-111             
# 扫描出系统内核版本
nmap -O 192.168.1.1                  
# 扫描端口的软件版本
nmap -sV 192.168.1.1-111             
# 半开扫描(通常不会记录日志)
nmap -sS 192.168.1.1-111             
# 不ping直接扫描
nmap -P0 192.168.1.1-111             
# 详细信息
nmap -d 192.168.1.1-111              
# 无法找出真正扫描主机(隐藏IP)
nmap -D 192.168.1.1-111              
# 端口范围  表示：扫描20到30号端口，139号端口以及所有大于60000的端口
nmap -p 20-30,139,60000-             
# 组合扫描(不ping、软件版本、内核版本、详细信息)
nmap -P0 -sV -O -v 192.168.30.251    
# 不支持windows的扫描(可用于判断是否是windows)
nmap -sF 192.168.1.1-111
nmap -sX 192.168.1.1-111
nmap -sN 192.168.1.1-111

# Single target scan:
#单目标扫描：
nmap [target]

# Scan from a list of targets:
#从目标列表中扫描：
nmap -iL [list.txt]

# iPv6:
#性IPv6：
nmap -6 [target]

# OS detection:
#OS检测：
nmap -O --osscan_guess [target]

# Save output to text file:
#将输出保存到文本文件：
nmap -oN [output.txt] [target]

# Save output to xml file:
#将输出保存到xml文件：
nmap -oX [output.xml] [target]

# Scan a specific port:
#扫描特定端口：
nmap -source-port [port] [target]

# Do an aggressive scan:
#做一个积极的扫描：
nmap -A [target]

# Speedup your scan:
#加快扫描速度：
# -n => disable ReverseDNS
#-n =>禁用反向DNS
# --min-rate=X => min X packets / sec
#--min-rate = X => min X包/秒
nmap -T5 --min-parallelism=50 -n --min-rate=300 [target]

# Traceroute:
#路由跟踪：
nmap -traceroute [target]

# Ping scan only: -sP
#仅限Ping扫描：-sP
# Don't ping:     -PN <- Use full if a host don't reply to a ping.
#请勿ping：-PN < - 如果主机不回复ping，请使用full。
# TCP SYN ping:   -PS
#TCP SYN ping：-PS
# TCP ACK ping:   -PA
#TCP ACK ping：-PA
# UDP ping:       -PU
#UDP ping：-PU
# ARP ping:       -PR
#你平

# Example: Ping scan all machines on a class C network
#示例：Ping扫描C类网络上的所有计算机
nmap -sP 192.168.0.0/24

# Force TCP scan: -sT
#强制TCP扫描：-sT
# Force UDP scan: -sU
#强制UDP扫描：-sU

# Use some script:
#使用一些脚本：
nmap --script default,safe

# Loads the script in the default category, the banner script, and all .nse files in the directory /home/user/customscripts.
#在脚本/ home / user / customscripts中加载默认类别，标题脚本和所有.nse文件中的脚本。
nmap --script default,banner,/home/user/customscripts

# Loads all scripts whose name starts with http-, such as http-auth and http-open-proxy.
#加载名称以http-开头的所有脚本，例如http-auth和http-open-proxy。
nmap --script 'http-*'

# Loads every script except for those in the intrusive category.
#加载除侵入类别中的脚本之外的每个脚本。
nmap --script "not intrusive"

# Loads those scripts that are in both the default and safe categories.
#加载默认和安全类别中的脚本。
nmap --script "default and safe"

# Loads scripts in the default, safe, or intrusive categories, except for those whose names start with http-.
#在默认，安全或侵入类别中加载脚本，但名称以http-开头的类别除外。
nmap --script "(default or safe or intrusive) and not http-*"

# Scan for the heartbleed
#扫描心脏病
# -pT:443 => Scan only port 443 with TCP (T:)
#-pT：443 =>仅使用TCP（T :)扫描端口443
nmap -T5 --min-parallelism=50 -n --script "ssl-heartbleed" -pT:443 127.0.0.1

# Show all informations (debug mode)
#显示所有信息（调试模式）
nmap -d ...
```