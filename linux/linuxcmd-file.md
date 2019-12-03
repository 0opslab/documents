---
title: linux-file
date: 2018-02-20 15:50:19
tags: Linux
---

文件在计算机中扮演着至关重要的角色。在Linux系统中可以说一切及文件，操作文件就能操作一切。在linux中文件大概分为常见如下几种

* block  块设备文件，如磁盘分区、光驱
* char 字符设备，指在I/O传输过程中以字符为单位进行传输的设备，如键盘、打印机
* dir  目录类型
* fifo 命名管道
* file 普通文件类型，如文本文件或可执行文件等
* link 符号链接
* unknown 未知类型

操作linux就是利用各种工具(可执行文件)去操作其他文件的过程。在linux中提供了很多文件操作相关的命令，此次列举常用的一些命令及其常用的格式。另外文件是具有权限属性的。下面是所有的文件组合

```bash
若要 rwx 则 4+2+1=7 
若要 rw- 则 4+2+0=6 
若要 r-w 则 4+0+1=5 
若要 r— 则 4+0+0=4 
若要 -wx 则 0+2+1=3 
若要 -w- 则 0+2+0=2 
若要 - -x 则 0+0+1=1 
若要 - - - 则 0+0+0=0 
```



#### ls\mv\cp\rm\touch\pwd\mkdir\rmdir\cd

常用的文件操作文件目录查看、文件的复制、移动、新建、删除和目录切换

```bash
### ls 产检文件和目录信息
usage: 
	ls (选项) (参数)
选项：
  -a  列出包括.a开头的隐藏文件的所有文件
  -A  通-a，但不列出"."和".."
  -l  列出文件的详细信息
  -c  根据ctime排序显示
  -t  根据文件修改时间排序
常用实例:
	//显示当前目录下非隐藏的文件与目录
	# ls
	//显示当前目录下所有文件和目录
	# ls -a
	//长格式输出
	# ls -l
	// 显示文件的inode信息
	# ls -i
	// 按照文件修改时间显示
	# ls -t
	// 递归显示
	# ls -R
	
### mv 文件移动和重命名
usage:
	mv (选项) (参数)
参数：
  -b  覆盖前做备份
  -f  如存在不询问而强制覆盖
  -i  如存在则询问是否覆盖
  -u  较新才覆盖
  -t  将多个源文件移动到统一目录下，目录参数在前，文件参数在后
实例：
    mv a /tmp/ 将文件a移动到 /tmp目录下
    mv a b 将a命名为b
    
### cp 用于文件复制
usgae:
	cp (选项) (参数)
选项:
  -r -R 递归复制该目录及其子目录内容
  -p  连同档案属性一起复制过去
  -f  不询问而强制复制
  -s  生成快捷方式
  -a  将档案的所有特性都一起复制
实例:
	//复制aaa目录下的所有文件到bbb目录下
	# cp aaa/* bbb/

### scp 该命令可以实现夸服务之间的文件复制
usage:
	scp [参数] source_file target_file
参数：
  -1：使用ssh协议版本1；
  -2：使用ssh协议版本2；
  -4：使用ipv4；
  -6：使用ipv6；
  -B：以批处理模式运行；
  -C：使用压缩；
  -F：指定ssh配置文件；
  -l：指定宽带限制；
  -o：指定使用的ssh选项；
  -P：指定远程主机的端口号；
  -p：保留文件的最后修改时间，最后访问时间和权限模式；
  -q：不显示复制进度；
  -r：以递归方式复制。
实例：
	scp常用的命令格式
    # scp local_file remote_username@remote_ip:remote_folder  
    # scp local_file remote_username@remote_ip:remote_file   
    # scp local_file remote_ip:remote_folder  
    # scp local_file remote_ip:remote_file 
    //从远处复制文件到本地目录
	# scp root@10.10.10.10:/opt/soft/nginx-0.5.38.tar.gz /opt/soft/
	//上传本地文件到远程主机指定目录
	# scp /opt/soft/nginx-0.5.38.tar.gz root@10.10.10.10:/opt/soft/scptest
	// 上传目录
	# scp -r /opt/soft/mongodb root@10.10.10.10:/opt/soft/scptest
	
### rm 删除文件
usage:
	rm (选项) (参数)
选项：
  -r  删除文件夹
  -f  删除不提示
  -i  删除提示
  -v  详细显示进行步骤
 
### touch 创建空文件或更新文件时间
usgae:
	touch (选项) 文件
参数：
  -a  只修改存取时间
  -m  值修改变动时间
  -r  eg:touch -r a b ,使b的时间和a相同
  -t  指定特定的时间 eg:touch -t 201211142234.50 log.log 
      -t time [[CC]YY]MMDDhhmm[.SS],C:年前两位
### pwd 查看当前所在的路径
### cd 切换目录
  - ：返回上层目录
  .. :返回上层目录
  回车  ：返回主目录
  /   :根目录
  
### mkdir 创建新目录
usage:
	mkdir [选项] 目录
选项：
  -p  递归创建目录，若父目录不存在则依次创建
  -m  自定义创建目录的权限  eg:mkdir -m 777 hehe
  -v  显示创建目录的详细信息

### rmdir 删除空目录
usgae:
	rmdir [选项] 目录
选项:
  -v  显示执行过程
  -p  若自父母删除后父目录为空则一并删除

```

####echo\cat\tac\more\less\nl\head\tail\wc\sort\uniq

这些命令是用来查看环境变量、文件内容和编辑文件内容的命令，会经常的用到的。

