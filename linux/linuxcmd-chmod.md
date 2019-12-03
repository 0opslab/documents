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
