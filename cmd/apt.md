# title{apt - apt常用命令}

```bash
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


# To search for apt packages:
#要搜索apt包：
apt-cache search "whatever"

# To display package records for the named package(s):
#要显示命名包的包记录：
apt-cache show pkg(s)

# To display reverse dependencies of a package
#显示包的反向依赖关系
apt-cache rdepends package_name

# To display package versions, reverse dependencies and forward dependencies 
#显示包版本，反向依赖关系和转发依赖关系
# of a package
#一个包
apt-cache showpkg package_name

# To search for packages:
#要搜索包裹：
aptitude search "whatever"

# To display package records for the named package(s):
#要显示命名包的包记录：
aptitude show pkg(s)

# To install a package:
#要安装包：
aptitude install package

# To remove a package:
#要删除包裹：
aptitude remove package

# To remove unnecessary package:
#删除不必要的包：
aptitude autoclean
```
