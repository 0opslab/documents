# title{cups - 通过cups来控制打印q}

```bash
# Manage printers through CUPS:
#通过CUPS管理打印机：
http://localhost:631 (in web browser)

# Print file from command line
#从命令行打印文件
lp myfile.txt

# Display print queue
#显示打印队列
lpq

# Remove print job from queue
#从队列中删除打印作业
lprm 545
or
lprm -

# Print log location
#打印日志位置
/var/log/cups

# Reject new jobs
#拒绝新的工作
cupsreject printername

# Accept new jobs
#接受新工作
cupsaccept printername
```