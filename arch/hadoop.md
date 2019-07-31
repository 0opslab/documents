hadoop是受google论文的启发，开发出来的。是一个适合大数据的分布式存储和计算平带，Hadoop的核实新是HDFS(Hadoop distributed file system)分布式文件系统，用来管理文件的。当然Hadoop爷爷支持MapReduce分布式并行计算框架。

## Hadoo的核心

* HDFS：Hadoop Distributed File System  分布式文件系统
* YARN: Yet Another Resource Negotiator   资源管理调度系统
* Mapreduce：分布式运算框架



hdfs和mapreduce都是主从结构，管理与被管理这种关系，分为管理者和被管理者，被管理者通常做具体的事物，管理着通常是组织、协调、管理的。

* 主节点，只有一个NameNode，负责各个节点数据的组织管理
* 从节点，有很多的DataNode，负责存储数据，数据节点

NameNode对外DataNode对内，NameNode接收用户的操作请求，NameNode负责协调管理，不是真正的存放数据会把把数据分散到各个节点上去存储。

当然一般都是只有一个NameNode，但在某些情况下着是不可靠的。因此Hadoop还提供SecondaryNameNode着种方式。

NameNode：是Master节点，是大领导。管理数据块映射；处理客户端的读写请求；配置副本策略；管理HDFS的名称空间；
SecondaryNameNode：是一个小弟，分担大哥namenode的工作量；是NameNode的冷备份；合并fsimage和fsedits然后再发给namenode。
DataNode：Slave节点，奴隶，干活的。负责存储client发来的数据块block；执行数据块的读写操作。
　　　　热备份：b是a的热备份，如果a坏掉。那么b马上运行代替a的工作。
　　　　冷备份：b是a的冷备份，如果a坏掉。那么b不能马上代替a工作。但是b上存储a的一些信息，减少a坏掉之后的损失。
fsimage:元数据镜像文件（文件系统的目录树。）
edits：元数据的操作日志（针对文件系统做的修改操作记录）
namenode内存中存储的是=fsimage+edits。
SecondaryNameNode负责定时默认1小时，从namenode上，获取fsimage和edits来进行合并，然后再发送给namenode。减少namenode的工作量。



**NameNode**  的工作机制尤其是对元数据管理机制，可以增强HDFS工作原理的理解，可以更好的进行性能调优，Namenode故障问题的分析解决能力。NameNode的主要职责：

* 负责客户端请求(读写数据，请求)的响应
* 维护目录结构树(元数据的管理：查询，修改)
* 配置和应用副本存放策略
* 管理集群数据块负载均衡问题

NameNode对数据的管理采用了俩种存储形式:内存和磁盘。其中内存中有一份完整的元数据(内存metadata)，磁盘中有一个“准完整”的元数据镜像fsimage文件(在namenode的工作目录中)。当客户端对hdfs中的文件进行新增或者修改操作，记录首先会写入到磁盘中edits文件中，当操作成功后，相应的元数据才会更新到内存的metadata中，随后才后写入到fsimage文件即同步到磁盘中。

磁盘元数据镜像文件fsimage_0000000000000000555等价于edits_0000000000000000001-0000000000000000555合并的结果。数据预写入操作日志文件edits_inprogress_0000000000000000556成功后会优先写入到内存的metadata中。

**DataNode** 的工作职责就就是负责存储管理用户的文件块数据，定期向namenode汇报自身持有的block信息(通过心跳信息)上报。datanode进程死亡或者网络故障造成datanode无法与namenode通信，namenode不会立即把该节点判定为死亡，要经过一段时间。HDFS默认的超时时长为10分钟+30秒，如果定义超时为timeout，则超时时长的计算公式为： timeout = 2 * heartbeat.recheck.interval + 10 * dfs.heartbeat.interval



**SecondaryNameNode**的作用就是分担namenode的合并元数据的压力，所以在配置secondaryName的工作节点时，一定切记，不要和namenode处于同一节点。但事实上，只有在普通的伪分布式集群中才会有secondaryNamenode这个角色，在HA或者联邦集群中都不再出现该角色，再HA和联邦集群中，都是有standbyName承担。每隔一段时间，会由 secondary namenode 将 namenode 上积累的所有 edits 和一个最新的 fsimage 下载到本地，并加载到内存进行 merge（这个过程称为 checkpoint）

## Hadoop的核心配置

