#!/bin/bash

#
#@summary:
#   演示通过shell脚本配置并管理防火墙规则
#


#====Set Variable 设置变量
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

$IPT -t filter -A INPUT -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT
