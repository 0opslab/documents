# title{oracle - }

### 监听的启动与停止

```bash
lsnrctl start 
lsnrctl status 
lsnrctl stop 
# 登录启动  
sqlplus / as sysdba
startup

```

### oracle-auto-start
1、以root身份登录到linux系统，编辑/etc/oratab文件，找到 

orcl:/u01/app/oracle/product/12.1.0/dbhome_1:N
，改为
orcl:/u01/app/oracle/product/12.1.0/dbhome_1:Y
　

# 配置/etc/rc.d/rc.local，添加以下脚本：

su oracle -lc "/u01/app/oracle/product/12.1.0/dbhome_1/bin/lsnrctl start"
su oracle -lc /u01/app/oracle/product/12.1.0/dbhome_1/bin/dbstart
　　

# 4、在/etc/init.d创建oracle服务启动，注意修改oracle路径：
vim /etc/init.d/oracle 
#!/bin/sh
# chkconfig: 345 61 61
# description: Oracle 11g R2 AutoRun Servimces
# /etc/init.d/oracle
#
# Run-level Startup script for the Oracle Instance, Listener, and
# Web Interface
export ORACLE_BASE=/u01/app/oracle    #根据个人情况修改路径
export ORACLE_HOME=$ORACLE_BASE/product/12.1.0/dbhome_1
export ORACLE_SID=orcl          #改成自己的ORACLE_SID:testsid
export PATH=$PATH:$ORACLE_HOME/bin
ORA_OWNR="oracle"
# if the executables do not exist -- display error
if [ ! -f $ORACLE_HOME/bin/dbstart -o ! -d $ORACLE_HOME ]
then
echo "Oracle startup: cannot start"
exit 1
fi
# depending on parameter -- startup, shutdown, restart
# of the instance and listener or usage display
case "$1" in
start)
# Oracle listener and instance startup
su $ORA_OWNR -lc $ORACLE_HOME/bin/dbstart
echo "Oracle Start Succesful!OK."
;;
stop)
# Oracle listener and instance shutdown
su $ORA_OWNR -lc $ORACLE_HOME/bin/dbshut
echo "Oracle Stop Succesful!OK."
;;
reload|restart)
$0 stop
$0 start
;;
*)
echo $"Usage: `basename $0` {start|stop|reload|reload}"
exit 1
esac
exit 0
#将oracle脚本文件赋予执行权限 
#说明：/etc/init.d -> /etc/rc.d/init.d 其中/etc/init.d为link文件，所以执行哪个目录下的Oracle脚本都应该可以。

cd /etc/rc.d/init.d
chmod +x oracle
　　

#修改dbstart和dbshut启动关闭脚本,使其启动数据库的同时也自动启动监听器（即启动数据库时启动监听器，停止数据库时停止监听器）： 

# vim /u01/app/oracle/product/12.1.0/dbhome_1/bin/dbstart
#找到下面的代码:
ORACLE_HOME_LISTNER=$1
#将其改为
ORACLE_HOME_LISTNER=$ORACLE_HOME
#同样也修改dbshut脚本：

 

# vim
/u01/app/oracle/product/12.1.0/dbhome_1/bin/dbshut
#找到下面的代码: ORACLE_HOME_LISTNER=$1 将其改为 ORACLE_HOME_LISTNER=$ORACLE_HOME
# 6/将 oracle服务加入到系统服务

chkconfig --level 234 oracle on
chkconfig --add oracle
# 7.检查是否生效：

chkconfig --list oracle

#8.加入自启动队列

ln –s /etc/rc.d/init.d/oracle /etc/rc0.d/K61oracle
ln –s /etc/rc.d/init.d/oracle /etc/rc2.d/S61oracle
ln –s /etc/rc.d/init.d/oracle /etc/rc3.d/S61oracle
ln –s /etc/rc.d/init.d/oracle /etc/rc4.d/S61oracle
ln –s /etc/rc.d/init.d/oracle /etc/rc6.d/K61oracle
```


* 查询某个用户下最耗时的SQL
```sql
select v.sql_id,
   v.child_number,
   v.sql_text,
   v.elapsed_time,
   v.cpu_time,
   v.disk_reads,
   rank() over(order by v.elapsed_time desc) elapsed_rank,
   v.PARSING_SCHEMA_NAME