hadoop的核心配置文件有如下即可

```bash
## 一般是修改一些环境变量等sh文件
xx/etc/hadoop/hadoop-env.sh
xx/etc/hadoop/yarn-env.sh
xx/etc/hadoop/mapred-env.sh
xx/etc/hadoop/savles

## 具体的配置
xx/etc/hadoop/core-site.xml
	fs.defaultFS		配置hdfs系统的地址,在那一台配，Namenode就在那一台启动
	io.file.buffer.size 该属性值单位为KB，131072KB即为默认的64M
xx/etc/hadoop/hdfs-site.xml
	dfs.replication  分片数量、伪分布式将其配置成1即可
    dfs.namenode.name.dir 命名空间和事务在本地文件系统永久存储的路径
    dfs.blocksize	大文件系统HDFS块大小为256M，默认值为64M
xx/etc/hadoop/mapred-site.xml
	mapreduce.framework.name 执行框架设置为 Hadoop YARN.
	mapreduce.map.memory.mb	 对maps更大的资源限制的.
	mapreduce.map.java.opts	 maps中对jvm child设置更大的堆大小
	mapreduce.reduce.memory.mb	设置 reduces对于较大的资源限制
	mapreduce.task.io.sort.factor 在文件排序中更多的流合并为一次
	mapreduce.reduce.shuffle.parallelcopies 通过reduces从很多的map中读取较多的平行
	
xx/etc/hadoop/yarn-site.xml
	# 配置ResourceManager 和 NodeManager
	yarn.resourcemanager.address 客户端对ResourceManager主机通过 host:port 提交作业
	yarn.resourcemanager.scheduler.address ApplicationMasters 通过ResourceManager主机访问host:port跟踪调度程序获资源
```

### HADOOP HA和联邦模式

常规的HADOOP集群或伪集群都存在单节点故障，如果NameNode挂了，整个集群都不可用，为此HADOOP提供了HA和联邦模式来解决这个问题。

**HA方案**

HDFS有俩个NameNode组成，一个处于Active状态，另一个处于standby状态。处于激活状态的NameNode会响应集群中所有的客户端，备份状态的NameNode只是作为一个副本，保证在必要的时候提供一个快速转移。为了让standby NameNode与处于Active NameNode 的状态同步，这俩个Node都与一组称谓JNS的相互独立的经常保持通讯(Journal Nodes).当Active Node上更新了namespace，它将记录修改日志发送给JNS的多数派。Standby noes将会从JNS中读取这些edits，并持续关注它们对日志的变更。Standby Node将日志变更应用在自己的namespace中，当failover发生时，Standby将会在提升自己为Active之前，确保能够从JNS中读取所有的edits，即在failover发生之前Standy持有的namespace应该与Active保持完全同步。

为了支持快速failover，Standby node持有集群中blocks的最新位置是非常必要的。为了达到这一目的，DataNodes上需要同时配置这两个Namenode的地址，同时和它们都建立心跳链接，并把block位置发送给它们。

任何时刻，只有一个Active NameNode是非常重要的，否则将会导致集群操作的混乱，那么两个NameNode将会分别有两种不同的数据状态，可能会导致数据丢失，或者状态异常，这种情况通常称为“split-brain”（脑裂，三节点通讯阻断，即集群中不同的Datanodes却看到了两个Active NameNodes）。对于JNS而言，任何时候只允许一个NameNode作为writer；在failover期间，原来的Standby Node将会接管Active的所有职能，并负责向JNS写入日志记录，这就阻止了其他NameNode基于处于Active状态的问题。

**Federation 联邦模式**

Federation 中文意思为联邦,联盟，是 NameNode 的 Federation,也就是会有多个NameNode。多个 NameNode 的情况意味着有多个 namespace(命名空间)，区别于 HA 模式下的多 NameNode，它们是拥有着同一个 namespace。HDFS Federation 并没有完全解决单点故障问题。虽然 namenode/namespace 存在多个，但是从单个 namenode/namespace 看，仍然存在单点故障：如果某个 namenode 挂掉了，其管理的相应的文件便不可以访问。Federation中每个namenode仍然像之前HDFS上实现一样，配有一个 secondary namenode，以便主 namenode 挂掉一下，用于还原元数据信息。所以一般集群规模真的很大的时候，会采用 HA+Federation 的部署方案。也就是每个联合的 namenodes 都是 ha 的。

