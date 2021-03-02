# title{aria2c - 比较全能，HTTP 下载和 BT 下载都有，性能也相当不错的一款下载器}

```bash
# Just download a file
#只需下载一个文件
# The url can be a http(s), ftp, .torrent file or even a magnet link
#网址可以是http（s），ftp，.torrent文件甚至是磁铁链接
aria2c <url>

# To prevent downloading the .torrent file
#防止下载.torrent文件
aria2c --follow-torrent=mem <url>

# Download 1 file at a time (-j) 
#一次下载1个文件（-j）
# continuing (-c) any partially downloaded ones
#继续（-c）任何部分下载的
# to the directory specified (-d)
#到指定的目录（-d）
# reading urls from the file (-i)
#从文件中读取网址（-i）
aria2c -j 1 -c -d ~/Downloads -i /path/to/file
```