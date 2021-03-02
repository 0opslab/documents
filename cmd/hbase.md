# title{hbase - hbase相关的那些操作}
HBase是一个面向列的数据库，在表中它由行排序。表模式定义只能列族，也就是键值对。一个表有多个列族以及**每一个列族可以有任意数量的列**。后续列的值连续存储在磁盘上。表中的每个单元格值都具有时间戳。总之，在一个HBase：

- 表是行的集合。
- 行是列族的集合。
- 列族是列的集合。
- 列是键值对的集合。

#### row key 行建

与nosql数据库一样，row key是用来表示唯一一行记录的**主键**，HBase的数据时按照RowKey的**字典顺序**进行全局排序的，所有的查询都只能依赖于这一个排序维度。访问HBASE table中的行，只有三种方式：

* 通过单个row key访问；

* 通过row key的range（正则）

* 全表扫描

Row  key 行键可以是任意字符串(最大长度是64KB，实际应用中长度一般为10-1000bytes)，在HBASE内部，row  key保存为字节数组。存储时，数据按照Row  key的字典序(byte  order)排序存储。设计key时，要充分排序存储这个特性，将经常一起读取的行存储放到一起

# HBase数据模型

在 HBase 中，数据模型同样是由表组成的，各个表中又包含数据行和列，在这些表中存储了 HBase 数据。

## HBase数据模型术语

- 表（Table）

    HBase 会将数据组织进一张张的表里面，一个 HBase 表由多行组成。

- 行（Row）

    HBase 中的一行包含一个行键和一个或多个与其相关的值的列。在存储行时，行按字母顺序排序。出于这个原因，行键的设计非常重要。目标是以相关行相互靠近的方式存储数据。常用的行键模式是网站域。如果你的行键是域名，则你可能应该将它们存储在相反的位置（org.apache.www，org.apache.mail，org.apache.jira）。这样，表中的所有 Apache 域都彼此靠近，而不是根据子域的第一个字母分布。

- 列（Column）

    HBase 中的列由一个列族和一个列限定符组成，它们由`:`（冒号）字符分隔。

- 列族（Column Family）

    出于性能原因，列族在物理上共同存在一组列和它们的值。在 HBase 中每个列族都有一组存储属性，例如其值是否应缓存在内存中，数据如何压缩或其行编码是如何编码的等等。表中的每一行都有相同的列族，但给定的行可能不会在给定的列族中存储任何内容。

    列族一旦确定后，就不能轻易修改，因为它会影响到 HBase 真实的物理存储结构，但是列族中的列标识(Column Qualifier)以及其对应的值可以动态增删。 

- 列限定符（Column Qualifier）

    列限定符被添加到列族中，以提供给定数据段的索引。鉴于列族的`content`，列限定符可能是`content:html`，而另一个可能是`content:pdf`。虽然列族在创建表时是固定的，但列限定符是可变的，并且在行之间可能差别很大。

- 单元格（Cell）

    单元格是行、列族和列限定符的组合，并且包含值和时间戳，它表示值的版本。

- 时间戳（Timestamp）

    时间戳与每个值一起编写，并且是给定版本的值的标识符。默认情况下，时间戳表示写入数据时 RegionServer 上的时间，但可以在将数据放入单元格时指定不同的时间戳值。

# HBase命名空间

## HBase命名空间

HBase命名空间 namespace 是与关系数据库系统中的数据库类似的表的逻辑分组。这种抽象为即将出现的多租户相关功能奠定了基础：

- 配额管理（Quota Management）（HBASE-8410） - 限制命名空间可占用的资源量（即区域，表）。
- 命名空间安全管理（Namespace Security Administration）（HBASE-9206） - 为租户提供另一级别的安全管理。
- 区域服务器组（Region server groups）（HBASE-6721） - 命名空间/表可以固定在 RegionServers 的子集上，从而保证粗略的隔离级别。

### 命名空间管理

你可以创建、删除或更改命名空间。通过指定表单的完全限定表名，在创建表时确定命名空间成员权限：

```
<table namespace>:<table qualifier>
```

