#! /bin/bash
#@summary: 建议将该问加入到/etc/profile文件中，该文真的会经常用到


# if [ -f /etc/profile.d/ljohn.sh ];then
#    echo "The file is exist"
# else
#    cat >> /etc/profile.d/ljohn.sh <<EOF
# HISTSIZE=10000
# HISTTIMEFORMAT="%F %T root "

# alias l='ls -AFhlt'
# alias lh='l | head'
# alias vi=vim

# GREP_OPTIONS="--color=auto"
# alias grep='grep --color'
# alias egrep='egrep --color'
# alias fgrep='fgrep --color'
# EOF
#    if [ $? -eq 0 ];then
#       echo 'PS1="\[\e[32;1m\][\u@\h \W]\\$\[\e[0m\]"' >> /etc/profile.d/ljohn.sh
#    else
#       echo "config failure" && exit 1
#    fi
#    chmod 644 /etc/profile.d/ljohn.sh
#    source /etc/profile.d/ljohn.sh
#    [ $? -eq 0 ] && echo "ok" || echo "failure"
# fi

#
# Set colors
#

bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)


#
# Headers and Logging
#

e_header () {
    printf "\n${bold}${purple}========== %s ==========${reset}\n" "$@"
}

e_arrow() {
    printf "➜ $@\n"
}

e_success() {
    printf "${green}✔ %s ${reset}\n" "$@"
}

e_error() {
    printf "${red}✖ %s ${reset}\n" "$@"
}

e_warning() {
    printf "${tan}➜ %s ${reset}\n" "$@"
}

e_underline() {
    printf "${underline}${bold}%s${reset}\n" "$@"
}

e_bold() {
    printf "${bold}%s${reset}\n" "$@"
}
e_note() {
    printf "${underline}${bold}${blue}Note:${reset}  ${blue}%s${reset}\n" "$@"
}

seek_confirmation() {
  printf "\n${bold}$@${reset}"
  read -p " (y/n) " -n 1
  printf "\n"
}

# Test whether the result of an 'ask' is a confirmation
is_confirmed() {
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
      return 0
    fi
    return 1
}

# command test
type_exists() {
    if [ $(type -P $1) ]; then
        return 0
    fi
    return 1
}


# os test
is_os() {
    if [[ "${OSTYPE}" == $1* ]]; then
        return 0
    fi
    return 1
}

# join

function join_by { local IFS="$1"; shift; echo "$*"; }


# send dingTalk

dingTalk() {
    DING="https://oapi.dingtalk.com/robot/send?access_token="$DINGTOKEN
    MSG=`printf '{"msgtype": "text", "text": {"content": "%s"}}' "$1"`
    curl ${DING} -H 'Content-Type: application/json' -d "$MSG" > /dev/null 2>&1
}


#@func{通过netstat统计各个状态的信息}
# LAST_ACK 5   (正在等待处理的请求数) 
# SYN_RECV 30 
# ESTABLISHED 1597 (正常数据传输状态) 
# FIN_WAIT1 51 
# FIN_WAIT2 504 
# TIME_WAIT 1057 (处理完毕，等待超时结束的请求数) 
netstatinfo(){
    netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
}

#@func{通过定期读取/sys/class/net/eth0/statistics/rx和tx系列的包 显示网络的负载情况}
netspeed(){
	INTERVAL="1"  # update interval in seconds
 
	if [ -z "$1" ]; then
    echo
    echo usage: $0 [network-interface]
    echo
    echo e.g. $0 eth0
    echo
    exit
	fi
	 
	IF=$1
	 
	while true
	do
    R1=`cat /sys/class/net/$1/statistics/rx_bytes`
    T1=`cat /sys/class/net/$1/statistics/tx_bytes`
    sleep $INTERVAL
    R2=`cat /sys/class/net/$1/statistics/rx_bytes`
    T2=`cat /sys/class/net/$1/statistics/tx_bytes`
    TBPS=`expr $T2 - $T1`
    RBPS=`expr $R2 - $R1`
    TKBPS=`expr $TBPS / 1024`
    RKBPS=`expr $RBPS / 1024`
    echo "TX $1: $TKBPS kb/s RX $1: $RKBPS kb/s"
	done
}


#@func{查看最消耗CPU的进程}
cputop(){
    HEADCOUNT = "10"
    HEADCOUNT = $1
    ps auxw|head -1;ps auxw|sort -rn -k3|head -HEADCOUNT
}

