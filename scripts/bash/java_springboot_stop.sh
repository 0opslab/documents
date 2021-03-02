#!/bin/bash

#func{停止项目}

projectDir="/home/youguan/ucloud-crm-rpc/"

jarName="crm-app-service-impl-1.0.0.jar"

count=$(ps -ef |grep ${jarName} |grep -v "grep" |wc -l)

if [ ${count} -gt 0 ]; then
        echo "已存在${count}个${jarName}程序在运行"
        jarPid=$(ps x |grep ${jarName} | grep -v grep | awk '{print $1}')
        echo ${jarPid}
        kill -9 ${jarPid}
        output=`echo "正在关闭${jarName}程序,进程id${jarPid}"`
        echo ${output}
else
        echo "没有对应的程序在运行"
fi