# title{spark - }
Spark是一个实现快速通用的集群计算平台。它的产生为了解决MapReduce的计算引擎缓慢的问题。Spark是MapReduce的替代方案，而且兼容HDFS、Hive可融入Hadoop的生态系统，以弥补MapReduce的不足。Spark使用最先进的DAG调度程序，查询优化程序和物理执行引擎，实现批量和流式数据的高性能。

另外Spark支持Java、Python和scala的API，还支持超过80中高级算法，使用户可以快速构建不同的应用，而且spark支持交互式的Python的Scala的shell，可以非常方便地在这些shell中使用spark集群来验证解决问题的方法。

什么集群部署，分布式环境，依赖于Hadoop集群，感觉挺唬人的。然而只是要单单的进行开发的环境的搭建的话，其实操作还是蛮简单的。以下部署方式之针对windows平台。如果是Linux平台会更加简单。

### winutils 安装配置

首先声明不需要安装hadoop，只是简单的进行winutils的配置即可。到如下网址进行下载对应的winutils

https://github.com/steveloughran/winutils

下载好根据要安装的spark依赖的hadoop选择对应的版本然后在windows中配置如下环境

```bat
//配置HADOOP_HOME
HADOOP_HOME=C:\local\hadoop-2.7.1
//配置Path(win10中这块终于可以分开写了，不用写一行了)
C:\local\hadoop-2.7.1\bin
```

### spark安装配置

选择要下载的spark，然后将其复制的到看着比较顺眼的地方，比如C:\local\spark下然后进行环境配置

```bat
//配置spark home
SPARK_HOME=C:\local\spark
//配置path
C:\local\spark\
```

完成以上操作，单机的spark开发环境已经完成了。接下来就是学习spark的开始了。当然如果你不是JavaDog的话，你还需要安装JDK。另外很多人和很多教程都是以scala进行教学和实验的。当然如果你想学的也是可以，但是python也学是一种更好的选择。

另外次数你写程序submit的时候发现有很多提示信息，然后很多看着其实并没那么有用，如果你想修改的话，可以到spark的conf目录下将log4j.properties.template复制为log4j.properties修改如下保存即可

```pro
log4j.rootCategory=INFO, console
log4j.rootCategory=WARN, console

```




### spark的组成

Spark组成(BDAS)：全称伯克利数据分析栈，通过大规模集成算法、机器、人之间展现大数据应用的一个平台。也是处理大数据、云计算、通信的技术解决方案。

它的主要组件有：

**SparkCore**：将分布式数据抽象为弹性分布式数据集（RDD），实现了应用任务调度、RPC、序列化和压缩，并为运行在其上的上层组件提供API。

**SparkSQL**：Spark Sql 是Spark来操作结构化数据的程序包，可以让我使用SQL语句的方式来查询数据，Spark支持 多种数据源，包含Hive表，parquest以及JSON等内容。

**SparkStreaming**： 是Spark提供的实时数据进行流式计算的组件。

**MLlib**：提供常用机器学习算法的实现库。

**GraphX**：提供一个分布式图计算框架，能高效进行图计算。

**BlinkDB**：用于在海量数据上进行交互式SQL的近似查询引擎。

**Tachyon**：以内存为中心高容错的的分布式文件系统。



### spark的编程套路

 * 1. 获取编程入口(SparkContext/SQLContext/HiveContext/StreamingContext)
   2. 通过编程入库加载数据(RDD/DataFrame/DataSet)
   3. 对数据进行处理得到结果(常用的算子)
   4. 对结果进行处理(打印储存)

#### RDD已经常用操作

Spark中的RDD就是一个不可变的分布式对象集合，每个RDD都被分为多个分区，这些分区运行在集群中的不同节点上，用户可以使用俩种方式创建RDD:读取一个外部数据集，或在驱动器程序里发布驱动器程序中的对象集合。创建了RDD后支持俩种类型的操作：转换操作(transformation)和行动操作(action)。转换操作会由一个RDD生成一个新的RDD，如果filter函数，action操作会对RDD计算出一个结果，并把结果返回到驱动器程序中，或把结果存储到外部存储系统如HDFS中，比如first函数。



