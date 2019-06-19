---
title: springboot整合redis使用cache并未缓存添加缓存时间
date: 2018-07-24 20:50:46
tags:
---
当调用一个缓存方法时会根据相关信息和返回结果作为一个键值对存放在缓存中，等到下次利用同样的参数来调用该方法时将不再执行该方法，而是直接从缓存中获取结果进行返回，这是SpringCache。SpringCache 定义 CacheManager 和 Cache 接口用来统一不同的缓存技术。例如 JCache、 EhCache、 Hazelcast、 Guava、 Redis 等。在使用 Spring 集成 Cache 的时候，需要注册实现的 CacheManager 的 Bean。Spring Boot 自动配置了 JcacheCacheConfiguration、 EhCacheCacheConfiguration、HazelcastCacheConfiguration、GuavaCacheConfiguration、RedisCacheConfiguration、SimpleCacheConfiguration 等.当然也可以使用redis。下面是redis、springcache集成。

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-cache</artifactId>
</dependency>
```

开启缓存技术
在程序的入口中加入@ EnableCaching开启缓存技术：

```java
@SpringBootApplication
@EnableScheduling
@EnableCaching
public class SpringbootApplication{

    public static void main(String[] args) {
        SpringApplication.run(SpringbootApplication.class, args);
    }
}
```
整合相关配置
```java
import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.cache.CacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.Jackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;

@Configuration
public class RedisConfiguration {


    //缓存管理器
    @Bean
    public RedisCacheManager cacheManager(RedisConnectionFactory connectionFactory) {
        RedisCacheManager cacheManager =  RedisCacheManager.create(connectionFactory);
        return cacheManager;
    }


    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory redisConnectionFactory) {
        Jackson2JsonRedisSerializer<Object> jackson2JsonRedisSerializer = new Jackson2JsonRedisSerializer<Object>(Object.class);
        ObjectMapper om = new ObjectMapper();
        RedisSerializer stringSerializer = new StringRedisSerializer();
        om.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        om.enableDefaultTyping(ObjectMapper.DefaultTyping.NON_FINAL);
        jackson2JsonRedisSerializer.setObjectMapper(om);
        RedisTemplate<String, Object> template = new RedisTemplate<String, Object>();
        template.setConnectionFactory(redisConnectionFactory);
        template.setKeySerializer(stringSerializer);
        template.setValueSerializer(jackson2JsonRedisSerializer);
        template.setHashKeySerializer(stringSerializer);
        template.setHashValueSerializer(jackson2JsonRedisSerializer);
        template.afterPropertiesSet();
        return template;
    }

}
```

application.properties中配置Redis连接信息
```java
# Redis数据库索引（默认为0）
spring.redis.database=0
# Redis服务器地址
spring.redis.host=172.31.19.222
# Redis服务器连接端口
spring.redis.port=6379
# Redis服务器连接密码（默认为空）
spring.redis.password=
# 连接池最大连接数（使用负值表示没有限制）
spring.redis.pool.max-active=8
# 连接池最大阻塞等待时间（使用负值表示没有限制）
spring.redis.pool.max-wait=-1
# 连接池中的最大空闲连接
spring.redis.pool.max-idle=8
# 连接池中的最小空闲连接
spring.redis.pool.min-idle=0
# 连接超时时间（毫秒）
spring.redis.timeout=0
```
## 标准的使用SpringCache

###Cacheable
Cacheable中存在有以下几个元素
value (也可使用 cacheNames) : 可看做命名空间，表示存到哪个缓存里了。
key : 表示命名空间下缓存唯一key,使用Spring Expression Language(简称SpEL,详见参考文献[5])生成。
condition : 表示在哪种情况下才缓存结果(对应的还有unless,哪种情况不缓存),同样使用SpEL
例子:
```java
@Override
@Cacheable(value = "user#100", key = "#userId")
public UserInfo userInfo(String userId) {
    return new UserInfo(userId,"222",new Date());
}
```

### CacheEvict
CacheEvict 中存在有以下几个元素 
- value (也可使用 cacheNames) : 同Cacheable注解，可看做命名空间。表示删除哪个命名空间中的缓存 
- allEntries: 标记是否删除命名空间下所有缓存，默认为false 
- key: 同Cacheable注解，代表需要删除的命名空间下唯一的缓存key。
例子:
```java
@CacheEvict(value = "models", allEntries = true)
@Scheduled(fixedDelay = 10000)
public void deleteFromRedis() {
}

