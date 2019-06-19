title: Hibernate对象的状态
date: 2016-01-28 22:22:26
tags:
    - hibernate
categories: Java
---
在Hibernate中有三种状态，对它的深入理解，才能更好的理解hibernate的运行机理，刚开始不太注意这些概念，
后来发现它是重要的。对于理解hibernate，JVM和sql的关系有更好的理解。对于需要持久化的JAVA对象，在它的
生命周期中有三种状态，而且互相转化
# hibernate的对象状态
Hibernate它的对象有三种状态，transient、persistent、detached下边是常见的翻译办法：
>* transient：瞬态或者自由态
>* persistent：持久化状态
>* detached：脱管状态或者游离态

## 瞬态
由new操作符创建，且尚未与Hibernate Session 关联的对象被认定为瞬时(Transient)的。
瞬时(Transient)对象不会被持久化到数据库中，也不会被赋予持久化标识(identifier)。 
如果瞬时(Transient)对象在程序中没有被引用，它会被垃圾回收器(garbage collector)销毁。 
使用Hibernate Session可以将其变为持久(Persistent)状态。(Hibernate会自动执行必要的SQL语句)
表示该实体对象在内存中是自由存在的，也就是说与数据库中的数据没有任何的关联即，该实体从未
与任何持久化上下文联系过，没有持久化标识（相当与主键）。
**瞬态实体的特征有**
  与数据库中的记录没有任何关联，也就是没有与其相关联的数据库记录 与Session没有任何关系，
  也就是没有通过Session对象的实例对其进行任何持久化的操作。

## 持久
持久(Persistent)的实例在数据库中有对应的记录，并拥有一个持久化标识(identifier)。 
持久(Persistent)的实例可能是刚被保存的，或刚被加载的，无论哪一种，按定义，
它存在于相关联的Session作用范围内。 Hibernate会检测到处于持久(Persistent)状态的对象的任何改动
在当前操作单元(unit of work)执行完毕时将对象数据(state)与数据库同步(synchronize)。 开发者不需
要手动执行UPDATE。将对象从持久(Persistent)状态变成瞬时(Transient)状态同样也不需要手动执行
DELETE语句。
指该实体对象处于Hibernate框架所管理的状态，也就是说这个实体对象是与Session对象的实例相关的。
处于持久态的实体对象的最大特征是对其所作的任何变更操作都将被Hibernate持久化到数据库中
处于持久态的对象具有的特征为
	每个持久态对象都于一个Session对象关联
    处于持久态的对象是于数据库中的记录相关联的
    Hibernate会根据持久态对象的属性的变化而改变数据库中的相应记录
## 脱管
与持久(Persistent)对象关联的Session被关闭后，对象就变为脱管(Detached)的。 对脱管(Detached)对象
的引用依然有效，对象可继续被修改。脱管(Detached)对象如果重新关联到某个新的Session上， 会再次转
变为持久(Persistent)的(在Detached其间的改动将被持久化到数据库)。 这个功能使得一种编程模型，
即中间会给用户思考时间(user think-time)的长时间运行的操作单元(unit of work)的编程模型成为可能。
我们称之为应用程序事务，即从用户观点看是一个操作单元(unit of work)	
处于持久态的实体对象，当他不再与Session对象关联时，这个对象就变成了游离态。。游离态对象的特征有
	游离态对象一定是由持久态对象转换而来
	游离态实体不再于Session关联
    游离态实体对象与数据库中的数据没有直接联系，主要表现在对其进行的修改不再影响到数据库中的数据
    游离态实体对象在数据库中有相应的数据记录（如果该记录没有被删除）
## 对象状态	
hibernate对于对象的保存提供了太多的方法，他们之间有很多不同，这里细说一下，以便区别
游离状态的实例可以通过调用save()、persist()或者saveOrUpdate()方法进行持久化。
通过get()或load()方法得到的实例都是持久化状态的。
持久化实例可以通过调用 delete()变成脱管状态。
脱管状态的实例可以通过调用 update()、0saveOrUpdate()、lock()或者replicate()进行持久化。
save()和persist()将会引发SQL的INSERT，delete()会引发SQLDELETE，
而update()或merge()会引发SQLUPDATE。对持久化（persistent）实例的修改在刷新提交的时候会被检测到，
它也会引起SQLUPDATE。saveOrUpdate()或者replicate()会引发SQLINSERT或者UPDATE

