# title{git - }
## 配置文件
git一共有三个配置文件
1. 仓库级的配置文件：在仓库的 `.git/.gitconfig`，该配置文件只对所在的仓库有效。
2. 全局配置文件：Mac 系统在 `~/.gitconfig`，Windows 系统在 `C:\Users\<用户名>\.gitconfig`。
3. 系统级的配置文件：在 Git 的安装目录下（Mac 系统下安装目录在 `/usr/local/git`）的 `etc` 文件夹中的 `gitconfig`

## 配置

```bash
# 查看配置信息
# --local：仓库级，--global：全局级，--system：系统级
$ git config <--local | --global | --system> -l

# 查看当前生效的配置信息
$ git config -l

# 编辑配置文件
# --local：仓库级，--global：全局级，--system：系统级
$ git config <--local | --global | --system> -e

# 添加配置项
# --local：仓库级，--global：全局级，--system：系统级
$ git config <--local | --global | --system> --add <name> <value>

# 获取配置项
$ git config <--local | --global | --system> --get <name>

# 删除配置项
$ git config <--local | --global | --system> --unset <name>

# 配置提交记录中的用户信息
$ git config --global user.name <用户名>
$ git config --global user.email <邮箱地址>

# 更改Git缓存区的大小
# 如果提交的内容较大，默认缓存较小，提交会失败
# 缓存大小单位：B，例如：524288000（500MB）
$ git config --global http.postBuffer <缓存大小>

# 调用 git status/git diff 命令时以高亮或彩色方式显示改动状态
$ git config --global color.ui true

# 配置可以缓存密码，默认缓存时间15分钟
$ git config --global credential.helper cache

# 配置密码的缓存时间
# 缓存时间单位：秒
$ git config --global credential.helper 'cache --timeout=<缓存时间>'

# 配置长期存储密码
$ git config --global credential.helper store
```



## 常用命令

```bash
# 初始化本地库
git init
#查看状态
git status
# 以简短模式查看本地仓库的状态
# 会显示两列，第一列是文件的状态，第二列是对应的文件
# 文件状态：A 新增，M 修改，D 删除，?? 未添加到Git中
$ git status -s
# 将新建/修改的内容提交
git add <file name>
# 移除暂存区的修改
git rm --cached <file name>
# 将暂存区的内容提交到本地库
git commit <file name>
# 文件从暂存区到本地库
git commit -m

```

## 日志

```bash
# 查看历史提交(空格向下翻页，b向上翻页，q退出)
git log
# 以漂亮的一行显示，包含全部哈希索引值
git log --pretty=oneline
# 以简洁的一行显示，包含简洁哈希索引值
git log --oneline
# 以简洁的一行显示，包含简洁哈希索引值，同时显示移动到某个历史版本所需的步数
git reflog
```

## 版本控制

```bash
# 回到指定哈希值所对应的版本
git reset --hard 简洁/完整哈希索引值
# 强制工作区、暂存区、本地库为当前HEAD指针所在的版本
git reset --hard HEAD
# 后退一个版本　
git reset --hard HEAD^
# 后退一个版本（波浪线~后面的数字表示后退几个版本）
git reset --hard HEAD~1
```

## 比较差异

```bash
# 比较工作区和暂存区的所有文件差异
git diff
# 比较工作区和暂存区的指定文件的差异
git diff <file name>
# 比较工作区跟本地库的某个版本的指定文件的差异
git diff HEAD|HEAD^|HEAD~|哈希索引值 <file name>
# 比较暂存区中的文件和上次提交时的差异
$ git diff --cached
$ git diff --staged

# 比较当前文件和上次提交时的差异
$ git diff HEAD

# 查看从指定的版本之后改动的内容
$ git diff <commit ID>

# 比较两个分支之间的差异
$ git diff <分支名称> <分支名称>

# 查看两个分支分开后各自的改动内容
$ git diff <分支名称>...<分支名称>
```

## 分支操作

