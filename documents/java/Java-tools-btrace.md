---
title: Java-tools-btrace
date: 2018-02-23 19:57:35
tags: Java
---

BTrace是SUN Kenai云计算开发平台下的一个开源项目，旨在为java提供安全可靠的动态跟踪分析工具。BTrace主要采用了Java Compiler API、ASM字节码修改技术、JVM Tool Interface和jdk1.6开始提供的Instrumentation技术,Java Compiler API用于在运行时把java源码编码成class文件;通过ASM字节码修改框架来实现对类的修改,通过tools.jar里提供的attach接口将btrace-agent 动态attach到目标JVM，实现非侵入式监控,btrace-agent会在目标JVM中创建一个Socket服务端,用于实现和btrace-client JVM的通信, btrace-agent会根据你的追踪脚本来生成字节码修改工具类,注册到ClassFileTransformer上,当JVM加载类时会调用ClassFileTransformer的transfrom方法(首次建立连接时会获取所有加载的类触发一次transform),btrace-agent会在transform()方法内对类的字节码进行修改,从而达到追踪的目标。

### 下载以及使用
通过https://github.com/btraceio/btrace 下载release版本的zip包，解压即可使用。主要的使用方式如下，另外在samples中提供了各种脚本的例子，可以参考和学习。
```bash
// will attach to the java application with the given PID and compile and submit the trace script
// 附加到给定PID的Java应用程序并编译并提交跟踪脚本
$ <btrace>/bin/btrace <PID> <trace_script>

//will compile the provided trace script
//编译给定的脚本
$ <btrace>/bin/btracec <trace_script> 

//will start the specified java application with the btrace agent running and the script previously 
//compiled by btracec loaded
//将启动运行btrace代理程序的指定java应用程序并加载的脚本
<btrace>/bin/btracer <compiled_script> <args to launch a java app> 
```
### 脚本的编写
BTrace方便的获取程序运行时的数据信息，如方法参数、返回值、全局变量和堆栈信息等，并且做到最少的侵入，占用最少的系统资源。由于Btrace会把脚本逻辑直接侵入到运行的代码中，所以在使用上做很多限制，并且不恰当的使用BTrace可能导致JVM崩溃，如在BTrace脚本使用错误的class文件，所以在上生产环境之前，务必在本地充分的验证脚本的正确性
1、不能创建对象
2、不能使用数组
3、不能抛出或捕获异常
4、不能使用循环
5、不能使用synchronized关键字
6、属性和方法必须使用static修饰
####  @OnMethod
Btrace使用@OnMethod注解定义需要分析的方法入口在@OnMethod注解中，需要指定class、method以及location等，class表明需要监控的类，method表明需要监控的方法，指定方式如下：
​	使用全限定名：clazz="com.metty.rpc.common.BtraceCase", method="add"
​	使用正则表达式：clazz="/javax.swing../", method="/./"
​	使用接口：clazz="+com.ctrip.demo.Filter", method="doFilter"
​	使用注解：clazz="@javax.jws.WebService", method=""@javax.jws.WebMethod"
​	如果需要分析构造方法，需要指定method=""

指定方法拦截的位置：@Location
定义Btrace对方法的拦截位置，通过@Location注解指定，默认为Kind.ENTRY
​	Kind.ENTRY：在进入方法时，调用Btrace脚本
​	Kind.RETURN：方法执行完时，调用Btrace脚本，只有把拦截位置定义为Kind.RETURN，才能获取方法的返回结果@Return和执行时间@Duration
​	Kind.CALL：分析方法中调用其它方法的执行情况，比如在execute方法中，想获取add方法的执行耗时，必须把where设置成Where.AFTER
​	Kind.LINE：通过设置line，可以监控代码是否执行到指定的位置
​	Kind.ERROR, Kind.THROW, Kind.CATCH
编写BTrace前，请参考官方提供的demo https://github.com/btraceio/btrace/tree/master/samples，下面是一些常用的实例
查找某个包下很耗时的方法
```java
import com.sun.btrace.annotations.*;
import static com.sun.btrace.BTraceUtils.*;

@BTrace
public class BtraceExecTime {
    @OnMethod(clazz="/com\\.xxx\\..*/", method="/.*/",location=@Location(Kind.RETURN))
    public static void execTime(@ProbeClassName String className,
                                @ProbeMethodName String methodName,
                                @Duration long time) {
        if(time / (100 * 1000000) > 0){
            println(className+"."+methodName+":"+ time /  1000000);
        }
    }
}
```
统计一段时间内某些方法的调用量
```java
import com.sun.btrace.annotations.*;

import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

import static com.sun.btrace.BTraceUtils.*;

/**
* Created by 0opslab
* count specified method call counts and print every 60s
*/
@BTrace
public class _4BTraceMethodCallCounts {
    private static Map<String, AtomicLong> histo = Collections.newHashMap();

    @OnMethod(clazz="/com\\.opslab\\..*/", method="/.*/")
    public static void methodCall(@ProbeClassName String className,
                                @ProbeMethodName String methodName
                                ) {
        String cn = className+"."+methodName;
        AtomicLong ai = Collections.get(histo, cn);
        if (ai == null) {
            ai = Atomic.newAtomicLong(1);
            Collections.put(histo, cn, ai);
        } else {
            Atomic.incrementAndGet(ai);
        }
    }

    @OnTimer(1000 * 60)
    public static void onTimer(){
        if (Collections.size(histo) != 0) {
            printNumberMap("Method call counts", histo);
        }
    }
}

```
查看触发system.gc的调用栈
```java
import com.sun.btrace.BTraceUtils;
import com.sun.btrace.annotations.BTrace;
import com.sun.btrace.annotations.Kind;
import com.sun.btrace.annotations.Location;
import com.sun.btrace.annotations.OnMethod;

/**
* Created by 0opslab
* the class stack touch off  System.gc
*/
@BTrace
public class _3BTraceSystemGC {
    @OnMethod(clazz="java.lang.System", method="gc",location=@Location(Kind.ENTRY))
    public static void onSystemGC(){
        BTraceUtils.print("==============GC start");
        BTraceUtils.jstack();
        BTraceUtils.print("==============GC end");
    }
}
```
