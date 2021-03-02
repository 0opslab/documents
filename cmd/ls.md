# title{ls - Linux下使用最多的命令之一}

### 常用参数
```bash
-a 显示所有文件及目录 (ls内定将文件名或目录名称开头为”.”的视为隐藏档，不会列出)
-l 除文件名称外，亦将文件型态、权限、拥有者、文件大小等资讯详细列出
-r 将文件以相反次序显示(原定依英文字母次序)
-t 将文件依建立时间之先后次序列出
-A 同 -a ，但不列出 “.” (目前目录) 及 “..” (父目录)
-F 在列出的文件名称后加一符号；例如可执行档则加 “*”, 目录则加 “/”
-R 若目录下有文件，则以下之文件亦皆依序列出
```

### 常用命令
```bash
# Displays everything in the target directory
#显示目标目录中的所有内容
ls path/to/the/target/directory

# Displays everything including hidden files
#显示包括隐藏文件在内的所
ls -a

# Displays all files, along with the size (with unit suffixes) and timestamp
#显示所有文件，以及大小（带有单位后缀）和时间戳
ls -lh 

# Display files, sorted by size
#显示文件，按大小排序
ls -S

# Display directories only
#仅显示目录
ls -d */

# Display directories only, include hidden
#仅显示目录，包括隐藏
ls -d .*/ */
```