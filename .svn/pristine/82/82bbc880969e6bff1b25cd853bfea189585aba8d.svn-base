# To download a single file
#下载单个文件
wget http://path.to.the/file

# To download a file and change its name
#下载文件并更改其名称
wget http://path.to.the/file -O newname

# To download a file into a directory
#将文件下载到目录中
wget -P path/to/directory http://path.to.the/file

# To continue an aborted downloaded
#要继续中止下载
wget -c http://path.to.the/file

# To download multiples files with multiple URLs
#下载包含多个URL的多个文件
wget URL1 URL2

# To parse a file that contains a list of URLs to fetch each one
#解析包含URL列表的文件以获取每个URL
wget -i url_list.txt

# To mirror a whole page locally
#在本地镜像整个页面
wget -pk http://path.to.the/page.html

# To mirror a whole site locally
#在本地镜像整个站点
wget -mk http://site.tl/

# To download files according to a pattern
#根据模式下载文件
wget http://www.myserver.com/files-{1..15}.tar.bz2

# To download all the files in a directory with a specific extension if directory indexing is enabled
#如果启用了目录索引，则下载具有特定扩展名的目录中的所有文件
wget -r -l1 -A.extension http://myserver.com/directory

# Allows you to download just the headers of responses (-S --spider) and display them on Stdout (-O -).
#允许您只下载响应的标题（-S --spider）并在Stdout（-O  - ）上显示它们。
wget -S --spider -O - http://google.com

# Change the User-Agent to 'User-Agent: toto'
#将User-Agent更改为“User-Agent：toto”
wget -U 'toto' http://google.com
