title: ubuntu install mysql
date: 2016-01-11 22:23:59
tags:
	- linux
	- mysql
categories: mysql
---
实在受够了windows上各种软件自动的安装，下载想要的软件还需要到处找的操蛋局面，还是切换到linux下的！
于是就有了这篇文章记录下！
一般环境不需要源码包编译安装直接apt-get即可
```bash
$ sudo apt-get install mysql-server mysql-client
```
安装好后默认的编码一般都需要修改下
```bash
$ mysql -u root -p
----
mysql>  show variables like "character%";
+--------------------------+----------------------------+
| Variable_name            | Value                      |
+--------------------------+----------------------------+
| character_set_client     | utf8                       |
| character_set_connection | utf8                       |
| character_set_database   | latin1                     |
| character_set_filesystem | binary                     |
| character_set_results    | utf8                       |
| character_set_server     | latin1                     |
| character_set_system     | utf8                       |
| character_sets_dir       | /usr/share/mysql/charsets/ |
+--------------------------+----------------------------+
```
修改默认的编码
```bash
# 停止mysql服务
$ sudo service mysql stop
# 如果提示
stop: Unknown job: mysql
# 执行下面命令几个
sudo initctl reload-configuration
# 停止服务后编辑下面的配置文件
sudo vim /etc/mysql/my.cnf

```
在该文件的[mysqld]下面新增如下配置
```bash
# 新增
character_set_server=utf8  
init_connect='SET NAMES utf8'  
```
然后重启服务
```bash
# 启动mysql服务
$ sudo service mysql start
```
查看编码
```bash
mysql> show variables like 'character%';
+--------------------------+----------------------------+
| Variable_name            | Value                      |
+--------------------------+----------------------------+
| character_set_client     | utf8                       |
| character_set_connection | utf8                       |
| character_set_database   | utf8                       |
| character_set_filesystem | binary                     |
| character_set_results    | utf8                       |
| character_set_server     | utf8                       |
| character_set_system     | utf8                       |
| character_sets_dir       | /usr/share/mysql/charsets/ |
+--------------------------+----------------------------+
8 rows in set (0.00 sec)
```
至此算是搞定了，之后就是根据应用进行相应的操作！