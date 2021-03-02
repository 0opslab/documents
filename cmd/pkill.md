# title{pkill - 用于杀死一个进程，与 kill 不同的是它会杀死指定名字的所有进程}

### 选项
```bash
-P 指定父进程号发送信号
-g 指定进程组
-t 指定开启进程的终端
```

### 常用命令
```bash
# To kill a process using it's full process name
#使用它的完整进程名称来终止进程
pkill <processname>

# To kill a process by it's partial name
#通过它的部分名称来杀死进程
pkill -f <string>
```
