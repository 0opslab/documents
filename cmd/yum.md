# title{yum - 包管理工具}

## yum扩展源
# 包下载地址:http://download.fedoraproject.org/pub/epel   
# 选择版本
wget http://download.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
rpm -Uvh epel-release-5-4.noarch.rpm



## 自定义yum源
```bash
find /etc/yum.repos.d -name "*.repo" -exec mv {} {}.bak \;
vim /etc/yum.repos.d/yum.repo
[yum]
#http
baseurl=http://10.0.0.1/centos5.5
#挂载iso
#mount -o loop CentOS-5.8-x86_64-bin-DVD-1of2.iso /data/iso/
#本地
#baseurl=file:///data/iso/
enable=1

#导入key
rpm --import  /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5
```



```bash
	yum list                 # 查找所有列表
		yum install 包名         # 安装包和依赖包
		yum -y update            # 升级所有包版本,依赖关系，系统版本内核都升级
		yum -y update 软件包名   # 升级指定的软件包
		yum -y upgrade           # 不改变软件设置更新软件，系统版本升级，内核不改变
		yum search mail          # yum搜索相关包
		yum grouplist            # 软件包组
		yum -y groupinstall "Virtualization"   # 安装软件包组


# To install the latest version of a package:
yum install <package name>

# To perform a local install:
yum localinstall <package name>

# To remove a package:
yum remove <package name>

# To search for a package:
yum search <package name>

# To find what package installs a program:
yum whatprovides </path/to/program>

# To find the dependencies of a package:
yum deplist <package name>

# To find information about a package:
yum info <package name>

# List currently enabled repositories:
yum repolist

# List packages containing a certain keyword:
yum list <package_name_or_word_to_search>
 
# To download the source RPM for a package:
yumdownloader --source <package name>

# (You have to install yumdownloader first, which is installed by the yum-utils package)
```
