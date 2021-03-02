# title{bash - 简单的bash编程入门}
## 基础说明
```bash
	#!/bin/sh         # 在脚本第一行脚本头 # sh为当前系统默认shell,可指定为bash等shell
	sh -x             # 执行过程
	sh -n             # 检查语法
	(a=bbk)           # 括号创建子shell运行
	basename /a/b/c   # 从全路径中保留最后一层文件名或目录
	dirname           # 取路径
	$RANDOM           # 随机数
	$$                # 进程号
	source FileName   # 在当前bash环境下读取并执行FileName中的命令  # 等同 . FileName
	sleep 5           # 间隔睡眠5秒
	trap              # 在接收到信号后将要采取的行动
	trap "" 2 3       # 禁止ctrl+c
	$PWD              # 当前目录
	$HOME             # 家目录
	$OLDPWD           # 之前一个目录的路径
	cd -              # 返回上一个目录路径
	local ret         # 局部变量
	yes               # 重复打印
	yes |rm -i *      # 自动回答y或者其他
	ls -p /home       # 查看目录所有文件夹
	ls -d /home/      # 查看匹配完整路径
	echo -n aa;echo bb                    # 不换行执行下一句话 将字符串原样输出
	echo -e "s\tss\n\n\n"                 # 使转义生效
	echo $a | cut -c2-6                   # 取字符串中字元
	echo {a,b,c}{a,b,c}{a,b,c}            # 排列组合(括号内一个元素分别和其他括号内元素组合)
	echo $((2#11010))                     # 二进制转10进制
	echo aaa | tee file                   # 打印同时写入文件 默认覆盖 -a追加
	echo {1..10}                          # 打印10个字符
	printf '%10s\n'|tr " " a              # 打印10个字符
	pwd | awk -F/ '{ print $2 }'          # 返回目录名
	tac file |sed 1,3d|tac                # 倒置读取文件  # 删除最后3行
	tail -3 file                          # 取最后3行
	outtmp=/tmp/$$`date +%s%N`.outtmp     # 临时文件定义
	:(){ :|:& };:                         # 著名的 fork炸弹,系统执行海量的进程,直到系统僵死
	echo -e "\e[32m....\e[0m"             # 打印颜色
	echo -e "\033[0;31mL\033[0;32mO\033[0;33mV\033[0;34mE\t\033[0;35mY\033[0;36mO\033[0;32mU\e[m"    # 打印颜色
```
## 正则表达式
```bash
^  	      # 行首定位
$ 	      # 行尾定位
. 	      # 匹配除换行符以外的任意字符
*	      # 匹配0或多个重复字符
+ 	      # 重复一次或更多次
? 	      # 重复零次或一次
?         # 结束贪婪因子 .*? 表示最小匹配
[]	      # 匹配一组中任意一个字符
[^]	      # 匹配不在指定组内的字符
\	      # 用来转义元字符
<	      # 词首定位符(支持vi和grep)  <love
>	      # 词尾定位符(支持vi和grep)  love>
x\{m\}    # 重复出现m次
x\{m,\}   # 重复出现至少m次
x\{m,n\}  # 重复出现至少m次不超过n次
X? 	      # 匹配出现零次或一次的大写字母 X
X+ 	      # 匹配一个或多个字母 X
()        # 括号内的字符为一组
(ab|de)+  # 匹配一连串的（最少一个） abc 或 def；abc 和 def 将匹配
[[:alpha:]]    # 代表所有字母不论大小写
[[:lower:]]    # 表示小写字母 
[[:upper:]]    # 表示大写字母
[[:digit:]]    # 表示数字字符
[[:digit:][:lower:]]    # 表示数字字符加小写字母 


\d 	  # 匹配任意一位数字
\D 	  # 匹配任意单个非数字字符
\w 	  # 匹配任意单个字母数字下划线字符，同义词是 [:alnum:]
\W    # 匹配非数字型的字符

\s 	  # 匹配任意的空白符
\S    # 匹配非空白字符
\b 	  # 匹配单词的开始或结束
\n    # 匹配换行符
\r    # 匹配回车符
\t    # 匹配制表符
\b    # 匹配退格符
\0    # 匹配空值字符

\b    # 匹配字边界(不在[]中时)
\B    # 匹配非字边界
\A    # 匹配字符串开头
\Z    # 匹配字符串或行的末尾
\z    # 只匹配字符串末尾
\G    # 匹配前一次m//g离开之处

(exp)                # 匹配exp,并捕获文本到自动命名的组里
(?<name>exp)         # 匹配exp,并捕获文本到名称为name的组里，也可以写成(?'name'exp)
(?:exp)              # 匹配exp,不捕获匹配的文本，也不给此分组分配组号

(?=exp)              # 匹配exp前面的位置
(?<=exp)             # 匹配exp后面的位置
(?!exp)              # 匹配后面跟的不是exp的位置
(?<!exp)             # 匹配前面不是exp的位置
(?#comment)	         # 注释不对正则表达式的处理产生任何影响，用于注释

http://en.wikipedia.org/wiki/Ascii_table
^H  \010 \b  
^M  \015 \r
匹配特殊字符: ctrl+V ctrl不放在按H或M 即可输出^H,用于匹配
```

