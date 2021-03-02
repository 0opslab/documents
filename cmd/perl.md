# title{perl - perl命令}

```bash
# To view the perl version:
#要查看perl版本：
perl -v

# Replace string "\n" to newline
#将字符串“\ n”替换为换行符
echo -e "foo\nbar\nbaz" | perl -pe 's/\n/\\n/g;'

# Replace newline with multiple line to space
#用多行到空格替换换行符
cat test.txt | perl -0pe "s/test1\ntest2/test1 test2/m"
```