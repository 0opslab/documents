# title{tail - 在屏幕上显示指定文件的末尾若干行}

### 选项
```bash
--retry：即是在tail命令启动时，文件不可访问或者文件稍后变得不可访问，都始终尝试打开文件。使用此选项时需要与选项“——follow=name”连用；
-c<N>或——bytes=<N>：输出文件尾部的N（N为整数）个字节内容；
-f<name/descriptor>或；--follow<nameldescript>：显示文件最新追加的内容。。“-f”与“-fdescriptor”等效；
-F：与选项“-follow=name”和“--retry"连用时功能相同；
-n<N>或——line=<N>：输出文件的尾部N（N位数字）行内容。
--pid=<进程号>：与“-f”选项连用，当指定的进程号的进程终止后，自动退出tail命令；
-q或——quiet或——silent：当有多个文件参数时，不输出各个文件名；
-s<秒数>或——sleep-interal=<秒数>：与“-f”选项连用，指定监视文件变化时间隔的秒数；
-v或——verbose：当有多个文件参数时，总是输出各个文件名；
--help：显示指令的帮助信息；
--version：显示指令的版本信息。
```

### 常用命令
```bash
# To show the last 10 lines of file
#显示最后10行文件
tail file

# To show the last N lines of file
#显示最后N行文件
tail -n N file

# To show the last lines of file starting with the Nth
#显示以Nth开头的最后一行文件
tail -n +N file

# To show the last N bytes of file
#显示文件的最后N个字节
tail -c N file

# To show the last 10 lines of file and to wait for file to grow
#显示最后10行文件并等待文件增长
tail -f file
```
