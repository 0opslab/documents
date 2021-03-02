#!/bin/bash
##备份数据库脚本
## http://www.aqzt.com
##email: ppabc@qq.com
##robert yu
id="root"
pwd="w@123123"
dbs="aqzhw  testdb " 
#dbs="aqzhw" 
backuppath="/home/mysqldatabak"
day=15
[ ! -d $backpath ] &&mkdir -p $backuppath
cd $backuppath

backupname=$(date +%Y-%m-%d)
for db in $dbs;
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
for db in $dbs;
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
rm -f *.sql
delname=mysql_$(date -d "$day day ago" +%Y-%m-%d).tar.gz
rm -f $delname


### 另外一款脚本

USERNAME=root
PASSWORD=m111111111111
#Date Format
DATE=`date +%Y%m%d`
#Back directory
DAYS=20
mkdir -p /backup/db-backup/${DATE}
BACKUP_DIR=/backup/db-backup/${DATE}
#MySQL directory
MYSQL_DIR=/usr/bin
#Go to the backup directory
cd ${BACKUP_DIR}
#The first instance of the backup
while read databasename
do
if [ -f ${databasename}_${DATE}.sql ]; then
echo MySQL Database ${databasename} ${DATE} backup file already exists.
else
${MYSQL_DIR}/mysqldump -u${USERNAME} -p${PASSWORD} ${databasename} --default-character-set=utf8 --opt -Q -R --skip-lock-tables > ${databasename}_${DATE}.sql
fi
done < /home/databasename.txt
find /backup/db-backup/ -name "20*" -type d -mtime +22|tee -a /home/del.txt|xargs rm -r 2>>/home/err.txt

##先做SSH无密码认证，SCP传到另外一台备份
/usr/bin/scp -r /backup/db-backup/${DATE} root@10.10.1.112:/mybk/db-backup/bak/

##删除旧备份文件
#find /mybk/db-backup/ -name "20*" -type f -mtime +${DAYS} -exec rm {} \;
exit 0