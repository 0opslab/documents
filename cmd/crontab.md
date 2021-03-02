# title{crontab - 用来完成一些定时任务}

文件夹内找到相关配置文件。

/var/spool/cron/ 目录下存放的是每个用户包括root的crontab任务，每个任务以创建者的名字命名
/etc/crontab 这个文件负责调度各种管理和维护任务。
/etc/cron.d/ 这个目录用来存放任何要执行的crontab文件或脚本。
我们还可以把脚本放在/etc/cron.hourly、/etc/cron.daily、/etc/cron.weekly、/etc/cron.monthly目录中，让它每小时/天/星期、月执行一次。


```bash
# set a shell
#设置一个shell
SHELL=/bin/bash

# crontab format
#crontab格式
* * * * *  command_to_execute
- - - - -
| | | | |
| | | | +- day of week (0 - 7) (where sunday is 0 and 7)
| | | +--- month (1 - 12)
| | +----- day (1 - 31)
| +------- hour (0 - 23)
+--------- minute (0 - 59)

# example entries
#示例条目
# every 15 min
#每15分钟一次
*/15 * * * * /home/user/command.sh

# every midnight
#每个午夜
0 0 * * * /home/user/command.sh

# every Saturday at 8:05 AM
#每周六上午8:05
5 8 * * 6 /home/user/command.sh
```

## 日志
日志文件位置

默认情况下,crontab中执行的日志写在/var/log下,如:
#ls /var/log/cron*
/var/log/cron /var/log/cron.1 /var/log/cron.2 /var/log/cron.3 /var/log/cron.4

crontab的日志比较简单，当crond执行任务失败时会给用户发一封邮件。恰巧在我们的一台服务器上发现一个任务没有正常执行，而且crond发邮件也失败了。通过看mail的日志，看到是磁盘空间不足造成的。
可以将每条 crontab中的任务增加自己的日志，有利于查找执行失败原因。
0 6 * * * //root/script/ss.sh >> /root/for_crontab/mylog.log 2>&1
把错误输出和标准输出都输出到mylog.log中。