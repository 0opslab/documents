# To tee stdout to a file:
#要将stdout发送到文件：
ls | tee outfile.txt

# To tee stdout and append to a file:
#要发送stdout并附加到文件：
ls | tee -a outfile.txt

# To tee stdout to the terminal, and also pipe it into another program for further processing:
#要将stdout发送到终端，并将其导入另一个程序以进行进一步处理：
ls | tee /dev/tty | xargs printf "\033[1;34m%s\033[m\n"
