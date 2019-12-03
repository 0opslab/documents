# To index recursively some paths for the very first run:
#要递归索引第一次运行的某些路径：
scd -ar ~/Documents/

# To change to a directory path matching "doc":
#要更改为与“doc”匹配的目录路径：
scd doc

# To change to a path matching all of "a", "b" and "c":
#要更改为匹配所有“a”，“b”和“c”的路径：
scd a b c

# To change to a directory path that ends with "ts":
#要更改为以“ts”结尾的目录路径：
scd "ts$"

# To show selection menu and ranking of 20 most likely directories:
#要显示20个最可能目录的选择菜单和排名：
scd -v

# To alias current directory as "xray":
#要将当前目录别名为“xray”：
scd --alias=xray

# To jump to a previously defined aliased directory:
#要跳转到先前定义的别名目录：
scd xray
