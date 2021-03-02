# title{dhclient - 使用动态主机配置协议动态的配置网络接口的网络参数}

### 常用参数
```bash
0：指定dhcp客户端监听的端口号；
-d：总是以前台方式运行程序；
-q：安静模式，不打印任何错误的提示信息；
-r：释放ip地址。
```

### 常用命令
```bash
# To release the current IP address:
#要释放当前的IP地址：
sudo dhclient -r

# To obtain a new IP address:
#要获取新的IP地址：
sudo dhclient

# Running the above in sequence is a common way of refreshing an IP.
#按顺序运行上述内容是刷新IP的常用方法。

# To obtain a new IP address for a specific interface:
#要获取特定接口的新IP地址，请执行以下操作：
sudo dhclient eth0
```