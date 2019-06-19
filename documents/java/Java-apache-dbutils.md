title: apache dbutils
date: 2016-01-07 19:58:11
tags:
    - Java
categories: Java
---
commons-dbutils 是 Apache 组织提供的一个开源 JDBC工具类库，它是对JDBC的简单封装，学习成本极低，
并且使用dbutils能极大简化jdbc编码的工作量，同时也不会影响程序的性能。
因此dbutils成为很多不喜欢hibernate的公司的首选。
# 接口封装
```java
package com.0opslab.dbutil;

import java.util.List;
import java.util.Map;

/**
 *  利用apache dbutils将一些常用的SQL操作封装
 */
public interface DBUtil {

	/**
	 * 执行sql语句
	 * @param sql sql语句
	 * @return 受影响的行数
	 */
	public int update(String sql);

	/**
	 * 执行sql语句
	 * <code>
	 * executeUpdate("update user set username = 'kitty' where username = ?", "hello kitty");
	 * </code>
	 * @param sql sql语句
	 * @param param 参数
	 * @return 受影响的行数
	 */
	public int update(String sql, Object param);
	/**
	 * 执行sql语句
	 * @param sql sql语句
	 * @param params 参数数组
	 * @return 受影响的行数
	 */
	public int update(String sql, Object[] params);

	/**
	 * 执行批量sql语句
	 * @param sql sql语句
	 * @param params 二维参数数组
	 * @return 受影响的行数的数组
	 */
	public int[] batchUpdate(String sql, Object[][] params);



	/**
	 * 执行查询，将每行的结果保存到一个Map对象中，然后将所有Map对象保存到List中
	 * @param sql sql语句
	 * @return 查询结果
	 */
	public List<Map<String, Object>> find(String sql);

	/**
	 * 执行查询，将每行的结果保存到一个Map对象中，然后将所有Map对象保存到List中
	 * @param sql sql语句
	 * @param param 参数
	 * @return 查询结果
	 */
	public List<Map<String, Object>> find(String sql, Object param);
	public List<String> findColumn(String sql,String column,Object[] params);
	public String findFirstColumn(String sql,String column,Object[] params);

	/**
	 * 执行查询，将每行的结果保存到一个Map对象中，然后将所有Map对象保存到List中
	 * @param sql sql语句
	 * @param params 参数数组
	 * @return 查询结果
	 */
	public List<Map<String, Object>> find(String sql, Object[] params);

	/**
	 * 执行查询，将每行的结果保存到Bean中，然后将所有Bean保存到List中
	 * @param entityClass 类名
	 * @param sql sql语句
	 * @return 查询结果
	 */
	public <T> List<T> find(Class<T> entityClass, String sql);

	/**
	 * 执行查询，将每行的结果保存到Bean中，然后将所有Bean保存到List中
	 * @param entityClass 类名
	 * @param sql sql语句
	 * @param param 参数
	 * @return 查询结果
	 */
	public <T> List<T> find(Class<T> entityClass, String sql, Object param);

	/**
	 * 执行查询，将每行的结果保存到Bean中，然后将所有Bean保存到List中
	 * @param entityClass 类名
	 * @param sql sql语句
	 * @param params 参数数组
	 * @return 查询结果
	 */

	public <T> List<T> find(Class<T> entityClass, String sql, Object[] params);

	/**
	 * 查询出结果集中的第一条记录，并封装成对象
	 * @param entityClass 类名
	 * @param sql sql语句
	 * @return 对象
	 */
	public <T> T findFirst(Class<T> entityClass, String sql);

	/**
	 * 查询出结果集中的第一条记录，并封装成对象
	 * @param entityClass 类名
	 * @param sql sql语句
	 * @param param 参数
	 * @return 对象
	 */
	public <T> T findFirst(Class<T> entityClass, String sql, Object param);

	/**
	 * 查询出结果集中的第一条记录，并封装成对象
	 * @param entityClass 类名
	 * @param sql sql语句
	 * @param params 参数数组
	 * @return 对象
	 */
	public <T> T findFirst(Class<T> entityClass, String sql, Object[] params);

	/**
	 * 查询出结果集中的第一条记录，并封装成Map对象
	 * @param sql sql语句
	 * @return 封装为Map的对象
	 */
	public Map<String, Object> findFirst(String sql);

	/**
	 * 查询出结果集中的第一条记录，并封装成Map对象
	 * @param sql sql语句
	 * @param param 参数
	 * @return 封装为Map的对象
	 */
	public Map<String, Object> findFirst(String sql, Object param);

	/**
	 * 查询出结果集中的第一条记录，并封装成Map对象
	 * @param sql sql语句
	 * @param params 参数数组
	 * @return 封装为Map的对象
	 */
	public Map<String, Object> findFirst(String sql, Object[] params);

	/**
	 * 查询某一条记录，并将指定列的数据转换为Object
	 * @param sql sql语句
	 * @param columnName 列名
	 * @return 结果对象
	 */
	public Object findBy(String sql, String columnName);

	/**
	 * 查询某一条记录，并将指定列的数据转换为Object
	 * @param sql sql语句
	 * @param columnName 列名
	 * @param param 参数
	 * @return 结果对象
	 */
	public Object findBy(String sql, String columnName, Object param);

	/**
	 * 查询某一条记录，并将指定列的数据转换为Object
	 * @param sql sql语句
	 * @param columnName 列名
	 * @param params 参数数组
	 * @return 结果对象
	 */
	public Object findBy(String sql, String columnName, Object[] params);

	/**
	 * 查询某一条记录，并将指定列的数据转换为Object
	 * @param sql sql语句
	 * @param columnIndex 列索引
	 * @return 结果对象
	 */
	public Object findBy(String sql, int columnIndex) ;

	/**
	 * 查询某一条记录，并将指定列的数据转换为Object
	 * @param sql sql语句
	 * @param columnIndex 列索引
	 * @param param 参数
	 * @return 结果对象
	 */
	public Object findBy(String sql, int columnIndex, Object param);

	/**
	 * 查询某一条记录，并将指定列的数据转换为Object
	 * @param sql sql语句
	 * @param columnIndex 列索引
	 * @param params 参数数组
	 * @return 结果对象
	 */
	public Object findBy(String sql, int columnIndex, Object[] params);

}

```

