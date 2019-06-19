title: JVM的内存结构
date: 2016-01-16 19:58:11
tags:
    - Java
    - jvm
categories: Java
---
Jvm内存主要分为6部分：分别是程序计数器、虚拟机栈、本地方法栈、堆、方法区和直接内存。
# 程序计数器
  线程私有，即每个线程都会有一个，线程之间互补影响，独立存储，代表着当前线程所执行的字节码的指示器
  
# 虚拟机栈
  线程私有，它的生命周期和线程相同。描述的是Java方法执行的内存模型，每一个方法在执行的同时会创建一
  个栈帧用户存储局部变量表，操作数栈，冬天链接表，方法出口等信息。每个方法从调用直指完成的过程，对
  应着一个栈帧在虚拟机中入栈到出栈的过程。局部变量表存放了编译器可知的各种基本数据类型和对象引用，
  所需的内存空间在编译期就是确定的。
  -Xss参数设置栈容量，例如-Xss128k。当栈的空间不足时，会抛出StackOverflowError的错误

# 本地方法栈
  JVM采用本地址方法堆栈来支持native方法，此区域用于存储每个native方法调用的状态

# 堆
  堆是对于JavaCoder来说最为熟悉的，它是线程共享的，主要用于分配对象实例和数组，堆中的对象需要等待
  gc进行回事，32位系统上最大为2g，64位系统上没有现在。其大小可以通过-Xms和-Xmx来控制。
  若-Xms=-Xmx则可以避免自动扩展，一定程度上会提升性能
  -XX:+HeapDumpOnOutOfMemoryError可以让虚拟机在出现内存溢出是dump出当前的内存堆转储快照
  所以一般会配置如下形式的参数:-Xms200m -Xmx200m -XX:+HeapDumpOnOutOfMemoryError
  对于分代的GC来说堆也是分单的。当然现在gc的算法基本都已经采用分带收集算法，因此该区也经常分为
  YoungGeneration(Eden/FromSpace Survivor1/ToSpace Survivor2) 和old/TenuredGeneration等区域
## 堆内存的配置
  -XX:NewRatio	:年轻代(包括Eden和两个Survivor区)与年老代的比值(除去持久代)
		-XX:NewRatio=4表示年轻代与年老代所占比值为1:4,
		年轻代占整个堆栈的1/5Xms=Xmx并且设置了Xmn的情况下，该参数不需要进行设置。
  -XX:SurvivorRatio:Eden区与Survivor区的大小比值
		  :设置为8,则两个Survivor区与一个Eden区的比值为2:8,一个Survivor区占整个年轻代的1/10
  对象在几个区交换的规则(根据GC的不同有不同的变化)：
  > 新建或者短期的对象存放在Eden区域
  > GC后幸存的对象或中期的对象将会从Eden区拷贝到Surivior区
  > 始终存在或长期存在的对象将会从Surivior区中拷贝到Old Generation
  
# 方法区  
  存储已被虚拟机加载的类信息、常量、静态变量、即使编译后的代码等数据。也就是所称的Permanent Generation
  当该区域内存不足(GC不能及时回事或内存使用达到98%)就会抛出java.lang.OutOfMemoryError: PermGen space
  运行时常量池(Runtime Constant Pool)是方法区的一部分。可以通过如下参数控制其大小
  -XX:MaxPermSize设置上限
  -XX:PermSize设置最小值 例：VM Args:-XX:PermSize=10M -XX:MaxPermSize=10M
  
  Class文件中除了有类的版本、字段、方法、接口等信息外，还有一项是常量池（Constant Pool Table）,用于存
  放编译期生成的各种字面量和符号引用，这部分内容将在类加载后进入方法区的运行时常量池中存放。运行时常
  量池相对于Class文件常量池的一个重要特征是具备动态性：即除了Class文件中常量池的内容能被放到运行时常
  量池外，运行期间也可能将新的常量放入池中，比如String类的intern（）方法。

# 直接内存
  直接内存并不是虚拟机运行时数据区的一部分，新版JDK引入了一种基于通道和缓冲区的I/O方式，
  它可以使用native函数直接分配堆外内存，然后通过一个存储在java堆中的DirectByteBuffer对象作为这块内
  存的引用进行操作。
  -XX:MaxDirectMemorySize设置最大值，默认与java堆最大值一样。
  例：-XX:MaxDirectMemorySize=10M -Xmx20M



