title: JDK中提供的线程池方案
date: 2016-10-18 09:49:54
tags: Java
categories: Java
---
JDK中提供了一套Executor框架,帮助开发人员有效的进行线程控制,其本质就是一个线程池。其操作也简单，通过Executors类的静态工厂方法获取到一个特定功能的线程池ExecutorService(普通线程池)或ScheduledExecutorService(具有调度功能的线程池)对象，然后通过该对象的submit方法提交一个任务到线程池中。线程池会自己根据实际情况进行任务处理。




## Executors
该类扮演着线程池工厂的角色，通过Executors可以取得一个拥有特定功能的线程池。该类主要提供了下工厂方法
```java
	//该方法返回一个固定线程数量的线程池.该线程池中的线程数量始终不变，当有一个新的任务提交时
	//线程池中有空闲的线程则立即执行，否则等待有空闲线程位置
	public static ExecutorService newFixedThreadPool(int nThreads)

	//该方法返回一个只有一个线程的线程池,若有多个任务被提交到该线程池,任务会会保存在任务队列中，
	//等待线程空闲按先进先出的顺序执行
	public static ExecutorService newSingleThreadExecutor()

	//该方法返回一个可根据实际情况调整线程数量。若有空闲线程可以服用,没有则会新建线程
	public static ExecutorService newCachedThreadPool()

	//该方法返回一个ScheduledExecutorService对象，线程池大小为1,该对在ExecutorService接口上扩展了
	//在给定时间执行某个任务,如在某个固定的延时之后执行,或者周期新执行任务
	public static ScheduledExecutorService newSingleThreadScheduledExecutor()

	//该方法和newSingleThreadScheduledExecutor类似但是可以指定线程池的数量
	public static ScheduledExecutorService newScheduledThreadPool(int corePoolSize)
```
下面是一个见得线程池实例
```java
package thread.ThreadPool;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * 缓存线程池
 */
public class CacheThreadPool implements Runnable{
    @Override
    public void run() {
        String name = Thread.currentThread().getName();
        for (int i = 0; i < 5; i++) {
            System.out.println(name+":线程在运行!");
            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) throws InterruptedException {
        //创建缓存线程池
        ExecutorService executorService =  Executors.newCachedThreadPool();


        FixedThreadPool task = new FixedThreadPool();
        for (int i = 0; i < 10; i++) {
            //向线程池中提交任务
            executorService.submit(task);
            Thread.sleep(250);
        }

    }
}

```

## ScheduleExecutorService
通过工厂方法得到的ScheduledExecutorService对象可以根据时间需要对线程进行调度，它主要有如下几个方法！
再此需要说明的是当调度周期小任务处理时间时不会出现任务重叠现象的！
```java
	//会在给定时间，对任务进行一次调度
	public ScheduledFuture<?> schedule(Runnable command,long delay,TimeUnit unit);

	//对任务进行固定频率的调用
	public ScheduledFuture<?> scheduleAtFixedRate(Runnable commond,long initDelay,
		long period,TimeUnit unit);

	//等上一个任务执行结束后,经过固定时间后再调用	
	public ScheduledFuture<?> scheduleWithFixedDelay(Runnable command,Long initDelay,
		long delay,TimeUnit unit);

```
下面是一个调度线程池相关的实例
```java
package thread.ThreadPool;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * ScheduleExecutorService线程池
 */
public class ScheduledExecutorServiceDemo implements Runnable {
    private String name;

    @Override
    public void run() {

        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");

        System.out.println(name + ":线程开始执行" + sdf.format(new Date()));
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

    }

    public ScheduledExecutorServiceDemo(String name) {
        this.name = name;
    }

    public static void main(String[] args) {
        ScheduledExecutorService scheduledExecutorService = Executors.newScheduledThreadPool(5);


        //1秒后执行该任务
        ScheduledExecutorServiceDemo task1 =
                new ScheduledExecutorServiceDemo("只执行一次任务");
        scheduledExecutorService.schedule(task1, 1, TimeUnit.DAYS.SECONDS);


        //5秒后开始每十秒调用一次该任务
        ScheduledExecutorServiceDemo task2 =
                new ScheduledExecutorServiceDemo("固定周期任务");
        scheduledExecutorService.scheduleAtFixedRate(task2, 5, 2, TimeUnit.SECONDS);

        //5秒后在上一个任务完成的基础上开始每十秒调用一次该任务
        ScheduledExecutorServiceDemo task3 =
                new ScheduledExecutorServiceDemo("保证上次任务完成的基础上固定周期任务");
        scheduledExecutorService.scheduleWithFixedDelay(task3, 5, 2, TimeUnit.SECONDS);
    }


}

```

## ThreadPoolExecutor
查看Executors该的源码可以发现发现其提供的几个工厂方法都是new了一个ThreadPoolExecutor对象。由此可以看出ThreadPoolExecutor类的强大.下面是该类的构造方法
```java
public ThreadPoolExecutor(int corePoolSize,
                              int maximumPoolSize,
                              long keepAliveTime,
                              TimeUnit unit,
                              BlockingQueue<Runnable> workQueue) ;

    public ThreadPoolExecutor(int corePoolSize,
                              int maximumPoolSize,
                              long keepAliveTime,
                              TimeUnit unit,
                              BlockingQueue<Runnable> workQueue,
                              RejectedExecutionHandler handler);
    public ThreadPoolExecutor(int corePoolSize,	//指定了线程池中线程数量
                              int maximumPoolSize,//指定了线程池中的最大线程数量
                              long keepAliveTime,//当线程池数量超过corePoolSize时，多余的空闲线程存活时间
                              TimeUnit unit, //keppAliveTime的单位
                              BlockingQueue<Runnable> workQueue,//任务队列
                              ThreadFactory threadFactory,//线程工厂,用于创建线程，
                              RejectedExecutionHandler handler//拒绝策略,当任务太多来不及处理，如何拒绝任务
                              )                                                            
```
因此可以根据上述构造方法可以根据自己的需求构建符合自己要求的线程池。同时ThreadPoolExecutor也提供了类似前置方法后后置方法的接口。分别为beforeExecute和afterExecute可以对线程池进行一定控制。下面使用自定的线程池的实例
```java
package thread.ThreadPool;

import java.util.concurrent.*;

/**
 * 创建自定义的线程池
 */
public class ThreadPoolExecutoreDemo implements Runnable{
    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public ThreadPoolExecutoreDemo(String name) {
        this.name = name;
    }

    @Override
    public void run() {
        System.out.println(name+":正在执行");
    }

    public static void main(String[] args) {

        //创建自定义的线程池
        ExecutorService executorService = new ThreadPoolExecutor(
                5, 5, 0L, TimeUnit.MILLISECONDS,
                new LinkedBlockingDeque<Runnable>()){
            @Override
            protected void beforeExecute(Thread t, Runnable r) {

                System.out.println("准备执行:"+((ThreadPoolExecutoreDemo)r).getName());
            }

            @Override
            protected void afterExecute(Runnable r, Throwable t) {
                System.out.println("执行结束:"+((ThreadPoolExecutoreDemo)r).getName());
            }

            @Override
            protected void terminated() {
                System.out.println("线程池关闭");
            }
        };


        //向线程池提交任务
        for (int i = 0; i < 5; i++) {
            executorService.execute(new ThreadPoolExecutoreDemo("任务"+i));
        }


        //关闭线程池
        executorService.shutdown();
    }
}


```