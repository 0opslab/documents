# title{screen - 命令用于多重视窗管理程序}

### 选项
```bash
-A 　将所有的视窗都调整为目前终端机的大小。
-d<作业名称> 　将指定的screen作业离线。
-h<行数> 　指定视窗的缓冲区行数。
-m 　即使目前已在作业中的screen作业，仍强制建立新的screen作业。
-r<作业名称> 　恢复离线的screen作业。
-R 　先试图恢复离线的作业。若找不到离线的作业，即建立新的screen作业。
-s<shell> 　指定建立新视窗时，所要执行的shell。
-S<作业名称> 　指定screen作业的名称。
-v 　显示版本信息。
-x 　恢复之前离线的screen作业。
-ls或–list 　显示目前所有的screen作业。
-wipe 　检查目前所有的screen作业，并删除已经无法使用的screen作业。
```

### 常用命令

```bash
# Start a new named screen session:
#启动一个新的命名屏幕会话：
screen -S session_name

# Detach from the current session:
#从当前会话中分离：
Press Ctrl+A then press d

# Re-attach a detached session:
#重新附加分离的会话：
screen -r session_name

# List all screen sessions:
#列出所有屏幕会话：
screen -ls
```