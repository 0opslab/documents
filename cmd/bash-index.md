# title{bash - linux下常用命令汇总}

# 命令汇总
# 安装和登录
```bash
	$ login
	$ shutdown
	$ halt
	$ reboot
	$ install
	$ mount
	$ umount
	$ chsh
	$ exit
	$ last
	$ apt
```
# 文件处理命令
```bash
	$ file
	$ mkdir
	$ grep
	$ dd
	$ find
	$ mv
	$ ls
	$ diff
	$ cat
	$ ln
	$ tree
	$ pwd
	$ cd
	$ rmdir
	$ touch
	$ cp
	$ head
	$ tail
	$ more
	$ sort
	$ uniq
	$ iconv
	$ cut
	$ paste
	$ wc
	$ md5sum
	$ rm
	$ echo
	$ lpr
	$ cmp
```
# 系统管理
```bash
	$ df
	$ top
	$ free
	$ quota
	$ at
	$ lp
	$ adduser
	$ groupadd
	$ kill
	$ crontab
	$ passwd
	$ su
	$ umask
	$ chgrp
	$ chmod
	$ chown
	$ chattr
	$ sudo
	$ who
	$ w
	$ lsblk
```
# 网络操作命令
```bash
	$ ifconfig
	$ ip
	$ ping
	$ telnet
	$ ftp
	$ route
	$ ssh
	$ mail
	$ dig
	$ nslookup
	$ netstat
	$ ifup
	$ ifdown
	$ dhclient
```
# 其命令
```bash
	$ tar
	$ unzip
	$ gzip
	$ unarj
	$ mtools
	$ histroy
	$ ps
	$ kill
	$ wall
	$ mesg
	$ whereis
	$ alias
	$ wget
	$ write
	$ talk
	$ mkfs
```
# 进程服务
```bash
	$ service
	$ top
	$ ps
	$ pstree
	$ lsof
	$ chkconfig
	$ kill
	$ nice
	$ renice
	$ sleep
	$ nohup
	$ pgrep
	$ killall
	$ pkill
	$ xkill
```
# 计划任务
```bash
	$ at
	$ batch
	$ crontab
	$ bg
	$ fg
	$ jobs
```
# 编译编程
```bash
	$ gcc
	$ g++
	$ java
	$ python
```
# 时间
```bash
	$ date
	$ uptime
	$ cal
	$ hwclock
	$ ntpd(Network-time-protocol)
```
# 日志
```bash
	syslog(/etc/syslog.conf|/etc/rsyslog.conf)
	/var/log/
	lastlog		检查上次某个特定用户登录信息
	last 		搜索/var/log/wtmp显示自文件创建以来登录过的用户
	lastb		搜索/var/log/btmp来显示登录未成功的信息
	who			搜索/var/wtmp显示当前登录的用户
	logrotate	用于配置滚动日志
```