```bash
### echo 用于在shell中查看shell变量的值
usage:
	echo [选项] [参数]
选项：
  -n  输出后不换行
  -e  遇到转义字符特殊处理  
  
### cat 查看文件或合并文件   tac 反向显示
usage:
	cat [选项] [参数]
选项：
  -n或-number：有1开始对所有输出的行数编号；
  -b或--number-nonblank：和-n相似，只不过对于空白行不编号；
  -s或--squeeze-blank：当遇到有连续两行以上的空白行，就代换为一行的空白行；
  -A：显示不可打印字符，行尾显示“$”；
  -e：等价于"-vE"选项；
  -t：等价于"-vT"选项；
实例：
  # cat m1 （在屏幕上显示文件ml的内容）
  # cat m1 m2 （同时显示文件ml和m2的内容）
  # cat m1 m2 > file （将文件ml和m2合并后放入文件file中）
  
### more 按页查看文章内容，从前向后读取文件
usage:
	more (选项) (参数)
快捷键：
	space 显示文本的下一屏内容
	enter 显示文本的下一行内容
	| 可以在文本中寻找下一个匹配的模式
	H 显示帮助
	B 显示上一屏
	Q 退出
选项：
  -<数字>：指定每屏显示的行数；
  -d：显示“[press space to continue,'q' to quit.]”和“[Press 'h' for instructions]”；
  -c：不进行滚屏操作。每次刷新这个屏幕；
  -s：将多个空行压缩成一行显示；
  -u：禁止下划线；
  +<数字>：从指定数字的行开始显示。
实例：
	// 显示文件file的内容，但在显示之前先清屏
	# more -dc file
	// 显示文件file的内容，每10行显示一次
	# more -c -10 file

### less 允许用户向前或向后浏览文件
usage:
	less [选项] 参数
选项：
  -e：文件内容显示完毕后，自动退出；
  -f：强制显示文件；
  -g：不加亮显示搜索到的所有关键词，仅显示当前显示的关键字，以提高显示速度；
  -l：搜索时忽略大小写的差异；
  -N：每一行行首显示行号；
  -s：将连续多个空行压缩成一行显示；
  -S：在单行显示较长的内容，而不换行显示；
  -x<数字>：将TAB字符显示为指定个数的空格字符。
### head 从头开始显示文件，默认显示开头10行
usage:
	head [选项] [参数]
选项:
  -n<数字>：指定显示头部内容的行数；
  -c<字符数>：指定显示头部内容的字符数；
  -v：总是显示文件名的头信息；
  -q：不显示文件名的头信息。

### nl 计算输入中的行号
usage:
	nl [选项] 参数
选项：
  -b ：指定行号指定的方式，主要有两种：
      -b a ：表示不论是否为空行，也同样列出行号(类似 cat -n)；
      -b t ：如果有空行，空的那一行不要列出行号(默认值)；

  -n ：列出行号表示的方法，主要有三种：
      -n ln ：行号在萤幕的最左方显示；
      -n rn ：行号在自己栏位的最右方显示，且不加 0 ；
      -n rz ：行号在自己栏位的最右方显示，且加 0 ；

  -w ：行号栏位的占用的位数。
  -p ：在逻辑定界符处不重新开始计算。
实例：
	// 显示行号 (空白行不会显示)
	# nl xx.log
	// 显示行号(空白行业会显示)
	# nl -b a xx.log
	// 让行号前面自动补上0,统一输出格式
	# nl -b a -n rz xx.log
	
### tail 用于输入文件中的尾部内容
usage：
	tail [选项] 参数
选项:
  -v  显示详细的处理信息
  -q  不显示处理信息
  -num/-n (-)num      显示最后num行内容
  -n +num 从第num行开始显示后面的数据
  -c  显示最后c个字符
  -f  循环读取
实例：
	//显示文件的最后10行
	# tail file
	// 显示文件file的内容，从第20行到文件末尾
	# tail +20 file
	// 显示文件file的最后10个字符串
	# tail -c 10 file 

常用组合命令:
//从第3000行开始，显示1000行。即显示3000~3999行
# cat file | tail -n +3000 | head -n 1000
//显示1000行到3000行
# cat file | head -n 3000 | tail -n +1000
// 查看文件的第5行到第10行
# sed -n '5,10p' file
// 循环监视日志文件
# tail -f xx.log

### wc 该命令用来计算数字
usage:
	wc [选项] (参数)
选项:
  -c或--bytes或——chars：只显示Bytes数；
  -l或——lines：只显示列数；
  -w或——words：只显示字数。
常用实例:
	# wc -l file  //统计文件行数
	# wc -w file  //统计单词数
	# wc -c file  //统计字符数

### sort 对文件进行排序，并将排序结果标准输出
usage: sort [选项] (参数)
选项:
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
  -k 指定某一个列排序
  +<起始栏位>-<结束栏位>：以指定的栏位来排序，范围由起始栏位到结束栏位的前一栏位。
实例：
	//对文件内容进行排序
	# sort sort.txt
	// 对文件内容进行排序，忽略相同的行
	# sort -u sort.txt
	// 每行按空格分割成列，按照第2列排序
	# sort -t '' -k 2 sort.txt
	
### uniq 用户与报告和忽略文件中的重复行
usage:
	uniq [选项] (参数)
选项:
  -c或——count：在每列旁边显示该行重复出现的次数；
  -d或--repeated：仅显示重复出现的行列；
  -f<栏位>或--skip-fields=<栏位>：忽略比较指定的栏位；
  -s<字符位置>或--skip-chars=<字符位置>：忽略比较指定的字符；
  -u或——unique：仅显示出一次的行列；
  -w<字符位置>或--check-chars=<字符位置>：指定要比较的字符。
实例：
	//删除重复行
	# uniq file.txt 
	# sort file.text | uniq
	# sort -u file
	// 只显示一行
	# uniq -u file.txt
	// 统计各个行在文件中出现的次数
	# sort file.txt | uniq -c
	// 在文件中查找重复的行
	# sort file.text | uniq -d

```

### split\paste\cut

对文件进行分割合并也是很常见的操作，当然随着更智能化的工具的诞生，这些命令终将退出历史的舞台。也许所谓的区块连接车辙能在几年内完成这一项任务。

```bash
### split 将一个大文件分割成很多小文件
usage:
	split [选项] 参数
选项:
  -b：值为每一输出档案的大小，单位为 byte。
  -C：每一输出档中，单行的最大 byte 数。
  -d：使用数字作为后缀。
  -l：值为每一输出档的行数大小。
实例:
	// 将date.txt文件分割成10M大小的文件
    # split -b 10M date.txt
    // 每10000行一个文件
    # split -l 10000 data.txt

### paste 用于将多个文件按照行进列合并
usage:
	paste [选项] 参数
选项:
	-d<间隔字符>或--delimiters=<间隔字符>：用指定的间隔字符取代跳格字符；
	-s或——serial串列进行而非平行处理。
实例:
	# paste file1 file2

### cut 显示行中的指定不服，删除文件中的指定字段
usage:
	cut [选项] (参数)
选项:
  -b：仅显示行中指定直接范围的内容；
  -c：仅显示行中指定范围的字符；
  -d：指定字段的分隔符，默认的字段分隔符为“TAB”；
  -f：显示指定字段的内容；
  -n：与“-b”选项连用，不分割多字节字符；
  --complement：补足被选择的字节、字符或字段；
  --out-delimiter=<字段分隔符>：指定输出内容是的字段分割符；
  --help：显示指令的帮助信息；
  --version：显示指令的版本信息。
 实例:
 	//显示第5个字符开始到结尾的内容
 	# cut -c5- test.txt
 	//只显示前俩个字符
 	# cut -c-2 test.txt
 	//显示第一个到第三个字符
 	# cut -c1-3 test.txt
 
// 取出俩个文件的并集
#cat file1 file2 | sort | uniq > file3
```



