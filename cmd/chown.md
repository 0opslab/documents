# title{chown - 命令用于设置文件所有者和文件关联组的命令}

语法
chown [-cfhvR] [--help] [--version] user[:group] file...
参数 :

user : 新的文件拥有者的使用者 ID
group : 新的文件拥有者的使用者组(group)
-c : 显示更改的部分的信息
-f : 忽略错误信息
-h :修复符号链接
-v : 显示详细的处理信息
-R : 处理指定目录以及其子目录下的所有文件
--help : 显示辅助说明
--version : 显示版本

```bash
# Change file owner
#更改文件所有者
chown user file

# Change file owner and group
#更改文件所有者和组
chown user:group file

# Change owner recursively
#递归更改所有者
chown -R user directory

# Change ownership to match another file
#更改所有权以匹配另一个文件
chown --reference=/path/to/ref_file file
```