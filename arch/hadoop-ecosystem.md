title： Hadoop生态圈的那些让人头疼的技术和软件



Hadoop真的那么优秀吗？貌似是站在了巨人的肩膀上了。Hadoop的核心是YARN\HDFS和Mapreduce。当在其核心的基础上衍生和诞生并时刻诞生着，很多组件算法，总会那么的让人感觉无措下手。



### HDFS

HDFS是Hadoop体系中数据存储管理的基础。它是一个高度容错的系统，能检测和应对硬件故障，用于在低成本的通用硬件上运行。HDFS简化了文件的一致性模型，通过流式数据访问，提供高吞吐量应用程序数据访问功能，适合带有大型数据集的应用程序。它提供了一次写入多次读取的机制，数据以块的形式，同时分布在集群不同物理机器上。



### MapReduce

MapReduce是一种分布式计算模型，用以进行大数据量的计算。它屏蔽了分布式计算框架细节，将计算抽象成map和reduce两部分，其中Map对数据集上的独立元素进行指定的操作，生成键-值对形式中间结果。Reduce则对中间结果中相同“键”的所有“值”进行规约，以得到最终结果。MapReduce非常适合在大量计算机组成的分布式并行环境里进行数据处理。



### 衍生出的那些并大厂使用的组件

#### HBASE分布式列存储数据库

HBase是一个建立在HDFS之上，面向列的针对结构化数据的可伸缩、高可靠、高性能、分布式和面向列的动态模式数据库。HBase采用了BigTable的数据模型：增强的稀疏排序映射表（Key/Value），其中，键由行关键字、列关键字和时间戳构成。HBase提供了对大规模数据的随机、实时读写访问，同时，HBase中保存的数据可以使用MapReduce来处理，它将数据存储和并行计算完美地结合在一起。



#### HIVE 数据仓库

Hive定义了一种类似SQL的查询语言(HQL),将SQL转化为MapReduce任务在Hadoop上执行。通常用于离线分析。HQL用于运行存储在Hadoop上的查询语句，Hive让不熟悉MapReduce开发人员也能编写数据查询语句，然后这些语句被翻译为Hadoop上面的MapReduce任务。



#### SPRAK

Spark是一个Apache项目，它被标榜为“快如闪电的集群计算”。它拥有一个繁荣的开源社区，并且是目前最活跃的Apache项目。最早Spark是UC Berkeley AMP lab所开源的类Hadoop MapReduce的通用的并行计算框架。Spark提供了一个更快、更通用的数据处理平台。和Hadoop相比，Spark可以让你的程序在内存中运行时速度提升100倍，或者在磁盘上运行时速度提升10倍



#### kylin

Apache Kylin™是一个开源的分布式分析引擎，提供Hadoop/Spark之上的SQL查询接口及多维分析OLAP能力以支持超大规模数据，最初由eBay Inc. 开发并贡献至开源社区。它能在亚秒内查询巨大的Hive表



### 数据相关那些令人头疼的名词

所谓的程序就是在数据堆中找数据、改数据、生产数据的过程。在这个过程中总有那么些人会给某个过程或环节以或是模式命名一些所谓高大上的名称。

* OLTP(ON LINE TRANSACTION PROCESSING) 也被称作联机事物处理
* OLAP(ON LINE Analytical Processing) 也被称作链接分析处理。
* DAG(Directed Acyclic Graph)有向无环图





### 那些令人头疼的算法

为了进行数据挖掘任务，数据科学家们提出了各种模型，在众多的数据挖掘模型中，国际权威的学术组织ICDM评选出了十大经典的算法，按照不同的目的，可以将算法为四类:

* 分类算法： C4.5、朴素贝叶斯(Naive bayes),SVM,KNN,Adaboost,CART
* 聚类算法：K-Means,EM
* 关联分享：Apriori
* 连接分享：PageRank