# title{nc - 一款网关相关的命令}

### 选项
```bash
-g<网关> 设置路由器跃程通信网关，最多可设置8个。
-G<指向器数目> 设置来源路由指向器，其数值为4的倍数。
-h 在线帮助。
-i<延迟秒数> 设置时间间隔，以便传送信息及扫描通信端口。
-l 使用监听模式，管控传入的资料。
-n 直接使用IP地址，而不通过域名服务器。
-o<输出文件> 指定文件名称，把往来传输的数据以16进制字码倾倒成该文件保存。
-p<通信端口> 设置本地主机使用的通信端口。
-r 乱数指定本地与远端主机的通信端口。
-s<来源位址> 设置本地主机送出数据包的IP地址。
-u 使用UDP传输协议。
-v 显示指令执行过程。
-w<超时秒数> 设置等待连线的时间。
-z 使用0输入/输出模式，只在扫描通信端口时使用。
```

### 常用命令
```bash
# To open a TCP connection to port 42 of host.example.com, using port 31337 as the source port
# with a timeout of 5 seconds:
# 要打开到host.example.com端口42的TCP连接，请使用端口31337作为源端口，超时为5秒：
nc -p 31337 -w 5 host.example.com 42

# To open a UDP connection to port 53 of host.example.com:
#要打开到host.example.com的端口53的UDP连接：
nc -u host.example.com 53

# To open a TCP connection to port 42 of host.example.com using 10.1.2.3 as the IP for the local end of the connection:
#要使用10.1.2.3作为连接本地端的IP，打开与host.example.com的端口42的TCP连接：
nc -s 10.1.2.3 host.example.com 42

# To create and listen on a UNIX-domain stream socket:
#要在UNIX域流套接字上创建和侦听：
nc -lU /var/tmp/dsocket

# To connect to port 42 of host.example.com via an HTTP proxy at 10.2.3.4, port 8080.
# This example could also be used by ssh(1); see the ProxyCommand directive in ssh_config(5) for more information.
# 通过10.2.3.4端口8080的HTTP代理连接到host.example.com的端口42.此示例也可以由ssh
# （1）使用;有关更多信息，请参阅ssh_config（5）中的ProxyCommand指令。
nc -x10.2.3.4:8080 -Xconnect host.example.com 42

# The same example again, this time enabling proxy authentication with username "ruser" if the proxy requires it:
#再次使用相同的示例，如果代理需要，则使用用户名“ruser”启用代理身份验证：
nc -x10.2.3.4:8080 -Xconnect -Pruser host.example.com 42

# To choose the source IP for the testing using the -s option
#使用-s选项为测试选择源IP
nc -zv -s source_IP target_IP Port
```