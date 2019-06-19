title: Java泛型
date: 2016-01-02 16:49:54
tags: Java
categories: Java
---
泛型可以解决数据类型的安全性问题.其主要原理是在类声明时通过一个标识标识类
中某个属性的类型或者某个方法的返回值及参数类型,这样在类声明或实例化时只要
指定要需要的类刑即可.

# 泛型类的定义格式
```java
[访问权限]  class  类名称<泛型标识符1,泛型标识符2,....,泛型标识符n>{

[访问权限]  泛型类型标识  变量名称;

[访问权限]  泛型类型标识  方法名称(){}

[访问权限]  返回值类型声明 方法名称(泛型类型标识  变量名称){}

}

```
# 泛型对象定义
```java
类名称<具体类型> 对象名称 = new  类名称<具体类>();
```
# 通配符
在实际的开发中对象的引用传递是最常见的，但是如果在泛型类的操作中，在进行引用传递时泛型类型必须匹配才可以传点，
否则是无法传递的。所以Java中引入了通配符“?”，表示可以接受此类型的任意泛型对象。

例如:
```java
package generics;

/*******************************************************
 * @author Neptunes
 * @summary 演示泛型中的通配符
 ******************************************************/
class Info<T>{
  private T var;
  public T getVar(){
     return var;
  }
  public void setVar(T var){
     this.var = var;
  }
}
public class wildcardClass {

  public static void fun(Info<?> temp){

     System.out.println(temp);

  }
}

```
# 受限泛型

在引用传递中,在泛型操作中也可设置一个泛型对象的访问上限和范围下限.
范围上限使用extends关键字声明.表示参数化的类型可能是所指定的类型或者是此类型的子类.
而范围下限使用super进行声明.表示参数化的类型可能是所指定的类型.或者此类型的父类或者是Object类.

## 上限
```java
对象声明: 类名称<? extends  类> 对象名称

定义类: [访问权限]  类名称<泛型标识  extends 类>{}

```
实例
现在假设一个方法中只能接收数字(Byte Short Long Interger Float. Double)类型.
此时在定义方法参数接收对象时,就必须指定泛型的上限.因为所有的数字的包装类都是Number类型的子类,所以代码如下:
```java
package generics;

/***********************************************************
 *
 * @author Neptune
 * @summary 演示泛型的上限设置
 *     该例子中泛型只能指定Number及其子类
 ***********************************************************/

public class UperlimitGenerics<T extends Number> {

  private T var;

  public T getVar() {

     return var;

  }
  public void setVar(T var) {

     this.var = var;

  }
  public static void main(String[] args){

     UperlimitGenerics<Integer> obj1 = new UperlimitGenerics<Integer>();

     obj1.setVar(new Integer(30));

     System.out.println(obj1.getVar());


     UperlimitGenerics<Float> obj2 = new UperlimitGenerics<Float>();

     obj2.setVar(new Float(30.0f));

     System.out.println(obj2.getVar());

     /**

      * 下面实例话String类型的对象时编译会报错

      */
     //UperlimitGenerics<String> obj3 = new UperlimitGenerics<String>();

  }

}

```
## 下限
```java
对象声明 : 类名称<? super 类> 对象名称

定义类: [访问权限] 类名称<泛型标识 extends 类> {}
```
实例
```java
package generics;

/*******************************************************
 *
 * @author Neptune
 * @summary 演示泛型的下限设置
 *     该类中泛型只能实例化String类型Object类型
 *******************************************************/

public class BelowlimitGenerics<T> {

  private T var;

  public T getVar() {
     return var;
  }
  public void setVar(T var) {
     this.var = var;
  }

  public static void main(String[] args){

     //指定obj1对象只能实现Object <> String之间类型的对象

     BelowlimitGenerics<? super String> obj1 = null;

     obj1 = new BelowlimitGenerics<String>();
     obj1.setVar("Neptune");

     System.out.println(obj1.getVar());

  }
}
```
# 泛型接口
在JDK1.5之后泛型也可以应用到接口中，其可以利用如下的语法定义:
```java
   [访问权限]   interface 接口名称<泛型标识>{
    }
例如

   Interface  Info<T>{
            public T getVar();
    }
```
## 泛型接口的俩种实现方式

   在定义完泛型接口后，就要定义此接口的子类。定义泛型接口的子类有俩种方式：
         方式一
                   直接在子类后声明泛型
         方式二
                   直接在子类实现的接口中明确地给出泛型类型
