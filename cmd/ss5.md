# title{ss5 - ss5实现socke代理}

```bash
#!/bin/bash

yum -y install gcc gcc-c++ automake make pam-devel openldap-devel cyrus-sasl-devel  openssl-devel
wget http://jaist.dl.sourceforge.net/project/ss5/ss5/3.8.9-8/ss5-3.8.9-8.tar.gz
tar zxvf ss5-3.8.9-8.tar.gz
cd ss5-3.8.9-8
./configure && make && make install

cat >/etc/opt/ss5/ss5.passwd<<EOF
test 123123
aaa  123123
bbb  123123
EOF


##无分组无限制配置
cat >/etc/opt/ss5/ss5.conf<<EOF
auth      0.0.0.0/0       -         u
permit u        0.0.0.0/0       -       0.0.0.0/0       -       -       -       -       -
EOF


##创建分组
echo "test">/etc/opt/ss5/ulimit
echo "aaa" >>/etc/opt/ss5/ulimit
echo "bbb" >/etc/opt/ss5/limit

##有分组 ，有限制配置
cat >/etc/opt/ss5/ss5.conf<<EOF
auth      0.0.0.0/0       -         u
permit u       0.0.0.0/0       -       0.0.0.0/0       -        -       ulimit       -       -
permit u       0.0.0.0/0       -       0.0.0.0/0       80       -       limit        -       -

permit u       0.0.0.0/0       -       0.0.0.0/0       -         -      ulimit       -       -
permit u       0.0.0.0/0       -       0.0.0.0/0       443       -      limit        -       -
EOF


echo "SS5_OPTS=\" -u root -b 0.0.0.0:10888\"" >>/etc/sysconfig/ss5
##使用默认端口
##echo "SS5_OPTS=\" -u root\"" >>/etc/sysconfig/ss5
##/etc/rc.d/init.d/ss5 文件修改自定义端口，默认为1080
##daemon /usr/sbin/ss5 -t $SS5_OPTS -b 0.0.0.0:10888

chmod 700 /etc/rc.d/init.d/ss5
chmod +x  /etc/rc.d/init.d/ss5

##启动ss5
service ss5 start

##停止ss5
#service ss5 stop

##加入开机自动启动 centos6
#chkconfig --add ss5
#chkconfig --level 345 ss5 on

##查看日志启动是否成功
tail -f /var/log/ss5/ss5.log



yum -y install gcc gcc-c++ automake make pam-devel openldap-devel cyrus-sasl-devel openssl-devel
wget http://jaist.dl.sourceforge.net/project/ss5/ss5/3.8.9-8/ss5-3.8.9-8.tar.gz
tar zxvf ss5-3.8.9-8.tar.gz
cd ss5-3.8.9
./configure && make && make install

##无分组无限制配置
#cat >/etc/opt/ss5/ss5.conf<<EOF
#set SS5_PAM_AUTH
#auth      0.0.0.0/0       -         u
#permit u        0.0.0.0/0       -       0.0.0.0/0       -       -       -       -       -
#EOF

#useradd test -s /sbin/nologin
#useradd aaa -s /sbin/nologin
#useradd bbb -s /sbin/nologin

/usr/sbin/useradd username1  -s /sbin/nologin
echo eUqO5VLWj9m3FXy6 | passwd  --stdin username1

/usr/sbin/useradd username2  -s /sbin/nologin
echo ltQQEmH72NDQ51Er | passwd  --stdin username2

/usr/sbin/useradd username3  -s /sbin/nologin
echo MauDmldzvnsX5iUo | passwd  --stdin username3

##创建分组
echo "username1">/etc/opt/ss5/ulimit
echo "username2" >>/etc/opt/ss5/ulimit
echo "username3" >/etc/opt/ss5/limit

##有分组 ，有限制配置
cat >/etc/opt/ss5/ss5.conf<<EOF
set SS5_PAM_AUTH
auth      0.0.0.0/0       -         u
permit u       0.0.0.0/0       -       0.0.0.0/0       -        -       ulimit       -       -
permit u       0.0.0.0/0       -       0.0.0.0/0       80       -       limit        -       -

permit u       0.0.0.0/0       -       0.0.0.0/0       -         -      ulimit       -       -
permit u       0.0.0.0/0       -       0.0.0.0/0       443       -      limit        -       -
EOF


echo "SS5_OPTS=\" -u root -b 0.0.0.0:11888\"" >>/etc/sysconfig/ss5
##使用默认端口
##echo "SS5_OPTS=\" -u root\"" >>/etc/sysconfig/ss5
##/etc/rc.d/init.d/ss5 文件修改自定义端口，默认为1080
##daemon /usr/sbin/ss5 -t $SS5_OPTS -b 0.0.0.0:11888

echo "auth        required     /usr/lib64/security/pam_unix.so">>/etc/pam.d/ss5

chmod 700 /etc/rc.d/init.d/ss5
chmod +x  /etc/rc.d/init.d/ss5

##启动ss5
service ss5 start

##停止ss5
#service ss5 stop

##加入开机自动启动 centos6
#chkconfig --add ss5
#chkconfig --level 345 ss5 on

##查看日志启动是否成功
#tail -f /var/log/ss5/ss5.log

wget http://jaist.dl.sourceforge.net/project/ss5/ss5/3.8.9-8/ss5-3.8.9-8.tar.gz
tar zxvf ss5-3.8.9-8.tar.gz
cd ss5-3.8.9-8
./configure && make && make install

##配置SS5：
    # vi /etc/opt/ss5/ss5.conf
    ============+============+============+============+============
    #实现用户认证并限制带宽：
    set SS5_DNSORDER
    set SS5_PAM_AUTH
    auth 0.0.0.0/0 - u
    permit - 0.0.0.0/0 - 0.0.0.0/0 - - - 10240 -
    #如果要实现不同用户认证并分别限制带宽，在/etc/opt/ss5目录创建user和file两个文件，该文件中含有要认证的用户名：
    permit - 0.0.0.0/0 - 0.0.0.0/0 - - user 10240 -
    permit - 0.0.0.0/0 - 0.0.0.0/0 - - file 102400 -
    ============+============+============+============+============
##配置PAM认证：
    # vi /etc/pam.d/ss5
    ============+============+============+============+============
    auth optional /usr/lib/security/pam_mysql.so user=ss5 \
    passwd=121212 host=localhost db=ss5 table=user \
    usercolumn=username passwdcolumn=passwd crypt=2
    account required /usr/lib/security/pam_mysql.so user=ss5 \
    passwd=121212 host=localhost db=ss5 table=user \
    usercolumn=username passwdcolumn=passwd crypt=2
    ============+============+============+============+============
##安装PAM_MYSQL：
    # tar -zxvf pam_mysql-0.7RC1.tar.gz
    # cd pam_mysql-0.7RC1
    # ./configure --with-openssl --with-mysql=/usr/local/mysql
    # make
    # make install
    # echo "/usr/lib/security" >> /etc/ld.so.conf
    # ldconfig
##创建数据库:
    # mysqladmin -u root -pmysqldbserver create ss5
    # mysql -u root -pmysqldbserver
    mysql> use ss5;
    mysql> GRANT ALL PRIVILEGES ON ss5.* TO
    [email='ss5'@'localhost']'ss5'@'localhost'[/email]
     IDENTIFIED BY '121212';
    mysql> CREATE TABLE user (ID int not null auto_increment,USERNAME varchar(64), PASSWD varchar(255), primary key(ID) );
##添加测试用户：
    mysql> insert into user (username,passwd) values ('test',password('1234'));
```