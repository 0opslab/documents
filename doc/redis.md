# title{redis - redis相关的那些命令}
#查看redis集群信息：
redis-cli -c -p 6379 cluster nodes
或者
redis-trib.rb  check  10.26.25.115:6379
redis-trib.rb info 10.26.25.115:6379

## redis cluster命令
cluster info 查看集群信息
->#######################查看集群信息##########################
->cluster info ##打印集群的信息
->cluster nodes ##列出集群当前已知的所有节点(node)，以及这些节点的相关信息
->########################节点操作命名##########################
->cluster meet <ip> <port> ##将ip和port所指定的节点添加到集群当中，让它成为集群的一份子
->cluster forget <node_id> ##从集群中移除node_id指定的节点
->cluster replicate <node_id> ##将当前节点设置为node_id指定的节点的从节点
->cluster saveconfig ##将节点的配置文件保存到硬盘里面
->cluster slaves <node_id> ##列出该slave节点的master节点
->cluster set-config-epoch ##强制设置configEpoch
->#########################槽(slot)##########################
->cluster addslots <slot> [slot ...] ##将一个或多个槽(slot)指派(assign)给当前节点
->cluster delslots <slot> [slot ...] ##移除一个或多个槽对当前节点的指派
->cluster flushslots ##移除指派给当前节点的所有槽，让当前节点变成一个没有指派任何槽的节点
->cluster setslot <slot> node <node_id> ##将槽slot指派给node_id指定的节点，如果槽已经指派给另一个节点，那么先让另一个节点删除该槽，然后再进行指派
->cluster setslot <slot> migrating <node_id> ##将本节点的槽slot迁移到node_id指定的节点中
->cluster setslot <slot> importing <node_id> ##从node_id 指定的节点中导入槽slot到本节点
->cluster setslot <slot> stable ##取消对槽slot的导入(import)或者迁移(migrate)
键(key)
->cluster keyslot <key> ##计算键key应该被放置在哪个槽上
->cluster countkeysinslot <slot> ##返回槽slot目前包含的键值对数量
->cluster getkeysinslot <slot> <count> ##返回count个slot槽中的键
->cluster myid ##返回节点的ID
->cluster slots ##返回节点负责的slot
->cluster reset ##重置集群，慎用

## cluster info 命令详解
127.0.0.1:6379> cluster info   ##命令

cluster_state:ok     ##如果当前redis发现有failed的slots，默认为把自己cluster_state从ok个性为fail, 写入命令会失败。如果设置cluster-require-full-coverage为no,则无此限制。

cluster_slots_assigned:16384   		##已分配的槽
cluster_slots_ok:16384              ##槽的状态是ok的数目
cluster_slots_pfail:0               ##可能失效的槽的数目
cluster_slots_fail:0                ##已经失效的槽的数目
cluster_known_nodes:6               ##集群中节点个数

cluster_size:3                      ##集群中设置的分片个数
cluster_current_epoch:15            ##集群中的currentEpoch总是一致的,currentEpoch越高，代表节点的配置或者操作越新,集群中最大的那个node epoch
cluster_my_epoch:12                 ##当前节点的config epoch，每个主节点都不同，一直递增, 其表示某节点最后一次变成主节点或获取新slot所有权的逻辑时间.
cluster_stats_messages_sent:270782059
cluster_stats_messages_received:270732696

## cluster nodes


## 槽slot命令
cluster keyslot key  查看某个key在哪个slot槽

cluster nodes 查看集群节点信息，slot槽区间段分布

CLUSTER ADDSLOTS <slot> [slot ...] 将一个或多个槽（slot）指派（assign）给当前节点。  

CLUSTER DELSLOTS <slot> [slot ...] 移除一个或多个槽对当前节点的指派。  

CLUSTER FLUSHSLOTS 移除指派给当前节点的所有槽，让当前节点变成一个没有指派任何槽的节点。  

CLUSTER SETSLOT <slot> NODE <node_id> 将槽 slot 指派给 node_id 指定的节点，如果槽已经指派给另一个节点，那么先让另一个节点删除该槽>，然后再进行指派。  

CLUSTER SETSLOT <slot> MIGRATING <node_id> 将本节点的槽 slot 迁移到 node_id 指定的节点中。  

CLUSTER SETSLOT <slot> IMPORTING <node_id> 从 node_id 指定的节点中导入槽 slot 到本节点。  

CLUSTER SETSLOT <slot> STABLE 取消对槽 slot 的导入（import）或者迁移（migrate）。

./redis-cli -p 7001 -h 192.168.2.64  info
 

