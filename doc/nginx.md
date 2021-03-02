# title{nginx - 关于Nginx这一篇就够了}

Nginx是一个高性能的HTTP和反向代理服务器，也是一个IMAP/POP3/STMP服务器，此处只说HTTP和反向代理服务。由于nginx的高效和反向代理功能，已经超过一大半的网站都使用Nginx进行承载，身为一个IT从业人员，如果没听过，没问题nginx是在愧对自己。当然还有一款国人春哥的升级版OpenResty是将nginx和LuaJIT整合到一起，提供了更加可控的动态Web平台。

### 安装及模块

安装Nginx前需要安装一些编辑工具及库文件

```bash
// 编辑工具及库 
# yum -y install make zlib  zlib-devel gcc-c++ libtool openssl openss-devel

// 安装PCRE
# wget http://downloads.sourceforge.net/project/pcre/pcre/8.35/pcre-8.35.tar.gz
# tar zxvf pcre-8.35.tar.gz
# cd pcre-8.35
# ./configure
# make && make install
# pcre-config --version
```

下载Nginx并进行安装。

```bash
// 进入解压后的目录
#  ./configure \
	--prefix=/usr/local/nginx \
	--with-http_stub_status_module \
	--with-http_ssl_module \
	--with-pcre=/usr/local/src/pcre-8.35
	
# make
# make install
# /usr/local/nginx/sbin/nginx -v
```

如果一切OK，通过上述的命令就可以完成nginx的安装了。Nginx文件非常小，但是其性能非常卓越，其中一个原因是Nginx自带的功能相对较少，但是允许以模块的方式添加自定义功能，因此Nginx越发强大。Nginx模块 是 被编译进入Nginx，并不像Apache那样去编译一个so文件，在配置里面指定是否加载，解析的时候Nginx的哥哥模块都有机会去接收处理某个请求，但是URL请求的模块只能有一个。可以通过-V参数查看当前Nginx已经安装了那些模块。至于常用的模块可以查找模块可以通过如下俩个网站查找：

 * http://www.nginx.cn/doc/index.html
* http://nginx.org/en/docs/ngx_core_module.html
* http://openresty.org/cn/components.html

```bash
sbin/nginx -V
nginx version: openresty/1.11.2.5
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-16) (GCC)
built with OpenSSL 1.0.2k-fips  26 Jan 2017
TLS SNI support enabled
configure arguments: 
--prefix=/usr/local/openresty/nginx 
--with-cc-opt=-O2 
--add-module=../ngx_devel_kit-0.3.0 
--add-module=../echo-nginx-module-0.61 
--add-module=../xss-nginx-module-0.05 
--add-module=../ngx_coolkit-0.2rc3
--with-http_v2_module 
--with-http_realip_module 
--with-http_sub_module
...
```

当需要安装第三方模块可以按照如下命令格式安装，主要不要make install而是直接把编辑出来的objs/nginx文件直接覆盖。

```bash
./configure --prefix=/安装目录 --add-module=/第三方模块目录
// 例如安装pagespeed模块
#  ./configure \
	--prefix=/usr/local/nginx \
	--with-http_stub_status_module \
	--with-http_ssl_module \
	--with-pcre=/usr/local/src/pcre-8.35
	--add-module=../ngx_pagespeed-master -add-module=/模块路径
	
# make
# /usr/local/nginx/sbin/nginx -V

# cp /usr/local/nginx/sbin/nginx /usr/local/nginx/sbin/nginx_bak
# cp objs/nginx /usr/local/nginx/sbin/nginx
// test
# /usr/local/nginx/sbin/nginx -t
# /usr/local/nginx/sbin/nginx -s realod
```

常用的一些模块

* ngx_http_core_module	包括一些核心的 http 参数配置，对应 Nginx 的配置为 HTTP 区块部分
* ngx_http_access_module访问控制模块，用来控制网站用户对 Nginx 的访问
* ngx_http_gzip_module压缩模块，对 Nginx 返回的数据压缩，属于性能优化模块
* ngx_http_fastcgi_moduleFastCGI 模块，和动态应用相关的模块，如 PHP
* ngx_http_proxy_moduleproxy 代理模块
* ngx_http_upstream_module负载均衡模块，可实现网站的负载均衡和节点的健康检查
* ngx_http_rewrite_moduleURL 地址重写模块
* ngx_http_limit_conn_module限制用户并发连接数以及请求数的模块
* ngx_http_limit_req_module根据定义的 key 限制 Nginx 请求过程的速率
* ngx_http_log_module访问日志模块，以指定的格式记录 Nginx 客户访问日志等信息
* ngx_http_auth_basic_moduleWeb 认证模块，设置 Web 用户通过账号密码访问 Nginx
* ngx_http_ssl_modulessl 模块，用于加密的 http 连接，如 https
* ngx_http_stub_status_module记录 Nginx 基本访问状态信息等的模块

### 使用Nginx

安装后就可以使用nginx了，这里介绍使用Nginx常用几个命令

```bash
// 启动Nginx
# /usr/local/nginx/sbin/nginx
// 测试配置文件是否有错误
# /usr/local/nginx/sbin/nginx -t
// 查看nginx的版本
# /usr/local/nginx/sbin/nginx -v  
// 查看Nginx版本和编译安装时的编译参数
# /usr/local/nginx/sbin/nginx -V 
// 强制停止Nginx服务
# /usr/local/nginx/sbin/nginx -s stop 
// 优雅地停止Nginx服务（即处理完所有请求后再停止服务）
# /usr/local/nginx/sbin/nginx -s quit  
// 重新加载Nginx配置文件，然后以优雅的方式重启Nginx
# /usr/local/nginx/sbin/nginx -s reload    
```

### 配置nginx

Nginx的默认配置文件为conf下的nginx.conf，该配置文件主要有四部分组成，全局设置、主机设置、负载均衡器设置和location设置。下面是其整体结构

```bash
//全局设置

//events设置

//http 主机设置
http{
  ...
  server { ... }
  ...
  server { ... }
}
```

##### 全局变量

```bash
// nginx的worker进场允许用户以及用户组
user nobody nobody

// Nginx开启的进程数
worker_processes 1;
worker_processes auto;	//自动
//以指定了那个CPU分配那个进程
//指定右4个worker进程
worker_processes 4;
worker_cpu_addinity 0001 0010 0100 1000

// 定义全局错误日志[debug|info|notice|warn|crit]
error_log logs/error.log info;

// 指定进程ID存储文件位置
pid logs/nginx.pid

//一个nginx进程打开的最多文件描述符数目，理论值应该是最多打开文件数（ulimit -n）
//与nginx进程数相除，但是nginx分配请求并不是那么均匀，所以最好与ulimit -n的值保持一致。
worker_rlimit_nofile 65535;
```

