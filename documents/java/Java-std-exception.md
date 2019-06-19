title: Java中优雅的记录异常信息
date: 2016-08-21 09:49:54
tags: Java
categories: Java
---
程序中有效的记录异常信息是必要且不能少的。还在使用使用下面的方式记录异常？是不是觉得记录的信息中自己关心的只有那么几行，其他很多信息都是无用的？

### 常用的记录信息方法
```java
try {
    ret = testEx1();
} catch (Exception e) { 
    System.out.println("testEx, catch exception"); 
    ret = false; 
    e.printStackTrace();
    //throw e;
} finally { 
    System.out.println("testEx, finally; return value=" + ret); 
    return ret; 
} 
```

### 使用LOG4J单独配置异常记录文件
```java
### set log levels ###
log4j.rootLogger = ERROR ,  stdout ,  D ,  E



### 输出到控制台 ###
log4j.appender.stdout = org.apache.log4j.ConsoleAppender
log4j.appender.stdout.Target = System.out
log4j.appender.stdout.layout = org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern =%d{yyyy-MM-dd HH:mm:ss} %5p [%c:%L] - %m%n


### 输出到日志文件 ###
log4j.appender.D = org.apache.log4j.DailyRollingFileAppender
log4j.appender.D.File = logs/log.log
log4j.appender.D.Append = true
## 输出DEBUG级别以上的日志
log4j.appender.D.Threshold = DEBUG
log4j.appender.D.layout = org.apache.log4j.PatternLayout
log4j.appender.D.layout.ConversionPattern =%d{yyyy-MM-dd HH:mm:ss} %5p [%c:%L] - %m%n


### 保存异常信息到单独文件 ###
log4j.appender.E = org.apache.log4j.DailyRollingFileAppender
## 异常日志文件名
log4j.appender.E.File = logs/error.log
log4j.appender.E.Append = true
## 只输出ERROR级别以上的日志!!!
log4j.appender.E.Threshold = ERROR
log4j.appender.E.layout = org.apache.log4j.PatternLayout
log4j.appender.E.layout.ConversionPattern = %d{yyyy-MM-dd HH:mm:ss} %5p [%c:%L] - %m%n
```

然后上述方法记录的异常信息可能是如下的形式的,
```java
java.lang.ArithmeticException: / by zero
	at com.opslab.util.ExceptionUtilTest.testStackTraceToString(ExceptionUtilTest.java:13)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at org.junit.runners.model.FrameworkMethod$1.runReflectiveCall(FrameworkMethod.java:50)
	at org.junit.internal.runners.model.ReflectiveCallable.run(ReflectiveCallable.java:12)
	at org.junit.runners.model.FrameworkMethod.invokeExplosively(FrameworkMethod.java:47)
	at org.junit.internal.runners.statements.InvokeMethod.evaluate(InvokeMethod.java:17)
	at org.junit.runners.ParentRunner.runLeaf(ParentRunner.java:325)
	at org.junit.runners.BlockJUnit4ClassRunner.runChild(BlockJUnit4ClassRunner.java:78)
	at org.junit.runners.BlockJUnit4ClassRunner.runChild(BlockJUnit4ClassRunner.java:57)
	at org.junit.runners.ParentRunner$3.run(ParentRunner.java:290)
	at org.junit.runners.ParentRunner$1.schedule(ParentRunner.java:71)
	at org.junit.runners.ParentRunner.runChildren(ParentRunner.java:288)
	at org.junit.runners.ParentRunner.access$000(ParentRunner.java:58)
	at org.junit.runners.ParentRunner$2.evaluate(ParentRunner.java:268)
	at org.junit.runners.ParentRunner.run(ParentRunner.java:363)
	at org.junit.runner.JUnitCore.run(JUnitCore.java:137)
	at com.intellij.junit4.JUnit4IdeaTestRunner.startRunnerWithArgs(JUnit4IdeaTestRunner.java:117)
	at com.intellij.junit4.JUnit4IdeaTestRunner.startRunnerWithArgs(JUnit4IdeaTestRunner.java:42)
	at com.intellij.rt.execution.junit.JUnitStarter.prepareStreamsAndStart(JUnitStarter.java:253)
	at com.intellij.rt.execution.junit.JUnitStarter.main(JUnitStarter.java:84)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at com.intellij.rt.execution.application.AppMain.main(AppMain.java:147)
```
然后实际分析的时候发现有用的信息只有俩行，因此真的需要这么多的信息？显然没必要！
```java
//有用的日志
java.lang.ArithmeticException: / by zero
	at com.opslab.util.ExceptionUtilTest.testStackTraceToString(ExceptionUtilTest.java:13)
```

### 如何只记录有效的日志信息？
只要想肯定是有办法的,办法就是对异常堆栈进行过滤，然后将异常信息和常规信息进行分类储存，这样做的好处有
>* 便于对日志信息分析
>* 记录的信息都是自己关心的，干扰信息少
>* 因为记录的信息少便于log4j等日志组件的减少IO，有助提升性能
>* 便于统一化的日志管理

### 如何做
首先对异常信息过滤，获得自己关心的日志信息，通过查看jdk源码，写了如下方式可以做到简单的过滤
```java
//可以通过使用我开源的工具包获取
//https://github.com/0opslab/utils/blob/master/src/main/java/com/opslab/util/ExceptionUtil.java
/**
     * 只返回指定包中的异常堆栈信息
     *
     * @param e
     * @param packageName
     * @return
     */
    public final static String stackTraceToString(Throwable e, String packageName) {
        StringWriter sw = new StringWriter();
        e.printStackTrace(new PrintWriter(sw, true));
        String str = sw.toString();
        String[] arrs = str.split("\n");
        StringBuffer sbuf = new StringBuffer();
        sbuf.append(arrs[0] + "\n");
        for (int i = 0; i < arrs.length; i++) {
            String temp = arrs[i];
            if (temp != null && temp.indexOf(packageName) > 0) {
                sbuf.append(temp + "\n");
            }
        }
        return sbuf.toString();
    }
```
记录日志信息
```java
try{
    int i=1/0;
    System.out.println(i);
}catch (Exception e){
    String errorMsg  = ExceptionUtil.stackTraceToString(e,"com.opslab"));
    logger.error(errorMsg);
}
```
记录的日志信息只有俩行，是不是很简洁一眼就能看出问题出在哪了？
```java
java.lang.ArithmeticException: / by zero
	at com.opslab.util.ExceptionUtilTest.testStackTraceToString(ExceptionUtilTest.java:13)
```
对用一般的应用使用以上的方法一般都可以了,但少大上面的方式显然侵入太深，此时可以使用在统一异常处理的部分中，例如springmvc中可以在GlobalExceptionHandler中使用。
当然再使用log4j将不同级别的日志分类存储就更完美了