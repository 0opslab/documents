title: JDK中提供的线程安全的集合
date: 2016-10-18 13:49:54
tags: Java
categories: Java
---
Java不但提供了很好的多线程的支持，同时提供了一些线程安全的集合，方便在多线程环境下做数据交换等操作。当然Collections工具类本身就可以将任意集合包装成线程安全的集合。

## Collections提供的工具方法
```java
	//可以通过该方法将一个Map对象转换成线程安全的
	//查看源码可以看到该方法使用锁实现
	public static <K,V> Map<K,V> synchronizedMap(Map<K,V> m)

	//可以通过该方法将一个List对象转换成线程安全的
	public static <T> List<T> synchronizedList(List<T> list) 

	...
```

## ConcurrentHashMap
这是一个高效的并发HashMap,可以理解为一个线程安全的HashMap
```java
package thread.collection;

import java.util.concurrent.ConcurrentHashMap;

/**
 * ConcurrentHashMap测试
 */
public class ConcurrentHashMapTest {

    private static ConcurrentHashMap<Integer, Integer> map =
                new ConcurrentHashMap<Integer, Integer>();


    public static void main(String[] args) {
        new Thread("Thread1"){
            @Override
            public void run() {
                for (int i = 0; i < 5; i++) {
                    map.put(i, i*i);
                }
            }
        }.start();

        new Thread("Thread2"){
            @Override
            public void run() {
                for (int i = 10; i < 20; i++) {
                    map.put(i, i*i);
                }

            }
        }.start();

        new Thread("Thread3"){
            @Override
            public void run() {
                for (int i = 0; i < 20; i++) {
                    System.out.println(map.get(i));
                }
            }
        }.start();


        System.out.println(map);
    }
}
```

## CopyOnWriteArrayList
这是一个List的实现，适用于读多写少的场合,这个List的性能非常好，远远好于Vettor
```java
package thread.collection;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * CopyOnWriteArrayList 根据类名就可以知道该类的实现在某些操作中或执行一次copy
 * 因此有一定的开销，当然如果在读远远大于写的环境中这开销是值得的
 */
public class CopyOnWriteArrayListTest {

    /**
     * 读线程
     */
    public static class ReadTask implements Runnable{
        private List<Integer> list ;

        public ReadTask(List<Integer> list) {
            this.list = list;
        }

        @Override
        public void run() {
            String name = Thread.currentThread().getName();
            if(list != null && list.size() > 0){
                for(Integer i:list){
                    System.out.println(name+":线程读取>"+i);
                }
            }
        }
        
        
    }

    public static class WriteTask implements Runnable{
        private List<Integer> list ;

        public WriteTask(List<Integer> list) {
            this.list = list;
        }

        @Override
        public void run() {
            String name = Thread.currentThread().getName();
            for (int i = 0; i < 10; i++) {
                System.out.println(name+":线程更新数据");
                list.add(i);
            }
        }
    }

    public static void main(String[] args) {
        CopyOnWriteArrayList list = new CopyOnWriteArrayList();
        ScheduledExecutorService scheduledExecutorService = Executors.newScheduledThreadPool(10);
        ReadTask readTask = new ReadTask(list);
        WriteTask writerTask = new WriteTask(list);

        scheduledExecutorService.scheduleAtFixedRate(writerTask,2,20, TimeUnit.SECONDS);

        scheduledExecutorService.scheduleAtFixedRate(readTask,1,2,TimeUnit.SECONDS);

    }
}

```
## BlockingQueue 和ConcurrentLinkedQueue
这是一个接口，表示阻塞队列，非常适用于做数据共享的通道。其实现类有LinkedBlockingDeque。而ConcurrentLinkedQueue是一个基于链接节点的无界线程安全队列，它采用先进先出的规则对节点进行排序，当我们添加一个元素的时候，它会添加到队列的尾部，当我们获取一个元素时，它会返回队列头部的元素

### 非阻塞队列的实现生产者消费者模式
你会发现生产的产品的会越来越多,嘎嘎！要是吃的还好其他的你就等着吧
```
package thread.collection;

import java.util.concurrent.*;

/**
 * ConcurrentLinkedQueue是一个基于链接节点的无界线程安全队列
 * 所以当插入比取出的多很多的时候，系统会有严重的开销
 */
public class ConcurrentLinkedQueueTest {

    public static class Monitor implements Runnable{
        private ConcurrentLinkedQueue queue;

        public Monitor(ConcurrentLinkedQueue queue) {
            this.queue = queue;
        }

        @Override
        public void run() {
            System.out.println("当前产品数量:"+queue.size());
        }

    }

    /**
     * 生产者
     */
    public static class Producer implements Runnable{
        private ConcurrentLinkedQueue queue;

        public Producer(ConcurrentLinkedQueue queue) {
            this.queue = queue;
        }

        @Override
        public void run() {
            for (int i = 0; i < 10; i++) {
                System.out.println("生产出:"+i);
                queue.offer(i);
            }
        }
    }

    public static class Customer implements Runnable{
        private ConcurrentLinkedQueue queue;

        public Customer(ConcurrentLinkedQueue queue) {
            this.queue = queue;
        }

        @Override
        public void run() {
            if (queue != null && queue.size() > 0){
                Object poll = queue.poll();
                System.out.println("消费产品:"+poll);
            }
        }
    }

    public static void main(String[] args) {
        ConcurrentLinkedQueue queue = new ConcurrentLinkedQueue();

        ScheduledExecutorService scheduledExecutorService = Executors.newScheduledThreadPool(10);

        //启动生产
        //每10秒生产一次
        scheduledExecutorService.scheduleAtFixedRate(new Producer(queue),2,10, TimeUnit.SECONDS);

        /**
         * 每2秒大于一次
         */
        scheduledExecutorService.scheduleAtFixedRate(new Customer(queue),1,2,TimeUnit.SECONDS);

        /**
         * 每10秒打印队列的大小
         */
        scheduledExecutorService.scheduleAtFixedRate(new Monitor(queue),5,10,TimeUnit.SECONDS);
    }
}

```

