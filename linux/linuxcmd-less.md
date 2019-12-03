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
