# title{grep - 用于查找文件里符合条件的字符串}

## 常用选项
```bash
-i	忽略大小写
-r	递归查找目录中的文件进行文本匹配
-l	只显示匹配文件所在的文件名
-n	显示匹配文件所在文件的行号
-A NUM	显示匹配文本后NUM行
-B NUM	显示匹配文本前NUM行
-C NUM	显示匹配文本前后NUM行
-v	反转匹配，匹配不在指定文本的行
-o	只显示匹配的文本
-c	统计匹配文本的行数
--color	高亮显示匹配文本
-h    # 不显示文件名
-i    # 忽略大小写
-l    # 只列出匹配行所在文件的文件名
-n    # 在每一行中加上相对行号
-s    # 无声操作只显示报错，检查退出状态
-e    # 使用正则表达式
-A3   # 打印匹配行和下三行
-w    # 精确匹配
-wc   # 精确匹配次数
-P    # 使用perl正则表达式
```

##  常用命令

```bash
# Search a file for a pattern
grep pattern file

# Case insensitive search (with line numbers)
grep -in pattern file

# Recursively grep for string <pattern> in folder:
grep -R pattern folder

#grep递归查找/etc目录及其子目录中含有”user“字符的文件，并显示文件与其含有”user“字符串的行
grep -r "user" /etc

#只匹配一个单词，而不是最为单词的一部分去匹配
grep -w user /etc/passwd

#查找两个字符串
grep "user|USER" /etc/passwd

#只输出包含的文件名而不输出文件行
grep -l "user" /etc/*


# Read search patterns from a file (one per line)
grep -f pattern_file file

# Find lines NOT containing pattern
grep -v pattern file

# You can grep with regular expressions
grep "^00" file  #Match lines starting with 00
grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" file  #Find IP add

# Find all files which match {pattern} in {directory}
# This will show: "file:line my research"
grep -rnw 'directory' -e "pattern"

# Exclude grep from your grepped output of ps.
# Add [] to the first letter. Ex: sshd -> [s]shd
ps aux | grep '[h]ttpd'

# Colour in red {bash} and keep all other lines
ps aux | grep -E --color 'bash|$'

##cat是用于查看普通文件的。
cat /etc/passwd

##zcat 是用于查看压缩的文件 
##gzip 套件包含许多可以 “在原地” 处理压缩文件的实用程序。zcat、zgrep、zless、zdiff 等实用程序的作用分别与 cat、grep、less 和 diff 相同，但是它们操作压缩的文件。
zcat web.log.gz | grep aqzt.com | head
 
###Grep 'OR' 或操作
grep "pattern1\|pattern2" file.txt
grep -E "pattern1|pattern2" file.txt
grep -e pattern1 -e pattern2 file.txt
egrep "pattern1|pattern2" file.txt

awk '/pattern1|pattern2/' file.txt
sed -e '/pattern1/b' -e '/pattern2/b' -e d file.txt

#找出文件（filename）中包含123或者包含abc的行
grep -E '123|abc' filename 
#用egrep同样可以实现
egrep '123|abc' filename 
#awk 的实现方式
awk '/123|abc/' filename 

###Grep 'AND'  与操作
grep -E 'pattern1.*pattern2' file.txt # in that order
grep -E 'pattern1.*pattern2|pattern2.*pattern1' file.txt # in any order
grep 'pattern1' file.txt | grep 'pattern2' # in any order

awk '/pattern1.*pattern2/' file.txt # in that order
awk '/pattern1/ && /pattern2/' file.txt # in any order
sed '/pattern1.*pattern2/!d' file.txt # in that order
sed '/pattern1/!d; /pattern2/!d' file.txt # in any order

#显示既匹配 pattern1 又匹配 pattern2 的行。
grep pattern1 files | grep pattern2 

###Grep 'NOT' 
grep -v 'pattern1' file.txt
awk '!/pattern1/' file.txt
sed -n '/pattern1/!p' file.txt

##删除两个文件相同部分
grep -v -f file1 file2 && grep -v -f file2 file1 

##计算并集
sort -u a.txt b.txt

##计算交集
grep -F -f a.txt b.txt | sort | uniq

##计算差集
grep -F -v -f b.txt a.txt | sort | uniq

sort a b b | uniq -u  
#a b 排序，两个的交集出现次就是2 了，a b b 再排序。b里面的次数，最少是2了，交集里面的是3
然后再uniq -u 取出现一次的，就是想要的结果了

##删除两个文件相同部分  实用comm
comm -3 file1 file2

##删除两个文件相同部分  使用awk
awk '{print NR, $0}' file1 file2 |sort -k2|uniq -u -f 1|sort -k1|awk '{print $2}'
##或者：
awk '{print $0}' file1 file2 |sort|uniq -u

##其他操作
#不区分大小写地搜索。默认情况区分大小写，
grep -i pattern files 
#只列出匹配的文件名，
grep -l pattern files 
#列出不匹配的文件名，
grep -L pattern files 
#只匹配整个单词，而不是字符串的一部分（如匹配‘magic’，而不是‘magical’），
grep -w pattern files 
#匹配的上下文分别显示[number]行，
grep -C number pattern files 

#grep -A ：显示匹配行和之后的几行
#-A -B -C 后面都跟阿拉伯数字，-A是显示匹配后和它后面的n行。-B是显示匹配行和它前面的n行。-C是匹配行和它前后各n行。总体来说，-C覆盖面最大。
grep -A 5 wikipedia files.txt
```