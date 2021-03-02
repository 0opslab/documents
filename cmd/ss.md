# title{ss - 获取socket统计信息}
### 选项
```bash
-h, --help      帮助信息
-V, --version   程序版本信息
-n, --numeric   不解析服务名称
-r, --resolve   解析主机名
-a, --all       显示所有套接字（sockets）
-l, --listening 显示监听状态的套接字（sockets）
-o, --options   显示计时器信息
-e, --extended  显示详细的套接字（sockets）信息
-m, --memory    显示套接字（socket）的内存使用情况
-p, --processes 显示使用套接字（socket）的进程
-i, --info      显示 TCP内部信息
-s, --summary   显示套接字（socket）使用概况
-4, --ipv4      仅显示IPv4的套接字（sockets）
-6, --ipv6      仅显示IPv6的套接字（sockets）
-0, --packet    显示 PACKET 套接字（socket）
-t, --tcp       仅显示 TCP套接字（sockets）
-u, --udp       仅显示 UCP套接字（sockets）
-d, --dccp      仅显示 DCCP套接字（sockets）
-w, --raw       仅显示 RAW套接字（sockets）
-x, --unix      仅显示 Unix套接字（sockets）
-f, --family=FAMILY  显示 FAMILY类型的套接字（sockets），FAMILY可选，支持  unix, inet, inet6, link, netlink
-A, --query=QUERY, --socket=QUERY
      QUERY := {all|inet|tcp|udp|raw|unix|packet|netlink}[,QUERY]
-D, --diag=FILE     将原始TCP套接字（sockets）信息转储到文件
 -F, --filter=FILE  从文件中都去过滤器信息
       FILTER := [ state TCP-STATE ] [ EXPRESSION ]
```

### 常用命令
```bash
# Args
# -4/-6 list ipv4/ipv6 sockets
# -n numeric addresses instead of hostnames
# -l list listing sockets
# -u/-t/-x list udp/tcp/unix sockets
# -p Show process(es) that using socket

# show all listing tcp sockets including the corresponding process
#显示所有列出的tcp套接字，包括相应的进程
ss -tlp

# show all sockets connecting to 192.168.2.1 on port 80
#显示连接到端口80上的192.168.2.1的所有套接字
ss -t dst 192.168.2.1:80

# show all ssh related connection
#显示所有ssh相关的连接
ss -t state established '( dport = :ssh or sport = :ssh )'


ss -an | grep 19000|grep -i es | awk '{ print $6 }' | awk -F: '{ print $1}' | sort | uniq -c | sort -nr | head -n 30



# 显示TCP连接
ss -t -a    

# 显示 Sockets 摘要
ss -s       

# 列出所有打开的网络连接端口
ss -l       

# 查看进程使用的socket
ss -pl      
# 找出打开套接字/端口应用程序
ss -lp | grep 3306  
#显示所有UDP Sockets
ss -u -a    
# 显示所有状态为established的SMTP连接
ss -o state established '( dport = :smtp or sport = :smtp )' 
# 显示所有状态为Established的HTTP连接
ss -o state established '( dport = :http or sport = :http )' 
# 列举出处于 FIN-WAIT-1状态的源端口为 80或者 443，目标网络为 193.233.7/24所有 tcp套接字
ss -o state fin-wait-1 '( sport = :http or sport = :https )' dst 193.233.7/24  

```
