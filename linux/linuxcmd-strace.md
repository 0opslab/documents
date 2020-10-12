# Basic stracing
#基本的支撑
strace <command>

# save the trace to a file
#将跟踪保存到文件
strace -o strace.out <other switches> <command>

# follow only the open() system call
#只关注open（）系统调用
strace -e trace=open <command>

# follow all the system calls which open a file
#按照打开文件的所有系统调用
strace -e trace=file <command>

# follow all the system calls associated with process
#按照与进程关联的所有系统调用
# management
#管理
strace -e trace=process <command>

# follow child processes as they are created
#在创建时跟踪子进程
strace -f <command>

# count time, calls and errors for each system call
#计算每个系统调用的时间，调用和错误
strace -c <command>

# trace a running process (multiple PIDs can be specified)
#跟踪正在运行的进程（可以指定多个PID）
strace -p <pid>