title: 一个通用的J2EE-service层和dao层的封装抽象类
date: 2016-01-06 21:40:20
author: opslab
tags:
    - hibernate
    - spring
    - J2EE
categories: Java
---
J2EE的分层等设计模式使得J2EE的项目代码维护相对PHP来说提高了不少。但是J2EE不对是Java的包管理机制相对来时很是操蛋
如果Java的包管理能像python一样pip install xxx然后本机到处都可以轻松的使用，并且解决包的依赖和冲突关系我想应该能
减少不少Java的开发成本。当然maven算是个鸡肋吧。尤其是这网络环境下，闲话不扯了，进入正文！直接上代码
# 分页实体
```java
package core.opslab.entity;

import core.opslab.constant;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * 一个分页对象
 */
public class Page {
    // 要返回的某一页的记录列表
    @Getter @Setter private List<Object> list = new ArrayList<Object>();

    // 总记录数
    @Getter @Setter private int allRow = 0;

    // 总页数
    @Getter @Setter private int totalPage = 0;

    // 当前页
    @Getter private int currentPage = 1;

    // 每页记录数
    @Getter @Setter private int pageSize = constant.HIBERNATE_PAGESIZE;

    // 链接增加的字符参数
    @Getter @Setter private String strpage;

    @Getter @Setter private int offset = 1;

    // 是否为第一页
    @Setter private boolean isFirstPage = false;

    // 是否为最后一页
    @Setter private boolean isLastPage = false;

    // 是否有前一页
    @Setter private boolean hasPreviousPage = false;

    // 是否有下一页
    @Setter private boolean hasNextPage = false;

    public void setCurrentPage(int p) {
        if (p <= 0) {
            this.currentPage = 1;
        } else {
            this.currentPage = p;
        }
    }

    public boolean isFirstPage() {
        // 如是当前页是第1页
        return currentPage == 1;
    }
    public boolean isLastPage() {
        //如果当前页是最后一页
        return currentPage == totalPage;
    }
    public boolean isHasPreviousPage() {
        //只要当前页不是第1页
        return currentPage != 1;
    }
    public boolean isHasNextPage() {
        if(totalPage == 0){
            return false;
        }else{
            return currentPage != totalPage;
        }
    }

    public void init(){
        this.isFirstPage = isFirstPage();
        this.isLastPage = isLastPage();
        this.hasPreviousPage = isHasPreviousPage();
        this.hasNextPage = isHasNextPage();
        totalPage = allRow % pageSize == 0 ? allRow/pageSize : allRow/pageSize+1;
        offset = pageSize*(currentPage-1);
    }

    @Override
    public String toString() {
        int size = 0;
        if(list != null){
            size = list.size();
        }
        return "Page{" +
                "list.size()=" + size +
                ", allRow=" + allRow +
                ", totalPage=" + totalPage +
                ", currentPage=" + currentPage +
                ", pageSize=" + pageSize +
                ", strpage='" + strpage + '\'' +
                ", offset=" + offset +
                ", isFirstPage=" + isFirstPage +
                ", isLastPage=" + isLastPage +
                ", hasPreviousPage=" + hasPreviousPage +
                ", hasNextPage=" + hasNextPage +
                '}';
    }
}

```

# DAO层的封装