#####事件配置

```bash
events{
  // use [ kqueue | rtsig | epoll | /dev/poll | select | poll ];
  // epoll模型是Linux 2.6以上版本内核中的高性能网络I/O模型，
  // 如果跑在FreeBSD上面，就用kqueue模型。
  use epoll;
  
  // 每个进程可以处理的最大连接数，理论上每台nginx服务器的最大连接数为
  //worker_processes*worker_connections。
  //理论值：worker_rlimit_nofile/worker_processes
  //注意：最大客户数也由系统的可用socket连接数限制（~ 64K），所以设置不切实际的高没什么好处
  worker_connections 10240；
  
  //worker工作方式：串行(一定程度降低负载，但服务器吞吐量大时，关闭使用并行方式)
  multi_accept on;
}
```

#####  http参数

```bash
//http参数配置在http{}语句块中

// 文件扩展名文件类型映射表
include mime.types;

// 默认文件类型
default_type application/octet-stream;

// 日志
log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                     '"$http_user_agent" "$http_x_forwarded_for";
    
// 日志路径
access_log logs/access.log main;
// 只记录严重的错误
error_log logs/error.log crit;
// 关闭日志
access_log off;

// 默认编码
# charset utf-8;
// 名字hash表大小
server_name_hash_bucket_size 128;
// 客户端请求单个文件的最大字节
client_max_body_size 8m;
// 指定来自客户端请求头的headerbuffer大小
client_header_buffer_size 32;
// 指定客户端请求中较大的消息的缓存最大数和大小
large_client_header_buffers 4 64k;

// 开启高效传输模式
sendfile on;
// 防止网络阻塞
tcp_nopush on;
tcp_nodelay on;
//gzip模块设置
//开启gizp压缩输出
gzip on;
//最小压缩文件大小
gzip_min_length 1k;
//压缩缓冲区
gzip_buffers 4 16k;
//压缩版本
gzip_http_version 1.0;
//压缩登记1-9 等级越高，压缩效果越好，节约带宽，但CPU消耗大
gzip_comp_level 2;
//前段缓存服务器缓存经过压缩的页面
gzip_vary on;

// 客户端连接超时时间,单位为秒
keepalive_timeout 60;
// 客户端请求头读取超时时间
client_header_timer 10;
// 设置客户端请求主体读取超时时间
client_body_timeout 10;
//响应活动超时时间10
send_timeout 10;

// fastCGI相关
fastcgi_connect_timeout 300;
fastcgi_send_timeout 300;
fastcgi_read_timeout 300;
fastcgi_buffer_size 64k;
fastcgi_buffers 4 64k;
fastcgi_busy_buffers_size 128k;
fastcgi_temp_file_write_size 128k;
```

##### 虚拟主机设置

利用虚拟主机提供了在同一台服务器、同一组Nginx进场上允许多个网站的功能，一个最简化的虚拟主机配置代码如下

```bash
//方式1基于域名的配置 推荐
 server{
        listen       80;
        server_name  xxx.com www.xxx.com;
        charset utf-8;
		access_log    logs/access_xxxcom.log    main;

        location / {
                root   /var/www/wx;
                index index.html;
        }
    }

    server{
        listen       80;
        server_name  xxx.club www.xxx.club;
        charset utf-8;
		access_log    logs/access_xxxclub.log    main;

        location / {
            root   /var/www/gugdc.club;
            index  index.html index.htm;
            log_not_found off;
        }
    }
 //基于虚拟ip
    server {
        listen      192.168.1.100:80;
        server_name example.org www.example1.com;
        root /data/www;
    }

    server {
        listen      192.168.1.101:80;
        server_name example.net www.example2.com;
        root /data/bbs;
    }

//基于断开的
    server {
        listen      8080;
        server_name example.org www.example1.com;
        root /data/www;
    }

    server {
        listen      9090;
        server_name example.net www.example2.com;
        root /data/bbs;
    }
```

##### 指令

数组指令，在同一上下文中添加多条指令，将添加多个值，而不是完全覆盖，在子级中定义的指令会覆盖父级的值

```bash
error_log logs/error.log;
error_log logs/error_notive.log notice;
error_log logs/error_debug.log debug;

server {
  location /downloads{
    //覆盖父级的上线中的指令
    error_log logs/error_dowanloads.log;
  }
}
```

行动指令，行动指令是改变事情的指令，根据模块的需要，它基础的行为可能会有所不同。

rewrite指令,只要匹配都会执行，而retrun只能回直接返回

server_name 指令，它可以接受多个值，它还处理通配符和正则表达式。

```bash
server_name netguru.co www.netguru.co; # exact match
server_name *.netguru.co;              # wildcard matching
server_name netguru.*;                 # wildcard matching
server_name  ~^[0-9]*\.netguru\.co$;   # regexp matching

// 下面俩个指令是等价的
server_name .netguru.co;
server_name  netguru.co  www.netguru.co  *.netguru.co;
```

listen指令，指定服务监听的ip和端口

```bash
listen 127.0.0.1:80;
listen 127.0.0.1;    # by default port :80 is used

listen *:81;
listen 81;           # by default all ips are used

listen [::]:80;      # IPv6 addresses
listen [::1];        # IPv6 addresses


listen unix:/var/run/nginx.sock;
listen localhost:80;
listen netguru.co:80;
```

* if指令和全局变量

  语法为if(condition){ … },对给定的条件condition进行判断，如果为真，大括号内的rewrite指令将被执行，if条件可以是：

  - 当表达式只是一个变量时，如果值为空或任何以0开头的字符串都会当做false
  - 直接比较变量和内容，使用=或!=
  - ~正则表达式匹配，~* 不区分大小写的匹配  !~ 区分大小写不匹配
  - -f 和 !-f 用来判断文件是否存在
  - -d 和 !-d 用来判断目录是否存在
  - -e 和 !-e 用来判断是否存在文件或目录
  - -x 和 !-x用来判断文件是否可执行

全局变量

