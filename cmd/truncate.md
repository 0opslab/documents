# title{truncate - 可以将一个文件缩小或者扩展到某个给定的大小 }

```bash
# To clear the contents from a file:
#要清除文件中的内容：
truncate -s 0 file.txt

# To truncate a file to 100 bytes:
#要将文件截断为100个字节：
truncate -s 100 file.txt

# To truncate a file to 100 KB:
#要将文件截断为100 KB：
truncate -s 100K file.txt

# (M, G, T, P, E, Z, and Y may be used in place of "K" as required.)
#（M，G，T，P，E，Z和Y可根据需要用来代替“K”。）
```