## 流程结构
```bash
	
#if判断
if [ $a == $b ]
then
  echo "等于"
else
  echo "不等于"
fi

#case分支选择
case $xs in
0) echo "0" ;;
1) echo "1" ;;
*) echo "其他" ;;
esac


# while循环
# while true  等同   while :
# 读文件为整行读入
num=1
while [ $num -lt 10 ]
do
echo $num
((num=$num+2))
done
###########################
grep a  a.txt | while read a
do
  echo $a
done
###########################
while read a
do
  echo $a
done < a.txt 

## for循环
# 读文件已空格分隔
w=`awk -F ":" '{print $1}' c`
for d in $w
do
  $d
done
###########################
for ((i=0;i<${#o[*]};i++))
do
echo ${o[$i]}
done

## until循环
#  当command不为0时循环
until command	
do
  body
done

# 流程控制
break N     #  跳出几层循环
continue N  #  跳出几层循环，循环次数不变
continue    #  重新循环次数不变
```


## 变量
```bash
		A="a b c def"           # 将字符串复制给变量
		A=`cmd`                 # 将命令结果赋给变量
		A=$(cmd)                # 将命令结果赋给变量
		eval a=\$$a             # 间接调用
		i=2&&echo $((i+3))      # 计算后打印新变量结果
		i=2&&echo $[i+3]        # 计算后打印新变量结果
		a=$((2>6?5:8))          # 判断两个值满足条件的赋值给变量
		A=(a b c def)           # 将变量定义为組数
		$1  $2  $*              # 位置参数 *代表所有
		env                     # 查看环境变量
		env | grep "name"       # 查看定义的环境变量
		set                     # 查看环境变量和本地变量
		read name               # 输入变量
		readonly name           # 把name这个变量设置为只读变量,不允许再次设置
		readonly                # 查看系统存在的只读文件
		export name             # 变量name由本地升为环境
		export name="RedHat"    # 直接定义name为环境变量
		export Stat$nu=2222     # 变量引用变量赋值
		unset name              # 变量清除
		export -n name          # 去掉只读变量
		shift                   # 用于移动位置变量,调整位置变量,使$3的值赋给$2.$2的值赋予$1
		name + 0                # 将字符串转换为数字
		number " "              # 将数字转换成字符串
```
## 定义变量类型
```bash
declare 或 typeset
-r 只读(readonly一样)
-i 整形
-a 数组
-f 函数
-x export
declare -i n=0
```

## 系统变量
```bash
$0   #  脚本启动名(包括路径)
$n   #  第n个参数,n=1,2,…9
$*   #  所有参数列表(不包括脚本本身)
$@   #  所有参数列表(独立字符串)
$#   #  参数个数(不包括脚本本身)
$$   #  当前程式的PID
$!   #  执行上一个指令的PID
$?   #  执行上一个指令的返回值
```

