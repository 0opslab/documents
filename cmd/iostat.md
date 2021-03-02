# title{iostat - 监视系统输入输出设备和CPU的使用情况}

被用于监视系统输入输出设备和CPU的使用情况。它的特点是汇报磁盘活动统计情况，同时也会汇报出CPU使用情况。
同vmstat一样，iostat也有一个弱点，就是它不能对某个进程进行深入分析，仅对系统的整体情况进行分析

### 常用选项
```bash
-c：仅显示CPU使用情况；
-d：仅显示设备利用率；
-k：显示状态以千字节每秒为单位，而不使用块每秒；
-m：显示状态以兆字节每秒为单位；
-p：仅显示块设备和所有被使用的其他分区的状态；
-t：显示每个报告产生时的时间；
-V：显示版号并退出；
-x：显示扩展状态。

```

### 输出选项说明
```bash
Device	监测设备名称
rrqm/s	每秒需要读取需求的数量
wrqm/s	每秒需要写入需求的数量
r/s	每秒实际读取需求的数量
w/s	每秒实际写入需求的数量
rsec/s	每秒读取区段的数量
wsec/s	每秒写入区段的数量
rkB/s	每秒实际读取的大小，单位为KB
wkB/s	每秒实际写入的大小，单位为KB
avgrq-sz	需求的平均大小区段
avgqu-sz	需求的平均队列长度
await	等待I/O平均的时间（milliseconds）
svctm	I/O需求完成的平均时间
%util	被I/O需求消耗的CPU百分比
```

### 常用命令
```bash
# 来观看磁盘I/O的详细情况
iostat -x /dev/sda1

# 获取cpu部分状态值
iostat -c 1 10

#查看TPS和吞吐量信息
iostat -d -k 1 10 

#查看设备使用率（%util）、响应时间（await）
iostat -d -x -k 1 10 

# 显示设备的持久化名称
iostat -d -j ID

# 显示 LVM2 设备的映射名称
iostat -d -N

# 以 M 为单位显示数字
iostat -m -d sdb
```




```bash
#!/bin/sh
which iostat > /dev/null 2>&1
if [ $? -ne 0 ]
then
  echo "error_text=iostat command not found!"
  exit 0
fi

if [ $# -lt 1 ]
then
  echo "error_text=diskname argument not specified!"
  exit
fi

os=`uname`
diskname=$1
rb=0
wb=0
trans=0
wt=0
bt=0
if [ "$os" = "linux" ] || [ "$os" = "Linux" ]
then
  output=`iostat 1 3 |grep $diskname|tail -1`
  rb=`echo $output|awk '{printf $3}'`
  wb=`echo $output|awk '{printf $4}'`
  wt=`echo $output|awk '{printf $9}'`
  bt=`echo $output|awk '{printf $10}'`
elif [ "$os" = "SunOS" ]
then
  output=`iostat -xnp 2 2 |grep $diskname|tail -1`
  rb=`echo $output|awk '{printf $3}'`
  wb=`echo $output|awk '{printf $4}'`
  wt=`echo $output|awk '{printf $9}'`
  bt=`echo $output|awk '{printf $10}'`
elif [ "$os" = "AIX" ] 
then
  output=`iostat -d 1 3 | grep $diskname | tail -1`
  rb=`echo $output | awk '{ print $5 }'`
  wb=`echo $output | awk '{ print $6 }'`
  trans=`echo $output | awk '{ print $4 }'`
fi
echo "Read bytes=$rb"
echo "Write bytes=$wb"
echo "Number of transactions being serviced=$trans"
echo "Wait time=$wt"
echo "Busy time=$bt"

```