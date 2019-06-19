title: 简洁的测试SpringMVC-Controller
date: 2016-10-08 08:22:26
tags:
    - SpringMVC
    - junit
categories: Java
---
路漫漫其修远兮,吾之蹉跎步履蹒跚,不知前路在何方！MD自从上次遇到坑以后，在家待了整整一个月，虽然在学驾照，但是没收入来源心理慌的不行！哎，这年头Java狗不好混啊！这特别是小地方！


国庆的时候在泡github的时候看到有些写的SpringMVC项目以及测试代码，哪叫一个惨不忍睹啊！对于一个无业游民，在这个大家都上班的日子里，唯独一个无聊的我，不知道干什么，索性就分享下我测试SpringMVC的方法吧！

首先SpringMVC比struts2或的原因有太多了，我就说两点第一使用方便灵活，第二方便测试(启动tomcat等容器测试的确实有点坑比)。废话不多说。

### 编写通用的测试模块
web层的api测试数据通常会变，因此在编写测试类的时候写一些常量有些不合适，我前期一般都会直接输出。因此需要编写一些通用的模块或方法，比如模拟发起http请求以及获取的响应的结果等。下面便是我编写的通用的父类。其中主要有httpGet/httpPost/httpInfo几个方法。
```java
package com.opslab.framework.base.action;

import com.opslab.util.JacksonUtil;
import com.opslab.util.SysUtil;
import org.junit.Before;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.webAppContextSetup;


/**
 * 利用Junit测试SpringMVC的controller
 * 业务层方法通过集成并调用actions或url方法即可模拟测试springmvc controller
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations =
        {"classpath*:/spring/Spring-beans-for-JUnit.xml",
                "classpath*:/spring/applicationContext-mvc.xml"})
public class SuperActionTest {
    // 模拟request,response
    protected MockHttpServletRequest request;
    protected MockHttpServletResponse response;

    protected String path;
    @Autowired
    protected WebApplicationContext wac;

    protected MockMvc mockMvc;


    // 执行测试方法之前初始化模拟request,response
    @Before
    public void setUp() {
        request = new MockHttpServletRequest();
        request.setCharacterEncoding("UTF-8");
        response = new MockHttpServletResponse();
        this.mockMvc = webAppContextSetup(this.wac).build();
        path = wac.getServletContext().getContextPath();
    }

    /**
     * 模拟http请求,并返回请求结果
     *
     * @param url
     * @return
     * @throws Exception
     */
    public ResultActions httpPost(String url) throws Exception {
        MockHttpServletRequestBuilder post = post(path + "/" + url);
        return mockMvc.perform(post);
    }

    /**
     * 模拟http请求,直接打印请求结果
     *
     * @param url
     * @throws Exception
     */
    public void httpPostPrint(String url) throws Exception {
        try {
            ResultActions actions = httpPost(url);
            actions.andExpect(status().isOk());
            actions.andDo(print());
        } catch (Exception e) {
            System.out.println("请求异常:" + url);
            e.printStackTrace();
        }
    }

    /**
     * 模拟http请求,并返回请求结果
     *
     * @param url
     * @param params
     * @return
     * @throws Exception
     */
    public ResultActions httpPost(String url, Map<String, String> params) throws Exception {
        MockHttpServletRequestBuilder post = post(path + "/" + url);
        if (params != null && params.size() > 0) {
            for (Map.Entry<String, String> entry : params.entrySet()) {
                post.param(entry.getKey(), entry.getValue());
            }
        }
        return mockMvc.perform(post);
    }

    /**
     * 模拟http请求可带参数,直接打印
     *
     * @param url
     * @param params
     * @throws Exception
     */
    public void httpPostPrint(String url, Map<String, String> params) throws Exception {
        try {
            ResultActions actions = httpPost(url, params);
            actions.andExpect(status().isOk());
            actions.andDo(print());
        } catch (Exception e) {
            System.out.println("请求异常:" + url);
            e.printStackTrace();
        }
    }


    /**
     * 模拟http请求,并返回请求结果
     *
     * @param url
     * @return
     * @throws Exception
     */
    public ResultActions httpGet(String url) throws Exception {
        MockHttpServletRequestBuilder get = get(url);
        return mockMvc.perform(get);
    }

    /**
     * 模拟http请求,直接打印请求结果
     *
     * @param url
     * @throws Exception
     */
    public void httpGetPrint(String url) {
        try {
            ResultActions actions = httpGet(url);
            actions.andExpect(status().isOk());
            actions.andDo(print());
        } catch (Exception e) {
            System.out.println("请求异常:" + url);
            e.printStackTrace();
        }
    }

    /**
     * 模拟http请求,并返回请求结果
     *
     * @param url
     * @param params
     * @return
     * @throws Exception
     */
    public ResultActions httpGet(String url, Map<String, String> params) throws Exception {
        MockHttpServletRequestBuilder post = get(path + "/" + url);
        if (params != null && params.size() > 0) {
            for (Map.Entry<String, String> entry : params.entrySet()) {
                post.param(entry.getKey(), entry.getValue());
            }
        }
        return mockMvc.perform(post);
    }

    /**
     * 模拟http请求可带参数,直接打印
     *
     * @param url
     * @param params
     * @throws Exception
     */
    public void httpGetPrint(String url, Map<String, String> params) throws Exception {
        try {
            ResultActions actions = httpGet(url, params);
            actions.andExpect(status().isOk());
            actions.andDo(print());
        } catch (Exception e) {
            System.out.println("请求异常:" + url);
            e.printStackTrace();
        }
    }

    public void info(ResultActions resultActions) {
        StringBuffer sbuf = new StringBuffer();
        try {
            MvcResult mvcResult = resultActions.andReturn();
            MockHttpServletResponse response = mvcResult.getResponse();
            String contentType = response.getContentType();
            sbuf.append("contentType:" + contentType + SysUtil.LINE_SEPARATOR);
            if (contentType != null && contentType.indexOf("application/json") != -1) {
                String json = response.getContentAsString();
                sbuf.append("json:" + json + SysUtil.LINE_SEPARATOR);
            } else {
                ModelAndView modelAndView = mvcResult.getModelAndView();
                sbuf.append("viewName:" + modelAndView.getViewName() + SysUtil.LINE_SEPARATOR);
                String modelMap = JacksonUtil.toJSON(modelAndView.getModelMap());
                sbuf.append("modelMap:" + modelMap + SysUtil.LINE_SEPARATOR);
            }
            System.out.println(sbuf.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void httpInfo(String url) {
        try {
            info(httpGet(url));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void httpInfo(String url, Map<String, String> params) {
        try {
            info(httpGet(url, params));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}
```
### 编写业务接口测试方法
业务测试方法就应该尽量减少非业务相关的代码，有了上面的父类可以方便的编写只跟业务相关的代码例如
```java
package com.opslab.framework.base.action;

import org.junit.Test;


public class BusinessLogActionTest extends SuperActionTest{

    @Test
    public void testInfo(){
        String url = "/log/business/info/bfb04b3183e244279d115f80c42f8b0d";
        httpInfo(url);
    }


    @Test
    public void testUser(){
        String url ="admin/code/save";

        Map<String,String> params = ImmutableMap.<String, String>builder()
                .put("codeId","USER_TYPE_05")
                .put("codeType","USER_TYPE")
                .put("codeName","高级VIP用户")
                .put("orderId","5")
                .put("desc","开通VIP的用户")
                .build();

        httpInfo(url,params);
    }
}
```