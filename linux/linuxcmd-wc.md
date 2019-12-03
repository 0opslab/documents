# Count the number of words (file or STDIN)
#计算单词数（文件或STDIN）
wc -w /path/to/foo.txt
cat /path/to/foo.txt | wc -w

# Count the number of lines (file or STDIN)
#计算行数（文件或STDIN）
wc -l /path/to/foo.txt
cat /path/to/foo.txt | wc -l

# Count the number of bytes (file or STDIN)
#计算字节数（文件或STDIN）
wc -c /path/to/foo.txt
cat /path/to/foo.txt | wc -c

# Count files and directories at a given location
#计算给定位置的文件和目录
ls -l | wc -l

# If you ever use `wc` in a shell script and need to compare the output with an int you can
#如果你在shell脚本中使用`wc`并且需要将输出与int进行比较
# clean the output (wc returns extra characters around the integer) by using xargs:
#使用xargs清理输出（wc返回整数周围的额外字符）：
ls -l | wc -l | xargs
