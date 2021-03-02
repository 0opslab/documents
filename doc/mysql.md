# title{mysql - }
### 常用操作

自增表

create table oldBoy  (id INTEGER  PRIMARY KEY AUTO_INCREMENT, name CHAR(30) NOT NULL, age integer , sex CHAR(15) );  # 创建自增表
insert into oldBoy(name,age,sex) values(%s,%s,%s)  # 自增插入数据



登录mysql的命令

# 格式： mysql -h 主机地址 -u 用户名 -p 用户密码
mysql -h110.110.110.110 -P3306 -uroot -p
mysql -uroot -p -S /data1/mysql5/data/mysql.sock -A  --default-character-set=GBK



shell执行mysql命令

mysql -u$username -p$passwd -h$dbhost -P$dbport -A -e "      
use $dbname;
delete from data where date=('$date1');
"    # 执行多条mysql命令
mysql -uroot -p -S mysql.sock -e "use db;alter table gift add column accountid  int(11) NOT NULL;flush privileges;"    # 不登陆mysql插入字段


备份数据库

mysqldump -h host -u root -p --default-character-set=utf8 dbname >dbname_backup.sql               # 不包括库名，还原需先创建库，在use 
mysqldump -h host -u root -p --database --default-character-set=utf8 dbname >dbname_backup.sql    # 包括库名，还原不需要创建库
/bin/mysqlhotcopy -u root -p    # mysqlhotcopy只能备份MyISAM引擎
mysqldump -u root -p -S mysql.sock --default-character-set=utf8 dbname table1 table2  > /data/db.sql    # 备份表
mysqldump -uroot -p123  -d database > database.sql    # 备份数据库结构

innobackupex --user=root --password="" --defaults-file=/data/mysql5/data/my_3306.cnf --socket=/data/mysql5/data/mysql.sock --slave-info --stream=tar --tmpdir=/data/dbbackup/temp /data/dbbackup/ 2>/data/dbbackup/dbbackup.log | gzip 1>/data/dbbackup/db50.tar.gz   # xtrabackup备份需单独安装软件 优点: 速度快,压力小,可直接恢复主从复制


还原数据库

mysql -h host -u root -p dbname < dbname_backup.sql   
source 路径.sql   # 登陆mysql后还原sql文件


赋权限

# 指定IP: $IP  本机: localhost   所有IP地址: %   # 通常指定多条
grant all on zabbix.* to user@"$IP";             # 对现有账号赋予权限
grant select on database.* to user@"%" Identified by "passwd";     # 赋予查询权限(没有用户，直接创建)
grant all privileges on database.* to user@"$IP" identified by 'passwd';         # 赋予指定IP指定用户所有权限(不允许对当前库给其他用户赋权限)
grant all privileges on database.* to user@"localhost" identified by 'passwd' with grant option;   # 赋予本机指定用户所有权限(允许对当前库给其他用户赋权限)
grant select, insert, update, delete on database.* to user@'ip'identified by "passwd";   # 开放管理操作指令
revoke all on *.* from user@localhost;     # 回收权限


更改密码

update user set password=password('passwd') where user='root'
mysqladmin -u root password 'xuesong'


mysql忘记密码后重置

cd /data/mysql5
/data/mysql5/bin/mysqld_safe --user=mysql --skip-grant-tables --skip-networking &
update user set password=password('123123') where user='root';


mysql主从复制失败恢复

slave stop;
reset slave;
change master to master_host='10.10.10.110',master_port=3306,master_user='repl',master_password='repl',master_log_file='master-bin.000010',master_log_pos=107,master_connect_retry=60;
slave start;



