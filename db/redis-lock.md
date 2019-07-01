title: 基于redis实现分布式锁
date: 2017-02-13 20:26:31
tags:
    - Java
    - spring
    - redis
categories: Java
---
总是那么的后知后觉，听说明天有是一个情人节。那句“送人玫瑰，收留余香”不知道已经陪伴我多少年了。明日终究还是和电脑过呢！鬼知道为什么男女平衡咋了！

年初的时候感觉手上的事情真心很多，发现有些事情真心不是需要技术就能搞定的。就拿项目重构来说，项目不重构只能是119到处救火，如果重构需要有大的担当。有时候这个平衡是很难掌握的。这次就来说说因为分布式锁引起的一次惨案吧。

公司是为运营商做APP的，后端采用大众化的nginx+多路tomcat。没有做动静分离（不可想象）。当然更不可想象的是既然部署了多路tomcat但是没有做分布式锁。所以悲剧很容易诞生。

按照中国这中量产化出来的码农一般下面的这种编码方式是很常见的。
```java
  @Override
    public void disableDistributedSave() {
        Map<Object, Object> params = ImmutableMap.builder()
                .put("starttime", "2017-02-10 00:00:00")
                .put("businessname","不支持分布式锁")
                .build();
        //先查询是否存在相应的记录，如果不存在则插入。
        //当然有些人此处会添加synchronized关键字。
        int count = businessLogService.count(params);
        if (count < 1) {
            BusinessLog log = new BusinessLog();
            log.setId(RandomUtil.uuid());
            log.setStartTime(new Date());
            log.setBusinessName("不支持分布式锁");
            businessLogService.save(log);
        }
    }
```
上面的代码虽然看着没问题。不过只要稍微有点眼力的都能看出什么问题，更别说部署到多路tomcat下了。非要不多说了，此处可以使用分布式锁解决这类问题。分布式锁都是借助第三方来管理锁，以达到多应用直接共同享有一把锁。业内比较常用且轻量级的就是基于redis实现。
## 基于redis锁的实现原理
Redis为单进程单线程模式，采用队列模式将并发访问变成串行访问，且多客户端对Redis的连接并不存在竞争关系。其次Redis提供一些命令SETNX，GETSET，可以方便实现分布式锁机制。
加锁实现

SETNX 可以直接加锁操作，比如说对某个关键词foo加锁，客户端可以尝试
SETNX foo.lock <current unix time>

如果返回1，表示客户端已经获取锁，可以往下操作，操作完成后，通过
DEL foo.lock

命令来释放锁。
如果返回0，说明foo已经被其他客户端上锁，如果锁是非堵塞的，可以选择返回调用。如果是堵塞调用调用，就需要进入以下个重试循环，直至成功获得锁或者重试超时。理想是美好的，现实是残酷的。仅仅使用SETNX加锁带有竞争条件的，在某些特定的情况会造成死锁错误。

处理死锁

在上面的处理方式中，如果获取锁的客户端端执行时间过长，进程被kill掉，或者因为其他异常崩溃，导致无法释放锁，就会造成死锁。所以，需要对加锁要做时效性检测。因此，我们在加锁时，把当前时间戳作为value存入此锁中，通过当前时间戳和Redis中的时间戳进行对比，如果超过一定差值，认为锁已经时效，防止锁无限期的锁下去，但是，在大并发情况，如果同时检测锁失效，并简单粗暴的删除死锁，再通过SETNX上锁，可能会导致竞争条件的产生，即多个客户端同时获取锁。

C1获取锁，并崩溃。C2和C3调用SETNX上锁返回0后，获得foo.lock的时间戳，通过比对时间戳，发现锁超时。
C2 向foo.lock发送DEL命令。
C2 向foo.lock发送SETNX获取锁。
C3 向foo.lock发送DEL命令，此时C3发送DEL时，其实DEL掉的是C2的锁。
C3 向foo.lock发送SETNX获取锁。

此时C2和C3都获取了锁，产生竞争条件，如果在更高并发的情况，可能会有更多客户端获取锁。所以，DEL锁的操作，不能直接使用在锁超时的情况下，幸好我们有GETSET方法，假设我们现在有另外一个客户端C4，看看如何使用GETSET方式，避免这种情况产生。

