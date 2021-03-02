# title{kill - 用于删除执行中的程序或工作}

kill可将指定的信息送至程序。预设的信息为SIGTERM(15)，可将指定程序终止。若仍无法终止该程序，
可使用SIGKILL(9)信息尝试强制删除程序。程序或工作的编号可利用ps指令或jobs指令查看。

#usage
kill[参数][进程id]

## 命令参数
-l  信号，若果不加信号的编号参数，则使用“-l”参数会列出全部的信号名称
-a  当处理当前进程时，不限制命令名和进程号的对应关系
-p  指定kill 命令只打印相关进程的进程号，而不发送任何信号
-s  指定发送信号
-u  指定用户

# 列出所有信号名称
# 只有第9种信号(SIGKILL)才可以无条件终止进程，其他信号进程都有权利忽略。 
#HUP    1    终端断线
#INT     2    中断（同 Ctrl + C）
#QUIT    3    退出（同 Ctrl + \）
#TERM   15    终止
#KILL    9    强制终止
#CONT   18    继续（与STOP相反， fg/bg命令）
#STOP    19    暂停（同 Ctrl + Z）

kill -l


# Kill a process gracefully
#优雅地杀死一个过程
kill -15 <process id>

# Kill a process forcefully
#强行杀死一个过程
kill -9 <process id>

# 过滤出hnlinux用户进程 并杀死
kill -9 $(ps -ef | grep hnlinux)
