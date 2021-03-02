# title{kafka - kafka相关的常用命令}
#!/bin/bash
#func{kafka常用命令}

##以下手动执行
##手动执行
source  /etc/profile

#执行如下命令：
cd /opt/kafka_2.10-0.9.0.1
/opt/kafka_2.10-0.9.0.1/bin/zookeeper-server-start.sh /opt/kafka_2.10-0.9.0.1/config/zookeeper.properties   >/dev/null 2>&1 &

/opt/kafka_2.10-0.9.0.1/bin/kafka-server-start.sh /opt/kafka_2.10-0.9.0.1/config/server.properties   >/dev/null 2>&1 &

##bin/zookeeper-server-start.sh config/zookeeper.properties    >/dev/null 2>&1 &
##bin/kafka-server-start.sh config/server.properties     >/dev/null 2>&1 &

##停止命令
##ps ax | grep -i 'kafka.Kafka' | grep -v grep | awk '{print $1}' | xargs kill

##查看创建的Topic，执行如下命令：
bin/kafka-topics.sh --create --zookeeper 192.168.142.136:2181 --replication-factor 1 --partitions 1 --topic mykafka
##bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test

##列出所有主题
bin/kafka-topics.sh --list --zookeeper 192.168.142.136:2181

##在一个终端，启动Producer，执行如下命令：
bin/kafka-console-producer.sh --broker-list 192.168.142.136:9092  --topic mykafka
##bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test 

##在另一个终端，启动Consumer，执行如下命令：
bin/kafka-console-consumer.sh --zookeeper 192.168.142.136:2181 --topic mykafka --from-beginning
##bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic test --from-beginning

#######confluent启动
cd /opt/confluent-2.0.1/
bin/schema-registry-start etc/schema-registry/schema-registry.properties  >/dev/null 2>&1 &
##停止命令
##ps ax | grep -i 'schema-registry' | grep -v grep | awk '{print $1}' | xargs kill

cd /opt/confluent-2.0.1/
bin/kafka-rest-start etc/kafka-rest/kafka-rest.properties  >/dev/null 2>&1 &
##停止命令
##ps ax | grep -i 'kafka-rest' | grep -v grep | awk '{print $1}' | xargs kill


cat /webapp01/local/kafka/config/server.properties 

export KAFKA_HEAP_OPTS="-server -Xms2G -Xmx2G -XX:PermSize=128m -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=8 -XX:ConcGCThreads=5 -XX:InitiatingHeapOccupancyPercent=70"
export JMX_PORT="9999"
==============================================================================
# zookeeper kafka集群

zookeeper 135.191.107.124:2181,135.191.107.125:2181,135.191.107.126:2181

kafka 135.191.107.124:9092,135.191.107.125:9092,135.191.107.126:9092


=============================================================================
# zookeeper 管理
zkCli.sh -server 127.0.0.1:2181
zkCli.sh -server 135.191.107.124:2181,135.191.107.125:2181,135.191.107.126:2181

权限控制
setAcl / ip:127.0.0.1:cdrwa,ip:135.191.107.124:cdrwa,ip:135.191.107.125:cdrwa,ip:135.191.107.126:cdrwa,ip:135.191.168.68:cdrwa,ip:135.191.168.69:cdrwa

getAcl /

setAcl / ip:127.0.0.1:cdrwa,ip:135.191.27.158:cdrwa,ip:135.191.27.193:cdrwa,ip:135.191.27.195:cdrwa,ip:135.191.168.68:cdrwa,ip:135.191.168.69:cdrwa


/webapp01/local/kafka/bin/zookeeper-shell.sh 135.191.107.124:2181,135.191.107.125:2181,135.191.107.126:2181 delete /broker/ids/3

==============================================================================
# kafka 
启动
/webapp01/local/kafka/bin/kafka-server-start.sh  -daemon /webapp01/local/kafka/config/server.properties

#创建主题
/webapp01/local/kafka/bin/kafka-topics.sh --create --zookeeper 135.191.107.124:2181,135.191.107.125:2181,135.191.107.126:2181 -replication-factor 3 --partitions 3 --topic xwtec-test

#查看主题
/webapp01/local/kafka/bin/kafka-topics.sh --list --zookeeper 135.191.107.124:2181,135.191.107.125:2181,135.191.107.126:2181
/webapp01/local/kafka/bin/kafka-topics.sh --describe --zookeeper 135.191.107.124:2181,135.191.107.125:2181,135.191.107.126:2181 --topic xwtec-test

#启动生产者
/webapp01/local/kafka/bin/kafka-console-producer.sh --broker-list 135.191.107.124:9092,135.191.107.125:9092,135.191.107.126:9092 --topic xwtec-test

