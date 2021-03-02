# title{less - less 可以随意浏览文件}

### 常用参数
```bash
-b <缓冲区大小> 设置缓冲区的大小
-e 当文件显示结束后，自动离开
-f 强迫打开特殊文件，例如外围设备代号、目录和二进制文件
-g 只标志最后搜索的关键词
-i 忽略搜索时的大小写
-m 显示类似more命令的百分比
-N 显示每行的行号
-o <文件名> 将less 输出的内容在指定文件中保存起来
-Q 不使用警告音
-s 显示连续空行为一行
-S 行过长时间将超出部分舍弃
-x <数字> 将"tab"键显示为规定的数字空格
/字符串：向下搜索"字符串"的功能
?字符串：向上搜索"字符串"的功能
n：重复前一个搜索（与 / 或 ? 有关）
N：反向重复前一个搜索（与 / 或 ? 有关）
b 向上翻一页
d 向后翻半页
h 显示帮助界面
Q 退出less 命令
u 向前滚动半页
y 向前滚动一行
空格键 滚动一页
回车键 滚动一行
[pagedown]： 向下翻动一页
[pageup]： 向上翻动一页

```

### 常用命令
```bash
# To disable the terminal refresh when exiting
#退出时禁用终端刷新
less -X

# To save the contents to a file
#将内容保存到文件
# Method 1 - Only works when the input is a pipe
#方法1  - 仅在输入为管道时有效
s <filename>

# Method 2 - This should work whether input is a pipe or an ordinary file.
#方法2  - 无论输入是管道还是普通文件，这都应该有效。
Type g or < (g or less-than) | $ (pipe then dollar) then cat > <filename> and Enter.
```