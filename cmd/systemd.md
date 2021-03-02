# title{systemd - Systemd 是 Linux 系统工具，用来启动守护进程，已成为大多数发行版的标准配置}

```bash
# Display process startup time
#显示进程启动时间
systemd-analyze

# Display process startup time at service level
#显示服务级别的进程启动时间
systemd-analyze blame

# List running units
#列出运行单位
systemctl list-units

# Load a unit at startup
#在启动时加载一个单元
systemctl enable foo.service

# Start or Stop a unit
#启动或停止装置
systemctl <start | stop> foo.service

# Unit file locations
#单位文件位置
/etc/systemd/system
/usr/lib/systemd/system
```

### link
http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html
