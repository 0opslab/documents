### lucene基本概念

es是基于lucene实现的，因此lucene基本概念在es中同样存在。

* segment

  lucene内部的数据是由一个个segment组成的，写入lucene的数据并不直接落盘，而是先写在内存中，经过了refresh间隔，lucene才将该时间段写入的全部数据refresh成一个segment，segment多了之后会进行merge成更大的segment。lucene查询时会遍历每个segment完成。由于lucene* 写入的数据是在内存中完成，所以写入效率非常高。但是也存在丢失数据的风险，所以Elasticsearch基于此现象实现了translog，只有在segment数据落盘后，Elasticsearch才会删除对应的translog。

* doc

  doc表示lucene中的一条记录

* field

  field表示记录中的字段概念，一个doc由若干个field组成。

* term

  term是lucene中索引的最小单位，某个field对应的内容如果全文检索，会将内容进行分词，分词的结果就是由term组成的，如果是不分词的字段，那么该字段的内容就是一个term。

* inverted index

  倒排索引lucene索引的通用叫法，即实现了term到doc list的映射。

* docvalues

  Elasticsearch中的列式存储的名称，Elasticsearch除了存储原始存储、倒排索引，还存储了一份docvalues，用作分析和排序。

  

### ES的基本概念

* 索引Index

  ES将数据存储于一个或多个索引中，索引是具有类似特性的文档的集合，类比传统的关系数据库中数据库DB，或者一个数据存储方案Schema。索引由其名称(必须为全小写字符)进行标识，并通过引用此名称完成文档的创建、搜索、更新及删除操作。一个ES集群中可以按需创建任意数目的索引。

* 类型Type

  类型是索引内部的逻辑分区(category/partition)，然而其意义完全取决于用户需求。因此，一个索引内部可定义一个或多个类型(type)。一般来说，类型就是为那些拥有相同的域的文档做的预定义。类比传统的关系数据库中的表。

* 文档Document

  文档是Lucene索引和搜索的原子单位，它是包含了一个或多个域的容器，基于JSON格式进行表示。文档由一个或多个域组成，每个域拥有一个名字及一个或多个值，有多个值的域通常称为“多值域”。每个文档可以存储不同的域集，但同一类型下的文档至应该有某种程度上的相似之处。

* 字段field

  文档包含一系列的字段，或者key-value 对。每个值都有可以是单个值（string，intger，date）或者是一个像数组的nested 结构或者对象。字段和关系数据库中的列类似。不要和文档type混淆。

* 映射mapping

  ES中，所有的文档在存储之前都要首先进行分析。用户可根据需要定义如何将文本分割成token、哪些token应该被过滤掉，以及哪些文本需要进行额外处理等等。

* 集群Cluster

  ES集群是一个或多个节点的集合，它们共同存储了整个数据集，并提供了联合索引以及可跨所有节点的搜索能力。多节点组成的集群拥有冗余能力，它可以在一个或几个节点出现故障时保证服务的整体可用性。

* 节点Node

  运行了单个实例的ES主机称为节点，它是集群的一个成员，可以存储数据、参与集群索引及搜索操作。类似于集群，节点靠其名称进行标识，默认为启动时自动生成的随机Marvel字符名称。

* 分片Shard和副本Replica

  ES的“分片(shard)”机制可将一个索引内部的数据分布地存储于多个节点，它通过将一个索引切分为多个底层物理的Lucene索引完成索引数据的分割存储功能，这每一个物理的Lucene索引称为一个分片(shard)。

* 分析analysis

  把字符串转换为terms的过程。基于它使用可那些分词器，短语：FOO BAR, Foo-Bar, foo,bar有可能分词为terms：foo和bar。这些terms会被存储在索引中。全文索引查询（不是term query）“FoO:bAR”，同样也会被分词为terms：foo,bar，并且也匹配存在索引中的terms。分词过程（包括索引或搜索过程）使es可以执行全文查询。

### ES的配置

es的核心配置文件在config目录下，如下所示

```bash
config/elasticsearch.yml   主配置文件
config/jvm.options         jvm参数配置文件
cofnig/log4j2.properties   日志配置文件
```

其中的elasticsearch.yml文件是主配置文件下面试es5.x的配置文件

