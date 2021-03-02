# title{watch - 周期性执行命令/定时执行命令}

### 选项
```bash
-n # 或--interval  watch缺省每2秒运行一下程序，可以用-n或-interval来指定间隔的时间。
-d # 或--differences  用-d或--differences 选项watch 会高亮显示变化的区域。 
  # 而-d=cumulative选项会把变动过的地方(不管最近的那次有没有变动)都高亮显示出来。
-t # 或-no-title  会关闭watch命令在顶部的时间间隔,命令，当前时间的输出。
-h, --help # 查看帮助文档
```


### 常用命令
```bash
# 监测命令动态刷新
watch uptime                
# 命令：每隔一秒高亮显示网络链接数的变化情况
watch -n 1 -d netstat -ant       
# 每隔一秒高亮显示http链接数的变化情况。 后面接的命令若带有管道符，需要加''将命令区域归整。
watch -n 1 -d 'pstree|grep http' 
 # 实时查看模拟攻击客户机建立起来的连接数
watch 'netstat -an | grep:21 | \ grep<模拟攻击客户机的IP>| wc -l'
# 监测当前目录中 scf' 的文件的变化
watch -d 'ls -l|grep scf'       
# 10秒一次输出系统的平均负载
watch -n 10 'cat /proc/loadavg' 
watch uptime
watch -t uptime
watch -d -n 1 netstat -ntlp
# 监测goface的文件
watch -d 'ls -l | fgrep goface'     
watch -t -differences=cumulative uptime
# 监控mail
watch -n 60 from            
# 监测磁盘inode和block数目变化情况
watch -n 1 "df -i;df"      
watch -n 10 'bin/redis-cli -h 135.191.27.193 -p 5380 -a xwsptyapp info | grep clients'
watch -n 10 -d 'find . -name server.log | xargs grep com.xwtec.qhmccCommon.jdbc.JdbcConnectUtils | wc -l '
 
```