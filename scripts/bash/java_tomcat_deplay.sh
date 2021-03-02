#!/bin/bash

#func{tomcat项目部署}
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



echo "handing www"
cd /home/local/www/ydb3
svn update


echo "restart tomcat"
kill -9 `ps -ef | grep tomcat | grep -v  "grep"|awk '{print $2}'`

rm -rdf /home/local/tomcat/work/
rm -rdf /home/local/tomcat/temp/

/home/local/tomcat/bin/startup.sh &

