# title{encoding - Linux编码相关的那些操作}
如果你需要在Linux中操作windows下的文件，那么你可能会经常遇到文件编码转换的问题。
Windows中默认的文件格式是GBK(gb2312)，而Linux一般都是UTF-8。下面介绍一下，
在Linux中如何查看文件的编码及如何进行对文件进行编码转换。


# 查看文件编码
在linux中查看文件编码可以通过以下几种方式
## 在vim中使用指定的编码查看
:set fileencoding
即可以制定的文件编码格式，如果只是想查看其它编码格式的文件或者想解决用Vim查看文件乱码的问题，
当然可以直接在.vimrc文件中设置。
例如
```bash
set encoding=utf-8
fileencoding=ucs-bom,utf-8,cp936
```
这样，就可以让vim自动识别文件编码（可以自动识别UTF-8或者GBK编码的文件），其实就是依照 
fileencodings提供的编码列表尝试，如果没有找到合适的编码，就用latin-1(ASCII)编码打开。
## 查看文件编码
linux下可以使用enca命令查看文件编码，但是对中文编码支持不是很好。
例如:
```bash
$ enca -L zh_CN bash.txt
Universal transformation format 8 bits; UTF-8

  CRLF line terminators
```
## 文件编码转换
在Vim中直接进行转换文件编码,比如将一个文件转换成utf-8格式
```bash
:set fileencoding=utf-8
```
##  iconv 转换
iconv的命令格式如下
```bash
$ iconv -f encoding -t encoding inputfile
//比如将一个UTF-8 编码的文件转换成GBK编码
$ iconv -f GBK -t UTF-8 file1 -o file2
```
## enconv 转换文件编码
比如要将一个GBK编码的文件转换成UTF-8编码，操作如下
```bash
$ enconv -L zh_CN -x UTF-8 filename
```
查看系统当前编码 locale
查看系统支持的编码 iconv -l
查看文件的编码  file -i  (注意与type不同，查看命令的类型）
在vim中 :edit  ++enc=utf8/gb18030/gb2312... 但只是编辑时转码了，重新打开还是乱码的，
最好用iconv 转码，如windows文件转到Linux下，如果使用dos2unix之后（一般只是去掉换行^M而已）
还会乱码，则可以 iconv -f GBK -t UTF-8 file1 -o file2