示例：

```
#Create a namespace
create_namespace 'my_ns'

#create my_table in my_ns namespace
create 'my_ns:my_table', 'fam'

#drop namespace
drop_namespace 'my_ns'

#alter namespace
alter_namespace 'my_ns', {METHOD => 'set', 'PROPERTY_NAME' => 'PROPERTY_VALUE'}
```

### HBase预定义的命名空间

在 HBase 中有两个预定义的特殊命名空间：

- hbase：系统命名空间，用于包含 HBase 内部表
- default：没有显式指定命名空间的表将自动落入此命名空间

示例：

```
#namespace=foo and table qualifier=bar
create 'foo:bar', 'fam'

#namespace=default and table qualifier=bar
create 'bar', 'fam'
```

# HBase表、行与列族

## HBase表

HBase 中表是在 schema 定义时被预先声明的。

可以使用以下的命令来创建一个表，在这里必须指定表名和列族名。在 HBase shell 中创建表的语法如下所示：

```
create ‘<table name>’,’<column family>’ 
```

## HBase行

HBase中的行是逻辑上的行，物理上模型上行是按列族(colomn family)分别存取的。

行键是未解释的字节，行是按字母顺序排序的，最低顺序首先出现在表中。空字节数组用于表示表命名空间的开始和结束。

## HBase列族

Apache HBase 中的列被分组为列族。列族的所有列成员具有相同的前缀。例如，courses:history 和 courses:math 都是 courses 列族的成员。冒号字符（:）从列族限定符中分隔列族。列族前缀必须由可打印字符组成。限定尾部，列族限定符可以由任意字节组成。必须在 schema 定义时提前声明列族，而列不需要在 schema 时定义，但可以在表启动并运行时动态地变为列。

在物理上，所有列族成员一起存储在文件系统上。由于调音（tunings）和存储（storage）规范是在列族级完成的，因此建议所有列族成员具有相同的一般访问模式和大小特征。

## HBase Cell

由{row key, column( =<family> + <label>), version} 唯一确定的单元。cell 中的数据是没有类型的，全部是字节码形式存储。

# HBase数据模型操作

## HBase数据模型操作

在 HBase 中有四个主要的数据模型操作，分别是：Get、Put、Scan 和 Delete。

### Get（读取）

Get 指定行的返回属性。读取通过 Table.get 执行。

Get 操作的语法如下所示：

```
get ’<table name>’,’row1’
```

在以下的 get 命令示例中，我们扫描了 emp 表的第一行：

```
hbase(main):012:0> get 'emp', '1'

   COLUMN                     CELL
   
personal : city timestamp=1417521848375, value=hyderabad

personal : name timestamp=1417521785385, value=ramu

professional: designation timestamp=1417521885277, value=manager

professional: salary timestamp=1417521903862, value=50000

4 row(s) in 0.0270 seconds
```

#### 读取指定列

下面给出的是使用 get 操作读取指定列语法：

```
hbase>get 'table name', ‘rowid’, {COLUMN => ‘column family:column name ’}
```

在下面给出的示例表示用于读取 HBase 表中的特定列：

```
hbase(main):015:0> get 'emp', 'row1', {COLUMN=>'personal:name'}

  COLUMN                CELL
  
personal:name timestamp=1418035791555, value=raju

1 row(s) in 0.0080 seconds
```

### Put（写）

Put 可以将新行添加到表中（如果该项是新的）或者可以更新现有行（如果该项已经存在）。Put 操作通过 Table.put（non-writeBuffer）或 Table.batch（non-writeBuffer）执行。

Put 操作的命令如下所示，在该语法中，你需要注明新值：

```
put ‘table name’,’row ’,'Column family:column name',’new value’
```

新给定的值将替换现有的值，并更新该行。

#### Put操作示例 

假设 HBase 中有一个表 EMP 拥有下列数据：

