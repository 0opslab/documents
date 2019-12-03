# To create a *.gz compressed file
#创建* .gz压缩文件
gzip test.txt

# To create a *.gz compressed file to a specific location using -c option (standard out)
#使用-c选项（标准输出）将* .gz压缩文件创建到特定位置
gzip -c test.txt > test_custom.txt.gz

# To uncompress a *.gz file
#解压缩* .gz文件
gzip -d test.txt.gz

# Display compression ratio of the compressed file using gzip -l
#使用gzip -l显示压缩文件的压缩比
gzip -l *.gz

# Recursively compress all the files under a specified directory
#递归压缩指定目录下的所有文件
gzip -r documents_directory

# To create a *.gz compressed file and keep the original
#要创建* .gz压缩文件并保留原始文件
gzip < test.txt > test.txt.gz