### find\xargs\grep\awk\sed

find命令可以是linux中最有用的命令之一,有了find命令可以按照一定的条件查找文件，并对文件进行批处理。

```bash
usage:
	find [选项] [参数]
选项：
  -amin<分钟>：查找在指定时间曾被存取过的文件或目录，单位以分钟计算；
  -anewer<参考文件或目录>：查找其存取时间较指定文件或目录的存取时间更接近现在的文件或目录；
  -atime<24小时数>：查找在指定时间曾被存取过的文件或目录，单位以24小时计算；
  -cmin<分钟>：查找在指定时间之时被更改过的文件或目录；
  -cnewer<参考文件或目录>查找其更改时间较指定文件或目录的更改时间更接近现在的文件或目录；
  -ctime<24小时数>：查找在指定时间之时被更改的文件或目录，单位以24小时计算；
  -daystart：从本日开始计算时间；
  -depth：从指定目录下最深层的子目录开始查找；
  -expty：寻找文件大小为0 Byte的文件，或目录下没有任何子目录或文件的空目录；
  -exec<执行指令>：假设find指令的回传值为True，就执行该指令；
  -false：将find指令的回传值皆设为False；
  -fls<列表文件>：此参数的效果和指定“-ls”参数类似，但会把结果保存为指定的列表文件；
  -follow：排除符号连接；
  -fprint<列表文件>：此参数的效果和指定“-print”参数类似，但会把结果保存成指定的列表文件；
  -fprint0<列表文件>：此参数的效果和指定“-print0”参数类似，但会把结果保存成指定的列表文件；
  -fprintf<列表文件><输出格式>：此参数的效果和指定“-printf”参数类似，但会把结果保存成指定的列表文件；
  -fstype<文件系统类型>：只寻找该文件系统类型下的文件或目录；
  -gid<群组识别码>：查找符合指定之群组识别码的文件或目录；
  -group<群组名称>：查找符合指定之群组名称的文件或目录；
  -help或——help：在线帮助；
  -ilname<范本样式>：此参数的效果和指定“-lname”参数类似，但忽略字符大小写的差别；
  -iname<范本样式>：此参数的效果和指定“-name”参数类似，但忽略字符大小写的差别；
  -inum<inode编号>：查找符合指定的inode编号的文件或目录；
  -ipath<范本样式>：此参数的效果和指定“-path”参数类似，但忽略字符大小写的差别；
  -iregex<范本样式>：此参数的效果和指定“-regexe”参数类似，但忽略字符大小写的差别；
  -links<连接数目>：查找符合指定的硬连接数目的文件或目录；
  -iname<范本样式>：指定字符串作为寻找符号连接的范本样式；
  -ls：假设find指令的回传值为Ture，就将文件或目录名称列出到标准输出；
  -maxdepth<目录层级>：设置最大目录层级；
  -mindepth<目录层级>：设置最小目录层级；
  -mmin<分钟>：查找在指定时间曾被更改过的文件或目录，单位以分钟计算；
  -mount：此参数的效果和指定“-xdev”相同；
  -mtime<24小时数>：查找在指定时间曾被更改过的文件或目录，单位以24小时计算；
  -name<范本样式>：指定字符串作为寻找文件或目录的范本样式；
  -newer<参考文件或目录>：查找其更改时间较指定文件或目录的更改时间更接近现在的文件或目录；
  -nogroup：找出不属于本地主机群组识别码的文件或目录；
  -noleaf：不去考虑目录至少需拥有两个硬连接存在；
  -nouser：找出不属于本地主机用户识别码的文件或目录；
  -ok<执行指令>：此参数的效果和指定“-exec”类似，但在执行指令之前会先询问用户，
  	若回答“y”或“Y”，则放弃执行命令；
  -path<范本样式>：指定字符串作为寻找目录的范本样式；
  -perm<权限数值>：查找符合指定的权限数值的文件或目录；
  -print：假设find指令的回传值为Ture，就将文件或目录名称列出到标准输出。
  	格式为每列一个名称，每个名称前皆有“./”字符串；
  -print0：假设find指令的回传值为Ture，就将文件或目录名称列出到标准输出。格式为全部的名称皆在同一行；
  -printf<输出格式>：假设find指令的回传值为Ture，就将文件或目录名称列出到标准输出。格式可以自行指定；
  -prune：不寻找字符串作为寻找文件或目录的范本样式;
  -regex<范本样式>：指定字符串作为寻找文件或目录的范本样式；
  -size<文件大小>：查找符合指定的文件大小的文件；
  -true：将find指令的回传值皆设为True；
  -typ<文件类型>：只寻找符合指定的文件类型的文件；
  -uid<用户识别码>：查找符合指定的用户识别码的文件或目录；
  -used<日数>：查找文件或目录被更改之后在指定时间曾被存取过的文件或目录，单位以日计算；
  -user<拥有者名称>：查找符和指定的拥有者名称的文件或目录；
  -version或——version：显示版本信息；
  -xdev：将范围局限在先行的文件系统中；
  -xtype<文件类型>：此参数的效果和指定“-type”参数类似，差别在于它针对符号连接检查。
实例:
	//基于name查询
	# find . -name test.txt
	# find /etc -name test.txt
    # find /home -iname test.txt
    # find / -type d -name test
    # find . -type f -name test.php
    # find . -type f -name *.php  //("*.php" 也是可以的)
    
    //基于权限的查询
    # find . -type f -perm 777 -print
    
    //基于用户好组查询
    # find / -user root -name test.txt
    # find /home -group developer
    # find /home -user developer -iname *.txt
    
    // 基于时间查询文件或目录
    # find / -mtime 50
    # find / -mtime +50 -mtime -100
    
    // 按照文件类型查找
    # find . type s //socket文件
    # find . type d //查找所有目录
    # find . type f //查找一般文件
    # find 
    
    // 基于文件大小查找文件或目录
    # find / -empty //查找空文件
    # find / -size 50M
    # find / -size +50M -size -100M
    # find / -type f -exec ls -s {} \; | sort -n -r | head -5 //查找当前目录最大的5个文件
    
    
    // 限定搜索目录深度
    # find / -maxdepth 2 -name passwd
    # find / -mindepth 3 -maxdepth 5 -name "*per*"
    
    // 相反匹配
    # find / -not -name "*.py"
    
    
    // 在find命令查找到的文件上执行命令
    # find -name "*.py" -exec md5sum {} \;
    // 查找当前目录下的所有txt文件
    # find ./ -name "*.txt" -exec ls -l "{}" /;
    // 将当前目录下的txt文件重名成txtd
    # find ./ -name "*.txt" -exec mv "{}" "{}d" /;
	// 查找内容中包含‘password’的文件列表
	# find . -type f  -exec grep 'password'  -l {} \;
	// 查找一小时内被编辑过的文件
	# find . -mmin -60 -exec ls -l {} \;
	// 删除所有pm3文件名中的空格
	# find . -type f -iname "*.mp3" -exec rename "s/ /_/g" {};
```

