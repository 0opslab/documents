#!/usr/bin/python
#-*- coding: utf-8 -*-

'''
   Use:             Backup MySQL DB
   Script Name:     mysql_db_backup.py
'''

import os
import time
import commands
import tarfile
from datetime import timedelta, datetime

###  全局变量定义

backup_path = '/data/backup/mysql/'
log_path = '/data/log/'
log_file = '/data/log/mysql_backup.log'
dbname = ['iduoqian', 'iduoqian_bbs', 'mysql']
dbhost = 'localhost'
dbuser = 'bakuser'
dbpasswd = 'backup2014'
date = time.strftime("%Y%m%d")
#保留几天内的备份
keep_day = 7

if not os.path.isdir(backup_path):
    os.mkdir(backup_path)

if not os.path.isdir(log_path):
    os.mkdir(log_path)

### 备份数据库
log = open (log_file,'ab')
log.write('-'*60 + '\n')
log.write('#'*60 + '\n')
log.write('#'*7 + '   数据库备份开始日期: %s    ' %(time.strftime("%Y-%m-%d %H:%M:%M")) + '#'*7 + '\n')
log.write('#'*60 + '\n')

print '#'*60
print '#'*7 + '   数据库备份开始日期: %s    ' %(time.strftime("%Y-%m-%d %H:%M:%M")) + '#'*7
print '#'*60
backfilename = []
for db in dbname:
    filename = 'MySQL-DB-%s-%s.sql' %(db, date)
    starttime= time.strftime("%Y:%m:%d %H:%M:%S")
    print '\033[1;33;5m\t\t开始备份数据库: %s\t\t\033[0m' %(db)
    log.write('\t\t开始备份数据库: %s\t\t\n' %(db))
    cmd = '/usr/local/bin/mysqldump -h%s -u%s -p%s --lock-tables=false %s > %s%s' %(dbhost, dbuser, dbpasswd, db, backup_path, filename)
    (backstat, backres) = commands.getstatusoutput(cmd)
    endtime= time.strftime("%Y:%m:%d %H:%M:%S")

    if backstat == 0:
        print '\033[1;32m[成功]\033[0m\t数据库:  \033[0;34m%s\033[0m  备份已完成...' %(db)
        log.write('[成功]\t数据库:  %s 备份已完成...\n' %(db))
        print '备份开始时间: %s' %(starttime)
        log.write('备份开始时间: %s\n' %(starttime))
        print '备份结束时间: %s' %(endtime)
        log.write('备份结束时间: %s\n' %(starttime))
    else:
        print '\033[1;31m[失败]\033[0m\t数据库:  \033[0;34m%s\033[0m  备份失败, 失败原因如下: \n%s\n' %(db, backres)
        log.write('[失败]\t数据库:  %s  备份失败, 失败原因如下:\n%s\n' %(db, backres))
    backfilename.append(filename)

### 归档压缩备份文件

os.chdir(backup_path)
tarname = backup_path + 'MySQL-DB-Backup-iduoqian-%s.tar.gz' %(date)
tar = tarfile.open(tarname,'w|gz')

print '\033[1;33;5m\t\t开始归档压缩备份文件\t\t\033[0m'
log.write('\t\t开始归档压缩备份文件\t\t\n')
for name in backfilename:
    tar.add(name)
tar.close()

print '\033[1;32m[成功]\033[0m\t数据压缩已完成'
log.write('[成功]\t数据压缩已完成\n')

### 删除临时文件
print '\033[1;33;5m\t\t开始清理临时文件\t\t\033[0m'
log.write('[成功]\t\t开始清理临时文件\t\t\n')
for name in backfilename:
    os.remove(name)

print '\033[1;32m[成功]\033[0m\t临时文件清理完成'
log.write('[成功]\t临时文件清理完成\n')

### 清理几天内文件

now = datetime.now()
old = now - timedelta(keep_day)
olddate = old.strftime('%Y%m%d')
exist = os.path.exists('MySQL-DB-Backup-iduoqian-%s.tar.gz' %(olddate))

print '\033[1;33;5m\t\t开始清理天内备份文件\t\t\033[0m'
log.write('\t\t开始清理七天内备份文件\t\t\n')
if exist:
    os.remove('MySQL-DB-Backup-iduoqian-%s.tar.gz' %(olddate))
    print '\033[1;32m[成功]\033[0m\t%s天内备份文件清理完成'%(keep_day)
    log.write('[成功]%s天内备份文件清理完成\n'%(keep_day))
else:
    print '\033[1;32m[成功]\033[0m\t未发现%s日内备份文件'%(keep_day)
    log.write('[成功]未发现%日内备份文件\n'%(keep_day))

print '#'*60
print '#'*7 + '   数据库备份结束日期: %s    ' %(time.strftime("%Y-%m-%d %H:%M:%M")) + '#'*keep_day
print '#'*60

log.write('#'*60 + '\n')
log.write('#'*keep_day + '   数据库备份结束日期: %s    ' %(time.strftime("%Y-%m-%d %H:%M:%M")) + '#'*keep_day + '\n')
log.write('#'*60 + '\n')
log.close()
