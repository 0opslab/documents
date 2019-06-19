#!/bin/bash


#######################################################
#       请勿执行,这里只是一些配置实例，仅供参考
#
#######################################################



#iptables基本语法#
    #基本语法类似如下形式:
    iptables -t filter -A INPUT -p icmp -j DROP


#
# 实例
#

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
