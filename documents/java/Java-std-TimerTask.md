title: 利用Timer和TimerTask完成简单的定时任务
date: 2016-01-02 16:49:54
tags: Java
categories: Java
---
在  Java中不借用第三方包可以实用Timer和TimerTask即可完成简单的定时任务。当然实际编程中经常借助如quartz完成

# Timer
Timer类是一种线程设施,可以用来实现在某一个时间或某一段时间后安排某一个任务执行一次或,定期重复执行.该功能要与TimerTask配合适用.TimerTask

类用来实现由Timer安排的一次或重复执行的某一个任务.

每一个Timer对象对应的是一个线程,因此计时器所执行的任务应该迅速完成.否则可能会延迟后续任务的执行.而这些后续的任务就有可能堆在一起.等待该

任务完成后才能快速连续执行.

该类常用的方法:


构造方法:
```java
    //用来创建一个计时器并启动该计时器
    public  Timer()

    //用来终止该计时器,并放弃所有已安排的任务.对当前正在执行的任务没有影响
    public  void cancel()

    //将所有已经取消的任务移除,一般用来释放内存空间
    public  int purge()

    //安排一个任务在指定的时间执行,然后以固定的频率(单位:毫秒)重复执行
    public  void schedule(TimerTask task,Date time)

    //安排一个任务在一段时间(单位:毫秒)后执行
    public  void schedule(TimerTask task, long delay)

    //安排一个任务在指定的时间执行,然后以近似的固定频率重复执行
    public  void scheduleAtFixedRate(TimerTask task,Date firstTime,long period)

    //安排一个任务在一段时间后执行,然后以近似固定的频率重复执行
    public  void scheduleAtFixedRate(TimerTask task,long delay,long period)
```

上述,schedule()与scheduleAtFixedRate()方法的区别在于重复执行任务相对于时间间隔出现延迟的情况除了:

+ schedule() 方法的执行时间间隔永远是固定的,如果之前出现了延迟的情况,之后也会继续按照设定好的间隔时间来执行

+ scheduleAtFixedRate() 方法可以根据出现的延迟时间自动调整下一次间隔的执行时间.


# TimerTask
要执行具体的任务.则必须适用TimerTask类.TimerTask类是一个抽象类,如果要适用该类,需要自己建立一个类来继续继承此类.并实现其中的抽象方法.TimerTask

中的常用方法有:
```java
    //用来终止此任务,如果该任务只执行一次且没有执行,则永远不会执行,如果为重复执行任务,则之后不会再执行.
    public void cancel()

    //该任务所要执行的具体操作,该方法为引入的接口Runnable中的方法,子类需要覆写此方法
    public void run()

    //返回最近一次要执行该任务的时间.(如果正在执行,则返回此任务的执行安排时间)
    public long scheduledExecutionTime()
```

//一般在run()方法调用,用来判断当前是否有足够的时间来执行完成该任务.

```java
    package timerTest;
    import java.text.SimpleDateFormat;
    import java.util.Date;
    import java.util.Timer;
    import java.util.TimerTask;
    public class Demo1 {
    public static void main(String[] args) {
        Timer timer = new Timer();
        myTask task = new myTask();
        //一秒后开始执行myTask，以后每5秒执行一次
        timer.schedule(task, 1000, 5000);
    }
    }
    /**
    * @type class
    * @resume 定时任务调度的任务指定
    *
    */
    class myTask extends TimerTask{
        @Override
        public void run() {
        SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        System.out.println("系统当前时间为："+date.format(new Date()));
        }
    }
```