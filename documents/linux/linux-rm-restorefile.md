title: 恢复rm删除的文件
date: 2016-01-31 13:13:22
tags: Linux
categories: Linux
---
在ext3/ext4文件系统下extundelete算是最给给力的工具,在实际环境中将extundelete安装单独的硬盘上
在执行extundelete执行完毕后在当前目录下生产一个RECOVERED_FILES目录，里面即是恢复出来的文件，
还包括文件夹。 任何的文件恢复工具，在使用前，均要将要恢复的分区卸载或挂载为只读，防止数据被覆
盖使用
```bash
#umount /dev/partition
#mount -o remount,ro /dev/partition 
```
# 安装
```bash
# yum install e2fsprogs* e2fslibs* -y 
# wget http://nchc.dl.sourceforge.net/project/extundelete/extundelete/0.2.4/extundelete-0.2.4.tar.bz2 
# tar -axf extundelete-0.2.4.tar.bz2 -C /usr/local/src 
# cd /usr/local/src/extundelete-0.2.4 
# ./configure --prefix=/usr/local/extundelete 
# make 
# make install 
# ln -s /usr/local/extundelete/bin/* /usr/local/bin/ 

```
# 使用及命令
## umount或者read only 分区
```bash
$ umount /dev/partition
$ mount -o remount,ro /dev/partition 
// 切换到存储恢复文件的目录 
$ cd $dir 
```
## 命令
```bash
Usage: extundelete [options] [--] device-file 
Options: 
--superblock 打印指定分区的超级块信息。如不加任何的参数， 
此选项是默认的.
extundelete --superblock /dev/sda3 <---> extundelete /dev/sda1 

--journal显示块的日志信息，同--superblock。 
extundelete --journal /dev/sda1 

--after dtime只恢复指定时间【dtime】（时间戳）之后，被删除的数据 

假如删除的时间大概是2011-7-26 14：30 
date -d "Jul 26 14:30" +%s 
得出秒数 1234567890 
恢复此时间后删除的所有文件 
extundelete /dev/sdb1 --after 1234567890 --restore-all 

--before dtime 只恢复指定时间【dtime】（时间戳）之前，被删除的数据 

Actions: 
--inode ino显示某分区inode为x的信息，一般是查看该分区下所有的文件. 
extundelete --inode 2 /dev/sda1 

--block blk显示某分区block为x的信息. 

--restore-inode ino[,ino,...] 恢复一个或多个指定inode号的文件，该恢复的文件， 
保存在当前目录下的RECOVERED_FILES里，文件名为【file.$inode】 
extundelete /dev/sda1 --restore-inode 13,14 

--restore-file 'filename'恢复指定的文件（被删除的），文件位于当前目录下 
的RECOVERED_FILES/$filename，文件名还是原来的 
extundelete /dev/sda1 --restore-file initramfs-2.6.32-358.el6.x86_64.img 

--restore-files 'read_filename'恢复指定的文件（真实存在的）中的内容， 
文件位于当前目录下的RECOVERED_FILES/$filename，文件名还是原来的 
vi test_restore.txt(结尾不可有多余的空格) 
 System.map-2.6.32-358.el6.x86_64 
 config-2.6.32-358.el6.x86_64 
 symvers-2.6.32-358.el6.x86_64.gz 
 vmlinuz-2.6.32-358.el6.x86_64 
 initramfs-2.6.32-358.el6.x86_64.img 
 extundelete /dev/sda1--restore-files test_restore.txt 


--restore-directory 'dir-name'恢复指定的目录，文件位于当前目录下的 
RECOVERED_FILES/$dir-name，文件名还是原来的 
  extundelete /dev/sda1--restore-files grub 

--restore-all  恢复某分区里所有被删除的数据，文件名还是原来的 
   extundelete /dev/sda1 --restore-all 
```

