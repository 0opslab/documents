# title{pushd - 将目录加入命令堆叠中}

pushd命令 是将目录加入命令堆叠中。如果指令没有指定目录名称，则会将当前的工作目录置入目录堆叠的最顶端。
置入目录如果没有指定堆叠的位置，也会置入目录堆叠的最顶端，同时工作目录会自动切换到目录堆叠最顶端的目录去。

### 选项
```bash
-n：只加入目录到堆叠中，不进行cd操作；
+n：删除从左到右的第n个目录，数字从0开始；
-n：删除从右到左的第n个目录，数字从0开始；
```

### 常用命令
```bash
# Pushes your current directory to the top of a stack while changing to the specified directory
pushd <directory>

# To return use popd
popd
```
