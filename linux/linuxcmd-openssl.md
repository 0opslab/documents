# To create a 2048-bit private key:
#要创建2048位私钥：
openssl genrsa -out server.key 2048

# To create the Certificate Signing Request (CSR):
#要创建证书签名请求（CSR）：
openssl req -new -key server.key -out server.csr

# To sign a certificate using a private key and CSR:
#使用私钥和CSR签署证书：
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

# (The above commands may be run in sequence to generate a self-signed SSL certificate.)
#（可以按顺序运行上述命令以生成自签名SSL证书。）

# To show certificate information for a certificate signing request
#显示证书签名请求的证书信息
openssl req -text -noout -in server.csr

# To show certificate information for generated certificate
#显示生成的证书的证书信息
openssl x509 -text -noout -in server.crt 

# To get the sha256 fingerprint of a certificate
#获取证书的sha256指纹
openssl x509 -in server.crt -noout -sha256 -fingerprint

# To view certificate expiration:
#要查看证书过期：
echo | openssl s_client -connect <hostname>:443 2> /dev/null | \
awk '/-----BEGIN/,/END CERTIFICATE-----/' | \
openssl x509 -noout -enddate

# Generate Diffie-Hellman parameters:
#生成Diffie-Hellman参数：
openssl dhparam -outform PEM -out dhparams.pem 2048
