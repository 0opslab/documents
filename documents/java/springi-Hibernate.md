title: Spring整合Hibernate
date: 2016-01-28 19:58:11
tags:
    - Java
    - spring
categories: Java
---

时至今日，Java EE通常都会面向对象的方式来操作关系数据库，都会采用ORM框架来完成这一功
能，其中Hiernate以其灵巧，轻便的封装赢得了准多开发者的青睐。Spring以良好的开放性，能
与大部分发ORM框架良好整合。

## Spring提供的DAO支持
DAO模式是一种标准的Java EE设计模式，DAO模式的核心思想是：所有的数据库访问，都通过DAO
组建完成，DAO组建封装了数据库的增、删、改等原子操作。对于Java EE应用的架构，有非常多
的选择，但不管细节如何变换。Java EE应用都大致可分为如下三层：
>* 表现层
>* 业务逻辑层
>* 数据持久层
轻量级Java EE框架以Spring Ioc容器为核心，承上启下，相上管理来自表现层的Action，下下管
理业务逻辑层组建，同事负责业务逻辑层所需的DAO对象。DAO组建是整个Java EE应用的持久层访
问的重要组件，每个Java EE应用的底层实现都难以离开DAO组件的支持。Spring对实现DAO组件提
供了许多工具类，系统的DAO组件可以继承这些工具类完成，从而可以更简单的实现DAO组件
Spring提供了一系列的抽象类，这些抽象类将被作为应用中DAO实现的父类，通过继承这些抽象类
spring简化DAO的开发不足，能以一致的方式使用数据库访问技术。不管底层采用JDBC、JDO还是
Hibernate就Hibernate的持久层访问技术而言，spring提供了如下三个工具类（或接口）来支持
DAO组件的实现
>* HibernateDaoSupport
>* HibernateTemplate
>* HibernateCallback

## 管理Hibernate的SessionFactory
当通过Hibernate进行持久层访问时，必须先获得SessionFactory对象。它是单个数据库映射关系编
译后的内存镜像。大部分请客下，一个JavaEE应用对应一个数据库，即对应一个SessionFactory对象
Spring的IoC容器正好提供了这种管理方式，它不仅能以声明式的方式配置SessionFactory实例，也
可以为SessionFactory注入数据源。
一旦在Spring的IoC容器中配置了SessionFactory Bean，它将随应用的启动而加载，并可以充分利
用IoC容器的功能，将SessionFactory Bean注入任何bean。比如DAO组件，一旦DAO组件获得了
SessionFactory Bean的引用，就可以完成实际的数据库访问。
例如:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns="http://www.springframework.org/schema/beans"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
	http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">
	
	<!-- 配置Spring数据源 Oracle10g -->
	<bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
		<property name="driverClassName" value="oracle.jdbc.driver.OracleDriver"></property>
		<property name="url" value="jdbc:oracle:thin:@localhost:1521:orcl"></property>
		<property name="username" value="scott"></property>
		<property name="password" value="tiger"></property>
	</bean>
	
	<!-- 定义Hibernate的SessionFactory -->
    <bean id="sessionFactory" class="org.springframework.orm.hibernate3.LocalSessionFactoryBean">
        <property name="dataSource" ref="dataSource"/>
        
        <!-- mappingResources属性用来列出全部映射文件 -->
        <property name="mappingResources">
            <list>
                <!-- 以下用来列出所有的PO映射文件 -->
                <value>conf/hbm/User.hbm.xml</value>
            </list>
        </property>
         <!-- 定义Hibernate的SessionFactory属性 -->
        <property name="hibernateProperties">
             <props>
                <!-- 指定Hibernate的连接方言 -->
                <prop key="hibernate.dialect">
                	org.hibernate.dialect.Oracle9Dialect
                </prop>
                <!-- 配置启动应用时，是否根据Hibernate映射自动创建数据表 -->
                <prop key="hibernate.hbm2ddl.auto">update</prop>
           </props>
        </property>
    </bean>
</beans>
```
## 使用HibernateTemplate
HibernateTemplate提供持久层访问模板化，它需要提供一个SessionFactory的引用，就可执行持久化
操作。SessionFactory对象既可通过构造参数传入，也可以通过设值方式传入，HibernateTemplate提
供如下三个构造函数
>* HibernateTemplate()构造一个默认的HibernateTemplate实例，
>*   因此创建了HibernateTemplate实例之后，还必须使用
>*   setSessionFactory(SessionFactory sf)为HibernateTemplate注入SessionFactory对象，
>*   然后才可以进行持久化操作。
>* HibernateTemplate(org.hibernate.SessionFactory sessionFactory)
>*     在构造时已经传入SessionFactory对象，创建后立即可以执行持久化操作。
>* HibernateTemplate(org.hibernate.SessionFactory sessionFactory,Boolean allowCreate)
>*     allowCreate参数表明，如果当前线程没有找到一个事务性的Session，
>*     是否需要创建一个非事务的Session
例如:
```java
package spring3.impl;

