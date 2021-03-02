# title{ping - ping命令}

### 选项
```bash
-d 使用Socket的SO_DEBUG功能。
-c<完成次数> 设置完成要求回应的次数。
-f 极限检测。
-i<间隔秒数> 指定收发信息的间隔时间。
-I<网络界面> 使用指定的网络界面送出数据包。
-l<前置载入> 设置在送出要求信息之前，先行发出的数据包。
-n 只输出数值。
-p<范本样式> 设置填满数据包的范本样式。
-q 不显示指令执行过程，开头和结尾的相关信息除外。
-r 忽略普通的Routing Table，直接将数据包送到远端主机上。
-R 记录路由过程。
-s<数据包大小> 设置数据包的大小。
-t<存活数值> 设置存活数值TTL的大小。
-v 详细显示指令的执行过程。
```

### 常用命令
```bash
# ping a host with a total count of 15 packets overall.    
#ping一个总数为15个数据包的主机。
ping -c 15 www.example.com

# ping a host with a total count of 15 packets overall, one every .5 seconds (faster ping). 
#ping一个总共15个数据包的主机，每0.5秒一次（更快的ping）。
ping -c 15 -i .5 www.example.com

# test if a packet size of 1500 bytes is supported (to check the MTU for example)
#测试是否支持1500字节的数据包大小（例如检查MTU）
ping -s 1500 -c 10 -M do www.example.com
```

