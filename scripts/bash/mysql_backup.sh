#!/bin/bash
#
#===============================
# Description: mysql backup scripts
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2017.12.28
# Version: 1.0
#===============================
#
# mysql root账号
id="root"
pwd="root"
# mysql 库名称，注意要以空格隔开
databases="vsftpd  test " 
#databases="test"
# mysql 备份目录 
backupdir="/home/mysqldatabak"
# mysql 备份保留时间
day=15

[ ! -d $backupdir ] && mkdir -p $backupdir
cd $backupdir

backupname=$(date +%Y-%m-%d)
for db in $databases;
do
   mysqldump -u$id -p$pwd -S /var/lib/mysql/mysql.sock $db >$backupname_$db.sql 
   if [ "$?" == "0" ] 
   then
       echo $(date +%Y-%m-%d)" $db  mysqldump sucess">>mysql.log 
   else
      echo $(date +%Y-%m-%d)"  $db mysql dump failed">>mysql.log
      exit 0
   fi
done
for db in $databases;
do
	tar -czf $db.$backupname.tar.gz $db.sql
done
if [ "$?" == "0" ]
then
   echo $(date +%Y-%m-%d)" tar sucess">>mysql.log
else
   echo $(date +%Y-%m-%d)" tar failed">>mysql.log
   exit 0
fi

# 删除所有sql文件，删除15天前的备份
rm -f *.sql
delname=mysql_$(date -d "$day day ago" +%Y-%m-%d).tar.gz
rm -f $delname



## 另完一款脚本


user='root'
passwd=''
database=test
nowtime=`date +%m-%d"-"%H:%M`
host=localhost
log=/var/log/mysqlbackup.log
backup_dir=/data/backup/
dump_command=/usr/local/mysql/bin/mysqldump
backup_file=/data/backup/$database-${nowtime}.sql

if [ ! -d "$backup_dir" ];then
    mkdir $backup_dir
fi
if [ ! -f "$log" ];then
    touch $log
fi
echo "Start to backup at $(date +%Y%m%d%H%M)" >> $log
$dump_command -u$user -p$passwd -h $host --opt --lock-all-tables --flush-logs --master-data=2 --databases $database|gzip > $backup_file.gz
if [ $? -eq 0 ];then
    echo "Backup is finish! at $(date +%Y%m%d%H%M)" >> $log    
    exit 0
else
    echo "Backup is Fail! at $(date +%Y%m%d%H%M)" >> $log
    exit 1
fi
