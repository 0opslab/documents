# Start tmux:
#启动tmux：
tmux

# Detach from tmux:
#从tmux分离：
Ctrl-b d

# Restore tmux session:
#恢复tmux会话：
tmux attach

# Detach an already attached session (great if you are moving devices with different screen resolutions)
#分离已连接的会话（如果您正在移动具有不同屏幕分辨率的设备，则非常棒）
tmux attach -d 

# Display session:
#显示会话：
tmux ls

# Rename session:
#重命名会话：
Ctrl-b $

# Switch session:
#切换会话：
Ctrl-b s

# Start a shared session:
#启动共享会话：
tmux -S /tmp/your_shared_session
chmod 777 /tmp/your_shared_session

# Help screen (Q to quit):
#帮助屏幕（Q退出）：
Ctrl-b ?

# Scroll in window:
#滚动窗口：
Ctrl-b PageUp/PageDown

# Reload configuation file
#重新加载配置文件
Ctrl-b : source-file /path/to/file

# Window management
#窗口管理
# =================
#=================

# Create window:
#创建窗口：
Ctrl-b c

# Destroy window:
#销毁窗口：
Ctrl-b x

# Switch between windows:
#在窗口之间切换：
Ctrl-b [0-9]
or
Ctrl-b Arrows

# Split windows horizontally:
#水平分割窗口：
Ctrl-b %

# Split windows vertically:
#垂直拆分窗口：
Ctrl-b "
