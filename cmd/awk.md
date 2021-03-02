# title{awk - 常用的awk命令}

awk 用法：awk ' pattern {action} '  

变量名	 含义 
ARGC	 命令行变元个数 
ARGV	 命令行变元数组 
FILENAME	当前输入文件名 
FNR	 当前文件中的记录号 
FS	 输入域分隔符，默认为一个空格 
RS	 输入记录分隔符 
NF	 当前记录里域个数 
NR	 到目前为止记录数 
OFS	 输出域分隔符 
ORS	 输出记录分隔符 
_________________________________________________________________________________

du -sk /data/ |gawk '$1>1024*1024 {print $1/1024/1024"G"} {print $1/1024"M"}'
3.15131G
3226.94M
精确到M和G 小数点....


du -sk /data/ |gawk '{print $1/1024}'  统计显示精确到M

du -sk /data/ |gawk '{print $1/1024/1024}' 统计显示精确到G
_________________________________________________________________________________

1、awk '/101/'               file 显示文件file中包含101的匹配行。 
   awk '/101/,/105/'         file 
   awk '$1 == 5'             file 
   awk '$1 == "CT"'          file 注意必须带双引号 
   awk '$1 * $2 >100 '       file  
   awk '$2 >5 && $2<=15'     file


2、awk '{print NR,NF,$1,$NF,}' file 显示文件file的当前记录号、域数和每一行的第一个和最后一个域。 
   awk '/101/ {print $1,$2 + 10}' file 显示文件file的匹配行的第一、二个域加10。 
   awk '/101/ {print $1$2}'  file 
   awk '/101/ {print $1 $2}' file 显示文件file的匹配行的第一、二个域，但显示时域中间没有分隔符。


3、df | awk '$4>1000000 '         通过管道符获得输入，如：显示第4个域满足条件的行。


4、awk -F "|" '{print $1}'   file 按照新的分隔符“|”进行操作。 
   awk  'BEGIN { FS="[: \t|]" } 
   {print $1,$2,$3}' 	     file 通过设置输入分隔符（FS="[: \t|]"）修改输入分隔符。 

   Sep="|" 
   awk -F $Sep '{print $1}'  file 按照环境变量Sep的值做为分隔符。    
   awk -F '[ :\t|]' '{print $1}' file 按照正则表达式的值做为分隔符，这里代表空格、:、TAB、|同时做为分隔符。 
   awk -F '[][]'    '{print $1}' file 按照正则表达式的值做为分隔符，这里代表[、]


5、awk -f awkfile 	     file 通过文件awkfile的内容依次进行控制。 
   cat awkfile 
/101/{print "\047 Hello! \047"} --遇到匹配行以后打印 ' Hello! '.\047代表单引号。 
{print $1,$2}                   --因为没有模式控制，打印每一行的前两个域。


6、awk '$1 ~ /101/ {print $1}' file 显示文件中第一个域匹配101的行（记录）。


7、awk   'BEGIN { OFS="%"} 
   {print $1,$2}'           file 通过设置输出分隔符（OFS="%"）修改输出格式。


8、awk   'BEGIN { max=100 ;print "max=" max}             BEGIN 表示在处理任意行之前进行的操作。 
   {max=($1 >max ?$1:max); print $1,"Now max is "max}' file 取得文件第一个域的最大值。 
   （表达式1?表达式2:表达式3 相当于： 
   if (表达式1) 
       表达式2 
   else 
       表达式3 
   awk '{print ($1>4 ? "high "$1: "low "$1)}' file 


9、awk '$1 * $2 >100 {print $1}' file 显示文件中第一个域匹配101的行（记录）。


10、awk '{$1 == 'Chi' {$3 = 'China'; print}' file 找到匹配行后先将第3个域替换后再显示该行（记录）。 
    awk '{$7 %= 3; print $7}'  file 将第7域被3除，并将余数赋给第7域再打印。


11、awk '/tom/ {wage=$2+$3; printf wage}' file 找到匹配行后为变量wage赋值并打印该变量。


12、awk '/tom/ {count++;}  
         END {print "tom was found "count" times"}' file END表示在所有输入行处理完后进行处理。


13、awk 'gsub(/\$/,"");gsub(/,/,""); cost+=$4; 
         END {print "The total is $" cost>"filename"}'    file gsub函数用空串替换$和,再将结果输出到filename中。 
    1 2 3 $1,200.00 
    1 2 3 $2,300.00 
    1 2 3 $4,000.00 

    awk '{gsub(/\$/,"");gsub(/,/,""); 
    if ($4>1000&&$4<2000) c1+=$4; 
    else if ($4>2000&&$4<3000) c2+=$4; 
    else if ($4>3000&&$4<4000) c3+=$4; 
    else c4+=$4; } 
    END {printf  "c1=[%d];c2=[%d];c3=[%d];c4=[%d]\n",c1,c2,c3,c4}"' file 
    通过if和else if完成条件语句 

    awk '{gsub(/\$/,"");gsub(/,/,""); 
    if ($4>3000&&$4<4000) exit; 
    else c4+=$4; } 
    END {printf  "c1=[%d];c2=[%d];c3=[%d];c4=[%d]\n",c1,c2,c3,c4}"' file 
    通过exit在某条件时退出，但是仍执行END操作。 
    awk '{gsub(/\$/,"");gsub(/,/,""); 
    if ($4>3000) next; 
    else c4+=$4; } 
    END {printf  "c4=[%d]\n",c4}"' file 
    通过next在某条件时跳过该行，对下一行执行操作。 


14、awk '{ print FILENAME,$0 }' file1 file2 file3>fileall 把file1、file2、file3的文件内容全部写到fileall中，格式为 
    打印文件并前置文件名。


15、awk ' $1!=previous { close(previous); previous=$1 }    
    {print substr($0,index($0," ") +1)>$1}' fileall 把合并后的文件重新分拆为3个文件。并与原文件一致。


