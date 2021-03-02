# title{ftp - ftp命令相关的那些操作}
#!/bin/bash
```bash
ftp [-dignv][主机名称或IP地址]
参数：
-d 详细显示指令执行过程，便于排错或分析程序执行的情形。
-i 关闭互动模式，不询问任何问题。
-g 关闭本地主机文件名称支持特殊字符的扩充特性。
-n 不使用自动登陆。
-v 显示指令执行过程。
```

### 常用命令
```bash
-dir：显示服务器目录和文件列表
-ls：显示服务器目录和文件列表
-cd：进入服务器指定的目录
-lcd：进入本地客户端指定的目录。
-dir  命令可以使用通配符“*”和“?”，比如，显示当前目录中所有扩展名为jpg的文件，可使用命令 dir  *.jpg。
-cd 命令中必须带目录名。比如 cd /tmp 表示进入/tmp目录
-type：查看当前的传输方式
-ascii：设定传输方式为ASCII码方式
-binary：设定传输方式为二进制方式
-get/recv：下载单个文件get filename [newname](filename为下载的ftp服务器上的文件名，newname为保存在本都计算机上时使用的名字，如果不指定newname，文件将以原名保存。
-get/recv命令下载的文件将保存在本地计算机的工作目录下。该目录是启动ftp客户端时的工作目录目录。如果想修改本地计算机的工作目录，可以使用 lcd 命令。比如：lcd /tmp 表示将工作目录设定/tmp/目录。
-mget：下载多个文件mget filename [filename ....]（mget命令支持通配符“*”和“?”，比如：mget  *.jpg 表示下载ftp服务器当前目录下的所有扩展名为jpg的文件。）
-prompt：关闭/打开互交提示。
-put/send：上传单个文件put filename [newname]
-filename为上传的本地文件名，newname为上传至ftp服务器上时使用的名字，如果不指定newname，文件将以原名上传。
-mput：上传多个文件mput filename [filename ....]
-mput命令支持通配符“*”和“?”，比如：mput  *.jpg 表示上传客户端服务器当前目录下的所有扩展名为jpg的文件。
-prompt：关闭/打开互交提示。
-pwd：查看ftp服务器上的当前工作目录
-rename filename newfilename：重命名ftp服务器上的文件
-delete filename：删除ftp服务器上一个文件。
-mdelete [remote-files] ：删除多个文件。
-mkdir pathname：在服务器上创建目录。
-rmdir pathname：删除服务器上的目录。
-passive：主动模式与被动模式切换。
-nlist：列出服务器目录中的文件名，如：nlist  /home/wucz  /tmp/tmp.list，表示把服务器上/home/wucz目录下的文件列出来，结果输出到本地的/tmp/tmplist文件中。
-help [cmd]：显示ftp命令的帮助信息，cmd是命令名，如果不带参数，则显示所有ftp命令。
-bye：结束与服务器的ftp会话并退出ftp环境
```
## 从linux服务器批量上传/home/test文件夹里面文件到FTP(192.168.1.122)里面wwwroot目录
```bash
updir=/home/test
todir=wwwroot
ip=192.168.1.122
user=test
password=test123123
sss=`find $updir -type d -printf $todir/'%P\n'| awk '{if ($0 == "")next;print "mkdir " $0}'`
aaa=`find $updir -type f -printf 'put %p %P \n'`
ftp -nv $ip <<EOF 
user $user $password
type binary 
prompt 
$sss 
cd $todir 
$aaa 
quit 
EOF
```


## 从linux服务器批量下载文件备份

```bash
date >> /tmp/ftp.log
today=`date +%Y-%m-%d_%H_%M_%S`
cd /data/backup/
mv 192.168.1.122  192.168.1.122_$today 
wget ftp://192.168.1.122:21/* --ftp-user=test --ftp-password=test123123 -r
date >> /tmp/ftp.log
```
