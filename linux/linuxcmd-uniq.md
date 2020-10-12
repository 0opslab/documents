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
