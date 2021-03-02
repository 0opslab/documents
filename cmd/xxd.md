# title{xxd - 主要用来查看文件对应的十六进制形式}

### 选项
```bash
-a : 它的作用是自动跳过空白内容，默认是关闭的
-c : 它的后面加上数字表示每行显示多少字节的十六进制数，默认是16bytes，最大是256bytes
-g : 设定以几个字节为一块，默认为2bytes
-l : 显示多少字节的内容
-s : 后面接【+-】和address。“+”表示从地址处开始的内容，“-”表示距末尾address开始的内容
-b:以二进制（0 or 1）的形式查看文件内容
-r:reverse operation: convert (or patch) hexdump into binary.
```

### 常用命令
```bash
# Convert bin/string to hex.
#将bin / string转换为hex。
# Result: 34322069732074686520736f6c7574696f6e0a
#结果：34322069732074686520736f6c7574696f6e0a
echo '42 is the solution' | xxd -p

# Convert hex to bin/string.
#将十六进制转换为bin / string。
# Result: 42 is the solution
#结果：42是解决方案
echo '34322069732074686520736f6c7574696f6e0a' | xxd -r -p

```
