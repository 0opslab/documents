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