@CacheEvict(value = "models", key = "#name")
public void deleteFromRedis(String name) {
}
```
例子里的注解 @

例子中第一段，与 @Scheduled 注解同时使用，每十秒删除命名空间name下所有的缓存。

第二段，调用此方法后删除命名空间models下, key == 参数 的缓存 
同样含有unless与condition

### CachePut
例子
```java
@CachePut(value = "models", key = "#name")
public TestModel saveModel(String name, String address) {
    return new TestModel(name, address);
}
```

## 为Cacheable添加超时时间
由于Cacheable是常见业务系统最常使用的方式，但是其也不是相当完美。例如统计一个活动的统计人数，执行一个count语句即可，但是如果所有的请求全部打到数据库，对数据库造成不小的压力，但是现有的Cacheable不能完美的实现，比如将count语句执行结果缓存30秒，30秒后重新执行语句查询并缓存下。从整合中可以看出org.springframework.data.redis.cache.RedisCacheManager就是相关的实现类。查阅该类可以看到如下相关核心实现。
```java
    protected RedisCache createRedisCache(String name, @Nullable RedisCacheConfiguration cacheConfig) {
        return new RedisCache(name, this.cacheWriter, cacheConfig != null ? cacheConfig : this.defaultCacheConfig);
    }
```
有此可以看出利用redis实现的具体类为org.springframework.data.redis.cache.RedisCache。在该类可以看出,具体的实现。
```java
public void put(Object key, @Nullable Object value) {
    Object cacheValue = this.preProcessCacheValue(value);
    if (!this.isAllowNullValues() && cacheValue == null) {
        throw new IllegalArgumentException(String.format(
        	"Cache '%s' does not allow 'null' values. Avoid storing null via '@Cacheable(unless=\"#result ="+
        	"= null\")' or configure RedisCache to allow 'null' via RedisCacheConfiguration.", this.name));
    } else {
        this.cacheWriter.put(this.name, this.createAndConvertCacheKey(key), this.serializeCacheValue(cacheValue), this.cacheConfig.getTtl());
    }
}
```
可以看出上处的实现本来就是支持缓存时间的配置，但是其他配置会作用于所有的键值。因此不是很灵活，因此可以在此处进行相应的修改，例如鄙人的修改方式以cache的name后面添加#缓存秒数。因此可以按照如下方式修改。
```java
public class RedisCacheImpl extends RedisCache {
    private final String name;
    private final RedisCacheWriter cacheWriter;
    private final RedisCacheConfiguration cacheConfig;
    private final ConversionService conversionService;
    /**
     * Create new {@link RedisCache}.
     *
     * @param name        must not be {@literal null}.
     * @param cacheWriter must not be {@literal null}.
     * @param cacheConfig must not be {@literal null}.
     */
    protected RedisCacheImpl(String name, RedisCacheWriter cacheWriter, RedisCacheConfiguration cacheConfig) {
        super(name, cacheWriter, cacheConfig);
        Assert.notNull(name, "Name must not be null!");
        Assert.notNull(cacheWriter, "CacheWriter must not be null!");
        Assert.notNull(cacheConfig, "CacheConfig must not be null!");

        this.name = name;
        this.cacheWriter = cacheWriter;
        this.cacheConfig = cacheConfig;
        this.conversionService = cacheConfig.getConversionService();
    }

    private byte[] createAndConvertCacheKey(Object key) {
        return serializeCacheKey(createCacheKey(key));
    }

    @Override
    public void put(Object key, @Nullable Object value) {
        Object cacheValue = preProcessCacheValue(value);

        if (!isAllowNullValues() && cacheValue == null) {
            throw new IllegalArgumentException(String.format(
                    "Cache '%s' does not allow 'null' values. Avoid storing null via '@Cacheable(unless=\""+
                    "#result == null\")' or configure RedisCache to allow 'null' via RedisCacheConfiguration.",
                    name));
        }
        if(name.contains("#")){
            try{
                Long ttlTime = Long.parseLong(name.split("#")[1]);
                if(ttlTime > 0){
                    cacheWriter.put(name, createAndConvertCacheKey(key), serializeCacheValue(cacheValue), Duration.ofSeconds(ttlTime));
                }else{
                    cacheWriter.put(name, createAndConvertCacheKey(key), serializeCacheValue(cacheValue), cacheConfig.getTtl());
                }
            }catch (Exception e){
                throw new IllegalArgumentException(String.format(
                        "Cache '%s' does not allow 'null' values. Avoid storing null via '@Cacheable(unless=\""+
                        "#result == null\")' or configure RedisCache to allow 'null' via RedisCacheConfiguration.",
                        name));
            }
        }else{
            cacheWriter.put(name, createAndConvertCacheKey(key), serializeCacheValue(cacheValue), cacheConfig.getTtl());
        }

    }
}
```
