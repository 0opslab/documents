# To copy a key to a remote host:
#要将密钥复制到远程主机：
ssh-copy-id username@host

# To copy a key to a remote host on a non-standard port:
#要将密钥复制到非标准端口上的远程主机：
ssh-copy-id username@host -p 2222

# To copy a key to a remote host on a non-standard port with non-standard ssh key:
#要使用非标准ssh密钥将密钥复制到非标准端口上的远程主机：
ssh-copy-id ~/.ssh/otherkey "username@host -p 2222"