- `$args` ： #这个变量等于请求行中的参数，同`$query_string`
- `$content_length` ： 请求头中的Content-length字段。
- `$content_type` ： 请求头中的Content-Type字段。
- `$document_root` ： 当前请求在root指令中指定的值。
- `$host` ： 请求主机头字段，否则为服务器名称。
- `$http_user_agent` ： 客户端agent信息
- `$http_cookie` ： 客户端cookie信息
- `$limit_rate` ： 这个变量可以限制连接速率。
- `$request_method` ： 客户端请求的动作，通常为GET或POST。
- `$remote_addr` ： 客户端的IP地址。
- `$remote_port` ： 客户端的端口。
- `$remote_user` ： 已经经过Auth Basic Module验证的用户名。
- `$request_filename` ： 当前请求的文件路径，由root或alias指令与URI请求生成。
- `$scheme` ： HTTP方法（如http，https）。
- `$server_protocol` ： 请求使用的协议，通常是HTTP/1.0或HTTP/1.1。
- `$server_addr` ： 服务器地址，在完成一次系统调用后可以确定这个值。
- `$server_name` ： 服务器名称。
- `$server_port` ： 请求到达服务器的端口号。
- `$request_uri` ： 包含请求参数的原始URI，不包含主机名，如：”/foo/bar.php?arg=baz”。
- `$uri` ： 不带请求参数的当前URI，$uri不包含主机名，如”/foo/bar.html”。
- `$document_uri` ： 与$uri相同。

```bash
//如果UA中包含MSIE则重定向
if ($http_user_agent ~ MSIE){
  rewrite ^(.*)$ /msis/$1 break;
}
//匹配cookie并设置边$id等于正则引用部分
if ($http_cookie ~* "id([^;]+)(?:;|$)") {
  set $id $1;
}
// 只放心HTTP GET|POST
if ($request_method !~* GET|POST) {
   return 403;
}
// 另外可以通过可以，nginx 有$cookie_x 变量，x是cookie变量名，例如sessionid 就是 
//$cookie_sessionid.cookie变量名不论大小写，在nginx的变量中都是小写，
//例如JSESSIoNID ，在nginx中的写法是$cookie_jsessionid

if ( $cookie_lang ~* ^.*chinese.*$ ){
	proxy_pass chs_web;
}
```





root、location、try_files指令

root指令设置请求的根目录，nginx将请求转入映射到文件系统上。

```bash
server {
  listen 80;
  server_name .xxx.com;
  root /var/www/xxx.com;
}
```

try_files尝试不同的路径，找到一个路径就返回,try_files然后定义匹配的所有请求的location,try_files将不会执行。

```bash
server {
  try_files $uri /index.html =404;

  location / {
  }
}
```

location指令，根据规则匹配，首先对字符串进行匹配查询，最确切的匹配将被使用。然后，正则表达式的匹配查询开始，匹配第一个结果后会停止搜索，如果没有找到正则表达式，将使用字符串的搜索结果，如果字符串和正则都匹配，那么正则优先级较高。它是nginx中最强大也是最经常用到的指令。

```bash
格式：location [=|~|~*|^~|2] /url/ { ... }
= 表示精确匹配，如果找到，立即停止搜索并立即处理此请求
~ 表示区分大小写匹配
~* 表示不区分大小匹配
^~ 表示只匹配字符串，不查询正则表达式
@ 指定一个命命的location，一般只用于内部处理请求。

location = / { //值匹配对/目录的查询}
location / { //匹配以/开始的查询,即匹配所有查询}
location ^~  /images/ {//匹配也/images/开始的查询，不在做正则表达式}
location ~* \.(gif|jpg|jpeg)$ { //匹配以gif,jpg，jpeg结尾的文件}

```

location优先级，在nginx中location配置中location的顺序没有太大的关心。根location表达式的类型有关，相同类型的表达式，字符串常的会优先匹配，具体的优先级顺序说明。

1. 等号类型（=）的优先级最高。一旦匹配成功，则不再查找其他匹配项。
2. ^~类型表达式。一旦匹配成功，则不再查找其他匹配项。
3. 正则表达式类型（~ ~*）的优先级次之。如果有多个location的正则能匹配的话，则使用正则表达式最长的
4. 常规字符串匹配类型。按前缀匹配。

```bash
location = / {
 # 仅仅匹配请求 /
 ...A
}
location / {
 # 匹配所有以 / 开头的请求。
 # 但是如果有更长的同类型的表达式，则选择更长的表达式。
 # 如果有正则表达式可以匹配，则优先匹配正则表达式。
 ...B
}
location /documents/ {
 # 匹配所有以 /documents/ 开头的请求。
 # 但是如果有更长的同类型的表达式，则选择更长的表达式。
 # 如果有正则表达式可以匹配，则优先匹配正则表达式。
 ...C
}
location ^~ /images/ {
 # 匹配所有以 /images/ 开头的表达式，如果匹配成功，则停止匹配查找。
 # 所以，即便有符合的正则表达式location，也不会被使用
 ...D
}
location ~* \.(gif|jpg|jpeg)$ {
 # 匹配所有以 gif jpg jpeg结尾的请求。
 # 但是 以 /images/开头的请求，将使用  D
 ...E
}
```

一般配置安装如下规则匹配即可

```bash
#直接匹配网站根，通过域名访问网站首页比较频繁，使用这个会加速处理，官网如是说。
#这里是直接转发给后端应用服务器了，也可以是一个静态首页
# 第一个必选规则
location = / {
    proxy_pass http://tomcat:8080/tomcat
}
# 第二个必选规则是处理静态文件请求，这是nginx作为http服务器的强项
# 有两种配置模式，目录匹配或后缀匹配,任选其一或搭配使用
location ^~ /static/ {
    root /www/static/;
}
location ~* \.(gif|jpg|jpeg|png|css|js|ico)$ {
    root /www/res;
}
# 第三个规则就是通用规则，用来转发动态请求到后端应用服务器
# 非静态文件请求就默认是动态请求，自己根据实际把握
# 毕竟目前的一些框架的流行，带.php,.jsp后缀的情况很少了
location / {
    proxy_pass http://tomcat:8080/tomcat
}
```

rewrite指令，语法为语法：rewrite regex replacement flag，可以在server、location、if中使用，该指令根据表达式来重定向URI，或者修改字符串。flag标记有

* last相当于Apache里的[L]标记，表示完成rewrite
* break终止匹配, 不再匹配后面的规则
* redirect返回302临时重定向 地址栏会显示跳转后的地址
* permanent返回301永久重定向 地址栏会显示跳转后的地址

实例

