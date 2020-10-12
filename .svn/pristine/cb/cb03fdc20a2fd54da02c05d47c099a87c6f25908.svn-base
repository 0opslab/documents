---
title: Spark之Java编程
date: 2018-06-20 21:52:03
tags: spark
---
Spark是一个用来实现快速而通用的集群计算的平台。扩展了广泛使用的MapReduce计算模型，而且高效地支持更多的计算模式，包括交互式查询和流处理。在处理大规模数据集的时候，速度是非常重要的。Spark的一个重要特点就是能够在内存中计算，因而更快。即使在磁盘上进行的复杂计算，Spark依然比MapReduce更加高效。

### Spark运行模式
Spark运行模式中Hadoop YARN的集群方式最为常用的方式，目前Spark的运行模式主要有以下几种:
* local
	主要用于开发调试Spark应用程序
* Standlone
	利用Spark自带的资源管理与调度器运行Spark集群，采用Master/Slave结构，为解决单点故障，可以采用Xookeeper实现高可靠(High Availability, HA)
* Apache Mesos
	运行在著名的Mesos资源管理框架基础之上，该集群运行模式将资源管理管理交给Mesos,Spark只负责运行任务调度和计算
* Hadoop YARN
	集群运行在Yarn资源管理器上，资源管理交给YARN，Spark只负责进行任务调度和计算

### Spark的组成
Spark已经发展成为包含众多子项目的大数据计算平台。伯克利将Spark的整个生态系统称为伯克利数据分析栈（BDAS）。其核心框架是Spark，同时BDAS涵盖支持结构化数据SQL查询与分析的查询引擎Spark SQL和Shark，提供机器学习功能的系统MLbase及底层的分布式机器学习库MLlib、并行图计算框架GraphX、流计算框架Spark Streaming、采样近似计算查询引擎BlinkDB、内存分布式文件系统Tachyon、资源管理框架Mesos等子项目	

#### spark core
Spark Core是Spark的核心组件，其基于核心的RDD(Resilient Distributed DataSet  弹性分布式数据集)抽象，提供了分布式作业分发、调度及丰富的RDD操作，这些操作通过Java、Python、Scala、R语言接口暴露。RDD是分布于集群各节点上的、不可变的弹性数据集，容纳的是Java/Python/Scala/R的对象实例。Spark定义了RDD之上的两种操作：Transformation和Action，RDD上运行一个操作之后，生成另一个RDD或者执行某些动作。

#### Spark Streaming
Spark Streaming基于Spark的计算性能进行流式的分析，将流式数据根据时间切分为小批量的数据（RDD），并在RDD上执行Transformation、Action操作完成分析。这种方式使得现有的很多批处理代码可以直接工作在流式处理的模式下。但是这种模式以牺牲一定的延时为代价，相比于其他基于事件或者消息的流式处理框架（Storm，Samza，Flink），延时比较大。Spark Streaming内置支持来自Kafka，Flume，ZeroMQ，Kinesis，Twitter，TCP/IP Socket的数据。

#### Spark SQL
Spark SQL引入了称为DataFrames的数据抽象，提供对结构化和半结构化数据操作的支持。Spark提供了一套DSL用于DataFrame的操作，DSL可以通过Scala，Java，Python来表示。同时Spark SQK提供了对标准SQL语言的支持，包括命令行接口和ODBC/JDBC支持（驱动）

#### MLib
MLib是基于Spark的机器学习框架，由于Spark的分布式内存框架,其实现的常用算法包括 概要统计、分类和回归、协同过滤、聚类分析、降维、特征提取与转换函数。

#### GraphX
GraphX则是基于Spark的分布式图处理框架，对标到Hadoop体系下基于MapReduce（因此基于磁盘）的图处理框架Giraph.由于RDD是不可变的，因此GraphX不适合需要更新操作的场景。GraphX提供了两套API，一套类似于Google Pregel提供的API，另一套则更像是MapReduce的风格。

### Spark的代码结构
* scheduler：文件夹中含有负责整体的Spark应用、任务调度的代码。
* broadcast：含有Broadcast（广播变量）的实现代码，API中是Java和Python API的实
* deploy：含有Spark部署与启动运行的代码。
* common：不是一个文件夹，而是代表Spark通用的类和逻辑实现，有5000行代码。
* metrics：是运行时状态监控逻辑代码，Executor中含有Worker节点负责计算的逻辑代码。
* partial：含有近似评估代码。
* network：含有集群通信模块代码。
* serializer：含有序列化模块的代码。
* storage：含有存储模块的代码。
* ui：含有监控界面的代码逻辑。其他的代码模块分别是对Spark生态系统中其他组件的实现。
* streaming：是Spark Streaming的实现代码。
* YARN：是Spark on YARN的部分实现代码。
* graphx：含有GraphX实现代码。
* interpreter：代码交互式Shell的代码量为3300行。
* mllib：代表MLlib算法实现的代码量。
* sql代表Spark SQL的代码量