16、awk 'BEGIN {"date"|getline d; print d}'         通过管道把date的执行结果送给getline，并赋给变量d，然后打印。 


17、awk 'BEGIN {system("echo \"Input your name:\\c\""); getline d;print "\nYour name is",d,"\b!\n"}' 
    通过getline命令交互输入name，并显示出来。 
    awk 'BEGIN {FS=":"; while(getline< "/etc/passwd" >0) { if($1~"050[0-9]_") print $1}}' 
    打印/etc/passwd文件中用户名包含050x_的用户名。 

18、awk '{ i=1;while(i<NF) {print NF,$i;i++}}' file 通过while语句实现循环。 
    awk '{ for(i=1;i<NF;i++) {print NF,$i}}'   file 通过for语句实现循环。     
    type file|awk -F "/" ' 
    { for(i=1;i<NF;i++) 
    { if(i==NF-1) { printf "%s",$i } 
    else { printf "%s/",$i } }}'               显示一个文件的全路径。 
    用for和if显示日期 
    awk  'BEGIN { 
for(j=1;j<=12;j++) 
{ flag=0; 
  printf "\n%d月份\n",j; 
        for(i=1;i<=31;i++) 
        { 
        if (j==2&&i>28) flag=1; 
        if ((j==4||j==6||j==9||j==11)&&i>30) flag=1; 
        if (flag==0) {printf "%02d%02d ",j,i} 
        } 
} 
}'


19、在awk中调用系统变量必须用单引号，如果是双引号，则表示字符串 
Flag=abcd 
awk '{print '$Flag'}'   结果为abcd 
awk '{print  "$Flag"}'   结果为$Flag

以上转自chinaunix，以下是自己的总结：

求和：

$awk 'BEGIN{total=0}{total+=$4}END{print total}' a.txt   -----对a.txt文件的第四个域进行求和！

$ awk '/^(no|so)/' test-----打印所有以模式no或so开头的行。

$ awk '/^[ns]/{print $1}' test-----如果记录以n或s开头，就打印这个记录。

$ awk '$1 ~/[0-9][0-9]$/(print $1}' test-----如果第一个域以两个数字结束就打印这个记录。

$ awk '$1 == 100 || $2 < 50' test-----如果第一个或等于100或者第二个域小于50，则打印该行。

$ awk '$1 != 10' test-----如果第一个域不等于10就打印该行。

$ awk '/test/{print $1 + 10}' test-----如果记录包含正则表达式test，则第一个域加10并打印出来。

$ awk '{print ($1 > 5 ? "ok "$1: "error"$1)}' test-----如果第一个域大于5则打印问号后面的表达式值，否则打印冒号后面的表达式值。

$ awk '/^root/,/^mysql/' test----打印以正则表达式root开头的记录到以正则表达式mysql开头的记录范围内的所有记录。如果找到一个新的正则表达式root开头的记 录，则继续打印直到下一个以正则表达式mysql开头的记录为止，或到文件末尾。



##按第六列  重复的删除，并保留一行
awk '!arr[$6]++' file

##按第2列和第三  重复的删除，并保留一行
awk '!arr[$2$3]++'  test.log
awk '!arr[$2_$3]++'  test.log

##提取两个文件第一列相同的行
awk -F',' 'NR==FNR{a[$1]=$0;next}NR>FNR{if($1 in a)print $0"\n"a[$1]}' 1.log 2.log

awk 'NR==FNR{a[$1]++}NR>FNR&&a[$1]>1' 111.txt 111.txt

awk 'a[$1]++==1' 

cat 111.txt | awk -F '[:|]' '{print $2}' > 111.txt

##awk 按某个位置的字符分隔的方法
awk -F ":" '{ for(i=1;i<=3;i++) printf("%s:",$i)}'
awk -F':' '{print $1 ":" $2 ":" $3; print $4}'
awk -F':' '{print $1 ":" $2 ":" $3; for(i=1;i<=3;i++)$i=""; print}'

##awk打印用户和密码
cat test.log  |awk -F '[ ]+' '{print $1 "   " $2}'

##排序显示重复项目
cat test.log |awk -F '[ ]+' '{print $1}'| sort | uniq -c | sort -nr

#awk -F '\t'来表示分隔符，比如
awk -F '\t' '{print $1}' file1.txt 

##多个空格分隔的方法
awk -F '[ ]+' '{print $9}'
ls -lh /etc/sysconfig/network-scripts/ifcfg-* | awk -F '[ ]+' '{print $9}'

##指定分隔符既可以为空格，又可以为冒号，那么处理将会变得简单。可以使用正则表达式来指定多个分隔符，格式为 -F'[空格:]+' 如下
awk -F'[ :]+' '{print $NF"\t"$(NF-2)}'  file1.txt 


1、awk '/101/'    file      显示文件file中包含101的匹配行。 
   awk '/101/,/105/'  file 
   awk '$1 == 5'    file 
   awk '$1 == "CT"'    file    注意必须带双引号 
   awk '$1 * $2 >100 '   file  
   awk '$2 >5 && $2<=15'  file


2、awk '{print NR,NF,$1,$NF,}' file     显示文件file的当前记录号、域数和每一行的第一个和最后一个域。 
   awk '/101/ {print $1,$2 + 10}' file       显示文件file的匹配行的第一、二个域加10。 
   awk '/101/ {print $1$2}'  file 
   awk '/101/ {print $1 $2}' file       显示文件file的匹配行的第一、二个域，但显示时域中间没有分隔符。


3、df | awk '$4>1000000 '         通过管道符获得输入，如：显示第4个域满足条件的行。


