# title{fiddler - 一款桌面端非常常用的http抓包分析器}

虽然fiddler提供了图像界面，但是其命令窗口能提供更多的选择

注1：通过快捷键 Alt + q 可以将焦点定位到命令行输入框（小黑框）中

注2：当焦点在命令输入框中时，快捷键 Ctrl + i 可以快速插入当前选中会话的 URL

问号（?）后边跟一个字符串，Fiddler 将所有会话中存在该字符串匹配的全部高亮显示（ ?google.com）

* < 和 >    大于号（>）和小于号（<）后边跟一个数值，表示高亮所有尺寸大于或小于该数值的会话

  比如我输入 >5000  表示你想高亮所有尺寸大于 5KB 的会话

* 等于号（=）后边可以接 HTTP 状态码或 HTTP 方法，比如 =200 表示高亮所有正常响应的会话

  =POST，表示希望高亮所有 POST 方法的会话

* @ 后边跟的是 Host，比如我想高亮所有鱼C论坛的连接，我可以 @bbs.fishc.com

* bpafter 后边跟一个字符串，表示中断所有包含该字符串的会话,比如我想中断所有包含 fishc 的响应那么我输入 bpafter fishc

* bps 后边跟的是 HTTP 状态码，表示中断所有为该状态码的会话

* bpv 或 bpm 后边跟的是 HTTP 方法，表示中断所有为该方法的会话

* bpu跟 bpafter 类似，区别：bpu 是在发起请求时中断，而 bpafter 是在收到响应后中断。

* csl clear清除当前的所有会话

* dump 将所有的会话打包成 .zip 压缩包的形式保存到 C 盘根目录下

* shou  显示fiddler

* start 开始工作

* end 停止工作

* quit退出

* select 后边跟响应的类型（Content-Type），表示选中所有匹配的会话  Fiddler 选中所有的图片，可以使用 select image

* !dns 后边跟一个域名，执行 DNS 查找并在右边的 LOG 栏打印结果

* !listen 设置其他监听的端口

* ### urlreplace

  urlreplace 后边跟两个字符串，表示替换 URL 中的字符串。比如 urlreplace baidu fishc 表示将所有 URL 的 baidu 替换成 fishc。

  urlreplace www.cnblogs.com www.cnblogs1.com 进行请求转发再测试的时候经常使用

  