```bash
# 查看所有分支
git branch -v
# 修改分支名称
# 如果不指定原分支名称则为当前所在分支
$ git branch -m [<原分支名称>] <新的分支名称>
# 强制修改分支名称
$ git branch -M [<原分支名称>] <新的分支名称>

# 删除指定的本地分支
$ git branch -d <分支名称>

# 强制删除指定的本地分支
$ git branch -D <分支名称>

# 新建分支
git branch <分支名>
# 切换分支
git checkout <分支名>
# 合并分支
git merge <被合并分支名>
# 列出本地的所有分支并显示最后一次提交，当前所在分支以 "*" 标出
$ git branch -v
```

## 与远程仓库交互

```bash
# 克隆远程库
git clone <远程库地址>
# 查看远程库地址别名
git remote -v
git remote --verbose
# 新建远程库地址别名
git remote add <别名> <远程库地址>
# 修改远程仓库的别名
git remote rename <原远程仓库的别名> <新的别名>
# 删除本地中远程库别名
git remote rm <别名>
# 本地库某个分支推送到远程库，分支必须指定
git push <别名> <分支名>
# 把远程库的修改拉取到本地（该命令包括 git fetch，git merge）
# 删除指定的远程仓库的分支
git push <远程仓库的别名> :<远程分支名>
git push <远程仓库的别名> --delete <远程分支名>
git pull <别名> <分支名>
# 抓取远程库的指定分支到本地，但没有合并
git fetch <远程库别名> <远程库分支名>
# 将抓取下来的远程的分支，跟当前所在分支进行合并
git merge <远程库别名/远程库分支名>
# 复制远程库
git fork
```

## 暂存操作

```bash
git stash 暂存当前修改
git stash apply 恢复最近的一次暂存
git stash pop 恢复暂存并删除暂存记录
git stash list 查看暂存列表
git stash drop 暂存名(例：stash@{0}) 移除某次暂存
git stash clear 清除暂存
```

## 回退操作

```bash
git reset --hard HEAD^ 回退到上一个版本
git reset --hard ahdhs1(commit_id) 回退到某个版本
git checkout -- file撤销修改的文件(如果文件加入到了暂存区，则回退到暂存区的，如果文件加入到了版本库，则还原至加入版本库之后的状态)
git reset HEAD file 撤回暂存区的文件修改到工作区
```

###  标签操作

```bash
git tag 标签名 添加标签(默认对当前版本)
git tag 标签名 commit_id 对某一提交记录打标签
git tag -a 标签名 -m '描述' 创建新标签并增加备注
git tag 列出所有标签列表
git show 标签名 查看标签信息
git tag -d 标签名 删除本地标签
git push origin 标签名 推送标签到远程仓库
git push origin --tags 推送所有标签到远程仓库
git push origin :refs/tags/标签名 从远程仓库中删除标签
```


### 删除操作
```Bash
# 我要删掉记录的文件的路径是(相对于项目):src/main/resources/config/application-test.yml
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch src/main/resources/config/application-test.yml' --prune-empty --tag-name-filter cat -- --all
# 本地记录覆盖到Github,(所有branch以及所有tags)
git push origin --force --all
git push origin --force --tags
# 确保没有什么问题之后,强制解除对本地存储库中的所有对象的引用和垃圾收集
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now
```

### 删除所有提交历史记录

```bash
# 尝试 运行 
git checkout --orphan latest_branch
# 添加所有文件
git add -A
# 提交更改
git commit -am "commit message"
# 删除分支
git branch -D master
# 将当前分支重命名
git branch -m master
# 最后，强制更新存储库。
git push -f origin master
```