这也可以是hadoop最大的败笔所在。



## FS Shell

调用文件系统(FS)Shell命令应使用 bin/hadoop fs <args>的形式。 所有的的FS shell命令使用URI路径作为参数。URI格式是*scheme://authority/path*。对HDFS文件系统，scheme是*hdfs*，对本地文件系统，scheme是*file*。其中scheme和authority参数都是可选的，如果未加指定，就会使用配置中指定的默认scheme。一个HDFS文件或目录比如*/parent/child*可以表示成*hdfs://namenode:namenodeport/parent/child*，或者更简单的*/parent/child*（假设你配置文件中的默认值是*namenode:namenodeport*）。大多数FS Shell命令的行为和对应的Unix Shell命令类似，不同之处会在下面介绍各命令使用详情时指出。出错信息会输出到*stderr*，其他信息输出到*stdout*。







### cat

使用方法：hadoop fs -cat URI [URI …]

将路径指定文件的内容输出到*stdout*。

示例：

- hadoop fs -cat hdfs://host1:port1/file1 hdfs://host2:port2/file2
- hadoop fs -cat file:///file3 /user/hadoop/file4

返回值：
成功返回0，失败返回-1。







### chgrp

使用方法：hadoop fs -chgrp [-R] GROUP URI [URI …] Change group association of files. With -R, make the change recursively through the directory structure. The user must be the owner of files, or else a super-user. Additional information is in the [Permissions User Guide](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html). -->

改变文件所属的组。使用-R将使改变在目录结构下递归进行。命令的使用者必须是文件的所有者或者超级用户。更多的信息请参见[HDFS权限用户指南](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html)。







### chmod

使用方法：hadoop fs -chmod [-R] <MODE[,MODE]... | OCTALMODE> URI [URI …]

改变文件的权限。使用-R将使改变在目录结构下递归进行。命令的使用者必须是文件的所有者或者超级用户。更多的信息请参见[HDFS权限用户指南](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html)。







### chown

使用方法：hadoop fs -chown [-R] [OWNER][:[GROUP]] URI [URI ]

改变文件的拥有者。使用-R将使改变在目录结构下递归进行。命令的使用者必须是超级用户。更多的信息请参见[HDFS权限用户指南](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_permissions_guide.html)。







### copyFromLocal

使用方法：hadoop fs -copyFromLocal <localsrc> URI

