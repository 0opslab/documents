---
title: Java8之Stream编程
date: 2018-06-23 20:45:56
tags: Java
---
Java 8 中的 Stream 是对集合（Collection）对象功能的增强，它专注于对集合对象进行各种非常便利、高效的聚合操作（aggregate operation），或者大批量数据操作 (bulk data operation)。Stream API 借助于同样新出现的 Lambda 表达式，极大的提高编程效率和程序可读性。同时它提供串行和并行两种模式进行汇聚操作，并发模式能够充分利用多核处理器的优势，使用 fork/join 并行方式来拆分任务和加速处理过程。通常编写并行代码很难而且容易出错, 但使用 Stream API 无需编写一行多线程的代码，就可以很方便地写出高性能的并发程序。所以说，Java 8 中首次出现的 java.util.stream 是一个函数式语言+多核时代综合影响的产物。


### 聚合操作
在传统的 J2EE 应用中，Java 代码经常不得不依赖于关系型数据库的聚合操作来完成诸如:客户每月平均消费金额、最昂贵的在售商品、本周完成的有效订单（排除了无效的）、取十个数据样本作为首页推荐，这类的操作在传统的Java中除了依赖于数据库外，更多的时候是程序员需要用 Iterator 来遍历集合，完成相关的聚合应用逻辑。这是一种远不够高效、笨拙的方法。在 Java 7 中，如果要发现 type 为 grocery 的所有交易，然后返回以交易值降序排序好的交易 ID 集合，的实现比较：
```java
//Java 7 的排序、取值实现
List<Transaction> groceryTransactions = new Arraylist<>();
for(Transaction t: transactions){
 if(t.getType() == Transaction.GROCERY){
 groceryTransactions.add(t);
 }
}
Collections.sort(groceryTransactions, new Comparator(){
 public int compare(Transaction t1, Transaction t2){
 return t2.getValue().compareTo(t1.getValue());
 }
});
List<Integer> transactionIds = new ArrayList<>();
for(Transaction t: groceryTransactions){
 transactionsIds.add(t.getId());
}

//Java8中stream实现的排序、取值实现
List<Integer> transactionsIds = transactions.parallelStream().
 filter(t -> t.getType() == Transaction.GROCERY).
 sorted(comparing(Transaction::getValue).reversed()).
 map(Transaction::getId).
 collect(toList());
```

### Stream
Stream 不是集合元素，它不是数据结构并不保存数据，它是有关算法和计算的，它更像一个高级版本的 Iterator。原始版本的 Iterator，用户只能显式地一个一个遍历元素并对其执行某些操作；高级版本的 Stream，用户只要给出需要对其包含的元素执行什么操作，比如 “过滤掉长度大于 10 的字符串”、“获取每个字符串的首字母”等，Stream 会隐式地在内部进行遍历，做出相应的数据转换。

Stream 就如同一个迭代器（Iterator），单向，不可往复，数据只能遍历一次，遍历过一次后即用尽了，就好比流水从面前流过，一去不复返。

而和迭代器又不同的是，Stream 可以并行化操作，迭代器只能命令式地、串行化操作。顾名思义，当使用串行方式去遍历时，每个 item 读完后再读下一个 item。而使用并行去遍历时，数据会被分成多个段，其中每一个都在不同的线程中处理，然后将结果一起输出。

Stream 的另外一大特点是，数据源本身可以是无限的。

#### stream的操作
当我们使用一个流的时候，通常包括三个基本步骤：

获取一个数据源（source）→ 数据转换→执行操作获取想要的结果，每次转换原有 Stream 对象不改变，返回一个新的 Stream 对象（可以有多次转换），这就允许对其操作可以像链条一样排列，变成一个管道。
##### 生成stream的多种方式
*  Collection 和数组
  - Collection.stream()
  - Collection.parallelStream()
  - Arrays.stream(T array) or Stream.of()
