# title{dnsmasq - 一个小巧且方便地用于配置DNS和DHCP的工具}

DNSmasq是一个小巧且方便地用于配置DNS和DHCP的工具，适用于小型网络，它提供了DNS功能和可选择的DHCP功能。
它服务那些只在本地适用的域名，这些域名是不会在全球的DNS服务器中出现的。


```bash
#!/bin/bash


yum install dnsmasq -y
cp /etc/resolv.conf /etc/resolv.dnsmasq.conf
cp /etc/hosts /etc/dnsmasq.hosts
echo 'nameserver 127.0.0.1' > /etc/resolv.conf
echo 'resolv-file=/etc/resolv.dnsmasq.conf' >> /etc/dnsmasq.conf
echo 'addn-hosts=/etc/dnsmasq.hosts' >> /etc/dnsmasq.conf

service dnsmasq restart
```