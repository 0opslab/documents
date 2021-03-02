# title{shutdown - 可以用来进行关机程序}

### 选项
```bash
-t seconds : 设定在几秒钟之后进行关机程序
-k : 并不会真的关机，只是将警告讯息传送给所有只用者
-r : 关机后重新开机
-h : 关机后停机
-n : 不采用正常程序来关机，用强迫的方式杀掉所有执行中的程序后自行关机
-c : 取消目前已经进行中的关机动作
-f : 关机时，不做 fcsk 动作(检查 Linux 档系统)
-F : 关机时，强迫进行 fsck 动作
time : 设定关机的时间
message : 传送给所有使用者的警告讯息
```

### 常用命令
```bash
# Reboot the system immediately
#立即重新启动系统
shutdown -r now

# Shut system down immediately
#立即关闭系统
shutdown -h now

# Reboot system after 5 minutes
#5分钟后重启系统
shutdown -r +5
```
