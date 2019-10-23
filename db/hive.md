简单的说：hive是基于hadoop的数据仓库，因为HIVE的数据存储在hdfs上，并且hive的数据计算用mapreduce。

hive主要的应用场景

​	 1.日志分析：大部分互联网公司使用hive进行日志分析，包括百度、淘宝等

​			(统计网站一个时间段内的pv、uv)

​	 2.多维度数据分析



### Hive 数据类型

Hive 提供了基本数据类型和复杂数据类型，复杂数据类型是 Java 语言所不具有的.Hive 的两种数据类型以及数据类型之间的转换.

基本类型:TINYINT、smallint、int、bigint、float、double、boolean、string

复杂类型:ARRAY、MAP、STRUCT

### HIVE的体系结构

* 用户接口主要有三个：CLI，Client 和 WUI。其中最常用的是CLI，Cli启动的时候，会同时启动一个Hive副本。Client是Hive的客户端，用户连接至Hive Server。在启动 Client模式的时候，需要指出Hive Server所在节点，并且在该节点启动Hive Server。 WUI是通过浏览器访问Hive。

* Hive将元数据存储在数据库中，如mysql、derby。Hive中的元数据包括表的名字，表的列和分区及其属性，表的属性（是否为外部表等），表的数据所在目录等。

* 解释器、编译器、优化器完成HQL查询语句从词法分析、语法分析、编译、优化以及查询计划的生成。生成的查询计划存储在HDFS中，并在随后有MapReduce调用执行。

* Hive的数据存储在HDFS中，大部分的查询、计算由MapReduce完成（包含*的查询，比如select * from tbl不会生成MapRedcue任务）。

### HIVE的文件格式

* TEXTFILE默认格式，数据不做压缩，磁盘开销大，数据解析开销大。 可结合Gzip、Bzip2使用(系统自动检查，执行查询时自动解压)，但使用这种方式，hive不会对数据进行切分， 从而无法对数据进行并行操作。
* SEQUENCEFILE是Hadoop API提供的一种二进制文件支持，其具有使用方便、可分割、可压缩的特点。 SequenceFile支持三种压缩选择：NONE，RECORD，BLOCK。Record压缩率低，一般建议使用BLOCK压缩
* RCFILERCFILE是一种行列存储相结合的存储方式。首先，其将数据按行分块，保证同一个record在一个块上，避免读一个记录需要读取多个block。其次，块数据列式存储，有利于数据压缩和快速的列存取。
* ORCFILE(0.11以后出现)

### HIVE命令行操作

```bash
#创建数据库
hive> create database zwctest;

#查看数据库
hive> show databases;
OK
default
zwctest
Time taken: 0.019 seconds, Fetched: 2 row(s)

 

# 切换数据库
# 切换数据库的时候可以输入：use database_name；
hive> use zwctest;
OK
Time taken: 0.012 seconds

 

# 删除数据库
hive> drop database if exists zwctest;

 

# 创建表
# 创建一个外部表，表有字段name，sex，age。comment后面内容为字段描述信息。
hive> create external table if not exists studenttable(
    > name string comment 'name value',
    > sex string comment 'sex value',
    > age string comment 'age value')
    > row format delimited
    > fields terminated by '\t'
    > lines terminated by '\n'
    > stored as textfile;
OK
Time taken: 0.163 seconds

 

# 查看所有表
hive> show tables;
OK
testtable
Time taken: 0.023 seconds, Fetched: 1 row(s)

 

# 查看表信息
hive> desc studenttable;
OK
name                    string                  name value          
sex                     string                  sex value           
age                     string                  age value      

#这里面有一个字段data，是string类型的，描述信息comment是“d comment”。

#查看拓展描述信息
hive> describe formatted studenttable;
OK
# col_name              data_type               comment             
                 
name                    string                  name value          
sex                     string                  sex value           
age                     string                  age value           
                 
# Detailed Table Information             
Database:               zwctest                  
Owner:                  root                     
CreateTime:             Sun Oct 23 17:52:38 CST 2016     
LastAccessTime:         UNKNOWN                  
Protect Mode:           None                     
Retention:              0                        
Location:               hdfs://test1:8020/user/hive/warehouse/zwctest.db/studenttable    
Table Type:             EXTERNAL_TABLE           
Table Parameters:                
        EXTERNAL                TRUE                
        transient_lastDdlTime   1477216358          
                 
# Storage Information            
SerDe Library:          org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe       
InputFormat:            org.apache.hadoop.mapred.TextInputFormat         
OutputFormat:           org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat       
Compressed:             No                       
Num Buckets:            -1                       
Bucket Columns:         []                       
Sort Columns:           []                       
Storage Desc Params:             
        field.delim             \t                  
        line.delim              \n                  
        serialization.format    \t                  
Time taken: 0.055 seconds, Fetched: 31 row(s)

# 注：desc为简写，可写全拼describe

 

# 删除表
hive> drop table testtable;
OK
Time taken: 0.198 seconds

 

# 表加载数据
hive> load data local inpath '/data/apps/test/zhangwenchao/data/data.txt' into table studenttable; 
Loading data to table zwctest.studenttable
Table zwctest.studenttable: [numFiles=1, totalSize=2117]
OK
Time taken: 0.659 seconds

 

# 查看数据
select * from testtable;
```