```bash
//将ww我冲定下到http://
if ($host ~* www\.(.*)){
  set $host_without_www $1;
  rewrite ^(.*)$ http://$host_without_www$1 permanent;
}
//目录不存在时冲顶向到某个html文件
if ( !-e $request_filename ){
  rewrite ^/(.*)$ 404.html last;
}
//将访问/b/的请求跳转到bbs目录上
rewrite ^/b/?$ /bbs permanent;
```

##### 反向代理与负载均衡

反向代理（Reverse Proxy）方式是指以代理服务器来接受Internet上的连接请求，然后将请求转发给内部网络上的服务器，并将从服务器上得到的结果返回给Internet上请求连接的客户端，此时代理服务器对外就表现为一个服务器。正向代理指的是，一个位于客户端和原始服务器之间的服务器，为了从原始服务器取得内容，客户端向代理发送一个请求并指定目标(原始服务器)，然后代理向原始服务器转交请求并将获得的内容返回给客户端。其实说白了正向代理就是nginx充当客户端的角色，而反向代理nginx充当服务器的角色。

Nginx常常被用于通过反向代理来使用，包括动静分离和负载均衡。都是以这种方式实现的。配置反向代理一般如下

http://www.nginx.cn/doc/standard/httpproxy.html



```bash
//在http节点下配置代理
upstream xxxs{
  server 127.0.0.1:8080;
  server 127.0.0.1:9090;
  server 127.0.0.1:9001 down;  //down表示单前的server暂时不参与负载.
  server 127.0.0.1:9002 backup; // 其它所有的非backup机器down或者忙的时候
  server 127.0.0.1:9003 weight=2; //负载权重
  server 127.0.0.1:9004 max_fails=2 fail_timeout=60s;   //max_fails次失败后，暂停的时间
}
//在server的location下配置
location / {
	proxy_pass_header Server;
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Scheme $scheme;
    proxy_pass http://tomcats;
}
```

Nginx支持如下几种方式的负载均衡策略

```bash
//轮询 根据每个server的权重值来轮流发送请求,默认的权重为1
upstream example {
  server www1.example.com;
  server www2.example.com;
}
upstream example2 {
  server www1.example.com weight=5;
  server www2.example.com;
}

//最少连接数
upstream example3 {
	least_conn;
	server www1.example.com;
	server www2.example.com;
}

//最少延时
//把请求发送给连接延时最小的那台服务器，延时的计算方式有俩种:
//header - 从server接收到第一个byte的时间
//last_byte - 从server接收到全部响应的时间
upstream example4 {
  least_time header;
  server www1.example.com;
  server www2.example.com;
}

//ip hash
//根据用ip计算出一个hash值，并记录下来，以后相同的hash都发送到同一台server上
upstream example5 {
  ip_hash;
  server www1.example.com;
  server www2.example.com;
}

// 通用hash
// 对用户指定的key进行hash计算，可以指定文本、变量、或者组合
upstream example6 {
  hash $request_uri consistent;
  server www1.example.com;
  server www2.example.com;
}
```

##### 日志配置

日志对于统计排错非常有利，Nginx有一个非常灵活的日志记录模式，每个级别的配置可以有各自独立的访问日志，日志格式通过log_format命令来定义，ngx_http_log_module是来定义请求日志格式的。

access_log指令是用来记录访问记录的，

```bash
语法:
	access_log path [format[buffer=size[flush_time]]];
	access_log path format gzip[=level] [buffer=size][flush=time];
	access_log syslog:server=address[,parameter=value][format];
	access_log off;
实例:
	// 默认的配置格式
	access_log /data/logs/nginx-access.log;
	// 设置日志刷盘相关的策略
	// 比如设置buffer，buffer慢32k才刷盘,加入buffer不满5s强制刷盘
	access_log /data/logs/nginx-access.log buffer=32k flush=5s;
	
```

log_format指令用来指定日志格式，如下的实例

```bash
//配置日志格式
//其实此处可以直接配置成JSON格式的然后抽到ELK中即可
log_format accesslog '$remote_addr - $remote_user  [$time_local]  '
                                   ' "$request"  $status  $body_bytes_sent  '
                                   ' "$http_referer"  "$http_user_agent" ';
                                   
// 当nginx处于F5\squid等之后的架构可能需要获取用户的真实ip
log_format  porxy  '$http_x_forwarded_for - $remote_user  [$time_local]  '
                             ' "$request"  $status $body_bytes_sent '
                             ' "$http_referer"  "$http_user_agent" ';
                             
// 日志格式允许包含的变量
$remote_addr, $http_x_forwarded_for（反向） 记录客户端IP地址
$remote_user 记录客户端用户名称
$request 记录请求的URL和HTTP协议
$status 记录请求状态
$body_bytes_sent 发送给客户端的字节数，不包括响应头的大小； 该变量与Apache模块mod_log_config里的“%B”参数兼容。
$bytes_sent 发送给客户端的总字节数。
$connection 连接的序列号。
$connection_requests 当前通过一个连接获得的请求数量。
$msec 日志写入时间。单位为秒，精度是毫秒。
$pipe 如果请求是通过HTTP流水线(pipelined)发送，pipe值为“p”，否则为“.”。
$http_referer 记录从哪个页面链接访问过来的
$http_user_agent 记录客户端浏览器相关信息
$request_length 请求的长度（包括请求行，请求头和请求正文）。
$request_time 请求处理时间，单位为秒，精度毫秒； 从读入客户端的第一个字节开始，直到把最后一个字符发送给客户端后进行日志写入为止。
$time_iso8601 ISO8601标准格式下的本地时间。
$time_local 通用日志格式下的本地时间。
```

*open_log_file_cache* 指令，对于每一条日志，都将是先打开日志文件，再写入日志，然后关闭，可以使用open_log_file_cache来设置日志文件缓存(默认是off)，格式如下:

```bash
语法: open_log_file_cache max=N [inactive=time] [min_uses=N] [valid=time];
open_log_file_cache off;
默认值: open_log_file_cache off;
配置段: http, server, location
max:设置缓存中的最大文件描述符数量，如果缓存被占满，采用LRU算法将描述符关闭。
inactive:设置存活时间，默认是10s
min_uses:设置在inactive时间段内，日志文件最少使用多少次后，该日志文件描述符记入缓存中，默认是1次
valid:设置检查频率，默认60s
off：禁用缓存

实例:
open_log_file_cache max=1000 inactive=20s valid=1m min_uses=2;
```

