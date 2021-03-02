# title{wget - Linux系统下载文件工具}

### 选项
```bash
启动参数：
-V, –version 显示wget的版本后退出
-h, –help 打印语法帮助
-b, –background 启动后转入后台执行
-e, –execute=COMMAND 执行`.wgetrc’格式的命令，wgetrc格式参见/etc/wgetrc或~/.wgetrc

#记录和输入文件参数：
-o, –output-file=FILE 把记录写到FILE文件中
-a, –append-output=FILE 把记录追加到FILE文件中
-d, –debug 打印调试输出
-q, –quiet 安静模式(没有输出)
-v, –verbose 冗长模式(这是缺省设置)
-nv, –non-verbose 关掉冗长模式，但不是安静模式
-i, –input-file=FILE 下载在FILE文件中出现的URLs
-F, –force-html 把输入文件当作HTML格式文件对待
-B, –base=URL 将URL作为在-F -i参数指定的文件中出现的相对链接的前缀
–sslcertfile=FILE 可选客户端证书
–sslcertkey=KEYFILE 可选客户端证书的KEYFILE
–egd-file=FILE 指定EGD socket的文件名

#下载参数：
–bind-address=ADDRESS 指定本地使用地址(主机名或IP，当本地有多个IP或名字时使用)
-t, –tries=NUMBER 设定最大尝试链接次数(0 表示无限制).
-O –output-document=FILE 把文档写到FILE文件中
-nc, –no-clobber 不要覆盖存在的文件或使用.#前缀
-c, –continue 接着下载没下载完的文件
–progress=TYPE 设定进程条标记
-N, –timestamping 不要重新下载文件除非比本地文件新
-S, –server-response 打印服务器的回应
–spider 不下载任何东西
-T, –timeout=SECONDS 设定响应超时的秒数
-w, –wait=SECONDS 两次尝试之间间隔SECONDS秒
–waitretry=SECONDS 在重新链接之间等待1…SECONDS秒
–random-wait 在下载之间等待0…2*WAIT秒
-Y, –proxy=on/off 打开或关闭代理
-Q, –quota=NUMBER 设置下载的容量限制
–limit-rate=RATE 限定下载输率

#目录参数：
-nd –no-directories 不创建目录
-x, –force-directories 强制创建目录
-nH, –no-host-directories 不创建主机目录
-P, –directory-prefix=PREFIX 将文件保存到目录 PREFIX/…
–cut-dirs=NUMBER 忽略 NUMBER层远程目录

# HTTP 选项参数：
–http-user=USER 设定HTTP用户名为 USER.
–http-passwd=PASS 设定http密码为 PASS
-C, –cache=on/off 允许/不允许服务器端的数据缓存 (一般情况下允许)
-E, –html-extension 将所有text/html文档以.html扩展名保存
–ignore-length 忽略 `Content-Length’头域
–header=STRING 在headers中插入字符串 STRING
–proxy-user=USER 设定代理的用户名为 USER
–proxy-passwd=PASS 设定代理的密码为 PASS
–referer=URL 在HTTP请求中包含 `Referer: URL’头
-s, –save-headers 保存HTTP头到文件
-U, –user-agent=AGENT 设定代理的名称为 AGENT而不是 Wget/VERSION
–no-http-keep-alive 关闭 HTTP活动链接 (永远链接)
–cookies=off 不使用 cookies
–load-cookies=FILE 在开始会话前从文件 FILE中加载cookie
–save-cookies=FILE 在会话结束后将 cookies保存到 FILE文件中

#FTP 选项参数：
-nr, –dont-remove-listing 不移走 `.listing’文件
-g, –glob=on/off 打开或关闭文件名的 globbing机制
–passive-ftp 使用被动传输模式 (缺省值).
–active-ftp 使用主动传输模式
–retr-symlinks 在递归的时候，将链接指向文件(而不是目录)

#递归下载参数：
-r, –recursive 递归下载－－慎用!
-l, –level=NUMBER 最大递归深度 (inf 或 0 代表无穷)
–delete-after 在现在完毕后局部删除文件
-k, –convert-links 转换非相对链接为相对链接
-K, –backup-converted 在转换文件X之前，将之备份为 X.orig
-m, –mirror 等价于 -r -N -l inf -nr
-p, –page-requisites 下载显示HTML文件的所有图片

#递归下载中的包含和不包含(accept/reject)：
-A, –accept=LIST 分号分隔的被接受扩展名的列表
-R, –reject=LIST 分号分隔的不被接受的扩展名的列表
-D, –domains=LIST 分号分隔的被接受域的列表
–exclude-domains=LIST 分号分隔的不被接受的域的列表
–follow-ftp 跟踪HTML文档中的FTP链接
–follow-tags=LIST 分号分隔的被跟踪的HTML标签的列表
-G, –ignore-tags=LIST 分号分隔的被忽略的HTML标签的列表
-H, –span-hosts 当递归时转到外部主机
-L, –relative 仅仅跟踪相对链接
-I, –include-directories=LIST 允许目录的列表
-X, –exclude-directories=LIST 不被包含目录的列表
-np, –no-parent 不要追溯到父目录
wget -S –spider url 不下载只显示过程
```