```yaml
################################### Cluster ################################### 
# 代表一个集群,集群中有多个节点,其中有一个为主节点,这个主节点是可以通过选举产生的,主从节点是对于集群内部来说的. 
# es的一个概念就是去中心化,字面上理解就是无中心节点,这是对于集群外部来说的,因为从外部来看es集群,在逻辑上是个整体,你与任何一个节点的通信和与整个es集群通信是等价的。 
# cluster.name可以确定你的集群名称,当你的elasticsearch集群在同一个网段中elasticsearch会自动的找到具有相同cluster.name的elasticsearch服务. 
# 所以当同一个网段具有多个elasticsearch集群时cluster.name就成为同一个集群的标识. 
# cluster.name: es6.2 

#################################### Node ##################################### 
# 节点名称同理,可自动生成也可手动配置. 
# node.name: node-1

# 允许一个节点是否可以成为一个master节点,es是默认集群中的第一台机器为master,如果这台机器停止就会重新选举master. 任何主节点的节点（默认情况下所有节点）都可以被主选举过程选为主节点。
# node.master: true 

# 允许该节点存储数据(默认开启) 
# node.data: true 
# 注意：主节点必须有权访问该data/目录（就像data节点一样 ），因为这是集群状态在节点重新启动之间持续存在的位置。

# 允许该节点为摄取节点(默认开启) 
# node.ingest：true
# 配置为true将主节点和数据节点标记为“是有意义的”

# 开启跨群集搜索（默认启用）
# search.remote.connect：true

# 配置文件中给出了三种配置高性能集群拓扑结构的模式,如下： 
# 1. 如果你想让节点从不选举为主节点,只用来存储数据,可作为数据节点 
# node.master: true 
# node.data: false
# node.ingest: true

# 2. 如果想让节点成为主节点,且不存储任何数据,并保有空闲资源,可作为协调器 
# node.master：true 
# node.data：false 
# node.ingest：false 

# 3. 如果想让节点既不称为主节点,又不成为数据节点,那么可将他作为摄取节点,从节点中获取数据,生成搜索结果等 
# node.master: false 
# node.data: false 
# node.ingest: true

# 4. 仅作为协调器 
# node.master: false 
# node.data: false
# node.ingest: false

#################################### Paths #################################### 
# 数据存储位置(单个目录设置) 
# path.data: /var/data/elasticsearch
#path.data应将该设置配置为在Elasticsearch主目录之外定位数据目录，以便在不删除数据的情况下删除主目录！

# 日志文件的路径 
# path.logs: /var/log/elasticsearch 

#################################### 网络设置 #################################### 
# 节点将绑定到此主机名或IP地址
# network.host: 127.0.0.1

# 绑定到传入HTTP请求的端口
# http.port: 9200 
# 接受单个值或范围。如果指定了范围，则节点将绑定到范围中的第一个可用端口。默认为9200-9300

#################################### TCP传输 #################################### 
# 端口绑定节点之间的通信。
# transport.tcp.port: 9300
# 接受单个值或范围。如果指定了范围，则节点将绑定到范围中的第一个可用端口。默认为9300-9400

# transport.publish_port: 9300
# 与此节点通信时，群集中其他节点应使用的端口。当群集节点位于代理或防火墙之后并且transport.tcp.port不能从外部直接寻址时很有用。默认为通过分配的实际端口 transport.tcp.port

# transport.bind_host: 127.0.0.1
# 将传输服务绑定到的主机地址。默认为transport.host（如果设置）或network.bind_host

# transport.publish_host: 127.0.0.1 
# 发布集群中要连接到的节点的主机地址。默认为transport.host（如果设置）或network.publish_host

# transport.host: 127.0.0.1 
# 用于设置transport.bind_host和transport.publish_host默认为transport.host或network.host

# transport.tcp.connect_timeout: 30s
# 套接字连接超时设置（以时间设置格式）。默认为30s

# transport.tcp.compress: false
# 设置是否压缩tcp传输时的数据，默认为false,不压缩。

# transport.ping_schedule: 5s
# 安排常规ping消息以确保连接保持活动状态。默认为5s在传输客户端和-1（禁用）

#################################### 高级网络设置 #################################### 
#该network.host设置中的说明通常使用的网络设置 是快捷方式设定所述绑定的主机和发布主机在同一时间。在高级用例中，例如在代理服务器后运行时，可能需要将这些设置设置为不同的值：
# 绑定到哪个网络接口以侦听传入请求
# network.bind_host: 127.0.0.1
# 点可以绑定到多个接口，例如两个网卡，或站点本地地址和本地地址。默认为 network.host。

# network.publish_host: 127.0.0.1
# 发布主机是节点通告集群中其他节点的单个接口，以便这些节点可以连接到它。目前，Elasticsearch节点可能会绑定到多个地址，但只发布一个。如果未指定，则默认为“最佳”地址network.host，按IPv4 / IPv6堆栈首选项排序，然后按可访问性排序。如果您将其设置为 network.host多个绑定地址，但依赖于特定地址进行节点间通信，则应该明确设置 network.publish_host。transport.tcp.port

#################################### 高级TCP设置 #################################### 
# 任何使用TCP的组件（如HTTP和 传输模块）都共享以下设置：
# network.tcp.no_delay: true
# 启用或禁用TCP无延迟 设置。默认为true。

# network.tcp.keep_alive: true
# 启用或禁用TCP保持活动状态。默认为true。

# network.tcp.reuse_address: true
# 地址是否应该重复使用。默认为true在非Windows机器上。

# network.tcp.send_buffer_size
# TCP发送缓冲区的大小（以大小单位指定）。默认情况下不明确设置。

# network.tcp.receive_buffer_size
# TCP接收缓冲区的大小（以大小单位指定）。默认情况下不明确设置。

################################### Memory #################################### 
# bootstrap.memory_lock: true
# 设置为true来锁住内存。因为内存交换到磁盘对服务器性能来说是致命的，当jvm开始swapping时es的效率会降低，所以要保证它不swap

###################### 使用head等插件监控集群信息，需要打开以下配置项 ###########
# http.cors.enabled: true
# http.cors.allow-origin: "*"
# http.cors.allow-credentials: true

################################### Gateway ###################################
# 以下静态设置（必须在每个主节点上设置）控制刚刚选择的主服务器在尝试恢复群集状态和群集数据之前应等待的时间，修改后需要重启生效
# gateway.expected_nodes: 0
# 预计在集群中的（数据或主节点）数量。只要预期的节点数加入群集，恢复本地碎片就会开始。默认为0

# gateway.expected_master_nodes: 0
# 预计将在群集中的主节点的数量。一旦预期的主节点数加入群集，就会立即开始恢复本地碎片。默认为0

# gateway.expected_data_nodes: 0
# 预计将在群集中的数据节点的数量。只要预期数量的节点加入群集，就会开始恢复本地碎片。默认为0

# gateway.recover_after_time: 5m
# 设置初始化恢复过程的超时时间,超时时间从上一个配置中配置的N个节点启动后算起。默认为5m

################################## Discovery ##################################
#### 该配置十分重要,没有正确配置,可能无法构成集群
# 这是一个集群中的主节点的初始列表,当节点(主节点或者数据节点)启动时使用这个列表进行探测
# discovery.zen.ping.unicast.hosts: ["host1:port", "host2:port", "host3:port"]
# 默认为["127.0.0.1", "[::1]"]

# discovery.zen.ping.unicast.hosts.resolve_timeout: 5s
# 在每轮ping中等待DNS查找的时间量。指定为 时间单位。默认为5秒

# discovery.zen.ping_timeout: 3s
# 确定节点将多久决定开始选举或加入现有的群集之前等待,默认3s

# discovery.zen.join_timeout: 
# 一旦一个节点决定加入一个现有的已形成的集群，它将发送一个加入请求给主设备，默认值是ping超时的20倍。

# discovery.zen.minimum_master_nodes: 2
# 为防止数据丢失，配置discovery.zen.minimum_master_nodes设置（默认设置1）至关重要， 以便每个符合主节点的节点都知道 为了形成群集而必须可见的主节点的最小数量。
#为了解释，假设您有一个由两个主节点组成的集群。网络故障会中断这两个节点之间的通信。每个节点都会看到一个主节点的节点......本身。随着minimum_master_nodes设置为默认1，这是足以形成一个集群。每个节点将自己选为新的主人（认为另一个主人资格的节点已经死亡），结果是两个集群，或者是一个分裂的大脑。直到一个节点重新启动后，这两个节点才会重新加入。任何已写入重新启动节点的数据都将丢失。
#现在想象一下，您有一个具有三个主节点资格的节点的集群，并 minimum_master_nodes设置为2。如果网络拆分将一个节点与其他两个节点分开，则具有一个节点的一侧不能看到足够的主节点，并且会意识到它不能将自己选为主节点。具有两个节点的一侧将选择一个新的主控（如果需要）并继续正常工作。一旦网络拆分解决，单个节点将重新加入群集并再次开始提供服务请求。
#该设置应该设置为符合主数据节点的法定数量：（master_eligible_nodes / 2）+ 1换句话说，如果有三个符合条件的节点，则最小主节点应设置为(3 / 2) + 1或2。


```

