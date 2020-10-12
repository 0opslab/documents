### 常见的大数据处理流程

以下是常见的大数据处理框架的一个基本核心过程

​	MapReduce:  Input -> map（reduce） -> output

​	storm： Input > spout/bolt -> output

​	spark: input > transformation/action -> output

​	flink: input > transformation/sink -> output

## flink 

经常会听到spark是现在，flink是为了。可见flink再数据处理方面flink是有着自己独有的优势。Flink是一个分层系统，从下到上分为：系统部署层、任务运行层、API层以及基于API开发的通用库层(Libraries)。而对于开发者而言，flink主要分为stateful Stream Processiing\Core APIS\Table & SQL。相对而言更多是面对core apis和table&sql

* Stateful Stream Processiing
    * 位于最底层，是core API的底层实现
    * process Function
    * 利用低阶，构建一些新组件
    * 灵活度高，但看法比较复杂
* core apis
    * DataStream 流式处理
    * DataSet 批量处理
* table & sql
    * SQL构建在Table之上，都需要构建Table环境
    * 不同类型的Table构建不同的Table环境
    * Table可以与DataStream或者DataSet进行相互转换。
    * Streaming SQL不同存储的SQL， 最终会转化为流式执行计划



### DataSet & DataStream

简单的说DataSet就是有界数据集的实现，而DataStream是无界数据集的实现。它们具有相同的特点也有个自己的特点。Dataset的实现在`flink-java`module中，而DataStream的实现在`flink-streaming-java`中。

* DataSet： 批式处理，其接口封装类似于Spark的Dataset，支持丰富的函数操作，比如map/fliter/join/cogroup等
  * 数据源创建初始数据集，例如来自文件或Java集合等静态数据；
  * 所有的操作为Operator的子类，实现具体逻辑，比如Join逻辑是在JoinOperator中实现；
* DataStram: 流式处理，其结构封装实现输入流的处理，其也实现了丰富的函数支持
  * 所有的操作为StreamOperator的子类，实现具体逻辑，比如Join逻辑是在`IntervalJoinOperator`中实现的

### transform

在flink中数据通过source进入数据流中，通过transform进行各种数据计算。然后交由sink进行数据沉淀输出。Flink中数据流中主要的操作都通过算子transformation来操作(如:过滤、修改状态、定义窗口、聚合等)。具体的算子可以单独参考：

​	https://ci.apache.org/projects/flink/flink-docs-master/dev/datastream_api.html



### time

在Flink中，有以下三种时间特征

- Processing time：Operator处理数据的时间。 是指执行相应操作的机器的系统时间。如果流计算系统基于Processing Time来处理，对流处理系统来说是最简单的，所有基于时间的操作（如Time Window）将使用运行相应算子的机器的系统时钟。然而，在分布式和异步环境中，Processing Time并不能保证确定性，它容易受到Event到达系统的速度（例如来自消息队列）以及数据在Flink系统内部处理的先后顺序的影响，所以Processing Time不能准确地反应数据发生的时间序列情况。
- Event time ： 事件发生时间。是每条数据在其生产设备上发生的时间。这段时间通常嵌入在记录数据中，然后进入Flink，可以从记录中提取事件的时间戳；Event Time即使在数据发生乱序，延迟或者从备份或持久性日志中重新获取数据的情况下，也能提供正确的结果。这个时间是最有价值的，和挂在任何电脑/操作系统的时钟时间无关。
- Ingestion time：被Flink摄入的时间。是事件进入Flink的时间。 在Source算子处产生，也就是在Source处获取到这个数据的时间，Ingestion Time在概念上位于Event Time和Processing Time之间。在Source处获取数据的时间,不受Flink分布式系统内部处理Event的先后顺序和数据传输的影响，相对稳定一些，但是Ingestion Time和Processing Time一样，不能准确地反应数据发生的时间序列情况。

### watermark机制

上面提到Event Time是最能反映数据时间属性的，但是Event Time可能会发生延迟或乱序，Flink系统本身只能逐个处理数据，为此能有效而处理Event Time这种乱序带来的问题，flink提供了watermark机制，Watermark是一个对Event Time的标识，内容方面Watermark是个时间戳，一个带有时间戳X的Watermark到达，相当于告诉Flink系统，任何Event Time小于X的数据都已到达。

