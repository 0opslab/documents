# title{ntp - 网络时间同步协议}

```bash
# Verify ntpd running:
#验证ntpd运行：
service ntp status

# Start ntpd if not running:
#如果没有运行，启动ntpd：
service ntp start

# Display current hardware clock value:
#显示当前硬件时钟值：
sudo hwclock -r

# Apply system time to hardware time:
#将系统时间应用于硬件时间：
sudo hwclock --systohc

# Apply hardware time to system time:
#将硬件时间应用于系统时间：
sudo hwclock --hctosys

# Set hwclock to local time:
#将hwclock设置为当地时间：
sudo hwclock --localtime

# Set hwclock to UTC:
#将hwclock设置为UTC：
sudo hwclock --utc

# Set hwclock manually:
#手动设置hwclock：
sudo hwclock --set --date="8/10/15 13:10:05"

# Query surrounding stratum time servers
#查询周围的层时间服务器
ntpq -pn

# Config file:
#配置文件：
/etc/ntp.conf

# Driftfile:
#操作文件：
location of "drift" of your system clock compared to ntp servers
/var/lib/ntp/ntp.drift
```