### 常用命令
```bash
# To set your identity:
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com

# To set your editor:
git config --global core.editor emacs

# To enable color:
git config --global color.ui true

# To stage all changes for commit:
git add --all

# To stash changes locally, this will keep the changes in a separate changelist
# called stash and the working directory is cleaned. You can apply changes
# from the stash anytime
git stash

# To stash changes with a message
git stash save "message"

# To list all the stashed changes
git stash list

# To apply the most recent change and remove the stash from the stash list
git stash pop

# To apply any stash from the list of stashes. This does not remove the stash
# from the stash list
git stash apply stash@{6}

# To commit staged changes
git commit -m "Your commit message"

# To edit previous commit message
git commit --amend

# Git commit in the past
git commit --date="`date --date='2 day ago'`"
git commit --date="Jun 13 18:30:25 IST 2015"
# more recent versions of Git also support --date="2 days ago" directly

# To change the date of an existing commit
git filter-branch --env-filter \
    'if [ $GIT_COMMIT = 119f9ecf58069b265ab22f1f97d2b648faf932e0 ]
     then
         export GIT_AUTHOR_DATE="Fri Jan 2 21:38:53 2009 -0800"
         export GIT_COMMITTER_DATE="Sat May 19 01:01:01 2007 -0700"
     fi'

# To removed staged and working directory changes
git reset --hard

# To go 2 commits back
git reset --hard HEAD~2

# To remove untracked files
git clean -f -d

# To remove untracked and ignored files
git clean -f -d -x

# To push to the tracked master branch:
git push origin master

# To push to a specified repository:
git push git@github.com:username/project.git

# To delete the branch "branch_name"
git branch -D branch_name

# To make an exisiting branch track a remote branch
git branch -u upstream/foo

# To see who commited which line in a file
git blame filename

# To sync a fork with the master repo:
# Set a new repo
git remote add upstream git@github.com:name/repo.git    
# Confirm new remote repo
git remote -v                                           
# Get branches
git fetch upstream                                      
# List local - remote branches
git branch -va                                          
# Checkout local master branch
git checkout master                                     
# Create and checkout a new branch
git checkout -b new_branch                              
# Merge remote into local repo
git merge upstream/master                               
# Show what a commit did.
git show 83fb499                                        
# Shows the file as it appeared at 83fb499.
git show 83fb499:path/fo/file.ext                       
# Check difference between branches
git diff branch_1 branch_2                              
# Show all the commits
git log                                                 
# Show the changes from last commit
git status                                              

# Commit history of a set of files
git log --pretty=email --patch-with-stat --reverse --full-index -- Admin\*.py > Sripts.patch

# Import commits from another repo
git --git-dir=../some_other_repo/.git format-patch -k -1 --stdout <commit SHA> | git am -3 -k

# View commits that will be pushed
git log @{u}..

# View changes that are new on a feature branch
git log -p feature --not master
git diff master...feature

# Interactive rebase for the last 7 commits
git rebase -i @~7

# Diff files WITHOUT considering them a part of git
# This can be used to diff files that are not in a git repo!
git diff --no-index path/to/file/A path/to/file/B

# To pull changes while overwriting any local commits
git fetch --all
git reset --hard origin/master

# Update all your submodules
git submodule update --init --recursive

# Perform a shallow clone to only get latest commits
# (helps save data when cloning large repos)
git clone --depth 1 <remote-url>

# To unshallow a clone
git pull --unshallow

# Create a bare branch (one that has no commits on it)
git checkout --orphan branch_name

# Checkout a new branch from a different starting point
git checkout -b master upstream/master

# Remove all stale branches (ones that have been deleted on remote)
# So if you have a lot of useless branches, delete them on Github and then run this
git remote prune origin

# The following can be used to prune all remotes at once
git remote prune $(git remote | tr '\n' ' ')

# Revisions can also be identified with :/text
# So, this will show the first commit that has "cool" in their message body
git show :/cool

# Undo parts of last commit in a specific file
git checkout -p HEAD^ -- /path/to/file

# Revert a commit and keep the history of the reverted change as a separate revert commit
git revert <commit SHA>

# Pich a commit from a branch to current branch. This is different than merge as
# this just applies a single commit from a branch to current branch
git cherry-pick <commit SHA1>
```