```java
package core.opslab.dao;

import core.opslab.entity.Page;
import core.opslab.exception.DataAccessException;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Objects;
/**
 * 封装DAO常用的操作
 */
public interface SupportDao<T,ID extends Serializable> {
    //保存实体
    public void saveEntity(T t) throws DataAccessException;

    //更新实体
    public void updateEntity(T t) throws DataAccessException;

    //保存或更新
    public void saveOrUpdateEntity(T t) throws DataAccessException;

    //删除实体
    public void deleteEntity(T t) throws DataAccessException;
    public void deleteEntityById(ID id) throws DataAccessException;
    public void deleteAll(Collection<T> entities) throws DataAccessException;
    //加载实体
    public T loadEntity(ID id) throws DataAccessException;
    public T getEntity(ID id) throws DataAccessException;

    //通过HQL查询单个实体
    public T queryEntityFirst(String hql) throws DataAccessException;
    public T queryEntiryFirst(String hql,Objects ...params) throws DataAccessException;
    public T queryEntityLast(String hql) throws DataAccessException;
    public T queryEntityLast(String hql,Objects ...params) throws DataAccessException;


    //通过HQL获得实体列表
    public List<T> queryEntityListByHQL(String hql,Object ...params) throws DataAccessException;

    //通过SQL获得提示列表
    public List<T> queryEntityListBySQL(String sql,Object ...params) throws DataAccessException;

    //统计一个HQL语句执行结果的总记录数
    public int count(String hql)throws DataAccessException;

    public int count(String hql,Object ...params)throws DataAccessException;

    //以分页的方式获得实体
    public Page query(String hql,String countHql,int page,  int size) throws DataAccessException;

    public Page query(String hql,String countHql,int page,int size, Object ...params) throws DataAccessException;
}

```
# DAO层的实现
```Java
    package core.opslab.dao.impl;

    import core.opslab.dao.SupportDao;
    import core.opslab.entity.Page;
    import core.opslab.exception.DataAccessException;
    import lombok.Getter;
    import lombok.Setter;
    import org.hibernate.Query;
    import org.hibernate.Session;
    import org.hibernate.SessionFactory;

    import javax.annotation.Resource;
    import java.io.Serializable;
    import java.lang.reflect.ParameterizedType;
    import java.util.Collection;
    import java.util.List;
    import java.util.Objects;

    /**
     * 封装DAO常用的操作主要用于继承
     */
    public class SupportDaoImpl<T, ID extends Serializable> implements SupportDao<T, ID> {
        /**
         * 构造时初始（获取泛型）
         */
        public SupportDaoImpl() {
            ParameterizedType type = (ParameterizedType) this.getClass().getGenericSuperclass();
            clazz = (Class<T>) type.getActualTypeArguments()[0];
        }

        @Resource(name = "sessionFactory")
        @Getter @Setter
        private SessionFactory sessionFactory;

        private Session session() {
            return sessionFactory.getCurrentSession();
        }

        /**
         * 泛型类型
         */
        private Class<T> clazz;

        @Override
        public void saveEntity(T o) throws DataAccessException {
            session().save(o);
        }

        @Override
        public void updateEntity(T o) throws DataAccessException {
            session().update(o);
        }

        @Override
        public void saveOrUpdateEntity(T o) throws DataAccessException {
            session().saveOrUpdate(o);
        }

        @Override
        public void deleteEntity(T t) throws DataAccessException {

        }

        @Override
        public void deleteEntityById(ID id) throws DataAccessException {
            T t = (T) session().get(clazz, id);
            if (t != null) {
                session().delete(t);
            }
        }

        @Override
        public void deleteAll(Collection<T> entities) throws DataAccessException {
            if (entities != null) {
                Session session = session();
                for (T t : entities) {
                    session.delete(t);
                }
            }
        }

        @Override
        public T loadEntity(ID id) throws DataAccessException {
            return (T) session().load(clazz, id);
        }

        @Override
        public T getEntity(ID id) throws DataAccessException {
            return (T) session().get(clazz, id);
        }

        @Override
        public T queryEntityFirst(String hql) throws DataAccessException {
            Query query = session().createQuery(hql);
            List<T> list = query.list();
            if (list != null && list.size() > 0) {
                return list.get(0);
            }
            return null;
        }

        @Override
        public T queryEntiryFirst(String hql, Objects... params) throws DataAccessException {
            Query query = session().createQuery(hql);
            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    query.setParameter(i, params[i]);
                }
            }
            List<T> list = query.list();
            if (list != null && list.size() > 0) {
                return list.get(0);
            }
            return null;
        }

        @Override
        public T queryEntityLast(String hql) throws DataAccessException {
            Query query = session().createQuery(hql);
            List<T> list = query.list();
            if (list != null && list.size() > 0) {
                return list.get(list.size() - 1);
            }
            return null;
        }

        @Override
        public T queryEntityLast(String hql, Objects... params) throws DataAccessException {
            Query query = session().createQuery(hql);
            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    query.setParameter(i, params[i]);
                }
            }
            List<T> list = query.list();
            if (list != null && list.size() > 0) {
                return list.get(list.size() - 1);
            }
            return null;
        }

        @Override
        public List queryEntityListByHQL(String hql, Object... params) throws DataAccessException {
            Query query = session().createQuery(hql);
            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    query.setParameter(i, params[i]);
                }
            }
            List<T> list = query.list();
            return list;
        }

        @Override
        public List queryEntityListBySQL(String sql, Object... params) throws DataAccessException {
            Query query = session().createSQLQuery(sql);
            List<T> list = query.list();
            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    query.setParameter(i, params[i]);
                }
            }
            return null;
        }

        @Override
        public int count(String hql) throws DataAccessException {
            Query query = session().createQuery(hql);
            return ((Number) query.uniqueResult()).intValue();
        }

        @Override
        public int count(String hql, Object... params) throws DataAccessException {
            Query query = session().createQuery(hql);
            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    query.setParameter(i, params[i]);
                }
            }
            return ((Number) query.uniqueResult()).intValue();
        }

        @Override
        public Page query(String hql, String countHql, int page, int size) throws DataAccessException {
            Page pageInfo = new Page();
            pageInfo.setPageSize(size);
            pageInfo.setCurrentPage(page);
            pageInfo.init();

            pageInfo.setAllRow(count(countHql));
            Query query = session().createQuery(hql);
            query.setFirstResult(pageInfo.getOffset());
            query.setMaxResults(size);
            List list = query.list();
            pageInfo.setList(list);

            pageInfo.init();
            return pageInfo;
        }

        @Override
        public Page query(String hql, String countHql, int page, int size, Object... params) throws DataAccessException {
            Page pageInfo = new Page();
            pageInfo.setPageSize(size);
            pageInfo.setCurrentPage(page);
            pageInfo.init();

            pageInfo.setAllRow(count(countHql));
            Query query = session().createQuery(hql);
            if (params != null) {
                for (int i = 0; i < params.length; i++) {
                    query.setParameter(i, params[i]);
                }
            }
            query.setFirstResult(pageInfo.getOffset());
            query.setMaxResults(size);
            List list = query.list();
            pageInfo.setList(list);

            pageInfo.init();
            return pageInfo;
        }


    }

```
# DAO层业务借口
```java
package core.opslab.dao;

import core.opslab.entity.Category;
import core.opslab.dao.SupportDao;

/**
* 业务实体DAO
*/

public interface CategoryDao  extends SupportDao<Category,Integer> {
}

```
# DAO层的业务实现
```java
package core.opslab.dao.impl;

import core.opslab.dao.CategoryDao;
import core.opslab.entity.Category;
import core.opslab.dao.impl.SupportDaoImpl;
import org.springframework.stereotype.Repository;

/**
* 业务实体DAO
*/
@Repository("categoryDao")
public class CategoryDaoImpl extends SupportDaoImpl<Category,Integer> implements CategoryDao {
}

```
# service层的封装

