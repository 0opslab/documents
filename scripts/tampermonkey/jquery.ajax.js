//func{jquery ajax}
$.ajax({
  //请求方式
  type: "POST",
  //请求的媒体类型
  contentType: "application/json;charset=UTF-8",
  //请求地址
  url: "http://127.0.0.1/admin/list/",
  //数据，json字符串
  data: JSON.stringify(list),
  //请求成功
  success: function (result) {
    console.log(result);
  },
  //请求失败，包含具体的错误信息
  error: function (e) {
    console.log(e.status);
    console.log(e.responseText);
  }
});

//func{jquery ajax jsonp}
$.ajax({
  //请求方式
  type: "get",
  //是否异步
  async: true,
  url: "http://www.domain.net/url",
  //跨域json请求一定是jsonp
  dataType: "jsonp",
  //跨域请求的参数名，默认是callback
  jsonp: "callbackparam",
  //自定义跨域参数值，回调函数名也是一样，默认为jQuery自动生成的字符串
  jsonpCallback: "successCallback",
  data: {
    "query": "civilnews"
  }, //请求参数

  beforeSend: function () {
    //请求前的处理
  },

  success: function (data) {
    //请求成功处理，和本地回调完全一样
  },

  complete: function () {
    //请求完成的处理
  },

  error: function () {
    //请求出错处理
  }
});
