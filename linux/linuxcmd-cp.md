# Create a copy of a file
#创建文件的副本
cp ~/Desktop/foo.txt ~/Downloads/foo.txt

# Create a copy of a directory
#创建目录的副本
cp -r ~/Desktop/cruise_pics/ ~/Pictures/

# Create a copy but ask to overwrite if the destination file already exists
#创建副本，但要求覆盖目标文件是否已存在
cp -i ~/Desktop/foo.txt ~/Documents/foo.txt

# Create a backup file with date
#使用日期创建备份文件
cp foo.txt{,."$(date +%Y%m%d-%H%M%S)"}
