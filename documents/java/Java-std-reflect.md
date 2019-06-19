title: Java reflect反射
date: 2016-01-12 22:32:49
tags: Java
categories: Java
---
在Java中将从一个对象中得到类的信息的过程叫做反射.
在Java中Object类是一切类的父类,那么所有类的对象实际上也就是java.lang.Class的实例.所以所有的对象都可以转变为
java.lang.Class类型标识.Class本身表示一个类的本身,通过Class可以完整地得到一个类中的完整结构.包括此类中定义
的方法定义,属性定义等.下面是Class类中的一些常用的操作方法.

```java
//传入完整的"包.类"名称实例化Class对象
static Class<?> forName(String className)
//得到一个类中的全部构造方法
Constructor[] getConstructors()
//得到本类中单独定义的全部属性
Field[]	getDeclaredFileds()
//取得本类继承而来的全部属性
Filed[]   getFields()
//得到一个类中的全部方法
Method[]	 getMethods()
//返回一个Method对象,并设置一个方法中的所有参数类型
Method	getMethods(String name,Class ... parameterTypes)
//得到一个类中所实现的全部接口
Class[]	getInterfaces()
//得到一个类完整的 包.类 名称
String getName()
//得到一个类的包
Package getPackage()
//得到一个类的父类
Class	getSuperclass()
//根据Class定义的类实例化对象
Object newInstance()
//返回表示数组类型的Class
Class<?> getComponentType()
//判断此Class是否是一个数组
boolean  isArray()
```
在Class类中本身没有定义任何的构造方法,所以如有要使用则首先必须通过forName()方法实例对象.除此之外,
也可使用 "类.class" 或"对象.getClass()"方法实例化.
# 调用无参构造函数
如果要想通过Class类本身实例化其他类的对象,则可以使用newInstance()方法,但是必须要保证被实例化的类中存在一个无参构造方法.
例如下面的实例:
```java
/**
 * 概要: 通过无参构造实例化对象 
 *	如果要想通过Class类本身实例化其他类的对象,则可以使用newInstance()方法.
 *	但是必须要保证被实例化的类存在一个无参构造方法
 *
 */
package classfile;

class Person{
	private String name;
	private int age;

	public String getName(){
		return this.name;
	}
	public void setName(String name){
		this.name = name;
	}
	public int getAge(){
		return this.age;
	}
	public void setAge(int age){
		this.age= age;
	}
	public String toString(){
		return "name:"	+this.name+"\t age:"+this.age;
	}

}
public class demo_1{
	public static void main(String[] args){

		Class<?> c1 =null;
		try{
			c1=Class.forName("classfile.Person");
		}catch(Exception e){
			e.printStackTrace();
		}
		Person per =null;
		try{
			per =(Person)c1.newInstance();
		}catch(Exception e){
			e.printStackTrace();
		}
		per.setName("禅师");
		per.setAge(24);
		System.out.println(per);
	}
}
```
# 调用有参构造
调用有参构造方法的操作步骤如下:
+通过Class类中的getConstructors()方法取得本类中的全部构造方法(返回一个Constructor数组)
+ 向构造方法中传递一个对象数组进去,里面包含了构造方法中所需的各个参数
+ 之后通过Contructor实例化对象
在Constructor中提供如下核心函数
```java
//得到构造方法准中的修饰符
int getModifiers()
//得到构造方法的名称
String getName()
//得到构造方法中参数的类型
Class<?>[] getParameterTypes()
//返回此构造方法的信息
String toString()
//向构造方法中传递参数,实例化对象
T newInstance(Object ... initargs)
```
下面是一个调用有参构造的实例：

