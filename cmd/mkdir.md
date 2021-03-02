# title{mkdir - 用于创建目录的命令}

### 选项
```bash
-p 确保目录名称存在，不存在的就建一个
```

### 常用命令
```bash
# Create a directory and all its parents
#创建一个目录及其所有父目录
mkdir -p foo/bar/baz

# Create foo/bar and foo/baz directories
#创建foo / bar和foo / baz目录
mkdir -p foo/{bar,baz}

# Create the foo/bar, foo/baz, foo/baz/zip and foo/baz/zap directories
#创建foo / bar，foo / baz，foo / baz / zip和foo / baz / zap目录
mkdir -p foo/{bar,baz/{zip,zap}}
```
