# title{ncat - nc和ncat是同一个工具}

```bash
# Connect mode (ncat is client) | default port is 31337
#连接模式（ncat是客户端）|默认端口是31337
ncat <host> [<port>]

# Listen mode (ncat is server) | default port is 31337
#监听模式（ncat是服务器）|默认端口是31337
ncat -l [<host>] [<port>]

# Transfer file (closes after one transfer)
#传输文件（一次传输后关闭）
ncat -l [<host>] [<port>] < file

# Transfer file (stays open for multiple transfers)
#传输文件（保持打开以进行多次传输）
ncat -l --keep-open [<host>] [<port>] < file

# Receive file
#接收文件
ncat [<host>] [<port>] > file

# Brokering | allows for multiple clients to connect
#经纪人|允许多个客户端连接
ncat -l --broker [<host>] [<port>]

# Listen with SSL | many options, use ncat --help for full list
#用SSL听很多选项，使用ncat --help获取完整列表
ncat -l --ssl [<host>] [<port>]

# Access control
#访问控制
ncat -l --allow <ip>
ncat -l --deny <ip>

# Proxying
#代理
ncat --proxy <proxyhost>[:<proxyport>] --proxy-type {http | socks4} <host>[<port>]

# Chat server | can use brokering for multi-user chat
#聊天服务器|可以使用代理进行多用户聊天
ncat -l --chat [<host>] [<port>]
```