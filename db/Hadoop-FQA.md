### Hadoop的那些端口

﻿//以下操作需要开启SSH免密登陆
//内部端口：外部端口
namenode 对内端口8020  对外端口50070
resourcemanager 对内端口8032 对外端口8088



### 配置MapReduce日志历史和日志聚合

再配置文件mapred-site.xml中配置
--》指定历史服务器所在位置及端口号
    <property>
        <name>mapreduce.jobhistory.address</name>
        <value>bdqn.linux.com:10020</value>
    </property>
    --》指定历史服务器所在的外部浏览器交互端口号及机器位置
    <property>
        <name>mapreduce.jobhistory.webapp.address</name>
        <value>bdqn.linux.com:19888</value>
    </property>

日志聚合
作用：
一、将我们操作的日志文件聚合到一起，通过web界面方便我们查看，并可以设置日志保存时间，可节省空间
二、在网页能够查看map和reduce的任务日志
三、存储在HDFS上的，比较容易读取
配置：yarn-site.xml
--》开启日志聚合功能
<property>
        <name>yarn.log-aggregation-enable</name>
        <value>true</value>
    </property>
    --》指定日志保存时间（单位为秒）
<property>
        <name>yarn.log-aggregation.retain-seconds</name>
        <value>604800</value>
    </property>

 启动节点进行测试：
    sbin/mr-jobhistory-daemon.sh start historyserver

    jps查看节点：
    9331 JobHistoryServer

    web页面查看：
    bdqn.linux.com:19888

    关闭节点的方法：
    sbin/mr-jobhistory-daemon.sh stop historyserver