除了限定源路径是一个本地文件外，和[**put**](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#putlink)命令相似。







### copyToLocal

使用方法：hadoop fs -copyToLocal [-ignorecrc] [-crc] URI <localdst>

除了限定目标路径是一个本地文件外，和[**get**](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_shell.html#getlink)命令类似。







### cp

使用方法：hadoop fs -cp URI [URI …] <dest>

将文件从源路径复制到目标路径。这个命令允许有多个源路径，此时目标路径必须是一个目录。 
示例：

- hadoop fs -cp /user/hadoop/file1 /user/hadoop/file2
- hadoop fs -cp /user/hadoop/file1 /user/hadoop/file2 /user/hadoop/dir

返回值：

成功返回0，失败返回-1。







### du

使用方法：hadoop fs -du URI [URI …]

显示目录中所有文件的大小，或者当只指定一个文件时，显示此文件的大小。
示例：
hadoop fs -du /user/hadoop/dir1 /user/hadoop/file1 hdfs://host:port/user/hadoop/dir1 
返回值：
成功返回0，失败返回-1。 







### dus

使用方法：hadoop fs -dus <args>

显示文件的大小。







### expunge

使用方法：hadoop fs -expunge

清空回收站。请参考[HDFS设计](http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html)文档以获取更多关于回收站特性的信息。







### get

使用方法：hadoop fs -get [-ignorecrc] [-crc] <src> <localdst> 

复制文件到本地文件系统。可用-ignorecrc选项复制CRC校验失败的文件。使用-crc选项复制文件以及CRC信息。

示例：

- hadoop fs -get /user/hadoop/file localfile
- hadoop fs -get hdfs://host:port/user/hadoop/file localfile

返回值：

成功返回0，失败返回-1。







### getmerge

使用方法：hadoop fs -getmerge <src> <localdst> [addnl]

接受一个源目录和一个目标文件作为输入，并且将源目录中所有的文件连接成本地目标文件。addnl是可选的，用于指定在每个文件结尾添加一个换行符。







### ls

使用方法：hadoop fs -ls <args>

如果是文件，则按照如下格式返回文件信息：
文件名 <副本数> 文件大小 修改日期 修改时间 权限 用户ID 组ID 
如果是目录，则返回它直接子文件的一个列表，就像在Unix中一样。目录返回列表的信息如下：
目录名 <dir> 修改日期 修改时间 权限 用户ID 组ID 
示例：
hadoop fs -ls /user/hadoop/file1 /user/hadoop/file2 hdfs://host:port/user/hadoop/dir1 /nonexistentfile 
返回值：
成功返回0，失败返回-1。 







### lsr

使用方法：hadoop fs -lsr <args> 
ls命令的递归版本。类似于Unix中的ls -R。







### mkdir

使用方法：hadoop fs -mkdir <paths> 

接受路径指定的uri作为参数，创建这些目录。其行为类似于Unix的mkdir -p，它会创建路径中的各级父目录。

示例：

- hadoop fs -mkdir /user/hadoop/dir1 /user/hadoop/dir2
- hadoop fs -mkdir hdfs://host1:port1/user/hadoop/dir hdfs://host2:port2/user/hadoop/dir

返回值：

成功返回0，失败返回-1。







### movefromLocal

使用方法：dfs -moveFromLocal <src> <dst>

输出一个”not implemented“信息。







### mv

使用方法：hadoop fs -mv URI [URI …] <dest>

将文件从源路径移动到目标路径。这个命令允许有多个源路径，此时目标路径必须是一个目录。不允许在不同的文件系统间移动文件。 
示例：

- hadoop fs -mv /user/hadoop/file1 /user/hadoop/file2
- hadoop fs -mv hdfs://host:port/file1 hdfs://host:port/file2 hdfs://host:port/file3 hdfs://host:port/dir1

返回值：

成功返回0，失败返回-1。







### put

使用方法：hadoop fs -put <localsrc> ... <dst>

从本地文件系统中复制单个或多个源路径到目标文件系统。也支持从标准输入中读取输入写入目标文件系统。

- hadoop fs -put localfile /user/hadoop/hadoopfile
- hadoop fs -put localfile1 localfile2 /user/hadoop/hadoopdir
- hadoop fs -put localfile hdfs://host:port/hadoop/hadoopfile
- hadoop fs -put - hdfs://host:port/hadoop/hadoopfile 
    从标准输入中读取输入。

返回值：

成功返回0，失败返回-1。







### rm

使用方法：hadoop fs -rm URI [URI …]

删除指定的文件。只删除非空目录和文件。请参考rmr命令了解递归删除。
示例：

- hadoop fs -rm hdfs://host:port/file /user/hadoop/emptydir

返回值：

成功返回0，失败返回-1。







### rmr

使用方法：hadoop fs -rmr URI [URI …]

delete的递归版本。
示例：

- hadoop fs -rmr /user/hadoop/dir
- hadoop fs -rmr hdfs://host:port/user/hadoop/dir

返回值：

成功返回0，失败返回-1。







### setrep

使用方法：hadoop fs -setrep [-R] <path>

改变一个文件的副本系数。-R选项用于递归改变目录下所有文件的副本系数。

示例：

- hadoop fs -setrep -w 3 -R /user/hadoop/dir1

返回值：

成功返回0，失败返回-1。







### stat

使用方法：hadoop fs -stat URI [URI …]

返回指定路径的统计信息。

示例：

- hadoop fs -stat path

返回值：
成功返回0，失败返回-1。







### tail

使用方法：hadoop fs -tail [-f] URI

将文件尾部1K字节的内容输出到stdout。支持-f选项，行为和Unix中一致。

示例：

- hadoop fs -tail pathname

返回值：
成功返回0，失败返回-1。







### test

使用方法：hadoop fs -test -[ezd] URI

选项：
-e 检查文件是否存在。如果存在则返回0。
-z 检查文件是否是0字节。如果是则返回0。 
-d 如果路径是个目录，则返回1，否则返回0。

示例：

- hadoop fs -test -e filename







### text

使用方法：hadoop fs -text <src> 

将源文件输出为文本格式。允许的格式是zip和TextRecordInputStream。







### touchz

使用方法：hadoop fs -touchz URI [URI …] 

创建一个0字节的空文件。

示例：

- hadoop -touchz pathname

返回值：
成功返回0，失败返回-1。