*log_not_found* 指令，是否在error_log中记录不存在的错误，模式是。

```bash
语法: log_not_found on | off;
默认值: log_not_found on;
配置段: http, server, location
```

*error_log*指令，用于配置错误日志

```bash
语法: error_log file | stderr | syslog:server=address[,parameter=value] [debug | info | notice | warn | error | crit | alert | emerg];
默认值: error_log logs/error.log error;
配置段: main, http, server, location
```

日志分割，nginx的日志模式之后写入一个文件中，所以随着时间的推移会产生一个巨大无比的日志文件，这不是我们想要的，因此需要做些什么，比如按天记录日志文件。在nginx中想要按天记录日志文件有俩中方式，可以根据自己的喜好进行配置

```
//方式一 主动分割
//通过lograted规则或者自定义脚本将日志文件按天进行分割


#!/bin/bash
#此脚本用于自动分割Nginx的日志，包括access.log和error.log
#每天00:00执行此脚本 将前一天的access.log重命名为access-xxxx-xx-xx.log格式，并重新打开日志文件
#Nginx日志文件所在目录
LOG_PATH=/opt/nginx/logs
#获取昨天的日期
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)
#获取pid文件路径
PID=/var/run/nginx/nginx.pid
#分割日志
mv ${LOG_PATH}access.log ${LOG_PATH}access-${YESTERDAY}.log
mv ${LOG_PATH}error.log ${LOG_PATH}error-${YESTERDAY}.log
#向Nginx主进程发送USR1信号，重新打开日志文件
kill -USR1 `cat ${PID}`
//添加到定时任务中
00 00 * * * /bin/bash /opt/nginx/sbin/cut_nginx_log.sh


// 方式二 分离法
// 在配置文件中配置，按照下方式进行分离记录日志
if ($time_iso8601 ~ "^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})"){
    set $year $1;
    set $month $2;
    set $day $3;
    set $hour $4;
    set $minutes $5;
    set $seconds $6;
}
#按天分离日志
access_log logs/xxx-access-$year-$month-$day.log;
#按分钟分离日志
access_log logs/xxx-access-$year-$month-$day-$hour-$minutes.log;
```

##### 安全配置

要想安全首先不能以root启动相关的服务，nginx同样也是，由于服务可能需要80和443端口，因此需要root权限。当然如果能运行1024以后的任何端口上直接也非root的方式启动即可。在非要用80端口下，常见的方案是+s运行，（以普通用户启动nginx，但nginx的master process还是以root运行，worker process以非root用户权限运行，因此有可承受范围内的风险,不说ZDAY的情况下）

```bash
# chown -R webapp:webaapp nginx
# chown root nginx/sbin/nginx
# chmod u+s nginx/sbin/nginx
# su - webapp
# /usr/local/nginx/sbin/nginx -t
```

常见的安全配置

```bash
// 隐藏服务器的版本号在配置文件的http模块 添加配置
server_tokens off;

// 关闭目录遍历 默认就是关闭的
autoindex off; 

// 配置文件中的变量不能使用用户可控部分 
// $uri 和  $document_uri表示的是解码以后的请求路径，不带参数,
// $request_uri表示的是完整的URI（没有解码）
// 下面的配置是不安全的因为$uri是可控部分
location /e { return 302 http://$host$uri;}
location /e { return 302 http://$host$request_uri;}//安全的
// 如果日志文件中有用户可控部分，处理是一定要小心命令注入

// 只允许指定的HTTP方法，现有的一般应只会使用到HTTP的GET、POST方法而不会用到PUT等方法，在确定后配置
if ($request_method !~* GET|POST) {
    return 403;
}

// 配置安全HTTP头
add_header X-Frame-Options "ALLOW-FROM https://mp.weixin.qq.com";
add_header X-Content-Type-Options "nosniff"
add_header X-XSS-Protection "1;mode=block"
add_header Content-Security-Policy "default-src 'self' https://mp.weixin.qq.com"

// 合理配置下面的值防止DDOS和CC
client_body_timeout   10;
client_header_timeout 10;
keepalive_timeout     5 5;
send_timeout          10;
limit_zone slimits $binary_remote_addr 5m;
limit_conn slimits 5;

```

##### 开启HTTPS模式

这个社会文明人太少了，所有裸奔的HTTP不再那么安全可靠，此时就需要开启HTTPS模式了，如果只是想私人之间开启HTTPS模式，而不需要X信机构颁发证书，可以使用OpenSSL这样玩，生成自己的证书。

```bash
// 创建服务器证书密钥文件 xxx.com.key 输入密码，确认密码，自己随便定义，但是要记住
$ openssl genrsa -des3 -out xxx.com.key 1024
// 创建服务器证书的申请文件 xxx.com.csr
$ openssl req -new -key xxx.com.key -out xxx.com .csr
输出内容为：
Enter pass phrase for root.key: ← 输入前面创建的密码 
Country Name (2 letter code) [AU]:CN ← 国家代号，中国输入CN 
State or Province Name (full name) [Some-State]:BeiJing ← 省的全名，拼音 
Locality Name (eg, city) []:BeiJing ← 市的全名，拼音 
Organization Name (eg, company) [Internet Widgits Pty Ltd]:MyCompany Corp. ← 公司英文名 
Organizational Unit Name (eg, section) []: ← 可以不输入 
Common Name (eg, YOUR name) []: ← 此时不输入 
Email Address []:admin@mycompany.com ← 电子邮箱，可随意填
Please enter the following ‘extra’ attributes 
to be sent with your certificate request 
A challenge password []: ← 可以不输入 
An optional company name []: ← 可以不输入
//备份一份服务器密钥文件
$ cp xxx.com.key xxx.com.key.org
//去除文件口令
$ openssl rsa -in xxx.com.key.org -out xxx.com.key
//生成证书文件server.crt
$ openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
```

有了证书就可以在nginx中配置并开启https。配置完以后可以使用在线监测工具进行检测

https://www.trustasia.com/tools-ssl-state

https://myssl.com/

```bash
server{
        listen       80;
        server_name  0opslab.com;
        add_header Strict-Transport-Security max-age=15768000;
        return 301 https://$server_name$request_uri;
    }
    server {
        listen       443 ssl;
        server_name  0opslab.com;
        charset utf-8;

        ssl_certificate     /data/nginx/key/xxx.crt;
        ssl_certificate_key /data/nginx/key/xxx.key;
        ssl_session_timeout 5m;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
        ssl_prefer_server_ciphers on;

        add_header X-Frame-Options "DENY";
        add_header X-Content-Type-Options "nosniff";
        add_header X-XSS-Protection "1;mode=block";
        add_header Strict-Transport-Security "max-age=31536000";
        
        
        //location
    }
```

