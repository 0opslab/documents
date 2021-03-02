# title{shred - 是一条终端命令，功能是重复覆盖文件，使得即使是昂贵的硬件探测仪器也难以将数据复原}
### 选项
```bash
-f, --force 必要时修改权限以使目标可写
-n, --iterations=N 覆盖N 次，而非使用默认的3 次
  --random-source=文件 从指定文件中取出随机字节
-s, --size=N 粉碎数据为指定字节的碎片(可使用K、M 和G 作为单位)
-u, --remove 覆盖后截断并删除文件
-v, --verbose 显示详细信息
-x, --exact 不将文件大小增加至最接近的块大小
-z, --zero 最后一次使用0 进行覆盖以隐藏覆盖动作
  --help 显示此帮助信息并退出
  --version 显示版本信息并退出
```

### 常用命令
```bash
# To shred a file (5 passes) and verbose output:
#要粉碎文件（5遍）和详细输出：
shred -n 5 -v file.txt

# To shred a file (5 passes) and a final overwrite of zeroes:
#要粉碎文件（5遍）并最后覆盖零：
shred -n 5 -vz file.txt

# To do the above, and then truncate and rm the file:
#要执行上述操作，然后截断并运行该文件：
shred -n 5 -vzu file.txt

# To shred a partition:
#要粉碎分区：
shred -n 5 -vz /dev/sda

# Remember that shred may not behave as expected on journaled file systems if file data is being journaled.
#请记住，如果正在记录文件数据，则shred可能在日志文件系统上的行为不正常。
```
