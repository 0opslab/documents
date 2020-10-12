title: Linux常用命令
date: 2016-01-02 16:22:26
tags: Linux
categories: Linux
---
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
# bash快捷键
## 编辑命令
```bash
	ctrl+a:移动到命令行首
	ctrl+e:移动到命令行尾
	ctrl+f:按字符串向前移动
	ctrl+b:按字符向后移动
	alt+f:按单词向前移动
	alt+b:按单词向后移动
	ctrl+xx:在命令行首与和光标之间移动
	ctrl+u:从光标处删除至命令行首
	ctrl+k:从光标处删除至命令行尾
	ald+d:从光标处删除至字尾
	ctrl+d:删除光标处的字符
	ctrl+h:删除光标前的字符
	ctrl+y:粘贴到光标之后
	alt+c:从光标处更改为首字母大写的单词
	alt+u:从光标处更改为全部大写的单词
	alt+l:从光标处更改为全部小写的单词
	ctrl+t:交换光标处和之前的字符
	alt+t:交换光标处和之前的单词
	alt+backspace:与ctrl+w相同
```
## 重新执行命令
```bash
    Ctrl + r：逆向搜索命令历史
    Ctrl + g：从历史搜索模式退出
    Ctrl + p：历史中的上一条命令
    Ctrl + n：历史中的下一条命令
    Alt + .：使用上一条命令的最后一个参数
```
## 控制命令
```bash
    Ctrl + l：清屏
    Ctrl + o：执行当前命令，并选择上一条命令
    Ctrl + s：阻止屏幕输出
    Ctrl + q：允许屏幕输出
    Ctrl + c：终止命令
    Ctrl + z：挂起命令
```
## 复制粘帖
```bash
	在终端中可以按Ctrl+c进入块模式，之后按方向键进行选择，然后按Ctrl+Insert键进行复制在需要的地方按shift+insert键进行粘帖
	在Vim中
		yy     复制一行，此命令前可跟数字，标识复制多行，如6yy，表示从当前行开始复制6行
		yw     复制一个字
		y$     复制到行末
		p      粘贴粘贴板的内容到当前行的下面
```
## Bang (!) 命令
```bash
    !!          执行上一条命令
    !blah       执行最近的以 blah 开头的命令，如 !ls
    !blah:p     仅打印输出，而不执行
    !$          上一条命令的最后一个参数，与 Alt + . 相同
    !$:p        打印输出 !$ 的内容
    !*          上一条命令的所有参数
    !*:p        打印输出 !* 的内容
    ^blah       删除上一条命令中的 blah
    ^blah^foo   将上一条命令中的 blah 替换为 foo
    ^blah^foo^  将上一条命令中所有的 blah 都替换为 foo
```
## linux下图行界面快捷键
```bash
    ALT+F1               打开linux 下gnome 的应用程序
    ALT+F2              打开一个小型的运行应用程序
    ALT＋F4              关闭窗口
    ALT＋F5              取消最大窗口
    ALT＋F7              移动窗口
    ATL＋F8              改变大小
    ALT＋F9              最小化当前窗口
    ALT＋F10               最大化当前窗
    ALT+鼠标左              移动窗口
    ALT+TAB              切换打开程序
    ALT+Print              当前窗口抓图
    ALT+CTRL+L              启动屏幕保护程序
    ATL+CTRL+D              显示桌面
    CRL＋SHIFT＋N            新建文件夹
    CTRL＋T           把选中的文件放入回收站
    CTRL＋ALT＋（F1－F6）    切换终端
    CTRL＋ATL＋F7           切换到图行界面
    CTRL＋R            刷新
    CTRL＋N            新建
    CTRL＋X            剪切
    CTRL＋C            复制
    CTRL＋V            粘贴
    CTRL＋Z            撤销
```
# shell元字符
```bash
	*               代表任意字符串
	?	        代表任意字符
	/	        代表根目录或作为路径间隔符使用
	\	        转义符。
	\<Enter>	续行符
	$	        变量值置换。
	‘	        在’....’中间的字符都会被当作文本处理。
	“	        在”...”中间的字符会被当作文本处理并允许变量值置换
	`	        命令替换，置换`...`中命令的执行结果
	<	        输入重定向字符
	>	        输出重定向字符
	|	        管道字符
	&	        后台执行符
	;	        分隔顺序执行的多个命令
	()	        在子shell中执行命令
	{}	        在当前shell中执行命令
	!	        执行历史命令
	~	        代表当前用户的家目录
```
