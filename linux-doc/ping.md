# ping a host with a total count of 15 packets overall.    
#ping一个总数为15个数据包的主机。
ping -c 15 www.example.com

# ping a host with a total count of 15 packets overall, one every .5 seconds (faster ping). 
#ping一个总共15个数据包的主机，每0.5秒一次（更快的ping）。
ping -c 15 -i .5 www.example.com

# test if a packet size of 1500 bytes is supported (to check the MTU for example)
#测试是否支持1500字节的数据包大小（例如检查MTU）
ping -s 1500 -c 10 -M do www.example.com
