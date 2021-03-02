# title{pgrep - 以名称为依据从运行进程队列中查找进程，并显示查找到的进程id}

以名称为依据从运行进程队列中查找进程，并显示查找到的进程id。每一个进程ID以一个十进制数表示，
通过一个分割字符串和下一个ID分开，默认的分割字符串是一个新行。对于每个属性选项，用户可以在命
令行上指定一个以逗号分割的可能值的集合。
### 选项
```bash
-o：仅显示找到的最小（起始）进程号；
-n：仅显示找到的最大（结束）进程号；
-l：显示进程名称；
-P：指定父进程号；
-g：指定进程组；
-t：指定开启进程的终端；
-u：指定进程的有效用户ID。
```


### 常用命令
```bash
# Get a list of PIDs matching the pattern 
#获取与模式匹配的PID列表
pgrep example

# Kill all PIDs matching the pattern
#杀死与模式匹配的所有PID
pgrep -f example | xargs kill
```
