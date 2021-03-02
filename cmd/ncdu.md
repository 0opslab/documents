# title{ncdu - 一款很好用的磁盘目前分析工具}

```bash
# Save results to file
#将结果保存到文件
ncdu -o ncdu.file

# Read from file
#从文件中读取
ncdu -f ncdu.file

# Save results to compressed file 
#将结果保存到压缩文件
ncdu -o-| gzip > ncdu.file.gz

# Read from compressed file
#从压缩文件中读取
zcat ncdu.file.gz | ncdu -f-
```