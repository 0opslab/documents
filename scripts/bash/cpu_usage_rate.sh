#!/bin/bash

#2.查CPU使用率比较高的线程
#
#bash cpu_usage_rate.sh 
#Mon Mar 16 09:24:39 CST 2020
# 8.6 32060 32060 32036 stress
# 8.4 32055 32055 32036 stress
# 8.4 32053 32053 32036 stress

LANG=C
PATH=/sbin:/usr/sbin:/bin:/usr/bin
interval=1
length=86400
for i in $(seq 1 $(expr ${length} / ${interval}));do
date
LANG=C ps -eT -o%cpu,pid,tid,ppid,comm | grep -v CPU | sort -n -r | head -20
date
LANG=C cat /proc/loadavg
{ LANG=C ps -eT -o%cpu,pid,tid,ppid,comm | sed -e 's/^ *//' | tr -s ' ' | grep -v CPU | sort -n -r | cut -d ' ' -f 1 | xargs -I{} echo -n "{} + " && echo ' 0'; } | bc -l
sleep ${interval}
done
#fuser -k $0
