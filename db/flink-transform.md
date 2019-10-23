#### source

Source就是你程序读取input的地方，你可以通过调用`StreamExecutionEnvironment.addSource(sourceFunction)`来添加一个Source到你的程序中，Flink提供了一些预定义的Source函数，但是你也可以通过实现`SourceFunction`接口来实现非并行的Source或者实现`ParalleSourceFunction`接口或者继承`RichParalleSourceFunction`类来实现并行的source。
这里有几个可以通过`StreamExecutionEnvironment`获取的预定义stream Source

###### 基于File的:

`readTextFile(path)` --- 一列一列的读取遵循TextInputFormat规范的文本文件，并将结果作为String返回。
`readFile(fileInputFormat, path)` --- 按照指定的文件格式读取文件
`readFile(fileInputFormat, path, watchType, interval, pathFilter)` --- 这个方法会被前面两个方法在内部调用，它会根据给定的fileInputFormat来读取文件内容，如果watchType是`FileProcessingModel.PROCESS_CONTINUOUSLY`的话，会周期性的读取文件中的新数据，而如果是`FileProcessingModel.PROCESS_ONCE`的话，会一次读取文件中的所有数据并退出。使用pathFilter来进一步剔除处理中的文件。

###### 基于Socket的

`socketTextStream`---从Socket中读取信息，元素可以用分隔符分开。

###### 基于集合(Collection)的

`fromCollection(seq)`--- 从Java的java.util.Collection中创建一个数据流，集合中所有元素的类型是一致的。
`fromCollection(Iterator)` --- 从迭代(Iterator)中创建一个数据流，指定元素数据类型的类由iterator返回
`fromElements(elements:_*)` --- 从一个给定的对象序列中创建一个数据流，所有的对象必须是相同类型的。
`fromParalleCollection(SplitableIterator)`--- 从一个给定的迭代(iterator)中并行地创建一个数据流，指定元素数据类型的类由迭代(iterator)返回。
`generateSequence(from, to)` --- 从给定的间隔中并行地产生一个数字序列。

###### 自定义(Custom)

`addSource` --- 附加一个新的数据源函数

#### sink

Data Sink 消费DataStream中的数据，并将它们转发到文件、套接字、外部系统或者打印出。Flink有许多封装在DataStream操作里的内置输出格式:
`writeAsText()/TextOutputFormat` --- 将元素以字符串形式逐行写入，这些字符串通过调用每个元素的toString()方法来获取。
`WriteAsCsv(…)/CsvOutputFormat` --- 将元组以逗号分隔写入文件中，行及字段之间的分隔是可配置的。每个字段的值来自对象的toString()方法。
`Print()/printToErr()` --- 打印每个元素的toString()方法的值到标准输出或者标准错误输出流中。或者也可以在输出流中添加一个前缀，这个可以帮助区分不同的打印调用，如果并行度大于1，那么输出也会有一个标识由哪个任务产生的标志。
`writeUsingOutputFormat()/FileOutputFormat` --- 自定义文件输出的方法和基类，支持自定义对象到字节的转换。
`writeToSocket` --- 根据SerializationSchema 将元素写入到socket中
`addSink` --- 调用自定义的接收器功能，Flink捆绑连接器(connectors)到外部系统中是通过sink 函数来实现的。
注意:DataStream中的write*()函数主要是调试用的，它们没有加入Flink的checkpoint机制，也就是说这些函数有至少一次(at-least-once)语义。数据流入到目标系统中取决于OutputFormat的实现，这就是说并非所有发送到OutputFormat中的元素都会立即展示在目标系统中，同时，失败的情况下，这些记录会丢失。
通过flink-connector-filesystem可以实现可靠的，仅执行一次地将流发布到文件系统中，通过`addSink(…)`方法自定义实现也可以引入Flink 的checkpoint机制来实现exactly-once机制。

#### 执行参数(Execution Parameters)

StreamExecutionEnvironment中包含了允许在运行时指定配置的ExecutionConfig对象。
来获取更多参数的描述，这些参数是针对DataStream API的:
`enableTimestamps()/disableTimestamps()`:为Source发出的每个事件附加一个时间戳，`areTimestampsEnadbled()`将返回当前设置的值
`setAutoWatermarkInterval(long milliseconds)`:设置自动水印发布的时间间隔，你可以通过`long getAutoWatermarkInterval()`方法来获取当前设置的值。

#### 控制延迟(Controlling Latency)

默认情况下，流中的元素并不会一个一个的在网络中传输(这会导致不必要的网络流量消耗)，而是缓存起来，缓存的大小可以在Flink的配置文件中配置。这个方法在优化吞吐量上是很好的，但是如果数据源输入不够快的话会导致数据延迟，为了控制吞吐量和延迟，你可以在运行环境中或者某个操作中使用`env.setBufferTimeout(timeoutMills)`来为缓存填入设置一个最大等待时间。等待时间到了之后，即使缓存还未填满,缓存中的数据也会自动发送。 这个超时的默认值是100ms。
案例:

