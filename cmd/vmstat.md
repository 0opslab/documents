# title{vmstat - 显示虚拟内存状态}

### 选项
```bash
-a：显示活动内页；
-f：显示启动后创建的进程总数；
-m：显示slab信息；
-n：头信息仅显示一次；
-s：以表格方式显示事件计数器和内存状态；
-d：报告磁盘状态；
-p：显示指定的硬盘分区状态；
-S：输出信息的单位。
```

### 常用命令
```bash
#显示活跃和非活跃内存
vmstat -a 2 5
#显示从系统启动至今的fork数量
vmstat -f 

#查看内存使用的详细信息
vmstat -s 

#查看磁盘的读/写
vmstat -d 

```

### 常用脚本
```bash
#!/bin/sh
os=`uname`
run_queue=0
blocked=0
swapped=0
vmexec=`which vmstat | awk '{print $1}'`
if [ "$vmexec" = "no" ]
then
  echo "error_text=vmstat command not found!"
  exit 0
fi

if [ "$os" = "linux" ] || [ "$os" = "Linux" ]
then
  temp=`vmstat |tail -1`
  run_queue=`echo $temp |awk '{printf("%s\n",$1)}'`
  blocked=`echo $temp |awk '{printf("%s\n",$2)}'`
  swapped=`echo $temp |awk '{printf("%s\n",$3)}'`

elif [ "$os" = "AIX" ] || [ "$os" = "aix" ]
then
  temp=`vmstat 1 5 |tail -1`
  run_queue=`echo $temp |awk '{printf("%s\n",$1)}'`
  blocked=`echo $temp |awk '{printf("%s\n",$2)}'`
  swapped=0

elif [ "$os" = "HP-UX" ]
then
  temp=`vmstat 1 5 |tail -1`
  run_queue=`echo $temp |awk '{printf("%s\n",$1)}'`
  blocked=`echo $temp |awk '{printf("%s\n",$2)}'`
  swapped=`echo $temp |awk '{printf("%s\n",$3)}'`

elif [ "$os" = "SCO_SV" ] || [ "$os" = "UnixWare" ]
then
  temp=`vmstat 1 5 |tail -1`
  run_queue=`echo $temp |awk '{printf("%s\n",$1)}'`
  blocked=`echo $temp |awk '{printf("%s\n",$2)}'`
  swapped=`echo $temp |awk '{printf("%s\n",$3)}'`

else
  temp=`vmstat 1 5 |tail -1`
  run_queue=`echo $temp |awk '{printf("%s\n",$1)}'`
  blocked=`echo $temp |awk '{printf("%s\n",$2)}'`
  swapped=`echo $temp |awk '{printf("%s\n",$3)}'`
fi

echo "Run queue length=$run_queue"
echo "Blocked processes=$blocked"
echo "Runnable but swapped processes=$swapped"
if [ "$os" = "AIX" ] || [ "$os" = "aix" ]
then
  echo "status_text=Processes run:{0}, blocked:{1};;;${run_queue};;;${blocked}"
else
  echo "status_text=Processes run:{0}, blocked:{1}, swapped:{2};;;${run_queue};;;${blocked};;;${swapped}"
fi

exit

```
