# Change file owner
#更改文件所有者
chown user file

# Change file owner and group
#更改文件所有者和组
chown user:group file

# Change owner recursively
#递归更改所有者
chown -R user directory

# Change ownership to match another file
#更改所有权以匹配另一个文件
chown --reference=/path/to/ref_file file
