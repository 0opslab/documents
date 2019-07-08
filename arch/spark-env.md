什么集群部署，分布式环境，依赖于Hadoop集群，感觉挺唬人的。然而只是要单单的进行开发的环境的搭建的话，其实操作还是蛮简单的。以下部署方式之针对windows平台。如果是Linux平台会更加简单。

### winutils 安装配置

首先声明不需要安装hadoop，只是简单的进行winutils的配置即可。到如下网址进行下载对应的winutils

https://github.com/steveloughran/winutils

下载好根据要安装的spark依赖的hadoop选择对应的版本然后在windows中配置如下环境

```bat
//配置HADOOP_HOME
HADOOP_HOME=C:\local\hadoop-2.7.1
//配置Path(win10中这块终于可以分开写了，不用写一行了)
C:\local\hadoop-2.7.1\bin
```

### spark安装配置

选择要下载的spark，然后将其复制的到看着比较顺眼的地方，比如C:\local\spark下然后进行环境配置

```bat
//配置spark home
SPARK_HOME=C:\local\spark
//配置path
C:\local\spark\
```

完成以上操作，单机的spark开发环境已经完成了。接下来就是学习spark的开始了。当然如果你不是JavaDog的话，你还需要安装JDK。另外很多人和很多教程都是以scala进行教学和实验的。当然如果你想学的也是可以，但是python也学是一种更好的选择。

另外次数你写程序submit的时候发现有很多提示信息，然后很多看着其实并没那么有用，如果你想修改的话，可以到spark的conf目录下将log4j.properties.template复制为log4j.properties修改如下保存即可

```pro
log4j.rootCategory=INFO, console
log4j.rootCategory=WARN, console

```

