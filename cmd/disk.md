# title{disk - 磁盘相关操作的常用命令}
## 常用命令

```bash
df -Ph                                # 查看硬盘容量
df -T                                 # 查看磁盘分区格式
df -i                                 # 查看inode节点   如果inode用满后无法创建文件
du -h 目录                            # 检测目录下所有文件大小
du -sh *                              # 显示当前目录中子目录的大小
iostat -x                             # 查看磁盘io状态
mount                                 # 查看分区挂载情况
fdisk -l                              # 查看磁盘分区状态
fdisk /dev/hda3                       # 分区 
mkfs -t ext3  /dev/hda3               # 格式化分区
fsck -y /dev/sda6                     # 对文件系统修复
lsof |grep delete                     # 释放进程占用磁盘空间  列出进程后，查看文件是否存在，不存在则kill掉此进程
tmpwatch -afv 3                       # 删除3小时内的临时文件
cat /proc/filesystems                 # 查看当前系统支持文件系统
mount -o remount,rw /                 # 修改只读文件系统为读写
smartctl -H /dev/sda                  # 检测硬盘状态
smartctl -i /dev/sda                  # 检测硬盘信息
smartctl -a /dev/sda                  # 检测所有信息
e2label /dev/sda5                     # 查看卷标
e2label /dev/sda5 new-label           # 创建卷标
ntfslabel -v /dev/sda8 new-label      # NTFS添加卷标
tune2fs -j /dev/sda                   # ext2分区转ext3分区
mke2fs -b 2048 /dev/sda5              # 指定索引块大小
dumpe2fs -h /dev/sda5                 # 查看超级块的信息
mount -t iso9660 /dev/dvd  /mnt       # 挂载光驱
mount -t ntfs-3g /dev/sdc1 /media/yidong        # 挂载ntfs硬盘
mount -t nfs 10.0.0.3:/opt/images/  /data/img   # 挂载nfs
mount -o loop  /software/rhel4.6.iso   /mnt/    # 挂载镜像文件
```
## 创建swap文件方法

```bash
dd if=/dev/zero of=/swap bs=1024 count=4096000            # 创建一个足够大的文件
# count的值等于1024 x 你想要的文件大小, 4096000是4G
mkswap /swap                      # 把这个文件变成swap文件
swapon /swap                      # 启用这个swap文件
/swap swap swap defaults 0 0      # 在每次开机的时候自动加载swap文件, 需要在 /etc/fstab 文件中增加一行
cat /proc/swaps                   # 查看swap
swapoff -a                        # 关闭swap
swapon -a                         # 开启swap
```

## 新硬盘挂载
```bash
fdisk /dev/sdc 
p	#  打印分区
d 	#  删除分区
n	#  创建分区，（一块硬盘最多4个主分区，扩展占一个主分区位置。p主分区 e扩展）
w	#  保存退出
mkfs -t ext3 -L 卷标  /dev/sdc1		# 格式化相应分区
mount /dev/sdc1  /mnt		# 挂载
vi /etc/fstab               # 添加开机挂载分区
LABEL=/data            /data                   ext3    defaults        1 2      # 用卷标挂载
/dev/sdb1              /data4                  ext3    defaults        1 2      # 用真实分区挂载
/dev/sdb2              /data4                  ext3    noatime,defaults        1 2

第一个数字"1"该选项被"dump"命令使用来检查一个文件系统应该以多快频率进行转储，若不需要转储就设置该字段为0
第二个数字"2"该字段被fsck命令用来决定在启动时需要被扫描的文件系统的顺序，根文件系统"/"对应该字段的值应该为1，其他文件系统应该为2。若该文件系统无需在启动时扫描则设置该字段为0
当以 noatime 选项加载（mount）文件系统时，对文件的读取不会更新文件属性中的atime信息。设置noatime的重要性是消除了文件系统对文件的写操作，文件只是简单地被系统读取。由于写操作相对读来说要更消耗系统资源，所以这样设置可以明显提高服务器的性能.wtime信息仍然有效，任何时候文件被写，该信息仍被更新。
```

## raid原理与区别

raid0至少2块硬盘.吞吐量大,性能好,同时读写,但损坏一个就完蛋
raid1至少2块硬盘.相当镜像,一个存储,一个备份.安全性比较高.但是性能比0弱
raid5至少3块硬盘.分别存储校验信息和数据，坏了一个根据校验信息能恢复
raid6至少4块硬盘.两个独立的奇偶系统,可坏两块磁盘,写性能非常差





