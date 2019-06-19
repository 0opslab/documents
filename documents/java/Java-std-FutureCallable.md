title: Callable Future 和 FutureTask
date: 2016-10-18 19:49:54
tags: Java
categories: Java
---
Java中提供了俩种创建线程方式，一种是直接继承Thread、另一种是实现Runnable接口。但是这俩种方式都有一个缺陷就是,在执行完任务之后无法获取执行结果！如果需要获取执行结果,就必须通过共享变量或者使用线程通信的方式来达到效果。为此JDK提供了Callable和Future通过它们可以在任务执行完毕之后得到任务执行结果。

## Callable与Runnable
在JDK中Runnable接口中定义了一个void run()方法，因此在执行完成任务之后无法返会任何结果。然而Callable接口则定义了如下方法
```java
public interface Callable<V>{
	V call() throws Exception;
}
```
一般情况下Callable和ExecutorService配合使用，在ExecutorService接口中定义了如下方法
```java
<T> Future<T> submit(Callable<T> task);
<T> Future<T> submit(Runnable task,T result);
Future<?> submit(Runnable task)
```

## Future
Future就是对具体的Runnable或者Callable任务的执行结果进行取消、查询是否完成、获取结果，必要时可以通过get方法获取执行结果，该方法会阻塞知道任务返回结果。
```java
public interface Future<V> {

	/**
	 * 取消任务,如果取消成功则返回true，如果取消失败则返回false。参数表示是否取消正则执行的任务。
	 */
    boolean cancel(boolean mayInterruptIfRunning);

	/**
	 * 表示任务是否被取消成功，如果在任务正常完成前被取消成功，则返回true
	 */
    boolean isCancelled();

	/**
	 * 表示任务是否已经完成，若任务完成则返回ture
	 */
    boolean isDone();

	/**
	 * 用来获取执行结果,这个方法会产生阻塞，会一直等待任务执行完毕才返回
	 */
    V get() throws InterruptedException, ExecutionException;

	/**
	 * 用来获取执行结果,如果在指定的时间内还未返回，则直接返回null
	 */
    V get(long timeout, TimeUnit unit)
        throws InterruptedException, ExecutionException, TimeoutException;
}
```
FutureTask是一个Future接口的实现类，该类提供了如下俩个构造器，可以方便的将Callable或Runnable转换为Future
```java
public FutureTask(Callable<V> callable) {
}
public FutureTask(Runnable runnable, V result) {
}
```

## Callable 和 Future实例
```java
package thread.ThreadPool;

import java.util.concurrent.*;

/**
 * 测试Callable
 */
public class CallableTest {
    public static class Task implements Callable<Long>{

        @Override
        public Long call() throws Exception {
            System.out.println("子线程计算中");
            Long sum = 0L;
            for (int i = 0; i < 10000; i++) {
                sum += i;
            }
            return sum;
        }
    }

    /**
     * 创建线程池并执行相应的任务
     * 注意俩种执行任务的方式以及获取结果的方法
     */
    public static void main(String[] args) throws ExecutionException, InterruptedException {

        /**
         * 创建线程池
         */
        ExecutorService executorService =  Executors.newCachedThreadPool();
        Task task = new Task();

        /**
         * 直接将Callable实例传给线程池
         */
        Future<Long> submit = executorService.submit(task);
        Long sum = submit.get();

        System.out.println("计算结果为:"+sum);

        /**
         * 将任务分装成FutureTask再提交
         */
        FutureTask<Long> taskFutureTask = new FutureTask<Long>(task);
        executorService.submit(taskFutureTask);

        Long sum1 = taskFutureTask.get();
        System.out.println("计算结果为:"+sum1);

        executorService.shutdown();

    }
}

```