#@func{查看最消耗内存的进程}
memtop(){}{
    HEADCOUNT = "10"
    HEADCOUNT = $1
    ps auxw|head -1;ps auxw|sort -rn -k4|head -10
}

#@func{虚拟内存使用最多的前N个进程}
cache(){}{
    HEADCOUNT = "10"
    HEADCOUNT = $1
    ps auxw|head -1;ps auxw|sort -rn -k5|head -10
}

#func{获取目录的文件的md5信息并保存到当前目录下}
#test hash_dir ~/workspace
function hash_dir(){
    log="hash_"`date +%Y%m%d%H`".log"
    for file in `ls $1`
    do
        if [ -d $1"/"$file ]
        then
            hash_dir $1"/"$file
        else
           echo `md5 $1"/"$file`>>$log
        fi
    done
}

# cat function.sh >> ~/.bashrc

# User specific aliases and functions
#@func{通过netstat统计各个状态的信息}
net_count(){
	# LAST_ACK 5   (正在等待处理的请求数)
	# SYN_RECV 30
	# ESTABLISHED 1597 (正常数据传输状态)
	# FIN_WAIT1 51
	# FIN_WAIT2 504
	# TIME_WAIT 1057 (处理完毕，等待超时结束的请求数)
	netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
}

#@func{通过定期读取/sys/class/net/eth0/statistics/rx和tx系列的包 显示网络的负载情况}
netspeed(){
	# update interval in seconds
	INTERVAL="1"
	if [ -z "$1" ]; then
		echo
		echo usage: $0 [network-interface]
		echo
		echo e.g. $0 eth0
		echo
		exit
	fi
	 
	IF=$1
	 
	while true
	do
		R1=`cat /sys/class/net/$1/statistics/rx_bytes`
		T1=`cat /sys/class/net/$1/statistics/tx_bytes`
		sleep $INTERVAL
		R2=`cat /sys/class/net/$1/statistics/rx_bytes`
		T2=`cat /sys/class/net/$1/statistics/tx_bytes`
		TBPS=`expr $T2 - $T1`
		RBPS=`expr $R2 - $R1`
		TKBPS=`expr $TBPS / 1024`
		RKBPS=`expr $RBPS / 1024`
		echo "TX $1: $TKBPS kb/s RX $1: $RKBPS kb/s"
	done
}

#@func{生成指定目录下的文件hash信息}
hash_dir(){
	log_file="./"`date +%Y%m%d_%H`"_hash.log"
	for file in `ls $1`
	do
		if [ -d $1"/"$file ] 
		then
			hash_dir $1"/"$file
		else
			hash=`md5sum $1"/"$file`
			echo $hash >> $log_file
		fi
	done
}

#@func{查看知道进程的句柄和线程数}
proc_info(){
	if [ -z "$1" ]; then
		echo
		echo 查看指定进程的信息
		echo 	usage: proc_info pid
		echo
		return
	fi
	echo pid info: ${1} 
	echo fleinfo:
	lsof -p 25758 | grep 'REG  ' | grep  -v 'mem    REG'	
	#echo exefile: `ll /proc/${1}/exe`
	#echo cwd: `ls /proc/${1}/cwd`
	echo proc-status================
	head -28 /proc/${1}/status
	echo proc-tcp===================
	lsof -p ${1} -nP | grep TCP
	echo proc-udp===================
	lsof -p ${1} -nP | grep UDP
}

#@func{查看cpu信息}
cpu_info(){
	echo CPU型号: `cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c`
	echo CPU个数: `cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l`
	echo CPU核数: `cat /proc/cpuinfo| grep "cpu cores"| uniq`
	echo 逻辑CPU总数: `cat /proc/cpuinfo| grep "processor"| wc -l`
	echo "=======系统整体的 CPU利用率和闲置率========="
	grep "cpu " /proc/stat | awk -F ' ' '{total = $2 + $3 + $4 + $5} END {print "idle \t used\n" $5*100/total "% " $2*100/total "%"}'
	echo "=======使用CPU最多的3个进程================"
	ps -aeo pcpu,user,pid,cmd | sort -nr | head -3
}

