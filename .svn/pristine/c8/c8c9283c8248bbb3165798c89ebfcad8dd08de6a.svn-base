# TCPDump is a packet analyzer. It allows the user to intercept and display TCP/IP
#TCPDump是一个数据包分析器。它允许用户拦截和显示TCP / IP
# and other packets being transmitted or received over a network. (cf Wikipedia).
#和其他数据包通过网络传输或接收。 （比较维基百科）。
# Note: 173.194.40.120 => google.com
#注意：173.194.40.120 => google.com

# Intercepts all packets on eth0
#拦截eth0上的所有数据包
tcpdump -i eth0

# Intercepts all packets from/to 173.194.40.120
#拦截来自/到173.194.40.120的所有数据包
tcpdump host 173.194.40.120

# Intercepts all packets on all interfaces from / to 173.194.40.120 port 80
#拦截来自/到173.194.40.120端口80的所有接口上的所有数据包
# -nn => Disables name resolution for IP addresses and port numbers.
#-nn =>禁用IP地址和端口号的名称解析。
tcpdump -nn -i any host 173.194.40.120 and port 80

# Make a grep on tcpdump (ASCII)
#在tcpdump上创建一个grep（ASCII）
# -A  => Show only ASCII in packets.
#-A =>仅显示数据包中的ASCII。
# -s0 => By default, tcpdump only captures 68 bytes.
#-s0 =>默认情况下，tcpdump仅捕获68个字节。
tcpdump -i -A any host 173.194.40.120 and port 80 | grep 'User-Agent'

# With ngrep
#使用ngrep
# -d eth0 => To force eth0 (else ngrep work on all interfaces)
#-d eth0 =>强制eth0（否则ngrep适用于所有接口）
# -s0 => force ngrep to look at the entire packet. (Default snaplen: 65536 bytes)
#-s0 =>强制ngrep查看整个数据包。 （默认snaplen：65536字节）
ngrep 'User-Agent' host 173.194.40.120 and port 80

# Intercepts all packets on all interfaces from / to 8.8.8.8 or 173.194.40.127 on port 80
#拦截端口80上所有接口上的所有数据包/ 8.8.8.8或173.194.40.127
tcpdump 'host ( 8.8.8.8 or 173.194.40.127 ) and port 80' -i any

# Intercepts all packets SYN and FIN of each TCP session.
#截获每个TCP会话的所有数据包SYN和FIN。
tcpdump 'tcp[tcpflags] & (tcp-syn|tcp-fin) != 0'

# To display SYN and FIN packets of each TCP session to a host that is not on our network
#将每个TCP会话的SYN和FIN数据包显示给不在我们网络上的主机
tcpdump 'tcp[tcpflags] & (tcp-syn|tcp-fin) != 0 and not src and dst net local_addr'

# To display all IPv4 HTTP packets that come or arrive on port 80 and that contain only data (no SYN, FIN no, no packet containing an ACK)
#显示到达或到达端口80并且仅包含数据的所有IPv4 HTTP数据包（没有SYN，FIN no，没有包含ACK的数据包）
tcpdump 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'

# Saving captured data
#保存捕获的数据
tcpdump -w file.cap

# Reading from capture file
#从捕获文件中读取
tcpdump -r file.cap

# Show content in hexa
#以hexa显示内容
# Change -x to -xx => show extra header (ethernet).
#将-x更改为-xx =>显示额外标头（以太网）。
tcpdump -x

# Show content in hexa and ASCII
#以十六进制和ASCII显示内容
# Change -X to -XX => show extra header (ethernet).
#将-X更改为-XX =>显示额外标头（以太网）。
tcpdump -X

# Note on packet maching:
#包机注意事项：
# Port matching:
#端口匹配：
# - portrange 22-23
# -  portrange 22-23
# - not port 22
# - 不是22号港口
# - port ssh
# - 端口ssh
# - dst port 22
# - 等端口22
# - src port 22
# -  src端口22
#
##
# Host matching:
#主机匹配：
# - dst host 8.8.8.8
# -  dst主机8.8.8.8
# - not dst host 8.8.8.8
# - 不是主持人8.8.8.8
# - src net 67.207.148.0 mask 255.255.255.0
# -  src net 67.207.148.0 mask 255.255.255.0
# - src net 67.207.148.0/24
# -  src net 67.207.148.0/24
