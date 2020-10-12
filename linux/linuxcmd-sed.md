# To replace all occurrences of "day" with "night" and write to stdout:
#用“night”替换所有出现的“day”并写入stdout：
sed 's/day/night/g' file.txt

# To replace all occurrences of "day" with "night" within file.txt:
#要在file.txt中用“night”替换所有出现的“day”：
sed -i 's/day/night/g' file.txt

# To replace all occurrences of "day" with "night" on stdin:
#要在stdin上用“night”替换所有出现的“day”：
echo 'It is daytime' | sed 's/day/night/g'

# To remove leading spaces
#删除前导空格
sed -i -r 's/^\s+//g' file.txt

# To remove empty lines and print results to stdout:
#删除空行并将结果打印到stdout：
sed '/^$/d' file.txt

# To replace newlines in multiple lines
#要替换多行中的换行符
sed ':a;N;$!ba;s/\n//g'  file.txt

# Insert a line before a matching pattern:
#在匹配的模式之前插入一行：
sed '/Once upon a time/i\Chapter 1'

# Add a line after a matching pattern:
#在匹配模式后添加一行：
sed '/happily ever after/a\The end.'
