## 配置文件

git一共有三个配置文件

1. 仓库级的配置文件：在仓库的 `.git/.gitconfig`，该配置文件只对所在的仓库有效。
2. 全局配置文件：Mac 系统在 `~/.gitconfig`，Windows 系统在 `C:\Users\<用户名>\.gitconfig`。
3. 系统级的配置文件：在 Git 的安装目录下（Mac 系统下安装目录在 `/usr/local/git`）的 `etc` 文件夹中的 `gitconfig`

https://www.jianshu.com/p/93318220cdce

## 配置

$ git config --global user.name "Some One"
$ git config --global user.email "someone@gmail.com"



## 常用命令

```bash
# 初始化本地库
git init
#查看状态
git status
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
```

## 分支操作

```bash
# 查看所有分支
git branch -v
# 删除本地分支
git branch -d <分支名>
# 新建分支
git branch <分支名>
# 切换分支
git checkout <分支名>
# 合并分支
git merge <被合并分支名>
```

## 与远程仓库交互

```bash
# 克隆远程库
git clone <远程库地址>
# 查看远程库地址别名
git remote -v
# 新建远程库地址别名
git remote add <别名> <远程库地址>
# 删除本地中远程库别名
git remote rm <别名>
# 本地库某个分支推送到远程库，分支必须指定
git push <别名> <分支名>
# 把远程库的修改拉取到本地（该命令包括 git fetch，git merge）
git pull <别名> <分支名>
# 抓取远程库的指定分支到本地，但没有合并
git fetch <远程库别名> <远程库分支名>
# 将抓取下来的远程的分支，跟当前所在分支进行合并
git merge <远程库别名/远程库分支名>
# 复制远程库
git fork
```







## FQA

* 我要删掉记录的文件的路径是(相对于项目):src/main/resources/config/application-test.yml

    ```B
    git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch src/main/resources/config/application-test.yml' --prune-empty --tag-name-filter cat -- --all
    # 本地记录覆盖到Github,(所有branch以及所有tags)
    git push origin --force --all
    git push origin --force --tags
    # 确保没有什么问题之后,强制解除对本地存储库中的所有对象的引用和垃圾收集
    git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
    git reflog expire --expire=now --all
    git gc --prune=now
    ```

    
    

# 