#####一个完整的服务器配置实例

服务及服务器说明：8核的服务器，承载的站点有俩个

st.0opslab.com 静态资源网站

www.0opslab.com 业务网站

```bash
#user  webapp;
worker_processes  8;
worker_cpu_affinity 10000000 01000000 00100000 00010000 00001000 00000100 00000010 00000001;

worker_rlimit_nofile 10240;
pid   tmp/nginx.pid;

# 事件机制配置
events {
    use epoll;
    worker_connections  15000;
    # worker的工作方式
    multi_accept on;
}

# 配置全局的错误日志
error_log  logs/error.log;

http {
    include      mime.types;
    default_type  application/octet-stream;
	charset  utf-8;
	# 配置全局的日志格式
    log_format  accesslog  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $request_time $body_bytes_sent $upstream_status ' 
                      '$upstream_addr $upstream_response_time "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for" '
                      '"$http_CFBundleShortVersionString"';

	# 开启高效传输模式
    sendfile        off;
    tcp_nopush    on;
    tcp_nodelay    on;

	client_header_buffer_size 32k;
    
    # 一个HTTP产生的TCP连接在传输玩最后一个响应后，还需要多久才能关闭连接
    # 建议配置为用户平均挺住本站的市场
    keepalive_timeout  65;
    
    # 关闭服务器版本号信箱
    server_tokens off;

    open_file_cache    max=65535      inactive=20s;
    open_file_cache_valid      30s;
    open_file_cache_min_uses    1;

	# 开启gzip传输
  	gzip  on;
    gzip_min_length  1000;
    gzip_buffers    4 16k;
    gzip_comp_level 2;
    gzip_types  text/plain application/x-javascript text/css text/javascript  image/jpeg image/gif image/png;
    gzip_vary  on;
    gzip_disable        "MSIE [1-6]\.";    

	# HTTP_PROXY设置
    client_max_body_size    20m;
    # 用于指定客户端请求主体缓冲区大小，可以理解为先保存到本地再传给用户
    client_body_buffer_size 500k;
    # 禁止使用临时文件
    proxy_max_temp_file_size 0;
    # 与后端服务器连接超时时间
    proxy_connect_timeout  60;
    # 表示后端服务器的数据回传时间，即在规定的时间内后端服务器必须传完所有的数据，否则断开连接
    proxy_send_timeout      60;
    # nginx从后端服务获取信息的时间，连接后nginx等待后端服务响应时间，
    proxy_read_timeout      60;
    # 设置缓冲区大小，默认，该缓冲区大小等于指令proxy_buffers舍子的大小
    proxy_buffer_size      128k;
    # 设置缓冲区的数量和大小
    proxy_buffers          8 128k;
    # 用户系统很忙是使用的proxy_buffers大小，官方推荐的大小为proxy_buffers * 2
    proxy_busy_buffers_size 256k;
    # 指定proxy缓存临时文件的大小
    proxy_temp_file_write_size 1024k;
 
	# 开启4xx和5xx错误消息传递
    fastcgi_intercept_errors on;
    underscores_in_headers on;    

	# 配置重原生工程的负载均衡
    upstream Client {
        server 135.191.168.68:9182;
        server 135.191.168.69:9182;
        
        check interval=3000 rise=2 fall=5 timeout=1000  type=http;
        check_http_send "GET  /Client  HTTP/1.0\r\n\r\n";
        check_http_expect_alive http_2xx http_3xx;
    }

	# 配置H5后端的负载均衡
    upstream ClientH5 {
        server 135.191.168.68:9183;
        server 135.191.168.69:9183;

        check interval=3000 rise=2 fall=5 timeout=1000  type=http;
        check_http_send "GET  /ClientH5  HTTP/1.0\r\n\r\n";
        check_http_expect_alive http_2xx http_3xx;
    }

	// 设置变量
	if ($time_iso8601 ~ "^(\d{4})-(\d{2})-(\d{2})") {
        set $year $1;
        set $month $2;
        set $day $3;
    }
    

    # 配置静态资源网站的信息
    server {
        listen      80;
        server_name  st.aaabbb.com 127.0.0.1；
		
		# 添加安全的HTTP头-精致资源类型探测
        add_header X-Content-Type-Options "nosniff"；
        add_header X-Frame-Options "DENY";
        add_header X-XSS-Protection "1;mode=block"
        add_header Content-Security-Policy "default-src 'self' https://mp.weixin.qq.com";
 
		# 添加分割日志
		access_log  /webapp01/nginxlog/st_access-$year$month$day.log accesslog;
		
		# 设置网站根目录
		root /webapp01/www/static/;
		
		
		# 禁止GET以为的所有的HTTP方法
		if ($request_method !~* GET) {
            return 403;
        }
        
        # 开启本地缓存/关闭本地缓存 off; 如果root目录在本地磁盘可以考虑关闭
		# proxy_store on;
		# proxy_store_access user:rw group:rw all:rw;
		# proxy_temp_path /data/nginx/sttmp/;

		# 限流，防止被单一资源占满带宽
        location / {
          limit_rate_after 100k;
          limit_rate 100k;
        }
        
        # 关闭无意义的资源访问日志，并设置缓存有效期
		location ~ .*\.(html|htm|css|js|ico|gif|jpg|jpeg|png|bmp|swf|woff)$ {
			etag off;
            if ($request_filename ~* .*.(html|htm|js)$){
                expires -1s;
            }
            if ($request_filename ~* .*.(css|gif|jpg|png|jpeg|bmp|zip|mp3|mp4|hs|ipa)$){
				# 关闭未找到日志记录
             	log_not_found off;
                access_log off;
                expires 100d;
            }
        }
        
        # 常见的服务端脚本不被允许
        location ~* \.(php|php5|jsp|asp|aspx|py|java|jar|class|groovy|scala|sh)$ {
            deny all;
        }

		location ~ .*\.(bak|rar|zip)$ {
			 # 禁止bak，rar ，zip文件输出
			 return 403;
        }
        
		# 配置监控
		# curl -I http://127.0.0.1/ngx_status
        location /ngx_status {
            stub_status on;
            access_log off;
            allow 127.0.0.1;
            deny all;
        }
    

    }

	# 配置www.0opslab.com
    server {
     
        listen        80;
        server_name  www.0opslab.com 127.0.0.1;
        
		// 配置安全HTTP头
        add_header X-Frame-Options "DENY";
        add_header X-Content-Type-Options "nosniff"
        add_header X-XSS-Protection "1;mode=block"
        add_header Content-Security-Policy "default-src 'self' https://mp.weixin.qq.com";
 
        
		access_log  /webapp01/nginxlog/h5_access-$year$month$day.log  accesslog;
        if ($request_method !~* GET|POST) {
            return 403;
        }
        
  		
		proxy_store off;

		# 设置根目录(将项目的静态资源文件抽离出来部署在与Nginx同在的服务器上)
        root /webapp01/www/;
        
        # 跟目录设置,并且设置显示
        location / {
			limit_rate_after 100k;
          	limit_rate 100k;
        }
        
		# 关闭静态资源的访问日志，并且设置缓存,注意此处不包括html文件
        location ~* \.(js|css|gif|jpg|png|jpeg)$ {
			log_not_found off;
            access_log off;
            expires 30d;
        }
        
		# 常见的服务端脚本不被允许(网站全部JSON处理，因此不需要如下类型的请求)
        location ~* \.(php|php5|jsp|asp|aspx|py|java|jar|class|scala|sh|properies|xml)$ {
            deny all;
        }
        
        
        # 将后台请求转发到后台服务器上
		location ~ ^/qhmccClientH5/.*\.(action|do|json)$ {
            # 用于指向反向代理的服务器池
            proxy_pass      		http://Client/mccClientWap;
            # 是否修改应答头location和refresh
            proxy_redirect          off;
            # 设置ip以便于后台服务能获取请求的真实IP，以及代理者的IP
            proxy_set_header        Host $host:$server_port;
            proxy_set_header        X-Real-IP $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
            # 传递useragent
            proxy_set_header		http_user_agent $http_user_agent;
            # 是否请求转发到下一台服务器
            proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;

        }

        location /ClientH5 {
            proxy_pass      		http://ClientH5/mccClientH5;
            proxy_redirect          off;
            proxy_set_header        Host $host:$server_port;
            proxy_set_header        X-Real-IP $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_next_upstream 	error timeout invalid_header http_500 http_502 http_503 http_504;
      	}

		error_page  500 502 503 504 /50x.html;
    	location = /50x.html {
			root /webapp01/www/;
   		}
		location /ngx_status {
            stub_status on;
            access_log off;
            allow 127.0.0.1;
            deny all;
        }

    }




    # HTTPS server
    #
    #server {
    #    listen      443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root  html;
    #        index  index.html index.htm;
    #    }
    #}

}
```

