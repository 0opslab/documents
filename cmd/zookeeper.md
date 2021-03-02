# title{zookeeper - zookeeper相关的那些操作}


## 检测服务

ZooKeeper 支持某些特定的四字命令字母与其的交互。它们大多是查询命令，用来获取 ZooKeeper 服务的当前状态及相关信息。用户在可以通过 telnet 或 nc 向 ZooKeeper 提交相应的命令

| conf | 输出相关服务配置的详细信息。                                 |
| ---- | ------------------------------------------------------------ |
| cons | 列出所有连接到服务器的客户端的完全的连接 / 会话的详细信息。包括“接受 / 发送”的包数量、会话 id 、操作延迟、最后的操作执行等等信息。 |
| dump | 列出未经处理的会话和临时节点。                               |
| envi | 输出关于服务环境的详细信息（区别于 conf 命令）。             |
| reqs | 列出未经处理的请求                                           |
| ruok | 测试服务是否处于正确状态。如果确实如此，那么服务返回“imok ”，否则不做任何相应。 |
| stat | 输出关于性能和连接的的列表。                                 |
| wchs | 列出服务器 watch 的详细信息。                                |
| wchc | 通过 session 列出服务器 watch 的详细信息，它的输出是一个与watch 相关的会话的列表。 |
| wchp | 通过路径列出 watch 的详细。它输出一个与 session相关的路径。  |

```bash
# 上述命令可以通过如下方式执行并得到想要的结果
echo ruok | nc 127.0.0.1 2181
```

## 常用的shell脚本

* 启动zk : bin/zkServer.sh start
* 查看ZK服务状态: bin/zkServer.sh status
* 停止ZK服务: bin/zkServer.sh stop
* 重启ZK服务: bin/zkServer.sh restart
* 连接服务器 : bin/zkCli.sh -server 127.0.0.1:2181

## 客户端常用命令

客户可以通过zkCli命令连接到指定的服务器上，然后就进行相应的操作。

```bash
[zk: localhost:2181(CONNECTED) 2] help
ZooKeeper -server host:port cmd args
        stat path [watch]		#查看节点状态属性，不包含节点数据信息
        
        # 修改znode节点内容，修改数据也可携带版本号，修改的时候要么不携带版本号，
        # 要么携带的版本号要跟dataVersion的版本号一致，否则就会报错
        set path data [version]
        
        # 使用 ls 命令来查看某个目录包含的所有文件
        ls path [watch]
        ls2 path [watch]
        
        # 删除配额
        delquota [-n|-b] path
        
        # 配置acl
        setAcl path acl
        addauth scheme auth
        getAcl path
        
        # 配额，给节点限制值，比如限制子节点个数、节点数据的长度
        # -n：限制子节点个数
        # -b：限制值的长度
        setquota -n|-b val path
        
        # 查看历史执行指令
        history
        # 再次执行某命令。如redo 10 其中10为命令ID，需与history配合使用
        redo cmdno
        
        # 在获取节点数据、子节点列表等操作时，都可以添加watch参数监听节点的变化，
        # 从而节点数据更改、子节点列表变更时收到通知，并输出到控制台。默认是打开，可以设置参数将其关闭
        printwatches on|off
        
        # 删除没有子节点的节点,如果有子节点将报Node not empty
        delete path [version]
        # 由于请求在半数以上的zk server上生效就表示此请求生效，
        # 那么就会有一些zk server上的数据是旧的。sync命令就是强制同步所有的更新操作。
        sync path
        
        # listquota，查看配额，以及节点的配额状态
        listquota path
        
        # 已过时的方法,推荐使用deleteall
        rmr path
        
        # 获取znode节点数据
        get path [watch]
        
        # 创建znode，并设置初始内容, 默认内容也可以是空串，附加参数 ：-s：顺序节点 ，-e：临时节点
        create [-s] [-e] path data acl  
        

        # 退出
        quit
        
        
        # 删除配额
        close
        connect host:port
```

##节点信息

* cZxid ：创建节点的id
* ctime ： 节点的创建时间
* mZxid ：修改节点的id
* mtime ：修改节点的时间
* pZxid ：子节点的id
* cversion : 子节点的版本
* dataVersion ： 当前节点数据的版本
* aclVersion ：权限的版本
* ephemeralOwner ：判断是否是临时节点
* dataLength ： 数据的长度
* numChildren ：子节点的数量

## 日志自动清理配置

在使用zookeeper过程中，我们知道，会有dataDir和dataLogDir两个目录，分别用于snapshot和事务日志的输出（默认情况下只有dataDir目录，snapshot和事务日志都保存在这个目录中，正常运行过程中，ZK会不断地把快照数据和事务日志输出到这两个目录，并且如果没有人为操作的话或者配置的话不会自动清理，当然可以再zoo.cfg文件中可以配置

```bash
# The number of snapshots to retain in dataDir
# 这个参数和上面的参数搭配使用，这个参数指定了需要保留的文件数目。默认是保留3个
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
# 这个参数指定了清理频率，单位是小时，需要填写一个1或更大的整数，默认是0，表示不开启自己清理功能。
#autopurge.purgeInterval=1
```

##集群配置和管理

说句实话Zookeeper就是个坑，配套的kafka等生态圈都是坑，但架不住用的人多。ZooKeeper的集群模式下，多个Zookeeper服务器在工作前会选举出一个Leader，在接下来的工作中这个被选举出来的Leader死了，而剩下的Zookeeper服务器会知道这个Leader死掉了，在活着的Zookeeper集群中会继续选出一个Leader，选举出Leader的目的是为了可以在分布式的环境中保证数据的一致性。

由于ZooKeeper集群中，会有一个Leader负责管理和协调其他集群服务器，因此服务器的数量通常都是单数，例如3，5，7...等，这样2n+1的数量的服务器就可以允许最多n台服务器的失效。

加入有三台服务器，可以分别在三台服务器上编写如下配置文件即可

```bash
dataDir=/home/jqlin/dev/zookeeper-3.4.6/data
tickTime=2000
initLimit=5
syncLimit=2
clientPort=2181

server.0=192.168.1.100:2888:3888
server.1=192.168.1.101:2888:3888
server.2=192.168.1.102:2888:3888
```

之后就可以通过zkCli连接到集群的任意一台服务器上然后进行相应的操作。



## 权限控制

CREATE、READ、WRITE、DELETE、ADMIN 也就是 增、删、改、查、管理权限，这5种权限简写为crwda(即：每个单词的首字符缩写)注：这5种权限中，delete是指对子节点的删除权限，其它4种权限指对自身节点的操作权限

身份的认证有4种方式：
world：默认方式，相当于全世界都能访问
auth：代表已经认证通过的用户(cli中可以通过addauth digest user:pwd 来添加当前上下文中的授权用户)
digest：即用户名:密码这种方式认证，这也是业务系统中最常用的
ip：使用Ip地址认证

* 密码认证方式

```bash
# 增加一个认证用户
# addauth digest 用户名:密码明文
addauth digest user1:password1
# 设置权限
# setAcl /path auth:用户名:密码明文:权限
setAcl /test auth:user1:password1:cdrwa
# 查看Acl设置
getAcl /path

# setAcl /path digest:用户名:密码密文:权限 这里的加密规则是SHA1加密，然后base64编码。

```

* ip认证方式 

```bash
# setAcl 路径 ip:xxx.xxx.xxx.xx1:cdrwa,ip:xxx.xxx.xxx.xx2:cdrwa
setAcl /zkaa ip:127.0.0.1:cdrwa,ip:10.111.134.6:cdrwa
```

