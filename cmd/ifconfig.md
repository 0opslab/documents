# title{ifconfig - 用于显示或设置网络设备}

### 常用参数
```bash
add<地址> 设置网络设备IPv6的IP地址。
del<地址> 删除网络设备IPv6的IP地址。
down 关闭指定的网络设备。
<hw<网络设备类型><硬件地址> 设置网络设备的类型与硬件地址。
io_addr<I/O地址> 设置网络设备的I/O地址。
irq<IRQ地址> 设置网络设备的IRQ。
media<网络媒介类型> 设置网络设备的媒介类型。
mem_start<内存地址> 设置网络设备在主内存所占用的起始地址。
metric<数目> 指定在计算数据包的转送次数时，所要加上的数目。
mtu<字节> 设置网络设备的MTU。
netmask<子网掩码> 设置网络设备的子网掩码。
tunnel<地址> 建立IPv4与IPv6之间的隧道通信地址。
up 启动指定的网络设备。
-broadcast<地址> 将要送往指定地址的数据包当成广播数据包来处理。
-pointopoint<地址> 与指定地址的网络设备建立直接连线，此模式具有保密功能。
-promisc 关闭或启动指定网络设备的promiscuous模式。
[IP地址] 指定网络设备的IP地址。
[网络设备] 指定网络设备的名称。
```

### 常用命令

```bash
# Display network settings of the first ethernet adapter
#显示第一个以太网适配器的网络设置
ifconfig wlan0

# Display all interfaces, even if down
#显示所有接口，即使向下
ifconfig -a

# Take down / up the wireless adapter
#取下/升起无线适配器
ifconfig wlan0 {up|down} 

# Set a static IP and netmask
#设置静态IP和网络掩码
ifconfig eth0 192.168.1.100 netmask 255.255.255.0

# You may also need to add a gateway IP
#您可能还需要添加网关IP
route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.1.1


# 为网卡配置和删除IPv6地址
# 为网卡设置IPv6地址
ifconfig eth0 add 33ffe:3240:800:1005::2/ 64 
# 为网卡删除IPv6地址
ifconfig eth0 del 33ffe:3240:800:1005::2/ 64 

# 用ifconfig修改MAC地址
# 关闭网卡
ifconfig eth0 down 
#修改MAC地址
ifconfig eth0 hw ether 00:AA:BB:CC:DD:EE 
#启动网卡
ifconfig eth0 up 
#关闭网卡并修改MAC地址 
ifconfig eth1 hw ether 00:1D:1C:1D:1E 
#启动网卡
ifconfig eth1 up 


# 启用和关闭ARP协议
# 开启
ifconfig eth0 arp 
#关闭 
ifconfig eth0 -arp  
```