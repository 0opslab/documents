springboot确实简化了Java项目开发的不少繁琐的步骤，并且使代码更加看着更加友好了。另外spring的全注解开发摒弃了繁琐蛋疼的xml配置，因此相对单单这件事情来说这是一件皆大欢喜的事情。用惯了注解，想在任何语言中都想写个注解。好了不跑题了，说说springboot的AOP，全注解的那种。

AOP可以说是层的一种实现，更是HOOK大法在Java里面的一种表现形式。springboot中使用AOP还是挺简单的，直接引入spring-boot-starter-aop即可，不需要额外的注解去启动AOP。默认就是启动的。

```xml
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-aop</artifactId>
</dependency>
```

### 相关的注解

```java
//正常秩序:around -> before->method ->around -> after -> afterReturning
//连接点，被AOP拦截的类或者方法
@Joinpoint
//表明是AOP
@Aspect
//添加切入点
@Pointcut 
//前置通知
@Before 
//后置通知
@After 
//环绕通知
@Around 
//返回后通知
@AfterReturning 
//异常通知
@AfterReturning 
//引入新的方法
@DeclareParents
```

下面是一个简单的aspect类

```java
package test;
 
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Component;
 
@Component
@Aspect
public class Aspect2 {
 
    @Before(value = "test.PointCuts.aopDemo()")
    public void before(JoinPoint joinPoint) {
        System.out.println("[Aspect2] before advise");
    }
 
    @Around(value = "test.PointCuts.aopDemo()")
    public void around(ProceedingJoinPoint pjp) throws Throwable{
        System.out.println("[Aspect2] around advise 1");
        pjp.proceed();
        System.out.println("[Aspect2] around advise2");
    }
 
    @AfterReturning(value = "test.PointCuts.aopDemo()")
    public void afterReturning(JoinPoint joinPoint) {
        System.out.println("[Aspect2] afterReturning advise");
    }
 
    @AfterThrowing(value = "test.PointCuts.aopDemo()")
    public void afterThrowing(JoinPoint joinPoint) {
        System.out.println("[Aspect2] afterThrowing advise");
    }
 
    @After(value = "test.PointCuts.aopDemo()")
    public void after(JoinPoint joinPoint) {
        System.out.println("[Aspect2] after advise");
    }
}
```

#### Pointcut 

spring 的AOP支持9种切入点表达式的写法

* execute表达式

  早起使用最多的一种方式

  execution(public * *(..))		//拦截所有的公共方法

  execution(* set*(..))			  //拦截所有以set开头的方法

  execution(* com.xyz.service.AccountService.*(..))  //拦截指定接口的所有方法

  execution(* com.xyz.service.*.*(..))			//拦截包中定义的方法，不包含子包中的方法

  execution(* com.xyz.service..*.*(..)) 		 //拦截包或者子包中定义的方法

* within

  within(com.xyz.service.*) //拦截包中任意方法，不包含子包中的方法

  within(com.xyz.service..*)//拦截包或者子包中定义的方法

* this

  代理对象为指定的类型会被拦截

* target

  目标对象为指定的类型被拦截

* args

  args(com.ms.aop.args.demo1.UserModel)匹配方法中的参数

* @target

  @target(com.ms.aop.jtarget.Annotation1)目标对象中包含com.ms.aop.jtarget.Annotation1注解，调用该目标对象的任意方法都会被拦截

* @within

  @within(com.ms.aop.jwithin.Annotation1)声明有com.ms.aop.jwithin.Annotation1注解的类中的所有方法都会被拦截

* @annotation

  @annotation(com.ms.aop.jannotation.demo2.Annotation1)//被调用的方法包含指定的注解

* @args

  @args(com.ms.aop.jargs.demo1.Anno1)匹配1个参数，且第1个参数所属的类中有Anno1注解

## 实例

利用AOP是写rediscache注解。Spring-data-redis本身就支持类似的注解，但是其不能设置失效时间，如要支持需要修改源码，可以看之前的文章。

```java
package com.imonsoon.system.annotation;

import java.lang.annotation.*;

@Inherited
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface BusRedisCache {
    /**
     * 缓存值主键前缀
     */
    String prefix ();

    /**
     * 缓存时间默认-1 单位未秒
     */
    long expire () default -1L;
}
```



```java
package com.imonsoon.system.aspect;

import com.imonsoon.system.annotation.BusMobile;
import com.imonsoon.system.annotation.BusRedisCache;
import com.imonsoon.system.component.RedisComponent;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;
import java.lang.reflect.Parameter;

@Aspect
@Component
@Order(2)
public class RedisCacheAspect {

    private static Logger logger = LoggerFactory.getLogger(RedisCacheAspect.class);

    @Autowired
    private RedisComponent redisComponent;

    @Around("@annotation(com.imonsoon.system.annotation.BusRedisCache)")
    public Object logWrited(ProceedingJoinPoint point) throws Throwable {
        String prefix = "";
        Long expire = 0L;
        String mobile = "";
        Class returnType = null;
        try {
            Object[] args = point.getArgs();
            Class<?>[] argTypes = new Class[args.length];
            for (int i = 0; i < args.length; i++) {
                argTypes[i] = args[i].getClass();
            }
            Method method = point.getTarget().getClass()
                    .getMethod(point.getSignature().getName(), argTypes);
            returnType = method.getReturnType();
            BusRedisCache ma = method.getAnnotation(BusRedisCache.class);
            prefix = ma.prefix();
            expire = ma.expire();

            Parameter[] parameters = method.getParameters();
            for (int i = 0; i < parameters.length; i++) {
                Parameter parameter = parameters[i];
                if (parameter.isAnnotationPresent(BusMobile.class)) {
                    mobile = args[i].toString();
                }
            }
            if (mobile == null || mobile.length() != 11) {
                return point.proceed();
            }
            String redisKey = (prefix + mobile).toUpperCase();

            Object object = redisComponent.get(redisKey);
            if (object != null && equalsClass(object.getClass().getName(), returnType.getName())) {
                logger.debug("RedisCacheAspect %s  key hit");
                return object;
            }
            Object objc = point.proceed();
            if (objc != null) {
                if (expire < 0) {
                    redisComponent.set(redisKey, objc);
                } else if (expire > 0) {
                    redisComponent.set(redisKey, objc, expire);
                }
            }
            return objc;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static boolean equalsClass(String className, String className1) {
        if (className.equals(className1)) {
            return true;
        }
        //System.out.println(className+"====>"+className1);
        switch (className) {
            case "java.lang.Boolean":
                return className1.equals("boolean");
            case "java.lang.Byte":
                return className1.equals("byte");
            case "java.lang.Integer":
                return className1.equals("int");
            case "java.lang.Long":
                return className1.equals("long");
            case "java.lang.Float":
                return className1.equals("flaot");
            case "java.lang.Double":
                return className1.equals("double");
            default:
                return className.equals(className1);
        }
    }
}

```

```java
    @BusRedisCache(prefix = App.REDIXPREFIX_DBCONFIGBEAN, expire = 3600L)
    public String confKey(String key){
        ConfigBeanMapper mapper = this.getBaseMapper();
        ConfigBean bean = mapper.selectById(key);
        if(bean != null){
            return bean.getContent();
        }
        return null;
    }
```