C1获取锁，并崩溃。C2和C3调用SETNX上锁返回0后，调用GET命令获得foo.lock的时间戳T1，通过比对时间戳，发现锁超时。
C4 向foo.lock发送GESET命令，
GETSET foo.lock <current unix time>
并得到foo.lock中老的时间戳T2

如果T1=T2，说明C4获得时间戳。
如果T1!=T2，说明C4之前有另外一个客户端C5通过调用GETSET方式获取了时间戳，C4未获得锁。只能sleep下，进入下次循环中。

现在唯一的问题是，C4设置foo.lock的新时间戳，是否会对锁产生影响。其实我们可以看到C4和C5执行的时间差值极小，并且写入foo.lock中的都是有效时间错，所以对锁并没有影响。
为了让这个锁更加强壮，获取锁的客户端，应该在调用关键业务时，再次调用GET方法获取T1，和写入的T0时间戳进行对比，以免锁因其他情况被执行DEL意外解开而不知。以上步骤和情况，很容易从其他参考资料中看到。客户端处理和失败的情况非常复杂，不仅仅是崩溃这么简单，还可能是客户端因为某些操作被阻塞了相当长时间，紧接着 DEL 命令被尝试执行(但这时锁却在另外的客户端手上)。也可能因为处理不当，导致死锁。还有可能因为sleep设置不合理，导致Redis在大并发下被压垮。最为常见的问题还有

GET返回nil时应该走那种逻辑？

第一种走超时逻辑
C1客户端获取锁，并且处理完后，DEL掉锁，在DEL锁之前。C2通过SETNX向foo.lock设置时间戳T0 发现有客户端获取锁，进入GET操作。
C2 向foo.lock发送GET命令，获取返回值T1(nil)。
C2 通过T0>T1+expire对比，进入GETSET流程。
C2 调用GETSET向foo.lock发送T0时间戳，返回foo.lock的原值T2
C2 如果T2=T1相等，获得锁，如果T2!=T1，未获得锁。

第二种情况走循环走setnx逻辑
C1客户端获取锁，并且处理完后，DEL掉锁，在DEL锁之前。C2通过SETNX向foo.lock设置时间戳T0 发现有客户端获取锁，进入GET操作。
C2 向foo.lock发送GET命令，获取返回值T1(nil)。
C2 循环，进入下一次SETNX逻辑

两种逻辑貌似都是OK，但是从逻辑处理上来说，第一种情况存在问题。当GET返回nil表示，锁是被删除的，而不是超时，应该走SETNX逻辑加锁。走第一种情况的问题是，正常的加锁逻辑应该走SETNX，而现在当锁被解除后，走的是GETST，如果判断条件不当，就会引起死锁，很悲催，我在做的时候就碰到了，具体怎么碰到的看下面的问题

GETSET返回nil时应该怎么处理？

C1和C2客户端调用GET接口，C1返回T1，此时C3网络情况更好，快速进入获取锁，并执行DEL删除锁，C2返回T2(nil)，C1和C2都进入超时处理逻辑。
C1 向foo.lock发送GETSET命令，获取返回值T11(nil)。
C1 比对C1和C11发现两者不同，处理逻辑认为未获取锁。
C2 向foo.lock发送GETSET命令，获取返回值T22(C1写入的时间戳)。
C2 比对C2和C22发现两者不同，处理逻辑认为未获取锁。

此时C1和C2都认为未获取锁，其实C1是已经获取锁了，但是他的处理逻辑没有考虑GETSET返回nil的情况，只是单纯的用GET和GETSET值就行对比，至于为什么会出现这种情况？一种是多客户端时，每个客户端连接Redis的后，发出的命令并不是连续的，导致从单客户端看到的好像连续的命令，到Redis server后，这两条命令之间可能已经插入大量的其他客户端发出的命令，比如DEL,SETNX等。第二种情况，多客户端之间时间不同步，或者不是严格意义的同步。

时间戳的问题

