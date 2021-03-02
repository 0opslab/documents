# title{mail - 命令行下发送和接收电子邮件}

### 选项
```bash
-b<地址>：指定密件副本的收信人地址；
-c<地址>：指定副本的收信人地址；
-f<邮件文件>：读取指定邮件文件中的邮件；
-i：不显示终端发出的信息；
-I：使用互动模式；
-n：程序使用时，不使用mail.rc文件中的设置；
-N：阅读邮件时，不显示邮件的标题；
-s<邮件主题>：指定邮件的主题；
-u<用户帐号>：读取指定用户的邮件；
-v：执行时，显示详细的信息。
```



```bash
#!/bin/bash

##定时更换/etc/mail.rc配置文件
##0 */12 * * * /data/shell/mail.sh
check=`cat /tmp/mail_check.log`
if [ "$check" == "1" ];then
cat >/etc/mail.rc<<EOF
set hold
set append
set ask
set crt
set dot
set keep
set emptybox
set indentprefix="> "
set quote
set sendcharsets=iso-8859-1,utf-8
set showname
set showto
set newmail=nopoll
set autocollapse
ignore received in-reply-to message-id references
ignore mime-version content-transfer-encoding
fwdretain subject date from to
set bsdcompat
set from=test1@nagios.com smtp=192.168.1.12
set smtp-auth-user=test1@nagios.com smtp-auth-password=testtest20160722a smtp-auth=login
EOF
echo "2" > /tmp/mail_check.log
fi


if [ "$check" == "2" ];then
cat >/etc/mail.rc<<EOF
set hold
set append
set ask
set crt
set dot
set keep
set emptybox
set indentprefix="> "
set quote
set sendcharsets=iso-8859-1,utf-8
set showname
set showto
set newmail=nopoll
set autocollapse
ignore received in-reply-to message-id references
ignore mime-version content-transfer-encoding
fwdretain subject date from to
set bsdcompat
set from=test2@nagios.com smtp=192.168.1.15
set smtp-auth-user=test2@nagios.com smtp-auth-password=testtest20160722b smtp-auth=login
EOF
echo "1" > /tmp/mail_check.log
fi
date >> /tmp/mail_time.log

```




