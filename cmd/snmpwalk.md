# title{snmpwalk - }

```bash
# To retrieve all of the variables under system for host zeus
#在系统下检索主机zeus的所有变量
snmpwalk -Os -c public -v 1 zeus system

# To retrieve the scalar values, but omit the sysORTable for host zeus
#要检索标量值，请省略主机zeus的sysORTable
snmpwalk -Os -c public -v 1 -CE sysORTable zeus system
```