#### 添加模块

有些时间最初的安装总是不尽人意，比如我进场安装的是将忘记安装--with-http_stub_status_module模块。而网站又不能停，这是可以使用如下方式重新编译并安装。

```bash
# 重新configure 将自己需要的模块添加进去
./configure --prefix=/usr/local/openresty --with-luajit --with-http_v2_module --with-http_realip_module --with-http_sub_module --with-http_gunzip_module  --with-http_gzip_static_module  --with-pcre --with-http_stub_status_module

# make或者gmake

# 备份原有的nginx
$ cp sbin/nginx sbin/nginx.old

# 将新编译的nginx复制过来nginx在objs下 openresty在build/nginx-1.11.2/objs/nginx下
$ cp -f  objs/nginx sbin/nginx

# 检测并平滑加载
$ sbin/nginx -V
$ sbin/nginx -t 
$ sbin/nginx -s reload

```



#### 监控

兵未动粮草先行，在正式运行之前充分的掌握各种指标相当重要，在nginx中掌握基本的信息可以添加http_stub_status模块

```bash
# 安装该模块
$ .configure --with-http_stub_status_module

# 在conf中配置
location /nginx_status {
    stub_status on;
    access_log off;
    allow 127.0.0.1; //本机测试需添加此条记录
    deny 192.168.1.1;
    allow 192.168.1.0/24; //允许192.168.1.0/24访问，拒绝192.168.1.1访问
    allow 10.1.1.0/16;
    allow 2620:100:e000::8001; //此处是ipv6的地址
    deny all; //除了上述地址，拒绝所有连接。写allow，deny时，注意顺序
}

# 加载配置
/usr/local/nginx/sbin/nginx -t  //测试配置是否正确
/usr/local/nginx/sbin/nginx -s reload
```

然后访问xxx/nginx_status即可看到该如下信息

```bash
Active connections: 3 
server accepts handled requests
 10 10 6 
Reading: 0 Writing: 1 Waiting: 0 


```

可能由于nginx的版本不同其处理连接和请求的工作方式上稍微有些差异，具体的模式请查阅官方文档，但总的来说其离不开如下几个状态:

active connections — 对后端发起的活动连接数
server accepts handled requests — nginx 总共处理了 16630948 个连接, 成功创建 16630948 次握手 (证明中间没有失败的), 总共处理了 31070465 个请求 (平均每次握手处理了 1.8个数据请求)
reading — nginx 读取到客户端的Header信息数
writing — nginx 返回给客户端的Header信息数
waiting — 开启 keep-alive 的情况下，这个值等于 active – (reading + writing)，意思就是Nginx说已经处理完正在等候下一次请求指令的驻留连接。

除了http_stub_status_module模块外，当然常见的Nagios、Zabbix等都是可以很好的监控Nginx服务，但是有时候全家桶用起来不是那边便捷，当然如果有现成的套件直接撸上去即可。另外还有一些爱好者开发的开源工具也是相当棒的。

##### ngxtop

ngxtop一个看上去就很眼熟的命令。**ngxtop** parses your nginx access log and outputs useful, `top`-like, metrics of your nginx server. So you can tell what is happening with your server in real-time.其地址为:

https://github.com/lebinh/ngxtop

```
pip install ngxtop

# 默认情况下会读取/etc/nginx/nginx.conf文件
$ ngxtop

# 具体的使用方法请看官方文档

# 一些常见的用户法

# 查看实时状态
$ ngxto -c /usr/local/openresty/nginx/conf/nginx.conf

# 访问前几的IP
$ ngxtop -c /opt/nginx/conf/nginx.conf top remote_addr

# 显示状态码为404的请求
$ ngxtop -i 'status == 404' print request status

# 显示前二十请求次数最高的请求
$ ngxtop -n 20

```

