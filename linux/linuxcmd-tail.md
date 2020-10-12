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
