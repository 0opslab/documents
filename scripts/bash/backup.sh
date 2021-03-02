#!/bin/bash
#
Dir=('/etc/httpd' '/etc/pam.d' '/etc/vsftpd')
Source=`dialog --stdout --title "Backup" --checklist "Choose the dir you want to backup: " 10 50 3 0 /etc/httpd 0 1 /etc/pam.d 1 2 /etc/vsftpd 0`
echo $Source
Source=`echo $Source | tr -d '"'`

for I in $Source; do
  echo ${Dir[$I]}
done



backupdir="/wwwroot/backup/backup1/"

if [ ! -d $backupdir ];then
	mkdir $backupdir
fi

# mkdir today backup

today=`date +%Y-%m-%d_%H_%M_%S`
fpath=$backupdir$today 
echo $fpath
if [ ! -d $fpath ];then
	mkdir $fpath
fi

# delete old file 

find $backupdir -type f -mtime +1 -print -exec /bin/rm -f {} \;

FL=`cat /wwwroot/backup/file_list_ftp`

for i in $FL ;do
	cp -Rp $i $fpath
done

# backup my self 
cp -Rp $0 $fpath
cp -Rp /wwwroot/backup/file_list_ftp $fpath

cd $backupdir
tar czf $today.tar.gz $today
rm -rf $today
cd -

# ftp ...

ftp -n<<!
open 192.168.1.12
user backup_q ftp111222
binary
lcd $backupdir
prompt off
mdelete *
mput *
bye
!