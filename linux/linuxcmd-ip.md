# Display all interfaces with addresses
#显示所有带地址的接口
ip addr

# Take down / up the wireless adapter
#取下/升起无线适配器
ip link set dev wlan0 {up|down}

# Set a static IP and netmask
#设置静态IP和网络掩码
ip addr add 192.168.1.100/32 dev eth0

# Remove a IP from an interface
#从接口中删除IP
ip addr del 192.168.1.100/32 dev eth0

# Remove all IPs from an interface
#从界面中删除所有IP
ip address flush dev eth0

# Display all routes
#显示所有路线
ip route

# Display all routes for IPv6
#显示IPv6的所有路由
ip -6 route

# Add default route via gateway IP
#通过网关IP添加默认路由
ip route add default via 192.168.1.1

# Add route via interface
#通过界面添加路由
ip route add 192.168.0.0/24 dev eth0

# Change your mac address 
#更改您的Mac地址
ip link set dev eth0 address aa:bb:cc:dd:ee:ff

# View neighbors (using ARP and NDP) 
#查看邻居（使用ARP和NDP）
ip neighbor show