from v$sql v
where V.PARSING_SCHEMA_NAME = 'xxx') ;
```
* 查看总消耗时间最多的前10条SQL语句
```sql
select *
from (select v.sql_id,
v.child_number,
v.sql_text,
v.elapsed_time,
v.cpu_time,
v.disk_reads,
rank() over(order by v.elapsed_time desc) elapsed_rank
from v$sql v) a
where elapsed_rank <= 10;
```

* 查看CPU消耗时间最多的前10条SQL语句
```sql
select *
from (select v.sql_id,
v.child_number,
v.sql_text,
v.elapsed_time,
v.cpu_time,
v.disk_reads,
rank() over(order by v.cpu_time desc) elapsed_rank
from v$sql v) a
where elapsed_rank <= 10;
```
* 查看消耗磁盘读取最多的前10条SQL语句
```sql
select *
from (select v.sql_id,
v.child_number,
v.sql_text,
v.elapsed_time,
v.cpu_time,
v.disk_reads,
rank() over(order by v.disk_reads desc) elapsed_rank
from v$sql v) a
where elapsed_rank <= 10;
```
* 查看表空间的名称及大小
```sql
    select t.tablespace_name, round(sum(bytes/(1024*1024)),0) ts_size
    from dba_tablespaces t, dba_data_files d
    where t.tablespace_name = d.tablespace_name
    group by t.tablespace_name;
```
* 查看表空间物理文件的名称及大小
```sql
    select tablespace_name, file_id, file_name,
    round(bytes/(1024*1024),0) total_space
    from dba_data_files
    order by tablespace_name;
```
* 查看回滚段名称及大小
```sql
    select segment_name, tablespace_name, r.status,
    (initial_extent/1024) InitialExtent,(next_extent/1024) NextExtent,
    max_extents, v.curext CurExtent
    From dba_rollback_segs r, v$rollstat v
    Where r.segment_id = v.usn(+)
    order by segment_name;
```
* 查看控制文件
```sql
    select name from v$controlfile;
```
* 查看日志文件
```sql
    select member from v$logfile;
```
* 查看表空间的使用情况
```sql
    select sum(bytes)/(1024*1024) as free_space,tablespace_name
    from dba_free_space
    group by tablespace_name;

    SELECT A.TABLESPACE_NAME,A.BYTES TOTAL,B.BYTES USED, C.BYTES FREE,
    (B.BYTES*100)/A.BYTES "% USED",(C.BYTES*100)/A.BYTES "% FREE"
    FROM SYS.SM$TS_AVAIL A,SYS.SM$TS_USED B,SYS.SM$TS_FREE C
    WHERE A.TABLESPACE_NAME=B.TABLESPACE_NAME AND A.TABLESPACE_NAME=C.TABLESPACE_NAME;
```
* 查看数据库库对象
```sql
    select owner, object_type, status, count(*) count# from all_objects group by owner, object_type, status;
```
* 查看数据库的版本　
```sql
    Select version FROM Product_component_version
    Where SUBSTR(PRODUCT,1,6)='Oracle';
```
* 查看数据库的创建日期和归档方式
```sql
    Select Created, Log_Mode, Log_Mode From V$Database;
```
* 捕捉运行很久的SQL
```sql
    column username format a12
    column opname format a16
    column progress format a8

    select username,sid,opname,
    round(sofar*100 / totalwork,0) || '%' as progress,
    time_remaining,sql_text
    from v$session_longops , v$sql
    where time_remaining <> 0
    and sql_address = address
    and sql_hash_value = hash_value
```
* 查看数据表的参数信息
```sql
    SELECT   partition_name, high_value, high_value_length, tablespace_name,
    pct_free, pct_used, ini_trans, max_trans, initial_extent,
    next_extent, min_extent, max_extent, pct_increase, FREELISTS,
    freelist_groups, LOGGING, BUFFER_POOL, num_rows, blocks,
    empty_blocks, avg_space, chain_cnt, avg_row_len, sample_size,
    last_analyzed
    FROM dba_tab_partitions
    --WHERE table_name = :tname AND table_owner = :towner
    ORDER BY partition_position
```
* 查看还没提交的事务
```sql
    select * from v$locked_object;
    select * from v$transaction;
```
* 查找object为哪些进程所用
```sql
    select
    p.spid,
    s.sid,
    s.serial# serial_num,
    s.username user_name,
    a.type  object_type,
    s.osuser os_user_name,
    a.owner,
    a.object object_name,
    decode(sign(48 - command),
    1,
    to_char(command), 'Action Code #' || to_char(command) ) action,
    p.program oracle_process,
    s.terminal terminal,
    s.program program,
    s.status session_status
    from v$session s, v$access a, v$process p
    where s.paddr = p.addr and
    s.type = 'USER' and
    a.sid = s.sid   and
    a.object='SUBSCRIBER_ATTR'
    order by s.username, s.osuser
