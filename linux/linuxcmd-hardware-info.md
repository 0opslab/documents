# Display all hardware details
#显示所有硬件细节
sudo lshw

# List currently loaded kernel modules
#列出当前加载的内核模块
lsmod

# List all modules available to the system
#列出系统可用的所有模块
find /lib/modules/$(uname -r) -type f -iname "*.ko"

# Load a module into kernel
#将模块加载到内核中
modprobe modulename

# Remove a module from kernel 
#从内核中删除模块
modprobe -r modulename

# List devices connected via pci bus
#列出通过pci总线连接的设备
lspci

# Debug output for pci devices (hex)
#pci设备的调试输出（十六进制）
lspci -vvxxx

# Display cpu hardware stats
#显示CPU硬件统计信息
cat /proc/cpuinfo

# Display memory hardware stats
#显示内存硬件统计信息
cat /proc/meminfo

# Output the kernel ring buffer
#输出内核环缓冲区
dmesg

# Ouput kernel messages
#输出内核消息
dmesg --kernel
