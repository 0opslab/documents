# title{java - java相关的那些操作}


## 安装
```bash
cat >>/etc/profile<<EOF
export JAVA_HOME=/usr/local/java/jdk1.8.0_171
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH
EOF

source /etc/profile
ln -s /usr/local/java/jdk1.8.0_171/bin/java /usr/bin/java
java -version
```


## java常用命令

### jps 

```bash
#主要用来输出JVM进程状态信息
–m 输出传入main方法的参数
–l 输出main类或Jar的全限名
–v 输出传入JVM的参数
```

### jmap
```bash
jmap命令主要用于打印指定Java进程的共享对象内存映射或堆内存细节，jmap命令可以获得运行中的jvm的堆的快照，
从而可以离线分析堆，以检查内存泄漏，检查一些严重影响性能的大对象的创建，检查系统中什么对象最多，各种对象
所占内存的大小等等。
–heap pid 查看堆栈分布
–histo pid 按照使用使用大小逆序排列的
–dump dump堆栈


# 以hprof二进制格式将Java堆信息输出到文件内，该文件可以用MAT、VisualVM或jhat等工具查看
# 输出到文件，注意此时会暂停应用
jmap -dump:live,format=b,file=heapDump 23766

# 查看占用内存最多的最象，并按降序排序输出：
jmap -histo <pid>|grep alibaba|sort -k 3 -g -r|less

#查看对象数最多的对象，并按降序排序输出：
jmap -histo <pid>|grep alibaba|sort -k 2 -g -r|less
```

### jstack
jstack能得到运行java程序的java stack和native stack的信息。
jstack可以定位到线程堆栈，根据堆栈信息我们可以定位到具体代码，所以它在JVM性能调优中使用得非常多。

命令格式
```bash
jstack [option] pid
jstack [option] executable core
jstack [option] [server-id@]remote-hostname-or-ip

jstack 27676| grep Druid-ConnectionPool- | wc -l
jstack 27676| grep Xmemcached-Reactor-
jstack 27676| grep java.lang.Thread.State
jstack 27676| grep DubboServerHandler-
jstack 27676| grep DubboClientHandler-
```


### jstat
JVM统计监测工具,通过该工具可以实时了解当前进程的gc，compiler，class，memory等相关的情况，具体我们可以通过
jstat -options来看我们到底支持哪些类型的数据，常用的如下选项：
-class:监视类装载、卸载数量、总空间及类装载所耗费的时间
-gc:监听Java堆状况，包括Eden区、两个Survivor区、老年代、永久代等的容量，以用空间、GC时间合计等信息
-gccapacity:监视内容与-gc基本相同，但输出主要关注java堆各个区域使用到的最大和最小空间
-gcutil:监视内容与-gc基本相同，但输出主要关注已使用空间占总空间的百分比
-gccause:与-gcutil功能一样，但是会额外输出导致上一次GC产生的原因
-gcnew:监视新生代GC状况
-gcnewcapacity:监视内同与-gcnew基本相同，输出主要关注使用到的最大和最小空间
-gcold:监视老年代GC情况
-gcoldcapacity:监视内同与-gcold基本相同，输出主要关注使用到的最大和最小空间
-gcpermcapacity:输出永久代使用到最大和最小空间
-compiler:输出JIT编译器编译过的方法、耗时等信息
-printcompilation:输出已经被JIT编译的方法

```bash
# 命令格式
jstat [ generalOption | outputOptions vmid [interval[s|ms] [count]] ]


```


### jinfo
用于查询当前运行这的JVM属性和参数的值。
-flag:显示未被显示指定的参数的系统默认值
-flag [+|-]name或-flag name=value: 修改部分参数
-sysprops:打印虚拟机进程的System.getProperties()

### jhat
用于分析使用jmap生成的dump文件，是JDK自带的工具，使用方法为： jhat -J -Xmx512m [file]

## jvm参数
标准参数（-），所有的JVM实现都必须实现这些参数的功能，而且向后兼容；
非标准参数（-X），默认jvm实现这些参数的功能，但是并不保证所有jvm实现都满足，且不保证向后兼容；
非Stable参数（-XX），此类参数各个jvm实现会有所不同，将来可能会随时取消，需要慎重使用（但是，这些参数往往是非常有用的）；

-client
设置jvm使用client模式，这是一般在pc机器上使用的模式，启动很快，但性能和内存管理效率并不高；多用于桌面应用；

-server
使用server模式，启动速度虽然慢（比client模式慢10%左右），但是性能和内存管理效率很高，适用于服务器，用于生成环境、开发环境或测试环境的服务端；
如果没有指定-server或-client，JVM启动的时候会自动检测当前主机是否为服务器，如果是就以server模式启动，64位的JVM只有server模式，所以无法使用-client参数；
默认情况下，不同的启动模式，执行GC的方式有所区别：