*  BufferedReader
  - java.io.BufferedReader.lines()
*  静态工厂
*  java.util.stream.IntStream.range()
*  java.nio.file.Files.walk()
*  主动构造
*  java.util.Spliterator
*  Random.ints()
*  BitSet.stream()
*  Pattern.splitAsStream(java.lang.CharSequence)
*  JarFile.stream()
  下面是一些常见的stream的构造与转换的实例,(注意只是代码片段)
```java
package stream;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;


/**
 * stream的构造与转换
 */
public class Stream01 {
    public static void main(String[] args) {
        //构造Stream
        // 1. Individual values
        Stream stream = Stream.of("a", "b", "c");
        // 2. Arrays
        String[] strArray = new String[]{"a", "b", "c"};
        stream = Stream.of(strArray);
        stream = Arrays.stream(strArray);
        // 3. Collections
        List<String> list = Arrays.asList(strArray);
        stream = list.stream();

        //数值流的构造
        //IntStream、LongStream、DoubleStream  JDK主动集成了
        IntStream.of(new int[]{1, 2, 3}).forEach(System.out::println);
        IntStream.range(1, 3).forEach(System.out::println);
        IntStream.rangeClosed(1, 3).forEach(System.out::println);

        //流转换为其它数据结构
        // 1. Array
        String[] strArray1 = stream.toArray(String[]::new);
        // 2. Collection
        List<String> list1 = stream.collect(Collectors.toList());
        List<String> list2 = stream.collect(Collectors.toCollection(ArrayList::new));
        Set set1 = stream.collect(Collectors.toSet());
        Stack stack1 = stream.collect(Collectors.toCollection(Stack::new));
        // 3. String
        String str = stream.collect(Collectors.joining()).toString();

    }
}
```


##### 流的操作类型
* Intermediate
  一个流可以后面跟随零个或多个 intermediate 操作。其目的主要是打开流，做出某种程度的数据映射/过滤，然后返回一个新的流，交给下一个操作使用。这类操作都是惰性化的（lazy），就是说，仅仅调用到这类方法，并没有真正开始流的遍历。常见的intermediate操作有：map (mapToInt, flatMap 等)、 filter、 distinct、 sorted、 peek、 limit、 skip、 parallel、 sequential、 unordered
* Terminal
  一个流只能有一个 terminal 操作，当这个操作执行后，流就被使用“光”了，无法再被操作。所以这必定是流的最后一个操作。Terminal 操作的执行，才会真正开始流的遍历，并且会生成一个结果，或者一个 side effect。常见的Terminal操作有：forEach、 forEachOrdered、 toArray、 reduce、 collect、 min、 max、 count、 anyMatch、 allMatch、 noneMatch、 findFirst、 findAny、 iterator
* short-circuiting
  用以指：对于一个 intermediate 操作，如果它接受的是一个无限大（infinite/unbounded）的 Stream，但返回一个有限的新 Stream。对于一个 terminal 操作，如果它接受的是一个无限大的 Stream，但能在有限的时间计算出结果。常见的操作有：anyMatch、 allMatch、 noneMatch、 findFirst、 findAny、 limit

###### map/flatMap
map它的作用就是把 input Stream 的每一个元素，映射成 output Stream 的另外一个元素。map 生成的是个 1:1 映射，每个输入元素，都按照规则转换成为另外一个元素。还有一些场景，是一对多映射关系的，这时需要 flatMap。
```java
package stream;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class StreamMap {
    public static void main(String[] args) {
        //将数组中所有元素全部转换为大写，并以List形式返回
        Stream<String> stringStream = Stream.of(new String[]{"a", "b", "c", "d"});
        List<String> stringList = stringStream.map(String::toUpperCase)
                .collect(Collectors.toList());

        //生成一个整数 list 的平方数 {1, 4, 9, 16}
        List<Integer> nums = Arrays.asList(1, 2, 3, 4);
        List<Integer> squareNums = nums.stream().
                map(n -> n * n).
                collect(Collectors.toList());


        Stream.of(
                Arrays.asList(1),
                Arrays.asList(2, 3),
                Arrays.asList(4, 5, 6)
        ).forEach(System.out::println);

        Stream<List<Integer>> inputStream = Stream.of(
                Arrays.asList(1),
                Arrays.asList(2, 3),
                Arrays.asList(4, 5, 6)
        );
        Stream<Integer> outputStream = inputStream.
                flatMap((childList) -> childList.stream());
        outputStream.forEach(System.out::println);
    }
}
```

