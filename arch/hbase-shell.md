

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

### Java Hbase编程
新建一个普通java项目，把${hbase}/lib/目录下的jar包全部导入。然后想常规项目进行相关的编程即可。不过值得注意的是由于HBASE是基于列族的是数据库。因此其操作API有些怪异并且比较难用。如下所示

```java
       table.setAutoFlushTo(false);
        table.setWriteBufferSize(534534534);
        ArrayList<Put> arrayList = new ArrayList<Put>();

        Put put = new Put(Bytes.toBytes("0_1"));
        put.add(Bytes.toBytes("info"), Bytes.toBytes("name"), Bytes.toBytes("网络部"));
        put.add(Bytes.toBytes("subdept"), Bytes.toBytes("subdept1"), Bytes.toBytes("1_1"));
        put.add(Bytes.toBytes("subdept"), Bytes.toBytes("subdept2"), Bytes.toBytes("1_2"));
        arrayList.add(put);

        Put put1 = new Put(Bytes.toBytes("1_1"));
        put1.add(Bytes.toBytes("info"), Bytes.toBytes("name"), Bytes.toBytes("开发部"));
        put1.add(Bytes.toBytes("info"), Bytes.toBytes("f_pid"), Bytes.toBytes("0_1"));

        Put put2 = new Put(Bytes.toBytes("1_2"));
        put2.add(Bytes.toBytes("info"), Bytes.toBytes("name"), Bytes.toBytes("测试部"));
        put2.add(Bytes.toBytes("info"), Bytes.toBytes("f_pid"), Bytes.toBytes("0_1"));

        for (int i = 1; i <= 100; i++) {

            put1.add(Bytes.toBytes("subdept"), Bytes.toBytes("subdept"+i), Bytes.toBytes("2_"+i));
            put2.add(Bytes.toBytes("subdept"), Bytes.toBytes("subdept"+i), Bytes.toBytes("3_"+i));
        }
        arrayList.add(put1);
        arrayList.add(put2);
        //插入数据
        table.put(arrayList);
        //提交
        table.flushCommits();
```

如上所示。看着很别扭，其实此处可以借鉴ES处理JSON的方法，可以多层次的key专为level1Key.level2Key的方式存储成单排的key-value键值对，而单独放一个字段姑且命名为_sourceData中存储原始的完整对象的序列化值。而其他keyvalue的值则只存储关键的需要索引的键值对。这样不但操作API使用起来简单，而且检索起来其速度也肯定很高效。这是一件很愉快的事情。

当然HBASE中的rowkey的设计是关键中的关键。