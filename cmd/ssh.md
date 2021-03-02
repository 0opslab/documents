# title{ssh - ssh相关的那些操作}

以常用的centos系统为例，系统默认是安装了openssh的服务端和客户端。如果没有安装可以yum或者apt-get大法安装。安装很简单，
但是想要使用好还是需要点时间的。下面是一些相关的配置文件和日志文件说明

```
# 服务器配置文件
/etc/ssh/sshd_config

# 客户端配置
/etc/ssh/ssh_config

# 客户端用户配置
$home/.ssh/config

## 主机密钥相关的文件
/etc/ssh/ssh_host_key:主机RSA认证私钥（SSH-1）
/etc/ssh/ssh_host_key.pub :主机RSA认证公钥(SSH-1)
/etc/ssh/ssh_host_dsa_key:主机DSA认证私钥（SSH-2）
/etc/ssh/ssh_host_dsa_key.pub:主机DSA认证公钥SSH2
/etc/ssh/ssh_host_rsa_key:主机RSA认证私钥（SSH-2）
/etc/ssh/ssh_host_rsa_key.pub:主机RSA认证公钥(SSH-2)
/etc/ssh/ssh_known_host:已知的主机密钥的系统级列表

```




### 解决ssh链接慢
sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/' /etc/ssh/sshd_config
sed -i '/#UseDNS yes/a\UseDNS no' /etc/ssh/sshd_config
/etc/init.d/sshd restart


### 客户端命令SSH

客户端SSH命令可以用来连接SSH服务端，并且载远程主机上执行命令。下面是客户端SSH命令的帮助信息

```bash
usage: ssh [-1246AaCfgKkMNnqsTtVvXxYy] [-b bind_address] [-c cipher_spec]
           [-D [bind_address:]port] [-E log_file] [-e escape_char]
           [-F configfile] [-I pkcs11] [-i identity_file]
           [-L [bind_address:]port:host:hostport] [-l login_name] [-m mac_spec]
           [-O ctl_cmd] [-o option] [-p port]
           [-Q cipher | cipher-auth | mac | kex | key]
           [-R [bind_address:]port:host:hostport] [-S ctl_path] [-W host:port]
           [-w local_tun[:remote_tun]] [user@]hostname [command]
 -a
    禁止转发认证代理的连接.
-A
    允许转发认证代理的连接. 可以在配置文件中对每个主机单独设定这个参数.
    代理转发须谨慎. 某些用户能够在远程主机上绕过文件访问权限 (由于代理的 UNIX 域 socket), 他们可以通过转发的连接访问
    本地代理. 攻击者不可能从代理获得密钥内容, 但是他们能够操作这些密钥, 利用加载到代理上 的身份信息通过认证.
-b bind_address
    在拥有多个接口或地址别名的机器上, 指定收发接口.
-c blowfish|3des|des
    选择加密会话的密码术. 3des 是默认算法. 3des (triple-des) 用三支不同的密钥做加密-解密-加密三次运算, 被认为比较可靠.
    blowfish 是一种快速的分组加密术(block cipher), 非常安全, 而且速度比 3des 快的多. des 仅支持 客户端, 目的是能够和
    老式的不支持 3des 的协议第一版互操作. 由于其密码算法上的弱点, 强烈建议避免使用.
    
-c cipher_spec
    另外, 对于协议第二版, 这里可以指定一组用逗号隔开, 按优先顺序排列的密码术. 详见 Ciphers
    
-e ch|^ch|none
    设置 pty 会话的 escape 字符 (默认字符: `~' ) . escape 字符只在行首有效, escape 字符后面跟一个点 (`.' ) 表示结束
    连接, 跟一个 control-Z 表示挂起连接(suspend), 跟 escape 字符自己 表示输出这个字符. 把这个字符设为 ``none 则禁止
    escape 功能, 使会话完全透明.

-f 要求 在执行命令前退至后台. 它用于当 准备询问口令或密语, 但是用户希望它在后台进行. 该选项隐含了 -n 选项. 在远端机器
    上启动 X11 程序的推荐手法就是类似于 ssh -f host xterm 的命令.
    
-g 允许远端主机连接本地转发的端口.
    
-i identity_file 指定一个 RSA 或 DSA 认证所需的身份(私钥)文件. 默认文件是协议第一版的 $HOME/.ssh/identity 以及协议第二版的 
    $HOME/.ssh/id_rsa 和 $HOME/.ssh/id_dsa 文件. 也可以在配置文件中对每个主机单独指定身份文件. 可以同时使用多个
     -i 选项 (也可以在配置文件中指定多个身份文件).
    
