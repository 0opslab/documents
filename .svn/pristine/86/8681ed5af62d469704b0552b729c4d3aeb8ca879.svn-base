title: mysql常用命令
tags:
	- linux
	- mysql
categories: mysql
---
###### 查看MySQL状态及配置
```bash
show status 查看当前连接的服务器状态
show global status 查看MySQL服务器启动以来的状态
show global variables 查看MySQL服务器配置的变量
```

###### 增删改的统计查看 insert delete update select查询总数
```bash
show global status like "com_insert%"

show global status like "com_delete%"

show global status like "com_update%"

show global status like "com_select%"
```

###### Innodb影响行数

```bash
show global status like "innodb_rows%";
```

###### MySQL连接总次数
```bash
show global status like "connection%";
```

###### 查看MySQL慢查询次数
```bash
show global status like "%slow%";
show global variables like "%slow%";
log_slow_queries = on slow_query_log = on 表明慢查询日志已经开启
slow_query_log_file 慢查询日志文件的路径
show global variables like "%long_query%";
```
###### 查看数据库信息
```bash
# 查看数据库信息
mysql>\s
# 查看引擎
mysql> show engines;
# 查看插件
mysql> show plugins;
# 查看数据库执行进程
mysql> show processlist ;
```

###### 当前连接
```bash
show processlist;只列出前100条，如果想全列出请使用show full processlist; 
mysql> show processlist; 
命令： show status; 
命令：show status like '%下面变量%'; 
Aborted_clients 由于客户没有正确关闭连接已经死掉，已经放弃的连接数量。 
Aborted_connects 尝试已经失败的MySQL服务器的连接的次数。 
Connections 试图连接MySQL服务器的次数。 
Created_tmp_tables 当执行语句时，已经被创造了的隐含临时表的数量。 
Delayed_insert_threads 正在使用的延迟插入处理器线程的数量。 
Delayed_writes 用INSERT DELAYED写入的行数。 
Delayed_errors 用INSERT DELAYED写入的发生某些错误(可能重复键值)的行数。 
Flush_commands 执行FLUSH命令的次数。 
Handler_delete 请求从一张表中删除行的次数。 
Handler_read_first 请求读入表中第一行的次数。 
Handler_read_key 请求数字基于键读行。 
Handler_read_next 请求读入基于一个键的一行的次数。 
Handler_read_rnd 请求读入基于一个固定位置的一行的次数。 
Handler_update 请求更新表中一行的次数。 
Handler_write 请求向表中插入一行的次数。 
Key_blocks_used 用于关键字缓存的块的数量。 
Key_read_requests 请求从缓存读入一个键值的次数。 
Key_reads 从磁盘物理读入一个键值的次数。 
Key_write_requests 请求将一个关键字块写入缓存次数。 
Key_writes 将一个键值块物理写入磁盘的次数。 
Max_used_connections 同时使用的连接的最大数目。 
Not_flushed_key_blocks 在键缓存中已经改变但是还没被清空到磁盘上的键块。 
Not_flushed_delayed_rows 在INSERT DELAY队列中等待写入的行的数量。 
Open_tables 打开表的数量。 
Open_files 打开文件的数量。 
Open_streams 打开流的数量(主要用于日志记载） 
Opened_tables 已经打开的表的数量。 
Questions 发往服务器的查询的数量。 
Slow_queries 要花超过long_query_time时间的查询数量。 
Threads_connected 当前打开的连接的数量。 
Threads_running 不在睡眠的线程数量。 
Uptime 服务器工作了多少秒。
```

