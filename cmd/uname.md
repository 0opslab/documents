# title{uname - 用于显示系统信息}

### 选项
```bash
-a或–all 　显示全部的信息。
-m或–machine 　显示电脑类型。
-n或-nodename 　显示在网络上的主机名称。
-r或–release 　显示操作系统的发行编号。
-s或–sysname 　显示操作系统名称。
-v 　显示操作系统的版本。
–help 　显示帮助。
–version 　显示版本信息。
```

### 常用命令
```bash
# Print all system information
#打印所有系统信息
uname -a
# Linux system-hostname 3.2.0-4-amd64 #1 SMP Debian 3.2.32-1 x86_64 GNU/Linux
#Linux system-hostname 3.2.0-4-amd64＃1 SMP Debian 3.2.32-1 x86_64 GNU / Linux

# Print the hostname
#打印主机名
uname -n
# system-hostname
#系统主机名

# Print the kernel release
#打印内核版本
uname -r
# 3.2.0-4-amd64
#3.2.0-4-AMD64

# Print the kernel version, with more specific information
#打印内核版本，以及更具体的信息
uname -v
# #1 SMP Debian 3.2.32-1
#＃1 Debian Middle School＃3.2.32-1

# Print the hardware instruction set
#打印硬件指令集
uname -m
# x86_64
#x86_64的

# Print the kernel name
#打印内核名称
uname -s
# Linux
#Linux的

# Print the operating system
#打印操作系统
uname -o
# GNU/Linux
#GNU/Linux
```