###### filter

filter 对原始 Stream 进行某项测试，通过测试的元素被留下来生成一个新 Stream。
```java
public class StreamFilter {
    public static void main(String[] args) {
        Integer[] sixNums = {1, 2, 3, 4, 5, 6};
        Integer[] evens =
                Stream.of(sixNums).filter(n -> n%2 == 0).toArray(Integer[]::new);

        List<String> output = reader.lines().
                flatMap(line -> Stream.of(line.split(REGEXP))).
                filter(word -> word.length() > 0).
                collect(Collectors.toList());
    }
}




```

###### forEach

forEach 方法接收一个 Lambda 表达式，然后在 Stream 的每一个元素上执行该表达式。
另外一点需要注意，forEach 是 terminal 操作，因此它执行后，Stream 的元素就被“消费”掉了，你无法对一个 Stream 进行两次 terminal 运算。相反，具有相似功能的 intermediate 操作 peek 可以达到上述目的。forEach 不能修改自己包含的本地变量值，也不能用 break/return 之类的关键字提前结束循环。

```java
    public static void main(String[] args) {

        //使用foreach
        Stream.of("one", "two", "three", "four")
                .forEach(System.out::println);


        //使用peek
        Stream.of("one", "two", "three", "four")
                .filter(e -> e.length() > 3)
                .peek(e -> System.out.println("Filtered value: " + e))
                .map(String::toUpperCase)
                .peek(e -> System.out.println("Mapped value: " + e))
                .collect(Collectors.toList());
    }
```

######  findFirst

findFirst是一个 termimal 兼 short-circuiting 操作，它总是返回 Stream 的第一个元素，或者空。它的返回值类型是Optional。这也是一个模仿 Scala 语言中的概念，作为一个容器，它可能含有某值，或者不包含。使用它的目的是尽可能避免 NullPointerException。另外Stream 中的 findAny、max/min、reduce 等方法等返回 Optional 值。还有例如 IntStream.average() 返回 OptionalDouble 等等。
```java
String strA = " abcd ", strB = null;
print(strA);
print("");
print(strB);
getLength(strA);
getLength("");
getLength(strB);
public static void print(String text) {
 // Java 8
 Optional.ofNullable(text).ifPresent(System.out::println);
 // Pre-Java 8
 if (text != null) {
 System.out.println(text);
 }
 }
public static int getLength(String text) {
 // Java 8
return Optional.ofNullable(text).map(String::length).orElse(-1);
 // Pre-Java 8
// return if (text != null) ? text.length() : -1;
 };
```

###### reduce

