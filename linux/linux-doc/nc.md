# To open a TCP connection to port 42 of host.example.com, using port 31337 as the source port, with a timeout of 5 seconds:
#要打开到host.example.com端口42的TCP连接，请使用端口31337作为源端口，超时为5秒：
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

# To connect to port 42 of host.example.com via an HTTP proxy at 10.2.3.4, port 8080. This example could also be used by ssh(1); see the ProxyCommand directive in ssh_config(5) for more information.
#要通过10.2.3.4端口8080的HTTP代理连接到host.example.com的端口42.此示例也可以由ssh（1）使用;有关更多信息，请参阅ssh_config（5）中的ProxyCommand指令。
nc -x10.2.3.4:8080 -Xconnect host.example.com 42

# The same example again, this time enabling proxy authentication with username "ruser" if the proxy requires it:
#再次使用相同的示例，如果代理需要，则使用用户名“ruser”启用代理身份验证：
nc -x10.2.3.4:8080 -Xconnect -Pruser host.example.com 42

# To choose the source IP for the testing using the -s option
#使用-s选项为测试选择源IP
nc -zv -s source_IP target_IP Port
