title: linux下的计划任务
date: 2016-01-02 16:22:26
tags: Linux
categories: Linux
---
linux下常用的计划任务相关的命令
```bash
At	安排作业在某一时刻执行一次
Batch	安排作业在系统负载不重时执行一次
Cron	安排周期性运行的作业
```
# at
命令at在指定的时刻执行指定的命令序列。也就说该命令至少需要指定一个命令，一个执行时间才能正常运行
该命令的语法格式为
```bash
at [-V] [-q队列] [-f 文档名] [-mldbv] 时间
at –c 作业 [作业....]
// 参数解释
	-V   讲标准版本好打印
	-q   queue 使用指定的队列。队列名称是由单个字母组成。合法的队列名能够由
	a~z组成
	-m	 作业结束后发送邮件给执行命令的用户
	-f file 使用该选项讲命令从指定的file读取，而不是从标准入读取
	-l	 同命令atq作用相同，用于查看安排的作业序列
	-d   同命令atrm作用相同，改用命令用于删除指定的命令序列
	-c   讲命令行上所有列的作业标准输出.
```
At运行使用一套相当复杂的指定时间的方法。实际上是讲POSIX.2标准扩展了。它能够接受当天的
HH:MM式的时间指定。假如时间已经过去，讲在第二天执行。用户还能够采用12小时计时制。即在
时间后面加上AM或PM来说明是上午还是下午。也能够指定命令执行的具体日期，指定格式为
month day或mm/dd/yy(月日年)，指定的日期必须跟在指定时间的后面。
当然还可以使用相对计时法。指定格式为:now + count time-units,now就是当前时间，
time-units是时间单位minutes，hours，days，weeks。例如
```bash
at  5:30pm
at  17:30 today
at  now +300 minutes
at  17:30 08.12.13
```
对于at命令来说，需要定时执行的命令是从标准输入或使用-f选项指定的文档中读取并运行。
```bash
$ at –f work 10am #今天十点是执行work文档中的作业
```
Root用户能在任何情况下使用这个命令，对于其他用户来说，是否能够使用就取决于俩个文档
/etc/at.allow和/etc/at.deny如果/etc/at.allow文档存在的话，那么只有在其中列出的用
户才能够使用at命令，假如该不存在怎检查/etc/at.deny文档，在这个文档中列出的用户都不
能使用该命令.如果俩个文档都不存在，那么只有终极用户才能使用该命令.
例如：（使用at命令需要atd-daemon）注：输入at +时间后 在at>中输入命令 以<EOT>结束。（Ctrl+D）

# batch命令
作用：安排一个或多个命令在系统负载比较轻的时候运行。使用方法同at命令

# crontab命令
在linux系统中有俩个守护进程cron和anacron用于自动执行周期性任务。Cron和anacron是完全不同的
俩个用于定期执行任务的守护进程。
 - Cron假定服务器是24*7全天候允许，当系统时间变化或有一段时间关机就会遗漏这一时间段应该执行的cron任务
 - Anacron是cron的一个连续时间版本。它不会因为时间不连续而导致任务的不执行
Anacron是针对非全天候运行而设计的，当anacron发现时间不连续时，也会执行这一时间段内该执行的任务。
每个用户都可以安排自己的cron任务。超级用户可以管理系统的cron任务anacron任务。
Cron守护进程启动以后，它将首先检查是否有用户设置了crontab文件.cron守护进程首先会搜索
/var/spool/cron目录。寻找以/etc/passwd文件中的用户名命名的crontab文件。
# 控制安排cron任务的人员
是否每个用户都可以安排cron任务。需要受如下俩个文件的限制
/etc/cron.allow
/etc/cron.deny
当用户每次安排cron任务时，系统会先查找/etc/cron.allow文件，若该文件存在，则只要包含在此文件的用户允许使用cron
若/etc/cron.allow文件不存在，系统继续查找/etc/cron.deny文件，若该文件存在，则只有包含在此文件中的用户禁止使用cron
/etc/cron.allow文件和/etc/cron.deny文件的格式很简单，每行只能包含一个用户名，且不能有空格字符
# 常用的参数
crontab -e : 执行文字编辑器来设定时程表,内定的文字编辑器是 VI,如果想用别的文字编辑器,
则请先设定 VISUAL 环境变数
crontab -r : 删除目前的时程表
crontab -l : 列出目前的时程表
crontab file [-u user]-用指定的文件替代目前的 crontab
```bash
基本格式 :
*  *  *  *  *  command
分 时 日 月 周 命令
第 1 列表示分钟 1~59 每分钟用*或者 */1 表示
第 2 列表示小时 1~23(0 表示 0 点)
第 3 列表示日期 1~31
第 4 列表示月份 1~12
第 5 列标识号星期 0~6(0 表示星期天)
第 6 列要运行的命令
```
# 使用方式
```bash
crontab file [-u user]-用指定的文件替代目前的 crontab。
crontab-[-u user]-用标准输入替代目前的 crontab.
crontab-1[user]-列出用户目前的 crontab.
crontab-e[user]-编辑用户目前的 crontab.
crontab-d[user]-删除用户目前的 crontab.
crontab-c dir- 指定 crontab 的目录。
crontab 文件的格式:M H D m d cmd
```


# 例子
```bash
30 21 * * * /usr/local/etc/rc.d/lighttpd restart
上面的例子表示每晚的 21:30 重启 apache。
45 4 1,10,22 * * /usr/local/etc/rc.d/lighttpd restart
上面的例子表示每月 1、10、22 日的 4 : 45 重启 apache。
10 1 * * 6,0 /usr/local/etc/rc.d/lighttpd restart
上面的例子表示每周六、周日的 1 : 10 重启 apache。
0,30 18-23 * * * /usr/local/etc/rc.d/lighttpd restart
上面的例子表示在每天 18 : 00 至 23 : 00 之间每隔 30 分钟重启 apache。
0 23 * * 6 /usr/local/etc/rc.d/lighttpd restart
上面的例子表示每星期六的 11 : 00 pm 重启 apache。
* */1 * * * /usr/local/etc/rc.d/lighttpd restart
每一小时重启 apache
* 23-7/1 * * * /usr/local/etc/rc.d/lighttpd restart
晚上 11 点到早上 7 点之间,每隔一小时重启 apache
0 11 4 * mon-wed /usr/local/etc/rc.d/lighttpd restart
每月的 4 号与每周一到周三的 11 点重启 apache
0 4 1 jan * /usr/local/etc/rc.d/lighttpd restart
一月一号的 4 点重启 apache
```
