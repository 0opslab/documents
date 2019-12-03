# To connect to a database
#连接到数据库
mysql -h localhost -u root -p

# To backup all databases
#备份所有数据库
mysqldump --all-databases --all-routines -u root -p > ~/fulldump.sql

# To restore all databases
#要还原所有数据库
mysql -u root -p  < ~/fulldump.sql

# To create a database in utf8 charset
#在utf8 charset中创建数据库
CREATE DATABASE owa CHARACTER SET utf8 COLLATE utf8_general_ci;

# To add a user and give rights on the given database
#添加用户并授予给定数据库权限
GRANT ALL PRIVILEGES ON database.* TO 'user'@'localhost'IDENTIFIED BY 'password' WITH GRANT OPTION;

# To list the privileges granted to the account that you are using to connect to the server. Any of the 3 statements will work. 
#列出授予用于连接服务器的帐户的权限。 3个陈述中的任何一个都可以。
SHOW GRANTS FOR CURRENT_USER();
SHOW GRANTS;
SHOW GRANTS FOR CURRENT_USER;

# Basic SELECT Statement
#基本SELECT语句
SELECT * FROM tbl_name;

# Basic INSERT Statement
#基本INSERT语句
INSERT INTO tbl_name (col1,col2) VALUES(15,col1*2);

# Basic UPDATE Statement
#基本更新声明
UPDATE tbl_name SET col1 = "example";

# Basic DELETE Statement
#基本DELETE语句
DELETE FROM tbl_name WHERE user = 'jcole';

# To check stored procedure
#检查存储过程
SHOW PROCEDURE STATUS;

# To check stored function
#检查存储的功能
SHOW FUNCTION STATUS;