```cpp
LocalStreamEnvironment env = StreamExecutionEnvironment.createLocalEnvironment
env.setBufferTimeout(timeoutMillis)

env.genereateSequence(1,10).map(myMap).setBufferTimeout(timeoutMillis)
```

为了最大吞吐量，可以设置setBufferTimeout(-1)，这会移除timeout机制，缓存中的数据一满就会被发送。为了最小的延迟，可以将超时设置为接近0的数(例如5或者10ms)。 缓存的超时不要设置为0，因为设置为0会带来一些性能的损耗。

#### transformation

数据的transformation将一个或者多个DataStream转换成一个或者多个新的DataStream，程序可以将多个transformation操作组合成一个复杂的拓扑结构,下面是flink常用的transformation

###### **map**

**DataStream → DataStream**: 输入一个参数产生一个参数，map的功能是对输入的参数进行

###### **flatMap**

**DataStream → DataStream**: 输入一个参数，产生0个、1个或者多个输出. 

###### **filter**

**DataStream → DataStream**: 结算每个元素的布尔值，并返回布尔值为true的元素

###### keyBy

**DataStream → KeyedStream**: 逻辑地将一个流拆分成不相交的分区，每个分区包含具有相同key的元素. 在内部是以hash的形式实现的.

###### reduce

**KeyedStream → DataStream**: 一个分组数据流的滚动规约操作. 合并当前的元素和上次规约的结果，产生一个新的值.

###### flod

**KeyedStream → DataStream**: 一个有初始值的分组数据流的滚动折叠操作. 合并当前元素和前一次折叠操作的结果，并产生一个新的值

###### aggregations

**KeyedStream → DataStream**: 分组数据流上的滚动聚合操作. min和minBy的区别是min返回的是一个最小值，而minBy返回的是其字段中包含最小值的元素(同样原理适用于max和maxBy)

###### window

**KeyedStream → WindowedStream**: Windows 是在一个分区的 KeyedStreams中定义的. Windows 根据某些特性将每个key的数据进行分组 (例如:在5秒内到达的数据)

###### windowAll

**DataStream → AllWindowedStream**: Windows 可以在一个常规的 DataStreams中定义. Windows 根据某些特性对所有的流 (例如:5秒内到达数数据)注意: 这个操作在许多情况下并非并行操作. 所有的记录都会聚集到一个windowAll操作的任务中。

###### windowApply

**WindowedStream → DataStream**、**AllWindowedStream → DataStream** 将一个通用函数作为一个整体传给window.

###### windowReduce

**WindowedStream → DataStream** 给window赋一个reduce功能的函数，并返回一个规约的结果.

###### windowFold

**WindowedStream → DataStream** 给窗口赋一个fold功能的函数，并返回一个fold后的结果

###### aggregations on Window

**WindowedStream → DataStream** 对window的元素做聚合操作. min和 minBy的区别是min返回的是最小值，而minBy返回的是包含最小值字段的元素。(同样的原理适用于 max 和 maxBy)



###### union

**DataStream → DataStream** 对两个或者两个以上的DataStream进行union操作，产生一个包含所有DataStream元素的新DataStream.注意:如果将一个DataStream跟它自己做union操作，在新的DataStream中，将看到每一个元素都出现两次.



###### windowJoion

**DataStream,DataStream → DataStream** 根据一个给定的key和window对两个DataStream做join操作.

```java
dataStream.join(otherStream)
    .where(<key selector>).equalTo(<key selector>)
    .window(TumblingEventTimeWindows.of(Time.seconds(3)))
    .apply { ... }
```

###### window CoGroup

**DataStream,DataStream → DataStream** 根据一个给定的key和window对两个DataStream做Cogroups操作.

```java
dataStream.coGroup(otherStream)
    .where(0).equalTo(1)
    .window(TumblingEventTimeWindows.of(Time.seconds(3)))
    .apply {}
```

###### connect

**DataStream,DataStream → ConnectedStreams**: 连接两个保持他们类型的数据流.

###### CoMap\CoFlatMap

**ConnectedStreams → DataStream** 作用于connected 数据流上，功能与map和flatMap一样

###### split

**DataStream → SplitStream**: 根据某些特征把一个DataStream拆分成两个或者多个DataStream.

###### select

**plitStream → DataStream**: 从一个SplitStream中获取一个或者多个DataStream.

###### iterate

**DataStream → IterativeStream → DataStream**: 在流程中创建一个反馈循环，将一个操作的输出重定向到之前的操作中. 这对于定义持续更新模型的算法来说是很有意义的.



###### Extract Timestamps

DataStream → DataStream 提取记录中的时间戳来跟需要事件时间的window一起发挥作用