```java
/**
 * 封装业务层常用的方法
 */
public interface SupportService<T,ID> {

    public SupportDao getDb();
    //保存实体
    public void save(T t) throws ServicesException;

    //更新实体
    public void update(T t) throws ServicesException;

    //保存或更新
    public void saveOrUpdate(T t) throws ServicesException;

    //删除实体
    public void delete(T t) throws ServicesException;
    public void deleteById(ID id) throws ServicesException;
    public void deleteAll(Collection<T> entities) throws ServicesException;
    //加载实体
    public T load(ID id) throws ServicesException;
    public T get(ID id) throws ServicesException;

    public List<T> list() throws ServicesException;


}
```
# serice层的实现
```java
package core.opslab.service.impl;

import core.opslab.dao.SupportDao;
import core.opslab.exception.ServicesException;
import core.opslab.service.SupportService;
import lombok.Getter;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import java.lang.reflect.ParameterizedType;
import java.util.List;

/**
 * 封装业务层常用的方法
 */
public abstract class SupportServiceImpl<T, ID extends Serializable> implements SupportService<T, ID> {

    public Logger log = Logger.getLogger(this.getClass());

    // 构造时初始（获取泛型）
    private Class<T> clazz;

    public SupportServiceImpl() {
        ParameterizedType type = (ParameterizedType) this.getClass().getGenericSuperclass();
        clazz = (Class<T>) type.getActualTypeArguments()[0];
    }

    @Override
    public void save(T t) throws ServicesException {
        getDb().saveEntity(t);
    }

    @Override
    public void update(T t) throws ServicesException {
        getDb().updateEntity(t);
    }

    @Override
    public void saveOrUpdate(T t) throws ServicesException {
        getDb().saveOrUpdateEntity(t);
    }

    @Override
    public void delete(T t) throws ServicesException {
        getDb().deleteEntity(t);
    }

    @Override
    public void deleteById(ID id) throws ServicesException {
        getDb().deleteEntityById(id);
    }

    @Override
    public void deleteAll(Collection<T> entities) throws ServicesException {
        getDb().deleteAll(entities);
    }

    @Override
    public T load(ID id) throws ServicesException {
        return (T)getDb().loadEntity(id);
    }

    @Override
    public T get(ID id) throws ServicesException {
        return (T)getDb().getEntity(id);
    }

    @Override
    public List<T> list() throws ServicesException {
        String hql= "form "+clazz+" t where 1=1";
        return getDb().queryEntityListByHQL(hql);
    }
}

```