这个方法的主要作用是把 Stream 元素组合起来。它提供一个起始值（种子），然后依照运算规则（BinaryOperator），和前面 Stream 的第一个、第二个、第 n 个元素组合。从这个意义上说，字符串拼接、数值的 sum、min、max、average 都是特殊的 reduce。也有没有起始值的情况，这时会把 Stream 的前面两个元素组合起来，返回的是 Optional。
下面是reduce的一些使用实例
```java
    public static void main(String[] args) {
        //字符串连接 结果为"ABCD"
        String concatStr = Stream.of("A", "B", "C", "D").reduce("", String::concat);

        //求最小值 结果为-3.0
        Double minValue = Stream.of(-1.5, 1.0, -3.0, -2.0).reduce(Double.MAX_VALUE, Double::min);

        // 求和,有起始值 结果为10
        // 第一个参数（空白字符）即为起始值，第二个参数（String::concat）为 BinaryOperator。
        // 这类有起始值的 reduce() 都返回具体的对象
        int sumValue = Stream.of(1, 2, 3, 4).reduce(0, Integer::sum);

        // @注意
        // 求和，sumValue = 10, 无起始值
        //没有起始值的 reduce()，由于可能没有足够的元素，返回的是 Optional
        sumValue = Stream.of(1, 2, 3, 4).reduce(Integer::sum).get();
        // 过滤，字符串连接，结果为"ace"
        concatStr = Stream.of("a", "B", "c", "D", "e", "F").
                filter(x -> x.compareTo("Z") > 0).
                reduce("", String::concat);
    }
```

###### limit/skip

limit 返回 Stream 的前面 n 个元素；skip 则是扔掉前 n 个元素（它是由一个叫 subStream 的方法改名而来）。
```java
package stream;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class StreamLimit {
    private static class Person {
        public int no;
        private String name;
        public Person (int no, String name) {
            this.no = no;
            this.name = name;
        }
        public String getName() {
            System.out.println(name);
            return name;
        }
    }
    public static void main(String[] args) {
        List<Person> persons = new ArrayList();
        for (int i = 1; i <= 10000; i++) {
            Person person = new Person(i, "name" + i);
            persons.add(person);
        }
        List<String> personList2 = persons.stream().
                map(Person::getName).
                limit(5).
                skip(3)
                .collect(Collectors.toList());

        System.out.println(personList2);
    }


}

```

###### sorted/min/max/distinct

对 Stream 的排序通过 sorted 进行，它比数组的排序更强之处在于你可以首先对 Stream 进行各类 map、filter、limit、skip 甚至 distinct 来减少元素数量后，再排序，这能帮助程序明显缩短执行时间。
```java
package stream;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class StreamSorted {
    private static class Person {
        public int no;
        private String name;
        public Person (int no, String name) {
            this.no = no;
            this.name = name;
        }
        public String getName() {
            System.out.println(name);
            return name;
        }
    }
    public static void main(String[] args) {
        List<Person> persons = new ArrayList();
        for (int i = 1; i <= 10000; i++) {
            Person person = new Person(i, "name" + i);
            persons.add(person);
        }

        //先过滤数据最后在排序
        List<Person> personList2 = persons.stream().limit(5)
                .skip(3)
                .sorted((p1, p2) -> p1.getName().compareTo(p2.getName()))
                .collect(Collectors.toList());

        System.out.println(personList2);

        // 找出最大的行
        BufferedReader br = new BufferedReader(new FileReader("c:\\SUService.log"));
        int longest = br.lines().
                mapToInt(String::length).
                max().
                getAsInt();
    }
}

```

###### Match

Stream 有三个 match 方法，从语义上说
 - allMatch：Stream 中全部元素符合传入的 predicate，返回 true
 - anyMatch：Stream 中只要有一个元素符合传入的 predicate，返回 true
 - noneMatch：Stream 中没有一个元素符合传入的 predicate，返回 true

```java
List<Person> persons = new ArrayList();
persons.add(new Person(1, "name" + 1, 10));
persons.add(new Person(2, "name" + 2, 21));
persons.add(new Person(3, "name" + 3, 34));
persons.add(new Person(4, "name" + 4, 6));
persons.add(new Person(5, "name" + 5, 55));
boolean isAllAdult = persons.stream().
 allMatch(p -> p.getAge() > 18);
System.out.println("All are adult? " + isAllAdult);
boolean isThereAnyChild = persons.stream().
 anyMatch(p -> p.getAge() < 12);
System.out.println("Any child? " + isThereAnyChild);
```

