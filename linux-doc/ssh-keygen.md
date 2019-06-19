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
