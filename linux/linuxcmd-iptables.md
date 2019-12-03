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
