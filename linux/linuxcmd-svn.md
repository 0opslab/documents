# update working copy from repository
#从存储库更新工作副本
svn update "/path"

# show changed files in working copy
#显示工作副本中已更改的文件
svn status

# show what changed in local file
#显示本地文件中的更改
svn diff "/path/filename"

# add files or folders
#添加文件或文件夹
svn add "path/item"

# revert local uncommited changes
#还原本地未提交的更改
svn revert "/path/file"

# commit changes to repo
#提交对repo的更改
svn commit -m "message" "/path"

# show help for 'svn diff'
#显示'svn diff'的帮助
svn help diff
