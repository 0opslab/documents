# Remove files and subdirs
#删除文件和子目录
rm -rf path/to/the/target/

# Ignore non existent files
#忽略不存在的文件
rm -f path/to/the/target

# Remove a file with his inode
#使用他的inode删除文件
find /tmp/ -inum 6666 -exec rm -i '{}' \;