#@func{查看io信息}
io_info(){
	echo 通过top命令可以粗略的看出IO的大致情况
	echo		us：用户态使用的cpu时间比
	echo		sy：系统态使用的cpu时间比
	echo		ni：用做nice加权的进程分配的用户态cpu时间比
	echo		id：空闲的cpu时间比
	echo		wa：cpu等待磁盘写入完成时间
	echo		hi：硬中断消耗时间
	echo		si：软中断消耗时间
	echo		st：虚拟机偷取时间
}
#@func{按照 Swap 分区的使用情况列出前 10 的进程}
proc_swap(){
	for file in /proc/*/status ; do awk '/VmSwap|Name|^Pid/{printf $2 " " $3}END{ print ""}' $file; done | sort -k 3 -n -r | head -10
}

#@funct{在指定目录中查找最大的N个文件}
file_max(){
	if [ -z "$1" ]; then
		echo
		echo "从指定的目录中查找最大的N个文件 usage:file_max path count"
		exit
	fi
	count=$2
	if [ -z "$2" ]; then
		count=10
	fi

	find $1 -type f -print0 | xargs -0 du -h | sort -rh | head -n $count
}


#@func{显示指定Java进程的信息}
java_info(){
	#显示最后一次或当前正在发生的垃圾收集的诱发原因
	jstat -gccause $pid

	#显示各个代的容量及使用情况
	jstat -gccapacity $pid

	#显示新生代容量及使用情况
	jstat -gcnewcapacity $pid

	#显示老年代容量
	jstat -gcoldcapacity $pid

	#显示垃圾收集信息（间隔1秒持续输出）
	#jstat -gcutil $pid 1000

	#按线程状态统计线程数(加强版)
	jstack $pid | grep java.lang.Thread.State:|sort|uniq -c | awk '{sum+=$1; split($0,a,":");gsub(/^[ \t]+|[ \t]+$/, "", a[2]);printf "%s: %s\n", a[2], $1}; END {printf "TOTAL: %s",sum}';

	# 查看堆内对象的分布 Top 50（定位内存泄漏）
	jmap –histo:live $pid | sort-n -r -k2 | head-n 50

}

#@func{获取用户指定用户的进程PID=`GetPID root TestApp` echo $PID}
function GetPID(){
 PsUser=$1
 PsName=$2
 pid=`ps -u $PsUser|grep $PsName|grep -v grep|grep -v vi|grep -v dbx | grep -v tail|grep -v start|grep -v stop |sed -n 1p |awk '{print $1}'`
 echo $pid
}

#func{多主机执行命令}
xcall(){
    list=('135.191.107.124' '135.191.107.125' '135.191.107.126')

    for host in ${list[@]}
    do
        echo ====================$host======================
        ssh $host $1
    done    
} 


#func{多主机执行命令}
ecplog(){
    txt=$1
    cmd="find /webapp02/logs/ -name \"crmDetail_*.log\" -exec grep --color \"${txt}\" {} \;"
    list=('135.191.107.124' '135.191.107.125' '135.191.107.126')

    for host in ${list[@]}
    do
        echo ====================$host======================
        #echo == $cmd
        ssh $host $cmd
    done
}

#func{多主机执行命令}
ecpdatelog(){
    txt=$1
    cmd="find /webapp02/logs/ -name \"crmDetail_*$1\" -exec grep --color \"$2\" {} \;"
    list=('135.191.107.124' '135.191.107.125' '135.191.107.126')

    for host in ${list[@]}
    do
        echo ====================$host======================
        ssh $host $cmd
    done  
}

#func{列出最常用的10条历史命令}
history_top(){
  printf "%-32s %-10s\n" 命令 次数
  cat ~/.bash_history | awk '{ list [$1] ++; } \
      END {
      for (i in list)
      {
      printf ("%-30s %-10s\n", i, list [i]); }
  }' | sort -nrk 2 | head
}

file_count(){
  Count=0
  for File in /var/*; do
    file $File
    Count=$[$Count+1]
  done
  return $Count
}


#func{查看cpu架构}
cpu_arch(){
  Vendor=`grep "vendor_id" /proc/cpuinfo  | uniq | cut -d: -f2`
  if [[ "$Vendor" =~ [[:space:]]*GenuineIntel$ ]]; then
    return "Intel"
  else
    return "AMD"
  fi
}

disk_info ()
{
   echo "======================disk info========================"
   df -ThP|column -t
}

cpu_info ()
{
   echo "=======================cpu info========================"
   echo "cpu processor is $(grep "processor" /proc/cpuinfo |wc -l)"
   echo "cpu mode name is $(grep "model name" /proc/cpuinfo |uniq|awk '{print $4,$5,$6,$7,$8,$9}')"
   grep "cpu MHz" /proc/cpuinfo |uniq |awk '{print $1,$2":"$4}'
   awk '/cache size/ {print $1,$2":"$4$5}' /proc/cpuinfo |uniq
}

mem_info ()
{
   echo "=====================memory info========================"
   MemTotal=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
   MemFree=$(awk '/MemFree/ {print $2}' /proc/meminfo)
   Buffers=$(awk '/^Buffers:/ {print $2}' /proc/meminfo)
   Cached=$(awk '/^Cached:/ {print $2}' /proc/meminfo)
   FreeMem=$(($MemFree/1024+$Buffers/1024+$Cached/1024))
   UsedMem=$(($MemTotal/1024-$FreeMem))
   echo "Total memory is $(($MemTotal/1024)) MB"
   echo "Free  memory is ${FreeMem} MB"
   echo "Used  memory is ${UsedMem} MB"
}

load_info ()
{
   echo "=====================load info=========================="
   Load1=$(awk  '{print $1}' /proc/loadavg)
   Load5=$(awk  '{print $2}' /proc/loadavg)
   Load10=$(awk '{print $3}' /proc/loadavg)
   echo "Load in 1  min is $Load1"
   echo "Load in 5  min is $Load5"
   echo "Load in 10 min is $Load10"
}

network_info ()
{
   echo "=====================network info======================="
   network=$(ifconfig |grep  "inet addr" |grep -v "127.0.0.1" |awk '{print $2}'|sed "s/addr://g")
   echo "network eth0 IP is $network"
}

network_card_info ()
{
   echo "=====================network_card_info==================="
   card=$(ip a|awk -F "inet|/"  '/inet.*brd/ {print $2}')
   echo "Network card  is $card"
}

system_info()
{
   echo "====================system info========================"
   VERSION=`cat /etc/redhat-release| awk 'NR==1{print}'`
   KERNEL=`uname -a|awk '{print $3}'`
   HOSTNAME=`uname -a|awk '{print $2}'`
   cat /etc/issue &> /dev/null
   if [ "$?" -ne 0 ];then
   echo -e "\033[31m The system is no support \033[0m"
   exit 1
   else
      echo -e "system_version is \033[32m $VERSION \033[0m"
      echo -e "system_kernel_version is  \033[32m $KERNEL \033[0m"
      echo -e "system_hostname is \033[32m $HOSTNAME \033[0m"
   fi

}

disk_info ()
{
   echo "======================disk info========================"
   DISK=$(df -ThP|column -t)
   echo -e "\033[32m $DISK \033[0m"
}

cpu_info ()
{
   echo "=======================cpu info========================"
   echo -e "cpu processor is \033[32m $(grep "processor" /proc/cpuinfo |wc -l) \033[0m"
   echo -e "cpu mode name is \033[32m $(grep "model name" /proc/cpuinfo |uniq|awk '{print $4,$5,$6,$7,$8,$9}') \033[0m"
   grep "cpu MHz" /proc/cpuinfo |uniq |awk '{print $1,$2":"$4}'
   awk '/cache size/ {print $1,$2":"$4$5}' /proc/cpuinfo |uniq
}

mem_info ()
{
   echo "====================memory info========================"
   MemTotal=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
   MemFree=$(awk '/MemFree/ {print $2}' /proc/meminfo)
   Buffers=$(awk '/^Buffers:/ {print $2}' /proc/meminfo)
   Cached=$(awk '/^Cached:/ {print $2}' /proc/meminfo)
   FreeMem=$(($MemFree/1024+$Buffers/1024+$Cached/1024))
   UsedMem=$(($MemTotal/1024-$FreeMem))
   echo -e "Total memory is \033[32m $(($MemTotal/1024)) MB \033[0m"
   echo -e "Free  memory is \033[32m ${FreeMem} MB \033[0m"
   echo -e "Used  memory is \033[32m ${UsedMem} MB \033[0m"
}

loadavg_info ()
{
   echo "==================load average info===================="
   Load1=$(awk  '{print $1}' /proc/loadavg)
   Load5=$(awk  '{print $2}' /proc/loadavg)
   Load10=$(awk '{print $3}' /proc/loadavg)
   echo -e "Loadavg in 1  min is \033[32m $Load1 \033[0m"
   echo -e "Loadavg in 5  min is \033[32m $Load5 \033[0m"
   echo -e "Loadavg in 10 min is \033[32m $Load10 \033[0m"
}

network_info ()
{
   echo "====================network info======================="
   network_card=$(ip addr |grep inet |egrep -v "inet6|127.0.0.1" | awk '{print $NF}')
   IP=$(ip addr |grep inet |egrep -v "inet6|127.0.0.1" |awk '{print $2}' |awk -F "/" '{print $1}') 
   echo -e "network_device is \033[32m $network_card \033[0m  address is  \033[32m $IP \033[0m"
}