# create database and launch interactive shell
#创建数据库并启动交互式shell
sqlite3 example.db

# create table
#创建表
sqlite3 example.db "CREATE TABLE Os(ID INTEGER PRIMARY KEY, Name TEXT, Year INTEGER);"

# insert data
#插入数据
sqlite3 example.db "INSERT INTO 'Os' VALUES(1,'Linux',1991);"

# list tables
#列表
sqlite3 example.db ".tables"

# view records in table
#查看表中的记录
sqlite3 example.db "SELECT * FROM 'Os';"

# view records in table conditionally
#有条件地查看表中的记录
sqlite example.db "SELECT * FROM 'Os' WHERE Year='1991';"

# view records with fuzzy matching
#用模糊匹配查看记录
sqlite3 ~/example.db "SELECT * FROM 'Os' WHERE Year like '19%';"