**xargs命令**是给其他命令传递参数的一个过滤器，也是组合多个命令的一个工具。它擅长将标准输入数据转换成命令行参数，xargs能够处理管道或者stdin并将其转换成特定命令的命令参数。xargs也可以将单行或多行文本输入转换为其他格式，例如多行变单行，单行变多行。xargs的默认命令是[echo](http://man.linuxde.net/echo)，空格是默认定界符。这意味着通过管道传递给xargs的输入将会包含换行和空白，不过通过xargs的处理，换行和空白将被空格取代。xargs是构建单行命令的重要组件之一。

```bash
usage:
	xargs [选项] command 参数
选项:
	-n 多行输出
	-d 自定义分界符
	-t 执行命令前先打印命令
	-I 参数替换
实例:
	# a.txt b.txt c.txt
	//查看txt文件的详细信息
	// 命令执行过程:
	//	1.ls *.txt 输出 a.txt b.txt c.txt
	//	2.通过管道将输出的 a.txt b.txt c.txt传递个xargs
	//	3.xargs通过空格/换行作为分割符将输出转成a.txt\b.txt\c.txt
	//	4.xargs将分割结果传递给后续的命令
	//	5.执行组和成的命令 ls -al a.txt b.txt c.txt
	# ls *.txt | xargs ls -al
	# ls *.txt | xargs -t ls -al  //执行命令前先打印命令
	# ls *.txt | xargs -t -n1 ls -al //将一条命令组合成3条命令，即执行3次ls
	//-I '{}' 表示将后面的命令中的{}替换成签名解析出来的参数值，在执行命令
	# ls *.txt | xargs -t -n1 -I '{}'  mv {} {}.backup
	// -print0 告诉find命令在输出文件名之后跟上NULL字符，而不是换行符
	// -0 告诉xargs 以NULL作为分割符
	# find . -name "*.txt" -print0 | xargs -0 -t ls -al
	
	// find + xargs 常见的命令实例
	// 批量下载
	# cat url-list.txt | xargs wget –c
	//查找并压缩jpg文件
	# find / -name *.jpg -type f -print | xargs tar -cvzf images.tar.gz
	//复制图片党另外一个目录
	# find . -iname "*.jpg" | xargs -1n -i cp {} /backup/
```

##### grep

grep是global search regular expression and print out the line的简称，简单的说就是搜索正则表达式并打印，是linux中强大的文本搜索工具，使用它可以利用正则表达式进行搜索匹配。

```bash
usage:
	grep [选项] PATTERN FILE
	grep [选项] [-e PATTERN | -f file] [FILE]
选项：
  -a 不要忽略二进制数据。
  -A<显示列数> 除了显示符合范本样式的那一行之外，并显示该行之后的内容。
  -b 在显示符合范本样式的那一行之外，并显示该行之前的内容。
  -c 计算符合范本样式的列数。
  -C<显示列数>或-<显示列数>  除了显示符合范本样式的那一列之外，并显示该列之前后的内容。
  -d<进行动作> 当指定要查找的是目录而非文件时，必须使用这项参数，否则grep命令将回报信息并停止动作。
  -e<范本样式> 指定字符串作为查找文件内容的范本样式。
  -E 将范本样式为延伸的普通表示法来使用，意味着使用能使用扩展正则表达式。
  -f<范本文件> 指定范本文件，其内容有一个或多个范本样式，让grep查找符合范本条件的文件内容，格式为每一列的范本样式。
  -F 将范本样式视为固定字符串的列表。
  -G 将范本样式视为普通的表示法来使用。
  -h 在显示符合范本样式的那一列之前，不标示该列所属的文件名称。
  -H 在显示符合范本样式的那一列之前，标示该列的文件名称。
  -i 忽略字符大小写的差别。
  -l 列出文件内容符合指定的范本样式的文件名称。
  -L 列出文件内容不符合指定的范本样式的文件名称。
  -n 在显示符合范本样式的那一列之前，标示出该列的编号。
  -q 不显示任何信息。
  -R/-r 此参数的效果和指定“-d recurse”参数相同。
  -s 不显示错误信息。
  -v 反转查找。
  -w 只显示全字符合的列。
  -x 只显示全列符合的列。
  -y 此参数效果跟“-i”相同。
  -o 只输出文件中匹配到的部分。
实例：
	常见用法：
	//在文件搜索，返回符合的文本行
	# grep match_pattern file_name
	# grep "match_pattern" file_name
	//在多个文件中查找
	# grep "match_pattern" file_1 file_2
	// 标记匹配演示
	# grep "match_pattern" file_name --color=auto
	// 在/etc/passwd中查找root
	# grep root /etc/passwd
	// 在多个文件中查找模式
	# grep root /etc/passwd /etc/shadow
	// 使用-l参数列出行号指定模式的文件名
	# grep -l root /etc/passwd /etc/shadow
	// 使用-你参数，在文件中查找模式并显示匹配行的行号
	# grep -n root /etc/passwd
	// 使用-v参数输出不包含指定模式的行
	# grep -v root /etc/passwd
	//使用^查找开头的行号
	# grep ^root /etc/passwd
	//使用$查找结尾的行
	# grep root$ /etc/passwd
	//使用-r在指定目录下递归查找指定模式
	# grep -r root /etc/
	// 使用-i参数忽略大小写
	# grep -i root /etc/passwd
	// 使用-e参数查找多个模式
	# grep -e "root" -e "toor" /etc/passwd
	// 使用-f用指定的模式文件查找
	# grep -f grep_pattern.file /etc/passwd
	// 使用-c参数计算模式匹配到的数量
	# grep -c root /etc/passwd
	// 输出匹配指定模式行的前N行
	# grep -B 4 "root" /etc/passwd
	// 输出匹配行后的后N行
	# grep -A 4 "root" /etc/passwd
	// 输出匹配行的前后各4行
	# grep -C 4 "root" /etc/passwd
	
```

#####awk

awk是一个强大的文本分析工具，相对于grep的查找，sed的编辑，awk在对数据分析统计方面尤为强大。其工作原理简单的来说就是吧文件逐行的读入，以空格为默认的分割符每行切片，切开的步伐再进行各种分析处理。awk有3个不同的版本，awk、nawk和gawk，未特别说一般指gawk。awk工作流程是这样的：先执行BEGING，然后读取文件，读入有/n换行符分割的一条记录，然后将记录按指定的域分隔符划分域，填充域，$0则表示所有域,$1表示第一个域,$n表示第n个域,随后开始执行模式所对应的动作action。接着开始读入第二条记录······直到所有的记录都读完，最后执行END操作。

```bash
usage:
	awk [-F field-separator] 'commands' intput-files
	awk -f awk-script-file input-files
模式:
	awk的模式可以是以下任意一个
	/正则表达式/:	使用通配符的扩展集
	关系表达式:		使用运算符进行操作、可以是字符串或数字的比较测试
	模式匹配表达式:	用运算符~(匹配) 和~!(不匹配)
awk脚本的基本结构
	一个awk脚本通常由：BEGIN语句块、pattern语句块、END语句块 这3部分构成，这三部分是可选的，
	任意一部分都可以不出现在脚本中，脚本通常是被单引号或双引号包起来：
	awk 'BEGIN{ print "start" } pattern{ command} NED{ print "end" }' file
	awk 'BEGIN{ i=0 } { i++ } END { print i }' file
	awk "BEGIN{ i=0 } { i++ } END { print i}" file
```

如上描述了awk脚本的基本结构，下载说说awk的工作原理，如上所示先执行BEGIN语句块，在执行pattern语句，最后执行END语句块，详细步骤如下：

* 第一步：执行`BEGIN{ commands }`语句块中的语句；
* 第二步：从文件或标准输入(stdin)读取一行，然后执行`pattern{ commands }`语句块，它逐行扫描文件，从第一行到最后一行重复这个过程，直到文件全部被读取完毕。
* 第三步：当读至输入流末尾时，执行`END{ commands }`语句块。

另外awk内置了一些变量，可以方彪的在语句块中使用,这些变量有和内置的字符函数:

```
$n 当前记录的第n个字段，比如n为1表示第一个字段，n为2表示第二个字段。 
$0 这个变量包含执行过程中当前行的文本内容。
[N] ARGC 命令行参数的数目。
[G] ARGIND 命令行中当前文件的位置（从0开始算）。
[N] ARGV 包含命令行参数的数组。
[G] CONVFMT 数字转换格式（默认值为%.6g）。
[P] ENVIRON 环境变量关联数组。
[N] ERRNO 最后一个系统错误的描述。
[G] FIELDWIDTHS 字段宽度列表（用空格键分隔）。
[A] FILENAME 当前输入文件的名。
[P] FNR 同NR，但相对于当前文件。
[A] FS 字段分隔符（默认是任何空格）。
[G] IGNORECASE 如果为真，则进行忽略大小写的匹配。
[A] NF 表示字段数，在执行过程中对应于当前的字段数。
[A] NR 表示记录数，在执行过程中对应于当前的行号。
[A] OFMT 数字的输出格式（默认值是%.6g）。
[A] OFS 输出字段分隔符（默认值是一个空格）。
[A] ORS 输出记录分隔符（默认值是一个换行符）。
[A] RS 记录分隔符（默认是一个换行符）。
[N] RSTART 由match函数所匹配的字符串的第一个位置。
[N] RLENGTH 由match函数所匹配的字符串的长度。
[N] SUBSEP 数组下标分隔符（默认值是34）。

字符函数://Ere都是可以使用正则表达式

gsub( Ere, Repl, [ In ] )	除了正则表达式所有具体值被替代这点，它和 sub 函数完全一样地执行。
sub( Ere, Repl, [ In ] )	用 Repl 参数指定的字符串替换 In 参数指定的字符串中的由 Ere 参数指定的扩展正则表达式的第一个具体值。sub 函数返回替换的数量。出现在 Repl 参数指定的字符串中的 &（和符号）由 In 参数指定的与 Ere 参数的指定的扩展正则表达式匹配的字符串替换。如果未指定 In 参数，缺省值是整个记录（$0 记录变量）。
index( String1, String2 )	在由 String1 参数指定的字符串（其中有出现 String2 指定的参数）中，返回位置，从 1 开始编号。如果 String2 参数不在 String1 参数中出现，则返回 0（零）。
length [(String)]	返回 String 参数指定的字符串的长度（字符形式）。如果未给出 String 参数，则返回整个记录的长度（$0 记录变量）。
blength [(String)]	返回 String 参数指定的字符串的长度（以字节为单位）。如果未给出 String 参数，则返回整个记录的长度（$0 记录变量）。
substr( String, M, [ N ] )	返回具有 N 参数指定的字符数量子串。子串从 String 参数指定的字符串取得，其字符以 M 参数指定的位置开始。M 参数指定为将 String 参数中的第一个字符作为编号 1。如果未指定 N 参数，则子串的长度将是 M 参数指定的位置到 String 参数的末尾 的长度。
match( String, Ere )	在 String 参数指定的字符串（Ere 参数指定的扩展正则表达式出现在其中）中返回位置（字符形式），从 1 开始编号，或如果 Ere 参数不出现，则返回 0（零）。RSTART 特殊变量设置为返回值。RLENGTH 特殊变量设置为匹配的字符串的长度，或如果未找到任何匹配，则设置为 -1（负一）。
split( String, A, [Ere] )	将 String 参数指定的参数分割为数组元素 A[1], A[2], . . ., A[n]，并返回 n 变量的值。此分隔可以通过 Ere 参数指定的扩展正则表达式进行，或用当前字段分隔符（FS 特殊变量）来进行（如果没有给出 Ere 参数）。除非上下文指明特定的元素还应具有一个数字值，否则 A 数组中的元素用字符串值来创建。
tolower( String )	返回 String 参数指定的字符串，字符串中每个大写字符将更改为小写。大写和小写的映射由当前语言环境的 LC_CTYPE 范畴定义。
toupper( String )	返回 String 参数指定的字符串，字符串中每个小写字符将更改为大写。大写和小写的映射由当前语言环境的 LC_CTYPE 范畴定义。
sprintf(Format, Expr, Expr, . . . )	根据 Format 参数指定的 printf 子例程格式字符串来格式化 Expr 参数指定的表达式并返回最后生成的字符串。


特殊函数：
close( Expression )	用同一个带字符串值的 Expression 参数来关闭由 print 或 printf 语句打开的或调用 getline 函数打开的文件或管道。如果文件或管道成功关闭，则返回 0；其它情况下返回非零值。如果打算写一个文件，并稍后在同一个程序中读取文件，则 close 语句是必需的。
system(command )	执行 Command 参数指定的命令，并返回退出状态。等同于 system 子例程。
Expression | getline [ Variable ]	从来自 Expression 参数指定的命令的输出中通过管道传送的流中读取一个输入记录，并将该记录的值指定给 Variable 参数指定的变量。如果当前未打开将 Expression 参数的值作为其命令名称的流，则创建流。创建的流等同于调用 popen 子例程，此时 Command 参数取 Expression 参数的值且 Mode 参数设置为一个是 r 的值。只要流保留打开且 Expression 参数求得同一个字符串，则对 getline 函数的每次后续调用读取另一个记录。如果未指定 Variable 参数，则 $0 记录变量和 NF 特殊变量设置为从流读取的记录。
getline [ Variable ] < Expression	从 Expression 参数指定的文件读取输入的下一个记录，并将 Variable 参数指定的变量设置为该记录的值。只要流保留打开且 Expression 参数对同一个字符串求值，则对 getline 函数的每次后续调用读取另一个记录。如果未指定 Variable 参数，则 $0 记录变量和 NF 特殊变量设置为从流读取的记录。
getline [ Variable ]	将 Variable 参数指定的变量设置为从当前输入文件读取的下一个输入记录。如果未指定 Variable 参数，则 $0 记录变量设置为该记录的值，还将设置 NF、NR 和 FNR 特殊变量。

时间函数:
mktime( YYYY MM dd HH MM ss[ DST])	生成时间格式
strftime([format [, timestamp]])	格式化时间输出，将时间戳转为时间字符串
systime()	得到时间戳,返回从1970年1月1日开始到当前时间(不计闰年)的整秒数
```

实例

```bash
$ echo -e "A line 1\nB line 2" | awk 'BEGIN { print "start" } { print } END { print "end" }'
start
A line 1
B line 2
end

// 如上输出A和B
$ echo -e "A line 1\nB line 2" | awk 'BEGIN { print "start" } { print $1} END { print "end" }'

//使用变量
$ echo | awk '{ var1="v1"; var2="v2"; var3="v3"; print var1,var2,var3; }'
v1 v2 v3
$ echo | awk '{ var1="v1"; var2="v2"; var3="v3"; print var1"="var2"="var3; }'
v1=v2=v3

//使用$NF能获取到最后一个字段 使用$(NF-1)就能获取倒数第二个字段
$ echo -e "line1 f2 f3\n line2 f4 f5" | awk '{print $NF}'
f3
f5
//打印每一行的第二和第三个字段
$ awk '{ print $2,$3} ' filename
//统计文件中的行数
$ awk 'END{ print NR }' filename

// 每一行中第一个字段的值累加
$ seq 5 | awk 'BEGIN{ sum=0; print "总和：" } { print $1"+"; sum+=$1 } END{ print "等于"; print sum }'

//传递外部变量
$ var=1000
$ echo | awk -v VARIABLE=$var '{ print VARRIABLE }'


//运算符
//+ -	加，减
//* / &	乘，除与求余
//+ - !	一元加，减和逻辑非
//^ ***	求幂
//++ --	增加或减少，作为前缀或后缀
//= += -= *= /= %= ^= **=	赋值语句
// || && 或 与
// < <= > >= != ==	关系运算符
//$	字段引用
//空格	字符串连接符
//?:	条件表达式(三目运算符)
//in	数组中是否存在某键值
$ awk 'BEGIN{a="b";print a++,++a;}'
$ awk 'BEGIN{a=1;b=2;print (a>5 && b<=2),(a>5 || b<=2);}'
$ awk 'BEGIN{a=11;if(a >= 9){print "ok";}}'
$ awk 'BEGIN{a="b";print a=="b"?"ok":"err";}'
$ awk 'BEGIN{a="b";arr[0]="b";arr[1]="c";print (a in arr);}'

// 正则运算符
//~ ~！ 匹配或不匹配
$ awk 'BEGIN{a="100testa";if(a ~ /^100*/){print "ok";}}'

//next语法 awk中next语句使用：在循环逐行匹配，如果遇到next，就会跳过当前行，直接忽略下面语句
// 只对双数行进行处理
$ awk 'NR%2==1{next}{print NR,$0;}' file_name
// 跳过web开头的行 然后将需要内容与下面的行合并为一行
$ awk '/^web/{T=$0;next;}{print T":t"$0;}' test.txt

// 输出到文件
$ echo | awk '{printf("hello word!n") > "datafile"}'
$ echo | awk '{printf("hello word!n") >> "datafile"}'

//设定分界符(默认是空格)
$ awk -F: '{ print $NF }' /etc/passwd
$ awk 'BEGIN{ FS=":" } { print $NF }' /etc/passwd

// if-else
$ awk 'BEGIN{
test=100;
if(test>90){
  print "very good";
  }
  else if(test>60){
    print "good";
  }
  else{
    print "no pass";
  }
 }'
 
 // while
 $ awk 'BEGIN{
  test=100;
  total=0;
  while(i<=test){
    total+=i;
    i++;
  }
  print total;
  }'
  
  // for循环
  $awk 'BEGIN{
  for(k in ENVIRON){
    print k"="ENVIRON[k];
  }
  }'
  
  //数组
  Array[1]="sun"
  Array[2]="kai"
  Array["first"]="www"
  Array["last"]="name"
  Array["birth"]="1987"
  
  $ awk -v array=$Array '{ for(item in array) {print array[item]}; }'
  $ awk -v array=$Array '{ for(i=1;i<=len;i++) {print array[i]}; }'
  
  //字符串内置函数
  //gsub,sub
  $ awk 'BEGIN{info="this is a test2010test!";gsub(/[0-9]+/,"!",info);print info}'
	this is a test!test!
  // 查找字符串
  $ awk 'BEGIN{info="this is a test2010test!";print index(info,"test")?"ok":"no found";}'
  // 正则表示match使用
  $ awk 'BEGIN{info="this is a test2010test!";print match(info,/[0-9]+/)?"ok":"no found";}'
  // 字符串截取
  $ awk 'BEGIN{info="this is a test2010test!";print substr(info,4,10);}'
  // 字符串分割
  $ awk 'BEGIN{info="this is a test";split(info,tA," ");print length(tA);for(k in tA){print k,tA[k];}}'
  
  // 打开和关闭外部文件
  $ awk 'BEGIN{while("cat /etc/passwd"|getline){print $0;};close("/etc/passwd");}'
  
  //求时间差
  $ awk 'BEGIN{tstamp1=mktime("2014 01 03 12 13 14");tstamp2=systime();print tstamp2-tstamp1;}' 
```

##### sed

sed是stream editor for filtering and transforming text的简称，简单的说就sed就是一个流编辑器，它能配合正则表达式完成批量自动化的文件编辑。处理时把当前行缓存起来，然后对缓存进行处理，将处理结果输出的屏幕上，然后接着处理下一行，这样不断重复直至文件末尾。文件的内容并不会改变，除非手动重定向。

```bash
usage:
	sed [option] 'command' files
	sed [option] -f script_file files
选项：
  -e<script>或--expression=<script>：以选项中的指定的script来处理输入的文本文件；
  -f<script文件>或--file=<script文件>：以选项中指定的script文件来处理输入的文本文件；
  -h或--help：显示帮助；
  -n或--quiet或——silent：仅显示script处理后的结果；
  -V或--version：显示版本信息。
command：
  a\ 在当前行下面插入文本。
  i\ 在当前行上面插入文本。
  c\ 把选定的行改为新的文本。
  d 删除，删除选择的行。
  D 删除模板块的第一行。
  s 替换指定字符
  h 拷贝模板块的内容到内存中的缓冲区。
  H 追加模板块的内容到内存中的缓冲区。
  g 获得内存缓冲区的内容，并替代当前模板块中的文本。
  G 获得内存缓冲区的内容，并追加到当前模板块文本的后面。
  l 列表不能打印字符的清单。
  n 读取下一个输入行，用下一个命令处理新的行而不是用第一个命令。
  N 追加下一个输入行到模板块后面并在二者间嵌入一个新行，改变当前行号码。
  p 打印模板块的行。
  P(大写) 打印模板块的第一行。
  q 退出Sed。
  b lable 分支到脚本中带有标记的地方，如果分支不存在则分支到脚本的末尾。
  r file 从file中读行。
  t label if分支，从最后一行开始，条件一旦满足或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾。
  T label 错误分支，从最后一行开始，一旦发生错误或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾。
  w file 写并追加模板块到file末尾。  
  W file 写并追加模板块的第一行到file末尾。  
  ! 表示后面的命令对所有没有被选定的行发生作用。  
  = 打印当前行号码。  
  # 把注释扩展到下一个换行符以前。
  
sed 替换标记
	g	表示行内全面替换
	p	表示打印行
	w	表示吧行写入一个文件
	x	表示互换模块中的文本和缓冲区中的文本
	y 	表示吧一个字符翻译为另外的字符(但不适用正则表达式)
	\1	子串标记
	&	已匹配字符串比较
	
sed 元字符集
    ^ 匹配行开始，如：/^sed/匹配所有以sed开头的行。
    $ 匹配行结束，如：/sed$/匹配所有以sed结尾的行。
    . 匹配一个非换行符的任意字符，如：/s.d/匹配s后接一个任意字符，最后是d。
    * 匹配0个或多个字符，如：/*sed/匹配所有模板是一个或多个空格后紧跟sed的行。
    [] 匹配一个指定范围内的字符，如/[ss]ed/匹配sed和Sed。  
    [^] 匹配一个不在指定范围内的字符，如：/[^A-RT-Z]ed/匹配不包含A-R和T-Z的一个字母开头，紧跟ed的行。
    \(..\) 匹配子串，保存匹配的字符，如s/\(love\)able/\1rs，loveable被替换成lovers。
    & 保存搜索字符用来替换其他字符，如s/love/**&**/，love这成**love**。
    \< 匹配单词的开始，如:/\<love/匹配包含以love开头的单词的行。
    \> 匹配单词的结束，如/love\>/匹配包含以love结尾的单词的行。
    x\{m\} 重复字符x，m次，如：/0\{5\}/匹配包含5个0的行。
    x\{m,\} 重复字符x，至少m次，如：/0\{5,\}/匹配至少有5个0的行。
    x\{m,n\} 重复字符x，至少m次，不多于n次，如：/0\{5,10\}/匹配5~10个0的行。
    
 实例：
 	// 将book替换为books
 	$ echo 'book xx friends' | sed 's/book/books/'
 	books xx friends
 	
 	// 将文件中第一个o替换为大写的O
 	$ sed 's/o/O/' sort.txt
 	// 将每行中o替换为O
 	$ sed 's/o/O/g' sort.txt
 	// 直接编辑源文件
 	$ sed -i 's/o/O/g' sed.txt
 	// 将每行中的每第二个o替换为大写的O
 	$ sed 's/o/O/2g' sed.txt
 	
 	//默认的界定符为/，也可以使用任意的界定符
 	$ sed 's:o:O:' sed.txt
 	//替换定义服你
 	$ sed 's:o:\:0:' sed.txt
 	
 	//删除操作
 	//删除空白行
 	$ sed '/^$/d' sed.txt
 	//删除文件的第二行
 	$ sed '2d' sed.txt
 	//删除文件的第2行到末尾的所有行
 	$ sed '2,$d' sed.txt
 	//删除文件的最后一行
 	$ sed '$d' sed.txt
 	// 删除文件中所有开头是test的行
 	$ sed '/^test/d' file.txt
 	// 删除文件中的空行和以test开头的行
 	$ sed '/^g/d;/^$/d' sed.txt
 	
 	//已匹配的字符串标记&
 	//将google中oo用p标签标记起来
 	$ echo 'google' | sed 's/o\+/<p>&<\/p>/g'
 	//将所以以192.168.0.开头的行都替换为加上-localhost
 	$ sed 's/^/192.168.0/&-localhost/' sed.txt
 	
 	//将以go开头的词替换为Go开头
 	$ sed 's/\<go/Go/g' sed.txt
 	//将至少2个00连续的数字替换为XX
 	$ sed 's/0\{2,\}/XX/g' sed.txt
 	
 	//使用变量
 	$ test=hello
 	$ echo "hello world" | sed "s/$test/Hello/"
  
  	// 子串标记
	$ echo aaa BBB | sed 's/\([a-z]\+\) \([A-Z]\+\)/\2 \1/'
	
	
	// 选定行的范围
	//打印模板test和check所确定的范围内的行
	$ sed -n '/test/,/check/p' file
	// 从第5行开始到遇到以test开头的行之前的所有行
	$ sed -n '5,/^test/p' file
	// 打印以g开头的行到下一个g开头行之前的所有行
	$ sed -n '/^g/,/^g/p' sort.txt
	// 以g开头的行到下一个g开头行之前的所有行末尾加上aaa bbb并打印
	$ sed -n '/^g/,/^g/s/$/aaa bbb/p' sort.txt
	
	// 多点编辑
	// sed表达式的第一条命令删除1至5行，第二条命令用check替换test。
	// 命令的执行顺序对结果有影响。如果两个命令都是替换命令，那么第一个替换命令将影响第二个替换命令的结果。
	$ sed -e '1,5d' -e 's/test/check/' file
	
	// 文件
	// file里的内容被读进来，显示在test匹配的行后面，如果匹配多行，则file的内容显示在所有匹配行后面
	$ sed '/test/r file' file
	// 在file中所有包含test的行都被写入f里面
	$ sed '/test/w f' file
	
	//奇偶行
	$ sed -n 'p;n' test //奇数行
	$ sed -n 'n;p' test //偶数行
```

#### vi/vim

vi和vim是命令形式下编辑文件的最佳选择，当然还有神一样的emacs。vi编辑器支持编辑模式和命令模式，编辑模式下可以完成文本的编辑功能，命令模式下可以完成对文件的操作命令，要正确使用vi编辑器就必须熟练掌握着两种模式的切换。

vi有一些内置的命令，以“：“开头输入

```bash
Ctrl+u：向文件首翻半屏；
Ctrl+d：向文件尾翻半屏；
Ctrl+f：向文件尾翻一屏；
Ctrl+b：向文件首翻一屏；
Esc：从编辑模式切换到命令模式；
ZZ：命令模式下保存当前文件所做的修改后退出vi；
:行号：光标跳转到指定行的行首；
:$：光标跳转到最后一行的行首；
x或X：删除一个字符，x删除光标后的，而X删除光标前的；
D：删除从当前光标到光标所在行尾的全部字符；
dd：删除光标行正行内容；
ndd：删除当前行及其后n-1行；
nyy：将当前行及其下n行的内容保存到寄存器？中，其中？为一个字母，n为一个数字；
p：粘贴文本操作，用于将缓存区的内容粘贴到当前光标所在位置的下方；
P：粘贴文本操作，用于将缓存区的内容粘贴到当前光标所在位置的上方；
/字符串：文本查找操作，用于从当前光标所在位置开始向文件尾部查找指定字符串的内容，查找的字符串会被加亮显示；
？name：文本查找操作，用于从当前光标所在位置开始向文件头部查找指定字符串的内容，查找的字符串会被加亮显示；
a，bs/F/T：替换文本操作，用于在第a行到第b行之间，将F字符串换成T字符串。其中，“s/”表示进行替换操作；
a：在当前字符后添加文本；
A：在行末添加文本；
i：在当前字符前插入文本；
I：在行首插入文本；
o：在当前行后面插入一空行；
O：在当前行前面插入一空行；
:wq：在命令模式下，执行存盘退出操作；
:w：在命令模式下，执行存盘操作；
:w！：在命令模式下，执行强制存盘操作；
:q：在命令模式下，执行退出vi操作；
:q！：在命令模式下，执行强制退出vi操作；
:e文件名：在命令模式下，打开并编辑指定名称的文件；
:n：在命令模式下，如果同时打开多个文件，则继续编辑下一个文件；
:f：在命令模式下，用于显示当前的文件名、光标所在行的行号以及显示比例；
:set number：在命令模式下，用于在最左端显示行号；
:set nonumber：在命令模式下，用于在最左端不显示行号；


usage: 
	vi (选项) (参数)
	
选项
    +<行号>：从指定行号的行开始先是文本内容；
    -b：以二进制模式打开文件，用于编辑二进制文件和可执行文件；
    -c<指令>：在完成对第一个文件编辑任务后，执行给出的指令；
    -d：以diff模式打开文件，当多个文件编辑时，显示文件差异部分；
    -l：使用lisp模式，打开“lisp”和“showmatch”；
    -m：取消写文件功能，重设“write”选项；
    -M：关闭修改功能；
    -n：不实用缓存功能；
    -o<文件数目>：指定同时打开指定数目的文件；
    -R：以只读方式打开文件；
    -s：安静模式，不现实指令的任何错误信息。
```

#####文件编码

常常因为一些编码的问题导致文件内容乱码不可读，在linu想下更文件编码有关的操作有。

1. 在vi/vim中可以查看和设置文件编码

   :set fileencoding

   :set encoding=utf-8

2. 使用enca查看文件编码

   $ enca filename

3. iconv转换文件编码

   $ iconv -f encoding -t encoding inputfile

   $ iconv -f GBK -t UTF-8 file1 -o file2

4. enconv 转换文件编码

   $ enconv -L zh_CN -x UTF-8 filename

5. 文件名乱码

   有事从windows下copy到linux的文件名可能会出现乱码，此时可以通过convmv命令来完成该操作。

##### 超大文件

有些超大的文件用常规命令操作，经常不尽人意，此时需要超大文件操作方案

1. vim的largefile插件

2. glolgg 日志资源管理器

3. JOE文件编辑器

4. 分割操作

   ​

#### 文件归档

所谓文件归档无非就是打包压缩之类的。在linux常用的归档命令有tar等。

```bash
### tar
usage:
	tar [选项] [参数]
选项:
  -A或--catenate：新增文件到以存在的备份文件；
  -B：设置区块大小；
  -c或--create：建立新的备份文件；
  -C <目录>：这个选项用在解压缩，若要在特定目录解压缩，可以使用这个选项。
  -d：记录文件的差别；
  -x或--extract或--get：从备份文件中还原文件；
  -t或--list：列出备份文件的内容；
  -z或--gzip或--ungzip：通过gzip指令处理备份文件；
  -Z或--compress或--uncompress：通过compress指令处理备份文件；
  -f<备份文件>或--file=<备份文件>：指定备份文件；
  -v或--verbose：显示指令执行过程；
  -r：添加文件到已经压缩的文件；
  -u：添加改变了和现有的文件到已经存在的压缩文件；
  -j：支持bzip2解压文件；
  -v：显示操作过程；
  -l：文件系统边界设置；
  -k：保留原有文件不覆盖；
  -m：保留文件不被覆盖；
  -w：确认压缩文件的正确性；
  -p或--same-permissions：用原来的文件权限还原文件；
  -P或--absolute-names：文件名使用绝对名称，不移除文件名称前的“/”号；
  -N <日期格式> 或 --newer=<日期时间>：只将较指定日期更新的文件保存到备份文件里；
  --exclude=<范本样式>：排除符合范本样式的文件。
 实例：
 	//仅仅打包，不压缩
 	$ tar -cvf log.tar  log.txt
 	//打包以gzip压缩
 	$ tar -zcvf log.tar.gz log.txt
 	//打包以bzip2压缩
 	$ tar -jcvf log.tar.bz2 log.txt
 	// 查看压缩包的内容
 	$ tar -ztvf log.tar.gz
 	// 解压压缩包
 	$ tar -zxvg log.tar.gz
 	// 保留原文件的属性压缩
 	$ tar -zcvpf log.tar.gz log.txt
 	//
 	$ tar -jxv -f log.tar.gz -C 解压目录
 	
 //zip
 $ zip file.zip files
 $ unzip file.zip
 
 // rar
 $ rar a filerar file
 $ unrar e filerar.rar
 $ unrar x filerar.rar
```





































