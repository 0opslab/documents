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
