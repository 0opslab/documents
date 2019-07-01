SSH(Secure Shell安全的Shell)是一种C/S协议模式，即区分服务端和客户端。OpenSSH是免费的SSH协议的开源实现，也是绝大多数系统的选择。OpenSSH默认采用RSA密钥。

### OpenSSH

以常用的centos系统为例，系统默认是安装了openssh的服务端和客户端。如果没有安装可以yum或者apt-get大法安装。安装很简单，但是想要使用好还是需要点时间的。

下面是一些相关的配置文件和日志文件说明

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

## 客户端密钥(用户相关 根据版本差异可能还存在其他的文件)
[opslab@VM_0_14_centos ~]$ ls -al ~/.ssh/
total 20
drwx------  2 opslab opslab 4096 Mar  1  2018 .
drwx------ 11 opslab opslab 4096 Feb 27 10:58 ..
-rw-------  1 opslab opslab  402 Mar  1  2018 authorized_keys #用于存放所有已知用户的公钥
-rw-------  1 opslab opslab 1679 Mar  1  2018 id_rsa
-rw-r--r--  1 opslab opslab  403 Mar  1  2018 id_rsa.pub
```

#### 服务端配置文件

openssh的服务端的配置文件为/etc/ssh/sshd_conffig。和其他的配置文件一样文件的每有一行包含关键词值的匹配。其中关键字是忽略大小写的。下面是一下常用的关键配置项

```bash
#Port 22      //监听端口，默认监听22端口   【默认可修改】
#AddressFamily any  //IPV4和IPV6协议家族用哪个，any表示二者均有
#ListenAddress 0.0.0.0   //指明监控的地址，0.0.0.0表示本机的所有地址  【默认可修改】
#ListenAddress ::        //指明监听的IPV6的所有地址格式
#Protocol 2              //使用SSH第二版本，centos7默认第一版本已拒绝
# HostKey for protocol version 1  //一版的SSH支持以下一种秘钥形式
#HostKey /etc/ssh/ssh_host_key
# HostKeys for protocol version 2 //使用第二版本发送秘钥，支持以下四种秘钥认证的存放位置：（centos6只支持rsa和dsa两种）
HostKey /etc/ssh/ssh_host_rsa_key   //rsa私钥认证 【默认】
#HostKey /etc/ssh/ssh_host_dsa_key  //dsa私钥认证
HostKey /etc/ssh/ssh_host_ecdsa_key //ecdsa私钥认证
HostKey /etc/ssh/ssh_host_ed25519_key //ed25519私钥认证
# Lifetime and size of ephemeral version 1 server key
#KeyRegenerationInterval 1h
#ServerKeyBits 1024        主机秘钥长度        
# Ciphers and keying      
#RekeyLimit default none
# Logging
# obsoletes QuietMode and FascistLogging
#SyslogFacility AUTH
SyslogFacility AUTHPRIV   //当有人使用ssh登录系统的时候，SSH会记录信息，信息保存在/var/log/secure里面
#LogLevel INFO       //日志的等级
# Authentication:
#LoginGraceTime 2m       //登录的宽限时间，默认2分钟没有输入密码，则自动断开连接
#PermitRootLogin no
PermitRootLogin yes      //是否允许管理员直接登录，'yes'表示允许 是否禁止root
#StrictModes yes         //是否让sshd去检查用户主目录或相关文件的权限数据
#MaxAuthTries 6          //最大认证尝试次数，最多可以尝试6次输入密码。之后需要等待某段时间后才能再次输入密码
#MaxSessions 10          //允许的最大会话数
#RSAAuthentication yes   //是否密钥认证
#PubkeyAuthentication yes
# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
//服务器生成一对公私钥之后，会将公钥放到.ssh/authorizd_keys里面，将私钥发给客户端
AuthorizedKeysFile .ssh/authorized_keys 