### spark的数据读取与存储

#### textFile 创建RDD

常规来看可有分为俩个维度，文件格式和文件系统：

* 文件格式： Text文件，Json文件，Sequence文件和Object文件
* 文件系统： Linux文本文件系统、HDFS、HBase、MySQL数据库

textFile 的参数是一个path,这个path可以是：
1. 一个文件路径，这时候只装载指定的文件
2. 一个目录路径，这时候只装载指定目录下面的所有文件（不包括子目录下面的文件）  (ps,这个没有测试通过，应该是错误的)
3. 通过通配符的形式加载多个文件或者加载多个目录下面的所有文件

```python
#一个文件路径，这时候只装载指定的文件
input_data_path = "hdfs://localhost:9002/input/2017-11-01.txt"  
#这个报错，没有测试通过  —— 一个目录路径，这时候只装载指定目录下面的所有文件（不包括子目录下面的文件）
input_data_path = "hdfs://localhost:9002/input"  
#通过通配符的形式加载多个文件或者加载多个目录下面的所有文件
input_data_path = "hdfs://localhost:9002/input/*"   
```



##### sequence文件

sequence序列化文件针对key-value类型的RDD

```python
sc.makeRDD(Array((1,2),(3,4),(5,6)))
sc.sequenceFile[Int,Int]("/opt/module/spark/seqFile")
```

##### Object文件

对象文件是将对象序列化后保存到文件，采用Java的序列化机制

```python
sc.makeRDD(Array(1,2,3,4,5))
rdd.saveAsObjectFile("/opt/module/spark/objectFile")
sc.objectFile[Int]("/opt/module/spark/objectFile")
```

#### Spark常引用函数

spark的函数主要分俩类，Transformations和Actions。transformations为一些数据转换类函数，actions为一些行动函数：

* 转换 转换的返回值是一个新的RDD集合，而不是单个值，调用有一个变换方法，不会有任何求值计算，它只获取一个RDD作为参数，然后返回一个新的RDD
* 行动 行动操作计算并返回一个新的值。当在一个RDD对象上调用行动函数时，会在这一时刻计算全部的数据处理查询并返回结果值。

### 转换函数

* map(func [,*preservesPartitioning=False*])  返回一个新的分布式数据集，这个数据集中的每个元素都经过func函数处理过的。
* filter(func) 返回有一个新的数据集，这个数据集中的元素是通过func函数筛选后返回为true的元素
* flatMap(func )类似于map(func)， 但是不同的是map对每个元素处理完后返回与原数据集相同元素数量的数据集，而flatMap返回的元素数不一定和原数据集相同
* **mapPartitions**(func [, *preservesPartitioning=False]*)mapPartitions是map的一个变种。map的输入函数是应用于RDD中每个元素，而mapPartitions的输入函数是应用于每个分区，也就是把每个分区中的内容作为整体来处理的。
* **mapPartitionsWithIndex**
* **reduceByKey**
* **sortByKey**
* **join**
* **cartesian**

####  行动函数

* reduce(func) reduce将RDD中元素两两传递给输入函数，同时产生一个新的值，新产生的值与RDD中下一个元素再被传递给输入函数直到最后只有一个值为止
* collect()  返回RDD中的数据，以list形式。
* count() 返回RDD中的元素个数。
* first()  返回RDD中的第一个元素。
* take() 返回RDD中前n个元素。
* takeOrdered() 返回RDD中前n个元素，但是是升序(默认)排列后的前n个元素，或者是通过key函数指定后的RDD
* saveAsTextFile() 该函数将RDD保存到文件系统里面，并且将其转换为文件行的文件中的每个源色调用tostring方法。
* countByKey() 返回一个字典（key,count），该函数操作数据集为kv形式的数据，用于统计RDD中拥有相同key的元素个数。
* countByValue() 返回一个字典（value,count），该函数操作一个list数据集，用于统计RDD中拥有相同value的元素个数。
* foreach() 运行函数func来处理RDD中的每个元素，这个函数常被用来updating an Accumulator或者与外部存储系统的交互









