4、awk -F "|" '{print $1}'   file         按照新的分隔符“|”进行操作。 
   awk  'BEGIN { FS="[: \t|]" } 
   {print $1,$2,$3}'       file         通过设置输入分隔符（FS="[: \t|]"）修改输入分隔符。 

   Sep="|" 
   awk -F $Sep '{print $1}'  file   按照环境变量Sep的值做为分隔符。    
   awk -F '[ :\t|]' '{print $1}' file   按照正则表达式的值做为分隔符，这里代表空格、:、TAB、|同时做为分隔符。 
   awk -F '[][]'    '{print $1}' file   按照正则表达式的值做为分隔符，这里代表[、]


5、awk -f awkfile    file         通过文件awkfile的内容依次进行控制。 
   cat awkfile 
/101/{print "\047 Hello! \047"}    --遇到匹配行以后打印 ' Hello! '.  \047代表单引号。 
{print $1,$2}                      --因为没有模式控制，打印每一行的前两个域。


6、awk '$1 ~ /101/ {print $1}' file         显示文件中第一个域匹配101的行（记录）。


7、awk   'BEGIN { OFS="%"} 
   {print $1,$2}'  file           通过设置输出分隔符（OFS="%"）修改输出格式。


8、awk   'BEGIN { max=100 ;print "max=" max}             BEGIN 表示在处理任意行之前进行的操作。 
   {max=($1 >max ?$1:max); print $1,"Now max is "max}' file           取得文件第一个域的最大值。 
   （表达式1?表达式2:表达式3 相当于： 
   if (表达式1) 
       表达式2 
   else 
       表达式3 
   awk '{print ($1>4 ? "high "$1: "low "$1)}' file 


9、awk '$1 * $2 >100 {print $1}' file         显示文件中第一个域匹配101的行（记录）。


10、awk '{$1 == 'Chi' {$3 = 'China'; print}' file        找到匹配行后先将第3个域替换后再显示该行（记录）。 
    awk '{$7 %= 3; print $7}'  file           将第7域被3除，并将余数赋给第7域再打印。


11、awk '/tom/ {wage=$2+$3; printf wage}' file          找到匹配行后为变量wage赋值并打印该变量。


12、awk '/tom/ {count++;}  
         END {print "tom was found "count" times"}' file            END表示在所有输入行处理完后进行处理。


13、awk 'gsub(/\$/,"");gsub(/,/,""); cost+=$4; 
         END {print "The total is $" cost>"filename"}'    file             gsub函数用空串替换$和,再将结果输出到filename中。 
    1 2 3 $1,200.00 
    1 2 3 $2,300.00 
    1 2 3 $4,000.00 

    awk '{gsub(/\$/,"");gsub(/,/,""); 
    if ($4>1000&&$4<2000) c1+=$4; 
    else if ($4>2000&&$4<3000) c2+=$4; 
    else if ($4>3000&&$4<4000) c3+=$4; 
    else c4+=$4; } 
    END {printf  "c1=[%d];c2=[%d];c3=[%d];c4=[%d]\n",c1,c2,c3,c4}"' file 
    通过if和else if完成条件语句 

    awk '{gsub(/\$/,"");gsub(/,/,""); 
    if ($4>3000&&$4<4000) exit; 
    else c4+=$4; } 
    END {printf  "c1=[%d];c2=[%d];c3=[%d];c4=[%d]\n",c1,c2,c3,c4}"' file 
    通过exit在某条件时退出，但是仍执行END操作。 
    awk '{gsub(/\$/,"");gsub(/,/,""); 
    if ($4>3000) next; 
    else c4+=$4; } 
    END {printf  "c4=[%d]\n",c4}"' file 
    通过next在某条件时跳过该行，对下一行执行操作。 


14、awk '{ print FILENAME,$0 }' file1 file2 file3>fileall              把file1、file2、file3的文件内容全部写到fileall中，格式为 
    打印文件并前置文件名。


15、awk ' $1!=previous { close(previous); previous=$1 }    
    {print substr($0,index($0," ") +1)>$1}' fileall           把合并后的文件重新分拆为3个文件。并与原文件一致。


16、awk 'BEGIN {"date"|getline d; print d}'         通过管道把date的执行结果送给getline，并赋给变量d，然后打印。 


17、awk 'BEGIN {system("echo \"Input your name:\\c\""); getline d;print "\nYour name is",d,"\b!\n"}' 
    通过getline命令交互输入name，并显示出来。 
    awk 'BEGIN {FS=":"; while(getline< "/etc/passwd" >0) { if($1~"050[0-9]_") print $1}}' 
    打印/etc/passwd文件中用户名包含050x_的用户名。 

18、awk '{ i=1;while(i<NF) {print NF,$i;i++}}' file 通过while语句实现循环。 
    awk '{ for(i=1;i<NF;i++) {print NF,$i}}'   file 通过for语句实现循环。     
    type file|awk -F "/" ' 
    { for(i=1;i<NF;i++) 
    { if(i==NF-1) { printf "%s",$i } 
    else { printf "%s/",$i } }}'               显示一个文件的全路径。 
    用for和if显示日期 
    awk  'BEGIN { 
for(j=1;j<=12;j++) 
{ flag=0; 
  printf "\n%d月份\n",j; 
        for(i=1;i<=31;i++) 
        { 
        if (j==2&&i>28) flag=1; 
        if ((j==4||j==6||j==9||j==11)&&i>30) flag=1; 
        if (flag==0) {printf "%02d%02d ",j,i} 
        } 
} 
}'


