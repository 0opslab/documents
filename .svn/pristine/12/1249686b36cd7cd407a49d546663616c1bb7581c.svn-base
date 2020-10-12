# WARNING ! netstat is deprecated. Look below.
#警告 ！ netstat已弃用。往下看。

# To view which users/processes are listening to which ports:
#要查看哪些用户/进程正在侦听哪些端口：
sudo netstat -lnptu

# To view routing table (use -n flag to disable DNS lookups):
#要查看路由表（使用-n标志禁用DNS查找）：
netstat -r

# Which process is listening to port <port>
#哪个进程正在侦听端口<port>
netstat -pln | grep <port> | awk '{print $NF}'

Example output: 1507/python

# Fast display of ipv4 tcp listening programs
#快速显示ipv4 tcp监听程序
sudo netstat -vtlnp --listening -4

# WARNING ! netstat is deprecated.
#警告 ！ netstat已弃用。
# Replace it by:
#替换为：
ss

# For netstat-r
#对于netstat-r
ip route

# For netstat -i
#对于netstat -i
ip -s link

# For netstat-g
#对于netstat-g
ip maddr