# service的业务接口
```java
package core.opslab.service;

import core.opslab.entity.Article;
import core.opslab.entity.Page;
import core.opslab.service.SupportService;

/**
* 业务方法接口
*/
public interface ArticleService extends SupportService<Article,Integer> {

    /**
     * 按照创建时间获取到一页文章
     * @param page
     * @param size
     * @return
     */
    public Page getPage(int page,int size);

    /**
     * 按照文件分来获取到一页文章
     * @param categroy
     * @param page
     * @param size
     * @return
     */
    public Page getPage(String categroy,int page,int size);
}
```
# service的业务实现
```java
package core.opslab.service.impl;

import core.opslab.dao.SupportDao;
import core.opslab.entity.Article;
import core.opslab.entity.Page;
import core.opslab.service.ArticleService;
import core.opslab.service.impl.SupportServiceImpl;
import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
* 业务方法
*/
@Service("articleService")
public class ArticleServiceImpl extends SupportServiceImpl<Article,Integer> implements ArticleService{
    @Resource(name = "articleDao")
    @Getter @Setter
    protected SupportDao db;

    @Override
    public Page getPage(int page, int size) {
        String hql = "from Article t  order by t.createTime desc";
        String count = "select count(1) from Article t ";
        return db.query(hql, count, page, size);
    }

    @Override
    public Page getPage(String categroy, int page, int size) {
        String hql = "from Article t where t.category=? order by t.createTime desc";
        String count = "select count(1) from Article t ";
        return db.query(hql, count, page, size, categroy);
    }


}
```
大概的实现就是这样了。当然聪明的你肯定会根据上述代码直接写成代码写成模板。然后开发是只需要写一个业务实例类的名字。然后全自动生成代码。
一件测试对吧