```bash
# sum integers from a file or stdin, one integer per line:
#从文件或stdin中求和整数，每行一个整数：
printf '1\n2\n3\n' | awk '{ sum += $1} END {print sum}'

# using specific character as separator to sum integers from a file or stdin
#使用特定字符作为分隔符来对文件或标准输入中的整数求和
printf '1:2:3' | awk -F ":" '{print $1+$2+$3}'

# print a multiplication table
#打印乘法表
seq 9 | sed 'H;g' | awk -v RS='' '{for(i=1;i<=NF;i++)printf("%dx%d=%d%s", i, NR, i*NR, i==NR?"\n":"\t")}'

# Specify output separator character
#指定输出分隔符
printf '1 2 3' | awk 'BEGIN {OFS=":"}; {print $1,$2,$3}'

#以冒号为分隔符，打印第一段
head -n2 test.txt|awk -F ':' '{print $1}' 
# 打印行号和最后一个字段和倒数第二个字段
head -n2 test.txt|awk -F ':' '{print $NR $NF-1 $NF}' 
#以冒号为分隔符，打印整行
head -n2 test.txt|awk -F ':' '{print $0}' 
#以冒号为分隔符，打印第1、2、3、4段，中间以井号间隔
awk -F ':' '{print $1"#"$2"#"$3"#"$4}' 
#打印包含oo的行
awk '/oo/' test.txt 
#以冒号为分隔符，打印第一列包含oo的行
awk -F ':' '$1 ~/oo/' test.txt 
#以冒号为分隔符，打印包含root行的第一、三段，打印包含games行的第一、三段
awk -F ':' '/root/ {print $1,$3} /games/ {print $1,$3}' test.txt 
#以冒号为分隔符，打印第三段是文本0的行，双引号代表字符，没有双引号代表数字
awk -F ':' '$3=="0"' /etc/passwd 
#以冒号为分隔符，打印第三段大于等于字符串500的行
awk -F ':' '$3>="500"' /etc/passwd 
#以冒号为分隔符，打印第三段大于等于数字500的行
awk -F ':' '$3>=500' /etc/passwd 
#以冒号为分隔符，打印第七段不为/sbin/nologin的行
awk -F ':' '$7!="/sbin/nologin"' /etc/passwd 
#以冒号为分隔符，打印第三段小于第四段的行
awk -F ':' '$3<$4' /etc/passwd 
#以冒号为分隔符，打印第三段大于字符5且第三段小于字符7的行
awk -F ':' '$3>"5" && $3<"7"' /etc/passwd 
#以冒号为分隔符，打印第三段大于1000或者第七段等于/bin/bash的行
awk -F ':' '$3>1000 || $7=="/bin/bash"' /etc/passwd 
#以冒号为分隔符，打印每行第1、3、4段，并以井号间隔
head -5 /etc/passwd |awk -F ':' '{OFS="#"} {print $1,$3,$4}'
#以冒号为分隔符，如果第三段大于1000则打印第1、3、4段，并以井号间隔
awk -F ':' '{OFS="#"} {if ($3>1000) {print $1,$2,$3,$4}}' /etc/passwd 
#以冒号为分隔符，逐行打印该行列数
head -n3 /etc/passwd | awk -F ':' '{print NF}'
#以冒号为分隔符，逐行打印该行行数
head -n3 /etc/passwd | awk -F ':' '{print NR}' 
#打印行数大于40的行
awk 'NR>40' /etc/passwd 
#打印行数小于20并且第一段包含roo的行
awk -F ':' 'NR<20 && $1 ~ /roo/' /etc/passwd 
#以冒号为分隔符，给第一段赋值root，然后打印每一行
head -n 3 /etc/passwd |awk -F ':' '$1="root"' 
#逐行做完tot=tot+3的运算，最后打印出tot的值
awk -F ':' '{(tot=tot+$3)}; END {print tot}' /etc/passwd 
#如果第一段是root，打印该行
awk -F ':' '{if ($1=="root") {print $0}}' /etc/passwd 
#第3段大于某个字符并且小于某个字符 。这里数字使用了双引号，所以表示字符
awk -F ':' '$3>"4" && $3<"8"' test.txt 
#打印第3段与第4段相同的行。
awk -F ':'  '$3==$4' test.txt 
#打印第3段小于第4段的行，比较的是数字
awk -F ':'  '$3<$4' test.txt  
#字符作为判断条件则是要使用双引号括起来的
awk -F ':' '$7!="/sbin/nologin"  {print $0} ' test.txt 
awk -F ':' '$3>=500 {print $0}' test.txt
#这里表示打印第3段等于0的行，要想等于必须使用2个=，不然就是赋值了。
awk -F ':' '$3==0'  test.txt  
awk -F ':' '/oo/ {print $1,$4} /user1/ {print $1,$6}' test.txt
awk -F ':' '$1 ~ /oo/' test.txt
#匹配出现oo的行
awk '/oo/' test.txt 
#将之前的：分隔符号替换为#，必须使用双引号引起来。
awk -F ':' '{print $1"#"$5"#"$6}' test.txt 
 #-F用来指定分隔符。不加-F选项，默认使用空格或者tab为分隔符，print为打印的意思。 $1表示打印第1字段   $0表示整行  
head -n2   test.txt  |awk  -F  ':'   '{print  $1}' 

## 响应时间大于10的记录
awk -F '=>' '/=>.*=>/{if($2>10){print $2 $3}}' access_124.log

# 提取数字
$ echo 'dsFUs34tg*fs5a%8ar%$#@' |awk -F "" '
{
  for(i=1;i<=NF;i++) 
  {  
    if ($i ~ /[[:digit:]]/)     
    {
      str=$i
      str1=(str1 str)
    }  
  } 
  print str1
}'
 
#输出
#3458
$ echo 'dsFUs34tg*fs5a%8ar%$#@' |awk -F "" '
{
  for(i=1;i<=NF;i++) 
  {  
    if ($i ~ /[0-9]/)             
    {
      str=$i
      str1=(str1 str)
    }  
  } 
  print str1
}'


#例：打印出/etc/passwd的所有用户名，并统计其字符长度
awk -F: '{print $1"长度为"length($1)}' /etc/passwd

#查找出用户名长度大于5的用户，显示用户名
awk -F: 'length($1)>5 {print $1}' /etc/passwd

#大小转换：toupper(),tolower()
awk -F: '{print toupper($1)}' /etc/passwd
awk -F: '{print tolower(toupper($1))}' /etc/passwd

#截取函数：substr()
#--把$1从第一个字符开始，截取2个（而不是从第一个到第二个)
awk -F: '{print substr($1,1,2)}' /etc/passwd        
echo 12345356346343234sfsahaha34523 |awk '{print substr($0,index($0,"haha"),4)}'

awk -F: 'NR==1 {sub("o","O",$0);print $0}' /etc/passwd
#rOot:x:0:0:root:/root:/bin/bash

awk -F: 'NR==1 {gsub("o","O",$0);print $0}' /etc/passwd
#rOOt:x:0:0:rOOt:/rOOt:/bin/bash

awk -F: 'NR==1 {gsub("/bin/bash","/sbin/nologin"); print $0}' /etc/passwd

#抽取xxx.log整个日志文件中，包含“listAuths”的行，打印输出
awk '{if($0~"listAuths") print}'   xxx.log

cat check_info.log.2017-09-20 | awk -F '(txt=|&client)' '{print $2}'

# 统计数量与去重
cat check_info.log.2017-09-20 | awk -F '(txt=|&client)' '{print $2}'| sort | uniq -c

# 按重复次数排序
cat check_info.log.2017-09-20 | awk -F '(txt=|&client)' '{print $2}'| sort | uniq -c | sort -nr
```