```
* 回滚段查看
```sql
    select rownum, sys.dba_rollback_segs.segment_name Name, v$rollstat.extents
    Extents, v$rollstat.rssize Size_in_Bytes, v$rollstat.xacts XActs,
    v$rollstat.gets Gets, v$rollstat.waits Waits, v$rollstat.writes Writes,
    sys.dba_rollback_segs.status status from v$rollstat, sys.dba_rollback_segs,
    v$rollname where v$rollname.name(+) = sys.dba_rollback_segs.segment_name and
    v$rollstat.usn (+) = v$rollname.usn order by rownum
```
* 耗资源的进程（top session）
```sql
    select s.schemaname schema_name,    decode(sign(48 - command), 1,
    to_char(command), 'Action Code #' || to_char(command) ) action,    status
    session_status,   s.osuser os_user_name,   s.sid,         p.spid ,         s.serial# serial_num,
    nvl(s.username, '[Oracle process]') user_name,   s.terminal terminal,
    s.program program,   st.value criteria_value  from v$sesstat st,   v$session s  , v$process p
    where st.sid = s.sid and   st.statistic# = to_number('38') and   ('ALL' = 'ALL'
    or s.status = 'ALL') and p.addr = s.paddr order by st.value desc,  p.spid asc, s.username asc, s.osuser asc
```
* 查看锁（lock）情况
```sql
    select  ls.osuser os_user_name,   ls.username user_name,
    decode(ls.type, 'RW', 'Row wait enqueue lock', 'TM', 'DML enqueue lock', 'TX',
    'Transaction enqueue lock', 'UL', 'User supplied lock') lock_type,
    o.object_name object,   decode(ls.lmode, 1, null, 2, 'Row Share', 3,
    'Row Exclusive', 4, 'Share', 5, 'Share Row Exclusive', 6, 'Exclusive', null)
    lock_mode,    o.owner,   ls.sid,   ls.serial# serial_num,   ls.id1,   ls.id2
    from sys.dba_objects o, (   select s.osuser,    s.username,    l.type,
    l.lmode,    s.sid,    s.serial#,    l.id1,    l.id2   from v$session s,
    v$lock l   where s.sid = l.sid ) ls  where o.object_id = ls.id1 and    o.owner
    <> 'SYS'   order by o.owner, o.object_name
```
* 查看等待（wait）情况
```sql
    SELECT v$waitstat.class, v$waitstat.count count, SUM(v$sysstat.value) sum_value
    FROM v$waitstat, v$sysstat WHERE v$sysstat.name IN ('db block gets',
    'consistent gets') group by v$waitstat.class, v$waitstat.count
```
* 查看sga情况
```sql
	SELECT NAME, BYTES FROM SYS.V_$SGASTAT ORDER BY NAME ASC
```
* 查看catched object
```sql
	SELECT owner,
       name,
       db_link,
       namespace,
       type,
       sharable_mem,
       loads,
       executions,
       locks,
       pins,
       kept
  FROM v$db_object_cache
```
* 查看V$SQLAREA
```sql
    SELECT SQL_TEXT, SHARABLE_MEM, PERSISTENT_MEM, RUNTIME_MEM, SORTS,
    VERSION_COUNT, LOADED_VERSIONS, OPEN_VERSIONS, USERS_OPENING, EXECUTIONS,
    USERS_EXECUTING, LOADS, FIRST_LOAD_TIME, INVALIDATIONS, PARSE_CALLS, DISK_READS,
    BUFFER_GETS, ROWS_PROCESSED FROM V$SQLAREA
```
* 查看object分类数量
```sql
    select decode (o.type#,1,'INDEX' , 2,'TABLE' , 3 , 'CLUSTER' , 4, 'VIEW' , 5 ,
    'SYNONYM' , 6 , 'SEQUENCE' , 'OTHER' ) object_type , count(*) quantity from
    sys.obj$ o where o.type# > 1 group by decode (o.type#,1,'INDEX' , 2,'TABLE' , 3
    , 'CLUSTER' , 4, 'VIEW' , 5 , 'SYNONYM' , 6 , 'SEQUENCE' , 'OTHER' ) union select
    'COLUMN' , count(*) from sys.col$ union select 'DB LINK' , count(*) from
