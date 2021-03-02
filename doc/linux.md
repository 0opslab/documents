# title{linux - linux常用命令汇总}
## 开机配置信息读取顺序
```bash
/etc/profile
/etc/profile.d/*.sh
~/bash_profile
~/.bashrc
/etc/bashrc
```

## grub开机启动项添加
```bash
vim /etc/grub.conf
title ms-dos
rootnoverify (hd0,0)
chainloader +1
```

## 终端下一些设置
stty iuclc          # 在命令行下禁止输出大写
stty -iuclc         # 恢复输出大写
stty olcuc          # 在命令行下禁止输出小写
stty -olcuc         # 恢复输出小写
stty size           # 打印出终端的行数和列数
stty eof "string"   # 改变系统默认ctrl+D来表示文件的结束 
stty -echo          # 禁止回显
stty echo           # 打开回显
stty -echo;read;stty echo;read  # 测试禁止回显
stty igncr          # 忽略回车符
stty -igncr         # 恢复回车符
stty erase '#'      # 将#设置为退格字符
stty erase '^?'     # 恢复退格字符

## 系统
```bash
wall        　  　          # 给其它用户发消息
whereis ls                  # 查找命令的目录
which                       # 查看当前要执行的命令所在的路径
clear                       # 清空整个屏幕
reset                       # 重新初始化屏幕
cal                         # 显示月历
echo -n 123456 | md5sum     # md5加密
mkpasswd                    # 随机生成密码   -l位数 -C大小 -c小写 -d数字 -s特殊字符
netstat -anlp | grep port   # 是否打开了某个端口
ntpdate stdtime.gov.hk      # 同步时间
tzselect                    # 选择时区 #+8=(5 9 1 1) # (TZ='Asia/Shanghai'; export TZ)括号内写入 /etc/profile
/sbin/hwclock -w            # 保存到硬件
/etc/shadow                 # 账户影子文件
LANG=en                     # 修改语言
vim /etc/sysconfig/i18n     # 修改编码  LANG="en_US.UTF-8"
export LC_ALL=C             # 强制字符集
vi /etc/hosts               # 查询静态主机名
alias                       # 别名
watch uptime                # 监测命令动态刷新
ipcs -a                     # 查看Linux系统当前单个共享内存段的最大值
lsof |grep /lib             # 查看加载库文件
ldconfig                    # 动态链接库管理命令
dist-upgrade                # 会改变配置文件,改变旧的依赖关系，改变系统版本 
/boot/grub/grub.conf        # grub启动项配置
sysctl -p                   # 修改内核参数/etc/sysctl.conf，让/etc/rc.d/rc.sysinit读取生效
mkpasswd -l 8  -C 2 -c 2 -d 4 -s 0            # 随机生成指定类型密码
echo 1 > /proc/sys/net/ipv4/tcp_syncookies    # 使TCP SYN Cookie 保护生效  # "SYN Attack"是一种拒绝服务的攻击方式
```


## 信号

