# title{paste - 命令用于合并文件的列}

### 选项
```bash
-d<间隔字符>或–delimiters=<间隔字符> 　用指定的间隔字符取代跳格字符。
-s或–serial 　串列进行而非平行处理。
–help 　在线帮助。
–version 　显示帮助信息。
[文件…] 指定操作的文件路径
```

### 常用命令
```bash
# Concat columns from files
#来自文件的Concat列
paste file1 file2 ...

# List the files in the current directory in three columns:
#在三列中列出当前目录中的文件：
ls | paste - - -

# Combine pairs of lines from a file into single lines:
#将文件中的线对组合成单行：
paste -s -d '\t\n' myfile

# Number the lines in a file, similar to nl(1):
#对文件中的行进行编号，类似于nl（1）：
sed = myfile | paste -s -d '\t\n' - -

# Create a colon-separated list of directories named bin,
#创建以冒号分隔的名为bin的目录列表，
# suitable for use in the PATH environment variable:
#适合在PATH环境变量中使用：
find / -name bin -type d | paste -s -d : -
```
