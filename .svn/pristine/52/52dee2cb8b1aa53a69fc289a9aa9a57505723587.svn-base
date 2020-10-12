# Desc: Allows to update the operating system
#描述：允许更新操作系统

# To fetch package list
#要获取包列表
apt-get update

# To download and install updates without installing new package.
#无需安装新软件包即可下载和安装更新。
apt-get upgrade

# To download and install the updates AND install new necessary packages
#下载并安装更新并安装新的必要软件包
apt-get dist-upgrade

# Full command:
#完整命令：
apt-get update && apt-get dist-upgrade

# To install a new package(s)
#安装新软件包
apt-get install package(s)

# Download a package without installing it. (The package will be downloaded in your current working dir)
#下载包而不安装它。 （该软件包将在您当前的工作目录中下载）
apt-get download modsecurity-crs

# Change Cache dir and archive dir (where .deb are stored).
#更改缓存目录和存档目录（存储.deb的位置）。
apt-get -o Dir::Cache="/path/to/destination/dir/" -o Dir::Cache::archives="./" install ...

# Show apt-get installed packages.
#显示apt-get安装包。
grep 'install ' /var/log/dpkg.log

# Silently keep old configuration during batch updates
#在批量更新期间静默保留旧配置
apt-get update -o DPkg::Options::='--force-confold' ...