#AuthorizedPrincipalsFile none 
#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody
# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#RhostsRSAAuthentication no
# similar for protocol version 2
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# RhostsRSAAuthentication and HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes
# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no
PasswordAuthentication yes         //是否允许支持基于口令的认证
# Change to no to disable s/key passwords
#ChallengeResponseAuthentication yes
ChallengeResponseAuthentication no //是否允许任何的密码认证
# Kerberos options            //是否支持kerberos（基于第三方的认证，如LDAP）认证的方式，默认为no 
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes
# GSSAPI options                                       
GSSAPIAuthentication yes
GSSAPICleanupCredentials no
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no
#GSSAPIEnablek5users no
# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication. Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
# WARNING: 'UsePAM no' is not supported in Red Hat Enterprise Linux and may cause several
# problems.
UsePAM yes
#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
//是否允许x11转发，可以让窗口的数据通过SSH连接来传递(请查看ssh -X 参数)：#ssh -X  user@IP
X11Forwarding yes 
#X11DisplayOffset 10
#X11UseLocalhost yes 
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#UseLogin no
UsePrivilegeSeparation sandbox # Default for new installations.
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#ShowPatchLevel no
#UseDNS yes     //是否反解DNS，如果想让客户端连接服务器端快一些，这个可以改为no      
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none
# no default banner path
#Banner none
# Accept locale-related environment variables
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS
# override default of no subsystems
//支持 SFTP ，如果注释掉，则不支持sftp连接
Subsystem sftp /usr/libexec/openssh/sftp-server                    
# Example of overriding settings on a per-user basis
#Match User anoncvs
# X11Forwarding no
# AllowTcpForwarding no
# PermitTTY no
# ForceCommand cvs server
//登录白名单（默认没有这个配置，需要自己手动添加），允许远程登录的用户。如果名单中没有的用户，则提示拒绝登录
AllowUsers user1 user2                
```

#### 客户端配置

通过/etc/ssh/ssh_config配置文件，可以设置不同选项来改变客户端运行的方式。

```bash
# Site-wide defaults for various options
带“#”表示该句为注释不起作，该句不属于配置文件原文，意在说明下面选项均为系统初始默认的选项。说明一下，实际配置文件中也有很多选项前面加有“#”注释，虽然表示不起作用，其实是说明此为系统默认的初始化设置。
Host *
"Host"只对匹配后面字串的计算机有效，“*”表示所有的计算机。从该项格式前置一些可以看出，这是一个类似于全局的选项，表示下面缩进的选项都适用于该设置，可以指定某计算机替换*号使下面选项只针对该算机器生效。
ForwardAgent no
"ForwardAgent"设置连接是否经过验证代理（如果存在）转发给远程计算机。
ForwardX11 no
"ForwardX11"设置X11连接是否被自动重定向到安全的通道和显示集（DISPLAY set）。
RhostsAuthentication no
"RhostsAuthentication"设置是否使用基于rhosts的安全验证。
RhostsRSAAuthentication no
"RhostsRSAAuthentication"设置是否使用用RSA算法的基于rhosts的安全验证。
RSAAuthentication yes
"RSAAuthentication"设置是否使用RSA算法进行安全验证。
PasswordAuthentication yes
"PasswordAuthentication"设置是否使用口令验证。
FallBackToRsh no
"FallBackToRsh"设置如果用ssh连接出现错误是否自动使用rsh，由于rsh并不安全，所以此选项应当设置为"no"。
UseRsh no
"UseRsh"设置是否在这台计算机上使用"rlogin/rsh"，原因同上，设为"no"。
BatchMode no
"BatchMode"：批处理模式，一般设为"no"；如果设为"yes"，交互式输入口令的提示将被禁止，这个选项对脚本文件和批处理任务十分有用。
CheckHostIP yes
"CheckHostIP"设置ssh是否查看连接到服务器的主机的IP地址以防止DNS欺骗。建议设置为"yes"。
StrictHostKeyChecking no
"StrictHostKeyChecking"如果设为"yes"，ssh将不会自动把计算机的密匙加入"$HOME/.ssh/known_hosts"文件，且一旦计算机的密匙发生了变化，就拒绝连接。
IdentityFile ~/.ssh/identity
"IdentityFile"设置读取用户的RSA安全验证标识。
Port 22
"Port"设置连接到远程主机的端口，ssh默认端口为22。
Cipher blowfish
“Cipher”设置加密用的密钥，blowfish可以自己随意设置。
EscapeChar ~
“EscapeChar”设置escape字符。
```

### 实现服务器禁止密码登录使用RSA免密登录

在服务器端中，配置禁止密码登录，必须使用秘钥key登录。首先配置SSH服务器经用密码登录。

```bash
# vi /etc/ssh/sshd_config

// 禁止密码验证
PasswordAuthentication no

// 启用秘钥登录
RSAAuthentication yes
PubkeyAuthentication yes

// 禁止root登陆
PermitRootLogin no
// 重启服务 - 等下顺客户端配置完成后再重启
// RHEL/Centos
# service sshd restart
# systemctl restart sshd.service

// Ubuntu 系统
# service ssh restart

// debian
# /etc/init.d/ssh restart
```

在想要使之免密登录的用户下执行如下命令，例如webapp用户

```bash
$ ssh-keygen -t rsa # 按3下回车
$ ls .ssh/
ls -la .ssh/
总用量 20
drwx------ 2 opslab opslab 4096 3月   1 20:58 .
drwx------ 8 opslab opslab 4096 3月   1 21:10 ..
-rw------- 1 opslab opslab  402 3月   1 20:59 authorized_keys
-rw------- 1 opslab opslab 1679 3月   1 20:56 id_rsa
-rw-r--r-- 1 opslab opslab  403 3月   1 20:56 id_rsa.pub

