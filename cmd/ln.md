# title{ln - 软连接}

必要参数：
-b 删除，覆盖以前建立的链接
-d 允许超级用户制作目录的硬链接
-f 强制执行
-i 交互模式，文件存在则提示用户是否覆盖
-n 把符号链接视为一般目录
-s 软链接(符号链接)
-v 显示详细的处理过程
选择参数：
-S “-S<字尾备份字符串> “或 “–suffix=<字尾备份字符串>”
-V “-V<备份方式>”或”–version-control=<备份方式>”
–help 显示帮助信息
–version 显示版本信息


```bash
# To create a symlink:
#要创建符号链接：
ln -s path/to/the/target/directory name-of-symlink

# Symlink, while overwriting existing destination files
#符号链接，同时覆盖现有目标文件
ln -sf /some/dir/exec /usr/bin/exec
```