## 变量引用技巧
```bash
${name:+value}        # 如果设置了name,就把value显示,未设置则为空
${name:-value}        # 如果设置了name,就显示它,未设置就显示value
${name:?value}        # 未设置提示用户错误信息value 
${name:=value}        # 如未设置就把value设置并显示<写入本地中>
${#A}                 # 可得到变量中字节
${#A[*]}              # 数组个数
${A[*]}               # 数组所有元素
${A[@]}               # 数组所有元素(标准)
${A[2]}               # 脚本的一个参数或数组第三位
${A:4:9}              # 取变量中第4位到后面9位
${A/www/http}         # 取变量并且替换每行第一个关键字
${A//www/http}        # 取变量并且全部替换每行关键字
  
#定义了一个变量： file=/dir1/dir2/dir3/my.file.txt
${file#*/}     # 去掉第一条 / 及其左边的字串：dir1/dir2/dir3/my.file.txt
${file##*/}    # 去掉最后一条 / 及其左边的字串：my.file.txt
${file#*.}     # 去掉第一个 .  及其左边的字串：file.txt
${file##*.}    # 去掉最后一个 .  及其左边的字串：txt
${file%/*}     # 去掉最后条 / 及其右边的字串：/dir1/dir2/dir3
${file%%/*}    # 去掉第一条 / 及其右边的字串：(空值)
${file%.*}     # 去掉最后一个 .  及其右边的字串：/dir1/dir2/dir3/my.file
${file%%.*}    # 去掉第一个 .  及其右边的字串：/dir1/dir2/dir3/my
#   # 是去掉左边(在键盘上 # 在 $ 之左边)
#   % 是去掉右边(在键盘上 % 在 $ 之右边)
#   单一符号是最小匹配﹔两个符号是最大匹配
```

## test条件判断
```bash
# 符号 [ ] 等同  test命令

expression为字符串操作{
  -n str   # 字符串str是否不为空
  -z str   # 字符串str是否为空
}

expression为文件操作{
  -a     # 并且，两条件为真
  -b     # 是否块文件     
  -p     # 文件是否为一个命名管道
  -c     # 是否字符文件   
  -r     # 文件是否可读
  -d     # 是否一个目录   
  -s     # 文件的长度是否不为零
  -e     # 文件是否存在   
  -S     # 是否为套接字文件
  -f     # 是否普通文件   
  -x     # 文件是否可执行，则为真
  -g     # 是否设置了文件的 SGID 位 
  -u     # 是否设置了文件的 SUID 位
  -G     # 文件是否存在且归该组所有 
  -w     # 文件是否可写，则为真
  -k     # 文件是否设置了的粘贴位  
  -t fd  # fd 是否是个和终端相连的打开的文件描述符（fd 默认为 1）
  -o     # 或，一个条件为真
  -O     # 文件是否存在且归该用户所有
  !      # 取反
}

expression为整数操作{
  expr1 -a expr2   # 如果 expr1 和 expr2 评估为真，则为真
  expr1 -o expr2   # 如果 expr1 或 expr2 评估为真，则为真
}

两值比较{
  整数	 字符串
  -lt      <         # 小于
  -gt      >         # 大于
  -le      <=        # 小于或等于
  -ge      >=        # 大于或等于
  -eq      ==        # 等于
  -ne      !=        # 不等于
}

test 10 -lt 5       # 判断大小
echo $?             # 查看上句test命令返回状态  # 结果0为真,1为假
test -n "hello"     # 判断字符串长度是否为0
[ $? -eq 0 ] && echo "success" || exit　　　# 判断成功提示,失败则退出
```

