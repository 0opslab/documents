# title{chkconfig - 命令用于检查，设置系统的各种服务}
chkconfig 服务名 on|off|set              # 设置非独立服务启状态
chkconfig --level 35   httpd   off       # 让服务不自动启动
chkconfig --level 35   httpd   on        # 让服务自动启动 35指的是运行级别
chkconfig --list                         # 查看所有服务的启动状态
chkconfig --list |grep httpd             # 查看某个服务的启动状态
chkconfig –-list [服务名称]              # 查看服务的状态

```bash
# 启动服务  
/etc/init.d/sendmail start
# 关闭服务
/etc/init.d/sendmail stop
# 查看服务当前状态
/etc/init.d/sendmail status
# 启动mysql后台运行
/date/mysql/bin/mysqld_safe --user=mysql &
# 开机启动执行  可用于开机启动脚本
vi /etc/rc.d/rc.local
# 开机启动和关机关闭服务连接    # S开机start  K关机stop  55级别 后跟服务名
/etc/rc.d/rc3.d/S55sshd
# 将启动程序脚本连接到开机启动目录
ln -s -f /date/httpd/bin/apachectl /etc/rc.d/rc3.d/S15httpd
# lvs查看后端负载机并发
ipvsadm -ln
# lvs清除规则
ipvsadm -C
# 查看xen虚拟主机列表
xm list
# 虚拟化(xen\kvm)管理工具  yum groupinstall Virtual*
virsh
# 查看httpd加载模块
./bin/httpd -M
# rpm包httpd查看加载模块
httpd -t -D DUMP_MODULES
# 发送邮件
echo 内容| /bin/mail -s "标题" 收件箱 -- -f 发件人
# 解决邮件乱码
"`echo "内容"|iconv -f utf8 -t gbk`" | /bin/mail -s "`echo "标题"|iconv -f utf8 -t gbk`" 收件箱
# 检测nagios配置文件
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
```