title: JVM的参数详解
date: 2016-01-16 19:58:11
tags:
    - Java
    - jvm
categories: Java
---
12年毕业到先在处理第一年外这几年纯属于打酱油，当初自学Java然后就出来找工作了，还有第一家面试就通过了挺幸运的
但之后的这段时间一直是处于吃老本的状态。最近心情真的很不好，各种黄老邪！一直处于堕落的状态，明知不可为而为之！
哎 想想就心碎！不跑题了，说了好撸码三十年，这才几年！
今天就整理下JVM的参数！相对而已JVM有很多参数，但对于一般开发人员执行知道和堆栈大小，GC、远程调试的参数即可。

# JVM Parameters
首先需要说明的是JVM的参数形式:

>* -X 开头的参数都是非标准的参数（不是所有的JVM都实现了）
>* -XX 都是不稳定的并且不推荐在生产环境中使用

```bash
* 布尔类型的参数
	格式	-XX:+<option>   打开/-XX:-<option>   关闭
    例如:	-XX:PrintGCDetails  打开GC信息(调优和定位内存回收问题经常使用)
* 数字型参数
	格式	-XX:<option>=<number>
    例如	-XX:NewRatio=2
* 字符型参数
	格式	-XX:<option>=<string>
    例如	-XX:HeapDumpPath=./java_pid.hprof
```
当然是人都不可能时时记住这些命令和选项，此时可以使用java -help(列出所有的标准选项)java -X(大写列出所有的非标准选项)
例如下面是我机器的选项：
```bash
$ java -help
Usage: java [-options] class [args...]
           (to execute a class)
   or  java [-options] -jar jarfile [args...]
           (to execute a jar file)
where options include:
    -d32	  use a 32-bit data model if available
    -d64	  use a 64-bit data model if available
    -server	  to select the "server" VM
                  The default VM is server,
                  because you are running on a server-class machine.


    -cp <class search path of directories and zip/jar files>
    -classpath <class search path of directories and zip/jar files>
                  A : separated list of directories, JAR archives,
                  and ZIP archives to search for class files.
    -D<name>=<value>
                  set a system property
    -verbose:[class|gc|jni]
                  enable verbose output
    -version      print product version and exit
    -version:<value>
                  require the specified version to run
    -showversion  print product version and continue
    -jre-restrict-search | -no-jre-restrict-search
                  include/exclude user private JREs in the version search
    -? -help      print this help message
    -X            print help on non-standard options
    -ea[:<packagename>...|:<classname>]
    -enableassertions[:<packagename>...|:<classname>]
                  enable assertions with specified granularity
    -da[:<packagename>...|:<classname>]
    -disableassertions[:<packagename>...|:<classname>]
                  disable assertions with specified granularity
    -esa | -enablesystemassertions
                  enable system assertions
    -dsa | -disablesystemassertions
                  disable system assertions
    -agentlib:<libname>[=<options>]
                  load native agent library <libname>, e.g. -agentlib:hprof
                  see also, -agentlib:jdwp=help and -agentlib:hprof=help
    -agentpath:<pathname>[=<options>]
                  load native agent library by full pathname
    -javaagent:<jarpath>[=<options>]
                  load Java programming language agent, see java.lang.instrument
    -splash:<imagepath>
                  show splash screen with specified image
See http://www.oracle.com/technetwork/java/javase/documentation/index.html for more details.
$ java -X
    -Xmixed           mixed mode execution (default)
    -Xint             interpreted mode execution only
    -Xbootclasspath:<directories and zip/jar files separated by :>
                      set search path for bootstrap classes and resources
    -Xbootclasspath/a:<directories and zip/jar files separated by :>
                      append to end of bootstrap class path
    -Xbootclasspath/p:<directories and zip/jar files separated by :>
                      prepend in front of bootstrap class path
    -Xdiag            show additional diagnostic messages
    -Xnoclassgc       disable class garbage collection
    -Xincgc           enable incremental garbage collection
    -Xloggc:<file>    log GC status to a file with time stamps
    -Xbatch           disable background compilation
    -Xms<size>        set initial Java heap size
    -Xmx<size>        set maximum Java heap size
    -Xss<size>        set java thread stack size
    -Xprof            output cpu profiling data
    -Xfuture          enable strictest checks, anticipating future default
    -Xrs              reduce use of OS signals by Java/VM (see documentation)
    -Xcheck:jni       perform additional checks for JNI functions
    -Xshare:off       do not attempt to use shared class data
    -Xshare:auto      use shared class data if possible (default)
    -Xshare:on        require using shared class data, otherwise fail.
    -XshowSettings    show all settings and continue
    -XshowSettings:all
                      show all settings and continue
    -XshowSettings:vm show all vm related settings and continue
    -XshowSettings:properties
                      show all property settings and continue
    -XshowSettings:locale
                      show all locale related settings and continue

The -X options are non-standard and subject to change without notice.

```
如果在应用程序中查询当前应用使用的参数可以使用例如如下的代码进行查询
```java
package JDK.JVM;

import com.opslab.StringUtil;

import java.lang.management.ManagementFactory;
import java.util.List;

public class JvmParamerters {
    public static void main(String[] args){
        List<String> paramters = ManagementFactory.getRuntimeMXBean().getInputArguments();
        System.out.println(StringUtil.join(paramters,":"));
    }
}
```
下面是根据用途进行了一些分类
## 三个个不显眼但及其有用的参数(知道的举手)
-XX:+PrintCommandLineFlags	:打印出JVM初始化完毕后所有跟初始化的默认之不同的参数及他们的值
-XX:+PrintFlagsFinal		:显示所有可设置的参数及"参数处理"后的默认值
							 可是查看不同版本默认值,以及是否设置成功.输出的信息中"="表示使用的是初始默认值，
                             而":="表示使用的不是初始默认值
