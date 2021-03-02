# title{user - linux下的用户管理}

linux 用户管理

	users                   # 显示所有的登录用户
	groups                  # 列出当前用户和他所属的组
	who -q                  # 显示所有的登录用户
	groupadd                # 添加组
	useradd user            # 建立用户
	passwd 用户             # 修改密码
	userdel -r              # 删除帐号及家目录
	chown -R user:group     # 修改目录拥有者(R递归)
	chown y\.li:mysql       # 修改所有者用户中包含点"."
	umask                   # 设置用户文件和目录的文件创建缺省屏蔽值
	chgrp                   # 修改用户组
	finger                  # 查找用户显示信息
	echo "xuesong" | passwd user --stdin       # 非交互修改密码
	useradd -g www -M  -s /sbin/nologin  www   # 指定组并不允许登录的用户,nologin允许使用服务
	useradd -g www -M  -s /bin/false  www      # 指定组并不允许登录的用户,false最为严格
	usermod -l 新用户名 老用户名               # 修改用户名
	usermod -g user group                      # 修改用户所属组
	usermod -d 目录 -m 用户                    # 修改用户家目录
	usermod -G group user                      # 将用户添加到附加组
	gpasswd -d user group                      # 从组中删除用户
	su - user -c " #命令1; "                   # 切换用户执行
	
	恢复密码{

		# 即进入单用户模式: 在linux出现grub后，在安装的系统上面按"e"，然后出现grub的配置文件，按键盘移动光标到第二行"Ker……"，再按"e"，然后在这一行的结尾加上：空格 single或者空格1回车，然后按"b"重启，就进入了"单用户模式"
	}
	
	特殊权限{

		s或 S （SUID）：对应数值4
		s或 S （SGID）：对应数值2
		t或 T ：对应数值1
		大S：代表拥有root权限，但是没有执行权限
		小s：拥有特权且拥有执行权限，这个文件可以访问系统任何root用户可以访问的资源
		T或T（Sticky）：/tmp和 /var/tmp目录供所有用户暂时存取文件，亦即每位用户皆拥有完整的权限进入该目录，去浏览、删除和移动文件

	}


  
```bash

#!/bin/bash
#
read -p "Enter a user name: " userName

while ! id $userName &> /dev/null; do
    read -p "Enter a user name again: " userName
done

who | grep "^$userName" &> /dev/null
retVal=$?

while [ $retVal -ne 0 ]; do
	sleep 5
	who | grep "^$userName" &> /dev/null
	retVal=$?	
done

echo "$userName is on."


cat userlist.log
username  password
test      123123
aaa       123123

########批量添加用户
for name in $(cat userlist.log | awk -F ' ' '{print $1}')
do
if [ -n $name ]
then
    useradd -m $name
    echo $(cat userlist.log  |grep $name | awk -F ' ' '{print $2}') | passwd --stdin $name
else
    echo "user is null"
fi
done

########批量删除用户
for name in $(cat userlist.log | awk -F ' ' '{print $1}')
do
if [ -n $name ]
then
    userdel $name
else
    echo "user is null"
fi
done


UserName="user4"
useradd $UserName
echo $UserName | passwd --stdin $UserName > /dev/null
echo "Add $UserName successfully."

useradd user2
echo user2 | passwd --stdin user2 > /dev/null
echo "Add user2 successfully."

useradd user3
echo user3 | passwd --stdin user3 > /dev/null



#
UserName=`dialog --stdout --backtitle "Add a user." --title "UserName" --inputbox "Please input a username: " 10 25`
RETVAL=$?
clear
if [ $RETVAL -eq 0 -a -n "$UserName" ] ; then
  if ! id $UserName &> /dev/null; then
    useradd $UserName
    Pass=`dialog --colors --ok-label "Submit" --no-shadow --nocancel --stdout --backtitle "Password for $UserName" --title "Password"  --insecure --passwordbox "Please enter the password for \Z1$UserName\Zn: " 10 30`
    echo $Pass | passwd --stdin $UserName &> /dev/null
    dialog --clear --backtitle "Add a user." --title "Add a user." --msgbox "Add user $UserName finished." 10 30
  else
    echo "$UserName is already there."
  fi
fi


# 批量添加用户
for I in {1..10}; do
  useradd user$I;
  echo user$I | passwd --stdin user$I
done


while read line; do
	[[ `echo $line | cut -d: -f7` == "/bin/bash" ]] && echo $line | cut -d: -f1
done < /etc/passwd
```