### Spark的工作流程
Spark的整体流程为：Client提交应用，Master找到一个Worker启动Driver，Driver向Master或者资源管理器申请资源，之后将应用转化为RDD Graph，再由DAGScheduler将RDD Graph转化为Stage的有向无环图提交给TaskScheduler，由TaskScheduler提交任务给Executor执行。在任务执行的过程中，其他组件协同工作，确保整个应用顺利执行。

### Java SparkCore编程
Spark提供了Java编程接口,通常可以先获取JavaSparkContext,让过创建RDD对象，然后执行响应的操作即可。可以通过Maven加入如下配置
```xml
<dependency>  
    <groupId>org.apache.spark</groupId>  
    <artifactId>spark-core_2.11</artifactId>  
    <version>2.0.2</version>  
</dependency>  
```
然后按照如下模式进行相关的业务代码开发
```java
import org.apache.spark.SparkConf;  
import org.apache.spark.api.java.JavaRDD;  
import org.apache.spark.api.java.JavaSparkContext;  
  
public class HelloSpark {  
      
    public static void main(String[] args) {  
    	// 1 创建一个sparkconf 对象并配置
		// 使用setMaster 可以设置spark集群可以链接集群的URL，如果设置local 代表在本地运行而不是在集群运行
        SparkConf conf = new SparkConf().setMaster("local").setAppName("HelloSpark");

        // 2 创建javasparkContext对象
		// sparkcontext 是一个入口，主要作用就是初始化spark应用程序所需的一些核心组件，例如调度器，task，
		// 还会注册spark，sparkMaster结点上注册。  
        try (JavaSparkContext jsc = new JavaSparkContext(conf)) { 


            // 3do something here  
        }  
    }  
  
} 
```
完成本地测试后可以到响应的程序，提交至spark中运行，通过可以编写响应的脚本
```bash
/opt/spark/bin/spark-submit \                    # 用这个命令启动
--class com.xxx.HelloSpark \    # 配置类名
--num-executors 3 \                              # 配置在三个结点上运行
--driver-memory 100m \                           # drive内存
--executor-memory 100m \                         # 配置execute内存
--executor-cores 3 \                             # 内核运行单元数
/opt/spark-script/java/HelloSpark-0.0.1-SNAPSHOT.jar \     # 运行的jar包
```
下面是一个使用spark进行词汇统计的小程序
```java
package com.opslab.spark;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.api.java.function.FlatMapFunction;
import org.apache.spark.api.java.function.Function2;
import org.apache.spark.api.java.function.PairFunction;
import org.apache.spark.api.java.function.VoidFunction;
import scala.Tuple2;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;

public class _01WordCount {
    public static void main(String[] args) {

        SparkConf conf = new SparkConf().setMaster("local").setAppName("WordCount");
        try (JavaSparkContext jsc = new JavaSparkContext(conf)) {
            /*
             * 第3步：根据具体的数据来源（HDFS、HBase、Local FS、DB、S3等）通过SparkContext来创建RDD
             * JavaRDD的创建基本有三种方式：根据外部的数据来源（例如HDFS）、根据Scala集合、由其它的RDD操作
             * 数据会被JavaRDD划分成为一系列的Partitions，分配到每个Partition的数据属于一个Task的处理范畴
             */
            JavaRDD<String> lines = jsc.textFile("D:/workspace/opslabSpark/resources/README.md");
            /*
             * 第4步：对初始的JavaRDD进行Transformation级别的处理，例如map、filter等高阶函数等的编程，来进行具体的数据计算
             * 第4.1步：讲每一行的字符串拆分成单个的单词
             */

            JavaRDD<String> words = lines.flatMap(new FlatMapFunction<String, String>() {
                @Override
                public Iterator<String> call(String s) throws Exception {
                    return (new ArrayList<String>(Arrays.asList(s.split(" ")))).iterator();
                }
                //如果是scala由于Sam转化所以可以写成一行代码

            });

            /*
             * 第4步：对初始的JavaRDD进行Transformation级别的处理，例如map、filter等高阶函数等的编程，来进行具体的数据计算
             * 第4.2步：在单词拆分的基础上对每个单词实例计数为1，也就是word => (word, 1)
             */

            JavaPairRDD<String, Integer> pairs = words.mapToPair(new PairFunction<String, String, Integer>() {
                @Override
                public Tuple2<String, Integer> call(String word) throws Exception {
                    // TODO Auto-generated method stub
                    return new Tuple2<String, Integer>(word, 1);
                }
            });

            /*
             * 第4步：对初始的RDD进行Transformation级别的处理，例如map、filter等高阶函数等的编程，来进行具体的数据计算
             * 第4.3步：在每个单词实例计数为1基础之上统计每个单词在文件中出现的总次数
             */

            JavaPairRDD<String, Integer> wordsCount = pairs.reduceByKey(new Function2<Integer, Integer, Integer>() {
                 //对相同的Key，进行Value的累计（包括Local和Reducer级别同时Reduce）
                @Override
                public Integer call(Integer v1, Integer v2) throws Exception {
                    // TODO Auto-generated method stub
                    return v1 + v2;
                }

            });

            wordsCount.foreach(new VoidFunction<Tuple2<String, Integer>>() {
                @Override
                public void call(Tuple2<String, Integer> pairs) throws Exception {
                    // TODO Auto-generated method stub
                    System.out.println(pairs._1 + " : " + pairs._2);
                }

            });

            // 5. 结果输出
            // 5.1 结果输出到HDFS
            //wordsCount.saveAsTextFile("D:/workspace/opslabJava/spark/out/sparkout/wordcount");

            // 单独出来结果集
            wordsCount.foreachPartition(new VoidFunction<java.util.Iterator<Tuple2<String, Integer>>>() {
                @Override
                public void call(Iterator<Tuple2<String, Integer>> tuple2Iterator) throws Exception {
                    Tuple2<String, Integer> t2 = tuple2Iterator.next();
                    System.out.println(t2._1());
                    System.out.println(t2._2());

                }
            });

        }
    }
}

```
### RDD算子
RDD支持两种类型的算子（operation）：transformation算子 和 action算子
transformation算子可以将已有RDD转换得到一个新的RDD，而action算子则是基于数据集计算，并将结果返回给驱动器（driver）。例如，map是一个transformation算子，它将数据集中每个元素传给一个指定的函数，并将该函数返回结果构建为一个新的RDD；而 reduce是一个action算子，它可以将RDD中所有元素传给指定的聚合函数，并将最终的聚合结果返回给驱动器（还有一个reduceByKey算子，其返回的聚合结果是一个数据集）。

