# title{man - 查看Linux中的指令帮助}
### 选项
```bash
-a：在所有的man帮助手册中搜索；
-f：等价于whatis指令，显示给定关键字的简短描述信息；
-P：指定内容时使用分页程序；
-M：指定man手册搜索的路径。

```

### 常用命令
```bash
# Convert a man page to pdf
#将手册页转换为pdf
man -t bash | ps2pdf - bash.pdf

# View the ascii chart
#查看ascii图表
man 7 ascii
```