返回的内容如下

Redis Info 详细注解
# Server
redis_version:2.8.11                                #redis 版本
redis_git_sha1:00000000 
redis_git_dirty:0
redis_build_id:c5d14b5292af31b8
redis_mode:standalone
os:Linux 2.6.32-220.el6.x86_64 x86_64               #运行系统内核版本
arch_bits:64                                        #系统
multiplexing_api:epoll                              #redis的事件循环机制
gcc_version:4.4.7                                   #GCC版本号
process_id:30505                                    #redis当前进程号
run_id:f7b1bc1010cc228d0475c9a7f727b71ff62f47b2
tcp_port:6379                                       #redis端口
uptime_in_seconds:72841                             #运行时间(秒)
uptime_in_days:0                                    #运行时间(天)
hz:10
lru_clock:14802484
config_file:/usr/local/redis/conf/redis.conf        #配置文件路径

# Clients
connected_clients:1                                 #客户端连接数
client_longest_output_list:0                        #当前客户端最大输出列表
client_biggest_input_buf:0                          #当前客户端最大输入列表
blocked_clients:0                                   #被阻塞的客户端数

# Memory
used_memory:1880256                                 #使用内存B
used_memory_human:1.79M                             #使用内存M
used_memory_rss:9502720                             #使用内存总量(包括碎片)
used_memory_peak:2041464                            #使用内存最高峰B
used_memory_peak_human:1.95M                        #使用内存最高峰M
used_memory_lua:33792
mem_fragmentation_ratio:5.05                        #内存碎片比
mem_allocator:jemalloc-3.2.0

# Persistence
loading:0
rdb_changes_since_last_save:652                     #自上次dump后rdb改动次数
rdb_bgsave_in_progress:0                            #rdb save是否在进行中
rdb_last_save_time:1407311308                       #上次save的时间戳
rdb_last_bgsave_status:ok                           #上次save的状态
rdb_last_bgsave_time_sec:0                          #上次save的时间，单位为秒
rdb_current_bgsave_time_sec:-1                      #如果rdb save操作正在进行，则是所使用的时间
aof_enabled:1                                       #是否开启了aof
aof_rewrite_in_progress:0                           #aof的rewrite操作是否在进行中
aof_rewrite_scheduled:0                             #是否在rdb save操作完成后执行
aof_last_rewrite_time_sec:-1                        #上次rewrite操作使用的时间，单位为秒
aof_current_rewrite_time_sec:-1                     #如果rewrite操作正在进行则记录时间
aof_last_bgrewrite_status:ok                        #上次rewrite操作的状态
aof_last_write_status:ok                            #上次wirte的状态
aof_current_size:8023768                            #aof当前大小
aof_base_size:0                                     #aof启动或者rewrite大小
aof_pending_rewrite:0                               #是否在rdb save操作完成后执行
aof_buffer_length:0                                 #aof buffer大小
aof_rewrite_buffer_length:0                         #aof rewrite buff大小
aof_pending_bio_fsync:0                             #后台IO队列中等待fsync的个数
aof_delayed_fsync:0                                 #延迟fsync计数器

# Stats
total_connections_received:246259                   #总计连接请求
total_commands_processed:1180958                    #总结执行命令
instantaneous_ops_per_sec:49                        #每秒执行个数                     
rejected_connections:0                              #因最大客户端限制而被拒绝连接的个数
sync_full:1
sync_partial_ok:0
sync_partial_err:0
expired_keys:0                                      #总过期key数量
evicted_keys:0                                      #总删除key数量
keyspace_hits:338581                                #查到key的数量
keyspace_misses:66475                               #未查到的key数量
pubsub_channels:0                                   #发布/订阅频道数
pubsub_patterns:0                                   #发布/订阅模式数
latest_fork_usec:2805                               #上次的fork操作使用的时间（单位ms）

# Replication
role:master                                             #角色，这里为master
connected_slaves:1                                      #有几个连接的slvae
slave0:ip=192.168.1.50,port=6379,state=online,offset=8087699,lag=0  #slave连接详细信息
master_repl_offset:8087752
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:7039177
repl_backlog_histlen:1048576

# CPU
used_cpu_sys:94.98                                      #redis server的sys cpu使用率
used_cpu_user:36.71                                     #redis server的user cpu使用率
used_cpu_sys_children:0.47                              #后台进程的sys cpu使用率
used_cpu_user_children:0.04                             #后台进程的user cpu使用率

# Keyspace
db0:keys=12,expires=0,avg_ttl=0                             #db0数据库，一共有多少个key，过期key，带生存期