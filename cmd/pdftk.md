# title{pdftk - 一款操作pdf的命令}

```bash
# Concatenate all pdf files into one:
#＃将所有pdf文件连接成一个：
pdftk *.pdf cat output all.pdf

# Concatenate specific pdf files into one:
#将特定的pdf文件连接成一个：
pdftk 1.pdf 2.pdf 3.pdf cat output 123.pdf

# Concatenate pages 1 to 5 of first.pdf with page 3 of second.pdf
#＃将first.pdf的第1页和第5页连接到第二页.pdf的第3页
pdftk A=fist.pdf B=second.pdf cat A1-5 B3 output new.pdf
```
