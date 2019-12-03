# List contents of RPM
#列出RPM的内容
rpm2cpio foo.rpm | cpio -vt

# Extract contents of RPM
#提取RPM的内容
rpm2cpio foo.rpm | cpio -vid