import org.springframework.orm.hibernate3.HibernateTemplate;

import hibernate3.POJO.VO_user;
import spring3.dao.PersonDao;

public class PersonDaoImpl implements PersonDao{

	//使用Spring注入HibernateTemplate的一个实例
	private HibernateTemplate hibernateTemplate;
	
	
	public HibernateTemplate getHibernateTemplate() {
		return hibernateTemplate;
	}

	public void setHibernateTemplate(HibernateTemplate hibernateTemplate) {
		this.hibernateTemplate = hibernateTemplate;
	}

	@Override
	public void save(VO_user vo) {
		this.hibernateTemplate.save(vo);
	}

	@Override
	public void delete(VO_user vo) {
		this.hibernateTemplate.delete(vo);
	}

	@Override
	public VO_user getUserByID(long id) {
		return this.hibernateTemplate.get(VO_user.class, id);
	}
}

```
利用spring进行注入
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns="http://www.springframework.org/schema/beans"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
	http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">
	
	<!-- 配置Spring数据源 Oracle10g -->
	<bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
		<property name="driverClassName" value="oracle.jdbc.driver.OracleDriver"></property>
		<property name="url" value="jdbc:oracle:thin:@localhost:1521:orcl"></property>
		<property name="username" value="scott"></property>
		<property name="password" value="tiger"></property>
	</bean>
	
	<!-- 定义Hibernate的SessionFactory -->
    <bean id="sessionFactory" class="org.springframework.orm.hibernate3.LocalSessionFactoryBean">
        <property name="dataSource" ref="dataSource"/>
        
        <!-- mappingResources属性用来列出全部映射文件 -->
        <property name="mappingResources">
            <list>
                <!-- 以下用来列出所有的PO映射文件 -->
                <value>conf/hbm/User.hbm.xml</value>
            </list>
        </property>
         <!-- 定义Hibernate的SessionFactory属性 -->
        <property name="hibernateProperties">
             <props>
                <!-- 指定Hibernate的连接方言 -->
                <prop key="hibernate.dialect">
                	org.hibernate.dialect.Oracle9Dialect
                </prop>
                <!-- 配置启动应用时，是否根据Hibernate映射自动创建数据表 -->
                <prop key="hibernate.hbm2ddl.auto">update</prop>
           </props>
        </property>
    </bean>
	
	<bean id="hibernateTemplate" class="org.springframework.orm.hibernate3.HibernateTemplate">
  		<property name="sessionFactory" ref="sessionFactory"></property>
 	</bean>
	
 	<!-- 配置一个Person操作 -->
 	<bean id="person" class="spring3.impl.PersonDaoImpl">
 		<property name="hibernateTemplate" ref="hibernateTemplate"></property>
 	</bean>
 	
</beans>

```
HibernateTemplate提供很多实用的方法来完成基本的操作，比如增加、删除、修改、查询等操作。
大部分情况下，通过HibernateTemplate如下的方法就可以完成大多数DAO对象的CRUD操作。
```java
//删除指定持久化实例
void delete(Object entity)
//删除集合内全部持久化类实例
deleteAll(Collection entitles)
//根据HQL查询字符串来返回实例集合的系列重载方法
find(String queryString)
//根据命名查询返回实例集合的系列重载方法
findByNameQuery(String queryName)
//根据主键加载特定持久化类的实例
get(Class entityClass,Serializable id)
//保存新的实例
save(Object entity)：
//根据实例状态，选择保存或更新
saveOrUpdate(Object entity)：
//更新实例的状态，要钱entity是持久状态
update(object entity)
//设置分页的大小
setMaxResults(int maxResults)
```
## 使用HibernateCallback
使用HibernateTemplate进行数据库访问十分方便，但不是什么时候都未必好用。为了避免
HibernateTemplate灵活性不足的缺陷，HibernateTemplate还提供一种更加灵活的方式来操
作数据，通过这种方式可以完全使用Hibernate的操作方式。HibernateTemplate的灵活访问
方式通过如下俩个方法来完成
	Object execute(HibernateCallback action)
	List executeFind(HibernateCallback action)
这俩个方法都需要一个HibernateCallback实例，HibernateCallback，实例可在任何有效
的Hibernate数据库访问中使用。程序开发者通过HibernateCallback可以完全使用Hibernate
灵活的方式来访问数据库，解决Spring封装Hibernate后灵活性不足的缺陷

# Hibernate
## 映射对象标识符
Hibernate使用对象标识符（OID）来建立内存中的对象和数据库表中记录的对应关系。对象
的OID和数据表的主键对应，Hibernate通过标识符生成器来为主键赋值。Hibernate推荐在数
据表中使用代理主键，既不具备业务含义的字段，代理主键通常为整数类型，因为整数类型
比字符串类型要节省更多的数据库空间在对象-关系映射文件中id元素用来设置对象标识符。
Generator子元素用来设定标识符生成器。
Hibernate提供了标识符生成器接口:identifierGenerator并提供了各种内置对象