#启动消费者
/webapp01/local/kafka/bin/kafka-console-consumer.sh --bootstrap-server 135.191.107.124:9092,135.191.107.125:9092,135.191.107.126:9092 --topic xwtec-test --from-beginning



# 消费者组列表
bin/kafka-consumer-groups.sh --bootstrap-server 135.191.107.124:9092,135.191.107.125:9092,135.191.107.126:9092 --list

bin/kafka-consumer-groups.sh --zookeeper 127.0.0.1:2181  --list

bin/kafka-consumer-groups.sh --bootstrap-server 127.0.0.1:9092  --list


# 消费者组的信息查看
/xwapp/kafka/bin/kafka-consumer-groups.sh  --bootstrap-server 135.191.107.124:9092,135.191.107.125:9092,135.191.107.126:9092 --describe --group 1


# 状态
/webapp01/local/kafka/bin/kafka-topics.sh --describe --zookeeper 135.191.107.124:2181,135.191.107.125:2181,135.191.107.126:2181 --topic xwtec-test


# 消费进度
/xwapp/kafka/bin/kafka-consumer-groups.sh  --bootstrap-server 135.191.27.158:9092,135.191.27.193:9092,135.191.27.195:9092 --describe --group 1


====================================================================
# memcached
/webapp01/local/memcached/memcached -d -l 127.0.0.1 -p 11211 -m 4096





/xwapp/kafka/bin/kafka-topic.sh --list --zookeeper 135.191.27.158:2181,135.191.27.193:2181,135.191.27.195:2181
 
/xwapp/kafka/bin/kafka-topic.sh --describe --zookeeper 135.191.27.158:2181,135.191.27.193:2181,135.191.27.195:2181 --topic appbusinessevent

/xwapp/kafka/bin/kafka-consumer-groups.sh  --bootstrap-server 135.191.27.158:9092,135.191.27.193:9092,135.191.27.195:9092 --list


/xwapp/kafka/bin/kafka-consumer-groups.sh --group 1 --zookeeper 135.191.27.158:2181,135.191.27.193:2181,135.191.27.195:2181 --topic xwtec-test

/xwapp/kafka/bin/kafka-consumer-groups.sh  --bootstrap-server 135.191.27.158:9092,135.191.27.193:9092,135.191.27.195:9092 --describe --group 1


/xwapp/kafka/bin/kafka-consumer-groups.sh  --bootstrap-server 135.191.27.158:9092,135.191.27.193:9092,135.191.27.195:9092 --describe --group 1

/xwapp/kafka/bin/kafka-console-consumer.sh --bootstrap-server 135.191.27.158:9092,135.191.27.193:9092,135.191.27.195:9092 --topic appbusinessevent --from-beginning

/xwapp/kafka/bin/kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list 135.191.27.158:9092,135.191.27.193:9092,135.191.27.195:9092 -topic appbusinessevent --time -2




/xwapp/kafka/bin/kafka-preferred-replica-election.sh --zookeeper 135.191.27.158:2181,135.191.27.193:2181,135.191.27.195:2181


/xwapp/zookeeper/bin/zkCli.sh -server 135.191.27.158:2181,135.191.27.193:2181,135.191.27.195:2181

 set /brokers/topics/appbusinessevent/partitions/8/state {"controller_epoch":20,"leader":2,"version":1,"leader_epoch":1,"isr":[0]}



// add ~/.bashrc
# User specific aliases and functions
kafka_topic(){
        /xwapp/kafka/bin/kafka-topics.sh --list --zookeeper 135.191.27.158:2181,135.191.27.193:2181,135.191.27.195:2181
}


## see topic descrie
kafka_topic_descrie(){
         /xwapp/kafka/bin/kafka-topics.sh  --describe --zookeeper 135.191.27.158:2181,135.191.27.193:2181,135.191.27.195:2181 --topic $1
}


## set kafka_consumer_group
kafka_consumer_group(){
        /xwapp/kafka/bin/kafka-consumer-groups.sh  --bootstrap-server 135.191.27.158:9092,135.191.27.193:9092,135.191.27.195:9092 --list
}

kafka_consumer_group_descrie(){
        /xwapp/kafka/bin/kafka-consumer-groups.sh  --bootstrap-server 135.191.27.158:9092,135.191.27.193:9092,135.191.27.195:9092 --describe --group $1
} 


//kafka配置
broker.id=1
listeners=PLAINTEXT://135.191.107.124:9092
num.network.threads=33
num.io.threads=66
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
log.dirs=/webapp01/data/kafka/kafka-logs
num.partitions=10
num.recovery.threads.per.data.dir=1
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
zookeeper.connect=135.191.107.124:2181,135.191.107.125:2181,135.191.107.126:2181
zookeeper.connection.timeout.ms=6000
group.initial.rebalance.delay.ms=0