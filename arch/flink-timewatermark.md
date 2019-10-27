## Flink生产Timestamps和watermarks

有关event time, processing time, and ingestion time的更多介绍，请参阅flink官方文档介绍。显示开发中处理乱序带有事件时间的任务应该是最重要也是最符合业务开发的。为了完成这样的工作，需要设置flink处理该类问题是必须的时间特性外，还需要分别事件的时间戳和水印方便完成各种任务。

```scala
val env = StreamExecutionEnvironment.getExecutionEnvironment
env.setStreamTimeCharacteristic(TimeCharacteristic.EventTime)
```

## 时间戳和水印的生成方式

flink中目前有俩种方式分配时间戳和生产水印

* 直接在数据流源source中进行
* 通过timestamp assigner和watermakrs generator生成

### 带有timestamp和watermark的源

数据流源中可以直接为数据袁术分配timestamp并且他们也能发送水印，处理这样的数据流源就没有必要去指定timestam分配器了。在数据流源中可以同，`SourceContext`中的`collectWithTimestamp(...)`方法。为了生成watermark，源需要调用`emitWatermark(Watermark)`方法。下面是一个没有checkpoint的在源中分配timestamp和生产watermark的例子。

```scala
override def run(ctx: SourceContext[MyType]): Unit = {
    while (/* condition */) {
        val next: MyType = getNext()
        ctx.collectWithTimestamp(next, next.eventTimestamp)

        if (next.hasWatermarkTime) {
            ctx.emitWatermark(new Watermark(next.getWatermarkTime))
        }
    }
}
```

### Timestamps assigner和watermark generator

在说具体的代码实现前，先看看flink为Timestamps assigner时间戳分配器提供的接口及继承关系。首先定义了org.apache.flink.streaming.api.functions.TimestampAssigner接口，其次又有如下的继承关系

![1567336431863](C:\Users\Administrator\Desktop\1567336431863.png)

从继承关系中可以明显的看出其主要分为AssignerWithPeriodicWatermarks和AssignerWithPunctuatedWatermarks俩大类别的接口。其实其也对应着俩大业务场景。

#### AssignerWithPeriodicWatermarks周期性时间分配及水印

`AssignerWithPeriodicWatermarks`分配时间戳并定期生成水印(这可能依赖于流元素，或者纯粹基于处理时间)。watermark`生成的时间间隔(每n毫秒)是通过`ExecutionConfig.setAutoWatermarkInterval(…)`定义的。每次调用分配器的`getCurrentWatermark()`方法时，如果返回的`watermark`非空且大于前一个`watermark`，则会发出新的`watermark`。

下面是展示了两个使用周期性水印生成的时间戳分配器的简单示例

```scala
class BoundedOutOfOrdernessGenerator extends AssignerWithPeriodicWatermarks[MyEvent] {

    val maxOutOfOrderness = 3500L // 3.5 seconds

    var currentMaxTimestamp: Long = _

    override def extractTimestamp(element: MyEvent, previousElementTimestamp: Long): Long = {
        val timestamp = element.getCreationTime()
        currentMaxTimestamp = max(timestamp, currentMaxTimestamp)
        timestamp
    }

    override def getCurrentWatermark(): Watermark = {
        // return the watermark as current highest timestamp minus the out-of-orderness bound
        new Watermark(currentMaxTimestamp - maxOutOfOrderness)
    }
}

class TimeLagWatermarkGenerator extends AssignerWithPeriodicWatermarks[MyEvent] {

    val maxTimeLag = 5000L // 5 seconds

    override def extractTimestamp(element: MyEvent, previousElementTimestamp: Long): Long = {
        element.getCreationTime
    }

    override def getCurrentWatermark(): Watermark = {
        // return the watermark as current time minus the maximum time lag
        new Watermark(System.currentTimeMillis() - maxTimeLag)
    }
}
```



#### AssignerWithPunctuatedWatermarks断点分配器及水印

无论何时，当某一事件表明需要创建新的`watermark`时，使用`AssignerWithPunctuatedWatermarks`创建。这个类首先调用`extractTimestamp(…)`方法来为元素分配一个时间戳，然后立即调用该元素上的`checkAndGetNextWatermark(…)`方法。checkAndGetNextWatermark(…)方法传入在给extractTimestamp(…)方法中分配的`timestamp`，并可以决定是否要生成`watermark`。每当`checkAndGetNextWatermark(…)`方法返回一个非空`watermark`并且该`watermark`大于最新的前一个`watermark`时，就会发出新的`watermark`。

```scala
class PunctuatedAssigner extends AssignerWithPunctuatedWatermarks[MyEvent] {

    override def extractTimestamp(element: MyEvent, previousElementTimestamp: Long): Long = {
        element.getCreationTime
    }

    override def checkAndGetNextWatermark(lastElement: MyEvent, extractedTimestamp: Long): Watermark = {
        if (lastElement.hasWatermarkMarker()) new Watermark(extractedTimestamp) else null
    }
}
```

### 时间时间分配器和水印

查看flink的datastream流的api你可以发现，如下3三个方法，其中已经被deprecated的方法

```java
//deprecated
//此方法是数据流的快捷方式，其中已知元素时间戳在每个并行流中单调递增。
//在这种情况下，系统可以通过跟踪上升时间戳自动且完美地生成水印。
public SingleOutputStreamOperator<T> assignTimestamps(TimestampExtractor<T> extractor) 

//对应AssignerWithPeriodicWatermarks
//基于给定的水印生成器生成水印，即使没有新元素到达也会定期检
//查给定水印生成器的新水印，以指定允许延迟时间
public SingleOutputStreamOperator<T> assignTimestampsAndWatermarks(AssignerWithPeriodicWatermarks<T> timestampAndWatermarkAssigner) 

//使用实例
source...
// assign timestamp & watermarks periodically(定期生成水印 延迟50ms)
    .assignTimestampsAndWatermarks(new BoundedOutOfOrdernessTimestampExtractor[LateDataEvent](Time.milliseconds(50)) {
        override def extractTimestamp(element: LateDataEvent): Long = {
            println("want watermark : " + sdf.parse(element.createTime).getTime)
                sdf.parse(element.createTime).getTime
        }    

//对应AssignerWithPunctuatedWatermarks
//此方法仅基于流元素创建水印，对于
//通过[[AssignerWithPunctuatedWatermarks::extractTimestamp（Object，long）]]
//处理的每个元素，
//调用[[AssignerWithPunctuatedWatermarks＃checkAndGetNextWatermark（）]]方法，
//如果返回的水印值大于以前的水印，会发出新的水印，
//此方法可以完全控制水印的生成，但是要注意，每秒生成数百个水印会影响性能    
public SingleOutputStreamOperator<T> assignTimestampsAndWatermarks(AssignerWithPunctuatedWatermarks<T> timestampAndWatermarkAssigner)
    
    
//使用实例
source...
// assign timestamp & watermarks every event
      .assignTimestampsAndWatermarks(new AssignerWithPunctuatedWatermarks[LateDataEvent]() {
      // check extractTimestamp emitted watermark is non-null and large than previously
      override def checkAndGetNextWatermark(lastElement: LateDataEvent, extractedTimestamp: Long): Watermark = {
        new Watermark(extractedTimestamp)
      }
      // generate next watermark
      override def extractTimestamp(element: LateDataEvent, previousElementTimestamp: Long): Long = {
        val eventTime = sdf.parse(element.createTime).getTime
        eventTime
      }
    })
    
```

