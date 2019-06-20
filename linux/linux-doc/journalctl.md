# Actively follow log (like tail -f)
# 积极关注日志
journalctl -f

# Display all errors since last boot
# 显示上次启动后的所有错误
journalctl -b -p err

# Filter by time period
# 按时间段过滤
journalctl --since=2012-10-15 --until="2011-10-16 23:59:59"
 
# Show list of systemd units logged in journal
#显示日志中记录的systemd单元列表
journalctl -F _SYSTEMD_UNIT

# Filter by specific unit
# 按特定单位过滤
journalctl -u dbus

# Filter by executable name
# 按可执行名称过滤
journalctl /usr/bin/dbus-daemon

# Filter by PID
# 按照PID过来
journalctl _PID=123

# Filter by Command, e.g., sshd
按命令过滤，例如sshd
journalctl _COMM=sshd

# Filter by Command and time period
# 按命令和时间段过滤
journalctl _COMM=crond --since '10:00' --until '11:00'

# List all available boots 
# 列出所有可用的boots
journalctl --list-boots

# Filter by specific User ID e.g., user id 1000 
# 按特定用户ID过滤，例如用户ID 1000
journalctl _UID=1000
