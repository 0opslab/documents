# title{csplit - 令用于分割文件。拆解文件主要是split和csplit命令，如果说split是按大小来拆分的话，那么csplit则可按匹配来拆分}

-b, --suffix-format=格式      使用sprintf 格式代替%02d
-f, --prefix=前缀              使用指定前缀代替"xx"
-k, --keep-files              不移除错误的输出文件
-n, --digits=数位              使用指定的进制数位代替二进制
-s, --quiet, --silent          不显示输出文件的尺寸计数
-z, --elide-empty-files          删除空的输出文件
--help                          显示此帮助信息并退出
--version                      显示版本信息并退出

如果文件为"-"，则读取标准输入。每个"格式"可以是：
整数                          不包括指定的行，并以其为文件分块边界
/表达式/[偏移量]              不包括匹配到的行，并以其为文件分块边界
%表达式%[偏移量]              预先跳过匹配的行数，以其为文件分块边界
{整数}                          将之前指定的模式重复指定的次数
{*}                              将之前指定的模式重复尽可能多的次数。


```bash
# Split a file based on pattern
#根据模式拆分文件
csplit input.file '/PATTERN/'

# Use prefix/suffix to improve resulting file names
#使用前缀/后缀来改进生成的文件名
csplit -f 'prefix-' -b '%d.extension' input.file '/PATTERN/' '{*}'
```