Spark中所有transformation算子都是懒惰的，也就是说，这些算子并不立即计算结果，而是记录下对基础数据集（如：一个数据文件）的转换操作。只有等到某个action算子需要计算一个结果返回给驱动器的时候，transformation算子所记录的操作才会被计算。这种设计使Spark可以运行得更加高效 – 例如，map算子创建了一个数据集，同时该数据集下一步会调用reduce算子，那么Spark将只会返回reduce的最终聚合结果（单独的一个数据）给驱动器，而不是将map所产生的数据集整个返回给驱动器。默认情况下，每次调用action算子的时候，每个由transformation转换得到的RDD都会被重新计算。然而，你也可以通过调用persist（或者cache）操作来持久化一个RDD，这意味着Spark将会把RDD的元素都保存在集群中，因此下一次访问这些元素的速度将大大提高。同时，Spark还支持将RDD元素持久化到内存或者磁盘上，甚至可以支持跨节点多副本。

##### 转换算子 – transformation
以下是Spark支持的一些常用transformation算子。详细请参考 RDD API doc (Scala, Java, Python, R) 以及 键值对 RDD 函数 (Scala, Java) 。Java的相关API可以查阅http://spark.apache.org/docs/latest/api/java/index.html
* map(func)   
    返回一个新的分布式数据集，其中每个元素都是由源RDD中一个元素经func转换得到的。
* filter(func)    
    返回一个新的数据集，其中包含的元素来自源RDD中元素经func过滤后（func返回true时才选中）的结果
* flatMap(func)   
    类似于map，但每个输入元素可以映射到0到n个输出元素（所以要求func必须返回一个Seq而不是单个元素）
* mapPartitions(func) 
    类似于map，但基于每个RDD分区（或者数据block）独立运行，所以如果RDD包含元素类型为T，则 func 必须是 Iterator<T> => Iterator<U> 的映射函数。
