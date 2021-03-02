#!/bin/bash

#func{多主机执行命令}
cd /home/local/workspace/QHMCC/
svn update
rm -rdf deploy/
gradle -P ReleaseState="Test" -P WebappNum="all" release
cd deploy/

echo "handing  qhmcc_wap"
unzip -qqo qhmcc_wap.zip -d qhmcc_wap
rm -rdf /home/local/tomcat/webapps/qhmcc_wap/
mv qhmcc_wap /home/local/tomcat/webapps/qhmcc_wap/

echo "handing qhmcc_client"
unzip -qqo qhmcc_client.zip -d qhmcc_client
rm -rdf /home/local/tomcat/webapps/qhmcc_client
mv qhmcc_client /home/local/tomcat/webapps/qhmcc_client/

echo "handing qhmcc_web"
unzip -qqo qhmcc_web.zip -d qhmcc_web
rm -rdf /home/local/tomcat/webapps/qhmcc_web
mv qhmcc_web /home/local/tomcat/webapps/qhmcc_web/


projectDir=/home/youguan/ucloud-crm-rpc/

jarName="crm-app-service-impl-1.0.0.jar"
logDir=${projectDir}/logs/
logName=service_$(date "+%Y-%m-%d").log

if [ ! -x "${logDir}" ]; then
        mkdir -p "${logDir}"
fi

count=$(ps -ef | grep ${jarName} |grep -v "grep" |wc -l)
if [ ${count} -lt 1 ]; then
        cd ${projectDir}
        nohup java -jar ${jarName} > ${logDir}/${logName} &
        echo "service启动中,对应的日志目录为${logName}"
else
        echo "该项目已启动----------"
fi