## 重定向
```bash
#  标准输出 stdout 和 标准错误 stderr  标准输入stdin
cmd 1> fiel              # 把 标准输出 重定向到 file 文件中
cmd > file 2>&1          # 把 标准输出 和 标准错误 一起重定向到 file 文件中
cmd 2> file              # 把 标准错误 重定向到 file 文件中
cmd 2>> file             # 把 标准错误 重定向到 file 文件中(追加)
cmd >> file 2>&1         # 把 标准输出 和 标准错误 一起重定向到 file 文件中(追加)
cmd < file >file2        # cmd 命令以 file 文件作为 stdin(标准输入)，以 file2 文件作为 标准输出
cat <>file               # 以读写的方式打开 file
cmd < file cmd           # 命令以 file 文件作为 stdin
cmd << delimiter
cmd; #从 stdin 中读入，直至遇到 delimiter 分界符


>&n    # 使用系统调用 dup (2) 复制文件描述符 n 并把结果用作标准输出
<&n    # 标准输入复制自文件描述符 n
<&-    # 关闭标准输入（键盘）
>&-    # 关闭标准输出
n<&-   # 表示将 n 号输入关闭
n>&-   # 表示将 n 号输出关闭
```
## 运算符
```bash
$[]等同于$(())  # $[]表示形式告诉shell求中括号中的表达式的值
~var            # 按位取反运算符,把var中所有的二进制为1的变为0,为0的变为1
var\<<str       # 左移运算符,把var中的二进制位向左移动str位,忽略最左端移出的各位,最右端的各位上补上0值,每做一次按位左移就有var乘2
var>>str        # 右移运算符,把var中所有的二进制位向右移动str位,忽略最右移出的各位,最左的各位上补0,每次做一次右移就有实现var除以2
var&str         # 与比较运算符,var和str对应位,对于每个二进制来说,如果二都为1,结果为1.否则为0
var^str         # 异或运算符,比较var和str对应位,对于二进制来说如果二者互补,结果为1,否则为0
var|str         # 或运算符,比较var和str的对应位,对于每个二进制来说,如二都该位有一个1或都是1,结果为1,否则为0

##运算符优先级{
##级别      运算符                                  说明
1      =,+=,-=,/=,%=,*=,&=,^=,|=,<<=,>>==     # 赋值运算符
2         ||                                  # 逻辑或 前面不成功执行
3         &&                                  # 逻辑与 前面成功后执行
4         |                                   # 按位或
5         ^                                   # 按异位与
6         &                                   # 按位与
7         ==,!=                               # 等于/不等于
8         <=,>=,<,>                           # 大于或等于/小于或等于/大于/小于 
9        \<<,>>                               # 按位左移/按位右移 (无转意符号)
10        +,-                                 # 加减
11        *,/,%                               # 乘,除,取余
12        ! ,~                                # 逻辑非,按位取反或补码
13        -,+                                 # 正负


## 数学运算
	
$(( ))        # 整数运算
+ - * / **    # 分別为 "加、減、乘、除、密运算"
& | ^ !       # 分別为 "AND、OR、XOR、NOT" 运算
%             # 余数运算

let{

  let # 运算  
  let x=16/4
  let x=5**5
}


expr 14 % 9                    # 整数运算
SUM=`expr 2 \* 3`              # 乘后结果赋值给变量
LOOP=`expr $LOOP + 1`          # 增量计数(加循环即可) LOOP=0
expr length "bkeep zbb"        # 计算字串长度
expr substr "bkeep zbb" 4 9    # 抓取字串
expr index "bkeep zbb" e       # 抓取第一个字符数字串出现的位置
expr 30 / 3 / 2                # 运算符号有空格
expr bkeep.doc : '.*'          # 模式匹配(可以使用expr通过指定冒号选项计算字符串中字符数)
expr bkeep.doc : '\(.*\).doc'  # 在expr中可以使用字符串匹配操作，这里使用模式抽取.doc文件附属名
```

# title{array - }

