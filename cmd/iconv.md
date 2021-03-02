# title{iconv - 用来转换文件的编码方式的}

Linux下的iconv开发库包括iconv_open,iconv_close,iconv等C函数，可以用来在C/C++程序中很方便的转换字符编码，
这在抓取网页的程序中很有用处，而iconv命令在调试此类程序时用得着。

### 常用选项
```bash
-f encoding :把字符从encoding编码开始转换。 
-t encoding :把字符转换到encoding编码。 
-l :列出已知的编码字符集合 
-o file :指定输出文件 
-c :忽略输出的非法字符 
-s :禁止警告信息，但不是错误信息 
--verbose :显示进度信息 
-f和-t所能指定的合法字符在-l选项的命令里面都列出来了。
```

### 常用命令
```bash
# 列出当前支持的字符编码
iconv -l

# 将文件file1转码，转后文件输出到fil2中
iconv file1 -f EUC-JP-MS -t UTF-8 -o file2


# To convert file (iconv.src) from iso-8859-1 to utf-8 and save to
#将文件（iconv.src）从iso-8859-1转换为utf-8并保存到
# /tmp/iconv.out
#/tmp/icon V.呕吐
iconv -f iso-8859-1 -t utf-8 iconv.src -o /tmp/iconv.out
```