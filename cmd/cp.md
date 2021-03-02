# title{cp - 命令主要用于复制文件或目录}

数说明：

-a：此选项通常在复制目录时使用，它保留链接、文件属性，并复制目录下的所有内容。其作用等于dpR参数组合。
-d：复制时保留链接。这里所说的链接相当于Windows系统中的快捷方式。
-f：覆盖已经存在的目标文件而不给出提示。
-i：与-f选项相反，在覆盖目标文件之前给出提示，要求用户确认是否覆盖，回答"y"时目标文件将被覆盖。
-p：除复制文件的内容外，还把修改时间和访问权限也复制到新文件中。
-r：若给出的源文件是一个目录文件，此时将复制该目录下所有的子目录和文件。
-l：不复制文件，只是生成链接文件。


```bash
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
```

# 备份文件
```bash
for File in /etc/fstab /etc/inittab /etc/rc.d/init.d/functions; do
  FileName=`basename $File`
  cp $File /tmp/$FileName-`date +%F`
done
```
