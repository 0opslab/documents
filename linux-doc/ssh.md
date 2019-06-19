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