# func{bash中各种数组的用法}
```bash
#!/bin/bash

#func{bash中的各种arry操作}

#in bash, you create array like this

arr=(one two three)

#to call the elements

echo ${arr[0]}
echo ${arr[2]}

# or shell

array=( "A" "B" "ElementC" "ElementE" )
for element in ${array[@]}
do
        echo $element
    done

    echo ""
    echo "Nbr of elements:" ${#array[@]}

    echo ""
    echo ${array[@]}



for i in {0..9}; do
    num[$i]=$RANDOM
done

for j in ${num[@]}; do
    echo "hello: $j"
done

for j in "${num[@]}"; do
    echo "hello: $j"
done

for j in ${num[*]}; do
    echo "hello: $j"
done

for j in "${num[*]}"; do
    echo "hello: $j"
done

#初始化定义三个数组
arry1=(A B C)
arry2=(D E F)
arry3=(G H I)
#
#使用for循环来读取数组中元素的个数，每次读取完一个数组将其打印到屏幕上并继续读取
for ((i=0;i<4;i++))
   do
     eval value=\${arry${i}[@]}
      for element in ${value}
         do
           echo -e ${value}
           continue 2
         done
    done
echo

#定义三个一维数组
array1="A B C"
array2="D E F"
array3="G H I"
#
#使用for语句来循环读取所定义的数组中的元素并暂存到变量i中
#将暂存在变量i中的元素赋予变量value
#使用for语句读取变量value中的值 每次读取完后都打印到标准输出直到读取完成
for i in array1 array2 array3
   do
     eval value=\$$i
      for j in $value
         do
          echo -e $value
          continue 2
      done
done


#初始化第一个数组
array2=(
   element2
   element3
   element4
)
#初始化第二个数组
array3=(
   element5 element6 element7
)
#定义一个函数 将所定义的两个一维数组组合成一个二维数组并显示到屏幕上
ARRAY()
{
  echo
  echo ">>Two-dimensional array<<"
  echo
  echo "${array2[*]}"
  echo "${array3[*]}"
}
#
ARRAY
echo array



declare -i j=0
declare -i limit=4
#
#初始化一个一维数组
array=(34 35 36 37 38 39)
#
echo "Two-dimensional array"
#使用while循环完成对一维数组元素的读取 并将读取的元素重新组成一个二维数组后输出
while [ $j -lt $limit ]
    do
#对数组array中的元素每次都从第$j个元素开始读取且读取的数目为3
      echo "${array[*]:$j:3}"       
      let j+=2
      let j++
done
echo

#在示例中，行分隔符（第1维）是空格字符。为了引入字段分隔符（第二维），使用标准unix工具tr。
#用于附加尺寸的附加分隔符可以以相同的方式使用。

#当然，这种方法的性能不是很好，但是如果性能是不是一个标准，这种做法是非常通用的，可以解决很多问题：

array2d="1.1:1.2:1.3 2.1:2.2 3.1:3.2:3.3:3.4" 

function process2ndDimension { 
    for dimension2 in $* 
    do 
     echo -n $dimension2 " " 
    done 
    echo 
} 

function process1stDimension { 
    for dimension1 in $array2d 
    do 
     process2ndDimension `echo $dimension1 | tr : " "` 
    done 
} 

process1stDimension 

##该样品的输出是这样的：

##1.1  1.2  1.3  
##2.1  2.2  
##3.1  3.2  3.3  3.4 




#!/bin/bash
##提取控制台上w命令给出的：USER,TTY和FROM值.在bash中我试图获取此输出并将这些值放入多
## 维数组(或只是一个带空格分隔符的数组).
w|awk '{if(NR > 2) print $1,$2,$3}' | while read line
do
     USERS+=("$line")
     echo ${#USERS[@]}
done
echo ${#USERS[@]}

#!/bin/bash
USERS=()
shopt -s lastpipe
w | awk '{if(NR > 2) print $1,$2,$3}' | while read line; do
  USERS+=("$line")
done
echo ${#USERS[@]}

##可以使用process substitution而不是管道,以便read命令在主shell进程中运行.

#!/bin/bash
USERS=()
while read line; do
  USERS+=("$line")
done < <(w | awk '{if(NR > 2) print $1,$2,$3}')
echo ${#USERS[@]}

##可以使用可移植方法,该方法适用于没有进程暂停或ksh / zsh行为的shell,例如Bourne,dash和pdksh.
## (对于数组,您仍然需要(pd)ksh,bash或zsh.)运行需要管道内管道数据的所有内容.

#!/bin/bash
USERS=()
shopt -s lastpipe
w | awk '{if(NR > 2) print $1,$2,$3}' | {
  while read line; do
    USERS+=("$line")
  done
  echo ${#USERS[@]}
}
```