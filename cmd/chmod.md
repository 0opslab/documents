# title{chmod - 令是控制用户对文件的权限的命令}

mode : 权限设定字串，格式如下 :

[ugoa...][[+-=][rwxX]...][,...]
其中：

u 表示该文件的拥有者，g 表示与该文件的拥有者属于同一个群体(group)者，o 表示其他以外的人，a 表示这三者皆是。
+ 表示增加权限、- 表示取消权限、= 表示唯一设定权限。
r 表示可读取，w 表示可写入，x 表示可执行，X 表示只有当该文件是个子目录或者该文件已经被设定过为可执行。
其他参数说明：

-c : 若该文件权限确实已经更改，才显示其更改动作
-f : 若该文件权限无法被更改也不要显示错误讯息
-v : 显示权限变更的详细资料
-R : 对目前目录下的所有文件与子目录进行相同的权限变更(即以递归的方式逐个变更)
--help : 显示辅助说明
--version : 显示版本

```bash
# Add execute for all (myscript.sh)
#为所有添加执行（myscript.sh）
chmod a+x myscript.sh

# Set user to read/write/execute, group/global to read only (myscript.sh), symbolic mode
#将用户设置为读/写/执行，将组/全局设置为只读（myscript.sh），符号模式
chmod u=rwx, go=r myscript.sh 

# Remove write from user/group/global (myscript.sh), symbolic mode
#从用户/组/全局（myscript.sh），符号模式中删除写入
chmod a-w myscript.sh

# Remove read/write/execute from user/group/global (myscript.sh), symbolic mode
#从用户/组/全局（myscript.sh），符号模式中删除读/写/执行
chmod = myscript.sh

# Set user to read/write and group/global read (myscript.sh), octal notation
#将用户设置为读/写和组/全局读（myscript.sh），八进制表示法
chmod 644 myscript.sh

# Set user to read/write/execute and group/global read/execute (myscript.sh), octal notation
#将用户设置为读/写/执行和组/全局读/执行（myscript.sh），八进制表示法
chmod 755 myscript.sh

# Set user/group/global to read/write (myscript.sh), octal notation
#将user / group / global设置为read / write（myscript.sh），八进制表示法
chmod 666 myscript.sh

# Roles
#角色
u - user (owner of the file)
g - group (members of file's group)
o - global (all users who are not owner and not part of group)
a - all (all 3 roles above)

# Numeric representations
#数字表示
7 - full (rwx)
6 - read and write (rw-)
5 - read and execute (r-x)
4 - read only (r--)
3 - write and execute (-wx)
2 - write only (-w-)
1 - execute only (--x)
0 - none (---)
```