### 常用命令
```bash
# To download a single file
#下载单个文件
wget http://path.to.the/file

# To download a file and change its name
#下载文件并更改其名称
wget http://path.to.the/file -O newname

# To download a file into a directory
#将文件下载到目录中
wget -P path/to/directory http://path.to.the/file

# To continue an aborted downloaded
#要继续中止下载
wget -c http://path.to.the/file

# To download multiples files with multiple URLs
#下载包含多个URL的多个文件
wget URL1 URL2

# To parse a file that contains a list of URLs to fetch each one
#解析包含URL列表的文件以获取每个URL
wget -i url_list.txt

# To mirror a whole page locally
#在本地镜像整个页面
wget -pk http://path.to.the/page.html

# To mirror a whole site locally
#在本地镜像整个站点
wget -mk http://site.tl/

# To download files according to a pattern
#根据模式下载文件
wget http://www.myserver.com/files-{1..15}.tar.bz2

# To download all the files in a directory with a specific extension if directory indexing is enabled
#如果启用了目录索引，则下载具有特定扩展名的目录中的所有文件
wget -r -l1 -A.extension http://myserver.com/directory

# Allows you to download just the headers of responses (-S --spider) and display them on Stdout (-O -).
#允许您只下载响应的标题（-S --spider）并在Stdout（-O  - ）上显示它们。
wget -S --spider -O - http://google.com

# Change the User-Agent to 'User-Agent: toto'
#将User-Agent更改为“User-Agent：toto”
wget -U 'toto' http://google.com

wget -t 0 -T 120 -np -c -r http://xxx.xxx.com/xxx
wget -t 0 -T 120 -np -c -r ftp://xxx:xxx@xxx.com/xxx
#其中“np”表示不跟随链接，只下载指定目录及子目录里的文件；-c 表示启动断点续传，其实下目录及子目录有-r就可以，
#简略就用映像用的-m参数，即：
wget -m -np http://xxx.xxx.com/xxx
wget -m -np ftp://xxx:xxx@xxx.com/xxx

#下载下载192.168.1.168首页并且显示下载信息Linux 
wget -d http://192.168.1.168
#下载192.168.1.168首页并且不显示任何信息
wget -q http://192.168.1.168
#下载filelist.txt中所包含的链接的所有文件
wget -i filelist.txt
#下载到指定目录,把文件file下载到/tmp目录下。
wget -P/tmp ftp://user:passwd@url/file

wget -r -np -nd http://example.com/packages/
#这条命令可以下载 http://example.com 网站上 packages 目录中的所有文件。其中，-np 的作用是不遍历父目录，-nd 表示不在本机重新创建目录结构。
wget -r -np -nd --accept=iso http://example.com/centos-5/i386/
#与上一条命令相似，但多加了一个 --accept=iso 选项，这指示Linux wget仅下载 i386 目录中所有扩展名为 iso 的文件。你也可以指定多个扩展名，只需用逗号分隔即可。
wget -i filename.txt
#此命令常用于批量下载的情形，把所有需要下载文件的地址放到 filename.txt 中，然后 Linux wget就会自动为你下载所有文件了。
wget -c http://example.com/really-big-file.iso
#这里所指定的 -c 选项的作用为断点续传。
wget -m -k (-H) http://www.example.com/
#该命令可用来镜像一个网站，Linux wget将对链接进行转换。如果网站中的图像是放在另外的站点，那么可以使用 -H 选项。

#下载某站点目录和子目录文件
wget -t 0 -T 120 -np -c -r --restrict-file-names=ascii  http://xxx.com/shell

#转换文件名乱码
python  rename.py -i utf-8 -o gbk -p /root/111 -u
```