-DpropertyName=value
定义系统的全局属性值，如配置文件地址等，如果value有空格，可以用-Dname="space string"这样的形式来定义，用System.getProperty("propertyName")可以获得这些定义的属性值，在代码中也可以用System.setProperty("propertyName","value")的形式来定义属性。
-verbose 
这是查询GC问题最常用的命令之一，具体参数如：
-verbose:class
 输出jvm载入类的相关信息，当jvm报告说找不到类或者类冲突时可此进行诊断。
-verbose:gc
 输出每次GC的相关情况，后面会有更详细的介绍。
-verbose:jni
 输出native方法调用的相关情况，一般用于诊断jni调用错误信息。

 -Xmn
新生代内存大小的最大值，包括E区和两个S区的总和，使用方法如：-Xmn65535，-Xmn1024k，-Xmn512m，-Xmn1g (-Xms,-Xmx也是种写法)
-Xmn只能使用在JDK1.4或之后的版本中，（之前的1.3/1.4版本中，可使用-XX:NewSize设置年轻代大小，用-XX:MaxNewSize设置年轻代最大值）；
如果同时设置了-Xmn和-XX:NewSize，-XX:MaxNewSize，则谁设置在后面，谁就生效；如果同时设置了-XX:NewSize -XX:MaxNewSize与-XX:NewRatio则实际生效的值是：min(MaxNewSize,max(NewSize, heap/(NewRatio+1)))（看考：http://www.open-open.com/home/space.php?uid=71669&do=blog&id=8891）
在开发、测试环境，可以-XX:NewSize 和 -XX:MaxNewSize来设置新生代大小，但在线上生产环境，使用-Xmn一个即可（推荐），或者将-XX:NewSize 和 -XX:MaxNewSize设置为同一个值，这样能够防止在每次GC之后都要调整堆的大小（即：抖动，抖动会严重影响性能）

 -Xms
初始堆的大小，也是堆大小的最小值，默认值是总共的物理内存/64（且小于1G），默认情况下，当堆中可用内存小于40%(这个值可以用-XX: MinHeapFreeRatio 调整，如-X:MinHeapFreeRatio=30)时，堆内存会开始增加，一直增加到-Xmx的大小；

 -Xmx
堆的最大值，默认值是总共的物理内存/64（且小于1G），如果Xms和Xmx都不设置，则两者大小会相同，默认情况下，当堆中可用内存大于70%（这个值可以用-XX: MaxHeapFreeRatio 调整，如-X:MaxHeapFreeRatio=60）时，堆内存会开始减少，一直减小到-Xms的大小；
整个堆的大小=年轻代大小+年老代大小，堆的大小不包含持久代大小，如果增大了年轻代，年老代相应就会减小，官方默认的配置为年老代大小/年轻代大小=2/1左右（使用-XX:NewRatio可以设置-XX:NewRatio=5，表示年老代/年轻代=5/1）；
建议在开发测试环境可以用Xms和Xmx分别设置最小值最大值，但是在线上生产环境，Xms和Xmx设置的值必须一样，原因与年轻代一样——防止抖动；

 -Xss
这个参数用于设置每个线程的栈内存，默认1M，一般来说是不需要改的。除非代码不多，可以设置的小点，另外一个相似的参数是-XX:ThreadStackSize，这两个参数在1.6以前，都是谁设置在后面，谁就生效；1.6版本以后，-Xss设置在后面，则以-Xss为准，-XXThreadStackSize设置在后面，则主线程以-Xss为准，其它线程以-XX:ThreadStackSize为准。

 -Xrs
减少JVM对操作系统信号（OS Signals）的使用（JDK1.3.1之后才有效），当此参数被设置之后，jvm将不接收控制台的控制handler，以防止与在后台以服务形式运行的JVM冲突（这个用的比较少，参考：http://www.blogjava.net/midstr/archive/2008/09/21/230265.html）。

-Xprof
 跟踪正运行的程序，并将跟踪数据在标准输出输出；适合于开发环境调试。

-Xnoclassgc
 关闭针对class的gc功能；因为其阻止内存回收，所以可能会导致OutOfMemoryError错误，慎用；

-Xincgc
 开启增量gc（默认为关闭）；这有助于减少长时间GC时应用程序出现的停顿；但由于可能和应用程序并发执行，所以会降低CPU对应用的处理能力。

-Xloggc:file
 与-verbose:gc功能类似，只是将每次GC事件的相关情况记录到一个文件中，文件的位置最好在本地，以避免网络的潜在问题。
 若与verbose命令同时出现在命令行中，则以-Xloggc为准。

非Stable参数（非静态参数）
以-XX表示的非Stable参数，虽然在官方文档中是不确定的，不健壮的，各个公司的实现也各有不同，但往往非常实用，所以这部分参数对于GC非常重要。JVM（Hotspot）中主要的参数可以大致分为3类（参考http://blog.csdn.net/sfdev/article/details/2063928）：

性能参数（ Performance Options）：用于JVM的性能调优和内存分配控制，如初始化内存大小的设置；
行为参数（Behavioral Options）：用于改变JVM的基础行为，如GC的方式和算法的选择；
调试参数（Debugging Options）：用于监控、打印、输出等jvm参数，用于显示jvm更加详细的信息；
比较详细的非Stable参数总结，请参考Java 6 JVM参数选项大全（中文版），
对于非Stable参数，使用方法有4种：

