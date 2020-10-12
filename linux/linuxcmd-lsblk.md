# Show all available block devices along with their partitioning schemes
#显示所有可用的块设备及其分区方案
lsblk

# To show SCSI devices:
#要显示SCSI设备：
lsblk --scsi

# To show a specific device
#显示特定设备
lsblk /dev/sda

# To verify TRIM support:
#要验证TRIM支持：
# Check the values of DISC-GRAN (discard granularity) and DISC-MAX (discard max bytes) columns.
#检查DISC-GRAN（丢弃粒度）和DISC-MAX（丢弃最大字节）列的值。
# Non-zero values indicate TRIM support
#非零值表示TRIM支持
lsblk --discard

# To featch info about filesystems:
#要获取有关文件系统的信息：
lsblk --fs

# For JSON, LIST or TREE output formats use the following flags:
#对于JSON，LIST或TREE输出格式，使用以下标志：
lsblk --json
lsblk --list
lsblk --tree # default view
