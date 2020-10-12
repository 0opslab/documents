# open encrypted partition /dev/sdb1 (reachable at /dev/mapper/backup)
#打开加密分区/ dev / sdb1（可在/ dev / mapper / backup处访问）
cryptsetup open --type luks /dev/sdb1 backup

# open encrypted partition /dev/sdb1 using a keyfile (reachable at /dev/mapper/hdd)
#使用密钥文件打开加密分区/ dev / sdb1（可在/ dev / mapper / hdd处访问）
cryptsetup open --type luks --key-file hdd.key /dev/sdb1 hdd

# close luks container at /dev/mapper/hdd
#在/ dev / mapper / hdd关闭luks容器
cryptsetup close hdd
