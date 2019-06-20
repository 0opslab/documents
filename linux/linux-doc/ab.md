# send 100 requests with a concurency of 50 requests to an URL
#向URL发送100个请求并发50个请求
ab -n 100 -c 50 http://www.example.com/

# send requests during 30 seconds with a concurency of 50 requests to an URL
#在30秒内发送请求，并发向URL的50个请求
ab -t 30 -c 50 URL http://www.example.com/