```
hbase(main):003:0> scan 'emp'
 ROW              COLUMN+CELL
row1 column=personal:name, timestamp=1418051555, value=raju
row1 column=personal:city, timestamp=1418275907, value=Hyderabad
row1 column=professional:designation, timestamp=14180555,value=manager
row1 column=professional:salary, timestamp=1418035791555,value=50000
1 row(s) in 0.0100 seconds
```

以下命令将员工名为“raju”的城市值更新为“Delhi”：

```
hbase(main):002:0> put 'emp','row1','personal:city','Delhi'
0 row(s) in 0.0400 seconds
```

更新后的表如下所示：

```
hbase(main):003:0> scan 'emp'
  ROW          COLUMN+CELL
row1 column=personal:name, timestamp=1418035791555, value=raju
row1 column=personal:city, timestamp=1418274645907, value=Delhi
row1 column=professional:designation, timestamp=141857555,value=manager
row1 column=professional:salary, timestamp=1418039555, value=50000
1 row(s) in 0.0100 seconds
```

### Scan（扫描）

Scan 允许在多个行上对指定属性进行迭代。

Scan 操作的语法如下：

```
scan ‘<table name>’ 
```

以下是扫描表格实例的示例。假定表中有带有键  "row1 "、 "row2 "、 "row3 " 的行，然后是具有键“abc1”，“abc2”和“abc3”的另一组行。以下示例显示如何设置Scan实例以返回以“row”开头的行。

```
public static final byte[] CF = "cf".getBytes();
public static final byte[] ATTR = "attr".getBytes();
...

Table table = ...      // instantiate a Table instance

Scan scan = new Scan();
scan.addColumn(CF, ATTR);
scan.setRowPrefixFilter(Bytes.toBytes("row"));
ResultScanner rs = table.getScanner(scan);
try {
  for (Result r = rs.next(); r != null; r = rs.next()) {
    // process result...
  }
} finally {
  rs.close();  // always close the ResultScanner!
}
```

请注意，通常，指定扫描的特定停止点的最简单方法是使用 InclusiveStopFilter 类。

### Delete（删除）

Delete 操作用于从表中删除一行。Delete 通过 Table.delete 执行。

HBase 不会修改数据，因此通过创建名为 tombstones 的新标记来处理 Delete 操作。这些  tombstones，以及没用的价值，都在重大的压实中清理干净。

使用 Delete 命令的语法如下：

```
delete ‘<table name>’, ‘<row>’, ‘<column name >’, ‘<time stamp>’
```

下面是一个删除特定单元格的例子：

```
hbase(main):006:0> delete 'emp', '1', 'personal data:city',
1417521848375
0 row(s) in 0.0060 seconds
```

#### 删除表的所有单元格

使用 “deleteall” 命令，可以删除一行中所有单元格。下面给出是 deleteall 命令的语法：

```
deleteall ‘<table name>’, ‘<row>’,
```

这里是使用“deleteall”命令删除 emp 表 row1 的所有单元的一个例子。

```
hbase(main):007:0> deleteall 'emp','1'
0 row(s) in 0.0240 seconds
```

使用 Scan 命令验证表。表被删除后的快照如下：

```
hbase(main):022:0> scan 'emp'

ROW                  COLUMN+CELL

2 column=personal data:city, timestamp=1417524574905, value=chennai 

2 column=personal data:name, timestamp=1417524556125, value=ravi

2 column=professional data:designation, timestamp=1417524204, value=sr:engg

2 column=professional data:salary, timestamp=1417524604221, value=30000

3 column=personal data:city, timestamp=1417524681780, value=delhi

3 column=personal data:name, timestamp=1417524672067, value=rajesh

3 column=professional data:designation, timestamp=1417523187, value=jr:engg

3 column=professional data:salary, timestamp=1417524702514, value=25000
```




### Hbase 常用shell命令
进入hbase shell console如果有kerberos认证，需要事先使用相应的keytab进行一下认证（使用kinit命令），认证成功之后再使用hbase shell进入可以使用whoami命令可查看当前用户.

### Shell 通用命令

- status: 提供HBase的状态，例如，服务器的数量。
- version: 提供正在使用HBase版本。
- table_help: 表引用命令提供帮助。
- whoami: 提供有关用户的信息。

