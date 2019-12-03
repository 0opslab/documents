# To shred a file (5 passes) and verbose output:
#要粉碎文件（5遍）和详细输出：
shred -n 5 -v file.txt

# To shred a file (5 passes) and a final overwrite of zeroes:
#要粉碎文件（5遍）并最后覆盖零：
shred -n 5 -vz file.txt

# To do the above, and then truncate and rm the file:
#要执行上述操作，然后截断并运行该文件：
shred -n 5 -vzu file.txt

# To shred a partition:
#要粉碎分区：
shred -n 5 -vz /dev/sda

# Remember that shred may not behave as expected on journaled file systems if file data is being journaled.
#请记住，如果正在记录文件数据，则shred可能在日志文件系统上的行为不正常。
