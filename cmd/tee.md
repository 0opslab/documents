# title{tee - 命令用于读取标准输入的数据，并将其内容输出成文件}

tee指令会从标准输入设备读取数据，将其内容输出到标准输出设备，同时保存成文件

### 选项
```bash
-a或–append 　附加到既有文件的后面，而非覆盖它．
-i或–ignore-interrupts 　忽略中断信号。
–help 　在线帮助。
–version 　显示版本信息。
```

### 命令
```bash
# To tee stdout to a file:
#要将stdout发送到文件：
ls | tee outfile.txt

# To tee stdout and append to a file:
#要发送stdout并附加到文件：
ls | tee -a outfile.txt

# To tee stdout to the terminal, and also pipe it into another program for further processing:
#要将stdout发送到终端，并将其导入另一个程序以进行进一步处理：
ls | tee /dev/tty | xargs printf "\033[1;34m%s\033[m\n"
```