### Shell 数据定义语言

下面列举了HBase Shell支持的可以在表中操作的命令。

- create: 用于创建一个表。
- list: 用于列出HBase的所有表。
- disable: 用于禁用表。
- is_disabled: 用于验证表是否被禁用。
- enable: 用于启用一个表。
- is_enabled: 用于验证表是否已启用。
- describe: 用于提供了一个表的描述。
- alter: 用于改变一个表。
- exists: 用于验证表是否存在。
- drop: 用于从HBase中删除表。
- drop_all: 用于丢弃在命令中给出匹配“regex”的表。
- Java Admin API: 在此之前所有的上述命令，Java提供了一个通过API编程来管理实现DDL功能。在这个org.apache.hadoop.hbase.client包中有HBaseAdmin和HTableDescriptor 这两个重要的类提供DDL功能。

### Shell 数据操作语言

- put: 用于把指定列在指定的行中单元格的值在一个特定的表。
- get: 用于取行或单元格的内容。
- delete:用于删除表中的单元格值。
- deleteall: 用于删除给定行的所有单元格。
- scan: 用于扫描并返回表数据。
- count: 用于计数并返回表中的行的数目。
- truncate: 用于禁用、删除和重新创建一个指定的表。
- Java client API: 在此之前所有上述命令，Java提供了一个客户端API来实现DML功能，CRUD（创建检索更新删除）操作更多的是通过编程，在org.apache.hadoop.hbase.client包下。 在此包HTable 的 Put和Get是重要的类。

```bash
$HBASE_HOME/bin/hbase shell

hbase(main)> whoami


# 表的管理
# 1）查看有哪些表
hbase(main)> list

# 2）创建表
# 语法：create <table>, {NAME => <family>, VERSIONS => <VERSIONS>}
# 例如：创建表t1，有两个family name：f1，f2，且版本数均为2
hbase(main)> create 't1',{NAME => 'f1', VERSIONS => 2},{NAME => 'f2', VERSIONS => 2}

# 3）删除表
# 分两步：首先disable，然后drop
# 例如：删除表t1
hbase(main)> disable 't1'
hbase(main)> drop 't1'

# 4）查看表的结构
# 语法：describe <table>
# 例如：查看表t1的结构
hbase(main)> describe 't1'

# 5）修改表结构
# 修改表结构必须先disable
# 语法：alter 't1', {NAME => 'f1'}, {NAME => 'f2', METHOD => 'delete'}
# 例如：修改表test1的cf的TTL为180天
hbase(main)> disable 'test1'
hbase(main)> alter 'test1',{NAME=>'body',TTL=>'15552000'},{NAME=>'meta', TTL=>'15552000'}
hbase(main)> enable 'test1'
```


###### 权限管理
```bash
# 1）分配权限
# 语法 : grant <user> <permissions> <table> <column family> <column qualifier> 参数后面用逗号分隔
# 权限用五个字母表示： "RWXCA".
# READ('R'), WRITE('W'), EXEC('X'), CREATE('C'), ADMIN('A')
# 例如，给用户‘test'分配对表t1有读写的权限，
hbase(main)> grant 'test','RW','t1'

# 2）查看权限
# 语法：user_permission <table>
# 例如，查看表t1的权限列表
hbase(main)> user_permission 't1'

# 3）收回权限
# 与分配权限类似，语法：revoke <user> <table> <column family> <column qualifier>
# 例如，收回test用户在表t1上的权限
hbase(main)> revoke 'test','t1'
```

