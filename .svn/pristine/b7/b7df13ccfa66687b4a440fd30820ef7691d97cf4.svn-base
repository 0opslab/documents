# sum integers from a file or stdin, one integer per line:
#从文件或stdin中求和整数，每行一个整数：
printf '1\n2\n3\n' | awk '{ sum += $1} END {print sum}'

# using specific character as separator to sum integers from a file or stdin
#使用特定字符作为分隔符来对文件或标准输入中的整数求和
printf '1:2:3' | awk -F ":" '{print $1+$2+$3}'

# print a multiplication table
#打印乘法表
seq 9 | sed 'H;g' | awk -v RS='' '{for(i=1;i<=NF;i++)printf("%dx%d=%d%s", i, NR, i*NR, i==NR?"\n":"\t")}'

# Specify output separator character
#指定输出分隔符
printf '1 2 3' | awk 'BEGIN {OFS=":"}; {print $1,$2,$3}'