-I smartcard_device 指定智能卡(smartcard)设备. 参数是设备文件, 能够用它和智能卡通信, 智能卡里面存储了用户的 RSA 私钥.
    
-k 禁止转发 Kerberos 门票和 AFS 令牌. 可以在配置文件中对每个主机单独设定这个参数.
    
-l login_name 指定登录远程主机的用户. 可以在配置文件中对每个主机单独设定这个参数.
    
-m mac_spec 另外, 对于协议第二版, 这里可以指定一组用逗号隔开, 按优先顺序排列的 MAC(消息验证码)算法 (message authentication code).
    详情以 MACs 为关键字查询.
    
-n 把 stdin 重定向到 /dev/null (实际上防止从 stdin 读取数据). 在后台运行时一定会用到这个选项. 它的常用技巧是远程运行
     X11 程序. 例如, ssh -n shadows.cs.hut.fi emacs 将会在 shadows.cs.hut.fi 上启动 emacs, 同时自动在加密通道中转发
      X11 连接. 在后台运行. (但是如果 要求口令或密语, 这种方式就无法工作; 参见 -f 选项.)
    
-N 不执行远程命令. 用于转发端口. (仅限协议第二版)
    
-o option 可以在这里给出某些选项, 格式和配置文件中的格式一样. 它用来设置那些没有命令行开关的选项.
    
-p port 指定远程主机的端口. 可以在配置文件中对每个主机单独设定这个参数.
    
-q 安静模式. 消除所有的警告和诊断信息.
    
-s 请求远程系统激活一个子系统. 子系统是 SSH2 协议的一个特性, 能够协助 其他应用程序(如 sftp)把SSH用做安全通路.
    子系统通过远程命令指定.
    
-t 强制分配伪终端. 可以在远程机器上执行任何全屏幕(screen-based)程序, 所以非常有用, 例如菜单服务. 并联的 -t
    选项强制分配终端, 即使 没有本地终端.
    
-T 禁止分配伪终端.
    
-v 冗详模式. 使 打印关于运行情况的调试信息. 在调试连接, 认证和配置问题时非常有用. 并联的 -v 选项能够增加冗详程度.
    最多为三个.
    
-x 禁止 X11 转发.
-X
    允许 X11 转发. 可以在配置文件中对每个主机单独设定这个参数.
    应该谨慎使用 X11 转发. 如果用户在远程主机上能够绕过文件访问权限 (根据用户的X授权数据库), 他就可以通过转发的连接
    访问本地 X11 显示器. 攻击者可以据此采取行动, 如监视键盘输入等.
    
-C
    要求进行数据压缩 (包括 stdin, stdout, stderr 以及转发 X11 和 TCP/IP 连接 的数据). 压缩算法和 gzip(1) 的一样, 
    协议第一版中, 压缩级别 ``level 用 CompressionLevel 选项控制. 压缩技术在 modem 线路或其他慢速连接上很有用, 但是
    在高速网络上反而 可能降低速度. 可以在配置文件中对每个主机单独设定这个参数. 另见 Compression 选项.
    
-F configfile
    指定一个用户级配置文件. 如果在命令行上指定了配置文件, 系统级配置文件 (/etc/ssh/ssh_config ) 将被忽略. 默认的用
    户级配置文件是 $HOME/.ssh/config
    
-L port:host:hostport
    将本地机(客户机)的某个端口转发到远端指定机器的指定端口. 工作原理是这样的, 本地机器上分配了一个 socket 侦听 port
     端口, 一旦这个端口上有了连接, 该连接就经过安全通道转发出去, 同时远程主机和 host 的 hostport 端口建立连接. 可以
     在配置文件中指定端口的转发. 只有 root 才能转发特权端口. IPv6 地址用另一种格式说明: port/host/hostport
    
-R port:host:hostport
    将远程主机(服务器)的某个端口转发到本地端指定机器的指定端口. 工作原理是这样的, 远程主机上分配了一个 socket 侦听 
    port 端口, 一旦这个端口上有了连接, 该连接就经过安全通道转向出去, 同时本地主机和 host 的 hostport 端口建立连接.
     可以在配置文件中指定端口的转发. 只有用 root 登录远程主机 才能转发特权端口. IPv6 地址用另一种格式说明: port/host/hostport
    