### awk内置函数

blength[([s])]          计算字符串长度(byte为单位)
length[([s])]           计算字符串长度(character为单位)
rand()                  生成随机数
srand([expr])           设置rand() seed
int(x)                  字符串转换为整型
substr(s, m [, n])      取子字符串
index(s, t)             在字符串s中定位t字符串首次出现的位置
match(s, ere)           在字符串s中匹配正则ere，match修改RSTART、RLENGTH变量。
split(s, a[, fs])       将字符串分割到数组中
sub(ere, repl [, in])   字符串替换
gsub                    同上
sprintf(fmt, expr, ...) 格式化输出      
system(cmd)             在shell中执行cmd。
toupper(s)              字符串转换为大写
tolower(s)              字符串转换为小写
cos(x)              返回x的余弦
exp(x)              返回e的x次幂
int(x)              返回x的整数部分
log(x)              返回x的自然数对数(e为底)
sin(x)              返回x的正弦
aqrt(x)             返回x的平方根
atan2(y,x)          返回y/x的反正切
rand()              返回随机数
srand(x)            建立rand()的新的种子数。如果没有指定种子数，就用当前时间。返回旧的种子值。
gsub(r,s,t)         在字符串t中用字符串s替换和r匹配的所有字符串。返回替换的个数。如果没有指定t，默认$0。
index(s,t)          返回子串t在字符串s中的位置，如果没有指定s，则返回0。
length(s)           返回s字符串的长度。如果未给出s参数，则返回$0的长度。
blength(s)          以字节为单位。
substr(s,p,n)       返回字符串s中从位置p开始最大长度为n的子串。如果没有给出n，返回从p开始剩余的字符串    
sub(r,s,t)          在字符串t中用s替换r的首次匹配。成功返回1，失败返回0，如果没有指定t，默认$0。
split(s,a,sep)      使用字段分隔符sep将字符串s分解到数组a的元素中，返回元素的个数。如果没有指定sep，则使用FS。
tolower(s)          将字符串s转换为小写，并返回新串
toupper(s)          将字符串s转换为大写，并返回新串
sprintf("fmt",expr)与printf格式相同
getline         用户从输入中读取另一行。输入包括文件和管道的数据。成功读取一行返回1，读到结尾返回0，出错返回-1，与shell编程的read函数类似
close           关闭打开的文件和管道
system          执行一条系统命令

## awk支持的运算符
1) 算数运算
   + -  * / %(取余数）
  
   ++ 
      a++ 就相当与 a=a+1
   --
      a-- 就相当与 a=a-1
2）赋值运算符
   = 
   +=  例如： a+=b 就相当与 a=a+b
   -=
   *=
   /=
   %=
  
3) 关系运算符
   >  大于
   >= 大于或等于  
   < 
   <=
   == 等于
   != 不等于
   
4) 逻辑运算符
   逻辑运算的结果，只有两种：真 假
  
   逻辑与 &&
   a >= 60  && a <= 100
   特点：
   1）只有两个都为真，结果才是真
   2）只有第1个为真，后计算后一个
     
   逻辑或 ||
   a > 100  ||  a < 0
   特点：
   1）只有有1个是真，结果就为真！
   2）如果前1个为真，那么后1个就不计算！

## BEGIN END
```bash
# BEGIN{}: 读入第一行文本之前执行的语句，一般用来初始化操作
# {}: 逐行处理
# END{}: 处理完最后一行文本后执行，一般用来处理输出结果
s="0,1,2,3"
awk 'BEGIN{split('"\"$s\""',myarray,","); for(i in myarray) {if(myarray[i]>1) print myarray[i]}}'
```

# cat命令 
cat命令主要有三大功能 
1.一次显示整个文件 cat filename 
2.创建一个文件 cat > fileName 
3.将几个文件合并为一个文件 cat file1 file2 > file 
参数： 
  -n 或 –number 由 1 开始对所有输出的行数编号 
  -b 或 –number-nonblank 和 -n 相似，只不过对于空白行不编号 
  -s 或 –squeeze-blank 当遇到有连续两行以上的空白行，就代换为一行的空白行 
  -v 或 –show-nonprinting