## 方式一
```java
package generics;

/**************************************************
 *
 * @author Neptune
 * @summary 演示泛型接口的定义及使用
 *
 **************************************************/
interface Infos<T>{
  public T getVar();
}
/**
 *
 * @author Neptune
 * @summary 通过方式一：直接在子类后面声明泛型
 * @param <T>
 */
public class InterfaceDemo1<T> implements Infos<T>{

  private T var;

  @Override
  public T getVar() {
     return var;
  }
  public void setVar(T var){
     this.var = var;
  }
  public static void main(String[] args){

     InterfaceDemo1<String> obj1 = new InterfaceDemo1<String>();

     obj1.setVar("already");

     System.out.println(obj1.getVar());

     InterfaceDemo1<Integer> obj2 = new InterfaceDemo1<Integer>();

     obj2.setVar(11);

     System.out.println(obj2.getVar());

  }
}
```
## 方式二
```java
package generics;

/*************************************************************
 *
 * @author Neptune
 * @summary 演示以方式二实现泛型接口
 *     在定义子类时指定泛型
 *************************************************************/
interface  interfaceGenerics<T>{
  public T getVar();
}

/**
 * @summary 演示直接在定义泛型子类时指定泛型的方式
 */
public class InterfaceDemo2 implements interfaceGenerics<String> {

  public String var;

  @Override

  public String getVar() {

     return var;

  }

  public void setVar(String var){
     this.var = var;

  }
  public static void main(String[] args){

     InterfaceDemo2 obj1 = new InterfaceDemo2();

     obj1.setVar("this's Demo");
     System.out.println(obj1.getVar());

  }
}

```
# 泛型方法
在类中可以定义泛型方法，泛型方法的定义与其所在的类是否是泛型类没有任何的关系。
在泛型方法中可以定义泛型参数，此时参数的类型就是传入数据的类型，可以使用如下的格式定义泛型方法。
```java
   访问权限  <泛型标识>  泛型标识  方法名称([泛型标识  参数名称])
```
例如
```java
package generics;

/**
 *****************************************************************
 * @Title     GenericsFunction1.java
 * @author    Neptune
 * @date    2013年10月13日 下午8:53:50
 * @version   V1.0
 * @summary   演示泛型方法的使用
 ******************************************************************/
public class GenericsFunction1 {

  public <T> T fun(T t){
     return t;
  }
  public static void main(String[] args){

    GenericsFunction1 obj1 = new GenericsFunction1();

     System.out.println(obj1.fun("this's String"));

     System.out.println(obj1.fun(1));
  }

}

```

# 泛型数组
```java
package generics;

/**
 * ****************************************************************
 * @Title     GenericsArray.java
 * @author    Neptune
 * @date    2013年10月13日 下午9:09:39
 * @version   V1.0
 * @summary   演示使用泛型数组
 ******************************************************************/

public class GenericsArray {
  /**
   * 返回一个泛型数组
   * @param ts
   * @return
   */
  @SafeVarargs
  public static <T> T[] getArray(T...ts){
     return ts;
  }
  /**
   * 为方法传递一个泛型数组
   * @param param
   */
  public static <T> void print(T[] param){

     System.out.println("the Param is:");

     for(T c:param){

       System.out.print(c);

    }

  }

  public static void main(String[] args){

     Integer[] arr = getArray(1,2,3,4,5);

     System.out.println(arr);

     print(arr);
  }
}


```