-D port
    指定一个本地机器 ``动态的 应用程序端口转发. 工作原理是这样的, 本地机器上分配了一个 socket 侦听 port 端口, 
    一旦这个端口上有了连接, 该连接就经过安全通道转发出去, 根据应用程序的协议可以判断出远程主机将和哪里连接. 
    目前支持 SOCKS4 协议, 将充当 SOCKS4 服务器. 只有 root 才能转发特权端口. 可以在配置文件中指定动态端口的转发.
    
-1 强制 只使用协议第一版.
-2 强制 只使用协议第二版.
-4 强制 只使用 IPv4 地址.
-6 强制 只使用 IPv6 地址.          
```

## 常用实例

```bash
#当前用户登录远程主机
ssh 192.168.1.108

#以tank用户登录远程主机
ssh 192.168.1.108 -l tank

#指定端口登录
ssh tank@192.168.1.108 -p 2222

#通过代理登录 
ssh  -D 7575 tank@192.168.1.108 

# 对所有数据请求压缩
ssh -C 192.168.0.103

# 绑定源地址
ssh -b 192.168.0.200 -l leni 192.168.0.103

# 直接连接到只能通过主机B连接的主机A
ssh -t hostA ssh hostB

# To ssh via pem file (which normally needs 0600 permissions):
#要通过pem文件ssh（通常需要0600权限）：
ssh -i /path/to/file.pem user@example.com

# To connect on an non-standard port:
#要在非标准端口上连接：
ssh -p 2222 user@example.com

# To connect and forward the authentication agent
#连接和转发身份验证代理
ssh -A user@example.com

# To execute a command on a remote server:
#要在远程服务器上执行命令：
ssh -t user@example.com 'the-remote-command'

# To tunnel an x session over SSH:
#通过SSH隧道传输x会话：
ssh -X user@example.com

# Redirect traffic with a tunnel between local host (port 8080) and a remote
#使用本地主机（端口8080）和远程控制器之间的隧道重定向流量
# host (remote.example.com:5000) through a proxy (personal.server.com):
#主机（remote.example.com:5000）通过代理（personal.server.com）：
ssh -f -L 8080:remote.example.com:5000 user@personal.server.com -N

# To launch a specific x application over SSH:
#要通过SSH启动特定的x应用程序：
ssh -X -t user@example.com 'chromium-browser'

# To create a SOCKS proxy on localhost and port 9999
#在localhost和端口9999上创建SOCKS代理
ssh -D 9999 user@example.com

# To tunnel an ssh session over the SOCKS proxy on localhost and port 9999
#在localhost和端口9999上通过SOCKS代理隧道ssh会话
ssh -o "ProxyCommand nc -x 127.0.0.1:9999 -X 4 %h %p" username@example2.com

# -X use an xsession, -C compress data, "-c blowfish" use the encryption blowfish
#-X使用xsession，-C压缩数据，“-c blowfish”使用加密河豚
ssh user@example.com -C -c blowfish -X

# For more information, see:
#有关更多信息，请参阅：
# http://unix.stackexchange.com/q/12755/44856
#HTTP://Unix.stack Exchange.com/请/12755/44856

# Copy files and folders through ssh from remote host to pwd with tar.gz compression
#使用tar.gz压缩将文件和文件夹通过ssh从远程主机复制到pwd
# when there is no rsync command available
#当没有可用的rsync命令时
ssh user@example.com "cd /var/www/Shared/; tar zcf - asset1 asset2" | tar zxf -

# Mount folder/filesystem through SSH
#通过SSH挂载文件夹/文件系统
# Install SSHFS from https://github.com/libfuse/sshfs
#从https://github.com/libfuse/sshfs安装SSHFS
# Will allow you to mount a folder securely over a network.
#允许您通过网络安全地挂载文件夹。
sshfs name@server:/path/to/folder /path/to/mount/point

# Emacs can read file through SSH
#Emacs可以通过SSH读取文件
# Doc: http://www.gnu.org/software/emacs/manual/html_node/emacs/Remote-Files.html
#Doc：http：//www.gnu.org/software/emacs/manual/html_node/emacs/Remote-Files.html
emacs /ssh:name@server:/path/to/file


# To generate an SSH key:
#要生成SSH密钥：
ssh-keygen -t rsa

# To generate a 4096-bit SSH key:
#要生成4096位SSH密钥：
ssh-keygen -t rsa -b 4096

# To update a passphrase on a key
#更新密钥的密码
ssh-keygen -p -P old_passphrase -N new_passphrase -f /path/to/keyfile

# To remove a passphrase on a key
#删除密钥上的密码
ssh-keygen -p -P old_passphrase -N '' -f /path/to/keyfile

