# title{nmcli - 地址配置工具 nmcli}

```bash

# 查看网卡绑定信息
nmcli con show 
# Desc: Command line interface to NetworkManager
#描述：NetworkManager的命令行界面

# Connect to a wireless access point - Parameters:
#连接到无线接入点 - 参数：
# 	<wiface> -- the name of your wireless interface
#<wiface>  - 无线接口的名称
#	<ssid> -- the SSID of the access point
#＃<ssid>  - 接入点的SSID
#	<pass> -- the WiFi password
#＃<pass>  -  WiFi密码
nmcli d wifi connect <ssid> password <pass> iface <wiface>

# Disconnect from WiFi - Parameters:
#断开WiFi连接 - 参数：
#	<wiface> -- the name of your wireless interface
#＃<wiface>  - 无线接口的名称
nmcli d wifi disconnect iface <wiface>

# Get WiFi status (enabled / disabled)
#获取WiFi状态（启用/禁用）
nmcli radio wifi

# Enable / Disable WiFi
#启用/禁用WiFi
nmcli radio wifi <on|off>

# Show all available WiFi access points
#显示所有可用的WiFi接入点
nmcli dev wifi list

# Refresh the available WiFi connection list
#刷新可用的WiFi连接列表
nmcli dev wifi rescan

# Show all available connections
#显示所有可用的连接
nmcli con

# Show only active connections
#仅显示活动连接
nmcli con show --active

# Review the available devices
#查看可用的设备
nmcli dev status

# Add a dynamic ethernet connection - parameters:
#添加动态以太网连接 - 参数：
#	<name> -- the name of the connection
#＃<name>  - 连接的名称
#	<iface_name> -- the name of the interface
#＃<iface_name>  - 接口的名称
nmcli con add type ethernet con-name <name> ifname <iface_name>

# Import OpenVPN connection settings from file:
#从文件导入OpenVPN连接设置：
nmcli con import type openvpn file <path_to_ovpn_file>

# Bring up the ethernet connection
#打开以太网连接
nmcli con up <name>
```