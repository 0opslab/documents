# title{xargs - 给其他命令传递参数的一个过滤器}

### 选项
```bash
-a file 从文件中读入作为 stdin
-e flag ，注意有的时候可能会是-E，flag必须是一个以空格分隔的标志，当xargs分析到含有flag这个标志的时候就停止。
-p 当每次执行一个argument的时候询问一次用户。
-n num 后面加次数，表示命令在执行的时候一次用的argument的个数，默认是用所有的。
-t 表示先打印命令，然后再执行。
-i 或者是-I，这得看linux支持了，将xargs的每项名称，一般是一行一行赋值给 {}，可以用 {} 代替。
-r no-run-if-empty 当xargs的输入为空的时候则停止xargs，不用再去执行了。
-s num 命令行的最大字符数，指的是 xargs 后面那个命令的最大命令行字符数。
-L num 从标准输入一次读取 num 行送给 command 命令。
-l 同 -L。
-d delim 分隔符，默认的xargs分隔符是回车，argument的分隔符是空格，这里修改的是xargs的分隔符。
-x exit的意思，主要是配合-s使用。。
-P 修改最大的进程数，默认是1，为0时候为as many as it can ，这个例子我没有想到，应该平时都用不到的吧。
```

### 常用命令
```bash
# find all file name ending with .pdf and remove them
#找到所有以.pdf结尾的文件名并删除它们
find -name *.pdf | xargs rm -rf

# if file name contains spaces you should use this instead
#如果文件名包含空格，则应使用此替代
find -name *.pdf | xargs -I{} rm -rf '{}'

# Will show every .pdf like:
#将显示每个.pdf像：
#	&toto.pdf=
#用＆和。 pdf =
#	&titi.pdf=
#＃＆titi.pdf =
# -n1 => One file by one file. ( -n2 => 2 files by 2 files )
#-n1 =>一个文件一个文件。 （-n2 => 2个文件的2个文件）

find -name *.pdf | xargs -I{} -n1 echo '&{}='

# If find returns no result, do not run rm
#如果find没有返回结果，请不要运行rm
# This option is a GNU extension.
#此选项是GNU扩展。
find -name "*.pdf" | xargs --no-run-if-empty rm
```
