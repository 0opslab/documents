# title{read - 命令用于从标准输入读取数值}


### 选项
```bash
-a 后跟一个变量，该变量会被认为是个数组，然后给其赋值，默认是以空格为分割符。
-d 后面跟一个标志符，其实只有其后的第一个字符有用，作为结束的标志。
-p 后面跟提示信息，即在输入前打印提示信息。
-e 在输入的时候可以使用命令补全功能。
-n 后跟一个数字，定义输入文本的长度，很实用。
-r 屏蔽\，如果没有该选项，则\作为一个转义字符，有的话 \就是个正常的字符了。
-s 安静模式，在输入字符时不再屏幕上显示，例如login时输入密码。
-t 后面跟秒数，定义输入字符的等待时间。
-u 后面跟fd，从文件描述符中读入，该文件描述符可以是exec新开启的。
```

### 常用命令
```bash
#!/bin/bash
read -t 5 -p "A compress ([bzip2|gzip|xz]): "  Com
[ -z $Com ] && Com=gzip
echo $Com


# 控制等待输入的时间 -t Second
if read -t 5 -p "Please input your name:" name;
then
    echo "$name,welcome!";
else
    echo "sorry";
fi;
exit 0

# 控制输入字符长度 -nNumber Number表示控制字符的长度,超过则read命令立即接受输入并将其传给变量。无需按回车键。
read -n1 -p "Do you agree with me [Y/N]?" ans
case $ans in
Y|y)
    echo "Great!";;
N|n)
    echo "Oh No!";;
*)
    echo "Please choice Y or N";;
esac;

# 读取文件,通过cat file 配合管道处理,如 cat file | while read line
count=1
if read -p "choice your file:" yourfile;then
    cat $yourfile|while read line
    do
        echo "Line $count:$line"
        let count++
    done
    exit 0
else
    echo "None"
    exit 0
fi;
exit 0
# 繁琐版本
echo "your name:"
read name
echo "name:$name"

# 精简版 -p 提示
read -p "your name:" name
echo "name:$name"

#如果不指定变量则放在环境变量REPLY中
read -p "you name:"
echo "name:$REPLY"

#密码 read -s (输入不显示在监视器上,实则改变背景色)
read -s -p "your pwd:"
```

