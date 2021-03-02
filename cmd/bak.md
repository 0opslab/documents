# title{bak - 归档解压缩}

## func{归档解压缩}
```bash
tar zxvpf gz.tar.gz -C 放到指定目录 包中的目录       # 解包tar.gz 不指定目录则全解压
tar zcvpf /$path/gz.tar.gz * # 打包gz 注意*最好用相对路径
tar zcf /$path/gz.tar.gz *   # 打包正确不提示
tar ztvpf gz.tar.gz          # 查看gz
tar xvf 1.tar -C 目录        # 解包tar
tar -cvf 1.tar *             # 打包tar
tar tvf 1.tar                # 查看tar
tar -rvf 1.tar 文件名        # 给tar追加文件
tar --exclude=/home/dmtsai -zcvf myfile.tar.gz /home/* /etc      # 打包/home, /etc ，但排除 /home/dmtsai
tar -N "2005/06/01" -zcvf home.tar.gz /home      # 在 /home 当中，比 2005/06/01 新的文件才备份
tar -zcvfh home.tar.gz /home                     # 打包目录中包括连接目录
zgrep 字符 1.gz              # 查看压缩包中文件字符行
bzip2  -dv 1.tar.bz2         # 解压bzip2
bzip2 -v 1.tar               # bzip2压缩
bzcat                        # 查看bzip2
gzip A                       # 直接压缩文件 # 压缩后源文件消失
gunzip A.gz                  # 直接解压文件 # 解压后源文件消失
gzip -dv 1.tar.gz            # 解压gzip到tar
gzip -v 1.tar                # 压缩tar到gz
unzip zip.zip                # 解压zip
zip zip.zip *                # 压缩zip
# rar3.6下载:  http://www.rarsoft.com/rar/rarlinux-3.6.0.tar.gz
# 压缩文件为rar包
rar a rar.rar *.jpg
# 解压rar包
unrar x rar.rar
# 7z压缩
7z a 7z.7z *
# 7z解压
7z e 7z.7z
```

