# title{task - 任务相关}

```bash
at 5pm + 3 days /bin/ls  # 单次定时任务 指定三天后下午5:00执行/bin/ls
crontab -e               # 编辑周期任务
#分钟  小时    天  月  星期   命令或脚本
1,30  1-3/2    *   *   *      命令或脚本  >> file.log 2>&1
echo "40 7 * * 2 /root/sh">>/var/spool/cron/root    # 直接将命令写入周期任务
crontab -l                                          # 查看自动周期性任务
crontab -r                                          # 删除自动周期性任务
cron.deny和cron.allow                               # 禁止或允许用户使用周期任务
service crond start|stop|restart                    # 启动自动周期性服务
```