# title{sort - 用于将文本文件内容加以排序}

### 选项
```bash
-t  # 指定排序时所用的栏位分隔字符
-n  # 依照数值的大小排序
-r  # 以相反的顺序来排序
-f  # 排序时，将小写字母视为大写字母
-d  # 排序时，处理英文字母、数字及空格字符外，忽略其他的字符
-c  # 检查文件是否已经按照顺序排序
-b  # 忽略每行前面开始处的空格字符
-M  # 前面3个字母依照月份的缩写进行排序
-k  # 指定域
-m  # 将几个排序好的文件进行合并
+<起始栏位>-<结束栏位>   # 以指定的栏位来排序，范围由起始栏位到结束栏位的前一栏位。
-o  # 将排序后的结果存入指定的文
n   # 表示进行排序
r   # 表示逆序
```
### 常用命令
```bash
# 按数字排序
sort -n
# 按数字倒叙
sort -nr
# 过滤重复行
sort -u
# 将两个文件内容整合到一起
sort -m a.txt c.txt
# 第二域相同，将从第三域进行升降处理
sort -n -t' ' -k 2 -k 3 a.txt
# 以:为分割域的第三域进行倒叙排列
sort -n -t':' -k 3r a.txt
# 从第三个字母起进行排序
sort -k 1.3 a.txt
# 以第二域进行排序，如果遇到重复的，就删除
sort -t" " -k 2n -u  a.txt

# To sort a file:
#要对文件进行排序：
sort file

# To sort a file by keeping only unique:
#通过仅保持唯一来对文件进行排序：
sort -u file

# To sort a file and reverse the result:
#要对文件进行排序并反转结果：
sort -r file

# To sort a file randomly:
#要随机排序文件：
sort -R file
```
