# title{flume - flume相关的一些知识概要}
Flume是Cloudera提供的一个高可用的，高可靠的，分布式的海量日志采集、聚合和传输的系统，Flume支持在日志系统中定制各类数据发送方，用于收集数据；同时，Flume提供对数据进行简单处理，并写到各种数据接受方（可定制）的能力。当前Flume有两个版本Flume 0.9X版本的统称Flume-og，Flume1.X版本的统称Flume-ng。由于Flume-ng经过重大重构，与Flume-og有很大不同。



#### 优势

 Flume可以将应用产生的数据存储到任何集中存储器中，比如HDFS,HBase。当收集数据的速度超过将写入数据的时候，也就是当收集信息遇到峰值时，这时候收集的信息非常大，甚至超过了系统的写入数据能力，这时候，Flume会在数据生产者和数据收容器间做出调整，保证其能够在两者之间提供平稳的数据.



#### 结构

Flume的核心是agent，把数据从数据源source收集过来，在将收集到的数据发送到指定的目的地sink。为了保证传送过程一定成功，在到sink之前，会先缓存数据channel，等待sink成功后，flume再自己删除缓存的数据。

flume以agent为最小的独立运行单位，一个agent就是一个JVM，它是一个完整的数据收集工具，含有三个核心组件，分别是source、channel、sink。

* source 数据源：数据的收集端，负责将数据铺货后进行特殊的格式化，将数据封装到事件event里，然将将时间推入一个或多个channel中，flume提供了很多内置的source。

    | avro                                      | 监听Avro端口并接收Avro Client的流数据                     |
    | ----------------------------------------- | --------------------------------------------------------- |
    | thrift                                    | 监听Thrift端口并接收Thrift Client的流数据                 |
    | exec                                      | 基于Unix的command在标准输出上生产数据                     |
    | jms                                       | 从JMS（Java消息服务）采集数据                             |
    | spooldir                                  | 监听指定目录                                              |
    | KafkaSource                               | 采集Kafka topic中的message                                |
    | netcat                                    | 监听端口（要求所提供的数据是换行符分隔的文本）            |
    | seq                                       | 序列产生器，连续不断产生event，用于测试                   |
    | syslogtcp、syslogudp、multiport_syslogtcp | 采集syslog日志消息，支持单端口TCP、多端口TCP和UDP日志采集 |
    | http                                      | 接收HTTP POST和GET数据                                    |

    

* channel 数据通道。一种短暂的存储容器，负责数据的存储持久化，可以持久化到jdbc、file、memory。

    | memory                 | Event数据存储在内存中                                        |
    | ---------------------- | ------------------------------------------------------------ |
    | jdbc                   | Event数据存储在持久化存储中，当前Flume Channel内置支持Derby  |
    | file                   | Event数据存储在磁盘文件中                                    |
    | SPILLABLEMEMORY        | Event数据存储在内存中和磁盘上，当内存队列满了，会持久化到磁盘文件（当前试验性的，不建议生产环境使用） |
    | PseudoTxnMemoryChannel | 测试用途                                                     |
    | KafkaChannel           | Event存储在kafka集群                                         |
    | Custom                 | 自定义Channel实现                                            |

    通道选择器：设置从source到多个channel的过滤数据，默认是replicating

    | replicating  | 默认管道选择器: 每一个管道传递的都是相同的events             |
    | ------------ | ------------------------------------------------------------ |
    | multiplexing | 多路复用通道选择器: 依据每一个event的头部header的地址选择管道 |
    | Custom       | 自定义selector实现                                           |

    

* sink 数据沉淀；负责数据的转发，将数据存储到集中存储器，比如HBASE、和HDFS，它从channel消费数据events并将器传递给目标地。目标地也可以是其他的agent的source。

    | avor        | 数据被转换成Avro Event，然后发送到配置的RPC端口上   |
    | ----------- | --------------------------------------------------- |
    | thrift      | 数据被转换成Thrift Event，然后发送到配置的RPC端口上 |
    | hive        | 数据导入到HIVE中                                    |
    | logger      | 数据写入日志文件                                    |
    | hdfs        | 数据写入HDFS                                        |
    | KafkaSink   | 数据写到Kafka Topic                                 |
    | hbase       | 数据写入HBase数据库                                 |
    | null        | 丢弃到所有数据                                      |
    | DatasetSink | 写数据到Kite Dataset，试验性质的                    |
    | Custom      | 自定义Sink实现                                      |

    ### flume用法

    * **an agent flow**：简单一个agent流程。
    * **multi-agent flow**：多个agent顺序连接。
    * **Consolidation**：多个agent的数据汇聚到同一个agent。
    * **Multiplexing flow**：多级流。





#### links

监控flume https://www.jianshu.com/p/c3dcb247a475


cd /opt/apache-flume-1.6.0-bin
bin/flume-ng agent -c conf/ -f conf/tail_kafka.conf -n a1 -Dflume.root.logger=INFO,console  >/dev/null 2>&1 &


##在一个终端，启动Consumer，执行如下命令：
bin/kafka-console-consumer.sh --zookeeper 192.168.142.136:2181 --topic mykafka --from-beginning

##访问NGINX的域名
curl  test_kafka.flume.com
##生成NGINX的日志会在Consumer显示出来

##停止命令
##ps ax | grep -i 'kafka-rest' | grep -v grep | awk '{print $1}' | xargs kill
