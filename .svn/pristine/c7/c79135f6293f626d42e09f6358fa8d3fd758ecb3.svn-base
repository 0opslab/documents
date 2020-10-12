### kafka常见问题解答

**kafka的版本问题**

kafka没有提供version命令，不确定是否有方便的方法，但你可以进入kafka/libs文件夹。你应该看到像kafka_2.10-0.8.2-beta.jar这样的文件，其中2.10是Scala版本，0.8.2-beta是Kafka版本。

### 常用命令

```bash
# 列出集群里的所有主题
kafka-topics.sh --zookeeper localhost:2181 --list

#创建一个叫作my-topic的主题,主题包含3分区,每个分区拥有两个副本
kafka-topics.sh --zookeeper localhost:2181 --create --topic my-topic --replication-factor 2 --partitions 3

# 列出集群里所有主题的详细信息
kafka-topics.sh --zookeeper localhost:2181 --describe

# 列出集群里特定主题的详细信息
kafka-topics.sh --zookeeper localhost:2181 --describe  --topic my-topic


# 删除一个叫作my-topic的主题
kafka-topics.sh --zookeeper localhost:2181 --delete  --topic my-topic

# 列出旧版本的所有消费者群组
kafka-consumer-groups.sh --zookeeper localhost:2181 --list

# 列出新版本的所有消费者群组
kafka-consumer-groups.sh --new-consumer --bootstrap-server 172.21.50.162:9092 --list


# 获取旧版本消费者群组testgroup的详细信息
kafka-consumer-groups.sh --zookeeper localhost:2181 --describe --group testgroup

# 获取新版本消费者群组testgroup的详细信息
kafka-consumer-groups.sh --new-consumer --bootstrap-server 172.21.50.162:9092 --describe --group testgroup

# 查看某一个topic对应的消息数量
kafka-run-class.sh  kafka.tools.GetOffsetShell --broker-list 172.21.50.162:9092 --topic my-topic --time -1


# 查看log日志片段的内容,显示查看日志的内容
kafka-run-class.sh kafka.tools.DumpLogSegments --files 00000000000000000000.log --print-data-log


# 控制台生产者:向主题 my-topic 生成两个消息
kafka-console-producer.sh --broker-list localhost:9092 --topic my-topic

# 控制台消费者:从主题 my-topic 获取消息
kafka-console-consumer.sh --zookeeper localhost:2181  --topic my-topic --from-beginning
kafka-console-consumer.sh --new-consumer --bootstrap-server 172.21.50.162:9092  --topic my-topic --from-beginning


# 平衡leader
bin/kafka-preferred-replica-election.sh --zookeeper zk_host:port/chroot


# 为topic t_cdr 增加10个分区
bin/kafka-topics.sh --zookeeper node01:2181  --alter --topic t_cdr --partitions 10

```