-XX:+<option> 启用选项
-XX:-<option> 不启用选项
-XX:<option>=<number> 给选项设置一个数字类型值，可跟单位，例如 32k, 1024m, 2g
-XX:<option>=<string> 给选项设置一个字符串值，例如-XX:HeapDumpPath=./dump.core
首先介绍性能参数，性能参数往往用来定义内存分配的大小和比例，相比于行为参数和调试参数，一个比较明显的区别是性能参数后面往往跟的有数值，常用如下：

参数及其默认值	描述
-XX:NewSize=2.125m
新生代对象生成时占用内存的默认值
-XX:MaxNewSize=size	新生成对象能占用内存的最大值
-XX:MaxPermSize=64m	方法区所能占用的最大内存（非堆内存）
-XX:PermSize=64m	方法区分配的初始内存
-XX:MaxTenuringThreshold=15
对象在新生代存活区切换的次数（坚持过MinorGC的次数，每坚持过一次，该值就增加1），大于该值会进入老年代
-XX:MaxHeapFreeRatio=70
GC后java堆中空闲量占的最大比例，大于该值，则堆内存会减少
-XX:MinHeapFreeRatio=40	GC后java堆中空闲量占的最小比例，小于该值，则堆内存会增加
-XX:NewRatio=2	新生代内存容量与老生代内存容量的比例
-XX:ReservedCodeCacheSize= 32m	保留代码占用的内存容量
-XX:ThreadStackSize=512	设置线程栈大小，若为0则使用系统默认值
-XX:LargePageSizeInBytes=4m	
设置用于Java堆的大页面尺寸
-XX:PretenureSizeThreshold= size   	大于该值的对象直接晋升入老年代（这种对象少用为好）
-XX:SurvivorRatio=8	Eden区域Survivor区的容量比值，如默认值为8，代表Eden：Survivor1：Survivor2=8:1:1
常用的行为参数，主要用来选择使用什么样的垃圾收集器组合，以及控制运行过程中的GC策略等：

参数及其默认值	描述
-XX:-UseSerialGC
启用串行GC，即采用Serial+Serial Old模式
-XX:-UseParallelGC
启用并行GC，即采用Parallel Scavenge+Serial Old收集器组合（-Server模式下的默认组合）
-XX:GCTimeRatio=99	设置用户执行时间占总时间的比例（默认值99，即1%的时间用于GC）
-XX:MaxGCPauseMillis=time	设置GC的最大停顿时间（这个参数只对Parallel Scavenge有效）
-XX:+UseParNewGC	使用ParNew+Serial Old收集器组合
-XX:ParallelGCThreads	设置执行内存回收的线程数，在+UseParNewGC的情况下使用
-XX:+UseParallelOldGC
使用Parallel Scavenge +Parallel Old组合收集器
-XX:+UseConcMarkSweepGC	使用ParNew+CMS+Serial Old组合并发收集，优先使用ParNew+CMS，当用户线程内存不足时，采用备用方案Serial Old收集。
-XX:-DisableExplicitGC	禁止调用System.gc()；但jvm的gc仍然有效
-XX:+ScavengeBeforeFullGC	新生代GC优先于Full GC执行
常用的调试参数，主要用于监控和打印GC的信息：

参数及其默认值	描述
-XX:-CITime	打印消耗在JIT编译的时间
-XX:ErrorFile=./hs_err_pid<pid>.log	保存错误日志或者数据到文件中
-XX:-ExtendedDTraceProbes	开启solaris特有的dtrace探针
-XX:HeapDumpPath=./java_pid<pid>.hprof	指定导出堆信息时的路径或文件名
-XX:-HeapDumpOnOutOfMemoryError	当首次遭遇OOM时导出此时堆中相关信息
-XX:OnError="<cmd args>;<cmd args>"	出现致命ERROR之后运行自定义命令
-XX:OnOutOfMemoryError="<cmd args>;<cmd args>"	当首次遭遇OOM时执行自定义命令
-XX:-PrintClassHistogram	遇到Ctrl-Break后打印类实例的柱状信息，与jmap -histo功能相同
-XX:-PrintConcurrentLocks	遇到Ctrl-Break后打印并发锁的相关信息，与jstack -l功能相同
-XX:-PrintCommandLineFlags	打印在命令行中出现过的标记
-XX:-PrintCompilation	当一个方法被编译时打印相关信息
-XX:-PrintGC	每次GC时打印相关信息
-XX:-PrintGC Details	每次GC时打印详细信息
-XX:-PrintGCTimeStamps	打印每次GC的时间戳
-XX:-TraceClassLoading	跟踪类的加载信息
-XX:-TraceClassLoadingPreorder	跟踪被引用到的所有类的加载信息
-XX:-TraceClassResolution	跟踪常量池
-XX:-TraceClassUnloading	跟踪类的卸载信息
-XX:-TraceLoaderConstraints	跟踪类加载器约束的相关信息