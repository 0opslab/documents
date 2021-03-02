#!/bin/bash
cd /data/workspace
svn update

cd /data/workspace/opslabJava/opslabJutil
mvn clean package install

cd /data/workspace/tianshu/tianshu
mvn clean package

cd /data/workspace/tianshu/tianshu-admin
mvn clean package -Dmaven.test.skip=true


jarPid=$(ps x |grep 'tianshu-app' | grep -v grep | awk '{print $1}')
echo ${jarPid}
kill -9 ${jarPid}
output=`echo "正在关闭tianshu-app程序,进程id${jarPid}"`
echo ${output}

jarPid=$(ps x |grep 'tianshu-data' | grep -v grep | awk '{print $1}')
echo ${jarPid}
kill -9 ${jarPid}
output=`echo "正在关闭tianshu-data程序,进程id${jarPid}"`
echo ${output}

jarPid=$(ps x |grep 'tianshu-admin' | grep -v grep | awk '{print $1}')
echo ${jarPid}
kill -9 ${jarPid}
output=`echo "正在关闭tianshu-admin程序,进程id${jarPid}"`
echo ${output}


cd /data/springboot/
find . -maxdepth 1 -name "*.jar" -exec cp {} {}_$(date +%Y%m%d_%H%M%S).bak \;
mv *.bak backup/

mv /data/workspace/tianshu/tianshu/tianshu-app/target/tianshu-app-1.0.0.jar /data/springboot/
mv /data/workspace/tianshu/tianshu/tianshu-data/target/tianshu-data-1.0.0.jar /data/springboot/
mv /data/workspace/tianshu/tianshu-admin/target/tianshu-admin.jar /data/springboot/

cd /data/springboot/
nohup java -jar tianshu-app-1.0.0.jar --spring.profiles.active=pro   > ./tianshu-app.log 2>&1 &
nohup java -jar tianshu-data-1.0.0.jar --spring.profiles.active=pro  > ./tianshu-data.log 2>&1 &
nohup java -jar tianshu-admin.jar --spring.profiles.active=pro  > ./tianshu-admin.log 2>&1 &