* mapPartitionsWithIndex(func)    
    类似于 mapPartitions，只是func 多了一个整型的分区索引值，因此如果RDD包含元素类型为T，则 func 必须是 Iterator<T> => Iterator<U> 的映射函数。
* sample(withReplacement, fraction, seed) 
    采样部分（比例取决于 fraction ）数据，同时可以指定是否使用回置采样（withReplacement），以及随机数种子(seed)
* union(otherDataset) 
    返回源数据集和参数数据集（otherDataset）的并集
* intersection(otherDataset)  
    返回源数据集和参数数据集（otherDataset）的交集
* distinct([numTasks]))   
    返回对源数据集做元素去重后的新数据集
* groupByKey([numTasks])  
    只对包含键值对的RDD有效，如源RDD包含 (K, V) 对，则该算子返回一个新的数据集包含 (K, Iterable<V>) 对。
    注意：如果你需要按key分组聚合的话（如sum或average），推荐使用 reduceByKey或者 aggregateByKey 以获得更好的性能。
    注意：默认情况下，输出计算的并行度取决于源RDD的分区个数。当然，你也可以通过设置可选参数 numTasks 来指定并行任务的个数。
* reduceByKey(func, [numTasks])   
    如果源RDD包含元素类型 (K, V) 对，则该算子也返回包含(K, V) 对的RDD，只不过每个key对应的value是经过func聚合后的结果，而func本身是一个 (V, V) => V 的映射函数。
    另外，和 groupByKey 类似，可以通过可选参数 numTasks 指定reduce任务的个数。
* aggregateByKey(zeroValue)(seqOp, combOp, [numTasks])    
    如果源RDD包含 (K, V) 对，则返回新RDD包含 (K, U) 对，其中每个key对应的value都是由 combOp 函数 和 一个“0”值zeroValue 聚合得到。允许聚合后value类型和输入value类型不同，避免了不必要的开销。和 groupByKey 类似，可以通过可选参数 numTasks 指定reduce任务的个数。
* sortByKey([ascending], [numTasks])  
    如果源RDD包含元素类型 (K, V) 对，其中K可排序，则返回新的RDD包含 (K, V) 对，并按照 K 排序（升序还是降序取决于 ascending 参数）
* join(otherDataset, [numTasks])  
    如果源RDD包含元素类型 (K, V) 且参数RDD（otherDataset）包含元素类型(K, W)，则返回的新RDD中将包含内关联后key对应的 (K, (V, W)) 对。外关联(Outer joins)操作请参考 leftOuterJoin、rightOuterJoin 以及 fullOuterJoin 算子。
* cogroup(otherDataset, [numTasks])   
    如果源RDD包含元素类型 (K, V) 且参数RDD（otherDataset）包含元素类型(K, W)，则返回的新RDD中包含 (K, (Iterable<V>, Iterable<W>))。该算子还有个别名：groupWith
* cartesian(otherDataset) 
    如果源RDD包含元素类型 T 且参数RDD（otherDataset）包含元素类型 U，则返回的新RDD包含前二者的笛卡尔积，其元素类型为 (T, U) 对。
* pipe(command, [envVars])    
    以shell命令行管道处理RDD的每个分区，如：Perl 或者 bash 脚本。
    RDD中每个元素都将依次写入进程的标准输入（stdin），然后按行输出到标准输出（stdout），每一行输出字符串即成为一个新的RDD元素。
* coalesce(numPartitions) 
    将RDD的分区数减少到numPartitions。当以后大数据集被过滤成小数据集后，减少分区数，可以提升效率。
* repartition(numPartitions)  
    将RDD数据重新混洗（reshuffle）并随机分布到新的分区中，使数据分布更均衡，新的分区个数取决于numPartitions。该算子总是需要通过网络混洗所有数据。
* repartitionAndSortWithinPartitions(partitioner) 
    根据partitioner（spark自带有HashPartitioner和RangePartitioner等）重新分区RDD，并且在每个结果分区中按key做排序。这是一个组合算子，功能上等价于先 repartition 再在每个分区内排序，但这个算子内部做了优化（将排序过程下推到混洗同时进行），因此性能更好。