```bash
kill -l                    # 查看linux提供的信号
trap "echo aaa"  2 3 15    # shell使用 trap 捕捉退出信号

# 发送信号一般有两种原因:
#   1(被动式)  内核检测到一个系统事件.例如子进程退出会像父进程发送SIGCHLD信号.键盘按下control+c会发送SIGINT信号
#   2(主动式)  通过系统调用kill来向指定进程发送信号                             
# 进程结束信号 SIGTERM 和 SIGKILL 的区别:  SIGTERM 比较友好，进程能捕捉这个信号，根据您的需要来关闭程序。在关闭程序之前，您可以结束打开的记录文件和完成正在做的任务。在某些情况下，假如进程正在进行作业而且不能中断，那么进程可以忽略这个SIGTERM信号。
# 如果一个进程收到一个SIGUSR1信号，然后执行信号绑定函数，第二个SIGUSR2信号又来了，第一个信号没有被处理完毕的话，第二个信号就会丢弃。

SIGHUP  1          A     # 终端挂起或者控制进程终止
SIGINT  2          A     # 键盘终端进程(如control+c)
SIGQUIT 3          C     # 键盘的退出键被按下
SIGILL  4          C     # 非法指令
SIGABRT 6          C     # 由abort(3)发出的退出指令
SIGFPE  8          C     # 浮点异常
SIGKILL 9          AEF   # Kill信号  立刻停止
SIGSEGV 11         C     # 无效的内存引用
SIGPIPE 13         A     # 管道破裂: 写一个没有读端口的管道
SIGALRM 14         A     # 闹钟信号 由alarm(2)发出的信号 
SIGTERM 15         A     # 终止信号,可让程序安全退出 kill -15
SIGUSR1 30,10,16   A     # 用户自定义信号1
SIGUSR2 31,12,17   A     # 用户自定义信号2
SIGCHLD 20,17,18   B     # 子进程结束自动向父进程发送SIGCHLD信号
SIGCONT 19,18,25         # 进程继续（曾被停止的进程）
SIGSTOP 17,19,23   DEF   # 终止进程
SIGTSTP 18,20,24   D     # 控制终端（tty）上按下停止键
SIGTTIN 21,21,26   D     # 后台进程企图从控制终端读
SIGTTOU 22,22,27   D     # 后台进程企图从控制终端写

缺省处理动作一项中的字母含义如下:
  A  缺省的动作是终止进程
  B  缺省的动作是忽略此信号，将该信号丢弃，不做处理
  C  缺省的动作是终止进程并进行内核映像转储(dump core),内核映像转储是指将进程数据在内存的映像和进程在内核结构
      中的部分内容以一定格式转储到文件系统，并且进程退出执行，这样做的好处是为程序员提供了方便，使得他们可以得
      到进程当时执行时的数据值，允许他们确定转储的原因，并且可以调试他们的程序。
  D  缺省的动作是停止进程，进入停止状况以后还能重新进行下去，一般是在调试的过程中（例如ptrace系统调用）
  E  信号不能被捕获
  F  信号不能被忽略
```




	
## 系统信息
```bash
		uname -a              # 查看Linux内核版本信息
		cat /proc/version     # 查看内核版本
		cat /etc/issue        # 查看系统版本
		lsb_release -a        # 查看系统版本  需安装 centos-release
		locale -a             # 列出所有语系
		hwclock               # 查看时间
		who                   # 当前在线用户
		w                     # 当前在线用户
		whoami                # 查看当前用户名
		logname               # 查看初始登陆用户名
		uptime                # 查看服务器启动时间
		sar -n DEV 1 10       # 查看网卡网速流量
		dmesg                 # 显示开机信息
		lsmod	              # 查看内核模块
```

	
## 硬件信息
```bash
more /proc/cpuinfo                                       # 查看cpu信息
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c    # 查看cpu型号和逻辑核心数
getconf LONG_BIT                                         # cpu运行的位数
cat /proc/cpuinfo | grep physical | uniq -c              # 物理cpu个数
cat /proc/cpuinfo | grep flags | grep ' lm ' | wc -l     # 结果大于0支持64位
cat /proc/cpuinfo|grep flags                             # 查看cpu是否支持虚拟化   pae支持半虚拟化  IntelVT 支持全虚拟化
more /proc/meminfo                                       # 查看内存信息
dmidecode                                                # 查看全面硬件信息
dmidecode | grep "Product Name"                          # 查看服务器型号
dmidecode | grep -P -A5 "Memory\s+Device" | grep Size | grep -v Range       # 查看内存插槽
cat /proc/mdstat                                         # 查看软raid信息
cat /proc/scsi/scsi                                      # 查看Dell硬raid信息(IBM、HP需要官方检测工具)
lspci                                                    # 查看硬件信息
lspci|grep RAID                                          # 查看是否支持raid
lspci -vvv |grep Ethernet                                # 查看网卡型号
lspci -vvv |grep Kernel|grep driver                      # 查看驱动模块
modinfo tg2                                              # 查看驱动版本(驱动模块)
ethtool -i em1                                           # 查看网卡驱动版本
```