我们看到foo.lock的value值为时间戳，所以要在多客户端情况下，保证锁有效，一定要同步各服务器的时间，如果各服务器间，时间有差异。时间不一致的客户端，在判断锁超时，就会出现偏差，从而产生竞争条件。
锁的超时与否，严格依赖时间戳，时间戳本身也是有精度限制，假如我们的时间精度为秒，从加锁到执行操作再到解锁，一般操作肯定都能在一秒内完成。这样的话，我们上面的CASE，就很容易出现。所以，最好把时间精度提升到毫秒级。这样的话，可以保证毫秒级别的锁是安全的。

分布式锁的问题

1：必要的超时机制：获取锁的客户端一旦崩溃，一定要有过期机制，否则其他客户端都降无法获取锁，造成死锁问题。
2：分布式锁，多客户端的时间戳不能保证严格意义的一致性，所以在某些特定因素下，有可能存在锁串的情况。要适度的机制，可以承受小概率的事件产生。
3：只对关键处理节点加锁，良好的习惯是，把相关的资源准备好，比如连接数据库后，调用加锁机制获取锁，直接进行操作，然后释放，尽量减少持有锁的时间。
4：在持有锁期间要不要CHECK锁，如果需要严格依赖锁的状态，最好在关键步骤中做锁的CHECK检查机制，但是根据我们的测试发现，在大并发时，每一次CHECK锁操作，都要消耗掉几个毫秒，而我们的整个持锁处理逻辑才不到10毫秒，玩客没有选择做锁的检查。
5：sleep学问，为了减少对Redis的压力，获取锁尝试时，循环之间一定要做sleep操作。但是sleep时间是多少是门学问。需要根据自己的Redis的QPS，加上持锁处理时间等进行合理计算。

