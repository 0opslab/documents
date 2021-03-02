# title{sockstat - 查看系统中socket状态}

```bash
# To view which users/processes are listening to which ports:
#要查看哪些用户/进程正在侦听哪些端口：
sudo sockstat -l

# 打开的socket数量很多时，netstat就会变得慢了，有什么办法可以快速查看系统中socket状态
cat /proc/net/sockstat

# ipv6
cat /proc/net/sockstat6

```