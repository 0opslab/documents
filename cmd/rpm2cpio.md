# title{rpm2cpio - 将RPM软件包转换为cpio格式的文件}

```bash
# List contents of RPM
#列出RPM的内容
rpm2cpio foo.rpm | cpio -vt

# Extract contents of RPM
#提取RPM的内容
rpm2cpio foo.rpm | cpio -vid
```