| 管道 
管道的作用是将左边命令的输出作为右边命令的输入
awk 命令 
awk 是行处理器，优点是处理庞大文件时不会出现内存溢出或处理缓慢的问题，通常用来格式化文本信息。awk依次对每一行进行处理，然后输出。 
命令形式 awk [-F|-f|-v] ‘BEGIN{} //{command1; command2} END{}’ file 
  [-F|-f|-v] 大参数，-F指定分隔符，-f调用脚本，-v定义变量 var=value 
  ’ ’ 引用代码块 
  BEGIN 初始化代码块，在对每一行进行处理之前，初始化代码，主要是引用全局变量，设置FS分隔符 
  // 匹配代码块，可以使字符串或正则表达式 
  {} 命令代码块，包含一条或多条命令 
  ;多条命令使用分号分隔 
  END 结尾代码块，对每一行进行处理后再执行的代码块，主要进行最终计算或输出 
由于篇幅限制，可自行查找更详细的信息。这里awk命令的作用是从文件中每一行取出我们需要的字符串

# sort 命令 
sort将文件的每一行作为一个单位，相互比较，比较原则是从首字符向后，依次按ASCII码值进行比较，最后将他们按升序输出。 
  -b：忽略每行前面开始出的空格字符； 
  -c：检查文件是否已经按照顺序排序； 
  -d：排序时，处理英文字母、数字及空格字符外，忽略其他的字符； 
  -f：排序时，将小写字母视为大写字母； 
  -i：排序时，除了040至176之间的ASCII字符外，忽略其他的字符； 
  -m：将几个排序号的文件进行合并； 
  -M：将前面3个字母依照月份的缩写进行排序； 
  -n：依照数值的大小排序； 
  -o<输出文件>：将排序后的结果存入制定的文件； 
  -r：以相反的顺序来排序； 
  -t<分隔字符>：指定排序时所用的栏位分隔字符；

# uniq 命令 
uniq 命令用于报告或忽略文件中的重复行，一般与sort命令结合使用 
   -c或——count：在每列旁边显示该行重复出现的次数； 
  -d或–repeated：仅显示重复出现的行列； 
  -f<栏位>或–skip-fields=<栏位>：忽略比较指定的栏位； 
  -s<字符位置>或–skip-chars=<字符位置>：忽略比较指定的字符； 
  -u或——unique：仅显示出一次的行列； 
  -w<字符位置>或–check-chars=<字符位置>：指定要比较的字符。
