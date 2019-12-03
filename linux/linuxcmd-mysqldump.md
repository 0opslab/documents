# To dump a database to a file (Note that your password will appear in your command history!):
#将数据库转储到文件中（请注意，您的密码将出现在命令历史记录中！）：
mysqldump -uusername -ppassword the-database > db.sql

# To dump a database to a file:
#要将数据库转储到文件：
mysqldump -uusername -p the-database > db.sql

# To dump a database to a .tgz file (Note that your password will appear in your command history!):
#将数据库转储到.tgz文件（请注意，您的密码将出现在命令历史记录中！）：
mysqldump -uusername -ppassword the-database | gzip -9 > db.sql

# To dump a database to a .tgz file:
#要将数据库转储到.tgz文件：
mysqldump -uusername -p the-database | gzip -9 > db.sql

# To dump all databases to a file (Note that your password will appear in your command history!):
#将所有数据库转储到文件中（请注意，您的密码将显示在命令历史记录中！）：
mysqldump -uusername -ppassword --all-databases > all-databases.sql

# To dump all databases to a file:
#要将所有数据库转储到文件：
mysqldump -uusername -p --all-databases > all-databases.sql

# To export the database structure only:
#仅导出数据库结构：
mysqldump --no-data -uusername -p the-database > dump_file

# To export the database data only:
#仅导出数据库数据：
mysqldump --no-create-info -uusername -p the-database > dump_file