Watermark的产生方式：

Periodic - 一定时间间隔或者达到一定的记录条数会产生一个watermark。

Punctuated – 基于event time通过一定的逻辑产生watermark，比如收到一个数据就产生一个WaterMark，时间是event time + 5秒。

在事件时间场景下，Flink 支持水印按事件时间处理可能的延迟和乱序事件。水印的作用：**告知算子之后不会有小于或等于水印时间戳的事件**

Flink 提供了两个预定义实现类

- `AscendingTimestampExtractor` 适用于时间戳递增的情况
- `BoundedOutOfOrdernessTimestampExtractor` 适用于乱序但最大延迟已知的情况

```
stream.assignTimestampsAndWatermarks(new AscendingTimestampExtractor[Event] {  
    override def extractAscendingTimestamp(element: Event): Long = { ... }
  })
stream.assignTimestampsAndWatermarks(new BoundedOutOfOrdernessTimestampExtractor[String]() {  
    override def extractTimestamp(element: String): Long = { ... }
  })
```

### window

spark只是近实时处理，而Flikn是真正的流处理。在设计上Flink认为数据是流式的，批处理只是流处理的特例。同时对数据分为有界数据和无界数据。有界数据对应批处理，API对应Datestet。无界数据对应流处理，API对应SataStream。当想看过去一分钟或者半小时的数据，进行聚合等操作，就需要窗口window的出现。

flink支持两种划分窗口的方式（time和count） 如果根据时间划分窗口，那么它就是一个time-window 如果根据数据划分窗口，那么它就是一个count-window。窗口有两个重要属性（size和interval）

- 如果size=interval,那么就会形成tumbling-window(无重叠数据)
- 如果size>interval,那么就会形成sliding-window(有重叠数据)
- 如果size<interval,那么这种窗口将会丢失数据。比如每5秒钟，统计过去3秒的通过路口汽车的数据，将会漏掉2秒钟的数据。

因此可以组合出四种基本窗口：

- `time-tumbling-window` 无重叠数据的时间窗口，设置方式举例：timeWindow(Time.seconds(5))
- `time-sliding-window` 有重叠数据的时间窗口，设置方式举例：timeWindow(Time.seconds(5), Time.seconds(3))

- `count-tumbling-window`无重叠数据的数量窗口，设置方式举例：countWindow(5)

- `count-sliding-window` 有重叠数据的数量窗口，设置方式举例：countWindow(5,3)

一些常用的使用实例

```scala
//假如需要统计每一分钟中用户购买的商品的总数，
//需要将用户的行为事件按每一分钟进行切分，这种切
//分被成为翻滚时间窗口（Tumbling Time Window）。
//翻滚窗口能将数据流切分成不重叠的窗口，每一个事件只能属于一个窗口

// 用户id和购买数量 stream
val counts: DataStream[(Int, Int)] = ...
val tumblingCnts: DataStream[(Int, Int)] = counts
  // 用userId分组
  .keyBy(0) 
  // 1分钟的翻滚窗口宽度
  .timeWindow(Time.minutes(1))
  // 计算购买数量
  .sum(1) 


//每30秒计算一次最近一分钟用户购买的商品总数。
//这种窗口我们称为滑动时间窗口（Sliding Time Window）。
//在滑窗中，一个元素可以对应多个窗口。

val slidingCnts: DataStream[(Int, Int)] = buyCnts
  .keyBy(0) 
  .timeWindow(Time.minutes(1), Time.seconds(30))
  .sum(1)


//想要每100个用户购买行为事件统计购买总数，
//那么每当窗口中填满100个元素了，就会对窗口进行计算，
//这种窗口我们称之为翻滚计数窗口（Tumbling Count Window）
// Stream of (userId, buyCnts)
val buyCnts: DataStream[(Int, Int)] = ...

val tumblingCnts: DataStream[(Int, Int)] = buyCnts
  // key stream by sensorId
  .keyBy(0)
  // tumbling count window of 100 elements size
  .countWindow(100)
  // compute the buyCnt sum 
  .sum(1)
```

