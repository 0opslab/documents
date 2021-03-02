#!/bin/bash
# 在一台主机上向多台主机执行命令并获取结果
params=$@
list=('135.191.107.124' '135.191.107.125' '135.191.107.126')

for host in ${list[@]}
do
    echo $host
done


xcall(){
    list=('135.191.107.124' '135.191.107.125' '135.191.107.126')

    for host in ${list[@]}
    do
        echo ====================$host======================
        ssh $host $1
    done    
} 



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