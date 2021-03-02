# title{asterisk - asterisk服务}

```bash
# To connect to a running Asterisk session:
#要连接到正在运行的Asterisk会话：
asterisk -rvvv

# To issue a command to Asterisk from the shell:
#要从shell向Asterisk发出命令：
asterisk -rx "<command>"

# To originate an echo call from a SIP trunk on an Asterisk server, to a specified number:
#要从Asterisk服务器上的SIP干线发起回显呼叫，请发送到指定的号码：
asterisk -rx "channel originate SIP/<trunk>/<number> application echo"

# To print out the details of SIP accounts:
#要打印出SIP帐户的详细信息：
asterisk -rx "sip show peers"

# To print out the passwords of SIP accounts:
#打印出SIP帐户的密码：
asterisk -rx "sip show users"

# To print out the current active channels:
#打印出当前活动频道：
asterisk -rx "core show channels"
```