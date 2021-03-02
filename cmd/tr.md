# title{tr - 命令用于转换或删除文件中的字符}
指令从标准输入设备读取数据，经过字符串转译后，将结果输出到标准输出设备。


## 常用参数
-c          # 用字符串1中字符集的补集替换此字符集，要求字符集为ASCII
-d          # 删除字符串1中所有输入字符
-s          # 删除所有重复出现字符序列，只保留第一个:即将重复出现字符串压缩为一个字符串
[a-z]       # a-z内的字符组成的字符串
[A-Z]       # A-Z内的字符组成的字符串
[0-9]       # 数字串
\octal      # 一个三位的八进制数，对应有效的ASCII字符
[O*n]       # 表示字符O重复出现指定次数n。因此[O*2]匹配OO的字符串

## tr中特定控制字符表达方式

\a Ctrl-G    \007    # 铃声
\b Ctrl-H    \010    # 退格符
\f Ctrl-L    \014    # 走行换页
\n Ctrl-J    \012    # 新行
\r Ctrl-M    \015    # 回车
\t Ctrl-I    \011    # tab键
\v Ctrl-X    \030
CHAR1-CHAR2 ：字符范围从 CHAR1 到 CHAR2 的指定，范围的指定以 ASCII 码的次序为基础，只能由小到大，不能由大到小。
[CHAR*] ：这是 SET2 专用的设定，功能是重复指定的字符到与 SET1 相同长度为止
[CHAR*REPEAT] ：这也是 SET2 专用的设定，功能是重复指定的字符到设定的 REPEAT 次数为止(REPEAT 的数字采 8 进位制计算，以 0 为开始)
[:alnum:] ：所有字母字符与数字
[:alpha:] ：所有字母字符
[:blank:] ：所有水平空格
[:cntrl:] ：所有控制字符
[:digit:] ：所有数字
[:graph:] ：所有可打印的字符(不包含空格符)
[:lower:] ：所有小写字母
[:print:] ：所有可打印的字符(包含空格符)
[:punct:] ：所有标点字符
[:space:] ：所有水平与垂直空格符
[:upper:] ：所有大写字母
[:xdigit:] ：所有 16 进位制的数字
[=CHAR=] ：所有符合指定的字符(等号里的 CHAR，代表你可自订的字符)



```bash
tr A-Z a-z                             # 将所有大写转换成小写字母
tr " " "\n"                            # 将空格替换为换行
tr -s "[\012]" < plan.txt              # 删除空行
tr -s ["\n"] < plan.txt                # 删除空行
tr -s "[\015]" "[\n]" < file           # 删除文件中的^M，并代之以换行
tr -s "[\r]" "[\n]" < file             # 删除文件中的^M，并代之以换行
tr -s "[:]" "[\011]" < /etc/passwd     # 替换passwd文件中所有冒号，代之以tab键
tr -s "[:]" "[\t]" < /etc/passwd       # 替换passwd文件中所有冒号，代之以tab键
echo $PATH | tr ":" "\n"               # 增加显示路径可读性
1,$!tr -d '\t'                         # tr在vi内使用，在tr前加处理行范围和感叹号('$'表示最后一行)
tr "\r" "\n"<macfile > unixfile        # Mac -> UNIX
tr "\n" "\r"<unixfile > macfile        # UNIX -> Mac
tr -d "\r"<dosfile > unixfile          # DOS -> UNIX  Microsoft DOS/Windows 约定，文本的每行以回车字符(\r)并后跟换行符(\n)结束
awk '{ print $0"\r" }'<unixfile > dosfile   # UNIX -> DOS：在这种情况下，需要用awk，因为tr不能插入两个字符来替换一个字符


#replace : with new line
##replace：用新线
echo $PATH|tr ":" "\n" #equivalent with:
echo $PATH|tr -t ":" \n 

#remove all occurance of "ab"
##remove所有出现的“ab”
echo aabbcc |tr -d "ab"
#ouput: cc
##ouput：cc

#complement "aa"
##complement“aa”
echo aabbccd |tr -c "aa" 1
#output: aa11111 without new line
##output：aa11111没有换行
#tip: Complement meaning keep aa,all others are replaced with 1
##tip：补充意义保持aa，所有其他用1替换

#complement "ab\n"
##complement“ab \ n”
echo aabbccd |tr -c "ab\n" 1
#output: aabb111 with new line
##output：带有新行的aabb111

#Preserve all alpha(-c). ":-[:digit:] etc" will be translated to "\n". sequeeze mode.
##Preserve all alpha（-c）。 “： -  [：digit：] etc”将被翻译为“\ n”。挤压模式。
echo $PATH|tr -cs "[:alpha:]" "\n" 

#ordered list to unordered list
##ordered list to unordered list
echo "1. /usr/bin\n2. /bin" |tr -cs " /[:alpha:]\n" "+"
# 大小写转换
cat testfile |tr [:lower:] [:upper:] 
```
