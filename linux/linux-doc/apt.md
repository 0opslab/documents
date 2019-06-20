# To search a package:
#要搜索包裹：
apt search package

# To show package informations:
#要显示包裹信息：
apt show package

# To fetch package list:
#要获取包列表：
apt update

# To download and install updates without installing new package:
#要在不安装新软件包的情况下下载和安装更新
apt upgrade

# To download and install the updates AND install new necessary packages:
#要下载并安装更新并安装新的必要软件包：
apt dist-upgrade

# Full command:
#完整命令：
apt update && apt dist-upgrade

# To install a new package(s):
#要安装新软件包：
apt install package(s)

# To uninstall package(s)
#卸载软件包
apt remove package(s)
