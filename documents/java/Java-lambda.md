---
title: Java8之lambda编程
date: 2018-06-27 21:45:46
tags: Java
---
现代工业及科技的发展，致使高效成为永恒的话题。作为工业级的软件开发语言Java支持lambda是势在必为的事情。其实Lambda表达式的本质只是一个"语法糖",由编译器推断并帮你转换包装为常规的代码,因此你可以使用更少的代码来实现同样的功能。Lambda表达式是Java SE 8中一个重要的新特性。lambda表达式允许你通过表达式来代替功能接口。 lambda表达式就和方法一样,它提供了一个正常的参数列表和一个使用这些参数的主体(body,可以是一个表达式或一个代码块)。

在Java中Lambda有着这样的特性可选类型声明(不需要声明参数类型，编译器可以统一识别参数值)可选的参数圆括号(一个参数无需定义圆括号，但多个参数需要定义圆括号)可选的大括号(如果主体包含了一个语句，就不需要使用大括号)可选的返回关键字(如果主体只有一个表达式返回值则编译器会自动返回值，大括号需要指定明表达式返回了一个数值)。通常Lambda的格式如下:
```java
(parameters) -> expression
// or
(parameters) ->{ statements; }

// 简单的实例
// 1. 不需要参数,返回值为 5  
() -> 5  
// 2. 接收一个参数(数字类型),返回其2倍的值  
x -> 2 * x  
// 3. 接受2个参数(数字),并返回他们的差值  
(x, y) -> x – y  
// 4. 接收2个int型整数,返回他们的和  
(int x, int y) -> x + y  
// 5. 接受一个 string 对象,并在控制台打印,不返回任何值(看起来像是返回void)  
(String s) -> System.out.print(s)  
```

### λ表达式
表达式有三部分组成：参数列表，箭头（->），以及一个表达式或语句块。下面以用一段代码来说明
```java
	//传统的方式
    public int add(int x, int y) {
        return x + y;
    }

	//转成λ表达式后是这个样子：
    (int x, int y) -> x + y;

	//参数类型也可以省略，Java编译器会根据上下文推断出来：
    (x, y) -> x + y; //返回两数之和
 	//或者
 	(x, y) -> { return x + y; } //显式指明返回值
 	//如果只有一个参数且可以被Java推断出类型，那么参数列表的括号也可以省略：
    c -> { return c.size(); }
    c -> c.size();
```
#### λ表达式的类型
λ表达式可以被当做是一个Object（注意措辞）。λ表达式的类型，叫做“目标类型（target type）”。λ表达式的目标类型是“函数接口（functional interface）”，这是Java8新引入的概念。它的定义是：一个接口，如果只有一个显式声明的抽象方法，那么它就是一个函数接口。一般用@FunctionalInterface标注出来（也可以不标）。例如:
```java
@FunctionalInterface
public interface Runnable { void run(); }

public interface Callable<V> { V call() throws Exception; }

public interface ActionListener { void actionPerformed(ActionEvent e); }

//注意equals方法其实是Object的方法
public interface Comparator<T> { int compare(T o1, T o2); boolean equals(Object obj); }
```

#### 将λ表达式复赋值一个函数接口
在Java8中可以将表达式复制给一个函数接口，这个特性极大的扩展了lambda的使用范围，可以下如下方式一样使用lambda
```java
 Runnable r1 = () -> {System.out.println("Hello");};
 //然后再赋值给一个Object：
 Object obj = r1;
 //错误的操作
 Object obj = () -> {System.out.println("Hello Lambda!");};
 //正常操作
 Object o = (Runnable) () -> { System.out.println("hi"); }; 
```
因此可以按照这种是编码
```java
//定义操作接口
@FunctionalInterface
public interface MyRunnable {
    public void run();
}
//像这样使用
Runnable r1 =    () -> {System.out.println("Hello Lambda!");};
MyRunnable2 r2 = () -> {System.out.println("Hello Lambda!");};
```