### ES的监控

ES听过了很多方式的监控查看，其中要属cat api的方式最为简单实用，直接访问对应地址即可。另外所有的catAPI都有如下几个通用参数:



Verbose   GET /_cat/XXX/?v   开启详细输出

Help GET /cat/XXX/?help 输出可用的列

Headers GET /_cat/XXX/?h=column1,column2 指定输出的列
Sort GET /_cat/XXX/?v&s=column1,column2:desc,column3 指定输出的列进行排序，默认按照升序排序
Format GET /_cat/XXX?format=json 指定响应返回的数据格式：text（默认）,json,yaml,smile,cbor

```bash
curl http://10.232.14.216:9200/_cat
=^.^=
# 提供了每个数据节点分配了多少分片和使用了多少磁盘空间的快照
/_cat/allocation
# 显示分片状态
/_cat/shards
/_cat/shards/{index}
# 显示ID、IP地址、主机名和节点名
/_cat/master
# 显示节点信息
/_cat/nodes
/_cat/tasks
# 查看索引状态，如主分片数和副本数、文档数、删除文档数，大小等等
/_cat/indices
/_cat/indices/{index}
# 显示索引分片段有关的低级别信息
/_cat/segments
/_cat/segments/{index}
# 快速查看整个集群的文档数或单个索引
/_cat/count
/_cat/count/{index}
# 显示正在进行的和以前完成的索引分片恢复状态。恢复事件随时可能发生，在集群中一个索引分片转移到其它节点上。可能发生在快照恢复、改变副本级别、节点故障或者启动节点。
/_cat/recovery
/_cat/recovery/{index}
# 查看集群状态。有一个ts选项禁用时间戳
/_cat/health
# 与 /_cluster/pending_tasks提供相同的信息，以表格化显示
/_cat/pending_tasks
# 显示目前配置的别名索引，包括过滤和路由相关的信息
/_cat/aliases
/_cat/aliases/{alias}
# 显示线程池状态。包括 merge，optimize，flush，refresh 等其他线程池状态，可通过 ?h 参数指明获取
/_cat/thread_pool
/_cat/thread_pool/{thread_pools}
# 显示节点插件信息
/_cat/plugins
# 显示集群中每个数据节点fielddata当前所使用的heap内存大小
/_cat/fielddata
/_cat/fielddata/{fields}
# 显示自定义节点属性，节点名、主机名、IP地址、属性名、属性值。属性名和属性值就是你定义的
/_cat/nodeattrs
# repositories 可以显示集群中的快照的资料库
/_cat/repositories
# 输出属于指定仓库的快照信息
/_cat/snapshots/{repository}
# 输出当前正在存在的模板信息
/_cat/templates

```