## 在java中实现基于redis的锁
```java
package com.opslab.web.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.data.redis.connection.RedisConnection;
import org.springframework.data.redis.core.RedisCallback;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.StringRedisSerializer;
/**
 * 实现分布式锁
 */
public class RedisLockUtil {
    private static Logger logger = LoggerFactory.getLogger(RedisLockUtil.class);

    private RedisTemplate redisTemplate;

    private static final int DEFAULT_ACQUIRY_RESOLUTION_MILLIS = 100;

    /**
     * Lock key path.
     */
    private String lockKey;

    /**
     * 锁超时时间，防止线程在入锁以后，无限的执行等待
     */
    private int expireMsecs = 60 * 1000;

    /**
     * 锁等待时间，防止线程饥饿
     */
    private int timeoutMsecs = 10 * 1000;

    /**
     * 锁到期时间
     */
    private String expiresStr="";

    private volatile boolean locked = false;

    /**
     * Detailed constructor with default acquire timeout 10000 msecs and lock expiration of 60000 msecs.
     *
     * @param lockKey lock key (ex. account:1, ...)
     */
    public RedisLockUtil(RedisTemplate redisTemplate, String lockKey) {
        this.redisTemplate = redisTemplate;
        this.lockKey = "LOCK_"+lockKey;
    }

    /**
     * Detailed constructor with default lock expiration of 60000 msecs.
     *
     */
    public RedisLockUtil(RedisTemplate redisTemplate, String lockKey, int timeoutMsecs) {
        this(redisTemplate, lockKey);
        this.timeoutMsecs = timeoutMsecs;
    }

    /**
     * Detailed constructor.
     *
     */
    public RedisLockUtil(RedisTemplate redisTemplate, String lockKey, int timeoutMsecs, int expireMsecs) {
        this(redisTemplate, lockKey, timeoutMsecs);
        this.expireMsecs = expireMsecs;
    }

    /**
     * @return lock key
     */
    public String getLockKey() {
        return lockKey;
    }

    private String get(final String key) {
        Object obj = null;
        try {
            obj = redisTemplate.execute(new RedisCallback<Object>() {
                @Override
                public Object doInRedis(RedisConnection connection) throws DataAccessException {
                    StringRedisSerializer serializer = new StringRedisSerializer();
                    byte[] data = connection.get(serializer.serialize(key));
                    connection.close();
                    if (data == null) {
                        return null;
                    }
                    return serializer.deserialize(data);
                }
            });
        } catch (Exception e) {
            logger.error("get redis error, key : {}", key);
        }
        return obj != null ? obj.toString() : null;
    }

    private boolean setNX(final String key, final String value) {
        Object obj = null;
        try {
            obj = redisTemplate.execute(new RedisCallback<Object>() {
                @Override
                public Object doInRedis(RedisConnection connection) throws DataAccessException {
                    StringRedisSerializer serializer = new StringRedisSerializer();
                    Boolean success = connection.setNX(serializer.serialize(key), serializer.serialize(value));
                    connection.close();
                    return success;
                }
            });
        } catch (Exception e) {
            logger.error("setNX redis error, key : {}", key);
        }
        return obj != null ? (Boolean) obj : false;
    }

    private String getSet(final String key, final String value) {
        Object obj = null;
        try {
            obj = redisTemplate.execute(new RedisCallback<Object>() {
                @Override
                public Object doInRedis(RedisConnection connection) throws DataAccessException {
                    StringRedisSerializer serializer = new StringRedisSerializer();
                    byte[] ret = connection.getSet(serializer.serialize(key), serializer.serialize(value));
                    connection.close();
                    return serializer.deserialize(ret);
                }
            });
        } catch (Exception e) {
            logger.error("setNX redis error, key : {}", key);
        }
        return obj != null ? (String) obj : null;
    }

    /**
     * 获得 lock.
     * 实现思路: 主要是使用了redis 的setnx命令,缓存了锁.
     * reids缓存的key是锁的key,所有的共享, value是锁的到期时间(注意:这里把过期时间放在value了,没有时间上设置其超时时间)
     * 执行过程:
     * 1.通过setnx尝试设置某个key的值,成功(当前没有这个锁)则返回,成功获得锁
     * 2.锁已经存在则获取锁的到期时间,和当前时间比较,超时的话,则设置新的值
     *
     * @return true if lock is acquired, false acquire timeouted
     * @throws InterruptedException in case of thread interruption
     */
    public synchronized boolean lock() throws InterruptedException {
        int timeout = timeoutMsecs;
        while (timeout >= 0) {
            //锁到期时间
            expiresStr = String.valueOf(System.currentTimeMillis() + expireMsecs + 1);
            if (this.setNX(lockKey, expiresStr)) {
                // lock acquired
                locked = true;
                return true;
            }

            String currentValueStr = this.get(lockKey); //redis里的时间
            if (currentValueStr != null && Long.parseLong(currentValueStr) < System.currentTimeMillis()) {
                //判断是否为空，不为空的情况下，如果被其他线程设置了值，则第二个条件判断是过不去的
                // lock is expired

                String oldValueStr = this.getSet(lockKey, expiresStr);
                //获取上一个锁到期时间，并设置现在的锁到期时间，
                //只有一个线程才能获取上一个线上的设置时间，因为jedis.getSet是同步的
                if (oldValueStr != null && oldValueStr.equals(currentValueStr)) {
                    //防止误删（覆盖，因为key是相同的）了他人的锁——这里达不到效果，这里值会被覆盖，但是因为什么相差了很少的时间，所以可以接受

                    //[分布式的情况下]:如过这个时候，多个线程恰好都到了这里，但是只有一个线程的设置值和当前值相同，他才有权利获取锁
                    // lock acquired
                    locked = true;
                    return true;
                }
            }
            timeout -= DEFAULT_ACQUIRY_RESOLUTION_MILLIS;

            /*
                延迟100 毫秒,  这里使用随机时间可能会好一点,可以防止饥饿进程的出现,即,当同时到达多个进程,
                只会有一个进程获得锁,其他的都用同样的频率进行尝试,后面有来了一些进行,也以同样的频率申请锁,这将可能导致前面来的锁得不到满足.
                使用随机的等待时间可以一定程度上保证公平性
             */
            Thread.sleep(DEFAULT_ACQUIRY_RESOLUTION_MILLIS);

        }
        return false;
    }


    /**
     * Acqurired lock release.
     */
    public synchronized void unlock() {
        if (locked) {
            if(expiresStr != null && expiresStr.equals(redisTemplate.opsForValue().get(lockKey))){
                redisTemplate.delete(lockKey);
                locked = false;
            }
        }
    }

}

```

