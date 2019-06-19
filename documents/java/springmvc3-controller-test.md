title: 简洁的测试SpringMVC-Controller
date: 2016-11-08 20:22:26
tags: SpringMVC
categories: Java
---
进入新公司也有几天了,虽然还没有签订合同，当时已经开放了一个在线活动！也不知道公司哪里的信息让我这么做。虽然这么说但自己对自己的还是蛮有信心的。不过这项目代码我也是看着醉了。全局我居然没有找到配置事物的管理或者事物的实现，难道没有遇到业务数据异常的事情或者认为数据异常是常事？当然了还没有发现SpringMVC Controller的测试也没有？难道都是重启tomcat测试？于是我吧写了下面的方法，应用项目使用SpringMVC3.0因此很少有人这么做！
```java
package com.xwtec;

import java.util.Map;

import org.junit.BeforeClass;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.annotation.AnnotationMethodHandlerAdapter;

import com.xwtec.util.JsonUtil;

@ContextConfiguration(locations = { "classpath:param-config.xml", "classpath:applicationContext_mvc.xml" })
public class SuperActionTest extends AbstractJUnit4SpringContextTests {

    // 模拟request,response
    protected static MockHttpServletRequest request;
    protected static MockHttpServletResponse response;

    @Autowired
    private AnnotationMethodHandlerAdapter handlerAdapter;


    /**
     * 读取配置文件
     */
    @BeforeClass
    public static void setUp() {

        // 执行测试方法之前初始化模拟request,response
        request = new MockHttpServletRequest();
        request.setCharacterEncoding("UTF-8");
        response = new MockHttpServletResponse();
    }

    /**
     * 执行get请求的action
     */
    public ModelAndView get(String url, Map<String, String> params, Object controller) throws Exception {
        request.setRequestURI(url);
        if (params != null && params.size() > 0) {
            for (Map.Entry<String, String> data : params.entrySet()) {
                request.addParameter(data.getKey(), data.getValue());
            }
        }
        request.setMethod("GET");
        return handlerAdapter.handle(request, response, controller);
    }

    public void getInfo(String url, Map<String, String> params, Object controller) {

        try {
            ModelAndView mav = get(url, params, controller);
            if (mav != null) {
                System.out.print("viewName:" + mav.getViewName());
                String modelMap = JsonUtil.toJson(mav.getModelMap());
                System.out.print("modelMap:" + modelMap);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * 执行get请求的action
     */
    public ModelAndView post(String url, Map<String, String> params, Object controller) throws Exception {
        request.setRequestURI(url);
        if (params != null && params.size() > 0) {
            for (Map.Entry<String, String> data : params.entrySet()) {
                request.addParameter(data.getKey(), data.getValue());
            }
        }
        request.setMethod("GET");
        return handlerAdapter.handle(request, response, controller);
    }

    public void postInfo(String url, Map<String, String> params, Object controller) {
        try {
            ModelAndView mav = get(url, params, controller);
            if (mav != null) {
                System.out.print("===================");
                System.out.print("viewName:" + mav.getViewName());
                String modelMap = JsonUtil.toJson(mav.getModelMap());
                System.out.print("modelMap:" + modelMap);
                System.out.print("===================");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
```