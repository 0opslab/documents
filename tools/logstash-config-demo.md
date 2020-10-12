title: logstash配置
date: 2017-04-16 16:25:47
tags: logstash
categories: elk
---

## input配置
### File
logstash使用一个叫做FileWatch的Ruby Gem库来监听文件变化。这个库支持glob展开文件路径，而且会使用一个叫做.sincedb的数据库文件夹来跟踪呗监听文件的变化包括被监听文件的inode,major,number,minor,number和pos
需要注意的是FileWath只支持文件的绝对路径，而且不会自动递归目录，所有需要的话，可以使用数组的方式写明具体的文件。另外FileWath不支持path => "/path/%{yyyy-mm-dd}.log"这种模糊匹配的方式。如果需要的话可以这样写 path => "/path/*.log"或者使用/**/表示递归全部子目录。下面是一个简单的配置实例
```java
input{
    file {
        path => ["/var/log/*.log","/var/log/message"]
        type => "system"
        # logstash 默认会从文件末尾开始读取，假如有原始数据可以使用beginning指定从开始位置读取
        start_position => "beginning"
        # stat_interval 设定每隔多久检查一次被监听文件的状态,默认是1秒
        # sincedb_write_interval 每隔多久写一次sincedb文件 默认是15秒
        # sincedb_path 指定sincedb文件的路径
        # ignore_older 在每次检查文件列表的时候，如果一个文件的最后修改时间超过这个值就忽略这个文件，默认是一天
        # close_older 一个被监听的文件，如果超过这个值还没有更新内容就关闭监听它的文件句柄，默认是一小时
        # exclude 不想被监听的文件可以排除
        # discover_interval 每隔多久去检查一被监听文件的path是否有信的文件。默认是15秒
    }
}
filter{
}
output{
    stdout { 
        codec => rubydebug 
    } 
}
```
### sdtin
tdin应该是logstash里最简单和基础的差距了。下面是一个配置实例
```java
input {
	stdin{
		add_field => {"key" => "value"}
		codec => "plain"
		tags => ["add"]
		type => "std"
	}
}

filter{
	

}

output{
	stdout{
		codec => rubydebug 
	}
}
```
当以上述的配置启动logstash后，在stdin中输入helloworld 会输出如下信息
```java
{
    "@timestamp" => 2017-04-16T04:39:23.321Z,
      "@version" => "1",
          "host" => "admin1602130927",
       "message" => "hello world\r",
          "type" => "std",
           "key" => "value",
          "tags" => [
        [0] "add"
    ]
}
```
注意其中的type和tag是logstash事件中俩个特殊的字段，通常来说会在输入区中通过type来标记事件类型，而tags则是在数据处理过程中，由具体的插件来添加或者删除。
### syslog
syslog可能是运维领域最流行的数据传输协议了。当想从手背上手机系统日志的时候，syslog应该是第一选择，尤其是网络设备，比如思考-syslog几乎是唯一可行的办法。
可以通过syslog.conf，rsyslog.con或者syslog-ng.conf来发送数据到logstash上。
```java
input{
	syslog{
		port => "514"
	}
}
filter{
	
}
output{
	stdout{
		codec => rubydebug 
	}
}
```
### tcp
生成上可能会用redis服务器或者其他的消息队列系统来头做完logstash broker的角色。不过logstash其实也有自己的tcp/udp的插件。在监听任务的时候，也算能用。
```java
input {
	tcp {
		port => 10000
		mode => "server"
		ssl_enable => false
	}
}
filter{
	
}
output{
	stdout{
		codec => rubydebug 
	}
}
```
###Codec
logstash不只是一个input > filter > output的数据流，而是一个input->decode > filter -> encode -> output的完整数据流，Codec是decode和encode时间的简称。
codec的引入使用logstash可以更好的与其他的自动定义格式的运维产品共享，比如graphite、fluent、netflowcollectd以及使用msgpack、json、end等通用数据的产品。
#### json编码
在早起的logstash中可以通过预定好的json数据来省略掉filter/grok配置，从而降低cpu使用率。
例如直接在nginx中配置accesslog的日志格式为
```java
logformat json '{"@timestamp":"$time_iso8601",'
               '"@version":"1",'
               '"host":"$server_addr",'
               '"client":"$remote_addr",'
               '"size":$body_bytes_sent,'
               '"responsetime":$request_time,'
               '"domain":"$host",'
               '"url":"$uri",'
               '"status":"$status"}';
access_log /var/log/nginx/access.log_json json;
```
然后就可以通用File直接输入到logstash中
```java
input{
	file{
		path => "/var/nginx/access_*.log"
		codec => "json"
	}
}
filter{
	
}
output{
	sdtout{
		codec => rubydebug 
	}
}
```
#### Multiline
有些时候，应用程序会以多行的内容来打印一个事件，这种日志通常很难通过命令行解析的方式来做分析。而logstash为此开发了codec/multiline插件来解决这类问题.
如下配置很简单就是把当前行的数据添加到前一行的后面，知道新进行以[开头为止。

```
input{
	stdin{
		# 匹配以[开头的行，如果不是，哪肯定属于前一行
		codec => multiline{
			# 必须配置 要匹配的正则表达式
			pattern => "^\["
			# 否定正则表达式
			negate => true
			# 可以设置为previous或next
			# 表示如果正则表达式匹配了，那么该事件属于下一个还是前一个事件
			what => "previous"
		}
	}
}
filter{
	
}
output{
	stdout{
		codec => rubydebug 
	}
}
```
之后在stdin中输入
```java
[2017-4-16 14:34:34] exception
        db error: no session
[2017-4-16 14:34:57] login userid;
{
    "@timestamp" => 2017-04-16T06:35:21.613Z,
      "@version" => "1",
          "host" => "admin1602130927",
       "message" => "[2017-4-16 14:34:34] exception\r\n\tdb error: no session\r",
          "tags" => [
        [0] "multiline"
    ]
}
```
#### collectd
collectd是一个收获进程，用来收集系统性能和提供各种存储方式来存储不同值的机制。它会在系统运行和存储信息时周期性的统计系统相关的信息。这些信息有利于查找当前系统性能瓶颈。
######collectd的配置
以下配置可以实现对服务器基本的CPU、内存、网卡流量、磁盘 IO 以及磁盘空间占用情况的监控:
```java
Hostname "host.example.com"
LoadPlugin interface
LoadPlugin cpu
LoadPlugin memory
LoadPlugin network
LoadPlugin df
LoadPlugin disk
<Plugin interface>
    Interface "eth0"
    IgnoreSelected false
</Plugin>
<Plugin network>
    # logstash 的 IP 地址和 collectd 的数据接收端口号>
    # 如果logstash和collectd在同一台主机上也可以用环回地址127.0.0.1
    <Server "10.0.0.1" "25826">
    </Server>
</Plugin>
```
然后在logstash中配置接受程序即可。
```java
input{
	udp {
		port => 25826
		buffer_size => 4096
		workers => 3
		queue_size => 30000
		codec => collectd{}
		type => "collectd"
	}
}
filter{
	

}

output{
	stdout{
		codec => rubydebug 
	}
}
```
## filter
丰富的filter是logstash威力强大的重要因素。下面是一些常用filter
#### date
该插件可以将日志记录中的时间字符串，编程Logstash::timestamp对象，然后存储到@timestamp字段里
#### grok
grok可以说是logstash最重要的一个插件。使用grok可以按照如下语法配置
```java
filter{
	grok {
		match => {
			"message" => "grok_parttern"
		}
	}
}
```
其中处理grok_pattern外其他的欧式logstash的关键字。grok_pattern部分是使用者根据自己的需求实现填写的。它有零个或多个 %{SYNTAX:SEMANTIC}组成，其中SYNTAX是表达式的名字，是由grok提供的，例如数字表达式的名字是NUMBER，IP地址表达式的名字是IP。SEMANTIC表示解析出来的这个字符的名字，由自己定义，例如IP字段的名字可以是client。
对于下面这条日志：
```log
55.3.244.1 GET /index.html 15824 0.043
```
可以这样解析：
```java
input{
	stdin{

	}
}
filter{
	grok {
		match => {
			"message" => "%{IP:client} %{WORD:method} %{URIPATHPARAM:request} %{NUMBER:bytes} %{NUMBER:duration}"
		}
	}
}
output{
	stdout { 
        codec => rubydebug 
    } 
}
```
将会得到这样的结果
```java
{
      "duration" => "0.043",
       "request" => "/index.html",
    "@timestamp" => 2017-04-16T07:29:37.416Z,
        "method" => "GET",
         "bytes" => "15824",
      "@version" => "1",
          "host" => "admin1602130927",
        "client" => "55.3.244.1",
       "message" => "55.3.244.1 GET /index.html 15824 0.043\r"
}
```
grok提供了哪些SYNTAX？可以查看文件grok-patterns，它默认放在路径/usr/local/logstash/vendor/bundle/jruby/1.9/gems/logstash-patterns-core-0.3.0/patterns下。假设现在要匹配一个正则表达式为regexp的字符串，而grok预定义的SYNTAX都不满足，也可以自己定义一个SYNTAX

自定义SYNTAX 方式有两种：

* 匿名SYNTAX
  将%{SYNTAX:SEMANTIC} 写为(?<SEMANTIC>regexp)

* 命名SYNTAX
  在dir下创建一个文件，文件名随意将dir加入grok路径： patterns_dir => "./dir"
  将想要增加的SYNTAX写入： SYNTAX_NAME regexp
  使用方法和使用默认SYNTAX相同：%{SYNTAX_NAME:SEMANTIC}

#### dissect
grok虽然灵活，但其性能却是差强人意，因此logstash中5.0的版本中加入了dissect插件，当日志有比较简明的分隔标志，而且重复性比较的打的时候可以使用dissect快更的完成解析工作。和 Grok 很类似的 %{} 语法来表示字段，这显然是基于习惯延续的考虑。不过示例中 %{+ts} 的加号就不一般了。dissect 除了字段外面的字符串定位功能以外，还通过几个特殊符号来处理字段提取的规则：
* %{+key} 这个 + 表示，前面已经捕获到一个 key 字段了，而这次捕获的内容，自动添补到之前 key 字段内容的后面。
* %{+key/2} 这个 /2 表示，在有多次捕获内容都填到 key 字段里的时候，拼接字符串的顺序谁前谁后。/2 表示排第 2 位。
* %{?string} 这个 ? 表示，这块只是一个占位，并不会实际生成捕获字段存到 Event 里面。
* %{?string} %{&string} 当同样捕获名称都是 string，但是一个 ? 一个 & 的时候，表示这是一个键值对
实例
```java
input {
	stdin{
		type => "dissect"
	}
}

filter{
	dissect{
		mapping => {
			"message" => "http://%{domain}/%{?url}?%{?arg1}=%{&arg1}"
		}
	}

}

output{
	stdout{
		codec => rubydebug 
	}
}
```
测试
```java
http://rizhiyi.com/index.do?id=123
{
    "@timestamp" => 2017-04-16T08:00:41.812Z,
        "domain" => "rizhiyi.com",
      "@version" => "1",
          "host" => "admin1602130927",
            "id" => "123\r",
       "message" => "http://rizhiyi.com/index.do?id=123\r",
          "type" => "dissect"
}
```
## output
Output就是文件的输出，可以设置输出到多个目标源，在这里指定它输出到Redis server，同时设置输出的类型为list，key就是每一条日志的名称，它默认是以map形式输出的，host为redis的主机地址
#### elasticsearch
logstash支持直接将日志存储到到elasticsearch中。下面是一个简单的配置。
```java
output {
    elasticsearch {
        hosts => ["192.168.0.2:9200"]
        index => "logstash-%{type}-%{+YYYY.MM.dd}"
        document_type => "%{type}"
        flush_size => 20000
        idle_flush_time => 10
        sniffing => true
        template_overwrite => true
    }
}
```
#### file
通过日志收集系统将分散在数百台服务器上的数据集中存储在某中心服务器上，这是运维最原始的需求
```java
output {
    file {
        path => "/path/to/%{+yyyy}/%{+MM}/%{+dd}/%{host}.log.gz"
        message_format => "%{message}"
        gzip => true
    }
}
```
## 扩展
一下配置使得logstash监听服务器的指定端口，凡是写写入到该端口的数据都会被保存进入redis中。
```java
input{
	log4j{
		mode => "server"
		host => "127.0.0.1"
		port => "4567"
	}
}

filter {

 
}
output {
  redis {
    host => "127.0.0.1"
    port => 6379
    data_type => "list" 
    key => "log4j" 
  } 
}
```
而以下配置则会从redis中读取伤处程序写入的数据，并将之存储到es中去。
```java
input{
	log4j{
		mode => "server"
		host => "127.0.0.1"
		port => "4567"
	}
}
filter {
  #Only matched data are send to output.
}
output {
  # For detail config for elasticsearch as output, 
  # See: https://www.elastic.co/guide/en/logstash/current/plugins-outputs-elasticsearch.html
  elasticsearch {
    action => "index"            #The operation on ES
    hosts  => "localhost:9200"     #ElasticSearch host, can be array.
    index  => "log4j"               #The index to write data to, can be any string.

  }
}
```