#### Stream.generate
通过实现 Supplier 接口，你可以自己来控制流的生成。这种情形通常用于随机数、常量的 Stream，或者需要前后元素间维持着某种状态信息的 Stream。把 Supplier 实例传递给 Stream.generate() 生成的 Stream，默认是串行（相对 parallel 而言）但无序的（相对 ordered 而言）。由于它是无限的，在管道中，必须利用 limit 之类的操作限制 Stream 大小。
```java
Random seed = new Random();
Supplier<Integer> random = seed::nextInt;
Stream.generate(random).limit(10).forEach(System.out::println);
//Another way
IntStream.generate(() -> (int) (System.nanoTime() % 100)).
limit(10).forEach(System.out::println);
```
Stream.generate() 还接受自己实现的 Supplier。例如在构造海量测试数据的时候，用某种自动的规则给每一个变量赋值；或者依据公式计算 Stream 的每个元素值。这些都是维持状态信息的情形。
```java
//自实现 Supplier
Stream.generate(new PersonSupplier()).
limit(10).
forEach(p -> System.out.println(p.getName() + ", " + p.getAge()));
private class PersonSupplier implements Supplier<Person> {
 private int index = 0;
 private Random random = new Random();
 @Override
 public Person get() {
 return new Person(index++, "StormTestUser" + index, random.nextInt(100));
 }
}
```

#### Stream.iterate
iterate 跟 reduce 操作很像，接受一个种子值，和一个 UnaryOperator（例如 f）。然后种子值成为 Stream 的第一个元素，f(seed) 为第二个，f(f(seed)) 第三个，以此类推。
```java
//生成一个等差数列
Stream.iterate(0, n -> n + 3).limit(10). forEach(x -> System.out.print(x + " "));.
```



#### stream的并发执行
一个顺序执行的stream转变成一个并发的stream只要调用 parallel()方法。将一个并发流转成顺序的流只要调用sequential()方法。并行流就是一个把内容分成多个数据块，并用不不同的线程分别处理每个数据块的流。最后合并每个数据块的计算结果。
```java
//用简单的程序验证是否是线程安全的
package stream;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.stream.IntStream;

public class StreamParallel {
    public static void main(String[] args) {
        List<Integer> list1 = new ArrayList<>();
        List<Integer> list2 = new ArrayList<>();
        List<Integer> list3 = new ArrayList<>();
        Lock lock = new ReentrantLock();

        IntStream.range(0, 10000).forEach(list1::add);

        IntStream.range(0, 10000).parallel().forEach(list2::add);

        IntStream.range(0, 10000).forEach(i -> {
            lock.lock();
            try {
                list3.add(i);
            } finally {
                lock.unlock();
            }
        });

        System.out.println("串行执行的大小-大小始终10000：" + list1.size());
        System.out.println("并行执行的大小-大小不一定：" + list2.size());
        System.out.println("加锁并行执行的大小-大小始终10000：" + list3.size());
    }
}
```