```
* 按用户查看object种类
```sql
    select u.name schema,   sum(decode(o.type#, 1, 1, NULL)) indexes,
    sum(decode(o.type#, 2, 1, NULL)) tables,   sum(decode(o.type#, 3, 1, NULL))
    clusters,   sum(decode(o.type#, 4, 1, NULL)) views,   sum(decode(o.type#, 5, 1,
    NULL)) synonyms,   sum(decode(o.type#, 6, 1, NULL)) sequences,
    sum(decode(o.type#, 1, NULL, 2, NULL, 3, NULL, 4, NULL, 5, NULL, 6, NULL, 1))
    others   from sys.obj$ o, sys.user$ u   where o.type# >= 1 and    u.user# =
    o.owner# and   u.name <> 'PUBLIC'   group by u.name    order by
    sys.link$ union select 'CONSTRAINT' , count(*) from sys.con$
```
* 查看有哪些用户连接
```sql
    select s.osuser os_user_name,    decode(sign(48 - command), 1, to_char(command),
    'Action Code #' || to_char(command) ) action,     p.program oracle_process,
    status session_status,    s.terminal terminal,    s.program program,
    s.username user_name,    s.fixed_table_sequence activity_meter,    '' query,
    0 memory,    0 max_memory,     0 cpu_usage,    s.sid,   s.serial# serial_num
    from v$session s,    v$process p   where s.paddr=p.addr and    s.type = 'USER'
    order by s.username, s.osuser
```
* 根据v.sid查看对应连接的资源占用等情况
```sql
    select n.name,
    v.value,
    n.class,
    n.statistic#
    from  v$statname n,
    v$sesstat v
    where v.sid = 71 and
    v.statistic# = n.statistic#
    order by n.class, n.statistic#
```
* 根据sid查看对应连接正在运行的sql
```sql
    select
    command_type,
    sql_text,
    sharable_mem,
    persistent_mem,
    runtime_mem,
    sorts,
    version_count,
    loaded_versions,
    open_versions,
    users_opening,
    executions,
    users_executing,
    loads,
    first_load_time,
    invalidations,
    parse_calls,
    disk_reads,
    buffer_gets,
    rows_processed,
    sysdate start_time,
    sysdate finish_time,
    '>' || address sql_address,
    'N' status
    from v$sqlarea
    where address = (select sql_address from v$session where sid = 71)
```
* 根据v.sid查看对应连接的资源占用等情况
```sql
    select n.name,
    v.value,
    n.class,
    n.statistic#
    from  v$statname n,
    v$sesstat v
    where v.sid = 71 and
    v.statistic# = n.statistic#
    order by n.class, n.statistic#
```
* 根据sid查看对应连接正在运行的sql
```sql
    select
    command_type,
    sql_text,
    sharable_mem,
    persistent_mem,
    runtime_mem,
    sorts,
    version_count,
    loaded_versions,
    open_versions,
    users_opening,
    executions,
    users_executing,
    loads,
    first_load_time,
    invalidations,
    parse_calls,
    disk_reads,
    buffer_gets,
    rows_processed,
    sysdate start_time,
    sysdate finish_time,
    '>' || address sql_address,
    'N' status
    from v$sqlarea
    where address = (select sql_address from v$session where sid = 71)
```
* 查询表空间使用情况
```sql
    select a.tablespace_name "表空间名称",
    100-round((nvl(b.bytes_free,0)/a.bytes_alloc)*100,2) "占用率(%)",
    round(a.bytes_alloc/1024/1024,2) "容量(M)",
    round(nvl(b.bytes_free,0)/1024/1024,2) "空闲(M)",
    round((a.bytes_alloc-nvl(b.bytes_free,0))/1024/1024,2) "使用(M)",
    Largest "最大扩展段(M)",
    to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') "采样时间"
    from  (select f.tablespace_name,
    sum(f.bytes) bytes_alloc,
    sum(decode(f.autoextensible,'YES',f.maxbytes,'NO',f.bytes)) maxbytes
    from dba_data_files f
    group by tablespace_name) a,
    (select  f.tablespace_name,
    sum(f.bytes) bytes_free
    from dba_free_space f
    group by tablespace_name) b,
    (select round(max(ff.length)*16/1024,2) Largest,
    ts.name tablespace_name
    from sys.fet$ ff, sys.file$ tf,sys.ts$ ts
    where ts.ts#=ff.ts# and ff.file#=tf.relfile# and ts.ts#=tf.ts#
    group by ts.name, tf.blocks) c
    where a.tablespace_name = b.tablespace_name and a.tablespace_name = c.tablespace_name
```
* 查询表空间的碎片程度
```sql
    select tablespace_name,count(tablespace_name) from dba_free_space group by tablespace_name
    having count(tablespace_name)>10;

    alter tablespace name coalesce;
    alter table name deallocate unused;

    create or replace view ts_blocks_v as
    select tablespace_name,block_id,bytes,blocks,'free space' segment_name from dba_free_space
    union all
    select tablespace_name,block_id,bytes,blocks,segment_name from dba_extents;

    select * from ts_blocks_v;

    select tablespace_name,sum(bytes),max(bytes),count(block_id) from dba_free_space
    group by tablespace_name;
```
* 查询有哪些数据库实例在运行
```sql
    select inst_name from v$active_instances;
    --取得服务器的IP 地址
    select utl_inaddr.get_host_address from dual
    --取得客户端的IP地址
    select sys_context('userenv','host'),sys_context('userenv','ip_address') from dual
```


