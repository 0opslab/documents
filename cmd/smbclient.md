# title{smbclient - 命令可存取SMB/CIFS服务器的用户端程序}

### 选项
```bash
[网络资源] [网络资源]的格式为//服务器名称/资源分享名称。
[密码] 输入存取网络资源所需的密码。
-B<IP地址> 传送广播数据包时所用的IP地址。
-d<排错层级> 指定记录文件所记载事件的详细程度。
-E 将信息送到标准错误输出设备。
-h 显示帮助。
-i<范围> 设置NetBIOS名称范围。
-I<IP地址> 指定服务器的IP地址。
-l<记录文件> 指定记录文件的名称。
-L 显示服务器端所分享出来的所有资源。
-M<NetBIOS名称> 可利用WinPopup协议，将信息送给选项中所指定的主机。
-n<NetBIOS名称> 指定用户端所要使用的NetBIOS名称。
-N 不用询问密码。
-O<连接槽选项> 设置用户端TCP连接槽的选项。
-p<TCP连接端口> 指定服务器端TCP连接端口编号。
-R<名称解析顺序> 设置NetBIOS名称解析的顺序。
-s<目录> 指定smb.conf所在的目录。
-t<服务器字码> 设置用何种字符码来解析服务器端的文件名称。
-T<tar选项> 备份服务器端分享的全部文件，并打包成tar格式的文件。
-U<用户名称> 指定用户名称。
-W<工作群组> 指定工作群组名称。
```

### 常用命令
```bash
# To display public shares on the server:
#要在服务器上显示公共共享：
smbclient -L <hostname> -U%

# To connect to a share:
#要连接到共享：
smbclient //<hostname>/<share> -U<username>%<password>
```