// 必须修改权限
$ chmod 700 .ssh/
$ chmod 600 .ssh/authorized_keys
```

之后再客户端主机上执行如下命令,如果有多台主机，分布在每台主机上执行如下命令即可。

```bash
$ ssh-keygen -t rsa # 按3下回车

// 将本地公钥复制到远程服务器上
$ ssh-copy-id -i .ssh/id_rsa.pub  webapp@192.168.30.22

// 免密登录测试
$ ssh webapp@192.168.30.22
```

### OpenSSH的日志

当有人使用ssh登录系统的时候，SSH会记录信息，信息保存在/var/log/secure里面。查阅该日志文件能掌握SSH的运行情况以及用户登录的情况等。

```bash
 tail -f /var/log/secure 
Jun  3 20:58:57 localhost sshd[13977]: Received disconnect from 111.230.154.177: 11:
Jun  3 20:58:57 localhost sshd[13975]: pam_unix(sshd:session): session closed for user xx
Jun  3 20:58:57 localhost su: pam_unix(su-l:session): session closed for user root
Jun  3 21:06:59 localhost sshd[16178]: Accepted password for xxx from 111.230.154.177 port 43520 ssh2
```

例如通知如下脚本可以查看登陆失败的IP和次数

```bash
# cat /var/log/secure | awk '/Failed/{print $(NF-3)}' | sort | uniq -c | awk '{print $2" = "$1;}'
101.254.230.36 = 2865
106.75.218.173 = 229
110.167.88.130 = 1
110.167.89.9 = 3
110.167.90.230 = 3
110.167.91.202 = 2
110.167.91.74 = 3
110.167.92.223 = 1
```

如上可以将数量大的ip地址加入服务器拒绝列表中

```bash
# echo "sshd:$IP:deny" >> /etc/hosts.deny
cat /etc/hosts.deny
sshd:101.254.230.36:deny
sshd:106.75.218.173:deny

```

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
    代理转发须谨慎. 某些用户能够在远程主机上绕过文件访问权限 (由于代理的 UNIX 域 socket), 他们可以通过转发的连接访问本地代理. 攻击者不可能从代理获得密钥内容, 但是他们能够操作这些密钥, 利用加载到代理上 的身份信息通过认证.
    
-b bind_address
    在拥有多个接口或地址别名的机器上, 指定收发接口.
    
-c blowfish|3des|des
    选择加密会话的密码术. 3des 是默认算法. 3des (triple-des) 用三支不同的密钥做加密-解密-加密三次运算, 被认为比较可靠. blowfish 是一种快速的分组加密术(block cipher), 非常安全, 而且速度比 3des 快的多. des 仅支持 客户端, 目的是能够和老式的不支持 3des 的协议第一版互操作. 由于其密码算法上的弱点, 强烈建议避免使用.
    
-c cipher_spec
    另外, 对于协议第二版, 这里可以指定一组用逗号隔开, 按优先顺序排列的密码术. 详见 Ciphers
    
-e ch|^ch|none
    设置 pty 会话的 escape 字符 (默认字符: `~' ) . escape 字符只在行首有效, escape 字符后面跟一个点 (`.' ) 表示结束连接, 跟一个 control-Z 表示挂起连接(suspend), 跟 escape 字符自己 表示输出这个字符. 把这个字符设为 ``none 则禁止 escape 功能, 使会话完全透明.

-f
    要求 在执行命令前退至后台. 它用于当 准备询问口令或密语, 但是用户希望它在后台进行. 该选项隐含了 -n 选项. 在远端机器上启动 X11 程序的推荐手法就是类似于 ssh -f host xterm 的命令.
    
-g
    允许远端主机连接本地转发的端口.
    
-i identity_file
    指定一个 RSA 或 DSA 认证所需的身份(私钥)文件. 默认文件是协议第一版的 $HOME/.ssh/identity 以及协议第二版的 $HOME/.ssh/id_rsa 和 $HOME/.ssh/id_dsa 文件. 也可以在配置文件中对每个主机单独指定身份文件. 可以同时使用多个 -i 选项 (也可以在配置文件中指定多个身份文件).
    
-I smartcard_device
    指定智能卡(smartcard)设备. 参数是设备文件, 能够用它和智能卡通信, 智能卡里面存储了用户的 RSA 私钥.
    
-k
    禁止转发 Kerberos 门票和 AFS 令牌. 可以在配置文件中对每个主机单独设定这个参数.
    
