# title{route - 显示并设置Linux中静态路由表}
用来显示并设置Linux内核中的网络路由表，route命令设置的路由主要是静态路由。要实现两个不同的子网之间的通信，
需要一台连接两个网络的路由器，或者同时位于两个网络的网关来实现。

### 选项
```bash
-A：设置地址类型；
-C：打印将Linux核心的路由缓存；
-v：详细信息模式；
-n：不执行DNS反向查找，直接显示数字形式的IP地址；
-e：netstat格式显示路由表；
-net：到一个网络的路由表；
-host：到一个主机的路由表。

## 参数
Add：增加指定的路由记录；
Del：删除指定的路由记录；
Target：目的网络或目的主机；
gw：设置默认网关；
mss：设置TCP的最大区块长度（MSS），单位MB；
window：指定通过路由表的TCP连接的TCP窗口大小；
dev：路由记录所表示的网络接口。


```

### 常用命令
```bash
# To display routing table IP addresses instead of host names:
route -n

# To add a default gateway:
route add default gateway 192.168.0.1

# To add the normal loopback entry, using netmask 255.0.0.0 and associated with the "lo" device (assuming this device was previously set up correctly with ifconfig(8)).
route add -net 127.0.0.0 netmask 255.0.0.0 dev lo

# To add a route to the local network 192.56.76.x via "eth0".  The word "dev" can be omitted here.
route add -net 192.56.76.0 netmask 255.255.255.0 dev eth0

# To delete the current default route, which is labeled "default" or 0.0.0.0 in the destination field of the current routing table.
route del default

# To add a default  route (which will be used if no other route matches).  All packets using this route will be gatewayed through "mango-gw". The device which will actually be used for that route depends on how we can reach "mango-gw" - the static route to "mango-gw" will have to be set up before.
route add default gw mango-gw

# To add the route to the "ipx4" host via the SLIP interface (assuming that "ipx4" is the SLIP host).
route add ipx4 sl0

# To add the net "192.57.66.x" to be gateway through the former route to the SLIP interface.
route add -net 192.57.66.0 netmask 255.255.255.0 gw ipx4

# To install a rejecting route for the private network "10.x.x.x."
route add -net 10.0.0.0 netmask 255.0.0.0 reject

# This is an obscure one documented so people know how to do it. This sets all of the class D (multicast) IP routes to go via "eth0". This is the correct normal configuration line with a multicasting kernel
route add -net 224.0.0.0 netmask 240.0.0.0 dev eth0
```