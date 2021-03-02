# title{uniq -用于检查及删除文本文件中重复出现的行列 }

### 选项
```bash
-c或–count 在每列旁边显示该行重复出现的次数。
-d或–repeated 仅显示重复出现的行列。
-f<栏位>或–skip-fields=<栏位> 忽略比较指定的栏位。
-s<字符位置>或–skip-chars=<字符位置> 忽略比较指定的字符。
-u或–unique 仅显示出一次的行列。
-w<字符位置>或–check-chars=<字符位置> 指定要比较的字符。
–help 显示帮助。
–version 显示版本信息。
[输入文件] 指定已排序好的文本文件。
[输出文件] 指定输出的文件。
```

### 常用命令
```bash
# show all lines without duplication
#显示所有行没有重复
# `sort -u` and `uniq` is the same effect.
#`sort -u`和`uniq`是同样的效果。
sort file | uniq

# show not duplicated lines
#显示没有重复的行
sort file | uniq -u

# show duplicated lines only
#仅显示重复的行
sort file | uniq -d

# count all lines
#统计所有行
sort file | uniq -c

# count not duplicated lines
#算不重复的行
sort file | uniq -uc

# count only duplicated lines
#只计算重复的行
sort file | uniq -dc
```