## 测试基于redis的分布式锁
```java
//service
package com.opslab.web.service.impl;

import com.google.common.collect.ImmutableMap;
import com.opslab.web.model.BusinessLog;
import com.opslab.web.service.BusinessLogService;
import com.opslab.web.service.DistributedService;
import com.opslab.web.util.MD5Util;
import com.opslab.web.util.RandomUtil;
import com.opslab.web.util.RedisLockUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.io.Serializable;
import java.util.Date;
import java.util.Map;

/**
 * 用于测试分布式锁
 */
@Service("distributedService")
public class DistributedServiceImpl extends SuperServiceImpl implements DistributedService{
    @Autowired
    private RedisTemplate<Serializable,Serializable> redisTemplate;

    @Autowired
    private BusinessLogService businessLogService;

    @Override
    public void disableDistributedSave() {
        Map<Object, Object> params = ImmutableMap.builder()
                .put("starttime", "2017-02-10 00:00:00")
                .put("businessname","不支持分布式锁")
                .build();
        int count = businessLogService.count(params);
        if (count < 1) {
            BusinessLog log = new BusinessLog();
            log.setId(RandomUtil.uuid());
            log.setStartTime(new Date());
            log.setBusinessName("不支持分布式锁");
            businessLogService.save(log);
        }
    }

    @Override
    public void distributedSave() {
        String key = MD5Util.MD5("com.opslab.web.service.impl.DistributedServiceImpl.distributedSave");
        RedisLockUtil lock = new RedisLockUtil(redisTemplate, key, 10000, 20000);
        try {
            if(lock.lock()) {
                //需要加锁的代码
                Map<Object, Object> params = ImmutableMap.builder()
                        .put("starttime", "2017-02-10 00:00:00")
                        .put("businessname","支持分布式锁")
                        .build();
                int count = businessLogService.count(params);
                if ( count < 1) {
                    BusinessLog log = new BusinessLog();
                    log.setId(RandomUtil.uuid());
                    log.setStartTime(new Date());
                    log.setBusinessName("支持分布式锁");
                    businessLogService.save(log);
                }
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }finally {
            lock.unlock();
        }

    }
}

//controller
package com.opslab.web.action;

import com.opslab.web.action.model.UIFactory;
import com.opslab.web.action.model.UIResult;
import com.opslab.web.model.ScheduleTask;
import com.opslab.web.service.DistributedService;
import com.opslab.web.util.JacksonUtil;
import org.quartz.Scheduler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 测试分布式锁
 */
@Controller
@RequestMapping("/distributedlock")
public class DistributedController {
    @Autowired
    private DistributedService service;

    @RequestMapping("disable")
    @ResponseBody
    public UIResult disable(){
        service.disableDistributedSave();
        return UIFactory.success();
    }

    @RequestMapping("able")
    @ResponseBody
    public UIResult able(){
        service.distributedSave();
        return UIFactory.success();
    }
}

```
将上述代码部署到多路tomcat下。然后利用nginx做负载。不需要其他的多么复杂的测试利用下面的一段js即可测试出效果。
```javascript
/**
 * 测试是否支持分布式锁
 * 脚本执行完后查询一下语句查看其记录是否只有一条
 * select * from ops_rt_businesslog t where t.business_name='支持分布式锁';
 */
function distributed() {
    for (var i = 0; i < 10000; i++) {
        $.ajax({
            type: "POST",
            url: '/Schedule/distributedlock/able',
            async: true,
            success: function (data) {
                if (data == "success") {
                    console.log("success");
                }
            }
        });
    }
}

/**
 * 测试是否支持分布式锁
 * 脚本执行完后查询一下语句查看其记录是否只有一条
 * select * from ops_rt_businesslog t where t.business_name='不支持分布式锁';
 */
function disabledistributed() {
    for (var i = 0; i < 10000; i++) {
        $.ajax({
            type: "POST",
            url: '/Schedule/distributedlock/disable',
            async: true,
            success: function (data) {
                if (data == "success") {
                    console.log("success");
                }
            }
        });
    }
}
```