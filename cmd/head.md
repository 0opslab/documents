# title{head - 在屏幕上显示指定文件的开头若干行}

### 常用选项
```bash
-n<数字>：指定显示头部内容的行数；
-c<字符数>：指定显示头部内容的字符数；
-v：总是显示文件名的头信息；
-q：不显示文件名的头信息。
```

### 常用命令
```bash
# To show the first 10 lines of file
#显示前10行文件
head file

# To show the first N lines of file
#显示前N行文件
head -n N file

# To show the first N bytes of file
#显示文件的前N个字节
head -c N file
```