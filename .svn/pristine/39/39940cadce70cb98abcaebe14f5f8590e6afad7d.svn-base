ss
Utility to investigate sockets

Args
-4/-6 list ipv4/ipv6 sockets
-n numeric addresses instead of hostnames
-l list listing sockets
-u/-t/-x list udp/tcp/unix sockets
-p Show process(es) that using socket

# show all listing tcp sockets including the corresponding process
#显示所有列出的tcp套接字，包括相应的进程
ss -tlp

# show all sockets connecting to 192.168.2.1 on port 80
#显示连接到端口80上的192.168.2.1的所有套接字
ss -t dst 192.168.2.1:80

# show all ssh related connection
#显示所有ssh相关的连接
ss -t state established '( dport = :ssh or sport = :ssh )'
