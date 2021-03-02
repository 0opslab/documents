# title{lsof - 显示Linux系统当前已打开的所有文件列表}

lsof命令 用于查看你进程开打的文件，打开文件的进程，进程打开的端口(TCP、UDP)。找回/恢复删除的文件。
是十分方便的系统监视工具，因为lsof命令需要访问核心内存和各种文件，所以需要root用户执行

### 选项
```bash
-a：列出打开文件存在的进程；
-c<进程名>：列出指定进程所打开的文件；
-g：列出GID号进程详情；
-d<文件号>：列出占用该文件号的进程；
+d<目录>：列出目录下被打开的文件；
+D<目录>：递归列出目录下被打开的文件；
-n<目录>：列出使用NFS的文件；
-i<条件>：列出符合条件的进程。（4、6、协议、:端口、 @ip ）
-p<进程号>：列出指定进程号所打开的文件；
-u：列出UID号进程详情；
-h：显示帮助信息；
-v：显示版本信息。
```

### 常用命令

```bash
# List all IPv4 network files
#列出所有IPv4网络文件
sudo lsof -i4

# List all IPv6 network files
#列出所有IPv6网络文件
sudo lsof -i6

# List all open sockets
#列出所有打开的套接字
lsof -i

# List all listening ports
#列出所有侦听端口
lsof -Pnl +M -i4

# Find which program is using the port 80
#找到正在使用端口80的程序
lsof -i TCP:80

# List all connections to a specific host
#列出与特定主机的所有连接
lsof -i@192.168.1.5

# List all processes accessing a particular file/directory
#列出访问特定文件/目录的所有进程
lsof </path/to/file>

# List all files open for a particular user
#列出为特定用户打开的所有文件
lsof -u <username>

# List all files/network connections a command is using
#列出命令正在使用的所有文件/网络连接
lsof -c <command-name>

# List all files a process has open
#列出进程已打开的所有文件
lsof -p <pid>

# List all files open mounted at /mount/point.
#列出挂载在/ mount / point的所有文件。
# Particularly useful for finding which process(es) are using a
#特别适用于查找哪些进程正在使用a
# mounted USB stick or CD/DVD.
#安装的USB记忆棒或CD / DVD。
lsof +f -- </mount/point>

# See this primer: http://www.danielmiessler.com/study/lsof/
#见这个入门书：http：//www.danielmiessler.com/study/lsof/
# for a number of other useful lsof tips
#对于许多其他有用的lsof提示
```