实例
```java
package com.opslab.spark;

import com.google.common.collect.Lists;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.api.java.function.Function;
import org.apache.spark.api.java.function.VoidFunction;

import java.util.List;

public class ApiMap {
    public static void main(String[] args) {
        //演示api函数map
        SparkConf conf = new SparkConf().setMaster("local").setAppName("APIMap");
        try (JavaSparkContext jsc = new JavaSparkContext(conf)) {
            List<Integer> list = Lists.newArrayList(1, 2, 3);

            JavaRDD<Integer> javaRDD = jsc.parallelize(list);

            //对数据集执行map操作，返回一个新的javaRDD
            JavaRDD<Integer> mapRDD = javaRDD.map(new Function<Integer, Integer>() {
                @Override
                public Integer call(Integer integer) throws Exception {
                    return integer * integer;
                }
            });

            //mapRDD.collect();
            mapRDD.foreach(new VoidFunction<Integer>() {
                @Override
                public void call(Integer integer) throws Exception {
                    System.out.println(integer);
                }
            });

            //与上面的方式相同，只是使用了便捷的lambda
            JavaRDD<Integer> mapRDD1 = javaRDD.map(s -> s * s);
            //mapRDD.collect();
            mapRDD1.foreach(new VoidFunction<Integer>() {
                @Override
                public void call(Integer integer) throws Exception {
                    System.out.println(integer);
                }
            });
        }
    }
}

```

##### 转换算子 – action
以下是Spark支持的一些常用action算子。详细请参考 RDD API doc (Scala, Java, Python, R) 以及 键值对 RDD 函数 (Scala, Java) 。
* reduce(func)    
    将RDD中元素按func进行聚合（func是一个 (T,T) => T 的映射函数，其中T为源RDD元素类型，并且func需要满足 交换律 和 结合律 以便支持并行计算）
* collect()   
    将数据集中所有元素以数组形式返回驱动器（driver）程序。通常用于，在RDD进行了filter或其他过滤操作后，将一个足够小的数据子集返回到驱动器内存中。
* count() 
    返回数据集中元素个数
* first() 
    返回数据集中首个元素（类似于 take(1) ）
* take(n) 
    返回数据集中前 n 个元素
* takeSample(withReplacement,num, [seed]) 
    返回数据集的随机采样子集，最多包含 num 个元素，withReplacement 表示是否使用回置采样，最后一个参数为可选参数seed，随机数生成器的种子。
* takeOrdered(n, [ordering])  
    按元素排序（可以通过 ordering 自定义排序规则）后，返回前 n 个元素
* saveAsTextFile(path)    
    将数据集中元素保存到指定目录下的文本文件中（或者多个文本文件），支持本地文件系统、HDFS 或者其他任何Hadoop支持的文件系统。
    保存过程中，Spark会调用每个元素的toString方法，并将结果保存成文件中的一行。
* saveAsSequenceFile(path)
    将数据集中元素保存到指定目录下的Hadoop Sequence文件中，支持本地文件系统、HDFS 或者其他任何Hadoop支持的文件系统。适用于实现了Writable接口的键值对RDD。在Scala中，同样也适用于能够被隐式转换为Writable的类型（Spark实现了所有基本类型的隐式转换，如：Int，Double，String 等）
* saveAsObjectFile(path)
    将RDD元素以Java序列化的格式保存成文件，保存结果文件可以使用 SparkContext.objectFile 来读取。
* countByKey()    
    只适用于包含键值对(K, V)的RDD，并返回一个哈希表，包含 (K, Int) 对，表示每个key的个数。
* foreach(func)   
    在RDD的每个元素上运行 func 函数。通常被用于累加操作，如：更新一个累加器（Accumulator ） 或者 和外部存储系统互操作。
    注意：用 foreach 操作出累加器之外的变量可能导致未定义的行为。更详细请参考前面的“理解闭包”（Understanding closures ）这一小节。
实例
```java
package com.opslab.spark;
import com.google.common.collect.Lists;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.api.java.function.Function2;
import java.util.List;
public class ApiReduce {
    public static void main(String[] args) {
        //演示api函数map
        SparkConf conf = new SparkConf().setMaster("local").setAppName("APIMap");
        try (JavaSparkContext jsc = new JavaSparkContext(conf)) {
            List<Integer> list = Lists.newArrayList(1, 2, 3);

            JavaRDD<Integer> javaRDD = jsc.parallelize(list);

            //对数据集执行map操作，返回一个新的javaRDD
            Integer reduce = javaRDD.reduce(new Function2<Integer, Integer, Integer>() {
                @Override
                public Integer call(Integer integer, Integer integer2) throws Exception {
                    return integer + integer2;
                }
            });
            System.out.println(reduce);
        }
    }
}

```

#### 参考
http://spark.apache.org/docs/latest/rdd-programming-guide.html
http://spark.apache.org/docs/latest/api/java/index.html
http://homepage.cs.latrobe.edu.au/zhe/ZhenHeSparkRDDAPIExamples.html
