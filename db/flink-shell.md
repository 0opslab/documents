Flink提供了一个命令行接口（CLI）用来运行打成JAR包的程序，并且可以控制程序的运行。命令行接口在Flink安装完之后即可拥有，本地单节点或是分布式的部署安装都会有命令行接口。命令行接口启动脚本是 $FLINK_HOME/bin目录下的flink脚本， 默认情况下会连接运行中的Flink master(JobManager)，JobManager的启动脚本与CLI在同一安装目录下。

使用命令行接口的先决条件是JobManager已经被启动或是在Flink YARN环境下。JobManager可以通过如下命令启动:

```bash
$FLINK_HOME/bin/start-local.sh
或
$FLINK_HOME/bin/start-cluster.sh
```

### 常用的命令

```bash
# 运行示例程序，不传参数
$ flink run ./examples/batch/WordCount.jar


# 运行示例程序，带输入或输出文件参数
$ flink run ./examples/batch/WordCount.jar --input file:///home/a.txt --out file:///home2.txt

# 运行示例程序，带输入和输出文件参数,并设置16个并发度
$ flink run -p 16 ./examples/batch/WordCount.jar --input file:///home/a.txt --output file:///home/2.txt

# 运行示例程序，并禁止Flink输出日志
$ flink run -q ./examples/batch/WordCount.jar

# 以独立(detached)模式运行示例程序
$ flink run -d ./examples/batch/WordCount.jar

# 在指定JobManager上运行示例程序
$ flink run -m myJMHost:6123 ./examples/batch/WordCount.jar --input file:///home/a.txt --output file:///home/result.txt

# 运行示例程序，指定程序入口类(Main方法所在类)
$ flink run -c org.apache.flink.examples.java.wordcount.WordCount ./examples/batch/WordCount.jar --input file:///home/a.txt --output file:///home/result.txt

# 运行示例程序，使用per-job YARN 集群启动 2 个TaskManager
$ flink run -m yarn-cluster -yn 2 ./examples/batch/WordCount.jar --input hdfs:///a.txt --output hdfs:///result.txt

# 以JSON格式输出 WordCount示例程序优化执行计划
$ flink info ./examples/batch/WordCount.jar --input file:///home/a.txt --output file:///home/result.txt

```

####  任务管理

```bash
# 列出已经调度的和正在运行的Job(包含Job ID信息)
$ flink list

# 列出已经调度的Job(包含Job ID信息)
$ flink list -s

# 列出正在运行的Job(包含Job ID信息)
$ flink list -r

# 列出在Flink YARN中运行Job
$ flink list -m yarn-cluster -yid <yarnApplicationID> -r

# 取消一个Job
# 取消和停止Job区别如下：
# 调用取消Job时，作业中的operator立即收到一个调用cancel()方法的指令以尽快取消它们。如果operator在调用取消操作后没有停止，Flink将定期开启中断线程来取消作业直到作业停止。
# 调用停止Job是一种停止正在运行的流作业的更加优雅的方法。停止仅适用于使用实现`StoppableFunction`接口的源的那些作业。当用户请求停止作业时，所有源将收到调用stop()方法指令。但是Job还是会持续运行，直到所有来源已经正确关闭。这允许作业完成处理所有正在传输的数据(inflight data)
$ flink cancel <jobID>

# 取消一个带有保存点(savepoint)的Job
$ flink cancel -s [targetDirectory] <jobID>

# 停止一个Job(只适用于流计算Job)
$ flink stop <jobID>

```

### 检查点和保存点

检查点（Checkpoint）机制是 Flink 实现错误容忍机制的核心。通过持续以异步的方式保存轻量级的镜像，当错误（机器、网络或者软件原因）发生时，系统重启操作并重置操作到最新保存成功的检查点。

Flink 检查点需要两个前提：

	* 持久化数据源支持重放（Replay）数据，如 Kafka 和 HDFS
	* 用于持久化状态的存储，如 HDFS 和 RocksDB；

默认情况下，检查点是禁用的，需要手动启用检查点，如下所示

```java
StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
//设置状态存储后端，支持内存、文件系统和 RocksDB
env.setStateBackend(new FsStateBackend(path)); 
//启用检查点并每秒保存一次，单位：毫秒
env.enableCheckpointing(1000); 


//取消时保留检查点
env.getCheckpointConfig().setCheckpointingMode(CheckpointingMode.EXACTLY_ONCE); 

env.getCheckpointConfig().enableExternalizedCheckpoints(CheckpointConfig.ExternalizedCheckpointCleanup.RETAIN_ON_CANCELLATION);
```

保存点通过 Flink 检查点机制保存了任务运行过程中状态的镜像。通常用于停止并恢复、分发和任务更新.如果不指定保存点目录，默认为 `state.savepoints.dir` 配置，可以通过编辑 conf/flink-conf.yml 文件修改：

```xml
state.savepoints.dir: hdfs://RM/user/flink/savepoints  
```

* 常用操作

```bash
# 触发保存点
$ bin/flink savepoint <任务 ID> [<保存点目录>] -yid <YARN 应用 ID>

# 取消时触发保存点
$ bin/flink cancel -s [<保存点目录>] <任务 ID> -yid <YARN 应用 ID> 

# 从保存点恢复运行
$ bin/flink run -s <保存点目录> -c <主类> -m <JM 地址> -p <并发数> app.jar 
```