#### 常见的大数据处理流程

MapReduce:  Input -> map（reduce） -> output

storm： Input > spout/bolt -> output

spark: input > transformation/action -> output

flink: input > transformation/sink -> output



### DataSet & DataStream

简单的说DataSet就是有界数据集的实现，而DataStream是无界数据集的实现。它们具有相同的特点也有个自己的特点。Dataset的实现在`flink-java`module中，而DataStream的实现在`flink-streaming-java`中。

* DataSet： 批式处理，其接口封装类似于Spark的Dataset，支持丰富的函数操作，比如map/fliter/join/cogroup等
  * 数据源创建初始数据集，例如来自文件或Java集合等静态数据；
  * 所有的操作为Operator的子类，实现具体逻辑，比如Join逻辑是在JoinOperator中实现；
* DataStram: 流式处理，其结构封装实现输入流的处理，其也实现了丰富的函数支持
  * 所有的操作为StreamOperator的子类，实现具体逻辑，比如Join逻辑是在`IntervalJoinOperator`中实现的