#### 窗口操作

window是处理数据的核心。按需选择你需要的窗口类型后，它会将传入的原始数据流切分成多个buckets，所有计算都在window中进行。对于窗口的操作主要分为两种，分别对于Keyedstream和Datastream。他们的主要区别也仅仅在于建立窗口的时候一个为.window(...)，一个为.windowAll(...)。对于Keyedstream的窗口来说，他可以使得多任务并行计算，每一个logical key stream将会被独立的进行处理。

```java
/**
 * Keyed Windows
 * 可以理解为:
 *			按照原始数据流中的某个key进行分类，拥有同一个key值的数据流将为进入
 *			同一个window，多个窗口并行的逻辑流
 */
stream
   .keyBy(...)               <-  keyed versus non-keyed windows
   .window(...)              <-  required: "assigner"
   [.trigger(...)]            <-  optional: "trigger" (else default trigger)
   [.evictor(...)]            <-  optional: "evictor" (else no evictor)
   [.allowedLateness(...)]    <-  optional: "lateness" (else zero)
   [.sideOutputLateData(...)] <-  optional: "output tag" (else no side output for late data)
   .reduce/aggregate/fold/apply()      <-  required: "function"
   [.getSideOutput(...)]      <-  optional: "output tag"

/**
 * Non-Keyed Windows
 * 可以理解为:
 *			不做分类，每进入一条数据即增加一个窗口，多个窗口并行，每个窗口处理1条数据
 */    
 stream
    .windowAll(...)           <-  required: "assigner"
    [.trigger(...)]            <-  optional: "trigger" (else default trigger)
    [.evictor(...)]            <-  optional: "evictor" (else no evictor)
    [.allowedLateness(...)]    <-  optional: "lateness" (else zero)
    [.sideOutputLateData(...)] <-  optional: "output tag" (else no side output for late data)
     .reduce/aggregate/fold/apply()      <-  required: "function"
    [.getSideOutput(...)]      <-  optional: "output tag"    
    
```

对于每个window必备的是触发器Trigger和一个附加在window上的函数窗口函数就是这四个：ReduceFunction，AggregateFunction，FoldFunction，ProcessWindowFunction。前两个执行得更有效，因为Flink可以增量地聚合每个到达窗口的元素。

Flink必须在调用函数之前在内部缓冲窗口中的所有元素，所以使用ProcessWindowFunction进行操作效率不高。不过ProcessWindowFunction可以跟其他的窗口函数结合使用，其他函数接受增量信息，ProcessWindowFunction接受窗口的元数据。

#### Triggers（触发器）

触发器定义了窗口何时准备好被窗口处理。每个窗口分配器默认都有一个触发器，如果默认的触发器不符合你的要求，就可以使用trigger(...)自定义触发器。

通常来说，默认的触发器适用于多种场景。例如，多有的event-time窗口分配器都有一个EventTimeTrigger作为默认触发器。该触发器在watermark通过窗口末尾时出发。

PS：GlobalWindow默认的触发器时NeverTrigger，该触发器从不出发，所以在使用GlobalWindow时必须自定义触发器。

#### Evictors（驱逐器）

Evictors可以在触发器触发之后以及窗口函数被应用之前和/或之后可选择的移除元素。使用Evictor可以防止预聚合，因为窗口的所有元素都必须在应用计算逻辑之前先传给Evictor进行处理

#### Allowed Lateness

当使用event-time窗口时，元素可能会晚到，例如Flink用于跟踪event-time进度的watermark已经超过了窗口的结束时间戳。

默认来说，当watermark超过窗口的末尾时，晚到的元素会被丢弃。但是flink也允许为窗口operator指定最大的allowed lateness，以至于可以容忍在彻底删除元素之前依然接收晚到的元素，其默认值是0。

为了支持该功能，Flink会保持窗口的状态，知道allowed lateness到期。一旦到期，flink会删除窗口并删除其状态。

把晚到的元素当作side output。

```java
SingleOutputStreamOperator<T> result = input
    .keyBy(<key selector>)
    .window(<window assigner>)
    .allowedLateness(<time>)
    .sideOutputLateData(lateOutputTag)
    .<windowed transformation>(<window function>);
```