```java
package classfile;

import java.lang.reflect.Constructor;
class Person{
	private String name;
	private int age;

	public Person(String name,int age){
		this.setName(name);
		this.setAge(age);
	}
	public String getName(){
		return this.name;
	}
	public void setName(String name){
		this.name = name;
	}
	public int getAge(){
		return this.age;
	}
	public void setAge(int age){
		this.age= age;
	}
	public String toString(){
		return "name:"	+this.name+"\t age:"+this.age;
	}
}
public class demo_2{
	public static void main(String[] args){
		Class<?> c = null;
		try{
			c = Class.forName("classfile.Person");
		}catch(Exception e){
			e.printStackTrace();
		}
		Person per = null;
		Constructor<?> constr[] = null;
		constr = c.getConstructors();
		try{
			per = (Person) constr[0].newInstance("禅师",24);
		}catch(Exception e){
			e.printStackTrace();
		}
		System.out.println(per);
	}
}
```
# 取得全部方法
要取得一个类中的全部方法,可以使用Class类中的getMethods()方法,此方法返回一个Method类的对象数组.
而如果想要近一部分取得方法的具体信息.例如方法的参数.抛出的异常声明等.则就必须依靠Method类.此类中的常用方法如下

```java
//取得本方法的访问修饰符
int getModifiers()

//取得方法的名称
String getName()

//取得方法的全部参数类型
Class<?>[] getParameterTypes

//取得方法的返回值类型
Class<?> getReturnType()

//得到一个方法的全部抛出异常
Class<?>[] getExceptionTypes()

//通过反射调用类中的方法
Object invoke(Object obj ,Object... args)
```
下面是一个实例:
```java
package classfile;
import java.lang.reflect.*;

public class getAllfunction{

	public static void main(String[] args){
		Class<?> c1= null;
		try{
			c1 = Class.forName("classfile.Person");
		}catch(Exception e){
			e.printStackTrace();
		}

		Method m[] = c1.getMethods();
		for(int i = 0; i < m.length;i++){
			Class<?> r= m[i].getReturnType();
			Class<?> p[] =m[i].getParameterTypes();
			int xx = m[i].getModifiers();
			System.out.print(Modifier.toString(xx) + "  ");
			System.out.print(r.getName() + " ");
			System.out.print(m[i].getName());
			System.out.print("(");
				for(int x = 0;x<p.length;x++){
					System.out.print(p[x].getName()+" arg" + x);
					if(x<p.length-1){
						System.out.print(",");
					}
				}
			Class<?> ex[] = m[i].getExceptionTypes();
			if(ex.length>0){
				System.out.print(") throws");
			}else{
				System.out.print(")");
			}
			for(int j=0;j<ex.length;j++){
				System.out.print(ex[j].getName());
				if(j<ex.length-1){
					System.out.print(",");
				}
			}
			System.out.println();
		}//end-Methods
	}
}
```

# 取得全部的属性
在反射操作中也同样可以取得一个类中的全部属性,但是在取得属性时有以下俩种不同的操作.
+ 得到实现的接口或父类中的公共属性:public Filed[]  getFileds();
+ 得到本类中的全部属性:public Field[] getDeaclaredFileds();
以上方法返回的都是Filed的数组,每一个Field对象表示类中的一个属性.而要想取得属性的进一步信息.可以使用如下的方法:

```java
//得到一个对象中属性的具体内容
Object get(Object obj)

//设置指定对象中属性的具体内容
void set(Object obj,Object value)

//得到属性的修饰符
int getModifiers()

//返回此属性的名称
String getName()

//判断此属性是否可被外部访问
boolean isAccessible()

//设置一个属性是否可被外部访问
void setAccessibel()

//设置一组属性是否可被外部访问
static void setAccessible(AccessiblleObject[] arg ,boolean flag)

//返回此Field类的信息
String toString()
```

下面使用反射直接操作对象的属性
```java
package classfile;
import java.lang.reflect.*;

public class getAllfunction{

	public static void main(String[] args){
		Class<?> c1= null;
		Object obj =  null;
		try{
			c1 = Class.forName("classfile.Person");
		}catch(Exception e){
			e.printStackTrace();
		}


		try{
			obj = c1.newInstance();
		}catch(Exception e){
			e.printStackTrace();
		}
		Field nameField = null;
		nameField = c1.getDeclaredFiled("name");

}
```