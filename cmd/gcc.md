# title{gcc - gcc相关的那些常用操作}

### 常用选项
```bash
-o：指定生成的输出文件；
-E：仅执行编译预处理；
-S：将C代码转换为汇编代码；
-wall：显示警告信息；
-c：仅执行编译操作，不进行连接操作。
```

### 常用命令
```bash
# Compile a file
#编译文件
gcc file.c

# Compile a file with a custom output
#使用自定义输出编译文件
gcc -o file file.c

# Debug symbols
#调试符号
gcc -g

# Debug with all symbols.
#使用所有符号进行调试
gcc -ggdb3

# Build for 64 bytes
#构建为64个字节
gcc -m64

# Include the directory {/usr/include/myPersonnal/lib/} to the list of path for #include <....>
#将目录{/ usr / include / myPersonnal / lib /}包含在include <....>的路径列表中
# With this option, no warning / error will be reported for the files in {/usr/include/myPersonnal/lib/}
#使用此选项，将不会报告{/ usr / include / myPersonnal / lib /}中文件的警告/错误
gcc -isystem /usr/include/myPersonnal/lib/

# Build a GUI for windows (Mingw) (Will disable the term/console)
#为Windows构建GUI（Mingw）（将禁用术语/控制台）
gcc -mwindows
```