# > 命令 
> 是定向输出到文件,如果文件不存在，就创建文件。如果文件存在，就将其清空 
另外 >>是将输出内容追加到目标文件中。其他同>


	# 默认是执行打印全部 print $0
		# 1为真 打印$0
		# 0为假 不打印

		-F   # 改变FS值(分隔符)
		~    # 域匹配
		==   # 变量匹配
		!~   # 匹配不包含
		=    # 赋值
		!=   # 不等于
		+=   # 叠加
		
		\b   # 退格
		\f   # 换页
		\n   # 换行
		\r   # 回车
		\t   # 制表符Tab
		\c   # 代表任一其他字符
		
		-F"[ ]+|[%]+"  # 多个空格或多个%为分隔符
		[a-z]+         # 多个小写字母
		[a-Z]          # 代表所有大小写字母(aAbB...zZ)
		[a-z]          # 代表所有大小写字母(ab...z)
		[:alnum:]      # 字母数字字符
		[:alpha:]      # 字母字符
		[:cntrl:]      # 控制字符
		[:digit:]      # 数字字符
		[:graph:]      # 非空白字符(非空格、控制字符等)
		[:lower:]      # 小写字母
		[:print:]      # 与[:graph:]相似，但是包含空格字符
		[:punct:]      # 标点字符
		[:space:]      # 所有的空白字符(换行符、空格、制表符)
		[:upper:]      # 大写字母
		[:xdigit:]     # 十六进制的数字(0-9a-fA-F)
		[[:digit:][:lower:]]    # 数字和小写字母(占一个字符)


		内建变量{
			$n            # 当前记录的第 n 个字段，字段间由 FS 分隔
			$0            # 完整的输入记录
			ARGC          # 命令行参数的数目
			ARGIND        # 命令行中当前文件的位置 ( 从 0 开始算 ) 
			ARGV          # 包含命令行参数的数组
			CONVFMT       # 数字转换格式 ( 默认值为 %.6g)
			ENVIRON       # 环境变量关联数组
			ERRNO         # 最后一个系统错误的描述
			FIELDWIDTHS   # 字段宽度列表 ( 用空格键分隔 ) 
			FILENAME      # 当前文件名
			FNR           # 同 NR ，但相对于当前文件
			FS            # 字段分隔符 ( 默认是任何空格 ) 
			IGNORECASE    # 如果为真（即非 0 值），则进行忽略大小写的匹配
			NF            # 当前记录中的字段数(列)
			NR            # 当前行数
			OFMT          # 数字的输出格式 ( 默认值是 %.6g) 
			OFS           # 输出字段分隔符 ( 默认值是一个空格 ) 
			ORS           # 输出记录分隔符 ( 默认值是一个换行符 ) 
			RLENGTH       # 由 match 函数所匹配的字符串的长度
			RS            # 记录分隔符 ( 默认是一个换行符 ) 
			RSTART        # 由 match 函数所匹配的字符串的第一个位置
			SUBSEP        # 数组下标分隔符 ( 默认值是 /034) 
			BEGIN         # 先处理(可不加文件参数)
			END           # 结束时处理
		}

		内置函数{
			gsub(r,s)          # 在整个$0中用s替代r   相当于 sed 's///g'
			gsub(r,s,t)        # 在整个t中用s替代r 
			index(s,t)         # 返回s中字符串t的第一位置 
			length(s)          # 返回s长度 
			match(s,r)         # 测试s是否包含匹配r的字符串 
			split(s,a,fs)      # 在fs上将s分成序列a 
			sprint(fmt,exp)    # 返回经fmt格式化后的exp 
			sub(r,s)           # 用$0中最左边最长的子串代替s   相当于 sed 's///'
			substr(s,p)        # 返回字符串s中从p开始的后缀部分 
			substr(s,p,n)      # 返回字符串s中从p开始长度为n的后缀部分 
		}

		awk判断{
			awk '{print ($1>$2)?"第一排"$1:"第二排"$2}'      # 条件判断 括号代表if语句判断 "?"代表then ":"代表else
			awk '{max=($1>$2)? $1 : $2; print max}'          # 条件判断 如果$1大于$2,max值为为$1,否则为$2
			awk '{if ( $6 > 50) print $1 " Too high" ;\
			else print "Range is OK"}' file
			awk '{if ( $6 > 50) { count++;print $3 } \
			else { x+5; print $2 } }' file
		}

		awk循环{
			awk '{i = 1; while ( i <= NF ) { print NF, $i ; i++ } }' file
			awk '{ for ( i = 1; i <= NF; i++ ) print NF,$i }' file
		}
		
		awk '/Tom/' file               # 打印匹配到得行
		awk '/^Tom/{print $1}'         # 匹配Tom开头的行 打印第一个字段
		awk '$1 !~ /ly$/'              # 显示所有第一个字段不是以ly结尾的行
		awk '$3 <40'                   # 如果第三个字段值小于40才打印
		awk '$4==90{print $5}'         # 取出第四列等于90的第五列
		awk '/^(no|so)/' test          # 打印所有以模式no或so开头的行
		awk '$3 * $4 > 500'            # 算术运算(第三个字段和第四个字段乘积大于500则显示)
		awk '{print NR" "$0}'          # 加行号
		awk '/tom/,/suz/'              # 打印tom到suz之间的行
		awk '{a+=$1}END{print a}'      # 列求和
		awk 'sum+=$1{print sum}'       # 将$1的值叠加后赋给sum
		awk '{a+=$1}END{print a/NR}'   # 列求平均值
		awk -F'[ :\t]' '{print $1,$2}'           # 以空格、:、制表符Tab为分隔符
		awk '{print "'"$a"'","'"$b"'"}'          # 引用外部变量
		awk '{if(NR==52){print;exit}}'           # 显示第52行
		awk '/关键字/{a=NR+2}a==NR {print}'      # 取关键字下第几行
		awk 'gsub(/liu/,"aaaa",$1){print $0}'    # 只打印匹配替换后的行
		ll | awk -F'[ ]+|[ ][ ]+' '/^$/{print $8}'             # 提取时间,空格不固定
		awk '{$1="";$2="";$3="";print}'                        # 去掉前三列
		echo aada:aba|awk '/d/||/b/{print}'                    # 匹配两内容之一
		echo aada:abaa|awk -F: '$1~/d/||$2~/b/{print}'         # 关键列匹配两内容之一
		echo Ma asdas|awk '$1~/^[a-Z][a-Z]$/{print }'          # 第一个域匹配正则
		echo aada:aaba|awk '/d/&&/b/{print}'                   # 同时匹配两条件
		awk 'length($1)=="4"{print $1}'                        # 字符串位数
		awk '{if($2>3){system ("touch "$1)}}'                  # 执行系统命令
		awk '{sub(/Mac/,"Macintosh",$0);print}'                # 用Macintosh替换Mac
		awk '{gsub(/Mac/,"MacIntosh",$1); print}'              # 第一个域内用Macintosh替换Mac
		awk -F '' '{ for(i=1;i<NF+1;i++)a+=$i  ;print a}'      # 多位数算出其每位数的总和.比如 1234， 得到 10
		awk '{ i=$1%10;if ( i == 0 ) {print i}}'               # 判断$1是否整除(awk中定义变量引用时不能带 $ )
		awk 'BEGIN{a=0}{if ($1>a) a=$1 fi}END{print a}'        # 列求最大值  设定一个变量开始为0，遇到比该数大的值，就赋值给该变量，直到结束
		awk 'BEGIN{a=11111}{if ($1<a) a=$1 fi}END{print a}'    # 求最小值
		awk '{if(A)print;A=0}/regexp/{A=1}'                    # 查找字符串并将匹配行的下一行显示出来，但并不显示匹配行
		awk '/regexp/{print A}{A=$0}'                          # 查找字符串并将匹配行的上一行显示出来，但并不显示匹配行
		awk '{if(!/mysql/)gsub(/1/,"a");print $0}'             # 将1替换成a，并且只在行中未出现字串mysql的情况下替换
		awk 'BEGIN{srand();fr=int(100*rand());print fr;}'      # 获取随机数
		awk '{if(NR==3)F=1}{if(F){i++;if(i%7==1)print}}'       # 从第3行开始，每7行显示一次
		awk '{if(NF<1){print i;i=0} else {i++;print $0}}'      # 显示空行分割各段的行数
		echo +null:null  |awk -F: '$1!~"^+"&&$2!="null"{print $0}'       # 关键列同时匹配
		awk -v RS=@ 'NF{for(i=1;i<=NF;i++)if($i) printf $i;print ""}'    # 指定记录分隔符
		awk '{b[$1]=b[$1]$2}END{for(i in b){print i,b[i]}}'              # 列叠加
		awk '{ i=($1%100);if ( $i >= 0 ) {print $0,$i}}'                 # 求余数
		awk '{b=a;a=$1; if(NR>1){print a-b}}'                            # 当前行减上一行
		awk '{a[NR]=$1}END{for (i=1;i<=NR;i++){print a[i]-a[i-1]}}'      # 当前行减上一行
		awk -F: '{name[x++]=$1};END{for(i=0;i<NR;i++)print i,name[i]}'   # END只打印最后的结果,END块里面处理数组内容
		awk '{sum2+=$2;count=count+1}END{print sum2,sum2/count}'         # $2的总和  $2总和除个数(平均值)
		awk 'BEGIN{ "date" | getline d; split(d,mon) ; print mon[2]}' file        # 将date值赋给d，并将d设置为数组mon，打印mon数组中第2个元素
		awk 'BEGIN{info="this is a test2010test!";print substr(info,4,10);}'      # 截取字符串(substr使用)
		awk 'BEGIN{info="this is a test2010test!";print index(info,"test")?"ok":"no found";}'      # 匹配字符串(index使用)
		awk 'BEGIN{info="this is a test2010test!";print match(info,/[0-9]+/)?"ok":"no found";}'    # 正则表达式匹配查找(match使用)
		awk 'BEGIN{info="this is a test";split(info,tA," ");print length(tA);for(k in tA){print k,tA[k];}}'    # 字符串分割(split使用)
		awk '{for(i=1;i<=4;i++)printf $i""FS; for(y=10;y<=13;y++)  printf $y""FS;print ""}'        # 打印前4列和后4列
		awk 'BEGIN{for(n=0;n++<9;){for(i=0;i++<n;)printf i"x"n"="i*n" ";print ""}}'                # 乘法口诀
		awk '{if (system ("grep "$2" tmp/* > /dev/null 2>&1") == 0 ) {print $1,"Y"} else {print $1,"N"} }' a            # 执行系统命令判断返回状态
		awk  '{for(i=1;i<=NF;i++) a[i,NR]=$i}END{for(i=1;i<=NF;i++) {for(j=1;j<=NR;j++) printf a[i,j] " ";print ""}}'   # 将多行转多列
		awk 'BEGIN{printf "what is your name?";getline name < "/dev/tty" } $1 ~name {print "FOUND" name " on line ", NR "."} END{print "see you," name "."}' file  # 两文件匹配
		cat 1.txt|awk -F" # " '{print "insert into user (user,password,email)values(""'\''"$1"'\'\,'""'\''"$2"'\'\,'""'\''"$3"'\'\)\;'"}' >>insert_1.txt     # 处理sql语句
		
		取本机IP{
		/sbin/ifconfig |awk -v RS="Bcast:" '{print $NF}'|awk -F: '/addr/{print $2}'
		/sbin/ifconfig |awk -v RS='inet addr:' '$1!="eth0"&&$1!="127.0.0.1"{print $1}'|awk '{printf"%s|",$0}'
		/sbin/ifconfig |awk  '{printf("line %d,%s\n",NR,$0)}'         # 指定类型(%d数字,%s字符)
		}

		查看磁盘空间{
			df -h|awk -F"[ ]+|%" '$5>14{print $5}'
			df -h|awk 'NR!=1{if ( NF == 6 ) {print $5} else if ( NF == 5) {print $4} }' 
			df -h|awk 'NR!=1 && /%/{sub(/%/,"");print $(NF-1)}'
			df -h|sed '1d;/ /!N;s/\n//;s/ \+/ /;'    #将磁盘分区整理成一行   可直接用 df -P
		}

		排列打印{
			awk 'END{printf "%-10s%-10s\n%-10s%-10s\n%-10s%-10s\n","server","name","123","12345","234","1234"}' txt
			awk 'BEGIN{printf "|%-10s|%-10s|\n|%-10s|%-10s|\n|%-10s|%-10s|\n","server","name","123","12345","234","1234"}'
			awk 'BEGIN{
			print "   *** 开 始 ***   ";
			print "+-----------------+";
			printf "|%-5s|%-5s|%-5s|\n","id","name","ip";
			}
			$1!=1 && NF==4{printf "|%-5s|%-5s|%-5s|\n",$1,$2,$3" "$11}
			END{
			print "+-----------------+";
			print "   *** 结 束 ***   "
			}' txt
		}

		老男孩awk经典题{
			分析图片服务日志，把日志（每个图片访问次数*图片大小的总和）排行，也就是计算每个url的总访问大小
			说明：本题生产环境应用：这个功能可以用于IDC网站流量带宽很高，然后通过分析服务器日志哪些元素占用流量过大，进而进行优化或裁剪该图片，压缩js等措施。
			本题需要输出三个指标： 【被访问次数】    【访问次数*单个被访问文件大小】   【文件名（带URL）】
			测试数据
			59.33.26.105 - - [08/Dec/2010:15:43:56 +0800] "GET /static/images/photos/2.jpg HTTP/1.1" 200 11299 

			awk '{array_num[$7]++;array_size[$7]+=$10}END{for(i in array_num) {print array_num[i]" "array_size[i]" "i}}'
		}

		awk练习题{

			wang     4
			cui      3
			zhao     4
			liu      3
			liu      3
			chang    5
			li       2

			1 通过第一个域找出字符长度为4的
			2 当第二列值大于3时，创建空白文件，文件名为当前行第一个域$1 (touch $1)
			3 将文档中 liu 字符串替换为 hong
			4 求第二列的和
			5 求第二列的平均值
			6 求第二列中的最大值
			7 将第一列过滤重复后，列出每一项，每一项的出现次数，每一项的大小总和

			1、字符串长度
				awk 'length($1)=="4"{print $1}'
			2、执行系统命令
				awk '{if($2>3){system ("touch "$1)}}'
			3、gsub(/r/,"s",域) 在指定域(默认$0)中用s替代r  (sed 's///g')
				awk '{gsub(/liu/,"hong",$1);print $0}' a.txt
			4、列求和
				awk '{a+=$2}END{print a}'
			5、列求平均值
				awk '{a+=$2}END{print a/NR}'
				awk '{a+=$2;b++}END{print a,a/b}' 
			6、列求最大值
				awk 'BEGIN{a=0}{if($2>a) a=$2 }END{print a}'
			7、将第一列过滤重复列出每一项，每一项的出现次数，每一项的大小总和
				awk '{a[$1]++;b[$1]+=$2}END{for(i in a){print i,a[i],b[i]}}'
		}