处理cat api外还有几个接口实用的场景也很多

```bash
# 顾名思义就是看集群内的每一个节点的状态信息，在每个节点上会有不同索引的一些分片，这个节点所涉及到的分片每一个单独的信息可以通过这个API观察到的
/_nodes/stats 
# Cluster Stats API，就是整个集群的比较选举性的信息，通过这个API包括插件节点输入，还有一些各个节点的统计信息的相加结果，都可以在这个API中可以看到
/_cluster/stats
# Index_name Stats API，就是刚才提到维度索引级别的。这个API的调用是通过一个index_name斜杠，是指定每一个索引都可以去调用这个接口，去观察这个索引的相关统计信息。部分指标和Node Stats API相匹配
/index_name/_stats
# Cluster Health API，这是大家非常了解的，ES绿、黄、红三个状态就是通过这个接口来拿到。这个接口包含整个集群的分片信息和监控状态，这个监控大家应该会用得非常广泛
/_cluster/health
# Pending Tasks API，ES里面有很多的异步任务，利用这个接口可以进行全局性观察。整个集群当中正在跑的一些任务，这些任务包括索引创建任务或者是shard均衡任务等
/_cluster/pending_tasks
```

查看集群的健康,集群的健康值一般有如下三个状态

green 所有主要分片和复制分片都可用

yellow 所有主要分片可用，但不是所有复制分片都可用。高可用不牢靠。但不会丢失数据

red 不是所有的主要分片都可用。数据有极大风险。数据不能用

```bash
GET _cluster/health

{

  "cluster_name": "elasticsearch",

  "status": "yellow",

  "timed_out": false,

  "number_of_nodes": 1,##集群节点数

  "number_of_data_nodes": 1,##数据节点数量

  "active_primary_shards": 156,##主分片数量

  "active_shards": 156,##可用的分片数量

  "relocating_shards": 0,##正在重新分配的分片数量，在新加或者减少节点的时候会发生

  "initializing_shards": 0,##正在初始化的分片数量，新建索引或者刚启动会存在，时间很短

  "unassigned_shards": 156, ##没有分配的分片，一般就是那些名存实不存的副本分片。

  "delayed_unassigned_shards": 0,

  "number_of_pending_tasks": 0,

  "number_of_in_flight_fetch": 0,

  "task_max_waiting_in_queue_millis": 0,

  "active_shards_percent_as_number": 50

}

##索引级别集群状态，可以细致查看到底是哪个索引引起集群的故障的

GET _cluster/health?level=indices

##分片级别集群状态，可以细致查看到底是哪个分片引起的集群故障

GET _cluster/health?level=shards

##阻塞查看集群状态，适用于自动化脚本。当状态变为指定状态或者更好就返回继续执行。

GET _cluster/health?wait_for_status=yellow

 
```

另外还有很多第三监控系统，如Bigdesk、ElasticSearch-HQ、Xpack monitor等。在Kibana中安装Xpack monitor的方式还是很常用的方式。