-XX:+PrintFlagsInitial		：在"参数处理"之前所有可设置的参数及它们的值,然后直接退出程序
例如不起用这个俩个参数时启动信息如下:
```bash
$ java -XX:+PrintGCDetails -Xloggc:./gc.log JDK.JVM.JvmParamerters
app starting...
```
启动以上俩个参数后:
```bash
$ java -XX:+PrintGCDetails -Xloggc:./gc.log -XX:+PrintCommandLineFlags -XX:+PrintFlagsFinal \
  JDK.JVM.JvmParamerters
-XX:InitialHeapSize=130056064 -XX:MaxHeapSize=2080897024 -XX:+PrintCommandLineFlags
-XX:+PrintFlagsFinal -XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCTimeStamps
-XX:+UseCompressedOops -XX:+UseParallelGC
[Global flags]
...-javaagent:jarpath[=options]
	uintx InitialHeapSize                          := 130056064       {product}           
    uintx InitialRAMFraction                        = 64              {product}           
    uintx InitialSurvivorRatio                      = 8               {product}           
     intx InitialTenuringThreshold                  = 7               {product}           
    uintx InitiatingHeapOccupancyPercent            = 45              {product}           
     bool Inline                                    = true            {product}           
...
	 bool PrintGCDetails                           := true            {manageable}        
     bool PrintGCTaskTimeStamps                     = false           {product}           
     bool PrintGCTimeStamps                        := true            {manageable}  
...
```
## 几个开发人员会用到的标准参数
-client		:设置JVM使用client模式,特点启动较快(神机不明显(I5/8G/SSD))
-server		:设置JVM使用server模式。64位JDK默认启动该模式
-agentlib:libname[=options]		:用于加载本地的lib
-agentlib:hprof					:用于获取JVM的运行情况
-agentpath:pathnamep[=options]	:加载制定路径的本地库
-Dproperty=value				:设置系统属性名/值对
-jar							:制定以jar包的形式执行一个应用程序
-javaagent:jarpath[=options]	:实现premain方法在main方法前执行可以利用该方式玩一个JVM层面的hook很有意思的东西
-verbose:jni					:输出native方法的调用情况玩JNI必备技能
例如:
```bash
-agentlib:jprofilerti=port=8849 -Xbootclasspath/a:/usr/local/jprofiler5/bin/agent.jar
```


## 跟Java对战大小相关的JVM内存参数
-Xms							:设置Java堆栈的初始化大小
-Xmx							:设置最大的java堆大小
-Xmn							:设置Young区大小
-Xss							:设置java线程堆栈大小
-XX:PermSize and MaxPermSize	:设置持久带的大小
-XX:NewRatio					:设置年轻代和老年代的比值
-XX:NewSize						:设置年轻代的大小
-XX:SurvivorRatio=n			:设置年轻代中E去与俩个S去的比值
```bash
$ java -Xmx128 -Xms64 -Xmn32m -Xss16m Main
```
## 打印垃圾回收器信息和设置垃圾回收器(串行、并行、并发等行为的收集器)
-verbose:gc					:记录GC运行以及运行时间,一般用来查看GC是否有瓶颈
-XX:+PrintGCDetails			:记录GC运行时的详细数据信息，包括新生占用的内存大小及消耗时间
-XX:-PrintGCTimeStamps		:打印收集的时间戳
-XX:+UseParallelGC			:使用并行垃圾收集器
-XX:-UseConcMarkSweepGC		:使用并发标志扫描收集器
-XX:-UseSerialGC			:使用串行垃圾收集器
-Xloggc:filename			:设置GC记录的文件
-XX:+UseGCLogFileRotation	:启用GC日志文件的自动转储
-XX:GCLogFileSize=1M		:控制GC日志文件的大小

## 调试参数
-Xdebug
-Xnoagent
-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8000
-XX:HeapDumpPath=./java_pid.hprof  		:Path to directory or file name for heap dump.
-XX:-PrintConcurrentLocks       		:Print java.util.concurrent locks in Ctrl-Break thread dump.
-XX:-PrintCommandLineFlags   			:Print flags that appeared on the command line.

## 关于性能
-Xprof
-Xrunhprof

## 类加载和跟踪类加载和卸载的信息
Xbootclasspath				:指定需要加载，但不想通过校验类路径。
							JVM会对所有的类在加载前进行校验并为每个类通过一个int数值来应用
-XX:+TraceClassLoading		:跟踪类加载的信息(诊断内存泄露很有用)
-XX:+TraceClassUnloading	:跟踪类卸载的信息(诊断内存泄露很有用)


# Oracle官方的解释
http://docs.oracle.com/javase/7/docs/technotes/tools/windows/java.html
