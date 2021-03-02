# title{log - 日志相关的常用命令}

```bash
# 历时命令默认1000条
history
# 让history命令显示具体时间
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
# 清除记录命令
history  -c
# 历史命令记录文件
cat $HOME/.bash_history
# 查看登陆过的用户信息
last
# 查看登陆过的用户信息
who /var/log/wtmp
# 用户最后登录的时间
lastlog
# 列出登录系统失败的用户相关信息
lastb -a
# 登录失败二进制日志记录文件
/var/log/btmp
# 系统日志
tail -f /var/log/messages
# ssh日志
tail -f /var/log/secure
```