##### GoAccess

简单来说呢 [GoAccess](https://github.com/allinurl/goaccess) 是一个专门用来分析日志的工具，既可以在终端中展示结果，也可以生成 HTML 报表在浏览器中查看。GoAccess 最吸引人的一点就是它生成的 HTML 足够炫酷。

```bash
# yum install goaccess
# apt-get install goaccess


$ git clone https://github.com/allinurl/goaccess.git
$ cd goaccess
$ autoreconf -fiv
$ ./configure --enable-utf8 --enable-geoip=legacy
$ make
# make install

$ goaccess -f access.log
// 选择Combined Log Format (XLF/ELF) 进入统计界面
// 该界面有用是如下快捷键
F1或h：帮助
F5 ：刷新主界面
q：退出程序/当前窗口/折叠当前模块
o或Enter：展开选中的模块或窗口
0-9以及Shift + 0：将选中的模块或窗口激活
k和j：模块内部移动
c：修改配色
^f和^b：模块中上下滚屏
tab shift+tab：前后切换模块
s：模块内部排序选择
/：在所有模块中搜索(支持正则)
n：找到下个匹配
g和G：跳到第一项/最后一项


```

另外如果对Nginx的日志进行定制的化，在使用goaccess前需要配置日志文件的解析格式。GoAccess的日志规范可以可以查阅https://goaccess.io/man#custom-log。当然可以使用如下开源工具进行转换https://github.com/stockrt/nginx2goaccess



#### 调优

Nginx的主要可以从如下几个方面入手：

* 升级服务器配置，比如上SSD硬盘，升级带宽
* 根据业务优化服务器的内核参数
* 根据业务优化Nginx的配置
* 优化后台服务

*升级服务器配置*

SSD硬盘是一个快速存储装置，没有即系运动部件，因此其访问速度相对机械硬盘是无延迟的，另外其几乎无热量产生，更加省电，因此直接上SSD硬盘是相当划算的选择。这比做很多优化配置来的更加直接。

*优化服务器内核参数*

以下操作除非你知道你在做什么，否则请勿乱修改。

```bash
// 查看各个状态的网络连接请求数
$ netstat -n | awk '/^tcp/ {++state[$NF]} END {for(key in state) print key,"\t",state[key]}'

// 调整同时打开文件的数量
ulimit -n 20480

// linux的/etc/sysctl.conf 更改内核参数,并使用sysctl -p命令使配置立即生效
// 表示单个进场最大可以打开的句柄书
fs.file-max = 999999
// 允许将TIME_WAIT状态的socket重新用于新的TCP连接
net.ipv4.tcp_tw_reuse = 1
// 当keepalive启动时,TCP发送keepalive消息的频度，单位为秒,设置的更新能加快清理无效的连接
net.ipv4.tcp_keepalive_time = 600
// 当服务器主动关闭链接时，socket保持在FIN_WAIT_2状态的最大时间
net.ipv4.tcp_fin_timeout = 30 

// 这个参数表示操作系统允许TIME_WAIT套接字数量的最大值，如果超过这个数字，
//TIME_WAIT套接字将立刻被清除并打印警告信息。该值不能过大
net.ipv4.tcp_max_tw_buckets = 5000

// 定义UDP和TCP连接的本地端口的取值范围
net.ipv4.ip_local_port_range = 1024 65000 

//定义了TCP接受缓存的最小值、默认值、最大值
net.ipv4.tcp_rmem = 10240 87380 12582912

//定义TCP发送缓存的最小值、默认值、最大值。
net.ipv4.tcp_wmem = 10240 87380 12582912

//当网卡接收数据包的速度大于内核处理速度时，会有一个列队保存这些数据包。这个参数表示该列队的最大值
net.core.netdev_max_backlog = 8096 

// 表示内核套接字接受缓存区默认大小
net.core.rmem_default = 6291456

//表示内核套接字发送缓存区默认大小
net.core.wmem_default = 6291456  

//表示内核套接字接受缓存区最大大小。
net.core.rmem_max = 12582912

//表示内核套接字发送缓存区最大大小
net.core.wmem_max = 12582912

//与性能无关。用于解决TCP的SYN攻击。
net.ipv4.tcp_syncookies = 1

//这个参数表示TCP三次握手建立阶段接受SYN请求列队的最大长度，默认1024，
//将其设置的大一些可以使出现Nginx繁忙来不及accept新连接的情况时，Linux不至于丢失客户端发起的链接请求。
net.ipv4.tcp_max_syn_backlog = 262144

//这个参数用于设置启用timewait快速回收
net.ipv4.tcp_tw_recycle = 1

// 选项默认值是128，这个参数用于调节系统同时发起的TCP连接数，在高并发的请求中，
// 默认的值可能会导致链接超时或者重传，因此需要结合高并发请求数来调节此值。
net.core.somaxconn=262114 


//选项用于设定系统中最多有多少个TCP套接字不被关联到任何一个用户文件句柄上。
//如果超过这个数字，孤立链接将立即被复位并输出警告信息。
net.ipv4.tcp_max_orphans=262114 


//关于具体的内核参数请查阅相关的系统 可以使用sysctl -a显示当前全部的参数

```

nginx的性能是没的说，但是如果真的除了问题，那肯定是你配置的问题，例如keepalive_timeout 设置的不合理，日志记录过多或者未使用缓存等等，另外就是是后台的问题。建议开启request_time和upstream_response_time，将这俩个值写入到access日志中。

request_time 指的就是从接受用户请求的第一个字节到发送完响应数据的时间，即包括接收请求数据时间、程序响应时间、输出响应数据时间。

upstream_response_time 是指从Nginx向后端建立连接开始到接受完数据然后关闭连接为止的时间。

将上述俩个值记录到access日志文本中，然后通过统计分析将需要优化的后台接口交给开发人员进行优化，如果像我这种啥活都干的人，只能自己默默的干了。

如下设置Nginx的日志格式,等运行一段时间后分析request_time和upstream_response_time字段，然后优化后台。

```bash
 log_format  accesslog  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $request_time $body_bytes_sent $upstream_status ' 
                      '$upstream_addr $upstream_response_time "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for" '
                      '"$http_CFBundleShortVersionString"';
```

后台系统优化，只能具体的问题具体分析了，如是Java可以用bstrace分析监控JVM等等，如果是PHP可以使用xhprof等工具分析。

至此身为一个Web开发人员，算是入门了Nginx，能使之更加方便和高效的工作了。































