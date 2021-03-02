# title{od - od命令用于输出文件内容}

### 选项
```bash
-a 　此参数的效果和同时指定"-ta"参数相同。
-A<字码基数> 　选择要以何种基数计算字码。
-b 　此参数的效果和同时指定"-toC"参数相同。
-c 　此参数的效果和同时指定"-tC"参数相同。
-d 　此参数的效果和同时指定"-tu2"参数相同。
-f 　此参数的效果和同时指定"-tfF"参数相同。
-h 　此参数的效果和同时指定"-tx2"参数相同。
-i 　此参数的效果和同时指定"-td2"参数相同。
-j<字符数目>或--skip-bytes=<字符数目> 　略过设置的字符数目。
-l 　此参数的效果和同时指定"-td4"参数相同。
-N<字符数目>或--read-bytes=<字符数目> 　到设置的字符数目为止。
-o 　此参数的效果和同时指定"-to2"参数相同。
-s<字符串字符数>或--strings=<字符串字符数> 　只显示符合指定的字符数目的字符串。
-t<输出格式>或--format=<输出格式> 　设置输出格式。
-v或--output-duplicates 　输出时不省略重复的数据。
-w<每列字符数>或--width=<每列字符数> 　设置每列的最大字符数。
-x 　此参数的效果和同时指定"-h"参数相同。
--help 　在线帮助。
--version 　显示版本信息。
```

### 常用命令
```bash
# Dump file in octal format
#以八进制格式转储文件
od /path/to/binaryfile
od -o /path/to/binaryfile
od -t o2 /path/to/binaryfile

# Dump file in hexadecimal format
#以十六进制格式转储文件
od -x /path/to/binaryfile
od -t x2 /path/to/binaryfile

# Dump file in hexadecimal format, with hexadecimal offsets and a space between each byte
#以十六进制格式转储文件，具有十六进制偏移量和每个字节之间的空格
od -A x -t x1 /path/to/binaryfile

# 使用单字节八进制解释进行输出，注意左侧的默认地址格式为八字节
od -c tmp
```