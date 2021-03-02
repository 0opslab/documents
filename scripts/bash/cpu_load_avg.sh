
#!/bin/bash

#1.load高时处于运行队列的进程

#bash cpu_load_avg.sh 
#Mon Mar 16 09:21:55 CST 2020
#R+   31979 31979 31978 stress
#R+   32003 32003 31997 bash
#R+   32002 32002 31997 ps
#R+   32004 32004 31997 bash
#Mon Mar 16 09:21:55 CST 2020
#2.14 1.94 2.10 2/135 32006
#R代表运行中的队列，D是不可中断的睡眠进程

LANG=C
PATH=/sbin:/usr/sbin:/bin:/usr/bin
interval=1
length=86400
for i in $(seq 1 $(expr ${length} / ${interval}))
do
  date
  LANG=C ps -eTo stat,pid,tid,ppid,comm  --no-header | sed -e 's/^ \*//' | perl -nE 'chomp;say if (m!^\S*[RD]+\s*!)'
  date
  cat /proc/loadavg
  echo -e "\n"
  sleep ${interval}
done
