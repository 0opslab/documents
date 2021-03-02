# title{date - linux用显示喝设置时间的命令}

可以用来显示或设定系统的日期与时间，在显示方面，使用者可以设定欲显示的格式，格式设定为一个加号后接数个标记

### 时间标记
```bash
% : 印出 %
%n : 下一行
%t : 跳格
%H : 小时(00..23)
%I : 小时(01..12)
%k : 小时(0..23)
%l : 小时(1..12)
%M : 分钟(00..59)
%p : 显示本地 AM 或 PM
%r : 直接显示时间 (12 小时制，格式为 hh:mm:ss [AP]M)
%s : 从 1970 年 1 月 1 日 00:00:00 UTC 到目前为止的秒数
%S : 秒(00..61)
%T : 直接显示时间 (24 小时制)
%X : 相当于 %H:%M:%S
%Z : 显示时区
#日期方面：

%a : 星期几 (Sun..Sat)
%A : 星期几 (Sunday..Saturday)
%b : 月份 (Jan..Dec)
%B : 月份 (January..December)
%c : 直接显示日期与时间
%d : 日 (01..31)
%D : 直接显示日期 (mm/dd/yy)
%h : 同 %b
%j : 一年中的第几天 (001..366)
%m : 月份 (01..12)
%U : 一年中的第几周 (00..53) (以 Sunday 为一周的第一天的情形)
%w : 一周中的第几天 (0..6)
%W : 一年中的第几周 (00..53) (以 Monday 为一周的第一天的情形)
%x : 直接显示日期 (mm/dd/yy)
%y : 年份的最后两位数字 (00.99)
%Y : 完整年份 (0000..9999)
```

### 常用参数
```bash
-d datestr : 显示 datestr 中所设定的时间 (非系统时间)
--help : 显示辅助讯息
-s datestr : 将系统时间设为 datestr 中所设定的时间
-u : 显示目前的格林威治时间
--version : 显示版本编号
```


```bash
# 设日期
date -s 20091112
# 设时间
date -s 18:30:50
# 7天前日期
date -d "7 days ago" +%Y%m%d
# 5分钟前时间
date -d "5 minute ago" +%H:%M
# 一个月前
date -d "1 month ago" +%Y%m%d
# 日期格式转换
date +%Y-%m-%d -d '20110902'
# 日期和时间
date +%Y-%m-%d_%X
# 纳秒
date +%N
# 换算成秒计算(1970年至今的秒数)
date -d "2012-08-13 14:00:23" +%s    
# 将时间戳换算成日期
date -d "@1363867952" +%Y-%m-%d-%T   
# 将时间戳换算成日期
date -d "1970-01-01 UTC 1363867952 seconds" +%Y-%m-%d-%T
# 格式化系统启动时间(多少秒前)  
date -d "`awk -F. '{print $1}' /proc/uptime` second ago" +"%Y-%m-%d %H:%M:%S"    



# Print date in format suitable for affixing to file names
#以适合粘贴文件名的格式打印日期
date +"%Y%m%d_%H%M%S"

# Convert Unix timestamp to Date(Linux)
#将Unix时间戳转换为日期（Linux）
date -d @1440359821

# Convert Unix timestamp to Date(Mac)
#将Unix时间戳转换为日期（Mac）
date -r 1440359821
```