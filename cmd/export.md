# title{export - 用于设置或显示环境变量}

### 常用参数
```bash
-f 　代表[变量名称]中为函数名称。
-n 　删除指定的变量。变量实际上并未删除，只是不会输出到后续指令的执行环境中。
-p 　列出所有的shell赋予程序的环境变量。

```

### 常用命令实例
```bash
# 列出当前的环境变量值
export -p

# Calling export with no arguments will show current shell attributes
#调用不带参数的导出将显示当前的shell属性
export

# Create new environment variable
#创建新的环境变量
export VARNAME="value"
```