-l login_name
    指定登录远程主机的用户. 可以在配置文件中对每个主机单独设定这个参数.
    
-m mac_spec
    另外, 对于协议第二版, 这里可以指定一组用逗号隔开, 按优先顺序排列的 MAC(消息验证码)算法 (message authentication code). 详情以 MACs 为关键字查询.
    
-n
    把 stdin 重定向到 /dev/null (实际上防止从 stdin 读取数据). 在后台运行时一定会用到这个选项. 它的常用技巧是远程运行 X11 程序. 例如, ssh -n shadows.cs.hut.fi emacs 将会在 shadows.cs.hut.fi 上启动 emacs, 同时自动在加密通道中转发 X11 连接. 在后台运行. (但是如果 要求口令或密语, 这种方式就无法工作; 参见 -f 选项.)
    
-N
    不执行远程命令. 用于转发端口. (仅限协议第二版)
    
-o option
    可以在这里给出某些选项, 格式和配置文件中的格式一样. 它用来设置那些没有命令行开关的选项.
    
-p port
    指定远程主机的端口. 可以在配置文件中对每个主机单独设定这个参数.
    
-q
    安静模式. 消除所有的警告和诊断信息.
    
-s
    请求远程系统激活一个子系统. 子系统是 SSH2 协议的一个特性, 能够协助 其他应用程序(如 sftp)把SSH用做安全通路. 子系统通过远程命令指定.
    
-t
    强制分配伪终端. 可以在远程机器上执行任何全屏幕(screen-based)程序, 所以非常有用, 例如菜单服务. 并联的 -t 选项强制分配终端, 即使 没有本地终端.
    
-T
    禁止分配伪终端.
    
-v
    冗详模式. 使 打印关于运行情况的调试信息. 在调试连接, 认证和配置问题时非常有用. 并联的 -v 选项能够增加冗详程度. 最多为三个.
    
-x
    禁止 X11 转发.
    
-X
    允许 X11 转发. 可以在配置文件中对每个主机单独设定这个参数.
    应该谨慎使用 X11 转发. 如果用户在远程主机上能够绕过文件访问权限 (根据用户的X授权数据库), 他就可以通过转发的连接访问本地 X11 显示器. 攻击者可以据此采取行动, 如监视键盘输入等.
    
-C
    要求进行数据压缩 (包括 stdin, stdout, stderr 以及转发 X11 和 TCP/IP 连接 的数据). 压缩算法和 gzip(1) 的一样, 协议第一版中, 压缩级别 ``level 用 CompressionLevel 选项控制. 压缩技术在 modem 线路或其他慢速连接上很有用, 但是在高速网络上反而 可能降低速度. 可以在配置文件中对每个主机单独设定这个参数. 另见 Compression 选项.
    
-F configfile
    指定一个用户级配置文件. 如果在命令行上指定了配置文件, 系统级配置文件 (/etc/ssh/ssh_config ) 将被忽略. 默认的用户级配置文件是 $HOME/.ssh/config
    
-L port:host:hostport
    将本地机(客户机)的某个端口转发到远端指定机器的指定端口. 工作原理是这样的, 本地机器上分配了一个 socket 侦听 port 端口, 一旦这个端口上有了连接, 该连接就经过安全通道转发出去, 同时远程主机和 host 的 hostport 端口建立连接. 可以在配置文件中指定端口的转发. 只有 root 才能转发特权端口. IPv6 地址用另一种格式说明: port/host/hostport
    
-R port:host:hostport
    将远程主机(服务器)的某个端口转发到本地端指定机器的指定端口. 工作原理是这样的, 远程主机上分配了一个 socket 侦听 port 端口, 一旦这个端口上有了连接, 该连接就经过安全通道转向出去, 同时本地主机和 host 的 hostport 端口建立连接. 可以在配置文件中指定端口的转发. 只有用 root 登录远程主机 才能转发特权端口. IPv6 地址用另一种格式说明: port/host/hostport
    
-D port
    指定一个本地机器 ``动态的 应用程序端口转发. 工作原理是这样的, 本地机器上分配了一个 socket 侦听 port 端口, 一旦这个端口上有了连接, 该连接就经过安全通道转发出去, 根据应用程序的协议可以判断出远程主机将和哪里连接. 目前支持 SOCKS4 协议, 将充当 SOCKS4 服务器. 只有 root 才能转发特权端口. 可以在配置文件中指定动态端口的转发.
    
-1
    强制 只使用协议第一版.
    
-2
    强制 只使用协议第二版.
    
-4
    强制 只使用 IPv4 地址.
    
-6
    强制 只使用 IPv6 地址.          
```

使用实例

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
```























