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
