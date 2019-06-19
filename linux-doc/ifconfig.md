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