# To generate a 4096 bit RSA key with a passphase and comment containing the user and hostname
#生成带有passphase的4096位RSA密钥和包含用户和主机名的注释
ssh-keygen -t rsa -b 4096 -C "$USER@$HOSTNAME" -P passphrase

# To copy a key to a remote host:
#要将密钥复制到远程主机：
ssh-copy-id username@host

# To copy a key to a remote host on a non-standard port:
#要将密钥复制到非标准端口上的远程主机：
ssh-copy-id username@host -p 2222

# To copy a key to a remote host on a non-standard port with non-standard ssh key:
#要使用非标准ssh密钥将密钥复制到非标准端口上的远程主机：
ssh-copy-id ~/.ssh/otherkey "username@host -p 2222"

ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa -q -b 2048 -C "test@ppabc.cn"

#查看生产的密匙
cat ~/.ssh/id_dsa

##用ssh -v 显示详细的登陆信息查找原因：
ssh -v localhost

# 从linux ssh登录另一台linux 
ssh -p 22 user@192.168.1.209                            
# 利用ssh操作远程主机
ssh -p 22 root@192.168.1.209 CMD                        
# 把本地文件拷贝到远程主机
scp -P 22 文件 root@ip:/目录                            
# 指定密码远程操作
sshpass -p '密码' ssh -n root@$IP "echo hello"          
# ssh连接不提示yes
ssh -o StrictHostKeyChecking=no $IP                     
# 指定伪终端 客户端以交互模式工作
ssh -t "su -"                                           
# 把远程指定文件拷贝到本地
scp root@192.168.1.209:远程目录 本地目录                 
# 用SSH创建端口转发通道
ssh -N -L2001:remotehost:80 user@somemachine            
# 嵌套使用SSH
ssh -t host_A ssh host_B                                
# 远程su执行命令 Cmd="\"/sbin/ifconfig eth0\""
ssh -t -p 22 $user@$Ip /bin/su - root -c {$Cmd};        
# 生成密钥
ssh-keygen -t rsa                                       
# 传送key
ssh-copy-id -i xuesong@10.10.10.133                     
# 公钥存放位置
vi $HOME/.ssh/authorized_keys                           
# 通过ssh挂载远程主机上的文件夹
sshfs name@server:/path/to/folder /path/to/mount/point  
# 卸载ssh挂载的目录
fusermount -u /path/to/mount/point                      
ssh user@host cat /path/to/remotefile | diff /path/to/localfile -                # 用DIFF对比远程文件跟本地文件
su - user -c "ssh user@192.168.1.1 \"echo -e aa |mail -s test mail@163.com\""    # 切换用户登录远程发送邮件

```





#### ssh无密码认证 RSA
```bash
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

#ssh无密码认证 DSA
ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys



#拷贝本地生产的key到远程服务器端（两种方法）
#1
cat ~/.ssh/id_dsa.pub | ssh 远程用户名@远程服务器ip 'cat - >> ~/.ssh/authorized_keys'
scp ~/.ssh/id_dsa.pub username@远程机器IP:/userhome/.ssh/authorized_keys
ssh-copy-id  -i /root/.ssh/id_dsa.pub root@192.168.142.136

#2
scp ~/.ssh/id_dsa.pub test@10.0.0.13:/home/test/
##登陆远程服务器test@10.0.0.13 后执行：
cat /home/test/id_dsa.pub >>  ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

#### ssh密钥分发脚本
```bash
#!/bin/sh
read -p "输入远端服务器IP: " ip
##ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub root@$ip
ssh-copy-id -i ~/.ssh/id_rsa.pub root@$ip
ssh root@$ip 'sed -i "s/^#RSAAuthentication\ yes/RSAAuthentication\ yes/g" /etc/ssh/sshd_config'
ssh root@$ip 'sed -i "s/^#PubkeyAuthentication\ yes/PubkeyAuthentication yes/g" /etc/ssh/sshd_config'
ssh root@$ip 'sed -i "s/^#PermitRootLogin\ yes/PermitRootLogin\ yes/g" /etc/ssh/sshd_config'
ssh root@$ip 'service sshd restart'
hostname=`ssh root@${ip} 'hostname'`
echo "添加主机名和IP到本地/etc/hosts文件中"
echo "$ip    $hostname" >> /etc/hosts
echo "远端主机主机名称为$hostname, 请查看 /etc/hosts 确保该主机名和IP添加到主机列表文件中"
```

