##### Function
Java1.8的JDK中定义了很多功能些的函数，用以支持如上说形式的使用lambda表达式，其中Function就是其中一个重要的函数，这个接口代表一个函数，接受一个T类型的参数，并返回一个R类型的返回值。
```java
//接口定义
@FunctionalInterface
public interface Function<T, R> {  
    R apply(T t);
}

//使用实例
import java.util.function.Function;

public class demo3 {
    /**
     * 定义一个方法，对一个Integer的参数执行一系列的操作，然后返回一个Integer
     * @param valueToBeOperated 需要操作的证书
     * @param function 需要执行一系列的操作
     */
    public static void applyItem(int valueToBeOperated, Function<Integer, Integer> function){
        int newValue = function.apply(valueToBeOperated);
        System.out.println(newValue);
    }

    public static void main(String[] args) {
        //对1执行 * 100 /36的操作
        applyItem(1,x -> x * 100 / 36);

        //对1执行另一种操作
        applyItem(1,x -> x + 1000 );

    }
}
```
##### Consumer
跟Function的唯一不同是它没有返回值
```java
@FunctionalInterface
public interface Consumer<T> {
    void accept(T t);
}
//使用实例
import java.util.Arrays;
import java.util.List;
import java.util.function.Consumer;

public class demo4 {
    public static void ConsumerItem(String item, Consumer<String> fuction){
        fuction.accept(item);
    }

    public static void main(String[] args) {
        List<String> features = Arrays.asList("A", "B", "C", "D");

        for (String str:features){
            ConsumerItem(str,x-> System.out.println(x+x));
            ConsumerItem(str,x-> System.out.println(x+x+x));
        }
    }
}

```
##### Predicate
Predicate，用来判断某项条件是否满足。经常用来进行筛滤操作,java.util.function.Predicate提供and(), or() 和 xor()可以进行逻辑操作，比如为了得到一串字符串中以"J"开头的4个长度：
```java
@FunctionalInterface
public interface Predicate<T> {
    boolean test(T t);
}
import java.util.Arrays;
import java.util.List;
import java.util.function.Predicate;

public class demo5 {

    public static void filer(int i,Predicate<Integer> filter){
        if(filter.test(i)){
            System.out.println(i);
        }
    }

    public static void main(String[] args) {
        List<Integer> features = Arrays.asList(1, 2, 3, 4);
        features.forEach(x -> filer(x,v -> v%2 == 0 ));
    }
}



```

### 编程中常见的几种使用方式

#### 使用lambda快速创建匿名类
```java
/**
 * 使用lambda快速创建一个Thread
 */
public class demo1 {
    public static void main(String[] args) {

        //使用非lambda的方式
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("Before Java8 ");
            }
        }).start();

        //使用lambda的方式
        //注意此处使用() -> {} 替代匿名类
        new Thread( () -> System.out.println("In Java8!") ).start();
    }
}
```

#### 使用lambda快速遍历集合类

```java
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 使用lambda快速遍历集合
 */
public class demo2 {
    public static void main(String[] args) {
        List<String> features = Arrays.asList("A", "B", "C", "D");

        //传统的遍历方式
        for(String feature : features) {
            System.out.println(feature);
        }

        //使用lambda表达式
        features.forEach(n -> System.out.println(n));
        features.forEach(System.out::println);


        Map<String, Integer> items = new HashMap<>();
        items.put("A", 10);
        items.put("B", 20);
        items.put("C", 30);
        items.put("D", 40);
        items.put("E", 50);
        items.put("F", 60);
        //传统的遍历方式
        for (Map.Entry<String, Integer> entry : items.entrySet()) {
            System.out.println("Item : " + entry.getKey() + " Count : " + entry.getValue());
        }
        //lambda遍历方式
        items.forEach((k,v) -> System.out.println("Item : " + k + " Count : " + v));
    }
}
```


### 参考
https://www.cnblogs.com/tiantianbyconan/p/3613506.html
https://www.cnblogs.com/andywithu/p/7357069.html
https://www.cnblogs.com/anakin/p/7742779.html
https://blog.csdn.net/wonking666/article/details/79208863