检测mysql主从复制延迟{

1、在从库定时执行更新主库中的一个timeout数值
2、同时取出从库中的timeout值对比判断从库与主库的延迟





```bash
./mysql/bin/mysqld_safe --user=mysql &   # 启动mysql服务
./mysql/bin/mysqladmin -uroot -p -S ./mysql/data/mysql.sock shutdown    # 停止mysql服务
mysqlcheck -uroot -p -S mysql.sock --optimize --databases account       # 检查、修复、优化MyISAM表
mysqlbinlog slave-relay-bin.000001              # 查看二进制日志(报错加绝对路径)
mysqladmin -h myhost -u root -p create dbname   # 创建数据库

flush privileges;             # 刷新
show databases;               # 显示所有数据库
use dbname;	                  # 打开数据库
show tables;                  # 显示选中数据库中所有的表
desc tables;                  # 查看表结构
drop database name;           # 删除数据库
drop table name;              # 删除表
create database name;         # 创建数据库
select 列名称 from 表名称;    # 查询
show grants for repl;         # 查看用户权限
show processlist;             # 查看mysql进程
select user();                # 查看所有用户
show slave status\G;          # 查看主从状态
show variables;               # 查看所有参数变量
show table status             # 查看表的引擎状态
drop table if exists user                       # 表存在就删除
create table if not exists user                 # 表不存在就创建
select host,user,password from user;            # 查询用户权限 先use mysql
create table ka(ka_id varchar(6),qianshu int);  # 创建表
SHOW VARIABLES LIKE 'character_set_%';          # 查看系统的字符集和排序方式的设定
show variables like '%timeout%';                # 查看超时(wait_timeout)
delete from user where user='';                 # 删除空用户
delete from user where user='sss' and host='localhost' ;    # 删除用户
ALTER TABLE mytable ENGINE = MyISAM ;                       # 改变现有的表使用的存储引擎
SHOW TABLE STATUS from  库名  where Name='表名';            # 查询表引擎
CREATE TABLE innodb (id int, title char(20)) ENGINE = INNODB                     # 创建表指定存储引擎的类型(MyISAM或INNODB)
grant replication slave on *.* to '用户'@'%' identified by '密码';               # 创建主从复制用户
ALTER TABLE player ADD INDEX weekcredit_faction_index (weekcredit, faction);     # 添加索引
alter table name add column accountid(列名)  int(11) NOT NULL(字段不为空);       # 插入字段
update host set monitor_state='Y',hostname='xuesong' where ip='192.168.1.1';     # 更新数据
```

### 数据库操作

```bash
## 创建数据并指定数据库
create database `datas` character set utf8mb4 collate utf8mb4_general_ci;

#一般环境不需要源码包编译安装直接apt-get即可
$ sudo apt-get install mysql-server mysql-client
# 停止mysql服务
$ sudo service mysql stop
# 如果提示
stop: Unknown job: mysql
# 执行下面命令几个
sudo initctl reload-configuration
# 停止服务后编辑下面的配置文件
sudo vim /etc/mysql/my.cnf
# 启动mysql服务
$ sudo service mysql start
# 查看数据库信息
mysql>\s
# 查看引擎
mysql> show engines;
# 查看插件
mysql> show plugins;
# 查看数据库执行进程
mysql> show processlist ;

```

## mysql用户管理

```bash
# 创建用户:
# 指定ip：192.118.1.1的mjj用户登录
create user 'alex'@'192.118.1.1' identified by '123';
# 指定ip：192.118.1.开头的mjj用户登录
create user 'alex'@'192.118.1.%' identified by '123';
# 指定任何ip的mjj用户登录
create user 'alex'@'%' identified by '123';
# 删除用户
drop user '用户名'@'IP地址';
# 修改用户
rename user '用户名'@'IP地址' to '新用户名'@'IP地址';
# 修改密码
set password for '用户名'@'IP地址'=Password('新密码');
#查看权限
show grants for '用户'@'IP地址'
#授权 mjj用户仅对db1.t1文件有查询、插入和更新的操作
grant select ,insert,update on db1.t1 to "alex"@'%';
# 表示有所有的权限，除了grant这个命令，这个命令是root才有的。mjj用户对db1下的t1文件有任意操作
grant all privileges  on db1.t1 to "alex"@'%';
#mjj用户对db1数据库中的文件执行任何操作
grant all privileges  on db1.* to "alex"@'%';
#mjj用户对所有数据库中文件有任何操作
grant all privileges  on *.*  to "alex"@'%';
#取消权限
# 取消mjj用户对db1的t1文件的任意操作
revoke all on db1.t1 from 'alex'@"%";  
# 取消来自远程服务器的mjj用户对数据库db1的所有表的所有权限
revoke all on db1.* from 'alex'@"%";  
# 取消来自远程服务器的mjj用户所有数据库的所有的表的权限
revoke all privileges on *.* from 'alex'@'%';
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

#mysql grant 权限，分别可以作用在多个层次上。grant 作用在整个 mysql 服务器上：  
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

#查看 mysql 用户权限 查看当前用户（自己）权限：  
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



#### 备份与恢复
```bash
#怎样列出 mysqldump 中的所有选项？ 中常用的选项是？
mysqldump –help
mysqldump 
All-databases
Databases
Routines
Single-transaction （它不会锁住表） – 一直在 innodb databases 中使用
Master-data – 复制 （现在忽略了）
No-data – 它将 dump 一个没有数据的空白数据库
#–singletransaction 选项避免了 innodb databases 备份期间的任何锁，如果你使用这个选项，在备份期间，没有锁

mysqldump -u [uname] -p[pass] –databases [dbname][dbname2] > [backupfile.sql]

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

#使用 mysqldump 怎样备份所有数据库？
mysqldump -u root -p –all-databases > backupfile.sql

#使用 mysqldump 怎样备份指定的数据库？
mysqldump -u root -p –databases school hospital > backupfile.sql


#使用 mysqldump 怎样备份指定的表？
mysqldump –user=root –password=mypassword -h localhost databasename table_name_to_dump
table_name_to_dump_2 > dump_only_two_tables_file.sql

#我不想要数据，怎样仅获取 DDL？
mysqldump -u root -p –all-databases –no-data > backupfile.sql


#一次 mysqldump 备份花费多长时间？
#这依赖于数据库大小，100 GB 大小的数据库可能花费两小时或更长时间

# 样备份位于其他服务器的远程数据库？
mysqldump -h 172.16.25.126 -u root -ppass dbname > dbname.sql


#–routines 选项的含义是什么？
#通过使用 -routines 产生的输出包含 CREATE PROCEDURE 和 CREATE FUNCTION
#语句用于重新创建 routines。如果你有 procedures 或 functions 你需要使用这个选项
#使用 mysqldump 备份的常用命令是什么？
nohup mysqldump –socket=mysql.sock –user=user1 –password=pass –single-transaction
–flush-logs –master-data=2 –all-databases –extended-insert –quick –routines > market_dump.sql 2> market_dump.err &

#使用 mysqldump 怎样压缩一个备份？注意: 压缩会降低备份的速度
Mysqldump [options] | gzip > backup.sql.gz

#怎样通过使用 mysqldump 来恢复备份？- 使用来源数据的方法
Mysql –u root –p < backup.sql

#在恢复期间我想记录错误到日志中，我也想看看恢复的执行时间？
Time Mysql –u root –p < backup.sql > backup.out 2>&1

#怎样从一个多数据库备份中提取一个数据库备份（假设数据库名字是 test）？
sed -n '/^-- Current Database: `test`/,/^-- Current Database: `/p' fulldump.sql > test.sql
# 导出数据库为dbname的表结构
mysqldump -uuser -pdbpasswd -d dbname >db.sql; 

# 导出数据库为dbname某张表结构
mysqldump -uuser -pdbpasswd -d dbname table_name>db.sql;

# 导出数据库为dbname所有表结构及表数据
mysqldump -uuser -pdbpasswd  dbname >db.sql;

# 导出数据库为dbname某张表结构及表数据
mysqldump -uuser -pdbpasswd dbname table_name>db.sql;

# 批量导出dbname数据库中多张表结构及表数据
mysqldump -uuser -pdbpasswd dbname table_name1 table_name2 table_name3>db.sql;

# 批量导出dbname数据库中多张表结构
mysqldump -uuser -pdbpasswd -d dbname table_name1 table_name2 table_name3>db.sql;
```
### 其他操作
```
在该文件的[mysqld]下面新增如下配置
```bash
# 新增
character_set_server=utf8  
init_connect='SET NAMES utf8'  
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

# create table as select 

# 复制表和表数据
CREATE TABLE app_enword_user_old SELECT * FROM app_enword_user;

#复制全部数据
select * into new_table from old_table;



# To backup all databases 备份所有数据库
mysqldump --all-databases --all-routines -u root -p > ~/fulldump.sql

# To restore all databases 要还原所有数据库
mysql -u root -p  < ~/fulldump.sql

# To create a database in utf8 charset 在utf8 charset中创建数据库
CREATE DATABASE owa CHARACTER SET utf8 COLLATE utf8_general_ci;

# To add a user and give rights on the given database
#添加用户并授予给定数据库权限
GRANT ALL PRIVILEGES ON database.* TO 'user'@'localhost'IDENTIFIED BY 'password' WITH GRANT OPTION;

#To list the privileges granted to the account that you are using to connect to the server. Any of the 3 statements will work. 
#列出授予用于连接服务器的帐户的权限。 3个陈述中的任何一个都可以。
SHOW GRANTS FOR CURRENT_USER();
SHOW GRANTS;
SHOW GRANTS FOR CURRENT_USER;

# Basic SELECT Statement
#基本SELECT语句
SELECT * FROM tbl_name;

# Basic INSERT Statement
#基本INSERT语句
INSERT INTO tbl_name (col1,col2) VALUES(15,col1*2);

# Basic UPDATE Statement
#基本更新声明
UPDATE tbl_name SET col1 = "example";

# Basic DELETE Statement
#基本DELETE语句
DELETE FROM tbl_name WHERE user = 'jcole';

# To check stored procedure
#检查存储过程
SHOW PROCEDURE STATUS;

# To check stored function
#检查存储的功能
SHOW FUNCTION STATUS;

# 修改自增长起始值
ALTER TABLE sys_upload_file AUTO_INCREMENT=142877;
```

## mysql导入文件
```bash
#记录MySQL导入txt文件命令：load data infile [文件路径/文件名.txt] into table [表名](col1,col2,col3...);
load data infile '/home/data/test.txt' into table temp(col1,col2,col3);默认分隔符是空格;

load data infile "/data/load.txt" replace into table test fields terminated by ',' lines terminated by '/n';

```

## mysql主从复制失败恢复

slave stop;
reset slave;
change master to master_host='10.10.10.110',master_port=3306,master_user='repl',master_password='repl',master_log_file='master-bin.000010',master_log_pos=107,master_connect_retry=60;
slave start;



## 检测mysql主从复制延迟
1、在从库定时执行更新主库中的一个timeout数值
2、同时取出从库中的timeout值对比判断从库与主库的延迟

