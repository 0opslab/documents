# To split a large text file into smaller files of 1000 lines each:
#要将大文本文件拆分为每个1000行的较小文件：
split file.txt -l 1000

# To split a large binary file into smaller files of 10M each:
#要将大型二进制文件拆分为每个10M的较小文件：
split file.txt -b 10M

# To consolidate split files into a single file:
#要将拆分文件合并为单个文件：
cat x* > file.txt
