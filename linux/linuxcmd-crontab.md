# set a shell
#设置一个shell
SHELL=/bin/bash

# crontab format
#crontab格式
* * * * *  command_to_execute
- - - - -
| | | | |
| | | | +- day of week (0 - 7) (where sunday is 0 and 7)
| | | +--- month (1 - 12)
| | +----- day (1 - 31)
| +------- hour (0 - 23)
+--------- minute (0 - 59)

# example entries
#示例条目
# every 15 min
#每15分钟一次
*/15 * * * * /home/user/command.sh

# every midnight
#每个午夜
0 0 * * * /home/user/command.sh

# every Saturday at 8:05 AM
#每周六上午8:05
5 8 * * 6 /home/user/command.sh