#### 用户管理
```sql
#创建用户
CREATE USER "allen" IDENTIFIED BY "1234";
#删除用户
DROP USER 用户名;
#修改用户密码
UPDATE USER SET PASSWORD=PASSWORD('000000') WHERE USER='ucenter';
#授于用户权限
GRANT ALL ON workcms.* TO ucenter@'%' IDENTIFIED BY "111111"; 

# 用户权限
# mysql中可以给你一个用户授予如select,insert,update,delete等其中的一个或者多个权限,
#主要使用grant命令,用法格式为：  
grant 权限 on 数据库对象 to 用户  
# 一、grant 普通数据用户，查询、插入、更新、删除 数据库中所有表数据的权利。  
grant select on testdb.* to common_user@’%’  
grant insert on testdb.* to common_user@’%’  
grant update on testdb.* to common_user@’%’  
grant delete on testdb.* to common_user@’%’  
#或者，用一条 mysql 命令来替代：  
grant select, insert, update, delete on testdb.* to common_user@’%’

#grant 数据库开发人员，创建表、索引、视图、存储过程、函数。。。等权限。  
grant 创建、修改、删除 mysql 数据表结构权限。  
grant create on testdb.* to developer@’192.168.0.%’;  
grant alter on testdb.* to developer@’192.168.0.%’;  
grant drop on testdb.* to developer@’192.168.0.%’;  
grant 操作 mysql 外键权限。  
grant references on testdb.* to developer@’192.168.0.%’;  
grant 操作 mysql 临时表权限。  
grant create temporary tables on testdb.* to developer@’192.168.0.%’; 
grant 操作 mysql 索引权限。  
grant index on testdb.* to developer@’192.168.0.%’;  
grant 操作 mysql 视图、查看视图源代码 权限。  
grant create view on testdb.* to developer@’192.168.0.%’;  
grant show view on testdb.* to developer@’192.168.0.%’;  
grant 操作 mysql 存储过程、函数 权限。  
grant create routine on testdb.* to developer@’192.168.0.%’; - now, can show procedure status  
grant alter routine on testdb.* to developer@’192.168.0.%’; - now, you can drop a procedure  
grant execute on testdb.* to developer@’192.168.0.%’;

#grant 普通 dba 管理某个 mysql 数据库的权限。  
grant all privileges on testdb to dba@’localhost’  
其中，关键字 “privileges” 可以省略。

#grant 高级 dba 管理 mysql 中所有数据库的权限。  
grant all on *.* to dba@’localhost’

#mysql grant 权限，分别可以作用在多个层次上。  
#grant 作用在整个 mysql 服务器上：  
grant select on *.* to dba@localhost; - dba 可以查询 mysql 中所有数据库中的表。  
grant all on *.* to dba@localhost; - dba 可以管理 mysql 中的所有数据库  
#grant 作用在单个数据库上：  
grant select on testdb.* to dba@localhost; - dba 可以查询 testdb 中的表。  
#grant 作用在单个数据表上：  
grant select, insert, update, delete on testdb.orders to dba@localhost; 
#grant 作用在表中的列上：  
grant select(id, se, rank) on testdb.apache_log to dba@localhost;  
#grant 作用在存储过程、函数上：  
grant execute on procedure testdb.pr_add to ’dba’@’localhost’  
grant execute on function testdb.fn_add to ’dba’@’localhost’

#查看 mysql 用户权限  
#查看当前用户（自己）权限：  
show grants;  
#查看其他 mysql 用户权限：  
show grants for dba@localhost;

#撤销已经赋予给 mysql 用户权限的权限。  
revoke 跟 grant 的语法差不多，只需要把关键字 “to” 换成 “from” 即可： 
grant all on *.* to dba@localhost;  
revoke all on *.* from dba@localhost;

#mysql grant、revoke 用户权限注意事项  
#grant, revoke 用户权限后，该用户只有重新连接 mysql 数据库，权限才能生效。 
#如果想让授权的用户，也可以将这些权限 grant 给其他用户，需要选项 “grant option“  
#grant select on testdb.* to dba@localhost with grant option;  
#这个特性一般用不到。实际中，数据库权限最好由 dba 来统一管理。
#注意：修改完权限以后 一定要刷新服务，或者重启服务，刷新服务用：flush privileges。
```

#### mysqldump
```bash
##mysqldump命令
mysqldump -u [uname] -p[pass] –databases [dbname][dbname2] > [backupfile.sql]

#使用 mysqldump 怎样备份所有数据库
mysqldump -u root -p –all-databases > backupfile.sql

# mysqldump 怎样备份指定的数据库
mysqldump -u root -p –databases school hospital > backupfile.sql

#  mysqldump 怎样备份指定的表
mysqldump –user=root –password=mypassword -h localhost databasename table_name_to_dump table_name_to_dump_2 > dump_only_two_tables_file.sql

# 仅获取 DDL
mysqldump -u root -p –all-databases –no-data > backupfile.sql

# 怎样备份位于其他服务器的远程数据库
mysqldump -h 172.16.25.126 -u root -ppass dbname > dbname.sql

# mysqldump 全备恢复
mysql -uroot -p db_name < 全备.sql

# mysql 命令行下
source 全备.sql
```

#### 常用sql
```sql

# 随机
SELECT * FROM address WHERE id >= (SELECT floor(RAND() * (SELECT MAX(id) FROM address))) ORDER BY id LIMIT 0,10

# 随机
SELECT *,RAND() as r FROM address ORDER BY r LIMIT 0,10


# insert into select from的使用
INSERT INTO db1_name(field1,field2) SELECT field1,field2 FROM db2_name

INSERT INTO a(field1,field2) SELECT * FROM(SELECT f1,f2 FROM b JOIN c) AS tb


########################################
# create table as select 

# 复制表和表数据
CREATE TABLE app_enword_user_old SELECT * FROM app_enword_user;

#复制全部数据
select * into new_table from old_table;
```