### 阻塞方式的实现生产者消费者模式
```java
package thread.collection;

import java.util.concurrent.*;

/**
 * 阻塞模式的生产者消费者模式
 * 方法\处理方式	抛出异常	返回特殊值	一直阻塞	超时退出
 * 插入方法	add(e)	    offer(e)	put(e)	offer(e,time,unit)
 * 移除方法	remove()	poll()	    take()	poll(time,unit)
 * 检查方法	element()	peek()	    不可用	不可用
 */
public class LinkedBlockingQueueTest {

    public static class Monitor implements Runnable{
        private BlockingQueue queue;

        public Monitor(BlockingQueue queue) {
            this.queue = queue;
        }

        @Override
        public void run() {
            System.out.println("当前产品数量:"+queue.size());
        }

    }

    /**
     * 生产者
     */
    public static class Producer implements Runnable{
        private BlockingQueue queue;

        public Producer(BlockingQueue queue) {
            this.queue = queue;
        }

        @Override
        public void run() {
            for (int i = 0; i < 10; i++) {
                System.out.println("生产出:"+i);
                queue.offer(i);
            }
        }
    }

    public static class Customer implements Runnable{
        private BlockingQueue queue;

        public Customer(BlockingQueue queue) {
            this.queue = queue;
        }

        @Override
        public void run() {
            if (queue != null && queue.size() > 0){
                Object poll = null;
                try {
                    poll = queue.take();
                    System.out.println("消费产品:"+poll);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }

            }
        }
    }

    public static void main(String[] args) {
        BlockingQueue queue = new LinkedBlockingQueue(10);

        ScheduledExecutorService scheduledExecutorService = Executors.newScheduledThreadPool(10);

        //启动生产
        //每10秒生产一次
        scheduledExecutorService.scheduleAtFixedRate(new Producer(queue),2,10, TimeUnit.SECONDS);

        /**
         * 每2秒大于一次
         */
        scheduledExecutorService.scheduleAtFixedRate(new Customer(queue),1,2,TimeUnit.SECONDS);

        /**
         * 每10秒打印队列的大小
         */
        scheduledExecutorService.scheduleAtFixedRate(new Monitor(queue),5,10,TimeUnit.SECONDS);
    }
}

```


## ConcurrentSkipListMap
这是个Map的实现，使用跳表的数据结构可以进行快速查找。相对ConcurrentHashMap该实现有以下俩个有点

### 特点
>*1.key是有序的
>*2.ConcurrentSkipListMap 支持更高的并发。ConcurrentSkipListMap 的存取时间是log（N），和线程数几乎无关。
>*也就是说在数据量一定的情况下，并发的线程越多，ConcurrentSkipListMap越能体现出他的优势。

### 使用建议
在非多线程的情况下，应当尽量使用TreeMap.此外对于并发性相对较低的并行程序可以使用Collections.synchronizedSortedMap将TreeMap进行包装，也可以提供较好的效率。对于高并发程序，应当使用ConcurrentSkipListMap,能够提供更高的并发度。所以在多线程程序中，如果需要对Map的键值进行排序时，请尽量使用ConcurrentSkipListMap,可能得到更好的并发度。注意，调用ConcurrentSkipListMap的size时，由于多个线程可以同时对映射表进行操作，所以映射表需要遍历整个链表才能返回元素个数，这个操作是个O（log（n））的操作

```java
package thread.collection;

import java.util.concurrent.ConcurrentSkipListMap;
import java.util.concurrent.Semaphore;

/**
 * ConcurrentSkipListMap的测试
 */
public class ConcurrentSkipListMapTest {
    private static Semaphore semaphore = new Semaphore(1);
    private static ConcurrentSkipListMap<Integer, Integer> concurrentSkipListMap =
            new ConcurrentSkipListMap<Integer, Integer>();

    public static void main(final String args[]) throws InterruptedException {


        new Thread("Thread1"){
            @Override
            public void run() {
                for (int i = 0; i < 5; i++) {
                    concurrentSkipListMap.put(i, i*i);
                }
            }
        }.start();

        new Thread("Thread2"){
            @Override
            public void run() {
                for (int i = 10; i < 20; i++) {
                    concurrentSkipListMap.put(i, i*i);
                }

            }
        }.start();

        Thread.sleep(10000);

        
        new Thread("Thread3"){
            @Override
            public void run() {
                for (int i = 0; i < 20; i++) {
                    System.out.println(concurrentSkipListMap.get(i));
                }
            }
        }.start();
    }
}

```

