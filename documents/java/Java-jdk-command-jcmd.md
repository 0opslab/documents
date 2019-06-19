title: JDK命令jcmd
date: 2016-01-19 22:22:22
tags:
    - Java
    - jvm
categories: Java
---
jcmd用于向正在运行的JVM发送诊断信息请求,是从JDK1.7开始提供可以说是jstack和jps的结合体

# 命令格式
```bash
jcmd [ options ]

jcmd [ pid | main-class ] PerfCounter.print

jcmd [ pid | main-class ] command [ arguments ]

jcmd [ pid | main-class ] -f file
```
## options
	命令行选项
## pid
	结束命令请求的进程ID
## main-class
	接收诊断命令请求的进程的main类
## command [arguments]
	命令
假使想要发送一个诊断命令请求到com.example.MyClass name="Value of name argument"，其命令格式如下
```bash
jcmd com.example.MyClass name=\"Value of name argument\"
jcmd com.example.MyClass name="'Value of name argument'"
jcmd com.example.MyClass name='"Value of name argument"'
```
## PerfCounter.print
	打印目标进程的性能计数器
## - file
	从文件file中读取命令，然后在目标Java进程上调用这些命令。在file中，每个命令必须写在单独的一行。
	以"#"开头的行会被忽略。当所有行的命令被调用完毕后，或者读取到含有stop关键字的命令，
	将会终止对file的处理。
# 实例查看当前java进程
```bash
$ jcmd
#进程pid  #进程mainClass
7012 sun.tools.jcmd.JCmd
4876 org.apache.catalina.startup.Bootstrap start
```
# 查看目标jvm中能获取到的信息
```bash
$ jcmd 4876 help
4876:
The following commands are available:
VM.native_memory
VM.commercial_features
ManagementAgent.stop
ManagementAgent.start_local
ManagementAgent.start
Thread.print
GC.class_histogram
GC.heap_dump
GC.run_finalization
GC.run
VM.uptime
VM.flags
VM.system_properties
VM.command_line
VM.version
help

For more information about a specific command use 'help <command>'.
#如上所示有很多选项 要查看具体的选项意思和用法可以利用如下方式查看帮助信息
#jcmd pid help <command>
#例如
$ jcmd 4876 help GC.run
4876:
GC.run
Call java.lang.System.gc().

Impact: Medium: Depends on Java heap size and content.

Syntax: GC.run

```
# 查看目标jvm进程的版本信息
```bash
$ jcmd 4876  VM.version
4876:
Java HotSpot(TM) Client VM version 24.75-b04
JDK 7.0_75
```
# 查看目标JVM进程的properties
```bash
$ jcmd 4876 VM.system_properties
4876:
#Wed Jan 20 11:08:17 CST 2016
java.runtime.name=Java(TM) SE Runtime Environment
java.vm.version=24.75-b04
shared.loader=
java.vm.vendor=Oracle Corporation
java.vendor.url=http\://java.oracle.com/
path.separator=;
java.vm.name=Java HotSpot(TM) Client VM
tomcat.util.buf.StringCache.byte.enabled=true
file.encoding.pkg=sun.io
user.script=

```
# 查看目标进程的参数
```bash
$ jcmd 4876 VM.flags
4876:
-XX:InitialHeapSize=16777216 -XX:MaxHeapSize=268435456 -XX:-UseLargePagesIndividualAllocation
```
# 查看类柱形图
这里和jmap -histo pid的效果是一样的
$ jcmd 4876 GC.class_histogram
4876:

 num     #instances         #bytes  class name
----------------------------------------------
   1:        141718       16093456  [C
   2:         77395        9721744  <constMethodKlass>
   3:         77395        5579408  <methodKlass>
   4:          6261        3956752  <constantPoolKlass>
   5:        140036        3360864  java.lang.String
   6:         13098        2974464  [B
   7:          6261        2573432  <instanceKlassKlass>
   8:          5512        2386208  <constantPoolCacheKlass>

```
# 查看JVM性能相关的参数
```bash
$ jcmd 4876  PerfCounter.print
4876:
java.ci.totalTime=3840798
java.cls.loadedClasses=6312
java.cls.sharedLoadedClasses=0
java.cls.sharedUnloadedClasses=0
java.cls.unloadedClasses=50
...
```
# 显示所有线程栈
```bash
$ jcmd 4876  Thread.print | more
4876:
2016-01-20 11:15:36
Full thread dump Java HotSpot(TM) Client VM (24.75-b04 mixed mode):

"http-nio-8055-exec-10" daemon prio=6 tid=0x190c0400 nid=0x1468 waiting on condition [0x1d38f000]
   java.lang.Thread.State: WAITING (parking)
        at sun.misc.Unsafe.park(Native Method)
```
# dump出hprof文件
```bash
$ jcmd 4876 GC.heap_dump dump.bin
```
# 执行一次finalization操作，相当于执行java.lang.System.runFinalization() 
```bash
$ jcmd 4876 GC.run_finalization
```
# 执行一次Full GC相当于执行java.lang.System.gc() 
```bash
$ jcmd 4876 GC.run
```	
# 参考
http://www.oracle.com/webfolder/technetwork/tutorials/obe/java/JavaJCMD/index.html
http://docs.oracle.com/javase/7/docs/technotes/tools/solaris/jcmd.html
https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/tooldescr006.html
http://hirt.se/blog/?p=211
