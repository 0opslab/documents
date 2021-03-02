# title{oracle-auto-start - linux下oracle自启动配置}

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