# 接口实现
```java
package com.hollycrm.unicom.dbutil.impl;


import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ColumnListHandler;
import org.apache.commons.dbutils.handlers.MapHandler;
import org.apache.commons.dbutils.handlers.MapListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.hollycrm.unicom.dbutil.DBUtil;
import com.hollycrm.unicom.util.ValidUtil;

@SuppressWarnings("unchecked")
public class DBUtilImpl implements DBUtil {
	private DataSource	dataSource;

	public DataSource getDataSource() {
		return dataSource;
	}

	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	private QueryRunner			queryRunner;
	private static final Log	LOG	= LogFactory.getLog(DBUtilImpl.class);

	/**
	 * 执行sql语句
	 *
	 * @param sql
	 *            sql语句
	 * @return 受影响的行数
	 */
	public int update(String sql) {
		return update(sql, null);
	}

	/**
	 * 执行sql语句 <code>
	 * executeUpdate("update user set username = 'kitty' where username = ?", "hello kitty");
	 * </code>
	 *
	 * @param sql
	 *            sql语句
	 * @param param
	 *            参数
	 * @return 受影响的行数
	 */
	public int update(String sql, Object param) {
		return update(sql, new Object[] { param });
	}

	/**
	 * 执行sql语句
	 *
	 * @param sql
	 *            sql语句
	 * @param params
	 *            参数数组
	 * @return 受影响的行数
	 */
	public int update(String sql, Object[] params) {
		queryRunner = new QueryRunner(dataSource, true);
		int affectedRows = 0;
		try {
			if (params == null) {
				affectedRows = queryRunner.update(sql);
			} else {
				affectedRows = queryRunner.update(sql, params);
			}
		} catch (SQLException e) {
			LOG.error("Error occured while attempting to update data", e);
		}
		return affectedRows;
	}

	/**
	 * 执行批量sql语句
	 *
	 * @param sql
	 *            sql语句
	 * @param params
	 *            二维参数数组
	 * @return 受影响的行数的数组
	 */
	public int[] batchUpdate(String sql, Object[][] params) {
		queryRunner = new QueryRunner(dataSource, true);
		int[] affectedRows = new int[0];
		try {
			affectedRows = queryRunner.batch(sql, params);
		} catch (SQLException e) {
			LOG.error("Error occured while attempting to batch update data", e);
		}
		return affectedRows;
	}

	/**
	 * 执行查询，将每行的结果保存到一个Map对象中，然后将所有Map对象保存到List中
	 *
	 * @param sql
	 *            sql语句
	 * @return 查询结果
	 */
	public List<Map<String, Object>> find(String sql) {
		return find(sql, null);
	}

	/**
	 * 执行查询，将每行的结果保存到一个Map对象中，然后将所有Map对象保存到List中
	 *
	 * @param sql
	 *            sql语句
	 * @param param
	 *            参数
	 * @return 查询结果
	 */
	public List<Map<String, Object>> find(String sql, Object param) {
		return find(sql, new Object[] { param });
	}

	/**
	 * 执行查询，将每行的结果保存到一个Map对象中，然后将所有Map对象保存到List中
	 *
	 * @param sql
	 *            sql语句
	 * @param params
	 *            参数数组
	 * @return 查询结果
	 */
	public List<Map<String, Object>> find(String sql, Object[] params) {
		queryRunner = new QueryRunner(dataSource, true);
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			if (params == null) {
				list = (List<Map<String, Object>>) queryRunner.query(sql, new MapListHandler());
			} else {
				list = (List<Map<String, Object>>) queryRunner.query(sql, new MapListHandler(), params);
			}
		} catch (SQLException e) {
			LOG.error("Error occured while attempting to query data", e);
		}
		return list;
	}

	/**
	 * 执行查询，将每行的结果保存到Bean中，然后将所有Bean保存到List中
	 *
	 * @param entityClass
	 *            类名
	 * @param sql
	 *            sql语句
	 * @return 查询结果
	 */
	public <T> List<T> find(Class<T> entityClass, String sql) {
		return find(entityClass, sql, null);
	}

	/**
	 * 执行查询，将每行的结果保存到Bean中，然后将所有Bean保存到List中
	 *
	 * @param entityClass
	 *            类名
	 * @param sql
	 *            sql语句
	 * @param param
	 *            参数
	 * @return 查询结果
	 */
	public <T> List<T> find(Class<T> entityClass, String sql, Object param) {
		return find(entityClass, sql, new Object[] { param });
	}

	public List<String> findColumn(String sql, String column, Object[] params) {
		queryRunner = new QueryRunner(dataSource, true);
		List<String> list = new ArrayList();
		try {
			if (params == null) {
				list = (List<String>)queryRunner.query(sql, new ColumnListHandler(column));
			} else {
				list = (List<String>) queryRunner.query(sql, new ColumnListHandler(column), params);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
	public String findFirstColumn(String sql, String column, Object[] params) {
		queryRunner = new QueryRunner(dataSource, true);
		List<String> list = new ArrayList();
		try {
			if (params == null) {
				list = (List<String>)queryRunner.query(sql, new ColumnListHandler(column));
			} else {
				list = (List<String>) queryRunner.query(sql, new ColumnListHandler(column), params);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		if(ValidUtil.isValid(list)){
			return list.get(0);
		}
		return "";
	}

	/**
	 * 执行查询，将每行的结果保存到Bean中，然后将所有Bean保存到List中
	 *
	 * @param entityClass
	 *            类名
	 * @param sql
	 *            sql语句
	 * @param params
	 *            参数数组
	 * @return 查询结果
	 */

	public <T> List<T> find(Class<T> entityClass, String sql, Object[] params) {
		queryRunner = new QueryRunner(dataSource, true);
		List<T> list = new ArrayList<T>();
		try {
			if (params == null) {
				list = (List<T>) queryRunner.query(sql, new BeanListHandler(entityClass));
			} else {
				list = (List<T>) queryRunner.query(sql, new BeanListHandler(entityClass), params);
			}
		} catch (SQLException e) {
			LOG.error("Error occured while attempting to query data", e);
		}
		return list;
	}

	/**
	 * 查询出结果集中的第一条记录，并封装成对象
	 *
	 * @param entityClass
	 *            类名
	 * @param sql
	 *            sql语句
	 * @return 对象
	 */
	public <T> T findFirst(Class<T> entityClass, String sql) {
		return findFirst(entityClass, sql, null);
	}

	/**
	 * 查询出结果集中的第一条记录，并封装成对象
	 *
	 * @param entityClass
	 *            类名
	 * @param sql
	 *            sql语句
	 * @param param
	 *            参数
	 * @return 对象
	 */
	public <T> T findFirst(Class<T> entityClass, String sql, Object param) {
		return findFirst(entityClass, sql, new Object[] { param });
	}

	/**
	 * 查询出结果集中的第一条记录，并封装成对象
	 *
	 * @param entityClass
	 *            类名
	 * @param sql
	 *            sql语句
	 * @param params
	 *            参数数组
	 * @return 对象
	 */
	public <T> T findFirst(Class<T> entityClass, String sql, Object[] params) {
		queryRunner = new QueryRunner(dataSource, true);
		Object object = null;
		try {
			if (params == null) {
				object = queryRunner.query(sql, new BeanHandler(entityClass));
			} else {
				object = queryRunner.query(sql, new BeanHandler(entityClass), params);
			}
		} catch (SQLException e) {
			LOG.error("Error occured while attempting to query data", e);
			e.printStackTrace();
		}
		return (T) object;
	}

	/**
	 * 查询出结果集中的第一条记录，并封装成Map对象
	 *
	 * @param sql
	 *            sql语句
	 * @return 封装为Map的对象
	 */
	public Map<String, Object> findFirst(String sql) {
		return findFirst(sql, null);
	}

	/**
	 * 查询出结果集中的第一条记录，并封装成Map对象
	 *
	 * @param sql
	 *            sql语句
	 * @param param
	 *            参数
	 * @return 封装为Map的对象
	 */
	public Map<String, Object> findFirst(String sql, Object param) {
		return findFirst(sql, new Object[] { param });
	}

	/**
	 * 查询出结果集中的第一条记录，并封装成Map对象
	 *
	 * @param sql
	 *            sql语句
	 * @param params
	 *            参数数组
	 * @return 封装为Map的对象
	 */
	public Map<String, Object> findFirst(String sql, Object[] params) {
		queryRunner = new QueryRunner(dataSource, true);
		Map<String, Object> map = null;
		try {
			if (params == null) {
				map = (Map<String, Object>) queryRunner.query(sql, new MapHandler());
			} else {
				map = (Map<String, Object>) queryRunner.query(sql, new MapHandler(), params);
			}
		} catch (SQLException e) {
			LOG.error("Error occured while attempting to query data", e);
		}
		return map;
	}

	/**
	 * 查询某一条记录，并将指定列的数据转换为Object
	 *
	 * @param sql
	 *            sql语句
	 * @param columnName
	 *            列名
	 * @return 结果对象
	 */
	public Object findBy(String sql, String columnName) {
		return findBy(sql, columnName, null);
	}

	/**
	 * 查询某一条记录，并将指定列的数据转换为Object
	 *
	 * @param sql
	 *            sql语句
	 * @param columnName
	 *            列名
	 * @param param
	 *            参数
	 * @return 结果对象
	 */
	public Object findBy(String sql, String columnName, Object param) {
		return findBy(sql, columnName, new Object[] { param });
	}

	/**
	 * 查询某一条记录，并将指定列的数据转换为Object
	 *
	 * @param sql
	 *            sql语句
	 * @param columnName
	 *            列名
	 * @param params
	 *            参数数组
	 * @return 结果对象
	 */
	public Object findBy(String sql, String columnName, Object[] params) {
		queryRunner = new QueryRunner(dataSource, true);
		Object object = null;
		try {
			if (params == null) {
				object = queryRunner.query(sql, new ScalarHandler(columnName));
			} else {
				object = queryRunner.query(sql, new ScalarHandler(columnName), params);
			}
		} catch (SQLException e) {
			LOG.error("Error occured while attempting to query data", e);
		}
		return object;
	}

	/**
	 * 查询某一条记录，并将指定列的数据转换为Object
	 *
	 * @param sql
	 *            sql语句
	 * @param columnIndex
	 *            列索引
	 * @return 结果对象
	 */
	public Object findBy(String sql, int columnIndex) {
		return findBy(sql, columnIndex, null);
	}

	/**
	 * 查询某一条记录，并将指定列的数据转换为Object
	 *
	 * @param sql
	 *            sql语句
	 * @param columnIndex
	 *            列索引
	 * @param param
	 *            参数
	 * @return 结果对象
	 */
	public Object findBy(String sql, int columnIndex, Object param) {
		return findBy(sql, columnIndex, new Object[] { param });
	}

	/**
	 * 查询某一条记录，并将指定列的数据转换为Object
	 *
	 * @param sql
	 *            sql语句
	 * @param columnIndex
	 *            列索引
	 * @param params
	 *            参数数组
	 * @return 结果对象
	 */
	public Object findBy(String sql, int columnIndex, Object[] params) {
		queryRunner = new QueryRunner(dataSource, true);
		Object object = null;
		try {
			if (params == null) {
				object = queryRunner.query(sql, new ScalarHandler(columnIndex));
			} else {
				object = queryRunner.query(sql, new ScalarHandler(columnIndex), params);
			}
		} catch (SQLException e) {
			LOG.error("Error occured while attempting to query data", e);
		}
		return object;
	}
}

```