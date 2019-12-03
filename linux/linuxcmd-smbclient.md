# To display public shares on the server:
#要在服务器上显示公共共享：
smbclient -L <hostname> -U%

# To connect to a share:
#要连接到共享：
smbclient //<hostname>/<share> -U<username>%<password>