##### 收集器
将Stream转换为常见的集合对象或者自定义的对象是经常需要的操作。下面是常见的转换方式
```java
package stream;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class StreamCollect01 {
    //将Stream转换为常见的集合对象
    public static void main(String[] args) {
        Stream<String> stream = Stream.of("I", "love", "you", "too");
        //将Stream转换为List
        List<String> list = stream.collect(Collectors.toList());
        list.forEach(System.out::println);

        //将Stream转换为Set
        Stream<String> stream1 = Stream.of("I", "love", "you", "too");
        Set<String> set = stream1.collect(Collectors.toSet());
        set.forEach(System.out::println);

        //将Stream转换为Map
        Stream<String> stream2 = Stream.of("I", "love", "you", "too");
        Map<String, Integer> map = stream2.collect(Collectors.toMap(Function.identity(), String::length));
        map.forEach((k, v) -> System.out.println(k + "=" + v));
    }
}
```
观察Stream的定义可以看到俩个版本的collect的方法，分别如下:
```java
//Supplier<R> var1函数接口，该接口声明了一个get方法，主要用来创建返回一个指定数据类型的对象
//BiConsumer 函数接口，该接口声明了accept方法，并无返回值，该函数接口主要用来声明一些预期操作。
//BiConsumer 该接口指定了apply方法执行的参数类型及返回值类
//简单的理解为 目标容器是什么？新元素如何添加到容器中？3. 多个部分结果如何合并成一个。
 <R> R collect(Supplier<R> var1, BiConsumer<R, ? super T> var2, BiConsumer<R, R> var3);
// 可以理解为对上述借口的以一个封装
<R, A> R collect(Collector<? super T, A, R> var1);
```
查阅Collector的定义如下，你会发现其和多参数的Stream.collect函数很相似
```java
public interface Collector<T, A, R> {
	//用来创建并且返回一个可变结果容器
    Supplier<A> supplier();
    //将一个值叠进一个可变结果容器
    BiConsumer<A, T> accumulator();
    //接受两个部分结果并将它们合并。可能是把一个参数叠进另一个参数并且返回另一个参数，
    //也有可能返回一个新的结果容器，多线程处理时会用到
    BinaryOperator<A> combiner();
    //将中间类型执行最终的转换，转换成最终结果类型
    //如果属性 IDENTITY_TRANSFORM 被设置，该方法会假定中间结果类型可以强制转成最终结果类型
    Function<A, R> finisher();
    //收集器的属性集合
    Set<Collector.Characteristics> characteristics();

    static <T, R> Collector<T, R, R> of(Supplier<R> var0, BiConsumer<R, T> var1, BinaryOperator<R> var2, Collector.Characteristics... var3) {
        Objects.requireNonNull(var0);
        Objects.requireNonNull(var1);
        Objects.requireNonNull(var2);
        Objects.requireNonNull(var3);
        Set var4 = var3.length == 0 ? Collectors.CH_ID : Collections.unmodifiableSet(EnumSet.of(Collector.Characteristics.IDENTITY_FINISH, var3));
        return new CollectorImpl(var0, var1, var2, var4);
    }

    static <T, A, R> Collector<T, A, R> of(Supplier<A> var0, BiConsumer<A, T> var1, BinaryOperator<A> var2, Function<A, R> var3, Collector.Characteristics... var4) {
        Objects.requireNonNull(var0);
        Objects.requireNonNull(var1);
        Objects.requireNonNull(var2);
        Objects.requireNonNull(var3);
        Objects.requireNonNull(var4);
        Set var5 = Collectors.CH_NOID;
        if (var4.length > 0) {
            EnumSet var6 = EnumSet.noneOf(Collector.Characteristics.class);
            Collections.addAll(var6, var4);
            var5 = Collections.unmodifiableSet(var6);
        }

        return new CollectorImpl(var0, var1, var2, var3, var5);
    }

    public static enum Characteristics {
        CONCURRENT,
        UNORDERED,
        IDENTITY_FINISH;

        private Characteristics() {
        }
    }
}
```
下面演示使用自定义的类型收集器
```java
package stream;

import java.util.*;
import java.util.function.BiConsumer;
import java.util.function.BinaryOperator;
import java.util.function.Function;
import java.util.function.Supplier;
import java.util.stream.Collector;
import java.util.stream.Stream;

import static java.util.stream.Collector.Characteristics.CONCURRENT;
import static java.util.stream.Collector.Characteristics.IDENTITY_FINISH;
import static java.util.stream.Collectors.toMap;

public class StreamCollect02 {
    private static class Person {
        private String name;
        private int age;
        private double height;

        public Person() {
        }

        public Person(String name, int age, double height) {
            this.name = name;
            this.age = age;
            this.height = height;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public int getAge() {
            return age;
        }

        public void setAge(int age) {
            this.age = age;
        }

        public double getHeight() {
            return height;
        }

        public void setHeight(double height) {
            this.height = height;
        }
    }

    /**
     * Person对象集合按年龄来分组
     */
    public static class MyGrouping implements Collector<Person, Map<Integer, ArrayList<Person>>, Map<Integer, ArrayList<Person>>> {
        @Override
        public Supplier<Map<Integer, ArrayList<Person>>> supplier() {
            return HashMap::new;
        }

        @Override
        public BiConsumer<Map<Integer, ArrayList<Person>>, Person> accumulator() {
            return (map, p) -> {
                ArrayList<Person> list;
                if ((list = map.get(p.getAge())) != null) {
                    list.add(p);
                } else {
                    list = new ArrayList<>();
                    list.add(p);
                    map.put(p.getAge(), list);
                }
            };
        }

        @Override
        public BinaryOperator<Map<Integer, ArrayList<Person>>> combiner() {
            return (m1, m2) -> Stream.of(m1, m2)
                    .map(Map::entrySet)
                    .flatMap(Collection::stream)
                    .collect(toMap(Map.Entry::getKey, Map.Entry::getValue, (e1, e2) -> {
                        e1.addAll(e2);
                        return e1;
                    }));
        }

        @Override
        public Function<Map<Integer, ArrayList<Person>>, Map<Integer, ArrayList<Person>>> finisher() {
            return Function.identity();
        }

        @Override
        public Set<Characteristics> characteristics() {
            return Collections.unmodifiableSet(EnumSet.of(IDENTITY_FINISH, CONCURRENT));
        }
    }

    private static class PersonSupplier implements Supplier<Person> {
        private int index = 0;
        private Random random = new Random();
        @Override
        public Person get() {
            return new Person("Name"+String.valueOf(index++), random.nextInt(100), random.nextDouble());
        }
    }

    public static void main(String[] args) {
        //使用自定义的类型收集器将stream转换为想要的数据类型
        Map<Integer, ArrayList<Person>> collect =
                Stream.generate(new PersonSupplier()).limit(100).collect(new MyGrouping());
        collect.forEach((k,v)-> System.out.println(k+"="+v));
    }
}

```
由于在Java系统中常用的数据类型就那么几种，因此JDK默认封装了一些常用的类型收集器。可以查阅java.util.stream.Collectors类型收集器工程查阅这些默认的封装，这其中就包括了toList、toMap等方法。java.util.stream.Collectors 类的主要作用就是辅助进行各类有用的 reduction 操作，例如转变输出为 Collection，把 Stream 元素进行归组。下面使用groupingBy/partitioningBy进行分组收集。
```java
//按照年龄归组
Map<Integer, List<Person>> personGroups = Stream.generate(new PersonSupplier()).
 limit(100).
 collect(Collectors.groupingBy(Person::getAge));
Iterator it = personGroups.entrySet().iterator();
while (it.hasNext()) {
 Map.Entry<Integer, List<Person>> persons = (Map.Entry) it.next();
 System.out.println("Age " + persons.getKey() + " = " + persons.getValue().size());
}

// 按照未成年人和成年人归组
Map<Boolean, List<Person>> children = Stream.generate(new PersonSupplier()).
 limit(100).
 collect(Collectors.partitioningBy(p -> p.getAge() < 18));
System.out.println("Children number: " + children.get(true).size());
System.out.println("Adult number: " + children.get(false).size());
```

#### 参考链接
https://blog.csdn.net/io_field/article/details/54971608
https://blog.csdn.net/zw19910924/article/details/76945279
https://segmentfault.com/a/1190000012166699
https://www.cnblogs.com/GYoungBean/p/4301557.html
https://blog.csdn.net/zhang89xiao/article/details/51942614
http://ifeve.com/stream/
https://blog.csdn.net/nianhua120/article/details/53406583
https://www.cnblogs.com/puyangsky/p/7608741.html
https://www.cnblogs.com/CarpenterLee/p/6550212.html
