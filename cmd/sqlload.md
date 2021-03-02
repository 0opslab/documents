# title{sqlload - sqlload导入数据库}


export ORACLE_SID=XE
export NLS_LANG=american_america.AL32UTF8
 
#数据库结构控制文件
CTL_FILE=/Vminfo/Vmdata.ctl
#sqlload输出日志文件
LOG_FILE=/Vminfo/sqlload.log
#数据文件
DATA_FILE=/Vminfo/Vmdata${ddate}.txt
 
sqlldr ARADMIN/clmAdm1n@10.200.108.100/XE control=${CTL_FILE} data=${DATA_FILE} log=${LOG_FILE}
 
# Clean log files
# clear yesterday's data
rm -f /Vminfo/Vmdata${yydate}.txt /Vminfo/Vmdata${ydate}.bad /Vminfo/Export66VMinfo${yydate}.csv /Vminfo/Export32VMinfo${yydate}.csv /Vminfo/ExportAllVMinfo${yydate}.csv
clm-db1:/Vminfo # 


## 控制文件
LOAD DATA
INFILE 'result/stat-20100821-detail.txt'
replace
into table LOGDETAILS_20100821 --   insert  append replace
FIELDS TERMINATED BY ' |+-s| ' --字段分割符号
TRAILING NULLCOLS --允许匹配不到的字段
(
  ID            RECNUM  , --RECNUM属性来实现id的自增 如果入库方式是追加一定要使用序列COUNTERINFO_SEQ.nextval
  IP            ,
  HITTIME       "to_date(:HITTIME, 'YYYY-MM-DD HH24:Mi:SS')",
  URL           ,
  STATUS        ,
  SIZES         ,
  URL_SOURCE    char(1024),
  TOOLS         char(1024),
  SERVERINFO    ,
  SYSTEM_ID     ,
  SOURCETYPE_ID ,
  SERVERSOURCE 
)