###### 表数据的增删改查
```bash
# 1）添加数据
# 语法：put <table>,<rowkey>,<family:column>,<value>,<timestamp>
# 例如：给表t1的添加一行记录：rowkey是rowkey001，family name：f1，column name：col1，value：value01，timestamp：系统默认
hbase(main)> put 't1','rowkey001','f1:col1','value01'

# 2）查询数据
# a）查询某行记录
# 语法：get <table>,<rowkey>,[<family:column>,....]
# 例如：查询表t1，rowkey001中的f1下的col1的值
hbase(main)> get 't1','rowkey001', 'f1:col1'
# 或者：
hbase(main)> get 't1','rowkey001', {COLUMN=>'f1:col1'}
# 查询表t1，rowke002中的f1下的所有列值
hbase(main)> get 't1','rowkey001'

#b）扫描表
# 语法：scan <table>, {COLUMNS => [ <family:column>,.... ], LIMIT => num}
# 另外，还可以添加STARTROW、TIMERANGE和FITLER等高级功能
# 例如：扫描表t1的前5条数据
hbase(main)> scan 't1',{LIMIT=>5}

#c）查询表中的数据行数
# 语法：count <table>, {INTERVAL => intervalNum, CACHE => cacheNum}
# INTERVAL设置多少行显示一次及对应的rowkey，默认1000；CACHE每次去取的缓存区大小，默认是10，调整该参数可提高查询速度
# 例如，查询表t1中的行数，每100条显示一次，缓存区为500
hbase(main)> count 't1', {INTERVAL => 100, CACHE => 500}

#3）删除数据
#a )删除行中的某个列值
# 语法：delete <table>, <rowkey>,  <family:column> , <timestamp>,必须指定列名
# 例如：删除表t1，rowkey001中的f1:col1的数据
hbase(main)> delete 't1','rowkey001','f1:col1'

#注：将删除改行f1:col1列所有版本的数据
#b )删除行
# 语法：deleteall <table>, <rowkey>,  <family:column> , <timestamp>，可以不指定列名，删除整行数据
# 例如：删除表t1，rowk001的数据
hbase(main)> deleteall 't1','rowkey001'

#c）删除表中的所有数据
# 语法： truncate <table>
# 其具体过程是：disable table -> drop table -> create table
# 例如：删除表t1的所有数据
hbase(main)> truncate 't1'
```

###### Region管理
```bash
#1）移动region
# 语法：move 'encodeRegionName', 'ServerName'
# encodeRegionName指的regioName后面的编码，ServerName指的是master-status的Region Servers列表
# 示例
hbase(main)>move '4343995a58be8e5bbc739af1e91cd72d', 'db-41.xxx.xxx.org,60020,1390274516739'

#2）开启/关闭region
# 语法：balance_switch true|false
hbase(main)> balance_switch

#3）手动split
# 语法：split 'regionName', 'splitKey'

#4）手动触发major compaction
#语法：
#Compact all regions in a table:
#hbase> major_compact 't1'
#Compact an entire region:
#hbase> major_compact 'r1'
#Compact a single column family within a region:
#hbase> major_compact 'r1', 'c1'
#Compact a single column family within a table:
#hbase> major_compact 't1', 'c1'
```

###### 配置管理及节点重启
```bash
#1）修改hdfs配置
hdfs配置位置：/etc/hadoop/conf
# 同步hdfs配置
cat /home/hadoop/slaves|xargs -i -t scp /etc/hadoop/conf/hdfs-site.xml hadoop@{}:/etc/hadoop/conf/hdfs-site.xml
#关闭：
cat /home/hadoop/slaves|xargs -i -t ssh hadoop@{} "sudo /home/hadoop/cdh4/hadoop-2.0.0-cdh4.2.1/sbin/hadoop-daemon.sh --config /etc/hadoop/conf stop datanode"
#启动：
cat /home/hadoop/slaves|xargs -i -t ssh hadoop@{} "sudo /home/hadoop/cdh4/hadoop-2.0.0-cdh4.2.1/sbin/hadoop-daemon.sh --config /etc/hadoop/conf start datanode"

#2）修改hbase配置
#hbase配置位置：
# 同步hbase配置
cat /home/hadoop/hbase/conf/regionservers|xargs -i -t scp /home/hadoop/hbase/conf/hbase-site.xml hadoop@{}:/home/hadoop/hbase/conf/hbase-site.xml
 
# graceful重启
cd ~/hbase
bin/graceful_stop.sh --restart --reload --debug inspurXXX.xxx.xxx.org

balance_switch true 开启负载均衡
```