```java
Session session = HibernateSessionFactory.getSession();
//瞬间状态
 Stud stud = new Stud();   
 stud.setSId(2);
stud.setSName("sadas");
Transaction tx = session.beginTransaction();
//持久化状态 处于缓存中的状态
session.save(stud);    
tx.commit();
 session.close();
//游离状态、脱管状态

```	
## save 和update区别
把这一对放在第一位的原因是因为这一对是最常用的。
save的作用是把一个新的对象保存
update是把一个脱管状态的对象保存
## update 和saveOrUpdate区别
这个是比较好理解的，顾名思义，saveOrUpdate基本上就是合成了save和update
引用hibernate reference中的一段话来解释他们的使用场合和区别
通常下面的场景会使用update()或saveOrUpdate()： 
程序在第一个session中加载对象 
该对象被传递到表现层 
对象发生了一些改动 
该对象被返回到业务逻辑层 
程序调用第二个session的update()方法持久这些改动
saveOrUpdate()做下面的事: 
如果对象已经在本session中持久化了，不做任何事 
如果另一个与本session关联的对象拥有相同的持久化标识(identifier)，抛出一个异常 
如果对象没有持久化标识(identifier)属性，对其调用save() 
如果对象的持久标识(identifier)表明其是一个新实例化的对象，对其调用save() 
如果对象是附带版本信息的（通过<version>或<timestamp>） 并且版本属性的值表明其是一个新实例化的对象，save()它。 
否则update() 这个对象

## persist和save区别
这个是最迷离的一对，表面上看起来使用哪个都行，在hibernate reference文档中也没有明确的区分他们.
这里给出一个明确的区分。（可以跟进src看一下，虽然实现步骤类似，但是还是有细微的差别）
这里参考http://opensource.atlassian.com/projects/hibernate/browse/HHH-1682中的一
1，persist把一个瞬态的实例持久化，但是并"不保证"标识符被立刻填入到持久化实例中，标识符的填入可能被推迟到flush的时间。
2，persist"保证"，当它在一个transaction外部被调用的时候并不触发一个Sql Insert，
这个功能是很有用的，当我们通过继承Session/persistence context来封装一个长会话流程的时候，
一个persist这样的函数是需要的。
3，save"不保证"第2条,它要返回标识符，所以它会立即执行Sql insert，不管是不是在transaction内部还是外部有问

## saveOrUpdateCopy,merge和update区别
首先说明merge是用来代替saveOrUpdateCopy的，这个详细见这里
http://www.blogjava.net/dreamstone/archive/2007/07/28/133053.html
然后比较update和merge
update的作用上边说了，这里说一下merge的 
如果session中存在相同持久化标识(identifier)的实例，用用户给出的对象的状态覆盖旧有的持久实例 
如果session没有相应的持久实例，则尝试从数据库中加载，或创建新的持久化实例,最后返回该持久实例 
用户给出的这个对象没有被关联到session上，它依旧是脱管的   即 merge等同于saveOrupdate  ，
如果数据库有就update没有就save，update 只能更新数据库已经有的数据
重点是最后一句：
当我们使用update的时候，执行完成后，我们提供的对象A的状态变成持久化状态
但当我们使用merge的时候，执行完成，我们提供的对象A还是脱管状态，hibernate或者new了一个B，
或者检索到一个持久对象B，并把我们提供的对象A的所有的值拷贝到这个B，执行完成后B是持久状态，
而我们提供的A还是托管状态

## flush和update区别
这两个的区别好理解
update操作的是在脱管状态的对象
而flush是操作的在持久状态的对象。
默认情况下，一个持久状态的对象是不需要update的，只要你更改了对象的值，等待hibernate flush就自动
保存到数据库了。hibernate flush发生再几种情况下：
1，调用某些查询的时候
2，transaction commit的时候
3，手动调用flush的时候
七,lock和update区别
update是把一个已经更改过的脱管状态的对象变成持久状态
lock是把一个没有更改过的脱管状态的对象变成持久状态
对应更改一个记录的内容，两个的操作不同：
update的操作步骤是：
（1）更改脱管的对象->调用update
lock的操作步骤是：
(2)调用lock把对象从脱管状态变成持久状态-->更改持久状态的对象的内容-->等待flush或者手动flush
