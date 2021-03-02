# title{curl - 基于URL语法在命令行非常实用非常强大}

### 常用选项如下所示:
```bash
　　-A/--user-agent <string>: 设置用户代理发送给服务器
　　-e/--referer <URL>: 来源网址
　　--cacert <file>: CA证书 (SSL)
　　-k/--insecure: 允许忽略证书进行 SSL 连接
　　--compressed: 要求返回是压缩的格式
　　-H/--header <line>: 自定义首部信息传递给服务器
　　-i: 显示页面内容，包括报文首部信息
　　-I/--head:只显示响应报文首部信息
　　-D/--dump-header <file>: 　将url的header信息存放在指定文件中
　　--basic: 使用HTTP基本认证
　　-u/--user <user[:password]>: 设置服务器的用户和密码
　　-L: 如果有3xx响应码，重新发请求到新位置
　　-O: 使用URL中默认的文件名保存文件到本地
　　-o <file>: 将网络文件保存为指定的文件中
　　--limit-rate <rate>: 设置传输速度
　　-0/--http1.0: 数字0，使用HTTP 1.0
　　-v/--verbose: 更详细
　　-C: 选项可对文件使用断点续传功能
　　-c/--cookie-jar <file name>: 将url中cookie存放在指定文件中
　　-x/--proxy <proxyhost[:port]>: 指定代理服务器地址
　　-X/--request <command>: 向服务器发送指定请求方法
　　-U/--proxy-user <user:password>: 代理服务器用户和密码
　　-T: 选项可将指定的本地文件上传到FTP服务器上
　　--data/-d: 方式指定使用POST方式传递数据
　　-b name=data: 从服务器响应set-cookie得到值，返回给服务器
```

##  实例
```bash
# Download a single file
#下载单个文件
curl http://path.to.the/file

# Download a file and specify a new filename
#下载文件并指定新文件名
curl http://example.com/file.zip -o new_file.zip

# Download multiple files
#下载多个文件
curl -O URLOfFirstFile -O URLOfSecondFile

# Download all sequentially numbered files (1-24)
#下载所有按顺序编号的文件（1-24）
curl http://example.com/pic[1-24].jpg

# Download a file and pass HTTP Authentication
#下载文件并传递HTTP身份验证
curl -u username:password URL 

# Download a file with a Proxy
#使用代理下载文件
curl -x proxysever.server.com:PORT http://addressiwantto.access

# Download a file from FTP
#从FTP下载文件
curl -u username:password -O ftp://example.com/pub/file.zip

# Get an FTP directory listing
#获取FTP目录列表
curl ftp://username:password@example.com

# Resume a previously failed download
#恢复以前失败的下载
curl -C - -o partial_file.zip http://example.com/file.zip

# Fetch only the HTTP headers from a response
#仅从响应中获取HTTP标头
curl -I http://example.com

# Fetch your external IP and network info as JSON
#将您的外部IP和网络信息作为JSON获取
curl http://ifconfig.me/all.json

# Limit the rate of a download
#限制下载速度
curl --limit-rate 1000B -O http://path.to.the/file

# Get your global IP
#获取您的全球IP
curl httpbin.org/ip 

# Get only the HTTP status code
#仅获取HTTP状态代码
curl -o /dev/null -w '%{http_code}\n' -s -I URL


# curl 命令分析请求的耗时情况
# curl-format.txt 定义内置变量，变量说明如下：
#
#   time_namelookup：DNS 域名解析的时候，就是把 https://zhihu.com 转换成 ip 地址的过程
#   time_connect：TCP 连接建立的时间，就是三次握手的时间
#   time_appconnect：SSL/SSH 等上层协议建立连接的时间，比如 connect/handshake 的时间
#   time_redirect：从开始到最后一个请求事务的时间
#   time_pretransfer：从请求开始到响应开始传输的时间
#   time_starttransfer：从请求开始到第一个字节将要传输的时间
#   size_download:  下载字节
#   time_total：这次请求花费的全部时间

# curl-format文件内容
#    time_namelookup:  %{time_namelookup}\n
#       time_connect:  %{time_connect}\n
#    time_appconnect:  %{time_appconnect}\n
#      time_redirect:  %{time_redirect}\n
#   time_pretransfer:  %{time_pretransfer}\n
# time_starttransfer:  %{time_starttransfer}\n
#      size_download:  %{size_download} KB\n
#                    ----------\n
#         time_total:  %{time_total}\n


CURL_FORMAT="$(dirname $0)/curl-format.txt" 
[ ! -z $1 ] && curl -w "@$CURL_FORMAT" -o /dev/null -s -L "$1" || echo "Usage $basename $0 <url>"

```